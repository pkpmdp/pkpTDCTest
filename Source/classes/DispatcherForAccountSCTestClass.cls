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
private class DispatcherForAccountSCTestClass {
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
		 	contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false];
		 }
		 
    	Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
       	u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
		insert u;
    //   u = [SELECT Id, Name FROM User where email = 'vishal.tambe@capgemini.com' limit 1]; 
       	System.runAs(u) {
       	ApexPages.Standardcontroller stc = new ApexPages.Standardcontroller(c);
       	DispatcherForAccountAssignmentController dispatcherObj = new DispatcherForAccountAssignmentController(stc);
    	dispatcherObj.redirectEditPage();   
    }
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c= clsTestDataForYS.createLookupCustomerSegment(); 
        insert acc;
        
        List<Contact> contactEmail = new List<Contact>();
        Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=acc.Id);
		 insert c;
		 if(c.email != null){
		 	contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false];
		 }
		Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        ApexPages.Standardcontroller stc = new ApexPages.Standardcontroller(c);
       	DispatcherForAccountAssignmentController dispatcherObj = new DispatcherForAccountAssignmentController(stc);
    	dispatcherObj.redirectEditPage();   
    }
    
    static testMethod void myUnitTest2(){
    	

    	Account acc1 = new Account();
    	acc1.Name = 'TestHierarchy';
    	acc1.Type = 'Hierarki';
    	acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
    	insert acc1;
    	List<Contact> contactTemp = new List<Contact>();
    	Contact c1 = new Contact(Email= 'abcd@test.com', FirstName= 'Amrish', LastName= 'Surve', Phone ='12457896', Temporary_contact__c = true);
    	insert c1;
    	ApexPages.Standardcontroller scCon = new ApexPages.Standardcontroller(c1);
    	DispatcherForAccountAssignmentController disCon = new DispatcherForAccountAssignmentController(scCon);
    	disCon.redirectEditPage();
    }
    
     
}