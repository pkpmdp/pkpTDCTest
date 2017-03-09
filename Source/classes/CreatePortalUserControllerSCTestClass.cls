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
private class CreatePortalUserControllerSCTestClass {
    
    public static User u;
    public List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
    
    
  static testMethod void myPositiveUnitTest() {
        
        Contact contact = new Contact();
        Address__c address = new Address__c();
	    
	    Account acc = new Account();
	    acc.Name = 'TestHierarchy';
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
        
        Account kundeChild = new Account();
        kundeChild.Name = 'kundeCustomer';
        kundeChild.parentId = acc.Id;
        kundeChild.Cable_Unit__c = cableUnitTest.id;
        kundeChild.Type = 'kunde';
        kundeChild.Anlaeg_No__c = '3452345';
        kundeChild.Anlaeg_Name__c = 'xyz';
        kundeChild.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        insert kundeChild;
        
        address.Street__c = 'Amagerbrogade';
        address.Entrance__c = '';
       	address.House_No__c = '40';
        address.Floor__c = '1';
        //address.Side__c ='';
        address.Postcode__c = '';
        address.Town__c = 'Orderse C'; 
        address.Door_No__c = '';
        insert address;
       
        contact.FirstName = 'TestContact';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'testClassUser1@test.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '8457124578';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c=acc.Id;
        contact.Street_P__c = address.Id;
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;
    //   u = [SELECT Id, Name FROM User where email = 'vishal.tambe@capgemini.com' limit 1]; 
       System.runAs(u) {
       ID fetchedId;
       String cid;
       CreatePortalUserController createPortalUsrObj = new CreatePortalUserController();
       
       List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
       List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
       
       
       

	   createPortalUsrObj.getFetchedId();
       createPortalUsrObj.setFetchedId(fetchedId);                 
       createPortalUsrObj.getContact();
       createPortalUsrObj.setContact(contact);
       objectStrListtemp = createPortalUsrObj.getObjectStructure();
       
       for(cObjectStructureMap cc : objectStrListtemp){
         cc.selected = true;
         objectStrList.add(cc);
       }
       
       
       PageReference pageRef = new PageReference('/apex/ManagePortalUsersPage'); 
       Test.startTest();
       createPortalUsrObj.setlevelFlag(null,null);   
       createPortalUsrObj.setcurrentId(cid);
       createPortalUsrObj.cancelCreate();
       createPortalUsrObj.getAccounts();
      
       //createPortalUsrObj.save();             
       createPortalUsrObj.fetchAddressDetails();
       Test.stopTest();
       System.debug('%%%%%%Limits Class'+Limits.getQueries());
       } 
    }
   
   
    
   /*static testMethod void fetchACRrecords1() {
        Contact contact = new Contact();
        Contact logContact = new Contact();
        Address__c address = new Address__c();
        
	    Account acc = new Account();
	    acc.Name = 'TestHierarchy';
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
        
        Account kundeChild = new Account();
        kundeChild.Name = 'kundeCustomer';
        kundeChild.parentId = acc.Id;
        kundeChild.Cable_Unit__c = cableUnitTest.id;
        kundeChild.Type = 'kunde';
        kundeChild.Anlaeg_No__c = '3452345';
        kundeChild.Anlaeg_Name__c = 'xyz';
        kundeChild.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        insert kundeChild;
        
        address.Street__c = 'Amagerbrogade';
        address.Entrance__c = '';
       	address.House_No__c = '40';
        address.Floor__c = '1';
        //address.Side__c ='';
        address.Postcode__c = '';
        address.Town__c = 'Orderse C'; 
        address.Door_No__c = '';
        insert address;
       
        contact.FirstName = 'Testa';
        contact.LastName = 'Testb';
        contact.Email = 'testab@test.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c=acc.Id;
        contact.Street_P__c = address.Id;
        contact.UserProfile__c = 'ServiceCenter Portal User';
        insert contact;
        
        logContact.FirstName = 'Testc';
        logContact.LastName = 'Testd';
        logContact.Email = 'testcd@test.com';
        logContact.Phone = '2222221';
        logContact.MobilePhone = '3333331';
        logContact.HomePhone = '4444441';
        logContact.HierarchyAccount__c=acc.Id;
        logContact.Street_P__c = address.Id;
        logContact.UserProfile__c = 'ServiceCenter Portal User';
        insert logContact;
        
        
        CreatePortalUserController createPortalUsrObj = new CreatePortalUserController();
        PageReference pageRef = new PageReference('/apex/ManagePortalUsersPage'); 
        Test.startTest();
        createPortalUsrObj.save();             
        Test.stopTest();
    }*/
}