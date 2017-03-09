@isTest

private class DealerCreationControllerTestClass
{
    static Pagereference pr;
    static ApexPages.StandardController sc;
    static DealerCreationController objController;
    static Account acc;
   
    static {
         createTestData();
         sc = new ApexPages.StandardController(acc); 
         objController = new DealerCreationController(sc);  
          
         objController.addAmbassador();
         objController.addmanager();  
    }
    
    static testmethod void pageGetActions()
    {
        
        objController.getDealerProductsItems();
        objController.getDealerGroupItems();
        objController.getDealerCategoryItems();
        objController.getSalesConsultantItems();
    }
    
    static testmethod void pageActionsTest()
    {
        objController.cancel();
        
        //Save without Dealer Group
        objController.setManagercontact(new Contact(LastName='testMgr',Email='testMgr@mail.com',Phone='123'));
        objController.getManagercontact();
        Contact c = objController.contactList[0];
        c.AccountId=acc.Id;
        c.Address_Id__c='mumbai';
        c.LastName = 'testAbr7';
        c.Email = 'testAbr78@mail.com';
        c.Phone = '4567';
      
        //DealerCreationController.contactList = lc;
        List<Contact> lc = objController.contactFinalList;
        //contactFinalList.add(c);
        objController.save();
        
        //Save with Dealer Group
        acc.DealerGroup__c='Fona';
        objController.save();
                
       
    }
    
    static testmethod void pageActionsTest1()
    {
        //objController.cancel();
        
        //Save without Dealer Group
        objController.setManagercontact(new Contact(LastName='',Email='',Phone=''));
        objController.getManagercontact();
        Contact c = objController.contactList[0];
        c.AccountId=acc.Id;
        c.Address_Id__c='mumbaii';
        c.LastName = 'testAbr78';
        c.Email = 'testAbr789@mail.com';
        c.Phone = '45678';
      
       
        objController.save();
                
       
    }
    
    static void createTestData()
    {
        // create test account
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        
        acc = new Account(Name='testDealer',DealerProducts__c='Digitalt kabel-tv;YouSee Telefoni',DealerGroup__c='none',recordTypeId=rt.id,Phone='123',Email__c='test@mail.com');
       
        // create test dealer products
        LookupMaster__c dp1 = new LookupMaster__c(Name='Digitalt kabel-tv',RecordType__C='Dealer Products',Order_sequence__c=1);
        LookupMaster__c dp2 = new LookupMaster__c(Name='YouSee Telefoni',RecordType__C='Dealer Products',Order_sequence__c=2);
        insert dp1;
        insert dp2;
        
        // create test dealer group items
        LookupMaster__c dg1 = new LookupMaster__c(Name='Fona',RecordType__C='Dealer Group',Order_sequence__c=1);
        LookupMaster__c dg2 = new LookupMaster__c(Name='Expert',RecordType__C='Dealer Group',Order_sequence__c=2);
        insert dg1;
        insert dg2;
        
        // create dealer category items
        LookupMaster__c dc1 = new LookupMaster__c(Name='A',RecordType__C='Dealer Kategori',Order_sequence__c=1);
        LookupMaster__c dc2 = new LookupMaster__c(Name='B',RecordType__C='Dealer Kategori',Order_sequence__c=2);
        insert dc1;
        insert dc2;
        
        // create sales consultant items
        LookupMaster__c sc1 = new LookupMaster__c(Name='ATO',RecordType__C='Sales Consultants');
        LookupMaster__c sc2 = new LookupMaster__c(Name='CPI',RecordType__C='Sales Consultants');
        insert sc1;
        insert sc2;
        
    }
}