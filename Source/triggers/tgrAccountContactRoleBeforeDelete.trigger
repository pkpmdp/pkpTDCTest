/*
    @Author: mkha@yousee.dk 
    
    Description: Implements role validation for external contact roles (Account_Contact_Role__c) on YS project.
    In addition, several related tasks are conducted like updating history logs and activating cable units for portal use etc.
    
    Test types:
    Primary: Test as much functionality as possible.
    Secondary: Only some code fragments are tested. Those classes have their own primary test classes.
    
    Test class:
    clstgrAccountContactRoleTest (Primary)  
*/

trigger tgrAccountContactRoleBeforeDelete on Account_Contact_Role__c (before delete) {
    //Implemented as part of https://yousee.jira.com/browse/SC-205 where Service-Center profiles can delete role without external id.    
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    
    //if (User.Id == '005200000012Dn3') - skal indsættes i for-løkke, hvis Cast Iron får fri-pass
    /*  After validation, all deleted records are transferred to a custom object DeletedAccountContactRole__c.
        This reason for this design is because Salesforce cannot send outbound delete messages from the Account_Contact_Role__c object
    */
    List<DeletedContactRole__c> deletedRecords = new List<DeletedContactRole__c>();
    List<History_Log_External_Contact_Role__c> history_entries = new List<History_Log_External_Contact_Role__c>();
    Integer CurrentRoles = 0;             
    Integer selectCount  = 0;
    Integer compareCount = 0;
    //Retrive ID for Cast Iron User for bypassing validation
    //User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    
    //YOA validation check - they can only
    //Profile YOA_Profile = [Select Id from Profile where Name = 'YOA Profil'];
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    private static ID userYOAId = ServiceCenter_CustomSettings__c.getInstance('YOA_ProfileID') != null ? ServiceCenter_CustomSettings__c.getInstance('YOA_ProfileID').Value__c : null;
    
    //String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
    private static ID selvBrugereId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c : null;
    private static ID selvAdminId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c : null;
    
    private static String brugerProfileName = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ? ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c : null;
    private static String adminProfileName = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator') != null ? ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c : null;
    
    
    //Set for storing cable unit references for portal check in future method
    Set <Id> CableUnitPortalCheck = new Set<Id>();
    Set <id> ContactSet = new Set<id>();           
    Set <Id> customerIds = new Set<Id>();
    Set<Id> portalIds = new Set<Id>();
    Set<ID> roleIdSet = new Set<Id>();
    for(Account_Contact_Role__c acr_old : Trigger.old){        
        if (!customerIds.contains(acr_old.customer__c)){
            customerIds.add(acr_old.customer__c);   
        }
        if(!ContactSet.contains(acr_old.Contact__c)){
            ContactSet.add(acr_old.Contact__c);      
        }
        
        if(!roleIdSet.contains(acr_old.Id)){
          //if(acr_old.Role__c != selvBrugereId || acr_old.Role__c == selvAdminId){
            roleIdSet.add(acr_old.Id);
          //}    
        }
        
        
        System.debug('%%selvBrugereId%%%'+selvBrugereId+'%%selvAdminId%%'+selvAdminId+'%%%Role'+acr_old.Role__c);
        if(!portalIds.contains(acr_old.Role__c)){
          if(acr_old.Role__c == selvBrugereId || acr_old.Role__c == selvAdminId){
            portalIds.add(acr_old.Role__c);
          }
        }
        
        /*
        if(!roleIdSet.contains(acr_old.Id)){
          roleIdSet.add(acr_old.Id);
          if(acr_old.Role__c == selvBrugereId || acr_old.Role__c == selvAdminId){
            roleIdSet.remove(acr_old.Id);
          }  
        } */
        
         System.debug('%%roleIdSet%%%'+roleIdSet);        
    }
    
    //Preload contacts to be used in updating history log 
    Map <ID, Contact> ContactMap = new Map <ID, Contact>();
    for(Contact contact : [SELECT Id, Name, Street_P__c, Phone, HomePhone, MobilePhone, FirstName, LastName from Contact where Id in : ContactSet]){
        if (ContactMap.get(contact.Id) == null){
            ContactMap.put(contact.Id, contact);   
        }           
    }
        
    system.debug('customerIds-------------------------'+customerIds);
    //Preload KISS rules to save SOQL queries in for loop
    Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
    for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Unlimited__c, Required__c, Possible__c, Type__c, Contact_Roles__c from KISS_Role_Validation_Rules__c where Type__c = 'Kunde' or Type__c = 'Hierarki']){
        //Old:String key = rule.Name + ':' + rule.Type__c;
        String key = rule.Contact_Roles__c + ':' + rule.Type__c;
        if (KISSRulesMap.get(key) == null) {
            KISSRulesMap.put(key, rule);    
        }
    }
    system.debug('KISSRulesMap--------------------------'+KISSRulesMap);
    //Preload aggregate queries to save SOQL queries in for loop
    Map <String, Integer> acrCurrentRolesMap = new Map <String, Integer>(); 
    Map<String, Integer> countMap = new Map<String, Integer>();
    
    History_Log_External_Contact_Role__c historyEntry = null; 
    //System.debug('@@@Profile'+usrProfileName+'%%portalIds'+portalIds.size());
    
    for(AggregateResult roleCount : [Select Count(Id) idCount, Role__r.Name roleName1,customer__r.Id customerId1 from Account_Contact_Role__c where ID IN :roleIdSet and customer__r.Id in : customerIds group by customer__r.Id,Role__r.Name]){
      String key1 = String.valueOf(roleCount.get('customerId1')) + ':' + String.valueOf(roleCount.get('roleName1'));
      if(countMap.get(key1) == null){
         countMap.put(key1, Integer.valueOf(roleCount.get('idCount')));
      }
    }
    System.debug('%%%%Select Count'+countMap);
    //if (usrProfileName != adminProfileName && !portalIds.isEmpty()){
      for(AggregateResult acrCurrentRoles : [Select Customer__r.Id customerId, Role__r.Name roleName, count(ID)total from Account_Contact_Role__c where customer__r.Id in : customerIds and Role__c NOT IN : portalIds group by Customer__r.Id, Role__r.Name]){
          String key = String.valueOf(acrCurrentRoles.get('customerId')) + ':' + String.valueOf(acrCurrentRoles.get('roleName'));
          if(acrCurrentRolesMap.get(key) == null) 
              acrCurrentRolesMap.put(key, Integer.valueOf(acrCurrentRoles.get('total')));             
      } 
    //}    
    system.debug('acrCurrentRolesMap--------------------------'+acrCurrentRolesMap);    
    for(Account_Contact_Role__c acr: [Select Customer__r.Type, Customer__r.Service_Center_Customer_Agreement_CU__c, Total_Insight__c, Customer__c, Customer__r.Name, Customer__r.Cable_Unit_No__c, Contact__c, Contact__r.Name, Role__c, Role__r.Name, Role__r.Visible_in_Service_Centre__c, ContactRoleExternalID__c from Account_Contact_Role__c where Id IN : Trigger.oldMap.keySet() and Role__c NOT IN :portalIds])
    {     
        //Mandatory null check
        if(acr.Customer__c == null){
            Trigger.oldMap.get(acr.Id).AddError('Fejl: Kunde findes ikke');
            continue;   
        }
        if(acr.Role__c == null){
            Trigger.oldMap.get(acr.Id).AddError('Fejl: Rolletype findes ikke');
            continue;
        }            
        if(acr.Contact__c == null){
            Trigger.oldMap.get(acr.Id).AddError('Fejl: Kontakt findes ikke');
            continue;
        }           
            
        if (UserInfo.GetUserID() != userCIId){
            //Mandatory data check on related contacts. If mandatory information is missing we can't update active status and hierarchy account changes.
            Contact obj = ContactMap.get(acr.Contact__c);
            // Contains Changes for SF-1559 , removed obj.FirstName == null from rule   
            if( (acr.Role__c != portalUserRoleId && acr.Role__c != portalUserAdministratorRoleId) &&
                (obj.Street_P__c == null || obj.LastName == null || (obj.Phone == null && obj.HomePhone == null && obj.MobilePhone == null ))){
                Trigger.oldMap.get(acr.Id).AddError('Fejl: Rollen kan ikke slettes, hvis der mangler obligatoriske informationer på kontakten. Tjek kontaktdata og prøv igen.');
                continue;
            } 
             
                        
            //If portal role, then add the associated cable unit to a future method that checks portal status
            if(!CableUnitPortalCheck.contains(acr.customer__c) && acr.Customer__r.Service_Center_Customer_Agreement_CU__c =='Ja' && acr.Customer__r.Type == 'Kunde' &&
              (acr.Role__c == portalUserRoleId || acr.Role__c == portalUserAdministratorRoleId)){                               
                CableUnitPortalCheck.add(acr.customer__c);  
            }
            
            //Old: String key = acr.Role__r.Name + ':' + acr.Customer__r.Type;
            //Old: KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
            String key = acr.Role__c + ':' + acr.Customer__r.Type;
            KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
            if(rule == null){
                Trigger.oldMap.get(acr.Id).AddError('Der findes ikke en KISS valideringsregel for kontaktrollen: \'' + acr.Role__r.Name + '\'. Kontakt din Salesforce Administrator' );
                continue;//Skip to new trigger if errors              
            }
            
             
            String currentRolesKey = acr.Customer__c + ':' + acr.Role__r.Name; 
            CurrentRoles = acrCurrentRolesMap.get(currentRolesKey);             
            selectCount = countMap.get(currentRolesKey);
            compareCount = CurrentRoles - selectCount;
            
            
            //Null value equals zero
            if(CurrentRoles == null)
                CurrentRoles = 0;  
            
            /* No longer neceassry since YOA users cannot delete any contact roles
             //YOA Users can only delete role types Teknisk sagskontakt and Leverandørkontakt
            if (UserInfo.getProfileId() == userYOAId && (acr.Role__r.Name != 'Teknisk sagskontakt' && acr.Role__r.Name != 'Leverandørkontakt')
            ){
                Trigger.oldMap.get(acr.Id).AddError('YOA brugere må kun slette rolletyper som \'Teknisk sagskontakt\' og \'Leverandørkontakt\'');
                continue; //skip to new trigger if errors 
            }
            */      
            system.debug('CurrentRoles-----------------------------------'+CurrentRoles+'$$$$currentRolesKey'+currentRolesKey);
            system.debug('rule.Required__c-----------------------------------'+rule.Required__c);
            system.debug('selectCount-----------------------------------'+selectCount);
            system.debug('compareCount-----------------------------------'+compareCount);
            
            //if (CurrentRoles  <= rule.Required__c) {
                //Validation messages are targeted internal and external portal users. However, this particular override should not used unless someone adds a minimum requirement in portal active roles.
             
              if(compareCount < rule.Required__c){  
                if (UserInfo.getUserType() != 'Standard') 
                    Trigger.oldMap.get(acr.Id).AddError('Sletning af krævet rolle ikke mulig. Der skal være mindst ' + rule.Required__c + ' ' + acr.Role__r.Name + ' rolle(r) tilknyttet kunder af typen: ' + acr.Customer__r.Type);
                else
                    Trigger.oldMap.get(acr.Id).AddError('Sletning af krævet rolle ikke mulig. Der skal være mindst ' + rule.Required__c + ' ' + acr.Role__r.Name + ' rolle(r) tilknyttet et kunde');  
                continue;//Skip to new trigger if errors
               }
            
            /* 
                When deleting external contact roles, a dummy object is created on a custom object 'DeletedAccountContactRole__c'. When inserting this object with required
                deletion information, an outbound is sent for backend deletion.
                Note: New deletion capability added as part of CRM-53. Now, deletion of internal contact roles on both hierarchy and cable units         
                are sent outbound in separate outbounds and workflow rules. The field customer type on DeletedAccountContactRole__c is used to 
                distinguish between deletion events from hierarchy and cable units, respectively.
              
            */   
            /*       
            System.debug('acr.Role__r.Id---'+ acr.Role__c);
            System.debug('portalUserRoleId---'+ portalUserRoleId);
            System.debug('portalUserAdministratorRoleId---'+ portalUserAdministratorRoleId);*/
           
           //Important validation for Service-Center and CRM:If user is not external or is system administrator, and if role is not a user role, then display this error.
           /*if(acr.ContactRoleExternalID__c == null && UserInfo.getUserType() == 'Standard' && UserInfo.getProfileId() !='00e20000001UQpw' &&
              acr.Role__c != portalUserRoleId && acr.Role__c != portalUserAdministratorRoleId){
                //Code before making changes in SC-465  
                //Trigger.oldMap.get(acr.Id).AddError('Kontaktrollen er nyoprettet og afventer oprettelse i KISS. Prøv igen om 10-15 sekunder.');
                Trigger.oldMap.get(acr.Id).AddError(System.Label.SC_ContactRoleExternalId);
                continue;//Skip to new trigger if errors
           }*/
        }//Close If-not-CastIron
            
       //If a portal enabled or portal user role without externalID is deleted, then no need to transfer object to deletedobject since that would throw an exception
         if (acr.ContactRoleExternalID__c != null){ 
            DeletedContactRole__c dacr = new DeletedContactRole__c();
            dacr.Customer_type__c = acr.Customer__r.Type; 
            dacr.AccountContactRoleExternalID__c = acr.ContactRoleExternalID__c;        
            dacr.LastModified__c = userCIId;
            deletedRecords.add(dacr);
        }
        //Update history - Service-Center           
        historyEntry = new History_Log_External_Contact_Role__c(
            Account__c = acr.Customer__c,
            Customer_Name__c = acr.Customer__r.Name,                        
            Cable_Unit_No__c = acr.Customer__r.Cable_Unit_No__c != null ? acr.Customer__r.Cable_Unit_No__c : '',
            Action__c = 'Delete',
            Old_ContactId__c = acr.Contact__c,         
            Old_Contact_Name__c = ContactMap.get(acr.Contact__c).Name,
            Old_RoleId__c = acr.Role__c,
            Old_RoleName__c = acr.Role__r.Name,
            Old_Total_Insight__c =  acr.Total_Insight__c,     
            User_Type__c = UserInfo.getUserType() == 'Standard' ? 'Internal' : 'External'
        );                      
        history_entries.add(historyEntry);      
        /* 
        Old code when deletion of contact roles on cable units should be sent outbound               
        if(acr.Customer__r.Type != 'Hierarki'){
            if(acr.ContactRoleExternalID__c == null){
                Trigger.oldMap.get(acr.Id).AddError('Kontaktrollen er nyoprettet og afventer oprettelse i KISS. Prøv igen om 10-15 sekunder.');         
            }else{ 
                DeletedAccountContactRole__c dacr = new DeletedAccountContactRole__c(); 
                dacr.ContactRoleExternalID__c = acr.ContactRoleExternalID__c;        
                dacr.LastModified__c = userCIId;
                deletedRecords.add(dacr);                
                //Add related contact to contact set to be updated
                contactsToBeUpdated.add(acr.Contact__r.Id);                
            }
        }
        else{
            //Add related contact to contact set to be updated
            contactsToBeUpdated.add(acr.Contact__r.Id);
        }  
    */   
    }    
    //Update database with deleted account contact roles
        if(deletedRecords.size() != 0) {
        Database.SaveResult[] resultsAccount = Database.insert(deletedRecords);
    }
    
    //Update history logs with trigger actions
    if(history_entries.size() > 0) {
         System.debug('Call before inserting into history log' + history_entries.size());
         Database.SaveResult[] resultsAccount = Database.insert(history_entries);
         System.debug('Insertion successful');
    }   
    
    //Updates cable units with Service-Center status. If batch or future we use the static version, otherwise we use future method
    if(CableUnitPortalCheck.size() > 0 && !System.isFuture() && !System.isBatch() && !System.isScheduled() && UserInfo.getUserId() != userCIId)
        clsAsyncMethods.checkCableUnitPortalStatus(CableUnitPortalCheck, false);
    else
        clsAsyncMethods.checkCableUnitPortalStatusStatic(CableUnitPortalCheck, false);
    
}//End trigger