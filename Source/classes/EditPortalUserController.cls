public class EditPortalUserController {
/*	PortalUserUtil portalUserUtil = new PortalUserUtil();
    PortalUserMailService mailService = new PortalUserMailService();
    PortalUserService service = new PortalUserService();
    
    public Boolean strFlag;
    public boolean chkFlag = true;
    public boolean displayAddressInfo{get; set;} //new
    public Boolean warningFlag {get; set;}
    public Boolean errorFlag {get; set;}
    //added- sc-234 
    public String freeFlyingChk {get; set;}
    public String userExistFreeFlyChk {get; set;} 
    public String checkInActiveFlag{get; set;}
     
    public User[] user { get; set; }
    public String portalBrugerRole{get; set;}
    //added sc-429
    public String portalAdminRole{get; set;}
    public String userRolename{get; set;}
    
    public String emailFlagValue, currentEmail, currentId;           
    public String checkInActive{get; set;}
    public string contactProfile{get;set;}
    public String portalAdminUser{get; set;}
  //  public String historyEntryFlag {get; set;}
    public String freeFlyingContact {get; set;}
    public String userExistsAsFreeFly {get; set;}
     
    public ID contactId,accountId,userId;
    public ID getAccountId() {return accountId;}
   
    public String getEmailFlagValue() {return emailFlagValue;}
    public void setEmailFlagValue(string eFlag){emailFlagValue = eFlag;}
    public void setAccountId(ID accountId) {accountId = accountId;} 
    public void setcurrentId(String cid) {currentId = cid;}
    
    public Contact contact;
    public Contact getContact(){return contact;}
    public void setContact(Contact c){this.contact = c;}     
    
    public List<cAccount> accountList {get; set;}
    public List<Integer> maxLevel = new List<Integer>{};
    public List<cObjectStructureMap> objectStrList {get; set;}
    public List<ObjectStructureMap> asm = new List<ObjectStructureMap>{}; 
    public Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
    
    List<ID> cableUnitIds = new List<ID>();
    
    public List<Contact> contactHistoryList = new List<Contact>();
    public List<History_Log_External_Contact_Role__c> historyContactLog = new List<History_Log_External_Contact_Role__c>();
   
    public Address__C address{get; set;}     //new
    public boolean isPortalAdmin {get; set;}
	public String siteCoreUrl{get; set;}
	public boolean isUserActive{get;set;}
*/
	PortalUserUtil portalUserUtil = new PortalUserUtil();
    PortalUserMailService mailService = new PortalUserMailService();
    PortalUserService service = new PortalUserService();
    
    transient Boolean strFlag;
    public boolean chkFlag = true;
    public boolean displayAddressInfo{get; set;} //new
    public Boolean warningFlag {get; set;}
    public Boolean errorFlag {get; set;}
    //added- sc-234 
    public String freeFlyingChk {get; set;}
    public String userExistFreeFlyChk {get; set;} 
    public String checkInActiveFlag{get; set;}
    
    public User[] user { get; set; }
    public String portalBrugerRole{get; set;}
    //added sc-429
    public String portalAdminRole{get; set;}
    public String userRolename{get; set;}
    
    public String emailFlagValue, currentEmail, currentId;           
    public String checkInActive{get; set;}
    public string contactProfile{get;set;}
    public String portalAdminUser{get; set;}
  //  public String historyEntryFlag {get; set;}
    public String freeFlyingContact {get; set;}
    public String userExistsAsFreeFly {get; set;}
     
    public ID contactId,accountId,userId;
    public ID getAccountId() {return accountId;}
   
    public String getEmailFlagValue() {return emailFlagValue;}
    public void setEmailFlagValue(string eFlag){emailFlagValue = eFlag;}
    public void setAccountId(ID accountId) {accountId = accountId;} 
    public void setcurrentId(String cid) {currentId = cid;}
    public string pageName {get;set;}
    public Contact contact;
    public Contact getContact(){return contact;}
    public void setContact(Contact c){this.contact = c;}     
    
    transient List<cAccount> accountList {get; set;}
    transient List<Integer> maxLevel = new List<Integer>{};
    transient List<cObjectStructureMap> objectStrList {get; set;}
    transient List<ObjectStructureMap> asm = new List<ObjectStructureMap>{}; 
    transient Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
    
    transient List<ID> cableUnitIds = new List<ID>();
    
    transient List<Contact> contactHistoryList = new List<Contact>();
    transient List<History_Log_External_Contact_Role__c> historyContactLog = new List<History_Log_External_Contact_Role__c>();
   
    public Address__C address{get; set;}     //new
    public boolean isPortalAdmin {get; set;}
	public String siteCoreUrl{get; set;}
	public boolean isUserActive{get;set;}
	public string objectStrListJson {get;set;}	
	public string selectNodeIds1 {get;set;}
	public Boolean checkFreeFly{get; set;}
	
    public EditPortalUserController(){
     pageName='';
     selectNodeIds1 = '';
     errorFlag = false;
     warningFlag = false;
     isPortalAdmin = false;
     isUserActive = false;
     portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
     portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
     siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
     //added sc-429
     portalAdminRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
     contactId = ApexPages.CurrentPage().getParameters().get('contactId');
     System.debug('---contactId EditPortalUserController------'+contactId);
     setContactDetails();
           
     if(ApexPages.CurrentPage().getParameters().get('enteredEmailUnique') != null){
       emailFlagValue = ApexPages.CurrentPage().getParameters().get('enteredEmailUnique');                        
     }
           
     if(ApexPages.CurrentPage().getParameters().get('isActiveExistHierarchy') != null){
       checkInActive = ApexPages.CurrentPage().getParameters().get('isActiveExistHierarchy'); 
       checkInActiveFlag = checkInActive;            
     }
     strFlag = false;
     System.debug('*History *'+ApexPages.CurrentPage().getParameters().get('historyLogExistHierarchy'));
         /* if(ApexPages.CurrentPage().getParameters().get('historyLogExistHierarchy') != null){
              historyEntryFlag = ApexPages.CurrentPage().getParameters().get('historyLogExistHierarchy');
              System.debug('historyEntryFlag:' + historyEntryFlag);
           }*/
     if(ApexPages.CurrentPage().getParameters().get('freeFlyingContactHierarchy') != null){
       freeFlyingContact = ApexPages.CurrentPage().getParameters().get('freeFlyingContactHierarchy');
       System.debug('freeFlyingContact :' + freeFlyingContact);
       freeFlyingChk = freeFlyingContact;
     }
         //  System.debug('historyEntryFlag value in conmstructor::'+historyEntryFlag);
     System.debug('Flag in EditPortalUser controller emailFlagValue::'+emailFlagValue+'..and checkInActive::'+checkInActive);
           
     if(ApexPages.CurrentPage().getParameters().get('userExistsFreeFlying') != null){
       userExistsAsFreeFly = ApexPages.CurrentPage().getParameters().get('userExistsFreeFlying');
       System.debug('userExistsAsFreeFly :' + userExistsAsFreeFly);
       userExistFreeFlyChk = userExistsAsFreeFly;
     }
     
     if(ApexPages.CurrentPage().getParameters().get('fromCreateScreen') != null && ApexPages.CurrentPage().getParameters().get('fromCreateScreen') == 'true'){
     	checkFreeFly = true;
     }else{
     	checkFreeFly = false;
     }
     system.debug('####checkFreeFly$$$'+checkFreeFly);
     fetchAddressDetails();
     getObjectStructure();
     objectStrListJson = JSON.serialize(objectStrList);
   }
   
   //Fetching the logged in contact details - as per SC-107 
   Contact loggedInContactDetails = service.getLoggedInUserContactDetails(); 
   public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('PortalUserUtil','Administration of portal users');
        
   public void setContactDetails(){
    //fetching the contact details 
  	ID accountId; 
  	Contact con = new Contact();
  	User loggedInUser = new User();
  	List<Contact> contList = new List<Contact>();
  	
    if(contactId != null){
      con = [Select id, accountId, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__r.Name, Status__c, UserProfile__c From Contact  where id =: contactId LIMIT 1];     
      if(con != null){
        currentEmail = con.Email;
      }
      //checking whether that contact is user or not
      user = [Select id, IsActive from user where contactid =: contactId];
      isUserActive = user[0].IsActive;
      //getting the streetdetails
      if(con.Street_P__c != null) {   
        con = portalUserUtil.getStreetForAccount(con.accountId, con);
      }   
    }
       
    //fetching the details of logged in user   
    loggedInUser = [select contactid from User where id =: UserInfo.getUserId()];            
       
    //checking whether that logged in user is contact or not
    if(loggedInUser != null){
      contList = [select accountId,HierarchyAccount__c from Contact where id =: loggedInUser.contactid limit 1];
    }
    if(contList.size() > 0) {                   
      setcurrentId(contList[0].HierarchyAccount__c);
    } 
    setContact(con);
    setContactProfile();
	 /*  if(con != null){
   	 		if(cableUnitAccountIds != null){
           	 	historyContactLog =[Select h.Action__c, h.Old_RoleName__c, h.Old_RoleId__c, h.Old_Contact_Name__c, h.Old_ContactId__c, h.Name,h.Id, h.Account__c From History_Log_External_Contact_Role__c h where h.Old_ContactId__c =: con.Id and h.Account__c =: currentAccountId  and  (h.Old_RoleName__c!=: contactRoleAdministrator or h.Old_RoleName__c !=: contactRoleBruger)];
                System.debug('historyContactLog in setcontact details '+historyContactLog);
                System.debug('size is  ::: '+historyContactLog.size());
                if(historyContactLog != null && historyContactLog.size() > 0){
                 
                }
   	 		}
	  }*/
   }
     
   public void setContactProfile(){
    if(Contact.Id != null){
      Profile[] profileContact = [Select Name from profile where id in (select profileId from User where Contactid =: Contact.Id)];
      if(profileContact != null && profileContact.size() > 0){
	    contactProfile = profileContact[0].name;
	    System.debug('Contact profile ::'+contactProfile);
	    if(contactProfile == portalAdminUser){
	       isPortalAdmin = true;
	       userRolename = portalAdminRole;
	    }else{
	       userRolename = portalBrugerRole;
	    }
      }
    }
   }
        
   public List<cObjectStructureMap> getObjectStructure(){
     Contact con = [Select id, accountId, name, firstname, lastname, email, MobilePhone, 
        				HomePhone, Phone, Street_P__c, Street_P__r.Name, UserProfile__c From Contact  where id = :contactId LIMIT 1];
     Map<ID, ID> params = portalUserUtil.getAssignedCableUnits(contactId);
     if(objectStrList == null){
       //asm.clear();
       asm = new List<ObjectStructureMap>{}; 
       if(objectStrList == null){
          objectStrList = new List<cObjectStructureMap>();
       } 
       if(currentId.length() > 0){
         System.assertNotEquals(currentId,null,Label.SC_SObjectIDMandatory);
         asm = formatObjectStructure(CurrentId);
         for(ObjectStructureMap objectStructure : asm) {
           cObjectStructureMap objmap = new cObjectStructureMap(objectStructure);
           if(params.containsKey(objmap.pos.account.id)){
             objmap.selected = true;
             objmap.prevselected = true;
           }      
           objectStrList.add(objmap); 
          }
        } 
       } 
       System.debug('inside getObjectStructure(),objectStrList--->'+objectStrList+'...and size--->'+objectStrList.size());
       return objectStrList;
  }
    
   // Query Account from top down to build the ObjectStructureMap //
  public ObjectStructureMap[] formatObjectStructure(String currentId){
    masm = new Map<String, ObjectStructureMap>{};
    //masm.clear();
    String nodeId = '0';
    String nodeType = 'child';
    Integer count = 0;
    Integer level = 0;
    Boolean endOfStructure = false;
    List<Account> al = new List<Account>{};
    List<ID> currentParent = new List<ID>{};
    List<String> nodeSortList = new List<String>{};
    List<Boolean> levelFlag = new List<Boolean>{};
    List<Boolean> closeFlag = new List<Boolean>{};
    List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
    Map<ID, String> nodeList = new Map<ID, String>{};
    maxLevel = new List<Integer>{};
    // Find highest level obejct in the structure//
    /*Commenting below line as GetTopElement is returing topmost parent acc id, if user has access to single account ,account hierarchy for the parent is generating*/
       //currentParent.add(GetTopElement(currentId));
   	currentParent.add(currentId);
      // Loop though all children
    while (!endOfStructure ){
      if(level==0){
         // Change below//        
         al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c,a.Cable_Unit__c,a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
      }else {
   		 // Change below
         al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c,a.Cable_Unit__c,a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
      }

      if(al.size() == 0){
        endOfStructure = true;
      }else {
        currentParent.clear();
        for (Integer i = 0 ; i < al.size(); i++){
         // Change below
          Account a = al[i];
          if(al[i].Anlaeg_Name__c != null && al[i].Anlaeg_Name__c != ''){
         		a.Anlaeg_Name__c = ' '+al[i].Anlaeg_Name__c;
          }else {
             a.Anlaeg_Name__c = ' ';
          }
          if(al[i].Cable_Unit_No__c != null && al[i].Cable_Unit_No__c != ''){
              a.Anlaeg_No__c = ' -  '+al[i].Cable_Unit_No__c+ ' ';
          }else {
              a.Anlaeg_No__c = ' ';
          }
          if (level > 0){
            nodeId=NodeList.get(a.ParentId)+'.'+String.valueOf(i);
          }else {
            nodeId=String.valueOf(i);
          }   
          masm.put( NodeID, new ObjectStructureMap(nodeID,levelFlag,closeFlag,nodeType,false,false,a));
          currentParent.add(a.id);
          nodeList.put(a.id,nodeId);
          nodeSortList.add(nodeId);
        }
        maxLevel.add(level);                
        level++;
      }
    }
        
   System.debug('NodeSortList.size()--->'+NodeSortList.size());
        // Account structure must now be formatted//
       NodeSortList.sort();
       for (Integer i = 0; i < NodeSortList.size();i++){
       List<String> pnl = new List<String> {};
       List<String> cnl = new List<String> {};
       List<String> nnl = new List<String> {};
       if (i > 0){
           String pn = NodeSortList[i-1];
           pnl = pn.split('\\.',-1);
        }
       String cn = NodeSortList[i];
       cnl = cn.split('\\.',-1);
       if (i < NodeSortList.size()-1){
          String nn = NodeSortList[i+1];
          nnl = nn.split('\\.',-1);
         }
      ObjectStructureMap tasm = masm.get(cn);
        if (cnl.size() < nnl.size()){
           //Parent
           if (isLastNode(cnl)){
               tasm.nodeType='parent_end';
           }else {
              tasm.nodeType='parent';
            }
         }else if (cnl.size() > nnl.size()){
              tasm.nodeType='child_end';
              tasm.closeFlag=setcloseFlag(cnl, nnl, tasm.nodeType);
         }else {
              tasm.nodeType='child';
         }
         tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType); 
          //Change below//
         if (tasm.account.id == currentId){
             tasm.currentNode=true;
         }
         asm.add(tasm);
         }
           
         if(asm.size() > 0){
           	asm[0].nodeType='start';
           	 // Below line commented as the last node of subhierarchy was not getting selected
             // on selecting the whole hierarhcy
           	//asm[asm.size()-1].nodeType='end';
         }
      return asm;
    }
    
   // Determin parent elements relationship to current element//
  public List<Boolean> setlevelFlag(List<String> nodeElements, String nodeType){
    List<Boolean> flagList = new List<Boolean>{};
    String searchNode = '';
    String workNode = '';
    Integer cn = 0;
    for(Integer i = 0; i < nodeElements.size()-1;i++){
        cn = Integer.valueOf(nodeElements[i]);
        cn++;
        searchNode=workNode + String.valueOf(cn);
        workNode=workNode + nodeElements[i] + '.';
        if (masm.containsKey(searchNode)){
            flagList.add(true);
        }else{
            flagList.add(false);
        }
      }
      return flagList;
  }
    
    // Determin if the element is a closing element//
  public List<Boolean> setcloseFlag(List<String> cnl, List<String> nnl, String nodeType){
    List<Boolean> flagList = new List<Boolean>{};
    String searchNode = '';
    String workNode = '';
    Integer cn = 0;
    for(Integer i = nnl.size(); i < cnl.size();i++){
        flagList.add(true);
    }
    return flagList;
  }

    // Determin if Element is the bottom node//    
  public Boolean isLastNode(List<String> nodeElements){
    String searchNode = '';
    Integer cn = 0;
    for(Integer i = 0; i < nodeElements.size();i++){
        if (i == nodeElements.size()-1){
            cn = Integer.valueOf(nodeElements[i]);
            cn++;
            searchNode=searchNode + String.valueOf(cn);
        }else {
            searchNode=searchNode + nodeElements[i] + '.';
        }
    }
    if (masm.containsKey(searchNode)){
        return false;
    }else{
        return true;
    }
  }

  // Find the tom most element in Heirarchy //
  /*public String GetTopElement(String objId) {
	System.debug('**objId**'+objId);
    Boolean top = false;
    while (!top) {
        //// Change below//
        Account a = [Select a.id, a.ParentId From Account a where a.id = :objId LIMIT 1];
        //
        
        if (a.ParentID != null) {
            objId = a.ParentID;
        }else{
            top=true;
        }
    }
    return objId ;
 }*/
    
 public List<ID> getAllRelatedCableUnits(){
     // Loop though all children and populate the accountsToShare list with the account ids
     Integer level = 0;
     ID accountId = getAccountId();
     List<ID> currentParent = new List<ID>{};
     List<ID> accountsToShare = new List<ID>{};
     List<Account> acctList = new List<Account>{};
     Boolean endOfStructure = false;
     while (!endOfStructure ){
       if(level==0)
         acctList = [select a.Cable_Unit__c,a.Cable_Unit__r.Building_Type__c,a.ParentId, a.Id, a.name from Account a WHERE a.id = :accountId];
      else
        acctList = [select a.Cable_Unit__c,a.ParentId, a.Cable_Unit__r.Building_Type__c,a.Id, a.name from Account a WHERE a.ParentId IN :currentParent];
        if(acctList.size() == 0){
          endOfStructure = true;
        }else {
         currentParent.clear();
         for(Account acctObj : acctList){
           accountsToShare.add(acctObj.Id);
           currentParent.add(acctObj.id);
         }
        acctList = new List<Account>{};
        level++;
     }
   }
   return currentParent;
  }
    
  public List<cAccount> getAccounts(){
  	cableUnitIds = new List<ID>(); 
    if(accountList == null){
      accountList = new List<cAccount>();
      cableUnitIds = getAllRelatedCableUnits();
      if(cableUnitIds != null){ 
       List<Account> accounts = [select Anlaeg_No__c, Name, id from Account where ID in :cableUnitIds];
       for(Account a : accounts) {
         accountList.add(new cAccount(a)); 
       }
      }
    }    
    return accountList;
  }   

  // save button is clicked  
  public PageReference save() {
  	System.debug('--------inside save-------- in editportalusercontroller-----------');
  	ApexPages.Message errorMsg = null;
  	boolean selectedFlag = false;
  	errorFlag = false;
    warningFlag = false;
  	boolean contactExists, userExists;
  	List<User> userList = new List<User>();
  	List<AccountShare> aShare = new AccountShare[0]; 
  	List<Contact> chkContactExist = new List<Contact>();
  	List<Contact> contactDetail = new List<Contact>();
  	List<Account> accountListCreated =new List<Account>();
  	List<Account> deletedCableUnitsList = new List<Account>();
  	
    List<ID> accountListDeleted =new List<ID>();
    List<ID> accountListCreatedId =new List<ID>();
    
    Map<String, String> deletedCableUnitMap = new Map<String, String>(); 
    
  	freeFlyingChk = 'false';
  	userExistFreeFlyChk = 'false';
  	checkInActiveFlag = 'false'; 
    try{
       system.debug('Inside validFlag');
       //Change to absolute path
       //String newPageUrl = '/apex/ManagePortalUsersPage';
       //PageReference newPage = new PageReference(newPageUrl);
       system.debug('select ids'+selectNodeIds1 );
       String[] dynStrArr = selectNodeIds1.split(','); 
       System.debug('#############3SelectIdSet$$$$$4'+dynStrArr);
       Set<String>SelectIdSet = new Set<String>(); 
       SelectIdSet.addAll(dynStrArr);
       System.debug('#############3SelectIdSet$$$$$4'+SelectIdSet);
       
       PageReference newPage = Page.ManagePortalUsersPage;
       if(!isPortalAdmin){
       	getObjectStructure();
       	if(objectStrList.size() > 0){
        	for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
                Id accntId =  objectStrList[chkBoxCount].pos.account.Id;
                System.debug('Selected :'+objectStrList[chkBoxCount].selected+'PrcSel**'+objectStrList[chkBoxCount].prevselected);
                if(SelectIdSet.contains(accntId)){
                        System.debug('Inside Selected&&&&&&');
                        objectStrList[chkBoxCount].selected = true;
                }else{
                        objectStrList[chkBoxCount].selected = false;
                }
             }
                            
         }
         objectStrListJson = JSON.serialize(objectStrList);
 		 system.debug('Inside save objectStrListJson: '+objectStrListJson); 
	      if(objectStrList.size() > 0){
			for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
	  			Account account = objectStrList[chkBoxCount].pos.account;
	  			if(objectStrList[chkBoxCount].selected){
	  				accountListCreated.add(account);
		           accountListCreatedId.add(account.id);
		           selectedFlag = true;
	  			}
	  		//	if((!deletedCableUnitMap.containsKey(account.name)) && objectStrList[chkBoxCount].selected == false && objectStrList[chkBoxCount].prevselected == true){
	  			if(objectStrList[chkBoxCount].selected == false && objectStrList[chkBoxCount].prevselected == true){
		           deletedCableUnitsList.add(account);
		           accountListDeleted.add(account.id);
		         }
		         deletedCableUnitMap.put(account.name, account.name);
			}
			System.debug('accountListCreated--'+accountListCreated);
			System.debug('accountListCreated size--'+accountListCreated.size());
			System.debug('outer***');
		  }
       	
       	     /*      
	       for(cObjectStructureMap objectStructureMap : getObjectStructure()){
	         Account account = objectStructureMap.pos.account;
	         if(objectStructureMap.selected){
	           system.debug('$objectStructureMap.selected$'+objectStructureMap.selected);
	           accountListCreated.add(account);
	           accountListCreatedId.add(account.id);
	           selectedFlag = true;
	         }
	         if((!deletedCableUnitMap.containsKey(account.name)) && objectStructureMap.selected == false && objectStructureMap.prevselected == true){
	           deletedCableUnitsList.add(account);
	           accountListDeleted.add(account.id);
	         }
	         deletedCableUnitMap.put(account.name, account.name);
	         system.debug('$Deleted Cable Unit Map$'+deletedCableUnitMap);
	       }*/
	       System.debug('selectedFlag-----'+selectedFlag);
	       System.debug('accountListCreated-----'+accountListCreated);
	       System.debug('accountListDeleted-----'+accountListDeleted);
	       if(!selectedFlag){
	          System.debug('selectedFlag error---'+selectedFlag);
	          ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_OneRoles_Mandatory);
	          ApexPages.addMessage(errorMsg1);
	          warningFlag = true;
	          return null;
	       }
       }
       //fetch current users assigned accounts from aCR to check if any new accounts are asigned.If new accounts are assigned then chaneg the accountId of Contact object to logged in users accountId
       Boolean accountCheckedFlag = ServiceCenterSingleton.getInstance().checkUsersAssignedAccount(accountListCreatedId,contact.Id);
       if(accountCheckedFlag == true){
    	if(accountListCreatedId.size() > 0){
        	if(accountListCreatedId.size() > 1){
        		contact.HierarchyAccount__c = currentId;
        	}else if(accountListCreatedId.size() == 1){
        		contact.HierarchyAccount__c = accountListCreatedId[0];
        	}
         }
       }
       //chk for email 
	   if(contact.Email != null && currentEmail != contact.Email.trim()){
		 chkContactExist = [select Id,Email,IsPersonAccount from Contact where Email =: contact.Email.trim() AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
	   }
       //userList = [Select u.IsPortalEnabled,u.isactive, u.ContactId ,u.Contact.Email,u.contact.accountid, u.contact.HierarchyAccount__c From User u where u.email =: contact.email and u.contact.email =: contact.email];
       //fetched user details of contact
       if(contactId != null){
         userList = [Select u.IsPortalEnabled,u.isactive, u.ContactId ,u.Contact.Email,u.contact.id,u.contact.accountid, u.Contact.HierarchyAccount__c From User u where u.contact.id =: contactId];
         contactDetail = [select Id, FirstName, LastName,MobilePhone,Phone, Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,HierarchyAccount__c from Contact where Id =: contactId];
       }
     
       if(contactDetail.size() > 0){ 
         if(contact.FirstName != null){
		   contactDetail[0].FirstName = contact.FirstName;
		 }
	     if(contact.LastName != null){
		   contactDetail[0].LastName = contact.LastName;
	     }
	     if(contact.Email != null){
		   contactDetail[0].Email = contact.Email.trim();
	     }
		 //if(contact.Phone != null){
		   contactDetail[0].Phone = contact.Phone;
		// }
		// if(contact.MobilePhone != null){
		   contactDetail[0].MobilePhone = contact.MobilePhone;
		// }
		// if(contact.HomePhone != null){
		   contactDetail[0].HomePhone = contact.HomePhone;
		// }
		 if(contact.Street_P__c != null){
		    contactDetail[0].Street_P__c = contact.Street_P__c;
		 }
		 
	     contact = contactDetail[0];
       }
         
       if(ApexPages.CurrentPage().getParameters().get('fromCreateScreen') != null &&  
                       ApexPages.CurrentPage().getParameters().get('fromCreateScreen') == 'true'){
		 newPage.getParameters().put('status', 'editedsuccessfully');
		// Contact[] contactEmail = [select Id, FirstName, LastName, Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,HierarchyAccount__c from Contact where Id =: contactId];
		 
		 if(contactDetail.size() > 0){
		   if(chkContactExist.size() > 0){ 
            //Scenario SC_P7 - if email id entered while editing, is already exists on Contact object
            System.debug('---Scenario SC_P7 Contact exists--------');
     	    errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P5); 
            ApexPages.addMessage(errorMsg);
            warningFlag = true;  
            return null;
	     }else{
		   if((freeFlyingContact == 'true' && freeFlyingContact != null) ||
		        (userExistsAsFreeFly == 'true' && userExistsAsFreeFly != null)){  //2ND IF
             System.debug('----SCENARIO OF SC_P7 FREE FLYING CONTACT/User already exists and account as dummy account--------');
	         //Scenario SC_P7
			 contactExists = true;
					
        	 if(freeFlyingContact != null){
        	   userExists = false;
        	   System.debug('-----------------------freeFlyingContact chk-------------------'+userExists);
               newPage.getParameters().put('freeFlyingCheck',freeFlyingContact);
        	 }
             if(userExistsAsFreeFly != null){
              //SC_P7 Free flying user with dummy accounts
               userExists = true;
               System.debug('-------userExistsfreeFlying-------------------------------'+userExists);
               newPage.getParameters().put('userExistsAsFreeFly',userExistsAsFreeFly);
             }
             strFlag = true;
             if(!PortalUserService.isMandatoryInfoMissingOnCU(accountListCreated)){
               service.createPortalUser(accountListCreated, contact,contactExists,userExists);
             }else{
               errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
               ApexPages.addMessage(errorMsg);
               errorFlag= true;
               return null;
              } 
              pageName = newPage.getUrl();
              return null;
	         //return newPage;
		  }else{ //End of freeflying chk from create screen
              //Method will get called for SC-P2
              System.debug('-------------SCENARIO SC_P2  OPENING IN editPORTAL USER PAGE --------------');	
              if (!PortalUserService.isMandatoryInfoMissingOnCU(accountListCreated)){
                 service.editPortalUserNew(contact, accountListCreatedId,accountListCreated, deletedCableUnitsList,accountListDeleted);
              }else{
                 errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                 ApexPages.addMessage(errorMsg);
                 errorFlag = true;
                 return null;
              } 
              newPage.getParameters().put('status', 'editedsuccessfully');
              newPage.getParameters().put('emailFlagValue',emailFlagValue);
              strFlag = true;
              pageName = newPage.getUrl();
              return null;
              //return newPage;
		}//end of else part of freeflying chk
      }
	 }//end of if contactemail size chk
    }//end of fromCreatescreen
       
    //Email doesn't exists.
   // List<Contact> contactList = new List<Contact>();   
    
    if(chkContactExist.size() > 0 && ((userList.size() > 0 && userList[0].Contact.Email != contact.email.trim()) || contact.email != currentEmail)){ 
	    //Scenario EDIT  - if email id entered while editing, is already exists on Contact object
	    System.debug('---Not fromCreatescreen SC_P9 Scenario Already exists on Contact object--------');
	    errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P5); 
	    ApexPages.addMessage(errorMsg);
	    warningFlag = true; 
	    return null;
	}else{
		//SC_P7, SC_P8
	 /*
	 contactList =[select Id,FirstName,LastName,Street_P__c,Status__c, Post_Code_P__c, House_No_P__c, HomePhone,Floor_No_P__c, 
                 	 	Entrance_P__c,Email,Door_No_P__c, District_P__c, AccountId, HierarchyAccount__c from Contact where Id =: contactId];  
       */         
     System.debug('SC_P7, SC_P8  contactDetail-----'+contactDetail.size());
    
     if(loggedInContactDetails != null && (userList.size() > 0 && userList[0].Contact.HierarchyAccount__c == loggedInContactDetails.HierarchyAccount__c)){           
          //For the same hierarchy
        newPage.getParameters().put('status', 'editedsuccessfully');
        System.debug('Scenario sc_p8---$$$$$-check userList[0].IsActive----'+userList[0].IsActive);
	    if(!PortalUserService.isMandatoryInfoMissingOnCU(accountListCreated)){
          service.editPortalUserNew(contact, accountListCreatedId,accountListCreated, deletedCableUnitsList,accountListDeleted);
        }else{
          errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
          ApexPages.addMessage(errorMsg);
          errorFlag = true;
          return null;
	    } 
	    newPage.getParameters().put('IsactiveAccount', 'true');
     }else{
     	System.debug('Emailid*** that you have enetered, that one is present in another hierarchy');
        errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P5); 
        ApexPages.addMessage(errorMsg);
        warningFlag = true;  //cfxf
        return null;
     }
   }//newly added
   pageName = newPage.getUrl();
   return null;
   //return newPage;
  }catch(Exception e){
  	if(e.getDmlType(0) == StatusCode.DUPLICATE_USERNAME){ 
  	  errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
  	  ApexPages.addMessage(errorMsg); 
  	  errorFlag = true;
	  exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
	  system.debug('Shown Error message');
	  return null;
  	}else{ 
      System.debug('editPortalUser CONTROLLER else---------------'+e.getMessage());
      ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
	  ApexPages.addMessage(debugMsg);
	  errorFlag = true;
	  exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
	  system.debug('Shown Error message');
	  return null;
     }
   }
 }
 
 public PageReference cancel() {
   return Page.ManagePortalUsersPage;   
 } 
      
 // Method to fetch address details
 public PageReference fetchAddressDetails(){
   String addressId = contact.Street_P__c;
   List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
   if(addressList.size() > 0){
	 address = addressList.get(0);			
   }
   displayAddressInfo = true;  	
   return null;
 }     
          
}