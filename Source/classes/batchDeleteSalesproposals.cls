/*
    SPOC-1626
    Description - This batch will run every week to delete old Salesproposals.
            When the Salesproposals reach the Expiration_Date they will be deleted.
*/

global class batchDeleteSalesproposals implements Database.Batchable<sObject> {  
  //constructor
  global batchDeleteSalesproposals(){}
  
  global Database.Querylocator start(Database.BatchableContext BC){
    String query = 'SELECT Id, Expiration_Date__c FROM Salesproposal__c WHERE CreatedDate < TODAY';
    return Database.getQueryLocator(query);
  }
  
  global void execute(Database.BatchableContext BC, List<sObject> scope){
    List<Salesproposal__c> salesProposalDelete = new List<Salesproposal__c>();
    for(sObject s : scope){
      Salesproposal__c sp = (Salesproposal__c)s;
      if(sp.Expiration_Date__c <= system.today()){
        salesProposalDelete.add(sp);
      }
    }
    //System.debug('@@@@@@@@@@ ' + salesProposalDelete);
    //delete salesProposalDelete; 
    if(salesProposalDelete.size() != 0){
    	Database.DeleteResult[] drList = Database.delete(salesProposalDelete, false);   
    	Database.emptyRecycleBin(salesProposalDelete);
    }
  }
  
  global void finish(Database.BatchableContext BC){
    if(BC != NULL) {
      AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {System.label.Recipient_email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  } 
}