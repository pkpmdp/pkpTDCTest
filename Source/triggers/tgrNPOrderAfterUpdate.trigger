trigger tgrNPOrderAfterUpdate on NP_Order__c (after update) {

    // to create Tasks in case CI does not respond
    Set<Id> noResponseCaseIds = new Set<Id>();

    Set<Id> toSendAcceptance = new Set<Id>();
    Set<Id> toSendFeedbackRequest = new Set<Id>();
    Map<String, Set<Id>> freqErrToCasesMap = new Map<String, Set<Id>>(); // errCode::Set<CaseId>
    Map<Id, String> casesToUpdateStatus = new Map<Id, String>(); // <CaseId::Status>

    // A container to store data to update a Case with
    class SrchData {
        SrchData() {}
        SrchData(String custNr, String phoneNr) {
            this.custNr = custNr;
            this.phoneNr = phoneNr;
        }
        String custNr {get; set;}
        String phoneNr {get; set;}
    }
    Map<Id, SrchData> casesToUpdateSrchData = new Map<Id, SrchData>(); // <CaseId::(custNr,phoneNr)>

    Map<id,id> npOrderToCases = new Map<id,Id>();
    Set<Id> toConfirmCases = new Set<Id>();
    Set<Id> toConfirmCasesNoDate = new Set<Id>();
    Set<Id> toRemindFirstCases = new Set<Id>();
    Set<Id> toRemindFirstCasesNoDate = new Set<Id>();
    Set<Id> toRemindSecondCases = new Set<Id>();
    Set<Id> toRemindSecondCasesNoDate = new Set<Id>();
    
    Set<Id> toRemindFirstCasesRF = new Set<Id>();
    Set<Id> toRemindSecondCasesRF = new Set<Id>();

//  Map<Id, String> toRejectCases = new Map<Id, String>();

    // maps to map Case record to appropriate contact record
    Map<Id, Id> caseToAccountMap = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapConfirmed = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapConfirmedNoDate = new Map<Id, Id>();

/*
    Map<Id, Id> caseToContactMapRemind1 = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapRemind1NoDate = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapremind2 = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapremind2NoDate = new Map<Id, Id>();
*/
    Map<Id, clsNpBatchSendConfirmationReminderEmails.RmndrData> casesToRmndrData =
        new Map<Id, clsNpBatchSendConfirmationReminderEmails.RmndrData>()
    ; // <CaseId::(contactId,template)>

    Map<Id, Id> caseToContactMapRemindRF1 = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapRemindRF2 = new Map<Id, Id>();

    Map<Id, Id> caseToContactMapAccept    = new Map<Id, Id>();
    Map<Id, Id> caseToContactMapRequestFB = new Map<Id, Id>();
    Map<Id, Boolean> npOrderToDKTVflow = new Map<Id, Boolean>();

    // prepare NP_Order to Case map. Assumes every NP Order has only one Case!
    for (NP_Order__c o : [SELECT Id,
            (SELECT Case.id, Case.AccountId, Case.NP_DKTV_Flow__c FROM NP_Order__c.Cases__r)
        FROM NP_Order__c WHERE Id IN :Trigger.newMap.keySet()]
    ) {
        for (Case c: o.Cases__r) {
            npOrderToCases.put(o.id, c.id);
            caseToAccountMap.put(c.id, c.AccountId);
            npOrderToDKTVflow.put(o.id, c.NP_DKTV_Flow__c);
        }
    }
    
    for (NP_Order__c o : trigger.New) {
// ChngRq #4 BEGIN ->
        // CI did not update the Status when expected
        if (
            (o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED ||
             o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION ||
             o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT ||
             o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT
            ) &&
            o.NP_Event_Date__c == null &&
            Trigger.oldMap.get(o.id).NP_Event_Date__c != null
        ) {
            noResponseCaseIds.add(npOrderToCases.get(o.id));
        }

        // Send NP in-port acceptance e-mail to customer
        if (o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED &&
            Trigger.oldMap.get(o.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED
        ) {
            Boolean isDKTVflow = npOrderToDKTVflow.get(o.id);
            if (isDKTVflow != null && isDKTVflow) {
                // No in-port acceptance e-mail for a DKTV customer phone number
                // DO NOTHING
            } else {
                // Send NP in-port acceptance e-mail to customer
                toSendAcceptance.add(npOrderToCases.get(o.id));
            }
        }

        // Send rejection fedback request e-mail to customer
        if (o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED &&
            Trigger.oldMap.get(o.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED
        ) {
            ID cId = npOrderToCases.get(o.id);
            toSendFeedbackRequest.add(cId);
            // collect all Case ids per given error code
            Set<Id> caseIds = freqErrToCasesMap.get(o.OCH_Error_Code__c);
            if (caseIds == null) {
                caseIds = new Set<Id>();
            }
            caseIds.add(cId);
            freqErrToCasesMap.put(o.OCH_Error_Code__c, caseIds);
        }

        // Send launch notification to a customer
        if (o.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPLAUNCHMSG &&
            Trigger.oldMap.get(o.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED
        ) {
            // No launch notification e-mail anymore (NP-162)
            casesToUpdateStatus.put(npOrderToCases.get(o.id), clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
        }

        // Set Status to Closed on Case
        if (o.Status__c == clsCasesNpHandlerController.NPO_STATUS_CLOSED &&
            Trigger.oldMap.get(o.id).Status__c == clsCasesNpHandlerController.NPO_STATUS_NPLAUNCHMSG
        ) {
            // This is a workflow field update
            casesToUpdateStatus.put(npOrderToCases.get(o.id), clsCasesNpHandlerController.CASE_STATUS_CLOSED);
        }
// <- ChngRq #4 END

        // Update SRCH values on Case
        if (
            o.Customer_Number__c != Trigger.oldMap.get(o.id).Customer_Number__c ||
            o.Telephone_Number__c != Trigger.oldMap.get(o.id).Telephone_Number__c
        ) {
            casesToUpdateSrchData.put(npOrderToCases.get(o.id), new SrchData(o.Customer_Number__c, o.Telephone_Number__c));
        }
            
        // Prepare Case id lists based on NP Order notification status
        if (
            o.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM
            && Trigger.oldMap.get(o.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM
        ) {
            if (o.NP_Date__c == null) {
                toConfirmCasesNoDate.add(npOrderToCases.get(o.id));
            } else {
                toConfirmCases.add(npOrderToCases.get(o.id));
            }
        }
        else if (
            o.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST
            && Trigger.oldMap.get(o.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST
        ) {
            if (o.NP_Date__c == null) {
                toRemindFirstCasesNoDate.add(npOrderToCases.get(o.id));
            } else {
                toRemindFirstCases.add(npOrderToCases.get(o.id));
            }
        }
        else if (
            o.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND
            && Trigger.oldMap.get(o.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND
        ) {
            if (o.NP_Date__c == null) {
                toRemindSecondCasesNoDate.add(npOrderToCases.get(o.id));
            } else {
                toRemindSecondCases.add(npOrderToCases.get(o.id));
            }
        }
        else if (
            o.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST_RF
            && Trigger.oldMap.get(o.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST_RF
        ) {  
            toRemindFirstCasesRF.add(npOrderToCases.get(o.id));
        }
        else if (
            o.In_Port_Notification_Status__c == clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND_RF
            && Trigger.oldMap.get(o.id).In_Port_Notification_Status__c != clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND_RF
        ) { 
            toRemindSecondCasesRF.add(npOrderToCases.get(o.id));
        }

        // if disapproval reason has been selected, case needs to be rejected
/*
        if (o.Disapproval_Reason__c != null && o.Disapproval_Reason__c != ''
            && (Trigger.oldMap.get(o.id).Disapproval_Reason__c == null 
                || Trigger.oldMap.get(o.id).Disapproval_Reason__c == '')) {
            toRejectCases.put(npOrderToCases.get(o.id), o.Disapproval_Reason__c);
        }
*/
    }

// ChngRq #4 BEGIN ->
    // CI does not respond: create a Task for 'power users'
    if (noResponseCaseIds.size() > 0) {
        for (Id caseId: noResponseCaseIds) {
            clsCasesNpHandlerController.createTaskForPowerGroup(
                clsCasesNpHandlerController.TASK_OBJECTIVE_NORESPONSEORERROR, Date.today(), caseId
            );
        }
    }
// <- ChngRq #4 END

    // Map cases to contacts & prepare data for confirmation reminders
    for (Contact cont : [SELECT Id, AccountId FROM Contact WHERE AccountId in :caseToAccountMap.values()]) {
        for (Id caseId: caseToAccountMap.keySet()) {
            if (caseToAccountMap.get(caseId) == cont.AccountId) {
                if (toConfirmCases.contains(caseId)) {
                    caseToContactMapConfirmed.put(caseId, cont.id);
                } else if (toConfirmCasesNoDate.contains(caseId)) {
                    caseToContactMapConfirmedNoDate.put(caseId, cont.id);
                } else if (toRemindFirstCases.contains(caseId)) {
                    //caseToContactMapRemind1.put(caseId, cont.id);
                    casesToRmndrData.put(caseId, new clsNpBatchSendConfirmationReminderEmails.RmndrData(cont.id, clsNPEmailSender.TMPL_NOTIFICATION_2));
                } else if (toRemindFirstCasesNoDate.contains(caseId)) {
                    //caseToContactMapRemind1NoDate.put(caseId, cont.id);
                    casesToRmndrData.put(caseId, new clsNpBatchSendConfirmationReminderEmails.RmndrData(cont.id, clsNPEmailSender.TMPL_NOTIFICATION_0_2));
                } else if (toRemindSecondCases.contains(caseId)) {
                    //caseToContactMapRemind2.put(caseId, cont.id);
                    casesToRmndrData.put(caseId, new clsNpBatchSendConfirmationReminderEmails.RmndrData(cont.id, clsNPEmailSender.TMPL_NOTIFICATION_3));
                } else if (toRemindSecondCasesNoDate.contains(caseId)) {
                    //caseToContactMapRemind2NoDate.put(caseId, cont.id);
                    casesToRmndrData.put(caseId, new clsNpBatchSendConfirmationReminderEmails.RmndrData(cont.id, clsNPEmailSender.TMPL_NOTIFICATION_0_3));
                } else if (toRemindFirstCasesRF.contains(caseId)) {
                    caseToContactMapRemindRF1.put(caseId, cont.id);
                } else if (toRemindSecondCasesRF.contains(caseId)) {
                    caseToContactMapRemindRF2.put(caseId, cont.id);
                } else if (toSendAcceptance.contains(caseId)) {
                    caseToContactMapAccept.put(caseId, cont.id);
                } else if (toSendFeedbackRequest.contains(caseId)) {
                    caseToContactMapRequestFB.put(caseId, cont.id);
                }
            }
        }
    }

    // send out emails
    if (!caseToContactMapConfirmed.isEmpty()) {
        clsNPEmailSender.sendConfirmNPOrderRequest(caseToContactMapConfirmed);
    }
    if (!caseToContactMapConfirmedNoDate.isEmpty()) {
        clsNPEmailSender.sendConfirmNPOrderRequest_NoDate(caseToContactMapConfirmedNoDate);
    }
    if (!casesToRmndrData.isEmpty()) {
       clsNPEmailSender.sendConfirmNPOrderReminderRequest(casesToRmndrData);
    }
    if (!caseToContactMapRemindRF1.isEmpty()) {
        clsNPEmailSender.sendRequestNPFeedback_1stNotification(caseToContactMapRemindRF1);
    }
    if (!caseToContactMapRemindRF2.isEmpty()) {
        clsNPEmailSender.sendRequestNPFeedback_2ndNotification(caseToContactMapRemindRF2);
    }
    if (!caseToContactMapAccept.isEmpty()) {
        clsNPEmailSender.sendNpInPortAcceptance(caseToContactMapAccept);
    }
    if (!caseToContactMapRequestFB.isEmpty()) {
        clsNPEmailSender.sendNpInPortRejection(caseToContactMapRequestFB, freqErrToCasesMap);
    }

    // reject cases
/* Will be done manually (user clicks a button) or by CastIron (after a successful call to Weasel ICH)
    Case[] casesToBeRejected = [select id, Status, RecordTypeId, Internal_Comments_Close_Reason__c from Case where id in :toRejectCases.keySet()];
    for (Case c: casesToBeRejected) {
        c.Status = clsCasesNpHandlerController.CASE_STATUS_NPORDERREJECTED;
        //noRT: c.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.CASE_RT_NPEXPORTCASEREJECTED);
        c.Internal_Comments_Close_Reason__c = toRejectCases.get(c.id);
    }
*/

    // Update cases
    Set<Case> casesToBeUpdated = new Set<Case>();
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
                if (c.Status == clsCasesNpHandlerController.CASE_STATUS_NEW ||
                    c.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED
                ) {
                    c.Status = newStatus;
                    casesToBeUpdated.add(c);
                }
            }
        }
    }
    if (!casesToUpdateSrchData.isEmpty()) {
        for (Case c: [
            SELECT Id, Status, NP_Customer_Number_Srch__c, NP_Telephone_Number_Srch__c
            FROM Case WHERE id IN :casesToUpdateSrchData.keySet()
        ]) {
            SrchData sd = casesToUpdateSrchData.get(c.Id);
            if (
                c.NP_Customer_Number_Srch__c != sd.custNr ||
                c.NP_Telephone_Number_Srch__c != sd.phoneNr
            ) {
                if (c.NP_Customer_Number_Srch__c != sd.custNr) {
                    c.NP_Customer_Number_Srch__c = sd.custNr;
                }
                if (c.NP_Telephone_Number_Srch__c != sd.phoneNr) {
                    c.NP_Telephone_Number_Srch__c = sd.phoneNr;
                }
                // check if the Case is to be updated with Status
                Case cFound = null;
                for (Case cx : casesToBeUpdated) {
                    if (cx.Id == c.Id) {
                        cFound = cx;
                        break;
                    }
                }
                if (cFound != null) {
                    // the Case is to be updated with Status
                    c.Status = cFound.Status;
                    casesToBeUpdated.remove(cFound);
                }
                casesToBeUpdated.add(c);
            }
        }
    }

    try {
/*
        if (casesToBeRejected != null && !casesToBeRejected.isEmpty())
            database.update(casesToBeRejected);
*/
        if (casesToBeUpdated != null && !casesToBeUpdated.isEmpty()) {
            List<Case> lst = new List<Case>();
            lst.addAll(casesToBeUpdated);
            database.update(lst);
        }
    } catch(Exception e){       
        System.debug('Error updating Case:' + e.getMessage());
    }
}