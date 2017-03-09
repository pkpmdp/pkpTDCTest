/*
    Description - This batch will run once every day to delete the inactive Amazon File records.
*/
global class Amazon_batchDeleteInActiveAmazonFiles implements Database.Batchable<sObject> {
    
    //Global string to be passed to Start Method
    global String query;
    global List<Cloud_File__c> listclf;
    
    global Amazon_batchDeleteInActiveAmazonFiles(){
        schema.describesobjectresult clfFiles = Cloud_File__c.sobjecttype.getdescribe();
        listclf = new List<Cloud_File__c>();
        query = 'SELECT Id, Name, IsActive__c '+'FROM Cloud_File__c WHERE IsActive__c = False';        
    }
    
    global Database.queryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('Inactive records= '+query);
        for(Cloud_File__c c : (List<Cloud_File__c>)scope){
            listclf.add(c);
        }
        system.debug('Iactive record list= '+listclf.size());
        /*system.debug('List Record 1= '+listclf[0]);
        system.debug('List Record 2= '+listclf[1]);
        system.debug('List Record 3= '+listclf[2]);
        system.debug('List Record 4= '+listclf[3]);*/
        
        if(!listclf.isEmpty()){
            delete listclf;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
      
}