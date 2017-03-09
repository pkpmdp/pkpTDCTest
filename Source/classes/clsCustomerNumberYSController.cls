public with sharing class clsCustomerNumberYSController {
	/* this controller should only works for YS Customer, not YS Hierarchy customer*/
    private Account account;    
    private User user;
    //private RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
    public clsCustomerNumberYSController(ApexPages.StandardController controller) {
		SObject obj = controller.getRecord();
        if (obj.getsObjectType() == Schema.Account.SObjectType) {
            account = (Account) obj;	
        } 
        user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
    }
    
    public Account getAccount() {
        return account;	
    }    
    
    public String getAccountNo() {
    	//ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'cusotmerno = ' + account.RecordTypeId);
    	//ApexPages.addMessage(existingProductsResponse);
    	if ((account.Customer_No__c == null) || (account.Customer_No__c.equals('') && account.RecordTypeId == '012200000000nf3')) {
            //if (account.Customer_No__c.startsWith('Pending')) {
        	    return 'Pending';
            //}
    	} else {
        	return account.Customer_No__c;
    	}
    }
    
    public Boolean getPollerEnabled() {
        if (account == null) {
        	return true;
        } else if ((account.Customer_No__c == null) || (account.Customer_No__c.equals('') && account.RecordTypeId == '012200000000nf3')) {
        	return true;
        } else {
        	return false;
        }
    }
    
    public PageReference checkCustomerNumber() {
    	if (account != null) {
    	    if (account.Customer_No__c == null || account.Customer_No__c.equals('')) {
    	        account = [Select Id, Customer_No__c From Account Where Id = : account.Id];
    	    } 	
    	}   	
    	return null;
    }
    
    static testMethod void testDisplayCustomer() {
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        
    	// Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
       
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Customer_No__c = '';
        acc.RecordTypeId = recordType.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        	
    	
    	// Get a handle on controller with account as focus record
    	ApexPages.StandardController sc = new ApexPages.StandardController(acc);    	
        clsCustomerNumberYSController controller = new clsCustomerNumberYSController(sc);
        
        System.assertEquals(true, controller.getPollerEnabled());
        System.assertEquals('Pending', controller.getAccountNo());
        
        controller.getAccount().Customer_No__c = '';
        update controller.getAccount();
     	controller.checkCustomerNumber();
        System.assertEquals(true, controller.getPollerEnabled());
     	System.assertEquals('Pending', controller.getAccountNo());
     	
        controller.getAccount().Customer_No__c = '1234567890';
        update controller.getAccount();
     	controller.checkCustomerNumber();
        System.assertEquals(false, controller.getPollerEnabled());
        System.assertEquals('1234567890', controller.getAccountNo());       
    }

}