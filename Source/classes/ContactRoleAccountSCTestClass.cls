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
private class ContactRoleAccountSCTestClass {

    static testMethod void myUnitTest() {
        Contact contact = new Contact(); 
    	ContactRoleAccount contactRoleAccountObj = new ContactRoleAccount(); 
        ContactRoleAccount contactRoleAccountObj1 = new ContactRoleAccount(contact); 
    }
    
   /* For Temporary purpose 
   static testMethod void myTest(){
   		Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
        add.Side__c='TV';
        insert add;
         
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acc = new Account(Name='Simferna');
        acc.Street_YK__c = add.Id;
        acc.RecordTypeId = recordType.Id;
        insert acc;
        ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
        Contact  C2 = new Contact(AccountID = acc.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_user@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1@test.com');
        insert C2;	
        User u1 = new User( email='test-user@test.com', contactid = C2.id, profileid = ProID,
                         UserName='test-user@testl.com', alias='tuser1', 
                         CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                         EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                         LastName = 'User',MID__c = 'M87654');
                         
	    	System.runAs(u1){
            //PageReference pageRef = Page.WriteToYourConsultant;
            //Test.setCurrentPage(pageRef);
            Test.startTest();
            ContactRoleAccount roleAccount = new ContactRoleAccount(C2);
   }
   
   } 
   
   static testMethod void paramContact(){
   		Contact c3 = new Contact();
   		ContactRoleAccount roleAccount = new ContactRoleAccount();
   }*/
}