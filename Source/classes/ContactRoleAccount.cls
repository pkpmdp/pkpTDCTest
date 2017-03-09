public class ContactRoleAccount {
	 public ContactRoleAccount(){}	
	
     public Boolean	selected {get; set;}
     public string	viewContact {get; set;}
     public string 	editContact {get; set;}
     public string 	deleteContact {get; set;}
     public string 	space {get; set;}
     public string 	contactName {get; set;}
     public string 	email {get; set;}
     public string 	roleName {get; set;}    
     public ID 		accountId {get; set;}
     public ID 		contactId {get; set;}
     public ID 		cUId {get; set;}
      
     public ContactRoleAccount(Contact contact){
            selected = false;
            viewContact = contactConstClass.VIEW;
            editContact = contactConstClass.EDIT;
            deleteContact = contactConstClass.DELETED;
            space = contactConstClass.SPACE;  
            contactName	= contact.FirstName + '  ' + contact.LastName;
            email		= contact.Email;
            accountId 	= contact.AccountId;
            contactId	= contact.Id;                       
     }
}