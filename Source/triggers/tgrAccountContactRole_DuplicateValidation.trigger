trigger tgrAccountContactRole_DuplicateValidation on Account_Contact_Role__c (before insert, before update) {
    // Check that the combination of the contact and the role is not found as a duplicated for the relevant account
      
    for (Account_Contact_Role__c acr: Trigger.New){    
       for (Account_Contact_Role__c acrCR : 
                   [SELECT Customer__c, Contact__c , Role__c 
                    FROM Account_Contact_Role__c 
                    WHERE Id !=:  acr.Id 
                    AND Customer__c =: acr.Customer__c 
                    AND Contact__c =:  acr.Contact__c 
                    AND Role__c =: acr.Role__c ]){
           system.debug('******customer'+acr.Customer__c+'acr role'+acr.Role__c+'acr contact'+ acr.Contact__c);
           acr.AddError('The one can not enter duplicate contact and role names');            
       }     
    }  
}