@isTest(SeeAllData = true)
public class ContractKundeTraverserTestCls {

	static testMethod void getYSKontraktDetailsTEST() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customer';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','getKontraktKunde');
        
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
        acc.Name = 'Test Account';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Street_YK__c = addr.Id;
        acc.Type = 'Hierarki';
        insert acc;
        
        Account kk = new Account();
        kk.Name = 'Child Account';
        kk.ParentId = acc.id;
        kk.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kk.Kontraktkunde__c = acc.Id;
        kk.Street_YK__c = addr.Id;
        insert kk;
        
		ContractKundeTraverser.getAction();
		ContractKundeTraverser.getYSKontraktDetails();
	}
	
	static testMethod void getYSKontraktDetailsBlankAction() {
		System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customer';
        ContractKundeTraverser.getAction();
	}
	
	static testMethod void getYSKontraktDetailsBlankCableUnits() {
		System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customer';
        RestContext.request.addParameter('action','getKontraktKunde');
        ContractKundeTraverser.getAction();
        ContractKundeTraverser.getYSKontraktDetails();
	}
	
	static testMethod void getKundeTest(){
		
		System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customer';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','getKontraktKunde');
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        
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
        acc.Name = 'Test Account1';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        acc.Street_YK__c = addr.Id;
        acc.Type = 'Hierarki';
        insert acc;
        
        Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'TESTCUSSSDDD';        
        cu.Cable_Unit_No__c = '0055225566';
        cu.Status__c = '0';
        cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cu;
          
        Account account = new Account();
        account.Name = 'Kunde_Traverser';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Potential_Installations__c = 12;
        account.Active__c = true;
        account.Kontraktkunde__c = acc.Id;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        insert account;
        
        List<Account> acccList = new List<Account>();
        acccList.add(account);
        
        ContractKundeTraverser.getYSKontraktDetails();
        ContractKundeTraverser.getMapToAccountList(acccList);
        
	}
}