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
 * See the Apex Language Reference for more information about Testing and Code Coverage. @isTest
 */

@isTest
public class CustomerLogHistoryTestClass {

   static testMethod void testCustomerLogHistroy() {
        
       
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
                
        Customer_Log__c c1 = new Customer_Log__c();
        c1.Creation_Date__c = System.now();
        c1.Customer__c = acc.id;
        c1.Inquiry_Form__c = '0';
        c1.Inquiry_Type__c = '0';
        c1.Text__c = 'TEST';
        c1.User_MID__c = 'M88889';
        c1.User_Name__c = 'TEST TEST';
        insert c1;
        
        
        CustomerLogHistory cuDetailsObj = new CustomerLogHistory();
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CableUnitCalloutMock());
            String page1 = CustomerLogHistory.fetchCustomerLog(acc.Id);
        Test.stopTest();
        
    }
   
    public class CableUnitCalloutMock implements HttpCalloutMock{
          public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Test Response');
            return res;
          }
      }
}