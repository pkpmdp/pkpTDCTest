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
private class Dezide_Controller_Test {

    static testMethod void testDezideController() {
        // TO DO: implement unit test
        INTEGRATION__c inte = new INTEGRATION__c();
        inte.Name = 'YK7Inbound';
        inte.HttpMethod__c = 'GET';
        inte.IsBodyAppended__c = false;
        inte.Service__c = 'JITTERBIT';
        inte.Params__c = 'customerid';
        insert inte;
        Account a = new Account();
        a.Name = 'test';
        a.Customer_No__c = '123456';
        a.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert a;
        
        Test.setMock(HttpCalloutMock.class, new DezideHttpCalloutMock());
        Test.startTest();
        ApexPages.StandardController std = new ApexPages.StandardController(a);
        Dezide_Controller ctrlr = new Dezide_Controller(std);
        Test.stopTest();
        ctrlr.redirectToDezide();
    }
    
    public class DezideHttpCalloutMock implements HttpCalloutMock{
          public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = '<rows><row><LEADCUSTOMERID>0002810398</LEADCUSTOMERID><CUSTOMERID>601983579</CUSTOMERID><ADDRESSID>5240931</ADDRESSID>' + 
      					+ '<FIRSTNAME>HENRIK</FIRSTNAME><LASTNAME>KLEFFEL</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><PRODUCTVARIANT/>' + 
      					+ '<ACTIVE>1</ACTIVE><BILLINGSTART>2003-01-01T00:00:00.000</BILLINGSTART><BILLINGEND/><BUSINESS_GROUP>Kabel-tv</BUSINESS_GROUP>' +
      					+ '<PRICE/><STREET>Platanhaven</STREET><VARENUMMER/><PAYERID> 601983579</PAYERID></row>' + 
      					+ '<row><LEADCUSTOMERID>0002810398</LEADCUSTOMERID><CUSTOMERID>601983579</CUSTOMERID><ADDRESSID>5240931</ADDRESSID>' + 
      					+ '<FIRSTNAME>HENRIK</FIRSTNAME><LASTNAME>KLEFFEL</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><PRODUCTVARIANT/>' + 
      					+ '<ACTIVE>1</ACTIVE><BILLINGSTART>2003-01-01T00:00:00.000</BILLINGSTART><BILLINGEND/><BUSINESS_GROUP>Bredbånd</BUSINESS_GROUP>' +
      					+ '<PRICE/><STREET>Platanhaven</STREET><VARENUMMER/><PAYERID> 601983579</PAYERID></row></rows>';
            res.setBody(body);
            return res;
          }
      }
}