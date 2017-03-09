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
private class ViewContactControllerSCTestClass {

    static testMethod void testViewContact() {
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
        
        	
			Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        	cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        	cableUnitTest.Name = 'cu_kundeCust_testing'; 
        	cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        	cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        	cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        	cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                     
        	cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        	insert cableUnitTest;
        	
            Account acc = new Account();
            acc.Name = 'testData';
            acc.Street_YK__c = addr.Id;
            acc.Phone = '223223';
            acc.Email__c = 'abc@abc.com';
            acc.Cable_Unit__c = cableUnitTest.Id;
        	acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
            insert acc;
            
            Contact contact = new Contact();
            contact.FirstName = 'FTest';
            contact.LastName = 'LTest';
            contact.Email = 'FTest@Ltest.com';
            contact.MobilePhone = '9823242526';
            contact.HomePhone = '154552';
            contact.Phone = '1234567890';
            contact.Street_P__c = addr.id;
            //contact.Street_P__r.Name = '';
            contact.Status__c = 'Aktiv';
            contact.AlternateEmail__c = 'FL@test.com';
            contact.AccountId = acc.id;
            insert contact;
            
            Account_Contact_Role__c acrContact= new Account_Contact_Role__c();
            /*acrContact.Contact__c = contact.id;
            acrContact.Customer__c = acc.id;
            acrContact.Role__c = 'a0yD0000000mHmTIAU';
            insert acrContact;*/
            
            Apexpages.currentpage().getparameters().put('accountId', acc.id);
            
            ApexPages.CurrentPage().getParameters().put('contactId',contact.Id);
            
            ApexPages.CurrentPage().getParameters().put('cableunitnumber', cableUnitTest.Cable_Unit_No__c);
            
            ViewContactController viewContObj = new ViewContactController();
            viewContObj.getAccountId();
            viewContObj.getContact();
            viewContObj.setContact(contact);
            viewContObj.getAcrContact();
            viewContObj.setAcrContact(acrContact);
            viewContObj.getItems();
            viewContObj.getSelectedItems();
            viewContObj.getChosenRoles();
            viewContObj.editContactTest();
            
            ApexPages.currentPage().getParameters().put('contactId','null');
            
            // To handle Exception
            
            viewContObj.getChosenRoles();
            viewContObj.getSelectedItems();
            viewContObj.cancel();
            ViewContactController viewContObj1 = new ViewContactController();
            apexpages.currentpage().getparameters().put(contactConstClass.ACCOUNTID, '');
            viewContObj.setContactDetails();
            apexpages.currentpage().getparameters().put(contactConstClass.CONTACTID, '');
            viewContObj.getSelectedItems();
    }
}