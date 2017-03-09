trigger tgrCustomTeamAfterInsert on Account_Team__c (after insert) {
	
	/*
	List <Account_Team__c> accountTeams = new List<Account_Team__c>();
	
		This after trigger inserts the Salesforce ID into StaffActorID__c on internal contact roles created on hierarchy customers.
		The background is because contact roles added on hierarchy customers are not created in KISS, thus no external id is received.
		Instead, these contact roles are stored directly in datawarehouse bypassing KISS. To ensure consistency in the use of external id we
		reuse the Salesforce id	as external id.
	
	if(Trigger.isAfter && Trigger.isInsert){   			
   		for(Account_Team__c ct: Trigger.new){   				
   			if(ct.Customer_Type__c == 'Hierarki'){
   				//We use the cloning capability to update fields after creation
   				Account_Team__c ct_tmp = ct.clone(true, true);  					        		
        		ct_tmp.StaffActorID__c = ct.Id;
        		accountTeams.add(ct_tmp);        				
      		}
   		}
   }
   //Update list of updated account teams
   if(accountTeams.size() > 0)
   		Database.update(accountTeams);*/
}