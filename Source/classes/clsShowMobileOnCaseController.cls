public with sharing class clsShowMobileOnCaseController {
	private Account account;
	private Case currentCase;
    
    public clsShowMobileOnCaseController(Apexpages.StandardController controller){
    	this.currentCase = (Case)controller.getRecord();
    	Case[] caseList = [Select accountID From Case Where Id = : currentCase.Id AND accountID <> null];
    	if(caseList.size() >0 && (caseList[0].AccountId != null || caseList[0].AccountId != '')) {
    		List<Account> caseAccounts = [Select Id, PersonMobilePhone From Account Where Id = : caseList[0].AccountId];
    		if(caseAccounts.size() > 0)
    			this.account =  caseAccounts[0];
    	} else 
    		this.account = null;	 	
    }      
   
    public String getMobileNumber() {  
    	if (account != null && account.PersonMobilePhone != null)     	
     		return account.PersonMobilePhone;
     	else
     		return '';
    }
    
    static testMethod void testDisplayMobile() {       
    	Account account = new account();
    	account.FirstName = 'Test Account 1';
    	account.LastName = 'Test Account 1';
    	RecordType recordType = [Select Id From RecordType Where Name = 'YK Customer Account'];
    	account.RecordTypeId = recordType.Id;
    	account.PersonMobilePhone = '12345678';
    	insert account;
    	
    	Case c = new Case();
    	RecordType caseRecordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        c.AccountId = account.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Description = 'Product: TV\r\nType: Support\r\n';
        c.RecordTypeId = caseRecordType.Id;
        insert c;
        
      	ApexPages.StandardController sc = new ApexPages.StandardController(c);    	
        clsShowMobileOnCaseController  controller = new clsShowMobileOnCaseController(sc);
    	System.assertEquals('12345678', controller.getMobileNumber());
     
    }      
	     
}