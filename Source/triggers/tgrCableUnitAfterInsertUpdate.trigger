trigger tgrCableUnitAfterInsertUpdate on Cable_Unit__c (before update) {
	List<Account> accountList = new List<Account>();
	
	/*For(Cable_Unit__c cu :Trigger.new){
		Cable_Unit__c oldCU = (Cable_Unit__c)System.Trigger.oldMap.get(cu.Id);
		if(oldcu.Current_Kiss_Case__c != null && cu.Current_Kiss_Case__c != null) {
			Opportunity oldOpp = [Select o.accountId from Opportunity o where o.id =: oldcu.Current_Kiss_Case__c];
			Opportunity newOpp = [Select o.accountId from Opportunity o where o.id =: cu.Current_Kiss_Case__c];
			if(cu.Current_Kiss_Case__c != oldCU.Current_Kiss_Case__c && newOpp.accountId != oldOpp.accountId) {
				Account oldAcc = [Select a.Cable_Unit__c, a.recordTypeId from account a where a.Id =: oldOpp.accountId];
				Account newAcc = [Select a.Cable_Unit__c, a.recordTypeId from account a where a.Id =: newOpp.accountId];
				if(oldAcc.RecordTypeId == '012200000000nf3' &&  newAcc.RecordTypeId == '012200000000o7Z') {
					oldAcc.Cable_Unit__c = null;
					oldAcc.RecordTypeId = '012200000000o7Z';
					newAcc.Cable_Unit__c = cu.id;
					newAcc.RecordTypeId = '012200000000nf3';
					accountList.add(oldAcc);
					accountList.add(newAcc);
				}
			}			
		}
	}
		
	if (!accountList.isEmpty()) {
            update accountList;
    }*/
    
    	
	
}