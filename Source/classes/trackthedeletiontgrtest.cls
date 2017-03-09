@isTest(SeeAllData=true)
public class trackthedeletiontgrtest {
static testMethod void trackthedeletionTestClass()
{
 // test.startTest();
    // address    
    Address__c addr  = new Address__c();
    addr.Town__c = 'AH';
    addr.Postcode__c = '421002';
    addr.Door_No__c = '301';
    addr.Floor__c = 'Third';
    addr.House_No__c = 'testData';
    addr.Street__c = 'AH';
    addr.Entrance__c = 'A';
    insert addr;
    system.debug('address list************'+addr);
    
    // account
    Account acc = new Account();
    acc.Name = 'TestHierarchy';
    acc.Type='Hierarki';
    acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
    acc.Street_YK__c = addr.Id;
    acc.Street_YK__r = addr;
    System.debug(' Address----- '+acc.Street_YK__r);
    insert acc;
    system.debug('account 1 list************'+acc);
    
    //cable unit 
    Cable_Unit__c cableUnitTest = new Cable_Unit__c();
    cableUnitTest.Name = 'cu_kundeCust_testing'; 
    cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
    cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
    cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
    cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
    cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
    cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
    insert cableUnitTest;
    
    //kundechild account
    RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
 /*   Account kundeChildAccount = new Account();
    kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
    kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
    kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
    kundeChildAccount.ParentId = acc.Id;
    insert kundeChildAccount;*/
    
    //contact
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
    contact.UserProfile__c ='';
    insert contact;
    
   
    ID roleId1 = [Select Id from Lookup_Contact_Roles__c where Name = 'Selvbetjeningsadministrator' limit 1].Id;
    Account_Contact_Role__c acr = new Account_Contact_Role__c(Customer__c = acc.Id,Contact__c = contact.Id,Role__c = roleId1); 		
    acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
    insert acr;
   
    
    delete acr;
//  test.stopTest();
}
}