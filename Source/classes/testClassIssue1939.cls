@isTest(SeeAllData=true) 
/*
SPOC-1939 TEST class issue
*/
public class testClassIssue1939 {
    // clsConsoleCustomerRedirectController 
    static testMethod void CustomerRedirectControllerTest()
    {
           
        Pagereference pgref1 = new Pagereference('apex/ConsoleCustomerRedirectLeftPanelPoC_YKRB?id=001');
        test.setCurrentPage(pgref1);
    clsConsoleCustomerRedirectController clscon1 = new clsConsoleCustomerRedirectController();
    //pgref.getParameters().put('id',String.ValueOf(001));
    
    //clscon.idParam = '001'; 
    clscon1.RedirectToCustomerpanel();
    Pagereference pgref2 = new Pagereference('apex/ConsoleCustomerRedirectLeftPanelPoC_YKRB?id=003');
        test.setCurrentPage(pgref2);
    clsConsoleCustomerRedirectController clscon2 = new clsConsoleCustomerRedirectController();
    //pgref.getParameters().put('id',String.ValueOf(001));
    
    //clscon.idParam = '001'; 
    clscon2.RedirectToCustomerpanel();
    Pagereference pgref3 = new Pagereference('apex/ConsoleCustomerRedirectLeftPanelPoC_YKRB?id=500');
        test.setCurrentPage(pgref3);
    clsConsoleCustomerRedirectController clscon3 = new clsConsoleCustomerRedirectController();
    //pgref.getParameters().put('id',String.ValueOf(001));
    
    //clscon.idParam = '001'; 
    clscon3.RedirectToCustomerpanel();
           
    }
    
    //clsPayerLegalCustomerController
    static testMethod void clsPayerLegalCustomerControllertTest()
    {
           
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
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
        clsTestFactory fact = new clsTestFactory();
        Cable_Unit__c cable_unit = new Cable_Unit__c();
        cable_unit.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cable_unit.Name = 'TestCustomerAccountRoleTrigger';
        cable_unit.Municipaly__c = '157 Gentofte';
        cable_unit.Cable_Unit_Post_Code__c = '3360';
        cable_unit.CA_Sales_Concept__c = 'SERVICE';        
        cable_unit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cable_unit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                     
        cable_unit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cable_unit.Potential_Installations__c = 68.0;
        insert cable_unit;
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                        where sObjectType='Account' and isActive=true 
                                        and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;                                          
        
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account.Cable_Unit__c = cable_unit.Id;  
        account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account.Billing_Address__c = addr.Id;
        insert account;
        cable_unit.Legal_Account_No__c = account.Id;
        cable_unit.Payment_Account_No__c = account.Id;
        update cable_unit;
        ApexPages.StandardController sc_customer =  new ApexPages.StandardController(account);
        clsPayerLegalCustomerController contr = new clsPayerLegalCustomerController(sc_customer);
    }
    // clsRelatedOCustomerRelationsController
    static testMethod void clsRelatedOCustomerRelationsControllerTest()
    {
           
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
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
        clsTestFactory fact = new clsTestFactory();
        Cable_Unit__c cable_unit = new Cable_Unit__c();
        cable_unit.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cable_unit.Name = 'TestCustomerAccountRoleTrigger';
        cable_unit.Municipaly__c = '157 Gentofte';
        cable_unit.Cable_Unit_Post_Code__c = '3360';
        cable_unit.CA_Sales_Concept__c = 'SERVICE';        
        cable_unit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cable_unit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                     
        cable_unit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cable_unit.Potential_Installations__c = 68.0;
        insert cable_unit;
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                        where sObjectType='Account' and isActive=true 
                                        and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;                                          
        List<Account> listacc = new List<Account>();
        // Account
        /*List<RecordType> rec = [select id from RecordType where DeveloperName = 'POF_O_Customer'];
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account.Cable_Unit__c = cable_unit.Id;  
        account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account.Billing_Address__c = addr.Id;
        account.Street_YK__c = addr.Id;
        account.RecordType = rec[0];
        insert account;*/
        //Account 1
        Account account1 = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account1.Cable_Unit__c = cable_unit.Id;  
        account1.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account1.Billing_Address__c = addr.Id;
        account1.Street_YK__c = null;
        insert account1;
        /*listacc.add(account);
        listacc.add(account1);
        insert listacc;*/
        //system.debug('***** Account **** '+account);
        /*ApexPages.StandardController sc_customer =  new ApexPages.StandardController(account);
        clsRelatedOCustomerRelationsController conr = new clsRelatedOCustomerRelationsController(sc_customer);
        PageReference pgref = new PageReference('RelatedOCustomerYFF');
        pgref.getParameters().put('searchfilter',String.valueof('abc'));
        conr.filterValue = 'abc';  
        conr.getBillingRelations();
        
        cable_unit.Legal_Account_No__c = account.Id;
        cable_unit.Payment_Account_No__c = account.Id;
        update cable_unit;
        conr.filterValue = ''; 
        conr.runFilter();
        conr.getBillingRelations();*/
        ApexPages.StandardController sc_customer1 =  new ApexPages.StandardController(account1);
        clsRelatedOCustomerRelationsController conr1 = new clsRelatedOCustomerRelationsController(sc_customer1);
        PageReference pgref1 = new PageReference('RelatedOCustomerYFF');
        pgref1.getParameters().put('searchfilter',String.valueof('abc'));
        conr1.filterValue = '';  
        conr1.getBillingRelations();
        
        cable_unit.Legal_Account_No__c = account1.Id;
        cable_unit.Payment_Account_No__c = account1.Id;
        update cable_unit;
        conr1.filterValue = ''; 
        conr1.runFilter();
        conr1.getBillingRelations();
        //conr.filterValue = 'abc';
           
    }
    
    // tgrOpportunitySalesConcept
    static testMethod void tgrOpportunitySalesConceptTest()
    {
         
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                        where sObjectType='Account' and isActive=true 
                                        and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;
            Lookup_Post_Code__c postcodeLookup;
        String postcode = '2009';
        
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;  
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'acu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = '0000123456';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        //cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Segment__c = '5';
        insert cableUnitTest; 
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
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        Account account1 = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account1.Cable_Unit__c = cableUnitTest.Id;   
        account1.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account1.Billing_Address__c = addr.Id;
        account1.Street_YK__c = null;
        insert account1;
        SalesConcept__c salesc = new SalesConcept__c();
        salesc.SC_Source_Id__c = 'abc';
        salesc.sc_code__c = 'abc';
        salesc.Solution__c = 'a';
        insert salesc;
        Opportunity opp = new Opportunity();
        opp.AccountId = account1.Id;
        opp.Name = 'opportunity1';
        opp.CloseDate = Date.today()+5;
        opp.KISS_Sales_Concept_Id__c = 'abc';
        opp.Sales_Concept__c = 'abc-a';
        opp.StageName = 'Udgivet';
        
        insert opp;
           
    }
    // tgrAddressAfterInsertUpdate
    static testMethod void tgrAddressAfterInsertUpdateTest()
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
        Address__c addr1  = new Address__c();
        addr1.Town__c = 'AH';
        addr1.Postcode__c = '421002';
        addr1.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr1.Floor__c = 'Third';
        addr1.House_No__c = 'testData';
        addr1.Street__c = 'AH';
        addr1.Entrance__c = 'A';
        insert addr1;
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                        where sObjectType='Account' and isActive=true 
                                        and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;
            Lookup_Post_Code__c postcodeLookup;
        String postcode = '2009';
        
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;  
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'acu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = '0000123456';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        //cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Segment__c = '5';
        insert cableUnitTest; 
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        Account account1 = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account1.Cable_Unit__c = cableUnitTest.Id;   
        account1.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account1.Billing_Address__c = addr.Id;
        account1.Street_YK__c = addr.Id;
        insert account1;
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account.Cable_Unit__c = cableUnitTest.Id;   
        account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account.Billing_Address__c = addr1.Id;
        account.Street_YK__c = addr1.Id;
        insert account; 
           
    }
    // UpdateFuturePackage
  /*  static testMethod void UpdateFuturePackageTest()
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
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                        where sObjectType='Account' and isActive=true 
                                        and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;
            Lookup_Post_Code__c postcodeLookup;
        String postcode = '2009';
        
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;  
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'acu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = '0000123456';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        //cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Segment__c = '5';
        cableUnitTest.Cable_Type__c = 'Coax';
        insert cableUnitTest; 
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = addr.id;
        installation.Address__c = addr.id;
        installation.Cable_Unit__c = cableUnitTest.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.INSTALLATION_ID__c = '123456';
        installation.HasFuturePackage__c = true;
        insert installation;
        Subscription__c sub = new Subscription__c();
        sub.Address__c = 'adder';
        sub.End_Date__c = Date.today()-5;
        sub.Net_Installation__c = installation.id;
        insert sub;
        UpdateFuturePackage upp = new UpdateFuturePackage();
        database.executeBatch(upp,50);
        
           
    }*/
    static testMethod void CompetitorMassEditController()
    {   
         
        
       Lookup_Contact_Roles__c accContactRoleObj = 
            new Lookup_Contact_Roles__c(Name = 'Rolle2', Start_Date__c = Date.valueOf('2011-01-01'),
                                       End_Date__c = Date.valueOf('2100-12-31'), SourceId__c = 'rolle1-Id',
                                       Code__c = 'Rolle10');
        insert accContactRoleObj;
        
        Lookup_Building_Type__c buildingType = new Lookup_Building_Type__c();
        //buildingType.Active__c='ja';
        buildingType.name ='Private bunglow';
        buildingType.Code__c='12121';
        buildingType.End_Date__c= date.today();
        buildingType.Start_Date__c=date.today();
        buildingType.SourceId__c='Private bunglow';
       
        insert  buildingType;
        //system.debug();
        //Lookup_Building_Type__c bTypeObj = [select Id,Name from Lookup_Building_Type__c limit 1];
        
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
        Cable_Unit__c cUnit = new Cable_Unit__c();
        cUnit.Name = 'Torvet 28'; 
        cUnit.Cable_Unit_No__c='1234';
        cUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cUnit.Building_Type__c = buildingType.id;        
        insert cUnit; 
        
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Customer_No__c = '1234';
        acc.Street_YK__c = add.Id;
        acc.Cable_Unit__c = cUnit.Id;  
        insert acc;
        
        Competitor__c competitor = new Competitor__c();
        competitor.customer__c = acc.Id;
        competitor.Competitor__c = 'TestCompetitor';
        competitor.Competitor_role__c = 'TestRole';        
        insert competitor;
        
        // End 
        System.currentPageReference().getParameters().put('id',string.valueOf(competitor.id));
        System.currentPageReference().getParameters().put('retURL','/'+String.valueOf(acc.id));
        ApexPages.StandardController comp =  new ApexPages.StandardController(competitor);
        CompetitorMassEditController obj = new CompetitorMassEditController(comp);
        
        obj.MoveDown();
        obj.MoveUp();
        obj.DoSelect();
        obj.DoUnselect();
        obj.save();
        obj.Cancel();
           
        
    }
    static testMethod void testConferenceEmailService(){
       
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
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger');
        kundeChildAccount.Type = 'Kunde';
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
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
       contact.UserProfile__c ='';
       insert contact;
        
       ConferenceEmailService.sendEmailYouseeConference(String.valueOf(contact.id), 'test.TestClase@test1.com');
       ConferenceEmailService.sendEmailYouseeConference('abcd', 'abcd');
      
    }
    
    
    
}