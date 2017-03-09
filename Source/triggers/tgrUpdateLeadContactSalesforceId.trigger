trigger tgrUpdateLeadContactSalesforceId on CampaignMember (after insert) {
   /* The trigger is used to implement the requirement for SF- 1195 
   Will have a new field Salesforce Id on Contact & lead  
   When a  Contact or Lead is assigned to a campaign then the Salesforceid will be populated with Camapign member Id */
   
   public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');    
   public String CampJF = yousee13.Jylland_Fyn_Campaign__c;
   public String CampSj = yousee13.Sjaelland_Campaign__c;
   public String CampSk = yousee13.Copenhagen_Campaign__c;
   
   List<Contact> contactList = null;
   List<Lead> leadList = null;  
   for (CampaignMember campaignMember : Trigger.new) {
     try{
         
         String campaignId = String.valueOf(campaignMember.CampaignId);
         if(campaignId.contains(CampJF) || campaignId.contains(CampSj)  || campaignId.contains(CampSk)){  
         	// If a contact is added to campaign 
	         if(campaignMember.ContactId != null){
	            contactList = [Select id, Salesforce_ID__c from Contact where id =: campaignMember.ContactId limit 1 ];
	            if(contactList != null && contactList.size() > 0){
	                contactList[0].Salesforce_ID__c = campaignMember.id;
	                update contactList[0];
	            }   
	         }else if(campaignMember.LeadId != null){ // If a lead is added to campaign
	            leadList = [Select id, Salesforce_ID__c from Lead where id =: campaignMember.LeadId  limit 1];
	            if(leadList != null && leadList.size() > 0){
	                leadList[0].Salesforce_ID__c = campaignMember.id;
	                 update leadList[0];
	            }   
	         }
         }    
     }catch(Exception ex){
        String errorMsg = ex.getMessage();
        if(errorMsg.contains('first error:')){
             errorMsg = errorMsg.subString(errorMsg.indexOf('first error:') + 12,errorMsg.length());
        }
        trigger.new[0].addError(errorMsg);
     }   
   }  
   
   
      
}