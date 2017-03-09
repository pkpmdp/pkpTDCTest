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

@isTest(SeeAllData = true)
private class SC_ValidateProfileSCTestClass{
    
    public static Cable_Unit__c cu;
    public static Account account;
    public static Account account1;
    private static void init(){
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
        cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        //cu.cableUnit_Name__c = 'ViewAddressesForInstallationsCU';
        cu.Status__c = '0';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cu;
        
        account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert account;
        
        List<User> tempUser1 = new List<User>();
        List<Contact> tempContact1 = new List<Contact>();
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        //addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;

        Contact contact1 = new Contact();              
        contact1.FirstName='MTest';       
        contact1.LastName='MTest';       
        contact1.email='Test@MTest.com';       
        contact1.MobilePhone='12234556';       
        contact1.HomePhone='23455689';        
        contact1.Phone='2354456';        
        contact1.Street_P__c = addr1.Id;  
        contact1.HierarchyAccount__c = account.id;    
        insert contact1; 
        
        tempContact1.add(contact1);
        
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal User%'];                
        Database.DMLOptions dmo = new Database.DMLOptions();        
        dmo.EmailHeader.triggerUserEmail = true;        
        
        User user = new User();        
        String paswd = 'temp';       
        user = new User(alias = 'standt', email='MTest@atest.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId = contact1.Id,timezonesidkey='America/Los_Angeles', CommunityNickname = 'test.test', username='testClassUser@test.com',MID__c = 'M87654',IsActive = true);                    
        user.setOptions(dmo);        
        insert user;
        tempUser1.add(user);
        
        SC_ValidateProfile controller = new SC_ValidateProfile();
        controller.validateProfileforContact(tempContact1);
        controller.ValidateProfileforUser(tempUser1);
        
        
    }
    
    @isTest(SeeAllData = true)
    public static void testInstallations(){
    	Test.startTest();
        init();
        SC_ValidateProfile controller = new SC_ValidateProfile();
        Test.stopTest();
        }
    
    
}