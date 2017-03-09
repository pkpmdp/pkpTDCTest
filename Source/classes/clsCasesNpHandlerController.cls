public class clsCasesNpHandlerController {

    // BusinessHours to use for next business day computation
    public static final String BUSINESS_HOURS_YK = 'Sales Business Hours';

    // NP Order Status values - must be the same as in the NP Order object set-up
    public static final String NPO_STATUS_NPORDERARRIVED = 'NP Order Arrived';
    public static final String NPO_STATUS_CLOSED         = 'Closed';
    public static final String NPO_STATUS_NPORDERINCOMPLETE           = 'NP Order Incomplete';
    public static final String NPO_STATUS_NPORDERCANCELED             = 'NP Order Canceled';
    public static final String NPO_STATUS_NPINPORTCONFIRMED           = 'NP In-port Confirmed';
    public static final String NPO_STATUS_NPORDERREQUESTCANCELLATION  = 'NP Request Cancellation';
    public static final String NPO_STATUS_NPREQUESTCONFIRMATION       = 'NP Request Confirmation';
    public static final String NPO_STATUS_NPREQUESTCREATED            = 'NP Request Created';
    public static final String NPO_STATUS_NPREQUESTACCEPTED           = 'NP Request Accepted';
    public static final String NPO_STATUS_NPREQUESTREJECTED           = 'NP Request Rejected';
    public static final String NPO_STATUS_NPDECIPHERRESPONSE          = 'NP Decipher Confirmation Response';
    public static final String NPO_STATUS_NPFEEDBACKREQUESTED         = 'NP Feedback Requested';
    public static final String NPO_STATUS_NPREQUESTFEEDBACK           = 'NP Request Feedback';
    public static final String NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED = 'NP Rejection Feedback Received';
    public static final String NPO_STATUS_NPLAUNCHMSG                 = 'NP Launch Msg';
    public static final String NPO_STATUS_NEW                   = 'New';
    public static final String NPO_STATUS_NPAUTHORIZATIONLETTER = 'NP Authorization Letter';
    public static final String NPO_STATUS_NPOUTPORTINCOMPLETE   = 'NP Out-port Incomplete';
    public static final String NPO_STATUS_NPOUTPORTCONFIRMED    = 'NP Out-port Confirmed';
    public static final String NPO_STATUS_NPOUTPORTACCEPT       = 'NP Out-port Accept';
    public static final String NPO_STATUS_NPOUTPORTREJECT       = 'NP Out-port Reject';
    public static final String NPO_STATUS_NPORDERREJECTED       = 'NP Order Rejected';

    // These must be the same values as in the Case object set-up
    public static final String CASE_DEPARTMENT_NPIMPORT = 'YKRB';
    public static final String CASE_DEPARTMENT_NPEXPORT = CASE_DEPARTMENT_NPIMPORT;
    public static final String CASE_PRODUCT_NPIMPORT    = 'Telephony YKRB';
    public static final String CASE_PRODUCT_NPEXPORT    = CASE_PRODUCT_NPIMPORT;
    public static final String CASE_TYPETASK_NPIMPORT   = 'NP in-port';
    public static final String CASE_TYPETASK_NPEXPORT   = 'NP out-port';
    public static final String CASE_ORIGIN_WEB          = 'Web';
    public static final String CASE_STATUS_NEW         = 'New';
    public static final String CASE_STATUS_CLOSED      = 'Closed';
    public static final String CASE_STATUS_NPRESERVED  = 'NP Reserved';
    public static final String CASE_STATUS_CANCELLED = 'Cancelled';
//    public static final String CASE_STATUS_NPLAUNCH    = 'NP Launch';
//    public static final String CASE_STATUS_NPLAUNCHED  = 'NP Launched';

    // Case Record Types
    public static final String RT_NPINPORTCASEOPEN             = 'CASE_RT_NPINPORTCASEOPEN'; // 'NP In-port Case Open'
    public static final String RT_NPINPORTCASEINCOMPLETE       = 'CASE_RT_NPINPORTCASEINCOMPLETE'; // 'NP In-port Case Incomplete'
    public static final String RT_NPINPORTCASECANCELED         = 'CASE_RT_NPINPORTCASECANCELED'; // 'NP In-port Case Canceled'
    public static final String RT_NPINPORTCASEDECIPHER         = 'CASE_RT_NPINPORTCASEDECIPHER'; // 'NP In-port Case - Decipher Confirmation Response'
    public static final String RT_NPINPORTCASEOCHRESPONSE      = 'CASE_RT_NPINPORTCASEOCHRESPONSE'; // 'NP In-port Case OCH Response'
    public static final String RT_NPINPORTCASEREQUESTFEEDBACK  = 'CASE_RT_NPINPORTCASEREQUESTFEEDBACK'; // 'NP In-port Case Request Rejection Feedback'
    public static final String RT_NPINPORTCASEFEEDBACKRECEIVED = 'CASE_RT_NPINPORTCASEFEEDBACKRECEIVED'; // 'NP In-port Case Rejection Feedback Received'
    public static final String RT_NPINPORTCASELAUNCHED         = 'CASE_RT_NPINPORTCASELAUNCHED'; // 'NP In-port Case Launched'
    public static final String RT_NPINPORTCASECLOSED           = 'CASE_RT_NPINPORTCASECLOSED'; // 'NP In-port Case Closed'
    public static final String RT_NPOUTPORTCASEOPEN      = 'CASE_RT_NPOUTPORTCASEOPEN'; // 'NP Out-port Case Open'
    public static final String RT_NPOUTPORTCASEREJECTED  = 'CASE_RT_NPOUTPORTCASEREJECTED'; // 'NP Out-port Case Rejected'
    public static final String RT_NPOUTPORTCASECONFIRMED = 'CASE_RT_NPOUTPORTCASECONFIRMED'; // 'NP Out-port Case Confirmed'
    public static final String RT_NPOUTPORTCASECLOSED    = 'CASE_RT_NPOUTPORTCASECLOSED'; // 'NP Out-port Case Closed'

    public static final String RT_NPOPEN_IN  = 'CASE_RT_NPOPEN_IN'; // 'NP In-port Open Case' (NP In-port Open Case Layout)
    public static final String RT_NPOPEN_OUT = 'CASE_RT_NPOPEN_OUT'; // 'NP Out-port Open Case' (NP Out-port Open Case Layout)
    public static final String RT_NPQUEUE    = 'CASE_RT_NPQUEUE'; // 'NP Queue Owned Case' (NP Queue Layout)
    public static final String RT_NPCLOSED   = 'CASE_RT_NPCLOSED'; // 'NP Closed Case' (NP Closed Case Layout)
    public static final String RT_OPEN   = 'CASE_RT_OPEN'; // 'Open Case' (Open Case Layout)
    public static final String RT_QUEUE  = 'CASE_RT_QUEUE'; // 'Queue Owned Case' (Queue Layout)
    public static final String RT_CLOSED = 'CASE_RT_CLOSED'; // 'Closed Case' (Closed Case Layout)

    //NP Task related constants
    //public static final String TASK_OBJECTIVE_CANCELSUBSCRIPTION   = 'Cancel Subscription in Triple/Casper';
    //public static final String TASK_OBJECTIVE_NPDATE               = 'Notify Internal Systems on NP Date';
    //public static final String TASK_OBJECTIVE_NPDATE_2             = 'Notify Internal Systems on Updated NP Date';
    //public static final String TASK_OBJECTIVE_EXECUTENUMBEROUTPORT = 'Phone Number Should Be Blocked in Internal Systems';
    public static final String TASK_OBJECTIVE_ADDMISSINGOPERATOR = System.Label.NP_Task_Add_Missing_Operator;
                                                                    //'External Operator Data Missing';
    public static final String TASK_OBJECTIVE_TOOLATETOCONFIRM   = System.Label.NP_Task_Too_Late_To_Confirm;
                                                                    // 'Customer Did Not Confirm Before NP Date';
    public static final String TASK_OBJECTIVE_NORESPONSEORERROR  = System.Label.NP_Task_No_Response_Or_Error;
                                                                    // 'CastIron Not Responding Or An Integration Error Reported';
    public static final String TASK_OBJECTIVE_INVALIDEMAILADDRESS= System.Label.NP_Task_Invalid_Email_Address;
                                                                    // 'Customers email address is missing or not valid';
    public static final String TASK_PRIORITY = 'High';
    public static final String TASK_SUBJECT = 'Opfølgning';
    public static final String TASK_TYPE = 'Andet';
    public static final String TASK_NPGROUP = 'NP Power Group';

    // NP Task Record Type
    public static final String RT_NPTASK = 'TASK_RT_NPTASK'; // 'NP Opgave'

    //NP Order constants
    public static final String NP_ORDER_INPORT_STATUS_CONFIRM = 'Confirmation Letter';
    public static final String NP_ORDER_INPORT_STATUS_FIRST = 'First Reminder';
    public static final String NP_ORDER_INPORT_STATUS_SECOND = 'Second Reminder';
    public static final String NP_ORDER_INPORT_STATUS_CLOSED = 'Closed';
    
    public static final String NP_ORDER_INPORT_STATUS_FEEDBACK_REQ = 'Feedback Requested';
    public static final String NP_ORDER_INPORT_STATUS_FIRST_RF = 'First Reminder RF';
    public static final String NP_ORDER_INPORT_STATUS_SECOND_RF = 'Second Reminder RF';
    public static final String NP_ORDER_INPORT_STATUS_CLOSED_RF = 'Closed RF';

    public static final String PARAM_CASE_ID = 'caseId';

    public static final String ERR_CODE_AUTO_RESUME_ON_REJECT = '398'; // SPOC-733 issue

    // Error messages
    //public static final String ERR_NPOUTPORT_VALIDATION_FAILED = ' Order rejected - mandatory field(s) missing';
    //public static final String ERR_NPINPORT_OPERATOR_NOT_FOUND = ' Operator was not found or Email message related to the Case was not found.';
    //public static final String ERR_NPOUTPORT_CANNOT_RECONFIRM  = ' Incorrect Case Status to set another NP Date.';
    public static final String ERR_NPOUTPORT_APPROVAL_FAILED  = ' Approval failed! Please check approval checkboxes on NP Order first.';
    public static final String ERR_NPOUTPORT_REJECTION_FAILED = ' Rejection failed! Please select a Disapproval Reason on NP Order first.';
    public static final String ERR_NPINPORT_OCH_REQUEST_FIRST = ' Response failed! Please send the request to OCH first.';

    public static final String ERR_NPINPORT_RESUME_FAILED        = System.Label.NP_Error_Resume_Failed;
                                        //' Resume failed! Please specify Telephone Number, Customer Number and Customer Name on NP Order first.';
    public static final String ERR_NPINPORT_CANNOT_CANCEL_AGAIN  = System.Label.NP_Error_Cannot_Cancel_Again;
                                        //' Closed or canceled NP in-port Case cannot be canceled.';
    public static final String ERR_NPINPORT_CANNOT_CANCEL_LAUNCH = System.Label.NP_Error_Cannot_Cancel_When_Launched;
                                        //' Completed NP in-port Case cannot be canceled.';
    public static final String ERR_NPOUTPORT_CANNOT_CANCEL       = System.Label.NP_Error_Cannot_Cancel_Outport;
                                        //' NP out-port Cases cannot be canceled or closed directly.';
    public static final String ERR_NPINPORT_UNKNOWN_ERROR_CODE   = System.Label.NP_Error_Unknown_OCH_Error_Code;
                                        //' Unknown error code from OCH: ';
    public static final String ERR_NPOUTPORT_CANNOT_RECONFIRM    = System.Label.NP_Error_Cannot_Reconfirm_Outport;
                                        //' NP out-port Case cannot be reconfirmed.';
    public static final String ERR_NPOUTPORT_CANNOT_REJECT       = System.Label.NP_Error_Cannot_Reject_Outport;
                                        //' Incorrect Case Status to set the Disapproval Reason value.';
    public static final String ERR_NPOUTPORT_CANNOT_APPROVE      = System.Label.NP_Error_Cannot_Approve_Outport;
                                        //' Incorrect Case Status to approve the Authorization.';
    public static final String ERR_NPINPORT_CANNOT_CONFIRM       = System.Label.NP_Error_Cannot_Confirm_Inport;
                                        //' Confirm failed! Please specify Telephone Number, Customer Number and Customer Name on NP Order first.';
    public static final String ERR_NP_ACTION_NOT_APPLICABLE      = System.Label.NP_Error_Action_Not_Applicable_In_State;
                                        //' Action is not applicable in the current state.';

    // Disapproval reasons for automatic rejections (picklist)
    public static final String ERR_330 = 'R330 - The number type II configuration does not match donor’s registration.';
    public static final String ERR_339 = 'R339 - The Customer ID does not match the telephone number.';
    public static final String ERR_349 = 'R349 - The telephone number is not active at the donor operator.';
    public static final String ERR_376 = 'R376 - Written termination not received by Donor within timeframe.';

    private ApexPages.standardController controller {get; set;}
    private Case aCase;

    public clsCasesNpHandlerController(ApexPages.StandardController stdController) {
        controller = stdController;
        aCase = (Case) controller.getRecord();
    }

    public PageReference cancelCloseNp() {
        // Set the values for Status
        Case dbCase = [SELECT Status, Type_Task__c, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        NP_Order__c npOrder = [SELECT Id, Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT &&
            (npOrder.Status__c == NPO_STATUS_NPORDERINCOMPLETE ||
            npOrder.Status__c == NPO_STATUS_NPREQUESTCONFIRMATION ||
            npOrder.Status__c == NPO_STATUS_NPDECIPHERRESPONSE)
        ) {
            // CANCEL
            if (dbCase.Status != CASE_STATUS_CANCELLED) {
                dbCase.Status = CASE_STATUS_CANCELLED;
                update dbCase;
            }
            npOrder.Status__c = NPO_STATUS_NPORDERCANCELED;
            update npOrder;
            return new PageReference('/' + dbCase.Id);
        } else if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT &&
            (npOrder.Status__c == NPO_STATUS_NPREQUESTFEEDBACK ||
            npOrder.Status__c == NPO_STATUS_NPFEEDBACKREQUESTED ||
            npOrder.Status__c == NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED)
        ) {
            // CLOSE
            if (dbCase.Status != CASE_STATUS_CLOSED) {
                dbCase.Status = CASE_STATUS_CLOSED;
                update dbCase;
            }
            npOrder.Status__c = NPO_STATUS_CLOSED;
            update npOrder;
            return new PageReference('/' + dbCase.Id);
        } else if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT &&
            (npOrder.Status__c == NPO_STATUS_NPREQUESTACCEPTED ||
            npOrder.Status__c == NPO_STATUS_NPREQUESTCREATED)
        ) {
            // REQUEST CANCELLATION
            PageReference customPage = new PageReference('/apex/NpOrderCancellationReason');
            customPage.getParameters().put('id', npOrder.Id);
            customPage.getParameters().put(PARAM_CASE_ID, aCase.Id);
            return customPage;
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.severity.ERROR, ERR_NP_ACTION_NOT_APPLICABLE)
            );
            return ApexPages.currentPage();
        }
    }

    public PageReference resumeNp() {
        // Set the values for Status
        Case dbCase = [SELECT Type_Task__c, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        NP_Order__c npOrder = [
            SELECT Telephone_Number__c, Customer_Number__c, Customer_Name__c,
                OCH_Error_Code__c, OCH_Error_Message__c, Is_Frequent_Code__c, Status__c
            FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c
        ];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT &&
            (npOrder.Status__c == NPO_STATUS_NPORDERINCOMPLETE ||
            npOrder.Status__c == NPO_STATUS_NPFEEDBACKREQUESTED ||
            npOrder.Status__c == NPO_STATUS_NPREQUESTFEEDBACK ||
            npOrder.Status__c == NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED
            )
        ) {
            // If required data has been filled, pass the Case to next state
            if (npOrder.Telephone_Number__c != null && npOrder.Customer_Number__c != null && npOrder.Customer_Name__c != null) {
                if (npOrder.Status__c == NPO_STATUS_NPORDERINCOMPLETE) {
                    // Resume on update of a new incomplete in-port order:
                    if (dbCase.Status == CASE_STATUS_NEW) {
                        dbCase.Status = CASE_STATUS_NPRESERVED;
                        update dbCase;
                    }
                    npOrder.Status__c = NPO_STATUS_NPREQUESTCONFIRMATION;
                } else if (
                    npOrder.Status__c == NPO_STATUS_NPFEEDBACKREQUESTED ||
                    npOrder.Status__c == NPO_STATUS_NPREQUESTFEEDBACK ||
                    npOrder.Status__c == NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED
                ) {
                    // Resume on fixed rejected in-port order:
                    // first - erase error fields
                    npOrder.OCH_Error_Code__c = null;
                    npOrder.OCH_Error_Message__c = null;
                    npOrder.Is_Frequent_Code__c = false;
                    // next - erase Order Id we got from Weasel
                    npOrder.Order_Id__c = null;
                    // next - set status values
                    npOrder.Status__c = NPO_STATUS_NPINPORTCONFIRMED;
                    if (dbCase.Status == CASE_STATUS_NEW) {
                        dbCase.Status = CASE_STATUS_NPRESERVED;
                        update dbCase;
                    }
                }
                update npOrder;
                return new PageReference('/' + dbCase.Id);
            } else {
                // Otherwise show error
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPINPORT_RESUME_FAILED)
                );
                return ApexPages.currentPage();
            }
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.severity.ERROR, ERR_NP_ACTION_NOT_APPLICABLE)
            );
            return ApexPages.currentPage();
        }
    }

    public Pagereference confirmOrder() {
        // Set the values for Status
        Case dbCase = [SELECT Id, Status, NP_Order__c, Type_Task__c FROM Case WHERE Id = :aCase.Id];
        NP_Order__c npOrder = [
            SELECT Status__c, Telephone_Number__c, Customer_Number__c, Customer_Name__c
            FROM NP_Order__c WHERE id = :dbCase.NP_Order__c
        ];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT && npOrder.Status__c == NPO_STATUS_NPDECIPHERRESPONSE) {
            if (npOrder.Telephone_Number__c != null && npOrder.Customer_Number__c != null && npOrder.Customer_Name__c != null) {
                updateConfirmedOrder(npOrder, null, null, null);
                if (dbCase.Status == CASE_STATUS_NEW) {
                    dbCase.Status = CASE_STATUS_NPRESERVED;
                    update dbCase;
                }
                return new PageReference('/' + dbCase.Id);
            } else {
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPINPORT_CANNOT_CONFIRM)
                );
                return ApexPages.currentPage();
            }
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.severity.ERROR, ERR_NP_ACTION_NOT_APPLICABLE)
            );
            return ApexPages.currentPage();
        }
    }

    public PageReference approveNp() {
        // To emulate Weasel ICH -> confirmOutboundOrder
        Case dbCase = [
            SELECT Type_Task__c, NP_Order__c, NP_Order__r.Authorization_Approved__c, NP_Order__r.Authorization_Received__c
            FROM Case WHERE Id = :aCase.Id
        ];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPEXPORT) {
            // If related authorization letter received and NP order approved, pass case to next state
            if (dbCase.NP_Order__r.Authorization_Received__c == true && dbCase.NP_Order__r.Authorization_Approved__c == true) {
                NP_Order__c npOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
                //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASECONFIRMED);
                if (aCase.Status == CASE_STATUS_NEW) {
                    aCase.Status = CASE_STATUS_NPRESERVED;
                }
                PageReference pgRef = controller.save();
                npOrder.Status__c = NPO_STATUS_NPOUTPORTCONFIRMED;
                update npOrder;
                return pgRef;
            }
            // Otherwise show error
            else {
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPOUTPORT_APPROVAL_FAILED)
                );
                return ApexPages.currentPage();
            }
        }
        // Otherwise:
        return null;
    }
    
    public PageReference rejectNp() {
        // To emulate Weasel ICH -> rejectOutboundOrder
        Case dbCase = [SELECT Type_Task__c, NP_Order__r.Disapproval_Reason__c, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPEXPORT) {
            // If NP order disapproved, pass case to the next state
            if (dbCase.NP_Order__r.Disapproval_Reason__c != null) {
                NP_Order__c npOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
                //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEREJECTED);
                if (aCase.Status == CASE_STATUS_NPRESERVED) {
                    aCase.Status = CASE_STATUS_NEW;
                }
                PageReference pgRef = controller.save();
                npOrder.Status__c = NPO_STATUS_NPORDERREJECTED;
                update npOrder;
                return pgRef;
            }
            // Otherwise show error
            else {
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPOUTPORT_REJECTION_FAILED)
                );
                return ApexPages.currentPage();
            }
        }
        // Otherwise:
        return null;
    }

    public PageReference sendRequestOCH() {
        // To emulate Weasel ICH -> createNumber
        Case dbCase = [SELECT Type_Task__c, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT) {
            // TEMPORARY SOLUTION:
            // Set the Status as if a request to OCH has been sent successfully
            NP_Order__c npOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
            if (npOrder.Status__c == NPO_STATUS_NPINPORTCONFIRMED) {
                if (aCase.Status == CASE_STATUS_NEW) {
                    aCase.Status = CASE_STATUS_NPRESERVED;
                }
                PageReference pgRef = controller.save();
                npOrder.Status__c = NPO_STATUS_NPREQUESTCREATED;
                update npOrder;
                return pgRef;
            }
        }
        // Otherwise:
        return controller.view();
    }

    public PageReference acceptedByOCH() {
        // To emulate Weasel ICH -> notifyConfirmedDate
        Case dbCase = [SELECT Id, Type_Task__c, NP_Order__c, CaseNumber, AccountId, Status FROM Case WHERE Id = :aCase.Id];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT) {
            // TEMPORARY SOLUTION:
            // Set NP Date as given by OCH
            NP_Order__c npOrder = [SELECT Id, NP_Date__c, Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
            if (npOrder.Status__c == NPO_STATUS_NPREQUESTCREATED) {
                // Set Status and RecType
                if (aCase.Status == CASE_STATUS_NEW) {
                    aCase.Status = CASE_STATUS_NPRESERVED;
                }
                //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPINPORTCASEOPEN);
                PageReference pgRef = controller.save();
                npOrder.NP_Date__c = DateTime.now().addDays(30);
                npOrder.Status__c = NPO_STATUS_NPREQUESTACCEPTED;
                update npOrder;
                return pgRef;
            } else {
                // A request to OCH must be sent first
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPINPORT_OCH_REQUEST_FIRST)
                );
                return ApexPages.currentPage();
            }
        }
        // Otherwise:
        return null;
    }

    public PageReference rejectedByOCH_F() {
        // To emulate Weasel ICH -> orderCancelled
        return rejectedByOCH('338'); // 338 is a frequent code
    }                           

    public PageReference rejectedByOCH_R() {
        // To emulate Weasel ICH -> orderCancelled
        return rejectedByOCH('359'); // 359 is a rare code
    }                           

    public PageReference rejectedByOCH(String errCode) {
        // To emulate Weasel ICH -> orderCancelled
        Case dbCase = [
            SELECT Id, Type_Task__c, NP_Order__c, CaseNumber, AccountId, Status
            FROM Case WHERE Id = :aCase.Id
        ];
        Map<Id, Id> caseToContactMap = new Map<Id,Id>();
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT) {
            // TEMPORARY SOLUTION:
            // Set OCH error code as given by OCH
            NP_Order__c npOrder = [
                SELECT Id, OCH_Error_Code__c, OCH_Error_Message__c, Status__c
                FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c
            ];
            if (npOrder.Status__c == NPO_STATUS_NPREQUESTCREATED) {
                // Set Status, RecType will be set in the trigger
                if (aCase.Status == CASE_STATUS_NEW) {
                    aCase.Status = CASE_STATUS_NPRESERVED;
                }
                PageReference pgRef = controller.save();
                npOrder.Status__c = NPO_STATUS_NPREQUESTREJECTED;
                //npOrder.OCH_Error_Code__c = errCode;
                npOrder.OCH_Error_Message__c = errCode + ' - bananabanana';
                update npOrder;
                return pgRef;
            } else {
                // A request to OCH must be sent first
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.severity.ERROR, ERR_NPINPORT_OCH_REQUEST_FIRST)
                );
                return ApexPages.currentPage();
            }
        }
        // Otherwise:
        return null;
    }

    public Pagereference completeNP() {
        // To emulate Weasel ICH -> orderFinished
        Case dbCase = [SELECT Type_Task__c, AccountId, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        if (dbCase.Type_Task__c == CASE_TYPETASK_NPIMPORT) {
            NP_Order__c npOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :dbCase.NP_Order__c];
            // Close the case (Set the values for Record Type and Status)
            //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPINPORTCASECLOSED);
            if (aCase.Status == CASE_STATUS_NPRESERVED || aCase.Status == CASE_STATUS_NEW) {
                aCase.Status = CASE_STATUS_CLOSED;
            }
            PageReference pgRef = controller.save();
            npOrder.Status__c = NPO_STATUS_CLOSED;
            update npOrder;
            return pgRef;
        }
        // Otherwise:
        return null;
    }

    // Update the NP Order when a new request is to be sent to Weasel
    public static void updateConfirmedOrder(
        NP_Order__c npOrder, EmailMessage email, String extCustNumber, String extCustName
    ) {
        // Update the NP Order
        npOrder.Status__c = NPO_STATUS_NPINPORTCONFIRMED;
        if (email != null) {
            if (email.Id != npOrder.Authorization_Email_ID__c) {
                npOrder.Authorization_Email_ID__c = email.Id;
            }
        }
        if (extCustNumber != null && !extCustNumber.equals(npOrder.External_Customer_Number__c)) {
            npOrder.External_Customer_Number__c = extCustNumber;
        }
        if (extCustName != null && !extCustName.equals(npOrder.External_Customer_Name__c)) {
            npOrder.External_Customer_Name__c = extCustName;
        }
        database.update(npOrder);
    }

    /* Create Task for each user from the Group */
    public static void createTaskForPowerGroup(String objective, Date activityDate, Id relatedTo) {
        /* Replaced by Custom Settings due to TOO MANY SOQL STATEMENTS issue
        Id npGroupId = [Select Name, Id From Group where Name = :TASK_NPGROUP].Id;
        GroupMember[] groupMembers = [Select UserOrGroupId, GroupId From GroupMember where GroupId = :npGroupId];
        Id rtTaskId = [Select Id From RecordType where Name = :TASK_RT_NPTASK].Id;
        for (GroupMember groupMember : groupMembers) {
            Task task = new Task(OwnerId = groupMember.UserOrGroupId, Subject = TASK_SUBJECT,
                Objective__c = objective, ActivityDate = activityDate, WhatId = relatedTo,
                RecordTypeId = rtTaskId, Type = TASK_TYPE, Priority = TASK_PRIORITY);
            insert task;
        }
        */
        List <Number_Porting_Power_Group__c> csUsers = Number_Porting_Power_Group__c.getAll().values();
        for (Number_Porting_Power_Group__c csUser : csUsers) {
            Task task = new Task(OwnerId = csUser.User_ID__c, Subject = TASK_SUBJECT,
                Objective__c = objective, ActivityDate = activityDate, WhatId = relatedTo,
                RecordTypeId = getRecordTypeId(RT_NPTASK), Type = TASK_TYPE, Priority = TASK_PRIORITY)
            ;
            insert task;
        }
    }

    /* Validate the new or updated out-port order when the request is received from OCH. 
       This code is called from the BeforeInsertUpdate Case trigger;
       think twice before you introduce a SOQL here :-)
     */
    public static void validateNpCaseInTrigger(
        NP_Order__c npOrder, Case aCase, List<NP_Order__c> toUpdateOrders, Map<String, Account> custNrToAccount, Datetime workDay
    ) {
        String disapprovalReason = null;
        // if no NP Date comes with the order
        if (npOrder.NP_Date__c == null) {
            npOrder.NP_Date__c = workDay;
        }
        // Validate the out-port order:
        // 1. YouSee customer number must be present
        boolean isValid = npOrder.Current_Customer_Id__c != null;
        // 2. Only 1 telephone number to out port
        if (isValid) {
            isValid = npOrder.Series_Count__c == 0;
            if (!isValid) {
                // There are number series to port - YouSee do not support this
                // Reject the order with error code 330
                disapprovalReason = ERR_330;
            }
        }
        // 3. Verify the subscription status in YouSee
        if (isValid) {
            if (npOrder.Customer_Number_Kasia__c == '0') {
                // Subscription is inactive for more than 6 months
                // Reject the order with error code 349
                isValid = false;
                disapprovalReason = ERR_349;
            } else if (npOrder.Current_Customer_Id__c != npOrder.Customer_Number_Kasia__c) {
                // No valid subscription found or the customer number does not match the subscription
                // Reject the order with error code 339
                isValid = false;
                disapprovalReason = ERR_339;
            } else {
                isValid = npOrder.Current_Customer_Id__c == npOrder.Customer_Number_Kasia__c;
                // Fill CustomerNumber with CurrentCustomerId value when an out-port is
                // automatically validated and CustomerNumber is undefined
                if (isValid && npOrder.Customer_Number__c == null) {
                    npOrder.Customer_Number__c = npOrder.Current_Customer_Id__c;
                }
            }
        }
        // 4. NP date must be the next day or later
        if (isValid) {
            isValid = npOrder.NP_Date__c.date() >= Date.today().addDays(1);
        }

        if (disapprovalReason != null) {
            if (aCase.Status == CASE_STATUS_NEW) {
                aCase.Status = CASE_STATUS_NPRESERVED;
            }
            npOrder.Disapproval_Reason__c = disapprovalReason;
            npOrder.Status__c = NPO_STATUS_NPOUTPORTREJECT;
        } else if (isValid) {
            // Order automatically validated
            npOrder.Authorization_Approved__c = true;
            // Set the valid customer number on Case (if still empty)
            if (aCase.Customer_Number__c == null && npOrder.Current_Customer_Id__c != null) {
                Account acc = custNrToAccount.get(npOrder.Current_Customer_Id__c);
                if (acc != null) {
                    aCase.AccountId = acc.Id;
                }
            }
            //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
            if (aCase.Status == CASE_STATUS_NEW) {
                aCase.Status = CASE_STATUS_NPRESERVED;
            }
            npOrder.Status__c = NPO_STATUS_NPOUTPORTACCEPT;
        } else {
            // Order needs a manual approval
            if (!npOrder.Authorization_Received__c) {
                // set the deadline for customer's authorization to be received
                npOrder.Authorization_Deadline__c = Date.today().addDays(14);
            }
            //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
            if (aCase.Status == CASE_STATUS_NPRESERVED) {
                aCase.Status = CASE_STATUS_NEW;
            }
            npOrder.Status__c = NPO_STATUS_NPOUTPORTINCOMPLETE;
        }
        toUpdateOrders.add(npOrder);
    }

    // Computes a working day X days from a given day
    public static Datetime computeFutureWorkingDate(DateTime aDate, Integer days) {
        // No check for a positive value of given number of days
        Datetime retVal = aDate.addDays(days);
        BusinessHours[] bhs = [SELECT Id FROM BusinessHours WHERE Name = :BUSINESS_HOURS_YK];
        BusinessHours ykBH = bhs.size() > 0 ? bhs[0] : null;
        if (ykBH != null) {
            // Take advantage of BusinessHours - find 1 business hour in future
            retVal = BusinessHours.add(ykBH.Id, retVal, 60*60*1000L);
        } else {
            // Default BusinessHours undefined - skip just weekends
            System.debug('BusinessHours undefined - skipping weekends only');
            String wkDay = retVal.format('EEE').toLowerCase();
            if (wkDay == 'sat') {
                retVal = retVal.addDays(2);
            } else if (wkDay == 'sun') {
                retVal = retVal.addDays(1);
            }
        }
        return retVal;
    }

    // Computes a working day X days from a given day and a given BusinessHours record
    public static Datetime computeFutureWorkingDateMyBH(DateTime aDate, Integer days, BusinessHours bh) {
        // No check for a positive value of given number of days
        Datetime retVal = aDate.addDays(days);
        if (bh != null) {
            // Take advantage of BusinessHours - find 1 business hour in future
            retVal = BusinessHours.add(bh.Id, retVal, 60*60*1000L);
        } else {
            // Default BusinessHours undefined - skip just weekends
            System.debug('BusinessHours undefined - skipping weekends only');
            String wkDay = retVal.format('EEE').toLowerCase();
            if (wkDay == 'sat') {
                retVal = retVal.addDays(2);
            } else if (wkDay == 'sun') {
                retVal = retVal.addDays(1);
            }
        }
        return retVal;
    }

    public static Datetime computeLaunchDate(dateTime aDate, Decimal hour) {
        // computes the launch date out of np date and a configurable time
        if (aDate != null) {
            Datetime retVal = aDate.date();
            return retVal.addHours(hour.intValue());
        } else {
            return null;
        }
    }

    public static Datetime computeAlertDate(dateTime aDate, Decimal delay) {
        // computes the alert date out of np date and a configurable delay
        if (aDate != null) {
            return aDate.addHours(delay.intValue());
        } else {
            return null;
        }
    }

    public static boolean compareDatetimeValues(Datetime dt1, Datetime dt2) {
        boolean retVal = false;
        if (dt1 == null && dt2 == null) {
            retVal = true;
        } else if (dt1 != null && dt2 != null) {
            retVal = dt1.getTime() == dt2.getTime();
        }
        return retVal;
    }

    public static String getRecordTypeId(String name) {
        String retVal = null;
        Number_Porting_Record_Types__c config = Number_Porting_Record_Types__c.getInstance(name);
        if (config != null) {
            retVal = config.Record_ID__c;
        }
        return retVal;
    }

    public static void setConfirmationReminders(NP_Order__c order, Number_Porting_Configuration__c config) {
        Datetime dt = DateTime.now();
        order.In_Port_Notification_Status__c = NP_ORDER_INPORT_STATUS_CONFIRM;
        order.First_Reminder_Date__c = dt.addDays(config.First_Delay__c.intValue());
        order.Second_Reminder_Date__c = dt.addDays(config.Second_Delay__c.intValue());
        order.Order_Close_Date__c = dt.addDays(config.Third_Delay__c.intValue());
    }


    /* 
     * --------------------------------------------------------------------
     * Test methods
     */
    static testMethod void testComputeFutureWorkingDate() {
        Datetime dtNow = Datetime.now();
        Datetime dtNextBizDay = computeFutureWorkingDate(dtNow, 1);
        System.assert(dtNextBizDay > dtNow);
    }

    static testMethod void testCompareDatetimeValues() {
        Datetime dtAa = Datetime.newInstanceGmt(2010, 10, 10, 0, 0, 1);
        Datetime dtAb = Datetime.newInstanceGmt(2010, 10, 10, 0, 0, 1);
        Datetime dtB = Datetime.newInstanceGmt(2010, 10, 10, 0, 0, 2);
        Datetime dtNa = null;
        Datetime dtNb = null;
        System.assertEquals(true, compareDatetimeValues(dtAa, dtAb));
        System.assertEquals(true, compareDatetimeValues(dtNa, dtNb));
        System.assertEquals(false, compareDatetimeValues(dtAa, dtB));
        System.assertEquals(false, compareDatetimeValues(dtAa, dtNa));
        System.assertEquals(false, compareDatetimeValues(dtNb, dtB));
    }

    static testMethod void testValidateNpCaseInTrigger() {
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Order_Id__c = 1;
        npOrder.Series_Count__c = 1; // invalid value
        npOrder.Telephone_Number__c = 'banana';
        npOrder.Current_Customer_Id__c = 'banana';
        npOrder.Status__c = NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASEREJECTED));
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [
            SELECT Authorization_Approved__c, Disapproval_Reason__c, Status__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assert(!dbOrder.Authorization_Approved__c);
        System.assertEquals(ERR_330, dbOrder.Disapproval_Reason__c);
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPOUTPORTREJECT);

        // Transition from NPO_STATUS_NPAUTHORIZATIONLETTER to NPO_STATUS_NPORDERARRIVED with no customer id
        dbOrder.Status__c = NPO_STATUS_NPAUTHORIZATIONLETTER;
        update dbOrder;
        dbOrder.Series_Count__c = 0;
        dbOrder.Current_Customer_Id__c = null;
        dbOrder.Disapproval_Reason__c = null;
        dbOrder.Status__c = NPO_STATUS_NPORDERARRIVED;
        update dbOrder;

        // Get from DB and compare:
        dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NEW);
        dbOrder = [
            SELECT Authorization_Approved__c, Disapproval_Reason__c, Status__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assertEquals(null, dbOrder.Disapproval_Reason__c);
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPOUTPORTINCOMPLETE);
    }

    static testMethod void testCancelNp() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpCancelClose;
        Test.setCurrentPage(pageRef);

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button
        pageRef = ctrl.cancelCloseNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPINPORTCASECANCELED));
        System.assertEquals(dbCase.Status, CASE_STATUS_CANCELLED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPORDERCANCELED);
    }

    static testMethod void testCloseNp() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpCancelClose;
        Test.setCurrentPage(pageRef);

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button
        pageRef = ctrl.cancelCloseNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, CASE_STATUS_CLOSED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_CLOSED);
    }

/* To be fixed (e-mail address needed)
    static testMethod void testResumeNp() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpResume;
        Test.setCurrentPage(pageRef);

        // Instantiate an NP Error Code
        String errCode = '380';
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=true, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        NP_Operator__c operator = new NP_Operator__c(Name='YouSee', Code__c='77777', Email__c='a@b.com');
        insert operator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '99887766';
        npOrder.Customer_Name__c = 'Jens Jensen';
        npOrder.Customer_Number__c = '123456780';
        npOrder.Status__c = NPO_STATUS_NPORDERINCOMPLETE;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button
        pageRef = ctrl.resumeNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPINPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPREQUESTCONFIRMATION);

        dbOrder.Status__c = NPO_STATUS_NPREQUESTCREATED;
        dbOrder.Order_Id__c = 101;
        update dbOrder;
        dbOrder.Status__c = NPO_STATUS_NPREQUESTREJECTED;
        dbOrder.OCH_Error_Message__c = errCode + ' - banana';
        update dbOrder;

        // Get from DB and compare:
        dbOrder = [
            SELECT OCH_Error_Code__c, OCH_Error_Message__c, Is_Frequent_Code__c, Status__c, Order_Id__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
         ];
        System.assert(dbOrder.OCH_Error_Code__c != null);
        System.assert(dbOrder.OCH_Error_Message__c != null);
        System.assert(dbOrder.Is_Frequent_Code__c);
        System.assert(dbOrder.Order_Id__c != null);
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPFEEDBACKREQUESTED);

        ctrl = new clsCasesNpHandlerController(new ApexPages.standardController(dbCase));

        // Press the button
        pageRef = ctrl.resumeNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        dbCase = [SELECT RecordTypeId, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPINPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        dbOrder = [
            SELECT OCH_Error_Code__c, OCH_Error_Message__c, Is_Frequent_Code__c, Status__c, Order_Id__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
         ];
        System.assertEquals(null, dbOrder.OCH_Error_Code__c);
        System.assertEquals(null, dbOrder.OCH_Error_Message__c);
        System.assert(!dbOrder.Is_Frequent_Code__c);
        System.assertEquals(null, dbOrder.Order_Id__c);
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPINPORTCONFIRMED);
    }
*/

    static testMethod void testSendRequestOCH() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpSendRequestOCH;
        Test.setCurrentPage(pageRef);

        String name = 'TestTDC';
        String code = '7777';
        NP_Operator__c npOperator =
            new NP_Operator__c(Name=name, Code__c=code, Email__c='a@b.com', Authorization_Required__c=true)
        ;
        insert npOperator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPINPORTCONFIRMED;
        npOrder.External_Operator_Code__c = code;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button
        pageRef = ctrl.sendRequestOCH();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPREQUESTCREATED);
    }

    static testMethod void testAcceptedByOCH() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpAcceptedOCH;
        Test.setCurrentPage(pageRef);

        // Prepare a Customer
        String CustomerName = 'John Doe';
        String CustomerNumber = '987654321';
        Account acc = new Account(name=CustomerName);
        acc.Customer_No__c = CustomerNumber;
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'john@doe.com';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPREQUESTCREATED;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        insert npOrder;
        
        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPINPORTCASEOCHRESPONSE);
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button - Frequent code
        pageRef = ctrl.acceptedByOCH();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPINPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPREQUESTACCEPTED);
    }

    static testMethod void testRejectedByOCH_F() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpRejectedOCH_F;
        Test.setCurrentPage(pageRef);

        // Prepare a Customer
        String CustomerName = 'John Doe';
        String CustomerNumber = '987654321';
        Account acc = new Account(name=CustomerName);
        acc.Customer_No__c = CustomerNumber;
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'john@doe.com';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPREQUESTCREATED;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        insert npOrder;
        
        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button - Frequent code
        pageRef = ctrl.rejectedByOCH_F();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPFEEDBACKREQUESTED);
    }

    static testMethod void testRejectedByOCH_R() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpRejectedOCH_R;
        Test.setCurrentPage(pageRef);

        // Prepare a Customer
        String CustomerName = 'John Doe';
        String CustomerNumber = '987654321';
        Account acc = new Account(name=CustomerName);
        acc.Customer_No__c = CustomerNumber;
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'john@doe.com';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPREQUESTCREATED;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        insert npOrder;
        
        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button - Rare code
        pageRef = ctrl.rejectedByOCH_R();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status, NP_Order__c FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, CASE_STATUS_NEW);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPREQUESTFEEDBACK);
    }

    static testMethod void testConfirmOrder() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpConfirmOrder;
        Test.setCurrentPage(pageRef);

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPDECIPHERRESPONSE;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Customer_Name__c = 'John Doe';
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        EmailMessage email = new EmailMessage();
        email.ParentId = aCase.Id;
        email.Subject = 'Subject';
        email.TextBody = 'Text Text';
        email.HtmlBody = '';
        insert email;

        npOrder.Authorization_Email_ID__c = email.Id;
        update npOrder;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

        // Press the button
        pageRef = ctrl.confirmOrder();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Authorization_Email_ID__c, Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Authorization_Email_ID__c, email.Id);
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPINPORTCONFIRMED);
    }

    static testMethod void testApproveNpSuccess() {
        PageReference pageRef = Page.CasesNpApprove;
        Test.setCurrentPage(pageRef);
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Authorization_Approved__c = true;
        npOrder.Authorization_Received__c = true;
        npOrder.NP_Date__c = Date.today().addDays(1);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = NPO_STATUS_NPOUTPORTINCOMPLETE;
        insert npOrder;
        
        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
        aCase.Department__c = CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
        
        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;
        
         // Press the button
        pageRef = ctrl.approveNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);
        
        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASECONFIRMED));
        System.assertEquals(dbCase.Status, CASE_STATUS_NPRESERVED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPOUTPORTCONFIRMED);
    }

    static testMethod void testApproveNpFailure() {
        PageReference pageRef = Page.CasesNpApprove;
        Test.setCurrentPage(pageRef);

        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Authorization_Approved__c = false;
        npOrder.Authorization_Received__c = false;
        npOrder.Status__c = NPO_STATUS_NPOUTPORTINCOMPLETE;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
        aCase.Department__c = CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

         // Press the button
        pageRef = ctrl.approveNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NEW);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPOUTPORTINCOMPLETE);
    }

/*
    static testMethod void testRejectNpSuccess() {
        PageReference pageRef = Page.CasesNpReject;
        Test.setCurrentPage(pageRef);

        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Authorization_Approved__c = false;
        npOrder.Authorization_Received__c = true;
        npOrder.Disapproval_Reason__c = ERR_330;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
        aCase.Department__c = CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

         // Press the button
        pageRef = ctrl.rejectNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASECLOSED));
        System.assertEquals(dbCase.Status, CASE_STATUS_CLOSED);
    }
*/

    static testMethod void testRejectNpFailure() {
        PageReference pageRef = Page.CasesNpReject;
        Test.setCurrentPage(pageRef);
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Authorization_Approved__c = false;
        npOrder.Authorization_Received__c = true;
        npOrder.Status__c = NPO_STATUS_NPOUTPORTINCOMPLETE;
        insert npOrder;

        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NEW;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPOUTPORTCASEOPEN);
        aCase.Department__c = CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;

         // Press the button
        pageRef = ctrl.rejectNp();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPOUTPORTCASEOPEN));
        System.assertEquals(dbCase.Status, CASE_STATUS_NEW);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_NPOUTPORTINCOMPLETE);
    }

    static testMethod void testCompleteNP() {
        PageReference pageRef = Page.CasesNpApprove;
        Test.setCurrentPage(pageRef);
        
        // Prepare a Customer
        String CustomerName = 'John Doe';
        String CustomerNumber = '987654321';
        Account acc = new Account(name=CustomerName);
        acc.Customer_No__c = CustomerNumber;
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'john@doe.com';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;
        
        // Instantiate a NP Order record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = NPO_STATUS_NPREQUESTACCEPTED;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        insert npOrder;
        
        // Instantiate a Case record
        Case aCase = new Case();
        aCase.Status = CASE_STATUS_NPRESERVED;
        //noRT: aCase.RecordTypeId = getRecordTypeId(RT_NPINPORTCASEOPEN);
        aCase.Department__c = CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.id;
        insert aCase;
        
        // Instantiate and construct the controller class
        clsCasesNpHandlerController ctrl =
            new clsCasesNpHandlerController(new ApexPages.standardController(aCase))
        ;
        
         // Press the button
        pageRef = ctrl.completeNP();
        // Check that the method doesn't return NULL
        System.assertNotEquals(null, pageRef);
        
        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, getRecordTypeId(RT_NPINPORTCASECLOSED));
        System.assertEquals(dbCase.Status, CASE_STATUS_CLOSED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, NPO_STATUS_CLOSED);
    }

    static testMethod void testNPMissingOperator() {
        String name = 'YouSee';
        String code = '77777';
        NP_Operator__c npOperator = new NP_Operator__c(Name=name, Code__c=code, Email__c='a@b.com');
        insert npOperator;

        // test when CastIron sets operator code
        NP_Order__c npOrder = new NP_Order__c(External_Operator_Code__c=code);
        insert npOrder;
        
        NP_Order__c dbOrder = [Select External_Operator__c From NP_Order__c Where Id = :npOrder.Id];
        System.assertEquals(npOperator.Id, dbOrder.External_Operator__c);
        
        // test when user enters operator
        npOrder = new NP_Order__c(External_Operator__c=npOperator.Id);
        insert npOrder;
        
        dbOrder = [Select External_Operator_Code__c From NP_Order__c Where Id = :npOrder.Id];
        System.assertEquals(code, dbOrder.External_Operator_Code__c);
    }

    public static testMethod void testNpRecordTypes() {
        // Test Custom Settings: Number Porting Record Types
        RecordType[] rts = [SELECT Id, Name FROM RecordType];
        Map<String, Id> rtsMap = new Map<String, Id>();
        for (RecordType rt : rts) {
            rtsMap.put(rt.Name, rt.Id);
        }
        Number_Porting_Record_Types__c csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEOPEN);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEOPEN));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEINCOMPLETE);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEINCOMPLETE));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASECANCELED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASECANCELED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEDECIPHER);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEDECIPHER));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEOCHRESPONSE);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEOCHRESPONSE));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEREQUESTFEEDBACK);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEREQUESTFEEDBACK));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASEFEEDBACKRECEIVED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASEFEEDBACKRECEIVED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASELAUNCHED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASELAUNCHED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPINPORTCASECLOSED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPINPORTCASECLOSED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOUTPORTCASEOPEN);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOUTPORTCASEOPEN));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOUTPORTCASEREJECTED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOUTPORTCASEREJECTED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOUTPORTCASECONFIRMED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOUTPORTCASECONFIRMED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOUTPORTCASECLOSED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOUTPORTCASECLOSED));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOPEN_IN);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOPEN_IN));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPOPEN_OUT);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPOPEN_OUT));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPQUEUE);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPQUEUE));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_NPCLOSED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_NPCLOSED));
        // Standard Case Record Types:
        csRT = Number_Porting_Record_Types__c.getInstance(RT_OPEN);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_OPEN));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_QUEUE);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_QUEUE));
        csRT = Number_Porting_Record_Types__c.getInstance(RT_CLOSED);
        System.AssertEquals(rtsMap.get(csRT.Record_Type_Name__c), getRecordTypeId(RT_CLOSED));
    }

    public static testMethod void testNpPowerGroup() {
        // Test Custom Settings: Number Porting Record Types
        Number_Porting_Record_Types__c csRT = Number_Porting_Record_Types__c.getInstance(RT_NPTASK);
        ID rtId = [SELECT Id FROM RecordType WHERE Name = :csRT.Record_Type_Name__c].Id;
        System.AssertEquals(rtId, getRecordTypeId(RT_NPTASK));
        Id npGroupId = [Select Name, Id From Group where Name = :TASK_NPGROUP].Id;
        GroupMember[] groupMembers = [Select UserOrGroupId, GroupId From GroupMember where GroupId = :npGroupId];
        // Test Custom Settings: Number Porting Power Group
        List <Number_Porting_Power_Group__c> csUsers = Number_Porting_Power_Group__c.getAll().values();
        System.AssertEquals(groupMembers.size(), csUsers.size());
        Boolean found = false;
        for (Number_Porting_Power_Group__c csUser : csUsers) {
            for (GroupMember groupMember : groupMembers) {
                found = groupMember.UserOrGroupId == csUser.User_ID__c;
                if (found) {
                    break;
                }
            }
            System.Assert(found);
        }
    }

    public static testMethod void testCreateTaskForPowerGroup() {
        Case aCase = new Case();
        insert aCase;
        String strO = 'banana banana';
        createTaskForPowerGroup(strO, Date.today(), aCase.Id);
        String objective = [SELECT Objective__c FROM Task WHERE WhatId = :aCase.Id LIMIT 1].Objective__c;
        System.AssertEquals(strO, objective);
    }
}