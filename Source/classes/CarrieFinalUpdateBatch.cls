/***********************************************************************************
************************************************************************************

* @class: CarrieFinalUpdateBatch
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 23/01/2014
* @description: Batch class for LastModifiedDateAria__c for accounts that were processed 
				succesfully thourgh batches. CARRIE-1418

************************************************************************************ 
***********************************************************************************/

global class CarrieFinalUpdateBatch implements Database.Batchable<sObject>{
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            query = '';
            String dateTimeFormat = DateTime.now().format('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            query = 'Select LastModifiedDateAria__c, API_calls__c, Updated__c, Id from Aria_Account__c '+
            		'where (API_calls__c = \'Transaction Created\' or  API_calls__c = \'\') and ' +
            		'LastModifiedDate >= ' + dateTimeFormat;
        }
        system.debug('Query in CarrieFinalUpdateBatch ' + query);
        return Database.getQueryLocator(query);
    } 
     
    global void execute(Database.BatchableContext BC, List<sObject> ariaAccs){
        List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
        ariaAccounts = (List<Aria_Account__c>)ariaAccs;
        for(Aria_Account__c aria : ariaAccounts){
            aria.LastModifiedDateAria__c = System.now();
        }
        update ariaAccounts;
    }    
    
    global void finish(Database.BatchableContext BC){
        CarrieBatchUtil insertRec = new CarrieBatchUtil();
        insertRec.sendEmail(BC.getJobId(),false);
    }
}