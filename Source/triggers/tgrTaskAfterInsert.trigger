trigger tgrTaskAfterInsert on Task (after Insert) {
    // Implementation of SUPPORT-1509 change request:
    // Collect related (Case?) Ids
    Set<Id> whatIds = new Set<Id>();
    for (Task t : Trigger.new) {
        if (t.Objective__c == 'Weasel Exception' && t.Description != null &&
            t.Description.contains('is owned by')
        ) {
            whatIds.add(t.whatId);
        }
    }
    if (!whatIds.isEmpty()) {
        // Collect only NP in-port Cases authorized for porting
        List<Case> cases = [
            SELECT Id, Type_Task__c, Status, NP_Order__c, NP_Order__r.Status__c FROM Case 
            WHERE Id IN :whatIds
            AND Type_Task__c = :clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT
            AND NP_Order__r.Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED
        ];
        if (!cases.isEmpty()) {
            Set<Id> npoIds = new Set<Id>();
            for (Case c : cases) {
                // NP in-port Case needs to be canceled
                c.Status = clsCasesNpHandlerController.CASE_STATUS_CANCELLED;
                if (c.NP_Order__c != null) {
                    npoIds.add(c.NP_Order__c);
                }
            }
            // Collect related NP Orders
            List<NP_Order__c> npos = [SELECT Status__c FROM NP_Order__c WHERE Id IN :npoIds];
            for (NP_Order__c npo : npos) {
                // NP Order needs to be canceled
                npo.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED;
            }
            update npos;  // Cancel NP Orders
            update cases; // Cancel NP in-port Cases
        }
    }
}