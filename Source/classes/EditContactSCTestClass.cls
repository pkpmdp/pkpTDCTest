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
private class EditContactSCTestClass {
    
    
    static testMethod void myUnitTest() {
       ID fetchedId;
       string eFlag;
       ID fetchedAccountId;
       ID[] assignedItems;
       Account_Contact_Role__c acrContact;
       Contact c;
    
       ApexPages.CurrentPage().getParameters().put('emailUnique','true');
       ApexPages.CurrentPage().getParameters().put('historyLogCheck','true');
       ApexPages.CurrentPage().getParameters().put('contactFreeFlyingLogCheck','true');
       
       EditContactController editCon = new EditContactController(); 
       editCon.getFetchedId();
       editCon.setFetchedId(fetchedId);
       editCon.getEmailFlag();
       editCon.setEmailFlag(eFlag);
       editCon.getFetchedAccountId();
       editCon.setFetchedAccountId(fetchedAccountId);
       editCon.getRoleSelected();
       editCon.getRoleSelectedId();
       editCon.getAccountId();
       editCon.getAssignedItems();
       editCon.setAssignedItems(assignedItems);
       editCon.getContact();
       editCon.setContact(c);
       editCon.getAcrContact();
       editCon.setAcrContact(acrContact);
       editCon.getfilteredContacts();
       
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
       acc.Name = 'testData';
       acc.Street_YK__c = addr.Id;
       acc.Phone = '223223';
       acc.Email__c = 'abc@abc.com';
       acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
       //acc.Customer_Segment_Lookup__c=customerSegment.Id;
       insert acc;
       
       Contact contact = new Contact();
       contact.FirstName = 'FTest';
       contact.LastName = 'LTest';
       contact.Email = 'FTest@Ltest.com';
       contact.MobilePhone = '9823242526';
       contact.HomePhone = '154552';
       contact.Phone = '1234567890';
       contact.Street_P__c = addr.id;        
       contact.Street_S__c = addr.id;
       contact.Status__c = 'Aktiv';
       contact.AlternateEmail__c = 'FL@test.com';
       contact.AccountId = acc.id;
       insert contact;
       Apexpages.currentpage().getparameters().put('contactId',contact.id);
    }
    
    static testmethod void positiveTest(){
        
	   
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
     //   RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
     
	     Account acc = new Account();
	     acc.Name = 'TestHierarchy';
	     //acc.Customer_Segment_Lookup__c=customerSegment.Id;
	     acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
	     acc.Street_YK__c = addr.Id;
	     acc.Street_YK__r = addr;
	     acc.Type = 'Hierarki';
	     System.debug(' Address----- '+acc.Street_YK__r);
	     insert acc;
         
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
       insert contact;
           
       Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like 'ServiceCenter Portal Administrator'];        
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
       

       Contact conContactRoles = new Contact(); 
       conContactRoles.FirstName = 'TestContactFirstname';
       conContactRoles.LastName = 'TestContactLastname';
       conContactRoles.Email = 'testcontactroles.TestClas@test1.com';
       conContactRoles.Phone = '2222221';
       conContactRoles.MobilePhone = '3333331';
       conContactRoles.HomePhone = '4444441';
       conContactRoles.HierarchyAccount__c = acc.id;
       conContactRoles.Street_P__c = addr.Id;
       conContactRoles.KissPartyId__c = 'KAS.P2---4015770456';
       conContactRoles.Status__c = 'Active';
       insert conContactRoles;
       
       Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3',Visible_in_Service_Centre__c = true);
        insert role3;
       List<Id> assignedRoles = new List<Id>();
                KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Hierarki', Contact_Roles__c = role3.Id);
        insert rule3;
        
        

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = acc.Id, 
                                        Contact__c = conContactRoles.Id,                                       
                                        Role__c = role3.Id); 
        
            System.runAs(u){
               // contactConstClass cs = new contactConstClass();
                //contactConstClass.ACCOUNTID = acc.Id;
                //contactConstClass.CONTACTID = conContactRoles.Id;
                ApexPages.CurrentPage().getParameters().put(contactConstClass.ACCOUNTID,acc.Id);
                ApexPages.CurrentPage().getParameters().put(contactConstClass.CONTACTID,conContactRoles.Id);
                ApexPages.CurrentPage().getParameters().put('cableunitnumber','');
                EditContactController ecc = new EditContactController();
                conContactRoles.Email = 'test@test.com';
                ecc.contact = conContactRoles;
            	ecc.tempTestFlag = false;
                ecc.getSelectedItems();
                ecc.setContactDetails(conContactRoles.Id);
                ecc.saveContacts();
                ecc.getAvailableRoles();
                ecc.getItems();
                ecc.getNewItems();
                ecc.cancel();
                ecc.toViewContactPage();
                ecc.tempTestFlag = false;
                ecc.getSelectedItems();
            }   
    }
    
    static testmethod void negativeTest(){
         Cable_Unit__c cableUnit = new Cable_Unit__c();  
     cableUnit.Name = 'cu_kundeCust_testing';
     cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
     cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
     cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
     cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
     cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
     cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
     cableUnit.Cable_Unit_No__c = '123456789';
     insert cableUnit;  
        
        
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
     //   RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
     
         Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
         //acc.Customer_Segment_Lookup__c=customerSegment.Id;
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
        acc.Customer_No__c = '123456789';
        acc.Cable_Unit__c = cableUnit.Id;
         //acc.Type = 'Hierarki';
         System.debug(' Address----- '+acc.Street_YK__r);
         insert acc;
         
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
       insert contact;
           
       Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like 'ServiceCenter Portal Administrator'];        
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
       

       Contact conContactRoles = new Contact(); 
       conContactRoles.FirstName = 'TestContactFirstname';
       conContactRoles.LastName = 'TestContactLastname';
       conContactRoles.Email = 'testcontactroles.TestClas@test1.com';
       conContactRoles.Phone = '2222221';
       conContactRoles.MobilePhone = '3333331';
       conContactRoles.HomePhone = '4444441';
       conContactRoles.HierarchyAccount__c = acc.id;
       conContactRoles.Street_P__c = addr.Id;
       conContactRoles.KissPartyId__c = 'KAS.P2---4015770456';
       conContactRoles.Status__c = 'Active';
       insert conContactRoles;
       
       Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3',Visible_in_Service_Centre__c = true);
        insert role3;
       List<Id> assignedRoles = new List<Id>();
                KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Hierarki', Contact_Roles__c = role3.Id);
        insert rule3;
        
        

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = acc.Id, 
                                        Contact__c = conContactRoles.Id,                                       
                                        Role__c = role3.Id); 
       
            System.runAs(u){
                ApexPages.CurrentPage().getParameters().put('accountId',acc.Id);
                ApexPages.CurrentPage().getParameters().put(contactConstClass.CONTACTID,conContactRoles.Id);
                ApexPages.CurrentPage().getParameters().put('cableunitnumber','123456789');
                ApexPages.CurrentPage().getParameters().put('emailUnique','test@test.com');
                ApexPages.CurrentPage().getParameters().put('contactFreeFlyingLogCheck','test');
                EditContactController ecc = new EditContactController();
                List<Id> roleIds = new List<Id>();
                ecc.tempTestFlag = true;
                ecc.getSelectedItems();
                ecc.getAvailableRoles();
                ecc.getItems();
                ecc.getNewItems();
                ecc.cancelSaveContacts();
                ecc.saveContactsPage();
                ecc.getRoleSelId();
                ecc.setRoleSelId(roleIds);
                ecc.cableUnitName = '';
                ecc.emailChk = '';
                ecc.displayAddressInfo = false;
                ecc.address = new Address__c();
                ecc.errorFlag = false;
                 ecc.successFlag = false;
                 ecc.warningFlag = false;
                 ecc.chkFlag= false;
                 ecc.isContactVisible= false;
                 ecc.isRoleFlag= false;
                ecc.setRoleSelected('test');
                ecc.setRoleSelectedId('test');
                ecc.setAccountId('test');
                ecc.availableItems = new List<String>{'test'};
                ecc.debugCode();
                ecc.fetchAddressDetails();
                ecc.selectedRoleIds = 'test';
                ecc.selectedRoleValues = 'test';
                
            }   
    }
    
}