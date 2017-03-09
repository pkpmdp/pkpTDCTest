public class CreatePortalUserController {

/*     PortalUserService service = new PortalUserService();
     AccountTreeStructure accTreeStructure =  new AccountTreeStructure();
     // Declare variables
     ID fetchedId;
     // For Test
     public boolean userExist {get;set;}
     public boolean userIsActive{get; set;}
     public Address__C address{get; set;}         // Added for Address Section
            
     public boolean chkFlag = true;
     public boolean errorFlag {get;set;} 
     public boolean successFlag {get;set;}
     public boolean warningFlag {get;set;}
     public boolean displayAddressInfo{get; set;}  // Added for Address Section
    
     //public String newPageUrl;        
     // the contact record you are adding values 
     public Contact contact = new Contact();      
     public Contact contactList {get; set;}
      
     public String currentId;
     public String streetName1 {get; set;}
     public String portalBrugerRole{get; set;}
     public String portalAdminUser{get; set;}  
     public String siteCoreUrl{get; set;}      
     //public ID accID = service.getContactAccountId();
     
     public List<ID> cableUnitIds = new List<Id>();                         
     public List<Integer> maxLevel = new List<Integer>{};
     public List<cAccount> accountList {get; set;}
     public List<cObjectStructureMap> objectStrList {get; set;}
     public List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
     public Boolean selectedFlag {get;set;} 
     public Contact loggedInContactDetails = new Contact();
         
   //  public List<History_Log_External_Contact_Role__c> historyContactLog {get; set;}
     public List<Account_Contact_Role__c> acrUserEntries = new List<Account_Contact_Role__c>();
     
     private static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
     private static String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
     
     
     public Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
     */
     PortalUserService service = new PortalUserService();
     transient AccountTreeStructure accTreeStructure =  new AccountTreeStructure();
     // Declare variables
     transient ID fetchedId;
     // For Test
     public boolean userExist {get;set;}
     public boolean userIsActive{get; set;}
     public Address__C address{get; set;}         // Added for Address Section
            
     public boolean chkFlag = true;
     public boolean errorFlag {get;set;} 
     public boolean successFlag {get;set;}
     public boolean warningFlag {get;set;}
     public boolean displayAddressInfo{get; set;}  // Added for Address Section
    
     //public String newPageUrl;        
     // the contact record you are adding values 
     public Contact contact = new Contact();      
     public Contact contactList {get; set;}
     public String pageName{get;set;} 
     public String currentId;
     public String streetName1 {get; set;}
     public String portalBrugerRole{get; set;}
     public String portalAdminUser{get; set;}  
     public String siteCoreUrl{get; set;}      
     //public ID accID = service.getContactAccountId();
     
     transient List<ID> cableUnitIds = new List<Id>();                         
     transient List<Integer> maxLevel = new List<Integer>{};
     transient List<cAccount> accountList {get; set;}
     transient List<cObjectStructureMap> objectStrList {get; set;}
     transient List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
     public Boolean selectedFlag {get;set;} 
     transient Contact loggedInContactDetails = new Contact();
         
   //  public List<History_Log_External_Contact_Role__c> historyContactLog {get; set;}
     transient List<Account_Contact_Role__c> acrUserEntries = new List<Account_Contact_Role__c>();
     
     private static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
     private static String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
     public string objectStrListJson {get;set;}
     public static String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ? 
                                             ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c: null;
   
     transient Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
            
     public ID getFetchedId(){
       return  fetchedId;       
     }
 
     public void setFetchedId(ID fetchedId){
           this.fetchedId = fetchedId;       
     } 
   public string selectNodeIds{get;set;}
   
     public CreatePortalUserController () { 
        selectNodeIds = '';
        //pageName1 = '';
        errorFlag = false;
        portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        
        System.debug('Before contact: '+contact); 
        if(service.getContactAccountId() != null){
          service.getStreetForAccount(service.getContactAccountId(), contact);
        }
        System.debug(' contact: '+contact); 
        contact.Street_P__c = null;
        selectedFlag = false;
        getObjectStructure();
        objectStrListJson = JSON.serialize(objectStrList);
     }
       
     public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('PortalUserUtil','Administration of portal users');
    
     public Contact getContact(){
        //contact.Street_P__c = null;
        return contact;
     }
     public void setContact(Contact c){
        contact = c; 
     }
    // Allow page to set the current ID
     public void setcurrentId(String cid) {
        currentId = cid;
     }
 
    /*
  private boolean chkValidation() {
          ApexPages.Message errorMsg = null;
          chkFlag = true;
          if(contact.MobilePhone == null && contact.HomePhone == null && contact.Phone == null){
                chkFlag= false;
                //SC_PhoneMandatory
                //errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Indtast telefonnummer');
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_PhoneMandatory);
                ApexPages.addMessage(errorMsg);
           }
          return chkFlag;
  }*/
         
  public List<cObjectStructureMap> getObjectStructure(){
    if(objectStrList == null){
       System.debug('-----------------------Inside getObjectStructure -------------------------');
       //asm.clear();
       asm = new List<ObjectStructureMap>{};
       if(objectStrList == null){
            objectStrList = new List<cObjectStructureMap>();
       }  
       if(currentId == null){ 
         if(service.getContactAccountId() != null){
           currentId =  service.getContactAccountId();
         }
       }
       if(currentId != null){
        System.assertNotEquals(currentId,null,Label.SC_SObjectIDMandatory);
       }
       if(currentId != null){
          asm = formatObjectStructure(currentId);
       }
       System.Debug('asm---->' + asm);          
       if(asm != null){
        for(ObjectStructureMap objectStructure : asm){ 
         objectStrList.add(new cObjectStructureMap(objectStructure)); 
        }
       }
    }
     return objectStrList;
   }
    
    public ObjectStructureMap[] formatObjectStructure(String currentId){
      try { 
            List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
           // masm.clear();
           masm = new Map<String, ObjectStructureMap>{};
            List<Account> al = new List<Account>{};
            accTreeStructure =  new AccountTreeStructure(); 
            Map<ID, String> nodeList = new Map<ID, String>{};
            List<ID> currentParent = new List<ID>{};
            List<String> nodeSortList = new List<String>{};
            List<Boolean> levelFlag = new List<Boolean>{};
            List<Boolean> closeFlag = new List<Boolean>{};
            
            String nodeId = '0';
            String nodeType = 'child';
            
            Integer count = 0;
            Integer level = 0;
            maxLevel = new List<Integer>{};        
            Boolean endOfStructure = false;
            // Find highest level obejct in the structure
            currentParent.add(currentId);
            System.debug('$currentParent$'+currentParent);
            // Loop though all children 
                    while (!endOfStructure ){
                        if(level==0){
                            al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c,a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c,a.Cable_Unit__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
                            System.debug('$aaaaaaaaa$'+al); 
                        }else {
                            al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c,a.Cable_Unit__r.Building_Type__c,a.Cable_Unit__r.Name,a.Customer_Segment_Lookup__c,a.Cable_Unit__r.Housing_Ownership__c,a.Cable_Unit__r.Housing_Type__c,a.Cable_Unit__r.Municipaly__c,a.Cable_Unit__r.Cable_Unit_Post_Code__c,a.Cable_Unit__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
                            System.debug('$a!!!!!!1$'+al);
                        }
                        if(al.size() == 0){
                            endOfStructure = true;
                        }else {
                            currentParent.clear();
                            for (Integer i = 0 ; i < al.size(); i++){
                                Account a = al[i];
                                if(al[i].Anlaeg_Name__c != null && al[i].Anlaeg_Name__c != ''){
                                    a.Anlaeg_Name__c = ' '+al[i].Anlaeg_Name__c;
                                } else {
                                    a.Anlaeg_Name__c = ' ';
                                }
                              /*  
                                if(al[i].Anlaeg_No__c != null && al[i].Anlaeg_No__c != ''){
                                    a.Anlaeg_No__c =  ' ' + ' - '+al[i].Anlaeg_No__c+ ' ';
                                } else {
                                    a.Anlaeg_No__c = ' ';
                                } */
                                if(al[i].Cable_Unit_No__c != null && al[i].Cable_Unit_No__c != ''){
                                     a.Anlaeg_No__c = ' -  '+al[i].Cable_Unit_No__c+ ' ';
                                 } else {
                                     a.Anlaeg_No__c = ' ';
                                 }
                                if (level > 0){
                                    nodeId=NodeList.get(a.ParentId)+'.'+String.valueOf(i);
                                }
                                else {
                                    nodeId=String.valueOf(i);
                                }   
                                masm.put( NodeID, new ObjectStructureMap(nodeID,levelFlag,closeFlag,nodeType,false,false,a,false));
                                currentParent.add(a.id);
                                nodeList.put(a.id,nodeId);
                                nodeSortList.add(nodeId);
                            }
                            maxLevel.add(level);   
                            //Integer flag=0;              
                            level++;
                            //flag++;
                           /* if (flag==2){
                                break;
                            }*/
                        }
                        
                    }
                    
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
                            }
                            else {
                                tasm.nodeType='parent';
                            } 
                        }
                        else if (cnl.size() > nnl.size()){
                            tasm.nodeType='child_end';
                            tasm.closeFlag=accTreeStructure.setcloseFlag(cnl, nnl, tasm.nodeType);
                        }
                        else {
                            tasm.nodeType='child';
                        }
                        tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType); 
                        //
                        // Change below
                        //
                        if (tasm.account.id == currentId) {
                            tasm.currentNode=true;
                        }
                        //
                        asm.add(tasm);
                    }
                    asm[0].nodeType='start';
                   // Below line commented as the last node of subhierarchy was not getting selected
                   // on selecting the whole hierarhcy
                  //  asm[asm.size()-1].nodeType='end';
                    
                    system.debug('ASM-----------formatobjcectStructure------------------------>'+asm);
                    
                    return asm;
                } catch (Exception e){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                    ApexPages.addMessage(errorMsg);
                    exceptionHandler.handleException(e,'formatObjectStructure()',false,false,null,'Medium');
                    return null;
                }    
            }
    
      // Determin parent elements relationship to current element
     
      public List<Boolean> setlevelFlag(List<String> nodeElements, String nodeType){
           try {
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
                    }
                    else {
                        flagList.add(false);
                    }
                }
              return flagList;
                    
             }catch(Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                exceptionHandler.handleException(e,'setlevelFlag()',false,false,null,'Medium');
                return null;
             }     
            }
    
      // Determin if Element is the bottom node
     
       public Boolean isLastNode(List<String> nodeElements){
            String searchNode = '';
            Integer cn = 0;
            for(Integer i = 0; i < nodeElements.size();i++){
                if (i == nodeElements.size()-1){
                    cn = Integer.valueOf(nodeElements[i]);
                    cn++;
                    searchNode=searchNode + String.valueOf(cn);
                }
                else {
                    searchNode=searchNode + nodeElements[i] + '.';
                }
            }
            if (masm.containsKey(searchNode)){
                return false;
            }
            else{
                return true;
            }
       }
 
        public List<cAccount> getAccounts(){
        //  setAccID(service.getAccountId());
            if(accountList == null){
                accountList = new List<cAccount>();
                List<ID> cableUnitIds = service.getAllRelatedCableUnits();
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
    ApexPages.Message errorMsg = null;
    pageName = '';
    errorFlag = false;
    warningFlag = false;
    boolean contactExists, userExists;
    List<User> userList = new List<User>(); 
    List<Account> accountList =new List<Account>();
    List<Contact> contactEmail = new  List<Contact>();
    try{
    System.debug('inside save method'+Limits.getScriptStatements());
    List<Account> accountListCreatedTest = new List<Account>();
    System.debug('Values from browser:' + selectNodeIds);
    getObjectStructure(); 
    System.debug('Object Size: ' +objectStrList.size());
    String[] dynStrArr = selectNodeIds.split(','); 
    Set<String> SelectIdSet = new Set<String>(); 
    SelectIdSet.addAll(dynStrArr);
   // cObjectStructureMap cObjectstrctList = null;  
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
    if(objectStrList.size() > 0){
        for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
            Account account = objectStrList[chkBoxCount].pos.account;
            if(objectStrList[chkBoxCount].selected){
                //accountListCreatedTest.add(accountTest);
                accountList.add(account);
                selectedFlag = true;
            }
        }
        System.debug('accountList--'+accountList);
        System.debug('accountList size--'+accountList.size());
        System.debug('outer***');
       } 
       
       System.debug('Total Number of ScriptStatements used in this apex code context: ' +  Limits.getScriptStatements());
  /*     for(cObjectStructureMap objectStructureMap : getObjectStructure()){
        Account account = objectStructureMap.pos.account;
        if(objectStructureMap.selected){
         accountList.add(account);
         selectedFlag = true;
        }
       }
       System.debug('Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getLimitQueries());
       */
      //Fetching the logged in contact details - as per SC-107 
      loggedInContactDetails = service.getLoggedInUserContactDetails();
        
      if(!selectedFlag){
        ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_OneRoles_Mandatory);
        ApexPages.addMessage(errorMsg1);
        warningFlag = true;
        return null;
      }
      if(contact.email != null){ 
        System.debug('---Contact Email---->'+contact.email);
        contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: contact.Email.trim() AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
        system.debug('contactEmail value is --------------'+contactEmail);
      }
      if(contactEmail.size() > 0){  
        if(contact.email != null){
         userList = [Select u.email,u.Id,u.IsPortalEnabled,u.isactive, u.ContactId ,u.Contact.Email,u.contact.accountid,u.Contact.Account.Name,u.Contact.HierarchyAccount__c From User u where u.email =: contact.email.trim() and u.contact.email =: contact.email.trim() and u.contact.RecordTypeId =: contactConstClass.ContactRecordType];
          System.debug('*****userList value is ---------:' +userList);
         System.debug('*****userList size:' +userList.size());
        }
          
        if(userList.size() == 0 ){//Portal user does not exists
          String fetchedAccountName; 
          if(contactEmail[0].AccountId != null){ 
             fetchedAccountName = contactEmail[0].Account.Name;
             System.debug('@@FetchedAccountName'+fetchedAccountName);
          }
          if(contactEmail[0].Email != null ){
          // if(contactEmail[0].Status__c == 'Aktiv'){
             System.debug('Inside If1'); 
             boolean acrExists = false;
             for(Account_Contact_Role__c acrlist : [select Id from Account_Contact_Role__c a where a.contact__c =: contactEmail[0].Id]) {
                acrExists = true;
                break;
             }  
            if(contactEmail[0].HierarchyAccount__c != null && contactEmail[0].HierarchyAccount__c == loggedInContactDetails.HierarchyAccount__c && contactEmail[0].Status__c == 'Aktiv'){
              //If contact is already present with that email id sc-p5 scenario
              System.debug('Inside If2');
//            if(contactEmail[0].HierarchyAccount__c != null && contactEmail[0].HierarchyAccount__c == loggedInContactDetails.HierarchyAccount__c){ 
                if(contact.FirstName != null){
                 contactEmail[0].FirstName = contact.FirstName;
                }
                if(contact.LastName != null){
                 contactEmail[0].LastName = contact.LastName;
                }
                if(contact.Email != null){
                 //contactEmail[0].Email = contact.Email;
                 contactEmail[0].Email = contact.Email.trim();
                }
                if(contact.Phone != null){
                 contactEmail[0].Phone = contact.Phone;
                }
                if(contact.MobilePhone != null){
                 contactEmail[0].MobilePhone = contact.MobilePhone;
                }
                if(contact.HomePhone != null){
                 contactEmail[0].HomePhone = contact.HomePhone;
                }
                if(contact.Street_P__c != null){
                 contactEmail[0].Street_P__c = contact.Street_P__c;
                }
                //Commented
                //Profile profile = [Select Id, name from profile where name = : ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c];
                contactEmail[0].UserProfile__c = portalUserProfile;
                //contactEmail[0].UserProfile__c = profile.Name;
                contact = contactEmail[0];
                contactExists= true;
                userExists = false;
                if(!PortalUserService.isMandatoryInfoMissingOnCU(accountList)){
                   service.createPortalUser(accountList, contact,contactExists,userExists);
                }else{
                   System.debug('@Inside @');   
                   errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                   ApexPages.addMessage(errorMsg);
                   errorFlag = true;
                   return null;
                } 
/*            }//end of contactEmail[0].HierarchyAccount__c != null chk
            else{
             errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
             ApexPages.addMessage(errorMsg);
             warningFlag = true;  //cfxf
             return null;
            }*/
         }else{
           System.debug('------------------- SC-P7 scenario----------------------------');
           //Checking whether it is free flying contact in SF and change the absolute path 
           //String newPageUrl = '/apex/ManagePortalUsersPage';
           //PageReference newPage = new PageReference(newPageUrl);
           
           PageReference newPage = Page.ManagePortalUsersPage;
           List<Id> freeFlyContDiffHier = new List<Id>();
           for(Contact fetchedContact : contactEmail){
              if(fetchedContact.HierarchyAccount__c != null){
                System.debug('--fetchedContact.HierarchyAccount__c ---'+fetchedContact.HierarchyAccount__c +'---cmpare------loggedInContactDetails.HierarchyAccount__c--'+loggedInContactDetails.HierarchyAccount__c);
                if(fetchedContact.HierarchyAccount__c != loggedInContactDetails.HierarchyAccount__c){
                    System.debug('----Free flying contact if the Hierarchy Account present in another hierarchy--------');
                    freeFlyContDiffHier.add(fetchedContact.HierarchyAccount__c);
                }
               }
           }
           if(freeFlyContDiffHier.size() > 0){
             System.debug('-----------Scenario SC_P7 - Free flying contact Hiearrchy Account is different/Present in another hierarchy ---------------');
             errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
             ApexPages.addMessage(errorMsg);
             warningFlag = true;  //cfxf
             return null;
                
           }else{
             System.debug('----------Scenario SC_P7 - Free flying contact Hiearachy Account is same/No Hiearrchy Account Present---------------'+freeFlyContDiffHier);
             //Change to absolute path
             //newPageUrl = '/apex/EditPortalUserPage';
             //newPage = new PageReference(newPageUrl);
             
             newPage = Page.EditPortalUserPage;
             if(contactEmail[0].Id != null){
               newPage.getParameters().put('contactId',contactEmail[0].Id);
             }
             newPage.getParameters().put('freeFlyingContactHierarchy','true');
             newPage.getParameters().put('fromCreateScreen','true');
             newPage.setRedirect(true);
             pageName = newPage.getURL();
             //return newpage;
             return null;    
           } 
        }
          //}
     }
     //Change to absolute path
     //String newPageUrl = '/apex/ManagePortalUsersPage';
     //PageReference newPage = new PageReference(newPageUrl);
     
     PageReference newPage = Page.ManagePortalUsersPage;
    // if(accountList.size() > 50){
        //newPage.getParameters().put('status', 'pendingcreation');
     //}else{
     newPage.getParameters().put('status', 'addedsuccessfully');
   //  }
   pageName = newPage.getURL();
    // return newPage;
    return null;
   }else{//Portal user exists
     System.debug('--------Portal user already exists---------------');
     List<String> userSpecificRoles = new List<String>();
     List<Id> userSpecificRoleIds = new List<Id>();
     Id contactId = service.getContactAccountId(); 
     if(contactId != null){
         fetchedId = contactId;
         System.debug('fetchedId--->'+fetchedId);
     }
     //Portal user exists for the same hierarchy
     System.debug('inside else part portal user exists in same hierarchy');
    
     if(contact.email != null){
        //user is present checking acr entries
        acrUserEntries =[select contact__c,customer__c,Email__c, Role__c,roleName__c,HierarchyAccount__c from Account_Contact_Role__c a 
                           where a.Contact__r.Status__c='Aktiv'  and a.Contact__r.email =: contact.email.trim()];
     }              
     if(acrUserEntries.size() > 0){// portal user is active
        for(Account_Contact_Role__c contactRoles : acrUserEntries){
            if(contactRoles.roleName__c == contactRolesBruger || contactRoles.roleName__c == contactRolesAdministrator){
             userSpecificRoles.add(contactRoles.roleName__c);
             userSpecificRoleIds.add(contactRoles.Role__c);
            }
        }
        if(contactEmail[0].HierarchyAccount__c != null && fetchedId != null && fetchedId != contactEmail[0].HierarchyAccount__c){
             System.debug('---active/inactive user with contact roles exists IN ANOTHER HIERARCHY---------');
             errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
             ApexPages.addMessage(errorMsg);
             warningFlag = true;  
             return null;
        }else{
            if(userList[0].isactive == true && userSpecificRoles.size() > 0){
                //Portal user exists and also belongs to same customer hierarchy
                   //SC-P2 - AS per SC-107 And SC-69 - chked
                System.debug('------SC-P2 SCENARIO Portal user exists in active state ---------');  
                // Change to absolute path                                                                        
                //String newPageUrl = '/apex/EditPortalUserPage';
                //PageReference newPage = new PageReference(newPageUrl);
                
                PageReference newPage = Page.EditPortalUserPage;
                newPage.getParameters().put('enteredEmailUnique','false');
                newPage.getParameters().put('contactId',userList[0].ContactId);
                newPage.getParameters().put('isActiveExistHierarchy','true');
                newPage.getParameters().put('fromCreateScreen','true');
                newPage.setRedirect(true);
                pageName = newPage.getURL();
                //return newPage;
                return null;
            }else{
                //SC_P3 Scenario if user present is in inactive state - nov specs and change to absolute path
                //String newPageUrl = '/apex/ManagePortalUsersPage';
                //PageReference newPage = new PageReference(newPageUrl);
                
                PageReference newPage = Page.ManagePortalUsersPage;
                System.debug('-----contactList[0] INACTIVE USER------'+contactEmail[0]);     
                contactEmail[0].FirstName = contact.FirstName;
                contactEmail[0].LastName =contact.LastName;
                contactEmail[0].Email =contact.Email.trim();
                contactEmail[0].Phone = contact.Phone;
                contactEmail[0].MobilePhone = contact.MobilePhone;
                contactEmail[0].HomePhone = contact.HomePhone;
                contactEmail[0].Street_P__c = contact.Street_P__c;
                contact = contactEmail[0];
                contactExists = true;
                userExists = true;
                System.debug('user is in inactive state-----contactEmail[0]-----'+contactEmail[0]);
                if(!PortalUserService.isMandatoryInfoMissingOnCU(accountList)){
                   service.createPortalUser(accountList,contact,contactExists,userExists);
                }else{
                   errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                   ApexPages.addMessage(errorMsg);
                   errorFlag = true;
                   return null;
                }
                newPage.getParameters().put('status','reactivateSuccessfully');
                newPage.getParameters().put('inactiveContactId',contactEmail[0].Id);
                System.debug('** contactList[0].id  **'+contactEmail[0].Id);
                pageName = newPage.getURL();
                //return newPage;
                return null;  
             }
        }
     }else{//portal user is inactive / contact is inactive 
         //SC_P6
        System.debug('Portal user/contact exists in inactive state or as free flying ');
        // Change to absolute path
        //String newPageUrl = '/apex/ManagePortalUsersPage';
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.ManagePortalUsersPage;
         //SC_P6 Scenario for free flying contact AND INACTIVE USER
        System.debug('-------------SC_P7- FIRST CNDTN-----userExistsFreeFlying----------'+contactEmail[0].Id);
        if(contactEmail[0].HierarchyAccount__c != null && fetchedId != null && fetchedId != contactEmail[0].HierarchyAccount__c){
            System.debug('-------------SC_P7-first if -----userExistsFreeFlying- IN ANOTHER HIERARCHY---------');
            errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
            ApexPages.addMessage(errorMsg);
            warningFlag = true;  
            return null;
        }else{
            System.debug('---HISTORY LOG REMOVED AND SC_P7--userExistsFreeFlying-else part---opening in edit mode');
            //Change to absolute path
            //newPageUrl = '/apex/EditPortalUserPage';
            //newPage = new PageReference(newPageUrl);
            
            newPage = Page.EditPortalUserPage;
            if(contactEmail[0].Id != null){
               newPage.getParameters().put('contactId',contactEmail[0].Id);
            }
            newPage.getParameters().put('userExistsFreeFlying','true');
            newPage.getParameters().put('fromCreateScreen','true');
            newPage.setRedirect(true);
            pageName = newPage.getURL();
            return null;
            //return newPage;
         }                                                          
        System.debug('-----end of scp6/ scp3 scenario---------');
        newPage.setRedirect(true);
        pageName = newPage.getURL();
        return null;
        //return newPage;  
     }//End of else part-----
    }//END OF Portal user exists
     
    }else{
       //SC-P1 SCENARIO contactEmail.size() EQUAL TO 0 and change to absolute path
        //String newPageUrl = '/apex/ManagePortalUsersPage';
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.ManagePortalUsersPage;
        System.debug('inside else part contact exists false'+contactEmail.size());
        contactExists = false;
        userExists = false;
        System.debug('Conatct may be not exists inside else if->'+contactExists);
         
        if (!PortalUserService.isMandatoryInfoMissingOnCU(accountList)){
            System.debug('called service-----accountList-------'+accountList+'-----size accountList-----'+accountList.size());
            service.createPortalUser(accountList, contact,contactExists,userExists);
        }else{
            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
        }
       // if(accountList.size() > 50){
        //newPage.getParameters().put('status', 'pendingcreation');
        // }else{
        newPage.getParameters().put('status', 'addedsuccessfully');
        pageName = newPage.getURL();
        System.debug('##############Manage Portal'+pageName+'$URL$'+newPage.getURL());
        
        return null;
     //scenario scp1
    }
     System.debug('########Redirect ######');
     String newPageUrl; 
     PageReference newPage1 = Page.CreatePortalUserPage;
     pageName = newPage1.getURL();
     return null;
     //return newPage1;
     /*
     if(Site.getPrefix() != null && Site.getPrefix() != ''){
        System.debug('#Inside if#');
        newPageUrl = Site.getPrefix() + '/apex/CreatePortalUserPage';
        PageReference newPage1 = new PageReference(newPageUrl);
        return newPage1;
     }else{
        System.debug('#Inside ilese#');
        PageReference newPage1 = Page.CreatePortalUserPage;
        //String newPageUrl = '/apex/CreatePortalUserPage';
        return newPage1;
     }*/     
   }catch(Exception e){
    if(e.getDmlType(0) == StatusCode.DUPLICATE_USERNAME){ 
      errorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.SC_P4); 
      ApexPages.addMessage(errorMsg); 
      errorFlag = true;
      exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
      return null;
    }else{ 
      System.debug('createPortal user controller---exception----');
      errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
      ApexPages.addMessage(errorMsg);
      errorFlag = true;
      exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
      return null;
    }
   }
  }
        
  public PageReference cancelCreate() {
    // Change to absolute path
    //String newPageUrl = '/apex/ManagePortalUsersPage';
    //PageReference newPage = new PageReference(newPageUrl);
    PageReference newPage = Page.ManagePortalUsersPage;
    newPage.setRedirect(true);
    return Page.ManagePortalUsersPage;
  }
        
  // Added for Address Section
  public PageReference fetchAddressDetails(){
    System.debug('Inside fetchAddressDetails');
    String addressId = contact.Street_P__c;
    System.debug('*****addressId: '+ addressId);
    List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
    if(addressList.size() > 0){
      address = addressList.get(0); 
      System.debug('First Fetch AddressList'+addressList);        
      }
    System.Debug('Adress Street: '+address.Street__c + 'town: '+address.Town__c);
    displayAddressInfo = true;  
    System.debug('Status'+displayAddressInfo);  
    return null;
  }
 }