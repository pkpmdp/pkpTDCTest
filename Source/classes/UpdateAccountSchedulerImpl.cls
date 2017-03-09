/**
 * Implementation for scheduled job UpdateAccountScheduler
 */
public with sharing class UpdateAccountSchedulerImpl {

    public void runJob() {
        List<Scheduled_Update__c> scheduledItems = 
        [SELECT Id, Id__c FROM Scheduled_Update__c];
        
        Set<Id> accountIDs = new Set<Id>();
        for(Scheduled_Update__c scheduled_Update : scheduledItems) {
            accountIDs.add(Id.valueOf(scheduled_Update.Id__c));
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        accountsToUpdate = [SELECT Id FROM Account WHERE Id IN :accountIDs];
        
        for(Account account : accountsToUpdate) {
            account.Survey_sent_date__c = Date.Today();
        }
        
        update(accountsToUpdate);
        
        // clean the table
        delete(scheduledItems);        
        
    }    
}