@isTest
public class LinksTestClass {
    static testMethod void myUnitTest() {
        
        
        Account acc = setupAccount();        
        Cable_Unit__c cu = setupCableUnit(); 
        Net_Installations__c netinst = setupnetInstallation(cu);        
        Customer_Installation_Address__c cust =  setupAddressInstallation(acc , netinst);
        
        Links link= new Links();        
        link.currentId = acc.Id;
        link.acc = acc;
        list<links__c> lst = new list<links__c>();
        lst = link.getLinks();        
        list<links__c> lst2 = new list<links__c>();
        lst2 = link.getLinks2(acc.id);        
        links lnk = new links(new ApexPages.StandardController(acc));
        lnk.getAccountId();
        
        
    }
    
    static Account setupAccount()
    {
        Lookup_Customer_Segment__c custSegment = new Lookup_Customer_Segment__c(Name='test seg name' , Code__c= 'test code' , SourceId__c= 'source');
        insert custSegment;
        Account acc = new Account(name='test1', Status_YK__c='Active',Customer_Segment_Lookup__c= custSegment.id,Potential_Installations__c=10, Municipaly__c='101 København');
        insert acc;
        return acc;
    }
    static Cable_Unit__c setupCableUnit()
    {
        Lookup_Post_Code__c postcodeLookup;
        String postcode = '2000';
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;  
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        //cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Segment__c = '5';
        cableUnitTest.distinctAddresses__c = 'address';
        cableUnitTest.Cable_Type__c = 'Coax';
        cableUnitTest.Oasis_Lock__c = '1';
        insert cableUnitTest;   
        
        return cableUnitTest;
    }
    
    static Net_Installations__c setupnetInstallation(Cable_Unit__c cu){
        Net_Installations__c netinst=new Net_Installations__c(name = 'Net Installation name',Cable_Unit__c=cu.Id);
        insert netinst;
        return netinst;
    }
    
    static Customer_Installation_Address__c setupAddressInstallation(Account acc , Net_Installations__c netinst)
    {
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
        
        Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
        cia.Address__c=addr.Id;
        cia.Customer__c=acc.Id;
        cia.Installation_Address_External_ID__c='12122';
        cia.Active_Sub__c = true;
        cia.Installation_ID__c = netinst.installation_id__c;
        insert cia; 
        return cia;
    }
}