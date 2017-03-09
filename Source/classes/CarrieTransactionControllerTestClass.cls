/*
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
@isTest(SeeAllData=true)
private class CarrieTransactionControllerTestClass {
    /**
    * @description: This method is used to test general methods of CarrieCustomerBillingController
    */
    static testMethod void testTransaction() {
        Decimal ariaAccountNo = 3666081; 
        Id customerId;
        User user = CarrieTestUtil.insertUser();
        Aria_Account__c customer  = CarrieTestUtil.insertAccount(); 
        
        system.runAs(user){
            Test.startTest(); //CARRIE-752
            /* Start of CARRIE-752 */
                        
            Transaction__c trans = new Transaction__c();
            trans.Aria_Account__c = customer.Id;
            trans.Name='111';
            trans.Transaction_No__c='111';
            trans.posting_date__c=Date.today();
            trans.charge_amt__c=100;
            trans.credit_amt__c=0;
            insert trans;
            
            ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
            CarrieTransactionController trans1 =new CarrieTransactionController(standardController);
            trans1.redirectCustomerBillingPage();
            trans1.getTransactionDetails();
            trans1.Beginning();
            trans1.Previous();
            trans1.Next();
            trans1.End();
            trans1.getDisablePrevious();
            trans1.getDisableNext();
            trans1.getTotal_size();
            trans1.getPageNumber();
            trans1.getTotalPages();
            Test.stopTest();
            }
       }    
 }