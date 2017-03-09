public class EditOwnContactDataController{

   public Contact contact;
   public String portalAdminUser{get; set;}
   public String portalBrugerRole{get; set;}
   public Address__C address{get; set;}
   public boolean displayAddressInfo{get; set;}
   PageReference returnPage;
   public ID contactId{get; set;}
   public boolean successFlag {get;set;}
   public boolean errorFlag {get;set;}
   public boolean warningFlag {get;set;}
   public String contactStatus { get; set; }
   public ID hierarchyStatus {get;set;} 
   public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('EditOwnContactDataController','Min Profile');
   private string fetchedEmail;
   public static boolean profilePortalContext = false;
   public String siteCoreUrl{get; set;}
     
   public Contact getContact(){
        return contact;
    }

    public void setContact(Contact c){
        this.contact = c; 
    }
    
    // Initialize the controller    
   public EditOwnContactDataController() {         
     setContactDetails();
     setStatus();
     portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
     portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
     siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
     fetchAddressDetails();
   }   
   
   public void setStatus(){
        String status = apexpages.currentpage().getparameters().get(contactConstClass.STATUS);
        ApexPages.Message myMsg;
        if(status == contactConstClass.PASSWORDCHANGED) {
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_ValidPassword);
            ApexPages.addMessage(myMsg);
            successFlag = true;
        }else if(status == contactConstClass.PASSWORDFAILED){
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_CantReuseOldPWD);
            ApexPages.addMessage(myMsg);
            errorFlag = true;
        }
   }
   
   /**
        Sets the Contact details for the contact. 
   */
    public void setContactDetails(){
        try {
            contactId = ApexPages.CurrentPage().getParameters().get('conId');
            //System.debug('ContactID--->'+contactId);
          
          	Contact con = [Select id,firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__c, AccountId , HierarchyAccount__c ,status__c, AlternateEmail__c, Permission__c From Contact  where id = :contactId LIMIT 1];
            hierarchyStatus = con.HierarchyAccount__c;
            //system.debug('$hierarchyStatus$'+hierarchyStatus);
            setContact(con);
            fetchedEmail=con.Email;
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);    
            ApexPages.addMessage(errorMsg);
        }    
    }   
    
    /**
        Action called when user clicks the Save button.Return back to the Home Page.
    */
    public PageReference save(){
        ApexPages.Message msg;
        try{
            //system.debug('before updating min profile*********');
            User[] user = [Select Id, firstname, lastname, isActive, email, Name  from User where contactId =: contact.id limit 1];
            //System.debug('user details size inside edit contact-->'+user.size());
            List<Contact> chkContactExists = new List<Contact>();
            //system.debug('***Quesry email***'+fetchedEmail);
            //system.debug('***Contact email***'+contact.Email);
            
            if(contact.email != fetchedEmail){
                
                //System.debug('----Inside if entered email is different from fetched email id----------');
                if(contact.email != null){
                    chkContactExists = [Select c.Phone, c.Name, c.MobilePhone, c.Id, c.HomePhone, c.HierarchyAccount__c, c.Email, c.AccountId,c.IsPersonAccount, c.Permission__c From Contact c where c.Email =: contact.email AND c.IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];             
                    //System.debug('editcontactcontroller---chkContactExists --->'+chkContactExists);
                }
            }
            //system.debug('**chkContactExists.size()***'+chkContactExists.size());
             
            if(chkContactExists != null && chkContactExists.size() > 0) { 
                msg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_MinProfilPageMsg);
                ApexPages.addMessage(msg);
                successFlag = false;
                errorFlag = false;
                warningFlag = true;
                return null;
             }else{
                if(user != null && user.size() > 0){
	                 System.debug('user details before updating user/contact-->'+user);
	                 user[0].email = contact.email;
	                 user[0].firstname = contact.firstname;
	                 user[0].lastname = contact.lastname;
	                 System.debug('user details after setting user/contact-->'+user[0]);
	                 update user[0];
                     
                     //Send mail functionality
                    /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            List<String> toAddresses = new List<String>();
             		//toAddresses.add('ashwini.shinde@capgemini.com');
            		toAddresses.add(user.Email);
	                mail.setToAddresses(toAddresses);
	                
	                mail.setTargetObjectId(user.Id);
	                mail.setSaveAsActivity(false);
	                mail.setTemplateId('00XM0000000HvM9');
	                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                }
                profilePortalContext = true;
                update contact;
                system.debug('after updating min profile*********'+contact);
                /*String newPageUrl = '/apex/ViewCableUnitsHomePage';
                PageReference newPage = new PageReference(newPageUrl);
                return newPage;*/
                msg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_MinProfilMsg);
                ApexPages.addMessage(msg);
                successFlag = true;
                errorFlag = false;
                warningFlag = false;
                return null;
            }
        } catch (Exception e){
                msg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);    
                ApexPages.addMessage(msg);
                successFlag = false;
                warningFlag = false;
                errorFlag = true;
                exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
                return null;
        }    
     }
            
    /**
        Action called when user clicks the Cancel button.Return back to the Home Page.
    */         
    public PageReference cancel()
     {
        returnPage = Page.ViewCableUnitsHomePage;  
         return returnPage;
     }     
     public PageReference fetchAddressDetails(){
        if(contact != null){
            String addressId=contact.Street_P__c;
            List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];     
            if(addressList.size() > 0){
                address = addressList.get(0);           
            }
        }
        displayAddressInfo = true;      
        return null;
     } 
     
    /* public void fetchContactDetails(){
     	ID userId = UserInfo.getUserId();
     	Contact userContact = [Select Id, HierarchyAccount__c, Status__c  From Contact where id in (select contactid from User where id =:userId) LIMIT 1];
     	system.debug('$USerContact$'+userContact);
     	contactStatus = userContact.Status__c;
     	hierarchyStatus = userContact.HierarchyAccount__c;
     	system.debug('$Details$'+contactStatus+'$hierarchyStatus$'+hierarchyStatus);
     }*/
     
       
}