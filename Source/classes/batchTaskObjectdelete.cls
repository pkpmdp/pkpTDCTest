/* Batch to delete ArchivedTask object records for Spoc -2018 */
global class batchTaskObjectdelete implements Database.Batchable<sObject>  {
    global String query;
    
    public batchTaskObjectdelete()
    {
            if (Test.isRunningTest()){
                //query = 'SELECT Id FROM Task WHERE IsArchived = true AND AccountId = null AND WhatId = null AND isDeleted=false order by CreatedDate Limit 1 ALL ROWS ';
                query = 'SELECT Id FROM Task WHERE subject=\'Testtask\'';
            } else{
            query = 'SELECT Id FROM Task WHERE IsArchived = true AND AccountId = null AND WhatId = null AND isDeleted=false AND CreatedDate >= LAST_N_Days:730';
            
            }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);

    }

    
    global void execute(Database.BatchableContext BC, List<Task> scope)
    {
       List <Task> TaskList= new list<Task>();
        for(Task t : scope)
        {
            
            TaskList.add(t);
        }
        delete TaskList;
        Database.emptyRecycleBin(TaskList);

                 
    }   
    global void finish(Database.BatchableContext ctx)
    {
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
                          FROM AsyncApexJob WHERE id = :ctx.getJobId()];
          String emailMessage = 'The batch job (Apex class: batchTaskObjectdelete ) has completed.\n\n' 
                              + 'The batch deletes Task object records which are archived.\n'
                              
                              + 'Number of transactions: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
                              + ' processed without any exceptions thrown. \n'                           
                              + 'Numbers of transactions that threw unhandled exceptions: ' + a.numberOfErrors + '.\n';
                                                          
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
          String[] toAddresses = new String[] {'tejas.naik@capgemini.com'};
          //List<String> toAddresses = new List<String>{'tejas.naik@capgemini.com'};
          //toAddresses = email.split(';'); 
          mail.setToAddresses(toAddresses);
          mail.setReplyTo('noreply@salesforce.com');
          mail.setSenderDisplayName('Service-Center Batch Job Summary');
          mail.setSubject('Service-Center batch job completed: batchTaskObjectdelete');
          mail.setPlainTextBody(emailMessage);
          mail.setHtmlBody(emailMessage);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
    
    }
    
}