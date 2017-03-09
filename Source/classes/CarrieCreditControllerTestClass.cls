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

* @class: CarrieCreditControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieCreditController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieCreditControllerTestClass {
    
    
    /**
    * @description: This method is used to test general methods of CarrieCreditController
    */
    static testMethod void testCredit() {
        User user = CarrieTestUtil.insertUser();
        Aria_Account__c customer = CarrieTestUtil.insertAccount(); 
        ApexPages.StandardController cont = new ApexPages.StandardController(customer);
        
        system.runAs(user){
            //Negative Scenarios
            CarrieCreditController credit = new CarrieCreditController(cont);
            credit.amount='';
            credit.selectComments ='Select';
            credit.Validate();   
            
            credit =new  CarrieCreditController(cont);
            credit.amount='10';
            credit.creditReason='0';
            credit.selectComments ='TEMP';
            credit.Validate();   
            
            credit =new  CarrieCreditController(cont);
            credit.amount='10';
            credit.creditReason='1';
            credit.selectComments ='';
            credit.Validate();   
            credit.save();
            credit.saveNew();
             
            //Positive Scenarios
            credit =new  CarrieCreditController(cont);
            credit.selectComments ='comments one';
            credit.amount='100';
            credit.creditReason='Help';
            credit.creditType='1';
            credit.Validate();      
            credit.saveNew();
            credit.getCreditReasons();
            credit.getCreditTypes();
            credit.redirectCustomerBillingPage();
            
            credit =new  CarrieCreditController(cont);
            credit.amount='100';
            credit.creditType='2';
            credit.creditReason='Help';
            credit.selectComments ='comments one';
            credit.save();
           
        }
    }

}