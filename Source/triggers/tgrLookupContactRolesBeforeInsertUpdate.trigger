trigger tgrLookupContactRolesBeforeInsertUpdate on Lookup_Contact_Roles__c (before insert, before update, before delete) {
    
    //Tmp code to controll triggers in production
    //Retriving environment unique field ids for customer lookup fields
    YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
    Boolean runTrigger = false;
	YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
	List<DeletedContactRole__c>	deletedRecords = new List<DeletedContactRole__c>();
	List<Lookup_Contact_Roles__c> roleList = new List<Lookup_Contact_Roles__c>();
	//Start Trigger switch
	if (config != null && (runTrigger = config.Contact_Role_Type__c) == true) {
    
    User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];    
    
    if (trigger.isDelete){
    	for(Lookup_Contact_Roles__c old : trigger.old)
		old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
    }
    
    /*if(Trigger.isDelete){
    	DeletedContactRole__c delContact = new DeletedContactRole__c();
    	Set<Id> contactroleIdSet = new Set<Id>();
        Map<Id, Lookup_Contact_Roles__c> contactroleMap = new Map<Id, Lookup_Contact_Roles__c>();
        
        for(Lookup_Contact_Roles__c lcrList : Trigger.old){
			if(!contactroleIdSet.contains(lcrList.Id))
				contactroleIdSet.add(lcrList.id);
		}
		if(contactroleIdSet.size() > 0){
			for(Lookup_Contact_Roles__c lcr : [Select Id from Lookup_Contact_Roles__c where Id IN (Select Role__c from Account_Contact_Role__c where Role__r.Id IN : contactroleIdSet)]){
				if(contactroleMap.get(lcr.id) == null)
					contactroleMap.put(lcr.Id,lcr);
			}

		}
		
		for(Lookup_Contact_Roles__c lcrOld : Trigger.old){
			if(lcrOld.SourceId__c != null){ 
				if(contactroleMap.get(lcrOld.id) != null)
					lcrOld.addError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
				else
					delContact.ContactRoleSourceId__c =  lcrOld.SourceId__c;
					Lookup_Contact_Roles__c lcrrole = lcrOld.clone(true, false);
					lcrrole.Delete_Flag__c = true;
					//lcrrole.id = lcrOld.id;
					//lcrrole.End_Date__c = Date.today();
        			roleList.add(lcrrole);
					deletedRecords.add(delContact);
					System.debug('@@@@@Before Delete'+roleList);
			}
		
		}
		if(deletedRecords.size() > 0){
			Database.SaveResult[] results = Database.insert(deletedRecords);
		}
		
		if(roleList.size() > 0){
			Database.SaveResult[] updateResult = Database.update(roleList);
			System.debug('@@@@@update outbound fire'+roleList);
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
	        
	        for (Lookup_Contact_Roles__c cr : Trigger.new) {  
	        	if(trigger.isInsert){
	        		if(existingInternalRoles.get(cr.Code__c)!= null || existingExternalRoles.get(cr.Code__c)!= null){
	        			cr.AddError('Koden du har angivet findes allerede på en anden intern eller ekstern kontaktrolle. Prøv venligst igen.');
	        		}
	        	}
	        	
	        	/*if(existingInternalRoles.get(cr.Code__c)!= null ||	        		        	
	        	  (existingExternalRoles.get(cr.Code__c)!= null && trigger.isInsert))
	                cr.AddError('Koden du har angivet findes allerede på en anden intern eller ekstern kontaktrolle. Prøv venligst igen.');*/   
	        }
	    }//Close If Not Cast Iron 
    }    
	}//End TMP Trigger switch 
}//End Class