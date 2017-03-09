/*Purpose : To view the contact details and assigned roles for the selected contact*/
public class ViewContactController
{ 
     public String portalBrugerRole {get; set;}
     public Address__C address{get; set;}
     public String indbliksadresseRoleChk {get; set;}
     public String siteCoreUrl{get; set;}
     public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewContactController','Administration of portal contacts for each cable unit');
/*--- Constructor ------*/
        public ViewContactController() {
        	try {
        		  indbliksadresseRoleChk = Label.SC_IndbliksadresseRoleCheck;
        		  portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        		  siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
			      setContactDetails();
			      cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
        	} catch (Exception e){
        		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            	ApexPages.addMessage(errorMsg);
         	 }        
        }
        
/*---- Property and variable region ------*/     
	    ID accountId;
	    public string[] availableItems {get;set;}
	    public Contact contact = new Contact();      
	    public string cableUnitName {get;set;}
	    public ID getAccountId(){
            return  accountId;       
        }
         
        public void setAccountId(ID accountId){
            this.accountId = accountId;       
        } 
                
        public Contact getContact(){
            return contact;
        }
        public void setContact(Contact c){
            contact = c; 
        }

       //Added as per the issue jira 403 
        public Account_Contact_Role__c acrContact = new Account_Contact_Role__c();
        
        public Account_Contact_Role__c getAcrContact(){
    	   return acrContact;
        }
        
        public void setAcrContact(Account_Contact_Role__c acrContact){
    	  acrContact = acrContact;
        }
        public String antalkopier {get;set;}
        List<Account_Contact_Role__c> acrContactList = new List<Account_Contact_Role__c>();
/*---- End of Property and variable region ------*/  

/*---- Public m/d region ------*/  

// Reading contact details
        public void setContactDetails(){
        	 try {
	                ID accId = apexpages.currentpage().getparameters().get(contactConstClass.ACCOUNTID);
	                setAccountId(accId);
	                ID contactId = ApexPages.CurrentPage().getParameters().get(contactConstClass.CONTACTID);
	                Contact con = [Select id, name, firstname, lastname, email, MobilePhone, HomePhone, Phone, Street_P__c,Street_P__r.Name, Status__c, AlternateEmail__c From Contact  where id = :contactId LIMIT 1];
	                system.debug('$Con details$'+con);
	                address = [Select Street__c, HouseNumber__c, Entrance__c,Door_No__c, Floor__c, Postcode__c, Town__c from Address__C where id =: con.Street_P__c];
	                system.debug('$Address Details$'+address);     
	                setContact(con);
	                acrContactList = [select Role__c, Id, First_Name__c,Email__c, Customer__c, Contact__c,Total_Insight__c from Account_Contact_Role__c where  Contact__c =: con.Id];
	                if(acrContactList.size() > 0){
	                	    setAcrContact(acrContactList[0]);
			                for(Account_Contact_Role__c accountContacts : acrContactList){
		                	  acrContact = accountContacts;
		                	  System.debug(' Inside For Loop ' +accountContacts.Total_Insight__c);
		                	  		//this is used for fetching the antal kopier value from acr table 
			                  acrContact.Total_Insight__c = accountContacts.Total_Insight__c ;
		                	  
			                }
	                }
        	 } catch (Exception e){
	        		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
	            	ApexPages.addMessage(errorMsg);
         	}          
        }      

// Reading the assigned roles for the selected contact
        public List<SelectOption> getSelectedItems(){
	 		try {
	                ID contactId = ApexPages.CurrentPage().getParameters().get(contactConstClass.CONTACTID);
	                List<Account_Contact_Role__c> acrList = [Select a.RoleName__c from Account_Contact_Role__c a  where a.Contact__c =: contactId ];
	                List<SelectOption> options = new List<SelectOption>();
	                for(Account_Contact_Role__c roles : acrList ){ 
	                    if(!(roles.RoleName__c == contactConstClass.PORTALUSER ||  roles.RoleName__c == contactConstClass.PORTALMANAGER))
	                        options.add(new SelectOption(roles.RoleName__c, roles.RoleName__c));
	                }
	                return options;
	 		} catch (Exception e){
	        		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
	            	ApexPages.addMessage(errorMsg);
	            	return null;
	 		}         
        }
        
// Reading all the roles from the lookup
        public List<SelectOption> getItems(){
         	try {
	                List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true and l.Active__c = 'Ja'];
	                List<SelectOption> options = new List<SelectOption>();
	                for(Lookup_Contact_Roles__c roles : rolesList ){ 
	                    if(!(roles.Name == contactConstClass.PORTALUSER ||  roles.Name == contactConstClass.PORTALMANAGER))
	                        options.add(new SelectOption(roles.Name, roles.Name));
	                }
	                return options;
         	} catch (Exception e){
	        		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
	            	ApexPages.addMessage(errorMsg);
	            	return null;
         	}        
        }
        
// Redirecting to manage contact page.
    public PageReference cancel(){
            String newPageUrl = contactConstClass.MANAGECONTACTURL;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put(contactConstClass.ACCOUNTID, getAccountId());
            newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
            newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
            newPage.setRedirect(true);
            return newPage;
     }
        
 //Reading the assigned role
    public List<Account_Contact_Role__c> getChosenRoles(){
     	try {
            ID contactId = ApexPages.CurrentPage().getParameters().get(contactConstClass.CONTACTID);
       		//current query     
            //List<Account_Contact_Role__c> acrList = [Select a.RoleName__c from Account_Contact_Role__c a  where a.Contact__c =: contactId and a.customer__C =: getAccountId() and (a.Role__c  !=: ServiceCenterSingleton.getInstance().getAdminRoleId()  and a.Role__c !=: ServiceCenterSingleton.getInstance().getUserRoleId()  and a.Role__c !=: ServiceCenterSingleton.getInstance().getPortalUserRoleId())];
            
            List<Account_Contact_Role__c> acrList = [Select a.RoleName__c, a.Total_Insight__c from Account_Contact_Role__c a  where a.Contact__c =: contactId and a.customer__C =: getAccountId() and (a.Role__c  !=: ServiceCenterSingleton.getInstance().getAdminRoleId()  and a.Role__c !=: ServiceCenterSingleton.getInstance().getUserRoleId()) and a.Role__r.Visible_in_Service_Centre__c = true and a.Role__r.Active__c = 'Ja'];
                                                    //  and a.Role__c != :dummyContactRoleId];
           	System.debug('list of roles-->'+acrList);
            return acrList ;
     	} catch (Exception e){
    		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        	ApexPages.addMessage(errorMsg);
        	return null;
     	}         
    }
	
	public PageReference editContactTest(){
		// Change to Absolute path
		//String pageUrl = '/apex/editContactTestPage';
		//PageReference newPage = new PageReference(pageUrl);
		
		PageReference newPage = Page.editContactTestPage;
		newPage.setRedirect(true);
		newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
		return newPage;
	}	
/*---- End of Public m/d region ------*/  
}