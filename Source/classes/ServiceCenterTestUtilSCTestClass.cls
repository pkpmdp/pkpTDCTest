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
private class ServiceCenterTestUtilSCTestClass {
    public static User u;
    public static String[] sourceArr = new String[]{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};   
    public static String[] phoneArr= new String[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9','','-','+',' '};   
    public static ID cAccId;
    public static ID cntId;
  
      
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
       Test.startTest();
       List<Account> randomAccountList = new List<Account>();
       ServiceCenterTestUtil testUtil = new ServiceCenterTestUtil();
       Contact contact = new Contact();
       Address__c address = new Address__c();
       ServiceCenterTestUtil.getRandomAccountIdList();
       ServiceCenterTestUtil.getRandomRoleId();
       ServiceCenterTestUtil.getRandomRoles();
       ServiceCenterTestUtil.getRandomAccountId();
       ServiceCenterTestUtil.getDomainName();
       ServiceCenterTestUtil.getRandomEmail();
       //ServiceCenterTestUtil.setTestCableUnitNumber();
       //ServiceCenterTestUtil.accountTestData();
       Test.stopTest(); 
      
    }
    
    static testMethod void myUnitTest1(){
       Test.startTest();
       ServiceCenterTestUtil testUtil1 = new ServiceCenterTestUtil();
       ServiceCenterTestUtil.getRandomRolesName();
       ServiceCenterTestUtil.getRandomName();
       ServiceCenterTestUtil.getRandomAlphaNumeric();
       ServiceCenterTestUtil.getRandomContact();
       Test.stopTest();
    }
    
    /*static testMethod void unitTest1(){
        Test.startTest();
        ServiceCenterTestUtil unitTest = new ServiceCenterTestUtil();
        ServiceCenterTestUtil.setTestCableUnitNumber();
        Test.stopTest();
    }*/
         
}