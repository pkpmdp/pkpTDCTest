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
private class ManagePortalUserControllerSCTestClass {
    public static ApexPages.Standardsetcontroller sc1;
    static List<Contact> dummyAdd;
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Address__c addr  = new Address__c();        
        addr.Town__c = 'AH';        
        addr.Postcode__c = '421002';        
        addr.Door_No__c = '301';        
        //addr.Side__c = 'A';        
        addr.Floor__c = 'Third';        
        addr.House_No__c = 'testData';        
        addr.Street__c = 'AH';        
        addr.Entrance__c = 'A';        
        insert addr;              
        
        
        //Insert a new account
        Account acc = new Account();         
        acc.Name = 'TestHierarchy';         
        acc.Type='Hierarki';         
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();         
        acc.Street_YK__c = addr.Id;         
        acc.Street_YK__r = addr;         
        insert acc;
        
        //Insert a new contact
        Contact contact = new Contact();              
        contact.FirstName='MTest';       
        contact.LastName='MTest';       
        contact.email='MTest@MTest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

        Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';         
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_No__c = '0000000455';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;        
                        
        Account account = new Account();
        account.Name = 'TestHierarchy1';         
        account.Type='Hierarki';         
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();       
        account.Street_YK__c = addr.Id;         
        account.Street_YK__r = addr; 
        account.ParentId = acc.Id; 
        account.Cable_Unit__c = cableUnitTest.Id;  
        account.Anlaeg_Name__c = 'EJENDOM 41';        
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User user = new User();        
        String paswd = 'temp';       
        user = new User(alias = 'standt', email='MTest@atest.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654',IsActive = true);                    
        user.setOptions(dmo);        
        insert user;         
        Integer pageSize = 5;
        Integer resultSize1 = 10;
        Id contactTempId;
        Test.startTest();
        System.runAs(user)
        {
            Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
            system.debug('role 3 PPPP ' + role3);
            
            Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = account.Id;
            acr.Contact__c = contact.Id;
            acr.Role__c = role3.Id;                        
            insert acr;
            contactWrapper tempWrapper = new contactWrapper();
            List<contactWrapper> portalTempList = new List<contactWrapper>();
            List<contactWrapper> listExpACRRole = new List<contactWrapper>();
            ACRRoles newTempRole = new ACRRoles();
                       
            PageReference pageRef = Page.ManagePortalUsersPage; 
            Test.setCurrentPage(pageRef);  
            ManagePortalUserController TempUsrObj = new ManagePortalUserController();
            TempUsrObj.fetchUserList();
            TempUsrObj.setStatus();
            TempUsrObj.addContact();
            TempUsrObj.deleteAllContact();
            TempUsrObj.tempFlag = true; 
            TempUsrObj.getContactsLoggedInAccountIdList();
            TempUsrObj.fetchContactDetails();
            TempUsrObj.fetchContact();
            
            TempUsrObj.setCurrentCountText1();
            //TempUsrObj.getPortalUserList();
            TempUsrObj.first();
            TempUsrObj.last();
            TempUsrObj.next();
            TempUsrObj.previous();
            TempUsrObj.cancel();
            TempUsrObj.setPageSize1(pageSize);
            TempUsrObj.getPageSize1();
            TempUsrObj.getResultSize();
            //TempUsrObj.getRecordsforExport();
            //TempUsrObj.getListExport();
            TempUsrObj.initializePagingForUser();
            //TempUsrObj.getAllRecords();
            //TempUsrObj.handlePaging();
            //TempUsrObj.fetchContactDetails1();
            //TempUsrObj.getProfileName(contactTempId);
        }
        Test.stopTest();
        
    }
    
    /*static testMethod void tempUnit(){
        Test.startTest();
        String deleteFlag;
        ManagePortalUserController tempCont = new ManagePortalUserController();
        tempCont.tempFlag = true;
        tempCont.getContactsLoggedInAccountIdList();
        tempCont.deleteAllContact();
        Test.stopTest();
    
    }*/
   
   static testMethod void tempTest(){
       //String query = 'Select Id, Name From Contact limit 10';
       Address__c addr  = new Address__c();        
        addr.Town__c = 'AH';        
        addr.Postcode__c = '421002';        
        addr.Door_No__c = '301';        
        //addr.Side__c = 'A';        
        addr.Floor__c = 'Third';        
        addr.House_No__c = 'testData';        
        addr.Street__c = 'AV';        
        addr.Entrance__c = 'B';        
        insert addr;              
        
        //Insert a new account
        Account acc = new Account();         
        acc.Name = 'TestHierarchy';         
        acc.Type='Hierarki';         
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        acc.Street_YK__c = addr.Id;         
        acc.Street_YK__r = addr;         
        insert acc;
        
        //Insert a new contact
        Contact contact = new Contact();              
        contact.FirstName='MTest3';       
        contact.LastName='MTest3';       
        contact.email='MTest33@MTest.com';       
        contact.MobilePhone='12234534';       
        contact.HomePhone='23455634';        
        contact.Phone='2354433';        
        contact.Street_P__c= addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

        

        Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';         
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_No__c = '0000000855';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;        
                        
        Account account = new Account();
        account.Name = 'TestHierarchy1';         
        account.Type='Hierarki';          
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();       
        account.Street_YK__c = addr.Id;         
        account.Street_YK__r = addr; 
        account.ParentId = acc.Id; 
        account.Cable_Unit__c = cableUnitTest.Id;  
        account.Anlaeg_Name__c = 'EJENDOM 41';        
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User user = new User();        
        String paswd = 'temp';       
        user = new User(alias = 'standt', email='MTest33@atest.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUse33r@test.com',MID__c = 'M87654',IsActive = true);                    
        user.setOptions(dmo);        
        insert user;         
        Integer pageSize = 5;
        Integer resultSize1 = 10;
        Id contactTempId;
        Test.startTest();
        
        System.runAs(user)
        {
            Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
            system.debug('role 3 PPPP ' + role3);
            
            Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = account.Id;
            acr.Contact__c = contact.Id;
            acr.Role__c = role3.Id;                        
            insert acr;
            contactWrapper tempWrapper = new contactWrapper();
            List<contactWrapper> portalTempList = new List<contactWrapper>();
            List<contactWrapper> listExpACRRole = new List<contactWrapper>();
            ACRRoles newTempRole = new ACRRoles();
                       
            PageReference pageRef = Page.ManagePortalUsersPage; 
            pageRef.getparameters().put(contactConstClass.STATUS,'editedsuccessfully');
            Test.setCurrentPage(pageRef);  
            ManagePortalUserController TempUsrObj = new ManagePortalUserController();
            TempUsrObj.fetchUserList();
            TempUsrObj.setStatus();
            TempUsrObj.addContact();
            TempUsrObj.tempFlag = true; 
            TempUsrObj.deleteAllContact();
            TempUsrObj.getContactsLoggedInAccountIdList();
            TempUsrObj.fetchContactDetails();
            TempUsrObj.fetchContact();
            
            //TempUsrObj.setCurrentCountText1();
            //TempUsrObj.getPortalUserList();
            /*TempUsrObj.first();
            TempUsrObj.last();
            TempUsrObj.next();
            TempUsrObj.previous();
            TempUsrObj.cancel();
            TempUsrObj.setPageSize1(pageSize);
            TempUsrObj.getPageSize1();
            TempUsrObj.getResultSize(); */
            //TempUsrObj.getRecordsforExport();
            //TempUsrObj.getListExport();
            TempUsrObj.initializePagingForUser();
            //TempUsrObj.getAllRecords();
            //TempUsrObj.handlePaging();
            //TempUsrObj.fetchContactDetails1();
            //TempUsrObj.getProfileName(contactTempId);
            
            Boolean b1 = TempUsrObj.hasPrevious;
            Boolean b2 = TempUsrObj.hasNext;
            TempUsrObj.hasNext = true;
            TempUsrObj.hasPrevious = true;
        }
        Test.stopTest();
   
   }
   
   /*
   static testMethod void unitTestForFlag(){
       Test.startTest();
       ManagePortalUserController tempcon1 = new ManagePortalUserController();
       tempcon1.tempFlag = true;
       tempcon1.deleteAllContact();
       tempcon1.fetchContactDetails1();
       Test.stopTest();
   }*/
   
   static testMethod void tempTestPAging(){
       String query = 'Select Id, Name From Contact limit 10';
        Address__c addr  = new Address__c();        
        addr.Town__c = 'AH';        
        addr.Postcode__c = '421002';        
        addr.Door_No__c = '301';        
        //addr.Side__c = 'A';        
        addr.Floor__c = 'Third';        
        addr.House_No__c = 'testData';        
        addr.Street__c = 'AH';        
        addr.Entrance__c = 'A';        
        insert addr;              
        
        //Insert a new account
        Account acc = new Account();         
        acc.Name = 'TestHierarchy';         
        acc.Type='Hierarki';         
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();          
        acc.Street_YK__c = addr.Id;         
        acc.Street_YK__r = addr;         
        insert acc;
        
        //Insert a new contact
        Contact contact = new Contact();              
        contact.FirstName='MTest';       
        contact.LastName='MTest';       
        contact.email='MTest@MTest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

        

        Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';         
        cableUnitTest.Cable_Unit_No__c = '0000000655';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;        
                        
        Account account = new Account();
        account.Name = 'TestHierarchy1';         
        account.Type='Hierarki';         
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();         
        account.Street_YK__c = addr.Id;         
        account.Street_YK__r = addr; 
        account.ParentId = acc.Id; 
        account.Cable_Unit__c = cableUnitTest.Id;  
        account.Anlaeg_Name__c = 'EJENDOM 41';        
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User user = new User();        
        String paswd = 'temp';       
        user = new User(alias = 'standt', email='MTest@atest.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654',IsActive = true);                    
        user.setOptions(dmo);        
        insert user;         
        Integer pageSize = 5;
        Integer resultSize1 = 10;
        Id contactTempId;
        Test.startTest();
        
        System.runAs(user)
        {
            Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
            system.debug('role 3 PPPP ' + role3);
            
            Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = account.Id;
            acr.Contact__c = contact.Id;
            acr.Role__c = role3.Id;                        
            insert acr;
            contactWrapper tempWrapper = new contactWrapper();
            List<contactWrapper> portalTempList = new List<contactWrapper>();
            List<contactWrapper> listExpACRRole = new List<contactWrapper>();
            ACRRoles newTempRole = new ACRRoles();
                       
            PageReference pageRef = Page.ManagePortalUsersPage; 
            Test.setCurrentPage(pageRef);  
            ManagePortalUserController TempUsrObj = new ManagePortalUserController();
            TempUsrObj.fetchUserList();
            TempUsrObj.setStatus();
            TempUsrObj.addContact();
            TempUsrObj.tempFlag = true; 
            TempUsrObj.deleteAllContact();
            TempUsrObj.getContactsLoggedInAccountIdList();
            TempUsrObj.fetchContactDetails();
            TempUsrObj.fetchContact();
            TempUsrObj.setCurrentCountText1();
            //TempUsrObj.getPortalUserList();
            TempUsrObj.first();
            TempUsrObj.last();
            TempUsrObj.next();
            TempUsrObj.previous();
            TempUsrObj.cancel();
            TempUsrObj.setPageSize1(pageSize);
            TempUsrObj.getPageSize1();
            TempUsrObj.getResultSize();
            //TempUsrObj.getRecordsforExport();
            //TempUsrObj.getListExport();
            TempUsrObj.initializePagingForUser();
            //TempUsrObj.getAllRecords();
            //TempUsrObj.handlePaging();
            //TempUsrObj.fetchContactDetails1();
            //TempUsrObj.getProfileName(contactTempId);
            
            Boolean b1 = TempUsrObj.hasPrevious;
            Boolean b2 = TempUsrObj.hasNext;
            TempUsrObj.hasNext = true;
            TempUsrObj.hasPrevious = true;
        }
        Test.stopTest();
   
   }
   
   
    static testMethod void myUnitTest2(){
        
        Address__c addr  = new Address__c();        
        addr.Town__c = 'AZ';        
        addr.Postcode__c = '741002';        
        addr.Door_No__c = '741';        
        //addr.Side__c = 'C';        
        addr.Floor__c = 'Fourth';        
        addr.House_No__c = 'testData1';        
        addr.Street__c = 'AZ';        
        addr.Entrance__c = 'B';        
        insert addr;
        
        Account acc = new Account();         
        acc.Name = 'TestHierarchy7';         
        acc.Type='Hierarki';         
        acc.Street_YK__c = addr.Id;         
        acc.Street_YK__r = addr; 
		acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();      
        insert acc;
        
        Contact contact = new Contact();              
        contact.FirstName='M1Test';       
        contact.LastName='M1Test';       
        contact.email='MTest1@MTest.com';       
        contact.MobilePhone='12634556';       
        contact.HomePhone='23458689';        
        contact.Phone='23544563';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact;
        
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User user = new User();        
        String paswd = 'temp';       
        user = new User(alias = 'samurl', email='PTest@atest.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test1.test', username='test11ClassUser@test.com',MID__c = 'M87054',IsActive = true);                    
        user.setOptions(dmo);        
        insert user;         
        Integer pageSize = 5;
        Integer resultSize1 = 10;
        Id contactTempId;
        Test.startTest();
        
        System.runAs(user)
        {
            Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
            system.debug('role 3 PPPP ' + role3); 
            
            Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = acc.Id;
            acr.Contact__c = contact.Id;
            acr.Role__c = role3.Id;                        
            insert acr;
            
            ManagePortalUserController testController = new ManagePortalUserController();
            testController.getPortalUserList();
            testController.editContact();
            testController.getProfileName(contact.id);
            testController.deleteContact();

            testController.exportExcel();
            testController.getListExport();
            testController.getRecordsforExport();
            testController.getAllRecords();
        }
    }  
    
}