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

* @class: CarriePaymentInvoiceControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarriePaymentInvoiceController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarriePaymentInvoiceControllerTestClass {
    
    /**
    * @description: This method is used to test general methods of CarriePaymentInvoiceController
    */
    static testMethod void testPaymentInvoice() {
        User user = CarrieTestUtil.insertUser();
        Decimal ariaAccno = 3666081;
        Aria_Account__c customer = CarrieTestUtil.insertAccount(); 
        Faktura__c invoice = new Faktura__c(Aria_account__c = customer.Id);
        insert invoice;        
        Payment__c pym = New Payment__c(aria_account__c = customer.Id, Aria_Event_No__c ='1');
        insert pym;         
        Invoice_Payment__c inv_pym = new Invoice_payment__c(Aria_Account__c= customer.Id, Faktura__c = invoice.Id, Payment__c =pym.Id, amount_applied__c =0);
        insert inv_pym;       
        
        system.runAs(user){
            ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(invoice);    
            CarriePaymentInvoiceController paymentInvoice = new CarriePaymentInvoiceController(standardController);
            paymentInvoice.redirectHomePage();
        }
    }

}