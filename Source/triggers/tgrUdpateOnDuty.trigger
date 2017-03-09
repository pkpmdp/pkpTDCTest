trigger tgrUdpateOnDuty on YO_OperationConsultant__c (after update, after insert) {
    
    /*
    This trigger is used to update the 'on duty' field.   
    We can have only one onduty consultants at a time. 
    So if a cosultant edits the onduty field to checked then the current consultant 
    onduty field should get updated to unchecked.
    */
    for(YO_OperationConsultant__c oc : trigger.new){
        if(oc.onDuty__c == true){
            
            List<YO_OperationConsultant__c> ocList = [Select Id From YO_OperationConsultant__c 
            Where onDuty__c =: true AND id !=: oc.id AND RecordTypeId =: oc.RecordTypeId];
                                        
            for(YO_OperationConsultant__c  opConsultant: ocList) {
                opConsultant.onDuty__c = false;
            }
            if(ocList != null && ocList.size() > 0){   
                update ocList;
            }     
        }
    }
}