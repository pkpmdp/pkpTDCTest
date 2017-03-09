@isTest(SeeAllData=true)
private class ContactCreateControllerSCTestClass{
    public static Contact newContact;
    public static User newUser;
    public static User u;
    static testMethod void unitTest(){
        Test.startTest();
        
        /*Lookup_Customer_Segment__c cuSegment = new Lookup_Customer_Segment__c();
        cuSegment.Name = 'ParceInt_Test1';
        cuSegment.Code__c = 'PnetTest1';
        cuSegment.SourceId__c = 'PCRM-seg---98777581'; 
        insert cuSegment;
        
        Account tempAcc = new Account();
        tempAcc.Name = 'Test Hierarchy333';
        tempAcc.Type = 'Hierarchy333';
        tempAcc.Customer_Segment_Lookup__c = cuSegment.Id;
        insert tempAcc;
        List<Contact> contactEmail = new List<Contact>();
        
        Contact tempContact = new Contact(email ='amr2@test.com',FirstName='amra',LastName='testa',Phone='3213214211', Temporary_contact__c=true, HierarchyAccount__c = tempAcc.Id, CanAllowPortalSelfReg = true);
        insert tempContact;
        
        if(tempContact.Email != null){
            contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: tempContact.Email AND IsPersonAccount = false];
        }
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        u = new User(alias = 'standt1', email='testClassUser1@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla1', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId = tempContact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser1@test.com',MID__c = 'M87654');        
        insert u;
        System.runAs(u) {*/
        
        /*Contact saveContact = new Contact(Email = 'test@test.com',FirstName = 'abc', LastName = 'pqr', Phone = '123456', Temporary_contact__c = true, HierarchyAccount__c = tempAcc.Id,CanAllowPortalSelfReg = true);
        insert saveContact;
        
        User saveUser = new User();
        String profileName = 'ServiceCenter Portal Administrator';
        ID profileId = [Select Id From Profile Where Name =: profileName].Id;
        saveUser.ContactId = saveContact.Id;
        saveUser.Email = saveContact.Email;
        saveUser.ProfileId = profileId;
        saveUser.userName = saveContact.LastName;
        saveUser.Alias = saveContact.FirstName;
        saveUser.CommunityNickName = saveContact.FirstName;
        saveUser.TimeZoneSidKey = 'America/New_York';
        saveUser.LocaleSidKey = 'en_US';
        saveUser.EmailEncodingKey = 'ISO-8859-1';         
        saveUser.LanguageLocaleKey = 'en_US';
        saveUser.FirstName = saveContact.FirstName;
        saveUser.LastName = saveContact.LastName; 
        insert saveUser;*/
        
        PageReference newPage = new PageReference('/apex/Contact_Create_Thankyou');
        Test.setCurrentPage(newPage);
        ContactCreateController testCont = new ContactCreateController();
        String testParam = 'abc';
        testCont.setMyparam(testParam);
        testCont.getMyparam();
        Test.stopTest();
    
    //}

    }

}