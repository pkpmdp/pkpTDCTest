@isTest(SeeAllData = true)
public class OasisTestClass{

public static YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
public static String cableUnitCustomerRecordType = ysRecords.YS_Customer_Account__c;

    public static testMethod void testPartySearch(){
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
    
        //YS customer
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Cable_Unit_No__c = '0001230076';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        insert cableUnit;
        
        Account acc = new Account();
        acc.name = 'TTest';
        acc.Street_YK__c = addr.Id;
        acc.RecordTypeId = cableUnitCustomerRecordType;
        acc.Cable_Unit__c = cableUnit.id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@abc.com';
        acc.Customer_No__c = cableUnit.Cable_Unit_No__c;
        acc.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
             
        Oasis_PartyActorSearch_CT controller = new Oasis_PartyActorSearch_CT();
        controller.cable_unit_No = cableUnit.Cable_Unit_No__c;
    }
}