public class ViewPortalUserController {
/*            
    public String portalUserProfile{get; set;}
    public String portalAdminUser{get; set;}
    public String portalBrugerRole{get; set;}
    public Boolean errorFlag {get; set;}
    public ID accID,contactId;
    
    public String currentId;
    public String siteCoreUrl{get; set;}
    public List<Integer> maxLevel = new List<Integer>{};
    public List<cObjectStructureMap> objectStrList {get; set;}
    public List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};  
      
    public Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
     
    public Address__C address{get; set;} */
    public String portalUserProfile{get; set;}
    public String portalAdminUser{get; set;}
    public String portalBrugerRole{get; set;}
    public Boolean errorFlag {get; set;}

    transient ID accID,contactId;
    
    public String currentId;
    public String siteCoreUrl{get; set;}
    public List<Integer> maxLevel = new List<Integer>{};
    transient List<cObjectStructureMap> objectStrList {get; set;}
    transient List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};  
      
    transient Map<String, ObjectStructureMap> masm = new Map<String, ObjectStructureMap>{};
     
    public Address__C address{get; set;}
    PortalUserUtil portalUserUtil = new PortalUserUtil();
    
    public string objectStrListJson {get;set;}

    public ID getAccID() {
      return accID;
    }

    public void setAccID(ID acountID) {
      accID= acountID; 
    } 

    public void setcurrentId(String cid) {
       currentId = cid;
    }
        
    public Contact contact;
     
    public Contact getContact(){
       System.debug('--------------------------- Here is the call for get Contact -----------------------------------------  ');
       return contact;
    }

    public void setContact(Contact c){
        this.contact = c; 
    }
    // Variable added to generate exception for test classes
    public Boolean tempTestFlag = false;
                     
    public ViewPortalUserController(){
      portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
      portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
      portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
      siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
      contactId = ApexPages.CurrentPage().getParameters().get('contactId');
      setContactDetails();
      errorFlag = false;
      tempTestFlag = false;
      getObjectStructure();
      objectStrListJson = JSON.serialize(objectStrList);
    }
   
   public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewPortalUserController','Administration of portal users');
   
   public Map<ID, ID> getAssignedCableUnits(){
        try {
            ID contactId = ApexPages.CurrentPage().getParameters().get('contactId');
            System.debug('-------contactId ---------' + contactId);
            List<Account_Contact_Role__c> acrlist = [Select a.Customer__c From Account_Contact_Role__c a where a.Contact__c =:contactId];
            Map<ID, ID> params = new Map<ID, ID>();
            for(Account_Contact_Role__c acr : acrlist) {
                params.put(acr.Customer__c, acr.Customer__c);
            }
            System.debug('-------params size ---------' + params.size());
            return params;
        }  catch (Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                errorFlag = true;
                return null;
         }   
    }
     // save button is clicked  
  /* Commented during TestClass Creation as it was not used anywhere    
     public PageReference save() { 
       try {    
         System.debug('Contact Last Name --------------------------------------------------------> ' + contact.lastName);
         update contact;
         List<AccountShare> aShare = new AccountShare[0];
         ID contactId = ApexPages.CurrentPage().getParameters().get('contactId');
         User u1 = [Select u.Id  From User u where u.Contactid =:contactId LIMIT 1];     
                        
         for(cObjectStructureMap objectStructureMap : getObjectStructure()){
                Account account = objectStructureMap.pos.account;
                    
                if(objectStructureMap.selected){
                    System.debug(' ObjectStructureMap.selected  ' +objectStructureMap.selected); 
                    
                    aShare.add(new AccountShare (AccountId=account.ID, accountAccessLevel='Edit', 
                    caseAccessLevel='Edit', opportunityAccessLevel='Edit', UserOrGroupId=u1.id));

                    // List<Lookup_Contact_Roles__c> userRoleList = [Select id from Lookup_Contact_Roles__c  where Name = 'Portal User'];
                     List<Lookup_Contact_Roles__c> userRoleList = [Select id from Lookup_Contact_Roles__c  where id =: ServiceCenterSingleton.getInstance().getUserRoleId()];

                     ID roleId;             
                     if(userRoleList .size() > 0) {                   
                          roleId= userRoleList [0].id;                           
                     } 
                                 
                    Account_Contact_Role__c acr = new Account_Contact_Role__c();  
                    acr.Customer__c = account.ID;  
                    acr.Contact__c= contact.id;  
                    acr.Role__c =  roleId;
                    upsert acr;  
                 }
             }
           
           if (aShare.isEmpty() == false) {           
               upsert aShare;
           }
           return Page.Contact_Create_Thankyou; 
       }catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
        }             
     }
     */
  
     // Return ObjectStructureMap to page
            //
     public ID getAccountId(){
        try {
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            }
            List<Contact> contList = new List<Contact>();
            User[] user = [select contactid from User where id =:UserInfo.getUserId()];     
            if(user != null && user.size() > 0){       
              contList = [select accountId,HierarchyAccount__c from Contact where id =:user[0].contactid limit 1];
            }
            ID accountId;             
            if(contList.size() > 0) {                   
               //accountId =  contList[0].accountId; 
              if(contList[0].HierarchyAccount__c != null){
                accountId =  contList[0].HierarchyAccount__c;
              }                          
            } 
            return  accountId;
         } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
         }       
     } 

  public void setContactDetails(){
    try {
        // if Statement added to generate exception for test classes
        if(tempTestFlag){
                integer i;
                i = 5/0;
        }
        Contact con = [Select id, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__c, Street_P__r.Name,Status__c From Contact  where id = :contactId LIMIT 1];
        address = [Select Street__c, HouseNumber__c, Entrance__c,Door_No__c, Floor__c, Postcode__c, Town__c from Address__C where id =: con.Street_P__c];     
        getStreetForAccount(getAccountId(), con);
        setContact(con);
     }catch(Exception e){
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
        errorFlag = true;
     }         
   }
            
  public List<cObjectStructureMap> getObjectStructure(){
       try {
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            } 
            System.debug('--------------------------- Here is the call for getObjectStructure -----------------------------------------  ');
            //Map<ID, ID> params = getAssignedCableUnits();
             Map<ID, ID> params = portalUserUtil .getAssignedCableUnits(contactId);
             asm.clear();
             if(objectStrList == null){
                objectStrList = new List<cObjectStructureMap>();
             }  
            if (currentId == null) {
                currentId =  getAccountId(); //System.currentPageReference().getParameters().get('id');
            }
            //SC_SObjectIDMandatory
            //System.assertNotEquals(currentId,null,'sObject ID must be provided');
            if(currentId != null){
             System.assertNotEquals(currentId,null,Label.SC_SObjectIDMandatory);
             asm = formatObjectStructure(CurrentId);
            }
            if(asm != null){
                for(ObjectStructureMap objectStructure : asm) {
                     cObjectStructureMap objmap = new cObjectStructureMap(objectStructure);
                     if (params.containsKey(objmap.pos.account.id)){
                         objmap.selected = true;
                     }      
                     objectStrList.add(objmap); 
                }
            }
            return objectStrList;
      }catch(Exception e){
         ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
         ApexPages.addMessage(errorMsg);
         errorFlag = true;
         return null;
      }     
    }
    // Query Account from top down to build the ObjectStructureMap
    //
    public ObjectStructureMap[] formatObjectStructure(String currentId){
       try {
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
            currentParent.add(currentId);
            // Loop though all children
             while (!endOfStructure ){
                if(level==0){
                    al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id,a.Cable_Unit__r.Name FROM Account a WHERE a.id IN :CurrentParent ORDER BY a.Name];
                } else {
                    al = [SELECT a.Anlaeg_Name__c, a.Anlaeg_No__c, a.Cable_Unit_No__c, a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id,a.Cable_Unit__r.Name FROM Account a WHERE a.ParentID IN :CurrentParent ORDER BY a.Name];
                }
                if(al.size() == 0){
                    endOfStructure = true;
                } else {
                    currentParent.clear();
                    for (Integer i = 0 ; i < al.size(); i++){
                        Account a = al[i];
                        if(al[i].Anlaeg_Name__c != null && al[i].Anlaeg_Name__c != ''){
                            a.Anlaeg_Name__c = ' '+al[i].Anlaeg_Name__c;
                        } else {
                            a.Anlaeg_Name__c = ' ';
                        }
                    /*    if(al[i].Anlaeg_No__c != null && al[i].Anlaeg_No__c != ''){
                            a.Anlaeg_No__c = ' -  '+al[i].Anlaeg_No__c+ ' ';
                        } else {
                            a.Anlaeg_No__c = ' ';
                        }  */
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
                    level++;
                }
            }
            // Account structure must now be formatted
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
              }else if (cnl.size() > nnl.size()){
                        tasm.nodeType='child_end';
                        tasm.closeFlag=setcloseFlag(cnl, nnl, tasm.nodeType);
               }else{
                    tasm.nodeType='child';
               }
               tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType); 
               if(tasm.account.id == currentId) {
                  tasm.currentNode=true;
               }
               asm.add(tasm);
            }
            asm[0].nodeType='start';
            asm[asm.size()-1].nodeType='end';
            return asm;
                    
         }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
         }      
    }
    
    // Determin parent elements relationship to current element
    //
    public List<Boolean> setlevelFlag(List<String> nodeElements, String nodeType){
    try {
         // if Statement added to generate exception for test classes
        if(tempTestFlag){
                integer i;
                i = 5/0;
        } 
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
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
        ApexPages.addMessage(errorMsg);
        errorFlag = true;
        return null;
      }         
    }
    
    // Determin if the element is a closing element
    public List<Boolean> setcloseFlag(List<String> cnl, List<String> nnl, String nodeType){
        try {
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            } 
            List<Boolean> flagList = new List<Boolean>{};
            String searchNode = '';
            String workNode = '';
            Integer cn = 0;
            for(Integer i = nnl.size(); i < cnl.size();i++){
                        flagList.add(true);
            }
            return flagList;
         } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
        }         
    }

    // Determin if Element is the bottom node
    //    
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

    // Find the tom most element in Heirarchy
    //    
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
       try {
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            }
            User user = [select contactid from User where id =:UserInfo.getUserId()];            
            List<Contact> contList = [select HierarchyAccount__c,accountId from Contact where id =:user.contactid limit 1];
            ID accountId;             
            if(contList.size() > 0) {                   
                //accountId =  contList[0].accountId;                           
                accountId =  contList[0].HierarchyAccount__c;
            } 
            setAccID(accountId);
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
                    level++;
                }
            }
            System.debug('---accountsToShare----'+accountsToShare.size()); 
            return accountsToShare;
       }catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            errorFlag = true;
            return null;
       }    
     }
    
     public List<cAccount> accountList {get; set;}
          
     public List<cAccount> getAccounts(){
       try {
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            }
            if(accountList == null){
                accountList = new List<cAccount>();
                List<ID> cableUnitIds = getAllRelatedCableUnits();
                if(cableUnitIds != null){ 
                    List<Account> accounts = [select Anlaeg_No__c, Name, id from Account where ID in :cableUnitIds];
                    for(Account a : accounts) {
                        accountList.add(new cAccount(a)); 
                    }
                }
            }    
           return accountList;
       }catch(Exception e){
         ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
         ApexPages.addMessage(errorMsg);
         errorFlag = true;
         return null;
       }    
     }   

     /**This method pre-populates the data in the Street field of the contact from the acct object. */ 
    public PageReference getStreetForAccount(ID accountId, Contact contact){
      try{ 
            // if Statement added to generate exception for test classes
            if(tempTestFlag){
                integer i;
                i = 5/0;
            }
            boolean acctAddrFlag;
            boolean contactAddrFlag;
            List<Account> acct = [Select a.Street_YK__r.Name, a.Street_YK__c, a.Name, a.Id From Account a where id=:accountId limit 1]; 
            system.debug('THE ACCT IS '+acct);
            if(acct.size() > 0){
                String streetName = acct[0].Street_YK__r.Name;
                //check if streetName is null for acct
                acctAddrFlag = checkIfObjectIsNull(acct[0].Street_YK__c);
                contactAddrFlag = checkIfObjectIsNull(contact.Street_P__c);
                if(!acctAddrFlag){
                    System.debug('###Not null--- check value fo acctAddrFlag ###'+acctAddrFlag);
                    // for cases where we have the addr of contact already populated.
                    if(!contactAddrFlag){
                        System.debug('###Not null--- check value fo contactAddrFlag ###'+contactAddrFlag);
                        //do not change the Contact Address with Acct Address       
                        contact.Street_P__c = contact.Street_P__c;
                     }else{
                        //change the Contact Address with Acct Address
                        System.debug('###NULL--- check value fo contactAddrFlag ###'+contactAddrFlag);
                        contact.Street_P__c = acct[0].Street_YK__c;
                     }
                }else{
                    System.debug('###ACCT ADDR IS NULL ###');
                    // acctAddrFlag is null, check if contactAddrFlag is null.
                    if(!contactAddrFlag){
                        // Dont Change the Contact Address
                        contact.Street_P__c = contact.Street_P__c;
                    }
                }    
              system.debug('The contact.Street_P__c is <<<<<:'+contact.Street_P__c);
            }   
           }catch (Exception e) {
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
              ApexPages.addMessage(errorMsg);
              errorFlag = true;
              return null;
          }
      return null;
    }
            
    private boolean checkIfObjectIsNull(Id addrReceived){
        if(addrReceived != null){
        // NOT NULL 
            return false;
        }else{
            //NULL
            return true;    
        } 
     }
   
    public PageReference cancel() {
      return Page.ManagePortalUsersPage;   
    }
    public PageReference backToManagePortalUserPage(){
        // Change According from Partial Page Reference to Absolute
        //String newPageUrl = '/apex/ManagePortalUsersPage';
        PageReference newPage = Page.ManagePortalUsersPage;
        //PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
        
    }
    
}