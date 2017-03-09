/** 
 Title: PortalUserService

 Purpose: This service will handle create, edit, delete operations for portal users
 
 Functionality : Manage Portal Users
 
 Application: ServiceCenter Application
   
*/
public class PortalUserService{

   PortalUserMailService mailService = new PortalUserMailService();
   Pattern isnumbers = Pattern.Compile('^[0-9]+$');
   Pattern alphanum = Pattern.compile('^[a-zA-Z0-9_]*$');
   String generatedPassword;
   public String password; 
   public String alphaPass;
   public String alias1;
   public static boolean inPortalContext = false;
   public static boolean tempTestFlag = false;
   public static boolean inUserPortalServiceContext = false;
   public boolean tempFlag = false;
   public static boolean TEST_MODE = false; 
   //public enum OPERATION {CREATE_ROLE, UPDATE_ROLE, DELETE_ROLE}
   
   private static String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ? 
                                             ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c: null;
   private static String portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator') != null ? 
                                            ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c : null;
   private static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger') != null ? 
                                              ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c: null;
   private static String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator') != null ?
                                                     ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c: null;
  
   private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c;
   private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;    
   private static String adminProfile = ServiceCenter_CustomSettings__c.getInstance('SC-Administrator_Profile_ID') != null ? 
                                             ServiceCenter_CustomSettings__c.getInstance('SC-Administrator_Profile_ID').Value__c: null;
   
   private static String adminbrugerId = ServiceCenter_CustomSettings__c.getInstance('SC-User_Profile_ID') != null ? 
                                             ServiceCenter_CustomSettings__c.getInstance('SC-User_Profile_ID').Value__c: null;
   
   public PortalUserService(){
        tempFlag = false;
   }
  
    // used when a new portal user is created
   public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('PortalUserService','Administration of portal users');
    
   public void createPortalUser(List<Account> selectedAccountList, Contact contactToBeCreated,boolean contactExists,boolean userExists){
      Savepoint sp = Database.setSavepoint();
      try{
        User portalUserToBeCreated = new User();
        Contact userContact =  getLoggedInUserContactDetails(); // get logged in users(admin) contact for accountid and street
        inUserPortalServiceContext = true; 
        Contact contactCreated = new Contact(); 
      
      //storing the accountids from selectedAccountList coming from controller for passing the accountids in inactive scenario - sc-p3 
      List<Id> accountIds = new List<Id>();
      if(selectedAccountList != null && selectedAccountList.size() > 0){
         for(Account acc : selectedAccountList){
            accountIds.add(acc.Id);
         }
      }
     
        if(userContact != null){
           if(contactToBeCreated != null){
              if(userExists == false){
                 System.debug('Inside userExist$$');
                  // Added to UserProfile__C field in contact object, commented as we only create user
                  //Profile profile = [Select Id, name from profile where name = : ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c];
                  //contactToBeCreated.UserProfile__c = profile.Name;
                  
                  contactToBeCreated.UserProfile__c = portalUserProfile;
                  
                  contactCreated = createContact(contactToBeCreated, userContact.HierarchyAccount__c,contactExists,accountIds);  // create contact with details
                  System.debug('Contact $$$$$'+ contactCreated);
                  portalUserToBeCreated = createUser(contactCreated); // create user
                  if(portalUserToBeCreated != null){
                    
                    //password = ServiceCenterTestUtil.getRandomName() + ServiceCenterTestUtil.getRandomNumber(100000000);
                    password = ServiceCenterTestUtil.getRandomAlphaNumericParam(8);
                    password += ServiceCenterTestUtil.getRandomCharsName(3) + ServiceCenterTestUtil.getRandomNumeric(3);
                    System.debug('@@PassWord Generated@'+password);
                    /*alphaPass = ServiceCenterTestUtil.getRandomAlphaNumericParam(8);
                    alphaPass += ServiceCenterTestUtil.getRandomCharsName(3) + ServiceCenterTestUtil.getRandomNumeric(3);
                    System.debug('alphaPass Sending mail$$'+alphaPass);*/
        
                    /*
                    Matcher pass1Match = isnumbers.matcher(alias1);
                    if(pass1Match.matches()){
                        password = portalUserToBeCreated.alias + ServiceCenterTestUtil.getRandomName() + ServiceCenterTestUtil.getRandomNumber(1000);
                        System.debug('##Paswword First#'+password);
                    }else{
                        password = portalUserToBeCreated.alias + ServiceCenterTestUtil.getRandomNumber(100000000);
                        System.debug('##Paswword Second#'+password);
                    }*/
                    
                        
                    /* Existing Password
                    String password = portalUserToBeCreated.CommunityNickname + ServiceCenterTestUtil.getRandomNumber(1000);*/
                    System.debug('@Random Name@'+ServiceCenterTestUtil.getRandomName()+'##Random Number##'+ServiceCenterTestUtil.getRandomNumber(100000000)+'##Paswword Exact#'+password);  
                    System.setPassword(portalUserToBeCreated.Id, password);
                    if(selectedAccountList != null){
                      //  createAccountContactRole(selectedAccountList, portalUserToBeCreated , contactCreated); // create account contact roles
                        createAccountContactRoleNew(selectedAccountList, portalUserToBeCreated , contactCreated); // create account contact roles
                        //mailService.sendMailPortalUserCreation(password,contactCreated);
                        System.debug('Before Sending mail$$'+password);
                        mailService.sendMailPortalUserCreationTest(password, contactCreated);
                        System.debug('After Sending mail$$');
                     }
                     //associateUserToGroup(portalUserToBeCreated.id);
                   } 
                
               }else{
                  //Scenario SC_P3 - Updating the inactive user with active and sc_p7 fre flying user already exists with dummy accounts
                 // contactToBeCreated
                 System.debug('$$$Inside else$'+contactToBeCreated.Email);
              //   String contactProfile = [select UserProfile__c,IsPersonAccount from Contact where email =: contactToBeCreated.Email AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType].UserProfile__c; 
                 Profile profile = [Select Id, name from profile where name = : ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c];
                 contactToBeCreated.UserProfile__c = profile.Name;
                
                  if(contactToBeCreated != null){
                /*    if(contactProfile != null){
                      contactToBeCreated.UserProfile__c = contactProfile;
                    } */
                    update contactToBeCreated; // update the contact details
                  }
                  //if(contactToBeCreated.UserProfile__c != null){
                  //}
                  deleteContactRolesInactiveUser(contactToBeCreated.Id, accountIds);
                  System.debug('$$$Inside else##########3$');
                  portalUserToBeCreated = updateUserNew(selectedAccountList, portalUserToBeCreated, contactToBeCreated);
                 } 
             }
            }
         if(tempFlag == true){
            integer i;
            i = 10/0;
         }   
      }catch(Exception e){
        Database.rollback(sp);
        throw e;
      }
    }
    
    
    public void deleteContactRolesInactiveUser(Id contactId,List<Id> accountIdList){
       Set<Id> delnewRoles = new Set<Id>();
       List<Id> newRoles = new List<Id>();
       List<Account_Contact_Role__c> deletedRolesList = new List<Account_Contact_Role__c>();
       Map<Id, Account_Contact_Role__c> oldListMap = new Map<Id, Account_Contact_Role__c>();
       
       List<Account_Contact_Role__c> acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
          where c.Contact__c =: contactId and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
       if(acrContactLst.size() > 0){
         for(Account_Contact_Role__c acnt : acrContactLst){
           oldListMap.put(acnt.Customer__c,acnt);
         }  
       }
       if(accountIdList.size() > 0){
          for(Id accountId : accountIdList){
            if(oldListMap.get(accountId) != null){
                 oldListMap.remove(accountId);
            }else{
                newRoles.add(accountId);    
            }
          }
       }
       delnewRoles = oldListMap.keyset();
      
       if(delnewRoles.size() > 0){
          for(ID rolesSel : delnewRoles){
            deletedRolesList.add(oldListMap.get(rolesSel));
            system.debug('$d$'+deletedRolesList);
          }
       }
       System.debug('deletedRolesList---'+deletedRolesList);
       System.debug('deletedRolesList size---'+deletedRolesList.size());
       if(deletedRolesList.size() > 0){
        delete deletedRolesList;
       }
       
     }
    
    /*//tmp cmmntd
    public void createPortalUser(List<Account> selectedAccountList, Contact contactToBeCreated,boolean contactExists,boolean userExists){
      //System.debug('----insdie createPortalUser------'+selectedAccountList+'Contacts'+contactToBeCreated+'ContactExist'+contactExists+'User Exists'+userExists);
      User portalUserToBeCreated;
      Contact userContact =  getLoggedInUserContactDetails(); // get logged in users(admin) contact for accountid and street
      inUserPortalServiceContext = true; 
       Contact contactCreated = new Contact(); 
      Savepoint sp = Database.setSavepoint();
      
      //storing the accountids from selectedAccountList coming from controller for passing the accountids in inactive scenario - sc-p3 
      List<Id> accountIds = new List<Id>();
      
      if(selectedAccountList != null && selectedAccountList.size() > 0){
         for(Account acc : selectedAccountList){
            accountIds.add(acc.Id);
         }
      }
      try{
        if(userContact != null){
           if(contactToBeCreated != null){
              if(userExists == false){
                  // Added to UserProfile__C field in contact object
                  Profile profile = [Select Id, name from profile where name = : ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c];
                  contactToBeCreated.UserProfile__c = profile.Name;
                  
                  createContact(contactToBeCreated, userContact.HierarchyAccount__c,contactExists,accountIds);  // create contact with details
                        
                  portalUserToBeCreated = createUser(contactToBeCreated); // create user
                  String password = generatePassword();
                  
                  if(portalUserToBeCreated != null){
                    System.setPassword(portalUserToBeCreated.id, password);
                    if(selectedAccountList != null){
                        createAccountContactRole(selectedAccountList, portalUserToBeCreated , contactToBeCreated); // create account contact roles
                     }
                     associateUserToGroup(portalUserToBeCreated.id);
                   }
                
               }else{
                  //Scenario SC_P3 - Updating the inactive user with active and sc_p7 fre flying user already exists with dummy accounts
                  if(contactToBeCreated != null){
                    update contactToBeCreated; // update the contact details
                  }
                  portalUserToBeCreated = updateUser(selectedAccountList, portalUserToBeCreated, contactToBeCreated);
               } 
             }
            }  
           }catch(Exception e){
              if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                Database.rollback(sp);                   
                throw e;
              }else{
                Database.rollback(sp);
                throw e;
              }
     }
    }   
    
     */
        
    // used when an existing portal user is updated 
    // List<ID> accountCreatedListIDs, added exttra 
    /*
    public void editPortalUser(Contact contactToBeUpdated, List<ID> accountCreatedListIDs, List<Account> accountCreatedList, List<Account> accountDeletedList,  List<ID> accountIdDeletedList){
        system.debug('$Contact$'+contactToBeUpdated+'$accountCreatedListIDs$'+accountCreatedListIDs+'$accountCreatedList$'+accountCreatedList+'$accountDeletedList$'+accountDeletedList+'$accountIdDeletedList$'+accountIdDeletedList);
      //SavePoint sp =Database.setSavepoint();  
      User portalUserToBeUpdated;
      try{
          System.debug('----------------editPortalUser-----------------------');
          //Static Variable used for restricting  the trigger to fire while updating contact and user
          inPortalContext= true;
          inUserPortalServiceContext = true;
          if(contactToBeUpdated != null){
            System.debug('Before updating contact----------'+contactToBeUpdated);
            update contactToBeUpdated; // update the contact details
          }
          System.debug('contactToBeUpdated-----------------'+contactToBeUpdated+'$portalUserToBeUpdated$'+portalUserToBeUpdated);
                
          portalUserToBeUpdated = updateUser(accountCreatedList, portalUserToBeUpdated, contactToBeUpdated);
          System.debug('portalUserToBeUpdated--------------'+portalUserToBeUpdated);
          
          //mailService.sendMailPortalUserUpdation(contactToBeUpdated); // send notification mail to portal users
          System.debug('accountCreatedList------------------'+accountCreatedList+' and size is-->'+accountCreatedList.size());
           
          deleteAccountContactRole(accountIdDeletedList, portalUserToBeUpdated, contactToBeUpdated); // deletes account contact roles
          system.debug('$portalUserToBeUpdated$'+portalUserToBeUpdated+'$accountDeletedList$'+accountDeletedList);
          mailService.sendMailForAccountDetached(portalUserToBeUpdated, accountDeletedList); // send mails for notifications
          
          System.debug('end of editPortalUser...');
      }catch(Exception e){
            system.debug('$e.getDmlType(0)1111111111$'+e.getDmlType(0)+'$Status code$'+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
            System.debug('editPortalUser else---------------'+e.getMessage());
            //Database.rollback(sp);
            throw e;
     }
    }
    */
    // used when an existing portal user is updated 
 /*   public void updateAccountAssignment(User user, Contact contact, List<Account> accountCreatedList, List<Account> accountDeletedList,  List<ID> accountIdDeletedList){
      try{
                inPortalContext = true;
                System.debug('----------------  Inside 1 ------------------');
           //     mailService.sendMailPortalUserUpdation(contact); // send notification mail to portal users
                System.debug('----------------  Inside 2 ------------------'+contact);
                System.debug('accountCreatedList--->'+accountCreatedList+' and size is-->'+accountCreatedList.size());
               // createACR(accountCreatedList, user, contact);  // create account contact roles
                createAccountContactRole(accountCreatedList, user, contact);  // create account contact roles
                
            
                System.debug('----------------  Inside 3 ------------------');
          //      mailService.sendMailForAccountAssignment(user, accountCreatedList); // send notification mail for the new account assignmnet
                System.debug('accountIdDeletedList--->'+accountIdDeletedList+' and size of deleted -->'+accountIdDeletedList.size());
                deleteAccountContactRole(accountIdDeletedList, user, contact); // deletes account contact roles
                System.debug('----------------  Inside 4 ------------------');
          //      mailService.sendMailForAccountDetached(user, accountDeletedList); // send mails for notifications
                System.debug('----------------  Inside 5 ------------------');
       }catch(Exception e){
            System.debug('updateAccountAssignment else---------------'+e.getMessage());
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'updateAccountAssignment()',false,false,null);
            throw e;
     }  
    }
      */
    // used when an portal user is deleted//new
   public void deletePortalUser(ID contactId){
      try{
        User[] user = [Select u.Id,u.Contact.Id From User u where u.contactId =: contactId limit 1]; 
        System.debug('ServiceCenterSingleton.getInstance().getUserRoleId()--'+ServiceCenterSingleton.getInstance().getUserRoleId());
        System.debug('ServiceCenterSingleton.getInstance().getAdminRoleId()--'+ServiceCenterSingleton.getInstance().getAdminRoleId());
        System.debug('portalUserRoleId--'+portalUserRoleId);
        System.debug('portalUserAdministratorRoleId---'+portalUserAdministratorRoleId); 
        List<Account_Contact_Role__c> listACR = [select id, contact__c,Role__c from Account_Contact_Role__c where contact__c  =: contactId and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
        if(listACR.size() > 0){
          delete listACR;
        }
        if(user != null && user.size() > 0){
          deleteUser(contactId);
            //List<Account> accountDeletedList = [Select acc.Name, acc.Anlaeg_No__c From Account acc where  acc.id in (Select  a.Customer__c From Account_Contact_Role__c a where a.Contact__c =: contactId)];
        }
      }catch(Exception e){
        System.debug('deletePortalUser else---------------'+e.getMessage());
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        ApexPages.addMessage(errorMsg);
        exceptionHandler.handleException(e,'deletePortalUser()',false,false,null,'Medium');
        throw e;
     }
    }

    @future 
    public static void deleteUser(ID contactId){
        try {
            System.debug('inside deleteAcr()  method'+contactId);
             User[] user = [Select u.Id, u.firstname, u.lastname, u.isActive,u.Contact.Id From User u where u.contactId =: contactId limit 1];  
            
            System.debug('user in deletPortalUser::'+user);
            if(user != null && user.size() > 0){
                System.debug(' user before delete in deleteUser::'+user[0]);
                if (user[0].isActive == true){
                   user[0].isActive = false;
                }
            }
            inUserPortalServiceContext = true;
            if(user != null && user.size() > 0){
            	update user[0];
            	System.debug('UPDATED user in deleteUser::'+user);
            }            	
        }catch(Exception e){
            System.debug('deleteUser else---------------'+e.getMessage());
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
           // exceptionHandler.handleException(e,'deleteUser()',false,false,null);
            throw e;
      }   
    }
 
   // deletes account contact roles
   public boolean deleteAccountContactRole(List<ID> accountList, User user, Contact contact){
      try {
            Database.DeleteResult[] DeleteResult;
            ID roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
            System.debug('DeleteList****Size'+accountList.size()+'accList&&&&&'+accountList);
            List<Account_Contact_Role__c> acrDelList = [Select id, Contact__c, Customer__c from Account_Contact_Role__c acr where 
                        acr.Contact__c =: contact.id  and acr.Role__c =: roleId and acr.Customer__c in : accountList];
             System.debug('ACRDELETE Size'+acrDelList.size());
            if(acrDelList.size() > 0){
                if(acrDelList.size() < 50){
                    //  delete acrDelList;
                    System.debug('Inside ACRDELETE Size'+acrDelList.size());
                    DeleteResult = Database.delete(acrDelList, true);
                }else{  
                        System.debug('Inside else ACRDELETE Size'+acrDelList.size());
                        SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrDelList, SC_BatchCreateEditDeleteContactRoles.OPERATION.DELETE_ROLE); 
                        Id jobId = Database.executebatch(batch, 50);
                }
              
            }
            List<AccountShare> accountShareList = [Select Id from AccountShare a  where a.UserOrGroupId =: user.id and a.AccountId  in : accountList ];
            if(accountShareList.size() > 0){ 
              delete accountShareList;
            }
            return true;
      } catch (Exception e){
            System.debug('delete error-------'+e.getMessage());
            throw e;
            return null;
      }     
    }
    
    // new code for creates new user with alias as firstname first 5 characters
    public User createUser(Contact contact){
        
        String commNickName;
        User user = null;
        Integer fnLength,lnLength;
        String fName,lName;
       
        
      try {  
             if(contact.FirstName != null && contact.FirstName != '' && contact.LastName != null && contact.LastName != ''){
                fName = contact.FirstName.trim();
                fnLength =  fName.length();
                lName = contact.LastName.trim(); 
                lnLength =  lName.length();
                if(fnLength <= 5 || lnLength <= 5){
                    alias1 = contact.FirstName.substring(0,1).trim();
                    alias1 += contact.LastName.substring(0,lnLength);   
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }else{
                        alias1 = alias1.substring(0,alias1.length());
                    }
                }else{
                    alias1 = contact.FirstName.substring(0,1).trim();
                    alias1 += contact.LastName.substring(0,lnLength);
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }
                }
             }else{
                if(contact.LastName != null && contact.LastName != ''){
                    system.debug('@@@Insdie ng testing');
                    lName = contact.LastName.trim(); 
                    lnLength =  lName.length();
                    alias1 = lName.substring(0,lnLength);
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }
                    /*
                    if(lnLength <= 5){
                        System.debug('@@@@@@@Inside less than first name 5'+contact.LastName+'####Random number'+ServiceCenterTestUtil.getRandomAlphaNumericParam(4));
                        alias1 = lName + ServiceCenterTestUtil.getRandomAlphaNumericParam(4);
                        if(alias1.length() > 5){
                            alias1 = alias1.substring(0,5);
                            System.debug('@@@First alias'+alias1);
                        }
                    }else{
                            alias1 = lName.substring(0,5);
                            System.debug('Inside Lastname length more than 5'+alias1);   
                    }*/
                }
                
             }
             //String fName = contact.FirstName.trim();
             //String lName = contact.LastName.trim();      
             //fnLength =  fName.length();
             //lnLength =  lName.length();
             
             
             //Integer fnLength = contact.FirstName.length();
             //Integer lnLength = contact.LastName.length();
             /*
             if(fnLength <= 5 || lnLength <= 5){
                alias1 = contact.FirstName.substring(0,1).trim();
                alias1 += contact.LastName.substring(0,lnLength);   
                if(alias1.length() > 5){
                    alias1 = alias1.substring(0,5);
                }else{
                    alias1 = alias1.substring(0,alias1.length());
                }
                
             }else{
                if(contact.FirstName != null && contact.FirstName != ''){
                    alias1 = contact.FirstName.substring(0,1).trim();
                }
                
                alias1 += contact.LastName.substring(0,lnLength);
                if(alias1.length() > 5){
                    alias1 = alias1.substring(0,5);
                }
             }*/
             
             System.debug('*Last alias*'+alias1);
             
             // SC - 121 Added for generating Community Nick Name with random number Existing
             commNickName = alias1 + ServiceCenterTestUtil.getRandomNumber(1000); 
             
             /*
             Matcher passMatch = isnumbers.matcher(alias1);
             if(passMatch.matches()){
                commNickName = alias1 +  .getRandomName();
                System.debug('@@@@Community NickName@'+commNickName);
             }else{
                commNickName = alias1 + ServiceCenterTestUtil.getRandomNumber(1000);
                System.debug('@@@@Community NickName Else $$$4@'+commNickName);
             }  */
             
             System.debug('#commNickName##'+commNickName);
             ID profileId = adminbrugerId;
             //ID profileId = ServiceCenterSingleton.getInstance().getUserProfile().id; 
             user = new User( 
                 email = contact.Email.trim(),contactid = contact.id, profileid = profileId, UserName=contact.Email.trim(),
                 alias = alias1, CommunityNickName = commNickName, 
                 TimeZoneSidKey = 'Europe/Paris',
                 LocaleSidKey ='da_DK', 
                 EmailEncodingKey ='ISO-8859-1',         
                 LanguageLocaleKey ='da', FirstName = contact.firstname, LastName = contact.lastname, 
                 isActive = true);
             System.debug('* Details of current user objects  *'+ user);
             insert user;
             System.debug('after insertion user details----'+user);
               /*if(tempFlag == true){
                    integer i;
                    i = 10/0;
                }*/
             return user;
      }catch (Exception e){
        System.debug('----exception in create user method---'+e.getMessage());
        throw e;
        return null;
      }        
    }                  
    
    
      // creates new user newone
    public User createPortalUser(Contact contact){
      try {
         // SC - 121 Added for generating Community Nick Name with random number
         /*Existing logic for generating alias
          String fNameLength = contact.FirstName;
          String alias1;
          if(fNameLength.length()>3){
             alias1 = contact.FirstName.substring(0,3);
          }else{
             alias1 = contact.FirstName;
          }*/
         
         Integer fnLength,lnLength;
         String fName,lName;
         if(contact.FirstName != null && contact.FirstName != '' && contact.LastName != null && contact.LastName != ''){
                fName = contact.FirstName.trim();
                fnLength =  fName.length();
                lName = contact.LastName.trim(); 
                lnLength =  lName.length();
                if(fnLength <= 5 || lnLength <= 5){
                    alias1 = contact.FirstName.substring(0,1).trim();
                    alias1 += contact.LastName.substring(0,lnLength);   
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }else{
                        alias1 = alias1.substring(0,alias1.length());
                    }
                }else{
                    alias1 = contact.FirstName.substring(0,1).trim();
                    alias1 += contact.LastName.substring(0,lnLength);
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }
                }
             }else{
                if(contact.LastName != null && contact.LastName != ''){
                    system.debug('@@@Insdie ng testing');
                    lName = contact.LastName.trim(); 
                    lnLength =  lName.length();
                    alias1 = lName.substring(0,lnLength);
                    if(alias1.length() > 5){
                        alias1 = alias1.substring(0,5);
                    }
                    /*
                    if(lnLength <= 5){
                        System.debug('@@@@@@@Inside less than first name 5'+contact.LastName+'####Random number'+ServiceCenterTestUtil.getRandomAlphaNumericParam(4));
                        alias1 = lName + ServiceCenterTestUtil.getRandomAlphaNumericParam(4);
                        if(alias1.length() > 5){
                            alias1 = alias1.substring(0,5);
                            System.debug('@@@First alias'+alias1);
                        }
                    }else{
                            alias1 = lName.substring(0,5);
                            System.debug('Inside Lastname length more than 5'+alias1);   
                    }*/
                }
                
             }
         
         String commNickName= alias1 + ServiceCenterTestUtil.getRandomNumber(1000);
         System.debug('---UserProfile__c---'+contact.UserProfile__c);
         Profile profile = [Select Id, name from profile where name = : contact.UserProfile__c];
         System.debug('---profile----'+profile.id);
         System.debug('---profile--name--'+profile.Name);
         //ID profileId= ServiceCenterSingleton.getInstance().getUserProfile().id;     
         User user = new User( 
           email=contact.Email.trim(),contactid = contact.id, profileid = profile.id, UserName=contact.Email.trim(),
           alias=alias1, CommunityNickName=commNickName,Phone=contact.Phone,MobilePhone=contact.MobilePhone,  
           TimeZoneSidKey = 'Europe/Paris',
           LocaleSidKey='da_DK', 
           EmailEncodingKey='ISO-8859-1',         
           LanguageLocaleKey='da', FirstName = contact.firstname, LastName = contact.lastname, 
           isActive = true);
      
              system.debug('$@@$');
              insert user;
          //    String password = generatePassword();
              password = ServiceCenterTestUtil.getRandomAlphaNumericParam(8);
              password += ServiceCenterTestUtil.getRandomCharsName(3) + ServiceCenterTestUtil.getRandomNumeric(3);
              System.setPassword(user.id, password);
              //sending mail
              system.debug('$@@######$');
              mailService.sendMailPortalUserCreationTest(password,contact);
              system.debug('$@@$$$$$');
              contact.Enable_Customer_Portal_User__c = true;
              contact.UserProfile__c = profile.name;
              system.debug('$@@$$$$$%%%%');
              System.debug(contact.IsPersonAccount);
              System.debug(contact.KissPartyId__c);
             update contact; 
              system.debug('$@@$$$$$###########');
        
         return user;
      }catch (Exception e){
            throw e;
            return null;
        }        
    }
    // creates new contact
  public Contact createContact(Contact contact, Id loggedInUserAccountId, boolean contactExists, List<Id> selectedAccountIdList){
    System.debug('insid createContact'+contact);
    Contact contactToBeCreated = new Contact();
    List<Contact> contactListToBeCreated = new List<Contact>();
    try{
       User[] checkUserProfile = [select u.Profile.Id from User u where u.id =: UserInfo.getUserId() LIMIT 1];
       if(checkUserProfile != null && checkUserProfile.size() > 0){
         //Id profileChk = [Select id from Profile where name =: portalAdminUser limit 1].id;
         Id profileChk = adminProfile;
         System.debug('%%%%Test'+profileChk);
         if((checkUserProfile[0].Profile.Id == [Select id from Profile where name =: portalAdminUser limit 1].id) || (checkUserProfile[0].Profile.Id == [Select id from Profile where name =: portalUserProfile limit 1].id) ){
            contactToBeCreated.HierarchyAccount__c = loggedInUserAccountId;
            contact.HierarchyAccount__c = loggedInUserAccountId;
         }
        }
        if(contactExists == true){
          contactToBeCreated = contact;
          contactToBeCreated.AccountId = null;
          contactListToBeCreated.add(contactToBeCreated);
          clsContactsAddAccount util = new clsContactsAddAccount();
          util.addDummyAccounts(contactListToBeCreated);
          inPortalContext= true;
          update contactListToBeCreated;
          System.debug('success updated if service createComtact..'+contactListToBeCreated);
        }else{
          contactToBeCreated.Status__c = contactConstClass.ACTIVE;
          contactToBeCreated.FirstName = contact.FirstName;
          contactToBeCreated.LastName = contact.LastName;
          contactToBeCreated.Email = contact.Email.trim();
          contactToBeCreated.Phone = contact.Phone;
          contactToBeCreated.MobilePhone = contact.MobilePhone;
          contactToBeCreated.HomePhone = contact.HomePhone;
          contactToBeCreated.Street_P__c = contact.Street_P__c;
          contactToBeCreated.UserProfile__c = portalUserProfile;
          contactToBeCreated.RecordTypeId = contactConstClass.ContactRecordType;
          contactListToBeCreated.add(contactToBeCreated);
          clsContactsAddAccount util = new clsContactsAddAccount();
          util.addDummyAccounts(contactListToBeCreated);
          system.debug('contactToBeCreated: '+contactToBeCreated);
          insert contactToBeCreated;
        }
    }catch(Exception e){
        throw e;
        return null;
    }
    System.debug('before *** return contactToBeCreated..'+contactToBeCreated);
    return contactToBeCreated;
  }    
    /*
    // creates account contact roles   
    public boolean createACR(List<Account> accountList, User user, Contact contact){
       try { 
          System.debug('inside createAccountContactRole, contact is --->'+contact);
          Id roleId;
          Account_Contact_Role__c acr; 
          
          List<AccountShare> aShareList = new AccountShare[0];
          List<Account_Contact_Role__c> acrList= new Account_Contact_Role__c[0];
          List<ID> accountIdList = new List<ID>();
          
          for(Account acc : accountList){
                accountIdList.add(acc.Id);
          }
          System.debug('accountIdList-in createAccountContactRole-->'+accountIdList+'..and size ->'+accountIdList.size());            
          List<Account_Contact_Role__c> acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
                                                            where c.Contact__c =: contact.Id and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
          System.debug('list acrContactList before for loop--->'+acrContactLst+'...and size is--->'+acrContactLst.size());
          if(acrContactLst.size() > 0){
                System.debug('inside if list acrContactList deleted size is--->'+acrContactLst.size());
                delete acrContactLst;
          }
          System.debug('size acctlist-->'+accountList.size()+'...and accountlist--->'+accountList);
          
          if(contact.id != null){  
            roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
          }
          if(accountList != null){     
              for(Account account : accountList){
                    aShareList.add(new AccountShare (AccountId=account.id , accountAccessLevel='Edit', 
                    caseAccessLevel='Edit', opportunityAccessLevel='Edit', UserOrGroupId=user.Id));  
                    acr = new Account_Contact_Role__c();  
                    System.debug('accountId--->'+account.id);
                    acr.Customer__c = account.id;  
                    acr.Contact__c= contact.id;  
                    //System.debug('creating acr ->'+ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null));
                    //acr.Role__c = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
                    if(roleId != null){
                      acr.Role__c = roleId;
                    }
                    System.debug('role->'+acr.Role__c);
                    System.debug('inside for loop acr is--->'+acr);
                    
                    if(acr != null){
                      acrList.add(acr);
                    }
                }
            }
            System.debug('acrList inserted/ updated in ACR--->'+acrList);
            if(aShareList.isEmpty() == false){    
              upsert aShareList;
            }
            
            if(acrList.isEmpty() == false){ 
               System.debug('before upserting acrList-->'+acrList);  
               upsert acrList;  
               System.debug('after upserting acrList--->'+acrList);
            }
           
        }catch(Exception e){
           throw e;
           return null;
        }
        return true;
    }
    */
    // creates account contact roles 
    /*  
    public boolean createAccountContactRole(List<Account> accountList, User user, Contact contact){
      try {
         System.debug('inside createAccountContactRole, contact is --->'+contact+'----accountList--'+accountList.size());
        Id roleId;
        Account_Contact_Role__c acrContactRoles; 
        
        List<AccountShare> aShareList = new AccountShare[0];
        List<Account_Contact_Role__c> acrList= new Account_Contact_Role__c[0];
        List<ID> accountIdList = new List<ID>();
            
        if(accountList != null && accountList.size() > 0){
           for(Account acc : accountList){
             accountIdList.add(acc.Id);
           }
        }
            
        System.debug('accountIdList-in createAccountContactRole-->'+accountIdList+'..and size ->'+accountIdList.size());            
        
        List<Account_Contact_Role__c> acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
               where c.Contact__c =: contact.Id and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId()) limit 5];
                                            
        System.debug('list acrContactList before for loop--->'+acrContactLst+'...and size is--->'+acrContactLst.size());
            if(acrContactLst.size() > 0){
                System.debug('inside if list acrContactList deleted size is--->'+acrContactLst.size());
                delete acrContactLst;   
            }
        System.debug('size acctlist-->'+accountList.size()+'...and accountlist--->'+accountList);
        
        if(contact.id != null){
          roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
        }
        System.debug('Before for loop creating acrContactRoles ->'+ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null));
        System.debug('role id in createAccountContactRole method of service::'+roleId);
        
        System.debug('inside createAccountContactRole, contact is --->'+contact+'----accountList--'+accountList.size());
        if(accountList != null && accountList.size() > 0){    
          for(Account account : accountList){
                aShareList.add(new AccountShare (AccountId=account.id , accountAccessLevel='Edit', 
                caseAccessLevel='Edit', opportunityAccessLevel='Edit', UserOrGroupId=user.Id));  
                
                acrContactRoles = new Account_Contact_Role__c();  
                System.debug('accountId--->'+account.id);
                acrContactRoles.Customer__c = account.id;  
                acrContactRoles.Contact__c= contact.id;  
                //System.debug('creating acr ->'+ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null));
                //acr.Role__c = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
                if(roleId != null){
                  acrContactRoles.Role__c = roleId;
                }
                System.debug('role->'+acrContactRoles.Role__c);
                System.debug('inside for loop acr is--->'+acrContactRoles);
                
                if(acrContactRoles != null){
                  acrList.add(acrContactRoles);
                }
            }
         }
            
         System.debug('acrList inserted/ updated in ACR--->'+acrList);
         System.debug('acrList inserted/ updated in ACR si8ze--->'+acrList.size());
         if(aShareList.isEmpty() == false){  
              upsert aShareList;
          }
         if(acrList.isEmpty() == false){ 
            System.debug('before upserting acrList-->'+acrList+'-----size----'+acrList.size());  
             insert acrList;
            System.debug('after upserting acrList--->'+acrList+'-----size----'+acrList.size());
         }
       }catch(Exception e){
          System.debug('createAccountContactRole else---------------'+e.getMessage());
          throw e;
       }
       return true;
    }
    */
    public List<ID> getAllRelatedCableUnits(){
        try {
            // Loop though all children and populate the accountsToShare list with the account ids 
            Integer level = 0;
           
            List<ID> accountIDList = new List<ID>{};
            List<ID> currentParent = new List<ID>{};
            List<Account> acctList = new List<Account>{};
            
            Boolean endOfStructure = false;
            
            //sc-107
            //System.debug('val--getAllRelatedCableUnits()--->'+getLoggedInUserContactDetails().accountId);
           // System.debug('val--getAllRelatedCableUnits()--->'+getLoggedInUserContactDetails().HierarchyAccount__c);
            
            while (!endOfStructure ){
                if(level==0){
                  //acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.id = :getLoggedInUserContactDetails().accountId];
                  if(getLoggedInUserContactDetails().HierarchyAccount__c != null){
                    acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.id = :getLoggedInUserContactDetails().HierarchyAccount__c];
                  }
                }else{
                    acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.ParentId IN :currentParent];
                }
                    
                if(acctList.size() == 0){
                    endOfStructure = true;
                }else {
                    currentParent.clear();
                    if(acctList.size() > 0){
                        for(Account acctObj : acctList){
                            accountIDList.add(acctObj.Id);
                            currentParent.add(acctObj.id);
                        }
                    }
                  level++;
                }
            }
            System.debug('accountIDList--->'+accountIDList.size());
            
            return accountIDList;
        }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'getAllRelatedCableUnits()',false,false,null,'Medium');
            return null;
        }   
    }
    
    public PageReference getStreetForAccount(ID accountId, Contact contact){
       boolean acctAddrFlag,contactAddrFlag;
       try{
          List<Account> acct = [Select a.Street_YK__r.Name, a.Street_YK__c, a.Name, a.Id From Account a where id=:accountId limit 1]; 
          if(acct.size() > 0){
             String streetName = acct[0].Street_YK__r.Name;
             acctAddrFlag = checkIfObjectIsNull(acct[0].Street_YK__c);
             contactAddrFlag = checkIfObjectIsNull(contact.Street_P__c);
             if(!acctAddrFlag){
                 if(!contactAddrFlag){
                     contact.Street_P__c = contact.Street_P__c;
                 }else{
                     contact.Street_P__c = acct[0].Street_YK__c;
                 }
              }else{
                    if(!contactAddrFlag){
                       contact.Street_P__c = contact.Street_P__c;
                    }
               }    
             }   
            }catch (Exception e) {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                    ApexPages.addMessage(errorMsg);
                    return null; 
            } 
            return null;
   }
 
    public ID getContactAccountId() { 
        system.debug('******Inside getContactAccountId()');
        try {
            system.debug('******Inside try getContactAccountId()');
            User user = [select contactid from User where id =:UserInfo.getUserId()];            
            system.debug('***user.contactid***'+user.contactid);
            List<Contact> contList = [select accountId, HierarchyAccount__c from Contact where id =:user.contactid limit 1];
            ID hierAccountId; 
            system.debug('***hierAccountId****'+hierAccountId);
            system.debug('**** contList.size()****'+contList.size());  
                     
            if(contList.size() > 0) {                   
               //accountId =  contList[0].accountId; 
                system.debug('****Inside if loop');
                if(contList[0] != null && contList[0].HierarchyAccount__c != null){
                    system.debug('****Inside hierAccountId if loop');   
                    hierAccountId =  contList[0].HierarchyAccount__c;                         
                }else{
                    return null;
                }
            } 
            system.debug('******End try getContactAccountId()');
            system.debug('**hierAccountId**'+hierAccountId);
            
            return hierAccountId;
        } catch (Exception e){
            //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            //ApexPages.addMessage(errorMsg);
          //  exceptionHandler.handleException(e,'getContactAccountId()',false,false,null);
          throw e;
            return null;
        }     
    }   
             
    public boolean checkIfObjectIsNull(Id addrReceived){
        if(addrReceived != null){
        // NOT NULL 
            return false;
        }else{
            //NULL
            return true;    
        } 
    }
    
    public String generatePassword(){
     try{ 
         Blob blobKey = crypto.generateAesKey(128); 
         String key = EncodingUtil.convertToHex(blobKey);   
         String newPwd = key.substring(0,8); 
         
         //return System.setPassword(user.id, newPwd);
         return newPwd;
     }catch(InvalidParameterValueException e){
         System.debug('generatePassword exception-----------'+e.getMessage());
        /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
         ApexPages.addMessage(errorMsg);
         exceptionHandler.handleException(e,'generatePassword()',false,false,null);*/
         throw e;
     }
    }
    
    /*
    public static boolean isMandatoryInfoMissingOnCU(List<Account> CustomerList) {
        try{
         if(CustomerList != null){
           for (Account Customer : CustomerList){
           //  if (Customer.Customer_Type__c=='Kunde'){
          // System.debug('Customer-----'+Customer);
             if(Customer.Type == 'Kunde'){
                System.debug('CableUnit'+Customer.Cable_Unit__c);
                System.debug('Condition1'+(Customer.Cable_Unit__r.Building_Type__c == '' ||  Customer.Cable_Unit__r.Building_Type__c == null));
                System.debug('Condition2'+(Customer.Cable_Unit__r.Name == '' || Customer.Cable_Unit__r.Name == null));
                System.debug('Condition3'+(Customer.Customer_Segment_Lookup__c == '' && Customer.Customer_Segment_Lookup__c == null));
                System.debug('Condition4'+(Customer.Cable_Unit__r.Housing_Ownership__c == '' ||  Customer.Cable_Unit__r.Housing_Ownership__c == null));
                System.debug('Condition5'+(Customer.Cable_Unit__r.Housing_Type__c == '' || Customer.Cable_Unit__r.Housing_Type__c == null));
                System.debug('Condition6'+(Customer.Cable_Unit__r.Municipaly__c =='' || Customer.Cable_Unit__r.Municipaly__c == null));
                System.debug('Condition7'+(Customer.Cable_Unit__r.Cable_Unit_Post_Code__c =='' || Customer.Cable_Unit__r.Cable_Unit_Post_Code__c == null));
                
                 if ((Customer.Cable_Unit__r.Building_Type__c == '' ||  Customer.Cable_Unit__r.Building_Type__c == null) ||
                        (Customer.Cable_Unit__r.Name == '' || Customer.Cable_Unit__r.Name == null) ||
                        (Customer.Customer_Segment_Lookup__c == '' && Customer.Customer_Segment_Lookup__c == null) ||
                        (Customer.Cable_Unit__r.Housing_Ownership__c == '' ||  Customer.Cable_Unit__r.Housing_Ownership__c == null) ||
                        (Customer.Cable_Unit__r.Housing_Type__c == '' || Customer.Cable_Unit__r.Housing_Type__c == null) || 
                        (Customer.Cable_Unit__r.Municipaly__c =='' || Customer.Cable_Unit__r.Municipaly__c == null) || 
                        (Customer.Cable_Unit__r.Cable_Unit_Post_Code__c =='' || Customer.Cable_Unit__r.Cable_Unit_Post_Code__c == null)
                        ){
                    
                       // System.debug('if block of 2nd if******');
                        return true;
                  } else {
                  //    System.debug('else block of 2nd if******');
                        return false;
                  }
              }  
           }
       }  
        }catch(Exception e){
            System.debug('exception in ismandatory***'+e.getMessage());
            throw e;
        }
       return false;
    } */
    
    
    public static boolean isMandatoryInfoMissingOnCU(List<Account> CustomerList) {
        try{
         Boolean mandatoryData = false;
         if(CustomerList != null){
           for (Account Customer : CustomerList){
           //  if (Customer.Customer_Type__c=='Kunde'){
          // System.debug('Customer-----'+Customer);
             if(Customer.Type == 'Kunde'){
                 if ((Customer.Cable_Unit__r.Building_Type__c != null) &&
                        (Customer.Cable_Unit__r.Name != null) &&
                        (Customer.Customer_Segment_Lookup__c != null) &&
                        (Customer.Cable_Unit__r.Housing_Ownership__c != null) &&
                        (Customer.Cable_Unit__r.Housing_Type__c != null) &&
                        (Customer.Cable_Unit__r.Municipaly__c != null) && 
                        (Customer.Cable_Unit__r.Cable_Unit_Post_Code__c != null) &&
                        (Customer.Cable_Unit__c != null)){
                        System.debug('#1#'+Customer.Cable_Unit__r.Building_Type__c+'@2@'+Customer.Cable_Unit__r.Name+'#3#'+Customer.Customer_Segment_Lookup__c+'#4#'+Customer.Cable_Unit__r.Housing_Ownership__c+'#5#'+Customer.Cable_Unit__r.Housing_Type__c+'#6#'+Customer.Cable_Unit__r.Municipaly__c+'#7#'+Customer.Cable_Unit__r.Cable_Unit_Post_Code__c+'$$$'+Customer.Cable_Unit__c);
                       // System.debug('if block of 2nd if******');
                        continue;
                     //   return false;
                  } else {
                  //    System.debug('else block of 2nd if******');
                  System.debug('#1222#'+Customer.Cable_Unit__r.Building_Type__c+'@222@'+Customer.Cable_Unit__r.Name+'#3222#'+Customer.Customer_Segment_Lookup__c+'#224#'+Customer.Cable_Unit__r.Housing_Ownership__c+'#52222#'+Customer.Cable_Unit__r.Housing_Type__c+'#622222#'+Customer.Cable_Unit__r.Municipaly__c+'#7222#'+Customer.Cable_Unit__r.Cable_Unit_Post_Code__c+'$$22222$'+Customer.Cable_Unit__c);
                        mandatoryData = true;
                        break;
                       // return true;
                  }
              }  
              
           }
           
       }  
        if(!mandatoryData){
            return false;
        }else{
            return true;
        }
        
        }catch(Exception e){
            System.debug('exception in ismandatory***'+e.getMessage());
            throw e;
        }
       return false;
    }  
     
    
  public Contact getLoggedInUserContactDetails(){
    try{
    Contact userContact = new Contact();
    System.debug('UserInfo.getUserId()--'+UserInfo.getUserId());
    userContact = [Select Street_P__r.Name, accountId, Name, HierarchyAccount__c From Contact  where id in(select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
    System.debug('#####User contact3'+userContact);
    return userContact;
    }catch(Exception e){
        System.debug('exception e---'+e.getMessage());
        throw e;
    }
  }
    
  // used when an existing contact is updated. user details should also get updated
  /*
   public User updateUser(List<Account> accountList, User userExist, Contact contact){
     User[] user;
     List<Id> listIdAShare = new List<Id>();
     Contact con = [select c.UserProfile__c from Contact c where c.Id = : contact.Id limit 10];
     system.debug('***User profile fetched form contact**'+ con.UserProfile__c);
     try {
       System.debug('inside updateUserTest user--->'+contact);
       if(contact != null){
          user = [Select u.Id, u.firstname, u.lastname, u.email,u.IsActive,u.ContactId,u.contact.accountid,u.contact.HierarchyAccount__c, u.ProfileId  From User u where u.Contactid =: contact.id limit 5];     
          System.debug('user in updateUser::'+user);
          if(user != null && user.size()> 0){ 
            if(user[0].isActive == false){
                System.debug('-----insdie updateUserTest-------- ');
                 user[0].email = contact.email;
                 user[0].firstname = contact.firstname;
                 user[0].lastname = contact.lastname;
                 System.Debug('Inside Portal User Contact Role---->'+contact.UserProfile__c);
                 user[0].isActive = true;
                 for(Account account:accountList){
                    listIdAShare.add(account.Id);
                 }
                 createAccountContactRoleActive(accountList, user[0], contact);  // create account contact roles
                 if(user != null && user.size()> 0){
                    System.debug('user info--->'+user[0]);
                  //updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email,user[0].isActive,listIdAShare);
                    updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email,user[0].isActive,user[0].ProfileId,listIdAShare);
                    System.debug('updated user--->'+user[0]);
                 }      
                 System.debug('------after createACR calllllll');
                 mailService.sendMailForAccountAssignment(user[0], accountList); // send notification mail for the new account assignmnet
                  
            }else{
                System.debug('-----inside else part in update user method last------');
                System.debug('User Size**'+user.size());
              if(user != null && user.size()> 0){
                  System.debug('Inside if when user.size is greater that 0');
                  user[0].email = contact.email;
                  user[0].firstname = contact.firstname;
                  user[0].lastname = contact.lastname;
                  user[0].isActive = true;
                  system.debug('**contact.UserProfile__c**'+con.UserProfile__c);
                  if(con.UserProfile__c != null){
                  Profile profile = [Select Id, name from profile where name = : con.UserProfile__c limit 10];
                  user[0].ProfileId = profile.Id;
                  System.debug('user info--->'+user[0].Profile);
                  System.debug('user info--->'+user[0]);
                  }
            //      update user[0];
                  updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email,user[0].isActive,user[0].ProfileId,listIdAShare);
                  System.debug('updated user--->'+user[0]);
                  createAccountContactRole(accountList, user[0], contact);  // create account contact roles
                  
                  mailService.sendMailForAccountAssignment(user[0], accountList); // send notification mail for the new account assignmnet
              }
            }
          }
            
       }
      return user[0];
    }catch (Exception e){
      system.debug('$e.getDmlType(0)$222222222222'+e.getDmlType(0)+'$Status code$'+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
      System.debug('updateUser else---------------'+e.getMessage());
      throw e;
    }    
   }
   */
   //updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email ,user[0].isActive;)
  //made for sc-p3  
   public boolean createAccountContactRoleActive(List<Account> accountList, User user, Contact contact){
      try {
        System.debug('inside createAccountContactRoleActive, contact is --->'+contact);
        Id roleId;
        Account_Contact_Role__c acr; 
        
        List<AccountShare> aShareList = new AccountShare[0];
        List<Account_Contact_Role__c> acrList= new Account_Contact_Role__c[0];
        List<ID> accountIdList = new List<ID>();
            
        if(accountList != null){
           for(Account acc : accountList){
             accountIdList.add(acc.Id);
           }
        }
            
        System.debug('accountIdList-in createAccountContactRoleActive-->'+accountIdList+'..and size ->'+accountIdList.size());            
        
        List<Account_Contact_Role__c> acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
               where c.Contact__c =: contact.Id and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
                                            
        System.debug('list acrContactList before for loop--->'+acrContactLst+'...and size is--->'+acrContactLst.size());
  
        if(acrContactLst.size() > 0){
            System.debug('inside if list acrContactList deleted size is--->'+acrContactLst.size());
            delete acrContactLst;
        }
       
        System.debug('size acctlist-->'+accountList.size()+'...and accountlist--->'+accountList);
        
        if(contact.id != null){
          roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
        }
        System.debug('Before for loop creating acr ->'+ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null));
        System.debug('role id in createAccountContactRole method of service::'+roleId);
        
        if(accountList != null){    
          for(Account account : accountList){
                //aShareList.add(new AccountShare (AccountId=account.id , accountAccessLevel='Edit', 
                //caseAccessLevel='Edit', opportunityAccessLevel='Edit', UserOrGroupId=user.Id)); 
                aShareList.add(new AccountShare (AccountId = account.Id, accountAccessLevel = 'All', caseAccessLevel = 'All', opportunityAccessLevel = 'All', UserOrGroupId = user.Id));
                
                acr = new Account_Contact_Role__c();  
                System.debug('accountId--->'+account.id);
                acr.Customer__c = account.id;  
                acr.Contact__c= contact.id;  
                if(roleId != null){
                  acr.Role__c = roleId;
                }
                System.debug('role->'+acr.Role__c);
                System.debug('inside createAccountContactRoleActive for loop acr is--->'+acr);
                
                if(acr != null){
                  acrList.add(acr);
                }
            }
         }
            
         System.debug('acrList inserted/ updated in ACR--->'+acrList);
         System.debug('acrList inserted/ updated in ACR si8ze--->'+acrList.size());
       
         if(acrList.isEmpty() == false){ 
            System.debug('before upserting acrList-->'+acrList+'-----size----'+acrList.size());  
            upsert acrList;  
            System.debug('after upserting acrList--->'+acrList+'-----size----'+acrList.size());
          }
          
         if(aShareList.isEmpty() == false){  
            //  upsert aShareList;
          }
           
       }catch(Exception e){
         //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
        // ApexPages.addMessage(errorMsg);
        // exceptionHandler.handleException(e,'createAccountContactRole()',false,false,null);
         throw e;
       }
       return true;
    }
   
   //Get called only SC_P3 AND SC_P5
   @future 
     public static void updateUserActive(ID userId, String firstName, String lastName, String email,Boolean activeFlag,Id profileId, List<Id> listIdAShare){
     PortalUserService service = new PortalUserService();
     PortalUserMailService mailService = new PortalUserMailService();
     CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('PortalUserService','Administration of portal users');
     Boolean bolsendMail = false; 
     Boolean bolsetPassword = false;
     String password;
     String nickname;
     List<String> splChar = new List<String> {'@','#','$','%','^','&','*','-','+','.','!'}; 
      try{
        User[] user;
        List<AccountShare> aShareList = new AccountShare[0];
        
        user = [Select u.Id, u.firstname, u.lastname, u.email,u.IsActive,u.CommunityNickname,u.ContactId,u.contact.accountid,u.contact.HierarchyAccount__c,u.ProfileId From User u where u.id =: userId];     
         if(user != null){
                 user[0].email = email;
                 user[0].firstname = firstName;
                 user[0].lastname = lastName;
                 if(user[0].isActive == false){
                    bolsendMail = true;
                    bolsetPassword = true;
                 }
                 user[0].isActive = activeFlag;
                 user[0].ProfileId = profileId;
                 inUserPortalServiceContext = true;
                 update user[0];
                   Contact contactAsUser = [select id from Contact where id =: user[0].ContactId];
                     if(contactAsUser != null){
                        if(bolsendMail == true){
                        //mailService.sendMailPortalUserCreation(password,contactAsUser);
                        System.debug('$password$$$$$$$'+password);
                         if(bolsetPassword == true){
                             nickname = user[0].CommunityNickname;
                             if(nickname != null){
                                 System.debug('List Characters'+splChar);
                                  for(String tempStr : splChar){
                                     System.debug('&&&&&&'+tempStr);
                                     if(nickname != null && nickname.contains(tempStr)){
                                        System.debug('inside if condtn contains');
                                        System.debug('nickname'+nickname);
                                     nickname = nickname.replace(tempStr,'');
                                     
                                     }
                                  }
                             //     nickname = nickname + 'a';
                             //     password = nickname + ServiceCenterTestUtil.getRandomNumber(1000);
                                    password = ServiceCenterTestUtil.getRandomAlphaNumericParam(8);
                                    password += ServiceCenterTestUtil.getRandomCharsName(3) + ServiceCenterTestUtil.getRandomNumeric(3);
                                  System.debug('password'+password);
                                  System.setPassword(user[0].id, password);
                             }
                        }
                        System.debug('$inactive user mail send$');
                        mailService.sendMailPortalUserCreationTest(password,contactAsUser);
                        }
                     }
                
             }
             
        }catch(Exception e){
             throw e;
             exceptionHandler.handleException(e,'updateUserActive()',false,false,null,'Medium');
        }
  
    }
      // creates account contact roles in modified way(testing) 
    public boolean createAccountContactRoleNew(List<Account> accountList, User user, Contact contact){
      try {
        Id roleId;
        Account_Contact_Role__c acrContactRoles; 
        List<ID> accountIdList = new List<ID>();
        List<Account> insertList = new List<Account>();
        List<AccountShare> aShareList = new AccountShare[0];
        List<Account_Contact_Role__c> acrList= new Account_Contact_Role__c[0];
        List<Account_Contact_Role__c> acrUpdateList= new Account_Contact_Role__c[0];
        Map<Id, Account_Contact_Role__c> selectListMap = new Map<Id, Account_Contact_Role__c>();  
        Database.SaveResult[] InsertResult;
        Database.SaveResult[] UpdateResult;
        List<Account_Contact_Role__c> acrContactLst = new List<Account_Contact_Role__c>();
        if(accountList != null && accountList.size() > 0){
           for(Account acc : accountList){
             accountIdList.add(acc.Id);
           }
        }
        if(accountIdList != null && accountIdList.size() > 0){
             acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
                where c.Contact__c =: contact.Id and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId()) and c.Customer__c in : accountIdList];
        }       
               
        if(acrContactLst != null &&  acrContactLst.size() > 0){
            for(Account_Contact_Role__c acnt : acrContactLst){
                selectListMap.put(acnt.Customer__c,acnt);
            }  
        }
        if(accountList != null && accountList.size() > 0){
           for(Account acrL : accountList){
                if(selectListMap.get(acrL.Id) == null){
                    insertList.add(acrL);
                }
           }
        }
       if(contact.id != null){
          if(contact.UserProfile__c != null){
          		roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRoleFromContact(contact);
          		//roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRoleUpdateFromContact(contact);      
          }
          else{
               //roleId = ServiceCenterSingleton.getInstance().getUpdatedLoggedInUserRole(contact.id,null);
               roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
          }
        }
        if(insertList != null && insertList.size() > 0){    
          for(Account account : insertList){
                aShareList.add(new AccountShare (AccountId=account.id , accountAccessLevel='Edit', 
                caseAccessLevel='Edit', opportunityAccessLevel='Edit', UserOrGroupId=user.Id));  
                acrContactRoles = new Account_Contact_Role__c();  
                acrContactRoles.Customer__c = account.id;  
                acrContactRoles.Contact__c= contact.id;  
                if(roleId != null){
                  acrContactRoles.Role__c = roleId;
                }
                if(acrContactRoles != null){
                  acrList.add(acrContactRoles);
                }
            }
         }
         if(aShareList.isEmpty() == false){  
              System.debug('Accnt Share--->'+aShareList);
              upsert aShareList;
          }
          Id roleIds;
           Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
           Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
        System.debug('portalAdminUser--->'+portalAdminUser+'%%portalUserProfile%%'+portalUserProfile);   
        if(contact.UserProfile__c == portalAdminUser){
            lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];
            roleIds = lcrRoleAdmin.Id;
            System.debug('admin roleIds--'+roleIds);
          }else if(contact.UserProfile__c  == portalUserProfile){
            lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesBruger];
            roleIds=lcrRoleUser.Id;
            System.debug('user roleIds--'+roleIds);
          }
          
        System.debug('portalUserRoleId--'+portalUserRoleId);
        System.debug('portalUserAdministratorRoleId---'+portalUserAdministratorRoleId+'%%%%roleIds'+roleIds);
        if(acrContactLst.isEmpty() == false){
            for(Account_Contact_Role__c acr : acrContactLst){
                if(acr.Role__c != null){
                    acr.Role__c = roleIds;
                }
                acrUpdateList.add(acr);
            }
         }
       System.debug('acrContactLst--'+acrContactLst.size());
        System.debug('acrUpdateList.size()---'+acrUpdateList.size());
         if(acrUpdateList.isEmpty() == false){
            if(acrUpdateList.size() < 50){
                System.debug('Total Number of script statements before ACR update '+  Limits.getScriptStatements());
            //    update acrUpdateList;
                UpdateResult = Database.update(acrUpdateList, true);    
            }else{
                SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrUpdateList, SC_BatchCreateEditDeleteContactRoles.OPERATION.UPDATE_ROLE); 
                Id jobId = Database.executebatch(batch, 50);
            }  
         }   
         if(acrList.isEmpty() == false){ 
            if(acrList.size() < 50){
                  //    insert acrList;    
                  System.debug('Total Number of script statements before ACR insert '+  Limits.getScriptStatements());
                  InsertResult = Database.insert(acrList, true);            
            }else{
                    System.debug('Total Number of script statements before ACR entry in this apex code context: '+  Limits.getScriptStatements());
                    SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrList, SC_BatchCreateEditDeleteContactRoles.OPERATION.CREATE_ROLE); 
                    Id jobId = Database.executebatch(batch, 50);
                    System.debug('Total Number of script statements before ACR entry in this apex code context: '+  Limits.getScriptStatements());            
                    System.debug('Total Number of script statements After ACR entry in this apex code context: '+  Limits.getScriptStatements());
            }
            
         }
       }catch(Exception e){
          throw e;
       }
       return true;
    }
    
/*@future
   public static void associateUserToGroup(Id id){
    try{
      String groupName = ServiceCenter_CustomSettings__c.getInstance('SC_Public_Group').Value__c;
      List<Group> groupList = [Select g.Id, g.Name From Group g where g.Name =: groupName];
      GroupMember groupMember = new GroupMember();
      groupMember.GroupId = groupList.get(0).id;
      groupMember.UserOrGroupId = id;
      insert groupMember;
    }catch(Exception e){
        throw e;
    }
   }*/
   
   
   
    public boolean createAccountContactRoleNewActive(List<Account> accountList, User user, Contact contact){
      try {
        Id roleId;
        Account_Contact_Role__c acrContactRoles =  new Account_Contact_Role__c(); 
        List<ID> accountIdList = new List<ID>();
        List<AccountShare> aShareList = new AccountShare[0];
        List<Account> insertList = new List<Account>();
        List<Account_Contact_Role__c> acrList= new Account_Contact_Role__c[0];
        List<Account_Contact_Role__c> acrUpdateList= new Account_Contact_Role__c[0];
        Database.SaveResult[] InsertResult;
        Database.SaveResult[] UpdateResult;
        Map<Id, Account_Contact_Role__c> selectListMap = new Map<Id, Account_Contact_Role__c>();  
        if(accountList != null && accountList.size() > 0){
           for(Account acc : accountList){
             accountIdList.add(acc.Id);
           }
        }
        List<Account_Contact_Role__c> acrContactLst =[Select c.Id,c.Customer__c , c.Contact__c,c.Role__c,c.RoleName__c from Account_Contact_Role__c c 
               where c.Contact__c =: contact.Id and (c.Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or c.Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
        if(acrContactLst.size() > 0){
            for(Account_Contact_Role__c acnt : acrContactLst){
                selectListMap.put(acnt.Customer__c,acnt);
            }  
        }
       if(accountList.size() > 0){ 
        for(Account acrL : accountList){
         if(selectListMap.get(acrL.Id) == null){
           insertList.add(acrL);
         }
        }
       }
       if(contact.id != null){
          if(contact.UserProfile__c != null){
                roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRoleFromContact(contact);      
          }
          else{
            roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contact.id,null);
          }
       }
       if(insertList != null && insertList.size() > 0){    
          for(Account account : insertList){
                acrContactRoles = new Account_Contact_Role__c();  
                acrContactRoles.Customer__c = account.id;  
                acrContactRoles.Contact__c= contact.id;  
                if(roleId != null){
                  acrContactRoles.Role__c = roleId;
                }
                if(acrContactRoles != null){
                  acrList.add(acrContactRoles);
                }
            }
         }
           Id roleIds;
           Lookup_Contact_Roles__c lcrRoleAdmin = new Lookup_Contact_Roles__c();
           Lookup_Contact_Roles__c lcrRoleUser = new Lookup_Contact_Roles__c();
        if(contact.UserProfile__c == [Select name from Profile where name =: portalAdminUser limit 1].name){
            lcrRoleAdmin = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesAdministrator];
            roleIds = lcrRoleAdmin.Id;
          }else if(contact.UserProfile__c  == [Select name from Profile where name =: portalUserProfile limit 1].name){
            lcrRoleUser = [Select Id, Name from Lookup_Contact_Roles__c  where name  =: contactRolesBruger];
            roleIds=lcrRoleUser.Id;
          }
          
        if(acrContactLst.isEmpty() == false){
            for(Account_Contact_Role__c acr : acrContactLst){
                if(acr.Role__c != null){
                    acr.Role__c = roleIds;
                    
                }
                acrUpdateList.add(acr);
            }
         }
         if(acrUpdateList.isEmpty() == false){
            if(acrUpdateList.size() < 50){
                //update acrUpdateList;
                UpdateResult = Database.update(acrUpdateList, true);    
            }else{
                SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrUpdateList, SC_BatchCreateEditDeleteContactRoles.OPERATION.UPDATE_ROLE); 
                Id jobId = Database.executebatch(batch, 50);
            }
              
         }  
         if(acrList.isEmpty() == false){
            if(acrList.size() < 50){
                System.debug('Inside Less than 50');
                InsertResult = Database.insert(acrList, true);
                //insert acrList;               
            }else{
                System.debug('Total Number of script statements before ACR entry in this apex code context: '+  Limits.getScriptStatements());
                System.debug('Inside Active Update');
                SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(acrList, SC_BatchCreateEditDeleteContactRoles.OPERATION.CREATE_ROLE); 
                Id jobId = Database.executebatch(batch, 50);            
                System.debug('Total Number of script statements After ACR entry in this apex code context: '+  Limits.getScriptStatements());
            }
         }
       }catch(Exception e){
          throw e;
       }
       return true;
    }
    
    // used when an existing portal user is updated in modified way(testing)
    public void updateAccountAssignmentNew(User user, Contact contact, List<Account> accountCreatedList, List<Account> accountDeletedList,  List<ID> accountIdDeletedList){
      try{
         inPortalContext = true;
         deleteAccountContactRole(accountIdDeletedList, user, contact); 
         createAccountContactRoleNew(accountCreatedList, user, contact);  // create account contact roles
       }catch(Exception e){
         throw e;
     }  
    }
    public void editPortalUserNew(Contact contactToBeUpdated, List<ID> accountCreatedListIDs, List<Account> accountCreatedList, List<Account> accountDeletedList,  List<ID> accountIdDeletedList){
      User portalUserToBeUpdated = new User();
      //Contact updatedContact = new Contact();
      Savepoint sp = Database.setSavepoint();
      try{
          //Static Variable used for restricting  the trigger to fire while updating contact and user
          inPortalContext= true;
          inUserPortalServiceContext = true;
          String contactProfile;
          if(contactToBeUpdated.UserProfile__c == null){
           contactProfile = [select UserProfile__c from Contact where Id =: contactToBeUpdated.Id].UserProfile__c;
          } 
          if(contactToBeUpdated != null){
            if(contactProfile != null){
               contactToBeUpdated.UserProfile__c = contactProfile;
            }
            system.debug('contactToBeUpdated'+contactToBeUpdated);
            update contactToBeUpdated; // update the contact details
          }
          System.debug('3rd Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
          portalUserToBeUpdated = [Select Id from User where contactId =: contactToBeUpdated.Id];
          if(accountIdDeletedList.size() > 0){
            deleteAccountContactRole(accountIdDeletedList, portalUserToBeUpdated, contactToBeUpdated);
          }  
          System.debug('4th Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());     
          portalUserToBeUpdated = updateUserNew(accountCreatedList, portalUserToBeUpdated, contactToBeUpdated);
          System.debug('5th Total Number of script statements allowed in this apex code context: '+  Limits.getScriptStatements());
         
      }catch(Exception e){
        Database.rollback(sp);
        throw e;
     }
    }
      // used when an existing contact is updated. user details should also get updated
   public User updateUserNew(List<Account> accountList, User userExist, Contact contact){
     User[] user;
     List<Id> listIdAShare = new List<Id>();
     try {
       if(contact != null){
          user = [Select u.Id, u.firstname, u.lastname, u.email,u.IsActive,u.ContactId,u.contact.accountid,u.contact.HierarchyAccount__c, u.ProfileId,u.Profile.Name  From User u where u.Contactid =: contact.id];     
          if(user != null && user.size()> 0){ 
             System.debug('User Details:'+ user);
             if(contact.UserProfile__c != null){
               Profile profile = [Select Id, name from profile where name = : contact.UserProfile__c];
               user[0].ProfileId = profile.Id;
             }
            if(user[0].isActive == false){
                 user[0].email = contact.email.trim();
                 user[0].firstname = contact.firstname;
                 user[0].lastname = contact.lastname;
                 user[0].isActive = true;
                 createAccountContactRoleNewActive(accountList, user[0], contact);  // create account contact roles
                 if(user != null && user.size()> 0){
                   updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email,user[0].isActive,user[0].ProfileId,listIdAShare);
                 }       
            }else{
                if(user != null && user.size()> 0){
                  user[0].email = contact.email.trim();
                  user[0].firstname = contact.firstname;
                  user[0].lastname = contact.lastname;
                  user[0].isActive = true;
                  createAccountContactRoleNew(accountList, user[0], contact);  // create account contact roles
                  updateUserActive(user[0].id,user[0].firstname,user[0].lastname,user[0].email,user[0].isActive,user[0].ProfileId,listIdAShare);
              }
            }
          }
       }
      return user[0];
    }catch (Exception e){
       throw e;
        return null;
    }    
   }
   
   
}