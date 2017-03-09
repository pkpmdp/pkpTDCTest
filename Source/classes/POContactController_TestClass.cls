@istest(SeeAllData=true)
class POContactController_TestClass {
  public static testMethod void testmethod1() {
         Address__c addr = getNewAddresses();        
         Account account = getNewAccount(addr);
  
         // Begin Tests
        Test.startTest();
        Contact contact = getNewContact(addr, account); 
        ApexPages.StandardController stdController = new ApexPages.StandardController(contact);
        POContactPermissionELQController pcf= new  POContactPermissionELQController(stdController);
        System.assertNotEquals(false, pcf.isUnknownAddress);
       
        pcf.permission = true;
        pcf.updatePermission();
        Test.stopTest();
    }
    
    static Address__c getNewAddresses(){
            Address__c addr  = new Address__c();      
            addr.Town__c = 'AH';        
            addr.Postcode__c = '421002';        
            addr.Door_No__c = '301';        
            addr.Side__c = 'A';        
            addr.Floor__c = 'Third';        
            addr.House_No__c = 'testData';        
            addr.Street__c = 'Ukendt adresse';        
            addr.Entrance__c = 'A';        
            insert addr;
            return  addr;
    }
    static Account getNewAccount(Address__c addr){
            Account account = new Account();        
            account.Name ='test12';        
            account.Phone = '223223';        
            account.Email__c = 'abc@xyz.com';
            account.Street_YK__c = addr.Id;         
            account.Street_YK__r = addr;
         //   account.Cable_Unit__c = getNewCableUnit().Id;  
         //   account.Customer_Segment_Lookup__c =  getCustomerSegment().Id;
            account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
            insert account;
            return account;
    }
    static Contact getNewContact(Address__c addr, Account acc){
           Contact contact = new Contact(); 
           contact.FirstName = 'TestContactFirstname';
           contact.LastName = 'TestContactLastname';
           contact.Email = 'test.TestClase@test1.com';
           contact.Phone = '2222221';
           contact.MobilePhone = '3333331';
           contact.HomePhone = '4444441';
           contact.HierarchyAccount__c = acc.id;
           contact.Street_P__c = addr.Id;
           contact.KissPartyId__c = 'KAS.P2---4015110456';
           contact.Permission__c = true;
           insert contact;
           
           contact con1 = [Select Id, Name, Permission__c, Address_merge_field__c FROM Contact WHERE Id =: contact.Id];
           System.debug('######con1 details'+con1);
           return contact;
    }

}