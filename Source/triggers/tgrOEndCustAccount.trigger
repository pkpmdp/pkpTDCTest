trigger tgrOEndCustAccount on Account (after insert) {

for(Account acc: Trigger.new) {
if(acc.IsPersonAccount==true && acc.PersonEmail!=null){
         if(acc.RecordTypeName__c=='YK Customer Account' && acc.Customer_type__c=='Enkel' && acc.CustomerSubType__c=='O-Slutkunde' ){
         MessagingOEndCustomer.callMessaging(''+acc.Id);         
         }
         else if(acc.RecordTypeName__c=='YK Prospect Account' && acc.CustomerSubType__c=='O-Slutkunde'){         
         MessagingOEndCustomer.callMessaging(''+acc.Id);
         }
        system.debug('Trigger tgrOEndCustAccount executed');
         }
         

    }

}