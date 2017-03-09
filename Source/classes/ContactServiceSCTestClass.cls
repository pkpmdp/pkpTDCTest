/* Test Class for Contacts Section. this test class includes Manage Contact, Create Contact, Edit Contact and Delete Contacts. 
It also includes the mailing functionality.*/

@isTest
private class ContactServiceSCTestClass{ 
        
      static ID[] rolesAssigned;
      static String roleNames; 
       
   static testMethod void createContactTest(){
        String selectedRole = 'abc';
        List<Account> lstAcc = new List<Account>();
        
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
        insert acc;
        lstAcc.add(acc);
        
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
        
        Lookup_Contact_Roles__c role1 = new Lookup_Contact_Roles__c();
        role1.Name = 'testRole';
        role1.Visible_in_Service_Centre__c = true;
        //role1.Active = 'Ja';
        insert role1;
        
        List<Lookup_Contact_Roles__c> lcrRoles = new List<Lookup_Contact_Roles__c>();
        lcrRoles.add(role1);
        
        Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        cu.Status__c = '0';
        cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cu;
        
        Apexpages.currentpage().getparameters().put('contactId',contact.id);
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User(alias = 'standt', email='abc@test.com',title='kunderådgiver',
        emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
        timezonesidkey='America/Los_Angeles', username='PoojaChawla@test.com',MID__c = 'M91294');        
        u.setOptions(dmo);
        insert u;
            
        ContactService csold = new ContactService();
        csold.getAllRoles();
        csold.deleteContact(contact.id,contact.AccountId,cu.Cable_Unit_No__c, role1.Name );    
        contact.FirstName=ServiceCenterTestUtil.getRandomName();
        contact.LastName=ServiceCenterTestUtil.getRandomName();
        contact.email=ServiceCenterTestUtil.getRandomEmail();
        contact.Phone=ServiceCenterTestUtil.getRandomAlphaNumeric();
        contact.Street_P__c = addr.id;
        rolesAssigned = ServiceCenterTestUtil.getRandomRoles(); // Roles are randomly picked
        roleNames = ServiceCenterTestUtil.getRandomRolesName(); 
        
        Contact Ncontact = new Contact();
        Ncontact.FirstName = 'FTest';
        Ncontact.LastName = 'LTest';
        Ncontact.Email = 'FTest123@Ltest.com';
        Ncontact.MobilePhone = '9823242526';
        Ncontact.HomePhone = '154552';
        Ncontact.Phone = '1234567890';
        Ncontact.Street_P__c = addr.id;        
        Ncontact.Street_S__c = addr.id;
        Ncontact.Status__c = 'Aktiv';
        Ncontact.AlternateEmail__c = 'FL@test.com';
        //Ncontact.AccountId = acc.id;
        Ncontact.RecordTypeId = YSRecordTypes__c.getInstance('YSRecordTypes').YS_Contact_Record_Type__c;
        insert Ncontact; 
        csold.deleteContact(Ncontact.id,Ncontact.AccountId,cu.Cable_Unit_No__c, role1.Name);
        }
        
  static testMethod void getLoginInDetails(){
      	Integer levwl = 0;
      	List<Account> lstAcc1 = new List<Account>();
      	List<Contact> lstContact = new List<Contact>();
      	
      	Address__c addr1  = new Address__c();
        addr1.Town__c = 'AH';
        addr1.Postcode__c = '421002';
        addr1.Door_No__c = '301';
        //addr1.Side__c = 'A';
        addr1.Floor__c = 'Third';
        addr1.House_No__c = 'testData';
        addr1.Street__c = 'AH';
        addr1.Entrance__c = 'A';
        insert addr1;        
        
        Account acc1 = new Account();
        acc1.Name = 'testData';
        acc1.Street_YK__c = addr1.Id;
        acc1.Phone = '223223';
        acc1.Email__c = 'abc@abc.com';
        acc1.Type = 'Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc1;
        lstAcc1.add(acc1);
        
        Contact contact1 = new Contact();
        contact1.FirstName = 'FTest';
        contact1.LastName = 'LTest';
        contact1.Email = 'FTest@Ltest.com';
        contact1.MobilePhone = '9823242526';
        contact1.HomePhone = '154552';
        contact1.Phone = '1234567890';
        contact1.Street_P__c = addr1.id;        
        contact1.Street_S__c = addr1.id;
        contact1.Status__c = 'Aktiv';
        contact1.AlternateEmail__c = 'FL@test.com';
        contact1.HierarchyAccount__c = acc1.Id;
        contact1.RecordTypeId = YSRecordTypes__c.getInstance('YSRecordTypes').YS_Contact_Record_Type__c;
        insert contact1;
        lstContact.add(contact1);
      
      	Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
      	Database.DMLOptions dmo = new Database.DMLOptions();
      	dmo.EmailHeader.triggerUserEmail = true;
      	User u = new User(alias = 'standt', email='abc1@test.com',title='kunderådgiver',
      	emailencodingkey='UTF-8', lastname='Chawla1', languagelocalekey='en_US',
      	localesidkey='en_US', profileid = profiles[0].Id, contactId = contact1.Id,
      	timezonesidkey='America/Los_Angeles', username='PoojaChawla1@test.com',MID__c = 'M97845');        
      	u.setOptions(dmo);
      	insert u;
    	System.runAs(u){
        	Test.startTest();
        	ContactService cs = new ContactService();
        	cs.getAllRelatedAccounts();
        	// This methosd
        	//cs.refineContacts(lstContact);
        	Test.stopTest();   
         }   
  }       
}