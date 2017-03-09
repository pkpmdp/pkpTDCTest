trigger tgrAddressAfterInsertUpdate on Address__c (after insert, after update) {
//SFDC TEST ( before insert,before update)
   //if(Trigger.isBefore)
  // System.debug('SFDC TEST Trigger Invoked');
//SFDC TEST END
    // List of account to be updated
    List<Account> accToUpdate = new List<Account>();
    
    // Map to addresses
    Map<Id,Address__c> addrMap = new Map<Id,Address__c>();
    
    if(Trigger.isAfter){
      addrMap = Trigger.newMap;
      // Loop through Account which are to be updated
      for(Account acc : [Select Id,Street_YK__c, CustomerSubType__c,customer_type__c From Account where IsPersonAccount = true and Street_YK__c in : addrMap.keySet()]){        
        System.debug('Account *****'+acc);
        Address__c address = addrMap.get(acc.Street_YK__c);
        
        if(acc.CustomerSubType__c == 'Normal'){
            System.debug('Inside Normal');
            if(address.OclearAddress__c == 'Yes' && address.Isubscription__c == 'No' && acc.customer_type__c !='Organiseret'){ // addedd customer_type__c condition for SPOC-1482
                acc.CustomerSubType__c = 'O-Slutkunde';
                accToUpdate.add(acc);
            }
        }else if(acc.CustomerSubType__c == 'O-Slutkunde'){
            System.debug('Inside O-slutKune');
            if(address.OclearAddress__c == 'Yes' && address.Isubscription__c == 'Yes'){
                acc.CustomerSubType__c = 'Normal';
                accToUpdate.add(acc);
            }
        }
      }
      
      // Update Accounts 
      if(accToUpdate.size() > 0){
          update accToUpdate;  
          System.debug('Update list&&&&&'+accToUpdate);
      }
    }
}