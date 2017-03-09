global class CarrieAriaBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
   public String query;
       private Aria_API_Configuration__c config { get; private set; } 


public CarrieAriaBatch()
{

}

 global Database.QueryLocator start(Database.BatchableContext BC)
 {
 	if(!Test.isRunningTest())
		query='Select Name, Updated__c,Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where Account__r.IsDirty__c =true';
  system.debug('Query in CarrieCustomersBatch ' + query);
        return Database.getQueryLocator(query);
 }

   global void execute(Database.BatchableContext BC, List<sObject> Accs){
        Integer count = 0;
        
        //List<Account> Accounts_del = new List<Account>();
        //Accounts_del= (List<Account>)Accs;
        
        //Fetch response from CarrieBillingControllerBatch 
        // CarrieBillingControllerBatch batchController = new CarrieBillingControllerBatch(Accounts_del[0],'onetimebatch');
        //batchController.upsertAriaAccount();   
        
        //For transaction
        
         list<Aria_Account__c> ac= new list<Aria_Account__c>();
                 ac= (List<Aria_Account__c>)Accs;

       // list<Aria_Account__c> ac= [Select Name, Updated__c,Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Account__c = :oppty.Id];
       // for(Aria_Account__c a1:ac){
        CarrieBillingBatchController CBC= new CarrieBillingBatchController(ac[0]);
       CBC.refreshNewAccounts();
       // }    
    }

global void finish(Database.BatchableContext BC){
System.debug('Batch is finished.........');
}

}