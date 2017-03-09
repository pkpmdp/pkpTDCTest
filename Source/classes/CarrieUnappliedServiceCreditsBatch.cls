/***********************************************************************************
************************************************************************************

* @class: CarrieUnappliedServiceCreditsBatch
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 25/08/2013
* @description: Batch class for updating Unapplied_Credit__c object by calling ARIa api (get_unapplied_service_credits)

************************************************************************************ 
***********************************************************************************/

global class CarrieUnappliedServiceCreditsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful{
    
    private Aria_API_Configuration__c config { get; private set; } 
    List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
    List<Aria_Account__c> acctsToUpdate = new List<Aria_Account__c>();
    global Set<String>setAriaAccName = new Set<String>();
    public String query;
    public String creditResponse = '';
    String scheduledClass = '';
         
    public CarrieUnappliedServiceCreditsBatch(String  batchClass){
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
                   
                /*CarrieBatchQueries__c cbq = new CarrieBatchQueries__c();
                cbq = [Select QueryString__c from CarrieBatchQueries__c where BatchName__c = 'UnappliedCreditsDaily' limit 1];
                query = cbq.QueryString__c;*/
            }
            else if (scheduledClass == 'CarrieBatchSchedularWeekly'){
                //Construct query string. Selects only those aria accounts where status is blank or terminated 
                //or has null invoice and payment dates. (For weekly runs)
                
                //Removed filter Regningsstatus__c = 'TERMINATED'. JIRA issue: CARRIE-1417
                query = 'Select Id,Name,Account__r.Customer_No__c,Account__c,Aria_Account_No__c,Aria_Plan_Name__c,LastModifiedDateAria__c ' +
                        'from Aria_Account__c ' +                        
                        'where (Regningsstatus__c = \'\' or '+
                        '(Faktureret1__c = null and Indbetalt__c = null)) and API_calls__c = \'Transaction Created\'';
                 
                /*CarrieBatchQueries__c cbq = new CarrieBatchQueries__c();
                cbq = [Select QueryString__c from CarrieBatchQueries__c where BatchName__c = 'UnappliedCreditsWeekend' limit 1];
                query = cbq.QueryString__c;*/  
            }
        }             
        system.debug('Query in CarrieUnappliedServiceCreditsBatch' + query);
        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, List<sObject> ariaAccs){
        system.debug('In CarrieUnappliedServiceCreditsBatch ****** Execute method');
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
        ariaAccounts = (List<Aria_Account__c>)ariaAccs;
        String unappCredQueryString = ariaAccounts[0].Name;
        setAriaAccName.add(ariaAccounts[0].Name);
        system.debug('******* unappCredQueryString+ '+unappCredQueryString);
        if(!Test.isRunningTest()){
            //Fetch unapplied service credits response from aria
            HttpResponse unappCredResponse;
            unappCredResponse = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_unapplied_service_credits', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'acct_no' => unappCredQueryString });
            system.debug('unapplied credit response in batch ' +unappCredResponse.getBody());
            creditResponse = unappCredResponse.getBody();
        }
        CarrieInsertRecordsBatch carMan = new CarrieInsertRecordsBatch();
        carMan.updateCredits(ariaAccounts,true,creditResponse);
  
    }
 
    global void finish(Database.BatchableContext BC){
        system.debug('In CarrieUnappliedServiceCreditsBatch ****** Finish method');
        system.debug('setAriaAccName ****** Finish method'+setAriaAccName);
        CarrieBatchUtil insertRec = new CarrieBatchUtil();
        insertRec.sendEmail(BC.getJobId(),false);
        //Call the blockbuster batch to get type/title for blockbuster customers
        if(!Test.isRunningTest()){
            
            BlockBusterGetTypeTitleBatch bbBatch = new BlockBusterGetTypeTitleBatch(setAriaAccName,true);
            Database.executeBatch(bbBatch,1);
            //CarrieFinalUpdateBatch  carrie = new CarrieFinalUpdateBatch();
            //Database.executeBatch(carrie,1500);
        }
    }
}