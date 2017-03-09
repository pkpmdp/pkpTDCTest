public class clsConvertLeadUtil {
    
    // Created: 18-Mar-2009
    // By: Darren Sabey
    // SOW: EMEA_SOW_YouSee_001
    // ======Requirement======
    // When a YS lead is converted set the address 
    // of the contact to be the same as the original lead
    static final String YS_LEAD_RECORD_TYPE_ID = '012200000000nzaAAA';
    String testRecordID;
    String ykLeadType;
    public void setContactAddresses(List<Lead> updatedLeads) {
    	// Store records to update in a list for efficiency
        List<Contact> contactsToUpdate = new List<Contact>();
        // Iterate through the updated leads
        for (Lead l : updatedLeads) {
            // Only process YS leads - YK are person accounts
            System.debug('**********l******'+l);
            if (l.RecordTypeId == YS_LEAD_RECORD_TYPE_ID) {
                // Check to see if the lead was converted into a contact
               System.debug('*******l.RecordTypeId*************'+l.RecordTypeId);
                if (l.ConvertedContactId != null) {
                    System.debug('****************l.ConvertedContactId'+l.ConvertedContactId);
        	        // If it was update the contact record with the address
        	        Contact contact = new Contact(id=l.ConvertedContactId);
        	        contact.Street_P__c = l.Street_Lookup__c;
        	        contactsToUpdate.add(contact);
                }
            }
        }
        // Update the contact records in bulk to optimise DML
        Database.SaveResult[] results = Database.update(contactsToUpdate);    	
    }
}