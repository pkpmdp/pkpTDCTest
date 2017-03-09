global class batchCountAccountOnContact implements Database.Batchable<sObject>, Database.Stateful  {
     global String query;
     global List<Contact> cons;
     public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
     String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
     Private List<Account_Contact_Role__c>  acrs = new List<Account_Contact_Role__c>();
     Private Set<ID> uniqueAccs = new Set<ID>();
     public String Status='Aktiv';
     public string isTestRun;
     public string testContactID;
     global String mailMsg = ''; 
     public Set <id> ContactSet;  
                   
     
     global batchCountAccountOnContact(){
                   
        query = 'SELECT Id FROM Contact WHERE RecordtypeId = :ysContactRecordType AND isDeleted=false AND Status__c = :Status';       
     }
        
     global Database.queryLocator start(Database.BatchableContext BC){
         if(isTestRun == '1') {
            query += ' AND id=: testContactID Limit 1';
        }
         return Database.getQueryLocator(query); 
     }
     
      
     global void execute(Database.BatchableContext BC, List<sObject> scope){
         ContactSet = new Set<id>();     
         for(sObject s : scope){
             Contact c = (Contact)s;            
             contactSet.add(c.id);   
         }
         
        Map<String, Integer> mapAccountCount = getContactAccounts(contactSet);
        cons = new List<Contact>();        
        for(Id cid : contactSet ) {
            String value = String.valueof(mapAccountCount.get(String.valueof(cid)));
            Contact c = new Contact(id=cid, kundeAntal__c = value);
            cons.add(c);
        } 
        
        if(!cons.isEmpty()){
             //System.debug('******Wen Debug'+cons);
             //update cons; 
             Database.SaveResult[] lsr;               
             try{
                 lsr = Database.update(cons);
                 Integer recordIndex = 0;
                 for(Database.SaveResult sr : lsr) {
                     System.debug('******Wen Debug update results');                
                     if(!sr.isSuccess()) {
                         System.debug('*****Wen debug something is failing');                    
                         List<Database.Error> err = sr.getErrors();
                         mailMsg += 'Contac record: '+ cons[recordIndex].id +', '+ err[0].getMessage()+'<br/>';
                     } 
                     recordIndex++;
                 }
                 System.debug('******Wen debug mail message'+mailMsg);                       
             } catch (Exception e) {                                
                 mailMsg += e.getMessage() + '</br>';  
             }
         }  
     }
     
     private Map<String, Integer> getContactAccounts(Set<id> contacts)
     {
         Map<String, Integer> mapAccountCount = new Map<String, Integer>();
         string initContactId = '';
         Set<Id> setAccounts = new Set<Id>();
         
         
         List<Account_Contact_Role__c> listACR = [select id, contact__c, customer__c 
                                             from Account_Contact_Role__c 
                                             where contact__c in : contactSet
                                             order by contact__c];
         if(!listACR.isEmpty()) 
         {          
             initContactId  = listACR[0].contact__c;
             
             for(Account_Contact_Role__c acr : listACR) 
             {            
                  if(initContactId == acr.contact__c)
                  {
                    setAccounts.add(acr.customer__c);              
                  
                  } else {
    
                      // create the map                    
                      mapAccountCount.put(initContactId,setAccounts.size()); 
                                            
                      initContactId = acr.contact__c;
                      setAccounts = new Set<Id>();
                      setAccounts.add(acr.customer__c);                                 
                  }
                                    
            }
            mapAccountCount.put(initContactId,setAccounts.size()); 
         }
         //System.debug('******Wen debug mapAccountCount'+mapAccountCount);
         return mapAccountCount;
  }   
     

         
     global void finish(Database.BatchableContext BC){
          if(BC != NULL) { 
              AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];   
              sendEmail('Batchjob: CountAccountOnContact','The batch Apex job processed ' + a.TotalJobItems + ' batches with '+a.NumberOfErrors + ' failures.'+mailMsg);        
              /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              String[] toAddresses = new String[] {'wm@yousee.dk'};
              mail.setToAddresses(toAddresses);
              mail.setSubject('Batchjob: CountAccountOnContact');
              mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+a.NumberOfErrors + ' failures.'+mailMsg);
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
          }
     } 
      
     private void sendEmail(String subject, String mailbody) {
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'mast@tdc.dk', 'jpni@tdc.dk'};
         mail.setToAddresses(toAddresses);
         mail.setSubject(subject);
         mail.setPlainTextBody(mailbody);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }           

}