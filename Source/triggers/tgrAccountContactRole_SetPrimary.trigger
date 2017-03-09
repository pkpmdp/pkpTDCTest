trigger tgrAccountContactRole_SetPrimary on Account_Contact_Role__c (before insert, before update) {
    // Make sure that only one record can have a Primary field checked for one customer 
    /*
    List <Account_Contact_Role__c> acrList  = new List<Account_Contact_Role__c>();
       
    for (Account_Contact_Role__c acr: Trigger.New){
        if (acr.Primary__c == true){
        	if (acr.Customer__c != null){
             	for (Account_Contact_Role__c acrP : [SELECT Id, Primary__c, Customer__c FROM Account_Contact_Role__c WHERE Primary__c = true and Id  != :  acr.Id and Customer__c = : acr.Customer__c Limit 1]){
               		acrP.Primary__c = false;
               		acrList.Add ( acrP);
             	}
        	}
        }       
    }       
 
    if (!acrList.isEmpty()){
         update acrList;         
    }
    */
}