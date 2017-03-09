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

* @class: CarrieInvoicePaymentControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieInvoicePaymentController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieInvoicePaymentControllerTestClass {
    
    /**
    * @description: This method is used to test general methods of CarrieInvoicePaymentController
    */
    static testMethod void testInvoicePayment() {
        User user = CarrieTestUtil.insertUser();
        Payment__c payment = new Payment__c();
        
        system.runAs(user){
            ApexPages.StandardController standardController = new ApexPages.StandardController(payment);
            CarrieInvoicePaymentController invoicePayment = new CarrieInvoicePaymentController(standardController);
            invoicePayment.redirectHomePage();
        }
    }
}