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
private class AccountTreeStructureSCTestClass {

    static testMethod void testAccountTreeStructure() {
    	String objId='testObject';
        AccountTreeStructure accTreeStructObj = new AccountTreeStructure();
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
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
         
         
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Customer_No__c = '475873495';
        accObj.ParentId = acc.Id;
        accObj.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        insert accObj;
        
        List<String> cnl = new List<String> { 'a','b','c'};
        List<String> nnl = new List<String> { 'a','b'};
        objId = accObj.Id;
        accTreeStructObj.getTopElement(objId);
        accTreeStructObj.setcloseFlag(cnl, nnl, 'end');
    }
}