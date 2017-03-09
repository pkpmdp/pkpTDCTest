/**
* This class contains unit tests for validating the behavior of Apex classes and triggers.
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
*/
 
/***********************************************************************************
************************************************************************************

* @class: CarrieUnappliedCreditControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieUnappliedCreditController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieUnappliedCreditControllerTestClass {
    
    /**
    * @description: This method is used to test general methods of CarrieUnappliedCreditController
    */
    static testMethod void testUnappliedCredit() {
        User user = CarrieTestUtil.insertUser();
        Unapplied_Credit__c credit = new  Unapplied_Credit__c();
        
        system.runAs(user){
            ApexPages.StandardController standardController = new ApexPages.StandardController(credit);
            CarrieUnappliedCreditController unappliedCredit = new CarrieUnappliedCreditController(standardController);
            unappliedCredit.redirectHomePage();
        }
    }
}