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
 * Test class For deleteCustomerLogHistory.
 
 */
@isTest
private class batchDeleteCustomerLogTestClass {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        // Create some test Sales proposal records to be deleted by the batch job.
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
        
        Account acc = new Account();
        acc.Name = 'TestKunde';
        acc.Type='Kunde';
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Customer_Log__c  sp = new Customer_Log__c();
        sp.Customer__c = acc.Id;
        sp.Date__c = Date.valueOf('2013-10-26');
        sp.Creation_Date__c = System.now();
        sp.Inquiry_Form__c = '1';
        sp.Inquiry_Type__c = '1';
        sp.Text__c = 'TEST1';
        sp.User_MID__c = 'M89562';
        sp.User_Name__c = 'TEST TEST';
        insert sp;
        
        id spId = sp.id;
       
        List<Customer_Log__c > spList = new List<Customer_Log__c >();
        spList = [Select Id From Customer_Log__c  Where Id = :spId];
        Test.startTest();
        deleteCustomerLogHistory deleteCL= new deleteCustomerLogHistory();
        integer batchSize = 200;
        ID batchprocessid = Database.executeBatch(deleteCL, batchSize);
        deleteCL.start(null);
        deleteCL.execute(null, spList);
        
        System.abortJob(batchprocessid);  
        Database.DeleteResult[] drList = Database.delete(spList, false);
        Database.EmptyRecycleBinResult[] emptyRecycleBinResults = Database.emptyRecycleBin(spList);
        Test.stopTest();
    }
}