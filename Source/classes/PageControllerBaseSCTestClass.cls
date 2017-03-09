/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test 	methods in an organization are executed whenever Apex code is deployed
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
private class PageControllerBaseSCTestClass {

	public static user u;

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         try{
        	Test.startTest();
        	
	        Account acc = new Account();
	        acc.Name = 'TestAccount';
	        acc.Type='Hierarki';
	        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
	        insert acc;
	        
	        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
	        cableUnitTest.Name = 'cu_kundeCust_testing'; 
	        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        	cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        	cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        	cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        	cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        	cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
	        insert cableUnitTest;
	        
	        List<Id> freeFlyContDiffHier = new List<Id>();
	        List<Contact> contactEmail = new  List<Contact>();
	        
		 	Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=acc.Id);
		 	insert c;
		 
			 if(c.email != null){
			 	contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
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
       		String query = 'Select Id, Name From Contact';
       		String excelQuery = 'Select Id, Name From Contact limit 10';
       		Integer pageSize = 10;
       		
       		PageControllerBase controller = new PageControllerBase();
        	controller.showFlagChange = false;
        	controller.getQuery();
        	controller.getExcelQuery();
        	controller.getPageSize();
        	//controller.initializePaging();
        	controller.getThis();
        	controller.setQuery(query);
        	controller.setExcelQuery(excelQuery);
        	controller.setPageSize(pageSize);
        	//controller.getRecords();
        	//controller.setQueryForAllRecords();
        	controller.getRecordsforExport();
        	
       }
        }catch(System.Exception e){
        	system.debug('Error'+e.getMessage());
        	Test.stopTest();	
        }
        
    }
  
}