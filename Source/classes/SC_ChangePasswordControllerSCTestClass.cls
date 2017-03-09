@isTest
private class SC_ChangePasswordControllerSCTestClass {

    static testMethod void myUnitTest() {
        SC_ChangePasswordController changePasswordController = new SC_ChangePasswordController();
        
        user u;
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
        acc.Name = 'testData';
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@abc.com';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc; 
        
        Contact contact = new Contact();
        contact.FirstName = 'FTest';
        contact.LastName = 'LTest';
        contact.Email = 'FTest@Ltest.com';
        contact.MobilePhone = '9823242526';
        contact.HomePhone = '154552';
        contact.Phone = '1234567890';
        contact.Street_P__c = addr.id;        
        contact.Street_S__c = addr.id;
        contact.Status__c = 'Aktiv';
        contact.AlternateEmail__c = 'FL@test.com';
        contact.AccountId = acc.id;
        insert contact;
        
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
        insert u;
     
        
     
        Apexpages.currentpage().getparameters().put('contactId',contact.id);
        SC_ChangePasswordController.newpwd = 'akshada26387';
        SC_ChangePasswordController.newpwd = 'april2012';
        changePasswordController.changePwdSection = true;
        changePasswordController.getLoggedInUser();
        changePasswordController.cancel();
        changePasswordController.changePassword();
        
    }
    
    static testMethod void unitTest(){
        user u1;
        Address__c addr1  = new Address__c();
        addr1.Town__c = 'AT';
        addr1.Postcode__c = '481002';
        addr1.Door_No__c = '308';
        //addr1.Side__c = 'B';
        addr1.Floor__c = 'Second';
        addr1.House_No__c = 'testData1';
        addr1.Street__c = 'AV';
        addr1.Entrance__c = 'B';
        insert addr1;
        
        Account acc1 = new Account();
        acc1.Name = 'testData1';
        acc1.Street_YK__c = addr1.Id;
        acc1.Phone = '223223';
        acc1.Email__c = 'abc@test.com';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc1; 
        
        Contact contact1 = new Contact();
        contact1.FirstName = 'FTest';
        contact1.LastName = 'LTest';
        contact1.Email = 'FTest@Ltest.com';
        contact1.MobilePhone = '9823242526';
        contact1.HomePhone = '154552';
        contact1.Phone = '1234567890';
        contact1.Street_P__c = addr1.id;        
        contact1.Street_S__c = addr1.id;
        contact1.Status__c = 'Aktiv';
        contact1.AlternateEmail__c = 'FL@test.com';
        contact1.AccountId = acc1.id;
        insert contact1;
        
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        u1 = new User(alias = 'standt', email='testClassUser1@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId = contact1.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
        insert u1;
        Test.startTest();
        
        SC_ChangePasswordController tempCon = new SC_ChangePasswordController();
        Apexpages.currentpage().getparameters().put('contactId',contact1.id);
        SC_ChangePasswordController.newpwd = 'amsur@123';
        SC_ChangePasswordController.newpwd = 'amsur@123';
        tempCon.changePwdSection = true;
        tempCon.getLoggedInUser();
        tempCon.cancel();
        tempCon.changePassword();
        
        Test.stopTest();
    }
}