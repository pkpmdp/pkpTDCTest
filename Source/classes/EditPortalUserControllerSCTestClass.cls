/** 
* This class contains unit tests for validating the behavior of Apex classes 
* and triggers. 
* * Unit tests are class methods that verify whether a particular piece 
* of code is working properly. Unit test methods take no arguments, 
* commit no data to the database, and are flagged with the testMethod 
* keyword in the method definition. 
* * All test methods in an organization are executed whenever Apex code is deployed 
* to a production organization to confirm correctness, ensure code 
* coverage, and prevent regressions. All Apex classes are 
* required to have at least 75% code coverage in order to be deployed 
* to a production organization. In addition, all triggers must have some code coverage. 
*  * The @isTest class annotation indicates this class only contains test 
* methods. Classes defined with the @isTest annotation do not count against 
* the organization size limit for all Apex scripts. 
* * See the Apex Language Reference for more information about Testing and Code Coverage. 
*/
@isTest
private class EditPortalUserControllerSCTestClass {    
    
    static testMethod void testEditPortalUserController()
    {
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
        contact.email='MTest@Mtest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

		Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';         
        cableUnitTest.Cable_Unit_No__c = '0000000455';
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
        
        User u = new User();        
        String paswd = 'temp';       
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654');                    
        u.setOptions(dmo);        
        insert u;         
        
        //Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
        
            
            /*Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = account.Id;
            acr.Contact__c = contact.Id;
            acr.Role__c = role3.Id;                 
            //acr.ContactRoleExternalID__c = acr + 'Fake-Id';          
            insert acr;*/
        Test.startTest();
        System.runAs(u){
           /*
            PageReference pageRef = Page.EditPortalUserPage; 
            Test.setCurrentPage(pageRef);  
            
            ApexPages.CurrentPage().getParameters().put('contactId', contact.Id);      
            ApexPages.CurrentPage().getParameters().put('enteredEmailUnique', 'false');      
            ApexPages.CurrentPage().getParameters().put('isActiveExistHierarchy','false');          
            ApexPages.CurrentPage().getParameters().put('freeFlyingContactHierarchy', 'true');      
            ApexPages.CurrentPage().getParameters().put('userExistsFreeFlying','true');          
            ApexPages.CurrentPage().getParameters().put('fromCreateScreen','true');    */      
                
            //EditPortalUserController editPortalUserObj = new EditPortalUserController();        
            //editPortalUserObj.getObjectStructure();
            //editPortalUserObj.accountId = account.Id; 
            //editPortalUserObj.getAccounts();
            //editPortalUserObj.save();
       //     editPortalUserObj.cancel();
        }
        Test.stopTest();
    }                    
    
    static testMethod void testEditPortalUserAdmin()
    {
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
        contact.email='MTest@Mtest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

        Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';    
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
        //account.Cable_Unit_No__c = '0995039362';
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Admin%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User u = new User();        
        String paswd = 'temp';       
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654');                    
        u.setOptions(dmo);        
        insert u;         
        
        Test.startTest();
        System.runAs(u)
        {
            PageReference pageRef = Page.EditPortalUserPage; 
            Test.setCurrentPage(pageRef);  
            
            ApexPages.CurrentPage().getParameters().put('contactId', contact.Id);      
            ApexPages.CurrentPage().getParameters().put('enteredEmailUnique', 'false');      
            ApexPages.CurrentPage().getParameters().put('isActiveExistHierarchy','false');          
            ApexPages.CurrentPage().getParameters().put('freeFlyingContactHierarchy', 'false');      
            ApexPages.CurrentPage().getParameters().put('userExistsFreeFlying','false');          
            ApexPages.CurrentPage().getParameters().put('fromCreateScreen','true');          
            
            EditPortalUserController editPortalUserObj = new EditPortalUserController();        
            editPortalUserObj.getObjectStructure();
            editPortalUserObj.setAccountId(account.Id);
            editPortalUserObj.getAccounts();           
            //editPortalUserObj.save();
        }
        Test.stopTest();
    }                 
    
    static testMethod void testEditPortalUserExceptions()
    {
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
        contact.email='MTest@Mtest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact;      
                        
        Account account = new Account();
        account.Name = 'TestHierarchy1';         
        account.Type='Hierarki';         
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();       
        account.Street_YK__c = addr.Id;         
        account.Street_YK__r = addr; 
        account.ParentId = acc.Id; 
        account.Anlaeg_Name__c = 'EJENDOM 41';        
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User u = new User();        
        String paswd = 'temp';       
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654');                    
        u.setOptions(dmo);        
        insert u;         
        
        Test.startTest();
        System.runAs(u)
        {
            PageReference pageRef = Page.EditPortalUserPage; 
            Test.setCurrentPage(pageRef);              
            ApexPages.CurrentPage().getParameters().put('contactId', contact.Id); 
            ApexPages.CurrentPage().getParameters().put('freeFlyingContactHierarchy', 'true');      
            ApexPages.CurrentPage().getParameters().put('userExistsFreeFlying','true');                             
            EditPortalUserController editPortalUserObj = new EditPortalUserController();   
            editPortalUserObj.getAccountId();
            editPortalUserObj.getEmailFlagValue();
            editPortalUserObj.setEmailFlagValue('test');
            editPortalUserObj.getContact();
            editPortalUserObj.getAccounts();
            editPortalUserObj.save();
        }
        Test.stopTest();
    } 
    
    
    
    static testMethod void checkCableUnit()
    {
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
        acc.Customer_Segment_Lookup__c= clsTestDataForYS.createLookupCustomerSegment();          
        acc.Street_YK__c = addr.Id;         
        acc.Street_YK__r = addr;         
        insert acc;
        
        //Insert a new contact
        Contact contact = new Contact();              
        contact.FirstName='MTest';       
        contact.LastName='MTest';       
        contact.email='MTest@Mtest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.HierarchyAccount__c = acc.id;    
        insert contact; 

        

        Cable_Unit__c cableUnitTest = new Cable_Unit__c();        
        cableUnitTest.Name = 'cu_kundeCust_testing';  
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
        //account.Cable_Unit_No__c = '0995039362';
        insert account;
                
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Admin%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User u = new User();        
        String paswd = 'temp';       
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654');                    
        u.setOptions(dmo);        
        insert u;         
        
        Test.startTest();
        System.runAs(u)
        {
            PageReference pageRef = Page.EditPortalUserPage; 
            Test.setCurrentPage(pageRef);  
            
            ApexPages.CurrentPage().getParameters().put('contactId', contact.Id);      
            ApexPages.CurrentPage().getParameters().put('enteredEmailUnique', 'false');      
            ApexPages.CurrentPage().getParameters().put('isActiveExistHierarchy','false');          
            ApexPages.CurrentPage().getParameters().put('freeFlyingContactHierarchy', 'false');      
            ApexPages.CurrentPage().getParameters().put('userExistsFreeFlying','false');          
            ApexPages.CurrentPage().getParameters().put('fromCreateScreen','true');          
            
            EditPortalUserController editPortalUserObj = new EditPortalUserController();        
            editPortalUserObj.getAllRelatedCableUnits();
            
            editPortalUserObj.cancel();           
            //editPortalUserObj.save();
        }
        Test.stopTest();
    }                 
       
}