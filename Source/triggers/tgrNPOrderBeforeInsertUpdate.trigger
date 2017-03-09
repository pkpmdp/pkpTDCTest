trigger tgrNPOrderBeforeInsertUpdate on NP_Order__c (before insert, before update) {

    //Set<Id> casesToReconfirm = new Set<Id>();
    Set<Id> casesToApprove                 = new Set<Id>(); // Authorization_Approved__c == true
    Set<Id> casesToRejectOnNoAuthorization = new Set<Id>(); // Authorization_Deadline__c == null
    Map<Id, String> casesToUpdateStatus = new Map<Id, String>(); // <CaseId::Status>
    Map<String, ID> codeToId = new Map<String, ID>(); // <ExtOperatorCode::ExtOperatorId>
    Map<ID, NP_Operator__c> idToOperator = new Map<ID, NP_Operator__c>(); // <ExtOperatorId::ExtOperator>

    Set<Case> casesToBeUpdated = new Set<Case>();

    // Prepare translation (code -> ID and ID -> code) maps
    for (NP_Operator__c operator: [SELECT Id, Code__c, Email__c, Authorization_Required__c FROM NP_Operator__c]) {
        idToOperator.put(operator.Id, operator);
        codeToId.put(operator.Code__c, operator.Id);
    }

    if (Trigger.isInsert) {
        for (NP_Order__c order: Trigger.new) {
            // Keep the original NP Date value
            order.NP_Date_Original__c = order.NP_Date__c;

            // Try to translate
            if (order.External_Operator__c == null) {
                ID newOperatorId = codeToId.get(order.External_Operator_Code__c);
                if (newOperatorId != null) {
                    order.External_Operator__c = newOperatorId;
                }
            } else if (order.External_Operator_Code__c == null) {
                NP_Operator__c op = idToOperator.get(order.External_Operator__c);
                if (op != null && op.Code__c != null) {
                    order.External_Operator_Code__c = op.Code__c;
                }
            }
        }
    } else if (Trigger.isUpdate) {
        // Do we need a list of frequent codes?
        boolean isOCHError = false;
        for (NP_Order__c order: Trigger.new) {
            String errMsg = order.OCH_Error_Message__c;
            isOCHError = (errMsg != null) && (Trigger.oldMap.get(order.Id).OCH_Error_Message__c != errMsg);
            if (isOCHError) {
                break;
            }
        }
        // Prepare a list of all frequent codes
        Set<String> freqCodes = new Set<String>();
        if (isOCHError) {
            for (NP_Error_Code__c errCode : [SELECT Name FROM NP_Error_Code__c WHERE Frequent_Code__c = true]) {
                freqCodes.add(errCode.Name);
            }
        }

        // Do we need to collect emails?
        boolean isWeaselNew = false;
        for (NP_Order__c order: Trigger.new) {
            isWeaselNew = (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED &&
                Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED) ||
                (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED &&
                Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED &&
                order.OCH_Error_Message__c != null &&
                order.OCH_Error_Message__c.contains(clsCasesNpHandlerController.ERR_CODE_AUTO_RESUME_ON_REJECT)
            );
            if (isWeaselNew) {
                break;
            }
        }
        // Collect email messages
        Map<Id, EmailMessage> idToEmailMessage = new Map<Id, EmailMessage>(); // <EmailMessageId::EmailMessage>
        Set<ID> emailIds = new Set<ID>();
        if (isWeaselNew) {
            for (NP_Order__c order: Trigger.new) {
                if (order.Authorization_Email_ID__c != null) {
                    emailIds.add(order.Authorization_Email_ID__c);
                }
            }
            for (EmailMessage msg : [SELECT Id, HtmlBody, TextBody, Subject FROM EmailMessage WHERE Id IN :emailIds]) {
                idToEmailMessage.put(msg.Id, msg);
            }
        }

        // Prepare NP_Order to Case map. Assumes every NP Order has only one Case!
        Map<Id, Id> npOrderToCases = new Map<Id, Id>();
        Map<Id, String> npOrderToCaseType = new Map<Id, String>();
        Map<Id, String> npOrderToDKTVnr = new Map<Id, String>();
        Map<Id, Boolean> npOrderToDKTVflow = new Map<Id, Boolean>();
        for (NP_Order__c o : [SELECT id,
                (SELECT Case.id, Case.Type_Task__c, Case.NP_DKTV_Customer_Number__c, Case.NP_DKTV_Flow__c
                FROM NP_Order__c.Cases__r) 
            FROM NP_Order__c WHERE id IN :Trigger.newMap.keySet()]
        ) {
            for (Case c: o.Cases__r) {
                npOrderToCases.put(o.id, c.id);
                npOrderToCaseType.put(o.id, c.Type_Task__c);
                npOrderToDKTVnr.put(o.id, c.NP_DKTV_Customer_Number__c);
                npOrderToDKTVflow.put(o.id, c.NP_DKTV_Flow__c);
            }
        }

        // Prepare Cases (and related data) for validation
        Set<Id> case2vIds = new Set<Id>();
        Set<String> inCustNumbers = new Set<String>(); // CustomerNumber
        Map<Id, Case> caseIdToCase2v = new Map<Id, Case>(); // <CaseId::Case>
        Map<String, Account> custNrToAccount = new Map<String, Account>(); // <CustomerNumber::Account>
        Datetime workDay = null;
        for (NP_Order__c order: Trigger.new) {
            String caseType = npOrderToCaseType.get(order.id);
            // in-port orders
            if (caseType == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT) {
                if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED &&
                    Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER
                ) {
                    // This order needs validation of the related Case
                    case2vIds.add(npOrderToCases.get(order.id));
                    if (order.Current_Customer_Id__c != null) {
                        inCustNumbers.add(order.Current_Customer_Id__c);
                    }
                }
            }
        }
        if (!case2vIds.isEmpty()) {
            workDay = clsCasesNpHandlerController.computeFutureWorkingDate(Datetime.now(), 30);
            for (Case aCase:[SELECT Id, Status, Customer_Number__c, AccountId FROM Case WHERE Id IN :case2vIds]
            ) {
                caseIdToCase2v.put(aCase.Id, aCase);
            }
        }
        if (!inCustNumbers.isEmpty()) {
            for (Account acc:[SELECT Id, Customer_No__c FROM Account WHERE Customer_No__c IN :inCustNumbers]
            ) {
                custNrToAccount.put(acc.Customer_No__c, acc);
            }
        }

        // Prepare error code to NP Error Code map
        Map<String, NP_Error_Code__c> errorCodes = new Map<String, NP_Error_Code__c>();
        for (NP_Error_Code__c code: [Select Name, Days_To_Second_Reminder__c, Days_To_First_Reminder__c, 
            Days_To_Cancel_Order__c From NP_Error_Code__c]
        ) {
            errorCodes.put(code.Name, code);
        }

        // Get the configuration data to compute NP Launch and NP Alert dates
        Number_Porting_Configuration__c confLaunch = Number_Porting_Configuration__c.getInstance('INPORT_CUTOVER');
        // Get the configuration data to compute reminder dates
        Number_Porting_Configuration__c confReminder = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');

        for (NP_Order__c order: Trigger.new) {
            boolean toReqCancel = false;
            String caseType = npOrderToCaseType.get(order.id);
            // in-port orders
            if (caseType == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT) {
                // Request Cancellation of an in-port order
                if (order.Cancellation_Reason__c != null && (Trigger.oldMap.get(order.Id).Cancellation_Reason__c == null)) {
                    // Cancellation Reason has been set: update Status
                    String oldStatus = Trigger.oldMap.get(order.Id).Status__c;
                    if (oldStatus == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED ||
                        oldStatus == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED
                    ) {
                        toReqCancel = true;
                        order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION;
                        casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
                    } else {
                        order.addError(clsCasesNpHandlerController.ERR_NP_ACTION_NOT_APPLICABLE);
                    }
                }

                if (!toReqCancel) {
                    // Check cancel transitions
                    if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION ||
                        order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED
                    ) {
                        if (Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPLAUNCHMSG) {
                            // Near completion NP Case cannot be canceled
                            order.addError(clsCasesNpHandlerController.ERR_NPINPORT_CANNOT_CANCEL_LAUNCH);
                        }
                    }

                    /* ExtOperator modification by a user is out of scope - updated by CastIron from Weasel with createNumber
                    // Set correct value for ExtOperatorCode if a user modifies ExtOperator after a rejection
                    if (order.External_Operator__c != null &&
                        order.External_Operator__c != Trigger.oldMap.get(order.id).External_Operator__c &&
                        (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED ||
                        order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK ||
                        order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED)
                    ) {
                        NP_Operator__c op = idToOperator.get(order.External_Operator__c);
                        if (op != null && op.Code__c != null && order.External_Operator_Code__c != op.Code__c) {
                            order.External_Operator_Code__c = op.Code__c;
                        }
                    }
                    */

                    // New in-port order created in Weasel
                    if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED &&
                        Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED
                    ) {
                        // set ExtOperator based on the code received from Weasel
                        order.External_Operator__c = null;
                        NP_Operator__c op = idToOperator.get(codeToId.get(order.External_Operator_Code__c));
                        ID caseId = npOrderToCases.get(order.id);
                        if (op != null) {
                            order.External_Operator__c = op.Id;
                            if (op.Authorization_Required__c) {
                                boolean authOK = false;
                                if (order.Is_Never_Rejected__c) {
                                    // new in-port order: forward the authorization
                                    authOK = true;
                                } else {
                                    // resumed in-port order after rejection
                                    if (order.External_Operator_Code__c != null &&
                                        order.External_Operator_Code__c != Trigger.oldMap.get(order.id).External_Operator_Code__c
                                    ) {
                                        // ExtOperator has changed: forward the authorization
                                        authOK = true;
                                    }
                                }
                                if (authOK && order.Authorization_Email_ID__c != null) {
                                    // Is there any authorization to forward?
                                    EmailMessage email = idToEmailMessage.get(order.Authorization_Email_ID__c);
                                    if (email != null) {
                                        // forward the authorization to the releasing operator
                                        clsNPEmailSender.sendNPInportAuthorization(op.Email__c.trim(), email, caseId);
                                    }
                                }
                            }
                        } else {
                            // External operator cannot be identified: create Task for NP Power Group to fix the Operator table
                            System.debug('Authorization not sent: no external operator.');
                            clsCasesNpHandlerController.createTaskForPowerGroup(
                                clsCasesNpHandlerController.TASK_OBJECTIVE_ADDMISSINGOPERATOR, Date.today(), caseId
                            );
                            casesToUpdateStatus.put(caseId, clsCasesNpHandlerController.CASE_STATUS_NEW);
                        }
                    }
                    /* Multiple OCH errors are out of scope
                    // Pre-process a new OCH error message
                    String errMsg = order.OCH_Error_Message__c;
                    if (errMsg != null && Trigger.oldMap.get(order.Id).OCH_Error_Message__c != errMsg) {
                        // Error message has been modified - detect a rare code in
                        // <code1> - <message1>, <code2> - <message2>, .. , <code3> - <message3>
                        String theCode = errMsg.trim().substring(0, 3);
                        String[] codes = errMsg.split(',');
                        if (codes.size() > 1) {
                            // Set the first code if all codes are frequent or set the first rare code
                            for (Integer i=0; i<codes.size(); i++) {
                                String aCode = codes[i].trim().substring(0, 3);
                                if (!freqCodes.contains(aCode)) {
                                    theCode = aCode;
                                    break;
                                }
                            }
                            order.OCH_Error_Code__c = theCode;
                        }
                        if (order.OCH_Error_Code__c != null) {
                            order.Is_Frequent_Code__c = freqCodes.contains(order.OCH_Error_Code__c);
                        }
                    }
                    */

                    // Rejected orders will be updated with relevant Status based on the OCH error code
                    if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED &&
                        Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED
                    ) {
                        /* OCH Error Code extraction to be done first
                        String eCode = order.OCH_Error_Code__c;
                        NP_Error_Code__c errorCode = errorCodes.get(eCode);
                        if (errorCode == null) {
                            // an unknown error code - no such error code in the table NP_Error_Code__c
                            if (eCode != null) {
                                try {
                                    Integer.valueOf(eCode);
                                } catch (System.TypeException e1) {
                                    // the code is not a number, get the code from the message; it can be:
                                    // [Message.TelephoneNumber=25250002]: 334 - NumberType and TelephoneNumber do not match
                                    String eMessage = order.OCH_Error_Message__c.trim();
                                    if (eMessage.startsWith('[')) {
                                        Integer idx = eMessage.indexOf(']:');
                                        if (idx > 0) {
                                            eCode = eMessage.substring(idx+2).trim();
                                            if (eCode.length() >= 3) {
                                                eCode = eCode.substring(0, 3);
                                                try {
                                                    Integer.valueOf(eCode);
                                                    // if it is a number, set the new value for OCH Error Code
                                                    order.OCH_Error_Code__c = eCode;
                                                    order.Is_Frequent_Code__c = freqCodes.contains(eCode);
                                                } catch (System.TypeException e2) {
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        errorCode = errorCodes.get(order.OCH_Error_Code__c);
                        */
                        // Extract the error code out from the error message
                        order.OCH_Error_Code__c = null;
                        String eMsg = order.OCH_Error_Message__c != null ? order.OCH_Error_Message__c.trim() : '';
                        if (eMsg.length() >= 6) {
                            if (eMsg.substring(3, 6).equals(' - ')) {
                                // Error message format: <RejectCode> - <RejectText>
                                // Example: 338 - Telephone number not located at donor operator
                                order.OCH_Error_Code__c = eMsg.substring(0, 3);
                            } else {
                                // Error message format: <fieldname>: <Errorcode> - <ErrorText>
                                // Example: 66162638: 309 - The TelephoneNumber is present in another active flow
                                // Error message format: <Reject Message code>: <RejectCode> - <RejectText>
                                // Example: ???
                                Integer idx = eMsg.indexOf(': ');
                                if (idx > 0 && idx+5 <= eMsg.length()) {
                                    order.OCH_Error_Code__c = eMsg.substring(idx+2, idx+5);
                                }
                            }
                        }
                        System.debug('Rejection with error code: ' + order.OCH_Error_Code__c);
                        order.Is_Never_Rejected__c = false;
                        order.Is_Frequent_Code__c = freqCodes.contains(order.OCH_Error_Code__c);
                        NP_Error_Code__c errorCode = errorCodes.get(order.OCH_Error_Code__c);
                        if (order.OCH_Error_Code__c == clsCasesNpHandlerController.ERR_CODE_AUTO_RESUME_ON_REJECT) {
                            // The other operator does not support Customer ID validation:
                            // auto resume without the external customer number
                            String extCustNum = order.External_Customer_Number__c;
                            order.External_Customer_Number__c = null;
                            order.OCH_Error_Code__c = null;
                            order.OCH_Error_Message__c = null;
                            order.Is_Frequent_Code__c = false;
                            order.Order_Id__c = null;
                            order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
                            casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
                            NP_Operator__c op = idToOperator.get(codeToId.get(order.External_Operator_Code__c));
                            if (op != null) {
                                if (op.Authorization_Required__c && order.Authorization_Email_ID__c != null) {
                                    // Is there any authorization to forward?
                                    EmailMessage email = idToEmailMessage.get(order.Authorization_Email_ID__c);
                                    if (email != null) {
                                        // forward the authorization to the releasing operator without the external customer number
                                        ID caseId = npOrderToCases.get(order.id);
                                        if (extCustNum != null && extCustNum.trim().length() > 0) {
                                            // there is an external customer number to remove
                                            clsNPEmailSender.sendNPInportAuthorizationNoExtCustNum(op.Email__c.trim(), email, caseId, extCustNum);
                                        } else {
                                            // nothing to remove
                                            clsNPEmailSender.sendNPInportAuthorization(op.Email__c.trim(), email, caseId);
                                        }
                                    }
                                }
                            }
                        } else {
                            if (errorCode != null) {
                                // set feedback reminders based on the error code
                                order.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FEEDBACK_REQ;
                                order.First_Reminder_Date__c = DateTime.now().addDays(errorCode.Days_To_First_Reminder__c.intValue());
                                order.Second_Reminder_Date__c = DateTime.now().addDays(errorCode.Days_To_Second_Reminder__c.intValue());
                                order.Order_Close_Date__c = DateTime.now().addDays(errorCode.Days_To_Cancel_Order__c.intValue());
                            }
                            if (order.Is_Frequent_Code__c) {
                                // Frequent code
                                order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED;
                                casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
                            } else {
                                // Rare code
                                order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK;
                                casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NEW);
                            }
                        }
                    }

                    // Process manually confirmed orders: set reminders
                    if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION &&
                        Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE
                    ) {
                        Boolean isDKTVflow = npOrderToDKTVflow.get(order.id);
                        if (isDKTVflow != null && isDKTVflow) {
                            // The related customer is a DKTV customer
                            String DKTVnr = npOrderToDKTVnr.get(order.id);
                            if (DKTVnr != null && order.External_Customer_Number__c == null) {
                                // Set the external number if blank
                                order.External_Customer_Number__c = DKTVnr;
                            }
                            // Automatic confirm for an in-port of a DKTV customer phone number
                            order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
                        } else {
                            // Set confirmation reminders and send a confirmation request
                            clsCasesNpHandlerController.setConfirmationReminders(order, confReminder);
                        }
                    }

                    // Process accepted orders:
                    // set NP Launch and NP Alert dates based on NP Date and configuration
                    if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED) {
                        if (Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED) {
                            // Transition from Request Created to Request Accepted
                            order.NP_Launch_Date__c = clsCasesNpHandlerController.computeLaunchDate(order.NP_Date__c, confLaunch.First_Delay__c);
                            order.NP_Alert_Date__c = clsCasesNpHandlerController.computeAlertDate(order.NP_Date__c, confLaunch.Second_Delay__c);
                            // Erase error code fields (there could have been a rejection before)
                            order.OCH_Error_Code__c = null;
                            order.OCH_Error_Message__c = null;
                            order.Is_Frequent_Code__c = false;
                            // Case.Status should be set by CastIron
                        }
                    }
    
                    // Process orders to be closed due to no response from the customer
                    if (order.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED &&
                        Trigger.oldMap.get(order.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED
                    ) {
                        // Status is updated in Np-InportConfirmOrder TBWF together with InPortNotificationStatus update to 'Closed'
                        // order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED;
                        casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_CANCELLED);
                    } else if (order.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED_RF &&
                        Trigger.oldMap.get(order.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED_RF
                    ) {
                        order.Status__c = clsCasesNpHandlerController.NPO_STATUS_CLOSED;
                        casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_CLOSED);
                    }
                }
            } else { // out-port orders
                // Check close or cancel transitions
                if ((order.Status__c != Trigger.oldMap.get(order.id).Status__c) &&
                    (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION ||
                    order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED ||
                    order.Status__c == clsCasesNpHandlerController.NPO_STATUS_CLOSED)
                ) {
                    // NP out-port Cases cannot be canceled or closed directly;
                    // It can be only closed by a workflow when it has reached the OutPortConfirmed state
                    if (!(order.Status__c == clsCasesNpHandlerController.NPO_STATUS_CLOSED &&
                        Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTCONFIRMED)
                    ) {
                        Boolean allowClose = false;
                        if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_CLOSED) {
                            // Specific user(s) can directly close out-port flows
                            Set<String> userIds = new Set<String>();
                            for (Dataload_No_Outboud_Users__c uCS : Dataload_No_Outboud_Users__c.getAll().values()) {
                                userIds.add(uCS.User_Id__c);
                            }
                            allowClose = userIds.contains(UserInfo.getUserId());
                        }
                        if (!allowClose) {
                            order.addError(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_CANCEL);
                        }
                    }
                }

                // If order has been rejected, close the Case
                if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERREJECTED &&
                    (Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE ||
                     Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NEW ||
                     Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER
                    )
                ) {
                    order.Status__c = clsCasesNpHandlerController.NPO_STATUS_CLOSED;
                    casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_CLOSED);
                }

                // Validate a new out-port request
                if (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED &&
                    Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER
                ) {
                    // The Case record was created from an authorization after it is to be updated with an OCH request
                    List<NP_Order__c> toUpdateOrders = new List<NP_Order__c>(); // just an empty list
                    Case case2v = caseIdToCase2v.get(npOrderToCases.get(order.id));
                    String cStatus = case2v.Status; // to identify a modification
                    ID cAccId = case2v.AccountId; // to identify a modification
                    clsCasesNpHandlerController.validateNpCaseInTrigger(
                        order, case2v, toUpdateOrders, custNrToAccount, workDay
                    );
                    if (cStatus != case2v.Status || cAccId != case2v.AccountId) {
                        // The validated Case has been modified
                        casesToBeUpdated.add(case2v);
                    }
                }
            } // out-port orders

            if (!toReqCancel) {
                Datetime npDate = order.NP_Date__c;
                Datetime npDateOld = Trigger.oldMap.get(order.Id).NP_Date__c;
                if (npDate != null && npDateOld != null &&
                    !clsCasesNpHandlerController.compareDatetimeValues(npDate, npDateOld)
                ) {
                    // A new NP Date has been set
                    //if (order.NP_Launch_Date__c != null && !order.Authorization_Approved__c) {
                    if (caseType == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT) {
                        // This is an IN-PORT: update NP Launch and NP Alert dates based on NP Date and configuration
                        order.NP_Launch_Date__c = clsCasesNpHandlerController.computeLaunchDate(npDate, confLaunch.First_Delay__c);
                        order.NP_Alert_Date__c = clsCasesNpHandlerController.computeAlertDate(npDate, confLaunch.Second_Delay__c);
    
                        /* Kasia integration will handle this
                        // Create a new Task for 'power users' to notify internal systems on updated NP In-port date
                        clsCasesNpHandlerController.createTaskForPowerGroup(
                            clsCasesNpHandlerController.TASK_OBJECTIVE_NPDATE_2, Date.today(), caseId
                        );
                        */
                    } else if (order.Authorization_Approved__c && Trigger.oldMap.get(order.Id).Authorization_Approved__c) {
                        // This is an OUT-PORT to be reconfirmed
                        order.addError(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_RECONFIRM);
                        //casesToReconfirm.add(npOrderToCases.get(order.id));
                    }
                }
    
                // This code must be located before the code that is triggered by Disaproval Reason modification:
                // if (order.Disapproval_Reason__c != null && (Trigger.oldMap.get(order.Id).Disapproval_Reason__c == null))...
                if (!order.Authorization_Received__c && !order.Authorization_Approved__c &&
                    order.Disapproval_Reason__c == null && 
                    (order.Authorization_Deadline__c == null && (Trigger.oldMap.get(order.Id).Authorization_Deadline__c != null))
                ) {
                    // Authorization deadline reached: set the disapproval reson + update Case.Status
                    order.Disapproval_Reason__c = clsCasesNpHandlerController.ERR_376;
                }
    
                // This code must be located after the code that is triggered by reaching the Authorization Deadline:
                // (order.Authorization_Deadline__c == null && (Trigger.oldMap.get(order.Id).Authorization_Deadline__c != null)...
                if (order.Disapproval_Reason__c != null && (Trigger.oldMap.get(order.Id).Disapproval_Reason__c == null)) {
                    // Disapproval Reason has been set: update Status
                    if (order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE &&
                        order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NEW &&
                        order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER &&
                        order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT
                    ) {
                        order.addError(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_REJECT);
                    } else {
                        order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT;
                        casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
                    }
                }
    
                if (order.Authorization_Approved__c && !Trigger.oldMap.get(order.Id).Authorization_Approved__c) {
                    // Approved: update Case.Status
                    if (order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT) {
                        if (order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE &&
                            order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NEW &&
                            order.Status__c != clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER
                        ) {
                            order.addError(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_APPROVE);
                        } else {
                            order.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT;
                            casesToUpdateStatus.put(npOrderToCases.get(order.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
                        }
                    }
                }
    
                // Order authorized or customer rejection feedback received or resumed after rejection:
                // reset confirmation state to prevent sending out reminder emails
                if (((order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED ||
                    order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED ||
                    order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE) &&
                    Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION)
                    ||
                    ((order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED ||
                    order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED) &&
                    (Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED ||
                    Trigger.oldMap.get(order.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK))
                ) {
                    order.In_Port_Notification_Status__c = null;
                }
                // Canceled or closed order, reset confirmation state to prevent sending out reminder emails
                if ((order.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED &&
                    Trigger.oldMap.get(order.id).Status__c != clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED) ||
                    (order.Status__c == clsCasesNpHandlerController.NPO_STATUS_CLOSED &&
                    Trigger.oldMap.get(order.id).Status__c != clsCasesNpHandlerController.NPO_STATUS_CLOSED) &&
                    order.In_Port_Notification_Status__c != null
                ) {
                    order.In_Port_Notification_Status__c = null;
                }
            }
        }
    } // if (Trigger.isUpdate)

    // Update cases
    if (!casesToUpdateStatus.isEmpty()) {
        for (Case c: [SELECT Id, Status FROM Case WHERE id IN :casesToUpdateStatus.keySet()]) {
            String newStatus = casesToUpdateStatus.get(c.Id);
            if (newStatus == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                    c.Status = newStatus;
                    casesToBeUpdated.add(c);
                }
            } else if (newStatus == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                    c.Status = newStatus;
                    casesToBeUpdated.add(c);
                }
            } else if (newStatus == clsCasesNpHandlerController.CASE_STATUS_CLOSED) {
                if (c.Status != clsCasesNpHandlerController.CASE_STATUS_CLOSED) {
                    c.Status = newStatus;
                    casesToBeUpdated.add(c);
                }
            } else if (newStatus == clsCasesNpHandlerController.CASE_STATUS_CANCELLED) {
                if (c.Status != clsCasesNpHandlerController.CASE_STATUS_CANCELLED) {
                    c.Status = newStatus;
                    casesToBeUpdated.add(c);
                }
            }
        }
    }

    /*
    if (casesToReconfirm.size() > 0) {
        Case[] moreCasesToBeUpdated = [SELECT Status, NP_Order__c FROM Case WHERE Id IN :casesToReconfirm];
        for (Case c : moreCasesToBeUpdated) {
            if (c.Status != clsCasesNpHandlerController.CASE_STATUS_NPOUTPORTCONFIRMED &&
                c.Status != clsCasesNpHandlerController.CASE_STATUS_NPOUTPORTINCOMPLETE
            ) {
                Trigger.newMap.get(c.NP_Order__c).addError(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_RECONFIRM);
            } else {
                c.Status = clsCasesNpHandlerController.CASE_STATUS_NPOUTPORTACCEPT;
                casesToBeUpdated.add(c);
            }
        }
    }
    */

    try {
        if (casesToBeUpdated != null && !casesToBeUpdated.isEmpty()) {
            List<Case> lst = new List<Case>();
            lst.addAll(casesToBeUpdated);
            database.update(lst);
        }
    } catch(Exception e){       
        System.debug('Error updating Case: ' + e.getMessage());
    }
}