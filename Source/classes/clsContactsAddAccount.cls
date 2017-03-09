public with sharing class clsContactsAddAccount {
     
    // Record type to be used to create dummy accounts
    static final String YS_CUSTOMER_RECORD_TYPE = '012200000000nf3';
    // Maximum number of contacts for a dummy account
    static final Integer MAX_CONTACTS_FOR_DUMMY_ACCOUNT = 50;
    // Default customer number - need this to validate query (needs an indexed field in where clause)
    static final String DEFAULT_CUSTOMER_NO = 'DUMMY_ACCOUNT';
    // Default dummy account name used in search
    static final String DEFAULT_START_CUSTOMER_NAME = 'DUMMY*';
       
    public void addDummyAccounts(List<Contact> contacts) {
        
        // Account record to associate contacts to
        DummyAccount dummyAccount;
        // List of dummy accounts that have their full allocation of contacts
        List<Account> existingDummyAccountsToRetire = new List<Account>();
        
        // Identify contacts that should be assigned to dummy accounts
        List<Contact> orphanContacts = new List<Contact>();
        for (Contact c : contacts) {
          if (c.AccountId == null) orphanContacts.add(c);
        }
        
        // Would prefer to fill up existing dummy accounts than create new ones
        List<Account> existingDummyAccounts = [Select Id, (Select Id From Contacts) From Account Where Name Like :DEFAULT_START_CUSTOMER_NAME And Dummy_Account__c = true and Dummy_Account_Allocation_Complete__c = false Limit 100];
        
     
        // Loop through the contacts that do not have an account
        for (Contact c : orphanContacts) {
          // Make sure we have a dummy account
            if (dummyAccount == null) {
            dummyAccount = getNextDummyAccount(existingDummyAccounts);
          }
          // If we have used up the allocation of the dummy account
          if (dummyAccount.getPlacesRemaining() < 1) {
            // Retire the dummy account
            dummyAccount.getAccount().Dummy_Account_Allocation_Complete__c = true;
            existingDummyAccountsToRetire.add(dummyAccount.getAccount());
            // And get a new one
            dummyAccount = getNextDummyAccount(existingDummyAccounts);
          }
          // Double check we have a dummy account to be safe
        if (dummyAccount != null) {
          if (dummyAccount.getAccount() != null) {
            // Set the account id of the trigger record
                  c.AccountId = dummyAccount.getAccount().Id;
                  // Decrement the number of places remaining for the account
                  dummyAccount.setPlacesRemaining(dummyAccount.getPlacesRemaining() - 1);
              }
            }
        }
      
        // Update any dummy accounts that should be retired
        Database.SaveResult[] results = Database.update(existingDummyAccountsToRetire);
    }
    
    private DummyAccount getNextDummyAccount(List<Account> existingDummyAccounts) {
      // Get the next dummy account - either from the existing list, or by creating a new one
      DummyAccount dummyAccount;
      // If there is an existing dummy account then use that
      if (existingDummyAccounts.size() > 0) {
        dummyAccount = new DummyAccount(existingDummyAccounts.get(0));
        dummyAccount.setPlacesRemaining(MAX_CONTACTS_FOR_DUMMY_ACCOUNT - dummyAccount.getAccount().Contacts.size());
        existingDummyAccounts.remove(0);
        } else {
        // Otherwise create a new one
        dummyAccount = createNewDummyAccount();
        // use updated method
        //dummyAccount = useExistingDummyAccount();
      }
      return dummyAccount;
    }
    
    private DummyAccount createNewDummyAccount() {
      Account newDummyAccount = new Account(Name='Dummy Account - '+system.now(),Dummy_Account__c=true,Dummy_Account_Allocation_Complete__c=false,Customer_No__c=DEFAULT_CUSTOMER_NO+'_'+System.currentTimeMillis(),RecordTypeId=YS_CUSTOMER_RECORD_TYPE);
      System.debug('newDummyAccount: ' + newDummyAccount);
      Database.SaveResult result = Database.insert(newDummyAccount);
      return new DummyAccount(newDummyAccount);
    }
    
    /*private DummyAccount useExistingDummyAccount() {
      List<Account> dummyList = [Select Id, Name,Dummy_Account_Allocation_Complete__c,Dummy_Account__c,Customer_No__c From Account where Dummy_Account_Allocation_Complete__c = false and Dummy_Account__c = true order by CreatedDate DESC limit 1 ];
      Account newDummyAccount = new Account();
      if(dummyList.size() > 0){
            newDummyAccount = dummyList.get(0);
      }
      //Account newDummyAccount = new Account(Name='Dummy Account - '+system.now(),Dummy_Account__c=true,Dummy_Account_Allocation_Complete__c=false,Customer_No__c=DEFAULT_CUSTOMER_NO+'_'+System.currentTimeMillis(),RecordTypeId=YS_CUSTOMER_RECORD_TYPE);
      System.debug('newDummyAccount: ' + newDummyAccount);
      //Database.SaveResult result = Database.insert(newDummyAccount);
      return new DummyAccount(newDummyAccount);
    }*/
    
    
    
    // Dummy account class wraps the account sobject
    class DummyAccount {
      private Account account;
      private Integer placesRemaining;
      
      public DummyAccount(Account acc) {
        this.account = acc;
        placesRemaining = MAX_CONTACTS_FOR_DUMMY_ACCOUNT;
      }
      
      public void setAccount(Account acc) {
        account = acc;
      }
      
      public Account getAccount() {
        return account;
      }
      
      public Integer getPlacesRemaining() {
        return placesRemaining;
      }
      
      public void setPlacesRemaining(Integer pr) {
        placesRemaining = pr;
      }
    }
    
    static testMethod void testContactsAddAccount() {
        YSRecordTypes__c obj = new YSRecordTypes__c();
        obj.Name = 'YSRecordTypes';
        obj.YK_Customer_Account__c = '012200000000o09';
        obj.YS_Contact_Record_Type__c = '012M0000000Clg3';
        obj.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c = '012200000000nf3';
        obj.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID2__c = '012200000000nf3AAA';
        obj.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID3__c = '012D0000000B2Z0';
        obj.YS_Customer_Account__c = '012200000000nf3';
        obj.YS_Hierarchy_Account__c = '012200000000o7Z';
        obj.YS_Opgave_Task_Record_Type__c = '01220000000TyI9AAK';
        insert obj;
        ServiceCenter_CustomSettings__c obj1 = new ServiceCenter_CustomSettings__c();
        obj1.Name = 'UserDataloadNoOutboundId';
        obj1.Value__c = '005M0000004cVgBIAU';
        insert obj1;
        
        ServiceCenter_CustomSettings__c obj2 = new ServiceCenter_CustomSettings__c();
        obj2.Name = 'UserCIID';
        obj2.Value__c = '005200000012Dn3AAE';
        insert obj2;
        
        ServiceCenter_CustomSettings__c obj3 = new ServiceCenter_CustomSettings__c();
        obj3.Name = 'UserAPINOId';
        obj3.Value__c = '005M0000004cVkwIAE';
        insert obj3;
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create contact
        Contact c = new Contact();
        c.FirstName = 'Bob';
        c.LastName = 'Smith';
        c.HomePhone = '123';
        c.Email = 'abcdddddd@test.com';
        c.Street_P__c = add.Id;
        insert c;
        
        c = [Select Id, AccountId From Contact Where Id = :c.Id];
        System.assertNotEquals(null, c.AccountId);
        
        // If we create 101 contacts we should have 3 new dummy accounts in total
        List<Contact> contactsToCreate = new List<Contact>();
        for (Integer i = 0; i < 101; i++) {
          Contact c1 = new Contact();
            c1.FirstName = 'Bob';
            c1.LastName = 'Smith';
            c1.HomePhone = '123';
            c1.Street_P__c = add.Id;
            c1.Email = 'ad@test.com';
            contactsToCreate.add(c1);
        }
        Database.SaveResult[] results = Database.insert(contactsToCreate);
        List<String> newContactIds = new List<String>();
        for (Database.SaveResult result: results) {
          newContactIds.add(result.getId());
        }
        List<Contact> newContacts = [Select Id, AccountId From Contact Where Id In :newContactIds];
        Set<Id> newAccountIds = new Set<Id>();
        for (Contact newContact : newContacts) {
          newAccountIds.add(newContact.AccountId);
        }
        System.assertEquals(3, newAccountIds.size());
        
    }
}