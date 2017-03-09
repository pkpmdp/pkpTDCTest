/**  Title: ServiceCenterSingleton 

     Purpose: This service will handle create, edit, delete operations for portal users  
     
     Functionality : Manage Portal Users  
     
     Application: ServiceCenter Application   
*/


public class ServiceCenterSingleton {
   
  // Its completely hidden to outside world. PRIVATE access modifier used      
  private static ServiceCenterSingleton instance; 
      
  private static Lookup_Contact_Roles__c role = null;

  private static Profile profile = null;
      
  private static String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
  private static String portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
  private static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
  private static String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
     
  public static string rName{get;set;}
      // NOTE: the constructor is marked PRIVATE  
      // so that no Apex code outside this class can create the instance  
  private  ServiceCenterSingleton(){
    // Do all the non DML initalization here  
    rName='Testing';
  }
      
  // This static method will be the only way to get the Single instance of this class.  
  public static ServiceCenterSingleton getInstance() {  
     if (instance != null){ // if instance is != null that means initialization is already done   
         return instance;  
     }    
     instance = new ServiceCenterSingleton();  // Create the single instance now. 
     System.debug('---contactRolesBruger----'+contactRolesBruger);
     role = [Select id from Lookup_Contact_Roles__c  where Name =: contactRolesBruger];
     System.debug('---portalUserProfile--'+portalUserProfile);
     profile = [Select id from Profile where name =:portalUserProfile limit 1];
     System.debug('--profile--'+profile);
     return instance;  
   }  
      
  // instance level methods that provide access through the single handle  
  public Lookup_Contact_Roles__c getPortalUserRole() {
         return role;
  }
    
  public Profile getUserProfile(){
    return profile;
  } 
      
  public ID getLoggedInUserRole(ID loggedInId, String contactProfile){
    Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
    Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
    ID roleId;
    User[] user=[select ContactId,ProfileId from User where ContactId =: loggedInId limit 1];
    //System.debug('User  123 ----------------> ' + user);
    if(user.size() > 0 && user != null){
      profile = [Select id from Profile where id =: user[0].ProfileId];
      System.debug('User  Profile ----------------> ' + profile);
      if(profile.id == [Select id from Profile where name =: portalAdminUser limit 1].id){
        lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];
        roleId = lcrRoleAdmin.Id;
      }else if(profile.id  == [Select id from Profile where name =: portalUserProfile limit 1].id){
        //lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where (name  =: 'Bruger' )];
        lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesBruger];
        roleId=lcrRoleUser.Id;
      }
    }
   return roleId;
  } 
   
   // This method is called when an user is updated in a future method
   // We get the to be updated user profile from contact field UserProfile__c
    
    public ID getLoggedInUserRoleFromContact(Contact contact){
    Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
    Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
    ID roleId;
    Profile profileInContact = [Select Id, name from profile where name = : contact.UserProfile__c];
     System.debug('User  Profile ----------------> ' + profile);
     if(profileInContact.id == [Select id from Profile where name =: portalAdminUser limit 1].id){
        lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];
        roleId = lcrRoleAdmin.Id;
      }else if(profileInContact.id  == [Select id from Profile where name =: portalUserProfile limit 1].id){
        //lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where (name  =: 'Bruger' )];
        lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesBruger];
        roleId=lcrRoleUser.Id;
     }
   return roleId;
  } 
  
      
  public ID getLoggedInUserRoleTest(ID loggedInId){
     Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
     Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
     ID roleId;
     User[] user=[select ContactId,ProfileId from User where ContactId =: loggedInId limit 1];
    
     if(user.size() > 0 && user != null){
        Id profileId = user[0].ProfileId;

        if(profileId == [Select id from Profile where name =:portalAdminUser limit 1].id){
          //lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: 'Administrator'];
            lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];
            roleId=lcrRoleAdmin.Id;
        }else if(profileId  == [Select id from Profile where name =:portalUserProfile limit 1].id){
           //lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where (name  =: 'Bruger' )];
            lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesBruger];
            roleId=lcrRoleUser.Id;
        }
       }
    return roleId;
  } 
      
  public string getCableUnitName(string cableUnitNumber){
      string cName;
      List<Cable_Unit__c> cableUnitList = [Select c.name from Cable_Unit__c c where  c.Cable_Unit_No__c =:cableUnitNumber];
      if(cableUnitList != null && cableUnitList.size() > 0){
         cName = cableUnitList[0].Name;
      }
      return cName;
  }
  
  public ID getAdminRoleId(){
    List<Lookup_Contact_Roles__c> lcrRoleAdmin = new List<Lookup_Contact_Roles__c>();
    // lcrRoleAdmin = [Select Id from Lookup_Contact_Roles__c  where name  =: 'Administrator'].Id;
   //  ID lcrRoleAdmin;
  //  lcrRoleAdmin = [Select Id from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator].Id;        
	 lcrRoleAdmin = [Select Id from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];        
    if(lcrRoleAdmin[0] != null){
        return lcrRoleAdmin[0].Id;
    }else{
        return null;  
    }
  }
    
  /*public ID getUserRoleId(){
  	List<Lookup_Contact_Roles__c> lcrRoleUser = new List<Lookup_Contact_Roles__c>();
  	lcrRoleUser = [Select Id from Lookup_Contact_Roles__c where name =: contactRolesBruger];
  	if(lcrRoleUser[0] != null){
  		return lcrRoleUser[0].Id;
  	}else{
  		return null;
  	}
  	
  }*/
      
  public ID getUserRoleId(){
  	
    ID lcrRoleUser;
    //lcrRoleUser = [Select Id from Lookup_Contact_Roles__c  where name  =: 'Bruger'].Id;
    lcrRoleUser = [Select Id from Lookup_Contact_Roles__c  where name  =: contactRolesBruger].Id;
    if(lcrRoleUser != null){  
    System.debug('lcrRoleUser ******: '+lcrRoleUser);     
       return lcrRoleUser;
    }else{
            System.debug('lcrRoleUser ******: null');     
       return null;
    }
  }
      
  public ID getPortalUserRoleId(){
    ID lcrRolePUser;
    lcrRolePUser = [Select Id from Lookup_Contact_Roles__c  where name  =: 'Portal User'].Id;
    if(lcrRolePUser != null){
      return lcrRolePUser;
    }else{
        return null;
    }
  }

  //fetch current users assigned accounts from aCR and compare it with the list of new selected accountIds(Edit portal user screen). return true if any new account is assigned else false.
  public boolean checkUsersAssignedAccount(List<ID> selectedAccountId,ID contactID){
     Boolean flag;
     List<Account_Contact_Role__c> listACR =[select customer__c from Account_Contact_Role__c where customer__C IN:selectedAccountId and  contact__C =:contactID and (role__c =:getAdminRoleId() or role__C =:getUserRoleId())];
     if(listACR.size() != selectedAccountId.size()){
            flag= true;
     }else if(listACR.size()== 1 && selectedAccountId.size() ==1){
        if(listACR[0].customer__C == selectedAccountId[0]){
            flag = true;
        }
     }else{
            flag= false;
     }
     return flag;
   }
}