global class CarrieCustomersBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
   public String query;
       private Aria_API_Configuration__c config { get; private set; } 


public CarrieCustomersBatch()
{

}

 global Database.QueryLocator start(Database.BatchableContext BC)
 {
 	if(!Test.isRunningTest())
		query='select id,Customer_No__c from Account where IsDirty__c =true';
 
//query='Select Name, Updated__c,Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where Account__r.IsDirty__c =true';
  system.debug('Query in CarrieCustomersBatch ' + query);
        return Database.getQueryLocator(query);
 }

   global void execute(Database.BatchableContext BC, List<sObject> Accs){
        Integer count = 0;
        
        List<Account> Accounts_del = new List<Account>();
       Accounts_del= (List<Account>)Accs;
        
        //Fetch response from CarrieBillingControllerBatch 
         CarrieBillingControllerBatch batchController = new CarrieBillingControllerBatch(Accounts_del[0],'onetimebatch');
       
    }

global void finish(Database.BatchableContext BC){
System.debug('Batch is finished.........');
}

}