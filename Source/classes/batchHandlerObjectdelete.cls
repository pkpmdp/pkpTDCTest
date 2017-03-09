/* Batch to delete Handler object records which were created 395 days before Spoc -1866 */
global class batchHandlerObjectdelete implements Database.Batchable<sObject>  {
    global String query;
    
    public batchHandlerObjectdelete()
    {
            if (Test.isRunningTest()){
                query = 'SELECT CreatedDate FROM Handler__c WHERE CreatedDate < N_DAYS_AGO:395 order by CreatedDate Limit 1';
            
            } else{
            query = 'SELECT Id,CreatedDate FROM Handler__c WHERE CreatedDate < N_DAYS_AGO:395';
            
            }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);

    }

    
    global void execute(Database.BatchableContext BC, List<Handler__c> scope)
    {
        List <Handler__c> handlerList= new list<Handler__c>();
        for(Handler__c s : scope)
        {
            
            handlerList.add(s);
        }
        delete handlerList;
         
    }   
    global void finish(Database.BatchableContext BC)
    {
        system.debug('HandlerObjectdeleteBatch ID is ----------'+BC.getJobId());
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        system.debug('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        system.debug('Status for job' + a.Status);
    
    }
    
}