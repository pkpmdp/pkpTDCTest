/*
    @Author: mkha@yousee.dk 
    
    Test types:
    Primary: Test as much functionality as possible.
    Secondary: Only some code fragments are tested. Those classes have their own primary test classes.
    
    Test-class for: 
    tgrAccountBeforeInsert (Primary)
    tgrAccountAfterInsertUpdate (Primary)
*/

@isTest(SeeAllData=true)
private class clsAccountTest {

    static testMethod void testCreatePersonAccount() {
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createPersonAccount();                    
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);        
    }
    
    static testMethod void testEditPersonAccount() {
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createPersonAccount();
            acc.Phone = '3232323';
            update acc;
                                
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);     
    }
    
    static testMethod void testCreateBusinessCableUnitAccount() {    
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);   
    }
    
    static testMethod void testEditBusinessCableUnitAccount() {
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
            acc.Phone = '3232323';
            update acc;
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);   
        
    }
    
    static testMethod void testCreateBusinessHierarchyAccount() {    
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);   
    }
    
    static testMethod void testEditBusinessHierarchyAccount(){
        Account acc = null;     
        Test.startTest();
        try{
            acc = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
            acc.Phone = '3232323';
            update acc;
        }catch(Exception e){
            system.assert(false);
            return;
        } finally{
            Test.stopTest();    
        }       
        system.assert(true);        
    }   
    
    static testMethod void testCustomerSatisfaction() {
        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        acc.Customer_Satisfaction_Lookup__c = null;
        Test.startTest();
        update acc; 
        acc = [Select Id, Customer_Satisfaction_Lookup__c from Account where id = :acc.Id];
        //system.assertNotEquals(acc.Customer_Satisfaction_Lookup__c, null);
        Test.stopTest();    
    }
    
    static testMethod void testUpdateExternalIds() {
        Account acc = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        acc.KISS_Customer_No__c = '';
        acc.Customer_No__c = '';
        update acc;
        
        Test.startTest();               
        Account tmp = [Select Id, KISS_Customer_No__c, Customer_No__c from Account where Id = :acc.Id];
        system.assertNotEquals('', tmp.KISS_Customer_No__c);
        system.assertNotEquals('', tmp.Customer_No__c);
        Test.stopTest();
    }
    // SPOC-1939 Test classes Issue
    static testMethod void testclsAccountContactRoleController()
    {
        
        Account acc1 = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc1.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       contact.Status__c = 'Aktiv';
       insert contact;
        AccountContactRole avccR = new AccountContactRole();
        avccR.AccountId = acc1.id;
        avccR.ContactId = contact.id;
        insert avccR;
        ApexPages.StandardController stdcon = new ApexPages.StandardController(acc1);
        clsAccountContactRoleController acc = new clsAccountContactRoleController(stdcon);
        PageReference pgref = new PageReference('AccountContactRoleSync');
        pgref.getParameters().put('id',acc1.Id);
        acc.touchContact();
    }
    
}