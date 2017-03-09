@isTest(SeeAllData = true)
private class ConsoleAlertsComponent_Test {
    
    
    static testMethod void testAll() {
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.getImageDisplay();
        ctrl.currentId2 = acc.id;
        ctrl.getCountOfCases();
        ctrl.getContactInfoWarning();
        
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = null;
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '911';
        acc.Permission__c = null;
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = '911';
        acc.Permission__c = null;
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = null;
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '911';
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = '911';
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new ConsoleAlertsComponent_CT();
        
    }
    
    
    //method for SPOC-2388
    //start
    static testmethod void testSpecial_Bland_Selv_rules1(){
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = '12457896';
        acc.X34_Mobile_Number__c = '12457896';
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'YK_Customer_Account'].Id;
        system.debug('acc.RecordTypeId'+acc.RecordTypeId);
        system.debug('acc.IsPersonAccount'+acc.IsPersonAccount);
        insert acc;
        Links__c link = new Links__c(Category__c='Regler for Bland Selv Tv', URL__c='www.google.com',Text__c='Service Center',Comment__c='Test af foreningslink til regler for Bland Selv Tv');
        link.Person_Account__c=acc.id;
        ctrl.currentId2= acc.Id;
        insert link;
        system.assert(link.Category__c!=null );
        ctrl.getSpecial_Bland_Selv_rules();
    }
    
    static testmethod void testSpecial_Bland_Selv_rules2(){
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = '12457896';
        acc.X34_Mobile_Number__c = '12457896';
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'YK_Customer_Account'].Id;
        system.debug('acc.RecordTypeId'+acc.RecordTypeId);
        system.debug('acc.IsPersonAccount'+acc.IsPersonAccount);
        insert acc;
        Links__c link = new Links__c(Category__c='Regler for Bland Selv Tv', URL__c='www.google.com',Text__c='Service Center',Comment__c='Test af foreningslink til regler for Bland Selv Tv');
        link.Person_Account__c=acc.id;
        insert link;
        system.assert(link.Category__c!=null );
        ctrl.getSpecial_Bland_Selv_rules();
    }
    //end SPOC-2388
    
    static testMethod void testAllPermission() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '987456';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermissionPositive() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = '12457896';
        acc.X34_Mobile_Number__c = null;
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermissionNegative() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = '12457896';
        acc.X34_Mobile_Number__c = '12457896';
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermissionNegative5() {
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
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        acc1.BillingRating__c='7';
        insert acc1;
        
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc1.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        contact.Status__c = 'Aktiv';
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u1 = new User();
        String paswd = 'temp';
        u1 = new User(alias = 'standt', email='testClassUser9@test.com',title='kunderådgiver', emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US', localesidkey='en_US', profileid = profiles[0].Id, timezonesidkey='America/Los_Angeles', username='testClassUser9@test.com',MID__c = 'M87600');        
        u1.setOptions(dmo);
        insert u1;  
        System.runAs(u1){ 
            Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
            acc.PersonEmail = null;
            acc.PersonMobilePhone = null;
            acc.Home_Phone__c = '12457896';
            acc.X34_Mobile_Number__c = '12457896';
            acc.X34_Fixed_line__c = '12457896';
            acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
            insert acc;
            
            ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
            ctrl.currentId2 = acc.id;
            ctrl.marketingPermission = true;
            ctrl.getContactInfoWarning();
        }
        
    }
    
    static testMethod void testmarketingPermission1() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = '12457896';
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermission12() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = '12345678';
        acc.X34_Mobile_Number__c = '87654321';
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testmethod void testbillinginformation(){
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.BillingRating__c='7';
        insert acc;
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.getBillingRatingWarning();
    }
   
    static testmethod void testgetActivityList()
    {
        Task tc= new Task();
        tc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Opgave'].Id;
        tc.Subject='test';
        tc.ActivityDate=null;
        tc.Kontakt_tlf_nr__c='858577257';
        tc.Status='high';
        tc.Priority='Normal';
        tc.CallType='Inbound';
        insert tc;
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = tc.id;
        ctrl.getActivityList();
    }
    static testmethod void testcommenttextblank(){
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.Comment__c='test';
        insert acc;
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.getIscommenttextblank();
    }
    
    
    
    static testMethod void testmarketingPermission2() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = '12457896';
        acc.X34_Fixed_line__c = '12457896';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermission3() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = null;
        acc.X34_Fixed_line__c = '12457896';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermission4() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '12457896';
        acc.Home_Phone__c = '12474125';
        acc.X34_Mobile_Number__c = null;
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();
    }
    
    static testMethod void testmarketingPermission5() {
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
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        insert acc1;
        
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc1.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        contact.Status__c = 'Aktiv';
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u1 = new User();
        String paswd = 'temp';
        u1 = new User(alias = 'standt', email='testClassUser7@test.com',title='kunderådgiver', emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US', localesidkey='en_US', profileid = profiles[0].Id, timezonesidkey='America/Los_Angeles', username='testClassUser7@test.com',MID__c = 'M87609');        
        u1.setOptions(dmo);
        insert u1;  
        System.runAs(u1){ 
            List<Account> acList = new List<Account>();
            Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
            acc.PersonEmail = null;
            acc.PersonMobilePhone = '12457896';
            acc.Home_Phone__c = '12474125';
            acc.X34_Mobile_Number__c = '12474125';
            acc.X34_Fixed_line__c = null;
            acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
            acList.add(acc);
            Database.saveResult[] dsr = Database.insert(acList, true);
            
            ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
            ctrl.currentId2 = acList[0].Id;
            ctrl.marketingPermission = true;
            ctrl.getContactInfoWarning();
        }
    }
    
    static testMethod void testmarketingPermission6() {
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
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        acc1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'YS_Hierarchy_Account'].Id;
        insert acc1;
        
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc1.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        contact.Status__c = 'Aktiv';
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u1 = new User();
        String paswd = 'temp1';
        u1 = new User(alias = 'standt1', email='testClassUser3@test.com',title='kunderådgiver', emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US', localesidkey='en_US', profileid = profiles[0].Id, timezonesidkey='America/Los_Angeles', username='testClassUser55@test.com',MID__c = 'M87608');        
        u1.setOptions(dmo);
        insert u1; 
        
        System.runAs(u1){
            List<Account> acList = new List<Account>();
            Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
            acc.PersonEmail = null;
            acc.PersonMobilePhone = '12457896';
            acc.Home_Phone__c = '12474125';
            acc.X34_Mobile_Number__c = '12474125';
            acc.X34_Fixed_line__c = '12474124';
            acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
            acList.add(acc);
            Database.saveResult[] dsr = Database.insert(acList, false);
            ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
            ctrl.currentId2 = acList[0].Id;
            ctrl.marketingPermission = true;
            ctrl.getContactInfoWarning();
        }
        
    }
    
    static testMethod void testmarketingPermissionPositive22() {
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
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        insert acc1;
        
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc1.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        contact.Status__c = 'Aktiv';
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u1 = new User();
        String paswd = 'temp1';
        u1 = new User(alias = 'standt1', email='testClassUser6@test.com',title='kunderådgiver', emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US', localesidkey='en_US', profileid = profiles[0].Id, timezonesidkey='America/Los_Angeles', username='testClassUser6@test.com',MID__c = 'M87607');        
        u1.setOptions(dmo);
        insert u1; 
        
        System.runAs(u1){
            
            Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
            acc.PersonEmail = 'abcd@test.com';
            acc.PersonMobilePhone = null;
            acc.Home_Phone__c = '12457896';
            acc.X34_Mobile_Number__c = '12474125';
            acc.X34_Fixed_line__c = '12474125';
            acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
            insert acc;
            
            ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
            ctrl.currentId2 = acc.id;
            ctrl.marketingPermission = true;
            ctrl.getContactInfoWarning();
        }
    }
    
    static testMethod void testmarketingPermissionPositive10() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = 'abcd@test.com';
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = '12474125';
        acc.X34_Fixed_line__c = '12474125';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();	
    }
    
    static testMethod void testmarketingPermissionPositive88() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = 'abcd@test.com';
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = null;
        acc.X34_Fixed_line__c = '12474125';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();	
    }
    
    static testMethod void testmarketingPermissionPositive34() {
        Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
        acc.PersonEmail = 'abcd@test.com';
        acc.PersonMobilePhone = null;
        acc.Home_Phone__c = null;
        acc.X34_Mobile_Number__c = null;
        acc.X34_Fixed_line__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        
        ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
        ctrl.currentId2 = acc.id;
        ctrl.marketingPermission = true;
        ctrl.getContactInfoWarning();	
    }
    
    static testMethod void testmarketingPermissionPositive35() {
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
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        insert acc1;
        
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.HierarchyAccount__c = acc1.id;
        contact.Street_P__c = addr.Id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        contact.Status__c = 'Aktiv';
        insert contact;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%'];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u1 = new User();
        String paswd = 'temp1';
        u1 = new User(alias = 'standt1', email='testClassUser22@test.com',title='kunderådgiver', emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US', localesidkey='en_US', profileid = profiles[0].Id, timezonesidkey='America/Los_Angeles', username='testClassUser22@test.com',MID__c = 'M87605');        
        u1.setOptions(dmo);
        insert u1; 
        
        System.runAs(u1){
            Account acc = new Account(FirstName='Johnfirst', LastName='Doe');
            acc.PersonEmail = 'abcd@test.com';
            acc.PersonMobilePhone = '12504512';
            acc.Home_Phone__c = '10203041';
            acc.X34_Mobile_Number__c = '10203041';
            acc.X34_Fixed_line__c = '10203041';
            acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
            insert acc;
            
            ConsoleAlertsComponent_CT ctrl = new ConsoleAlertsComponent_CT();
            ctrl.currentId2 = acc.id;
            ctrl.marketingPermission = true;
            ctrl.getContactInfoWarning();
            
        }	
    }
}