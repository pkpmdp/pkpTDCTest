global class batchRetrieveCustomerTeam implements Database.Batchable<sObject>, Database.Stateful{
    global String query;
    global List<Account> accs;
    public Map<Id, Account> mapCustomer;
    global String mailMsg = '';
    public string isTestRun;
    public string testID;
    public String roleType1;
    public String roleType2;
    global batchRetrieveCustomerTeam(){                   
        query = 'SELECT Id, Customer__r.name, Customer__c, Customer_Team_Member__r.name, Customer_Team_Member__c, Customer_Team_Role__r.name FROM Account_Team__c WHERE isDeleted=false AND (Customer_Team_Role__r.name = :roleType1 OR Customer_Team_Role__r.name =: roleType2)'; 
     }
    global Database.queryLocator start(Database.BatchableContext BC){
        if(isTestRun == '1'){
            query += ' AND id =: testID';
            roleType1 = 'TestRole1';
            roleType2 = 'TestRole2';
        }else{
            query +=' order by Customer__c';
            roleType1 = 'Kundeansvarlig';
            roleType2 = 'Salgsansvarlig';
        }
        System.debug('***Wen'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        // accs = new List<Account>();
         mapCustomer = new Map<Id, Account>();
         Account c;
         for(sObject s : scope){
             Account_Team__c acct = (Account_Team__c)s;
             System.debug('*****Wen'+acct.Customer_Team_Member__r.name);
             if(mapCustomer.containsKey(acct.Customer__c)){
                c = mapCustomer.get(acct.Customer__c);
                if(acct.Customer_Team_Role__r.name == roleType1) {
                    c.kundeansvarligc__c = acct.Customer_Team_Member__c;
                }
                if(acct.Customer_Team_Role__r.name == roleType2) {
                    c.salgsansvarlig__c = acct.Customer_Team_Member__c;
                }
                mapCustomer.put(c.Id, c);
             }else {
                c = new Account(id=acct.Customer__c);
                if(acct.Customer_Team_Role__r.name == roleType1) {
                    c.kundeansvarligc__c = acct.Customer_Team_Member__c;
                }
                if(acct.Customer_Team_Role__r.name == roleType2) {
                    c.salgsansvarlig__c = acct.Customer_Team_Member__c;
                }
                mapCustomer.put(c.Id, c);
             } 
         }
         if(mapCustomer.size() > 0){
             Database.SaveResult[] lsr;     
             try{
             	 accs = new List<Account>();
             	 accs = mapCustomer.values();
                 lsr = Database.update(accs);
                 Integer recordIndex = 0;
                 for(Database.SaveResult sr : lsr){
                     System.debug('******Wen Debug update results');
                     if(!sr.isSuccess()){
                         System.debug('*****Wen debug something is failing');
                         List<Database.Error> err = sr.getErrors();
                         mailMsg += 'Contac record: '+ accs[recordIndex].id +', '+ err[0].getMessage()+'<br/>';
                     }
                     recordIndex++;
                 }
                 System.debug('******Wen debug mail message'+mailMsg);
             } catch (Exception e){
                 mailMsg += e.getMessage() + '</br>';
             }
         }
    }
    global void finish(Database.BatchableContext BC){
        if(BC != NULL) {
              AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
              sendEmail('Batchjob: RetriveCustomerTeam','The batch Apex job processed ' + a.TotalJobItems + ' batches with '+a.NumberOfErrors + ' failures.'+mailMsg);
          }
    }
    private void sendEmail(String subject, String mailbody){
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'jpni@tdc.dk', 'rosa@tdc.dk'};
         mail.setToAddresses(toAddresses);
         mail.setSubject(subject);
         mail.setPlainTextBody(mailbody);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
}