public with sharing class SC_ChangePasswordController{

    public User loggedInUser;
    public static string newpwd {get;set;}
    public string confirmpwd {get;set;}
    public boolean changePwdSection {get;set;}
    public boolean pwdChangeMsg {get;set;}
    public string confirmMsg {get;set;}
    public boolean status=false;  
    public boolean successFlag {get;set;}
    public boolean errorFlag {get;set;}
    public boolean warningFlag {get;set;}
    public ID contactId{get;set;}
    public DateTime dt{get;set;}
    public String dt1{get;set;}
    public String portalAdminUser{get; set;}
    public String portalBrugerRole{get; set;}
    public String siteCoreUrl{get; set;}
    public String retURL;
    ServiceCenter_CustomSettings__c scToAddresses;
    ServiceCenter_CustomSettings__c testDomain;
    ServiceCenter_CustomSettings__c ccTestDomain = ServiceCenter_CustomSettings__c.getValues('Production_CC_EmailSettings');
    public User getLoggedInUser() {
        loggedInUser = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
                system.debug('**newpwd in getLogedInUser**'+newpwd);
        return loggedInUser;
    }    
      
    
    public SC_ChangePasswordController(){
       contactId = ApexPages.CurrentPage().getParameters().get('conId');
       dt1 = getTodayDate();
       portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
       portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
       siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
       scToAddresses = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');
       testDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
           
    }
    
     public PageReference cancel(){
     	//Change to absolute path
 		//String newPageUrl = '/apex/editContactDispatcherPage';	
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.editContactDispatcherPage;
        return newPage;
     }
    
     public Pagereference changePassword(){
        status = false;
        // Change to absolute path
        //String newPageUrl = '/apex/editPersonalDataPage';
        //PageReference newPage = new PageReference(newPageUrl);
        
        PageReference newPage = Page.editPersonalDataPage;
        List<EmailTemplate> templateList = null;
        try{
           pwdChangeMsg = true;
           System.setPassword(loggedInUser.Id, newpwd);
           changePwdSection = false;
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String value2;
           String[] toCCAddresses1; 
         //  if(retURL == testDomain.Value__c){
	          	if(ccTestDomain != null && ccTestDomain.Value__c != null){
                	value2 = ccTestDomain.Value__c;
                	toCCAddresses1 = value2.split(';');
                //	mail.setToAddresses(toCCAddresses1);
                    mail.setCcAddresses(toCCAddresses1);
                    //	System.debug('#toCCAddresses#'+toCCAddresses1);
            	}
         // 	}
            //String[] toAddresses;
            //toAddresses = new String[]{loggedInUser.Email,'poonam.thergaonkar@capgemini.com'};
            //mail.setToAddresses(toAddresses);
            
            mail.setTargetObjectId(loggedInUser.Id);
            mail.setSaveAsActivity(false);
            templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal: Customer Portal Change Password Email Template'];
            mail.setTemplateId(templateList.get(0).id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            newPage.getParameters().put('conId',contactId);
            newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDCHANGED);
            newPage.getParameters().put('loggedInUserRoleName',ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
            return newPage;
        }catch(System.InvalidParameterValueException  ex){
            if(ex.getMessage().contains('invalid repeated password')){
                newPage.getParameters().put('conId',contactId);
                newPage.getParameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDFAILED);
                successFlag = null;
                errorFlag = true;
                return newPage;
            } else if(ex.getMessage().contains('INVALID_NEW_PASSWORD')){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.SC_InvalidPassword);
                ApexPages.addMessage(msg);
                successFlag = null;
                errorFlag = true;
            }
        } 
        return null;        
    }   
      
    public string getTodayDate(){
        dt = datetime.now();
        return dt.format('dd-MM-yyyy');
    }   
}