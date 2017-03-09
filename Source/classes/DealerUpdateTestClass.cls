@isTest
private class DealerUpdateTestClass
{
    static Pagereference pr;
    static ApexPages.StandardController sc;
    static DealerUpdateController objController;
    static Account acc;
    static Contact c;

    static {
            
         System.debug('Surve upside');
         createTestData();
         System.debug('Surve downside');
         pr = Page.EditCustPage;
         pr.getparameters().put('accountId',acc.Id);
         Test.setcurrentPage(pr);
         sc = new ApexPages.StandardController(acc); 
         objController = new DealerUpdateController(sc);  
          
         //objController.addAmbassador();
         //objController.addmanager();  
    }
    
    static testmethod void pageGetActions()
    {
        System.debug('objController'+objController);
        Contact tempc =objController.ViewManager;
        List<Contact> lc = objController.ViewAmbassadorList;
        List<Contact> cfl = objController.contactFinalList;
        objController.getDealerProductsItems();
        objController.getDealerGroupItems();
        objController.getDealerCategoryItems();
        objController.getSalesConsultantItems();
    }
    
    static testmethod void pageActionsTest()
    {   
        objController.cancel();
        //Save without Dealer Group
        objController.contactFinalList = new List<Contact>{c};
        List<Contact> lc = objController.contactFinalList;
        lc[0].LastName = 'testAbr';
        lc[0].Email = 'testAbr@mail.com';
        lc[0].Phone = '456';
        objController.save();
        
        objController.addAmbassador();
        objController.addManager();
    }
    
    static void createTestData()
    {
        
        Address__c addr = new Address__c();
        addr.Active__c= true;
        addr.District__c ='test';
        addr.Door_No__c ='123';
        addr.Entrance__c = 'ABC';
        addr.Floor__c = '4';
        addr.House_No__c ='34';
        addr.Name = 'Ram Chokkam';
        addr.Town__c = 'ABS';
        addr.Postcode__c = '4000076';
        
        insert addr;
        
        // create test account
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        acc = new Account();
        acc.Name ='test12';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
        
       
        c = [select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ c);
        
        
        //Lookup_Contact_Roles__c exiting = [Select Id from Lookup_Contact_Roles__c where Name = 'Kundeadministrator' ];
        
        /*
        Lookup_Contact_Roles__c lcr1 = new Lookup_Contact_Roles__c(Name='Dealer Mana',SourceId__c='2323jajajs', Code__c ='121243');
        insert lcr1;
        Lookup_Contact_Roles__c lcr2 = new Lookup_Contact_Roles__c(Name='Dealer Managr', SourceId__c='dsdsd999323', Code__c = '54455');
        insert lcr2;
        */
        // create test dealer products
        LookupMaster__c dp1 = new LookupMaster__c(Name='Digitalt kabel-tv',RecordType__C='Dealer Products',Order_sequence__c=1);
        LookupMaster__c dp2 = new LookupMaster__c(Name='YouSee Telefoni',RecordType__C='Dealer Products',Order_sequence__c=2);
        insert dp1;
        insert dp2;
        
     //   insert new Account_Contact_Role__c(Customer__c=acc.Id,Role__c=exiting.id,Contact__c=c.id);
        
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