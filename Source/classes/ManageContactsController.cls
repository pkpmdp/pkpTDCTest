/* Purpose : To display the contact list and redirect to View,Edit,new creation of contact Page.*/
public class ManageContactsController extends PageControllerBase{
    /*--- Property and variable Region -------*/
    public ID accID;
    public string cableUnitNumber;  
    public String roleFirstName;
    public String roleStr;
    public string cableUnitName{get;set;}
    public String userSelectedPage{ get; set;}
    public String portalBrugerRole {get; set;}
    public String siteCoreUrl{get; set;}
    public boolean successFlag {get;set;}
    public boolean warningFlag {get;set;}
    public boolean displayFlag {get; set;}
    public String accountId{get;set;}//support-5377
    public Boolean renderSection{get;set;}//support-5377
    public List<Contact> contactAddress {get; set;}
    public List<Account_Contact_Role__c> contactRoles {get;set;}
    public List<cAccount_Contact_Role> finalListAcr = new List<cAccount_Contact_Role>(); 
    public List<cAccount_Contact_Role> finalExpList = new List<cAccount_Contact_Role>();
    Map<Id,String> contactMapId = new Map<Id,String>();
    // added for 312
    Map<Id,String> contactTotalInsightMapId = new Map<Id,String>();
    public Boolean tempFlag;
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ManageContactsController','Manage Contacts');
    public String getRoleFirstName(){
    	return roleFirstName;
    }
    public void setRoleFirstName(String roleFirstName){
    	this.roleFirstName=roleFirstName;
    }
    public String getRoleStr(){
    	return roleStr;
    }
    public void setRoleStr(String roleStr){
    	this.roleStr = roleStr;
    }
    public String deleteFlag{ 
        get{return deleteFlag;}
        set{deleteFlag=value;} 
    }
    public ID getAccID(){ 
      return accID; 
    }
    public void setAccID(ID acountID){ 
     accID= acountID; 
    }  
    public String getCableUnitNumber(){ 
      return cableUnitNumber;
    }
    public void setCableUnitNumber(String cableUnitNumber) {
      this.cableUnitNumber= cableUnitNumber; 
    }
    public Boolean contactSize{get;set;}
/*--- End of Property and variable Region -------*/           
  public ManageContactsController(){ 
    try { 
    	displayFlag = true;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        userSelectedPage = Label.SC_kontakterPage;
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');//start-5377
        Boolean cableUnitNotMatch = false;
        renderSection = true;
        list<Account> accList = new list<Account>();
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
       if(!accList.isEmpty()){
            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
           if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
            }else{
            	fetchContact();
            	setStatus();
        		if(ApexPages.CurrentPage().getParameters().get('cableunitnumber') != null){
          		cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
        	}
    } 
        }
        else{
            renderSection=false;
        }
        //End support-5377
    }catch (Exception e){
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
            ApexPages.addMessage(myMsg);
    }       
  }         
/*---End of Constructor ------*/
 
/*---- Public m/d Region -----*/
 public void setCableUnitName(){
   List<Cable_Unit__c> cableUnitList = [Select c.name from Cable_Unit__c c where  c.Cable_Unit_No__c =:ApexPages.CurrentPage().getParameters().get('cableunitnumber')];
   if(cableUnitList.size() > 0){
      cableUnitName = cableUnitList[0].name;
   }
 }    
 public void setStatus(){
    String status = apexpages.currentpage().getparameters().get(contactConstClass.STATUS);
    String isAnotherHierarchy=apexpages.currentpage().getparameters().get('isAnotherHierarchy');
    if(status == null){
       status = contactConstClass.INITIALSTATUS; 
    }
    ApexPages.Message myMsg;
    if(isAnotherHierarchy == 'true'){
       myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C2);
       ApexPages.addMessage(myMsg);
       warningFlag = true;
       successFlag = false;
    }
    if(status == contactConstClass.EDITMSG){ 
       String emailFlag = apexpages.currentpage().getparameters().get('emailFlag');
       String isInExistingHierarchy = apexpages.currentpage().getparameters().get('isInExistingHierarchy');
       String isExistAnotherHierarchy = apexpages.currentpage().getparameters().get('isExistAnotherHierarchy');
       String freeFlyingContact = apexpages.currentPage().getParameters().get('freeFlyingContact');
       if(freeFlyingContact != null && freeFlyingContact == 'true'){
         myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C3);
         ApexPages.addMessage(myMsg);
         successFlag = true;
       }else{
         if(emailFlag != null && emailFlag == 'false'){
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C3);
           ApexPages.addMessage(myMsg);
           successFlag = true;
         }else if(isInExistingHierarchy != null && isInExistingHierarchy == 'true'){
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C4);
           ApexPages.addMessage(myMsg);
           warningFlag = true;
         }else if(isExistAnotherHierarchy != null && isExistAnotherHierarchy == 'true'){
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C2);
           ApexPages.addMessage(myMsg);
           warningFlag = true;
         }else{
           myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C3);
            ApexPages.addMessage(myMsg);
            successFlag = true;
          }
        }
     }else if(status == contactConstClass.CREATEMSG) {
      	   myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C1);
           ApexPages.addMessage(myMsg);
           successFlag = true;
     } 
  }
  public void fetchContact(){
     try {
       ID accountId;
       Integer cntCount;
       String roleStr = '';
       // Added for 312
       String allInsightValues = ''; 
       String strQuery;
       String contactId;
       String uniqueContactID = '';
       Boolean currentStatus = false;
       Set<Id> cIdss = new Set<Id>();
       List<cAccount_Contact_Role> listAcr = new List<cAccount_Contact_Role>();
       List<cAccount_Contact_Role> finalListAcr = new List<cAccount_Contact_Role>();
      String accId = apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID);
       if(apexpages.currentpage().getparameters().get('loggedInaccountId')!=null){
         accId= apexpages.currentpage().getparameters().get('loggedInaccountId');
       }
       String cableunitnumber = apexpages.currentpage().getparameters().get(contactConstClass.CABLEUNITNUMBER);
      
       if(cableunitnumber != null && cableunitnumber != ''){
       	 setCableUnitNumber(cableunitnumber);
       }
       if(accId == null ){ 
         Account account = [Select a.Id From Account a where a.Anlaeg_No__c =: cableunitnumber limit 10];
         if(account != null){
           accountId = account.id;
         }             
       }else{
       	 if(accId != null){ 
          accountId = accId;
       	 }
       }
       if(accountId != null){    
       setAccID(accountId);
       }
       User[] user = [select Id,ContactId,ProfileId from User where Id =: UserInfo.getUserId()];
       if(user.size() > 0){
          ID loggedInUserId= user[0].ContactId; 
          ID adminRoleID = ServiceCenterSingleton.getInstance().getAdminRoleId();
          ID userRoleID = ServiceCenterSingleton.getInstance().getUserRoleId();
       system.debug('accountId------------>'+ accountId+'loggedInUserId'+loggedInUserId);
       List<Account_Contact_Role__c> contact_Role= [Select a.Id, a.Last_Name__c,  a.RoleName__c,a.email__c,a.Contact__c, Total_Insight__c from Account_Contact_Role__c a where a.Contact__r.Status__c =: contactConstClass.ACTIVE and (a.Role__c != : adminRoleID  and a.Role__c !=: userRoleID) and a.Role__r.Visible_in_Service_Centre__c = true and a.Customer__c =: accountId ORDER BY Last_Name__c];
       if(contact_Role.size() > 0){
       	system.debug('$contact_Role$'+contact_Role.size());
        for(Account_Contact_Role__c acr : contact_Role){
         cAccount_Contact_Role cAcr;
         cAcr = new cAccount_Contact_Role(acr);
         if(!uniqueContactID.equals(acr.Contact__c) ){
            cAcr.accountId  = acr.Id;
            cAcr.contactName = acr.Last_Name__c;
            cAcr.roleName = acr.RoleName__c;  
            listAcr.add(cAcr); 
            cntCount = listAcr.Size()-1;
            roleStr = acr.RoleName__c;
            if(contactMapId.containsKey(listAcr[cntCount].accountId)){
               contactMapId.Remove(listAcr[cntCount].accountId);
            }
            // added for 312
            cAcr.totalInsightRoles = acr.Total_Insight__c;
            allInsightValues = acr.Total_Insight__c;
            if(contactTotalInsightMapId.containsKey(listAcr[cntCount].accountId)){
               contactTotalInsightMapId.Remove(listAcr[cntCount].accountId);
            }
            if(acr.RoleName__c.equalsIgnoreCase('Indbliksadresse')){
            	allInsightValues = acr.Total_Insight__c;
            }
            else{
            	allInsightValues = '';
            }
            contactTotalInsightMapId.put(listAcr[cntCount].accountId, allInsightValues);
            contactMapId.put(listAcr[cntCount].accountId  ,roleStr);
            listAcr[cntCount].roleName=roleStr;
            cIdss.add(acr.Contact__c);
            if(contactId == null){
                contactId='\'' +acr.Id+'\'';     
            }else{
                contactId+=',\'' +acr.Id+'\'';     
            } 
         }else{
            roleStr  = roleStr  + ',' + acr.RoleName__c; 
            // added for 312
            if(acr.RoleName__c.equalsIgnoreCase('Indbliksadresse')){
            	allInsightValues = allInsightValues + ',' +acr.Total_Insight__c;
            }
            else{
            	allInsightValues = allInsightValues + ',' + '';
            }
            cAcr.totalInsightRoles = allInsightValues;
            cAcr.roleName = roleStr;
            if(listAcr != null){
              if(contactMapId.containsKey(listAcr[cntCount].accountId)){
                contactMapId.Remove(listAcr[cntCount].accountId);
              }
              contactMapId.put(listAcr[cntCount].accountId  ,roleStr);
              listAcr[cntCount].roleName=roleStr;
              
              if(contactTotalInsightMapId.containsKey(listAcr[cntCount].accountId)){
               contactTotalInsightMapId.Remove(listAcr[cntCount].accountId);
            	}
            	contactTotalInsightMapId.put(listAcr[cntCount].accountId, allInsightValues);
            }
         }
         uniqueContactID = acr.Contact__c;
         currentStatus = true;
       } 
       } 
       //To fetch the contact details from ACR and passing the query to pagination controller.
       if(contactId != null){
	       strQuery=' Select a.Id, a.Contact__c, a.Customer__c, a.Last_Name__c, a.Email__c, a.First_Name__c, a.Home_Phone__c, a.Phone__c, a.Role__c, a.RoleName__c, a.Street_P__c, a.Total_Insight__c, a.Mobile_Phone__c,';
	       strQuery+=' Contact__r.FirstName, Contact__r.LastName, Contact__r.Phone, Contact__r.HomePhone, Contact__r.MobilePhone, Contact__r.AlternateEmail__c, Contact__r.Email from Account_Contact_Role__c a where a.Contact__r.Status__c=\'Aktiv\'';
	       strQuery+= '  and a.Id in ('+ contactId +') ORDER BY CreatedDate DESC';
       }else{
       	   strQuery=' Select a.Id, a.Contact__c, a.Customer__c, a.Last_Name__c, a.Email__c, a.First_Name__c, a.Home_Phone__c, a.Phone__c, a.Role__c, a.RoleName__c, a.Street_P__c, a.Total_Insight__c, a.Mobile_Phone__c,';
	       strQuery+=' Contact__r.FirstName, Contact__r.LastName, Contact__r.Phone, Contact__r.HomePhone, Contact__r.MobilePhone, Contact__r.AlternateEmail__c, Contact__r.Email from Account_Contact_Role__c a where a.Contact__r.Status__c=\'Aktiv\'';
	       strQuery+= '  and a.Id in ('+ '\''+ '\'' +') ORDER BY CreatedDate DESC';
       }
       if(strQuery != null){
       	 setQuery(strQuery);
         setExcelQuery(strQuery);
         displayFlag = true;
       }else{
       	 displayFlag = false;
       }
       if(cIdss.size() > 0){
         contactAddress = [select a.Street_p__r.Id,a.Street_p__r.name,a.street_p__r.House_No__c,a.street_p__r.Floor__c,a.street_p__r.Postcode__c,a.street_p__r.Town__c from Contact a where a.id in :cIdss];
         contactRoles = [Select a.Role__c, a.RoleName__c, a.Contact__r.Id, a.Contact__c From Account_Contact_Role__c a where a.Contact__r.Id in : cIdss];
       }
      }
    }catch(Exception e){
       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
       ApexPages.addMessage(errorMsg);
     }    
  }
/*--- Reading the conatct details and roles for the current account ------ old one*/
    public List<cAccount_Contact_Role> getContactsList(){ 
    try {
    	   finalListAcr = new List<cAccount_Contact_Role>(); 
          List<Account_Contact_Role__c> contact_Paging_Role = (List<Account_Contact_Role__c>)getRecords() ;
          if(contact_Paging_Role.size() > 0){
           for(Integer roleCount=0;roleCount< contact_Paging_Role.size();roleCount++){
             cAccount_Contact_Role cAcrRole;
             cAcrRole= new cAccount_Contact_Role(contact_Paging_Role[roleCount]);
             cAcrRole.firstName = contact_Paging_Role[roleCount].RoleName__c;
             cAcrRole.accountId  = contact_Paging_Role[roleCount].Customer__c;
             if(contact_Paging_Role[roleCount].First_Name__c != null && contact_Paging_Role[roleCount].First_Name__c != ''){
             	System.debug('@@@contact_Paging_Role[roleCount].First_Name__c@@@'+contact_Paging_Role[roleCount].First_Name__c);
             	cAcrRole.contactFName = contact_Paging_Role[roleCount].First_Name__c;
             	System.debug('@@@contact_Paging_RolecontactFName'+cAcrRole.contactFName);
             }
             if(contact_Paging_Role[roleCount].Last_Name__c != null && contact_Paging_Role[roleCount].Last_Name__c != ''){
             	System.debug('@@@contact_Paging_Role[roleCount].Last_Name__c@@@'+contact_Paging_Role[roleCount].Last_Name__c);
             	cAcrRole.contactLName = contact_Paging_Role[roleCount].Last_Name__c;
             	System.debug('@@@contact_Paging_RolecontactFName'+cAcrRole.contactLName);
             }
             if(cAcrRole.contactFName != null && cAcrRole.contactFName != '' && cAcrRole.contactLName != null && cAcrRole.contactLName != ''){
             		cAcrRole.contactName = cAcrRole.contactFName + '  ' + cAcrRole.contactLName;
             }else{
             		cAcrRole.contactName = 	cAcrRole.contactLName;
             }
             //cAcrRole.contactName = contact_Paging_Role[roleCount].First_Name__c + '  ' + contact_Paging_Role[roleCount].Last_Name__c;
             cAcrRole.phone = contact_Paging_Role[roleCount].Phone__c;
             cAcrRole.homePhone = contact_Paging_Role[roleCount].Home_Phone__c;
             cAcrRole.mobilePhone = contact_Paging_Role[roleCount].Mobile_Phone__c;
	         if(contact_Paging_Role[roleCount].Street_P__c!=null){
	             for(Contact contactadd : contactAddress){
	              if(contact_Paging_Role[roleCount].Street_P__c == contactadd.Street_p__r.Id){
	                cAcrRole.address = new Address__c();
	                cAcrRole.address.Town__c = contactadd.Street_p__r.Town__c;
	                cAcrRole.address.Postcode__c = contactadd.Street_p__r.Postcode__c;
	                cAcrRole.address.Name = contactadd.Street_p__r.Name;
	                cAcrRole.address.House_No__c = contactadd.Street_p__r.House_No__c;
	              }
	           }         
	         }else{
	            cAcrRole.address = new Address__c();
	         }         
             finalListAcr.add(cAcrRole); 
             finalListAcr[roleCount].roleName = contactMapId.get(contact_Paging_Role[roleCount].Id);
            }
          }//end of if
	        if(finalListAcr.size() > 0){
				contactSize = true;
				displayFlag = true;
			}else{
            	contactSize = false;
            	displayFlag = false;
            }
            return finalListAcr;
    } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
     }        
} 
/*---- Deleting all the contacts, the status will be set to inactive ------*/
  public PageReference deleteAllContact(){ 
     try {
        if(deleteFlag == 'true'){
            String accountId = getAccID();
            List<Contact> contactList = [Select c.id, c.Status__c from Contact c where c.id in (Select a.Contact__c from Account_Contact_Role__c a  where a.Customer__c =: accountId) and c.Status__c ='Aktiv']; 
            for(Contact contact: contactList){
                contact.Status__c = contactConstClass.INACTIVE;
                update contact;        
            } 
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO, contactConstClass.DELETEALLMSG);
            ApexPages.addMessage(myMsg);
            successFlag = true;
            warningFlag = false;
            String newPageUrl = contactConstClass.MANAGECONTACTURL;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true); 
            newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.DELETESTATUS);
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
             if(tempFlag == true){
            	integer i;
            	i = 10/0;
            }
            return newPage;
         }else{
         	 if(tempFlag == true){
            	integer i;
            	i = 10/0;
            }
         	return null;
         }
       }catch (Exception e){
        ApexPages.Message myMsg;
        myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
        ApexPages.addMessage(myMsg);
        exceptionHandler.handleException(e,'deleteAllContact()',false,false,cableUnitName,'Medium');
        return null;
      }     
    } 
    public PageReference deleteContact(){
  	System.debug('delete contact called');
    try{
            ID contactId = ApexPages.CurrentPage().getParameters().get('contactId');
            ID accountId = ApexPages.CurrentPage().getParameters().get(contactConstClass.ACCOUNTID);
            String cableunitnumber = ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER);
            String roleName =ApexPages.CurrentPage().getParameters().get('roleName');
            ContactService contactService = new ContactService();
            contactService.deleteContact(contactId,accountId,cableunitnumber ,roleName);     
            fetchContact();
            ApexPages.Message myMsg;
			myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C6);
           ApexPages.addMessage(myMsg);
            successFlag = true;
            warningFlag = false;
          //  String newPageUrl = contactConstClass.MANAGECONTACTURL;
            String newPageUrl = contactConstClass.MANAGECONTACTURL;
            PageReference newPage = new PageReference(newPageUrl);
           // newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.DELETESTATUS);
            newPage.getParameters().put('status', 'deletedsuccessfully');
            newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, contactConstClass.CABLEUNITNUMBER);
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            return newPage;
   }catch (Exception e) {
	       ApexPages.Message myMsg;
	       myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
	       ApexPages.addMessage(myMsg);
   return null;
  }
 } 
/*----- Deleting the selected contact, status will be set to Inactive -------*/
 /* public PageReference deleteContact(){
    try{
       if(deleteFlag == 'true'){
            ID contactId = ApexPages.CurrentPage().getParameters().get('contactId');
            ID accountId = ApexPages.CurrentPage().getParameters().get(contactConstClass.ACCOUNTID);
            String cableunitnumber = ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER);
            String roleName =ApexPages.CurrentPage().getParameters().get('roleName');
            ContactService contactService = new ContactService();
            contactService.deleteContact(contactId,accountId,cableunitnumber ,roleName);     
            fetchContact();
            ApexPages.Message myMsg;
			myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.SC_C6);
            ApexPages.addMessage(myMsg);
            successFlag = true;
            warningFlag = false;
            String newPageUrl = contactConstClass.MANAGECONTACTURL;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.DELETESTATUS);
            newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, contactConstClass.CABLEUNITNUMBER);
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            return newPage;
       }else{
            return null;
       }
   }catch (Exception e) {
   	
	       ApexPages.Message myMsg;
	       myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
	       ApexPages.addMessage(myMsg);
   return null;
  }
 } */      
       
/*---- redirected to EditPage for updation of contact and role ------*/
   public PageReference editContact(){ 
      try { 
            String newPageUrl = contactConstClass.EDITCONTACTURL;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put('cableunitnumber', ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
            newPage.getParameters().put('contactId',ApexPages.CurrentPage().getParameters().get('contactId'));
            newPage.getParameters().put('accountId',apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID));
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            newPage.setRedirect(true);
            if(tempFlag == true){
            	integer i;
            	i = 10/0;
            }
            return newPage;
             
       } catch (Exception e) {
	        ApexPages.Message myMsg;
	        myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
	        ApexPages.addMessage(myMsg);
	        exceptionHandler.handleException(e,'editContact()',false,false,cableUnitName,'Medium');
	        return null;
       }         
   }
/*----- Redirected to HomePage-----*/
        // save button is clicked  
   public PageReference cancel(){
      try { 
            String cableUnitNumber = getCableUnitNumber();
            PageReference newPage = new PageReference(contactConstClass.CABLEUNITDETAILURL);
            if (getCableUnitNumber() != null){
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, getCableUnitNumber());
            }else{
                Account account = [Select a.Anlaeg_No__c From Account a where a.id =: getAccID() ];
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, account.Anlaeg_No__c);
            }
            newPage.getParameters().put(contactConstClass.ACCOUNTID, getAccID());
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            newPage.setRedirect(true);
             if(tempFlag == true){
            	integer i;
            	i = 10/0;
            }
            return newPage;
                
       } catch (Exception e) {
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
            ApexPages.addMessage(myMsg);
            exceptionHandler.handleException(e,'cancel()',false,false,cableUnitName,'Medium');
            return null;
       }     
    }
/*---- Reading logged in users details ------*/
    public User getLoggedInUserDetails(){
      User loggedInUser = [Select email, firstname, lastname from user where Id =: userInfo.getUserId() LIMIT 1];
      return loggedInUser;
    }
/*---- Redirected to Create Page to add the contact -----*/
        public PageReference addContact(){ 
            try { 
                String newPageUrl = contactConstClass.CREATECONTACTURL;
                PageReference newPage = new PageReference(newPageUrl);
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, getCableUnitNumber());
                newPage.getParameters().put(contactConstClass.ACCOUNTID, getAccID());
                newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
                newPage.getParameters().put('loggedInaccountId', getAccID());
                newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
                newPage.setRedirect(true);
                if(tempFlag == true){
                	integer i;
                	i = 10/0;
                }
                return newPage;
            } catch (Exception e) {
                ApexPages.Message myMsg;
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
                ApexPages.addMessage(myMsg);
                exceptionHandler.handleException(e,'addContact()',false,false,cableUnitName,'Medium');
                return null;
            }   
        }
      public boolean displayPopup {get; set;}     
      public void closePopup() {        
        displayPopup = false;    
      }     
      public void showPopup() {        
        displayPopup = true;    
      }
         /** This method is used to export contacts to a excel sheet.*/
    public PageReference exportExcel(){
        PageReference excelPage;
        excelPage= Page.exportexcelcontacts;
        return excelPage;
    }
    /** This method passes the list to exportexcelcontacts page */
     public List<cAccount_Contact_Role> getListExport(){ 
        try {
            finalExpList = new List<cAccount_Contact_Role>();  
            List<Account_Contact_Role__c> expList= (List<Account_Contact_Role__c>)getRecordsforExport();
            for(Integer roleCount=0;roleCount< expList.size();roleCount++){
                 cAccount_Contact_Role cConExp = new cAccount_Contact_Role(expList[roleCount]);
                 String roles = contactMapId.get(expList[roleCount].Id);
                 String rolesInsight = contactTotalInsightMapId.get(expList[roleCount].Id);
                 String assignedRoles = '';
                 List<String> roleArray = new List<String>() ;
                 List<String> totalInsightArray = new List<String>() ;
                 if(roles != null && roles.length() > 0){
                 	roleArray = roles.split(',');
                 	Integer roleSize = roleArray.size();
                 	if(rolesInsight != null && rolesInsight.length() > 0){
                 		totalInsightArray = rolesInsight.split(',');
                 	}
                 	Integer c = 0;
                 	for(String role : roleArray){
                 		if(role.equalsIgnoreCase('Indbliksadresse')){
                 			//if(expList[roleCount].Total_Insight__c != null ){
                 			if(totalInsightArray.size() > 0){
                 				role = role + ' (antal kopier: '+totalInsightArray[c]+')';	
                 			}else{
                 				role = role + ' (antal kopier: '+ ')';
                 			}
                 		}
                 		if(assignedRoles == ''){
                 			if(roleSize == 2){
								assignedRoles = role + ', ';                 				
                 			}else{
                 				assignedRoles = role;
                 			}
                 		}else{
                 			if(c == roleSize-1){
                 				assignedRoles += role;
                 			}else if(c == 1){
                 				assignedRoles += ', ' + role + ', ';
                 			}else{
                 				assignedRoles += role + ', ';	  
                 			}
                 		}
                 		c++;
                 	}
                 }
                 cConExp.roleName = assignedRoles;
                 cConExp.accountId  = expList[roleCount].Customer__c;
                 cConExp.FName = expList[roleCount].Contact__r.FirstName;     
                 cConExp.LName = expList[roleCount].Contact__r.LastName;
                 cConExp.phone = expList[roleCount].Contact__r.Phone;
                 cConExp.homePhone = expList[roleCount].Contact__r.HomePhone;
                 cConExp.mobilePhone = expList[roleCount].Contact__r.MobilePhone;
                 cConExp.alternateEmail = expList[roleCount].Contact__r.AlternateEmail__c;
                 cConExp.email = expList[roleCount].Contact__r.Email;
                 if(expList[roleCount].Street_P__c!=null){
                   for(Contact contactadd : contactAddress){
                    if(expList[roleCount].Street_P__c == contactadd.Street_p__r.Id){
	                 cConExp.address = new Address__c();
	                 cConExp.address.Town__c = contactadd.Street_p__r.Town__c;
	                 cConExp.address.Postcode__c = contactadd.Street_p__r.Postcode__c;
	                 cConExp.address.Name = contactadd.Street_p__r.Name;
	                 cConExp.address.House_No__c = contactadd.Street_p__r.House_No__c;
	                 cConExp.address.Floor__c = contactadd.Street_p__r.Floor__c;
	                 //cConExp.address.Side__c = contactadd.Street_p__r.Side__c;
                    }
                  }         
                }else{
                  cConExp.address = new Address__c();
                  cConExp.address.Name = '';
                }         
                finalExpList.add(cConExp); 
                finalExpList[roleCount].roleName = assignedRoles;
            }
             if(tempFlag == true){
            	integer i;
            	i = 10/0;
            }
            return finalExpList;
       } catch (Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
                exceptionHandler.handleException(e,'getListExport()',false,false,cableUnitName,'Medium');
                return null;
         }          
      }
}