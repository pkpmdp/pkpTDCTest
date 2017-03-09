public class clsNPEmailConfirmationParser {

    public static final Pattern subjectPattern = Pattern.compile('^.*\\b[Jj][Aa]\\b.*$');
    public static final String SUBJECT_POSITIVE = 'SV: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee [ref:_00DS07Cnp._500S04EDsS:ref]';

    public static final Integer NO_DATA_LIMIT = 2;

    public static final Integer EXT_CUST_NUMBER_SIZE = 20;
    public static final Integer EXT_CUST_NAME_SIZE   = 100;

    // The following values must be present in e-mail templates 'Confirm Order Request Notification ...'
    public static final String TAG_A = '1) Nuværende teleselskab';
    public static final String TAG_B = '2) Kundenummer hos nuværende selskab';
    public static final String TAG_C = '3) Evt. anden ejer af det eksisterende telefoniabonnement';
    public static final String TAG_D = 'Telefonnummer der skal flyttes';

    // A container to store data to update an NP Order with
    private class AuthData {
        AuthData() {}
        AuthData(ID emailId, String extCustNumber, String extCustName) {
            this.emailId = emailId;
            this.extCustNumber = extCustNumber;
            this.extCustName = extCustName;
        }
        ID emailId {get; set;}
        String extCustNumber {get; set;}
        String extCustName {get; set;}
    }

    public void parseConfirmationEmail(Map <Id, List<EmailMessage>> caseToEmailsMap, List<Case> casesToProcess) {
        List<Case> updatedCases = new List<Case>();
        Map<Id, AuthData> npOrderToDecipher = new Map<Id, AuthData>(); // <NPOrderId::(emailId,extCustNumber,extCustName)>
        Map<Id, EmailMessage> npOrderToNotifyNoData = new Map<Id, EmailMessage>();

        if (caseToEmailsMap != null && !caseToEmailsMap.isEmpty()) {
            // Collect all relevant NP Order and Contact records
            Map<Id, NP_Order__c> npOrders = new Map<Id, NP_Order__c>();
            Map<Id, Id> caseToAccountMap = new Map<Id, Id>();
            Map<Id, Id> caseToContactMap = new Map<Id, Id>();
            Set<Id> orderIds = new Set<Id>();
            for (Case c : casesToProcess) {
                orderIds.add(c.NP_Order__c);
                caseToAccountMap.put(c.Id, c.AccountId);
            }
            for (NP_Order__c npOrder : [SELECT Id, NP_Date__c, Authorization_Email_ID__c,
                External_Operator__c, External_Operator_Code__c, External_Customer_Number__c,
                External_Customer_Name__c, Status__c, Counter_No_Data__c
                FROM NP_Order__c WHERE id IN :orderIds]
            ) {
                // Collect NP Order records
                npOrders.put(npOrder.Id, npOrder);
            }
            for (Contact cont : [SELECT Id, AccountId FROM Contact WHERE AccountId in :caseToAccountMap.values()]) {
                for (Id caseId : caseToAccountMap.keySet()) {
                    if (caseToAccountMap.get(caseId) == cont.AccountId) {
                        // Collect Contact records
                        caseToContactMap.put(caseId, cont.Id);
                        break;
                    }
                }
            }
            // Calculate the next business day
            Datetime nextWkDay = clsCasesNpHandlerController.computeFutureWorkingDate(DateTime.now(), 1);

            // Process incoming emails for each relevant case
            for (Case c : casesToProcess) {
                for (EmailMessage m : caseToEmailsMap.get(c.Id)) {
                    System.debug('Processing number porting reponse email for case: ' + m.ParentId);
                    String body = String.valueOf(m.TextBody);
                    boolean isAuthorized = parseSubject(m.Subject);
                    boolean isParseable = true; //isAuthorized;
                    boolean isLengthOK = true;
                    String extOperatorName = null;
                    String extCustNumber = null;
                    String extCustName = null;
                    if (isParseable) {
                        extOperatorName = parseMailTextBodyString(body, TAG_A, TAG_B);
                        isParseable = !TAG_A.equals(extOperatorName);
                    }
                    if (isParseable) {
                        extCustNumber = parseMailTextBodyString(body, TAG_B, TAG_C);
                        isParseable = !TAG_B.equals(extCustNumber);
                        if (isParseable && extCustNumber != null) {
                            // check length of the value from customer
                            isLengthOK = extCustNumber.length() <= EXT_CUST_NUMBER_SIZE;
                        }
                    }
                    if (isParseable) {
                        extCustName = parseMailTextBodyString(body, TAG_C, TAG_D);
                        isParseable = !TAG_C.equals(extCustName);
                        if (isParseable && isLengthOK && extCustName != null) {
                            // check length of the value from customer
                            isLengthOK = extCustName.length() <= EXT_CUST_NAME_SIZE;
                        }
                    }
                    boolean toUpdateCase = false;                    
                    NP_Order__c npOrder = npOrders.get(c.NP_Order__c);
                    if (isAuthorized && isParseable && (extOperatorName == null || extCustNumber == null)) {
                        System.debug('Result - Positive with no required info from customer for Case: ' + m.ParentId);
                        Integer cntNoData = npOrder.Counter_No_Data__c != null ? npOrder.Counter_No_Data__c.intValue() : 0;
                        if (npOrder.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION) {
                            // Update SPOC only if the case is not in manual handling
                            if (cntNoData < NO_DATA_LIMIT) {
                                // Within the limit: send the 'no data' notification
                                if (npOrder.NP_Date__c == null) {
                                    clsNPEmailSender.sendConfirmNPOrderRequest_Notification_No_Data_NoDate(caseToContactMap);
                                } else {
                                    clsNPEmailSender.sendConfirmNPOrderRequest_Notification_No_Data(caseToContactMap);
                                }
                                if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                                    c.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
                                    toUpdateCase = true;
                                }
                                npOrderToNotifyNoData.put(c.NP_Order__c, m);
                            } else {
                                // More than the limit of 'no data' notifications: needs manual handling
                                AuthData aData = new AuthData(m.Id, null, null);
                                // Collect all data that can be updated in SPOC
                                if (extCustNumber != null && (extCustNumber.length() <= EXT_CUST_NUMBER_SIZE)) {
                                    aData.extCustNumber = extCustNumber;
                                }
                                if (extCustName != null && (extCustName.length() <= EXT_CUST_NAME_SIZE)) {
                                    aData.extCustName = extCustName;
                                }
                                if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                                    c.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
                                    toUpdateCase = true;
                                }
                                npOrderToDecipher.put(c.NP_Order__c, aData);
                            }
                        }
                    } else if (isAuthorized && isParseable && isLengthOK && extOperatorName != null && extCustNumber != null) {
                        // Parseable and required data present and valid
                        if (npOrder.NP_Date__c == null || (Date.today() < npOrder.NP_Date__c.date())) {
                            System.debug('Result - Positive for Case: ' + m.ParentId);
                            // Update the NP Order + send the positive confirmation from the customer to the donor operator
                            clsCasesNpHandlerController.updateConfirmedOrder(npOrder, m, extCustNumber, extCustName);
                            if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                                c.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
                                toUpdateCase = true;
                            }
                        } else {
                            // Positive confirmation comes too late
                            System.debug('Result - Positive for Case but too late: ' + m.ParentId);
                            // make the NP date the next working day
                            npOrder.NP_Date__c = nextWkDay;
                            // Update the NP Order + send the positive confirmation from the customer to the donor operator
                            clsCasesNpHandlerController.updateConfirmedOrder(npOrder, m, extCustNumber, extCustName);
                            if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                                c.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
                                toUpdateCase = true;
                            }
                        }
                    } else {
                        // Not authorized or not parseable - requires manual resolution by CSR
                        System.debug('Result - Manual resolution for Case: ' + m.ParentId);
                        if (npOrder.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION) {
                            // Update SPOC only if the case is not in manual handling
                            AuthData aData = new AuthData();
                            aData.emailId = m.Id;
                            aData.extCustNumber = null;
                            aData.extCustName = null;
                            if (isParseable) {
                                // Collect all data that can be updated in SPOC
                                if (extCustNumber != null && (extCustNumber.length() <= EXT_CUST_NUMBER_SIZE)) {
                                    if (!extCustNumber.isAlphanumeric() && (extCustNumber.length() > 0)) {
                                        // remove the last char in case of a special char (SUPPORT-3948)
                                        extCustNumber = extCustNumber.substring(0, extCustNumber.length()-1);
                                    }
                                    aData.extCustNumber = extCustNumber;
                                }
                                if (extCustName != null && (extCustName.length() <= EXT_CUST_NAME_SIZE)) {
                                    aData.extCustName = extCustName;
                                }
                            }
                            if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                                c.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
                                toUpdateCase = true;
                            }
                            npOrderToDecipher.put(c.NP_Order__c, aData);
                        }
                    }
                    if (toUpdateCase) {
                        updatedCases.add(c);
                    }
                }
            }
        }

        if (updatedCases.size() > 0) {
            update updatedCases;
        }

        if (npOrderToNotifyNoData.size() > 0) {
            // Update NpOrder - set confirmation reminders + authorization e-mail ID
            Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
            List<NP_Order__c> orders = [
                SELECT id, Authorization_Email_ID__c, In_Port_Notification_Status__c, First_Reminder_Date__c,
                    Second_Reminder_Date__c, Order_Close_Date__c, Counter_No_Data__c
                FROM NP_Order__c WHERE id in :npOrderToNotifyNoData.keySet()
            ];
            Integer cntNoData = 0;
            for (NP_Order__c o: orders) {
                if (o.Counter_No_Data__c != null) {
                    cntNoData = o.Counter_No_Data__c.intValue();
                }
                o.Counter_No_Data__c = cntNoData + 1;
                clsCasesNpHandlerController.setConfirmationReminders(o, config);
                o.Authorization_Email_ID__c = npOrderToNotifyNoData.get(o.id).id;
            }
            update orders;
        }

        if (npOrderToDecipher.size() > 0) {
            // Update NpOrder
            List<NP_Order__c> orders = [
                SELECT id, Authorization_Email_ID__c, Status__c, External_Operator__c, External_Customer_Number__c,
                External_Customer_Name__c FROM NP_Order__c WHERE id in :npOrderToDecipher.keySet()
            ];
            for (NP_Order__c o: orders) {
                AuthData aData = npOrderToDecipher.get(o.id);
                o.Authorization_Email_ID__c = aData.emailId;
                if (aData.extCustNumber != null) {
                    o.External_Customer_Number__c = aData.extCustNumber;
                }
                if (aData.extCustName != null) {
                    o.External_Customer_Name__c = aData.extCustName;
                }
                o.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE;
            }
            update orders;
        }
    }

    private boolean parseSubject(String line) {
        // process the e-mail subject
        if (line != null && line.length() > 0) {
            Matcher positiveMatcher = subjectPattern.matcher(line);
            return positiveMatcher.matches();
        }
        return false;
    }

    private String parseMailTextBodyString(String body, String tagFrom, String tagTo) {
        // Parse a value located between given tags from a text e-mail body
        String retVal = tagFrom; // E-mail text body is not parseable
        Integer idx = (body == null) ? -1 : body.indexOf(tagFrom);
        if (idx < 0) {
            // not parseable
            return retVal;
        } else {
            String data = body.substring(idx + tagFrom.length());
            idx = data.indexOf(tagTo);
            if (idx < 0) {
                // not parseable
                return retVal;
            } else {
                data = data.substring(0, idx);
                retVal = null;
                if (data.length() > 0) {
                    List<String> lines = data.split('\n');
                    for (String line : lines) {
                        line = line.trim();
                        if (line.length() > 0) {
                            idx = 0;
                            String c = line.substring(idx, idx+1);
                            // ignore spaces and '>' chars
                            while (idx < line.length()-1 && (c == '>' || c == ' ')) {
                                idx++;
                                c = line.substring(idx, idx+1);
                            }
                            if ((c != '>' && c != ' ') && idx < line.length()) {
                                // a value found
                                retVal = line.substring(idx).trim();
                                break;
                            }
                        }
                    }
                }
                return retVal;
            }
            return null;
        }
    }

    public static void removeExtCustNum(EmailMessage targetEm, EmailMessage sourceEm, String extCustNum) {
        // Remove the external customer number value from both HtmlBody and TextBody
        String body = sourceEm.HtmlBody;
        if (body != null && body.indexOf(extCustNum) > 0) {
            targetEm.HtmlBody = removeFromBody(body, TAG_B, TAG_C, extCustNum);
        }
        body = sourceEm.TextBody;
        if (body != null && body.indexOf(extCustNum) > 0) {
            targetEm.TextBody = removeFromBody(body, TAG_B, TAG_C, extCustNum);
        }
    }

    public static String removeFromBody(String body, String tagBefore, String tagAfter, String token) {
        // Removes a string between given tags from a text or html e-mail body
        String retVal = body;
        Integer idx = body.indexOf(tagBefore);
        if (idx > 0) {
            idx += tagBefore.length();
            Integer i = body.indexOf(tagAfter, idx);
            if (i > idx) {
                retVal = body.substring(0, idx) +
                    body.substring(idx, i).replace(token, '') +
                    body.substring(i)
                ;
            }
        }
        return retVal;
    }

    /* 
     * --------------------------------------------------------------------
     * Test methods
     */
    public static EmailMessage prepareTestData(String aSubject, String aBody, Datetime npDate, Integer counter) {
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

        NP_Order__c o = new NP_Order__c();
        o.Telephone_Number__c = '911';
        o.Customer_Number__c = '666';
        o.NP_Date__c = npDate;
        o.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION;
        if (counter == 1) {
            // set the Counter_No_Data__c value as if the 1st email has been received already
            o.Counter_No_Data__c = Decimal.valueOf('1.0');
        } else if (counter == 2) {
            // set the Counter_No_Data__c value as if the 2nd email has been received already
            o.Counter_No_Data__c = Decimal.valueOf('2.0');
        }
        insert o;

        Case c = new Case();
        c.AccountId = acc.id;
        c.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        c.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        c.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        c.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        c.NP_Order__c = o.Id;
        insert c;

        EmailMessage m = new EmailMessage(TextBody=aBody);
        m.Subject = aSubject;
        m.Incoming = true;
        m.ParentId = c.id;
        insert m;

        return m;
    }

    public static EmailMessage prepareTestData(String aSubject, String aBody, Datetime npDate) {
        // No need to prepare a specific value for the Counter_No_Data__c field on NP Order
        return prepareTestData(aSubject, aBody, npDate, 0);
    }

    public static testmethod void testParsingAnswerWithNoBody() {
        Test.startTest();
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            null,
            null
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, NP_Date__c, Authorization_Email_ID__c, External_Operator__r.Name, External_Operator_Code__c,
                External_Customer_Number__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Customer_Number__c);
        System.assertEquals(null, dbOrder.External_Customer_Name__c);
        System.assertEquals(null, dbOrder.NP_Date__c);
    }

    public static testmethod void testParsingUnauthorizedParseablePlainTextAnswer() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '123456789';
        String extCustName = 'Gee Eye Jane';
        EmailMessage m = prepareTestData('Banana banana',
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke registreret ' +
            'ændringerne korrekt. ' + TAG_A + ' ' + extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' +
            TAG_C + ' ' + extCustName + ' ' + TAG_D + ' 12345678 * Oplysningerne kan du finde på din sidste ' +
            'telefonregning eller onlineopgørelse fra dit nuværende selskab. Vær opmærksom på, at du skal oplyse ' +
            'dit kundenummer; hvis du flytter dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            null
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, NP_Date__c, Authorization_Email_ID__c, External_Operator__r.Name, External_Operator_Code__c,
                External_Customer_Number__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(custNumber, dbOrder.External_Customer_Number__c);
        System.assertEquals(extCustName, dbOrder.External_Customer_Name__c);
        System.assertEquals(null, dbOrder.NP_Date__c);
    }

    public static testmethod void testParsingUnparseablePlainTextAnswer() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '123456789';
        String extCustName = 'Gee Eye Jane';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke registreret ' +
            'ændringerne korrekt. ' + TAG_A + ' ' + extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' +
            'TAG_C' + ' ' + extCustName + ' ' + TAG_D + ' 12345678 * Oplysningerne kan du finde på din sidste ' +
            'telefonregning eller onlineopgørelse fra dit nuværende selskab. Vær opmærksom på, at du skal oplyse ' +
            'dit kundenummer; hvis du flytter dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            Datetime.now()
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [SELECT id, Authorization_Email_ID__c, Status__c FROM NP_Order__c WHERE id = :dbCase.NP_Order__c];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswer() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '123456789';
        String extCustName = 'Gee Eye Jane';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter dit ' +
            'telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            null
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, NP_Date__c, Authorization_Email_ID__c, External_Operator__r.Name, External_Operator_Code__c,
                External_Customer_Number__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(custNumber, dbOrder.External_Customer_Number__c);
        System.assertEquals(extCustName, dbOrder.External_Customer_Name__c);
        //System.assert(dbOrder.NP_Date__c > Datetime.now().addDays(29));
        System.assertEquals(null, dbOrder.NP_Date__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerTooLate() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '123456789';
        String extCustName = 'Gee Eye Jane';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            Datetime.now().addDays(-1)
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, NP_Date__c, Authorization_Email_ID__c, External_Operator__r.Name, External_Operator_Code__c,
                External_Customer_Number__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(custNumber, dbOrder.External_Customer_Number__c);
        System.assertEquals(extCustName, dbOrder.External_Customer_Name__c);
        System.assert(dbOrder.NP_Date__c > Datetime.now());
    }

    public static testmethod void testParsingPositivePlainTextAnswerNoCustomerData_First() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = ' ';
        String extCustName = 'Gee Eye Jane';
        Date aDate = Date.today();
        String aBody = 'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.';
        String aSubject = SUBJECT_POSITIVE;

        // 1. inbound email message - mandatory data mising
        EmailMessage m = prepareTestData(aSubject, aBody, Datetime.now().addDays(2));
        Test.stopTest();

        Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
        Case dbCase = [SELECT Id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT Authorization_Email_ID__c, In_Port_Notification_Status__c, First_Reminder_Date__c,
                Second_Reminder_Date__c, Order_Close_Date__c, Status__c, Counter_No_Data__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM, dbOrder.In_Port_Notification_Status__c);
        System.assertEquals(aDate.addDays(config.First_Delay__c.intValue()), dbOrder.First_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Second_Delay__c.intValue()), dbOrder.Second_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Third_Delay__c.intValue()), dbOrder.Order_Close_Date__c.date());
        System.assertEquals(Decimal.valueOf('1.0'), dbOrder.Counter_No_Data__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerNoCustomerData_Second() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = ' ';
        String extCustName = 'Gee Eye Jane';
        Date aDate = Date.today();
        String aBody = 'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.';
        String aSubject = SUBJECT_POSITIVE;

        // 2. inbound email message - mandatory data mising
        // Prepare the data as if the first email has been received already
        EmailMessage m = prepareTestData(aSubject, aBody, Datetime.now().addDays(2), 1);
        Test.stopTest();

        Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
        Case dbCase = [SELECT Id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT Authorization_Email_ID__c, In_Port_Notification_Status__c, First_Reminder_Date__c,
                Second_Reminder_Date__c, Order_Close_Date__c, Status__c, Counter_No_Data__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM, dbOrder.In_Port_Notification_Status__c);
        System.assertEquals(aDate.addDays(config.First_Delay__c.intValue()), dbOrder.First_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Second_Delay__c.intValue()), dbOrder.Second_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Third_Delay__c.intValue()), dbOrder.Order_Close_Date__c.date());
        System.assertEquals(Decimal.valueOf('2.0'), dbOrder.Counter_No_Data__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerNoCustomerData_Third() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = ' ';
        String extCustName = 'Gee Eye Jane';
        Date aDate = Date.today();
        String aBody = 'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.';
        String aSubject = SUBJECT_POSITIVE;

        // 3. inbound email message - mandatory data mising
        // Prepare the data as if the second email has been received already
        EmailMessage m = prepareTestData(aSubject, aBody, Datetime.now().addDays(2), 2);
        Test.stopTest();

        Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
        Case dbCase = [SELECT Id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT Authorization_Email_ID__c, In_Port_Notification_Status__c, Counter_No_Data__c,
            External_Operator__r.Name, External_Operator_Code__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.In_Port_Notification_Status__c);
        System.assertEquals(Decimal.valueOf('2.0'), dbOrder.Counter_No_Data__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(extCustName, dbOrder.External_Customer_Name__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerNoExternalName() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '6';
        String extCustName = ' ';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            Datetime.now().addDays(2)
        );
        Test.stopTest();

        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, Authorization_Email_ID__c, External_Operator__r.Name, External_Operator_Code__c,
                External_Customer_Number__c, External_Customer_Name__c, Status__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(custNumber, dbOrder.External_Customer_Number__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerTooLongExternalNumber() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '1234567890 1234567890';
        String extCustName = 'Gee Eye Jane';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            Datetime.now().addDays(2)
        );
        Test.stopTest();
 
        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, Authorization_Email_ID__c, Status__c, External_Operator__r.Name,
                External_Operator_Code__c, External_Customer_Name__c, External_Customer_Number__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(null, dbOrder.External_Customer_Number__c);
        System.assertEquals(extCustName, dbOrder.External_Customer_Name__c);
    }

    public static testmethod void testParsingPositivePlainTextAnswerTooLongExternalName() {
        Test.startTest();
        String extOperatorName = 'xXx';
        String custNumber = '123456789';
        String extCustName = '1234567891 1234567892 1234567893 1234567894 1234567895 1234567896 1234567897 1234567898 1234567899 1234567890';
        EmailMessage m = prepareTestData(SUBJECT_POSITIVE,
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '123456789 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke ' + TAG_A + ' ' +
            extOperatorName + ' ' + TAG_B + ' ' + custNumber + ' ' + TAG_C + ' ' + extCustName + ' ' + TAG_D +
            ' 12345678 * Oplysningerne kan du finde på din sidste telefonregning eller onlineopgørelse fra ' +
            'dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit kundenummer; hvis du flytter ' +
            'dit telefonnummer fra TDC, skal du dog i stedet oplyse dit kontonummer.',
            Datetime.now().addDays(2)
        );
        Test.stopTest();
 
        Case dbCase = [SELECT id, Status, NP_Order__c FROM Case WHERE id = :m.ParentId];
        NP_Order__c dbOrder = [
            SELECT id, Authorization_Email_ID__c, Status__c, External_Operator__r.Name,
                External_Operator_Code__c, External_Customer_Name__c, External_Customer_Number__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE, dbOrder.Status__c);
        System.assertEquals(m.id, dbOrder.Authorization_Email_ID__c);
        System.assertEquals(null, dbOrder.External_Operator__r.Name);
        System.assertEquals(null, dbOrder.External_Operator_Code__c);
        System.assertEquals(custNumber, dbOrder.External_Customer_Number__c);
        System.assertEquals(null, dbOrder.External_Customer_Name__c);
    }

    public static testmethod void testRemoveExtCustNum() {
        String extCustNum = '1138687';
        String htmlBody =
            '<body bgcolor="#CCCCCC" lang=DA link=blue vlink=purple style=\'bLabel:body;bEditID:b1st1\'>' +
            '<div class=WordSection1><p class=MsoNormal><span style=\'font-size:11.0pt;font-family:"Calibri"' +
            ',"sans-serif";color:#1F497D\'><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span style=' +
            '\'font-size:11.0pt;font-family:"Calibri","sans-serif";color:#1F497D\'><o:p>&nbsp;</o:p></span>' +
            '</p><div><div style=\'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0cm 0cm 0cm\'>' +
            '<p class=MsoNormal><b><span lang=EN-US style=\'font-size:10.0pt;font-family:"Tahoma",' +
            '"sans-serif"\'>From:</span></b><span lang=EN-US style=\'font-size:10.0pt;font-family:"Tahoma",' +
            '"sans-serif"\'> Kundeservice [mailto:kundeservice@yousee.dk] <br><b>Sent:</b> 17. juni 2013 ' +
            '13:23<br><b>To:</b> Jens Jensen<br><b>Subject:</b> Sandbox: Ja, jeg vil gerne have overført ' +
            'mit telefonnummer 12345678 til YouSee [ref:_00DS07Cnp._500S04EDsS:ref]<o:p></o:p></span></p>' +
            '</div></div><p class=MsoNormal><o:p>&nbsp;</o:p></p><div align=center><table class=MsoNormalTable ' +
            'border=0 cellspacing=0 cellpadding=0 width=500 style=\'width:375.0pt\'><tr style=\'height:15.0pt' +
            '\'><td valign=top style=\'background:white;padding:0cm 0cm 0cm 0cm;height:15.0pt\'></td></tr>' +
            '<tr><td valign=top style=\'background:white;padding:0cm 0cm 0cm 0cm;bLabel:accent1;bEditID:r2st1' +
            '\'></td></tr><tr style=\'height:225.0pt\'><td valign=top style=\'background:white;padding:0cm ' +
            '0cm 0cm 0cm;height:225.0pt;bLabel:main;bEditID:r3st1\'><table class=MsoNormalTable border=0 ' +
            'cellspacing=5 cellpadding=0 width=550 style=\'width:412.5pt\'><tr style=\'height:300.0pt\'>' +
            '<td valign=top style=\'background:white;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:300.0pt\'>' +
            '<h1><span style=\'font-size:10.0pt;font-family:"Arial","sans-serif";color:black\'>Jens Jensen' +
            '</span><span style=\'font-family:"Arial","sans-serif";color:black\'><o:p></o:p></span></h1><h1>' +
            '<span style=\'font-size:10.0pt;font-family:"Arial","sans-serif";color:black\'>Testvej 21 <br>' +
            '0900 København C</span><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:' +
            'black;font-weight:normal\'><o:p></o:p></span></h1><h1><span style=\'font-size:10.0pt;font-family:' +
            '"Verdana","sans-serif";color:black;font-weight:normal\'>YouSee kundenummer: 611386872</span><span ' +
            'style=\'font-family:"Arial","sans-serif";color:black\'><o:p></o:p></span></h1><p class=western>' +
            '<strong><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>Må vi ' +
            'få din fuldmagt til at flytte dit nummer?</span></strong><b><span style=\'font-size:10.0pt;' +
            'font-family:"Verdana","sans-serif";color:black\'><br></span></b><span style=\'font-size:10.0pt;' +
            'font-family:"Verdana","sans-serif";color:black\'>For at få dit telefonnummer med over til os, ' +
            'skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab.<o:p></o:p></span>' +
            '</p><p class=western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black' +
            '\'><br><strong><span style=\'font-family:"Verdana","sans-serif"\'>Tryk ’Besvar’ og udfyld felterne' +
            '</span></strong><b><br></b>Du giver os din fuldmagt til at flytte dit telefonnummer ved at svare ' +
            'denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme felter i skemaet ' +
            'længere nede*.<o:p></o:p></span></p><p class=western style=\'margin-bottom:12.0pt\'><span style=' +
            '\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>&nbsp;<br>Hvis du gerne vil ' +
            'ændre nogle oplysninger, du tidligere har udfyldt, beder vi dig ringe til Kundeservice på 70 70 ' +
            '40 40 – ellers får vi ikke registreret ændringerne korrekt.<o:p></o:p></span></p><table class=' +
            'MsoNormalTable border=1 cellspacing=0 cellpadding=0 align=left width=653 style=\'width:489.75pt\'>' +
            '<tr><td width=311 valign=top style=\'width:233.25pt;padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class' +
            '=western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>1) Nuværende ' +
            'teleselskab </span><span style=\'font-family:"Verdana","sans-serif"\'><o:p></o:p></span></p></td><td ' +
            'width=312 valign=top style=\'width:234.0pt;padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=MsoNormal>' +
            '<span style=\'font-family:"Verdana","sans-serif";color:#1F497D\'>Waoo</span><span style=\'font-family' +
            ':"Verdana","sans-serif"\'><o:p></o:p></span></p></td></tr><tr><td width=311 valign=top style=\'width:' +
            '233.25pt;padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=western><span style=\'font-size:10.0pt;font-' +
            'family:"Verdana","sans-serif";color:black\'>2) Kundenummer hos nuværende selskab</span><span style=' +
            '\'font-family:"Verdana","sans-serif"\'><o:p></o:p></span></p></td><td width=312 valign=top style=' +
            '\'width:234.0pt;padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=MsoNormal><span style=\'font-family:' +
            '"Verdana","sans-serif";color:#1F497D\'>' + extCustNum + '</span><span style=\'font-family:"Verdana",' +
            '"sans-serif"\'><o:p></o:p></span></p></td></tr><tr><td width=311 valign=top style=\'width:233.25pt;' +
            'padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=western><span style=\'font-size:10.0pt;font-family:' +
            '"Verdana","sans-serif";color:black\'>3) Evt. anden ejer af det eksisterende telefoniabonnement</span>' +
            '<span style=\'font-family:"Verdana","sans-serif"\'> <o:p></o:p></span></p></td><td width=312 valign=' +
            'top style=\'width:234.0pt;padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=MsoNormal><span style=\'font' +
            '-family:"Verdana","sans-serif";color:#1F497D\'>Johnny</span><span style=\'font-family:"Verdana","sans' +
            '-serif"\'><o:p></o:p></span></p></td></tr><tr><td valign=top style=\'padding:5.25pt 5.25pt 5.25pt ' +
            '5.25pt\'><p class=MsoNormal><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif"\'>' +
            'Telefonnummer der skal flyttes</span><span style=\'font-family:"Verdana","sans-serif"\'><o:p></o:p>' +
            '</span></p></td><td valign=top style=\'padding:5.25pt 5.25pt 5.25pt 5.25pt\'><p class=MsoNormal>' +
            '<span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif"\'>12345678</span><span style=\'font' +
            '-family:"Verdana","sans-serif"\'><o:p></o:p></span></p></td></tr></table><p class=western><span style' +
            '=\'font-family:"Verdana","sans-serif";color:black\'><o:p>&nbsp;</o:p></span></p><p class=western>' +
            '<span style=\'font-size:7.5pt;font-family:"Verdana","sans-serif";color:black\'>* Oplysningerne kan ' +
            'du finde på din sidste telefonregning eller onlineopgørelse fra dit nuværende selskab. Vær opmærksom ' +
            'på, at du skal oplyse dit kundenummer; hvis du flytter dit telefonnummer fra TDC, skal du dog i ' +
            'stedet oplyse dit kontonummer.<br></span><span style=\'font-family:"Verdana","sans-serif";color:black' +
            '\'>&nbsp;<o:p></o:p></span></p><p class=western><span style=\'font-size:10.0pt;font-family:"Verdana",' +
            '"sans-serif";color:black\'>Du har bestilt at få flyttet dit nummer, når en eventuel bindingsperiode ' +
            'hos dit nuværende selskab er udløbet.</span><span style=\'font-family:"Verdana","sans-serif";color:' +
            'black\'><o:p></o:p></span></p><p class=western><span style=\'font-family:"Verdana","sans-serif";color:' +
            'black\'>&nbsp;<o:p></o:p></span></p><p class=western><span style=\'font-size:10.0pt;font-family:' +
            '"Verdana","sans-serif";color:black\'>Ved at returnere denne mail bekræfter jeg min tilladelse til at ' +
            'YouSee, på mine vegne og ifølge ovenstående specifikationer, må sige mit abonnement op hos min ' +
            'nuværende teleudbyder, for at flytte nummeret til YouSee.</span><span style=\'font-family:"Verdana",' +
            '"sans-serif";color:black\'><o:p></o:p></span></p><p class=western><span style=\'font-family:"Verdana",' +
            '"sans-serif";color:black\'>&nbsp;<o:p></o:p></span></p><p class=western><strong><span style=\'font-' +
            'size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>Vi sørger for resten</span></strong><b>' +
            '<span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'><br></span></b><span ' +
            'style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>Så snart vi har modtaget ' +
            'din bekræftende svarmail, bestiller vi opsigelse og flytning af dit nu-værende abonnement. Du skal ' +
            'derfor ikke selv kontakte dit nuværende teleselskab, det sørger vi for.</span><span style=\'font-' +
            'family:"Verdana","sans-serif";color:black\'><o:p></o:p></span></p><p class=western><span style=\'font' +
            '-family:"Verdana","sans-serif";color:black\'>&nbsp;<o:p></o:p></span></p><p class=western><span style=' +
            '\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>Derefter opretter vi dit nye ' +
            'Telefoni-abonnement og sender dig information om, på hvilken dag dit nye abonnement vil være aktivt. ' +
            '</span><span style=\'font-family:"Verdana","sans-serif";color:black\'><o:p></o:p></span></p><p class=' +
            'western><span style=\'font-family:"Verdana","sans-serif";color:black\'>&nbsp;<o:p></o:p></span></p><p ' +
            'class=western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>Der er ' +
            'to punkter, vi beder dig være opmærksom på:</span><span style=\'font-family:"Verdana","sans-serif";' +
            'color:black\'><o:p></o:p></span></p><p class=western><span style=\'font-size:10.0pt;font-family:' +
            '"Verdana","sans-serif";color:black\'><br>•&nbsp;Har du serviceaftaler? Abonnements- og serviceaftaler ' +
            'på telefoner, fax m.m. kan ikke flytte med over til os og vil blive sagt op.<o:p></o:p></span></p><p ' +
            'class=western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>•&nbsp;' +
            'Fortryder du? Du kan fortryde din bestilling af Telefoni indtil 14 dage efter, du har modtaget en ' +
            'ordrebekræftelse fra os.</span><span style=\'font-family:"Verdana","sans-serif";color:black\'><o:p>' +
            '</o:p></span></p><p class=western><span style=\'font-family:"Verdana","sans-serif";color:black\'>&nbsp;' +
            '<o:p></o:p></span></p><p class=western><strong><span style=\'font-size:10.0pt;font-family:"Verdana",' +
            '"sans-serif";color:black\'>Har du spørgsmål?</span></strong><b><span style=\'font-size:10.0pt;font-' +
            'family:"Verdana","sans-serif";color:black\'><br></span></b><span style=\'font-size:10.0pt;font-family:' +
            '"Verdana","sans-serif";color:black\'>Du er velkommen til at ringe til os på <strong><span style=\'font' +
            '-family:"Verdana","sans-serif"\'>70 70 40 40</span></strong> på hverdage mellem kl. 8.00 og 18.30. ' +
            'Måske kan du også finde svar på <a href="http://yousee.dk/telefoni"><strong><span style=\'font-family:' +
            '"Verdana","sans-serif";color:#006600\'>yousee.dk/telefoni</span></strong></a>?</span><span style=\'font' +
            '-family:"Verdana","sans-serif";color:black\'><o:p></o:p></span></p><p class=western><span style=\'font' +
            '-size:8.0pt;font-family:"Verdana","sans-serif";color:black\'><br></span><span style=\'font-size:10.0pt;' +
            'font-family:"Verdana","sans-serif";color:black\'>Venlig hilsen</span><span style=\'font-size:8.0pt;font' +
            '-family:"Verdana","sans-serif";color:black\'><o:p></o:p></span></p><p class=western><span style=\'font' +
            '-size:8.0pt;font-family:"Verdana","sans-serif";color:black\'>&nbsp;<o:p></o:p></span></p><p class=' +
            'western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>YouSee A/S' +
            '</span><span style=\'font-family:"Verdana","sans-serif";color:black\'><o:p></o:p></span></p><p class=' +
            'western><span style=\'font-family:"Verdana","sans-serif";color:black\'><o:p>&nbsp;</o:p></span></p><p ' +
            'class=western><span style=\'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black\'>[ref:_' +
            '00DS07Cnp._500S04EDsS:ref]</span><span style=\'font-family:"Verdana","sans-serif";color:black\'><o:p>' +
            '</o:p></span></p></td></tr></table></td></tr><tr><td valign=top style=\'background:white;padding:0cm ' +
            '0cm 0cm 0cm;bLabel:accent2;bEditID:r4st1\'></td></tr><tr style=\'height:15.0pt\'><td valign=top style=' +
            '\'background:white;padding:0cm 0cm 0cm 0cm;height:15.0pt;bLabel:footer;bEditID:r5st1\'></td></tr><tr>' +
            '<td valign=top style=\'background:white;padding:0cm 0cm 0cm 0cm;bLabel:accent3;bEditID:r6st1\'></td>' +
            '</tr></table></body>'
        ;
        String textBody =
            'From: Kundeservice [mailto:kundeservice@yousee.dk] Sent: 17. juni 2013 13:23 To: Jens Jensen ' +
            'Subject: Sandbox: Ja, jeg vil gerne have overført mit telefonnummer 12345678 til YouSee ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref] Jens Jensen Testvej 21 0900 København C YouSee kundenummer: ' +
            '611386872 Må vi få din fuldmagt til at flytte dit nummer? For at få dit telefonnummer med ' +
            'over til os, skal vi sige dit nuværende telefoniabonnement op hos dit nuværende teleselskab. ' +
            'Tryk ’Besvar’ og udfyld felterne Du giver os din fuldmagt til at flytte dit telefonnummer ' +
            'ved at svare denne mail, som du plejer at svare en mail, og derefter udfylde de fire tomme ' +
            'felter i skemaet længere nede*. Hvis du gerne vil ændre nogle oplysninger, du tidligere har ' +
            'udfyldt, beder vi dig ringe til Kundeservice på 70 70 40 40 – ellers får vi ikke registreret ' +
            'ændringerne korrekt. 1) Nuværende teleselskab Waoo 2) Kundenummer hos nuværende selskab ' +
            extCustNum + ' 3) Evt. anden ejer af det eksisterende telefoniabonnement Johnny Telefonnummer ' +
            'der skal flyttes  12345678 * Oplysningerne kan du finde på din sidste telefonregning ' +
            'eller onlineopgørelse fra dit nuværende selskab. Vær opmærksom på, at du skal oplyse dit ' +
            'kundenummer; hvis du flytter dit telefonnummer fra TDC, skal du dog i stedet oplyse dit ' +
            'kontonummer. Du har bestilt at få flyttet dit nummer, når en eventuel bindingsperiode hos dit ' +
            'nuværende selskab er udløbet. Ved at returnere denne mail bekræfter jeg min tilladelse til at ' +
            'YouSee, på mine vegne og ifølge ovenstående specifikationer, må sige mit abonnement op hos min ' +
            'nuværende teleudbyder, for at flytte nummeret til YouSee. Vi sørger for resten Så snart vi har ' +
            'modtaget din bekræftende svarmail, bestiller vi opsigelse og flytning af dit nu-værende ' +
            'abonnement. Du skal derfor ikke selv kontakte dit nuværende teleselskab, det sørger vi for. ' +
            'Derefter opretter vi dit nye Telefoni-abonnement og sender dig information om, på hvilken dag ' +
            'dit nye abonnement vil være aktivt. Der er to punkter, vi beder dig være opmærksom på: • Har du ' +
            'serviceaftaler? Abonnements- og serviceaftaler på telefoner, fax m.m. kan ikke flytte med over ' +
            'til os og vil blive sagt op. • Fortryder du? Du kan fortryde din bestilling af Telefoni indtil ' +
            '14 dage efter, du har modtaget en ordrebekræftelse fra os. Har du spørgsmål? Du er velkommen ' +
            'til at ringe til os på 70 70 40 40 på hverdage mellem kl. 8.00 og 18.30. Måske kan du også ' +
            'finde svar på yousee.dk/telefoni <http://yousee.dk/telefoni> ? Venlig hilsen YouSee A/S ' +
            '[ref:_00DS07Cnp._500S04EDsS:ref]'
        ;
        EmailMessage emIn = new EmailMessage();
        emIn.TextBody = textBody;
        emIn.HtmlBody = htmlBody;
        EmailMessage emOut = new EmailMessage();
        removeExtCustNum(emOut, emIn, extCustNum);
        // was the external customer number removed from the html body?
        System.assertEquals(emIn.HtmlBody.length() - emOut.HtmlBody.length(), extCustNum.length());
        // is the external customer number value present in the html body (as a part of YouSee kundenummer value)?
        Integer idx = emOut.HtmlBody.indexOf(extCustNum);
        System.assert(idx > 0);
        // was the external customer number removed from the text body?
        System.assertEquals(emIn.TextBody.length() - emOut.TextBody.length(), extCustNum.length());
        // is the external customer number value present in the text body (as a part of YouSee kundenummer value)?
        idx = emOut.TextBody.indexOf(extCustNum);
        System.assert(idx > 0);
    }
}