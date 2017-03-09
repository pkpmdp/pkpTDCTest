public with sharing class clsKissInternalContactController {
	
	public String externalKISSID{get;set;}    
    
    public clsKissInternalContactController(ApexPages.StandardController standardController){        
        externalKISSID = ApexPages.currentPage().getParameters().get('KissInternalContactID');        
    }
    
    public PageReference showInternalContact(){
    	if(externalKISSID != null) {
	    	Lookup_Account_Team_Member__c teamMember;
	    	try{
	    		teamMember = [Select Id, SourceId__c from  Lookup_Account_Team_Member__c where SourceId__c =: externalKISSID];
	    	}catch(Exception e){
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen intern kontakt med dette Kiss ID i Salesforce'));
	        	return null;	
	    	}
	    	return new PageReference('/' + teamMember.Id);
    	}
    	else{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen intern kontakt med dette Kiss ID i Salesforce'));
	        return null;	
    	}    	    
    }
    
    public static testMethod void clsKissInternalContactController() {
    	
    	//Account a =  Oasis_TestClass.setupDummyAccount(); 
        Address__c addr = Oasis_TestClass.setupDummyAddress();
        
        Test.startTest();
    	Pagereference pgref = new Pagereference('KissInternalContact');
    	pgref.getParameters().put('KissInternalContactID',String.Valueof(addr.Id));
    	ApexPages.StandardController sc_customer =  new ApexPages.StandardController(addr);
    	clsKissInternalContactController clsKiss = new  clsKissInternalContactController(sc_customer);
    	clsKiss.externalKISSID = '1234';
    	clsKiss.showInternalContact();
        clsKiss.externalKISSID = '';
    	clsKiss.showInternalContact();
    	clsKiss.externalKISSID = null;
    	clsKiss.showInternalContact();
    	Test.stopTest();
    }
        
}