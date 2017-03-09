@isTest
/**
  A test class for CTICallRegistrationWebServices.
*/
private class CTICallRegistrationWebServicesTest {

    public static testMethod void testNotVisible() {
        System.runAs(createTestYOUser()) { 
            System.assert(!CTICallRegistrationWebServices.isCallRegVisible());
        }
    }

    public static testMethod void testNotRequired() {
        System.runAs(createTestYOUser()) { 
            String contextId = '123'; 
            Long callDuration = 1;
            CTI_CallRegistration__c callReg = new CTI_CallRegistration__c(ContextId__c = contextId);
            insert callReg;

            System.assert(!CTICallRegistrationWebServices.isCallRegVisible());
            System.assert(!CTICallRegistrationWebServices.IsCallRegMandatory('CDN')); 
            System.assert(!CTICallRegistrationWebServices.DoCallReg(contextId, 'CDN', 1, '123', '', '', '', ''));
        }
    }

    public static testMethod void testVisible() {
        System.runAs(createTestYOUser()) {
            String CDN = '123';
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_REQUIRED,
                Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;
            Jobs_Users__c userJob = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert userJob;
            System.assert(CTICallRegistrationWebServices.isCallRegVisible());
        }
    }

    public static testMethod void testRequired() {
        System.runAs(createTestYOUser()) { 
            String CDN = '123';
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_REQUIRED,
                Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;
            Jobs_Users__c userJob = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert userJob;

            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(CTICallRegistrationWebServices.DoCallReg('123', CDN, 1, '123', '', '', '', ''));
        }
    }

    public static testMethod void testTypeTime() {
        System.runAs(createTestYOUser()) { 
            String CDN = '123';
            Date now = Date.today();
            DateTime nowTime = DateTime.now();
            DateTime timeFrom = DateTime.newInstance(
                CTIAdministrationController.DEFAULT_DATE, Time.newInstance(nowTime.hour() - 1, 0, 0, 0)
            );
            DateTime timeTo = DateTime.newInstance(
                CTIAdministrationController.DEFAULT_DATE, Time.newInstance(nowTime.hour() + 1, 0, 0, 0)
            );
            System.debug('timeFrom:' + timeFrom + ' timeTo:' + timeTo);
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_TIME,
                Valid_From__c = now - 1, Valid_To__c = now + 1, Time_From__c = timeFrom, Time_To__c = timeTo
            );
            insert callRegJob;
            Jobs_Users__c userJob = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert userJob;

            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(
                CTICallRegistrationWebServices.DoCallReg('123', CDN, 1, '123',
                String.valueOf(nowTime.getTime() / 1000), '', '', '')
            );
        }
    }

    public static testMethod void testTypeCDN() {
        System.runAs(createTestYOUser()) { 
            String CDN = '123';
            Date now = Date.today();
            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_CDN,
                Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;
            Jobs_Users__c jobUser = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert jobUser;

            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(CTICallRegistrationWebServices.DoCallReg('123', CDN, 1, '', '', '', '', ''));
        }
    }

    public static testMethod void testTaxonomy() {
        System.runAs(createTestYOUser()) { 
            String CDN = '123';
            Date now = Date.today();
            String contextId = '123';

            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_CDN,
                Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;

            Jobs_Users__c jobUser = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert jobUser;

            System.assert(CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', ''));

            List<CTI_CallRegistration__c> actualCalls = [SELECT Id
                FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId()
            ];
            system.debug(actualCalls != null && actualCalls.size() == 1);

            actualCalls[0].TaksonomySet__c = 'YO';
            update actualCalls;

            System.assert(!CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', ''));
            System.assert(CTICallRegistrationWebServices.IsCallRegFinished(contextId));
        }
    }

    public static testMethod void testCancelCTI() {
        System.runAs(createTestYOUser()) { 
            String CDN = '123';
            Date now = Date.today();
            String contextId = '123';

            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_CDN,
                Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;

            Jobs_Users__c jobUser = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert jobUser;

            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', ''));

            List<CTI_CallRegistration__c> actualCalls = [SELECT Id
                FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId()
            ];
            system.debug(actualCalls != null && actualCalls.size() == 1);

            CTICallRegistrationWebServices.cancelCallReg(contextId);

            actualCalls = [SELECT Id
                FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId()
            ];
            system.debug(actualCalls == null || actualCalls.size() == 0);
        }
    }

    public static testMethod void testTypeCoverage() {
        String contextId = '123';
        String callObject = '456';
        String CDN = '789';
        Date now = Date.today();

        Account account = new Account(Name = 'Test', Customer_No__c = '1', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert account;
        String CustNo = [SELECT Id,Customer_No__c FROM Account WHERE Id =:account.id ].Customer_No__c;

        User u = createTestYOUser();

        System.runAs(u) { 
            Contact c = new Contact(
                Temporary_contact__c = true, AccountId=account.Id, FirstName='TestUserFirstNameXY',
                LastName='TestUserLastNameXY', HomePhone='123'
            );
            insert c;

            Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
                CDN__c = CDN, Job_Type__c = CTIAdministrationController.JOB_TYPE_COVERAGE,
                Coverage__c = 50, Valid_From__c = now, Valid_To__c = now + 1
            );
            insert callRegJob;
            Jobs_Users__c userJob = new Jobs_Users__c(
                User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
            );
            insert userJob;

            // The following code runs as user 'u'
            System.debug('Current User: ' + UserInfo.getUserName());

            Task task = new Task (CallObject = callObject);
            insert task;
            //first Call
            System.assert(CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', '')); 

            CTI_CallRegistration__c filledCTI = new CTI_CallRegistration__c(ContextId__c=contextId);
            insert filledCTI;

            System.assert(!CTICallRegistrationWebServices.IsCallRegFinished(contextId));

            Task task2 = new Task (CallObject = callObject);
            insert task2;

            //second Call
            System.assert(!CTICallRegistrationWebServices.IsCallRegMandatory(CDN));
            System.assert(!CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', ''));
            System.assert(!CTICallRegistrationWebServices.IsCallRegFinished(contextId));

            System.assert(!CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', c.Id, '', ''));
            System.assert(!CTICallRegistrationWebServices.IsCallRegFinished(contextId));

            filledCTI = [SELECT Id, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId LIMIT 1];
            if (filledCTI != null){
                System.assertEquals(filledCTI.Account__c, account.Id);
                filledCTI.Account__c = null;
                update filledCTI;
            }

            System.assert(!CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', account.Id, ''));
            System.assert(!CTICallRegistrationWebServices.IsCallRegFinished(contextId));

            filledCTI = [SELECT Id, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId LIMIT 1];
            if (filledCTI != null){
                System.assertEquals(filledCTI.Account__c, account.Id);
                filledCTI.Account__c = null;
                update filledCTI;
            }

            System.assert(
                !CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 1, '', '', '', '', CustNo)
            );
            System.assert(!CTICallRegistrationWebServices.IsCallRegFinished(contextId));

            filledCTI = [SELECT Id, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId LIMIT 1];
            if (filledCTI != null){
                System.assertEquals(filledCTI.Account__c, account.Id);
            }

            System.debug('Current Profile: ' + UserInfo.getProfileId());
            // Run some code that checks record sharing
        } 
    }

    public static testMethod void testCallRegAccountWithInstallation() {
        
        Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
        cableUnitTest1.HF_no__c = '1234';
        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest1;
        
        Cable_Unit__c cableUnitTest2 = new Cable_Unit__c();
        cableUnitTest2.Name = 'cu_kundeCust_testing1'; 
        cableUnitTest2.HF_no__c = '1235';
        cableUnitTest2.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest2.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest2.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest2.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership1();
        cableUnitTest2.Housing_Type__c = clsTestDataForYS.createLookupHousingType1();
        cableUnitTest2.Building_Type__c = clsTestDataForYS.createLookupBuildingType1();
        insert cableUnitTest2; 
        
        Cable_Unit__c cableUnitTest3 = new Cable_Unit__c();
        cableUnitTest3.Name = 'cu_kundeCust_testing2'; 
        cableUnitTest3.HF_no__c = '1236';
        cableUnitTest3.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest3.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest3.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest3.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership2();
        cableUnitTest3.Housing_Type__c = clsTestDataForYS.createLookupHousingType2();
        cableUnitTest3.Building_Type__c = clsTestDataForYS.createLookupBuildingType2();
        insert cableUnitTest3;
        
        
        
        Date now = Date.today();
        DateTime nowTime = DateTime.now();

        String taxonomySet = 'XY';
        String contextId = String.valueOf(nowTime.getTime() / 1000);
        String timeSince1970 = String.valueOf(nowTime.getTime() / 1000);
        String CDN = timeSince1970;

        Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;

        Account account = new Account(Name = 'Test', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde());
        insert account;

        /* Commented for Installation merge
        Installation__c inst1 = new Installation__c(
            Address__c = add.Id, Customer__c = account.Id, HF_no__c = '1234', Cable_Unit_no__c = '5678'
        );
        Installation__c inst2 = new Installation__c(
            Address__c = add.Id, Customer__c = account.Id, HF_no__c = '1234'
        );
        Installation__c inst3 = new Installation__c(
            Address__c = add.Id, Customer__c = account.Id, HF_no__c = '22552255', Cable_Unit_no__c = '5678'
        );
        insert new Installation__c[]{inst1, inst2, inst3};*/
        
        
        Net_Installations__c inst1 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest1.Id);
        Net_Installations__c inst2 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest2.Id);
        Net_Installations__c inst3 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest3.Id);

        insert new Net_Installations__c[]{inst1, inst2 , inst3};
        
        Contact c = new Contact(
            Temporary_contact__c = true, AccountId = account.Id, FirstName = 'TestUserFirstNameXY',
            LastName = 'TestUserLastNameXY', HomePhone = '123'
        );
        insert c;

        Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(
            Job_Type__c = CTIAdministrationController.JOB_TYPE_REQUIRED,
            Taksonomy_Set__c = taxonomySet, Valid_From__c = now, Valid_To__c = now + 1
        );
        insert callRegJob;

        Jobs_Users__c userJob = new Jobs_Users__c(
            User__c = UserInfo.getUserId(), Call_Registration_Job__c = callRegJob.Id
        );
        insert userJob;

        /*List<Installation__c> lstInstallations = [SELECT Id, Customer__c, HF_no__c, Cable_Unit_no__c
            FROM Installation__c WHERE Customer__c = :account.Id
        ];
        system.debug(lstInstallations);*/

        // call registration form is saved before call
        System.assert(
            CTICallRegistrationWebServices.DoCallReg(contextId, CDN, 98, '123-456-7890', timeSince1970, c.Id, '', '')
        );

        List<CTI_CallRegistration__c> res = [SELECT Id, HF_Number__c, Facility__c, Account__c
            FROM CTI_CallRegistration__c
            WHERE ContextId__c = :contextId AND CreatedById = :UserInfo.getUserId() AND CDN__c = :CDN
        ];

        system.assert((res != null) && (res.size() == 1));
        system.assert(res[0].Account__c == account.Id);
        //system.assert(res[0].HF_Number__c == null || res[0].HF_Number__c.length() == 0);
        //system.assert(res[0].Facility__c == null || res[0].Facility__c.length() == 0);

        res[0].Account__c = null;
        update(res[0]);

        res = [SELECT Id, HF_Number__c, Facility__c, Account__c FROM CTI_CallRegistration__c
            WHERE ContextId__c = :contextId AND CreatedById = :UserInfo.getUserId() AND CDN__c = :CDN
        ];

        system.assert((res != null) && (res.size() == 1));
        system.assert(res[0].Account__c == null);
        //system.assert(res[0].HF_Number__c == null || res[0].HF_Number__c.length() == 0);
        //system.assert(res[0].Facility__c == null || res[0].Facility__c.length() == 0);
    }

     private static User createTestYOUser(){
        //Profile p = [select id from profile where name='YouSee SU User'];
        Profile p = [select id from profile where name='YouSee YO User'];
        User u = new User(alias = 'YOUntUsr', email='YOUnitTestUser@testorg.com',
            emailencodingkey='UTF-8', lastname='YOUnitTestUser', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, timezonesidkey='Europe/Paris',
            username='YOUnitTestUser@testorg.com', MID__c='T999999999'
        );
        return u;
    }
}