public with sharing class clsCasesUtil {

    public void linkCasesToCustomer(List<Case> newVersions, List<Case> oldVersions) {

       Map<String, Case> accountsToUpdate1 = new Map<String, Case>();
       Map<String, Case> accountsToUpdate2 = new Map<String, Case>();
       Map<String, Case> accountsToUpdate3 = new Map<String, Case>();
	  
       for (Integer i = 0; i < newVersions.size(); i++) {

          if (Trigger.isInsert) {

            if ((newVersions[i].AccountId == null) && (newVersions[i].Customer_Number__c != null)) {
              // Set the customer lookup
              accountsToUpdate1.put(newVersions[i].Customer_Number__c, newVersions[i]);
            }
            else if ((newVersions[i].AccountId == null) && (newVersions[i].Anlaeg_No_New__c != null)) {
              // Set the customer lookup
              accountsToUpdate2.put(newVersions[i].Anlaeg_No_New__c, newVersions[i]);
            } 
            else if ((newVersions[i].AccountId == null) && (newVersions[i].Email__c != null) && (newVersions[i].Department__c != 'Blockbuster')) {
              // Set the customer lookup
              accountsToUpdate3.put(newVersions[i].Email__c, newVersions[i]);
            } 
          }

          if (Trigger.isUpdate) {
                
               if (newVersions[i].Customer_Number__c != oldVersions[i].Customer_Number__c) {
                 
                // Customer number has changed 
                if (newVersions[i].Customer_Number__c == null) {
                      newVersions[i].AccountId = null;
                      newVersions[i].Anlaeg_No_New__c = null;//added by Satarupa on 24th June 2015
                } else {
                                    
                	accountsToUpdate1.put(newVersions[i].Customer_Number__c,newVersions[i] );
                	String key = newVersions[i].Customer_Number__c;
                	while (key.length() < 10) {                
			               
			                key = '0' + key;
			        }                    
                	accountsToUpdate1.put(key, newVersions[i]);                   
                }
              }
              else if(newVersions[i].Anlaeg_No_New__c != oldVersions[i].Anlaeg_No_New__c){
              
              	//Anlaeg number has changed 
                if (newVersions[i].Anlaeg_No_New__c == null) {                	
                  newVersions[i].AccountId = null;
                  newVersions[i].Customer_Number__c = null;
                  
                } else {
                	accountsToUpdate2.put(newVersions[i].Anlaeg_No_New__c, newVersions[i]);
                	//if(mapCustNoToBusinessArea.get(newVersions[i].Anlaeg_No_New__c)=='YS'){
                	 String key = newVersions[i].Anlaeg_No_New__c;
	                    while (key.length() < 10) {                
		               
		                key = '0' + key;
		        }                    
            	accountsToUpdate2.put(key, newVersions[i]);            
                }
              }
              else if(newVersions[i].Email__c != oldVersions[i].Email__c){
                 //Email has changed 
                if (newVersions[i].Email__c == null) {
                  newVersions[i].AccountId = null;
                } else {
                accountsToUpdate3.put(newVersions[i].Email__c, newVersions[i]);
                }
              }
            }
        }
        
        if(accountsToUpdate1.size() > 0 || accountsToUpdate2.size() > 0 || accountsToUpdate3.size() > 0){
          //SF-2674
          system.debug('accountsToUpdate2'+accountsToUpdate2);
          system.debug('accountsToUpdate1'+accountsToUpdate1);
          //List<Account> accounts = [Select Id, Anlaeg_No__c, Customer_No__c, (Select Id, Name From Contacts) From Account Where YouSee_Business_Area__c =:'YS' AND Anlaeg_No__c In :accountsToUpdate2.keySet()];
          List<Account> accounts = [Select Id, Anlaeg_No__c, Customer_No__c, (Select Id, Name From Contacts) From Account Where YouSee_Business_Area__c =:'YS' AND Customer_No__c In :accountsToUpdate2.keySet()];
    
          // Set the account ids of the trigger records
          Map<String, Account> customerMap2 = new Map<String, Account>();
          for (Account account : accounts) {
          	//SF-2674
          	//customerMap2.put(account.Anlaeg_No__c, account);
            customerMap2.put(account.Customer_No__c, account);
          }
          /*for (Case c: accountsToUpdate2.values()) {
            Account account = customerMap2.get(c.Anlaeg_No_New__c);
            system.debug('***********'+c.Anlaeg_No_New__c);
            system.debug('account**'+account);
            if (account == null) {
            system.debug('account is null-----------'+account );
              c.AccountId = null;
             // c.Customer_Number__c= null;
              system.debug('accountid is null---------'+c.AccountId);
            } else {
              c.AccountId = account.Id;
              if(account.Contacts.size()!=0) {
                System.debug('Wen'+account.Contacts[0].id);
                c.ContactId = account.Contacts[0].id;
              }
            }
          }*/
          
          for(String s: accountsToUpdate2.keyset()){
          	Case c = accountsToUpdate2.get(s);
          	Account account = customerMap2.get(s);
          	if (account == null) {
              c.AccountId = null;
             // c.Customer_Number__c= null;
              system.debug('accountid is null---------'+c.AccountId);
            } else {
              c.AccountId = account.Id;
              if(account.Contacts.size()!=0) {
                //System.debug('Wen'+account.Contacts[0].id);
                c.ContactId = account.Contacts[0].id;
              }
              else
              	c.ContactId = null;
            }
           	
          }
          // Set the account ids of the trigger records
          Map<String, Account> customerMap = new Map<String, Account>();
          for (Account account : [Select Id, Customer_No__c, Anlaeg_No__c, Cableunit_no__c, (Select Id, Name From Contacts) From Account Where Customer_No__c <> null and Customer_No__c In :accountsToUpdate1.keySet()]) {
            //changed for sf-2674   customerMap.put(account.Anlaeg_No__c, account);
            customerMap.put(account.Customer_No__c, account);
          }
          /*for (Case c: accountsToUpdate1.values()) {
            Account account = customerMap.get(c.Customer_Number__c);
            if (account == null) {
            system.debug('2nd if account null'+account );
              c.AccountId = null;
            } else {
            system.debug('2nd else');
              c.AccountId = account.Id;
              //changed for sf-2674
              //c.Anlaeg_No_New__c = account.Anlaeg_No__c;
              c.Anlaeg_No_New__c = account.Customer_No__c;
              if(account.Contacts.size()!=0){
                //System.debug('Wen'+account.Contacts[0].id);
                c.ContactId = account.Contacts[0].id;
              }
            }
          }*/
          for(String s: accountsToUpdate1.keyset()){
          	Case c = accountsToUpdate1.get(s);
          	Account account = customerMap.get(s);
          	if (account == null) {
	           		c.AccountId = null;
            } else {
            		system.debug('2nd else');
              		c.AccountId = account.Id;
              		//SF-2674 Changing the field as Anlaeg_No__c can be blank for YS.
              		//c.Anlaeg_No_New__c = account.Anlaeg_No__c;
              		c.Anlaeg_No_New__c = account.Cableunit_no__c;
              		if(account.Contacts.size()!=0){
                		//System.debug('Wen'+account.Contacts[0].id);
                	c.ContactId = account.Contacts[0].id;
              		}
              		else
              		c.ContactId = null;	
            }
          	
          }
          // Set the account ids of the trigger records
          Map<String, Account> customerMap3 = new Map<String, Account>();
          for (Account account : [Select Id, PersonEmail, (Select Id, Name From Contacts) From Account Where PersonEmail <> null and PersonEmail In :accountsToUpdate3.keySet()]) {
            customerMap3.put(account.PersonEmail, account);
          }
          for (Case c: accountsToUpdate3.values()) {
            Account account = customerMap3.get(c.Email__c);
            if (account == null) {
              c.AccountId = null;
            } else {
              c.AccountId = account.Id;
              c.Email__c = account.PersonEmail;
              if(account.Contacts.size()!=0){
                //System.debug('Wen'+account.Contacts[0].id);
                c.ContactId = account.Contacts[0].id;
              }
            }
          }
         
        }
    }
	
    // Test coverage for requirement to link cases to customers based on customer number
    
    /*static testMethod void testLinkCaseToCustomer() {

        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        RecordType recordType2 = [Select Id From RecordType Where Name = 'Blockbuster Customer Account'];

        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;

        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        acc.RecordTypeId=recordType2 .Id;
        //acc.RecordTypeName__c='Blockbuster Customer Account';
        insert acc;
        
         
        acc = [Select Id, Customer_No__c From Account Where Id = :acc.Id];

        // Create case record
        Case c = new Case();
        c.Customer_Number__c = acc.Customer_No__c;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Anlaeg_No_New__c='1234';
        //c.Email__c='tejas@test.com';
        //c.Department__c = '';
        c.Product_2__c = 'TV';
        c.Type_Task__c = 'Support';
        c.RecordTypeId = recordType.Id;
        insert c;

        c = [Select Id, AccountId, Customer_Number__c From Case Where Id = :c.Id];
        System.assertEquals(acc.Id, c.AccountId);
    } */
}