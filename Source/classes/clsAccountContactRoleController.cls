public with sharing class clsAccountContactRoleController {

    private Account account;
    public Contact contact {get;set;}
    
	public clsAccountContactRoleController(ApexPages.StandardController controller) {
    	this.account = (Account) controller.getRecord();
    	contact = null;
		for (AccountContactRole acr : [select AccountId, ContactId, Contact.Name, Contact.LastModifiedDate, LastModifiedDate from AccountContactRole where AccountId = :account.id ]) {
			if (acr.LastModifiedDate > acr.Contact.LastModifiedDate) {
				contact = acr.Contact;
				break;	
			}
		}
    }
    
    public PageReference touchContact() {
    	if (contact != null) {
    		update new contact (id = contact.id);
    	}
    	contact = null;
    	return null;
    }
}