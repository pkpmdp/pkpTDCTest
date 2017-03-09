/* @ Author Navneet Rajput
*  @ Date 9/9/2011
*/

trigger tgrLookupAccountTeamMemberBeforeDelete on Lookup_Account_Team_Member__c (before delete) {
	
	//Tmp code to controll triggers in production
	//Retriving environment unique field ids for customer lookup fields
	YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
	Boolean runTrigger = false;
	YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
	//Start Trigger switch
	if (config != null && (runTrigger = config.Customer_Team_Member__c) == true) {
	
	
	for(Lookup_Account_Team_Member__c old : trigger.old)
		old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
/*
    List <Lookup_Account_Team_Member__c> accountTeamMemberList = trigger.old;
    List<Account_Team__c> accountTeamList = [select Customer_Team_Member__c from Account_Team__c where Customer_Team_Member__c IN : accountTeamMemberList];

    // if (trigger.isBefore && trigger.isDelete) {
        if (accountTeamMemberList.size() > 0 && accountTeamList.size() > 0) {
            for (Lookup_Account_Team_Member__c LATM : accountTeamMemberList) {
                for (Account_Team__c acc : accountTeamList) {
                     if (LATM.Id == acc.Customer_Team_Member__c) {
                        LATM.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'); 
                        break;
                     } 
                }
            
            }
        }
     //}
    
    // Ended 
*/
	}//End TMP Trigger switch

}