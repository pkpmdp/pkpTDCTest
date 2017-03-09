/* @ Author Navneet Rajput
*  @ Date 9/9/2011
*/

trigger tgrlookupCustomerSegmentBeforeDelete on Lookup_Customer_Segment__c (before delete) {
	
	//Tmp code to controll triggers in production
    //Retriving environment unique field ids for customer lookup fields
    YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
    Boolean runTrigger = false;
	YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
	//Start Trigger switch
	if (config != null && (runTrigger = config.Customer_Segment__c) == true) {
    
    for(Lookup_Customer_Segment__c old : trigger.old)
        old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
        
    }//End TMP Trigger switch 
/*
    // Added by navneet for preventing deletion of existing records 

    List <Lookup_Customer_Segment__c> customerSegmentList = trigger.old;
    List<Account> accountList = [select Customer_Segment_Lookup__c from Account where Customer_Segment_Lookup__c IN : customerSegmentList];

     if (trigger.isBefore && trigger.isDelete) {
        if (customerSegmentList.size() > 0 && accountList.size() > 0) {
            for (Lookup_Customer_Segment__c LCS : customerSegmentList) {
                for (Account acc : accountList) {
                     if (LCS.Id == acc.Customer_Segment_Lookup__c) {
                        LCS.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'); 
                        break;
                     }
                }
            
            }
        }
     }
    
*/
}