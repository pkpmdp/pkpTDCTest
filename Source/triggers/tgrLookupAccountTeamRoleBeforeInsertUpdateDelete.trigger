trigger tgrLookupAccountTeamRoleBeforeInsertUpdateDelete on Lookup_Account_Team_Role__c (before insert, before update, before delete) {
        //Tmp code to controll triggers in production
    	//Retriving environment unique field ids for customer lookup fields
    	YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
    	Boolean runTrigger = false;
		YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
		List<DeletedContactRole__c>	deletedRecords = new List<DeletedContactRole__c>();
		List<Lookup_Account_Team_Role__c> actList = new List<Lookup_Account_Team_Role__c>();
		//Start Trigger switch
		if (config != null && (runTrigger = config.Customer_Team_Role__c) == true) {
        
        
        User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];        
        if(trigger.isDelete){
            for(Lookup_Account_Team_Role__c old : trigger.old)
                old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
        }
        /*if(trigger.isDelete){
        	Set<Id> contactroleIdSet = new Set<Id>();
        	DeletedContactRole__c delContact = new DeletedContactRole__c();
        	Map<Id,Lookup_Account_Team_Role__c> contactroleMap = new Map<Id,Lookup_Account_Team_Role__c>();
        	
        	for(Lookup_Account_Team_Role__c lcrTeamList : Trigger.old){
        		if(!contactroleIdSet.contains(lcrTeamList.id)){
        			contactroleIdSet.add(lcrTeamList.id);	
        		}
        	}
        	
        	if(contactroleIdSet.size() > 0){
        		for(Lookup_Account_Team_Role__c latr : [Select Id from Lookup_Account_Team_Role__c where Id IN (Select Customer_Team_Role__c from Account_Team__c where Customer_Team_Role__r.Id IN : contactroleIdSet)]){
				if(contactroleMap.get(latr.id) == null)
					contactroleMap.put(latr.Id,latr);
				}
        	}
        	
        	for(Lookup_Account_Team_Role__c latcr : Trigger.old){
        		if(latcr.SourceId__c != null){
        			if(contactroleMap.get(latcr.id) != null)
        				latcr.addError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
        			else
        				delContact.CustomerTeamRoleSourceId__c = latcr.SourceId__c;
        				Lookup_Account_Team_Role__c lcrrole = latcr.clone(true, true);  					        		
        				lcrrole.End_Date__c = Date.today();
        				actList.add(lcrrole);
        				deletedRecords.add(delContact);
        		}
        	}
        	
        	if(deletedRecords.size() > 0){
				Database.SaveResult[] results = Database.insert(deletedRecords);
			}
			
        	if(actList.size() > 0){
        		Database.SaveResult[] results1 = Database.update(actList);
        	}
		}*/
		
		
		
		else{   
            if (UserInfo.GetUserID() != CastIron.Id){
                //Preload internal contact role
                Map <String, Lookup_Contact_Roles__c> existingExternalRoles  = new Map <String, Lookup_Contact_Roles__c>();
                for(Lookup_Contact_Roles__c externalRole : [select Id, Code__c from Lookup_Contact_Roles__c]){        
                    if (existingExternalRoles.get(externalRole.Code__c) == null)
                        existingExternalRoles.put(externalRole.Code__c, externalRole);        
                }
                
                //Preload internal contact role
                Map <String, Lookup_Account_Team_Role__c> existingInternalRoles  = new Map <String, Lookup_Account_Team_Role__c>();
                for(Lookup_Account_Team_Role__c internalRole : [select Id, Code__c from Lookup_Account_Team_Role__c]){        
                    if (existingInternalRoles.get(internalRole.Code__c) == null)
                        existingInternalRoles.put(internalRole.Code__c, internalRole);        
                }
                /*
                for (Lookup_Account_Team_Role__c cr : Trigger.new) {
                    if( existingExternalRoles.get(cr.Code__c)!= null ||
                       (existingInternalRoles.get(cr.Code__c)!= null && trigger.isInsert))
                        cr.AddError('Koden du har angivet findes allerede på en anden intern eller ekstern kontaktrolle. Prøv venligst igen.');   
                }*/
                
                for(Lookup_Account_Team_Role__c cr : Trigger.new) {  
		        	if(trigger.isInsert){
		        		if(existingExternalRoles.get(cr.Code__c)!= null || existingInternalRoles.get(cr.Code__c)!= null){
		        			cr.AddError('Koden du har angivet findes allerede på en anden intern eller ekstern kontaktrolle. Prøv venligst igen.');
		        		}
		        	}
                }
                
              }//Close If Not Cast Iron 
        }
    
    }//End TMP Trigger switch
}