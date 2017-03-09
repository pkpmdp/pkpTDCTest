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
private class ViewPortalUserControllerTest {

            
   static testMethod void initData(){
            
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        
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
        
       
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
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
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
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
       /*
       
        KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde');
        insert rule3;
        
        Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3');
        insert role3;                                           
      

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = contact.Id,                                       
                                        Role__c = role3.Id); 
        
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;
       
       */
       /*
       Lookup_Contact_Roles__c role3 = new Lookup_Contact_Roles__c();
        role3 = 
                new Lookup_Contact_Roles__c(Name = 'Selvbetjeningsbruger', Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                            Code__c = 'Rolle3');
        insert role3;
        KISS_Role_Validation_Rules__c rule3;
        rule3 = 
                new KISS_Role_Validation_Rules__c( Name = 'Selvbetjeningsbruger',
                                                   Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role3.Id);
        insert rule3;
        
                                                   
      

        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = kundeChildAccount.Id, 
                                        Contact__c = contact.Id,                                       
                                        Role__c = role3.Id); 
        
        acr.ContactRoleExternalID__c = acr + 'Fake-Id';  
        insert acr;*/
        
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
        Id accountId = acc.id;
        
        Id contactId;
        Apexpages.currentpage().getparameters().put('contactId',contact.id);
        ViewPortalUserController viewPortalUserObj = new ViewPortalUserController(); 

        //viewPortalUserObj.contactId=contact.Id;
        viewPortalUserObj.getContact();
        viewPortalUserObj.setContact(contact);
        viewPortalUserObj.getAccID();
        viewPortalUserObj.setAccID(accountId);
        viewPortalUserObj.setcurrentId(accountId);
        viewPortalUserObj.getAccounts();
        viewPortalUserObj.cancel();
        viewPortalUserObj.backToManagePortalUserPage();
                System.debug(' Before Object Structure ');
         objectStrListtemp = viewPortalUserObj.getObjectStructure();
        // System.debug(' ObjectList Size '+ objectStrListtemp.size());
      /* for(cObjectStructureMap cc : objectStrListtemp){
        System.debug(' Inside for ');
        cc.selected = true;
         objectStrList.add(cc);
       }
        viewPortalUserObj.objectStrList = objectStrList;
        
        */
        Test.startTest();
        viewPortalUserObj.getAssignedCableUnits();
        viewPortalUserObj.getAllRelatedCableUnits();
        viewPortalUserObj.GetTopElement(accountId);
        Test.stopTest();
        /*viewPortalUserObj.tempTestFlag = true;
        viewPortalUserObj.getStreetForAccount(accountId,contact);*/

     //   viewPortalUserObj.save();
    //    viewPortalUserObj.setcurrentId(accountId);
        //viewPortalUserObj.getStreetForAccount(accountId, contact);
        //viewPortalUserObj.setlevelFlag(nodeElements, nodeType);       
        //viewPortalUserObj.setcloseFlag(cnl, nnl, nodeType);                     
     //   viewPortalUserObj.getAccounts();
     //   viewPortalUserObj.cancel();
        
        }
    
    } 
    Static testMethod void negativeTest(){
        ViewPortalUserController viewPortalUserObj = new ViewPortalUserController(); 
        Id currentId='01pM00000000V4b';
        viewPortalUserObj.formatObjectStructure(currentId);
   //   String newPageUrl = '';
   //   PageReference back = new PageReference(newPageUrl);
        viewPortalUserObj.getAccounts();
        viewPortalUserObj.cancel();
        viewPortalUserObj.backToManagePortalUserPage();
        ApexPages.CurrentPage().getParameters().put('contactId','');
        viewPortalUserObj.getAssignedCableUnits();
        viewPortalUserObj.tempTestFlag = true;
        viewPortalUserObj.getAccountId();
        viewPortalUserObj.setContactDetails();
        viewPortalUserObj.getAllRelatedCableUnits();
        viewPortalUserObj.getAccounts();
        viewPortalUserObj.getObjectStructure();
        List<String> tempList1 = new List<String> {'1','2'};
        List<String> tempList2 = new List<String> {'1','2'};
        String tempStr = 'temp';
        viewPortalUserObj.setlevelFlag(tempList1, tempStr);
        viewPortalUserObj.setcloseFlag(tempList1, tempList2, tempStr);
        
    }
}