/*Purpose : To create new contact, assign the Role and send mail to user. LastName, phone number and Roles are the mandatory fields.*/

public class CreateContactController extends PageControllerBase { 
    /*---- Property and variable Region -----*/
    ID accountId,fetchedId, fetchedHierAccntId;
    ID[] assignedItems= new ID[]{};   
        public String[] availableItems = new String[]{};
            public Address__C address{get; set;}
    public String antalkopier {get;set;}
    public String contactRoleBruger{get; set;}
    public String portalBrugerRole{get; set;}
    public string cableUnitName {get;set;}
    private String cableunitNumber;
    public boolean successFlag {get;set;}
    public boolean warningFlag {get;set;}
    public boolean errorFlag {get;set;}
    public Boolean isContactVisible{get;set;}   
    public Boolean isRoleFlag{get;set;} 
    public Boolean isSelected {get;set;}
    public boolean displayAddressInfo{get; set;}
    public String siteCoreUrl{get; set;}
    //public String accountId{get;set;}
    public boolean renderSection{get;set;}
    // Temporary variable for checking test classes
    public Boolean tempTestFlag = false;
    public List<ContactRoleAccount> filteredContacts = new List<ContactRoleAccount>(); 
    private List<Contact> contactPhone = new List<Contact>(); 
    public Contact contactList {get; set;} 
    // the contact record you are adding values 
    public Contact contact = new Contact();
    public ContactService service = new ContactService();
    public Contact loggedInContactDetails;      
    //Added as per the issue jira 403 
    public Account_Contact_Role__c acrContact = new Account_Contact_Role__c();
    public static String contactRoleAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
    public static String ContactRecordType = YSRecordTypes__c.getInstance('YSRecordTypes').YS_Contact_Record_Type__c;
    public ID getAccountId(){
        return  accountId;       
    }
    public void setAccountId(ID accountId){
        this.accountId = accountId;       
    }
    public ID getFetchedId(){
        return  fetchedId;       
    }
    public void setFetchedId(ID fetchedId){
        this.fetchedId = fetchedId;       
    }  
    public ID getFetchedHierAccntId(){
        return fetchedHierAccntId;       
    }
    public void setFetchedHierAccntId(ID fetchedHierAccntId){
        this.fetchedHierAccntId = fetchedHierAccntId;       
    } 
    public ID[] getAssignedItems(){
        if(availableItems != null){
            System.debug(' ------------- Available Items -----------------------' + availableItems.size());
        }    
        return assignedItems;
    }
    public void setAssignedItems(ID[] assignedItems) {
        this.assignedItems= assignedItems;
    }
    public String[] getAvailableItems(){
        if(availableItems != null){
            System.debug(' ------------- Available Items -----------------------' + availableItems.size());
        }    
        return availableItems;
    }
    public void setAvailableItems(String[] availableItems) {
        this.availableItems = availableItems;
    }
    public Contact getContact() {
        return contact;
    }
    
    public void setContact(Contact c) {
        contact = c; 
    }
    public String selectedRoleValues { 
        get{ return selectedRoleValues;}
        set{ selectedRoleValues =value;}
    }
    public List<ContactRoleAccount> getfilteredContacts(){
        return filteredContacts;
    }
    public Account_Contact_Role__c getAcrContact(){
        return acrContact;
    }
    public void setAcrContact(Account_Contact_Role__c acrContact){
        acrContact = acrContact;
    }
    
    /*----End of Property and variable Region -----*/
    
    /*--- constructor ----*/
    public CreateContactController() {
        //contactRoleBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        ID accountId =  ApexPages.CurrentPage().getParameters().get(contactConstClass.ACCOUNTID);
        cableunitNumber = ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER);
        siteCoreUrl= ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        setAccountId(accountId);
        isContactVisible=false; 
        isSelected = true;
        tempTestFlag = false;
        cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');
        Boolean cableUnitNotMatch = false;
        renderSection = true;
        list<Account> accList = new list<Account>();//start-5377
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
        if(!accList.isEmpty()){
            
            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
            if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
            }
        }
        else
        {
            renderSection = false;  
        } 
    }//end support-5377
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('CreateContactController','Administration of portal contacts for each cable unit');
    /*---- Public method Region -------*/
    
    /*---- Reading all the available roles from Lookup_Contact_Roles__c ------*/                  
    public List<SelectOption> getItems() {
        
        List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true and l.Active__c = 'Ja'];
        List<SelectOption> options = new List<SelectOption>();
        contactRoleBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        
        options.add(new SelectOption(contactConstClass.SELECTVALUE, contactConstClass.SELECTLABEL));
        for(Lookup_Contact_Roles__c roles : rolesList ) {
            if(!(roles.Name == contactConstClass.PORTALUSER ||  roles.Name == contactConstClass.PORTALMANAGER || roles.Name == contactRoleAdministrator ||  roles.Name == contactRoleBruger))
                options.add(new SelectOption(roles.Id, roles.Name));
        }
        return options;
    }
    /*----- To cancel and redirect to ManageConatctPage ------*/
    public PageReference cancel() {
        String newPageUrl = contactConstClass.MANAGECONTACTURL;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.getParameters().put(contactConstClass.ACCOUNTID , getAccountId());
        newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
        newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
        newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
        newPage.setRedirect(true);
        return newPage;
    }
    /*---- Saving contact and selected role ----*/
    public PageReference saveContacts() {
        try{
            if(tempTestFlag == true){
                integer i;
                i = 10/0;
            }
            ApexPages.Message myMsg = null;  
            antalkopier = acrContact.Total_Insight__c;
            List<Id> accountIds = new List<Id>();
            List<Id> diffAccountIds = new List<Id>();
            List<Id> hierarchyAccountId = new List<Id>();
            List<Id> contactDiffHierAccnt = new List<Id>();
            List<Id> diffHierarchyAccountId = new List<Id>();
            List<Account> accountListValid = new List<Account>();
            List<Account_Contact_Role__c> contactEmail = new List<Account_Contact_Role__c>();
            List<Contact> chkContactExist = new List<Contact>();
            String loggedInAccntId,extrLoggedInAccntId;
            loggedInContactDetails = service.getLoggedInUserContact();
            //= [Select Street_P__r.Name, HierarchyAccount__c,AccountId From Contact  where id in(select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
            if(getAccountId() != null){
                accountListValid =[select a.Id, a.name,a.Type,a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c,a.Cable_Unit__c from Account a where a.id =: getAccountId()];
            }
            
            //chking email against each account in ACR. To verify if the contact is either created from contact screen or portal screen.
            if(contact.email != null){
                contactEmail = [select contact__c,customer__c,Role__c, RoleName__c,Email__c,HierarchyAccount__c from Account_Contact_Role__c a 
                                where a.Contact__r.Status__c = 'Aktiv' and a.Contact__r.email =: contact.email.trim()];
            }  
            if(contactEmail.size () > 0){
                for(Account_Contact_Role__c accountContacts : contactEmail){ 
                    if(loggedInContactDetails != null && loggedInContactDetails.HierarchyAccount__c != null){ 
                        if(accountContacts.HierarchyAccount__c == loggedInContactDetails.HierarchyAccount__c){
                            system.debug('loggedInContactDetails++++++++++++++++++'+loggedInContactDetails);
                            system.debug('loggedInContactDetails.HierarchyAccount__c++++++++++++++++'+loggedInContactDetails.HierarchyAccount__c);
                            if(accountContacts.customer__c == getAccountId()){
                                accountIds.add(accountContacts.customer__c);
                            }else{
                                diffAccountIds.add(accountContacts.customer__c);
                            }
                            hierarchyAccountId.add(accountContacts.HierarchyAccount__c);
                        }else{
                            diffHierarchyAccountId.add(accountContacts.HierarchyAccount__c);
                        }
                    }
                }
            }
            if(accountIds.size() > 0){
                fetchedId = accountIds.get(0);
            }
            //if(contactEmail.size() > 0 && accountIds.size() > 0 && diffAccountIds.size() == 0 && hierarchyAccountId.size() > 0)
            system.debug('contactEmail.size() ' + contactEmail.size());
            system.debug('hierarchyAccountId.size()' + hierarchyAccountId.size()); 
            system.debug('diffHierarchyAccountId.size()' + diffHierarchyAccountId.size());
            if(contactEmail.size() > 0 && fetchedId != null && hierarchyAccountId.size() > 0 && diffHierarchyAccountId.size() == 0){	
                //Change to absolute path
                //String newPageUrl = '/apex/EditContactPage'; 
                //PageReference newPage = new PageReference(newPageUrl);
                PageReference newPage = Page.EditContactPage;
                if(fetchedId == getAccountId()){
                    System.debug('---------Inside if condition scenario SC C2 edit----------');
                    newPage.getParameters().put('emailUnique','false');
                    newPage.getParameters().put('cableunitnumber', ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
                    newPage.getParameters().put('contactId',contactEmail[0].contact__c);
                    newPage.getParameters().put('accountId',apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
                    newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                    newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                    newPage.getParameters().put('loggedInaccountId',apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
                    newPage.setRedirect(true);
                }
                return newPage; 
                
            }else{ 
                system.debug('hello');
                Contact[] contactList;
                // system.debug('$Contact.email####$'+contact.email);              
                if(contact.email != null && contact.email != ''){  
                    contactList = [select Id,FirstName,LastName,Street_P__c, Status__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId, HierarchyAccount__c,IsPersonAccount from Contact where Email =: contact.Email.trim() AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
                } 
                if(contactList != null && contactList.size() > 0){
                    if(loggedInContactDetails != null && loggedInContactDetails.HierarchyAccount__c != null){ 
                        loggedInAccntId = loggedInContactDetails.HierarchyAccount__c;
                        // extrLoggedInAccntId = loggedInAccntId.substring(0, loggedInAccntId.length() - 3);
                    }
                    contactDiffHierAccnt = new List<Id>();
                    for(Contact fetchedCon : contactList){
                        if(fetchedCon.HierarchyAccount__c != null){
                            if(fetchedCon.HierarchyAccount__c != loggedInAccntId){
                                contactDiffHierAccnt.add(fetchedCon.HierarchyAccount__c);
                            }
                        }
                    }
                    if(contactDiffHierAccnt != null && contactDiffHierAccnt.size() > 0){ 
                        //another hierarchy
                        myMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_C2); 
                        ApexPages.addMessage(myMsg);
                        warningFlag = true;  //cfxf
                        return null;
                    }else{
                        if(contactEmail.size() > 0 && (diffAccountIds != null && diffAccountIds.size() > 0) || (diffHierarchyAccountId != null && diffHierarchyAccountId.size() > 0)){
                            myMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_C2); 
                            ApexPages.addMessage(myMsg);
                            warningFlag = true;  //cfxf
                            return null;
                        }else if(contactEmail.size() == 0){
                            //Change to absolute path
                            //String newPageUrl = '/apex/EditContactPage'; 
                            //PageReference newPage = new PageReference(newPageUrl);
                            PageReference newPage = Page.EditContactPage;
                            newPage.getParameters().put('emailUnique','false');
                            newPage.getParameters().put('cableunitnumber', ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
                            newPage.getParameters().put('contactId',contactList[0].id);
                            newPage.getParameters().put('accountId',apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
                            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                            newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                            newPage.getParameters().put('loggedInaccountId',apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
                            newPage.getParameters().put('contactFreeFlyingLogCheck','true');
                            newPage.setRedirect(true);
                            return newPage;
                        }//END OF ELSE PART OF historyContactLog != null && historyContactLog.size() > 0
                        else{
                            return null;
                        }
                    } 
                }//END OF contactList != null && contactList.size() > 0
                else{
                    String newPageUrl = contactConstClass.MANAGECONTACTURL;
                    PageReference newPage = new PageReference(newPageUrl); 
                    if(accountListValid != null && accountListValid.size() > 0){
                        if(!ContactService.isMandatoryInfoMissingOnCU(accountListValid)){
                            service.createContact(getAccountId(), contact, assignedItems, cableunitNumber,selectedRoleValues, antalkopier);
                            newPage.getParameters().put(contactConstClass.ACCOUNTID , apexpages.currentpage().getparameters().get('loggedInaccountId'));
                            newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, cableunitnumber);
                            newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.CREATEMSG);
                            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                            newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                        }else{
                            
                            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                            ApexPages.addMessage(myMsg);
                            errorFlag = true;
                            return null;
                        }
                    }
                    return newPage; 
                }
            }
        }catch(Exception e){
            if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                //ApexPages.addMessage(errorMsg);
                errorFlag = true;
                exceptionHandler.handleException(e,'saveContacts()',false,false,cableunitNumber,'Medium');
                return null;
            }else{
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                errorFlag = true;
                exceptionHandler.handleException(e,'saveContacts()',false,false,cableunitNumber,'Medium');
                return null;
            }
        }
    }
    /*----- End of Public method Region -----*/
    /*----- Private method Region -----*/
    public PageReference fetchAddressDetails(){
        String addressId = contact.Street_P__c;
        List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
        // Old query without Post box no change for Sc 168
        //List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Side__c, Postcode__c, Town__c, Door_No__c, PO_Box__c from Address__c where id =: addressId];
        if(addressList.size() > 0){
            address = addressList.get(0);			
        }
        displayAddressInfo = true;  	
        return null;
    }
    /*----- End of Private method Region -----*/
}