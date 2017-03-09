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

trigger tgrAccountContactRoleBeforeInsert on Account_Contact_Role__c (before insert, before update){    
    System.debug('---trigger tgrAccountContactRoleBeforeInsert called----');
    //Implemented as part of https://yousee.jira.com/browse/SC-205 where Service-Center profiles can delete role without external id.
    
    /*
        private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c;
        private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    */
    
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger') != null ?  ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c : null;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c : null;
    
    /* 
    Process explained:
    1. Load all contacts in account roles and associate account-ids
    2. Fill out customer-ID in case of null values in account contact roles.
    3. Validate for duplicates if one contact has the same role with the same customer more than one time.
    4. KISS validation
    */
    //Retrive ID for Cast Iron User for bypassing validation
    //User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];   
    
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    private static ID yoaProfileId = ServiceCenter_CustomSettings__c.getInstance('OKTKPAgent_ProfileID') != null ? ServiceCenter_CustomSettings__c.getInstance('OKTKPAgent_ProfileID').Value__c : null;
    //YOA validation check - they can only
    //Profile YOA_Profile = [Select Id from Profile where Name = 'YOA Profil'];
    
    System.debug('Michel' + userCIId);
    
    List<Account_Contact_Role__c > acrList = new List<Account_Contact_Role__c >(); 
    Set <id> ContactSet = new Set<id>();
    
    //Set for storing cable unit references for portal check in future method
    Set <Id> CableUnitPortalCheck = new Set<Id>();
    
    List<History_Log_External_Contact_Role__c> history_entries = new List<History_Log_External_Contact_Role__c>();
    
    Map <String,String> ContactAccountMap = new Map <String, String>(); 
    
    for(Account_Contact_Role__c acr : Trigger.New){
        if (!Contactset.contains(acr.Contact__c)){
            Contactset.add(acr.Contact__c);   
        }           
    }    
    
    for(Contact con : [Select c.Id, c.AccountId From Contact c Where c.Id in : Contactset ]){
        ContactAccountMap.put(con.Id, con.AccountId );              
    }
    
    //Replace null with actual account-id from contacts
    for(Account_Contact_Role__c acr : Trigger.New){
        Id AccountId =  ContactAccountMap.get(acr.Contact__c);
        if(acr.Customer__c == null) {
            acr.Customer__c  = AccountId;
            acrList.Add(acr);
        }
    }
    if (!acrList.isEmpty()){
    	if(!Test.isRunningTest())
	         update acrList;         
    }
         
         
    /* Old code for primary check
     if (acr.Primary__c == true){
            for (Account_Contact_Role__c acrP : [SELECT Id, Primary__c, Customer__c FROM Account_Contact_Role__c WHERE Primary__c = true and Id  != :  acr.Id and Customer__c = : acr.Customer__c Limit 1]){
                    acrP.Primary__c = false;
                    acrList.Add ( acrP);
            }
    }*/ 
    
    //KISS validation       
    Set <Id> acrIds = new Set<Id>(); 
    Set <Id> roleIds = new Set<Id>(); 
    Set <Id> customerIds = new Set<Id>(); 
    for(Account_Contact_Role__c acr_new : Trigger.new){
        if (!acrIds.contains(acr_new.Id)){
            acrIds.add(acr_new.Id);           
        }  
        if (!roleIds.contains(acr_new.Role__c)){
            roleIds.add(acr_new.Role__c);   
        } 
        if (!customerIds.contains(acr_new.customer__c)){
            customerIds.add(acr_new.customer__c);   
        }          
    }       
    
    //Add old role-Ids for lookup purposes     
    if(Trigger.isUpdate){
        //Add old role ids for lookup purpose
        for(Account_Contact_Role__c acr_old : Trigger.old){
            if (!roleIds.contains(acr_old.Role__c))
                roleIds.add(acr_old.Role__c); 
            if(!ContactSet.contains(acr_old.Contact__c))
                ContactSet.add(acr_old.Contact__c);
            if (!customerIds.contains(acr_old.customer__c)){
                customerIds.add(acr_old.customer__c);   
            }                     
        }       
    }
     
    //Preload contacts to be used in validation. The values are also used in for updating search criteria
    Map <ID, Contact> ContactMap = new Map <ID, Contact>();
    for(Contact contact : [SELECT Id, Name, HierarchyAccount__c from Contact where Id in : ContactSet]){
        if (ContactMap.get(contact.Id) == null){
            ContactMap.put(contact.Id, contact);   
        }           
    }    
    
    //Preload customer to save SOQL queries in for loop
    Map <ID, Account> CustomerAccountMap = new Map <ID, Account>();
    for(Account customer : [SELECT Id, Name, Type, Cable_Unit_No__c, Parent.SuperiorAccount__c, SuperiorAccount__c, ParentId, Service_Center_Customer_Agreement_CU__c from Account where Id in : customerIds]){
        if (CustomerAccountMap.get(customer.Id) == null){
            CustomerAccountMap.put(customer.Id, customer);   
        }           
    }    
    
    //Preload contact roles to save SOQL queries in for loop
    Map <ID,Lookup_Contact_Roles__c> ContactRolesMap = new Map <ID, Lookup_Contact_Roles__c>();
    for(Lookup_Contact_Roles__c role : [SELECT Id, Active__c, Name from Lookup_Contact_Roles__c where Id in : roleIds]){
        if (ContactRolesMap.get(role.Id) == null){
            ContactRolesMap.put(role.Id, role);   
        }                   
    }
         
    //Preload KISS rules to save SOQL queries in for loop
    Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
    for(KISS_Role_Validation_Rules__c rule : [Select Id, Name, Unlimited__c, Required__c, Possible__c, Type__c, Contact_Roles__c from KISS_Role_Validation_Rules__c where Type__c = 'Kunde' or Type__c = 'Hierarki']){
        //String key = rule.Name + ':' + rule.Type__c;
        String key = rule.Contact_Roles__c + ':' + rule.Type__c;
        if (KISSRulesMap.get(key) == null)
            KISSRulesMap.put(key, rule);        
    }
     
    //Preload aggregate queries to save SOQL queries in for loop
    Map <String, Integer> acrCurrentRolesMap = new Map <String, Integer>();    
    for(AggregateResult acrCurrentRoles : [Select Customer__r.Id customerId, Role__r.Name roleName, count(ID)total from Account_Contact_Role__c where customer__r.Id in : customerIds group by Customer__r.Id, Role__r.Name]){
        String key = String.valueOf(acrCurrentRoles.get('customerId')) + ':' + String.valueOf(acrCurrentRoles.get('roleName'));
        if(acrCurrentRolesMap.get(key) == null) 
            acrCurrentRolesMap.put(key, Integer.valueOf(acrCurrentRoles.get('total')));             
    }  
    
  Map <String,Set<Id>> DuplicateCheckData = new Map<String,Set<Id>>();
    Set <ID> oldACRIds = new Set<Id>();
    String acr_comb = null;
    for (Account_Contact_Role__c acr :[Select ID, Customer__r.Type,Customer__c, Role__c, Contact__c from Account_Contact_Role__c where Customer__r.Id in : customerIds] ){
      acr_comb = (String) acr.customer__c +  (String)acr.role__c + (String) acr.contact__c;
       oldACRIds = DuplicateCheckData.get(acr_comb);
       System.debug('$$acr_comb$'+acr_comb+'###oldACRIds##'+oldACRIds);
       if (oldACRIds == null){
         oldACRIds = new Set<Id>();
          oldACRIds.add(acr.Id);
          DuplicateCheckData.put(acr_comb,oldACRIds);
          System.debug('###Insert null oldACRIds##'+oldACRIds+'$$$DuplicateCheckData$'+DuplicateCheckData);
       }else {
       // ACRIds.add(acr.id);
       //   oldACRIds = new Set<Id>();
          oldACRIds.add(acr.Id);
       //   DuplicateCheckData.put(acr_comb,oldACRIds);
       }
    }

  
  System.debug('$$$$$$$$$$$$$$$$$$$customerIds%%%%%%%%%%%%%%%'+customerIds.size());
  //Map to check for duplicates in Insert statement. If update statement, values are already accessible in Trigger.old
    //Map <Id,Account_Contact_Role__c> DuplicateMapCheck = new Map <ID, Account_Contact_Role__c>([Select ID, Customer__r.Type,Customer__c, Role__c, Contact__c from Account_Contact_Role__c where Customer__r.Id in : customerIds]);
  System.debug('##################Map Size :' + DuplicateCheckData.size()+'####ContactSet'+ContactSet);
    //Set including contacts that are also active portal users
    Set<Id> contactWithPortalUser = new Set<Id>();
    for(User portalUser: [Select ContactId from User where IsActive=true and ContactId IN : ContactSet]){
        if(!contactWithPortalUser.contains(portalUser.ContactId))
            contactWithPortalUser.add(portalUser.ContactId);
    }  
    
    
    
    
    Integer CurrentRoles = 0;
    //KISS Validation 
    Account customer = null;
    Lookup_Contact_Roles__c role = null;
    Contact contact = null;
    History_Log_External_Contact_Role__c historyEntry = null;
    
    if (Trigger.isInsert){      
        for(Account_Contact_Role__c new_trigger: Trigger.New){          
            customer = CustomerAccountMap.get(new_trigger.customer__c);
            role = ContactRolesMap.get(new_trigger.Role__c);
            contact = ContactMap.get(new_trigger.Contact__c);            
            //Mandatory null check
            if(customer == null){
                new_trigger.AddError('Fejl: Kunde findes ikke');
                continue;   
            }
            if(role == null){
                new_trigger.AddError('Fejl: Rolletype findes ikke');
                continue;
            }            
            if(contact == null){
                new_trigger.AddError('Fejl: Kontakt findes ikke');
                continue;
            }   
            //Mandatory duplicate check
          
            System.debug('$$$$$$new_trigger$$$$$$$$'+new_trigger);
            
            /*
            if(CheckForDuplicate(new_trigger)){                              
                    new_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                    continue; //Skip to new trigger if errors                     
            }//Close if duplicate*/
          
          
           acr_comb = (String)new_trigger.customer__c + (String) new_trigger.role__c + (String) new_trigger.contact__c;
           oldACRIds = DuplicateCheckData.get(acr_comb);
           if (oldACRIds != null && !oldACRIds.contains(new_trigger.id)) {
                 new_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                    continue; //Skip to new trigger if errors                     
           }
           
            //Cast Iron bypasses normal validation rules due to consistency issues.            
            if (UserInfo.GetUserID() != userCIId && !System.isBatch() && !System.isScheduled()){
                //If portal role, then add the associated cable unit to a future method that checks portal status
                if(!CableUnitPortalCheck.contains(new_trigger.customer__c) && customer.Service_Center_Customer_Agreement_CU__c =='Nej' && customer.Type =='Kunde' &&
                    (new_trigger.Role__c == portalUserRoleId || new_trigger.Role__c == portalUserAdministratorRoleId)){
                    CableUnitPortalCheck.add(new_trigger.customer__c);  
                }
                //Load KISS for new ct role
                //Old: String key = role.Name + ':' + customer.Type;
                //Old: KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
                String key = role.Id + ':' + customer.Type;
                KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
                if(rule == null){
                    new_trigger.AddError('Der findes ikke en KISS valideringsregel for kontaktrollen: \'' + role.Name + '\'. Kontakt din Salesforce Administrator' );
                    continue; //Skip to new trigger if errors               
                }
                
                //Check for null customer - sometimes Cast Iron causes this error
                if (customer == null){
                    new_trigger.AddError('Den angivne kunde med ID: \'' + new_trigger.customer__r.Id + '\' eksisterer ikke. Kontakt din Salesforce Administrator' );
                    continue; //Skip to new trigger if errors   
                }
                 
                //YOA Users can only create and edit role types Teknisk sagskontakt and Leverandørkontakt
                if ( (UserInfo.getProfileId() == yoaProfileId) && 
                    ((role.name != 'Teknisk sagskontakt') && role.name != 'Leverandørkontakt')){
                    new_trigger.AddError('YOA brugere må kun oprette og redigere rolletyper som \'Teknisk sagskontakt\' og \'Leverandørkontakt\'');
                    continue; //Skip to new trigger if errors 
                }
                          
                //Check for expired role                  
                if(((!rule.Unlimited__c) && (rule.Possible__c == 0) && (rule.Required__c == 0)) || (role.Active__c == 'Nej')){                       
                    new_trigger.AddError('Tilføjelse af kontaktrolle ikke mulig. Kontaktrollen' + ' \'' + role.Name + '\'' + ' er udgået og må ikke længere anvendes.');
                    continue;//Skip to new trigger if errors 
                }
                else if(!rule.Unlimited__c){//If the contact role has no upper limit, then no need to check further
                    //If not, then count how many contact roles exist already for the specific customer
                    String currentRolesKey = customer.Id + ':' + role.Name;                 
                    CurrentRoles = Integer.valueOf(acrCurrentRolesMap.get(currentRolesKey));
                    if(CurrentRoles != null){                       
                        if (CurrentRoles + 1 > rule.Possible__c){
                             //Validation messages are targeted internal and external portal users. This override is applicate for both inserts and update actions.
                             if (UserInfo.getUserType() != 'Standard')
                                new_trigger.AddError('Tilføjelse af kontaktrolle ikke mulig. Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' rolle(r) tilknyttet et kunde.');
                             else                                     
                                new_trigger.AddError('Tilføjelse af kontaktrolle ikke mulig. Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' rolle(r) tilknyttet kunder af typen: ' + customer.Type);
                            continue;//Skip to new trigger if errors 
                        }
                    }
                }//End not Expired                 
                
                //Logic to determine superiorAccount
                Id superiorAccount = null;
                if(customer.ParentId == null)
                    superiorAccount = customer.Id;
                else 
                    superiorAccount = customer.SuperiorAccount__c;   
                System.debug('#1'+superiorAccount+'#2'+contactWithPortalUser+'#3'+contact.HierarchyAccount__c);
                //Add check that prevents adding a contact role with a completely different customer hierarchy for active portal users                                    
                if ( superiorAccount != null && contactWithPortalUser.contains(new_trigger.Contact__c) &&
                     contact.HierarchyAccount__c != null && superiorAccount != contact.HierarchyAccount__c ){
                        new_trigger.AddError('Det er ikke muligt at tilføje en kontaktrolle tilhørende et andet hierarki på en aktiv portalbruger/portaladministrator.');
                        continue;//Skip to new trigger if errors                        
                }                                               
            }//Close if-not Cast Iron user
            
            //Update Search Criteria
            updateSearchCriteria(new_trigger, ContactRolesMap.get(new_trigger.Role__c) != null ? ContactRolesMap.get(new_trigger.Role__c).Name : null,
                                     contact != null ? contact.Name : '',
                                     new_trigger.CableUnit__c);
           
           //Update history log with insertion data
           historyEntry = new History_Log_External_Contact_Role__c(
                Account__c = new_trigger.Customer__c,
                Customer_Name__c = CustomerAccountMap.get(new_trigger.Customer__c).Name != null ? CustomerAccountMap.get(new_trigger.Customer__c).Name  : null,                     
                Cable_Unit_No__c = CustomerAccountMap.get(new_trigger.Customer__c).Cable_Unit_No__c != null ? CustomerAccountMap.get(new_trigger.Customer__c).Cable_Unit_No__c : null,                  
                Action__c = 'New',
                New_ContactId__c = new_trigger.Contact__c,
                New_Contact_Name__c = contact != null ? contact.Name : null,
                New_RoleId__c = new_trigger.Role__c,
                New_Role_Name__c = ContactRolesMap.get(new_trigger.Role__c) != null ? ContactRolesMap.get(new_trigger.Role__c).Name : null,
                New_Total_Insight__c = new_trigger.Total_Insight__c,
                User_Type__c = UserInfo.getUserType() == 'Standard' ? 'Internal' : 'External'
           ); 
           history_entries.add(historyEntry);
        }//End For-structure 
        System.debug('################3Before Insert');   
    }//End Trigger.isInsert
    else{
        for(Account_Contact_Role__c update_trigger: Trigger.New){
            customer = CustomerAccountMap.get(update_trigger.customer__c);
            role = ContactRolesMap.get(update_trigger.Role__c);
            contact = ContactMap.get(update_trigger.Contact__c);
            
            //Mandatory null check
            if(customer == null){
                update_trigger.AddError('Fejl: Kunde findes ikke');
                continue;   
            }
            if(role == null){
                update_trigger.AddError('Fejl: Rolletype findes ikke');
                continue;
            }            
            if(contact == null){
                update_trigger.AddError('Fejl: Kontakt findes ikke');
                continue;
            }
            
                oldACRIds = DuplicateCheckData.get((String)update_trigger.customer__c + (String)update_trigger.role__c + (String)update_trigger.contact__c);
             if (oldACRIds != null && !oldACRIds.contains(update_trigger.id)) {
               update_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                      continue; //Skip to new trigger if errors                     
             
             }
           
           /*
            //Mandatory duplicate check            
            if(CheckForDuplicate(update_trigger)){              
                update_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                
                continue;// Skip to new trigger if errors 
            }//Close if duplicate */
                
            //Cast Iron bypasses normal validation rules due to consistency issues. 
            //Also, we have a nightly batch job that touches account contact roles with no externalid. This should also by bypassed.
            if (UserInfo.GetUserID() != userCIId && !System.isBatch() && !System.isScheduled()){
                //String newKey = role.Name + ':' + customer.Type;
                //KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(newKey);
                String newKey = role.Id + ':' + customer.Type;
                KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(newKey);
                if(rule == null){
                    update_trigger.AddError('Der findes ikke en KISS valideringsregel for kontaktrollen: \'' + role.Name + '\'. Kontakt din Salesforce Administrator' );
                    continue; //Skip to new trigger if errors               
                }
                //Check for null customer - sometimes Cast Iron causes this error
                if (customer == null){
                    update_trigger.AddError('Den angivne kunde med ID: \'' + update_trigger.customer__r.Id + '\' eksisterer ikke. Kontakt din Salesforce Administrator' );
                    continue;//Skip to new trigger if errors     
                }
                
                //Contact roles cannot be edited if we haven't receved the external kiss id
                //if(customer.Type != 'Hierarki' && update_trigger.ContactRoleExternalID__c == null)
                    //update_trigger.AddError('Kontaktrollen afventer oprettelse i KISS og kan i øjeblikket ikke ændres. Prøv venligst igen om 10-15 sekunder.');                          
                            
                //Check for expired role
                if(((!rule.Unlimited__c) && (rule.Possible__c == 0) && (rule.Required__c == 0)) || (role.Active__c == 'Nej'))
                    update_trigger.AddError('Ændring af kontaktrolle ikke mulig. Kontaktrollen' + ' \'' + role.Name + '\'' + ' er udgået og må ikke længere anvendes.' );
                else{
                    /*
                    Two checks need to be made if the user update the role: (1) determine if KISS rule for old contact role is respected and (2)
                    that new contact roles don't exceed maximum settings for a specfic role type.
                    Updates regarding the contacts don't apply in KISS validation since duplication check is performed prior to KISS validation in this trigger
                    */  
                                
                    //Load the old role and determine if the user has changed to a new role             
                    Lookup_Contact_Roles__c oldContactRole = ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c);
                    
                    //Load new role for YOA validation purposes
                    Lookup_Contact_Roles__c newContactRole = ContactRolesMap.get(Trigger.newMap.get(update_trigger.Id).Role__c);
                    
                    //If by mistake, the old role id is null, we allow inserting a new role without validation since this is an odd scenario.
                    if(oldContactRole != null && update_trigger.Role__c != oldContactRole.Id){
                        //If portal role is chosen, then add the associated cable unit to a future method that checks portal status
                        if(!CableUnitPortalCheck.contains(update_trigger.customer__c) && customer.Service_Center_Customer_Agreement_CU__c =='Nej' && customer.Type =='Kunde' &&
                          (update_trigger.Role__c == portalUserRoleId || update_trigger.Role__c == portalUserAdministratorRoleId))                              
                            CableUnitPortalCheck.add(update_trigger.customer__c);
                        
                        //Logic to determine superiorAccount
                        Id superiorAccount = null;
                        if(customer.ParentId == null)
                            superiorAccount = customer.Id;
                        else 
                            superiorAccount = customer.SuperiorAccount__c;                        
                                 
                        //Add check that prevents adding a contact role with a completely different customer hierarchy for active portal users                                            
                        if ( superiorAccount != null && contactWithPortalUser.contains(update_trigger.Contact__c) &&
                             contact.HierarchyAccount__c != null && superiorAccount != contact.HierarchyAccount__c ){
                             update_trigger.AddError('Det er ikke muligt at tilføje en kontaktrolle tilhørende et andet kundehierarki på en aktiv portalbruger/portaladministrator.');
                             continue;//Skip to new trigger if errors                       
                        }
                        
                        /* Replaced by standard validation rule
                        if( update_trigger.ContactRoleExternalID__c == null && UserInfo.getUserType() == 'Standard' &&
                            update_trigger.Role__c != portalUserRoleId && update_trigger.Role__c != portalUserAdministratorRoleId){
                            update_trigger.AddError('Kontaktrollen er nyoprettet og afventer oprettelse i KISS. Prøv igen om 10-15 sekunder.');
                            continue;//Skip to new trigger if errors 
                        }
                        */
                                             
                        //Check if old role rule is still valid. Assume that the customer is the same                                                           
                        //Old: String oldKey = oldContactRole.Name + ':' + customer.Type;
                        //Old: KISS_Role_Validation_Rules__c rule_old = KISSRulesMap.get(oldKey);
                        String oldKey = oldContactRole.Id + ':' + customer.Type;
                        KISS_Role_Validation_Rules__c rule_old = KISSRulesMap.get(oldKey);
                        if(rule == null){
                            update_trigger.AddError('Der findes ikke en KISS valideringsregel for kontaktrollen: \'' + oldContactRole.Name + '\'. Kontakt din Salesforce Administrator' );
                            continue; //Skip to new trigger if errors               
                        }                                           
                        
                        //YOA Users can only edit role types Teknisk sagskontakt and Leverandørkontakt
                        if ( (UserInfo.getProfileId() == yoaProfileId) && 
                            ((oldContactRole.Name == 'Teknisk sagskontakt' && newContactRole.Name != 'Leverandørkontakt') || 
                            (oldContactRole.Name == 'Leverandørkontakt' && newContactRole.Name != 'Teknisk sagskontakt'))){
                            update_trigger.AddError('YOA brugere må kun oprette og redigere rolletyper som \'Teknisk sagskontakt\' og \'Leverandørkontakt\'');
                            continue; //Skip to new trigger if errors                           
                        }
                        
                        //Count how many contact roles exist already for the specific customer for old roles
                        String currentRolesKey = customer.Id + ':' + oldContactRole.Name;                   
                        CurrentRoles = Integer.valueOf(acrCurrentRolesMap.get(currentRolesKey));
                        //If CurrentRoles is null it means zero
                        if(CurrentRoles == null)
                            CurrentRoles = 0;                             
                        
                        //Check if new role exceed maximum requirements
                        String newRolesKey = customer.Id + ':' + role.Name;                 
                        Integer NewRoles = Integer.valueOf(acrCurrentRolesMap.get(newRolesKey));
                        //If NewRoles is null it means zero
                        if(NewRoles == null)
                            NewRoles = 0;                                      
                        
                        String update_error = 'Ændring af kontaktrolle ikke mulig. ';
                        Boolean hasError = false;
                        //Does the old role still comply with minimum requirements in KISS
                        //Portal-enabled roles are excluded from this validation to allow for replacement of required roles like Sagskontakt
                        if (CurrentRoles <= rule_old.Required__c){ 
                            //Validation messages are targeted internal and external portal users. This override is applicate for both inserts and update actions.
                            if (UserInfo.getUserType() != 'Standard')           
                                update_error += 'Der skal mindst være ' + rule_old.Required__c + ' \'' + oldContactRole.Name + '\' rolle(r) tilknyttet et kunde.';
                            else
                                update_error += 'Der skal mindst være ' + rule_old.Required__c + ' \'' + oldContactRole.Name + '\' rolle(r) tilknyttet kunder af typen: ' + customer.Type + '. ';
                            hasError = true;
                        }   
                        //Check if new role does not exceed maximum settings in KISS                        
                        if(!rule.Unlimited__c && (NewRoles + 1 > rule.Possible__c)){                                
                            //Validation messages are targeted internal and external portal users. This override is applicate for both inserts and update actions.
                            if (UserInfo.getUserType() != 'Standard')                            
                                update_error += 'Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' rolle(r) tilknyttet et kunde.';
                            else
                                update_error += 'Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' rolle(r) tilknyttet kunder af typen: ' + customer.Type;
                            hasError = true;
                        }
                        if(hasError){
                            update_trigger.AddError(update_error);
                            continue; //Skip to new trigger if errors
                        }
                    }//End if different roles
               }//Not expired       
            }//End if not Cast Iron            
            //Update Search Criteria            
            /*updateSearchCriteria(update_trigger, ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c) != null ? ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c).Name : null,
                                 ContactMap.get(update_trigger.Contact__c) != null ? ContactMap.get(update_trigger.Contact__c).Name : '',
                                 update_trigger.CableUnit__c);*/
            
            updateSearchCriteria(update_trigger, ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c) != null ? ContactRolesMap.get(Trigger.newMap.get(update_trigger.Id).Role__c).Name : null,
                                 ContactMap.get(update_trigger.Contact__c) != null ? ContactMap.get(update_trigger.Contact__c).Name : '',
                                 update_trigger.CableUnit__c);
                                 
            //Update history log
            if( Trigger.oldMap.get(update_trigger.Id).Contact__c != update_trigger.Contact__c ||
                Trigger.oldMap.get(update_trigger.Id).Role__c != update_trigger.Role__c ||
                Trigger.oldMap.get(update_trigger.Id).Total_Insight__c != update_trigger.Total_Insight__c){                
                    //Add information about old contact role
                    historyEntry = new History_Log_External_Contact_Role__c(
                        Account__c = update_trigger.Customer__c,
                        Customer_Name__c = CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Name != null ? CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Name  : null,                     
                        Cable_Unit_No__c = CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Cable_Unit_No__c != null ? CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Cable_Unit_No__c : null,
                        Action__c = 'Update', 
                        Old_ContactId__c = Trigger.oldMap.get(update_trigger.Id).Contact__c,
                        Old_Contact_Name__c = ContactMap.get(Trigger.oldMap.get(update_trigger.Id).Contact__c) != null ? ContactMap.get(Trigger.oldMap.get(update_trigger.Id).Contact__c).Name : null, 
                        Old_RoleId__c = Trigger.oldMap.get(update_trigger.Id).Role__c,
                        Old_RoleName__c = ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c) != null ? ContactRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Role__c).Name : null,
                        Old_Total_Insight__c = Trigger.oldMap.get(update_trigger.Id).Total_Insight__c,                      
                        //Add information about new contact role
                        New_ContactId__c = contact.Id,
                        New_Contact_Name__c = contact != null ? contact.Name : null,
                        New_RoleId__c = update_trigger.Role__c,
                        New_Role_Name__c = ContactRolesMap.get(update_trigger.Role__c) != null ? ContactRolesMap.get(update_trigger.Role__c).Name : null,
                        new_Total_Insight__c = update_trigger.Total_Insight__c,
                        User_Type__c = UserInfo.getUserType() == 'Standard' ? 'Internal' : 'External' 
                    );                               
                    history_entries.add(historyEntry);
            }//End history entry
        }//End for structure if update
    }//End else if isUpdate 
    updateHistoryLog();
    if(!Test.isRunningTest()){
    //Updates cable units with Service-Center status. If batch or future we use the static version, otherwise we use future method
    if(CableUnitPortalCheck.size() > 0 && !System.isFuture() && !System.isBatch() && !System.isScheduled() && UserInfo.getUserId() != userCIId)
        clsAsyncMethods.checkCableUnitPortalStatus(CableUnitPortalCheck, true);
    else
        clsAsyncMethods.checkCableUnitPortalStatusStatic(CableUnitPortalCheck, true);
    }
    //This method updates text field on Account Contact Roles to make them searchable in Global Search
    private void updateSearchCriteria(Account_Contact_Role__c edit_new_acr, 
                                    String roleName, String contactName, 
                                    String cableUnitNumber){ 
        System.debug('####Role Name'+roleName);                                           
        edit_new_acr.Contact_Role_Name_Search_Criteria__c = roleName;
        edit_new_acr.Contact_Name_Search_Criteria__c = contactName;
        edit_new_acr.Cable_Unit_Number_Search_Criteria__c = cableUnitNumber;
        System.debug('%%edit_new_acr.Contact_Role_Name_Search_Criteria__c%%'+edit_new_acr.Contact_Role_Name_Search_Criteria__c);
    }
    
    //Private method to check for duplicates
    private boolean CheckForDuplicate(Account_Contact_Role__c newAcr){ 
        Boolean isDuplicate = false;
        /*for(Account_Contact_Role__c oldAcr: DuplicateMapCheck.values()){
            if( (newAcr.Customer__c == DuplicateMapCheck.get(oldAcr.Id).Customer__c)&&
                (newAcr.Role__c == DuplicateMapCheck.get(oldAcr.Id).Role__c) &&
                (newAcr.Contact__c == DuplicateMapCheck.get(oldAcr.Id).Contact__c) &&
                (newAcr.Id != oldAcr.Id)){
                isDuplicate = true;
                break;              
            }
        }//End for-loop  */
        
       
        return isDuplicate;                     
    }//End CheckForDuplicate
    
    private void updateHistoryLog(){
        //Update history logs with trigger actions
        if(history_entries.size() != 0) {
           Database.SaveResult[] resultsAccount = Database.insert(history_entries);
        }        
    }    
}//End Trigger