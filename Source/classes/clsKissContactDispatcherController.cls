public with sharing class clsKissContactDispatcherController {
	
	public String externalKISSID{get;set;}    
    
    public clsKissContactDispatcherController(ApexPages.StandardController standardController){        
        //externalKISSID = ApexPages.currentPage().getParameters().get('KissContactID');  
        externalKISSID = ApexPages.currentPage().getParameters().get('ContactID');       
    }
    
    public PageReference showContact(){
    	if(externalKISSID != null){
	    	Contact contact;
	    	try{
	    		//contact = [Select Id, KissPartyId__c from Contact where KissPartyId__c =: externalKISSID];
	    		contact = [Select Id, KissPartyId__c from Contact where Id =: externalKISSID];
	    	}catch(Exception e){
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kontakt med dette Kiss ID i Salesforce'));
	        	return null;	
	    	}
	    	return new PageReference('/' + contact.Id);
    	}
    	else{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kontakt med dette Kiss ID i Salesforce'));
	        return null;
    	}    		    	    
    }
    
    public static testMethod void clsKissContactDispatcherController() {
    	
    	/*Address__c address = new Address__c(Name= 'Klostervangen', Active__c = true, External_Id__c = 'test454',
	        				      				House_No__c = '34', Postcode__c = '3360');
	    insert address;
	    
    	Contact contact1 = 
    		new Contact( FirstName = 'Michel', 
    					 Lastname = 'Hansen', 
    					 HomePhone = '56897412',
    					 KissPartyId__c = 'KISS-24-aug',
    					 Street_P__c = address.Id);
        insert contact1;
        
        
        PageReference prf = Page.KissContactDispatcherPage;
        prf.getParameters().put('ContactID', Valueof(c.Id)); 
        Test.setCurrentPage(prf);
        ApexPages.StandardController stdController = new ApexPages.StandardController(contact1);
        clsKissContactDispatcherController controller = new clsKissContactDispatcherController(stdController); 
        //System.assertEquals('KISS-24-aug', controller.externalKISSID);     
        //System.assertNotEquals(null, controller.showContact());*/
        Account a =  Oasis_TestClass.setupDummyAccount(); 
        Address__c addr = Oasis_TestClass.setupDummyAddress();
        Contact c =  Oasis_TestClass.setupDummyContact(a, addr); 
        Test.startTest();
    	Pagereference pgref = new Pagereference('KissContactDispatcherPage');
    	pgref.getParameters().put('ContactID',String.Valueof(c.Id));
    	ApexPages.StandardController sc_customer =  new ApexPages.StandardController(c);
    	clsKissContactDispatcherController clsKiss = new clsKissContactDispatcherController(sc_customer);
    	clsKiss.externalKISSID = '1234';
    	clsKiss.showContact();
    	clsKiss.externalKISSID = null;
    	clsKiss.showContact();
    	Test.stopTest();
    }
	

}