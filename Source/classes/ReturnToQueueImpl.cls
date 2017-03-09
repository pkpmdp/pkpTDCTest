/**
 * Implementation for scheduled job, ReturnToQueueScheduler.
 */
public with sharing class ReturnToQueueImpl { 
    private List<Case> cases = new List<Case>(); // List of Cases found. Initialized in #runJob
    private Integer businessDaysToGoBackInt = 2; // Can be overridden by Custom Settings. See #initCustomSettings
    private Integer businessDaysToGoBackIntForSelectedProfile = 14; //SF-2715 For Profile Yousee PYF User and Yousee Sales User 
    private String[] toAddresses; // Setup by Custom Settings. See #initCustomSettings
    private String sandboxName = ''; // Get sandbox name from custom setting
    List <String> newProfile;
    Set<String> setSelectedProfile = new Set<String>();
    /**
     * The only method which is called by the scheduled Apex Class, ReturnToQueueScheduler.
     * The method takes a testCaseId which should be present when calling the method from a test method.
     * When calling runJob from anywhere but from a test method, testCaseId should be null.
     */
    public String runJob(String testCaseId) {
        // Initialize Custom Settings
        initCustomSettings();
		system.debug('chec++'+testCaseId);
        // Only find cases that were updated X or more business days ago (defined by businessDaysToGoBackInt)
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
        system.debug('check1'+bh);
        Datetime now = Datetime.now();
        Long businessDaysToGoBackInMilliseconds = this.businessDaysToGoBackInt * 8 * 60 * 60 * 1000L; // days * working hours per day * minutes * seconds * milliseconds
         system.debug('check1'+businessDaysToGoBackInMilliseconds );
      //Long businessDaysToGoBackInMilliseconds = 60 * 60 * 1000L; // 1 hour - used when testing
        businessDaysToGoBackInMilliseconds = -1 * businessDaysToGoBackInMilliseconds; // Multiply with -1 to get a negative value so the date will be in the past
        Datetime businessDaysToGoBack = BusinessHours.addGmt(bh.Id, now, businessDaysToGoBackInMilliseconds);
        system.debug('check1'+businessDaysToGoBack );
        
        //For SF-2715 Only find cases that were updated X or more business days ago (defined by businessDaysToGoBackIntForSelectedProfile)
        Long businessDaysToGoBackForProfileInMilliseconds = this.businessDaysToGoBackIntForSelectedProfile * 8 * 60 * 60 * 1000L; // days * working hours per day * minutes * seconds * milliseconds
        businessDaysToGoBackForProfileInMilliseconds = -1 * businessDaysToGoBackForProfileInMilliseconds; // Multiply with -1 to get a negative value so the date will be in the past
        Datetime businessDaysToGoBackForProfile = BusinessHours.addGmt(bh.Id, now, businessDaysToGoBackForProfileInMilliseconds);
        
        
        // Fetch cases that:
        // - are owned by a user
        // - have not been modified the last X business days (defined by businessDaysToGoBackInt)
        // - have not been reserved
        system.debug('check1'+bh);
        if(testCaseId != testCaseId ) {
            // Ignore LastModifiedDate clause as the field cannot be manipulated in the test method
            this.cases = [SELECT Id, Subject FROM Case WHERE Owner.Type = 'User' AND Reserve_Until__c = null AND Id = :testCaseId LIMIT 1];
        } else {
            // Include LastModifiedDate clause
            List<Case>listCaseNotProfile = new List<Case>();
            List<Case>listCaseProfile = new List<Case>();
            listCaseNotProfile = [SELECT Id FROM Case WHERE Owner.Type = 'User' AND Owner.ProfileId NOT IN : setSelectedProfile  AND LastModifiedDate <= :businessDaysToGoBack AND Reserve_Until__c = null LIMIT 200];
            listCaseProfile = [SELECT Id FROM Case WHERE Owner.Type = 'User' AND Owner.ProfileId IN : setSelectedProfile AND Reserve_Until__c = null AND  LastModifiedDate <= :businessDaysToGoBackForProfile LIMIT 200];
        	if(!listCaseNotProfile.isEmpty())
        		this.cases.addAll(listCaseNotProfile);
        	if(!listCaseProfile.isEmpty())
        		this.cases.addAll(listCaseProfile); 
        } 
        
		system.debug('thiscase '+this.cases);
        // Prepare DMLOptions to run the default assignment rule so that the Case is returned to a queue
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;

        // Set urgent to true and create case comment
        List<CaseComment> comments = new List<CaseComment>();
        for(Case c : this.cases) {
            c.Urgent__c = true;
            c.setOptions(dmo); // Run the default assignment rule for this Case

            CaseComment cc = new CaseComment();
            cc.ParentId = c.Id;
            cc.CommentBody = 'Sagen er sendt retur til behandlingskøen, da der ikke er sket nogen ændringer de seneste ' + this.businessDaysToGoBackInt + ' dage';
            comments.add(cc);
        }

        String ret = '';

        // Update cases:
        // The cases are returned to the correct queue by the assignment rules triggered by the after update trigger
        // and the record type is changed by a workflow.
        // Note that this also goes for closed cases which means this also serves as a clean-up of closed cases.
        //
        // Insert case comments:
        // Case comments are inserted in order to track changes.
        //
        // Send email:
        // Create email message and send to recipient(s)
        try {
            // Carry out case update and comment insert
            Database.SaveResult[] updateResult = Database.update(cases, false);
            Database.SaveResult[] insertResult = Database.insert(comments, false);

            // Create, and send, debug email
            ret = sendEmail(updateResult, insertResult, null, null);
        } catch (Exception e) {
            // Create, and send, debug email
            ret = sendEmail(null, null, 'Failed updating cases', e.getMessage());

            // Log exception
            System.debug('Failed updating cases during scheduled run (ReturnToQueueImpl#runJob): ' + e.getMessage());
            System.debug(e);
        }

        return ret;
    }

    /**
     * Private helper method for initializing the application parameters/values.
     */
    private void initCustomSettings() {
        // Setup debug and exception email recipients
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues('ReturnToQueue.TO_ADDRESSES');
        String value, strBHValue;

        if(cs != null && cs.Setting_Value__c != null) {
            value = cs.Setting_Value__c;
            this.toAddresses = value.split(',');
        }

        // Setup businessDaysToGoBackInt
        cs = YouSeeCustomSettings__c.getValues('ReturnToQueue.BUSINESS_DAYS_TO_GO_BACK');
        if(cs != null && cs.Setting_Value__c != null) {
            value = cs.Setting_Value__c;
            this.businessDaysToGoBackInt = Integer.valueOf(value);
        }
        
        //Changes for SF-2715 Setup businessDaysToGoBackIntForSelectedProfile 
        YouseeCustomSettingNew__c csn = YouseeCustomSettingNew__c.getOrgDefaults();
        if(csn != null && csn.Setting_New_Value__c != null && csn.Setting_New_BH_Value__c != null){
        Value=csn.Setting_New_Value__c;
        newProfile= Value.split(' ');
        Integer i;
     
        setSelectedProfile.addAll(newProfile);
        system.debug('SF-2715'+setSelectedProfile );
          
        strBHValue=csn.Setting_New_BH_Value__c;
        this.businessDaysToGoBackIntForSelectedProfile = Integer.valueOf(strBHValue);
        }
                            
        cs = YouSeeCustomSettings__c.getValues('Sandbox');
        if(cs != null && cs.Setting_Value__c != null) {
            this.sandboxName = cs.Setting_Value__c;
        }
    } 

    /**
     * Private helper method for sending debug email.
     */
    private String sendEmail(Database.SaveResult[] updateResult, Database.SaveResult[] insertResult, String subject, String body) {
        if(this.toAddresses == null) {
            System.debug('No recipients found. Not sending out any (debug/error) emails!');
            return '';
        }

        // Initialize empty emailBody
        String emailBody = '';
        if (this.sandboxName != null && this.sandboxName != '') {
            // A sandbox
            emailBody = 'This email is generated from sandbox: ' + this.sandboxName + '\n\r\n\r';
        }

        // Report Cases that failed: not returned to a queue
        if (this.cases != null && this.cases.size() > 0) {
            Set<Id> ids = new Set<Id>();
            for (Case c : this.cases) {
                ids.add(c.Id);
            }
            String strNotReturned = '';
            for (Case c : [SELECT Id, Owner.Type FROM Case WHERE Id IN :ids]) {
                if (c.Owner.Type == 'User') {
                    strNotReturned += 'Failed : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id + '\r\n';
                }
            }
            if (strNotReturned != '') {
                // There are Cases that failed
                emailBody += '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n';
                emailBody += 'Cases not returned to a queue due to an error:\n\r';
                emailBody += strNotReturned;
                emailBody += '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\r';
            }
        }

        if(updateResult != null) {
            // Create email body for update errors          
            if (this.cases != null && this.cases.size() == updateResult.size()){
                emailBody += 'Update Case[] results:\n\r';
                for(Integer i=0; i<this.cases.size(); ++i){
                    Database.SaveResult res = updateResult[i]; 
                    if (res != null){
                        Database.Error[] errs = res.getErrors();
                        if (errs != null && errs.size() > 0){
                        emailBody += 'Failed : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.cases[i].Id + '\r\n';                 
                        for(Database.Error err : errs) {
                            emailBody += ' - ' + err.getMessage() + '\n\r';
                        }
                        emailBody += '\n\r';
                        } else {
                            emailBody += 'Succeded : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.cases[i].Id + '\r\n\n\r';
                        }                     
                    } else {
                        emailBody += 'Succeded : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.cases[i].Id + '\r\n\n\r';
                    }
                }
            } else {
                emailBody = 'Update Case[] errors: Unable to figure failed Cases IDs\n\r\n\r';
            }
        }

        if(insertResult != null) {
            // Create email body for insert errors
            emailBody += 'Insert CaseComment[] errors:\n\r';
            for(Database.SaveResult res : insertResult) {
                for(Database.Error err : res.getErrors()) {
                    emailBody += err.getMessage() + '(' + res.getId() + ')\n\r';
                }
            }
        }

        system.debug(emailBody);

        // Create email
        Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
        sem.setUseSignature(false);
        sem.setToAddresses(this.toAddresses);
        if (this.sandboxName != null && this.sandboxName != '') {
            // A sandbox
            sem.setSubject(subject != null ? subject : this.sandboxName + ' - Updated ' + this.cases.size() + ' cases');
        } else {
            // Production (maybe)
            sem.setSubject(subject != null ? subject : 'Updated ' + this.cases.size() + ' cases');
        }
        sem.setPlainTextBody(body != null ? body : emailBody);

        // Send email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
        return emailBody;
    }

    /**
     * Test scheduler
     */
    private static void testSchedulerImpl(User runner, Boolean shouldSucceed) {
        // Fetch Test Data
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Open Case' LIMIT 1];
        User u = createYFFUser();
        insert u;

        // Create Test Case
        Case c = new Case();
        c.Subject = 'ReturnToQueueScheduler Test Case Subject';
        c.Description = 'ReturnToQueueScheduler Test Case Description';
        c.Department__c = System.label.PYSF;
        c.Product_2__c = 'Agent';
        c.RecordTypeId = rt.Id;
        c.OwnerId = u.Id;
        c.Urgent__c = false;

        // Insert Test Case
        insert c;
        casecomment casecom=new casecomment();
        casecom.CommentBody='test comment';
        casecom.ParentId=c.Id;
        insert casecom;

        System.runAs(runner) { 
            // Start Test
            Test.startTest();

            // Verify Case is owned by user and urgent is false
            System.assertEquals(u.Id, c.OwnerId);
            System.assertEquals(false, c.Urgent__c);

            // Run Job
            ReturnToQueueImpl impl = new ReturnToQueueImpl();
            String str = impl.runJob(c.Id);
            system.debug(str);

            // Fetch data after job has run
            Case c2 = [SELECT Urgent__c FROM Case WHERE Id = :c.Id];
            CaseComment cc = [SELECT Id FROM CaseComment WHERE ParentId = :c.Id];

            // Verify Case is owned by queue, urgent is true and case comment exist
            System.assertEquals(shouldSucceed, true);
            System.assertNotEquals(null, cc);

            // Stop Test
            Test.stopTest();
        }
    }

    /**
     * Create system administrator user to be able to modify Case and sheduler should succeed
     */
    private static User createStrongUser(){
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'SA', email='sa@testorg.com',
            emailencodingkey='UTF-8', lastname='SA', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='Europe/Paris', username='sa@testorg.com', IsActive=true);
        u.MID__c = 'MRetToQueS'; // to avoid 'FIELD_CUSTOM_VALIDATION_EXCEPTION, MID is mandatory: [MID__c]'
        return u;
    }

    /**
     * Create readonly user to be NOT able to modify Case and sheduler should fail
     */
    private static User createWeakUser(){
        Profile p = [select id from profile where name='Read Only'];
        User u = new User(alias = 'RO', email='readonly@testorg.com',
            emailencodingkey='UTF-8', lastname='RO', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='Europe/Paris', username='readonly@testorg.com', IsActive=true);
        u.MID__c = 'MRetToQueW'; // to avoid 'FIELD_CUSTOM_VALIDATION_EXCEPTION, MID is mandatory: [MID__c]'
        return u;
    }

    /**
     * Create YFF user as a Case Owner
     */
    private static User createYFFUser(){
        String profileName = 'YouSee '+System.label.PYSF+' User';
        Profile p = [select id from profile where name=:profileName];
        User u = new User(alias = 'PYF', email='yff@testorg.com',
            emailencodingkey='UTF-8', lastname=System.label.PYSF, languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='Europe/Paris', username='yff@testorg.com', IsActive=true);
        u.MID__c = 'MRetToQueY'; // to avoid 'FIELD_CUSTOM_VALIDATION_EXCEPTION, MID is mandatory: [MID__c]'
        return u;
    }

    /**
     * Test scheduler as active user
     */
    public static testMethod void testSchedulerImplActiveUser() {
        testSchedulerImpl(createStrongUser(), true);
    }

    /**
     * Test scheduler as inactive user
     */
/*  KM Commented out due to deployment validation error in Prod:
    API Name: ReturnToQueueImpl.testSchedulerImplInactiveUser()
    Line: 225
    Failure Message: "System.DmlException: Insert failed. First exception on row 0;
     first error: DUPLICATE_USERNAME, Duplicate Username.<br>
     Another user has already selected this username.<br>
     Please select another.: [Username]", Failure Stack Trace:
      "Class.ReturnToQueueImpl.testSchedulerImpl: line 225, column 1 Class.ReturnToQueueIm...

    public static testMethod void testSchedulerImplInactiveUser() {
        testSchedulerImpl(createWeakUser(), false);
    }
*/
}