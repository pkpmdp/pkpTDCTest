/* @ Author Navneet Rajput
*  @ Date 9/9/2011
*/

trigger tgrLookupCustomerSatisfactionDelete on Lookup_Customer_Satisfaction__c (before delete) {
    
    //Tmp code to controll triggers in production
	//Retriving environment unique field ids for customer lookup fields
	YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
	Boolean runTrigger = false;
	YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
	//Start Trigger switch
	if (config != null && (runTrigger = config.Customer_Satisfaction__c) == true) {
    
    for(Lookup_Customer_Satisfaction__c old : trigger.old)
        old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
    
/*
    // Added by navneet for preventing deletion of existing records 

    List <Lookup_Customer_Satisfaction__c> customerSatisfactionList = trigger.old;
    List<Account> accountList = [select Customer_Satisfaction_Lookup__c from Account where Customer_Satisfaction_Lookup__c IN : customerSatisfactionList];

   
        if (customerSatisfactionList.size() > 0 && accountList.size() > 0) {
            for (Lookup_Customer_Satisfaction__c LCS : customerSatisfactionList) {
                for (Account acc : accountList) {
                     if (LCS.Id == acc.Customer_Satisfaction_Lookup__c) {
                        LCS.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'); 
                        break;
                     }
                }
            
            }
        }
*/
}//End TMP Trigger switch

}