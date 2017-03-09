/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DispatcherForEditContactControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
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
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
       
        Contact contact = new Contact(); 
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        contact.Street_P__c = addr.Id;
        contact.HierarchyAccount__c = acc.id;
        contact.KissPartyId__c = 'KAS.P2---4015110456';
        insert contact;
        
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kundeChildAccount.Anlaeg_No__c = '45345354';
        insert kundeChildAccount;
        
        Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3');
        insert role3;                                           
               KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role3.Id);
        insert rule3;
        
        
      
		Test.startTest();
        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = contact.Id,                                       
                                        Role__c = role3.Id); 
        
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr; 
		Test.stopTest();
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u; 
        System.runAs(u){
        ApexPages.StandardController sc = new ApexPages.Standardcontroller(contact);
        DispatcherForEditContactController dec = new DispatcherForEditContactController(sc);
        dec.getContactId();
        dec.redirectEditPage();
        }
        
    }
}