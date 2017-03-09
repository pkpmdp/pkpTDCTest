trigger tgrECommAccount on Account (after insert,after update) {
if(Trigger.isAfter){

if (Trigger.isInsert) {
for(Account acc: Trigger.new) {
if(acc.IsPersonAccount==true && acc.E_comm_agreement__c==true){
 
       MessagingEComm.callMessaging(''+acc.Id);
       system.debug('acc.E_comm_agreement__c in insert '+acc.E_comm_agreement__c);
    
         }

    }
}
if (Trigger.isUpdate) {
    for(Account acc: Trigger.new) {
    if (acc.IsPersonAccount==true && Trigger.oldMap.get(acc.Id).E_comm_agreement__c ==false && acc.E_comm_agreement__c==true){
        
        MessagingEComm.callMessaging(''+acc.Id);
        system.debug('acc.E_comm_agreement__c in update '+acc.E_comm_agreement__c);                                                                        
        } 

    }
    }

}
}