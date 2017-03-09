@isTest(seeAlldata = true)
private class batchCountAccountOnContactTest {
    static testMethod void countUnitTest() {
        Account account1 = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
        Account_Contact_Role__c acr1 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account1.id);
        //Account account2 = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();        
        //Account_Contact_Role__c acr2 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account2.id);
        
        Test.startTest();
                
        batchCountAccountOnContact countAcc = new batchCountAccountOnContact();
        //countAcc.cons.add(contact);
        countAcc.isTestRun = '1';
        countAcc.testContactID = contact.id;
        integer batchSize = 1;
        ID batchprocessid = Database.executeBatch(countAcc, batchSize);     
        
        Test.stopTest();
        List<Contact> cs = [SELECT kundeAntal__c FROM Contact where id =: contact.id Limit 1];       
        System.assertEquals('1', cs[0].kundeAntal__c);
    }
}