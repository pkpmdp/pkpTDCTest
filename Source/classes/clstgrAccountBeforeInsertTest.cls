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
private class clstgrAccountBeforeInsertTest {

    static testMethod void myUnitTest() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 1; i++){
            Account a = new Account();
            a.name = 'test'+i;
            a.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
            accounts.add(a);
        }
        
        try{
            Test.starttest();
            System.debug('Attempting to insert accounts');
            insert accounts;
            System.debug('Insert complete');
            // refresh the Position list to include the Hello__c field after the insert
            Map<ID,Account> accountMap = new Map<ID,Account>(accounts);
            accounts = [select id,Customer_Satisfaction_Lookup__c from account where id IN :accountMap.keySet()];
            List<Lookup_Customer_Satisfaction__c> lcss = [Select Id, Name from Lookup_Customer_Satisfaction__c where Name = 'Ikke relevant' LIMIT 1];
            Lookup_Customer_Satisfaction__c lcs;
            if(lcss.size() > 0)
                lcs = lcss[0];
            for (Account account:accounts){
                if(lcs != null) {
                    System.assertNotEquals(account.id,null);
                    System.assertEquals(account.Customer_Satisfaction_Lookup__c, lcs.Id);
                }
            }
        } catch (System.DmlException e){
            System.debug('We caught a DML exception: ' + e.getDmlMessage(0));   
        }
            Test.stoptest();    
    }

    /* Commented out - SPOC-1121 is replaced by SPOC-1213 - following methods are not applicable anymore:
    // SPOC-1121 tests
    static testMethod void fillNetInstallationTest1() {
        Address__c add = new Address__c(Name = 'Test street');
        insert add;

        Cable_Unit__c cu = new Cable_Unit__c(Name = 'Test Unit');
        insert cu;
        
        Net_Installations__c net = new Net_Installations__c(Name = 'Test instalation');
        net.Cable_Unit__c = cu.id;
        net.Address__c = add.id;
        insert net;
        
        // Uncomment if needed in order to create a customer
        //Decimal TESTNUM = 68999998;
        //CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        //custSeq.lastNumber__c = TESTNUM;              
        //insert custSeq;
        
        Account acc = new Account(Name = 'Test');
        acc.Street_YK__c = add.id;
        
        Test.startTest();
        
        insert acc;
        
        Account acc2 = [ SELECT Id, Net_Installation__c FROM Account WHERE Id=:acc.id ];
        System.assertEquals(net.id, acc2.Net_Installation__c);

        Test.stopTest();
    }
    
    static testMethod void fillNetInstallationTest2() {
        Address__c add = new Address__c(Name = 'Test street');
        insert add;

        Cable_Unit__c cu = new Cable_Unit__c(Name = 'Test Unit');
        insert cu;
        
        Net_Installations__c net1 = new Net_Installations__c(Name = 'Test instalation 1');
        net1.Cable_Unit__c = cu.id;
        net1.Address__c = add.id;
        insert net1;
        
        Net_Installations__c net2 = new Net_Installations__c(Name = 'Test instalation 2');
        net2.Cable_Unit__c = cu.id;
        net2.Address__c = add.id;
        insert net2;
        
        // Uncomment if needed in order to create a customer
        //Decimal TESTNUM = 68999998;
        //CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        //custSeq.lastNumber__c = TESTNUM;              
        //insert custSeq;
        
        Account acc = new Account(Name = 'Test');
        acc.Street_YK__c = add.id;
        
        Boolean excThrown = false;
        
        Test.startTest();
        try {
            insert acc;
        } catch (System.DmlException e) {        
            excThrown = true;
        }

        System.assert(excThrown);

        Account[] acc2 = [ SELECT Id, Net_Installation__c FROM Account WHERE Id=:acc.id ];
        System.assertEquals(0, acc2.size());

        Test.stopTest();
    }
    ... commented out */
}