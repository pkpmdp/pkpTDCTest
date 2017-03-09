/*Purpose : To update the selected contact details, Role and send mail to user. LastName, phone number and Roles are the mandatory fields.*/

public class EditContactController extends ContactBaseClass{
 public String portalBrugerRole {get; set;}
 public string cableUnitName{get;set;}
 public String localAccountId;
 public String emailFlag;
 public String emailChk {get; set;}
 //public String historyEntryFlag {get; set;}
 public String freeFlyingContact {get; set;}
 public String antalkopier {get;set;}
 public boolean displayAddressInfo{get; set;}
 public Address__C address{get; set;}
 public String siteCoreUrl{get; set;}
 public String contactRoleBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
 public String contactRoleAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
 public Boolean renderSection{get;set;}//support-5377
 public String cableUnitNumber;//support-5377
 ContactService service = new ContactService();

 /*------ Property & Variable Region ------*/
 ID fetchedId, fetchedAccountId,hierarchyAccntId;
 public ID contactId;
 public Id currentAccountId {get; set;}

 ID[] assignedItems= new ID[]{};

 //public string[] availableItems {get;set;}


  public boolean errorFlag {get;set;}
 public boolean successFlag {get;set;}
 public boolean warningFlag {get;set;}
 public Boolean chkFlag{get;set;}
 public Boolean isContactVisible{get;set;}
 public Boolean isRoleFlag{get;set;}
 
 // Variable added to generate exception for test classes
 public Boolean tempTestFlag = false;

 String roleSelected,roleSelectedId,accountId;
 //String roleSelected,accountId;
 //Id[] roleSelectedId;
 //Added for check
 ID[] roleSelId;
 // the contact record you are adding values
 public Contact contact = new Contact();
 //Added as per the issue jira 403
 public Account_Contact_Role__c acrContact = new Account_Contact_Role__c();

 List<SelectOption> options = new List<SelectOption>();
 List<Account_Contact_Role__c> acrContactList = new List<Account_Contact_Role__c>();
 List<Account_Contact_Role__c> acrContactList2 = new List<Account_Contact_Role__c>();

 public List<Contact> contactHistoryList = new List<Contact>();
 public List<ContactRoleAccount> filteredContacts = new List<ContactRoleAccount>();
 public List<History_Log_External_Contact_Role__c> historyContactLog = new List<History_Log_External_Contact_Role__c>();

 public ID getFetchedId(){
   return  fetchedId;
 }
 public void setFetchedId(ID fetchedId){
   this.fetchedId = fetchedId;
 }
 public String getEmailFlag() {
   return emailFlag;
 }
 public void setEmailFlag(string eFlag){
   emailFlag = eFlag;
 }
 public ID getFetchedAccountId(){
   return  fetchedAccountId;
 }
 public void setFetchedAccountId(ID fetchedAccountId){
   this.fetchedAccountId = fetchedAccountId;
 }
 public String getRoleSelected (){
   return roleSelected;
 }
 public void setRoleSelected(String roleSelected){
   this.roleSelected = roleSelected;
   system.debug('$roleSelected$'+roleSelected);
 }

 /*public ID[] getRoleSelectedId(){
       return roleSelectedId;
 }
 public void setRoleSelectedId(ID[] roleSelectedId ){
       this.roleSelectedId = roleSelectedId;
 }*/

 public String getRoleSelectedId (){
   return roleSelectedId;
 }
 public void setRoleSelectedId(String roleSelectedId){
   this.roleSelectedId= roleSelectedId;
    system.debug('$roleSelectedId$'+roleSelectedId);
 }


 public ID[] getRoleSelId(){
       return roleSelId;
 }
 public void setRoleSelId(ID[] roleSelId){
       this.roleSelId = roleSelId;
 }

 public String getAccountId (){
   return accountId;
 }
 public void setAccountId(String accountId){
   this.accountId= accountId;
 }
 public ID[] getAssignedItems(){
   return assignedItems;
 }
 public void setAssignedItems(ID[] assignedItems){
   this.assignedItems= assignedItems;
   system.debug('$AssignItems$'+assignedItems);
 }
 public Contact getContact(){
   return contact;
 }
 public void setContact(Contact c){
   contact = c;
 }
 public Account_Contact_Role__c getAcrContact(){
   return acrContact;
 }
 public void setAcrContact(Account_Contact_Role__c acrContact){
    acrContact = acrContact;
 }
 public String selectedRoleValues{
    get
        { return selectedRoleValues;}
    set { selectedRoleValues = value;}
 }
 /* public ID[] selectedRoleIds{
       get{
               return selectedRoleIds;}
               set{selectedRoleIds = value;}
       }
 */
 public String selectedRoleIds{
    get
     {return selectedRoleIds;}
     set{selectedRoleIds = value;}
 }
 public List<ContactRoleAccount> getfilteredContacts(){
    return filteredContacts;
 }


/*------ End of Property Region ------*/

 /*--- constructor ---*/
 public EditContactController(){
   currentAccountId = ApexPages.CurrentPage().getParameters().get(contactConstClass.ACCOUNTID);
   siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
   System.debug(' ------------------------ 1 ---------------------------');
   portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
   contactId = ApexPages.CurrentPage().getParameters().get(contactConstClass.CONTACTID);
      cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');//start-5377
        Boolean cableUnitNotMatch = false;
        renderSection = true;
   setContactDetails(contactId);
   System.debug('----acrContactList******---'+acrContactList);
   setContactRolesList(acrContactList);
   //System.debug('---- Total_Insight__c after setContactRolesList()******---'+acrContactList.Total_Insight__c);
    list<Account> accList = new list<Account>();
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
       if(!accList.isEmpty()){

            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
           if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
               
            }
           else{
   getSelectedItems();
   //System.debug('---- Total_Insight__c after getSelectedItems()******---'+acrContactList.Total_Insight__c);
   System.debug(' ------------------------ 2 ---------------------------');
   if(ApexPages.CurrentPage().getParameters().get('emailUnique') != null){
      emailFlag = ApexPages.CurrentPage().getParameters().get('emailUnique');
      emailChk = emailFlag;
   }
         
  // if(ApexPages.CurrentPage().getParameters().get('historyLogCheck') != null){
    // historyEntryFlag = ApexPages.CurrentPage().getParameters().get('historyLogCheck');
  // }//
   if(ApexPages.CurrentPage().getParameters().get('contactFreeFlyingLogCheck') != null){
     freeFlyingContact = ApexPages.CurrentPage().getParameters().get('contactFreeFlyingLogCheck');
   }
    System.debug(' ------------------------ 3 ---------------------------');
   System.debug('**emailFlag**'+ApexPages.CurrentPage().getParameters().get('emailUnique'));
   //System.debug('**historyEntryFlag**'+ApexPages.CurrentPage().getParameters().get('historyLogCheck'));
   System.debug('**freeFlyingContact**'+ApexPages.CurrentPage().getParameters().get('contactFreeFlyingLogCheck'));
   System.debug(' ------------------------ 4 ---------------------------');
   cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
   isRoleFlag = false;
   fetchAddressDetails();
   //System.debug('---- Total_Insight__c after fetchAddressDetails()******---'+acrContactList.Total_Insight__c);
   System.debug(' ------------------------ 5 ---------------------------');
   warningFlag = false;
   errorFlag = false;
   tempTestFlag = false;
 }
       }
     else{
         renderSection=false;
     }
 }
 public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('EditContactController','Manage Contacts');
/*---- Public m/d Region ----- */

/*--- Setting contact details ---*/
 private string fetchedEmail,fetchedPhone,fetchedMobilePhone,fetchedHomePhone,fetchedAntalKopier,fetchedHierarchyAccnt;
 private List<Account_Contact_Role__c>  contactRolesList = new List<Account_Contact_Role__c>();

 /*private List<Account_Contact_Role__c> getContactRolesList(){
    return contactRolesList;
 }*/

 private void setContactRolesList(List<Account_Contact_Role__c> contactRolesList){
    this.contactRolesList = contactRolesList;
 }

 public void setContactDetails(Id conId){
       try{
     system.debug('contactId--------->' + contactId);
     system.debug('before query is executer');
     Contact contact = [Select id, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__r.Name, Status__c,AlternateEmail__c,HierarchyAccount__c From Contact  where id = :conId ];
     acrContactList = [select Role__c,RoleName__c, Id, First_Name__c,Email__c, Customer__c, Contact__c,Total_Insight__c,HierarchyAccount__c from Account_Contact_Role__c where  Contact__c =: contact.Id];
     system.debug('after query is executer'+acrContactList);
   //  system.debug('copy value****'+acrContactList[1].Total_Insight__c);
     setContact(contact);
     system.debug('------contactRolesList is executer---'+contactRolesList);
     setContactRolesList(acrContactList);
     system.debug('-----after -contactRolesList is executer---'+contactRolesList);
	 
	 Account_Contact_Role__c[] accountContacts1 ;
	 if(acrContactList.size() > 0){

       for(Account_Contact_Role__c accountContacts : acrContactList){
        //this is used for fetching the antal kopier value from acr table
        //acrContact = accountContacts;
        if(accountContacts.RoleName__c == 'Indbliksadresse'){
        system.debug('inside if loop******');	
         acrContact.Total_Insight__c = accountContacts.Total_Insight__c;
         
         system.debug('copy value inside for****'+accountContacts.Total_Insight__c);
        }
         
         
       }
      //  setAcrContact(acrContactList[0]);
     }
     
     
     
     system.debug('copy value outside for****'+acrContact.Total_Insight__c);
     fetchedEmail = contact.Email.trim();
     fetchedPhone = contact.Phone;
     fetchedHomePhone = contact.HomePhone;
     fetchedMobilePhone = contact.MobilePhone;
     fetchedHierarchyAccnt = contact.HierarchyAccount__c;
        }catch(Exception e){
           ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
           ApexPages.addMessage(errorMsg);
        }
 }
       public void debugCode(){
               system.debug('roleSelected: '+roleSelected);
               system.debug('roleSelectedId: '+roleSelectedId);
               system.debug('accountId: '+accountId);
               system.debug('availableItems.size(): '+availableItems.size());
               system.debug('assignedItems.size(): '+assignedItems.size());
               system.debug('selectedRoleValues: '+selectedRoleValues);
               system.debug('selectedRoleIds:'+selectedRoleIds);


       }
/*--- Saving Contacts. Updating the contact object, deleting the saved roles and inserting the new and old saved roles. ----*/
 public PageReference saveContacts(){
       System.debug('abcd');
       System.debug('inside save c--------------------');
       System.debug('inside save  contactRolesList'+ contactRolesList+'$assignedItems$'+assignedItems);
        try {
            //ApexPages.Message myMsg = null;
            antalkopier = acrContact.Total_Insight__c;
            List<Id> accountIds = new List<Id>();
            List<Id> hierAccountIds = new List<Id>();
            List<Id> existContHierAccnt = new List<Id>();
            List<string> enteredPhoneNos   = new List<string>();
            List<Contact> chkContactExists = new List<Contact>();
            List<Account> accountListValid = new List<Account>();
            List<Account_Contact_Role__c> acrContactExists = new List<Account_Contact_Role__c>();

           if(getAccountId() != null){
               accountListValid =[select a.Id, a.name, a.Type, a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c,a.Cable_Unit__c from Account a where id =: getAccountId()];
               system.debug('$accountListValid$'+accountListValid);
            }
            String cableunitNumber = ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER);
            system.debug('$Contact.Email$'+contact.Email+'$FetchedEmail$'+fetchedEmail);
           //fetchedEmail- email id from Database and contact.email is from Page-entered one
            if(contact.email != fetchedEmail){
              System.debug('----Inside if entered email is different from fetched email id----------');
              if(contact.email != null){
                 chkContactExists = [Select c.Phone, c.Name, c.MobilePhone, c.Id, c.HomePhone, c.HierarchyAccount__c, c.Email, c.AccountId, c.IsPersonAccount From Contact c where c.Email =: contact.email.trim() AND c.IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
                 System.debug('editcontactcontroller---chkContactExists --->'+chkContactExists);
              }
            }
            system.debug('**chkContactExists.size()***'+chkContactExists.size());

            if(chkContactExists != null && chkContactExists.size() > 0) {
                for(Contact existContact : chkContactExists){
                       existContHierAccnt.add(existContact.HierarchyAccount__c);
                       System.debug('----Fetching Hierarchy Account Id from Contact-------'+existContHierAccnt.size());
                }
                if(existContHierAccnt.size() > 0){
                    hierarchyAccntId = existContHierAccnt.get(0);
                }
                System.debug('hierarchyAccntId --->'+hierarchyAccntId);

                //if different hierarchy
                /*------ Comparing with the hierarchy account field as per SC-107 ------*/
                System.debug('---hierarchyAccntId----'+hierarchyAccntId+'---and---fetchedHierarchyAccnt-----'+fetchedHierarchyAccnt);

                if(hierarchyAccntId != fetchedHierarchyAccnt){

                   System.debug('--------------Exists Another Hierarchy-------------');
                   String cuNumber = ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER);
                  /* String newPageUrl = contactConstClass.MANAGECONTACTURL;
                   PageReference newPage = new PageReference(newPageUrl);
                   newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.EDITMSG);
                   newPage.getParameters().put(contactConstClass.ACCOUNTID , apexpages.currentpage().getparameters().get('loggedInaccountId'));
                   newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, cuNumber);
                   newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                   newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                   newPage.getParameters().put('isExistAnotherHierarchy','true');
                   return newPage;*/
                   ApexPages.Message myMsg;
               myMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_C2);
                   ApexPages.addMessage(myMsg);
                   warningFlag = true;  //cfxf
                   return null;
                }else{
                   System.debug('--------------Exists Hierarchy----------------------');
                   String newPageUrl = contactConstClass.MANAGECONTACTURL;
                   PageReference newPage = new PageReference(newPageUrl);
                   newPage.getParameters().put(contactConstClass.ACCOUNTID , apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
                   newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
                   newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.EDITMSG);
                   newPage.getParameters().put('isInExistingHierarchy', 'true');
                   newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                   newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                   newPage.setRedirect(true);
                   return newPage;
                }
            }else{
                String newPageUrl = contactConstClass.MANAGECONTACTURL;
                PageReference newPage = new PageReference(newPageUrl);
                system.debug('$AccountListValid$'+accountListValid+'$Size$'+accountListValid.size());
                List<Account_Contact_Role__c> acrContactRoleList = [select Role__c,RoleName__c, Id, First_Name__c,Email__c, Customer__c, Contact__c,Total_Insight__c,HierarchyAccount__c from Account_Contact_Role__c where  Contact__c =: contact.Id];
                /*ID rolesSelectedId;
                for(Account_Contact_Role__c acrRolesId : acrContactRoleList){
                       system.debug('$acrRolesId$'+acrRolesId);
                       rolesSelectedId = acrRolesId.Id;
                       system.debug('$rolesSelectedId$'+rolesSelectedId);
                }*/


                System.debug('---acrContactRoleList----'+acrContactRoleList);
                if(accountListValid != null && accountListValid.size() > 0){
                       system.debug('inside accountListValidsize'+ contactRolesList);
                       if(!ContactService.isMandatoryInfoMissingOnCU(accountListValid)){
                   //if(!ContactService.isMandatoryInfoMissingOnCU(accountListValid,acrContactRoleList)){
                      System.debug('-------Before calling edit contact-------'+contact);
                      System.debug('Before calling assignedItems-------'+assignedItems);
                       System.debug('calling edit selectedRoleValues-------'+selectedRoleValues);
                      service.editContactNew(contact, apexpages.currentpage().getparameters().get('accountId'), assignedItems, cableunitNumber,selectedRoleValues,antalkopier);
                      // Before check second methos for editContact
                      //service.editContact(contact,ApexPages.currentPage().getParameters().get('accountId'),roleSelectedId,cableunitNumber,selectedRoleValues,antalKopier);
                      //service.editContact(contact, apexpages.currentpage().getparameters().get('accountId'), assignedItems, cableunitNumber,selectedRoleValues,antalkopier);
                   }else{
                      ApexPages.Message myMsg;
                      myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                      ApexPages.addMessage(myMsg);
                       errorFlag = true;
                      return null;
                  }
                }
                newPage.getParameters().put(contactConstClass.ACCOUNTID , apexpages.currentpage().getparameters().get('loggedInaccountId'));
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, cableunitNumber);
                newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.EDITMSG);
                newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                newPage.getParameters().put('emailFlag',emailFlag);
                if(freeFlyingContact != null && freeFlyingContact == 'true'){
                   System.debug('Free flying value::'+freeFlyingContact);
                   newPage.getParameters().put('freeFlyingContact',freeFlyingContact);
                }
                System.Debug('updation completed--->');
                return newPage;
              }
           }catch (Exception e){
              if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
			     // ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
			     // ApexPages.addMessage(errorMsg);
			      errorFlag = true;
				  exceptionHandler.handleException(e,'saveContacts()',false,false,cableUnitName,'Medium');
				  return null;
		      } else{
                 system.debug('Inside catch- save method editcontact');
                 ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                 ApexPages.addMessage(errorMsg);
                 errorFlag = true;
                 exceptionHandler.handleException(e,'saveContacts()',false,false,cableUnitName,'Medium');
                 return null;
               }
           }
 }

 public PageReference cancelSaveContacts(){
    return Page.Contact_Create_Thankyou;
 }

/*----- Reading saved roles from Account_Contact_Role__c for the current contact object ------*/
 public List<SelectOption> getSelectedItems(){
   try {
   	  // if Statement added to generate exception for test classes
   		if(tempTestFlag){
    			integer i;
    			i = 5/0;
    	}
      List<Id> portalRoles = new List<Id>();
      Map<Id, String> portalRolesKey = new Map<Id,String>();
      ID accountId = ApexPages.CurrentPage().getParameters().get(contactConstClass.ACCOUNTID);
      List<Account_Contact_Role__c> acrList = [Select a.Role__c,a.RoleName__c, Total_Insight__c from Account_Contact_Role__c a  where a.Contact__c =: contactId and a.customer__C =: accountId and (a.RoleName__c !=: contactRoleAdministrator or a.RoleName__c !=: contactRoleBruger)];
      system.debug('total value insight****'+acrList);
      for(Account_Contact_Role__c roles : acrList ) {
       portalRoles.add(roles.Role__c);
      }
      Lookup_Contact_Roles__c[] listRoles = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true and l.ID IN: portalRoles];
      if(listRoles != null && listRoles.size() > 0){
       for(Lookup_Contact_Roles__c fetchedRole : listRoles){
         portalRolesKey.put(fetchedRole.Id,fetchedRole.Name);
       }
      }
      List<SelectOption> options = new List<SelectOption>();
      integer rolessize =  acrList.size();
      String[] rolesSel = new String[rolessize];

      String rolesSelected = contactConstClass.SELECTVALUE;
      String rolesSelectedId = contactConstClass.SELECTVALUE;
      system.debug('$roles Selected Id$'+rolesSelectedId);
      options.add(new SelectOption(contactConstClass.SELECTVALUE, contactConstClass.SELECTLABEL));

      if(acrList != null && acrList.size() > 0){
        for(Account_Contact_Role__c roles : acrList ) {
          if(portalRolesKey.containsKey(roles.Role__c)){
            if(!(roles.RoleName__c == contactRoleAdministrator ||  roles.RoleName__c == contactRoleBruger )){
               options.add(new SelectOption(roles.Role__c, roles.RoleName__c));
               rolesSelectedId =rolesSelectedId + ',' +roles.Role__c;
               rolesSelected=rolesSelected + ',' +roles.RoleName__c;
             }
           }
         }
       }
       setAccountId(accountId);
       System.debug('rolesSelected---'+rolesSelected);
       System.debug('rolesSelectedId---'+rolesSelectedId);
       setRoleSelected(rolesSelected);
       setRoleSelectedId(rolesSelectedId);
       return options;
   } catch (Exception e){
       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
       ApexPages.addMessage(errorMsg);
       return null;
   }
 }



 public List<SelectOption> getAvailableRoles() {
   try {
   		// if Statement added to generate exception for test classes
   		if(tempTestFlag){
    			integer i;
    			i = 5/0;
    	}
       List<ID> rolesID = new List<ID>();
       List<SelectOption> options = new List<SelectOption>();
       List<Account_Contact_Role__c> acrList = [Select a.Role__c,a.RoleName__c,Total_Insight__c from Account_Contact_Role__c a  where a.Contact__c =: contactId and (a.RoleName__c !=: contactRoleAdministrator or a.RoleName__c !=: contactRoleBruger)];
       for(Account_Contact_Role__c acr :  acrList){
           rolesID.add(acr.Role__c);
       }
       List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.id NOT IN : rolesID and l.Visible_in_Service_Centre__c = true];
       for(Lookup_Contact_Roles__c roles : rolesList ) {
           if(!(roles.Name == contactConstClass.PORTALUSER ||  roles.Name == contactConstClass.PORTALMANAGER))
               options.add(new SelectOption(roles.Id, roles.Name));
       }
       return options;
    }catch(Exception e){
       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
       ApexPages.addMessage(errorMsg);
       return null;
   }
 }
/*----- Reading the available roles which are not saved for the current contact -----*/
 public List<SelectOption> getNewItems() {
   try {
   		// if Statement added to generate exception for test classes
   		if(tempTestFlag){
    			integer i;
    			i = 5/0;
    	}
       List<ID> rolesID = new List<ID>();
       List<SelectOption> options = new List<SelectOption>();
       List<Account_Contact_Role__c> acrList = [Select Role__c,RoleName__c,Total_Insight__c from Account_Contact_Role__c a  where a.Contact__c =: contactId];
       for(Account_Contact_Role__c acr :  acrList){
           rolesID.add(acr.Role__c);
       }
       List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.id NOT IN : rolesID and l.Visible_in_Service_Centre__c = true];
       options.add(new SelectOption(contactConstClass.SELECTLABEL, contactConstClass.SELECTLABEL));
       for(Lookup_Contact_Roles__c roles :  rolesList){
           if(!(roles.Name == contactConstClass.PORTALUSER ||  roles.Name== contactConstClass.PORTALMANAGER))
               options.add(new SelectOption(roles.Id, roles.Name));
       }
       return options;
   }catch (Exception e){
     ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
     ApexPages.addMessage(errorMsg);
     return null;
   }
 }

/*---- Reading saved roles for the current contact-----*/
 public List<SelectOption> getItems() {
   try {
   		// if Statement added to generate exception for test classes
   		if(tempTestFlag){
    			integer i;
    			i = 5/0;
    	}
       System.debug('--Inside getItems method-----');
       List<SelectOption> options = new List<SelectOption>();
       List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Active__c = 'Ja' and l.Visible_in_Service_Centre__c = true and (l.Name !=: contactRoleAdministrator or l.Name !=: contactRoleBruger)];
       options.add(new SelectOption(contactConstClass.SELECTLABEL, contactConstClass.SELECTLABEL));
       System.debug('---rolesList in getItems()----'+rolesList.size());
       if(rolesList != null && rolesList.size() > 0){
         for(Lookup_Contact_Roles__c roles : rolesList ) {
                if(!(roles.Name == contactRoleAdministrator || roles.Name == contactRoleBruger)){
                   options.add(new SelectOption(roles.Id, roles.Name));
                }
         }
       }
       System.debug('options addedd finally '+options);
       return options;
   } catch (Exception e){
       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
       ApexPages.addMessage(errorMsg);
       return null;
   }
 }
 public string[] availableItems {get;set;}
       /*String[] availableItems = new String[]{};
   public String[] getAvailableItems() {
           return availableItems;
       }

       public void setAvailableItems(String[] availableItems) {
           this.availableItems = availableItems;
       }*/

 public PageReference cancel() {
   String newPageUrl = contactConstClass.MANAGECONTACTURL;
   PageReference newPage = new PageReference(newPageUrl);
   newPage.getParameters().put(contactConstClass.ACCOUNTID, getAccountId());
   newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
   newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
   newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
   newPage.setRedirect(true);
   return newPage;
 }

 public PageReference fetchAddressDetails(){
       String addressId = contact.Street_P__c;
       System.debug('*****addressId: '+ addressId);
       // Query before implementing  SC- 168 for extra post box number
       //List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Side__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
       List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
       if(addressList.size() > 0){
               address = addressList.get(0);
   }
       displayAddressInfo = true;
       return null;
 }








 // Edited code for new page
	 public PageReference toViewContactPage(){
	 	   // Change to absolute path
           //String newPageUrl = '/apex/ViewContactPage';
           //PageReference viewPage = new PageReference(newPageUrl);
           PageReference viewPage = Page.ViewContactPage;
           viewPage.setRedirect(true);
           return viewPage;
	 }

        /*public void checkRoles(){
               List<SelectOption> newOption = new List<SelectOption>();
               List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Active__c = 'Ja' and l.Visible_in_Service_Centre__c = true and (l.Name !=: contactRoleAdministrator or l.Name !=: contactRoleBruger)];
               newOption.add(new SelectOption(contactConstClass.SELECTLABEL,contactConstClass.SELECTLABEL));
               if(rolesList != null && rolesList != ''){
                       for(Lookup_Contact_Roles__c lookupRoles : rolesList){

                       }
               }
        }*/

       public void saveContactsPage(){
               System.debug('$$$$$$$$$$$roleSelectedId$$$'+roleSelectedId);
	   }



}