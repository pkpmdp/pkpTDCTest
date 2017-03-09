public with sharing class SC_ValidateProfile {
	public String userId {get;set;}
    public String profileName;
    public Boolean chkProfile;
    public Id contactId {get;set;}
    public Id tempId {get;set;}
    public List<User> users {get;set;}
    public List<Contact> contacts {get;set;}
    public String serviceCenterPortalUser;
    public String serviceCenterPortalAdministrator;
    
    public Boolean ValidateProfileforUser(List<User> users){
        chkProfile = false;
        if(users != null){
            if(users.size() > 0){
                system.debug('users.size()'+users.size());
                userId = users[0].Id;
                profileName = [select u.Id, u.Profile.Name from user u where u.Id =: userId].Profile.Name;
                System.Debug('Profile User Name --->'+profileName);
               /* //priyanka
                serviceCenterPortalUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
                serviceCenterPortalAdministrator = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
                */
                serviceCenterPortalUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ? 
                                              ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c: null;
                serviceCenterPortalAdministrator = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator') != null ? 
                                              ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c: null;
                                               
                if(profileName.equals(serviceCenterPortalUser) || profileName.equals(serviceCenterPortalAdministrator)){
                    chkProfile = true;
                }
            }
        
        System.Debug('Boolean Value'+chkProfile);
        }
        return chkProfile;
    }

    public Boolean validateProfileforContact(List<Contact> contacts){
        chkProfile = false;
        if(contacts != null){
          if(contacts.size() > 0){
             contactId = contacts[0].Id;
             users = [Select Id From user  where ContactId =: contactId];
             if(users != null){
                if(users.size() > 0){
	                tempId = users[0].Id;
	                profileName = [select u.Id, u.Profile.Name from user u where u.id =: tempId].Profile.Name;
	                System.Debug('Profile User Name --->'+profileName);
	                /* //priyanka
	                serviceCenterPortalUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
	                serviceCenterPortalAdministrator = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
	                */
	                
	                serviceCenterPortalUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ? 
	                              ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c: null;
	                serviceCenterPortalAdministrator = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator') != null ? 
	                              ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c: null;
	
	                if(profileName.equals(serviceCenterPortalUser) || profileName.equals(serviceCenterPortalAdministrator)){
	                    chkProfile=true;
	                }
               }
            }
          }
        }
        System.Debug('Boolean Value'+chkProfile);
        return chkProfile;
    }
}