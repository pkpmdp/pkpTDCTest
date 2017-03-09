/** 
* This class contains unit tests for validating the behavior of Apex classes 
* and triggers. 
** Unit tests are class methods that verify whether a particular piece 
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
private class ManageContactsControllerSCTestClass {     
  

   static testMethod void initData(){
     
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        
        
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
        
         Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Type='Hierarki';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
         System.debug(' Address----- '+acc.Street_YK__r);
         insert acc;
        
        
        system.debug('$Account List$'+acc);
        
        
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
       Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       contact.Status__c = 'Aktiv';
       insert contact;
       
       Test.startTest();
        Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3');
        insert role3; 
        KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde',Contact_Roles__c = role3.Id);
        insert rule3;
        
                                                 
      

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = contact.Id,                                       
                                        Role__c = role3.Id); 
         
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
        Test.stopTest();
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];
         Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;  
        System.runAs(u){   
        Id accountId = acc.id;
        Id contactId;
        contactConstClass tempCls = new contactConstClass();
        Apexpages.currentpage().getparameters().put('contactId',contact.id);
        Apexpages.currentpage().getparameters().put('cableunitnumber','123456789');
        ManageContactsController conObj = new ManageContactsController();
        conObj.tempFlag = true;
        conObj.getRoleFirstName();
        conObj.getRoleStr();
        conObj.getCableUnitNumber();
        conObj.setCableUnitNumber(conObj.cableUnitNumber);
        conObj.setCableUnitName();
        conObj.getContactsList();
        conObj.setRoleFirstName('test');
        conObj.setRoleStr('test1');
        //conObj.exportExcel();
        //conObj.showPopup();
        //conObj.closePopup(); 
        //conObj.addContact();
    	//conObj.getListExport();  
    	//conObj.exportExcel();
    	//conObj.deleteAllContact();
    	//conObj.deleteContact();
    	//conObj.userSelectedPage = null;
    }
    
    }
    
    
    static testMethod void testDataForAccount(){
     
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        
        
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
        
         Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Type='Hierarki';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
         System.debug(' Address----- '+acc.Street_YK__r);
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
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
       Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'pqrs@yahoo1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       contact.Status__c = 'Aktiv';
       insert contact;
       
         
        Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3');
        insert role3; 
        KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role3.Id);
        insert rule3;
                                                
      
    Contact tempContact = new Contact();
    tempContact.FirstName = 'Temp';
    tempContact.LastName = 'Test';
    tempContact.Email = 'test_user@test.com';
    tempContact.Phone = '11145';
    tempContact.MobilePhone = '12457';
    tempContact.HomePhone = '789456';
    tempContact.HierarchyAccount__c = acc.Id;
    tempContact.Street_P__c = addr.Id;
    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
    tempContact.Status__c = 'Aktiv';
    insert tempContact;
  
    Test.startTest();
        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, Contact__c = tempContact.Id,Role__c = role3.Id); 
         
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
    Test.stopTest();    
        List<Account_Contact_Role__c> lstAcr = new List<Account_Contact_Role__c>();
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        
        String paswd = 'temp';
        u = new User(alias = 'standt', email='testClassUser4589@yahoo.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;  
        System.runAs(u){   
        Id accountId = acc.id;
        Id contactId;
        contactConstClass tempCls = new contactConstClass();
        Apexpages.currentpage().getparameters().put('contactId',contact.id);
        ManageContactsController conObj = new ManageContactsController();
        cAccount_Contact_Role tempcAcr;
        tempcAcr = new cAccount_Contact_Role(acr);
        conObj.tempFlag = true; 
        conObj.fetchContact();
        //conObj.getContactsList();
        //conObj.getListExport();
        //conObj.exportExcel();
        //conObj.deleteAllContact();
        //conObj.deleteContact();
        
    }
    
    }
    
    static testMethod void MyUnittestData(){  //Aditya
      
      	
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
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
      
      	Account acc = new Account(Name = 'TestHierarchy', Type='Hierarki', Street_YK__c = addr.Id, Street_YK__r = addr,
        Cable_Unit__c = cableUnitTest.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        
        insert acc;
        
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
        
        
        Contact tempContact = new Contact();
	    tempContact.FirstName = 'Temp';
	    tempContact.LastName = 'Test';
	    tempContact.Email = 'test_user@test.com';
	    tempContact.Phone = '11145';
	    tempContact.MobilePhone = '12457';
	    tempContact.HomePhone = '789456';
	    //tempContact.HierarchyAccount__c = acc.Id;
	    tempContact.AccountId = kundeChildAccount.Id;
	    tempContact.Street_P__c = addr.Id;
	    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
	    tempContact.Status__c = 'Aktiv';
	    insert tempContact;
    
    	Test.startTest();
      	Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3', Visible_in_Service_Centre__c = true);
        insert role3; 
        
        Lookup_Contact_Roles__c role4 = new Lookup_Contact_Roles__c(Name = 'Indbliksadresse', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle4-id',
                                            Visible_in_Service_Centre__c = true);
        insert role4;
        KISS_Role_Validation_Rules__c rule3 = new KISS_Role_Validation_Rules__c( Name = 'Rolle3',Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde' ,Contact_Roles__c = role3.Id);
        insert rule3;
        
        KISS_Role_Validation_Rules__c rule4 = new KISS_Role_Validation_Rules__c( Name = 'Rolle4',Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde' ,Contact_Roles__c = role4.Id);
        insert rule4;
        
      
        
        Account_Contact_Role__c acr = new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, Contact__c = tempContact.Id,Role__c = role3.Id); 
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';
        insert acr;
        Test.stopTest();
        
        apexpages.currentpage().getparameters().put('loggedInaccountId',kundeChildAccount.Id);
        ManageContactsController manageContactsObj = new ManageContactsController();
        apexpages.currentpage().getparameters().put('contactId',tempContact.Id);
        
        try{
        manageContactsObj.fetchContact();
        manageContactsObj.deleteFlag = 'true';
        manageContactsObj.deleteContact();
        ApexPages.CurrentPage().getParameters().put('cableunitnumber',' ');
        manageContactsObj.tempFlag = true;
        manageContactsObj.cancel();
        apexpages.currentpage().getparameters().put('contactId','');
        manageContactsObj.deleteContact();
        manageContactsObj.editContact();
        //Added for spoc-1939
        manageContactsObj.addContact(); 
        manageContactsObj.exportExcel();
        manageContactsObj.closePopup();
        manageContactsObj.showPopup();
          manageContactsObj.tempFlag=true;
                manageContactsObj.contactSize=false;
                manageContactsObj.displayFlag=false;
                manageContactsObj.warningFlag=true;
                manageContactsObj.successFlag=false;
                  
        }catch(LimitException e){
          
        }
        
        PageReference pageRef = Page.ViewAddressesForInstallationsPage;
        Test.setCurrentPageReference(pageRef);
        PagingController paging = new PagingController();
        paging.pageController = manageContactsObj.getThis();
        
        manageContactsObj.finalListAcr = manageContactsObj.getContactsList();
        manageContactsObj.finalExpList = manageContactsObj.getListExport();
        
    }
    
   
    static testMethod void testForContactsList(){
      ManageContactsController conObj = new ManageContactsController();
      
      	
      
      	Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
      
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
      
        
       
      	Account acc = new Account(Name = 'TestHierarchy', Type='Hierarki',
      	Street_YK__c = addr.Id,
        Street_YK__r = addr,
        Cable_Unit__c = cableUnitTest.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        
        insert acc;
      
      RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
      
      Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
      
      	Contact tempContact = new Contact();
	    tempContact.FirstName = 'Temp';
	    tempContact.LastName = 'Test';
	    tempContact.Email = 'test_user@test.com';
	    tempContact.Phone = '11145';
	    tempContact.MobilePhone = '12457';
	    tempContact.HomePhone = '789456';
	    tempContact.HierarchyAccount__c = acc.Id;
	    tempContact.Street_P__c = addr.Id;
	    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
	    tempContact.Status__c = 'Aktiv';
	    insert tempContact;
     Test.startTest(); 
      Lookup_Contact_Roles__c role4 = new Lookup_Contact_Roles__c(Name = 'Indbliksadresse', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle4-id',
                                            Visible_in_Service_Centre__c = true);
        insert role4;
          KISS_Role_Validation_Rules__c rule4;
        rule4 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle4',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde',Contact_Roles__c = role4.Id);
        insert rule4;
        
      
      Account_Contact_Role__c acr = 
        new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = tempContact.Id,                                       
                                        Role__c = role4.Id); 
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
    Test.stopTest();    
      conObj.getContactsList();
      conObj.getLoggedInUserDetails();
    } 
    
    
    static testMethod void testForContactsList9(){
      ManageContactsController conObj = new ManageContactsController();
      
      
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
      
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
      
        
        
        Account acc = new Account(Name = 'TestHierarchy', Type='Hierarki',
      Street_YK__c = addr.Id,
        Street_YK__r = addr,
        Cable_Unit__c = cableUnitTest.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        
        insert acc;
      
      RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
      
      Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
      
      Contact tempContact = new Contact();
    tempContact.FirstName = 'Temp';
    tempContact.LastName = 'Test';
    tempContact.Email = 'test_88user@test.com';
    tempContact.Phone = '11145';
    tempContact.MobilePhone = '12457';
    tempContact.HomePhone = '789456';
    tempContact.HierarchyAccount__c = acc.Id;
    tempContact.Street_P__c = addr.Id;
    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
    tempContact.Status__c = 'Aktiv';
    insert tempContact;
     Test.startTest(); 
      Lookup_Contact_Roles__c role4 = new Lookup_Contact_Roles__c(Name = 'Indbliksadresse', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle4-id',
                                            Visible_in_Service_Centre__c = true);
        insert role4;
          KISS_Role_Validation_Rules__c rule4;
        rule4 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle4',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde',Contact_Roles__c = role4.Id);
        insert rule4;
        
      
      Account_Contact_Role__c acr = 
        new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = tempContact.Id,                                       
                                        Role__c = role4.Id); 
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
    Test.stopTest();    
      conObj.editContact();
      //conObj.getLoggedInUserDetails();
      
    }
    
    static testMethod void testForContactsListDel1(){
      ManageContactsController conObj = new ManageContactsController();
      
      
      
      	Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        insert cableUnitTest;
      
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
      
         
        Account acc = new Account(Name = 'TestHierarchy', Type='Hierarki',
        Street_YK__c = addr.Id,
        Street_YK__r = addr,
        Cable_Unit__c = cableUnitTest.Id, Customer_Segment_Lookup__c= clsTestDataForYS.createLookupCustomerSegment());
        
        insert acc;
      
      RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
      
      Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
      
      Contact tempContact = new Contact();
    tempContact.FirstName = 'Temp';
    tempContact.LastName = 'Test';
    tempContact.Email = 'test_88user@test.com';
    tempContact.Phone = '11145';
    tempContact.MobilePhone = '12457';
    tempContact.HomePhone = '789456';
    tempContact.HierarchyAccount__c = acc.Id;
    tempContact.Street_P__c = addr.Id;
    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
    tempContact.Status__c = 'Aktiv';
    insert tempContact;
     Test.startTest(); 
      Lookup_Contact_Roles__c role4 = new Lookup_Contact_Roles__c(Name = 'Indbliksadresse', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle4-id',
                                            Visible_in_Service_Centre__c = true);
        insert role4;
          KISS_Role_Validation_Rules__c rule4;
        rule4 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle4',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde',Contact_Roles__c = role4.Id);
        insert rule4;
        
      
      Account_Contact_Role__c acr = 
        new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = tempContact.Id,                                       
                                        Role__c = role4.Id); 
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
    Test.stopTest();
      conObj.deleteFlag = 'true';
      conObj.deleteAllContact();
      //conObj.getLoggedInUserDetails();
      
    }
    
  //Added for spoc-1939
  static testMethod void testForaddContact(){
      ManageContactsController conObj = new ManageContactsController();
       	Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        cableUnitTest.Cable_Unit_No__c = '987654321';
        insert cableUnitTest;
      
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
      
        Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
         //acc.Customer_Segment_Lookup__c=customerSegment.Id;
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
        acc.Customer_No__c = '987654321';
        acc.Cable_Unit__c = cableUnitTest.Id;
         //acc.Type = 'Hierarki';
         System.debug(' Address----- '+acc.Street_YK__r);
         insert acc;
        
      
      RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
      
     /* Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestHierarchy', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;*/
    
      
      Contact tempContact = new Contact();
    tempContact.FirstName = 'Temp';
    tempContact.LastName = 'Test';
    tempContact.Email = 'test_88user@test.com';
    tempContact.Phone = '11145';
    tempContact.MobilePhone = '12457';
    tempContact.HomePhone = '789456';
    tempContact.HierarchyAccount__c = acc.Id;
    tempContact.Street_P__c = addr.Id;
    tempContact.KissPartyId__c = 'KAS.P2---4015110478';
    tempContact.Status__c = 'Aktiv';
    insert tempContact;
     Test.startTest(); 
      Lookup_Contact_Roles__c role4 = new Lookup_Contact_Roles__c(Name = 'Indbliksadresse', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle4-id',
                                            Visible_in_Service_Centre__c = true);
        insert role4;
          KISS_Role_Validation_Rules__c rule4;
        rule4 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle4',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde',Contact_Roles__c = role4.Id);
        insert rule4;
        
      
      Account_Contact_Role__c acr = 
        new Account_Contact_Role__c(Customer__c = acc.Id, 
                                        Contact__c = tempContact.Id,                                       
                                        Role__c = role4.Id); 
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
    Test.stopTest();
      conObj.addContact();
      //conObj.getLoggedInUserDetails();
      
    }
    static testmethod void negativeTest(){
         Cable_Unit__c cableUnit = new Cable_Unit__c();  
     cableUnit.Name = 'cu_kundeCust_testing';
     cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
     cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
     cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
     cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
     cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
     cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
     cableUnit.Cable_Unit_No__c = '123456789';
     insert cableUnit;  
        
        
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
     //   RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
     
         Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
         //acc.Customer_Segment_Lookup__c=customerSegment.Id;
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
        acc.Customer_No__c = '123456789';
        acc.Cable_Unit__c = cableUnit.Id;
         //acc.Type = 'Hierarki';
         System.debug(' Address----- '+acc.Street_YK__r);
         insert acc;
         
         Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       insert contact;
           
       Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like 'ServiceCenter Portal Administrator'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u; 
       

       Contact conContactRoles = new Contact(); 
       conContactRoles.FirstName = 'TestContactFirstname';
       conContactRoles.LastName = 'TestContactLastname';
       conContactRoles.Email = 'testcontactroles.TestClas@test1.com';
       conContactRoles.Phone = '2222221';
       conContactRoles.MobilePhone = '3333331';
       conContactRoles.HomePhone = '4444441';
       conContactRoles.HierarchyAccount__c = acc.id;
       conContactRoles.Street_P__c = addr.Id;
       conContactRoles.KissPartyId__c = 'KAS.P2---4015770456';
       conContactRoles.Status__c = 'Active';
       insert conContactRoles;
       
       Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3',Visible_in_Service_Centre__c = true);
        insert role3;
       List<Id> assignedRoles = new List<Id>();
                KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Hierarki', Contact_Roles__c = role3.Id);
        insert rule3;
        
        

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = acc.Id, 
                                        Contact__c = conContactRoles.Id,                                       
                                        Role__c = role3.Id); 
       
            System.runAs(u){
                ApexPages.CurrentPage().getParameters().put('accountId',acc.Id);
                ApexPages.CurrentPage().getParameters().put(contactConstClass.CONTACTID,conContactRoles.Id);
                ApexPages.CurrentPage().getParameters().put('cableunitnumber','123456789');
                ApexPages.CurrentPage().getParameters().put('emailUnique','test@test.com');
                ApexPages.CurrentPage().getParameters().put('contactFreeFlyingLogCheck','test');
                ManageContactsController conObj = new ManageContactsController();
                List<Id> roleIds = new List<Id>();
                conObj.tempFlag=true;
                conObj.contactSize=false;
                conObj.displayFlag=false;
                conObj.warningFlag=true;
                conObj.successFlag=false;
               
               
            }   
    }
    
}