/** 
 Title          : ContactService
 Purpose        : This service will handle create, edit, delete operations for Contacts
 Functionality  : Manage own Contacts
 Application    : ServiceCenter Application
*/
public class ContactService {
  //ContactMailService mailService = new ContactMailService(); 
  public static Boolean tempFlag = false;
  public static boolean inContactPortalServiceContext = false;
  public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ContactService','Manage Contacts');
  public ContactService(){
      tempFlag = false;
  } 
  public void createContact(ID accountId, Contact contact, ID[] rolesAssigned, String cableunitNumber,String selectedRoleValues, String antalKopier){   
    Savepoint sp = Database.setSavepoint();
    Contact contactToBeInserted = new Contact();
    // List<ID> rolesNameList = new List<String>();
    Contact userContact =  getLoggedInUserContact();
    clsContactsAddAccount util = new clsContactsAddAccount();
    List<Contact> contactListToBeCreated = new List<Contact>();
    List<Account_Contact_Role__c> contactRolesToBeInserted = new List<Account_Contact_Role__c>();
    try {
 //       contactToBeInserted.accountId = accountId;  Removed as a part of SC-508
        contactToBeInserted.Status__c = contactConstClass.ACTIVE;
        //Contact cont = getLoggedInUserContact();
        System.debug('getLoggedInContact: '+userContact.HierarchyAccount__c);
        contactToBeInserted.HierarchyAccount__c = userContact.HierarchyAccount__c;
        contactToBeInserted.FirstName = contact.FirstName;
        contactToBeInserted.LastName = contact.LastName;
        if(contact.Email != null){
        contactToBeInserted.Email = contact.Email.trim();
        }
        contactToBeInserted.Phone = contact.Phone;
        contactToBeInserted.MobilePhone = contact.MobilePhone;
        contactToBeInserted.HomePhone = contact.HomePhone;
        contactToBeInserted.Street_P__c = contact.Street_P__c;
        contactToBeInserted.RecordTypeId = contactConstClass.ContactRecordType;
        contactListToBeCreated.add(contactToBeInserted);
        util.addDummyAccounts(contactListToBeCreated); 
        System.debug('contact: '+contact);
        if(contactToBeInserted.Status__c == contactConstClass.ACTIVE){
            insert contactToBeInserted;
        }
        Id indbliksadresseRole = [Select Id, Name from Lookup_Contact_Roles__c  where name = :Label.SC_IndbliksadresseRoleCheck].Id;
        Account_Contact_Role__c acr = new Account_Contact_Role__c();
        for(ID roleId : rolesAssigned){
            acr = new Account_Contact_Role__c();
            acr.Role__c = roleId;
            acr.Customer__c = accountId;
            acr.Contact__c = contactToBeInserted.id;
            contactRolesToBeInserted.add(acr);
            if(roleId == indbliksadresseRole){
                acr.Total_Insight__c = antalKopier; 
            }
        }
        if(contactRolesToBeInserted.size() > 0)
            insert contactRolesToBeInserted;
            if(tempFlag == true){
            	integer k;
            	k = 10/0;
            }
            
    }catch(Exception e){
        Database.rollback(sp);
        throw e;
    }
    }  
      
  public void deleteContact(Id contactId ,ID accountId ,string cableunitnumber ,string selectedRoleValues){      
   try {
      Contact contact = [Select c.Id, c.Status__c, c.FirstName, c.LastName, c.email, c.phone, c.mobilephone, c.homephone, c.Street_P__r.Name  From Contact c where c.Id =: contactId];
      User[] user = [Select Id from User where contactId =: contactId limit 1];
      if(user != null && user.size() > 0){
        List<Account_Contact_Role__c> contactRolesToBeDeleted = [Select a.Id from Account_Contact_Role__c a  where a.Contact__c =: contactId and a.Role__c !=: ServiceCenterSingleton.getInstance().getLoggedInUserRole(contactId,null) and a.Customer__c =: accountId and a.Role__r.Visible_in_Service_Centre__c = true and a.Role__r.Active__c = 'Ja' ];
        delete contactRolesToBeDeleted;
      }else{
        List<Account_Contact_Role__c> contactRolesToBeDeleted = [Select a.Id,a.RoleName__c,a.Role__c from Account_Contact_Role__c a  where a.Contact__c =: contactId and a.Role__r.Visible_in_Service_Centre__c = true and a.Role__r.Active__c = 'Ja' and a.Customer__c =: accountId ];
        delete contactRolesToBeDeleted;
      }
      /*if(tempFlag == true){
            integer i;
            i = 10/0;
      }*/
    }catch(Exception e){
    	throw e;
    }
  }
  
   
    public void editContactNew(Contact contact, ID accountId, ID[] rolesAssigned, String cableunitNumber,String selectedRoleValues, String antalKopier){
    String indbliksadresseRoleName;
    Id indbliksadresseRoleId;
    List<Account_Contact_Role__c> contactRolesToBeUpdated = new Account_Contact_Role__c[0];
    Savepoint sp = Database.setSavepoint();
    try{
        
        Contact contactToBeUpdated = new Contact();
        contactToBeUpdated = contact;
          if(contactToBeUpdated != null){
              inContactPortalServiceContext = true;
              update contactToBeUpdated;
          }
        
      List<Account_Contact_Role__c> oldContactRolesToBeDeleted = [Select a.Id , a.Role__c,a.RoleName__c from Account_Contact_Role__c a  where a.Contact__c =: contactToBeUpdated.id and a.Customer__c =: accountId and a.Role__c !=: ServiceCenterSingleton.getInstance().getLoggedInUserRole(contactToBeUpdated.id,null)];
      Map<Id, Account_Contact_Role__c> oldListMap = new Map<Id, Account_Contact_Role__c>();
      //added-295
      Map<Id, String> oldRoleMap = new Map<Id, String>();
      List<Id> newRoles = new List<Id>();
      if(oldContactRolesToBeDeleted.size() > 0){
          for(Account_Contact_Role__c acrM : oldContactRolesToBeDeleted){
                oldListMap.put(acrM.Role__c,acrM);
                oldRoleMap.put(acrM.Role__c,acrM.RoleName__c);
          }
      }
      Lookup_Contact_Roles__c indbliksadresseRoleRecord = [Select Id,Name From Lookup_Contact_Roles__c where name =: Label.SC_IndbliksadresseRoleCheck limit 1];
      if(indbliksadresseRoleRecord != null){
       indbliksadresseRoleName = indbliksadresseRoleRecord.Name;
       indbliksadresseRoleId = indbliksadresseRoleRecord.Id;
      }
      if(rolesAssigned.size() > 0){
          for(Id roles1 : rolesAssigned){
            if(oldListMap.get(roles1) != null){
                if(!(oldRoleMap.get(roles1) != null && indbliksadresseRoleName != null && oldRoleMap.get(roles1) == indbliksadresseRoleName)){
                 oldListMap.remove(roles1);
                }else{
                  newRoles.add(roles1);     
                }
            }else{
                newRoles.add(roles1);   
            }
          }
     }
      List<Account_Contact_Role__c> deletedRoles1 = new List<Account_Contact_Role__c>();
      Set<Id> delnewRoles = new Set<Id>();
      delnewRoles = oldListMap.keyset();
      if(delnewRoles != null && delnewRoles.size() > 0){
          for(ID rolesSel : delnewRoles){
            deletedRoles1.add(oldListMap.get(rolesSel));
          }
      }
     if(deletedRoles1 != null && deletedRoles1.size() > 0){
        delete deletedRoles1;
      } 
     
      List<String> rolesNameList = new List<String>();
      if(newRoles != null){
       for(ID option : newRoles){
         Account_Contact_Role__c acr = new Account_Contact_Role__c();
         acr.Role__c = option;
         if(accountId != null){
           acr.Customer__c = accountId;
         }
         if(contactToBeUpdated != null){
            acr.Contact__c = contactToBeUpdated.id;
         }
         if(indbliksadresseRoleId != null && option == indbliksadresseRoleId){
            acr.Total_Insight__c = antalKopier.trim();
         }
         rolesNameList.add(option);
         if (acr != null){
            contactRolesToBeUpdated.add(acr);
         }
       }
      }
      if(!contactRolesToBeUpdated.isEmpty()){ 
        insert contactRolesToBeUpdated; 
      }
      User[] portalUserToBeUpdated = [Select Id, firstname, lastname, isActive, email, Name  from User where contactId =: contactToBeUpdated.id limit 1];
      if(portalUserToBeUpdated != null && portalUserToBeUpdated.size() > 0){
         portalUserToBeUpdated[0].email = contactToBeUpdated.email;
         portalUserToBeUpdated[0].firstname = contactToBeUpdated.firstname;
         portalUserToBeUpdated[0].lastname = contactToBeUpdated.lastname;
         update portalUserToBeUpdated[0];
       }
   }catch(Exception e){
         Database.rollback(sp);
         throw e;
     } 
  }


  // used for returning all roles which are specific to ServiceCenter Application
  public List<Lookup_Contact_Roles__c> getAllRoles(){
        return [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true];
  }
    
    //Used to form contact details in display format for Create and Edit Contact functionality 
    public List<ContactRoleAccount> refineContacts(List<Contact> contactPhone){
        List<ContactRoleAccount> filteredContacts = new List<ContactRoleAccount>(); 
        try{
            List<Id> contactIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            //created for fetching from the method getLoggedInUserRole(ID loggedInId,null) in ServiceCenterSingleton class
            List<Id> roleIds = new List<Id>();
            Map<Id, String> mapContactIdRole = new Map<Id, String>();
            Map<Id, String> mapAccountIdCUId = new Map<Id, String>();
            string roleName;
            ID roleId;
            for(Contact contct:contactPhone){
                contactIds.add(contct.Id);
                roleId = ServiceCenterSingleton.getInstance().getLoggedInUserRole(contct.Id,null);
                roleIds.add(roleId);
                accountIds.add(contct.accountId);
            }
            if(contactIds.size() > 0){
              List<Account_Contact_Role__c> accountContactRoles = [select id,Contact__c, Customer__c, Last_Name__c, Email__c, First_Name__c, 
                                                                    Home_Phone__c, Phone__c, Role__c, RoleName__c, Street_P__c, 
                                                                    Mobile_Phone__c from Account_Contact_Role__c 
                                                                    where Contact__c in :contactIds and Contact__r.Status__c='Aktiv' and 
                                                                    Role__c in :roleIds ] ;                                                     
              if(accountContactRoles.size() > 0){
                 for(Account_Contact_Role__c accountContactRole:accountContactRoles){
                   if(mapContactIdRole.containsKey(accountContactRole.Contact__c)){
                        roleName= mapContactIdRole.get(accountContactRole.Contact__c) + ','+ accountContactRole.RoleName__c;
                    }else{
                        roleName= accountContactRole.RoleName__c;
                        mapContactIdRole.put(accountContactRole.Contact__c,roleName);
                   }     
                  }   
               }
                                
             }//End of if
             if(accountIds.size() > 0){
               for(Cable_Unit__c cableUnit :[select Customer__c,Id from Cable_Unit__c where Customer__c in :accountIds]){
                  mapAccountIdCUId.put(cableUnit.Customer__c, cableUnit.Id);
               }
             }
                
             ContactRoleAccount contactRoleAcc = new ContactRoleAccount();
             for(Contact contct:contactPhone){
                    contactRoleAcc = new ContactRoleAccount(contct);    
                    contactRoleAcc.roleName =  mapContactIdRole.get(contct.Id); 
                    contactRoleAcc.cUId     =  mapAccountIdCUId.get(contct.accountId); 
                    filteredContacts.add(contactRoleAcc);
             }
             if(tempFlag == true){
                 integer i;
                 i = 10/0;
             }
        }catch(exception ex){
            System.debug('Error'+ex.getMessage());
            throw ex;
        }
        return filteredContacts;
    }
    
    //Added - sc-c5- sc-c6 nov specs - priyanka
    public Contact getLoggedInUserContact(){
     try{
     	Contact userContact = new Contact();
        userContact = [Select Street_P__r.Name, HierarchyAccount__c,AccountId From Contact  where id in(select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
        System.debug('userContact getLoggedInUserContact----'+userContact);
        if(tempFlag == true){
           integer i;
           i = 10/0;
        }
        return userContact;
       
     }catch(Exception e){
       return null;
     }
    }
    
    public List<ID> getAllRelatedAccounts(){
      Integer level = 0;
      // Loop though all children and populate the accountsToShare list with the account ids
      List<ID> accountIDList = new List<ID>{};
      List<ID> currentParent = new List<ID>{};
      List<Account> acctList = new List<Account>{};
      Boolean endOfStructure = false;
            
      while (!endOfStructure ){
         if(level==0)
             acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.id = :getLoggedInUserContact().accountId];
         else
             acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.ParentId IN :currentParent];
                    
          if(acctList.size() == 0){
             endOfStructure = true;
          }else {
             currentParent.clear();
             for(Account acctObj : acctList){
                accountIDList.add(acctObj.Id);
                currentParent.add(acctObj.id);
             }
            level++;
           }
       }//End of while
       return accountIDList;
    }
    
     
    public static boolean isMandatoryInfoMissingOnCU(List<Account> CustomerList) {
        try{
         if(CustomerList != null){
           for (Account Customer : CustomerList){
           if(Customer.Type == 'Kunde'){
           		 if ((Customer.Cable_Unit__r.Building_Type__c != null) && (Customer.Cable_Unit__r.Name != null) && (Customer.Customer_Segment_Lookup__c != null) && (Customer.Cable_Unit__r.Housing_Ownership__c != null) && (Customer.Cable_Unit__r.Housing_Type__c != null) && (Customer.Cable_Unit__r.Municipaly__c != null) && (Customer.Cable_Unit__r.Cable_Unit_Post_Code__c != null) && (Customer.Cable_Unit__c != null)){
           		 		return false;
                  }
                  else {
                  		return true;
                  }
              }  
           }
       }
       }
       catch(Exception e){
            throw e;
        }
       return false;
    }  
      
}