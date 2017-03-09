/* @ Author : Michel Hansen
* @ Date : 16-10-2011
* Test-class: clsContactTest
* @ Description : Trigger prevent deletion of contact record if that contact has refered in to Account Contact Role object
* Code must be replaced later with bulk api so related records are deleted automatically when a contact is deleted
*/  

trigger tgrContactBeforeDelete on Contact (before delete) { 
    //Fetch YS contact record type 
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
    String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;  
    
    List<DeletedContactRole__c> deletedRecords = new List<DeletedContactRole__c>();
    if (Trigger.isDelete){
        Set <Id> contactIdSet = new Set<Id>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        
        //Gather all contact Id's in a unique Set   
        for(Contact con: Trigger.old){
            if(!contactIdSet.contains(con.Id) && con.RecordTypeId == ysContactRecordType)
                contactIdSet.add(con.Id);
        }
        
        if(contactIdSet.size() > 0){
            //Identify those contacts that have related roles.
            //for(Contact con: [select Id, Contact__c from Account_Contact_Role__c where Contact__c IN : contactIdSet]){
            for(Contact con: [select Id from Contact where Id IN (Select Contact__c from Account_Contact_Role__c where Contact__r.Id IN : contactIdSet) ]){
                if(contactMap.get(con.Id) == null)
                    contactMap.put(con.Id, con);              
            }        
        }  
        
        //Traverse through all contacts and delete if no associated contact roles exist.
        for(Contact contact: Trigger.old){
            //The validation flow below with subsequent transfer to DeletedContactRole__c only concern YS contacts 
            if(contact.IsPersonAccount == false && contact.KissPartyId__c !='' && contact.Temporary_contact__c == false && contact.RecordTypeId == ysContactRecordType){
                if(contactMap.get(contact.Id) != null)
                    contact.addError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
                else{   
                    DeletedContactRole__c delContact = new DeletedContactRole__c();
                    delContact.ContactExternalId__c = contact.KissPartyId__c; 
                    delContact.Contact_Name__c = contact.name;
                    deletedRecords.add(delContact);
                }
            }
        }    
        
        //Update database with deleted contacts that are sent outbound
        if(deletedRecords.size() != 0) {
            Database.SaveResult[] resultsAccount = Database.insert(deletedRecords);
        }
    }          
}//End trigger