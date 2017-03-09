@isTest(SeeAllData = true)
private class WriteToYourConsultantSCTestClass {

        
        public static Account acc;
        //public Boolean pageFlag = true;
        
        public static User u;
         
        /*static testMethod void Test1() {
            //try{
                //Boolean editProfile = true;
                System.debug('$$$$$$$$$$$$$4');
                ServiceCenter_CustomSettings__c scTestDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
                System.debug('$SCTest Domain$'+scTestDomain.Value__c);
                scTestDomain.Value__c = 'c.cs7.visual.force.com';
                String testUrl = 'c.cs7.visual.force.com';
                Test.startTest();
                Boolean pageFlag = false;
                Boolean sendCopy = true;
                Address__c add = new Address__c();
                add.Active__c= true;
                add.District__c ='test';
                add.Door_No__c ='1';
                add.Entrance__c = 'ABC';
                add.Floor__c = '4';
                add.House_No__c ='34';
                add.Name = 'test1';
                add.Town__c = 'ABS';
                add.Postcode__c = '4000076';
                add.Street__c='ordrupVej';
                //add.Side__c='TV';
                insert add;
                 
                RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
                Account acct = new Account(Name='Simferna');
                acct.Street_YK__c = add.Id;
                acct.RecordTypeId = recordType.Id;
                insert acct;
                ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
                //Contact C1 = new Contact( AccountID = acc.id, FirstName = 'Test', LastName = 'User', email = 'test-user@fakeemail.com', Street_P__c=add.id );
                //C1.Phone = '23423432';
                //insert C1;
                
                //acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id ='0012000000WCynkAAD'];
                //System.assertEquals('My Account', acc.Id);
                
                    Contact  C2 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_user@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1@test.com');
                    insert C2;
                
                    User u1 = new User( email='test-user@fakeemail.com', contactid = C2.id, profileid = ProID,
                                 UserName='test-user@fakeemail.com', alias='tuser1', 
                                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                                 LastName = 'User',MID__c = 'M87654');
                                 
                    System.runAs(u1){
                        
                    PageReference pageRef = Page.WriteToYourConsultant;
                    Test.setCurrentPage(pageRef);
                    //Test.startTest();
                    Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
                    
                    WriteToYourConsultantController controller = new WriteToYourConsultantController();
                    WriteToYourConsultantController.TEST_MODE1 = true; 
                    // Scenario 1. mailDescription = null,sendCopy = false,editProfile = false
                      
                    //ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','flemming_hansen@tdc.dk');
                    //ApexPages.CurrentPage().getParameters().put('Host','c.cs7.visual.force.com');
                    //controller.editProfile = true;
                    //controller.sendMail();
                    
                    // Scenario 2. mailDescription != null,sendCopy = true,editProfile = true
                    controller.tempFlag = true;
                    controller.setPageFlag(false);
                    controller.backToContactPersonPage();
                    controller.setPageFlag(true);
                    controller.setMailDescription('asjdfkdsf');
                    controller.setSendCopy(true);
                    controller.setEditProfile(true); 
                    controller.setPageFlag(true);
                    WriteToYourConsultantController.TEST_MODE1 = true;
                    //controller.sendMail();
                    controller.sendMail();
                    controller.setSendCopy(false);
                    //controller.sendMail();
                    WriteToYourConsultantController.TEST_MODE1 = true;
                    controller.sendMail();
                    // other calls..
                    controller.getContactDetail();
                    controller.returnToAgreement();
                    controller.getMailDescription();
                    controller.getSendCopy();
                    controller.getEditProfile();
                    controller.getPageFlag();
                    
                    //acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =:acct.Id];
                    if(sendCopy){
                    //if(controller.getSendCopy()){
                        //controller.sendMail();
                        WriteToYourConsultantController.TEST_MODE1 = true;
                        controller.sendMail();
                    }
                    
                    if(pageFlag == false){
                        PageReference backPageRef = Page.ViewAgreementsPage;
                        backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                        backPageRef.setRedirect(true);
                        Test.setCurrentPage(backPageRef);
                    }
                    
                    String fullUrl = URL.getCurrentRequestUrl().toExternalForm();
                    if(fullUrl.contains('ViewAgreementPage')){
                        controller.setPageFlag(false);
                    }
                    if(!controller.getPageFlag()){
                        String newPage = '/apex/ViewAgreementsPage';
                        PageReference backPageRef = new PageReference(newPage);
                        backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                        backPageRef.setRedirect(true);
                        Test.setCurrentPage(backPageRef);
                    }   
               }
            /*}catch(System.DmlException e){
                system.debug('$Error$'+e.getDmlMessage(0));
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError); 
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
                ApexPages.addMessage(errorMsg);
                Test.stopTest();
            }*/
    //}   
     
  /* static testMethod void Test2() {
            Address__c add1 = new Address__c();
            add1.Active__c= true;
            add1.District__c ='test';
            add1.Door_No__c ='1';
            add1.Entrance__c = 'ABD';
            add1.Floor__c = '5';
            add1.House_No__c ='22';
            add1.Name = 'test2';
            add1.Town__c = 'ABSE';
            add1.Postcode__c = '4000056';
            add1.Street__c='ordrupVej'; 
            //add1.Side__c='TH';
            insert add1;        
   
            RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
            Account acc1 = new Account(Name='Simferna');
            acc1.Street_YK__c = add1.Id;
            acc1.RecordTypeId = recordType.Id;
            insert acc1;
            ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
            Contact  C1 = new Contact(AccountID = acc1.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add1.Id, Description = 'For Testing Purpose', Email = 'test_user@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1@test.com');
            insert C1;
            User u2 = new User( email='test-user@test.com', contactid = C1.id, profileid = ProID,
                         UserName='test-user@fakeemail.com', alias='tuser1', 
                         CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                         EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                         LastName = 'User',MID__c = 'M87654');
                         
            System.runAs(u2){
            PageReference pageRef = Page.WriteToYourConsultant;
            Test.setCurrentPage(pageRef);
            Test.startTest();
            WriteToYourConsultantController controller1 = new WriteToYourConsultantController();
            //ID accountId = '0012000000WCynkAAD';
            //acc = [select a.Id, a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =: '0012000000WCynkAAD'];
            controller1.setMailDescription('asjdfkdsf');
            controller1.setSendCopy(true);
            controller1.setEditProfile(true); 
            controller1.setPageFlag(true);
            //controller1.sendMail();
            
            if(controller1.getSendCopy()){
                controller1.sendMail();
            }
             
   }
   }*/
   /*static testMethod void test2(){
        ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
        User u2 = new User( email='test-user@fakeemail.com',
                         UserName='test-user@fakeemail.com', alias='tuser1', profileid = ProID,
                         CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                         EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                         LastName = 'User',MID__c = 'M87654');
                         
        System.runAs(u2){
        Test.startTest();
        WriteToYourConsultantController consulatantController = new WriteToYourConsultantController();
        Contact dummyContact = new Contact(FirstName='user1', LastName= 'test1', Description='Test Description', Email = 'test_test@test.com',Phone= '1010', MobilePhone='4561237890', HomePhone= '4512');
        if(dummyContact != null){
            upsert dummyContact;
        }
        }   
   }*/
   
   /*static testMethod void testUnitForAcc(){
        ID proId = '00e20000001UMw6AAG';
        //ID ProId = [Select Id From Profile where Name = 'Customer Portal Manager Custom'].Id;
        Database.DMLOptions dmo = new Database.DMLOptions();
        User scUser = new User(email='test-user@fakeemail.com',UserName='test-user@fakeemail.com', alias='tuser1', profileid = ProId,CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'user1',LastName = 'user',MID__c = 'M28991');
        insert scUser;
        system.runAs(scUser){
        Test.startTest();
        WriteToYourConsultantController yscontroller = new WriteToYourConsultantController();
        String hostname = ApexPages.currentPage().getHeaders().get('Host');
        ServiceCenter_CustomSettings__c testDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
        system.debug('$hostname$'+hostname+'$testDomain$'+testDomain);
        if(hostname == testDomain.Value__c){
            system.debug('##Before##');
            acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id ='0012000000W5UOQAA3'];
            system.debug('##After##');
            if(yscontroller.getSendCopy()){
                yscontroller.sendMail();
                system.debug('$Mail send$');
            }   
        }
        
        }       
   }*/
  /* 
   static testMethod void myPositiveUnitTest() {
        //try{
                Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
                customerSegment.Name = 'ParceInt_Test'; 
                customerSegment.Code__c = 'pnetTest'; 
                customerSegment.SourceId__c = 'PCRM-seg---98777511'; 
                insert customerSegment;
                Account accp = new Account();
                accp.Name = 'TestHierarchy';
                accp.Type='Hierarki';
                accp.Customer_Segment_Lookup__c = customerSegment.Id;
                insert accp;
                Cable_Unit__c cableUnitTest = new Cable_Unit__c();
                cableUnitTest.Potential_Installations__c = 68.0;
                cableUnitTest.Name = 'cu_kundeCust_testing'; 
                cableUnitTest.Municipaly__c = '223 Hørsholm'; 
                cableUnitTest.Cable_Unit_Post_Code__c = '4200';
                insert cableUnitTest;
                Account kundeChild = new Account();
                kundeChild.Name = 'kundeCustomer';
                kundeChild.parentId = accp.Id;
                kundeChild.Cable_Unit__c = cableUnitTest.id;
                kundeChild.RecordTypeId = '012200000000nf3';
                kundeChild.Type = 'kunde';
                insert kundeChild;
                Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=accp.Id);
                insert c;
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
               WriteToYourConsultantController yscontroller = new WriteToYourConsultantController();
               WriteToYourConsultantController.TEST_MODE = true; 
               yscontroller.setSendCopy(true);
               String hostName = ApexPages.currentPage().getHeaders().get('Host');
               PageReference pageRef = Page.WriteToYourConsultant;
               Apexpages.currentpage().getparameters().put('Account Id','0012000000W5UOQAA3');
               Test.setCurrentPage(pageRef);
               //Test.startTest();
               ServiceCenter_CustomSettings__c testDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
               //yscontroller.setAccountId('0012000000W5UOQAA3');
               system.debug('$Value of test Domain$'+testDomain);
               if(hostName  == testDomain.Value__c){
                system.debug('$Inside check$');
                    if(yscontroller.getSendCopy()){
                        WriteToYourConsultantController.TEST_MODE1 = true;
                        yscontroller.sendMail();
                    }
                    system.debug('$After Final mail send$');    
               }
        }
    /*}catch(System.DmlException e){
            system.debug('$Error$'+e.getDmlMessage(0));
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
            //ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getDmlMessage());
            ApexPages.addMessage(debugMsg);
            Test.stopTest();
    } */   
  //}
  
/*  static testMethod void testContact(){
                try{
                Test.startTest();
                

                Account accp = new Account();
                accp.Name = 'TestAccount';
                accp.Type='Hierarki';
                accp.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
                insert accp;
                
                Contact c = new Contact(email = 'amr@test.com',FirstName='amr',LastName='suv',Phone='1247', Temporary_contact__c = true, HierarchyAccount__c= accp.Id);
                insert c;
                Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = true;
                u = new User(alias = 'ssess', email='testClassUser@testuser.com',title='kunderådgiver',
                    emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
                    timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M08933');        
                    u.setOptions(dmo);
                insert u;
            //   u = [SELECT Id, Name FROM User where email = 'vishal.tambe@capgemini.com' limit 1]; 
               System.runAs(u) {
               WriteToYourConsultantController yscontroller = new WriteToYourConsultantController();
               yscontroller.setSendCopy(true);
               WriteToYourConsultantController.TEST_MODE1 = true;
               yscontroller.sendMail();
               //yscontroller.sendMail();
               String hostName = ApexPages.currentPage().getHeaders().get('Host');
               PageReference pageRef = Page.WriteToYourConsultant;
                 yscontroller.getEditProfile();
                
               String portalBrugerRole;
               portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
               
               Contact ltContact = new Contact();
               ltContact = [Select Contact.Id, Contact.FirstName, Contact.LastName, Contact.Street_P__c, Contact.Description, Contact.Email, Contact.Phone, Contact.MobilePhone, Contact.HomePhone, Contact.Address_merge_field__c, Contact.AlternateEmail__c From Contact where Id In (Select ContactId From User where Id =: userInfo.getUserId())];
               
             }
                }catch(System.Exception e){
                    System.debug('Error'+e.getMessage());
                    Test.stopTest();
                }
    }*/
    
    
    /*static testMethod void TestUnit() {
            //try{
                //Boolean editProfile = true;
                Test.startTest();
                Boolean pageFlag = false;
                Boolean sendCopy = true;
                Address__c add = new Address__c();
                add.Active__c= true;
                add.District__c ='test';
                add.Door_No__c ='1';
                add.Entrance__c = 'ABC';
                add.Floor__c = '4';
                add.House_No__c ='34';
                add.Name = 'test1';
                add.Town__c = 'ABS';
                add.Postcode__c = '4000076';
                add.Street__c='ordrupVej';
                //add.Side__c='TV';
                insert add;
                 
                RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
                Account acct = new Account(Name='Simferna');
                acct.Street_YK__c = add.Id;
                acct.RecordTypeId = recordType.Id;
                insert acct;
                
               
                ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
                //Contact C1 = new Contact( AccountID = acc.id, FirstName = 'Test', LastName = 'User', email = 'test-user@fakeemail.com', Street_P__c=add.id );
                //C1.Phone = '23423432';
                //insert C1;
                
                //acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id ='0012000000WCynkAAD'];
                //System.assertEquals('My Account', acc.Id);
                
                    Contact  C2 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_userwest@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1west@test.com');
                    insert C2;
                
                    User u1 = new User( email='test-usereast@fakeemail.com', contactid = C2.id, profileid = ProID,
                                 UserName='test-user@fakeemail.com', alias='tuser1', 
                                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                                 LastName = 'User',MID__c = 'M87655');
                                 
                    System.runAs(u1){
                    PageReference pageRef = Page.WriteToYourConsultant;
                    Test.setCurrentPage(pageRef);
                    //Test.startTest();
                    String retUrl = 'c.cs7.visual.force.com';
                    
                    
                    //Apexpages.currentpage().getHeaders().put('Host','c.cs7.visual.force.com'); 
                    Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
                    
                    WriteToYourConsultantController.TEST_MODE = true; 
                    WriteToYourConsultantController controller = new WriteToYourConsultantController();
                    // Scenario 1. mailDescription = null,sendCopy = false,editProfile = false
                      
                    //ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','flemming_hansen@tdc.dk');
                    //ApexPages.CurrentPage().getParameters().put('Host','c.cs7.visual.force.com');
                    //controller.editProfile = true;
                    //controller.sendMail();
                    
                    // Scenario 2. mailDescription != null,sendCopy = true,editProfile = true
                    controller.tempFlag = true;
                    controller.setPageFlag(false);
                    controller.backToContactPersonPage();
                    controller.setPageFlag(true);
                    controller.setMailDescription('asjdfkdsf');
                    controller.setSendCopy(true); 
                    controller.setEditProfile(true); 
                    controller.setPageFlag(true);
                    WriteToYourConsultantController.TEST_MODE1 = true;
                    //controller.sendMail();
                    controller.sendMail();
                    controller.setSendCopy(false);
                    //controller.sendMail();
                    controller.sendMail();
                    // other calls..
                    controller.getContactDetail();
                    controller.returnToAgreement();
                    controller.getMailDescription();
                    controller.getSendCopy();
                    controller.getEditProfile();
                    controller.getPageFlag();
                    
                    acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =:acct.Id];
                    if(sendCopy){
                    //if(controller.getSendCopy()){
                       WriteToYourConsultantController.TEST_MODE1 = true;
                        controller.sendMail();
                    }
                    
                    if(pageFlag == false){
                        PageReference backPageRef = Page.ViewAgreementsPage;
                        backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                        backPageRef.setRedirect(true);
                        Test.setCurrentPage(backPageRef);
                    }
                    
                    String fullUrl = URL.getCurrentRequestUrl().toExternalForm();
                    if(fullUrl.contains('ViewAgreementPage')){
                        controller.setPageFlag(false);
                    }
                    if(!controller.getPageFlag()){
                        String newPage = '/apex/ViewAgreementsPage';
                        PageReference backPageRef = new PageReference(newPage);
                        backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                        backPageRef.setRedirect(true);
                        Test.setCurrentPage(backPageRef); 
                    }   
               }
            /*}catch(System.DmlException e){
                system.debug('$Error$'+e.getDmlMessage(0));
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError); 
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
                ApexPages.addMessage(errorMsg);
                Test.stopTest();
            }*/
   // } 
/*    static testMethod void testWritetoConsultant(){
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
       // add.Side__c='TV';
        insert add;
         
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acct = new Account(Name='Simferna');
        acct.Street_YK__c = add.Id;
        acct.RecordTypeId = recordType.Id;
        acct.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acct;
        
        Contact  C2 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_userwest@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1west@test.com');
        insert C2; 
        
        ID ProID = [ Select id from Profile where name = 'ServiceCenter Portal Administrator'].id;
        User u1 = new User( email='test-usereast@fakeemail.com', contactid = C2.id, profileid = ProID,
                 UserName='test-user@fakeemail.com', alias='tuser1', 
                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                 LastName = 'User',MID__c = 'M87655');
        system.runAs(u1){         
            PageReference pageRef = Page.WriteToYourConsultant;
            Test.setCurrentPage(pageRef);
            Apexpages.currentpage().getHeaders().put('Host','c.cs7.visual.force.com'); 
            Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','vpr@yousee.dk');
            WriteToYourConsultantController.TEST_MODE = true; 
            WriteToYourConsultantController controller = new WriteToYourConsultantController();
            controller.setEditProfile(true); 
            controller.setSendCopy(true);
            WriteToYourConsultantController.TEST_MODE1 = true;
            controller.sendMail();
            controller.setSendCopy(false);
            controller.sendMail();
 
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail',''); 
            controller.setEditProfile(true);
            controller.setSendCopy(true);
            controller.sendMail();
            controller.setSendCopy(false);
            controller.sendMail();

            controller.getContactDetail();
             controller.returnToAgreement();
             controller.getMailDescription();
             controller.getSendCopy(); 
             controller.getEditProfile();
             controller.getPageFlag();
            
            	controller.setPageFlag(false);
                controller.backToContactPersonPage();
                controller.setPageFlag(true);
                controller.setMailDescription('test');
                controller.setSendCopy(true);
                controller.setEditProfile(true); 
                controller.setPageFlag(true);
                WriteToYourConsultantController.TEST_MODE1 = true;   
                controller.setSendCopy(false);
                controller.sendMail();
            	controller.fetchAddressDetails();

   			}
   	}*/
    
    /*static testMethod void testWritetoConsultant3(){
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
       // add.Side__c='TV';
        insert add;
         
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acct = new Account(Name='Simferna');
        acct.Street_YK__c = add.Id;
        acct.RecordTypeId = recordType.Id;
        acct.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acct;
        
        Contact  C3 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_userwest@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1west@test.com');
        insert C3; 
        
        ID ProID = [ Select id from Profile where name = 'ServiceCenter Portal Administrator'].id;
        User u2 = new User( email='test-usereast@fakeemail.com', contactid = C3.id, profileid = ProID,
                 UserName='test-user@fakeemail.com', alias='tuser1', 
                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                 LastName = 'User',MID__c = 'M87655');
        system.runAs(u2){         
            PageReference pageRef3 = Page.WriteToYourConsultant;
            Test.setCurrentPage(pageRef3);
            Apexpages.currentpage().getHeaders().put('Host',''); 
            Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','vpr@yousee.dk');
            WriteToYourConsultantController.TEST_MODE = true; 
            WriteToYourConsultantController controller3 = new WriteToYourConsultantController();
            controller3.setEditProfile(true); 
            controller3.setSendCopy(true);
            WriteToYourConsultantController.TEST_MODE1 = true;
            controller3.sendMail();
            controller3.setSendCopy(false);
            controller3.sendMail();
            
             ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail',''); 
            controller3.setEditProfile(true);
            controller3.setSendCopy(true);
            controller3.sendMail();
            controller3.setSendCopy(false);
            controller3.sendMail();
 

   			}
	}*/
}

       /* static testMethod void testWritetoConsultant1(){
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
       // add.Side__c='TV';
        insert add;
         
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acct = new Account(Name='Simferna');
        acct.Street_YK__c = add.Id;
        acct.RecordTypeId = recordType.Id;
        acct.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acct;
        
        Contact  C2 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_userwest@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1west@test.com');
        insert C2; 
        
        ID ProID = [ Select id from Profile where name = 'ServiceCenter Portal Administrator'].id;
        User u1 = new User( email='test-usereast@fakeemail.com', contactid = C2.id, profileid = ProID,
                 UserName='test-user@fakeemail.com', alias='tuser1', 
                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                 LastName = 'User',MID__c = 'M87655');
        system.runAs(u1){         
            PageReference pageRef = Page.WriteToYourConsultant;
            Test.setCurrentPage(pageRef);
            Apexpages.currentpage().getHeaders().put('Host','c.ces7.visual.force.com'); 
            Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','amsur@yousee.dk');
            WriteToYourConsultantController.TEST_MODE = true; 
            WriteToYourConsultantController controller12 = new WriteToYourConsultantController();
            controller12.setEditProfile(true); 
            controller12.setSendCopy(true);
            WriteToYourConsultantController.TEST_MODE1 = true;
            controller12.sendMail();
                                   
            controller12.setSendCopy(false);          
            controller12.sendMail();
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail','ss@gmail.com');  
                
            controller12.sendMail();
            controller12.setPageFlag(false);
            controller12.backToContactPersonPage();
            ApexPages.CurrentPage().getParameters().put('YouSeeContactEmail',''); 
            controller12.setSendCopy(true);
            controller12.sendMail();
            controller12.setSendCopy(false);
            controller12.sendMail();
    }  
    } */