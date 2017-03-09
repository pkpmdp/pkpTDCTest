/*
    @Author: mkha@yousee.dk 
    
    Description: Handles various tasks after an external role has been created or updated.  
    
    Test types:
    Primary: Test as much functionality as possible.
    Secondary: Only some code fragments are tested. Those classes have their own primary test classes.
    
    Test class:
    clstgrAccountContactRoleTest (Primary)  
    clsContactTest (Secondary)
*/

trigger tgrAccountContactRoleAfterInsertUpdate on Account_Contact_Role__c (after insert, after update, after delete) {
    //Retrive ID for Cast Iron User for bypassing validation.    
    //public static User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    List <Account_Contact_Role__c> contactRoles = new List<Account_Contact_Role__c>();
        
    //Map containing Account HierarchyField to be updated on Contact
    Map<Id,Id> contactWithHierarchyField = new Map<Id,Id>();
    Set<ID> contacttobeexclude = new Set<ID>();
    //Set containing candidate map for deactivating contacts
    Set <Id> CandidateContactsToBeDeactivated = new Set<Id>();
    Set<ID> nonPortalContactRoles = new Set<ID>();
    List<Contact> conTobeUpdated = new List<Contact>();
    //Updates with the CI user from datawarehouse must not be allowed to trigger the logic in this trigger.
    if (UserInfo.getUserId() != userCIId){
        //If delete trigger, then add contact to this Set for deactivation check. According to business rules, contacts with no contact roles are automatically deactivated. 
        
        if(Trigger.isInsert || Trigger.isUpdate){
            /*
            This after insert trigger inserts the Salesforce ID into ContactRoleExternalID__c on external contact roles created on hierarchy customers.
            The background is because contact roles added on hierarchy customers are not created in KISS, thus no external id is received.
            Instead, these contact roles are stored directly in datawarehouse bypassing KISS. To ensure consistency in the use of external id we
            reuse the Salesforce id as external id.
            */
            //Set <Id> acrs = Trigger.isDelete || Trigger.isUpdate ? Trigger.oldMap.keySet() : Trigger.newMap.keySet();
            for(Account_Contact_Role__c acr: [Select Id, ContactRoleExternalID__c, Contact__c, Customer__r.ParentId, Customer__c, Customer_Type__c, Customer__r.SuperiorAccount__c from Account_Contact_Role__c where Id IN : trigger.new]){
                //SF-28 - special logic for contact roles on hierarchy customers on update and insert                
                
                
                if(acr.Customer_Type__c == 'Hierarki' && acr.ContactRoleExternalID__c == null){
                    //We use the cloning capability to update fields after creation
                    System.debug('%%%Inside');
                    Account_Contact_Role__c acr_tmp = acr.clone(true, true);                                    
                    acr_tmp.ContactRoleExternalID__c = acr.Id;
                    contactRoles.add(acr_tmp);                      
                }
                          
                //We insert  all contacts to allow updates of status and for setting HierarchyAccount__c field contact. 
                //Calculate SuperiorAccount based on the account record
                Id newSuperiorAccount = acr.Customer__r.ParentId != null ? acr.Customer__r.SuperiorAccount__c : acr.Customer__c;
                if(contactWithHierarchyField.get(acr.Contact__c) == null)
                    contactWithHierarchyField.put(acr.Contact__c, newSuperiorAccount);
            }   
         }//Close for-loop for (Trigger.isInsert || Trigger.isUpdate)
   }//Close if not Cast Iron
   
   //This code must be placed before processing Set 'contactWithPortalUser' displayed below. Otherwise, errors can occur.
   if(Trigger.isDelete){
        for(Account_Contact_Role__c acr : trigger.old){
            if(!CandidateContactsToBeDeactivated.contains(acr.Contact__c))
                CandidateContactsToBeDeactivated.add(acr.Contact__c);      
                nonPortalContactRoles.add(acr.Role__c);            
        }
        System.debug('$$$CandidateContactsToBeDeactivated$$$'+CandidateContactsToBeDeactivated+'#####nonPortalContactRoles'+nonPortalContactRoles);
        if(CandidateContactsToBeDeactivated.size() > 0){
          contacttobeexclude.addAll(CandidateContactsToBeDeactivated);
          for(Account_Contact_Role__c roleCount : [select Id, contact__c,Role__c from Account_Contact_Role__c where contact__c  =: CandidateContactsToBeDeactivated and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())]){
            contacttobeexclude.remove(roleCount.Contact__c);
          }
            System.debug('%%%%%%countACRMap'+contacttobeexclude);  
        }
    }
   
   //Update list of contact roles with external ID
   System.debug('############contactRoles'+contactRoles);
   
   if(contactRoles.size() > 0)
        Database.update(contactRoles);
   
   //This section checks which contacts are also portal users in the Set 'CandidateContactsToBeDeactivated'. This is used to prevent HierarchyAccount__c to be nulified on active portal users.
    Set<Id> contactWithPortalUser = new Set<Id>();  
    //First, we get ids from contacts where roles are deleted
    if(CandidateContactsToBeDeactivated.size() > 0){
      for(User portalUser1: [Select ContactId from User where IsActive = true and ContactId IN : CandidateContactsToBeDeactivated]){
          if(!contactWithPortalUser.contains(portalUser1.ContactId))
              contactWithPortalUser.add(portalUser1.ContactId);
          
      }
    }    
    //Second, we get ids from contacts where roles are updated or added
    
    if(contactWithHierarchyField.size() > 0){
      for(User portalUser2: [Select ContactId from User where IsActive = true and ContactId IN : contactWithHierarchyField.keySet()]){
          if(!contactWithPortalUser.contains(portalUser2.ContactId))
              contactWithPortalUser.add(portalUser2.ContactId);
      }       
    }
   //Update contacts with hierarchyfield and status info
    if(contactWithHierarchyField.size() > 0){
        List <Contact> contactsToBeUpdated = new List<Contact>();        
        for(Contact con: [Select Id, Status__c, HierarchyAccount__c from Contact where Id  IN : contactWithHierarchyField.keySet()]){  
            Id hierarchyAccount = contactWithHierarchyField.get(con.Id);
            boolean updatedObj = false;
            if( hierarchyAccount != null && 
             ( (con.HierarchyAccount__c != null && con.HierarchyAccount__c != hierarchyAccount && !contactWithPortalUser.contains(con.Id) ) ||
               (con.HierarchyAccount__c == null) )){
                con.HierarchyAccount__c = hierarchyAccount;
                updatedObj = true;  
            }
            if(con.Status__c != 'Aktiv'){
                con.Status__c = 'Aktiv';
                con.Inactive_Reason__c = '';
                updatedObj = true;  
            }
            if(updatedObj == true) 
                contactsToBeUpdated.add(con);
        } 
        //Update contacts
        if(contactsToBeUpdated.size() > 0){
            //We use a try block because some contacts without mandatory data can cause validation errors, thus causing an error in portal or CRM           
            try{            
                Database.SaveResult[] resultsContact1 = Database.update(contactsToBeUpdated);
            }catch(Exception e){
                system.debug('Error updating contacts due for updating (scenario: activation + update: ' + e.getMessage());
            }   
        }//End if contacts should be updated 
    }
    //Perform deactivation check. If no more contact roles, then deactivate.       
    List<Contact> contactsToBeDeactivated = new List<Contact>();
    //Contacts without roles are deactivated. We don't deactivate if deletion is taking place from batch job 'SC_AcquireExternalIdForContactRoles' because this would remove the hierarchy account for portal users.
    //Thus we have implemented this safe guard.
   
    
    
    
    //if(CandidateContactsToBeDeactivated.size() > 0 && !System.isBatch() && !System.isScheduled()){
    if(CandidateContactsToBeDeactivated.size() > 0){
       //If contact has no more contact roles after deletion, then the contact must be deactivated according to business rules.        
        //clsAsyncMethods.updateContactStatus(CandidateContactsToBeDeactivated, contactWithPortalUser);
       
       Set<Id> aggResultSet = new Set<Id>();
      /*for(Account_Contact_Role__c acr : [Select Contact__c from Account_Contact_Role__c where Contact__c!= null and Contact__c IN :CandidateContactsToBeDeactivated and isDeleted = false]){
             aggResultSet.add(acr.Contact__c);
      }*/
       
        for(AggregateResult agrList : [Select Contact__c from Account_Contact_Role__c where Contact__c IN : CandidateContactsToBeDeactivated group by Contact__c]){
           aggResultSet.add((ID)agrList.get('Contact__c'));
        }
        
        /*
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for(Contact con: [select Id from Contact where Id IN (Select Contact__c from Account_Contact_Role__c where Contact__c IN : CandidateContactsToBeDeactivated)]){
                    if(contactMap.get(con.Id) == null)
                        contactMap.put(con.Id, con);              
        }*/
        System.debug('$$$$$$$$44CandidateContactsToBeDeactivated$'+CandidateContactsToBeDeactivated.size());
           //System.debug('#After else#'+aggResultSet.size());
       for(Contact con: [select Id from Contact where Id IN : CandidateContactsToBeDeactivated and Id NOT IN : aggResultSet]){                              
            con.Status__c = 'Inaktiv';
            con.Inactive_Reason__c = 'Automatisk deaktiveret - ingen kontaktroller';
            
            //Rule: If contact is still portal user, we don't nullify the hierarchy account assignment. This is only done on ordinary YS contacts who no longer are associated with any customer hierarhy.
            if(!contactWithPortalUser.contains(con.Id))         
                con.HierarchyAccount__c = null;
             
            contactsToBeDeactivated.add(con);                           
        }
        System.debug('### after Limits.getScriptStatements();#'+Limits.getScriptStatements()+'$Afte $Numbers of Scripts$'+Limits.getLimitScriptStatements());
        //Update contacts
        if(contactsToBeDeactivated.size() > 0){
            //We use a try block because some contacts without mandatory data can cause validation errors, thus causing an error in portal or CRM
            try{            
                Database.SaveResult[] resultsContact2 = Database.update(contactsToBeDeactivated);
            }catch(Exception e){
                system.debug('Error updating contacts due for deactivation scenario: ' + e.getMessage());
            }   
        }//End if contacts should be updated
       
       if(contacttobeexclude.size() > 0){
       		System.debug('####Inside  aaaa'+ServiceCenterSingleton.getInstance().getUserRoleId() + '$$$$$$$$ bbbbbb'+ServiceCenterSingleton.getInstance().getAdminRoleId());
       		if(nonPortalContactRoles.contains(ServiceCenterSingleton.getInstance().getUserRoleId()) || nonPortalContactRoles.contains(ServiceCenterSingleton.getInstance().getAdminRoleId())){
           		List<Contact> conList = [Select Id from Contact where Id IN : contacttobeexclude];
           			if(!conList.isEmpty()){
             			for(Contact con : conList){
               				system.debug('For Deactivating user and update contact status '+con);
               				con.Enable_Customer_Portal_User__c = false;
               				PortalUserService.deleteUser(con.Id);  
               				conTobeUpdated.add(con);
             			}
           			}
		           if(conTobeUpdated.size() > 0){
		             Database.SaveResult[] resultsContact3 = Database.update(conTobeUpdated);  
		           }
       		}     
       }
   }
}//Close trigger