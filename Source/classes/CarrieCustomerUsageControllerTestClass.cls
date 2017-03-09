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

* @class: CarrieCustomerUsageControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieCustomerUsageController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieCustomerUsageControllerTestClass{
    static User testUser;
    
    /**
    * @description: Cover Postive Scenarios and General Methods in the controller
    */  
    static testMethod void testGenerateTree(){
              
        Aria_Account__c customer = new Aria_Account__c(); 
        customer = CarrieTestUtil.insertAccount();               
        testUser= CarrieTestUtil.insertUser();
        List<Account> acc = [Select Id,PersonEmail from Account where Id =: customer.Account__c]; 
        acc[0].PersonEmail = 'abc@test.com';
        update acc;
        
        String response = '[{"usage":{"amount":-1.55,"duration":50100.0,"calls":8,"type":"a-number","length":2, '+
          '"data":{"74532976":{"amount":-1.55,"duration":50100.0,"calls":8,"type":"dest","length":2, '+
          '"data":{"Opkaldsafgift":{"amount":-0.25,"duration":60.0,"calls":1,"type":"subdest","length":1, '+
          '"data":{"Opkaldsafgift for opkald til 40793076": '+
          '{"amount":-0.25,"duration":60.0,"calls":1,"type":"b-number","length":1, '+
          '"data":{"40793076":{"amount":-0.25,"duration":60.0,"calls":1,"type":"call","length":1, '+
          '"data":[{"start-time":"19-06-2011 17:57:50","duration":60,"amount":-0.25}]}}}}}, '+
          '"Opkald til Danmark":{"amount":-1.3,"duration":50040.0,"calls":1,"type":"subdest","length":2, '+
          '"data":{"Opkald til Mobil":{"amount":-1.3,"duration":60.0,"calls":1,"type":"b-number","length":1, '+
          '"data":{"40793076":{"amount":-1.3,"duration":60.0,"calls":1,"type":"call","length":1, '+
          '"data":[{"start-time":"19-06-2011 17:57:50","duration":60,"amount":-1.3}]}}}, '+
          '"Opkald til Fastnet":{"amount":0.0,"duration":49980.0,"calls":2,"type":"b-number","length":5, '+
          '"data":{"74567902":{"amount":0.0,"duration":240.0,"calls":1,"type":"call","length":1, '+
          '"data":[{"start-time":"22-05-2011 16:46:23","duration":240,"amount":0.0}]}, '+
          '"74520606":{"amount":0.0,"duration":720.0,"calls":4,"type":"call","length":4, '+
          '"data":[{"start-time":"11-05-2011 16:33:17","duration":180,"amount":0.0}, '+
          '{"start-time":"18-05-2011 17:07:23","duration":420,"amount":0.0}, '+
          '{"start-time":"18-05-2011 17:14:07","duration":60,"amount":0.0}, '+
          '{"start-time":"18-05-2011 17:15:10","duration":60,"amount":0.0}]}}}}} '+
          '}}}}}]';

        system.runAs(testUser) {
            Test.startTest(); 
              
            PageReference pageRef = Page.CarrieCustomerUsagePage;
            Test.setCurrentPage(pageRef); 
            
            ApexPages.StandardController cont = new ApexPages.StandardController(customer);    
            CarrieCustomerUsageController usage = new CarrieCustomerUsageController(cont);
            usage.isApexTest = true;
            
            //Test reRenderDates() method        
            usage.getTimePeriod();
            usage.selectedPeriod = 'I dag';
            usage.reRenderDates();
            usage.selectedPeriod = 'Seneste uge';
            usage.reRenderDates();
            usage.selectedPeriod = '4';
            usage.reRenderDates();
    
            //Test remaining methods for positive scenarios            
            usage.selectedPeriod = 'Vælg periode';
            usage.fromDate = '01-05-2010';
            usage.toDate = '01-05-2011';
            usage.getUsageDetails();
            usage.generateTree(response);        
            usage.renderAsPDF();
            usage.emailAsPDF(); 
            usage.backToCustomer();   
            usage.selectedPeriod = 'Vælg periode';
            usage.startDate= '01-05-2010';
            usage.searchEndDate = '01-05-2011';        
            usage.getUsageDetails();
            usage.generateTree(response);
            system.debug('abcd' + customer);
            system.debug(customer.account__c); 
            system.debug(acc);
            usage.emailAsPDF();  
            usage.getthousandBlocks();        
            Test.stopTest();
        }
    }
    
    /**
    * @description: Cover Negative Scenarios
    */  
    static testMethod void testExceptionScenarios(){        
        Aria_Account__c customer = new Aria_Account__c();      
        customer = CarrieTestUtil.insertAccount();
        testUser= CarrieTestUtil.insertUser();
        
        system.runAs(testUser){
            Test.startTest();  
            PageReference pageRef = Page.CarrieCustomerUsagePage;
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController cont = new ApexPages.StandardController(customer);        
            CarrieCustomerUsageController usage = new CarrieCustomerUsageController(cont);
            usage.isApexTest = true;
            usage.selectedPeriod = 'Vælg periode';                        
             
            //From date greater than To date
            usage.startDate = usage.searchEndDate = '';
            usage.fromDate = '01-05-2012';
            usage.toDate = '01-05-2011';
            usage.getUsageDetails();
            
            //Future Date scenario
            usage.startDate = usage.searchEndDate = '';             
            usage.fromDate = '30-12-2020';
            usage.toDate = '31-12-2020';
            usage.getUsageDetails();   
            
            //Future From Date   
            usage.fromDate = '31-12-2020';
            usage.toDate = '14-10-2010';
            usage.getUsageDetails();
            
            //Future To Date
            usage.startDate = usage.searchEndDate = '';   
            usage.fromDate = '14-10-2010';
            usage.toDate = '31-12-2020';            
            usage.getUsageDetails();
                                                         
            //No From date and To date
            usage.startDate = usage.fromDate = usage.toDate = usage.searchEndDate = '';
            usage.getUsageDetails();                        
            
            String response = '{"usage":{"amount":-1.55,"duration":50100.0,"calls":8,"type":"a-number","length":2, '+
          '"data":{"74532976":{"amount":-1.55,"duration":50100.0,"calls":8,"type":"dest","length":2, '+
          '"data":{"Opkaldsafgift":{"amount":-0.25,"duration":60.0,"calls":1,"type":"subdest","length":1, '+
          '"data":[{"start-time":"22-05-2011 16:46:23","duration":240,"amount":0.0}]}}}}}}'; 
            usage.selectedPeriod = 'Vælg periode';
            usage.fromDate = '01-05-2010';
            usage.toDate = '01-05-2011';
            usage.getUsageDetails();
            usage.generateTree(response); 
            
            //Invalid Response
            response = 'abcd';
            usage.generateTree(response);      
            Test.stopTest();
        }         
    } 
    
    /**
    * @description: Cover new methods created + additional negative scenarios
    */  
    static testMethod void testNewMethods(){
        Aria_Account__c customer = new Aria_Account__c();  
        customer = CarrieTestUtil.insertAccount();
        testUser= CarrieTestUtil.insertUser();
        
        system.runAs(testUser){
            Test.startTest();  
            PageReference pageRef = Page.CarrieCustomerUsagePage;
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController cont = new ApexPages.StandardController(customer);        
            CarrieCustomerUsageController usage = new CarrieCustomerUsageController(cont);
            usage.isApexTest = true;
            
            //Test setDateType method
            usage.dateType = 'bothDate';
            usage.setDateType();
            
            usage.dateType = 'fromDate';
            usage.setDateType();
            
            usage.dateType = 'toDate';
            usage.setDateType();
            
            //Test emailAsPDF method
            usage.fromDate = '01-05-2010';
            usage.toDate = '01-05-2011';
            usage.getUsageDetails();
            usage.emailAsPDF(); 
            
            //Test case for customer where customer number is null
            customer = [Select Account__c,Account__r.Customer_No__c, Name, Aria_Account_No__c, Customer_No__c from Aria_account__c where Customer_No__c = '' limit 1];
            ApexPages.StandardController cont2 = new ApexPages.StandardController(customer);        
            CarrieCustomerUsageController usage2 = new CarrieCustomerUsageController(cont2);
            usage2.isApexTest = true; 
            usage2.selectedPeriod = 'Vælg periode';
            usage2.fromDate = '01-05-2010';
            usage2.toDate = '01-05-2011';
            usage2.getUsageDetails();
            
            Test.stopTest();
        }        
    }
}