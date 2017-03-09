trigger LoginTrigger on ForhandlerInformations__c (after update, after insert, after delete) {

     string loginMessage='';
     List<ForhandlerInformations__c > loginRec = [Select f.Sequence_Number__c, f.Page_Type__c, f.Description__c From ForhandlerInformations__c f where f.Page_Type__c='Login Page' order by  f.Sequence_Number__c];
     for(ForhandlerInformations__c docRecord : loginRec){
     loginMessage = loginMessage + '\n' + docRecord.Description__c;
     }
                  Blob blbVal = Blob.valueof(loginMessage);
                  // LoginTriggerClass.uploadDocument(blbVal );
                 Document document = new Document();
                 document=[select id,Name,Body,BodyLength from Document where name ='LoginPage'];
                if(document.BodyLength > 0){
                    document.Body = blbVal ;
                   
           try {
                  upsert document;
                } 
          catch (DMLException e) {
                System.debug('Exception-->' + e.getMessage());
               } 
          finally {
              document = new Document();
                }    
          
     }
}