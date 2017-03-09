public class AccountAssignmentContactController {
/*        
        public Boolean strFlag;
        public boolean statusAssignment{ get; set; }
        public User user = null;
        public User getUser(){return user;}
        public void setUser(User u){this.user = u;}
        public boolean chkFlag = true;
        public String checkInActive{get; set;}
        public ID accountId;
        public ID getAccountId() {return accountId;}
        public void setAccountId(ID accountId) {accountId = accountId;} 
        public Contact contact;
        public PortalUserUtil portalUserUtil = new PortalUserUtil();
        public PortalUserMailService mailService = new PortalUserMailService();
        public PortalUserService service = new PortalUserService();
        public string contactProfile{get;set;}
        public Contact getContact(){return contact;}
        public void setContact(Contact c){this.contact = c;}     
        public String currentId;
        public List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        public Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
        public List<Integer> maxLevel = new List<Integer>{};
        public List<cObjectStructureMap> objectStrList {get; set;}
        public void setcurrentId(String cid) {currentId = cid;}
        public List<cAccount> accountList {get; set;}
        public String portalAdminUser{get; set;}
        public String portalUserProfile{get; set;}
        public List<User> userList {get; set;}
        public ID contactId {get; set;}
        public Boolean errorChk { get;set; }
        public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('AccountAssignmentContactController','Administration of portal users through Contact Page');
        public ID orgId { get; set; }
        public ID portalId { get; set; }
        public ID contactUserId {get; set;}
        public boolean enableCustomerLoginButton {get;set;}
        public boolean userExist {get;set;}
        public boolean userIsActive {get;set;}
        public String hierarchyDetail {get;set;}
        public Boolean tempFlag = false;
        public Boolean displayuserSection{get;set;}
        public Boolean displayErrorSection{get;set;}
        public Boolean displaynoUserSection{get;set;}
        public String objectStrListJson{get;set;}
         
        public List<Account> accntStrList = new List<Account>{}; 
        public List<User> userId; 
        public Boolean disableFlag{get;set;}
         
        // Change for SC-471
        public Set<Id> usersWithPermissionSet = new Set<Id>();
      // public List<PermissionSetAssignment> perSetAssign1 = new List<PermissionSetAssignment>(); 
        public Boolean displayPageComponent{get;set;}
        public String youseeSysAdminProfile {get;set;}
        public Set<String> SelectIdSet = new Set<String>(); 
        public String selectNodeIds {get;set;}    */
        transient Boolean strFlag;
        public boolean statusAssignment{ get; set; }
        private User user = null;
        private User getUser(){return user;}
        public void setUser(User u){this.user = u;}
        transient boolean chkFlag = true;
        public String checkInActive{get; set;}
        transient ID accountId;
        public ID getAccountId() {return accountId;}
        private void setAccountId(ID accountId) {accountId = accountId;} 
        public Contact contact;
        transient PortalUserUtil portalUserUtil = new PortalUserUtil();
        transient PortalUserMailService mailService = new PortalUserMailService();
        transient PortalUserService service = new PortalUserService();
        transient string contactProfile{get;set;}
        public Contact getContact(){return contact;}
        public void setContact(Contact c){this.contact = c;}     
        transient String currentId;
        transient List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        transient Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
        transient List<Integer> maxLevel = new List<Integer>{};
        transient List<cObjectStructureMap> objectStrList {get; set;}
        public void setcurrentId(String cid) {currentId = cid;}
        transient List<cAccount> accountList {get; set;}
        transient String portalAdminUser{get; set;} 
        transient String portalUserProfile{get; set;}
        transient List<User> userList {get; set;}
        public ID contactId {get; set;}
        transient Boolean errorChk { get;set; }
        transient CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('AccountAssignmentContactController','Administration of portal users through Contact Page');
        public ID orgId { get; set; }
        public ID portalId { get; set; }
        //public Boolean acrPortal{get; set;}
        //public Boolean acrCountFlag{get; set;}
        //transient ID contactUserId {get; set;}
        public ID getContactUserId(){
          if (user != null){
               return user.Id;
          }else return null ;
               
        }
        public boolean enableCustomerLoginButton {get;set;}
        public boolean userExist {get;set;}
        public boolean userIsActive {get;set;}
        transient String hierarchyDetail {get;set;}
        public Boolean tempFlag = false;
        public Boolean displayuserSection{get;set;}
        public Boolean displayErrorSection{get;set;}
        public Boolean displaynoUserSection{get;set;}
        public String objectStrListJson{get;set;}
         
        transient List<Account> accntStrList = new List<Account>{}; 
        transient List<User> userId; 
        public Boolean disableFlag{get;set;}
         
        // Change for SC-471
        transient Set<Id> usersWithPermissionSet = new Set<Id>();
      // transient List<PermissionSetAssignment> perSetAssign1 = new List<PermissionSetAssignment>(); 
        public Boolean displayPageComponent{get;set;}
        transient String youseeSysAdminProfile {get;set;}
        transient Set<String> SelectIdSet = new Set<String>(); 
        //public String selectNodeIds {get;set;}
        private string selectNodeIds;
        public void setSelectNodeIds(String str){
          selectNodeIds = str;
        }  
        public String getSelectNodeIds(){
          return selectNodeIds;
        }
        public AccountAssignmentContactController (ApexPages.StandardController stdController){
               selectNodeIds =''; 
               statusAssignment = false;
               tempFlag = false;
               //acrPortal = true;
               //acrCountFlag = true;
               List<Contact> conList1 = new List<Contact>();
               contact = (Contact)stdController.getRecord();
          //     contactId = ApexPages.CurrentPage().getParameters().get('contactId');
               contactId = contact.Id;
               disableFlag = false;
               redirectPage();
               checkInActive = ApexPages.CurrentPage().getParameters().get('isActiveExistHierarchy');
               strFlag=false;
               errorChk=false;
               userExist = false;
               userIsActive = false;
               Contact con = new Contact();
               portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
               portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
               conList1 = [Select id, Enable_Customer_Portal_User__c, UserProfile__c, accountId, name, firstname, lastname, email, HierarchyAccount__c, MobilePhone, HomePhone, Phone, Street_P__r.Name, Street_P__r.Street__c, Status__c, KissPartyId__c From Contact  where id = :contact.Id];
               if(conList1 != null && conList1.size() > 0){
               		con = conList1[0];
               }
               
               
               //Contact con = [Select id, Enable_Customer_Portal_User__c, UserProfile__c, accountId, name, firstname, lastname, email, HierarchyAccount__c, MobilePhone, HomePhone, Phone, Street_P__r.Name, Street_P__r.Street__c, Status__c, KissPartyId__c From Contact  where id = :contact.Id LIMIT 1];


        /*       if(con.HierarchyAccount__c != null){
                   userList =[Select id, ProfileID, Profile.Name, IsActive, firstname, lastname from user where contactid =: contactId];
                   if(userList.size() > 0){
                        setUser(userList[0]);
                        con.UserProfile__c = userList[0].Profile.Name;
                        con.Enable_Customer_Portal_User__c = userList[0].IsActive;                   
                   }    
                   setcurrentId(con.HierarchyAccount__c);                    
                   setContact(con);
                   setAccountId(con.HierarchyAccount__c);
               }   
               */
                userList =[Select id, ProfileID, Profile.Name, IsActive, firstname, lastname from user where contactid =: contact.Id]; //changed
                 if(userList.size() > 0){
                        setUser(userList[0]);
                        con.UserProfile__c = userList[0].Profile.Name;
                        con.Enable_Customer_Portal_User__c = userList[0].IsActive;  
 //                       contactUserId = userList[0].Id; 
                        enableCustomerLoginButton = userList[0].IsActive;
                        userExist = true;
                        userIsActive = userList[0].IsActive;                 
                   } 
                /* changes for spoc-1539
                List<Account_Contact_Role__c> acrlist = [Select a.Customer__c From Account_Contact_Role__c a where a.Contact__c =:contactId and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
                if(acrlist.isEmpty() && userIsActive == true){
                	con.Enable_Customer_Portal_User__c = false;
                	acrPortal = false;
                }*/
                   setContact(con); 
                   system.debug('...........con.............'+con + 'Contact street name: ' + con.Street_P__r.Name);
                if(con.HierarchyAccount__c != null){
                    setcurrentId(con.HierarchyAccount__c);
                                
                   hierarchyDetail = con.HierarchyAccount__c;
                   System.debug('Hierarchy id'+hierarchyDetail);
                   setAccountId(con.HierarchyAccount__c);
               } 
               
              orgId = UserInfo.getOrganizationId();
           //   portalId = '060M00000000Q7r';Customer Portal Id
              portalId = ServiceCenter_CustomSettings__c.getInstance('Customer Portal Id').Value__c;
              String status = apexpages.currentpage().getparameters().get(contactConstClass.STATUS);
              System.debug('status---'+status);
              if(status != null && status == 'pendingcreation'){     
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_PendingCreation);
                ApexPages.addMessage(myMsg); 
              }
              // Code below add for SC-471
              displayPageComponent = false;
              youseeSysAdminProfile = ServiceCenter_CustomSettings__c.getInstance('YouSee System Administrator').Value__c;
              for(PermissionSetAssignment p : [Select p.SystemModstamp, p.PermissionSetId, p.Id, p.AssigneeId From PermissionSetAssignment p where p.PermissionSetId IN (Select p.Id From PermissionSet p where p.Name='Manage_O_customer_portal_users')])
              {
                    usersWithPermissionSet.add(p.AssigneeId);
                    System.debug('AssigneeId***'+p.AssigneeId);
              }
              System.debug('UserId***'+UserInfo.getProfileId());
              Profile[] profiles = [Select p.name, p.id From Profile p where p.Name =: youseeSysAdminProfile]; 
              if(usersWithPermissionSet.contains(UserInfo.getUserId()) || UserInfo.getProfileId()==profiles[0].Id){
                displayPageComponent = true;
              } 
              System.debug('DisplayPage%%%%%'+displayPageComponent); 
              getObjectStructure();
              objectStrListJson = JSON.serialize(objectStrList);
              system.debug('objectStrListJson: '+objectStrListJson);
              
        }
     
        //Wrapper class
     /*   public class ObjectStructureMap {
               public String nodeId;
               public Boolean[] levelFlag = new Boolean[]{};
               public Boolean[] closeFlag = new Boolean[]{};
               public String nodeType;
               public Boolean currentNode;
               public Account account;
               public String getnodeId() { return nodeId; }
               public Boolean[] getlevelFlag() { return levelFlag; }
               public Boolean[] getcloseFlag() { return closeFlag; }
               public String getnodeType() { return nodeType; }
               public Boolean getcurrentNode() { return currentNode; }
               public Account getaccount() { return account; }
               public void setnodeId( String n ) { this.nodeId = n; }
               public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
               public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
               public void setnodeType( String nt ) { this.nodeType = nt; }
               public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }
               public void setaccount( Account a ) { this.account = a; }
    
               public ObjectStructureMap(String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a){
                  this.nodeId = nodeId;
                  this.levelFlag = levelFlag; 
                  this.closeFlag = closeFlag;
                  this.nodeType = nodeType;
                  this.currentNode = currentNode;
                  this.account = a;
               }
               
               public ObjectStructureMap(){
                
               }
        }
            
        public class cObjectStructureMap{
            public ObjectStructureMap pos {get; set;} 
            public Boolean selected {get; set;}
            public Boolean prevselected {get; set;}
            public cObjectStructureMap(ObjectStructureMap a){
                pos = a;
                selected = false;
                prevselected = false;
            }
        }
        public class cAccount{
            public Account acc {get; set;}
            public Boolean selected {get; set;}
           /*This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false */
         /*   public cAccount(Account a){
                  acc = a;
                  selected = false;
            }
        } */       
        
        public List<cObjectStructureMap> getObjectStructure(){
        	List<Contact> conList2 = new List<Contact>();
        	Contact con = new Contact();
        	conList2 = [Select id, accountId, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__c, Street_P__r.Name,Street_P__r.Street__c From Contact  where id = :contactId ];
            if(conList2 != null && conList2.size() > 0){
            	con = conList2[0];
            }
            //Contact con = [Select id, accountId, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__c, Street_P__r.Name,Street_P__r.Street__c From Contact  where id = :contactId LIMIT 1]; //changed
            System.debug('Inside OBject structure' + con);
            portalUserUtil = new PortalUserUtil();
            Map<ID, ID> params = portalUserUtil.getAssignedCableUnits(con.Id);
            System.debug('Inside OBject structure after' + con.id);
            if(objectStrList == null){
                   // asm.clear();
                    if(objectStrList == null){
                        objectStrList = new List<cObjectStructureMap>();
                    }  
                    asm = formatObjectStructure(contact.HierarchyAccount__c);
                    for(ObjectStructureMap objectStructure : asm) {
                          cObjectStructureMap objmap = new cObjectStructureMap(objectStructure);
                          if (params.containsKey(objmap.pos.account.id)){
                              objmap.selected = true;
                              objmap.prevselected = true;
                          }      
                          objectStrList.add(objmap); 
                    }
            } 
            /*if(params.isEmpty()){
            	acrCountFlag = false;
            	displayPageComponent = false;
            	contact.Enable_Customer_Portal_User__c = false;
            	System.debug('@@@Inside Zero map values'+params.size() + '!!!!Flag'+acrCountFlag);
            }*/          

            
            return objectStrList;
        }
    
       // Query Account from top down to build the ObjectStructureMap //
       public ObjectStructureMap[] formatObjectStructure(String currentId){
            List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
            //masm.clear();
            masm = new Map<String, ObjectStructureMap>{};
            maxLevel = new List<Integer>{};
            List<Account> al = new List<Account>{};
            List<ID> currentParent = new List<ID>{};
            Map<ID, String> nodeList = new Map<ID, String>{};
            List<String> nodeSortList = new List<String>{};
            List<Boolean> levelFlag = new List<Boolean>{};
            List<Boolean> closeFlag = new List<Boolean>{};
            String nodeId = '0';
            String nodeType = 'child';
            Integer count = 0;
            Integer level = 0;
            Boolean endOfStructure = false;
            // Find highest level obejct in the structure//
            /*Commenting below line as GetTopElement is returing topmost parent acc id, if user has access to single account ,account hierarchy for the parent is generating*/
            //currentParent.add(GetTopElement(currentId));
            currentParent.add(currentId);
            System.debug('$currentParent$'+currentParent);
          //  Map<Id,Id> testMap = new Map<Id,Id>();
         //   accntStrList = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Customer_Type__c, a.Cable_Unit__r.Building_Type__c, a.Cable_Unit__r.Name, a.Customer_Segment_Lookup__c, a.Cable_Unit__r.Housing_Ownership__c, a.Cable_Unit__r.Housing_Type__c, a.Cable_Unit__r.Municipaly__c, a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit__c FROM Account a WHERE a.SuperiorAccount__c IN :CurrentParent or id IN: CurrentParent ORDER BY a.Name];
         //   System.debug('formatObjectStructure accntStrList----'+accntStrList);
          //  System.debug('formatObjectStructure accntStrList size----'+accntStrList.size());
         //   createChildNodes(testMap,currentId);
            // Loop though all children
            while (!endOfStructure ){
                    if(level==0){
                         // Change below//        
                      //   al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
                       // Changed above line to display Cable_Unit_No__c  instead on Anlaeg_No__c
                         al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Customer_Type__c, a.Cable_Unit__r.Building_Type__c, a.Cable_Unit__r.Name, a.Customer_Segment_Lookup__c, a.Cable_Unit__r.Housing_Ownership__c, a.Cable_Unit__r.Housing_Type__c, a.Cable_Unit__r.Municipaly__c, a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit__c FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
                //                 al = [SELECT  a.Name,a.Type,a.Anlaeg_Name__c,a.Cable_Unit_No__c,a.Anlaeg_No__c, a.ParentId,  a.Id, a.Customer_Type__c,a.Cable_Unit__c,a.Cable_Unit__r.Name FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
                    }
                    else {
                            // Change below
                        // al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
                         // Changed above line to display Cable_Unit_No__c  instead on Anlaeg_No__c
               //          al = [SELECT  a.Name,a.Type,a.Anlaeg_Name__c,a.Cable_Unit_No__c,a.Anlaeg_No__c, a.ParentId,  a.Id, a.Customer_Type__c,a.Cable_Unit__c,a.Cable_Unit__r.Name FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
               al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Customer_Type__c, a.Cable_Unit__r.Building_Type__c, a.Cable_Unit__r.Name, a.Customer_Segment_Lookup__c, a.Cable_Unit__r.Housing_Ownership__c, a.Cable_Unit__r.Housing_Type__c, a.Cable_Unit__r.Municipaly__c, a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit__c FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
                    }
                    if(al.size() == 0){
                        endOfStructure = true;
                    }
                    else {
                    	system.debug('al inside else part ----'+al);
                            currentParent.clear();
                            for (Integer i = 0 ; i < al.size(); i++){
                            // Change below
                                Account a = al[i];
                                 if(al[i].Anlaeg_Name__c != null && al[i].Anlaeg_Name__c != ''){
                                        a.Anlaeg_Name__c = ' '+al[i].Anlaeg_Name__c;
                                 } 
                                 else {
                                     a.Anlaeg_Name__c = ' ';
                                 }
                           /*      if(al[i].Anlaeg_No__c != null && al[i].Anlaeg_No__c != ''){
                                     a.Anlaeg_No__c = ' -  '+al[i].Anlaeg_No__c+ ' ';
                                 } else {
                                     a.Anlaeg_No__c = ' ';
                                 }    */
                                 if(al[i].Cable_Unit_No__c != null && al[i].Cable_Unit_No__c != ''){
                                     a.Anlaeg_No__c = ' -  '+al[i].Cable_Unit_No__c+ ' ';
                                 } else {
                                     a.Anlaeg_No__c = ' ';
                                 }
                                  //
                                  
                                  system.debug('a---'+a);
                                  system.debug('a.ParentId---'+a.ParentId);
                                 if (level > 0){
                                      nodeId=NodeList.get(a.ParentId)+'.'+String.valueOf(i);
                                 }else {
                                      nodeId=String.valueOf(i);
                                 }  
                                 system.debug('nodeId inside else part---'+nodeId);
                                 System.debug('formatObjectStructure levelflag----'+levelFlag);
                                 System.debug('formatObjectStructure closeFlag----'+closeFlag);
                                 System.debug('formatObjectStructure nodeType----'+nodeType); 
                                 masm.put( NodeID, new ObjectStructureMap(nodeID,levelFlag,closeFlag,nodeType,false,false,a));
                                 System.debug('formatObjectStructure masm----'+masm);
                                 currentParent.add(a.id);
                                 nodeList.put(a.id,nodeId);
                                 System.debug('formatObjectStructure nodeList----'+nodeList);
                                 nodeSortList.add(nodeId);
                                 System.debug('formatObjectStructure nodeSortList----'+nodeSortList);
                            }
                            maxLevel.add(level);                
                            level++;
                    }
            }
            
            
            // Account structure must now be formatted//
            NodeSortList.sort();
            System.debug('NodeSortList--->'+NodeSortList);
            for (Integer i = 0; i < NodeSortList.size();i++){
                   List<String> pnl = new List<String> {};
                   List<String> cnl = new List<String> {};
                   List<String> nnl = new List<String> {};
                               if (i > 0){
                                   String pn = NodeSortList[i-1];
                                   pnl = pn.split('\\.',-1);
                               }
                               String cn = NodeSortList[i];
                               System.debug('cn value--'+cn);
                               cnl = cn.split('\\.',-1);
                               System.debug(' cnl  value---'+ cnl);
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
                        tasm.closeFlag=setcloseFlag(cnl, nnl, tasm.nodeType);
                    }
                    else {
                        tasm.nodeType='child';
                    }
                    System.debug('tasm.nodeType--'+tasm.nodeType);
                    tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType); 
                    System.debug('tasm.levelFlag---'+tasm.levelFlag);
                    //Change below//
                    if (tasm.account.id == currentId) {
                        tasm.currentNode=true;
                    }
                    //
                    asm.add(tasm);
               }
               if(NodeSortList.size()> 0){
               asm[0].nodeType='start';
             //  asm[asm.size()-1].nodeType='end';
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
                    }
                    else {
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

            // Find the tom most element in Heirarchy //    
        public String GetTopElement(String objId) {
                Boolean top = false;
                while (!top) {
                    Account a = [Select a.id, a.ParentId From Account a where a.id = :objId LIMIT 1];
                    if (a.ParentID != null) {
                        objId = a.ParentID;
                    }
                    else {
                        top=true;
                    }
                }
                return objId ;
        }
    
    
        public List<ID> getAllRelatedCableUnits(){
            // Loop though all children and populate the accountsToShare list with the account ids
            //ID accountId = getAccountId();
            ID accountId = contact.HierarchyAccount__c;
            System.debug('AccountId: '+ accountId); 
            List<ID> accountsToShare = new List<ID>{};
            List<ID> currentParent = new List<ID>{};
            Integer level = 0;
            List<Account> acctList = new List<Account>{};
            Boolean endOfStructure = false;
            while (!endOfStructure ){
                if(level==0)
                    acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.id = :accountId];
                else
                    acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.ParentId IN :currentParent];
                if(acctList.size() == 0){
                    endOfStructure = true;
                }    
                else {
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
            if(accountList == null){
                accountList = new List<cAccount>();
                List<ID> cableUnitIds = getAllRelatedCableUnits();
                if(cableUnitIds != null){ 
               //     List<Account> accounts = [select Anlaeg_No__c, Name, id from Account where ID in :cableUnitIds];
               // Changed above line to display Cable_Unit_No__c  instead on Anlaeg_No__c
                    List<Account> accounts = [select Anlaeg_No__c,Cable_Unit_No__c, Name, id from Account where ID in :cableUnitIds];
                    for(Account a : accounts) {
                        accountList.add(new cAccount(a)); 
                    }
                }
            }    
            return accountList;
        }   

         public PageReference saveOne() {
               // Change According from Partial Page Reference to Absolute
               //String newPageUrl = '/apex/AccountAssignmentContactPage';
               //PageReference newPage = new PageReference(newPageUrl);
               
               PageReference newPage = Page.AccountAssignmentContactPage;
               List<AccountShare> aShare = new AccountShare[0];
               List<Account> deletedCableUnitsList = new List<Account>();
               Map<String, String> deletedCableUnitMap = new Map<String, String>();
               List<Account> accountListCreated =new List<Account>();
               List<ID> accountListDeleted =new List<ID>();
               List<ID> accountListCreatedId =new List<ID>();
            try{
                if(contact.HierarchyAccount__c != null){
                    if(contact.Enable_Customer_Portal_User__c == true){
                                if(getUser() == null){
                                        if(contact.UserProfile__c == null){
                                            ApexPages.Message errorMsg = null; 
                                            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Select_UserProfile);
                                            ApexPages.addMessage(errorMsg); 
                                            errorChk = true; 
                                            return null;                    
                                         }
                                //  if(contact.Email != null){
                                        System.debug('in create user');
                                        user = service.createPortalUser(getContact()); // create user
                                        
                                //      errorChk=false;
                                //  }
                                //  else{errorChk=true;}
                               }
                               else{    
                                       // Error Message added to stop activatio of any user withour any hierarchy account
                                    /*      ApexPages.Message errorMsgHierarchy = null; 
                                            errorMsgHierarchy = new ApexPages.Message(ApexPages.Severity.ERROR,'You need to assign an hierarchy account for giving an access rights to this user');
                                            ApexPages.addMessage(errorMsgHierarchy);    
                                            errorChk = true; 
                                            return null;    */ 
                                        // Above error message not required if we allow creation of user withour any hierarchy account.                     
                                        if(contact.UserProfile__c == null){
                                            ApexPages.Message errorMsg = null; 
                                            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Select_UserProfile);
                                            ApexPages.addMessage(errorMsg); 
                                            errorChk = true; 
                                            return null;                    
                                         }
                                          update contact;
                               
                                          updateUserActive(getUser().Id,contact.UserProfile__c);
                               }
                      } 
                      else if(getUser() != null && contact.Enable_Customer_Portal_User__c == false){
                                    contact.Enable_Customer_Portal_User__c = false;
                                    update contact;
                                    if(userList.size() > 0){
                                    //  deactivateUser(getUser().Id);
                                        PortalUserService.deleteUser(contact.Id);
                                    }
                                    statusAssignment = true;
                                    return null;
                   
                      }
                      else{
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_EnableUser_ChkBx_Select);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null;  
                        
                      } 
                }
                else{
                          ApexPages.Message errorMsg = null; 
                          errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_HierarchyAccount_Required);
                          ApexPages.addMessage(errorMsg);   
                          errorChk = true; 
                          return null;  
                }   
                statusAssignment = true;
                if(tempFlag == true){
                    integer j;
                    j = 10/0;
                }
              return newPage;
            

            }
            catch(Exception e){
                System.Debug('In Exception'+e);
                ApexPages.addMessages(e);
                return null;
            }
        }  
        
         public PageReference save() {
               System.debug('inside save method');
                // Change According from Partial Page Reference to Absolute
               //String newPageUrl = '/apex/AccountAssignmentContactPage';
               //PageReference newPage = new PageReference(newPageUrl);
               System.debug('Selected Nodes in save:' + selectNodeIds);
               getObjectStructure(); 
               service = new PortalUserService();
            //   String dynaStr = '0012000000W5BtFAAV,0012000000W5BtUAAV,0012000000W5CPYAA3,0012000000W5CPZAA3,0012000000W5CxkAAF,0012000000W5Da1AAF,0012000000W5Da2AAF,0012000000W5DlmAAF,0012000000W5EijAAF,0012000000W5EilAAF,0012000000W5ErNAAV,0012000000W5EruAAF,0012000000W5EuZAAV,0012000000W5EzYAAV,0012000000W5FNnAAN,0012000000W5FNoAAN,0012000000W5UNsAAN,0012000000W5nHxAAJ,0012000000W5nIOAAZ,0012000000W5nIZAAZ,0012000000W5nZMAAZ,0012000000W5nZNAAZ,0012000000W5rNSAAZ,0012000000W5rNXAAZ,0012000000W5rNZAAZ,0012000000W5rf0AAB,0012000000W5s0YAAR,0012000000W5s0cAAB,0012000000W5s0eAAB,0012000000W5sAzAAJ,0012000000W5sB1AAJ,0012000000W59VZAAZ,0012000000W5AB1AAN,0012000000W5ABCAA3,0012000000W5AVUAA3,0012000000W5AVdAAN,0012000000W5B90AAF,0012000000W5BI4AAN,0012000000W5BaBAAV,0012000000W5BkNAAV,0012000000W5BkOAAV,0012000000W5BkRAAV,0012000000W5BkZAAV,0012000000W5C4QAAV,0012000000W5CFMAA3,0012000000W5EYfAAN,0012000000W5EipAAF,0012000000W5EunAAF,0012000000W5FCdAAN,0012000000W5Ii0AAF,0012000000W5UODAA3,0012000000W5UOKAA3,0012000000W5nZOAAZ,0012000000W5nZSAAZ,0012000000W5rFOAAZ,0012000000W5s25AAB,0012000000W5s26AAB,0012000000W5s27AAB,0012000000W5s28AAB,0012000000W5s29AAB,0012000000W5sBXAAZ,0012000000W5sBYAAZ,0012000000W5sBaAAJ,0012000000W5sBbAAJ,0012000000W5sBdAAJ,0012000000W5sQIAAZ,0012000000W5sVWAAZ,0012000000W59IOAAZ,0012000000W59IVAAZ,0012000000W59YPAAZ,0012000000W5A21AAF,0012000000W5AN0AAN,0012000000W5AN5AAN,0012000000W5AN9AAN,0012000000W5AVmAAN,0012000000W5AW2AAN,0012000000W5AW3AAN,0012000000W5AW5AAN,0012000000W5AiLAAV,0012000000W5ArLAAV,0012000000W5ArZAAV,0012000000W5ArhAAF,0012000000W5BaiAAF,0012000000W5Bb8AAF,0012000000W5CFdAAN,0012000000W5CRWAA3,0012000000W5CnGAAV,0012000000W5CnaAAF,0012000000W5CnfAAF,0012000000W5E85AAF,0012000000W5F0RAAV,0012000000W5IiBAAV,0012000000W5IiEAAV,0012000000W5IiNAAV,0012000000W5OJRAA3,0012000000W5UOUAA3,0012000000W5UOWAA3,0012000000W5UOXAA3,0012000000W5UOYAA3,0012000000W5hkEAAR,0012000000W5hkGAAR,0012000000W5naDAAR,0012000000W5naEAAR,0012000000W5rFlAAJ,0012000000W5s2GAAR,0012000000W5s2OAAR,0012000000W5sBiAAJ,0012000000W5sBjAAJ,0012000000W59IjAAJ,0012000000W5ACoAAN,0012000000W5ANGAA3,0012000000W5ANKAA3,0012000000W5ANPAA3,0012000000W5ANRAA3,0012000000W5AWAAA3,0012000000W5AWEAA3,0012000000W5AWFAA3,0012000000W5AWIAA3,0012000000W5AWKAA3,0012000000W5AjVAAV,0012000000W5AjeAAF,0012000000W5B0HAAV,0012000000W5B9sAAF,0012000000W5BSdAAN,0012000000W5BbgAAF,0012000000W5BlFAAV,0012000000W5Bv6AAF,0012000000W5C51AAF,0012000000W5C54AAF,0012000000W5CeTAAV,0012000000W5DOAAA3,0012000000W5DOMAA3,0012000000W5DbsAAF,0012000000W5DoKAAV,0012000000W5E87AAF,0012000000W5E88AAF,0012000000W5OJtAAN,0012000000W5hkLAAR,0012000000W5hkOAAR,0012000000W5nWmAAJ,0012000000W5naIAAR,0012000000W5rGYAAZ,0012000000W5rt9AAB,0012000000W5sCBAAZ,0012000000W5sCDAAZ,0012000000W5sCEAAZ,0012000000W5sCIAAZ,0012000000W5sCMAAZ,0012000000W6NAdAAN,0012000000W6QXNAA3,0012000000W5sc0AAB,0012000000W5sc1AAB,0012000000W5sc9AAB,0012000000W5scCAAR,0012000000W59LIAAZ,0012000000W59ZLAAZ,0012000000W59pqAAB,0012000000W5ACqAAN,0012000000W5AD6AAN,0012000000W5ANfAAN,0012000000W5ANjAAN,0012000000W5ANlAAN,0012000000W5ANmAAN,0012000000W5ANnAAN,0012000000W5ANpAAN,0012000000W5ANqAAN,0012000000W5ANsAAN,0012000000W5AOZAA3,0012000000W5AYPAA3,0012000000W5AYTAA3,0012000000W5AYdAAN,0012000000W5Ak7AAF,0012000000W5AkKAAV,0012000000W5AsCAAV,0012000000W5AsDAAV,0012000000W5B1HAAV,0012000000W5BAJAA3,0012000000W5BJ6AAN,0012000000W5BJEAA3,0012000000W5BJHAA3,0012000000W5BJLAA3,0012000000W5BSuAAN,0012000000W5Bc0AAF,0012000000W5C5hAAF,0012000000W5DOfAAN,0012000000W5E9TAAV,0012000000W5E9VAAV,0012000000W5EknAAF,0012000000W5F2nAAF,0012000000W5OKJAA3,0012000000W5nTaAAJ,0012000000W5nX8AAJ,0012000000W5nXQAAZ,0012000000W5nXSAAZ,0012000000W5nXTAAZ,0012000000W5rRzAAJ,0012000000W5rtSAAR,0012000000W5rtTAAR,0012000000W5s3SAAR,0012000000W5s3TAAR,0012000000W5s3UAAR,0012000000W5sowAAB,0012000000W5t6IAAR,0012000000W59ZhAAJ,0012000000W5AOaAAN,0012000000W5AOdAAN,0012000000W5AOkAAN,0012000000W5AOpAAN,0012000000W5AOzAAN,0012000000W5B1jAAF,0012000000W5B1wAAF,0012000000W5BKeAAN,0012000000W5BcRAAV,0012000000W5DP0AAN,0012000000W5DP8AAN,0012000000W5DclAAF,0012000000W5Ec0AAF,0012000000W5Ec3AAF,0012000000W5FEVAA3,0012000000W5FL9AAN,0012000000W5eMKAAZ,0012000000W5rMIAAZ,0012000000W5ru7AAB,0012000000W5s5PAAR,0012000000W5sEYAAZ,0012000000W5sEhAAJ,0012000000W5sEjAAJ,0012000000W5tpYAAR,0012000000W59ZpAAJ,0012000000W59dnAAB,0012000000W59qRAAR,0012000000W59qXAAR,0012000000W5A4PAAV,0012000000W5AP6AAN,0012000000W5AP7AAN,0012000000W5APAAA3,0012000000W5APCAA3,0012000000W5APFAA3,0012000000W5APHAA3,0012000000W5APKAA3,0012000000W5APNAA3,0012000000W5APQAA3,0012000000W5APSAA3,0012000000W5APTAA3,0012000000W5AlAAAV,0012000000W5AtfAAF,0012000000W5B26AAF,0012000000W5B2EAAV,0012000000W5B2QAAV,0012000000W5B2SAAV,0012000000W5BBUAA3,0012000000W5BBVAA3,0012000000W5BBoAAN,0012000000W5BTbAAN,0012000000W5BTeAAN,0012000000W5BTnAAN,0012000000W5BTrAAN,0012000000W5C6rAAF,0012000000W5C6sAAF,0012000000W5CKNAA3,0012000000W5CTWAA3,0012000000W5DRMAA3,0012000000W5DdPAAV,0012000000W5EAQAA3,0012000000W5FArAAN,0012000000W5GO0AAN,0012000000W5K0AAAV,0012000000W5PkWAAV,0012000000W5fFsAAJ,0012000000W5rMfAAJ,0012000000W5rMgAAJ,0012000000W5rMtAAJ,0012000000W5rMvAAJ,0012000000W5rlkAAB,0012000000W5s5dAAB,0012000000W5vPDAAZ,0012000000W5ywJAAR,0012000000W59MFAAZ,0012000000W59e6AAB,0012000000W59e8AAB,0012000000W59eEAAR,0012000000W59eQAAR,0012000000W59qxAAB,0012000000W5A5UAAV,0012000000W5AFAAA3,0012000000W5APUAA3,0012000000W5APVAA3,0012000000W5APWAA3,0012000000W5APaAAN,0012000000W5APcAAN,0012000000W5APdAAN,0012000000W5APeAAN,0012000000W5APhAAN,0012000000W5APjAAN,0012000000W5APkAAN,0012000000W5APmAAN,0012000000W5APrAAN,0012000000W5APtAAN,0012000000W5APvAAN,0012000000W5AZhAAN,0012000000W5AZjAAN,0012000000W5AbkAAF,0012000000W5AbyAAF,0012000000W5B3TAAV,0012000000W5BU2AAN,0012000000W5BUmAAN,0012000000W5BnTAAV,0012000000W5C7zAAF,0012000000W5C81AAF,0012000000W5CUCAA3,0012000000W5Ch9AAF,0012000000W5DB2AAN,0012000000W5DBDAA3,0012000000W5DRRAA3,0012000000W5ECBAA3,0012000000W5Pl1AAF,0012000000W5fGAAAZ,0012000000W5rNLAAZ,0012000000W5rNMAAZ,0012000000W5rNQAAZ,0012000000W5rc2AAB,0012000000W5rwfAAB,0012000000W5rwhAAB,0012000000W5s60AAB,0012000000W5s6FAAR,0012000000W5s6HAAR,0012000000W5s6IAAR,0012000000W5sFGAAZ,0012000000W5sFHAAZ,0012000000W5sFJAAZ,0012000000W5sFLAAZ,0012000000W5ywcAAB,0012000000W5ywrAAB,0012000000W5zX4AAJ,0012000000W5zt0AAB,0012000000W59OAAAZ,0012000000W59eqAAB,0012000000W59rKAAR,0012000000W5A5tAAF,0012000000W5APyAAN,0012000000W5APzAAN,0012000000W5AQ3AAN,0012000000W5AQ7AAN,0012000000W5AQ9AAN,0012000000W5B3YAAV,0012000000W5B3uAAF,0012000000W5BLvAAN,0012000000W5BV9AAN,0012000000W5Bo2AAF,0012000000W5BoIAAV,0012000000W5ByrAAF,0012000000W5CLHAA3,0012000000W5CVGAA3,0012000000W5CVHAA3,0012000000W5DRyAAN,0012000000W5Df8AAF,0012000000W5DfDAAV,0012000000W5EmsAAF,0012000000W5En8AAF,0012000000W5GP2AAN,0012000000W5PlUAAV,0012000000W5PlWAAV,0012000000W5fGMAAZ,0012000000W5rVFAAZ,0012000000W5reHAAR,0012000000W5rwnAAB,0012000000W5s6OAAR,0012000000W5s6UAAR,0012000000W5sHQAAZ,0012000000W5sHbAAJ,0012000000W5sHcAAJ,0012000000W5sHdAAJ,0012000000W5sHfAAJ,0012000000W5sHiAAJ,0012000000W5sHlAAJ,0012000000W5sHmAAJ,0012000000W5sHnAAJ,0012000000W5sHpAAJ,0012000000W5sHqAAJ,0012000000W5zoqAAB,0012000000W6343AAB,0012000000W6XaRAAV,0012000000W6ApiAAF,0012000000W59fDAAR,0012000000W5AQOAA3,0012000000W5AQQAA3,0012000000W5AQUAA3,0012000000W5AQXAA3,0012000000W5AQYAA3,0012000000W5AQjAAN,0012000000W5AQlAAN,0012000000W5AQnAAN,0012000000W5AcSAAV,0012000000W5B4HAAV,0012000000W5BE7AAN,0012000000W5BMhAAN,0012000000W5BMkAAN,0012000000W5BVWAA3,0012000000W5BVYAA3,0012000000W5BVfAAN,0012000000W5BVpAAN,0012000000W5BoKAAV,0012000000W5CVPAA3,0012000000W5D3XAAV,0012000000W5DfPAAV,0012000000W5DrgAAF,0012000000W5Ee3AAF,0012000000W5fGsAAJ,0012000000W5fH1AAJ,0012000000W5iYSAAZ,0012000000W5sHrAAJ,0012000000W5sHuAAJ,0012000000W5sHyAAJ,0012000000W5sI0AAJ,0012000000W6FRHAA3,0012000000W5sZEAAZ,0012000000W5sZGAAZ,0012000000W5sdJAAR,0012000000W5sdMAAR,0012000000W5sdNAAR,0012000000W5sdPAAR,0012000000W5sdUAAR,0012000000W5sphAAB,0012000000W5t2pAAB,0012000000W5t31AAB,0012000000W5t3CAAR,0012000000W5t6hAAB,0012000000W5t91AAB,0012000000W5t95AAB,0012000000W59AZAAZ,0012000000W59AhAAJ,0012000000W59AjAAJ,0012000000W59AkAAJ,0012000000W59OuAAJ,0012000000W59P0AAJ,0012000000W59P3AAJ,0012000000W59ulAAB,0012000000W5A6jAAF,0012000000W5AQqAAN,0012000000W5AQsAAN,0012000000W5AQuAAN,0012000000W5AQwAAN,0012000000W5AQyAAN,0012000000W5AR0AAN,0012000000W5AR5AAN,0012000000W5AR6AAN,0012000000W5AR7AAN,0012000000W5ARDAA3,0012000000W5AREAA3,0012000000W5ARGAA3,0012000000W5AvzAAF,0012000000W5AwIAAV,0012000000W5AwJAAV,0012000000W5AwKAAV,0012000000W5BN0AAN,0012000000W5BVsAAN,0012000000W5BVyAAN,0012000000W5BXDAA3,0012000000W5BffAAF,0012000000W5C9KAAV,0012000000W5CjdAAF,0012000000W5CrmAAF,0012000000W5Cs4AAF,0012000000W5DCbAAN,0012000000W5DT9AAN,0012000000W5EUFAA3,0012000000W5EoNAAV,0012000000W5EoQAAV,0012000000W5EoSAAV,0012000000W5GG7AAN,0012000000W5HPuAAN,0012000000W5HQ7AAN,0012000000W5g9BAAR,0012000000W5g9JAAR,0012000000W5jaQAAR,0012000000W5rqsAAB,0012000000W5rqtAAB,0012000000W5rquAAB,0012000000W5rzqAAB,0012000000W5sIIAAZ,0012000000W5sIMAAZ,0012000000W5sIWAAZ,0012000000W5sIYAAZ,0012000000W5sIaAAJ,0012000000W5sIbAAJ,0012000000W5sdfAAB,0012000000W5sdpAAB,0012000000W5sgmAAB,0012000000W5t0AAAR,0012000000W5t9JAAR,0012000000W5t9MAAR,0012000000W5t9OAAR,0012000000W5t9XAAR,0012000000W5t9cAAB,0012000000W5t9eAAB,0012000000W5tkuAAB,0012000000W59B9AAJ,0012000000W59g8AAB,0012000000W5A7SAAV,0012000000W5A7YAAV,0012000000W5ARIAA3,0012000000W5ARMAA3,0012000000W5AROAA3,0012000000W5ARPAA3,0012000000W5ARWAA3,0012000000W5ARbAAN,0012000000W5AweAAF,0012000000W5AwfAAF,0012000000W5AwkAAF,0012000000W5B5HAAV,0012000000W5B5TAAV,0012000000W5BEbAAN,0012000000W5BEcAAN,0012000000W5BNTAA3,0012000000W5BNlAAN,0012000000W5BXgAAN,0012000000W5CjuAAF,0012000000W5DTTAA3,0012000000W5HQWAA3,0012000000W5T0WAAV,0012000000W5jaSAAR,0012000000W5s07AAB,0012000000W5s0BAAR,0012000000W5s9KAAR,0012000000W5sIlAAJ,0012000000W5tA1AAJ,0012000000W5tTcAAJ,0012000000W5sQcAAJ,0012000000W5sQeAAJ,0012000000W5sQtAAJ,0012000000W5sVkAAJ,0012000000W59TKAAZ,0012000000W59gWAAR,0012000000W59gdAAB,0012000000W5ASvAAN,0012000000W5AT3AAN,0012000000W5AT4AAN,0012000000W5AT5AAN,0012000000W5AxBAAV,0012000000W5B5pAAF,0012000000W5BFHAA3,0012000000W5BFKAA3,0012000000W5BFLAA3,0012000000W5BO0AAN,0012000000W5BOCAA3,0012000000W5BOIAA3,0012000000W5Ct3AAF,0012000000W5DFWAA3,0012000000W5gA6AAJ,0012000000W5javAAB,0012000000W5s9uAAB,0012000000W5s9zAAB,0012000000W5sAoAAJ,0012000000W5sK2AAJ,0012000000W5sK5AAJ,0012000000W5sK7AAJ,0012000000W5sK9AAJ,0012000000W5sKBAAZ,0012000000W5sR1AAJ,0012000000W5sR2AAJ,0012000000W5sR3AAJ,0012000000W5sR4AAJ,0012000000W5sR7AAJ,0012000000W5zIDAAZ,0012000000VwvvXAAR,0012000000W59G6AAJ,0012000000W59xfAAB,0012000000W5A8JAAV,0012000000W5A8cAAF,0012000000W5AT9AAN,0012000000W5ATBAA3,0012000000W5ATFAA3,0012000000W5ATKAA3,0012000000W5AexAAF,0012000000W5BG5AAN,0012000000W5BOmAAN,0012000000W5BYWAA3,0012000000W5BgoAAF,0012000000W5C1BAAV,0012000000W5CDAAA3,0012000000W5CDSAA3,0012000000W5COYAA3,0012000000W5CZOAA3,0012000000W5CtLAAV,0012000000W5DFoAAN,0012000000W5DYzAAN,0012000000W5EpyAAF,0012000000W5yqtAAB,0012000000W5sSTAAZ,0012000000W5sWNAAZ,0012000000W5zR2AAJ,0012000000W5zerAAB,0012000000W5zu0AAB,0012000000W60DDAAZ,0012000000W66OXAAZ,0012000000W59GdAAJ,0012000000W59jcAAB,0012000000W5A8lAAF,0012000000W5AKdAAN,0012000000W5AKkAAN,0012000000W5ATiAAN,0012000000W5ATkAAN,0012000000W5ATxAAN,0012000000W5ATyAAN,0012000000W5AfJAAV,0012000000W5AxuAAF,0012000000W5BP6AAN,0012000000W5BPAAA3,0012000000W5BhxAAF,0012000000W5BriAAF,0012000000W5BrjAAF,0012000000W5CZZAA3,0012000000W5ClcAAF,0012000000W5DGIAA3,0012000000W5DLrAAN,0012000000W5DZ6AAN,0012000000W5sNjAAJ,0012000000W5sNkAAJ,0012000000W5sSwAAJ,0012000000W6NAGAA3,0012000000W6QXVAA3,0012000000W6QXiAAN,0012000000W5sb7AAB,0012000000W5sb8AAB,0012000000W5se6AAB,0012000000W5seEAAR,0012000000W5shMAAR,0012000000W5shNAAR,0012000000W59GpAAJ,0012000000W59jwAAB,0012000000W5AAFAA3,0012000000W5AAKAA3,0012000000W5AKxAAN,0012000000W5AU1AAN,0012000000W5AptAAF,0012000000W5AytAAF,0012000000W5BPLAA3,0012000000W5BPOAA3,0012000000W5BPaAAN,0012000000W5BZBAA3,0012000000W5BiOAAV,0012000000W5BiRAAV,0012000000W5BiUAAV,0012000000W5ClmAAF,0012000000W5D6HAAV,0012000000W5DZsAAN,0012000000W5EhzAAF,0012000000W5EqiAAF,0012000000W5EqkAAF,0012000000W5sPnAAJ,0012000000W5sPoAAJ,0012000000W5sPpAAJ,0012000000W5sPyAAJ,0012000000W5sTTAAZ,0012000000W5sTUAAZ,0012000000W5sTYAAZ,0012000000W5sTZAAZ,0012000000W5sYfAAJ,0012000000W5sYhAAJ,0012000000W6TxMAAV,0012000000W6dyPAAR,0012000000W5sbuAAB,0012000000W5t2EAAR,0012000000W5t2GAAR,0012000000W5t5pAAB,0012000000W5t63AAB,0012000000W5t65AAB,0012000000W5t66AAB,0012000000W5tAEAAZ,0012000000W59klAAB,0012000000W5ALXAA3,0012000000W5AUnAAN,0012000000W5AUoAAN,0012000000W5AUpAAN,0012000000W5AV3AAN,0012000000W5AV7AAN,0012000000W5AV8AAN,0012000000W5AVAAA3,0012000000W5AVBAA3,0012000000W5AhTAAV,0012000000W5AhoAAF,0012000000W5Az5AAF,0012000000W5Az8AAF,0012000000W5AzDAAV,0012000000W5BZyAAN,0012000000W8UQdAAN,0012000000W8dAhAAJ,0012000000W8dLjAAJ,0012000000W8dVUAAZ,0012000000W8dVYAAZ,0012000000W8dVZAAZ,0012000000W8ddaAAB,0012000000W8ddfAAB,0012000000W8ddgAAB,0012000000W8ddlAAB,0012000000W8ddLAAR,0012000000W8dnNAAR,0012000000W8dnlAAB,0012000000W8dyAAAR,0012000000W8e6EAAR,0012000000W8eFJAAZ,0012000000W8eMtAAJ,0012000000W8eV8AAJ,0012000000W8ed8AAB,0012000000W8elyAAB,0012000000W8emXAAR,0012000000WCywdAAD,0012000000WCyweAAD,0012000000WCywfAAD,0012000000WCywkAAD,0012000000WCz2LAAT,0012000000WCz2NAAT,0012000000WCz2PAAT,0012000000WCz2QAAT,0012000000WCz2RAAT,0012000000WCz2TAAT,0012000000WCz2VAAT,0012000000WCz2WAAT,0012000000WCz2XAAT,0012000000WCz2YAAT,0012000000WCz2ZAAT,0012000000WCz2aAAD,0012000000WCz2cAAD,0012000000W8LYzAAN,0012000000W8TY7AAN,0012000000W8TfnAAF,0012000000W8TyHAAV,0012000000W8U6DAAV,0012000000W8UFsAAN,0012000000W8UR8AAN,0012000000W8URGAA3,0012000000W8URHAA3,0012000000W8UagAAF,0012000000W8UanAAF,0012000000W8dB9AAJ,0012000000W8dO0AAJ,0012000000W8dW0AAJ,0012000000W8dykAAB,0012000000W8dymAAB,0012000000W8e6tAAB,0012000000W8eFSAAZ,0012000000W8eNiAAJ,0012000000W8eVaAAJ,0012000000W8edVAAR,0012000000W8emZAAR,0012000000W8emgAAB,0012000000WCynuAAD,0012000000WCyt1AAD,0012000000WCywtAAD,0012000000WCywwAAD,0012000000WCz67AAD,0012000000WCz6AAAT,0012000000WCz6BAAT,0012000000WCz6CAAT,0012000000WCz6DAAT,0012000000WCz6EAAT,0012000000WCz6FAAT,0012000000WCz6GAAT,0012000000WCz6HAAT,0012000000WCz6IAAT,0012000000WCz6KAAT,0012000000WCz6LAAT,0012000000WCz6MAAT,0012000000WCz6NAAT,0012000000WCz6OAAT,0012000000WCz6PAAT,0012000000WCz6QAAT,0012000000WCz6SAAT,0012000000WCz6TAAT,0012000000WCzBnAAL,0012000000WCzC3AAL,0012000000WCzjxAAD,0012000000W7lfiAAB,0012000000W8T1uAAF,0012000000W8TYnAAN,0012000000W8TgUAAV,0012000000W8TpSAAV,0012000000W8TpVAAV,0012000000W8U6TAAV,0012000000W8U6aAAF,0012000000W8UFwAAN,0012000000W8URbAAN,0012000000W8dDAAAZ,0012000000W8dDHAAZ,0012000000W8dqkAAB,0012000000W8e7JAAR,0012000000W8e7TAAR,0012000000W8eG1AAJ,0012000000W8edtAAB,0012000000W8ee3AAB,0012000000W8ee4AAB,0012000000W8enJAAR,0012000000WCysTAAT,0012000000WCyvwAAD,0012000000WCz6VAAT,0012000000WCz6XAAT,0012000000WCz6YAAT,0012000000WCz6aAAD,0012000000WCz6bAAD,0012000000WCz6dAAD,0012000000WCz6eAAD,0012000000WCz6fAAD,0012000000WCz6gAAD,0012000000WCz6hAAD,0012000000WCz6iAAD,0012000000WCz6jAAD,0012000000WCz6kAAD,0012000000W6dylAAB,0012000000W6dz3AAB,0012000000W7GbLAAV,0012000000W8FIVAA3,0012000000W8TReAAN,0012000000W8TRgAAN,0012000000W8TgcAAF,0012000000W8TgjAAF,0012000000W8TqFAAV,0012000000W8UGNAA3,0012000000W8UGnAAN,0012000000W8dDjAAJ,0012000000W8dWhAAJ,0012000000W8df6AAB,0012000000W8dfDAAR,0012000000W8dfEAAR,0012000000W8drFAAR,0012000000W8dzOAAR,0012000000W8e7nAAB,0012000000W8e7tAAB,0012000000W8eGVAAZ,0012000000W8eOfAAJ,0012000000W8eOhAAJ,0012000000W8eeVAAR,0012000000W8eo3AAB,0012000000W8exUAAR,0012000000W8exWAAR,0012000000W8exhAAB,0012000000WCyvxAAD,0012000000WCyvyAAD,0012000000WCyvzAAD,0012000000WCyw0AAD,0012000000WCyw1AAD,0012000000WCz1OAAT,0012000000WCz1PAAT,0012000000WCz1RAAT,0012000000WCz1ZAAT,0012000000WCz1aAAD,0012000000WCz1bAAD,0012000000WCz1cAAD,0012000000WCz1eAAD,0012000000WCz1gAAD,0012000000WCz1hAAD,0012000000WCz1iAAD,0012000000WCz1jAAD,0012000000WCz1kAAD,0012000000WCz1lAAD,0012000000WCz1nAAD,0012000000WCz1oAAD,0012000000WjG4zAAF,0012000000W6dz5AAB,0012000000W8TqLAAV,0012000000W8TzrAAF,0012000000W8U7SAAV,0012000000W8UHAAA3,0012000000W8UULAA3,0012000000W8dfkAAB,0012000000W8draAAB,0012000000W8e0VAAR,0012000000W8e0gAAB,0012000000W8e8OAAR,0012000000W8e8SAAR,0012000000W8eXKAAZ,0012000000W8eeyAAB,0012000000W8ef3AAB,0012000000W8eoCAAR,0012000000W8eoZAAR,0012000000W8exqAAB,0012000000WCz1pAAD,0012000000WCz1tAAD,0012000000WCz1uAAD,0012000000WCz1vAAD,0012000000WCz23AAD,0012000000WCz2FAAT,0012000000WCzRUAA1,0012000000W7K2sAAF,0012000000W84OPAAZ,0012000000W8TSXAA3,0012000000W8TZzAAN,0012000000W8ThcAAF,0012000000W8ThdAAF,0012000000W8TrCAAV,0012000000W8U7zAAF,0012000000W8UV3AAN,0012000000W8dEZAAZ,0012000000W8dEnAAJ,0012000000W8dEoAAJ,0012000000W8dsPAAR,0012000000W8dsVAAR,0012000000W8e0jAAB,0012000000W8e0nAAB,0012000000W8eHeAAJ,0012000000W8ePRAAZ,0012000000W8ePUAAZ,0012000000W8eXYAAZ,0012000000W8eXpAAJ,0012000000W8efEAAR,0012000000W8efSAAR,0012000000W8eohAAB,0012000000W8eoiAAB,0012000000W8eyNAAR,0012000000W8eyqAAB,0012000000WCze9AAD,0012000000WCznwAAD,0012000000WCzo4AAD,0012000000W6hmVAAR,0012000000W7K3LAAV,0012000000W7aCoAAJ,0012000000W8TEkAAN,0012000000W8TaTAAV,0012000000W8TaWAAV,0012000000W8TadAAF,0012000000W8TrTAAV,0012000000W8TrgAAF,0012000000W8TrhAAF,0012000000W8TrjAAF,0012000000W8U0XAAV,0012000000W8U0iAAF,0012000000W8U0yAAF,0012000000W8U8eAAF,0012000000W8UI1AAN,0012000000W8UI9AAN,0012000000W8UVJAA3,0012000000W8dgiAAB,0012000000W8dgqAAB,0012000000W8dh0AAB,0012000000W8dsoAAB,0012000000W8eIDAAZ,0012000000W8eQ7AAJ,0012000000W8eYEAAZ,0012000000W8ehGAAR,0012000000W8ehaAAB,0012000000W8ep6AAB,0012000000W8ep7AAB,0012000000W8epTAAR,0012000000W8ezGAAR,0012000000WCzHbAAL,0012000000W7aD5AAJ,0012000000W8TTKAA3,0012000000W8TTQAA3,0012000000W8TbDAAV,0012000000W8TbIAAV,0012000000W8TroAAF,0012000000W8TrpAAF,0012000000W8TrqAAF,0012000000W8TruAAF,0012000000W8TrwAAF,0012000000W8U14AAF,0012000000W8U91AAF,0012000000W8U99AAF,0012000000W8U9KAAV,0012000000W8UVhAAN,0012000000W8dFXAAZ,0012000000W8dFgAAJ,0012000000W8dFhAAJ,0012000000W8dR1AAJ,0012000000W8dh4AAB,0012000000W8dtDAAR,0012000000W8dtLAAR,0012000000W8dtWAAR,0012000000W8e27AAB,0012000000W8eA1AAJ,0012000000W8eA6AAJ,0012000000W8eIgAAJ,0012000000W8eIoAAJ,0012000000W8eQNAAZ,0012000000W8S2QAAV,0012000000W8TFbAAN,0012000000W8Tj5AAF,0012000000W8TjHAAV,0012000000W8TsEAAV,0012000000W8TsVAAV,0012000000W8U1YAAV,0012000000W8U1cAAF,0012000000W8UIoAAN,0012000000W8UWDAA3,0012000000W8UWRAA3,0012000000W8dFqAAJ,0012000000W8dReAAJ,0012000000W8dZiAAJ,0012000000W8dhmAAB,0012000000W8dhrAAB,0012000000W8dhtAAB,0012000000W8dtlAAB,0012000000W8e2TAAR,0012000000W8eAQAAZ,0012000000W8eAcAAJ,0012000000W8eAiAAJ,0012000000W8eIyAAJ,0012000000W8eR6AAJ,0012000000W8eZ1AAJ,0012000000W8eZEAAZ,0012000000WjJ7mAAF,0012000000W79FUAAZ,0012000000W8T5rAAF,0012000000W8TUWAA3,0012000000W8TcGAAV,0012000000W8TjRAAV,0012000000W8TufAAF,0012000000W8U22AAF,0012000000W8UWdAAN,0012000000W8UWgAAN,0012000000W8dIZAAZ,0012000000W8dRrAAJ,0012000000W8dZvAAJ,0012000000W8da4AAB,0012000000W8da6AAB,0012000000W8diWAAR,0012000000W8e2mAAB,0012000000W8eJSAAZ,0012000000W8eJVAAZ,0012000000W8eJYAAZ,0012000000W8eJjAAJ,0012000000W8eRLAAZ,0012000000W8eivAAB,0012000000W8eqZAAR,0012000000W8eqlAAB,0012000000W8eqmAAB,0012000000WDAeYAAX,0012000000W7tsEAAR,0012000000W8TUhAAN,0012000000W8TcaAAF,0012000000W8TumAAF,0012000000W8TuwAAF,0012000000W8TvAAAV,0012000000W8UAbAAN,0012000000W8ULdAAN,0012000000W8ULhAAN,0012000000W8ULsAAN,0012000000W8dIiAAJ,0012000000W8dJ1AAJ,0012000000W8dSBAAZ,0012000000W8dSIAAZ,0012000000W8dSWAAZ,0012000000W8dSYAAZ,0012000000W8daaAAB,0012000000W8dicAAB,0012000000W8ditAAB,0012000000W8e3DAAR,0012000000W8e3QAAR,0012000000W8e3hAAB,0012000000W8eJuAAJ,0012000000W8eK1AAJ,0012000000W8eSLAAZ,0012000000W8eaCAAR,0012000000WDAoSAAX,0012000000W6ltfAAB,0012000000W6yE3AAJ,0012000000W7e0fAAB,0012000000W8TcxAAF,0012000000W8Td0AAF,0012000000W8TdHAAV,0012000000W8TmLAAV,0012000000W8U35AAF,0012000000W8U3UAAV,0012000000W8U3VAAV,0012000000W8UB3AAN,0012000000W8UB9AAN,0012000000W8UMKAA3,0012000000W8UY3AAN,0012000000W8dJ4AAJ,0012000000W8dT0AAJ,0012000000W8datAAB,0012000000W8dauAAB,0012000000W8dbMAAR,0012000000W8dbRAAR,0012000000W8djKAAR,0012000000W8dvSAAR,0012000000W8e3tAAB,0012000000W8eCGAAZ,0012000000W8eKdAAJ,0012000000W8eKlAAJ,0012000000W8eKqAAJ,0012000000W8eKrAAJ,0012000000W8eSaAAJ,0012000000W8eSgAAJ,0012000000W8eaMAAR,0012000000W8ejfAAB,0012000000W8ejhAAB,0012000000W8ejxAAB,0012000000WCvSfAAL,0012000000WCvSnAAL,0012000000W6yECAAZ,0012000000W8TdJAAV,0012000000W8TdUAAV,0012000000W8TdiAAF,0012000000W8TmUAAV,0012000000W8TmlAAF,0012000000W8UBMAA3,0012000000W8UMcAAN,0012000000W8UMdAAN,0012000000W8UMkAAN,0012000000W8UOWAA3,0012000000W8dJXAAZ,0012000000W8dJbAAJ,0012000000W8dJmAAJ,0012000000W8djcAAB,0012000000W8djpAAB,0012000000W8dwBAAR,0012000000W8eLGAAZ,0012000000W8ek4AAB,0012000000W8SqYAAV,0012000000W8Te9AAF,0012000000W8Tn6AAF,0012000000W8TwSAAV,0012000000W8UBpAAN,0012000000W8UBxAAN,0012000000W8UOeAAN,0012000000W8UOqAAN,0012000000W8UYhAAN,0012000000W8d7iAAB,0012000000W8d7lAAB,0012000000W8dKSAAZ,0012000000W8dTlAAJ,0012000000W8dTvAAJ,0012000000W8dbvAAB,0012000000W8dc4AAB,0012000000W8dwdAAB,0012000000W8eDTAAZ,0012000000W8eLPAAZ,0012000000W8eTmAAJ,0012000000W8ebNAAR,0012000000W8ebWAAR,0012000000W8eknAAB,0012000000W7SNoAAN,0012000000W7SO9AAN,0012000000W8TP7AAN,0012000000W8TP9AAN,0012000000W8TPHAA3,0012000000W8TeMAAV,0012000000W8TeOAAV,0012000000W8TnnAAF,0012000000W8TwbAAF,0012000000W8TwqAAF,0012000000W8TwvAAF,0012000000W8TwxAAF,0012000000W8UE2AAN,0012000000W8UE7AAN,0012000000W8UEGAA3,0012000000W8UEJAA3,0012000000W8UETAA3,0012000000W8UP8AAN,0012000000W8UZFAA3,0012000000W8dcfAAB,0012000000W8dcgAAB,0012000000W8dcjAAB,0012000000W8dcoAAB,0012000000W8dmZAAR,0012000000W8dx6AAB,0012000000W8eDpAAJ,0012000000W8eLxAAJ,0012000000W8eM1AAJ,0012000000W8eM3AAJ,0012000000W8eMOAAZ,0012000000W8eUEAAZ,0012000000W8ec9AAB,0012000000W8el6AAB,0012000000W8etCAAR,0012000000WCyimAAD,0012000000W8TXNAA3,0012000000W8TXXAA3,0012000000W8Tf8AAF,0012000000W8TnyAAF,0012000000W8To1AAF,0012000000W8Tx8AAF,0012000000W8TxSAAV,0012000000W8U4yAAF,0012000000W8U5HAAV,0012000000W8U5OAAV,0012000000W8dA1AAJ,0012000000W8dUZAAZ,0012000000W8dcvAAB,0012000000W8dd0AAB,0012000000W8dd1AAB,0012000000W8dd2AAB,0012000000W8dn1AAB,0012000000W8e5zAAB,0012000000W8e6BAAR,0012000000W8e6CAAR,0012000000W8eEIAAZ,0012000000W8eUTAAZ,0012000000W8eUgAAJ,0012000000W8ecRAAR,0012000000W8ecSAAR,0012000000W8ecZAAR,0012000000W8ecgAAB,0012000000W8elXAAR,0012000000W8elYAAR,0012000000W8elpAAB,0012000000W8evNAAR,0012000000W8TXdAAN,0012000000W8TXmAAN,0012000000W8TXqAAN,0012000000W8TfDAAV,0012000000W8TfUAAV,0012000000W8TfeAAF,0012000000W8ToTAAV,0012000000W8TolAAF,0012000000W8TomAAF,0012000000W8TonAAF,0012000000W8Ty0AAF,0012000000W8Ty2AAF,0012000000W8U5pAAF,0012000000W8UFIAA3,0012000000W8UQNAA3,0012000000W8UQOAA3,0012000000W8UQZAA3,0012000000YOGuSAAX,0012000000X9UZzAAN,0012000000X9PkjAAF,0012000000XtM1PAAV,001D000000jBPTQIA4,001D000000jBPncIAG,001D000000jBPojIAG,001D000000jBPhaIAG,001D000000jBPhdIAG,001D000000jBPotIAG,001D000000jBPpPIAW,001D000000jBPhhIAG,001D000000jBPhqIAG,001D000000jBPhxIAG,001D000000jBPhyIAG,001D000000jBPpfIAG,001D000000jBPpgIAG,001D000000jBPq1IAG,001D000000jBPicIAG,001D000000jBPj0IAG,001D000000jBPj1IAG,001D000000jBPjEIAW,001D000000jBPjIIAW,001D000000jBPjVIAW,001D000000jBPjcIAG,001D000000jBPjjIAG,001D000000jBPuiIAG,001D000000pSIetIAG,001D000000p6KLkIAM,001D000000prc3EIAQ,001D000000pSEqmIAG,001D000000pSF3OIAW,001D000000oahKdIAI,001D000000p6nJKIAY,001D000000pSFCwIAO,001D000000pretCIAQ,001D000000rZT7kIAG,001D000000p6ogUIAQ,001D000000pSFgsIAG,001D000000prf4tIAA,001D000000prfF2IAI,001D000000p5xHvIAI,001D000000p5xMSIAY,001D000000p6oxFIAQ,001D000000pSG4NIAW,001D000000pSG8OIAW,001D000000prfOsIAI,001D000000p6pF1IAI,001D000000p6pOgIAI,001D000000p5y2SIAQ,001D000000p6pt5IAA,001D000000pSHoZIAW,001D000000p5yFlIAI,001D000000p6qDpIAI,001D000000pSI8KIAW,001D000000pSIEGIA4,001D000000p5ySBIAY,001D000000p6qQsIAI,001D000000p6qayIAA,001D000000p6r3JIAQ,001D000000p6r7DIAQ,001D000000sdi8pIAA,001D000000sdiAaIAI,001D000000sm5uqIAA,001D000000sm6H6IAI,001D000000t86rLIAQ,001D000000s9ndYIAQ,001D000000s9njmIAA,001D000000sA1f1IAC,001D000000sA1teIAC,001D000000sB5ytIAC,001D000000sdLWDIA2,001D000000sdWDPIA2,001D000000sdiQKIAY,001D000000t8XXKIA2,001D000000s9noVIAQ,001D000000s9nv1IAA,001D000000sA26OIAS,001D000000sA2QoIAK,001D000000sAwR6IAK,001D000000sB6TXIA0,001D000000sdWz4IAE,001D000000sdiv0IAA,001D000000t8DGNIA2,001D000000s9pjaIAA,001D000000sA2jKIAS,001D000000sA2r4IAC,001D000000sAwaAIAS,001D000000sAx8XIAS,001D000000sB6i9IAC,001D000000sdMcGIAU,001D000000sdNLaIAM,001D000000smBEcIAM,001D000000t8DqaIAE,001D000000t8DyDIAU,001D000000sA332IAC,001D000000sANgGIAW,001D000000sANlRIAW,001D000000sAY7PIAW,001D000000sAYGOIA4,001D000000sB74GIAS,001D000000sdNgAIAU,001D000000sdXgcIAE,001D000000smBrdIAE,001D000000t7PqNIAU,001D000000raRdDIAU,001D000000sA49CIAS,001D000000sANzCIAW,001D000000sAYrKIAW,001D000000sAZC1IAO,001D000000sAxm4IAC,001D000000sAxtuIAC,001D000000sdNxoIAE,001D000000t6DXdIAM,001D000000t7QRSIA2,001D000000s91gYIAQ,001D000000sA4P7IAK,001D000000sAZgOIAW,001D000000sAaEkIAK,001D000000sAaTkIAK,001D000000sB8GSIA0,001D000000sdOS7IAM,001D000000smCYkIAM,001D000000smxFeIAI,001D000000t6DZVIA2,001D000000t7SPPIA2,001D000000s9keYIAQ,001D000000sAOK7IAO,001D000000sAOVMIA4,001D000000sAz6IIAS,001D000000smDaNIAU,001D000000smxgFIAQ,001D000000smxs4IAA,001D000000t7afoIAA,001D000000s96qyIAA,001D000000sAQCkIAO,001D000000smDp3IAE,001D000000smyiGIAQ,001D000000t62yEIAQ,001D000000t6EQXIA2,001D000000sARG2IAO,001D000000sAbrxIAC,001D000000sAbwAIAS,001D000000sAzJ3IAK,001D000000sm1fZIAQ,001D000000sm1plIAA,001D000000smz5uIAA,001D000000t63LbIAI,001D000000t6FIaIAM,001D000000t7ee7IAA,001D000000s973IIAQ,001D000000sAcMhIAK,001D000000sAza2IAC,001D000000sAzstIAC,001D000000sddLnIAI,001D000000sddZVIAY,001D000000sm25yIAA,001D000000sm2ExIAI,001D000000smEujIAE,001D000000smzSLIAY,001D000000t7f0vIAA,001D000000t7fKXIAY,001D000000sATOcIAO,001D000000sB00TIAS,001D000000sB0L5IAK,001D000000sdTNRIA2,001D000000sde1RIAQ,001D000000sm2JuIAI,001D000000smF4nIAE,001D000000t655OIAQ,001D000000t6FlTIAU,001D000000t6G3RIAU,001D000000s9lt7IAA,001D000000s9luBIAQ,001D000000sATYlIAO,001D000000sAdCuIAK,001D000000sdTS3IAM,001D000000sdTkrIAE,001D000000sdeEtIAI,001D000000sdeTuIAI,001D000000sdeg2IAA,001D000000sm2h3IAA,001D000000sm4aZIAQ,001D000000sn0MMIAY,001D000000t65MhIAI,001D000000s97THIAY,001D000000sdJUZIA2,001D000000sdTyKIAU,001D000000sdextIAA,001D000000sm52RIAQ,001D000000sn0ZRIAY,001D000000t65YNIAY,001D000000t7sq4IAA,001D000000s9mVFIAY,001D000000s9mmaIAA,001D000000sm5GsIAI,001D000000sn0pcIAA,001D000000sdK3wIAE,001D000000sdVBYIA2,001D000000sdVGFIA2,001D000000sdhT8IAI,001D000000sdhsxIAA,001D000000sm5bNIAQ,001D000000sm5lAIAQ,001D000000sn13cIAA,001D000000sn13dIAA,001D000000t8WKuIAM,001D000000s9nRIIAY,001D000000s9nY4IAI,001D000000sA1FaIAK,001D000000sAN32IAG,001D000000sB5i7IAC,001D000000sB5qOIAS,001D000000sdKZvIAM,0012000000W5AVFAA3,0012000000W5As8AAF,0012000000W5scJAAR,0012000000W5sETAAZ,0012000000W5sEUAAZ,0012000000W5APGAA3,0012000000W5APMAA3,0012000000W5APPAA3,0012000000W5AlEAAV,0012000000W5APZAA3,0012000000W5APiAAN,0012000000W5APnAAN,0012000000W5AQ1AAN,0012000000W5BV1AAN,0012000000W5g8yAAB,0012000000W5t96AAB,0012000000W5AQzAAN,0012000000W5AR3AAN,0012000000W5AR8AAN,0012000000W5ARiAAN,0012000000W5ASpAAN,0012000000W5sAmAAJ,0012000000W5ufzAAB,0012000000W5sR8AAJ,0012000000W5ATGAA3,0012000000W5ATeAAN,0012000000W5ATfAAN,0012000000W5ATjAAN,0012000000W5ATlAAN,0012000000W5gwGAAR,0012000000W5AU0AAN,0012000000W5AqJAAV,0012000000W5BZoAAN,0012000000W8ddiAAB,0012000000WjA0HAAV,0012000000WjA0IAAV,0012000000WjA0JAAV,0012000000WjBeMAAV,0012000000WjBeQAAV,0012000000WjBebAAF,0012000000WjBecAAF,0012000000WjBedAAF,0012000000WjBeeAAF,0012000000W8dhPAAR,0012000000W8eQUAAZ,0012000000W8dZtAAJ,0012000000W8Tc7AAF,0012000000W8UBJAA3';
               
               String[] dynStrArr = selectNodeIds.split(','); 
               SelectIdSet = new Set<String>(); 
               SelectIdSet.addAll(dynStrArr);
               System.debug('PrintSet***'+SelectIdSet+'DynaSTR*****'+dynStrArr+ 'ObjectSTringSize' +objectStrList.size() );
               PageReference newPage = Page.AccountAssignmentContactPage;
               System.debug('top 1st Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
               boolean pageFlag = false; 
               List<AccountShare> aShare = new AccountShare[0];
               List<Account> deletedCableUnitsList = new List<Account>();
               Map<String, String> deletedCableUnitMap = new Map<String, String>();
               List<Account> accountListCreated =new List<Account>();
               List<ID> accountListDeleted =new List<ID>();
               List<ID> accountListCreatedId =new List<ID>();
               Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
               Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
               List<Account> accountListForAdmin =new List<Account>();
               List<ID> accountListForAdminId =new List<ID>();
               Database.DeleteResult[] DeleteResult;
               //ADDED Priyanka
               List<Account> accountListCreatedTest =new List<Account>();
               portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
               portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
            try{
                System.Debug('-----'+contact.KissPartyId__c);
                System.debug('top 2nd Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
                // Temporary commented as per the mail for avoiding problems while creating contact roles if cast iron has performance problems.
            //  if(contact.KissPartyId__c != null){ 
                    if(getUser()!=null){
                        system.debug('....................contact.email..............'+contact.email);
                        system.debug('....................contact.Street_P__c..............'+contact.Street_P__c);
                        system.debug('....................contact.Street_P__r.Name..............'+contact.Street_P__r.name );
                        system.debug('....................contact.Street_P__r.Street__c..............'+contact.Street_P__r.Street__c );
                        
                        system.debug('....................contact.FirstName..............'+contact.FirstName);
                        system.debug('....................contact.LastName..............'+contact.LastName);
                        system.debug('....................contact.Phone..............'+contact.Phone);
                        system.debug('....................contact.HomePhone..............'+contact.HomePhone);
                        system.debug('....................contact.MobilePhone..............'+contact.MobilePhone);
                           if(contact.Enable_Customer_Portal_User__c == true){ 
                                if(contact.email == null){
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Contact_Email_Error);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null; 
                                    // remove contact.FirstName for SF-1599 issue
                                }else if(contact.Street_P__r.Name == null || contact.LastName == null || (contact.Phone == null && contact.HomePhone == null && contact.MobilePhone == null )){
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Contact_Mandatory_Check);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null; 
                                }
                                if(contact.UserProfile__c == null){
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Select_UserProfile);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null;                    
                                 }                          
                                //  user=[Select Id,IsActive from User where Id=:getUser().Id];
                                //  user.IsActive=true;
                                //  update user;
                                // For Loop Added 
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
                                System.debug('top 2nd Total Number of script statements allowed in this apex code context: after first forloop'+  Limits.getScriptStatements());
                                
                                if(objectStrList.size() > 0){
                                 System.debug('Inside if$$&&&'+objectStrList.size());   
                                 for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
                                    Account account = objectStrList[chkBoxCount].pos.account;
                                    accountListForAdmin.add(account);
                                    accountListForAdminId.add(account.id);
                                    if(objectStrList[chkBoxCount].selected){
                                        accountListCreated.add(account);
                                        accountListCreatedId.add(account.id);
                                    }
                                    if(account.Type == 'Kunde' && (contact.UserProfile__c==portalAdminUser || objectStrList[chkBoxCount].selected)){
                                      System.debug('Inside PageFlag');  
                                      pageFlag = true;
                                    }
                                 // Below 5 lines commented just for test   
                                /*    if((!deletedCableUnitMap.containsKey(account.name)) && objectStrList[chkBoxCount].selected == false && objectStrList[chkBoxCount].prevselected == true){
                                       deletedCableUnitsList.add(account);
                                       accountListDeleted.add(account.id);
                                    }
                                    deletedCableUnitMap.put(account.name, account.name);   */
                                 // below 4 line added in place of above line with some modifications   
                                    if(objectStrList[chkBoxCount].selected == false && objectStrList[chkBoxCount].prevselected == true){
                                       deletedCableUnitsList.add(account);
                                       accountListDeleted.add(account.id);
                                    }  
                                 }
                                }
                                System.debug('DeleteList Size%%%%%'+accountListDeleted.size());
                                System.debug('accountListCreated--'+accountListCreated);
                                System.debug('accountListCreated size--'+accountListCreated.size());
                                System.debug('first Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements()); 
                            /*
                                     for(cObjectStructureMap objectStructureMap : getObjectStructure()){
                                         Account account = objectStructureMap.pos.account;
                                         accountListForAdmin.add(account);
                                         accountListForAdminId.add(account.id);
                                           if(objectStructureMap.selected){
                                                accountListCreated.add(account);
                                                accountListCreatedId.add(account.id);
                                                
                                           }
                                           
                                           if((!deletedCableUnitMap.containsKey(account.name)) && objectStructureMap.selected == false && objectStructureMap.prevselected == true){
                                                deletedCableUnitsList.add(account);
                                                accountListDeleted.add(account.id);
                                                
                                           }
                                           
                                           deletedCableUnitMap.put(account.name, account.name);
                                        }
                                        */
                                        
                                        if(accountListCreated.size() == 0 && contact.UserProfile__c==portalAdminUser){
                                                accountListCreated.addAll(accountListForAdmin);
                                                accountListCreatedId.addAll(accountListForAdminId);
                                                deletedCableUnitsList.clear();
                                                accountListDeleted.clear();  
                                        }
                                        else if(accountListCreated.size() == 0){
                                            ApexPages.Message errorMsg = null; 
                                            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Need_OneAccount_Error);
                                            ApexPages.addMessage(errorMsg); 
                                            errorChk = true; 
                                            return null; 
                                        }
                                        // Change according to the test scenarios  wherein hierarchy type 
                                        // system.debug('$accountListCreated$'+accountListCreated);
                                       if(accountListCreated.size() > 0){
                                           /* for(Account hierarchy1 : accountListCreated){
                                                if(hierarchy1.Type == 'Kunde'){
                                                    pageFlag = true;
                                                    break;
                                                } 
                                                
                                            }*/
                                            System.debug('pageFlag---@@@@@'+pageFlag);
                                            if(!pageFlag){
                                                ApexPages.Message errorMsg2 = null; 
                                                errorMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_HierarchyType_WithoutCableUnit);
                                                ApexPages.addMessage(errorMsg2);    
                                                errorChk = true; 
                                                return null; 
                                            }
                                        }
                                        ApexPages.Message pendingMsg = null;
                                        System.debug('@@@@@second Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
                                        if(!PortalUserService.isMandatoryInfoMissingOnCU(accountListCreated)){
                                            if(getUser().IsActive){
                                                //disableFlag = true;
                                                pendingMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_PendingUpdation);
                                            }else{
                                                //disableFlag = true;
                                                pendingMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_PendingCreation);
                                            }
                                            service.editPortalUserNew(contact, accountListCreatedId,accountListCreated, deletedCableUnitsList, accountListDeleted);
                                            System.debug('Check Mandatory Information' + pendingMsg );
                                        }else{
                                        ApexPages.Message errorMsg = null; 
                                           errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mandatory field missing on CU');
                                           ApexPages.addMessage(errorMsg);
                                           //exceptionHandler.handleException('','save()',false,false);
                                           errorChk = true;
                                           return null;
                                        } 
                                    if(accountListCreated.size() > 50 || accountListDeleted.size() > 50){
                                          //ApexPages.Message pendingMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_PendingCreation);
                                           ApexPages.addMessage(pendingMsg);
                                           disableFlag = true;
                                           return null;
                                    }else{
                                    statusAssignment = true;
                                    System.debug('Status Assignment' + statusAssignment);
                                //   service.updateAccountAssignmentNew(user, contact, accountListCreated, deletedCableUnitsList, accountListDeleted);
                                //    return newPage;
                                    return null; 
                                    }
                                }else{
                                    if(userIsActive == false){
                                        ApexPages.Message errorMsg = null; 
                                            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_EnableUser_ChkBx_Select);
                                            ApexPages.addMessage(errorMsg); 
                                            errorChk = true; 
                                            return null;                                    
                                    }
                                    contact.Enable_Customer_Portal_User__c = false;
                            
                                     update contact;
                                    Profile profile = [Select id from Profile where id =: user.ProfileId];
              
                                    if(profile.id == [ Select id from Profile where name =: portalAdminUser].id){
                                      lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where id =: ServiceCenterSingleton.getInstance().getAdminRoleId()];
                                      System.debug('!!lcrRoleAdmin!'+lcrRoleAdmin);
                            //      roleId=lcrRoleAdmin.Id;
                
                                    }else if(profile.id  == [ Select id from Profile where name =: portalUserProfile].id){
                                       System.debug('Inside if');
                                       lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where Id  =: ServiceCenterSingleton.getInstance().getUserRoleId()];
                            //        roleId=lcrRoleUser.Id;
                                    System.debug('!!lcrRoleUser!'+lcrRoleUser);
                                    }
                                    
                                    if(objectStrList.size() > 0){
                                     for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
                                        Account account = objectStrList[chkBoxCount].pos.account;
                                        if(objectStrList[chkBoxCount].prevselected == true){
                                          accountListCreated.add(account);
                                          accountListCreatedId.add(account.id);
                                        }
                                     }
                                    }
                                    /*
                                     for(cObjectStructureMap objectStructureMap : getObjectStructure()){
                                         Account account = objectStructureMap.pos.account;                
                                           if(objectStructureMap.prevselected == true){
                                                accountListCreated.add(account);
                                                accountListCreatedId.add(account.id);
                                                
                                           }                  
                                        }*/
                                    List<AccountShare> accountShareList = [Select Id from AccountShare a  where a.UserOrGroupId =: getUser().Id and a.AccountId  in : accountListCreatedId];
                                    if(accountShareList.size() > 0){
                                      delete accountShareList;
                                      System.debug('After delete');
                                    }  
                                
                                   List<Account_Contact_Role__c> acrdeleteItems = [select acr.Id from Account_Contact_Role__c acr where acr.Contact__c =: contact.Id and (role__c =:lcrRoleAdmin.Id or role__c=:lcrRoleUser.Id )];
                                   System.debug('delete list'+acrdeleteItems);
                                   if(acrdeleteItems.size() > 0){
                                        if(acrdeleteItems.size() < 50){
                                            //delete acrdeleteItems; 
                                            DeleteResult = Database.delete(acrdeleteItems, true);
                                        }else{
                                            SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrdeleteItems, SC_BatchCreateEditDeleteContactRoles.OPERATION.DELETE_ROLE); 
                                            Id jobId = Database.executebatch(batch, 50);
                                        }
                                   }
                                //   deactivateUser(getUser().Id);
                                    PortalUserService.deleteUser(contact.Id);
                                   statusAssignment = true;
                                //      service.updateAccountAssignmentNew(user, contact, accountListCreated, deletedCableUnitsList, accountListDeleted);
                                   return null;
                                }
                    }else{
                        if(contact.Email == null){
                                ApexPages.Message errorMsg = null; 
                                errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Contact_Email_Error);
                                ApexPages.addMessage(errorMsg); 
                                errorChk = true; 
                                return null;           
                                // remove contact.FirstName for SF-1599 issue         
                        } else if(contact.Street_P__r.Name == null || contact.LastName == null || (contact.Phone == null && contact.HomePhone == null && contact.MobilePhone == null )){
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Contact_Mandatory_Check);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null; 
                        }else{
                               system.debug('$Contact Email$');
                           if(contact.Enable_Customer_Portal_User__c == true && getUser() == null){
                              system.debug('$Contact Enable$');
                              if(contact.UserProfile__c == null){
                                    ApexPages.Message errorMsg = null; 
                                    errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Select_UserProfile);
                                    ApexPages.addMessage(errorMsg); 
                                    errorChk = true; 
                                    return null;                    
                               } 
                               System.Debug('String size' +objectStrList.size());
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
                                System.Debug('String size after loop' +objectStrList.size());
                                objectStrListJson = JSON.serialize(objectStrList);
                       system.debug('Inside save for nonexistant user objectStrListJson: '+objectStrListJson);
                                System.debug('In create user');
                                System.debug('BEFORE CREATING USER secnd Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());    
                                if(objectStrList.size() > 0){
                                 for(Integer chkBoxCount = 0; chkBoxCount < objectStrList.Size() ; chkBoxCount++){
                                   Account account = objectStrList[chkBoxCount].pos.account;
                                   accountListForAdmin.add(account);
                                   accountListForAdminId.add(account.id);
                                   if(objectStrList[chkBoxCount].selected){
                                     accountListCreated.add(account);
                                     accountListCreatedId.add(account.id);
                                   }
                                   if((!deletedCableUnitMap.containsKey(account.name)) && objectStrList[chkBoxCount].selected == false && objectStrList[chkBoxCount].prevselected == true){
                                        deletedCableUnitsList.add(account);
                                        accountListDeleted.add(account.id);
                                   }
                                  
                                   if(account.Type == 'Kunde' && (contact.UserProfile__c==portalAdminUser || objectStrList[chkBoxCount].selected)){
                                     System.debug('create user account.Type---'+account.Type);
                                      pageFlag = true;
                                   }
                                   deletedCableUnitMap.put(account.name, account.name);
                                 }
                                 }
                                 System.debug('BEFORE CREATING USER third Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
                                    /* temp cmmntd priyanka
                                       for(cObjectStructureMap objectStructureMap : getObjectStructure()){
                                           Account account = objectStructureMap.pos.account;
                                           accountListForAdmin.add(account);
                                         accountListForAdminId.add(account.id);
                                           if(objectStructureMap.selected){
                                                accountListCreated.add(account);
                                                accountListCreatedId.add(account.id);
                                           }
                                           if((!deletedCableUnitMap.containsKey(account.name)) && objectStructureMap.selected == false && objectStructureMap.prevselected == true){
                                                deletedCableUnitsList.add(account);
                                                accountListDeleted.add(account.id);
                                           }
                                           deletedCableUnitMap.put(account.name, account.name);
                                        }*/
                                        System.debug('Hierarcly selection');
                                        System.debug('Outside Admin Selection'+accountListCreated.size()+'and profile'+contact.UserProfile__c+'**'+portalAdminUser);
                                       if(accountListCreated.size() == 0 && contact.UserProfile__c==portalAdminUser){
                                         System.debug('Inside Admin Selection'+accountListCreated.size()+'and profile'+contact.UserProfile__c+'**'+portalAdminUser);
                                         System.debug('Admin List'+accountListForAdmin+'its Ids'+accountListForAdminId);
                                         accountListCreated.addAll(accountListForAdmin);
                                         accountListCreatedId.addAll(accountListForAdminId);     
                                         System.debug('AccountLIstSize&&&&'+accountListCreated.size()); 
                                       }else if(accountListCreated.size() == 0){
                                            System.debug('Inside ElseIf AccountLIstSize&&&&'+accountListCreated.size());    
                                            ApexPages.Message errorMsg = null; 
                                            errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_Need_OneAccount_Error);
                                            ApexPages.addMessage(errorMsg); 
                                            errorChk = true; 
                                            return null; 
                                        }
                                       if(accountListCreated.size() > 0){
                                        /* for(Account hierarchy1 : accountListCreated){
                                          if(hierarchy1.Type == 'Kunde'){
                                            pageFlag = true;
                                            break;
                                          }
                                         }*/
                                         if(!pageFlag){
                                            ApexPages.Message errorMsg2 = null; 
                                            errorMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_HierarchyType_WithoutCableUnit);
                                            ApexPages.addMessage(errorMsg2);    
                                            errorChk = true; 
                                            return null; 
                                         }
                                       }
                                       system.debug('$before$'+accountListCreated);
                                        System.debug('BEFORE CREATING USER Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
                                       if(!PortalUserService.isMandatoryInfoMissingOnCU(accountListCreated)){
                                           System.debug('** CREATING PORTAL USERInside mandatory fields of portal user service **');
                                           user = service.createPortalUser(getContact()); // create user
                                       }else{
                                           System.debug('#Inside Else#');   
                                           ApexPages.Message errorMsg = null; 
                                           errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mandatory field missing on CU');
                                           ApexPages.addMessage(errorMsg);
                                           //exceptionHandler.handleException('','save()',false,false);
                                           return null;
                                        }   
                                    // user = service.createPortalUser(getContact()); // create user
                                        service.updateAccountAssignmentNew(user, contact, accountListCreated, deletedCableUnitsList, accountListDeleted);
                                        
                                        if(accountListCreated.size() > 50){
                                          ApexPages.Message pendingMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_PendingCreation);
                                          ApexPages.addMessage(pendingMsg);
                                          disableFlag = true;
                                          System.debug('*****accountListCreated.size()--'+accountListCreated.size());
                                          //newPage.getParameters().put('status', 'pendingcreation');
                                          return null;
                                        }else{
                                            statusAssignment = true;
                                            return null;
                                        }
                        
                           }else if(getUser() == null && contact.Enable_Customer_Portal_User__c == false)  {
                                ApexPages.Message errorMsg = null; 
                                errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_EnableUser_ChkBx_Select);
                                ApexPages.addMessage(errorMsg); 
                                errorChk = true; 
                                return null;     
                           }
                           return null;
                       }
                    }
            /*  }else{
                  ApexPages.Message errorMsg = null; 
                  errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_KissPartyId_To_Be_Generated);
                  ApexPages.addMessage(errorMsg);   
                  errorChk = true; 
                  if(tempFlag == true){
                    integer j;
                    j = 10/0;
                  }
                  return null;  
                } */
               
            }catch(Exception e){
            //  System.debug('print ::' + e.getDmlType(0));
                System.debug('save else---------------'+e.getMessage());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                exceptionHandler.handleException(e,'save()',false,false,null,'Medium');
                return null;
            }   
        }

            @future
            public static void deactivateUser(Id tmpId){
                List<User> tmpuser=[Select Id,IsActive,ProfileId,ContactId from User where Id=:tmpId];
                if(tmpuser.size() > 0){
                    tmpuser[0].IsActive=false;
                    update tmpuser[0];
                    System.debug('After Update user');
                }   
            } 
            
             @future 
     public static void updateUserActive(Id userId, String userProfile){
          List<User> updateUser = [Select id, ProfileID, Profile.Name, IsActive, firstname, lastname from user where id=:userId];
                
          List<Profile> profile = [Select Id, name from profile where name = : userProfile];
                if(updateUser.size() > 0){
                    if(profile[0] != null){
                        updateUser[0].ProfileId = profile[0].Id;
                    }
                    updateUser[0].isActive = true;
                    update updateUser[0];
                }
        
     }
     
     /*public void callAdditionalMethods(){
       ObjectStructureMap maps = new ObjectStructureMap();
       maps.nodeId = '1';
       maps.levelFlag = new List<Boolean>();
       maps.closeFlag = new List<Boolean>();
       maps.nodeType = 'a';
       maps.currentNode = true;
       maps.account = new Account();
       maps.setnodeId(maps.getnodeId());
       maps.setlevelFlag(true);
       maps.getlevelFlag();
       maps.setlcloseFlag(true);
       maps.getcloseFlag();
       maps.setnodeType(maps.getnodeType());
       maps.setcurrentNode(maps.getcurrentNode());
       maps.setaccount(maps.getaccount());
     }*/
     
     //testing priyanka
     /*public List<cObjectStructureMap> getTestObjectStructure(){
            Contact con = [Select id, accountId, name, firstname, lastname, email, MobilePhone, 
                        HomePhone, Phone, Street_P__c, Street_P__r.Name From Contact  where id = :contactId LIMIT 1];
            Map<ID, ID> params = portalUserUtil.getAssignedCableUnits(con.Id);
            if(objectStrList == null){
                    asm.clear();
                    if(objectStrList == null){
                        objectStrList = new List<cObjectStructureMap>();
                    }  
                    asm = testformatObjectStructure(CurrentId);
                    for(ObjectStructureMap objectStructure : asm) {
                          cObjectStructureMap objmap = new cObjectStructureMap(objectStructure);
                          if (params.containsKey(objmap.pos.account.id)){
                              objmap.selected = true;
                              objmap.prevselected = true;
                          }      
                          objectStrList.add(objmap); 
                    }
            } 
            System.debug('objectStrList'+objectStrList);
            return objectStrList;
        }*/
     public Integer cnt {get;set;}
     public Map<Id,Id> mainKundeList {get;set;}
     public Map<Id,Id> kundeList {get;set;}
     public List<String> nodeSortListTest = new List<String>{};
     
     /*public void createChildNodes(Map<Id,Id> mapIdList,String parentId){
        System.debug('createChildNodes----called');
        Map<Id,Id> mapIdParent = new Map<Id,Id>();
        System.debug('createChildNodes----accntStrList---'+accntStrList);
        System.debug('createChildNodes----accntStrList size--'+accntStrList.size());
        for(Account acnt : accntStrList){
            if(mapIdList != null && mapIdList.size() > 0){
             mapIdParent = mapIdList;
             System.debug('mapIdParent----'+mapIdParent);
             System.debug('mapIdParent size----'+mapIdParent.size());
            }
            if(parentId == acnt.ParentId || (mapIdParent.size() > 0 && mapIdParent.get(acnt.Id) == parentId)){
                if(acnt.type == 'Kunde'){
                    /*
                    if(mainKundeList.get(acnt.Id) == null){
                        cnt = 0;
                        kundeList = new Map<Id,Id>();
                        kundeList.put(acnt.Id,acnt.Id);
                        mainKundeList.put(acnt.Id,acnt.Id);
                        for(Account temp : accntStrList){
                            if(temp.type == 'Kunde' && temp.ParentId == currentId && (kundeList.get(temp.Id) == null)){
                                mainKundeList.put(temp.Id,temp.Id);
                                kundeList.put(temp.Id,temp.Id);
                                cnt++;
                            }
                        }
                    }//
                }
                else{
                    mapIdParent.put(acnt.Id,acnt.ParentId);
                    System.debug('else part mapIdParent---'+mapIdParent);
                    System.debug('else part mapIdParent size---'+mapIdParent.size());
                    createChildNodes(mapIdParent,acnt.Id);
                }
           }
        }
     }*/
     
     
       // Query Account from top down to build the ObjectStructureMap //
       /*public ObjectStructureMap[] testformatObjectStructure(String currentId){
            List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
            masm.clear();
            List<Account> al = new List<Account>{};
            List<ID> currentParent = new List<ID>{};
            Map<ID, String> nodeList = new Map<ID, String>{};
            List<String> nodeSortList = new List<String>{};
            List<Boolean> levelFlag = new List<Boolean>{};
            List<Boolean> closeFlag = new List<Boolean>{};
            String nodeId = '0';
            String nodeType = 'child';
            Integer count = 0;
            Integer level = 0;
            Boolean endOfStructure = false;
            // Find highest level obejct in the structure//
            //currentParent.add(GetTopElement(currentId));
            currentParent.add(currentId);
            System.debug('Current   Parent Id'+currentParent);
            // Loop though all children
            Map<Id, Id> mapIDParent =  new Map<Id, Id>();           
            Map<Id, Account> mapIDAccount =  new Map<Id, Account>();
            al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.Customer_Type__c, a.Cable_Unit__r.Building_Type__c, a.Cable_Unit__r.Name, a.Customer_Segment_Lookup__c, a.Cable_Unit__r.Housing_Ownership__c, a.Cable_Unit__r.Housing_Type__c, a.Cable_Unit__r.Municipaly__c, a.Cable_Unit__r.Cable_Unit_Post_Code__c, a.Cable_Unit__c FROM Account a WHERE a.SuperiorAccount__c IN :CurrentParent or id IN: CurrentParent ORDER BY a.Name];
            List<Id> hierTypeId = new List<Id>();
            for(Account a :  al){
                if(a.Type == 'Hierarki'){
                  hierTypeId.add(a.Id);
                }
            }
            
           Map<Id,List<Id>> mapParentChilds = new Map<Id,List<Id>>();
           List<Id> tempList = new List<Id>(); 
      /*     for(Id hierId : hierTypeId){
                for(Account temp : al){
                    tempList = new List<Id>();
                    System.debug('before temp.ParentId---'+temp.ParentId);
                    System.debug('before hierId---'+hierId);
                    if(temp.ParentId == hierId){
                        System.debug('temp.ParentId---'+temp.ParentId);
                        System.debug('hierId---'+hierId);
                    tempList.add(temp.Id);
                    }
                }
             mapParentChilds.put(hierId,tempList);
           }
         //
           for (Integer i = 0 ; i < hierTypeId.size(); i++){
            tempList = new List<Id>();
               for(Account temp : al){
                    
                    System.debug('before temp.ParentId---'+temp.ParentId);
                    System.debug('before hierTypeId[i]---'+hierTypeId[i]);
                    if(temp.ParentId == hierTypeId[i]){
                      System.debug('after temp.ParentId---'+temp.ParentId);
                      System.debug('after hierTypeId[i]---'+hierTypeId[i]);
                       tempList.add(temp.Id);
                    }
                }
                if(tempList.size() > 0){
                   mapParentChilds.put(hierTypeId[i],tempList);
                }
           }
            
           List<Id> parentIdSet = new List<Id>();
           
          System.debug('mapParentChilds---'+mapParentChilds);
          System.debug('mapParentChilds size---'+mapParentChilds.size());
           List<Id> idList = new List<Id>();
           idList.add(currentId);
           Integer startIndex = 0;
           Integer endIndex = 0;
            List<Id> childList =  new  List<Id>();
            Map<Id,Account> mainMap = new Map<Id,Account>();
            for(Account tempAcc : al){
                mainMap.put(tempAcc.Id,tempAcc);
                
            }
           do {
               Id tempID = idList[startIndex];
               childList.clear();
               childList = mapParentChilds.get(tempID);
               startIndex += 1;
               endIndex += childList.size();
               for(Id childId : childList){
                 idList.add(childId);   
               }
               System.debug('childList---'+childList);
               System.debug('childList size---'+childList.size());
               for (Integer i = 0 ; i < childList.size(); i++){
                    // Change below
                        Account a = mainMap.get(childList[i]);
                        // if(al[i].Anlaeg_Name__c != null && al[i].Anlaeg_Name__c != ''){
                                a.Anlaeg_Name__c = ' '+al[i].Anlaeg_Name__c;
                       //  } 
                        /* else {
                             a.Anlaeg_Name__c = ' ';
                         }//
                
                        // if(al[i].Cable_Unit_No__c != null && al[i].Cable_Unit_No__c != ''){
                             a.Anlaeg_No__c = ' -  '+al[i].Cable_Unit_No__c+ ' ';
                        // } else {
                        //     a.Anlaeg_No__c = ' ';
                        // }
                          //
                         if (level > 0){
                              nodeId=NodeList.get(a.ParentId)+'.'+String.valueOf(i);
                         }else {
                              nodeId=String.valueOf(i);
                         }  
                       //  System.debug('formatObjectStructure levelflag----'+levelFlag); 
                         masm.put( NodeID, new ObjectStructureMap(nodeID,levelFlag,closeFlag,nodeType,false,false,a));
                         currentParent.add(a.id);
                         nodeList.put(a.id,nodeId);
                         nodeSortList.add(nodeId);
                    }
            
            // Account structure must now be formatted//
            NodeSortList.sort();
           System.debug('NodeSortList--->'+NodeSortList);
            for (Integer i = 0; i < NodeSortList.size();i++){
               List<String> pnl = new List<String> {};
               List<String> cnl = new List<String> {};
               List<String> nnl = new List<String> {};
               if (i > 0){
                   String pn = NodeSortList[i-1];
                   pnl = pn.split('\\.',-1);
               }
               String cn = NodeSortList[i];
               System.debug('test cn value--'+cn);
               cnl = cn.split('\\.',-1);
               System.debug('test cnl  value---'+ cnl);
               if (i < NodeSortList.size()-1){
                  String nn = NodeSortList[i+1];
                  nnl = nn.split('\\.',-1);
               }
               ObjectStructureMap tasm = masm.get(cn);
                if (cnl.size() < nnl.size()){
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
                System.debug('test tasm.nodeType--'+tasm.nodeType);
                System.debug('test cnl**--'+cnl);
                tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType); 
                System.debug('test tasm.levelFlag---'+tasm.levelFlag);
                if (tasm.account.id == currentId) {
                    tasm.currentNode=true;
                }
                asm.add(tasm);
               }
               if(NodeSortList.size()> 0){
                asm[0].nodeType='start';
               }
              
            }while (startIndex != endIndex);
             return asm;
        /*   if(mapParentChilds.size() > 0){
             parentIdSet.addAll(mapParentChilds.keySet());
           }//
          // System.debug('parentIdSet---'+parentIdSet);
          // System.debug('parentIdSet size---'+parentIdSet.size());
          
            
        }*/
        
   public PageReference redirectPage(){ 
        PageReference customPage;
        System.debug('*****contact.Id---'+contact.Id);
        List<Contact> conList = new List<Contact>();
        conList = [Select id, HierarchyAccount__c From Contact where id = :contact.Id];
        if(conList != null && conList.size() > 0){
        Contact con = new Contact();
        con = conList[0];
        //Contact con = [Select id, HierarchyAccount__c From Contact  where id = :contact.Id LIMIT 1];
        System.debug('con HierarchyAccount__c---'+con.HierarchyAccount__c);
	        if(con.HierarchyAccount__c != null){
	             userId = [select Id,IsActive from user where contactId =: con.Id];
	             if(userId.size() > 0){
	                System.debug('Inside One');
	                displayuserSection = true;
	          //   customPage= new PageReference('/apex/AccountAssignmentContactPage');
	         //    customPage.getParameters().put('contactId', con.id);
	             }
	             else{
	                System.debug('Inside Two');
	                displayuserSection = true;
	          //   customPage= new PageReference('/apex/AccountAssignmentContactPage');
	          //   customPage.getParameters().put('contactId', con.id);
	             } 
	        }else {
	             userId = [select Id,IsActive from user where contactId =: con.Id];
	             if(userId.size() > 0){
	                System.debug('Inside Three'); 
	                displayErrorSection = true;
	          //   customPage= new PageReference('/apex/AccountAssignmentErrorPage');
	          //   customPage.getParameters().put('contactId', con.id);  // added
	             }
	             else{
	                System.debug('Inside Four');
	                displaynoUserSection = true;
	          //   customPage= new PageReference('/apex/AccountAssignmentErrorPageNoUser');
	         //    customPage.getParameters().put('contactId', con.id);   
	             } 
	        }
        }
      //  customPage.setRedirect(true);
        return null;
   }
   
   
   public PageReference refresh(){ 
    
        return null;
   }
   
   
}