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
private class updateActivityHelperSCTestClass {
    public static User u;
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc;
        
        List<Contact> contactEmail = new  List<Contact>();
        Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=acc.Id);
        insert c;
        if(c.email != null){
            contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false ];
        }
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
        insert u;
        System.runAs(u) {
        List<Order__c> tempOrder = new List<Order__c>();
        List<Account> loggedInAccount = new List<Account>();
        List<Contact> loggedInContact = new List<Contact>();
        SC_Activity_Log__c activLog = new SC_Activity_Log__c();
        Order__c o1 = new Order__c();
        o1.selectedmyBeboer__c = false;
        o1.loggedInUserName__c = 'vishal.thambe@test.com';
        o1.Kundedata__c = '';
        o1.Order_type__c = 'Downgrade';
        o1.cableUnitNumber__c = '0005037310';
        o1.ChangePackageDate__c = '01-06-2012';
        o1.cableUnitName__c = 'Bryggene';
        o1.SalesChannel__c = 'SC';
        o1.packageBeforeChange__c = 'Fuldpakke';
        o1.URL__c = 'http://preprod-kasia.yousee.dk/afsaetning/opdater/0/1101101';
        o1.Address_Id__c = '210291';
        o1.Media_Type__c = 'application/vnd.yousee.kasia2+json;version=1;charset=UTF-8';
        o1.Net_Installation__c = 'a1xM0000000NncMIAS';
        o1.Product_No__c = '1101101';
        o1.Kasia_Order_Status__c = 'NEW';
        o1.Product_Name__c = 'Mellempakke';
        o1.Installation_No__c = '1';
        tempOrder.add(o1);
        updateActivityHelper activityObj = new updateActivityHelper();
        activityObj.updatedCalloutActivityLog(tempOrder);
      }  
   
 }
}