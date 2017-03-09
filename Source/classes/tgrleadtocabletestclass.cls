@isTest(SeeAllData=true)
public class tgrleadtocabletestclass {
static testMethod void LeadtoCableTestClass()
{
    test.startTest();
 
    RecordType recordtype = new RecordType();
    recordtype = [select Id,Name from RecordType where Name='YK Lead'];
    User uid = [SELECT id,name from User where Profile.name = 'API User Profile' and IsActive = true limit 1]; 
    
    Cable_Unit__c cableUnitTest = new Cable_Unit__c();
    cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
    cableUnitTest.Name = 'cu_kundeCust_testing1'; 
    cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
    cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
    cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                    
    cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
    cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
    cableUnitTest.Cable_Unit_No__c=String.valueOf(Crypto.getRandomInteger());
    insert cableUnitTest; 
    
	System.debug(' Address----- '+cableUnitTest.Cable_Unit_No__c);
    
    Address__c addr  = new Address__c();
    addr.Town__c = 'AH';
    addr.Postcode__c = '421002';
    addr.Door_No__c = '301';
    //addr.Side__c = 'A';
    addr.Floor__c = 'Third';
    addr.House_No__c = 'testData';
    addr.Street__c = 'AH';
    addr.Entrance__c = 'A';
    addr.External_Id__c ='1636835';
    addr.Cableunit_number__c = cableUnitTest.Cable_Unit_No__c;
    insert addr;
        
        
    Account acc1 = new Account();
    acc1.Name = 'TestHierarchy';
    acc1.Type='Hierarki';
    acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
    acc1.Street_YK__c = addr.Id;
    acc1.Street_YK__r = addr;
    System.debug(' Address----- '+acc1.Street_YK__r);
    insert acc1;

    RecordType recordtype1 = new RecordType();
    recordtype1 = [select Id,Name from RecordType where Name='YS Customer Account'];
 
    Account kundeChildAccount = new Account();
    kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger');
    kundeChildAccount.Type = 'Kunde';
    kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
    kundeChildAccount.RecordTypeId =recordtype1.id;
    kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
    kundeChildAccount.ParentId = acc1.Id;
    
    insert kundeChildAccount;
   
    system.runAs(uid){
        
    
    Lead le = new lead();
    le.FirstName = 'sneha';
    le.LastName = 'test17march';
    le.LeadSource = 'Web - 300 Mbit';
    le.RecordTypeId= recordtype.Id;
    le.Status= 'Åben';
    le.Address_External_Id__c=addr.External_Id__c;
    insert le;
    
    system.debug('lead id----'+le.Id);
    
    Lead le1 = new lead();
    le1.FirstName = 'snehanull';
    le1.LastName = 'test17march';
    le1.LeadSource = 'Web - 300 Mbit';
    le1.RecordTypeId= recordtype.Id;
    le1.Status= 'Åben';
    le1.Address_External_Id__c='';
    insert le1;
 //if(le1.Address_External_Id__c=='')
     update le1;
     
    }
    test.stopTest();
    
}
}