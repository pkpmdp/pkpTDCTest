@isTest(SeeAllData=true)
public class afterorderinserttest {
static testMethod void CaseTestClass()
 {
       Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
     system.debug('address list*************'+addr);
     
   //   List<Account> testApp = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
   system.debug('account list****************'+acc);
     insert acc;
     
           
     
  /*  // contact
      Contact c = new Contact();
        c.FirstName = 'Bob';
        c.LastName = 'Smith';
        c.HomePhone = '123';
        c.Email = 'abcdddddd@test.com';
        c.Street_P__c = addr.Id;
        c.Id = '1245464';
        insert c;*/
   /*  User u = new User();
        
        u.FirstName = acc.FirstName;
        u.LastName = acc.LastName;
        
        u.Alias = acc.FirstName.substring(0,1) + acc.LastName.substring(0,3);
        u.ContactId = c.Id;
   /*     u.Email = acc.PersonEmail;
        u.Username = acc.PersonEmail;
        u.CommunityNickname = acc.PersonEmail;
     //   u.ProfileId  =p.Id;  
    //    u.CPQ_Username__c = acc.PersonEmail;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
     
     insert u;*/
     
     // cable unit
     Cable_Unit__c cu = new Cable_Unit__c();
     cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cu.Name = 'cu_kundeCust_testing'; 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                     
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cu.Cable_Unit_No__c = '0000000435';
     
     insert cu;
     
     // net installation
     Net_Installations__c ni = new Net_Installations__c();
 //    ni.Id = cu.Id;
     ni.Cable_Unit__c = cu.Id;
  //   ni.Name ='7291492';
     insert ni;
     system.debug('ni details******'+ni);    
     
      Order__c o = new Order__c();
           //o.Net_Installation__c = '549890';
           o.Order_type__c = 'Downgrade';
           o.Kasia_Order_Status__c = 'Pending';
           o.cableUnitName__c = 'SKOTTEPARKEN MATR.8 C';
           o.cableUnitNumber__c = '0000007574';
           o.ChangePackageDate__c = '01-06-2012';
           o.Installation_No__c = '1';
           o.Product_Name__c = 'Grundpakke';
     o.loggedInUserName__c='sneha s';
     o.packageBeforeChange__c='Fuldpakke';
     o.Location__c='denmark';
     o.OrderGroupId__c='04-11-2012-30715';
     o.nybeboreAvailable__c='Omk. gratis';
     o.Address_Id__c='136548';
     o.Net_Installation__c = ni.Id;
     
     
         system.debug('order list****************'+o);
   
        insert o;
     update o;
    
         
         Order__c o1 = new Order__c();
           //o1.Net_Installation__c = ;
               
           o1.Order_type__c = 'Cancellation';
           o1.Kasia_Order_Status__c = 'Pending';
           o1.cableUnitName__c = 'Bryggenet';
           o1.cableUnitNumber__c = '0000001234';
           o1.ChangePackageDate__c = '01-06-2014';
           o1.Installation_No__c = '1';
           o1.Product_Name__c = 'Mellempakke';
          o1.loggedInUserName__c='sneha';
     o1.nybeboreAvailable__c='Omk. sales';
     
         system.debug('order list****************'+o1);
   
        insert o1;
     
 }
}