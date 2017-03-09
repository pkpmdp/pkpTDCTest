public class DispatcherForEditContactController {
    //add an instance variable for the standard controller
   private ApexPages.StandardController controller;    
   public String portalAdminUser{get; set;}
   public String portalBrugerRole{get; set;}
   public String portalUserProfile{get; set;}
   public String contactRolesAdministrator{get; set;}
   Lookup_Contact_Roles__c lcrRole = new Lookup_Contact_Roles__c();
   String acrRolename;
   List<Account_Contact_Role__c> acrAccountsList = new List<Account_Contact_Role__c>();
   Id selectedRoleId;
   
    public DispatcherForEditContactController(ApexPages.StandardController controller){ 
        this.controller = controller;
        portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
        portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
 
        Contact contactList =  [Select Id From Contact  where id in (select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
        
        acrAccountsList = [select Id,RoleName__c,Role__r.Name from Account_Contact_Role__c where Contact__c =: contactList.Id];
        System.debug('---acrAccountsList----'+acrAccountsList.size());
        if(acrAccountsList.size() != 0){
        	for(Account_Contact_Role__c accountContacts :acrAccountsList){
        	  	if( accountContacts.Role__r.Name == contactRolesAdministrator || accountContacts.Role__r.Name == portalBrugerRole ){
            	         selectedRoleId = accountContacts.Role__c;
            	         System.debug('#SElecte RoleId#'+selectedRoleId);
            	         lcrRole = [Select Id, Name from Lookup_Contact_Roles__c  where id  =: selectedRoleId limit 1];
            	         acrRolename = lcrRole.Name;
            	         break;
            	   }
        }    
        System.debug('$$$$$$loggedInUserRoleName: '+acrAccountsList.get(0).RoleName__c);
        System.debug('acrRolename: '+acrRolename);
        }
        
    }

    public Id getContactId(){
        User user = [select contactid from User where id =:UserInfo.getUserId()];            
        return  user.contactId ; 
    }

   public PageReference redirectEditPage(){ 
        Id contactId = getContactId(); //System.currentPageReference().getParameters().get('conId');
        Profile profile = [select name from Profile where id =:UserInfo.getProfileId()];
        PageReference customPage;
        
        system.debug('### The Profile for the User is  ###' + profile.Name);
        portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
        portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        if (portalAdminUser.equals(profile.name)||portalUserProfile.equals(profile.name)){
            //customPage =  Page.editPersonalDataPage;
            
            /*if(Site.getPrefix() != null && Site.getPrefix() != ''){
            	
            	customPage= new PageReference(Site.getPrefix()+'/apex/editPersonalDataPage');
            }else{
            	customPage= new PageReference('/apex/editPersonalDataPage');
            }*/
            customPage = Page.editPersonalDataPage;
            system.debug('### VF page:editPersonalDataPage==###'+customPage);
        }
        customPage.getParameters().put('conId', contactId);
        System.debug('$$$$$$loggedInUserRoleName1: '+ApexPages.CurrentPage().getParameters().get('loggedInUserRoleName'));
        customPage.getParameters().put('loggedInUserRoleName',acrRolename);
        return customPage.setRedirect(true);
   }
   
}