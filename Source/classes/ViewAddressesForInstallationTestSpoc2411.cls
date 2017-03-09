@isTest(SeeAllData = true)
private class ViewAddressesForInstallationTestSpoc2411 {
    
    public static Cable_Unit__c cu;
    public static Account account;
    public static List<cInstallation> listcInst;
    public static List<id> instID;
    public static void init(){
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        instID = new List<id>();
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
        cu.Loop__c = 'T';
        cu.Cable_Type__c = 'Coax';
        insert cu;
          
        account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert account;
        
        List<Address__c> addressLst = new List<Address__c>();
        List<Net_Installations__c> netInstallationList = new List<Net_Installations__c>();
        
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
        
        
        //added for Bland selv phase 2b
        Address__c addr4 = new Address__c();
        addr4.Name='Vashi 1';
        addr4.House_No__c='14';
        addr4.Postcode__c='1100';
        addr4.Floor__c='7';
        addr4.Active__c = true;
        addr4.External_Id__c = '58852';
        insert addr4;
        
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr1.id;
        installation.Cable_Unit__c = cu.Id;
        installation.Start_Date__c=date.today();
        installation.AddressId_InstLbnr__c = '1';
        insert installation;
        
        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123a';
        installation1.Address__c = addr2.id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.Start_Date__c=date.today();
        installation1.AddressId_InstLbnr__c = '1';
        insert installation1;

        Net_Installations__c installation2 = new Net_Installations__c();
        installation2.Address_Id__c = 'add123a';
        installation2.Address__c = addr3.id;
        installation2.Cable_Unit__c = cu.Id;
        installation2.Start_Date__c=date.today();
        installation2.AddressId_InstLbnr__c = '1';
        insert installation2;           
        
        
        //added for bland selv phase 2b
        
        
        Net_Installations__c installation3 = new Net_Installations__c();
        installation3.Address_Id__c = 'add123a';
        installation3.Address__c = addr4.id;
        installation3.Cable_Unit__c = cu.Id;
        installation3.AddressId_InstLbnr__c = '1';
        installation3.Installation_Status_Code__c='1';
        installation3.Start_Date__c=date.today();
        installation3.isBadPayee__c=true;
        insert installation3;   
        
        Product__c product = new Product__c();
        product.Name = 'Fuldpakke';
        product.Product_ID__c = '1101201';
        insert product;
        
        Product__c product1 = new Product__c();
        product1.Name = 'Mellempakke';
        product1.Product_ID__c = '1101101';
        insert product1;
        
        Product__c product2 = new Product__c();
        product2.Name = 'Grundpakke';
        product2.Product_ID__c = '1101001';
        insert product2;
        
        
        //Added for bland selv phase 2
        
        Product__c product3 = new Product__c();
        product3.Name = 'Fuldpakke med Bland Selv';
        product3.Product_ID__c = '1101204';
        insert product3;
        
        
        
        Order__c o1 = new Order__c();
        o1.packageBeforeChange__c = product2.Name;
        o1.cableUnitName__c = cu.Name;
        o1.cableUnitNumber__c = cu.Cable_Unit_No__c;
        o1.Product_No__c = product2.Product_ID__c;
        o1.Product_Name__c = product1.Product_Name__c;
        o1.Net_Installation__c = installation2.id;
        o1.Address_Id__c = addr3.Id;
        insert o1;
        
        //Select s.Net_Installation__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, s.Product__r.Name, s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today()
        
        Subscription__c subscription = new Subscription__c();
        subscription.Subscription_No__c = '841119859';
        Integer d = 01;
        Integer m = 01;
        Integer y = 2004;
        date eDate = date.newInstance(y,m,d);
        subscription.Start_Date__c = eDate;
        subscription.Product__c = product.id;
        subscription.Net_Installation__c = installation.id;
        subscription.Address__c = installation.Address__r.External_Id__c;
        subscription.Installation_Id__c = installation.AddressId_InstLbnr__c;
        insert subscription;
        
        Subscription__c subscription1 = new Subscription__c();
        subscription1.Subscription_No__c = '841119860';
        subscription1.Start_Date__c = eDate;
        subscription1.Product__c = product1.id;
        subscription1.Net_Installation__c = installation1.id;
        subscription1.Address__c = installation1.Address__r.External_Id__c;
        subscription1.Installation_Id__c = installation1.AddressId_InstLbnr__c;
        insert subscription1;
        
        Subscription__c subscription2 = new Subscription__c();
        subscription2.Subscription_No__c = '841119861';
        subscription2.Start_Date__c = eDate;
        subscription2.Product__c = product2.id;
        subscription2.Net_Installation__c = installation2.id;
        subscription2.Address__c = installation2.Address__r.External_Id__c;
        subscription2.Installation_Id__c = installation2.AddressId_InstLbnr__c;
        insert subscription2;
        
        
        //Added for bland selv phase 2 b
        
        Subscription__c subscription3 = new Subscription__c();
        subscription3.Subscription_No__c = '841119869';
        subscription3.Start_Date__c = date.today()-1;
        subscription3.Product__c = product3.id;
        subscription3.Net_Installation__c = installation3.id;
        subscription3.Address__c = installation3.Address__r.External_Id__c;
        subscription3.Installation_Id__c = installation3.AddressId_InstLbnr__c;
        insert subscription3;
        
        instID.add(installation.id);
        instID.add(installation1.id);
        instID.add(installation2.id);
        instID.add(installation3.id);
        cInstallation cInst = new cInstallation(installation,subscription2);
        cInstallation cInst2 = new cInstallation(installation3,subscription3);
        listcInst = new List<cInstallation>();
        listcInst.add(cInst); 
        listcInst.add(cInst2);
        
    }
    
    @isTest
    public static void testInstallations(){
        init();

        PageReference pageRef = Page.ViewAddressesForInstallationsPage2411;
        Test.setCurrentPageReference(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber', cu.Cable_Unit_No__c);
        Test.startTest();
        ViewAddressesForInstallationsController2 controller = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController.FORCE_TEST_MODE = true;
        String tempPageSize = '10';
        PagingController paging = new PagingController();
        paging.pageController = controller.getThis();
        paging.setPageSize(tempPageSize);
        paging.changPaging();
        paging.getAllRecords();
        paging.getRequirePageChange();
        paging.first();
        paging.last();
        paging.previous();
        paging.next();
        paging.getHasPrevious();
        paging.getHasNext();
        
        controller.getWrapperMap();
        controller.pagingComponent = paging;
        controller.cableUnitName = cu.Name;
        controller.cableUnitNumber = cu.Cable_Unit_No__c;
        List<SelectOption> selectopts = controller.getItems();
        controller.installationList = controller.getInstallationList();
        controller.installationList[0].isBadPayee = false;
        controller.addAsBadPayee();
        controller.backToViewAddressInstallationPage();
        controller.finalSelectedListInstallationMap.put(controller.installationList[0].installation.Id,controller.installationList[0]);
        controller.setSelectedInstallations();
        controller.installationList[0].selected = true;
        controller.getSelectedSubscriptionForAddresses();
        controller.setSelectedInstallations();
        controller.searchValues = 'Alle adresser';
        controller.searchHsNoText = '2';
        
        //controller.search();//EDM-756
        controller.installationList = controller.getInstallationList();
        //controller.installationList.get(0).selected = true;

        controller.displayTvPackages();
        controller.changeTvPackage();
        controller.getSelectListALL();
        //controller.getItemsDropDown();
        controller.getPackageItems();
        controller.getInstallationOfferingList();
        controller.confirmTvPackage();
        controller.setConfirmedInstallations();
        //controller.displaySelectedDate();
        controller.getConfirmedInstallations();
        controller.finalInstallations = new List<cInstallation>();
        controller.finalInstallations.addAll(controller.installationList);
        cInstallation.cProducts pi = new cInstallation.cProducts();
        pi.prodName = 'Mellempakke';
        pi.productNo = '1101101';
        pi.mediaType = 'test';
        pi.sortering = '112-220';
        pi.href = 'test';
        controller.finalInstallations[0].tvpackage = 'Mellempakke';
        controller.finalInstallations[0].productsList = new List<cInstallation.cProducts>();
        controller.finalInstallations[0].productsList.add(pi);
       // controller.placeOrderForPackageChange();
 
        controller.callToCastIron();
        controller.backToViewInstallation();
        controller.backToChangeTvPackagesPage();
        controller.viewInstallationHistory();
        
        controller.exportAddressesToExcel();
        controller.getListExport();
        controller.getListExportBS();

        controller.displaySelectedValue();      
        controller.callMethodsForTestClasses(); 
        
        controller.addressSearch = null;
        controller.fetchAddresses();
        controller.installationList = null;
        controller.displayTvPackages();
        controller.cableUnitNumber = null;
        controller.getItems();
        
        controller.searchValues = 'test()';
        controller.searchHsNoText = '2';
        //controller.search();//EDM-756
        
        controller.searchValues = 'test';       
        controller.searchHsNoText = '2';
        //controller.search();//EDM-756
        
        //Added for bland selv phase 2b
        controller.searchValues = 'Alle adresser';
        controller.BSsearchValues='BlandSelv';
        controller.searchHsNoText = '14';
        //controller.search();//EDM-756
        
        controller.searchValues = 'Alle adresser';
        controller.BSsearchValues='BlandSelv';
        controller.addressSearch='test';
        //controller.search();//EDM-756
        controller.fetchAddresses();
        
        controller.searchValues = 'test';
        controller.BSsearchValues='BlandSelv';
        //controller.search();//EDM-756
        controller.fetchAddresses();
        String enkelcustinfo='<?xml version="1.0" encoding="UTF-8"?><rows><row>'+
      '<CUSTOMERID>612121367</CUSTOMERID>'+
      '<FIRSTNAME>BRITTA</FIRSTNAME>'+
      '<LASTNAME>PULTZ</LASTNAME>'+
      '<SUBSCRIPTION><![CDATA[YouSee Kort]]></SUBSCRIPTION>'+
      '<ACTIVE>1</ACTIVE>'+
      '<BILLINGSTART>2009-09-16T00:00:00.000</BILLINGSTART>'+
      '<BILLINGEND xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>'+
      '<BUSINESS_GROUP>Digitalt kabel-tv</BUSINESS_GROUP>'+
      '<AMSADDRESSID>58852</AMSADDRESSID>'+
      '<INSTALLATIONSEQ>1026174</INSTALLATIONSEQ>'+
      '<CABLEUNIT>0002000299</CABLEUNIT>'+
      '<EMAIL>brittapultz@yahoo.dk</EMAIL>'+
      '<CUSTOMERTYPE>0</CUSTOMERTYPE>'+
      '</row></rows>';
      ViewAddressesForInstallationsController2.installationIdStr='58852';
      ViewAddressesForInstallationsController2.getEnkelInformation();
        ViewAddressesForInstallationsController2.parseProducts(enkelcustinfo);
        //BS list
        String exportres='<?xml version="1.0" encoding="UTF-8"?>'+
'<objects xmlns="urn:sobject.partner.soap.sforce.com">'+
   '<Subscription__c>'+
      '<Id xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">a23M00000019KGuIAM</Id>'+
      '<Net_Installation__r xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
         '<Address__r>'+
            '<Street__c>Ringparken</Street__c>'+
            '<House_No__c>32</House_No__c>'+
            '<Floor__c>1</Floor__c>'+
            '<Entrance__c xsi:nil="true"/>'+
           '<Door_No__c>MF</Door_No__c>'+
            '<Postcode__c>7500</Postcode__c>'+
            '<Town__c>Holstebro</Town__c>'+
         '</Address__r>'+
         '<Location__c xsi:nil="true"/>'+
         '<Start_Date__c>2001-07-01T00:00:02.000Z</Start_Date__c>'+
         '<Installation_Status_Code__c>1</Installation_Status_Code__c>'+
         '<Name>5457550</Name>'+
         '<INSTALLATION_ID__c>49138</INSTALLATION_ID__c>'+
      '</Net_Installation__r>'+
      '<Net_Installation__c xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">a1xM0000001mDKVIA2</Net_Installation__c>'+
      '<Start_Date__c xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">2013-11-01</Start_Date__c>'+
      '<Product__r xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
         '<Name>Fuldpakke med Bland Selv</Name>'+
      '</Product__r>'+
      '<CUSTOMERID xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">605264739</CUSTOMERID>'+
      '<FIRSTNAME xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">FREDDIE</FIRSTNAME>'+
      '<LASTNAME xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">PEDERSEN</LASTNAME>'+
      '<SUBSCRIPTION xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">YouSee Kort</SUBSCRIPTION>'+
      '<ACTIVE xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">1</ACTIVE>'+
      '<BILLINGSTART xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">2009-12-01T00:00:00.000</BILLINGSTART>'+
      '<BILLINGEND xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>'+
      '<BUSINESS_GROUP xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Digitalt kabel-tv</BUSINESS_GROUP>'+
      '<AMSADDRESSID xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">5457550</AMSADDRESSID>'+
      '<INSTALLATIONSEQ xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">49138</INSTALLATIONSEQ>'+
      '<EMAIL xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">frede_fup1@hotmail.com</EMAIL>'+
   '</Subscription__c>'+
   '<Subscription__c>'+
      '<Id xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">a23M00000019KHoIAM</Id>'+
      '<Net_Installation__r xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
         '<Address__r>'+
            '<Street__c>Ringparken</Street__c>'+
            '<House_No__c>44</House_No__c>'+
            '<Floor__c>2</Floor__c>'+
            '<Entrance__c xsi:nil="true"/>'+
            '<Door_No__c>TH</Door_No__c>'+
            '<Postcode__c>7500</Postcode__c>'+
            '<Town__c>Holstebro</Town__c>'+
         '</Address__r>'+
         '<Location__c xsi:nil="true"/>'+
         '<Start_Date__c>2001-07-01T00:00:02.000Z</Start_Date__c>'+
         '<Installation_Status_Code__c>1</Installation_Status_Code__c>'+
         '<Name>5457647</Name>'+
         '<INSTALLATION_ID__c>49185</INSTALLATION_ID__c>'+
      '</Net_Installation__r>'+
      '<Net_Installation__c xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">a1xM0000001mDLQIA2</Net_Installation__c>'+
      '<Start_Date__c xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">2013-11-01</Start_Date__c>'+
      '<Product__r xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
         '<Name>Fuldpakke med Bland Selv</Name>'+
      '</Product__r>'+
      '<CUSTOMERID xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">606212656</CUSTOMERID>'+
      '<FIRSTNAME xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">TOMMY</FIRSTNAME>'+
      '<LASTNAME xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">RØNN SØRENSEN</LASTNAME>'+
      '<SUBSCRIPTION xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">YouSee Kort</SUBSCRIPTION>'+
      '<ACTIVE xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">1</ACTIVE>'+
      '<BILLINGSTART xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">2009-10-01T00:00:00.000</BILLINGSTART>'+
      '<BILLINGEND xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>'+
      '<BUSINESS_GROUP xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Digitalt kabel-tv</BUSINESS_GROUP>'+
      '<AMSADDRESSID xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">5457647</AMSADDRESSID>'+
      '<INSTALLATIONSEQ xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">49185</INSTALLATIONSEQ>'+
      '<EMAIL xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">tomsen@webspeed.dk</EMAIL>'+
   '</Subscription__c></objects>';
   
        controller.exportAddressesToExcelBS();
        controller.getListofBS();
        controller.getListExportBS();
        ViewAddressesForInstallationsController2.emailSTR='namita.patil@cg.com';
        ViewAddressesForInstallationsController2.customerName='Namita Patil';
        ViewAddressesForInstallationsController2.parseBSList(exportres);
       // controller.isBadPayee=true;
       // ViewAddressesForInstallationsController.BadPayeeCalloutXmlResponse='{"InputRecords":"1","Updatedrecords":"1"}';
        //controller.addAsBadPayee();
        controller.wrapperMap = null;
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = True;
        controller.parseInstallationHistoryXML('32132', new List<cInstallation>());
        list<string> installationIds = new List<string>();
        installationIds.add('test');
        
        string ParseResponse = '<?xml version="1.0"  encoding="UTF-8"?>'+
                    '<Installation_List>'+
                    '<Installation_Record>'+
                    '<Address_Id>58852</Address_Id>'+ 
                    '<Installation_Lbnr>1</Installation_Lbnr>'+
                    '<Error>'+
                    '<Error_Code></Error_Code>'+ 
                    '<Error_Message></Error_Message>'+ 
                    '</Error>'+
                    '<Existing_products>'+
                    '<Navn>Fuldpakke</Navn>'+
                    '<Sortering>11-01-0030</Sortering>'+
                    '<Varenr>1101201</Varenr>'+
                    '</Existing_products>'+
                    '<Product_list>'+
                    '<Product_Record>'+
                    '<Product_Name>Grundpakke</Product_Name>'+
                    '<Product_Number>1101001</Product_Number>'+ 
                    '<Href>yahoo.com</Href>'+ 
                    '<Mediatype>tv</Mediatype>'+ 
                    '<sortering>11-01-0011</sortering>'+ 
                    '</Product_Record>'+
                    '<Product_Record>'+
                    '<Product_Name>Fuldpakke</Product_Name>'+ 
                    '<Product_No>1101201</Product_No>'+
                    '<Href>lmn</Href>'+ 
                    '<Mediatype>teliphony</Mediatype>'+ 
                    '<sortering>11-01-0015</sortering>'+ 
                    '</Product_Record>'+
                    '</Product_list>'+
                    '<Nybeboer_product>'+
                    '<Href>http://preprod-kasia.yousee.dk/afsaetning/opdater/-849407049/1119008</Href>'+ 
                    '<Mediatype>vnd.yousee.kasia2.afsaetning+json;version=1;charset=UTF-8</Mediatype>'+ 
                    '</Nybeboer_product>'+
                    '<Nybeboer_product>'+
                    '<Href>http://preprod-kasia.yousee.dk/afsaetning/opdater/-849407049/1112001</Href>'+ 
                    '<Mediatype>vnd.yousee.kasia2.afsaetning+json;version=1;charset=UTF-8</Mediatype>'+ 
                    '</Nybeboer_product>'+
                    '<Kunde_Data>aaaa </Kunde_Data>'+  
                    '<Array_Init />'+ 
                    '<Etag/>'+ 
                    '</Installation_Record>'+
                    '</Installation_List>';
        
        
        //controller.parseXMLResponse(exportres,installationIds);
        controller.parseXMLResponse(ParseResponse,instID); 
        
        controller.createInstallationHistoryReqXML(null);
        controller.installationList = null; 
        controller.viewInstallationHistory();
        
        controller.clearProductMap = null;
        controller.getPackageItems();
        controller.checkValidateNewResident();
        controller.displaySelectedDate();
        controller.callKasiaForChangedDates();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
        controller.setConfirmedInstallations();
        string datecheck = string.valueof(date.today());
        controller.parseInstallationDate(datecheck);
        Test.stopTest();
    }
    
    
    static testMethod void testforblandselv(){
      init();

        PageReference pageRef = Page.ViewAddressesForInstallationsPage2411;
        Test.setCurrentPageReference(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber', cu.Cable_Unit_No__c);
        Test.startTest();
        ViewAddressesForInstallationsController2 controller = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
        controller.setConfirmedInstallations();

        controller.getInstallationList();
        controller.setSelectedPackages();
        controller.setSelectedInstallations();
        //controller.search();//EDM-756
        ViewAddressesForInstallationsController2.parseProducts('<?xml version="1.0" encoding="UTF-8"?><objects xmlns="urn:sobject.partner.soap.sforce.com"><Subscription__c>');
        ViewAddressesForInstallationsController2.parseBSList('<?xml version="1.0" encoding="UTF-8"?><objects xmlns="urn:sobject.partner.soap.sforce.com"><Subscription__c>');
        Test.stopTest();
    
    }
    static testMethod void testforaddasbadpayee(){
      init();

        PageReference pageRef = Page.ViewAddressesForInstallationsPage2411;
        Test.setCurrentPageReference(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber', cu.Cable_Unit_No__c);
        Test.startTest();
        ViewAddressesForInstallationsController2 controller = new ViewAddressesForInstallationsController2();
        controller.pagingComponent = new PagingController();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
        controller.installationList = controller.getInstallationList();
        controller.isBadPayee=false; 
        //controller.set_existingBadPayee = new Set<Id>{controller.installationList[0].installation.Id};
        controller.addAsBadPayee();
        controller.isBadPayee=true;
        controller.installationList = new List<cInstallation>();
        listcInst[0].isBadPayee = true;
        controller.installationList.addAll(listcInst);
        //controller.set_existingBadPayee.add(listcInst[0].installation.Id);
        controller.addAsBadPayee();
        ViewAddressesForInstallationsController2.BadPayeeCalloutXmlResponse='{"InputRecords":"1","Updatedrecords":"1"}';
        
        Test.stopTest();
    
    }
    static testMethod void testforblandselvnoinstallations(){
      init();

        PageReference pageRef = Page.ViewAddressesForInstallationsPage2411;
        Test.setCurrentPageReference(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber','123456789');
        Test.startTest();
        ViewAddressesForInstallationsController2 controller = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
        controller.searchHsNoText='';
        controller.addressSearch='test';
        controller.fetchAddresses();
        Test.stopTest();
    
    }
    
    static testMethod void unitTestForInstallation(){
        Test.startTest();
        List<String> tempList1;
        List<String> tempList2;
        ViewAddressesForInstallationsController2 tempCont = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
     //   tempCont.tempFlag = true;
        tempCont.getInstallationList();
        tempCont.fetchAddresses();
        tempCont.getItems();
        tempCont.getListExport();
        //tempCont.generateRequestAndResponse(tempList1,tempList2);
        tempCont.getPackageItems();
        tempCont.confirmTvPackage();
        Test.stopTest();
    
    }
    
    static testMethod void testAddInstallations(){
        
        SalesConcept__c salesConObj = new SalesConcept__c();
        salesConObj.Solution__c = 'Indholdsbeskrivelse mangler';
        salesConObj.TVandRadio__c = 1 ;
        salesConObj.Broadband__c = 0 ;
        salesConObj.Telephony__c = 1 ;
        salesConObj.SC_Source_Id__c = 'OAS';
        insert salesConObj;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj.Name = 'A:6000545:201134';
        oppObj.StageName = 'Potentiel';
        oppObj.CloseDate = Date.valueOf('2014-03-03');
        insert oppObj;
        
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
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        //addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        acc.Street_YK__c = addr.Id; 
        acc.Street_YK__r = addr;
        insert acc; 
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = '0000005566';
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Current_Kiss_Case__c = oppObj.Id;
        cableUnitTest.Status__c = 'Running';
        Date myDate = date.newinstance(2013, 2, 17);
        cableUnitTest.Inaktiv_Dato__c = mydate;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                    
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Contract_Source_ID__c = 'KAS.P2---4015110456';
        cableUnitTest.distinctAddresses__c = 'Gyvelvej(4-4)';
        cableUnitTest.Legal_Account_No__c = acc.Id;
        cableUnitTest.Cable_Type__c = 'Coax';
        insert cableUnitTest;
        
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr1.id;
        installation.Cable_Unit__c = cableUnitTest.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.Installation_Status_Code__c = '1';
        installation.Start_Date__c = date.today();
        insert installation;
        
        Net_Installations__c installation2 = new Net_Installations__c();
        installation2.Address_Id__c = '7862229';
        installation2.Address__c = addr1.id;
        installation2.Cable_Unit__c = cableUnitTest.Id;
        installation2.AddressId_InstLbnr__c = '1';
        installation2.Start_Date__c = date.today();
        insert installation2;
        
        List<Net_Installations__c>  listInstall = new List<Net_Installations__c>();
        listInstall.add(installation);   
        system.debug('installation***** '+installation.Id );
        
        Product__c product2 = new Product__c();
        product2.Name = 'Grundpakke';
        product2.Product_ID__c = '1101001';
        insert product2;
        
        Product__c product3 = new Product__c();
        product3.Name = 'med Bland Selv';
        product3.Product_ID__c = '1101001';
        insert product3;
         
        Subscription__c subscription2 = new Subscription__c();
        subscription2.Subscription_No__c = '841119861';
        subscription2.Start_Date__c = system.today()-1;
        subscription2.Product__c = product2.id;
        subscription2.Net_Installation__c = installation.id;
        subscription2.Address__c = installation.Address__r.External_Id__c;
        subscription2.Installation_Id__c = installation.AddressId_InstLbnr__c;
        insert subscription2;
        
        Subscription__c subscription3 = new Subscription__c();
        subscription3.Subscription_No__c = '841119861';
        subscription3.Start_Date__c = system.today()-1;
        subscription3.Product__c = product3.id;
        subscription3.Net_Installation__c = installation.id;
        subscription3.Address__c = installation.Address__r.External_Id__c;
        subscription3.Installation_Id__c = installation.AddressId_InstLbnr__c;
        insert subscription3;   
        
        Sales_Concept_Parameter__c salesConPar = new Sales_Concept_Parameter__c();
        salesConPar.Sales_Concept__c = salesConObj.Id;
        salesConPar.Parameter_Group__c = 'Bredbånd';
        salesConPar.Parameter_Head__c = 'Gratis ændringsgebyr nyindflytning'; 
        salesConPar.Parameter_Value__c = 'Ja'; 
        salesConPar.Parameter_PortalActive__c = true;
        salesConPar.SC_Param_SourceId__c = 'KAS.P2---4015110456';
        insert salesConPar;
        
        cInstallation cInst = new cInstallation(installation,subscription2);
        List<cInstallation> cList = new List<cInstallation>();
        cList.add(cInst); 
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(listInstall);
        PagingController pageCon = new PagingController();
        pageCon.stdSetController = ssc;
              
        PageReference pageRef = Page.ViewAddressesForInstallationsPage;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentpage().getparameters().put('cableunitnumber', cableUnitTest.Cable_Unit_No__c); 
                       
        ViewAddressesForInstallationsController2 tempCont = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
        ViewAddressesForInstallationsController2.ordertypeFlag = true;
        Test.startTest();
        tempCont.setInstallationList(cList);
        tempCont.getdslOrderListForMail();          
        tempCont.getInstallationList();
        //tempCont.getItemsDropDown();
        //tempCont.exportAddressesToExcelAndSendMail();        
        tempCont.setCheckBoxValue();
        tempCont.checkValidateNewResident();
        tempCont.getListExport();
        tempCont.addressSearch = 'Nerult';
        tempCont.searchValues = 'Nerult';
        tempCont.searchHsNoText = '2';
        tempCont.BSsearchValues = 'BlandSelv';
        tempCont.search(); 
              
        installation.Installation_Status_Code__c = '2';
        update installation2;
        //tempCont.exportAddressesToExcelAndSendMail();   
             
        installation.Installation_Status_Code__c = '9';
        update installation2;
        tempCont.exportAddressesToExcelAndSendMail();    
        Test.stopTest(); 
           
    }
    
    static testMethod void testMethodForInstallations1(){
        Test.startTest();
        ViewAddressesForInstallationsController2 controller1 = new ViewAddressesForInstallationsController2();
        controller1.finalInstallations = new List<cInstallation>();
        //finalInstallations.add()
        controller1.placeOrderForPackageChange();
        //ViewAddressesForInstallationsController2.callToFutureForAddressesExport('test');
        Test.stopTest();
    }
    static testMethod void testMethodForInstallations(){
        
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
        cu.Cable_Type__c = 'Coax';
        insert cu;
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        //addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;
        
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr1.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.Start_Date__c = date.today()-1;
        installation.Installation_Status_Code__c = '1';
        insert installation;
        
        List<Net_Installations__c> instList = new List<Net_Installations__c>();
        ViewAddressesForInstallationsController2 controller = new ViewAddressesForInstallationsController2();
        ViewAddressesForInstallationsController2.FORCE_TEST_MODE = true;
         controller.pagingComponent = new PagingController();
        String addressSearch = 'Abc';
        Test.startTest();
        controller.fetchAddresses();
        controller.backToViewPage();
        controller.streetFlag = false;
        controller.showChangePackageButton = false;
        controller.addressesFlag = false;
        controller.selectedPackageDate = '';
        controller.changedAmsId = '';
        controller.JSONString = '';
        controller.addressItems = new List<Net_Installations__c>();
        ViewAddressesForInstallationsController2.callToFutureForAddressesExport(cu.Cable_Unit_No__c);
        //controller.ForTestCoverage();
        ViewAddressesForInstallationsController2.instMap = new Map<String, String>();
        ViewAddressesForInstallationsController2.BSlistexport bs = new ViewAddressesForInstallationsController2.BSlistexport();
        bs.response = '';
        system.debug('bs.response'+bs.response);
        bs.Street = '';
        bs.House_No = '';
        bs.Floor = '';
        bs.Entrance = '';
        bs.Door_No = '';
        bs.Postcode = '';
        bs.Town = '';
        ViewAddressesForInstallationsController2.testData(); 
        Test.stopTest();
    }
    /*
    private static void testMethodForBlankInstallations(){
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
        Test.startTest();
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
        cu.Loop__c = 'T';
        insert cu;
          
        account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert account;
        
        List<Address__c> addressLst = new List<Address__c>();
        List<Net_Installations__c> netInstallationList = new List<Net_Installations__c>();
        
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
        insert installation;
        
        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123a';
        installation1.Address__c = addr2.id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.AddressId_InstLbnr__c = '1';
        insert installation1;

        Net_Installations__c installation2 = new Net_Installations__c();
        installation2.Address_Id__c = 'add123a';
        installation2.Address__c = addr3.id;
        installation2.Cable_Unit__c = cu.Id;
        installation2.AddressId_InstLbnr__c = '1';
        insert installation2;           
        
        Product__c product = new Product__c();
        product.Name = 'Fuldpakke';
        product.Product_ID__c = '1101201';
        insert product;
        
        Product__c product1 = new Product__c();
        product1.Name = 'Mellempakke';
        product1.Product_ID__c = '1101101';
        insert product1;
        
        Product__c product2 = new Product__c();
        product2.Name = 'Grundpakke';
        product2.Product_ID__c = '1101001';
        insert product2;
        
        Order__c o1 = new Order__c();
        o1.packageBeforeChange__c = product2.Name;
        o1.cableUnitName__c = cu.Name;
        o1.cableUnitNumber__c = cu.Cable_Unit_No__c;
        o1.Product_No__c = product2.Product_ID__c;
        o1.Product_Name__c = product1.Product_Name__c;
        o1.Net_Installation__c = installation2.id;
        o1.Address_Id__c = addr3.Id;
        insert o1;
        
        //Select s.Net_Installation__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, s.Product__r.Name, s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today()
        List<Net_Installations__c>  listInstall = new List<Net_Installations__c>();
        listInstall.add(installation);
        listInstall.add(installation1);
        listInstall.add(installation2);
        
        Subscription__c subscription = new Subscription__c();
        subscription.Subscription_No__c = '841119859';
        Integer d = 01;
        Integer m = 01;
        Integer y = 2004;
        date eDate = date.newInstance(y,m,d);
        subscription.Start_Date__c = eDate;
        subscription.Product__c = product.id;
        subscription.Net_Installation__c = installation.id;
        subscription.Address__c = installation.Address__r.External_Id__c;
        subscription.Installation_Id__c = installation.AddressId_InstLbnr__c;
        insert subscription;
        
        Subscription__c subscription1 = new Subscription__c();
        subscription1.Subscription_No__c = '841119860';
        subscription1.Start_Date__c = eDate;
        subscription1.Product__c = product1.id;
        subscription1.Net_Installation__c = installation1.id;
        subscription1.Address__c = installation1.Address__r.External_Id__c;
        subscription1.Installation_Id__c = installation1.AddressId_InstLbnr__c;
        insert subscription1;
        
        Subscription__c subscription2 = new Subscription__c();
        subscription2.Subscription_No__c = '841119861';
        subscription2.Start_Date__c = eDate;
        subscription2.Product__c = product2.id;
        subscription2.Net_Installation__c = installation2.id;
        subscription2.Address__c = installation2.Address__r.External_Id__c;
        subscription2.Installation_Id__c = installation2.AddressId_InstLbnr__c;
        insert subscription2;
        
        cInstallation cInst = new cInstallation(installation,subscription2);
        List<cInstallation> cList = new List<cInstallation>();
        cList.add(cInst); 
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(listInstall);
        PagingController pageCon = new PagingController();
        pageCon.stdSetController = ssc;
              
        PageReference pageRef = Page.ViewAddressesForInstallationsPage;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentpage().getparameters().put('cableunitnumber', cu.Cable_Unit_No__c);
        
        ViewAddressesForInstallationsController Controller = new ViewAddressesForInstallationsController(); 
        ViewAddressesForInstallationsController.FORCE_TEST_MODE = true;
        Controller.exportAddressesToExcelAndSendMail();

        ViewAddressesForInstallationsController.callToFutureForAddressesExport(cu.Cable_Unit_No__c);
        Test.stopTest();
    }
    private static void calltoCastIronTest(){
        Integer d = 01;
        Integer m = 06;
        Integer y = 2014;
        date eDate = date.newInstance(y,m,d);
        
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
        cu.Loop__c = 'T';
        insert cu;
        
        Address__c addr2 = new Address__c();

        addr2.Name='Vashi';
        addr2.House_No__c='1';
        addr2.Postcode__c='1100';
        addr2.Door_No__c='52';
        addr2.Street__c ='wall street';
        addr2.Active__c = true;
        addr2.External_Id__c = '58850';
        insert addr2;
        
        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123a';
        installation1.Address__c = addr2.id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.AddressId_InstLbnr__c = '1';
        insert installation1;
        
        Product__c product1 = new Product__c();
        product1.Name = 'Mellempakke';
        product1.Product_ID__c = '1101101';
        insert product1;
        
        Product__c product2 = new Product__c();
        product2.Name = 'Grundpakke';
        product2.Product_ID__c = '1101001';
        insert product2;
        
        Order__c o1 = new Order__c();
        o1.packageBeforeChange__c = product2.Name;
        o1.cableUnitName__c = cu.Name;
        o1.cableUnitNumber__c = cu.Cable_Unit_No__c;
        o1.Product_No__c = product2.Product_ID__c;
        o1.Product_Name__c = product1.Product_Name__c;
        o1.Net_Installation__c = installation1.id;
        o1.Address_Id__c = addr2.Id;
        o1.Kasia_Order_Status__c = 'New';
        o1.ChangePackageDate__c = String.valueOf(eDate);
        o1.Order_type__c = 'New';
        insert o1;
        
        ViewAddressesForInstallationsController Controller = new ViewAddressesForInstallationsController(); 
        ViewAddressesForInstallationsController.FORCE_TEST_MODE = true;
        Controller.callToCastIron();
    }*/
}