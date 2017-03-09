@isTest
/**
    A test class for CTICallRegistrationController.
*/
private class CTICallRegistrationTest {
    public static testMethod void testMissingPageParams() {
        CTICallRegistrationController controller = new CTICallRegistrationController();
        System.debug(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        //System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
    }
    
    public static testMethod void testCancelParams() {
        System.runAs(createTestYOUserWithNoRole()) {
            preparePageParams(null, null, '123', null);
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.createEmptyCallReg();     
            controller.cancelCallRegistration();
        }
    }
     
    public static testMethod void testMissingDefaultJob() {
        System.runAs(createTestYOUserWithNoRole()) {
            preparePageParams(null, null, '123', null);
            CTICallRegistrationController controller = new CTICallRegistrationController();
            List<Call_Registration_Job__c> callRegJobs = [SELECT Id FROM Call_Registration_Job__c WHERE Job_Type__c = :CTICallRegistrationController.DEFAULT_JOB_TYPE];
            if (callRegJobs == null) {
                System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true);
                System.assertEquals(System.Label.CR_Job_Missing, ApexPages.getMessages()[0].getDetail());
            }
        }
    }

    public static testMethod void testDefaultJob() {
        System.runAs(createTestYOUserWithNoRole()) {
            String phoneNumber = '12345';
            String contextId = 'abcdefgh';
            preparePageParams(phoneNumber, null, contextId, null);
            Call_Registration_Job__c defaultJob = new Call_Registration_Job__c(Job_Type__c = CTICallRegistrationController.DEFAULT_JOB_TYPE);
            insert defaultJob;
            
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.createEmptyCallReg();
            controller.saveCallRegistration();
            List<CTI_CallRegistration__c> cti = [SELECT Id FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId];
            System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            System.assert(cti.size() == 1);
        }
    }
    
    public static testMethod void testCallRegForCustomer1() {
        System.runAs(createTestYOUserWithNoRole()) {
            String customerNumber = '67890';
            String taxonomySet = 'XY';
            String contextId = '112233';
            Account account = new Account(Customer_No__c = customerNumber, Name = 'Test', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());

            // KM: Next line added to get rid of the following error:
            // System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, record type missing for: Customer: []
            account.RecordTypeId = '012200000000nf3'; // YS Customer Account
            insert account;
            
            customerNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:account.id ].Customer_No__c;
            
            preparePageParams('12345', customerNumber, contextId, null);
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(Taksonomy_Set__c = taxonomySet, Valid_From__c = now, Valid_To__c = now + 1);
            insert callRegJob;
            
            Jobs_Users__c userJob = new Jobs_Users__c(User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id);
            insert userJob;
            
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.createEmptyCallReg();
            controller.saveCallRegistration();
            
            // call registration form is saved before call
            String CDN = '123';
            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN) == false);
            System.assert(CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 100, '', '', '', '', '') == false);
            
            List<CTI_CallRegistration__c> cti = [SELECT TaksonomySet__c, ContextId__c, Call_Duration_In_Seconds__c FROM CTI_CallRegistration__c WHERE Customer_number__c = :customerNumber];
            System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            System.assert(cti != null && cti.size() > 0);
            System.assertEquals(taxonomySet, cti[0].TaksonomySet__c);
            System.assertEquals(contextId, cti[0].ContextId__c);
            System.assertEquals(100, cti[0].Call_Duration_In_Seconds__c);
            System.assert(account.Id == controller.CTI.Account__c);
            
            preparePageParams('12345', customerNumber, contextId, null);
            CTICallRegistrationController cCancel = new CTICallRegistrationController();
            cCancel.createEmptyCallReg();
            cCancel.cancelCallRegistration();
            
            cti = [SELECT TaksonomySet__c, ContextId__c, Call_Duration_In_Seconds__c FROM CTI_CallRegistration__c WHERE Customer_number__c = :customerNumber];
            System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            System.assert(cti != null && cti.size() > 0);
            System.assertEquals(taxonomySet, cti[0].TaksonomySet__c);
            System.assertEquals(contextId, cti[0].ContextId__c);
            System.assertEquals(100, cti[0].Call_Duration_In_Seconds__c);
            System.assert(account.Id == cCancel.CTI.Account__c);
        }
    }
    
    public static testMethod void testCallRegForCustomer1b() {
        System.runAs(createTestYOUserWithNoRole()) {
            String customerNumber = '67890';
            String taxonomySet = 'XY';
            String contextId = '112233';
            Account account = new Account(Customer_No__c = customerNumber, Name = 'Test' , Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());

            // KM: Next line added to get rid of the following error:
            // System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, record type missing for: Customer: []
            account.RecordTypeId = '012200000000nf3'; // YS Customer Account

            insert account;
            customerNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:account.id ].Customer_No__c;
            preparePageParams('12345', customerNumber, contextId, null);
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(Taksonomy_Set__c = taxonomySet, Valid_From__c = now, Valid_To__c = now + 1);
            insert callRegJob;
            
            Jobs_Users__c userJob = new Jobs_Users__c(User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id);
            insert userJob;
            
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.saveCallRegistration();
            
            // call registration form is saved before call
            String CDN = '123';
            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN) == false);
            System.assert(CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 100, '', '', '', '', '') == false);
            
            List<CTI_CallRegistration__c> cti = [SELECT TaksonomySet__c, ContextId__c, Call_Duration_In_Seconds__c FROM CTI_CallRegistration__c WHERE Customer_number__c = :customerNumber];
            System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            System.assert(cti != null && cti.size() > 0);
            System.assertEquals(taxonomySet, cti[0].TaksonomySet__c);
            System.assertEquals(contextId, cti[0].ContextId__c);
            System.assertEquals(100, cti[0].Call_Duration_In_Seconds__c);
            System.assert(account.Id == controller.CTI.Account__c);
        }
    }
    
    public static testMethod void testCallRegForCustomer2() {
        System.runAs(createTestYOUser()) {
            String customerNumber = '67890';
            String taxonomySet = 'XY';
            String contextId = '112233';
            
            // call registration form is saved after call
            preparePageParams('12345', customerNumber, contextId, '100');
            Account account = new Account(Customer_No__c = customerNumber, Name = 'Test' , Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());

            // KM: Next line added to get rid of the following error:
            // System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, record type missing for: Customer: []
            account.RecordTypeId = '012200000000nf3'; // YS Customer Account

            insert account;
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(Taksonomy_Set__c = taxonomySet, Valid_From__c = now-1, Valid_To__c = now + 1);
            insert callRegJob;
            List<Group> groups = [SELECT Id from Group WHERE RelatedId = :UserInfo.getUserRoleId()];
            Jobs_Groups__c userGroup = new Jobs_Groups__c(Group_ID__c = groups[0].Id, Call_Registration_Job__c = callRegJob.Id);
            insert userGroup;
            
            String CDN = '123';
            CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 100, '', '', '', '', '');
            
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.createEmptyCallReg();
            controller.saveCallRegistration();
        
            List<CTI_CallRegistration__c> cti = [SELECT TaksonomySet__c, ContextId__c, Call_Duration_In_Seconds__c FROM CTI_CallRegistration__c WHERE Customer_number__c = :customerNumber];
            //System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            //System.assert(cti != null && cti.size() > 0);
            //System.assertEquals(taxonomySet, cti[0].TaksonomySet__c);
            //System.assertEquals(contextId, cti[0].ContextId__c);
            //System.assertEquals(100, cti[0].Call_Duration_In_Seconds__c);
            //System.assert(account.Id == controller.CTI.Account__c);
        }
    }
    
    public static testMethod void testCallRegForCustomer2b() {
        System.runAs(createTestYOUser()) {
            String customerNumber = '67890';
            String taxonomySet = 'XY';
            String contextId = '112233';
            
            // call registration form is saved after call
            preparePageParams('12345', customerNumber, contextId, '100');
            Account account = new Account(Customer_No__c = customerNumber, Name = 'Test' , Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());

            // KM: Next line added to get rid of the following error:
            // System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, record type missing for: Customer: []
            account.RecordTypeId = '012200000000nf3'; // YS Customer Account

            insert account;
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(Taksonomy_Set__c = taxonomySet, Valid_From__c = now-1, Valid_To__c = now + 1);
            insert callRegJob;
            List<Group> groups = [SELECT Id from Group WHERE RelatedId = :UserInfo.getUserRoleId()];
            Jobs_Groups__c userGroup = new Jobs_Groups__c(Group_ID__c = groups[0].Id, Call_Registration_Job__c = callRegJob.Id);
            insert userGroup;
            
            String CDN = '123';
            CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 100, '', '', '', '', '');
            
            CTICallRegistrationController controller = new CTICallRegistrationController();
            controller.saveCallRegistration();
        
            List<CTI_CallRegistration__c> cti = [SELECT TaksonomySet__c, ContextId__c, Call_Duration_In_Seconds__c FROM CTI_CallRegistration__c WHERE Customer_number__c = :customerNumber];
            //System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false);
            //System.assert(cti != null && cti.size() > 0);
            //System.assertEquals(taxonomySet, cti[0].TaksonomySet__c);
            //System.assertEquals(contextId, cti[0].ContextId__c);
            //System.assertEquals(100, cti[0].Call_Duration_In_Seconds__c);
            //System.assert(account.Id == controller.CTI.Account__c);
        }
    }
    
    public static testMethod void testCallRegAccountParam() {
        String taxonomySet = 'XY';
        String contextId = '112233';
        preparePageParams('12345', null, contextId, null);
       
        Account account = new Account(Name = 'Test', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert account;
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.ACCOUNT_ID, account.Id);
        CTICallRegistrationController controller = new CTICallRegistrationController();
    }

    public static testMethod void testCallRegContactIdParam() {
        String taxonomySet = 'XY';
        String contextId = '112233';
        preparePageParams('12345', null, contextId, null);
        
        Account account = new Account(Name = 'Test', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert account;
        
        Contact c = new Contact(Temporary_contact__c = true,AccountId=account.Id,FirstName='TestUserFirstNameXY',LastName='TestUserLastNameXY',HomePhone='123');
        insert c;
        
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CONTACT_ID, c.Id);
        CTICallRegistrationController controller = new CTICallRegistrationController();
    }

    
    private static void preparePageParams(String phone, String customerNumber, String contextId, String callDuration) {
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CONTEXT_ID, contextId);
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.PHONE_NUMBER, phone);
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CDN, 'test');
        ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CALL_START_TIME, '1313487469');
        if (callDuration!=null){
            ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CALL_DURATION, callDuration);         
        }
        if (customerNumber != null)
            ApexPages.currentPage().getParameters().put(CTICallRegistrationController.CUSTOMER_NUMBER, customerNumber);
    }
    
    private static User createTestYOUser(){
        Profile p = [select id from profile where name='YouSee YO User'];
        //UserRole ur = [select id from UserRole where name = 'YK System Administrator'];
        User u = new User(alias = 'YOUntUsr', email='YOUnitTestUser@testorg.com',
            emailencodingkey='UTF-8', lastname='YOUnitTestUser', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            //timezonesidkey='Europe/Paris', username='YOUnitTestUser@testorg.com',MID__c='M95432',UserRoleId=ur.id);
            timezonesidkey='Europe/Paris', username='YOUnitTestUser@testorg.com',MID__c='M95432');
        return u;
    }
 
    private static User createTestYOUserWithNoRole(){
        Profile p = [select id from profile where name='YouSee YO User'];
        //UserRole ur = [select id from UserRole where name = 'YK System Administrator'];
        User u = new User(alias = 'YOUntUsr', email='YOUnitTestUser@testorg.com',
            emailencodingkey='UTF-8', lastname='YOUnitTestUser', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='Europe/Paris', username='YOUnitTestUser@testorg.com',MID__c='M95432');
        return u;
    }
    
}