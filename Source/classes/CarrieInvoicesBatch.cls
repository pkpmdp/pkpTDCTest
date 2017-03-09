/***********************************************************************************
************************************************************************************

* @class: CarrieInvoicesBatch
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 25/08/2013
* @description: Batch class for updating Faktura__c, Invoice_Payments__c, Payment_Invoice__c, Invoice_Subscription,
                Invoice_Usage__c, Aria_Account__c,Applied_Credit__c and Unapplied_Credit__c objects 
                by calling ARIa api (get_account_details, get_transaction_information, get_invoice_details)

************************************************************************************ 
***********************************************************************************/

global class CarrieInvoicesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    private Aria_API_Configuration__c config { get; private set; }  
    List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
    List<Aria_Account__c> acctsToUpdate = new List<Aria_Account__c>();
    public String query;
    public String billingResp = '';
    public String transactionResp = '';
    public String invoiceResp = '';
    String scheduledClass = '';
    
    public CarrieInvoicesBatch(String batchClass){
        //This string will determine the scheduled class which called the batch class. 
        //Required to construct different query strings for differnt schedulars.
        scheduledClass = batchClass;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            if(scheduledClass == 'CarrieBatchSchedular'){
                //Construct query string. Added conditions to filter aria accounts with blank and terminated status 
                //or has null invoice and payment dates. (For daily runs)
                
                //Removed filter Regningsstatus__c != 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where Regningsstatus__c != \'\' and '+
                        '(Faktureret1__c != null and Indbetalt__c != null) and API_calls__c = \'Transaction Created\'';
            }
            else if (scheduledClass == 'CarrieBatchSchedularWeekly'){
                //Construct query string. Selects only those aria accounts where status is blank or terminated 
                //or has null invoice and payment dates. (For weekly runs)
                
                //Removed filter Regningsstatus__c = 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where (Regningsstatus__c = \'\'  or '+
                        '(Faktureret1__c = null and Indbetalt__c = null)) and API_calls__c = \'Transaction Created\'';
            }
        }             
        system.debug('Query in CarrieInvoicesBatch' + query);
        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, List<sObject> ariaAccs){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
        ariaAccounts = (List<Aria_Account__c>)ariaAccs;
        Set<Id> accountIds = new Set<Id>();
        //Start consturct query string
        String billingQueryString = '';   
        String transQueryString = '';
        String invoiceQueryString = '';
        Integer count = 0;
        for(Aria_Account__c aria : ariaAccounts){
            accountIds.add(aria.Id);
            if(count == ariaAccounts.size()-1)  {
                transQueryString += 'acct_no='+aria.Name + ' AND transaction_type_no != -2 AND transaction_type_no != -3';
                invoiceQueryString += 'acct_no='+aria.Name;
                billingQueryString += 'acct_no='+aria.Name;
            }
            else{
                transQueryString += 'acct_no='+aria.Name+' OR ';
                invoiceQueryString += 'acct_no='+aria.Name+' OR '; 
                billingQueryString += 'acct_no='+aria.Name+' OR ';
            }
            count++;
        }
        
        if(!Test.isRunningTest()){
            //Fetch billing response from Aria
            HttpResponse billingResponse; 
            billingResponse = AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => billingQueryString});
            system.debug('billing response in batch ' +billingResponse.getBody());
            billingResp = billingResponse.getBody();
            
            //Fetch transaction response from Aria
            HttpResponse transactionResponse;
            transactionResponse = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => transQueryString });
            system.debug('transaction response in batch ' +transactionResponse.getBody());
            transactionResp = transactionResponse.getBody();
            
            //Fetch invoice response from Aria
            HttpResponse invoiceResponse; 
            invoiceResponse = AriaWebServices.makeCallForJson('get_invoice_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => invoiceQueryString });
            system.debug('invoiceResponse response in batch ' +invoiceResponse.getBody());
            invoiceResp = invoiceResponse.getBody();
        }
        
        CarrieInsertRecordsBatch carMan = new CarrieInsertRecordsBatch();
        carMan.updateAriaAccounts(ariaAccounts,true,billingResp);
        carMan.updateInvoicePayments(ariaAccounts,true,transactionResp,invoiceResp);
        carMan.updateOthers(accountIds);
    }

    global void finish(Database.BatchableContext BC){
        system.debug('scheduledClass in CarrieTransactionBatch ' + scheduledClass);
        CarrieBatchUtil insertRec = new CarrieBatchUtil();
        insertRec.sendEmail(BC.getJobId(),false);
        //Call the next batch
        if(!Test.isRunningTest()){
            CarrieUnappliedServiceCreditsBatch carrie = new CarrieUnappliedServiceCreditsBatch(scheduledClass);
            Database.executeBatch(carrie,1);
        }
    }
}