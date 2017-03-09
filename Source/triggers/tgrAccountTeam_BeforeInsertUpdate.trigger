trigger tgrAccountTeam_BeforeInsertUpdate on Account_Team__c (before insert, before update) {
    Map <Id,Account_Team__c> DuplicateMapCheck;
    
    //List to contain updates to history log
    List<History_Log_Internal_Contact_Role__c> history_entries = new List<History_Log_Internal_Contact_Role__c>();
    
    //Tmp code to controll triggers in production
    //Retriving environment unique field ids for customer lookup fields
    YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl'); 
    Boolean runTrigger = false;
    YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
    //Start Trigger switch
    if (config != null && (runTrigger = config.AccountTeam__c) == true) {
    
        //if (User.Id == '005200000012Dn3') - skal indsættes i for-løkke, hvis Cast Iron får fri-pass
        /*
        Process explained:    
        1. Validate for duplicates if one contact has the same role with the same customer more than one time.
        2. KISS validation 
        */
        
        //Retrive ID for Cast Iron User for bypassing validation
        User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
                  
        //KISS validation       
        Set <Id> ctIds = new Set<Id>(); 
        Set <Id> roleIds = new Set<Id>(); 
        Set <Id> customerIds = new Set<Id>();
        Set <Id> teamMemberIds = new Set<Id>();
            
        for(Account_Team__c ct_new : Trigger.new){
            if (!ctIds.contains(ct_new.Id)){
                ctIds.add(ct_new.Id);   
            }  
            if (!roleIds.contains(ct_new.Customer_Team_Role__c)){
                roleIds.add(ct_new.Customer_Team_Role__c);   
            } 
            if (!customerIds.contains(ct_new.customer__c)){
                customerIds.add(ct_new.customer__c);   
            }
            if (!teamMemberIds.contains(ct_new.Customer_Team_Member__c)){
                teamMemberIds.add(ct_new.Customer_Team_Member__c);   
            }            
        }
        
        //Add old role-Ids for lookup purposes
        if(Trigger.isUpdate){       
            //Add old role ids for lookup purpose
            for(Account_Team__c ct_old : Trigger.old){
                if (!roleIds.contains(ct_old.Customer_Team_Role__c))
                    roleIds.add(ct_old.Customer_Team_Role__c);        
                if (!teamMemberIds.contains(ct_old.Customer_Team_Member__c))
                    teamMemberIds.add(ct_old.Customer_Team_Member__c);
                if (!customerIds.contains(ct_old.customer__c))
                		customerIds.add(ct_old.customer__c);
            }
        }
        
       //Preload team member data to be used for search criteria and validation
        Map <ID, Lookup_Account_Team_Member__c> TeamMemberMap = new Map <ID, Lookup_Account_Team_Member__c>();
        for(Lookup_Account_Team_Member__c teamMember : [SELECT Id, Name from Lookup_Account_Team_Member__c where Id in : teamMemberIds]){
            if (TeamMemberMap.get(teamMember.Id) == null){
                TeamMemberMap.put(teamMember.Id, teamMember);   
            }           
        }     
        
        //Preload customer info to save SOQL queries in for loop
        Map <ID, Account> CustomerAccountMap = new Map <ID, Account>();
        for(Account customer : [SELECT Id, Name, Type, Cable_Unit_No__c from Account where Id in : customerIds]){
            if (CustomerAccountMap.get(customer.Id) == null){
                CustomerAccountMap.put(customer.Id, customer);   
            }           
        }
        
        
        //Preload Customer Team Roles to save SOQL queries in for loop
        Map <ID,Lookup_Account_Team_Role__c> CustomerTeamRolesMap = new Map <ID, Lookup_Account_Team_Role__c>();
        for(Lookup_Account_Team_Role__c ctRole: [SELECT Id, Active__c, Name from Lookup_Account_Team_Role__c where Id in : roleIds]){
            if (CustomerTeamRolesMap.get(ctRole.Id) == null){
                CustomerTeamRolesMap.put(ctRole.Id, ctRole);   
            }           
        }    
        
        //Preload KISS rules to save SOQL queries in for loop
        Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
        for(KISS_Role_Validation_Rules__c rule : [Select Id, Name, Unlimited__c, Required__c, Possible__c, Type__c, Customer_Team_Role__c from KISS_Role_Validation_Rules__c where Type__c ='YouSee Customer Teams']){
            String key = rule.Customer_Team_Role__c + ':YouSee Customer Teams';
            if (KISSRulesMap.get(key) == null)
                KISSRulesMap.put(key, rule);        
        }
        
        
        //Preload aggregate queries to save SOQL queries in for loop
        Map <String, Integer> ctCurrentRolesMap = new Map <String, Integer>();    
        for(AggregateResult ctCurrentRoles : [Select Customer__r.Id customerId, Customer_Team_Role__r.Name roleName, count(ID)total from Account_Team__c where customer__r.Id in : customerIds group by Customer__r.Id, Customer_Team_Role__r.Name]){
            String key = String.valueOf(ctCurrentRoles.get('customerId')) + ':' + String.valueOf(ctCurrentRoles.get('roleName'));
            if(ctCurrentRolesMap.get(key) == null)  
                ctCurrentRolesMap.put(key, Integer.valueOf(ctCurrentRoles.get('total')));               
        }  
        
        //Map to check for duplicates in Insert statement. If update statement, values are already accessible in Trigger.old
        DuplicateMapCheck = new Map <ID, Account_Team__c>([Select ID, Customer__c, Customer_Team_Role__c, Customer_Team_Member__c from Account_Team__c where Customer__r.Id in : customerIds]);    
        
        Integer CurrentRoles = 0;
        //KISS Validation 
        Account customer = null;
        Lookup_Account_Team_Role__c role = null; 
        History_Log_Internal_Contact_Role__c historyEntry = null;         
            
        if (Trigger.isInsert){
            for(Account_Team__c new_trigger: Trigger.New){
                customer = CustomerAccountMap.get(new_trigger.customer__c);
                role = CustomerTeamRolesMap.get(new_trigger.Customer_Team_Role__c);
                //Mandatory null checks
                if(customer == null){
                	new_trigger.AddError('Fejl ved oprettelse: Kunde findes ikke');
                	continue;	
                }
                if(role == null){
                	new_trigger.AddError('Fejl ved oprettelse: Rolletype findes ikke');
                	continue;	
                }
                  
                //Cast Iron bypasses normal validation rules due to consistency issues.
                if (UserInfo.GetUserID() != CastIron.Id){
                    //First check for duplicates            
                    if(CheckForDuplicate(new_trigger)){             
                        new_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                        continue;//Skip to new trigger if errors 
                    }
                    
                    //String key = role.Name + ':YouSee Customer Teams'; 
                    String key = role.Id + ':YouSee Customer Teams';         
                    KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
                    
                    if(rule == null){
                        new_trigger.AddError('Der findes ikke en KISS valideringsregel for YouSee kontaktrollen: \'' + role.Name + '\'. Kontakt din Salesforce Administrator' );
                        continue; //Skip to new trigger if errors               
                    }
                    //Check for null customer - sometimes Cast Iron causes this error
                    if (customer == null){
                        new_trigger.AddError('Den angivne kunde med ID: \'' + new_trigger.customer__r.Id + '\' eksisterer ikke. Kontakt din Salesforce Administrator' );
                        continue; //Skip to new trigger if errors   
                    }
                    
                    //Check for expired role
                    if(((!rule.Unlimited__c) && (rule.Possible__c == 0) && (rule.Required__c == 0)) || (role.Active__c == 'Nej')){
                        new_trigger.AddError('Tilføjelse af YouSee kontaktrolle ikke mulig. Kontaktrollen' + ' \'' + role.Name + '\'' + ' er udgået og må ikke længere anvendes.' );
                        continue; //Skip to new trigger if errors
                    }
                    else if(!rule.Unlimited__c){//If not Unlimited, then count how many contact roles exist already for the specific customer
                        String currentRolesKey = customer.Id + ':' + role.Name;                 
                        CurrentRoles = Integer.valueOf(ctCurrentRolesMap.get(currentRolesKey));
                        //If CurrentRoles is null it means zero
                        if(CurrentRoles != null){
                            if (CurrentRoles + 1 > rule.Possible__c){                   
                                new_trigger.AddError('Tilføjelse af YouSee kontaktrolle ikke mulig. Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' rolle(r) tilknyttet kunder af typen: ' + customer.Type);
                            	continue; //Skip to new trigger if errors 	
                            }
                        } 
                    }//End Else-If !rule.Unlimited__c
                }//End if-not Cast Iron
                
                //Updates search criteria at insert
                updateSearchCriteria(new_trigger, CustomerTeamRolesMap.get(new_trigger.Customer_Team_Role__c) != null ? CustomerTeamRolesMap.get(new_trigger.Customer_Team_Role__c).Name : null,
                                     TeamMemberMap.get(new_trigger.Customer_Team_Member__c).Name,
                                     new_trigger.Cable_Unit__c);
               	
               	//Add insert to history log               	
           		historyEntry = new History_Log_Internal_Contact_Role__c(
           			Customer_Name__c = CustomerAccountMap.get(new_trigger.Customer__c) != null ? CustomerAccountMap.get(new_trigger.Customer__c).Name  : null,	           			
	           		Cable_Unit_No__c = CustomerAccountMap.get(new_trigger.Customer__c).Cable_Unit_No__c != null ? CustomerAccountMap.get(new_trigger.Customer__c).Cable_Unit_No__c : null,         		
           			Action__c = 'New', 
           			Account__c = new_trigger.Customer__c,
           			New_Customer_Team_Member__c = new_trigger.Customer_Team_Member__c,           		
           			New_Role__c = new_trigger.Customer_Team_Role__c,
           			New_Role_Name__c = CustomerTeamRolesMap.get(new_trigger.Customer_Team_Role__c) != null ? CustomerTeamRolesMap.get(new_trigger.Customer_Team_Role__c).Name : null           		
           		);           		
            	history_entries.add(historyEntry);
            }//End For-structure    
        }//End Trigger.isInsert
        else{
            for(Account_Team__c update_trigger: Trigger.New){                
                customer = CustomerAccountMap.get(update_trigger.customer__c);
                role = CustomerTeamRolesMap.get(update_trigger.Customer_Team_Role__c);
                
                //Mandatory null checks
                if(customer == null){
                	update_trigger.AddError('Fejl ved oprettelse: Kunde findes ikke');
                	continue;	
                }
                if(role == null){
                	update_trigger.AddError('Fejl ved oprettelse: Rolletype findes ikke');
                	continue;	
                }
                
                //Cast Iron bypasses normal validation rules due to consistency issues. 
                if (UserInfo.GetUserID() != CastIron.Id){
                    //Locate KISS rule for new contact role
                    //Old: String newKey = role.Name + ':YouSee Customer Teams';
                    String newKey = role.Id + ':YouSee Customer Teams';
                    KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(newKey);                    
                    if(rule == null){
                        update_trigger.AddError('Der findes ikke en KISS valideringsregel for YouSee kontaktrollen: \'' + role.Name + '\'. Kontakt din Salesforce Administrator' );
                        continue; //Skip to new trigger if errors               
                    }
                    
                    //Check for null customer - sometimes Cast Iron causes this error
                    if (customer == null){
                        update_trigger.AddError('Den angivne kunde med ID: \'' + update_trigger.customer__r.Id + '\' eksisterer ikke. Kontakt din Salesforce Administrator');
                        continue; //Skip to new trigger if errors   
                    }       
                    //Check for expired role
                    if(((!rule.Unlimited__c) && (rule.Possible__c == 0) && (rule.Required__c == 0)) || (role.Active__c == 'Nej')){
                        update_trigger.AddError('Ændring af YouSee YouSee kontaktrolle ikke mulig. Kontaktrollen' + ' \'' + role.Name + '\'' + ' er udgået og må ikke længere anvendes.' );
                    	continue; //Skip to new trigger if errors
                    }
                    else{                 
                        /*
                        Two checks need to be made if the user update the role: 
                        (1) Determine if KISS rule (minimum) for old contact role is respected.
                        (2) New YouSee contact roles don't exceed maximum settings for a specfic role type.
                        Updates regarding the contacts don't apply in KISS validation since duplication check is performed prior to KISS validation in this trigger
                        */  
                                    
                        //Load the old role and determine if the user has changed to a new role             
                        Lookup_Account_Team_Role__c oldContactRole = CustomerTeamRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c);
                        
                        //If the user has changed the role then check validation rules for old and new role
                        //If by mistake, the old role id is null, we allow inserting a new role without validation since this is an odd scenario.
                        if(oldContactRole != null && update_trigger.Customer_Team_Role__c != oldContactRole.Id){                                      
                            //First check for duplicates            
                            if(CheckForDuplicate(update_trigger)){              
                                update_trigger.AddError('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.');
                                continue;//Skip to new trigger if errors
                            }//Close if duplicate
                            
                            //Check if old role rule is still valid. Assume that the customer is the same                   
                            //Old: String oldKey = oldContactRole.Name + ':YouSee Customer Teams';
                            //Old: KISS_Role_Validation_Rules__c rule_old = KISSRulesMap.get(oldKey);
                            String oldKey = oldContactRole.Id + ':YouSee Customer Teams';
                            KISS_Role_Validation_Rules__c rule_old = KISSRulesMap.get(oldKey);
                            if(rule == null){
                                update_trigger.AddError('Der findes ikke en KISS valideringsregel for YouSee kontaktrollen: \'' + oldContactRole.Name + '\'. Kontakt din Salesforce Administrator' );
                                continue; //Skip to new trigger if errors               
                            }
                            
                            //Count how many contact roles exist already for the specific customer for old roles
                            String currentRolesKey = customer.Id + ':' + oldContactRole.Name;                   
                            CurrentRoles = Integer.valueOf(ctCurrentRolesMap.get(currentRolesKey));
                            //If CurrentRoles is null it means zero
                            if(CurrentRoles == null)
                                CurrentRoles = 0;      
                            
                            //Check if new role exceed maximum requirements
                            String newRolesKey = customer.Id + ':' + role.Name;                 
                            Integer NewRoles = Integer.valueOf(ctCurrentRolesMap.get(newRolesKey));
                            //If NewRoles is null it means zero
                            if(NewRoles == null)
                                NewRoles = 0;
                                
                            String update_error = 'Ændring af YouSee kontaktrolle ikke mulig. ';
                            Boolean hasError = false;
                            //Does the old role still comply with minimum requirements in KISS?
                            system.debug('CurrentRoles: ' + CurrentRoles + 'Rule_old_required: ' + rule_old.Required__c);
                            if (CurrentRoles -1 < rule_old.Required__c) {                                             
                                update_error += 'Der skal mindst være ' + rule_old.Required__c + ' \'' + oldContactRole.Name + '\' YouSee kontaktrolle(r) tilknyttet kunder af typen: ' + customer.Type + '. ';
                                hasError = true;
                            }   
                            //Check if new role does not exceed maximum settings in KISS                        
                            if(!rule.Unlimited__c && (NewRoles + 1 > rule.Possible__c)){                                
                                update_error += 'Der må maks. være ' + rule.Possible__c + ' \'' + role.Name + '\' YouSee kontaktrolle(r) tilknyttet kunder af typen: ' + customer.Type;
                                hasError = true;
                            }
                            if(hasError){
                                update_trigger.AddError(update_error);
                                continue; //Skip to new trigger if errors
                            }
                        }//end if different roles
                    }//End Not Expired
                }//End if-not Cast Iron user
                
                //Update Search Criteria
                updateSearchCriteria(update_trigger, CustomerTeamRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c) != null ? CustomerTeamRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c).Name : null,
                                         TeamMemberMap.get(update_trigger.Customer_Team_Member__c).Name,
                                         update_trigger.Cable_Unit__c);
                                         
                if( update_trigger.Customer_Team_Role__c != Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c ||
                	update_trigger.Customer_Team_Member__c != Trigger.oldMap.get(update_trigger.Id).Customer_Team_Member__c){
            		
            		//Add update data to history log			           		
	           		historyEntry = new History_Log_Internal_Contact_Role__c(
	           			Customer_Name__c = CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c) != null ? CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Name  : null,	           			
	           			Cable_Unit_No__c = CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Cable_Unit_No__c != null ? CustomerAccountMap.get(Trigger.oldMap.get(update_trigger.Id).Customer__c).Cable_Unit_No__c : null,
	           			Action__c = 'Update', 
	           			Account__c = update_trigger.Customer__c,
	           			Old_Customer_Team_Member__c = Trigger.oldMap.get(update_trigger.Id).Customer_Team_Member__c,           		
	           			Old_RoleId__c = Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c,
	           			Old_Role_Name__c = CustomerTeamRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c) != null ? CustomerTeamRolesMap.get(Trigger.oldMap.get(update_trigger.Id).Customer_Team_Role__c).Name : null,	           		
	           			New_Customer_Team_Member__c = update_trigger.Customer_Team_Member__c,           		
	           			New_Role__c = update_trigger.Customer_Team_Role__c,
	           			New_Role_Name__c = CustomerTeamRolesMap.get(update_trigger.Customer_Team_Role__c) != null ? CustomerTeamRolesMap.get(update_trigger.Customer_Team_Role__c).Name : null	           		 
	           		);	           		  
                	history_entries.add(historyEntry);
                }//End history update                 	                              
            }// End outer For-structure
        }//End else if isUpdate
    }//End trigger switch
    updateHistoryLog();
    
    //This method updates text field on Account Contact Roles to make them searchable in Global Search
    private void updateSearchCriteria(Account_Team__c edit_new_ct, 
                                    String roleName, String memberName, 
                                    String cableUnitNumber){                                            
        edit_new_ct.Customer_Team_Role_Name_Search_Criteria__c = roleName;
        edit_new_ct.Customer_Team_Member_Search_Criteria__c = memberName;
        edit_new_ct.Cable_Unit_Number_Search_Criteria__c = cableUnitNumber;     
    }
    
     //Private method to check for duplicates
    private boolean CheckForDuplicate(Account_Team__c newCT){ 
        Boolean isDuplicate = false;
        for(Account_Team__c oldCT: DuplicateMapCheck.values()){
            if( (newCT.Customer__c == DuplicateMapCheck.get(oldCT.Id).Customer__c) &&
                (newCT.Customer_Team_Role__c == DuplicateMapCheck.get(oldCT.Id).Customer_Team_Role__c) &&
                (newCT.Customer_Team_Member__c == DuplicateMapCheck.get(oldCT.Id).Customer_Team_Member__c) &&
                (newCT.Id != oldCT.Id)){
                isDuplicate = true;
                break;              
            }
        }//End for-loop  
        return isDuplicate;                     
    }//End CheckForDuplicate
    
    private void updateHistoryLog(){
        //Update history logs with trigger actions
        if(history_entries.size() != 0) {
           Database.SaveResult[] resultsAccount = Database.insert(history_entries);
        }        
    }
}