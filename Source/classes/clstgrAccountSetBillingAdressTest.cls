/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class clstgrAccountSetBillingAdressTest {

    static testMethod void NoBillingAdressTest() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        insert custSeq;

        Test.startTest();
        Address__c add = new Address__c(Street__c='Test street');
        insert add;
        
        Account acc = new Account(FirstName='John', LastName='Test');
        acc.Street_YK__c = add.Id;
        insert acc;

        Account acc2 = [Select Id, LastName, Street_YK__c, Billing_Address__c FROM Account WHERE Id = :acc.id];

        System.assertEquals('Test', acc2.LastName);
        System.assertEquals(add.Id, acc2.Street_YK__c);
        System.assertEquals(add.Id, acc2.Billing_Address__c);
        Test.stopTest();
    }
    
    static testMethod void BillingAdressSetTest() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        insert custSeq;

        Test.startTest();
        Address__c add1 = new Address__c(Street__c='Test street');
        insert add1;
        Address__c add2 = new Address__c(Street__c='Test street 2');
        insert add2;
        
        Account acc = new Account(FirstName='John', LastName='Test');
        acc.Street_YK__c = add1.Id;
        acc.Billing_Address__c = add2.Id;
        insert acc;

        Account acc2 = [Select Id, LastName, Street_YK__c, Billing_Address__c FROM Account WHERE Id = :acc.id];

        System.assertEquals('Test', acc2.LastName);
        System.assertEquals(add1.Id, acc2.Street_YK__c);
        System.assertEquals(add2.Id, acc2.Billing_Address__c);
        Test.stopTest();
    }
    
    static testMethod void NoLegalAdressTest() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        insert custSeq;

        Test.startTest();
        
        Account acc = new Account(FirstName='John', LastName='Test');
        insert acc;

        Account acc2 = [Select Id, LastName, Street_YK__c, Billing_Address__c FROM Account WHERE Id = :acc.id];

        System.assertEquals('Test', acc2.LastName);
        System.assertEquals(null, acc2.Street_YK__c);
        System.assertEquals(null, acc2.Billing_Address__c);
        Test.stopTest();
    }
}