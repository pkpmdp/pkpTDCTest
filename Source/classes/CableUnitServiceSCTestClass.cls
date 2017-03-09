@isTest
private class CableUnitServiceSCTestClass {

    private static void init(){
    }
	public static User u;
    static testMethod void testCableUnitList(){
        init(); 
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type='Hierarki';
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
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
        
        List<Id> freeFlyContDiffHier = new List<Id>();
        List<Contact> contactEmail = new  List<Contact>();
        
        /*Account kundeChild = new Account();
        kundeChild.Name = 'kundeCustomer';
        kundeChild.parentId = acc.Id;
        kundeChild.Cable_Unit__c = cableUnitTest.id;
        kundeChild.RecordTypeId = '012200000000nf3';
        kundeChild.Type = 'kunde';
        insert kundeChild;*/
        
        
		 Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=acc.Id);
		 insert c;
		 if(c.email != null){
		 	contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name,HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false];
		 }
		 
    	Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        //dmo.EmailHeader.triggerUserEmail = true;
       	u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            //u.setOptions(dmo);
		insert u;
		String userInfoId = u.Id;
		//Set<ID> accountKeySet = new Set<ID>{'001M000000Bh6T6IAJ','001M000000ACcpLIAT','001M000000ACgjSIAT','001M000000ACykiIAD','001M000000AD7LjIAL','001M000000ADVOBIAS','001M000000ADnmdIAD','001M0000009ACLwIAO','001M000000ACd2WIAT','001M0000009ACJ2IAO'};
		//List<ID> contactIds = new List<ID>{'003M0000008rv3gIAA'};
		//ID hierarchyIds = '001M000000AAWXFIA5'; 
		
		
		SalesConcept__c salesConObj = new SalesConcept__c();
        salesConObj.Solution__c = 'Indholdsbeskrivelse mangler';
        salesConObj.TVandRadio__c = 1 ;
        salesConObj.Broadband__c = 0 ;
        salesConObj.Telephony__c = 1 ;
        salesConObj.SC_Source_Id__c = 'OAS';
        salesConObj.Customer__c = acc.Id;
        insert salesConObj;
         
        Sales_Concept_Parameter__c salesConPar = new Sales_Concept_Parameter__c();
        salesConPar.Sales_Concept__c = salesConObj.Id;
        salesConPar.Parameter_Group__c = 'salaParamG';
        salesConPar.Parameter_PortalActive__c = true;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj.Name = 'A:6000545:201134';
        oppObj.StageName = 'Potentiel';
        oppObj.CloseDate = Date.valueOf('2014-03-03');
        oppObj.AccountId = acc.Id;
        insert oppObj;
        
        Opportunity oppObj1 = new Opportunity();
        oppObj1.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj1.Name = 'A:6000545:201134';
        oppObj1.StageName = 'Potentiel';
        oppObj1.CloseDate = Date.valueOf('2014-03-03');
        oppObj1.AccountId = acc.Id;
        insert oppObj1;
        
        Opportunity oppObj2 = new Opportunity();
        oppObj2.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj2.Name = 'A:6000545:201134';
        oppObj2.StageName = 'Potentiel';
        oppObj2.CloseDate = Date.valueOf('2014-03-03');
        oppObj2.AccountId = acc.Id;
        insert oppObj2;
		
		List<ID> contactIds1 = new List<ID>();
		contactIds1.add(c.Id);
		
		ID hierarchyIds1 = c.HierarchyAccount__c;
		Set<ID> accountKeySet = new Set<ID>{oppObj.Id,oppObj1.Id,oppObj2.Id};
    //   u = [SELECT Id, Name FROM User where email = 'vishal.tambe@capgemini.com' limit 1]; 
       	 System.runAs(u) {
         CableUnitService cableUnitController = new CableUnitService();
         cableUnitController.getCableUnitRelatedDetails(userInfoId);
         cableUnitController.getLoggedInUserAccountID();
         cableUnitController.getAssignedAccountsPortalAdmin();
         cableUnitController.getUserProfile();
         cableUnitController.getContactHierarchyDetails();
         cableUnitController.getSalesConceptRelatedDetails(accountKeySet);
         cableUnitController.userId = u.Id;
         cableUnitController.getAccountIds(contactIds1,hierarchyIds1);
         //cableUnitController.getAssignedAccountsPortalUser();
         CableUnitService_SPOC2411 cableUnitController2411 = new CableUnitService_SPOC2411();
         cableUnitController2411.getCableUnitRelatedDetails(userInfoId);
         cableUnitController2411.getLoggedInUserAccountID();
         cableUnitController2411.getAssignedAccountsPortalAdmin();
         cableUnitController2411.getUserProfile();
         cableUnitController2411.getContactHierarchyDetails();
         cableUnitController2411.getSalesConceptRelatedDetails(accountKeySet);
         cableUnitController2411.userId = u.Id;
         cableUnitController2411.getAccountIds(contactIds1,hierarchyIds1);
         
    }
   }
}