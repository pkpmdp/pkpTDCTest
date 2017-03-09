@isTest(SeeAllData=true)
public class clsCasesUtilTest{

    public static testMethod void testLinkCaseToCustomer(){
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
         RecordType recordType2 = [Select Id From RecordType Where Name = 'Blockbuster Customer Account'];
          //New Address;
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        System.debug('Adrees inserted ' + addr.Id);    
             // insert a new customer
            
            
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
        //acc.Email__c='tejas@test.com';
        //acc.RecordTypeName__c=recordType2.Id;
        //acc.PersonEmail='tejas@test.com';
        acc.Brands__c='Blockbuster';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        System.debug('Acc inserted ' + acc.Id);
        
       Contact contactTest4 = new Contact(); 
       contactTest4.FirstName = 'TestContactFN';
       contactTest4.LastName = 'TestContactLN';
       contactTest4.Email = 'tejas@test.com';
       contactTest4.Phone = '2222221';
       contactTest4.MobilePhone = '3333331';
       contactTest4.HomePhone = '4444441';
       contactTest4.HierarchyAccount__c = acc.id;
       contactTest4.Street_P__c = addr.Id;
       contactTest4.KissPartyId__c = 'KAS.P2---4015113456';
       contactTest4.Status__c = 'Aktv';
       contactTest4.Enable_Customer_Portal_User__c = false;
       contactTest4.accountId = acc.Id;
       insert contactTest4;
        
        
        // Create case record
        Case c = new Case();
        c.Customer_Number__c = acc.Customer_No__c;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Department__c = 'Blockbuster';
        c.Product_2__c = 'Betaling';
        c.Type_Task__c = 'Support';
        c.Email__c='tejas@test.com';
        //c.Anlaeg_No_New__c='1234';
        c.RecordTypeId = recordType.Id;
        insert c;
        System.debug('Case inserted ' + c.Id);
        
        c = [Select Id, AccountId, Customer_Number__c From Case Where Id = :c.Id];
        System.assertEquals(acc.Id, c.AccountId);
        System.debug('cCAseaccount id id '+c.AccountId + 'Account id'  +acc.Id );
        c.AccountId=null;
        c.Product_2__c = 'Andet';
        c.Email__c='tejas2@test.com';
        update c;
   }
   
   public static testMethod void testLinkCaseToCustomer2(){
       
       Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        System.debug('Adrees inserted ' + addr.Id);
        
        Account acc = new Account();
        acc.YouSee_Business_Area__c='YS';
        acc.Anlaeg_No__c='1234';
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
        //acc.Email__c='tejas@test.com';
        //acc.RecordTypeName__c=recordType2.Id;
        //acc.PersonEmail='tejas@test.com';
        acc.Brands__c='Blockbuster';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        System.debug('Acc inserted ' + acc.Id);
        
        Case c = new Case();
        
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Department__c = 'Blockbuster';
        c.Product_2__c = 'Betaling';
        c.Type_Task__c = 'Support';
        c.Email__c='tejas@test.com';
        c.Anlaeg_No_New__c='1234';
        
        insert c;
        
        Case updatecase =[Select Id, AccountId, Customer_Number__c,Anlaeg_No_New__c,Email__c  From Case Where Id = :c.Id];
        updatecase.Anlaeg_No_New__c ='12345';        
        update updatecase;
        
        updatecase.Email__c='xyz123@test.com';
        update updatecase;
        
        updatecase.Customer_Number__c = null;
        update updatecase;
   }
   // SPOC- 1939 Test classes issue
   public static testMethod void testclsCasesReassign()
   {
   		Case c = new Case();
        
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Department__c = 'Blockbuster';
        c.Product_2__c = 'Betaling';
        c.Type_Task__c = 'Support';
        c.Email__c='tejas@test.com';
        c.Anlaeg_No_New__c='1234';
        
        insert c;
        List<Case> listCase = new List<Case>();
        listCase.add(c);
   		clsCasesReassign clsa = new clsCasesReassign();
   		clsa.reassignCases(listCase,true);
   		
   }
}