/*Purpose : To display the Portal Users List, and allow to View,edit and delete the Poratl Users*/
public class ManagePortalUserController {

    public Contact cntAccount;  
    public Profile userProfile;
    
    private Id fetchedContactId;
    public String contactId, contactIDList;
    public String portalAdminRole{get; set;}
    public String portalBrugerRole{get; set;}
    public String userSelectedPage{ get; set;}
    public String currentCountText1{get; set;}
    public String siteCoreUrl{get; set;}
    public boolean displayAddressInfo{get; set;}
    public boolean successFlag {get;set;}
    public boolean warningFlag {get;set;}
    public boolean commonErrorFlag {get;set;}
    public boolean flagInactive {get; set;}
    public boolean displayFlag {get; set;}
    
    public Contact refContact{get; set;}
    //public boolean refreshFlag {get; set;} 
    List<ID> accListID =new List<ID>();
    List<ID> contactID1 = new List<ID>();
    public List<Contact> contact1 {get; set;}
    public List<Contact> contactList3 {get; set;}
    public boolean pageFlag{get; set;}
        
    //Added sc-106
    List<ACRRoles> listExpACRRole = new List<ACRRoles>();
    List<ACRRoles> listACRRole = new List<ACRRoles>();
    List<ContactWrapper> portalUserList {get;set;}
    List<ContactWrapper> cwp = new List<ContactWrapper>();
    List<ContactWrapper> portalUserListRefresh {get; set;}
    List<ContactWrapper> portalUserList3 {get; set;}
    List<ContactWrapper> portalList{get; set;}
    Map<ID,String> finalContactID = new Map<ID,String>();
     
     
    public Boolean tempFlag = false;   
    private Integer pageSize1 = 10;
    String strQuery='';
    String query1;
    // Added for checking hierarchy Account Field on contact object
    public Boolean hierarchyFlag{get; set;}
        
    String loggedInContactAccountIdList1 = getContactsLoggedInAccountIdList(); 
    private static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
    private static String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
    public String  portalAdminUser{get; set;}
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ManagePortalUserController','Administration of portal users');

    public ApexPages.Standardsetcontroller con {
        get{
            try{
                if(con == null){
                    if(loggedInContactAccountIdList1.trim().length() > 0){
                    query1 = 'select Id,Name,FirstName,LastName,Email,MobilePhone,HomePhone,Phone,Street_P__c,Street_P__r.Name,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c,UserProfile__c,Address_merge_field__c from Contact where Status__c = \''+ contactConstClass.ACTIVE + '\'';
                    query1 = query1 + ' and Id In (' + loggedInContactAccountIdList1 + ')';
                    query1 = query1 + ' and Id In (Select contactId From user where IsActive = true and Id != \'' + UserInfo.getUserId()+ '\') Order by CreatedDate DESC';
                    con = new ApexPages.Standardsetcontroller(Database.getQueryLocator(query1));
                    System.debug('##con resultSize$#'+con.getResultSize());
                    con.setPageSize(10);
                    return null;            
                  }
                }
                return con;
            }catch(Exception e){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                    ApexPages.addMessage(errorMsg);
                    commonErrorFlag = true;
            }
                    return null;
            }
        set;
    }
        
     public String deleteFlag{ 
         get{ return deleteFlag;}
         set{deleteFlag=value; }
     }
        
   public ManagePortalUserController(){ 
       flagInactive = false;
       userSelectedPage = Label.SC_brugerePage;
       portalAdminRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
       portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
       portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
       siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
       ID user1 = UserInfo.getUserId();
       String status1 = apexpages.currentpage().getparameters().get(contactConstClass.STATUS);
       if(status1 != null){
       if(status1 == 'reactivateSuccessfully' || status1 == 'deletedsuccessfully'){
            fetchedContactId = apexpages.currentpage().getparameters().get('inactiveContactId');
       }
       }
       fetchContact(); 
       setStatus();
       pageFlag = false;
       commonErrorFlag = true;
       //fetchHierarchyDetails();
       tempFlag = false;
       
       List<Contact> hierarchyContact = new List<Contact>();
       hierarchyContact = [Select Id , HierarchyAccount__c From Contact where Id IN (select ContactId from User where Id =:UserInfo.getUserId()) LIMIT 1];
       if(hierarchyContact != null){
            if(hierarchyContact.get(0).HierarchyAccount__c == null && hierarchyContact.get(0).HierarchyAccount__c == ''){
                hierarchyFlag = false;
            }else{
                hierarchyFlag = true;
            }
            
       }
          
   }
        
   public PageReference fetchContactDetails(){
        fetchContact(); 
        // Change to absolute path
        //String newPageUrl = '/apex/ManagePortalUsersPage';
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.ManagePortalUsersPage;
        newPage.setRedirect(true);
        return newPage;
   }
   
  public void fetchContact(){      
    try {
       String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
       userProfile = [select id from profile where name =:portalUserProfile];
       String profileId = '\'' + userProfile.Id +'\''  ;
       String strQuery='';
        //latest query 28 july
       String loggedInContactAccountIdList = getContactsLoggedInAccountIdList();
       if(loggedInContactAccountIdList!= null && loggedInContactAccountIdList.length() > 0){
          //Query changes for Jira iSSUE 106
          strQuery= 'select id, FirstName, LastName, name, email, MobilePhone, HomePhone,Phone, Street_P__c,Street_P__r.Name,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c,UserProfile__c,Address_merge_field__c, HierarchyAccount__c from Contact where Status__c = \''+contactConstClass.ACTIVE+'\' and id in ('+ loggedInContactAccountIdList + ') and id in(select contactId from user where IsActive=true and id != \''+ UserInfo.getUserId()+'\') ORDER BY CreatedDate DESC ';
          System.debug('strQuery::'+strQuery);
          // Committed below 2 lines For Extending from pageControllerBase
          //setQuery(strQuery);
          //setExcelQuery(strQuery);
       } 
       if(tempFlag == true){
            integer i;
            i = 10/ 0;
        } 
     }catch(Exception e){
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
     }           
  }
   public List<User> fetchUserList(){
    return null;
  }
    
   public String getContactsLoggedInAccountIdList(){
    try {
        List<ID> accountIdList = new List<ID>();
        Map<ID,ID> contactAccMapList = new Map<ID,ID>();
        List<Account_Contact_Role__c> fetchAccountsACR = new List<Account_Contact_Role__c>();
        List<Account_Contact_Role__c> listOfContactsACR = new List<Account_Contact_Role__c>();
        //fetching the contactid first from contact- (contactid of logged in user)
        cntAccount=[select Id from contact where id in (Select contactId From User u where u.id=: UserInfo.getUserId() and u.IsActive=true)];
                
        //Fetching the accounts of that corresponding contact from ACR passing the contact id.
        fetchAccountsACR = [select Role__c,roleName__c,contact__c,Customer__c from Account_Contact_Role__c where contact__c = : cntAccount.Id and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
        System.debug('#fetchAccountsACR#'+fetchAccountsACR); 
        if(fetchAccountsACR.size() > 0){
         for(Account_Contact_Role__c acr: fetchAccountsACR){
           //Adding all accounts in list of that contact
           accountIdList.add(acr.Customer__c);
         }
       }
        //Fetching all the contacts from ACR Of this account list so that we will get all the contacts of the loogedincontactaccount from ACR
        listOfContactsACR =[select Role__c,roleName__c,contact__c,Customer__c from Account_Contact_Role__c where Customer__c in : accountIdList and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
        String uniqueContactIds = '';
        if(listOfContactsACR.size() > 0){
            for(Account_Contact_Role__c contactsACR :listOfContactsACR){
                if(contactsACR.Contact__C != null){
                //collecting Unique contacts ids from the fetched contactids
                    if(!uniqueContactIds.contains(contactsACR.Contact__C)){
                        if(uniqueContactIds == null || uniqueContactIds == ''){
                            uniqueContactIds = '\'' + contactsACR.Contact__C + '\'';
                        }else{
                            uniqueContactIds += ',\'' +contactsACR.Contact__C+'\'';
                        } 
                    }
                }
            }
        }  
        if(uniqueContactIds != null){
            return uniqueContactIds;
        }
        if(tempFlag == true){
            integer i;
            i = 10/ 0;
        }
            return uniqueContactIds;
    }catch(Exception e){
      system.debug('Error'+e.getMessage());
      ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
      ApexPages.addMessage(errorMsg);
      return null;
   } 
  }
      
  public void setStatus(){     
        String status = apexpages.currentpage().getparameters().get(contactConstClass.STATUS);
        String isActiveExistHierarchy = apexpages.currentpage().getparameters().get('isActiveExistHierarchy');
        system.debug('$isActiveExistHierarchy$'+isActiveExistHierarchy);
        if(status == null){        
          status = contactConstClass.INITIALSTATUS; 
        }   
        ApexPages.Message myMsg; 
        if(isActiveExistHierarchy == 'true'){
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_CreateContactPage_AnotherHierarchy);
           ApexPages.addMessage(myMsg);
           warningFlag = true;
        }else if(isActiveExistHierarchy == 'false'){
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P3);
           ApexPages.addMessage(myMsg);
           successFlag = true;
        }
        if(status == 'editedsuccessfully'){
            String emailFlag = apexpages.currentpage().getparameters().get('emailFlagValue');
            String freeFlyingFlag = apexpages.currentpage().getparameters().get('freeFlyingCheck');
            String userExistsfreeFlying = apexpages.currentpage().getparameters().get('userExistsAsFreeFly');
            if(emailFlag != null && emailFlag == 'false'){
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P3);    
                ApexPages.addMessage(myMsg);
                successFlag = true;
            }else if(apexpages.currentpage().getparameters().get('IsactiveAccount') == 'true'){
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P3);
                ApexPages.addMessage(myMsg);
                successFlag = true;
            }else if((freeFlyingFlag == 'true' && freeFlyingFlag != null) || (userExistsfreeFlying == 'true' && userExistsfreeFlying != null)){
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P1);    
                ApexPages.addMessage(myMsg);
                successFlag = true;
             }else{
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P3);    
                ApexPages.addMessage(myMsg);
                successFlag = true;
             } 
        }else if(status == 'addedsuccessfully'){     
          myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P1);
          ApexPages.addMessage(myMsg); 
          successFlag = true;    
        }else if(status == 'pendingcreation'){     
          myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_PendingCreation);
          ApexPages.addMessage(myMsg); 
          successFlag = true;    
        }else if(status == 'reactivateSuccessfully'){
          myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P1); 
          ApexPages.addMessage(myMsg);
          flagInactive = true;
          successFlag = true;
        }else if(status == 'deletedsuccessfully'){
          myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_P6); 
          ApexPages.addMessage(myMsg);
          flagInactive = true;
          successFlag = true;
        }
  }
     
        // save button is clicked  
   public PageReference addContact(){
   	// Change to absolute path
    //String newPageUrl = '/apex/CreatePortalUserPage';
    //PageReference newPage = new PageReference(newPageUrl);
    
    PageReference newPage = Page.CreatePortalUserPage;
    newPage.setRedirect(true);
    return newPage;
  }
        // save button is clicked  
   public PageReference deleteAllContact(){ 
     try {
        if(fetchUserList() != null){
            for(User user: fetchUserList()){
               user.isActive = false;
               update user;        
           } 
       }
       ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Successfully deleted all Portal Users');
       ApexPages.addMessage(debugMsg);
       fetchContact();
       initializePagingForUser();
       //Change to absolute path
       //String newPageUrl = '/apex/ManagePortalUsersPage';
       //PageReference newPage = new PageReference(newPageUrl);
       
       PageReference newPage = Page.ManagePortalUsersPage;
       newPage.getParameters().put('status', 'deletedsuccessfully');
       if(tempFlag == true){
            integer i;
            i = 10/ 0;
        }
       return newPage;
     }catch(Exception e){
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
        exceptionHandler.handleException(e,'deleteAllContact()',false,false,null,'Medium');
        return null;
     }      
   }
        // save button is clicked  
   public PageReference deleteContact() { 
     try {
        ID contactId = ApexPages.CurrentPage().getParameters().get('contactId');
        PortalUserService service = new PortalUserService();
        service.deletePortalUser(contactId);
        fetchContactDetails1();
        handlePaging();
        con.setPageSize(10);
        setCurrentCountText1();
       // ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_P6);
       // ApexPages.addMessage(errorMsg);
        successFlag = true;
        // Change to absolute path
        //String newPageUrl = '/apex/ManagePortalUsersPage';
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.ManagePortalUsersPage;
        newPage.getParameters().put('status', 'deletedsuccessfully');
        newPage.setRedirect(true);
        if(tempFlag == true){
            integer i;
            i = 10/ 0;
        }
        return newPage;
     } catch (Exception e){
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
        exceptionHandler.handleException(e,'deleteContact()',false,false,null,'Medium');
        return null;
     }     
   }
  // save button is clicked  
  public PageReference editContact() { 
  	
        String newPageUrl = '/apex/EditContactDetailsPage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
  }
  
  /** This method is used to export contacts to a excel sheet.*/
  public PageReference exportExcel(){
        PageReference excelPage;
        excelPage= Page.ExportExcelUser;
        return excelPage;
  }
        
  public void setCurrentCountText1(){
        if(con != null){
            if(con.getPageNumber() != null){
                Integer startRecordNumber = (con.getPageNumber()-1) * Integer.valueof(getPageSize1()) + 1;
                Integer lastRecordNumber = con.getPageNumber() * Integer.valueof(getPageSize1());
                if(Integer.valueof(getResultSize()) < lastRecordNumber )
                lastRecordNumber = Integer.valueOf(getResultSize());
                if(Integer.valueof(getResultSize()) <= 0 ){
                    currentCountText1 = string.valueof(getResultSize()) + '-' + string.valueof(lastRecordNumber) + ' ud af ' + string.valueof(getResultSize()) + ' brugere';
                }else{
                    currentCountText1 = string.valueof(startRecordNumber)+ '-' + string.valueof(lastRecordNumber) + ' ud af ' + string.valueof(getResultSize()) + ' brugere ';  
                }
            }
            }    
    }
        
    public List<contactWrapper> getPortalUserList(){
     try{
       List<ID> contactID = new List<ID>();
       portalUserList = new List<contactWrapper>();
       Map<ID,string> finalContactID = new Map<ID,string>();
       if(con != null){
                for(Contact c : (List<Contact>)con.getRecords()){
                	System.debug('#Records#'+c);
                    contactID.add(c.ID);
                }
        }
        System.debug('ContactId*****'+contactID);    
        List<Account_Contact_Role__c> listACR = [select id, Role__c,roleName__c,contact__c from Account_Contact_Role__c where contact__c IN : contactID  and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
        System.debug('$listACR$'+listACR);
        if(listACR.size() > 0){
        	System.debug('$Inside$');
         for(Account_Contact_Role__c acr : listACR){
              if(!finalContactID.containsKey(acr.Contact__C)){
                 finalContactID.put(acr.Contact__C, acr.roleName__c);
              }
         }
        }
        if(con != null){
            for(Contact c :(List<Contact>)con.getRecords()){
                contactWrapper portalUserList2 = new contactWrapper();
                portalUserList2.contact1 = c;
                portalUserList2.roleName = getProfileName(c.ID);
                if(portalUserList2.roleName == 'Bruger'){
                    portalUserList2.userRolename = contactRolesBruger;
                }else if(portalUserList2.roleName == 'Administrator'){
                    portalUserList2.userRolename = contactRolesAdministrator;
                }portalUserList.add(portalUserList2);
                    displayFlag = true;
                }
        }
        setCurrentCountText1();
        if(tempFlag == true){
            integer i;
            i = 10/ 0;
        }
        return portalUserList;
        }catch(Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                return null;
       }    
    } 
        
     public Boolean hasNext {
        get {
            if(con != null){
                return con.getHasNext();
            }
            return null;    
        }
        set;
     }
 
     // indicates whether there are more records before the current page set.
     public Boolean hasPrevious {
        get {
            if(con != null){
                return con.getHasPrevious();
            }
            return null;
        }
        set;
     }
 
     // returns the page number of the current page set
     public Integer pageNumber {
        get {

            if(con != null){
                return con.getPageNumber();
            }
            return null;
        }
        set;
     }
 
     // returns the first page of records
     public void first() {
        con.first();
     }
 
     // returns the last page of records
     public void last() {
        con.last();
     }
 
     // returns the previous page of records
     public void previous() {
        con.previous();
     }
 
     // returns the next page of records
     public void next() {
        con.next();
        setCurrentCountText1();
     }
 
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    
    public void setPageSize1(Integer pageSize1){
        this.pageSize1 = pageSize1;
    }
    
    public Integer getPageSize1(){
        return pageSize1;
    }
    public Integer getResultSize(){
        return con.getResultSize();
    }
    
   public List<sObject> getRecordsforExport(){
        List<sObject> temList = Database.query(query1);
        return temList;
   } 
        //Added sc-106        
   public List<ACRRoles> getListExport(){ 
    try {
          List<ACRRoles> listExpACRRole = new List<ACRRoles>();
          
          List<Contact> contactExpList = (List<Contact>)getRecordsforExport();
          List<ID> contactExpID = new List<ID>();
          for(Contact c : contactExpList){
            contactExpID.add(c.ID);
          }
          List<User> userList = [select u.Profile.Name, u.ContactId from User u where u.ContactId in: contactExpID];
          
          for(Contact c : contactExpList){
            ACRRoles newExpRole = new ACRRoles();
            newExpRole.contact = c;
            for(User user : userList){
                if(user.ContactId == c.Id){
                   if(user.Profile.Name.indexOf(ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c)!=-1){
                      newExpRole.UserType = 'Bruger';
                   }else if(user.Profile.Name.indexOf(ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c)!=-1){
                      newExpRole.UserType = 'Administrator';
                   }
                }
            }
            listExpACRRole.add(newExpRole);
          }
          if(tempFlag == true){
            integer i;
            i = 10/ 0;
          }
          return listExpACRRole;
    } catch (Exception e){
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
        exceptionHandler.handleException(e,'getListExport()',false,false,null,'Medium');
        return null;
    }      
    } 
  
    public void initializePagingForUser(){
        if(con !=null && con.getRecords() != null){
            if(con.getPageSize() == 0){
                getAllRecords();
            }else{
                con.setPageSize(Integer.valueOf(con.getPageSize()));
            }
            if(Integer.valueOf(getResultSize()) > 0 ){
                setCurrentCountText1();
            }
        }
        
    }
    public void getAllRecords(){
        con = new ApexPages.StandardSetController(Database.getQueryLocator(query1));
    }   
    
    public void handlePaging(){
        if(con != null && con.getRecords() != null){
            if(con.getPageSize() == 0){
                getAllRecords();
            }else{
                con = new ApexPages.Standardsetcontroller(Database.getQueryLocator(query1));
                con.setPageSize(Integer.valueOf(con.getPageSize()));
            }
            if(Integer.valueOf(getResultSize()) > 0 ){
                setCurrentCountText1();
            }
        }
    }
    
    public void fetchContactDetails1(){
        try {
            String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
            userProfile = [select id from profile where name =:portalUserProfile];
            String profileId = '\'' + userProfile.Id +'\''  ;
            String strQuery='';
            String loggedInContactAccountIdList = getContactsLoggedInAccountIdList();
            if(loggedInContactAccountIdList!= null && loggedInContactAccountIdList.length() > 0){
            strQuery= 'select id, name, email, MobilePhone, HomePhone,Phone, Street_P__c,Street_P__r.Name,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c from Contact where Status__c = \''+contactConstClass.ACTIVE+'\' and id in ('+ loggedInContactAccountIdList + ') and id in(select contactId from user where IsActive=true and id != \''+ UserInfo.getUserId()+'\') ORDER BY CreatedDate DESC ';
            }  
            if(tempFlag == true){
                integer i;
                i = 10/ 0;
            }
         } catch (Exception e){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                    ApexPages.addMessage(errorMsg);
            }   
    }
    
     public String getProfileName(ID contactId){
        User[] user=[select  u.Profile.Name from User u where u.ContactId =: contactId limit 1];
        String profileName = null;
        String roleName = null;
        String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
        portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
        if(user.size() > 0 && user != null){
             profileName = user[0].Profile.Name;
             
             if(profileName.indexOf(portalAdminUser)!=-1){
                    roleName = 'Administrator';
             }else if(profileName.indexOf(portalUserProfile)!=-1){
                    roleName = 'Bruger';
             }
        }
        return roleName;
    } 
    
    /*public void fetchHierarchyDetails(){
        Contact contact1 = [Select Id , HierarchyAccount__c From Contact  where id in (select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
        System.debug('$contact1$'+contact1);
        if(contact1 != null){
            if(contact1.HierarchyAccount__c == null && contact1.HierarchyAccount__c != ''){
                hierarchyFlag = false;
            }else{
                hierarchyFlag = true;
            }
        }
    }*/
 
    
}