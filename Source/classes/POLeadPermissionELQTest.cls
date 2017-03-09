@isTest(SeeAllData = true)
public class POLeadPermissionELQTest{
    public static testMethod void testPOLeadPermissionELQ(){
        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Address__c add = setupDummyAddress();
        Lead lead = new Lead();
        lead.Anlaeg_No__c = acc.Cable_Unit__r.Cable_Unit_No__c;
        lead.Anlaeg_Name__c =  acc.Cable_Unit__r.Name;
        lead.Title = 'Guest';
        lead.FirstName = 'Me';
        lead.LastName = 'N Marley';
        lead.Street_Lookup__c = add.id;
        lead.Email= 'test123@gmail.com';
        lead.RecordTypeId = '012200000000nza';
        insert lead;
        System.debug('Lead Street ==>' + lead.Street_Lookup__r.Street__c);
        System.debug('Address ==>'+add);
        System.debug('Lead ==> '+ lead);
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(lead);
        POLeadPermissionELQController con = new POLeadPermissionELQController(stdController);
        System.assertNotEquals(true, con.isUnknownAddress );
        
        con.permission = true;
        con.updatePermission(); 
        Test.stopTest();    
    }
    
    private static Address__c setupDummyAddress(){
    Address__c address = new Address__c();
       address.Street__c = 'Stradellasvej';
       address.External_Id__c ='66666666';
       address.Entrance__c = '';
       address.House_No__c = '80';
       address.Floor__c = '2';
       address.Postcode__c = '';
       address.Town__c = 'paris'; 
       address.Door_No__c = '';
       address.OclearAddress__c = 'Yes';
       address.Isubscription__c = 'No';
       insert address;
       
       return address;
    }
}