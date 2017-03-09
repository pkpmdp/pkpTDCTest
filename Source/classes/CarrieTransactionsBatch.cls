/***********************************************************************************
************************************************************************************

* @class: CarrieTransactionsBatch
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 25/08/2013
* @description: Batch class for updating Payment__c and Transaction__c objects by calling ARIa api (get_acct_trans_history)

************************************************************************************ 
***********************************************************************************/

global class CarrieTransactionsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    private Aria_API_Configuration__c config { get; private set; } 
    List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
    List<Aria_Account__c> acctsToUpdate = new List<Aria_Account__c>();
    public String query;
    public String response = '';
    Map<String,DateTime> dateMap = new Map<String,DateTime>();
    String scheduledClass = '';
    
    public CarrieTransactionsBatch(String batchClass){
        //This string will determine the scheduled class which called the batch class. 
        //Required to construct different query strings for differnt schedulars.
        system.debug('batchClass ' + batchClass);
        scheduledClass = batchClass; 
        system.debug('testClass'+batchClass);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){    
            if(scheduledClass == 'CarrieBatchSchedular'){
                //Construct query string. Added conditions to filter aria accounts with blank and terminated status 
                //or has null invoice and payment dates. (For daily runs)
                
                //Removed filter Regningsstatus__c != 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Updated__c,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where Regningsstatus__c != \'\' and '+
                        '(Faktureret1__c != null and Indbetalt__c != null)';
            }
            else if (scheduledClass == 'CarrieBatchSchedularWeekly'){
                //Construct query string. Selects only those aria accounts where status is blank or terminated 
                //or has null invoice and payment dates. (For weekly runs)
                
                //Removed filter Regningsstatus__c = 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Updated__c,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where Regningsstatus__c = \'\' or '+
                        '(Faktureret1__c = null and Indbetalt__c = null)';
            }
        }  
        //tEST CLASS CHANGES
        else
        { 
			    if(scheduledClass == 'CarrieBatchSchedular'){
                //Construct query string. Added conditions to filter aria accounts with blank and terminated status 
                //or has null invoice and payment dates. (For daily runs)
                
                //Removed filter Regningsstatus__c != 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Updated__c,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where Regningsstatus__c != \'\' and '+
                        '(Faktureret1__c != null and Indbetalt__c != null) limit 10';
            }
            else if (scheduledClass == 'CarrieBatchSchedularWeekly'){
                //Construct query string. Selects only those aria accounts where status is blank or terminated 
                //or has null invoice and payment dates. (For weekly runs)
                
                //Removed filter Regningsstatus__c = 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Updated__c,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where Regningsstatus__c = \'\' or '+
                        '(Faktureret1__c = null and Indbetalt__c = null) limit 10';
            } 
        }
        system.debug('Query in CarrieTransactionsBatch ' + query);
        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, List<sObject> ariaAccs){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        Integer count = 0;
        String billingQueryString = '';  
        List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
        List<DateTime> dateTimeList = new List<DateTime>();
        ariaAccounts = (List<Aria_Account__c>)ariaAccs;
        
        //Fetch response from CarriePaymentController
        CarriePaymentController paymentController = new CarriePaymentController(ariaAccounts[0]);
        if(!Test.isRunningTest()){
            response = paymentController.getAriaResponse();
        }
        CarrieInsertRecordsBatch car = new CarrieInsertRecordsBatch();
        car.updatePaymentTransactions(ariaAccounts,true,response);  
    }

    global void finish(Database.BatchableContext BC){
        //Send email to batch owner
        system.debug('scheduledClass in CarrieTransactionBatch ' + scheduledClass);
        CarrieBatchUtil insertRec = new CarrieBatchUtil();
        //tEST CLASS CHANGES
        if(!Test.isRunningTest()){
        	insertRec.sendEmail(BC.getJobId(),false);
        }
        //Call the next batch
        if(!Test.isRunningTest()){
            CarrieInvoicesBatch carrie = new CarrieInvoicesBatch(scheduledClass);
            Database.executeBatch(carrie,35);
        }
    }
}