trigger tgrEmailMessageAfterInsert on EmailMessage (after Insert) {
    
    // Map Case Ids to messages
    Map <Id, List<EmailMessage>> caseToEmailMap = new Map<Id, List<EmailMessage>>();
    for (EmailMessage m : Trigger.new) {
        if (m.Incoming == true && m.ParentId != null) {
            List<EmailMessage> messages = new List<EmailMessage>();
            if (caseToEmailMap.containsKey(m.ParentId) && caseToEmailMap.get(m.ParentId) != null) {
                messages = caseToEmailMap.get(m.ParentId);
            }
            messages.add(m);
            caseToEmailMap.put(m.ParentId, messages);
        }
    }

    if (!caseToEmailMap.isEmpty()) {
        // Select all NP in-port Cases waiting for customer's feedback on rejection
        List<Case> casesFeedback = [
            SELECT Id, Type_Task__c, Status, RecordTypeId, NP_Order__c, NP_Order__r.Status__c FROM Case 
            WHERE Id IN :caseToEmailMap.keySet()
                AND Type_Task__c = :clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT
                AND (NP_Order__r.Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK OR
                     NP_Order__r.Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED
                )
        ];
        List<Case> casesConfirm = [
            // Select all NP in-port Cases waiting for customer's confirmation
            SELECT Id, Type_Task__c, Status, RecordTypeId, NP_External_Operator_Name__c, NP_Order__c,
                AccountId, NP_Order__r.Status__c
            FROM Case 
            WHERE Id IN :caseToEmailMap.keySet()
                AND Type_Task__c = :clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT
                AND (NP_Order__r.Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION OR
                     NP_Order__r.Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPDECIPHERRESPONSE
                )
        ];

        if (casesFeedback != null && casesFeedback.size() > 0) {
            // Process NP in-port Cases waiting for customer's feedback on rejection
            Set<Id> orderIds = new Set<Id>();
            for (Case aCase : casesFeedback) {
                orderIds.add(aCase.NP_Order__c);
                // Set the values for Status and Record Type
                if (aCase.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                    aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
                }
                //noRT: aCase.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEFEEDBACKRECEIVED);
            }
            List<NP_Order__c> ordersFeedback = [SELECT Status__c FROM NP_Order__c WHERE Id IN :orderIds];
            for (NP_Order__c npo : ordersFeedback) {
                // Set the value for Status__c
                npo.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED;
            }
            update casesFeedback;
            update ordersFeedback;
        }

        if (casesConfirm != null && casesConfirm.size() > 0) {
            // Process NP in-port Cases waiting for customer's confirmation
            clsNPEmailConfirmationParser proc = new clsNPEmailConfirmationParser();
            proc.parseConfirmationEmail(caseToEmailMap, casesConfirm);
        }
    }

    //SPOC-598
    if (!caseToEmailMap.isEmpty()) {
        List<Case> YFFCases = [
            SELECT Id, CaseNumber, Product_2__c, Status, Department__c, OwnerId FROM Case
            WHERE Id IN :caseToEmailMap.keySet() AND Department__c = 'YFF'];
       
        if(YFFCases != null && YFFCases.size() > 0){
            Case aCase = YFFCases[0];

            List<EmailMessage> aMessages = caseToEmailMap.get(aCase.Id);
            if(aMessages != null && aMessages.size() > 0){
                EmailMessage aMessage = caseToEmailMap.get(aCase.Id)[0];
                Boolean sentMail = false;
                if(aMessage != null){
                    sentMail = sentMail || (aMessage.ToAddress != null && (aMessage.ToAddress.contains('foreningsservice@yousee.dk') || aMessage.ToAddress.contains('Foreningsservice@tdc.dk')));
                    sentMail = sentMail || (aMessage.CcAddress!= null && (aMessage.CcAddress.contains('foreningsservice@yousee.dk') || aMessage.CcAddress.contains('Foreningsservice@tdc.dk')));
                    sentMail = sentMail && (aCase.Status.equals('Reserved'));   
                    if(sentMail){
                        User user = [SELECT Id, Email From User WHERE Id = :aCase.OwnerId];
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                        String[] toAddresses = new String[] {user.Email};
                        mail.setToAddresses(toAddresses);
                        mail.setReplyTo('no-replay@salesforce.com');
                        mail.setSenderDisplayName('No replay');
                        mail.setSubject(System.Label.EM_Subject + ' ' + aCase.CaseNumber);
                        mail.setPlainTextBody(System.Label.EM_Body + ' ' + 'ID: ' + aCase.Id);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                }   
            }  
        }
    }
}