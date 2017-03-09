@istest
public class CableUnitInformationForAddressTest {
	
    static testmethod void CableUnitInformationForAddressControllerTest1(){
        
        Lookup_Post_Code__c postcode= new Lookup_Post_Code__c();
        //postcode.PostCode_External_ID__c='7400';
        postcode.Name='7400';
        insert postcode;
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Cable_Unit_No__c='0000001570';
        cableUnitTest.Cable_Type__c = 'Coax';
        insert cableUnitTest;
        
       
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;
        
        Address__c addr2 = new Address__c();
        addr2.Name='Nerult';
        addr2.House_No__c='2';
        addr2.Entrance__c = '12';
        addr2.Side__c = 'west';
        addr2.Active__c = true;
        addr2.External_Id__c = '58848';
        insert addr2;

        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123b';
        installation.Address__c = addr2.id;
        installation.Cable_Unit__c = cableUnitTest.Id;
        installation.AddressId_InstLbnr__c = '1';
        insert installation;
		
        Links__c link= new Links__c();
        link.URL__c='www.test.com';
        link.Category__c='Priser';
       	link.Cable_Unit__c= cableUnitTest.id;
        link.Text__c='test';
        insert link;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(addr1);
       CableUnitInformationForAddressController controller = new CableUnitInformationForAddressController(stdController);
       controller.getCableUnitInformation();
        
         ApexPages.StandardController stdController1 = new ApexPages.StandardController(addr2);
       CableUnitInformationForAddressController controller1 = new CableUnitInformationForAddressController(stdController1);
       controller1.getCableUnitInformation();
    }
}