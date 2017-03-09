/**
*   class Oasis_TestClass
*
*   Test class for all "Oasis_" classes.  
*
*/ 
@isTest
public class Oasis_TestClass {  
    static testMethod void test_Oasis_Utils()
    {
        setupCustomSettings();
        Oasis_Error_Type_Codes__c oErr = new Oasis_Error_Type_Codes__c();
        oErr.Name = 'Indbrud i skab m. låsemodstand';
        oErr.Error_Type_Label__c = 'Indbrud i skab u. låsemodstand';
        insert oErr;
        Oasis_Utils.encodeCookieValue('test');
        Oasis_Utils.decodeCookieValue('test');
        Oasis_Utils.getCookieValue('test');
        Oasis_Utils.getErrorTypeCode('Indbrud i skab u. låsemodstand');
        Oasis_Utils.getErrorTypeCode('test');
    }
    
    // test method for the change password class
    static testMethod void test_Oasis_ChangePassword_CT()
    {           
        setupCustomSettings();
        Account a =  setupDummyAccount();
        Address__c addr = setupDummyAddress();
        Contact c =  setupDummyContact(a, addr);
        //     setupUserData(a, c); 
        Test.startTest();
        
        //change the password
        Oasis_ChangePassword_CT con = new Oasis_ChangePassword_CT();
        con.oldPassword = 'oldpassword';
        con.newPassword = 'newPassword';
        con.oUser = new Oasis_User__c();
        system.assertEquals(con.changePassword(), null);            
        test.stopTest();    
    }
    
    // test the login page
    static testmethod void test_Oasis_SiteLogin_CT()
    {
        setupCustomSettings();
        
        Account a = setupDummyAccount();
        Address__c addr = setupDummyAddress();
        Cable_Unit__c cu = setupCableUnit();
        Contact c =  setupDummyContact(a, addr); 
        Net_Installations__c installation1 = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation1);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation1);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        cS = setupDummyCustomerSubscription_customer(addr, installation1, prod,a.Customer_No__c);
        system.debug('***a**' + a);
        
        Oasis_User__c   oaUser = new Oasis_User__c();
        oaUser.Oasis_User_Name__c = 'Eva Abildgaard Stokholm';
        oaUser.Oasis_User_Email__c = 'evast@tdc.dk';
        oaUser.Oasis_mId__c = 'A10563';
        oaUser.Oasis_User_Password__c = 'A10563' ;
         insert oaUser;
         
        PageReference pageRef = Page.Oasis_SiteLogin;
        Test.setCurrentPage(pageRef);       
        //   setupUserData(a, c);      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL',Encodingutil.urlEncode('http://www.google.com', 'UTF-8'));
        ApexPages.currentPage().getParameters().put('username',oaUser.Oasis_User_Name__c);
        ApexPages.currentPage().getParameters().put('password',oaUser.Oasis_User_Password__c);
        ApexPages.currentPage().getParameters().put('customer',cS.Customer_Number__c);
        Oasis_SiteLogin_CT con = new Oasis_SiteLogin_CT();
        // wrong user id password
        con.email = 'abc@test.com';
        con.password = 'abcdef';
        system.assertEquals(con.login(), null);   
        con.email = 'test@email.com';
        con.password = 'password';
        system.assertNotEquals(con.login(), null);
        //con.email = 'testClassUser@test.com';
        //con.password = 'p@ssw0rd';
        //system.assertNotEquals(con.login(), null);
        con.doRedirection();
        con.retURL = '';
        Test.stoptest();
    }
    //start 2422 single net installtion
    static testmethod void test_Oasis_addressSingleLogin()
    {
        setupCustomSettings();
        
        Account a = setupDummyAccount();
        Address__c addr = setupDummyAddress();
        Cable_Unit__c cu = setupCableUnit();
        Contact c =  setupDummyContact(a, addr); 
        Net_Installations__c installation1 = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation1);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation1);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        cS = setupDummyCustomerSubscription_customer(addr, installation1, prod,a.Customer_No__c);
        system.debug('***a**' + a);
        
        Oasis_User__c   oaUser = new Oasis_User__c();
        oaUser.Oasis_User_Name__c = 'Eva Abildgaard Stokholm';
        oaUser.Oasis_User_Email__c = 'evast@tdc.dk';
        oaUser.Oasis_mId__c = 'A10563';
        oaUser.Oasis_User_Password__c = 'A10563' ;
         insert oaUser;
         
        PageReference pageRef = Page.Oasis_SiteLogin;
        Test.setCurrentPage(pageRef);       
        //   setupUserData(a, c);      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL',Encodingutil.urlEncode('http://www.google.com', 'UTF-8'));
        ApexPages.currentPage().getParameters().put('username',oaUser.Oasis_User_Name__c);
        ApexPages.currentPage().getParameters().put('password',oaUser.Oasis_User_Password__c);
        ApexPages.currentPage().getParameters().put('address',addr.External_Id__c);
        Oasis_SiteLogin_CT con = new Oasis_SiteLogin_CT();
        // wrong user id password
        con.email = 'abc@test.com';
        con.password = 'abcdef';
        system.assertEquals(con.login(), null);   
        con.email = 'test@email.com';
        con.password = 'password';
        system.assertNotEquals(con.login(), null);
        //con.email = 'testClassUser@test.com';
        //con.password = 'p@ssw0rd';
        //system.assertNotEquals(con.login(), null);
        con.doRedirection();
        con.retURL = '';
        Test.stoptest();
    }
    //End 2422
    
    //start 2422 more than net installtion
    static testmethod void test_Oasis_addressMoreThanSingleLogin()
    {
        setupCustomSettings();
        
        Account a = setupDummyAccount();
        Address__c addr = setupDummyAddress();
        System.debug('test addr >>>>>'+addr);
        /*
         Address__c addr  = new Address__c();
        addr.Town__c = 'AHtest';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        //addr.HouseNumber__c = '';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';

        insert addr;
        */
        System.debug('test address'+addr);
        Cable_Unit__c cu = setupCableUnit();
        Contact c =  setupDummyContact(a, addr); 
        Net_Installations__c installation1 = setupDummyInstallation(addr, cu);
        Net_Installations__c installation2 = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation1);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation1);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        cS = setupDummyCustomerSubscription_customer(addr, installation1, prod,a.Customer_No__c);
        system.debug('***a**' + a);
        
        Oasis_User__c   oaUser = new Oasis_User__c();
        oaUser.Oasis_User_Name__c = 'Eva Abildgaard Stokholm';
        oaUser.Oasis_User_Email__c = 'evast@tdc.dk';
        oaUser.Oasis_mId__c = 'A10563';
        oaUser.Oasis_User_Password__c = 'A10563' ;
         insert oaUser;
         
        PageReference pageRef = Page.Oasis_SiteLogin;
        Test.setCurrentPage(pageRef);       
        //   setupUserData(a, c);      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL',Encodingutil.urlEncode('http://www.google.com', 'UTF-8'));
        ApexPages.currentPage().getParameters().put('username',oaUser.Oasis_User_Name__c);
        ApexPages.currentPage().getParameters().put('password',oaUser.Oasis_User_Password__c);
        ApexPages.currentPage().getParameters().put('address',addr.External_Id__c);
        Oasis_SiteLogin_CT con = new Oasis_SiteLogin_CT();
        // wrong user id password
        con.email = 'abc@test.com';
        con.password = 'abcdef';
        system.assertEquals(con.login(), null);   
        con.email = 'test@email.com';
        con.password = 'password';
        system.assertNotEquals(con.login(), null);
        //con.email = 'testClassUser@test.com';
        //con.password = 'p@ssw0rd';
        //system.assertNotEquals(con.login(), null);
        con.doRedirection();
        con.retURL = '';
        Test.stoptest();
    }
    //End 2422
    //start 2422 constructor 
    static testMethod void testTestingEX1 () {
        PageReference tpageRef = Page.oasis_installationinfo2;
            Test.setCurrentPage(tpageRef);
            Address__c addr = setupDummyAddress();
            ApexPages.currentPage().getParameters().put('address','123456');

        //System.assertEquals( po.id,ApexPages.currentPage().getParameters().get('Id'));
           
            Oasis_InstallationSearch_CT Sc=new Oasis_InstallationSearch_CT();           
        
}
    //End 2422 constructor
    // test the login page
    static testmethod void test_Oasis_SiteLogin_CT_multipleInstallaiton()
    {
        setupCustomSettings();
        
        Account a = setupDummyAccount();
        Address__c addr = setupDummyAddress();
        Cable_Unit__c cu = setupCableUnit();
        Contact c =  setupDummyContact(a, addr); 
        Net_Installations__c installation1 = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation1);
        
        Net_Installations__c installation2 = setupDummyInstallation(addr, cu);
        Subscription__c sub2 = setupDummySubscription(installation2);
        
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation1);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        Customer_Subscription__c cS2 = new Customer_Subscription__c();
        cS = setupDummyCustomerSubscription_customer(addr, installation1, prod,a.Customer_No__c);
        cS2 = setupDummyCustomerSubscription_customer(addr, installation2, prod,a.Customer_No__c);
        system.debug('***a**' + a);
        
        Oasis_User__c oaUser = new Oasis_User__c();
        oaUser.Oasis_User_Name__c = 'Eva Abildgaard Stokholm';
        oaUser.Oasis_User_Email__c = 'evast@tdc.dk';
        oaUser.Oasis_mId__c = 'A10563';
        oaUser.Oasis_User_Password__c = 'A10563' ;
        insert oaUser;
         
        PageReference pageRef = Page.Oasis_SiteLogin;
        Test.setCurrentPage(pageRef);       
        //   setupUserData(a, c);      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL',Encodingutil.urlEncode('http://www.google.com', 'UTF-8'));
        ApexPages.currentPage().getParameters().put('username',oaUser.Oasis_User_Name__c);
        ApexPages.currentPage().getParameters().put('password',oaUser.Oasis_User_Password__c);
        ApexPages.currentPage().getParameters().put('customer',cS.Customer_Number__c);
        Oasis_SiteLogin_CT con = new Oasis_SiteLogin_CT();
        // wrong user id password
        con.email = 'abc@test.com';
        con.password = 'abcdef';
        system.assertEquals(con.login(), null);   
        con.email = 'test@email.com';
        con.password = 'password';
        system.assertNotEquals(con.login(), null);
        //con.email = 'testClassUser@test.com';
        //con.password = 'p@ssw0rd';
        //system.assertNotEquals(con.login(), null);
        con.doRedirection();
        con.retURL = '';
        Test.stoptest();
    }
    
    // test method for cu search page
    static testmethod void test_Oasis_CUSearch_CT()
    {
        setupCustomSettings();
        Cable_Unit__c cu = setupCableUnit();
        Lookup_Customer_Segment__c customerSegment = setupLookupCustomerSegment();
        Address__c addr = setupDummyAddress();
        Account cableUnitAccount = setupDummyCableUnitAccount(cu, customerSegment, addr); 
        Test.startTest();
        Oasis_CUSearch_CT con;
        // test the search functionality when coming from installtion search page
        Apexpages.currentPage().getParameters().put('id', cu.Cable_Unit_No__c);
        con  = new Oasis_CUSearch_CT();         
        con.searchCU();
        system.assertNotEquals(con.cableUnit, null);
        system.assertEquals(con.cableUnit.id, cu.Id);
        // test the search functionality when search from the CU search page            
        con  = new Oasis_CUSearch_CT();         
        con.cable_unit_No = cu.Cable_Unit_No__c;
        con.searchCUWrapper();
        con.searchCU();
        system.assertNotEquals(con.cableUnit, null);
        system.assertEquals(con.cableUnit.id, cu.Id);
        // test the CU registration code
        system.assertNotEquals(con.getListCURegCodes(),null);
        // test create case logic
        con.cable_unit_No = cu.Cable_Unit_No__c;
        con.regCode = 'Reg, Korrekt';
        con.comments = 'test comments';
        system.assertEquals(con.registerCase(),null);
        // test the various dropdowns
        Oasis_utils.getErrorTypeLabels();
        Oasis_Utils.getStrikeValues();
        OAsis_utils.getInstallationRegistrationCodes();
        Oasis_utils.getCURegistrationCodes();
        con.registerCase();
        Oasis_CUSearch_CT con1 = new Oasis_CUSearch_CT();
        con1.cable_unit_No = '';
        con1.registerCase();
        Test.stopTest();       
    }
    
    // test method for Installation Info page
    static testmethod void test_Oasis_InstallationInfo_CTE()
    {
        // setup data
        setupCustomSettings();
        Address__c addr = setupDummyAddress();
        Cable_Unit__c cu = setupCableUnit();
        Lookup_Customer_Segment__c customerSegmentObj = setupLookupCustomerSegment();
        Account a = setupDummyCableUnitAccount(cu, customerSegmentObj, addr);
        Net_Installations__c installation = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        cS = setupDummyCustomerSubscription(addr, installation, prod);        
        Test.startTest();
        // test the page load, where the page gets the subscription id from the querystring
        Apexpages.currentPage().getParameters().put('id', installation.id);
        Apexpages.currentPage().getParameters().put('ocn', EncodingUtil.base64Encode(Blob.valueOf('123456')));
        Oasis_InstallationInfo_CTE con = new Oasis_InstallationInfo_CTE();      
        //system.assertNotEquals(con.customer, null);
        con.customer = new Account();
        con.isNetInstallationInMovement = false;
        con.isBlandSelvProduct  = false;
        con.installation = installation;
        // test individual methods of class
        con.getListErrorTypeLabels();
        con.getListInstRegCodes();
        con.getListStrikeValues();
        Oasis_InstallationInfo_CTE.getPICKLIST_OPTION_SELECT();
        // check if we are getting the registration codes for installation
        system.assertNotEquals(con.getListInstRegCodes(), null);
        // test case registration       
        con.regCode =  'Reg, Korrekt'; 
        con.comments = 'Test comments';
        con.strikeValue =  'Strike 1';
        con.errorTypeLabel = 'Test Error Label'; 
       
        Oasis_Case__c occ = new Oasis_Case__c();
        occ.Oasis_Installation__c=installation.Id;
        insert occ;
        Oasis_InstallationInfo_CTE.ViewModel obj = new Oasis_InstallationInfo_CTE.ViewModel();
        obj.csObj = new Customer_Subscription__c();
        obj.isBlandSelv = false;
        con.registerCase();
        Apexpages.currentPage().getParameters().put('odc', EncodingUtil.base64Encode(Blob.valueOf('true')));
        Oasis_InstallationInfo_CTE con1 = new Oasis_InstallationInfo_CTE();  
        Test.stopTest();
    } 
    
    static testmethod void test_Oasis_kundeLogController()
    {
        // setup data
        setupCustomSettings();
        Address__c addr = setupDummyAddress();
        Cable_Unit__c cu = setupCableUnit();
        Lookup_Customer_Segment__c customerSegmentObj = setupLookupCustomerSegment();
        Account a = setupDummyCableUnitAccount(cu, customerSegmentObj, addr);
        Net_Installations__c installation = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation);
        Product__c prod = setDummyProduct1();
        Customer_Subscription__c cS = new Customer_Subscription__c();
        Customer_Log__c custLog=new Customer_Log__c();
        cS = setupDummyCustomerSubscription(addr, installation, prod);        
        Test.startTest();
        // test the page load, where the page gets the subscription id from the querystring
        Apexpages.currentPage().getParameters().put('id', a.id);
        Apexpages.currentPage().getParameters().put('ocn', EncodingUtil.base64Encode(Blob.valueOf('123456')));
        Oasis_kundeLogController contr = new Oasis_kundeLogController();
        contr.changPaging();
        contr.getshow();
        contr.first();
        contr.getHasNext();
        contr.getPageNumber();
        contr.getHasPrevious();
        contr.getPageSize();
        contr.last();
        contr.next();
        contr.previous();
       // contr.showAllLogs();
        contr.setCurrentPageCountText();
        contr.setPageSize(10);
        contr.ResponseFromCon='recordspresent';
        Oasis_kundeLogController.getPICKLIST_OPTION_SELECT();
        
        Test.stopTest();
    } 
    
    // test method for installation Search controller
    static testmethod void test_Oasis_InstallationSearch_CT()
    {
        // setup data
        setupCustomSettings(); 
        Product__c prod = setDummyProduct();
        Address__c addr = setupDummyAddress2();
        Cable_Unit__c cu = setupCableUnit();
        Lookup_Customer_Segment__c customerSegmentObj = setupLookupCustomerSegment();
        Account a = setupDummyCableUnitAccount(cu, customerSegmentObj, addr);
        Net_Installations__c installation = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation);
        Customer_Subscription__c cs = setupDummyCustomerSubscription(addr, installation, prod);
        Customer_Subscription__c cs2 = setupDummyCustomerSubscription(addr, installation, prod);
        // second installtion
        Net_Installations__c installation2 = setupDummyInstallation2(addr, cu);
        Subscription__c sub2 = setupDummySubscription(installation2);
        Customer_Installation_Address__c cia2 = setupDummyCustomerInstallationAddress2(a, addr, installation2);
        Customer_Subscription__c cs3 = setupDummyCustomerSubscription(addr, installation2, prod);
        END_POINT__c en = new END_POINT__c();
        en.END_POINT__c = 'https://TDCGroupTRIAL79207.jitterbit.eu/devtdcapi/1';
        en.Name='JITTERBIT';
        insert en;
        insert new INTEGRATION__c(
            HttpMethod__c = 'GET',
            Name = 'DigitalFilter',
            Params__c = 'cableunitid',
            Service__c = 'JITTERBIT',
            IsBodyAppended__c = false);
        
        insert new INTEGRATION__c(
            HttpMethod__c = 'GET',
            Name = 'Activities2showinOASIS',
            Params__c = 'cableUnitId',
            Service__c = 'JITTERBIT',
            IsBodyAppended__c = false);
        Test.startTest();
        Oasis_InstallationSearch_CT con;
        list<OasisCallouts.CasperActivityWrapper> listxmlParser = new list<OasisCallouts.CasperActivityWrapper>();
        OasisCallouts.CasperActivityWrapper xmlparse = new OasisCallouts.CasperActivityWrapper();
        xmlparse.AMSID = '123456';
        listxmlParser.add(xmlparse);
        // search installation with Address
        con = new Oasis_InstallationSearch_CT();
        con.parsedXML = listxmlParser;
        con.address.Street__c = 'Kastanievej';
        con.address.Postcode__c = '8660';
        con.houseNumberFrom = '1';
        con.houseNumberTo = '11';
        con.address.Entrance__c = 'B';
        con.address.Floor__c = 'ST';
        con.address.Door_No__c = 'TV';
        List<Net_Installations__c> instList = new List<Net_Installations__c>();
        instList.add(installation2);
        con.stdSetController = new ApexPages.StandardSetController(instList);
        con.searchWrapper();
        con.search();  
        system.assertNotEquals(con.searchResults, null);
        String.valueOf(Crypto.getRandomInteger());
        // search installation with CU number
        con = new Oasis_InstallationSearch_CT();
        con.cuNo = cu.Cable_Unit_No__c;
        con.getListStreetValues();
        con.search();     
        system.assertNotEquals(con.searchResults, null);
        con.getListStreetValues();
        system.assertNotEquals(con.streetsForCU, null);
        con.getListStrikeValues();
        system.assertNotEquals(con.listStrikeValues, null);
        con.getlistErrorTypeLabels();
        system.assertNotEquals(con.listErrorTypeLabels, null); 
        Oasis_InstallationSearch_CT.ViewModel vm = new Oasis_InstallationSearch_CT.ViewModel();
        vm.regCode = 'Tilsluttet Grundpakke';
        vm.installation = installation;
        if(con.searchResults!= null)
            con.searchResults.add(vm);
        con.registerCase();
        Oasis_Utils.CaseCreateParam csparam = new Oasis_Utils.CaseCreateParam();
        csparam.regCode ='Tilsluttet Fuldpakke';
        csparam.installationId = installation.Id;
        Map<String, Case> mapSubCase = new Map<String, Case>();
        mapSubCase = Oasis_Utils.getInstallationCases(new Set<String>{installation.Id});
        Oasis_Utils.createCaseForInstallation(new List<Oasis_Utils.CaseCreateParam>{csparam}, mapSubCase);
        Test.stopTest();
        // get a list of installations reg codes
        con = new Oasis_InstallationSearch_CT();
        system.assertNotEquals(con.getListInstRegCodes(), null);
        // search installtion with CU number & insert case for second installation
        con = new Oasis_InstallationSearch_CT();
        con.cuNo = cu.Cable_Unit_No__c;
        con.search();  
        Oasis_InstallationSearch_CT.ViewModel vm2 = new Oasis_InstallationSearch_CT.ViewModel();
        vm2.regCode = 'Tilsluttet Fuldpakke';
        vm2.installation = installation2;
        con.searchResults.add(vm2);
        con.registerCase();
        con.first();
        con.last();
        con.previous();
        con.next();
        con.changPaging();
        con.getHasNext();
        con.getHasPrevious();
        con.setPageSize(2);
        vm2.cuNo = '';
        vm2.casperAct = false;
        con.addrId = '';
        con.flag = false;
        List<Subscription__c> listSubs = new List<Subscription__c>();
        listSubs.add(sub);
        Oasis_Utils.getAccountInfo(listSubs);
        //Oasis_InstallationSearch_CT con2 = new Oasis_InstallationSearch_CT();
        con.getPageNumber();
        List<SelectOption> ListToSort = new List<SelectOption>();
        ListToSort.add(new SelectOption('test','test'));
        ListToSort.add(new SelectOption('testing','testing'));
        ListToSort.add(new SelectOption('testing1','testing1'));
        ListToSort.add(new SelectOption('test1','test1'));
        con.sortOptionList(ListToSort);
        // get a list of installations with customers
        //con = new Oasis_InstallationSearch_CT();
        //Set<String> listInstallationIds = Oasis_InstallationSearch_CT.getInstallationWithoutCustomers(new List<String>{installation.INSTALLATION_ID__c}); 
        //system.assertEquals(listInstallationIds.isEmpty(), true);
    } 
    
    //Test mehtod for Oasis Site Template
    static testmethod void test_Oasis_SiteTemplate_CT()
    {
        setupCustomSettings(); 
        PageReference pageRef = Page.oasis_SiteLogin;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Oasis_SiteTemplate_CT ost = new Oasis_SiteTemplate_CT();
        Oasis_SiteLogin_CT con = new Oasis_SiteLogin_CT();
        con.email = 'test@email.com';
        con.password = 'password';
        con.login();
        ost.onPageLoad();
        ost.logout();
        Test.setCurrentPage(Page.Oasis_InstallationSearch2);
        ost.onPageLoad();
        Test.stopTest();
    }
    
    static testmethod void test_Oasis_partyActorSearch_CT()
    {
        Test.startTest();
        setupCustomSettings(); 
        Product__c prod = setDummyProduct();
        Address__c addr = setupDummyAddress();
        //Cable_Unit__c cu = setupCableUnit();
        Cable_Unit__c cu = setupCableUnit1();
        Lookup_Customer_Segment__c customerSegmentObj = setupLookupCustomerSegment();
        Account a = setupDummyCableUnitAccount(cu, customerSegmentObj, addr);
        Contact c =  setupDummyContact(a, addr);
        Lookup_Contact_Roles__c comR = contactRole();
        Account_Contact_Role__c accC = setupAccConRole(a,c,comR);
        Account_Contact_Role__c accC1 = setupAccConRole(a,c,comR);
        //Account_Contact_Role__c accc = [select id from Account_Contact_Role__c order by createddate desc LIMIT 1];
        //system.debug('******** Account Role '+accc);
        //Cable_Unit__c csu = setupCableUnit1();
        Oasis_PartyActorSearch_CT oCT = new Oasis_PartyActorSearch_CT();
        oCT.cable_unit_No = '0000123456';
        oCT.searchPartyActors();
        //accC.Contact__c = null;
        // update accC;
        //oCT.searchPartyActors();
        Oasis_PartyActorSearch_CT.ViewpartyActor view = new Oasis_PartyActorSearch_CT.ViewpartyActor(); 
        Test.stopTest();
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // TEST DATA SETUP METHODS START HERE
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
    
    static void setupCustomSettings()
    {
        
        Profile[] testProfile = [Select p.name, p.id From Profile p where p.Name =: 'YouSee Foreningsservice User'];        
        
        
        YouSeeCustomSettings__c  ycSettings = new YouSeeCustomSettings__c();
        ycSettings.Name = 'No_case_assignment_customerinformation';
        ycSettings.Setting_Value__c = testProfile[0].ID;
        insert ycSettings;
        
        YSRecordTypes__c r=new YSRecordTypes__c();
        r.Name='YSRecordTypes';
        r.YS_Contact_Record_Type__c='012D0000000BD3N';
        insert r;  
        
        Oasis_Case_Assignment__c oac = new Oasis_Case_Assignment__c();
        oac.Name = 'Reg, Korrekt';
        oac.Case_Dept__c = 'CCE';
        oac.Case_Product__c = 'TV CCE';
        oac.Case_Type_Task__c = 'Gratisseer';
        oac.For__c = 'Installation';
        insert oac;
        
        oac = new Oasis_Case_Assignment__c();
        oac.Name = 'Default';
        oac.Case_Dept__c = 'CCE';
        oac.Case_Product__c = 'TV CCE';
        oac.Case_Type_Task__c = 'Gratisseer';
        oac.For__c = '';
        insert oac;
        
        oac = new Oasis_Case_Assignment__c();
        oac.Name = 'Tilsluttet Grundpakke';
        oac.Case_Dept__c = 'CCE';
        oac.Case_Product__c = 'TV CCE';
        oac.Case_Type_Task__c = 'Gratisseer';
        oac.For__c = 'Installation';
        insert oac;
        
        oac = new Oasis_Case_Assignment__c();
        oac.Name = 'Tilsluttet Fuldpakke';
        oac.Case_Dept__c = 'CCE';
        oac.Case_Product__c = 'TV CCE';
        oac.Case_Type_Task__c = 'Gratisseer';
        oac.For__c = 'Installation';
        insert oac;
        
        Oasis_Error_Type_Codes__c oet = new Oasis_Error_Type_Codes__c();
        oet.Name = 'Indbrud i skab m. låsemodstand';
        oet.Error_Type_Code__c = '1';
        oet.Error_Type_Label__c = 'Indbrud i skab m. låsemodstand';
        insert oet;  
        
        Oasis_User__c oUser = New Oasis_User__c();
        oUser.Oasis_User_Name__c = 'testDataUser';  
        oUser.Oasis_User_Password__c = 'password';
        oUser.Oasis_User_Email__c = 'test@email.com';
        oUser.Oasis_mId__c = 'M99887';
        insert oUser;
        
        Oasis_String_Values__c prod = new Oasis_String_Values__c();
        prod.Name = 'Tilsluttet Grundpakke';
        prod.Value__c = 'Tilsluttet Grundpakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Tilsluttet Mellempakke';
        prod.Value__c = 'Tilsluttet Mellempakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Tilsluttet Fuldpakke';
        prod.Value__c = 'Tilsluttet Fuldpakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Lille Tillægspakke';
        prod.Value__c = 'Lille Tillægspakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Tillægspakke';
        prod.Value__c = 'Tillægspakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Grundpakke';
        prod.Value__c = 'Grundpakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Mellempakke';
        prod.Value__c = 'Mellempakke';
        insert prod;
        
        prod = new Oasis_String_Values__c();
        prod.Name = 'Fuldpakke';
        prod.Value__c = 'Fuldpakke';
        insert prod;   
    }
    public static Address__c setupDummyAddress()
    {
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        //addr.HouseNumber__c = '';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        addr.External_Id__c='22345678';
        insert addr;
        return addr;
    }
    
    public static Address__c setupDummyAddress2()
    {
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '8660';
        addr.Door_No__c = 'TV';
        //addr.Side__c = 'A';
        addr.Floor__c = 'ST';
        addr.House_No__c = '9';
        addr.Street__c = 'AHKastanievej';
        addr.Entrance__c = 'B';
        addr.External_Id__c='67894522';
        insert addr;
        return addr;
    }
    
    public static Account setupDummyAccount()
    {
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                   where sObjectType='Account' and isActive=true 
                                   and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;
        Account newDummyAccount = new Account(Name='Oasis Test Account', 
                                              Dummy_Account__c=true,
                                              Dummy_Account_Allocation_Complete__c=false,
                                              Customer_No__c='OASIS DUMMY ACCOUNT',
                                              Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(),
                                              RecordTypeId=YSCustomerRecordTypeId);
        Database.SaveResult result = Database.insert(newDummyAccount);
        return newDummyAccount;     
    }
    
    public static Lookup_Customer_Segment__c setupLookupCustomerSegment(){
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        return customerSegmentObj;          
    }
    
    public static Account setupDummyCableUnitAccount(Cable_Unit__c cableUnit, Lookup_Customer_Segment__c customerSegmentObj, Address__c addr)
    {
        String YSCustomerRecordTypeId;
        List<RecordType> rtypes = [Select Name, Id From RecordType
                                   where sObjectType='Account' and isActive=true 
                                   and DeveloperName = 'YS_Customer_Account'];
        if(!rtypes.isEmpty())
            YSCustomerRecordTypeId = rtypes[0].id;                                          
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = YSCustomerRecordTypeId);
        account.Cable_Unit__c = cableUnit.Id;  
        account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        //account.AddressId__c = addr.Id;
        account.Billing_Address__c = addr.Id;
        insert account;
        return account;
        
    }
    
    public static Contact setupDummyContact(Account acc, Address__c addr)
    {
        RecordType record = [select Id,Name from RecordType where Name like 'YS Contact Layout' limit 1];
        Contact contact = new Contact(); 
        contact.AccountId = acc.Id;     
        contact.FirstName = 'TestContactFirstname';
        contact.LastName = 'TestContactLastname';
        contact.Email = 'test.TestClase@test1.com';
        contact.Phone = '2222221';
        contact.MobilePhone = '3333331';
        contact.HomePhone = '4444441';
        //contact.HierarchyAccount__c = acc.id;
        contact.Street_P__c = addr.Id;
        //contact.KissPartyId__c = 'KAS.P2---4015110456';
        //contact.Enable_Customer_Portal_User__c = false;
        contact.RecordTypeId = record.Id;
        insert contact;
        return contact;       
    }
    static Lookup_Contact_Roles__c contactRole()
    {
        Lookup_Contact_Roles__c con = new Lookup_Contact_Roles__c();
        con.Code__c = 'Test';
        con.End_Date__c = Date.today()+5;
        con.Start_Date__c = Date.today();
        insert con;
        return con;
    }
    static Customer_Log__c setupCustomerLog()
    {
        Customer_Log__c customerLog =new Customer_Log__c();
        customerLog.Text__c='Test' ;
        customerLog.User_Name__c='Kim Tombak';
        customerLog.User_MID__c='A64965';
        customerLog.Inquiry_Type__c='1';
        customerLog.Date__c=Date.today();
        insert customerLog;
        return customerLog;
    }
    static Account_Contact_Role__c setupAccConRole(Account acc,Contact con,Lookup_Contact_Roles__c consR)
    {
        String roleName = 'Role' + String.valueOf(Crypto.getRandomInteger());
        Lookup_Contact_Roles__c role = new Lookup_Contact_Roles__c(Name = roleName, Start_Date__c = Date.valueOf('2011-01-01'),
                                                                   End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = String.valueOf(Crypto.getRandomInteger()),
                                                                   Code__c = roleName );
        insert role;        
        
        KISS_Role_Validation_Rules__c rule = new KISS_Role_Validation_Rules__c( Name = roleName,
                                                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role.Id );
        insert rule; 
        
        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = acc.Id, 
                                        Contact__c = con.Id,                                       
                                        Role__c = role.Id); 
        //Insert fake-KISS-ID to bypass validation. We dont have time to wait for Cast iron update (ex. 4 secs)
        acr.ContactRoleExternalID__c = acr + String.valueOf(Crypto.getRandomInteger());
        insert acr;
        return acr;
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
    static Cable_Unit__c setupCableUnit1()
    {
        Lookup_Post_Code__c postcodeLookup;
        String postcode = '2000';
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
        return cableUnitTest;
    }
    
    static Net_Installations__c setupDummyInstallation(Address__c addr, Cable_Unit__c cu)
    {
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = addr.id;
        installation.Address__c = addr.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.INSTALLATION_ID__c = '123456';
        installation.Move_Flag__c = true;
        insert installation;
        return installation;
    }
    
    static Net_Installations__c setupDummyInstallation2(Address__c addr, Cable_Unit__c cu)
    {
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = addr.id;
        installation.Address__c = addr.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.INSTALLATION_ID__c = '456789';
        insert installation;
        return installation;
    }
    
    static Subscription__c setupDummySubscription(Net_Installations__c installation)
    {
        Product__c Prod = new Product__c(Name='TestProduct', Product_ID__c = '1101101');
        insert Prod;
        Subscription__c subscription = new Subscription__c(Product__c = Prod.id, 
                                                           Net_Installation__c = installation.id, 
                                                           Requested_End_Date__c = system.today(), 
                                                           Requested_Start_Date__c = system.today(),
                                                           installation_id__c = installation.INSTALLATION_ID__c, 
                                                           Address__c = '1234');
        insert subscription;
        return subscription;
    }
    
    static Customer_Installation_Address__c setupDummyCustomerInstallationAddress(Account acc, Address__c addr, Net_Installations__c inst)
    {
        Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
        cia.Address__c=addr.Id;
        cia.Customer__c=acc.Id;
        cia.Installation_Address_External_ID__c='12121';
        cia.Active_Sub__c = true;
        cia.Installation_ID__c = inst.installation_id__c;
        insert cia;
        return cia;
    }
    static Customer_Installation_Address__c setupDummyCustomerInstallationAddress2(Account acc, Address__c addr, Net_Installations__c inst)
    {
        Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
        cia.Address__c=addr.Id;
        cia.Customer__c=acc.Id;
        cia.Installation_Address_External_ID__c='12122';
        cia.Active_Sub__c = true;
        cia.Installation_ID__c = inst.installation_id__c;
        insert cia;
        return cia;
    }
    static Customer_Subscription__c setupDummyCustomerSubscription(Address__c addr, Net_Installations__c inst,Product__c prod)
    {
        System.debug('*****Prod******'+prod);
        Customer_Subscription__c cs = new Customer_Subscription__c();
        cs.Address__c = addr.Id;
        cs.Product__c = prod.Id;
        //cs.Product__r.Name = prod.Name;
        cs.Installation_Id__c = inst.installation_id__c;
        insert cs;
        return cs;
    }
    
    static Customer_Subscription__c setupDummyCustomerSubscription_customer(Address__c addr, Net_Installations__c inst,Product__c prod, String custNumb)
    {
        System.debug('*****Prod******'+prod);
        Customer_Subscription__c cs = new Customer_Subscription__c();
        cs.Address__c = addr.Id;
        cs.Product__c = prod.Id;
        //cs.Product__r.Name = prod.Name;
        cs.Installation_Id__c = inst.installation_id__c;
        cs.Customer_Number__c = custNumb;
        insert cs;
        return cs;
    }
    
    static Product__c setDummyProduct(){
        Product__c prod = new Product__c();
        prod.Name = 'Lille Tillægspakke';
        prod.Product_ID__c = '12345';
        insert prod;
        return prod;
    }
    static Product__c setDummyProduct1(){
        Product__c prod = new Product__c();
        prod.Name = 'Bland Selv';
        prod.Product_ID__c = '12345';
        insert prod;
        return prod;
    }
    static List<Oasis_Case__c> createOasisCases(){
        List<Oasis_Case__c> listOcases = new List<Oasis_Case__c>();
        Oasis_Case__c  oCase = new Oasis_Case__c ();
        oCase.Oasis_Inst_Case_Registration_Code__c='Tilsluttet Grundpakke';
        oCase.Oasis_Strike__c='Strike 1';
        oCase.Oasis_CU_No__c='0005016294';
        oCase.Oasis_Freeviewer__c=true;
        listOcases.add(oCase);
        oCase = new Oasis_Case__c ();
        oCase.Oasis_Inst_Case_Registration_Code__c='Tilsluttet Fuldpakke';
        oCase.Oasis_Strike__c='Strike 2';
        oCase.Oasis_CU_No__c='0005014147';
        oCase.Oasis_Freeviewer__c=false; 
        listOcases.add(oCase);
        oCase = new Oasis_Case__c ();
        oCase.Oasis_Inst_Case_Registration_Code__c='Tilsluttet Fuldpakke';
        oCase.Oasis_Strike__c='Strike 1';
        oCase.Oasis_CU_No__c='0001043860';
        oCase.Oasis_Freeviewer__c=false;
        listOcases.add(oCase);
        oCase = new Oasis_Case__c ();
        oCase.Oasis_Inst_Case_Registration_Code__c='Husnr. forkert';
        oCase.Oasis_Strike__c='Strike 1';
        oCase.Oasis_CU_No__c='0005016294';
        oCase.Oasis_Freeviewer__c=false;
        listOcases.add(oCase);
        insert listOcases;
        return listOcases;
    }

    // test method for installation Search controller
    static testmethod void test_Oasis_InstallationSearch_CT_singleKunde()
    {
        // setup data
        setupCustomSettings(); 
        Product__c prod = setDummyProduct();
        Address__c addr = setupDummyAddress2();
        Cable_Unit__c cu = setupCableUnit();
        Lookup_Customer_Segment__c customerSegmentObj = setupLookupCustomerSegment();
        Account a = setupDummyCableUnitAccount(cu, customerSegmentObj, addr);
        Net_Installations__c installation = setupDummyInstallation(addr, cu);
        Subscription__c sub = setupDummySubscription(installation);
        Customer_Installation_Address__c cia = setupDummyCustomerInstallationAddress(a, addr, installation);
        Customer_Subscription__c cs = setupDummyCustomerSubscription_customer(addr, installation, prod,a.Customer_No__c);
        Address__c add = new Address__c();
        add.House_No__c='10';
            //add.HouseNumber__c=11;
        Test.startTest();
        Oasis_InstallationSearch_CT con;
        // search installation with Address
        con = new Oasis_InstallationSearch_CT();
        con.custNumber = a.Customer_No__c;
        /* instList.add(installation);
        con.stdSetController = new ApexPages.StandardSetController(instList); */
        con.searchWrapper();
        Test.stopTest();

    }   
}