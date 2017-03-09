public class POContactPermissionELQController {
    private ApexPages.standardController controller;
    public Boolean permission{get;set;}
    public Contact contact;
    
    public List<Contact> contactList{get; set;}
    public Boolean isUnknownAddress{get;set;}
    
    public POContactPermissionELQController(ApexPages.StandardController controller) {
        controller = controller;
        contactList = new List<Contact>();
       //if(!Test.isRunningTest()){
	        contactList = [SELECT Permission__c, Address_merge_field__c FROM Contact WHERE Id = :((Contact) controller.getRecord()).Id];
	        if(contactList.size() > 0){
	        	contact = contactList[0];
		        contact = [SELECT Permission__c, Address_merge_field__c FROM Contact WHERE Id = :((Contact) controller.getRecord()).Id];
		        if(contact.Address_merge_field__c != null) {
		            if(contact.Address_merge_field__c.startsWith('Ukendt adresse'))
		               isUnknownAddress = true;
		            else
		               isUnknownAddress = false;
		        }
	      }
        //}
    }
    
    public void updatePermission() {
       if(contact != null){
       		contact.Permission__c = permission;
       		update contact;
       }    
    }


}