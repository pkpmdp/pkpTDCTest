public class clsNPEmailSender {

    public class EmailTemplateNotFoundException extends Exception{}

    // This address needs to be configured in Email-to-case in the current org
    public static final String NP_REPLY_TO_ADDRESS = 'kundeservice@yousee.dk';
    // This is an ID of NP specific Organization-Wide Email Address in the current org
    public static final String NP_ORG_WIDE_ADDRESS_ID = '0D2200000004CKG';

    public static final String ERR_MISSING_TEMPLATE = System.Label.NP_Error_Missing_OCH_Email_Template;
                                                        //'Missing email template for OCH error code: ';

    // E-mail templates
    public static final String TMPL_NOTIFICATION_1       = 'Confirm_Order_Request_Notification_1';
    public static final String TMPL_NOTIFICATION_2       = 'Confirm_Order_Request_Notification_2';
    public static final String TMPL_NOTIFICATION_3       = 'Confirm_Order_Request_Notification_3';
    public static final String TMPL_NOTIFICATION_NO_DATA = 'Confirm_Order_Request_No_Data';
    public static final String TMPL_INPORT_ACCEPTANCE = 'NP_Inport_Acceptance';
    public static final String TMPL_INPORT_REJECTION_RMNDR = 'NP_Inport_Rejection_Reminder';
    public static final String TMPL_INPORT_REJECTION_330   = 'NP_Inport_Rejection_330';
    public static final String TMPL_INPORT_REJECTION_338   = 'NP_Inport_Rejection_338';
    public static final String TMPL_INPORT_REJECTION_339   = 'NP_Inport_Rejection_339';
    public static final String TMPL_INPORT_REJECTION_349   = 'NP_Inport_Rejection_349';
    public static final String TMPL_INPORT_REJECTION_351   = 'NP_Inport_Rejection_351';
    public static final String TMPL_INPORT_REJECTION_354   = 'NP_Inport_Rejection_354';
    public static final String TMPL_INPORT_REJECTION_377   = 'NP_Inport_Rejection_377';
    public static final String TMPL_INPORT_REJECTION_380   = 'NP_Inport_Rejection_380';
    public static final String TMPL_NOTIFICATION_0_1       = 'Confirm_Order_Request_Notification_0_1';
    public static final String TMPL_NOTIFICATION_0_2       = 'Confirm_Order_Request_Notification_0_2';
    public static final String TMPL_NOTIFICATION_0_3       = 'Confirm_Order_Request_Notification_0_3';
    public static final String TMPL_NOTIFICATION_0_NO_DATA = 'Confirm_Order_Request_0_No_Data';

    private Messaging.SingleEmailMessage emailMessage;

    private clsNPEmailSender() {}

    public clsNPEmailSender(Messaging.SingleEmailMessage emailMessage) {
        this.emailMessage = emailMessage;
    }

    public void sendMessage() {
        // send email out
        try {
            List<Messaging.Sendemailresult> resultList = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        } catch (Exception e) {
            Id relatedTo = emailMessage != null ? emailMessage.getWhatId() : null;
            clsCasesNpHandlerController.createTaskForPowerGroup(
                clsCasesNpHandlerController.TASK_OBJECTIVE_INVALIDEMAILADDRESS + ' (' + e.getMessage() + ')',
                Date.today(), relatedTo
            );
        }
/*
        List<Messaging.Sendemailresult> resultList = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });

        // process results
        if (resultList != null)
            System.debug('Emailing result list size: ' + resultList.size());

        for (Messaging.Sendemailresult r : resultList) {
            System.debug('Email success: ' + r.isSuccess());
            if (!r.isSuccess()) {
                for (Messaging.SendEmailError err: r.getErrors()) {
                    System.debug('Email error: ' + err.getMessage());
                }
            }
        }
*/
    }

    private static void prepareAndSendEmailsForTemplate(String templateId, Map<Id, Id> caseToContactMap) {
        // send messages for all cases in the map 
        for (Id caseId : caseToContactMap.keySet()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(caseToContactMap.get(caseId));       // recipient's contact - who is going to receive the email
            mail.setWhatId(caseId);                                     // related case id
            mail.setTemplateId(templateId);                             // email template Id
            setDefaultPropertiesToEmail(mail);
            
            clsNPEmailSender sender = new clsNPEmailSender(mail);
            sender.sendMessage();
        }
    }

    public static void SetDefaultPropertiesToEmail(Messaging.SingleEmailMessage mail) {
        mail.setBccSender(false);               // bcc to email sender (SF user under which is this running)
        mail.setUseSignature(false);
        mail.setSaveAsActivity(true);           // save as activity to case (appears in the list of related emails in case record)
        
        // following properties should be filled with data configured on Email-to-case routing
        // again this is not portable since it relies on setting of current SF org
        mail.setOrgWideEmailAddressId(NP_ORG_WIDE_ADDRESS_ID); // this will set both FromAddress and DisplayName
        mail.setReplyTo(NP_REPLY_TO_ADDRESS);
    }
    
    /*
     * Public static methods to be called from outside
     */
    public static void sendConfirmNPOrderRequest(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_1), caseToContactMap);
    }

    public static void sendConfirmNPOrderRequest_NoDate(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_1), caseToContactMap);
    }

/*
    public static void sendConfirmNPOrderRequest_2ndNotification(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_2), caseToContactMap);
    }

    public static void sendConfirmNPOrderRequest_2ndNotification_NoDate(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_2), caseToContactMap);
    }

    public static void sendConfirmNPOrderRequest_3rdNotification(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_3), caseToContactMap);
    }

    public static void sendConfirmNPOrderRequest_3rdNotification_NoDate(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_3), caseToContactMap);
    }
*/

    public static void sendConfirmNPOrderRequest_Notification_No_Data(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_NO_DATA), caseToContactMap);
    }

    public static void sendConfirmNPOrderRequest_Notification_No_Data_NoDate(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_NO_DATA), caseToContactMap);
    }

    public static void sendRequestNPFeedback_1stNotification(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_INPORT_REJECTION_RMNDR), caseToContactMap);
    }

    //using the same template for the 2nd notification - possible to change in future - note by Martin
    public static void sendRequestNPFeedback_2ndNotification(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_INPORT_REJECTION_RMNDR), caseToContactMap);
    }

    public static void sendNpInPortAcceptance(Map<Id, Id> caseToContactMap) {
       prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_INPORT_ACCEPTANCE), caseToContactMap);
    }

    public static void sendNpInPortRejection(Map<Id, Id> caseToContactMap, String errCode) {
        String templateId = getTemplateIdByCode(errCode);
        if (templateId != null) {
            prepareAndSendEmailsForTemplate(templateId, caseToContactMap);
        } else {
            throw new EmailTemplateNotFoundException(ERR_MISSING_TEMPLATE + errCode);
        }
    }

    public static void sendNpInPortRejection(Map<Id, Id> caseToContactMap, Map<String, Set<Id>> freqErrToCasesMap) {
        // Process more pairs of caseId-contactId for various frequent error codes
        for (String errCode : freqErrToCasesMap.keySet()) {
            Set<Id> cIds = freqErrToCasesMap.get(errCode);
            Map<Id, Id> caseToContactMap2 = new Map<Id, Id>();
            for (Id caseId : cIds) {
                Id contId = caseToContactMap.get(caseId);
                if (contId != null) {
                    caseToContactMap2.put(caseId, contId);
                }
            }
            sendNpInPortRejection(caseToContactMap2, errCode);
        }
    }

    public static void sendConfirmNPOrderReminderRequest(Map<Id, clsNpBatchSendConfirmationReminderEmails.RmndrData> casesToRmndrData) {
        if (casesToRmndrData.size() > 10) {
            // SF: Total number of sendEmail methods allowed is 10 -> Batch Apex
            clsNpBatchSendConfirmationReminderEmails batch = new clsNpBatchSendConfirmationReminderEmails(casesToRmndrData);
            Database.executeBatch(batch, 10);
        } else {
            Map<Id, Id> tmplNotif_2_caseToContactMap = new Map<Id, Id>();
            Map<Id, Id> tmplNotif_0_2_caseToContactMap = new Map<Id, Id>();
            Map<Id, Id> tmplNotif_3_caseToContactMap = new Map<Id, Id>();
            Map<Id, Id> tmplNotif_0_3_caseToContactMap = new Map<Id, Id>();
            for (Id caseId : casesToRmndrData.keySet()) {
                clsNpBatchSendConfirmationReminderEmails.RmndrData rd = casesToRmndrData.get(caseId);
                if (rd.tmpl == TMPL_NOTIFICATION_2) {
                    tmplNotif_2_caseToContactMap.put(caseId, rd.contId);
                } else if (rd.tmpl == TMPL_NOTIFICATION_0_2) {
                    tmplNotif_0_2_caseToContactMap.put(caseId, rd.contId);
                } else if (rd.tmpl == TMPL_NOTIFICATION_3) {
                    tmplNotif_3_caseToContactMap.put(caseId, rd.contId);
                } else if (rd.tmpl == TMPL_NOTIFICATION_0_3) {
                    tmplNotif_0_3_caseToContactMap.put(caseId, rd.contId);
                }
            }
            if (!tmplNotif_2_caseToContactMap.isEmpty()) {
                prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_2), tmplNotif_2_caseToContactMap);
            }
            if (!tmplNotif_0_2_caseToContactMap.isEmpty()) {
                prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_2), tmplNotif_0_2_caseToContactMap);
            }
            if (!tmplNotif_3_caseToContactMap.isEmpty()) {
                prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_3), tmplNotif_3_caseToContactMap);
            }
            if (!tmplNotif_0_3_caseToContactMap.isEmpty()) {
                prepareAndSendEmailsForTemplate(getTemplateIdByName(TMPL_NOTIFICATION_0_3), tmplNotif_0_3_caseToContactMap);
            }
        }
    }

    /* Forwards Authorization for NP Inport received from Customer to the releasing operator */
    public static void sendNPInportAuthorization(String emailAddress, EmailMessage authorizationEmail, ID caseId) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Create a temporary Contact to be able to attach the forwarded auth. to the Case
        Contact cont = new Contact(FirstName='x', LastName='y'+caseId, Email=emailAddress, Phone='123');
        cont.Temporary_contact__c = true;
        insert cont;
        email.setTargetObjectId(cont.Id);
        email.setHtmlBody(authorizationEmail.HtmlBody);
        email.setPlainTextBody(authorizationEmail.TextBody);
        if (authorizationEmail.HtmlBody == null && authorizationEmail.TextBody == null) {
            // To avoid: 'System.EmailException: SendEmail failed. First exception on row 0;
            // first error: REQUIRED_FIELD_MISSING, Missing body, need at least one of html or plainText'
            email.setPlainTextBody('');
        }
        email.setSubject('Fwd: ' + authorizationEmail.Subject);
        email.setWhatId(caseId);
        SetDefaultPropertiesToEmail(email);

        clsNPEmailSender sender = new clsNPEmailSender(email);
        sender.sendMessage();
        delete cont; // delete the temporary Contact
    }

    public static void sendNPInportAuthorizationNoExtCustNum(
        String emailAddress, EmailMessage authorizationEmail, ID caseId, String extCustNum
    ) {
        // Forward the authorization without the external customer number
        EmailMessage em = new EmailMessage();
        clsNPEmailConfirmationParser.removeExtCustNum(em, authorizationEmail, extCustNum);
        em.Subject = authorizationEmail.Subject;
        sendNPInportAuthorization(emailAddress, em, caseId);
    }

    public static String getTemplateIdByCode(String code) {
        String retVal = null;
        if (code != null) {
            List<Number_Porting_Email_Templates__c> configs = Number_Porting_Email_Templates__c.getAll().values();
            for (Number_Porting_Email_Templates__c config : configs) {
                if (code.equals(config.Code__c)) {
                    retVal = config.Record_ID__c;
                    break;
                }
            }
        }
        return retVal;
    }

    public static String getTemplateIdByName(String name) {
        String retVal = null;
        Number_Porting_Email_Templates__c config = Number_Porting_Email_Templates__c.getInstance(name);
        if (config != null) {
            retVal = config.Record_ID__c;
        }
        return retVal;
    }

    /*
     * TESTS
     */
    public static testMethod void testSendConfirmNPOrderRequest() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'banana@banana.net';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;

        NP_Order__c order = new NP_Order__c();
        insert order;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.AccountId = acc.id;
        aCase.NP_Order__c = order.Id;
        insert aCase;

        Map<Id, Id> aMap = new Map<Id, Id>();
        aMap.put(aCase.Id, cnt.Id);
        sendConfirmNPOrderRequest(aMap);
    }

    public static testMethod void testSendNpInPortRejection() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'banana@banana.net';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;

        NP_Order__c order = new NP_Order__c();
        insert order;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.AccountId = acc.id;
        aCase.NP_Order__c = order.Id;
        insert aCase;

        Map<Id, Id> aMapCC = new Map<Id, Id>();
        aMapCC.put(aCase.Id, cnt.Id);
        Set<Id> aSet = new Set<Id>();
        aSet.add(aCase.Id);
        Map<String, Set<Id>> aMapFC = new Map<String, Set<Id>>();
        aMapFC.put('338', aSet);
        sendNpInPortRejection(aMapCC, aMapFC);
    }

    public static testMethod void testSendNPInportAuthorization() {
        String eAddr = 'banana@banana.net';
        EmailMessage eMsg = new EmailMessage(TextBody='Something...');
        Case aCase = new Case();
        insert(aCase);
        sendNPInportAuthorization(eAddr, eMsg, aCase.Id);
    }

    public static testMethod void testSendNPInportAuthorizationWithNoBody() {
        String eAddr = 'banana@banana.net';
        EmailMessage eMsg = new EmailMessage(TextBody=null);
        Case aCase = new Case();
        insert(aCase);
        sendNPInportAuthorization(eAddr, eMsg, aCase.Id);
    }

    public static testMethod void testSendNPInportAuthorizationNoExtCustNum() {
        String eAddr = 'banana@banana.net';
        EmailMessage eMsg = new EmailMessage(TextBody='Something...');
        Case aCase = new Case();
        insert(aCase);
        sendNPInportAuthorizationNoExtCustNum(eAddr, eMsg, aCase.Id, '1234');
    }

    public static testMethod void testNpEmailTemplates() {
        // Test Custom Settings: Number Porting Email Templates
        EmailTemplate[] ts = [SELECT Id, DeveloperName FROM EmailTemplate];
        Map<String, Id> tsMap = new Map<String, Id>();
        for (EmailTemplate t : ts) {
            tsMap.put(t.DeveloperName, t.Id);
        }
        // Check email teplates unrelated to OCH frequent errors
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_1), getTemplateIdByName(TMPL_NOTIFICATION_1));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_2), getTemplateIdByName(TMPL_NOTIFICATION_2));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_3), getTemplateIdByName(TMPL_NOTIFICATION_3));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_NO_DATA), getTemplateIdByName(TMPL_NOTIFICATION_NO_DATA));
        System.assertEquals(tsMap.get(TMPL_INPORT_ACCEPTANCE), getTemplateIdByName(TMPL_INPORT_ACCEPTANCE));
        System.assertEquals(tsMap.get(TMPL_INPORT_REJECTION_RMNDR), getTemplateIdByName(TMPL_INPORT_REJECTION_RMNDR));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_0_1), getTemplateIdByName(TMPL_NOTIFICATION_0_1));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_0_2), getTemplateIdByName(TMPL_NOTIFICATION_0_2));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_0_3), getTemplateIdByName(TMPL_NOTIFICATION_0_3));
        System.assertEquals(tsMap.get(TMPL_NOTIFICATION_0_NO_DATA), getTemplateIdByName(TMPL_NOTIFICATION_0_NO_DATA));
        // Check email teplates related to OCH frequent errors
        List<Number_Porting_Email_Templates__c> configs = Number_Porting_Email_Templates__c.getAll().values();
        NP_Error_Code__c[] eCodes = [SELECT Id, Name FROM NP_Error_Code__c WHERE Frequent_Code__c = true];
        for (NP_Error_Code__c eCode : eCodes) {
            System.assert(getTemplateIdByCode(eCode.Name) != null);
            for (Number_Porting_Email_Templates__c config : configs) {
                if (eCode.Name.equals(config.Code__c)) {
                    System.assertEquals(tsMap.get(config.Name), config.Record_ID__c);
                    break;
                }
            }
        }
    }
}