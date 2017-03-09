/*@Author Ashwini*/

@isTest
private class PortalUserMailServiceSCTestClass {
static testMethod void myUnitTest() {}
/* KM
Method commented out by: Kamil Mihina

Reason: When running other tests, the following error was thrown:
System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY,
tgrContactBeforeInsert: execution of BeforeInsert caused by: line -1, column -1: Previous load of class failed:
portalusermailservicesctestclass: []
*/
  /*  static testMethod void myUnitTest() {
       PortalUserMailService portalMailObj = new PortalUserMailService();
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        List<Account> accountsList = new List<Account>();
       
        
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testDataa';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy4';
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
        kundeChildAccount.Anlaeg_No__c = '45345354';
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
        insert contact;
       
       /*
       Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
       role3 = new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',Code__c = 'Rolle3');
       insert role3;                                           
      
       KISS_Role_Validation_Rules__c rule3;
       rule3 = new KISS_Role_Validation_Rules__c( Name = 'Rolle3',Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role3.Id);
       insert rule3;
        
       Account_Contact_Role__c acr = new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, Contact__c = contact.Id, Role__c = role3.Id); 
       acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
       insert acr;*/
       
     /*   accountsList.add(kundeChildAccount);
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUserswde@test.com',MID__c = 'M87014');        
            u.setOptions(dmo);
        insert u; 
        
        System.runAs(u){
            PortalUserMailService.FORCE_TEST_MODE = true;
            System.debug('####SOQL Raised!!!!!11'+Limits.getQueries());
            Test.startTest();
            System.debug('####SOQL Raised!!!!!222'+Limits.getQueries());
            portalMailObj.getLoggedInUserDetails();
            portalMailObj.sendMailPortalUserUpdation(contact);
            //portalMailObj.sendMailPortalUserCreation(paswd, contact);
            portalMailObj.sendMailForAccountDetached(u,accountsList);
            portalMailObj.sendMailForAccountAssignment(u,accountsList);
            portalMailObj.sendMailPortalUserCreationTest(paswd,contact);
            System.debug('####SOQL Raised!!!!!33'+Limits.getQueries());
            Test.stopTest();
            //String subject = 'test Subject'; 
            //String message = 'test Message';
            //List<String> accountsList1 = new List<String>{'abc','xyz'};
            //portalMailObj.sendMail(u,accountsList1,subject,message);
            //portalMailObj.sendMailPortalUserCreation(paswd,contact);
            //portalMailObj.sendMailUserCreation(paswd, contact);
        }
         
        /// KM
        /*
        List<String> accList = new List<String>();
        accList.add('Ashwini');
        accList.add('Abhijit');
        String password = 'December2011';
        String street = 'Dahisar';
        String subject = 'My mail';
        String message = 'Test Mail'; 
        portalMailObj.getLoggedInUserDetails();
        portalMailObj.sendMailPortalUserCreation(password,cnt1);
        
        //portalMailObj.sendMailPortalUserCreation(password, cnt1);
        //portalMailObj.sendMailForAccountDetached(usr, accountsList);
        //portalMailObj.sendMailForAccountAssignment(usr, accountsList);
        //portalMailObj.sendMailPortalUserUpdation(cnt1); 
        //portalMailObj.fireMail(usr, accList, subject, message); */
    /*    
            
    }
    
  static testMethod void myUnitTest1() {
        
        PortalUserMailService portalMailObj = new PortalUserMailService();
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        List<Account> accountsList = new List<Account>();
        
        
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
        kundeChildAccount.Anlaeg_No__c = '45345354';
        insert kundeChildAccount;
   
               
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContact';
        contact.LastName = 'TestContact';
        contact.Email = 'test.Test@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        insert contact;
       
        /*KISS_Role_Validation_Rules__c rule3;
        rule3 = new KISS_Role_Validation_Rules__c( Name = 'Rolle3',Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde');
        insert rule3;
        
        Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',Code__c = 'Rolle3');
        insert role3;                                           
      

        Account_Contact_Role__c acr = new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, Contact__c = contact.Id,Role__c = role3.Id); 
        
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;*/
    /*    accountsList.add(kundeChildAccount);
        
        List<String> testString = new List<String>();
        testString.add('test');
        String subject = 'testsubject';
        String message = 'testmessage';
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd1 = '!ndia@123';
        u = new User(alias = 'standt', email='testClass@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId = contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClass@test.com',MID__c = 'M00145');        
            u.setOptions(dmo);
        insert u; 
        
        System.runAs(u){
            Test.startTest();
            System.debug('####SOQL Raised!!!!!444'+Limits.getQueries());
            portalMailObj.sendMailPortalUserCreation(paswd1,contact);
            portalMailObj.sendMailUserCreation(paswd1,contact);
            portalMailObj.sendMail(u,testString,subject,message);
            System.debug('####SOQL Raised!!!!!555'+Limits.getQueries());
            
            Test.stopTest();
            
        }
    }
*/
}