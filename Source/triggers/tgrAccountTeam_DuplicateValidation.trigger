trigger tgrAccountTeam_DuplicateValidation on Account_Team__c (before insert, before update) {
     
    for (Account_Team__c atm : Trigger.New){  
       for (Account_Team__c at : 
               [SELECT Customer__c, Customer_Team_Role__c , Customer_Team_Member__c 
                FROM Account_Team__c 
                WHERE Id !=:  atm.Id 
                AND Customer__c =: atm.Customer__c 
                AND Customer_Team_Role__c  = : atm.Customer_Team_Role__c
                AND Customer_Team_Member__c =:  atm.Customer_Team_Member__c ]
            ){
           atm.AddError('The one can not enter duplicate account team member and role names');            
       }   
    }  
}