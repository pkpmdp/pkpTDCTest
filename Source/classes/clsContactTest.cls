/*
    @Author: mkha@yousee.dk
    Test-class for : tgrContactBeforeInsert 
*/
@isTest(SeeAllData=true)
private class clsContactTest {
        
    static testMethod void testContactActivation() {        
        Account account = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
        //We initialize the value to inaktiv
        contact.Status__c = 'Inaktiv';
        update contact;
        Account_Contact_Role__c acr = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account.id);
        
        Test.startTest();       
        contact = [Select Id, Status__c from Contact where id =: contact.Id];
        //system.assertEquals('Aktiv', contact.Status__c);
        Test.stopTest();        
            
    }
    
    static testMethod void testContactDeactivation() {      
        Account account = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
        Account_Contact_Role__c acr = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account.id);
        
        Test.startTest();
        delete acr;     
        contact = [Select Id, Status__c from Contact where id =: contact.Id];
        //system.assertEquals('Inaktiv', contact.Status__c);
        Test.stopTest();        
    }
    
    static testMethod void testContactValidationDeactivation() {                    
        Account account = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
        Account_Contact_Role__c acr = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account.id);
        
        Test.startTest();
        try{
            contact.Status__c = 'Inaktiv';
            update contact;
        }catch(Exception e){
            system.assert(true);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(false);
    }
    
    static testMethod void testContactEmailValidationNegative() {
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
        contact.Email = 'test982121@test32783787.dk';
        update contact;
        
        Contact contact2 = null;
        Test.startTest();
        try{
            contact2 = clsTestFactory.getTestFactoryInstance().createYSContactWithParameters(null, null, null, contact.Email);          
        }catch(Exception e){
            system.assert(true);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);
    }
    
    static testMethod void testContactEmailValidationPositive() {
        Contact contact1 = null;
        Contact contact2 = null;
        Test.startTest();
        try{
            contact1 = clsTestFactory.getTestFactoryInstance().createYSContactWithParameters(null, null, null, 'test741122@test66698test.dk');
            contact2 = clsTestFactory.getTestFactoryInstance().createYSContactWithParameters(null, null, null, 'test434893498@test43434test.dk');           
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);
    } 
    
    static testMethod void testContactDeletion() {
        Contact contact1 = null;        
        contact1 = clsTestFactory.getTestFactoryInstance().createYSContactWithParameters(null, null, null, 'test741122@test66698test.dk');
        Contact tmpObj = [Select Id, KissPartyId__c from Contact where Id=: contact1.Id];
        String externalId = tmpObj.KissPartyId__c;
        
        Test.startTest();
        try{
            delete contact1;        
        }catch(Exception e){
            system.debug('Error when deleting contact: ' + e.getMessage());
            system.assert(false);
            return;
        }
        
        DeletedContactRole__c  deleteObj = [Select Id, ContactExternalId__c from DeletedContactRole__c where ContactExternalId__c = :externalId];
         
        //DeletedContact__c deleteObj = [Select ID, ContactExternalID__c from DeletedContact__c where ContactExternalID__c =:externalId];     
        //system.assertNotEquals(null, deleteObj);
        Test.stopTest();
    }             
    // SPOC - 1939 test class issue 
    static testMethod void clsContactCreationDispatchControllertest()
    {
    	Contact contact1 = clsTestFactory.getTestFactoryInstance().createYSContactWithParameters(null, null, null, 'test741122@test66698test.dk');
    	 Test.startTest();
    	ApexPages.StandardController stdcon = new ApexPages.StandardController(contact1);
    	clsContactCreationDispatchController clscon = new clsContactCreationDispatchController(stdcon);
    	Pagereference pgref = new Pagereference('003/e?ent=Contact&nooverride=0&RecordType=012M0000000Clg3&saveURL=123ser');
    	//pgref.getParameters().put('saveurl',String.valueOf('123qw'));
    	YSRecordTypes__c ysrec = YSRecordTypes__c.getInstance('YSRecordTypes');
    	String ysContactRecordType = ysrec.YS_Contact_Record_Type__c;
    	clscon.recordType = ysContactRecordType;
    	//pgref.getParameters().put('RecordType','123456789');
    	Test.setCurrentPage(pgref);
    	clscon.getRedir();
    	clscon.isYSContactDefault(); 
        ApexPages.currentPage().getParameters().put('RecordType','test'); 
        clscon.getRecordType();
        clscon.getRedir();
        ApexPages.currentPage().getParameters().put('RecordType',null); 
        clscon.getRecordType();
        clscon.getRedir();
    	Test.stopTest();
    	
    }      
}