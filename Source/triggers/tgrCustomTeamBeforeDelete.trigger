trigger tgrCustomTeamBeforeDelete on Account_Team__c (before delete) {  
    /*  All deleted records are transferred to a custom object DeletedAccountContactRole__c.
        This reason for this design is because Salesforce cannot send outbound delete messages from the Account_Team__c object
    */
    //Retrive ID for Cast Iron User for bypassing validation
    User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    
    List<History_Log_Internal_Contact_Role__c> history_entries = new List<History_Log_Internal_Contact_Role__c>();
    
    List<DeletedContactRole__c> deletedRecords = new List<DeletedContactRole__c>();
    
    Set <Id> customerIds = new Set<Id>();
    for(Account_Team__c ct_old : Trigger.old){        
        if (!customerIds.contains(ct_old.customer__c)){
            customerIds.add(ct_old.customer__c);   
        }          
    } 
    
    //Preload KISS rules to save SOQL queries in for loop
    Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
    for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Unlimited__c, Required__c, Possible__c, Type__c, Customer_Team_Role__c from KISS_Role_Validation_Rules__c where Type__c = 'YouSee Customer Teams']){
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
    
    History_Log_Internal_Contact_Role__c historyEntry = null;
    
    for(Account_Team__c ct: [Select Customer__r.Type, Customer__r.Cable_Unit_No__c, Customer_Team_Member__c, Customer_Team_Role__c, Customer__r.Name, Customer_Team_Role__r.Name, Customer_Team_Member_Kiss_Id__c, StaffActorID__c, Customer_Kiss_Id__c, Customer_Team_Role_Kiss_Id__c, Customer_Name__c from Account_Team__c where Id in : Trigger.oldmap.keySet()])
    {       
        //Cast Iron bypasses normal validation rules due to consistency issues. 
        //Object is also NOT transferred to DeletedAccountTeam__c to prevent outbound messages looping issues
        if (UserInfo.GetUserID() != CastIron.Id){
	        
	        //String key = ct.Customer_Team_Role__r.Name + ':YouSee Customer Teams';
	        String key = ct.Customer_Team_Role__c + ':YouSee Customer Teams';
	        KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
	        if(rule == null){
	            Trigger.oldMap.get(ct.Id).AddError('Der findes ikke en KISS valideringsregel for kontaktrollen: \'' + ct.Customer_Team_Role__r.Name + '\'. Kontakt din Salesforce Administrator' );
	            continue;//Skip to new trigger if errors              
	        }
	            
	        String currentRolesKey = ct.Customer__c + ':' + ct.Customer_Team_Role__r.Name; 
	        Integer CurrentRoles = ctCurrentRolesMap.get(currentRolesKey);              
	        
	        //Null value equals zero
	        if(CurrentRoles == null)
	            CurrentRoles = 0;
	                                
	        if (CurrentRoles <= rule.Required__c){ 
	             Trigger.oldMap.get(ct.Id).AddError('Sletning af påkrævet rolle ikke mulig. Der skal være mindst ' + rule.Required__c + ' ' + ct.Customer_Team_Role__r.Name + ' rolle(r) tilknyttet kunder af typen: ' + ct.Customer__r.Type);
	             continue;//Skip to new trigger if errors
	        }
	                   
	        /* 
	         	When deleting internal contact roles, a dummy object is created on a custom object 'DeletedAccountTeam__c'. When inserting this object with required
	         	deletion information, an outbound is sent for backend deletion.
	         	Note: New deletion capability added as part of CRM-53. Now, deletion of internal contact roles on both hierarchy and cable units         
	            are sent outbound in separate outbounds and workflow rules. The field customer type on DeletedAccountTeam__c is used to 
	            distinguish between deletion events from hierarchy and cable units, respectively.
	          
	       	*/ 
	        //StaffActorID__c is required to commit deletion to backend systems
	        // commented for making party actor changes	
	        /*if(ct.StaffActorID__c == null){
	            //Trigger.oldMap.get(ct.Id).AddError('Kontaktrollen er nyoprettet og afventer oprettelse i KISS. Prøv igen om 10-15 sekunder.');
	          	Trigger.oldMap.get(ct.Id).AddError(System.Label.SC_ContactRoleExternalId);
	            continue;//Skip to new trigger if errors
	        }else{ 
	            //Account Team Role information is copied to customized deletion object due to integration setup.
	            DeletedAccountTeam__c dat = new DeletedAccountTeam__c();
	            //We assume that KISS Ids for customer, team member and staff-actor is present
	            dat.Customer_Team_Member_Kiss_Id__c = ct.Customer_Team_Member_Kiss_Id__c;
	            dat.Customer_Type__c = ct.Customer__r.Type;
	            //Dummy value is inserted for roles associated with hierarchy customers
	            dat.Customer_Kiss_ID__c = ct.Customer_Kiss_Id__c != null ? ct.Customer_Kiss_Id__c : 'Dummy-value';
	            dat.StaffActorId__c = ct.StaffActorID__c;                       
	            dat.LastModified__c = CastIron.Id;  
	            dat.Customer_Name__c = ct.Customer_Name__c;             
	            deletedRecords.add(dat);
	        }*/
	        // dont display error message if staffActor id is null since salesforce only send record id into StaffActorId__c
	        if(ct.StaffActorID__c != null){
	        	//Account Team Role information is copied to customized deletion object due to integration setup.
	            DeletedContactRole__c dat = new DeletedContactRole__c();
	            //We assume that KISS Ids for customer, team member and staff-actor is present
	            dat.Customer_Team_Member_Kiss_Id__c = ct.Customer_Team_Member_Kiss_Id__c;
	            dat.Customer_type__c = ct.Customer__r.Type;
	            //Dummy value is inserted for roles associated with hierarchy customers
	            dat.Customer_Kiss_ID__c = ct.Customer_Kiss_Id__c != null ? ct.Customer_Kiss_Id__c : 'Dummy-value';
	            dat.StaffActorId__c = ct.StaffActorID__c;                       
	            dat.LastModified__c = CastIron.Id;  
	            dat.Customer_Name__c = ct.Customer_Name__c;
				deletedRecords.add(dat); 
	        }
	        
	        
	         
       }//End if not Cast Iron 
             
       //Add insert to history log
       historyEntry = new History_Log_Internal_Contact_Role__c(
	       Action__c = 'Delete',
	       Customer_Name__c = ct.Customer__r.Name,	           			
	       Cable_Unit_No__c = ct.Customer__r.Cable_Unit_No__c != null ? ct.Customer__r.Cable_Unit_No__c : '',  
	   	   Account__c = ct.Customer__c,
	   	   Old_Customer_Team_Member__c = ct.Customer_Team_Member__c,           		
	   	   Old_RoleId__c = ct.Customer_Team_Role__c,
	   	   Old_Role_Name__c = ct.Customer_Team_Role__r.Name	   	   
       );
   	   
       history_entries.add(historyEntry);
	    /* Old code for deleting only contact roles on cable units - no longer valid
	    if(ct.Customer__r.Type != 'Hierarki'){        	
	        if(ct.Customer_Team_Role_Kiss_Id__c == null){
	            Trigger.oldMap.get(ct.Id).AddError('Kontaktrollen er nyoprettet og afventer oprettelse i KISS. Prøv igen om 10-15 sekunder.');
	        }else{
	            DeletedAccountTeam__c dat = new DeletedAccountTeam__c();
	            //We assume that KISS Ids for customer, team member and staff-actor is present
	            dat.Customer_Team_Member_Kiss_Id__c = ct.Customer_Team_Member_Kiss_Id__c;	           
	            dat.Customer_Kiss_ID__c = ct.Customer_Kiss_Id__c;
	            dat.StaffActorId__c = ct.StaffActorID__c;                       
	            dat.LastModified__c = CastIron.Id;  
	            dat.Customer_Name__c = ct.Customer_Name__c;             
	            deletedRecords.add(dat);
	        }
	    }
	   */          
    }//End for loop
    
    //Update database with deleted account contact roles
    if(deletedRecords.size() > 0) {
        Database.SaveResult[] resultsAccount = Database.insert(deletedRecords);
    }
    
    //Update history logs with trigger actions
    if(history_entries.size() > 0) {
    	 System.debug('Call before inserting into history log'+history_entries.size());
         Database.SaveResult[] resultsAccount = Database.insert(history_entries);
         System.debug('Insertion successful');
    }	
}//End trigger