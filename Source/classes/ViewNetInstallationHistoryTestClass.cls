@isTest
public class ViewNetInstallationHistoryTestClass {
	
	public static Cable_Unit__c cu;
    public static Account account;
    
    
    @isTest
    public static void testInstallations(){
        
        List<Net_Installations__c> netInstallationList = new List<Net_Installations__c>();
        cu = new Cable_Unit__c();
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
        
        account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert account;
        
        List<Address__c> addressLst = new List<Address__c>();
        
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        //addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;

        Address__c addr2 = new Address__c();
        addr2.Name='Vashi';
        addr2.House_No__c='1';
        addr2.Postcode__c='1100';
        addr2.Door_No__c='52';
        addr2.Street__c ='wall street';
        addr2.Active__c = true;
        addr2.External_Id__c = '58850';
        insert addr2;
        
        Address__c addr3 = new Address__c();
        addr3.Name='Vashi';
        addr3.House_No__c='4';
        addr3.Postcode__c='1100';
        addr3.Floor__c='4';
        addr3.Active__c = true;
        addr3.External_Id__c = '58851';
        insert addr3;
        
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr1.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.INSTALLATION_ID__c = '001248';
        insert installation;
        
        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123a';
        installation1.Address__c = addr2.id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.AddressId_InstLbnr__c = '1';
        installation1.INSTALLATION_ID__c = '001248';
        insert installation1;

        Net_Installations__c installation2 = new Net_Installations__c();
        installation2.Address_Id__c = 'add123a';
        installation2.Address__c = addr3.id;
        installation2.Cable_Unit__c = cu.Id;
        installation2.AddressId_InstLbnr__c = '1';
        installation2.INSTALLATION_ID__c = '0012741';
        insert installation2;   
        
        netInstallationList.add(installation);
        netInstallationList.add(installation1);
        netInstallationList.add(installation2);
        
        PageReference pageRef = Page.ViewNetInstallationHistory;
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(installation);
        ViewNetInstallationHistory vsc = new ViewNetInstallationHistory(sc);
        vsc.getInstallationList(installation.Id);
        
        
	}
	
	
}