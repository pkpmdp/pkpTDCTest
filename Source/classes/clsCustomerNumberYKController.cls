public class clsCustomerNumberYKController {
	
	private Account account;
    private User user;
    
    public clsCustomerNumberYKController(ApexPages.StandardController controller) {
        SObject obj = controller.getRecord();
        if (obj.getsObjectType() == Schema.Account.SObjectType) {
            account = (Account) obj;	
        } else if (obj.getsObjectType() == Schema.Case.SObjectType) {
        	if (obj.get('AccountId') != null) {
                account = [Select Id, Customer_No__c From Account Where Id = : (String) obj.get('AccountId')];
        	}
        }
        user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
    }
    
    public Account getAccount() {
        return account;	
    }    
    
    public String getAccountNo() {
    	if (account.Customer_No__c != null) {
            if (account.Customer_No__c.startsWith('Pending')) {
        	    return 'Pending';
            }
    	}
        return account.Customer_No__c;
    }
    
    public Boolean getPollerEnabled() {
        if (account == null) {
        	return true;
        } else if ((account.Customer_No__c == null) || (account.Customer_No__c.startsWith('Pending'))) {
        	return true;
        } else {
        	return false;
        }
    }
          
    public PageReference checkCustomerNumber() {
    	if (account != null) {
    	    if ((account.Customer_No__c == null) || (account.Customer_No__c.startsWith('Pending'))) {
    	        account = [Select Id, Customer_No__c From Account Where Id = : account.Id];
    	    } 	
    	}   	
    	return null;
    }
    
    public PageReference sendToCasper() {
    	if (account != null) {
    	    if (account.Customer_No__c != null) {
    	        String customerNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_METHOD, account.Customer_No__c + ';' + this.user.MID__c );
            }
    	}
        return null;                    
    } 
    
    private String callout(String endpoint, String body) {
    	// Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));        
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res = ' + res);
        } catch (Exception e) {}
        if (res != null) {
        	if (res.getStatusCode() == 200) {
        	    return res.getBody();  // Good response
            }
        }
        return null;	
    }
    
    static testMethod void testDisplayCustomer() {
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
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
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = 'Pending_0012000000a9Y4L';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        	
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Description = 'Product: TV\r\nType: Support\r\n';
        c.RecordTypeId = recordType.Id;
        insert c;
    	
    	// Get a handle on controller with account as focus record
    	ApexPages.StandardController sc = new ApexPages.StandardController(acc);    	
        clsCustomerNumberYKController controller = new clsCustomerNumberYKController(sc);
        
        System.assertEquals(true, controller.getPollerEnabled());
        
        controller.getAccount().Customer_No__c = 'Pending';
        update controller.getAccount();
     
        System.assertEquals(true, controller.getPollerEnabled());
     
        controller.getAccount().Customer_No__c = '1234567890';
        update controller.getAccount();
     
        System.assertEquals(false, controller.getPollerEnabled());
        
        // Invoke the method to send the web service request              
        controller.sendToCasper();

    	// Repeat with case as focus record
    	sc = new ApexPages.StandardController(c);    	
        controller = new clsCustomerNumberYKController(sc);
        
        System.assertEquals(false, controller.getPollerEnabled());
        
        controller.getAccount().Customer_No__c = 'Pending';
        update controller.getAccount();
     
        System.assertEquals(true, controller.getPollerEnabled());
     
        controller.getAccount().Customer_No__c = '1234567890';
        update controller.getAccount();
     
        System.assertEquals(false, controller.getPollerEnabled());
        controller.getAccountNo();
        controller.sendToCasper();
        controller.checkCustomerNumber();
        
    }
}