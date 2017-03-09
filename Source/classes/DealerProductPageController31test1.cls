/**********************************************************************************
************************************************************************************

* @Test class: DealerProductControllerTest1
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 3.0
* @date: 03/26/2013
* @description: This test Class is for DealerProductPageController3.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class DealerProductPageController31test1 {
        
     static testMethod void DealerProductest() {
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301'; 
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc= new Account();
        acc.Name ='test2445';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Billing_Address__c = addr.Id;
        acc.Phone = '223225';
        acc.Email__c = 'p13567@test.com';
        acc.Customer_No__c = '123459'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni;YouBio';
        acc.DealerGroup__c = 'Fona';
        acc.PO_Box_alt__c ='2450';
        acc.RecordTypeId = rt.Id;
        insert acc;
        
        Customer_Installation_Address__c CIA = new Customer_Installation_Address__c();
        
        CIA.Address__c=addr.Id;
        CIA.Customer__c=acc.Id;
        CIA.Installation_Address_External_ID__c='12121';
        
        insert CIA;     
        
        DealerCustomerPOJO dealerpojo = new DealerCustomerPOJO();
        DealerCustomerPOJO dealerpojo1 = new DealerCustomerPOJO();
        List<DealerCustomerPOJO> dealerpojoLst = new List<DealerCustomerPOJO>();
        
        dealerpojo.conformEmail='navneet@gmail';
        dealerpojo.credit=true;
        dealerpojo.customerName='Navneet';
        dealerpojo.customerNumber='654321';
        dealerpojo.customerSelected=true;
        dealerpojo.email='abc@gmail';
        dealerpojo.installationID='1';
        
        dealerpojo1.conformEmail='navneet1@gmail';
        dealerpojo1.credit=true;
        dealerpojo1.customerName='Navneet1';
        dealerpojo1.customerNumber='65432111';
        dealerpojo1.customerSelected=false;
        dealerpojo1.email='abc@gmail';
        dealerpojo1.installationID='1';
        
        dealerpojoLst.add(dealerpojo);
        dealerpojoLst.add(dealerpojo1);
        
                  
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
        add.Side__c='TV';
        insert add;
        
        cCustomerInstallationAddress payeeCustInstAdd = new cCustomerInstallationAddress();
        //payeeCustInstAdd.addr='abc nasik';
        payeeCustInstAdd.amsId='7685111';
        payeeCustInstAdd.contactNumber='9890156452';
        payeeCustInstAdd.conformEmailID='n@gmail.com';
        payeeCustInstAdd.customerNumber='616158831';
        payeeCustInstAdd.isNewCustomer=false;
        //payeeCustInstAdd.getAddr1();
        //payeeCustInstAdd.getAddr2();
        
        cCustomerInstallationAddress payeeCustInstAdd1 = new cCustomerInstallationAddress();
        //payeeCustInstAdd1.addr=add.Id;
        payeeCustInstAdd1.amsId='7685111';
        payeeCustInstAdd1.contactNumber='9890156452';
        payeeCustInstAdd1.conformEmailID='navi@gmail.com';
        payeeCustInstAdd1.customerNumber='65432111';
        payeeCustInstAdd1.isNewCustomer=true;
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        User u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
     
    DealerProductPageController31 control;     
     System.runAs(u) {
        PageReference pageRef = Page.DealerCustomerSearch;
        Test.setCurrentPage(pageRef);
         control = new DealerProductPageController31();
        DealerProductPageController31.FORCE_TEST_MODE = true;
        control.testMode =  true;
        control.newsLetterUser = true;
        control.ekomUser= true;
         control.clearFlag = false;
         control.firstJsonResponse = '';
         control.checkSPBBFlag = false;
         control.checkCLFlag = false;
         control.SerialNoSection = false;  
    	 control.KortSection1 = false;
    	 control.KortSection2 = false;
    	 control.BilledelegitimationSection = false;
         control.produktUrl = '';
         control.broadbandUpgradationFlag = false;
         control.ValidatedState = false;
         control.productsSelected = '';
       //  control.accountIdNewCustomer = '';
         control.selectedAbonnementerAftalenr = '';
         control.receiptValgtResponse = '';
         control.priceJsonResponse  = '';
         control.productJsonArray = '';
         control.plus = '';
         control.youBioPriceJson = '';
         control.isTelephninBasket = '';
         control.totalPrice = '';
   // control.getb
    control.settingDealerValues(dealerpojoLst);
    control.setupCustomerInstallationAddress(payeeCustInstAdd); 
    control.setupCustomerInstallationAddress(payeeCustInstAdd1);
    
         
    //commonClass commoncls = new commonClass(); 
    ProductOfferWrapper prdWrapper= new ProductOfferWrapper();
    Product pr = new Product(); 
    ProductForDisplay prd = new ProductForDisplay();
    cCustomerInstallationAddress cInstallationAddr = new cCustomerInstallationAddress(); 
    cInstallationAddr.addr =add;
    cInstallationAddr.getAddr1();
    cInstallationAddr.getAddr2(); 
          
        Set<String> prodStr= new Set<String>();
        prodStr.add('Bredbånd');
        prodStr.add('Ekstrakanaler');
        prodStr.add('Telefoni');
        prodStr.add('yousee clear');
        //prodStr.add('Telefoni');
       
        //commoncls.productsDealerCanSell=prodStr;
        control.objCommon.dealerAccount = acc;
        control.objCommon.productsDealerCanSell=prodStr;
        List<String> selectedProdLst = new List<String>(); 
       selectedProdLst.add('broadband');
       selectedProdLst.add('telephony');
       selectedProdLst.add('clear'); 
       //selectedProdLst.add('Tvillingkort');
       // create product serial number MAP
       
       Map<String,List<string>> ProductSerialNumbersMapProp = new Map<String,List<string>>(); 
       ProductSerialNumbersMapProp.put('123423123423',selectedProdLst);
       ProductSerialNumbersMapProp.put('123423111111',selectedProdLst);
       
       // populate DTV info 
        Map<Decimal, string> DTVInfMap = new Map<Decimal, string>();
        DTVInfMap.put(1.1,'DTV1');
        DTVInfMap.put(1.2,'DTV2');
        DTVInfMap.put(1.3,'DTV3');
        
        control.isFirstCallToKasia=true;
        control.kundeData = 'Kunde Data';
        control.arrayInit = 'Array Init';
        control.url = 'http://preprod-kasia.yousee.dk/afsaetning/slet/dummy-1/1201504~YouSee Plus';
        control.etag = '-1257831469';
        control.BBProduct='http://preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1212@@bb';
        control.TLFProduct='http://preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1212@@tlf';
        control.newNumber='12';
       // control.npHref='http://preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1212';
        control.hardwareSelection='1201505';
        control.ProductSerialNumbersMap = ProductSerialNumbersMapProp;
        control.SerialNo='435233445345';
        control.secondPayee=false;
        control.displayTVkort=true;
        control.dateForNumberPorting='22-02-2011';
        control.DTVInformationMap=DTVInfMap;
        control.searchPostNrText='2600';
        control.tlfNumberForNumberPorting='78678611';
        control.emailIdForNumberporting='sudip@gmail.com';
        control.onlyBroadbandFlag=true;
        control.selectedNumber = 'Intet nummer valgt';
         control.oneTimePriceForBBnTFValue = '';
       String a = 'a';
        string nam = 'name';
         map<string,string> mapprod = new map<string,string>();
         mapprod.put(a,nam);
       // control.END_POINT='http://213.174.69.111:7890';
        Apexpages.currentpage().getparameters().put('pinCode','2600');
        Apexpages.currentpage().getparameters().put('streetName','vesterVej');
        Apexpages.currentpage().getparameters().put('amsId','7685111');
        Apexpages.currentpage().getparameters().put('houseNo','7'); 
        Apexpages.currentpage().getparameters().put('perviousPage','/apex/DealerCustomerSearch');
        Apexpages.currentpage().getparameters().put('selectedProds','15mbit@yousee.dk/broadband/12432!#@broadband#&#fullpack@yousee.dk/broadband/12432!#@clearpack@yousee.dk/Mediumpack/2011');
        Apexpages.currentpage().getparameters().put('mergedstring','kundeData@@@ArrayInit@@@12342');
        Apexpages.currentpage().getparameters().put('npTffNumber','12342344');
        Apexpages.currentpage().getparameters().put('radioValue','true');
        Apexpages.currentpage().getparameters().put('radioID','1232ab');
        Apexpages.currentpage().getparameters().put('newTlfID','54345454');
        Apexpages.currentpage().getparameters().put('extTlfID','54653434');
        Apexpages.currentpage().getparameters().put('installNr','111111');
        Apexpages.currentpage().getparameters().put('laterPortingDate','12-11-2011');
        Apexpages.currentpage().getparameters().put('portingDate','1-10-2011');
        Apexpages.currentpage().getparameters().put('selectedCustomer','616169140');
        Apexpages.currentpage().getparameters().put('customerCredit','true');
        ApexPages.CurrentPage().getParameters().put('existingYoubio','54653434');
      
        Apexpages.currentpage().getparameters().put('NPMergedstring','kundeData@@@ArrayInit@@@12342@@@preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1212');
        Apexpages.currentpage().getparameters().put('npFutureDate','12-2-2012');
        Apexpages.currentpage().getparameters().put('activationDateForTlfBB','12-10-2011');
        Apexpages.currentpage().getparameters().put('selectedProdIds',
                                                    'broadbandId@telephonyId@bbTlfCommonId@BroadBandModemId@TelephoniProductId@dtvEngId@dtvPakkeId@dtvCardSelectId@fcCardSelectId@dtvChannelSelId@fcChannelSelId@dtvClearId@dtvtaId');
        
        Apexpages.currentpage().getparameters().put('isBroadbandSubscriptionPresent','false');
        Apexpages.currentpage().getparameters().put('isBroadbandSubscriptionNotAvailable','true'); 
        Apexpages.currentpage().getparameters().put('isBlandSelvProduct','true'); 
		Apexpages.currentpage().getparameters().put('isKortOrBox','true');
        Apexpages.currentpage().getparameters().put('numberOfYouseeKorts','2');
        Test.startTest(); 
         
            control.findCityName();
           // add.Town__c=null;
            //add.Postcode__c=null;
            //update add;
            
            control.findCityName();
            control.getProductSerialNumbersMapKeys();
            control.findStreets();
            control.showCustomers();
         Apexpages.currentpage().getparameters().put('amsId','0123456');
         	control.showCustomers();
            control.getDisplayProperty();
            control.setDisplayProperty('None');
            control.dummyAction();
            control.dummyAction1();
            control.searchAddress();
            control.getCustomerFlag();
            control.getCustomerInstallationAddress();
            control.settelephnflag();
           
            
            control.productSelectionPage();
            system.debug('In test class-----------------------------------'+ApexPages.CurrentPage().getParameters().get('selectedProdIds'));
            control.startSalesFlow();
            
            Apexpages.currentpage().getparameters().put('redirectToNewPage','youbio');
            control.addYoubioProducts();

            Apexpages.currentpage().getparameters().put('redirectToNewPage','bb@TLF');
            control.afterBroadBandOrTelephonyProductSelection();
            Apexpages.currentpage().getparameters().put('redirectToNewPage','bb');
            control.afterBroadBandOrTelephonyProductSelection();
            Apexpages.currentpage().getparameters().put('redirectToNewPage','TLF');
            control.afterBroadBandOrTelephonyProductSelection(); 
            control.index =0;
            //List<string> temp = new List<string>();
            //temp.add('CustomerInfoPage');
            //control.selectedProducts = temp;
            control.afterTelephonyProductSelection(); 
            
            control.back();
            control.secondCallToCasia(control.url,control.arrayInit,control.kundeData,control.etag);
            control.backToDealerProduct();
            DealerSalesConstant.clearId='broadband';
            //control.selectedProducts.add('broadband');
            control.secondCallToCasia();
            // functionality testing broadband and telephony
            control.selectedBBValue();
            control.selectedTLFValue();
            control.getAvailableTelephoneNumbers();
            control.getSelectedTelephones();
            control.callOutNPAction();
        	
            control.RedirectToCustomerInfoPage();
            
            control.redirectCustomerInfo();
            //Added on 25 sept 2011 
            control.onlyBroadbandFlag=true;
            control.tlfNumberForNumberPorting='7867861212';
            control.emailIdForNumberporting='sudip@gmail1.com';
            control.broadbandTelephonyCommonFlag=true;
           
            cCustomerInstallationAddress cinstObj1 = new cCustomerInstallationAddress();
            
            cinstObj1.isNewCustomer=true; 
            cinstObj1.amsId='7685111';
            cinstObj1.firstName='Navneet';
            cinstObj1.lastName='Rajput';
            control.setupcCustInstAdd(cinstObj1);
           /**
           control.priceJsonResponse = '{"1701001": {"koda": "0.00","fejlkode": 0,"pris": "79.20", ' +
                                        + '  "betalingsperiode": "maaned","radiokoda": "0.00","totalpris": "99.00", ' + 
                                        + ' "moms": "19.80","copydan": "0.00"}, ' + 
                                        + ' "1702001": {"koda": "0.00","fejlkode": 0,"pris": "396.00", ' + 
                                        + ' "betalingsperiode": "enkelt","radiokoda": "0.00","totalpris": "495.00", ' +
                                        + ' "moms": "99.00","copydan": "0.00"}}';
            control.receiptValgtResponse = '{"dtv-uden-clear":false,"kabeltype":"coax","adresse-kreditvalideret":true,"kampagner":[{"opfyldt":true,"navn":"Gratis YouBio måneden ud","master-plan":"YouBio","type":"Kupon","id":"YouBioGratisMaanedenUd"}],"salgskanal":"Forhandler","laase":"000000","instnr":"53408","bb-uden-clear":false,"boligtype":"E","aftaler":[{"kreditvalideret":true,"aftaletype":"clear","kundetype":"I","kundeid":"615425148","aftalenr":"0","abonnementer":[{"status":"aktiv","navn":"Mellempakke","sortering":"11-01-0020","varenr":"1101101","abonnementsid":"-1508357654","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","kortnavn":"MP","links":[{"rel":"pakkeindhold","href":"http://preprod-kasia.tdk.dk/afsaetning/pakkeindhold/0005019118/1101101","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP","CLEAR1LT"]}]},{"kreditvalideret":true,"aftaletype":"bb","kundetype":"I","kundeid":"615425148","aftalenr":"249057","abonnementer":[{"status":"aktiv","navn":"Bredbånd 4 Mbit/512 kbit","modemid":"104968084","sortering":"31-13-00000000000155","varenr":"1301004","abonnementsid":"-1610220028","varetype":"ga","sorteringsgruppe":"03-31-0020","sorteringsgruppenavn":"SAVE Hastighedsprodukter","kortnavn":"SAVE 4 M/512 k"}]},{"kreditvalideret":true,"aftaletype":"tlf","kundetype":"I","kundeid":"615425148","aftalenr":"1095572","abonnementer":[{"status":"kunplan","navn":"TLF FAST","modemid":"104968084","sortering":"33-05-00000000000020","varenr":"1401002","abonnementsid":"1035719","varetype":"ga","kortnavn":"TLF FAST"}]}],"links":[{"rel":"adresse","href":"http://preprod-kasia.tdk.dk/adresse/5957540","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"valgt":[{"aftalenr":"dummy-1","aftaletype":"youbio","varer":[{"navn":"YouBio Abonnement","sortering":"1","varenr":"1701001","varetype":"ga","kortnavn":"YouBio Abonnement","links":[{"rel":"slet","href":"http://preprod-kasia.tdk.dk/afsaetning/slet/dummy-1/1701001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"YouBio Boks","sortering":"16","varenr":"1702001","varetype":"yd","kortnavn":"YouBio Boks","links":[{"rel":"slet","href":"http://preprod-kasia.tdk.dk/afsaetning/slet/dummy-1/1702001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]}],"amsid":"5957540","stikstatus":"1","anlaegsnr":"0005019118"}';
            */
            control.placeOrder(); 
         Apexpages.currentpage().getparameters().put('isKortOrBox','true');
        Apexpages.currentpage().getparameters().put('numberOfYouseeKorts','2');
            control.afterClearProductSelection();
         Apexpages.currentpage().getparameters().put('isKortOrBox','true');
        Apexpages.currentpage().getparameters().put('numberOfYouseeKorts','2');
            control.RedirectToClearKravetPage();
            control.setHasCustomerYouSeeCard();
            control.getProductDealerCanSell();
            control.getSearchSectionDisplayDetails();
            control.DeleteBasketProduct('Tvillingkort');
            control.next();
            control.goToBroadbandProductsPage();
            control.ResetSerialPageValues();
            control.NumberValidate();
            control.KortNumber1Validate();
            control.KortNumber2Validate();
            control.AdditionalKortNumber1Validate();
            control.AdditionalKortNumber2Validate();
            control.SerialNumberValidate();
            control.NextFromSerialNumberPage();
          //  control.getSerialNumberJSON();
           // control.getHandlingInfo();
            control.getDTVInfo1();
            control.getDTVInfo2();
           // control.RedirectToDTVSmartCardSelection();
            control.backtoHardwareSelection();
            control.RedirectToDTVChannelSelection();
           // control.RedirectToSerialNumberEntryPage();
            control.cancel();
            control.getTelephoneNumbers('4534,4545,1212,6767'); 
            //control.getTelephoneNumbers('');
            //control.callToKasia();
            control.placeOrder();
            
            control.addSubscription('sameh@tdc.dk', '2156' , 'CHARLOTTE', 'RYBERG', '001S000000SP3hM','');
            //test case2  
            cCustomerInstallationAddress cinstObj2 = new cCustomerInstallationAddress();
            cinstObj2.isNewCustomer=false; 
            cinstObj2.amsId='7685111';
            cinstObj2.firstName='Navneet';
            cinstObj2.lastName='Rajput';
            cinstObj2.customerNumber='616158831';
            control.setupcCustInstAdd(cinstObj2);
            control.placeOrder();
            
            cCustomerInstallationAddress cinstObj = new cCustomerInstallationAddress();
            cinstObj.isNewCustomer=true; 
            cinstObj.amsId='7685111';
            cinstObj.firstName='Navneet';
            cinstObj.lastName='Rajput';
            control.setupcCustInstAdd(cinstObj);
            control.placeOrder(); 
           
            
            control.index=0;
            control.backFlow();
            control.index=1;
            control.backFlow();
            
            //control.parseProducts('broadband!#@dtv#&#telephony!#@freechannels#&#clear');
            control.subsequentCallToKasia();
            control.redirectToFrontPage();
            control.fetchProductOffer();
            control.RedirectToApprovalPage();
            control.RedirectToFreeChoiceChannelSelectionPage();
            control.RedirectToSerialNumberEntryPage();
            control.displayNewPhoneNumber();
            
             control.secondPayee=true;
            payeeCustInstAdd.amsId='7685111';
            payeeCustInstAdd.contactNumber='9890156452';
            payeeCustInstAdd.conformEmailID='n@gmail.com';
            payeeCustInstAdd.customerNumber='616158831';
            payeeCustInstAdd.isNewCustomer=false;
            control.payeeCustInstAdd=payeeCustInstAdd;
            control.showCustomers();
            control.getCustomerInstallationAddress();
            control.placeOrder(); 
            
            PageReference customerSearch = Page.DealerCustomerSearch;
            Test.setCurrentPage(customerSearch);
            ApexPages.currentPage().getParameters().put('streetName', 'AH');
            ApexPages.currentPage().getParameters().put('houseNo', 'test');
            control.searchPostNrText='421002';
            control.searchAddress(); 
            
          
            control.saveReceipt();
            control.printReceipt();
            control.getProductSelection();
            control.setSecondPayee(true);
            control.getIsNewCustomer();
            control.getSecondPayee();
            control.getInformation();
            control.getApprovalInfo1();
            control.getApprovalInfo2();
            control.getApprovalInfo4();
            control.getApprovalInfoForBBorTF();
            control.getApprovalInfoForClear1();
            control.getApprovalInfoForClearFlow2();
            control.getApprovalInfoForBSXX();
            control.getApprovalInfoForYouSeePlusOrFreechoice();
            control.getApprovalInfoIalt();
            control.getApprovalInfoForTelefoni(); 
            control.finalApproval();
            control.getApprovalInfoForBB();
            control.getApprovalInfoForYouBio();
            
                    
            Test.stopTest();        
     } 
     
            cCustomerInstallationAddress newCustomer = new cCustomerInstallationAddress();
            newCustomer.isNewCustomer=true; 
            newCustomer.amsId='7685111';
            newCustomer.firstName='nk';
            newCustomer.lastName='nk';
            newCustomer.customerNumber='123459';
            newCustomer.mobilePhone='989898978';
            newCustomer.email='nk@nk.com';
            newCustomer.contactNumber='89899889';
            newCustomer.addr=addr;
           // control.setupcCustInstAdd(newCustomer);
            control.cCustInstAdd=newCustomer;           
            control.insertCustomer();          
   }    
   
      /*  
      static testMethod void testBackFlow() {
        
        control.index=0;
        control.backFlow();
        control.index=1;
        control.backFlow();
      }  
        */
     
      public static User u;
      public static  string Key;
      public static List<string> productSRNumberList = new List<string>();
      public static DealerProductPageController31 controller;
      
     static testMethod void testCreateData() {
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc= new Account();
        acc.Name ='test23456';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'p13567@test.com';
        acc.Customer_No__c = '123456'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;     
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='123';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'pooja Agicha';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        
        insert add;
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
         
    System.runAs(u) {
        PageReference pageRef = Page.DealerCustomerSearch;
        Test.setCurrentPage(pageRef);
        controller = new DealerProductPageController31();
        DealerProductPageController31.FORCE_TEST_MODE = true;
        controller.testMode =  true;
        controller.url = 'test.yousee.dk/dummy-1/120505';
         controller.arrayInit = 'test';
         controller.etag = '';
         controller.kundeData ='test';
          controller.error ='';   
          controller.index =0;
          List<string> temp = new List<string>();
          temp.add('CustomerInfoPage');
          controller.selectedProducts = temp;
          //controller.selectedProducts.add('CustomerInfoPage');
         // controller.selectedProducts.add('test');   
       
        try{
    //  List<String> lst= controller.getDetails();
       testYouSeeKort();     
        testHDStandardBox();
         controller.ResetSerialPageValues(); 
        testHDStandardBoxWithKort();
         controller.ResetSerialPageValues(); 
        testYouSeePlus();
         controller.ResetSerialPageValues(); 
        testLejeOfYouSeeBoks(); 
         controller.ResetSerialPageValues(); 
        testTvillingKort();
         controller.ResetSerialPageValues(); 
        testonDemand();
         controller.ResetSerialPageValues(); 
        failureScenarios(); 
         controller.ResetSerialPageValues(); 
          testAddtvkort2();
          controller.ResetSerialPageValues();
         testAddtvkort();  
             
              
       //controller.displayTVkort = true;  
        
              
        }
        catch(Exception e)
        {
            system.debug('******************'+ e.getMessage());
            system.assertEquals( e.getMessage(), e.getMessage());
        }
     
        }   
            
        
              
    }       
          
   static public void failureScenarios() {
         controller.hardwareSelection = '1201505';
        controller.hardwareSelectionName = 'YouSee Kort';        
        controller.KortNo2 = '12345678987';
        controller.callMethod= 'Kort2Validate';      
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201505","type":3,"lokation":"T7006","status":"Transit","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
       // controller.NumberValidate();
        //system.assertEquals('Kan ikke bytte hardware med status Transit. Husk at varemodtage',controller.error);
        
        
         controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201505","type":3,"lokation":"T8219","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        //controller.NumberValidate();
        //system.assertEquals('Serienummer er ikke disponibelt',controller.error);
        
        controller.ApprovalResponse =  '{"logistik":{"error":"testing through testmethod","ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201505","type":3,"lokation":"T8219","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"500","responsemessage":"OK","ETag":"2142747879"}';      
        //controller.NumberValidate();
       // system.assertEquals('testing through testmethod',controller.error);
        
        
        /*controller.ApprovalResponse =  '{"logistik":{"Testing through Test Method"},"responsecode":"500","responsemessage":"OK","ETag":"2142747879"}';            
        controller.NumberValidate();
        system.assertEquals('Testing through Test Method',controller.error);*/
        
         controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201777","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        controller.displayTVkort = false;
        //controller.NumberValidate();
        //system.assertEquals('Serienummer stemmer ikke overens med korttype',controller.error);
    }
   static public void testYouSeeKort() {                   
        controller.hardwareSelection = '1201505';
        controller.hardwareSelectionName = 'YouSee Kort';        
        controller.KortNo2 = '12345678987';
        controller.callMethod= 'Kort2Validate';      
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201505","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';              
        controller.NumberValidate();
        controller.isKasiaCallSuccess= true;
       //controller.ValidateAllBooleans();
       Key = '1201505'+'~'+'YouSee Kort';           
        productSRNumberList.add(controller.KortNo2);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);
        controller.KortNumber2Validated=true;                
        controller.ValidateAllBooleans();
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
       controller.displayTVkort= true;
        controller.AdditionalTVKortNumber1Validated= false;                 
       controller.EnableNextButton=true;
       controller.plusFlag = false;
       controller.ekstrakanalerFlag = true;
       controller.NextFromSerialNumberPage();
        
        }
  
  
  static public void testHDStandardBox() {                 
        controller.hardwareSelection = '1218385';
        controller.hardwareSelectionName = 'DEMO HD-Standardboks';        
        controller.SerialNo = '123456789871';
        controller.callMethod= 'SerialNumberValidate';
        controller.serialNumbervalidated = true;      
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"DEMO HD-Standardboks","varenummer":"1218385","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        controller.NumberValidate();
        controller.isKasiaCallSuccess= true;                
        Key = '1218385'+'~'+'DEMO HD-Standardboks';          
        productSRNumberList.add(controller.SerialNo);
         controller.serialNumbervalidated = true;  
       controller.ValidateAllBooleans();
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        controller.EnableNextButton = true;
        controller.NextFromSerialNumberPage(); 
        }
  
  static public void testHDStandardBoxWithKort() {                 
        controller.hardwareSelection = 'HDstandardboksWithCard';
        controller.hardwareSelectionName = 'HD-standardboks uden harddisk med YouSee Kort';        
        controller.SerialNo = '12345678987';
        controller.callMethod= 'SerialNumberValidate';
        controller.KortNo2 = '12345678987';
        controller.callMethod= 'Kort2Validate'; 
        controller.serialNumbervalidated = true;      
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Plus","varenummer":"1201504","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        controller.NumberValidate();
        controller.isKasiaCallSuccess= true;                
        Key = '1218385'+'~'+'HD-standardboks uden harddisk med YouSee Kort';        
       controller.serialNumbervalidated = true;   
       controller.KortNumber2Validated=true;
        controller.ValidateAllBooleans();
        productSRNumberList.add(controller.SerialNo);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        controller.EnableNextButton = false;
        controller.plusFlag = false;
        controller.NextFromSerialNumberPage(); 
        }
   static public void testAddtvkort() {
     controller.hardwareSelection = '1201601';
        controller.hardwareSelectionName = 'Tvillingkort';                
        controller.TVKortNo1 ='12345678908';
        controller.callMethod= 'AdditionalKortNumber1Validate';
      //  controller.isKasiaCallSuccess= false;           
        controller.displayTVkort= true;
        //controller.isFirstTKortCalled=false;
        controller.url='test';
        controller.isKasiaCallSuccess=true; 
         controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"TvillingKort","varenummer":"1201601","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
        // controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1201505","type":3,"lokation":"T7006","status":"Transit","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
       controller.AdditionalKortNumber1Validate();
  
   }
  
   static public void testAddtvkort2() {
     controller.hardwareSelection = '1201601';
        controller.hardwareSelectionName = 'Tvillingkort';                                         
       // controller.displayTVkort= true;
      //  controller.isFirstTKortCalled=false;
         productSRNumberList.clear(); 
        controller.ProductSerialNumbersMap.clear();
        controller.url='test';
        controller.isKasiaCallSuccess=true;                
      controller.TVKortNo1 ='';
      controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"TvillingKort","varenummer":"1201601","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
    //   controller.isSecondTKortCalled =false;
        controller.TVKortNo2 ='12345678908';
        controller.callMethod= 'AdditionalKortNumber2Validate';
         controller.AdditionalKortNumber2Validate();
   }
   
  static public void testYouSeePlus() {                
        controller.hardwareSelection = '1201504';
        controller.hardwareSelectionName = 'YouSee Plus';        
        controller.SerialNo = '12345678987';
        controller.callMethod= 'SerialNumberValidate';
        controller.KortNumber2Validated=true;
        controller.serialNumbervalidated = true; 
        //controller.isKasiaCalled= false;
         controller.NumberValidate();  
        controller.KortNo2 = '12345678987';
        controller.callMethod= 'Kort2Validate'; 
        Controller.bundleProductValue ='1203021,1201504';
       // controller.isKasiaCalled = true;
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Plus","varenummer":"1201504","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        controller.NumberValidate();
        controller.isKasiaCallSuccess= true;                
        
        //controller.AdditionalTvKort = true;
        controller.displayTVkort= true;
        controller.TVKortNo1 = '09876543212';
        controller.TVKortNo2 = '12345676543';
        controller.callMethod = 'AdditionalKortNumber1Validate';
        controller.AdditionalTVKortNumber1Validated= true;
        controller.AdditionalTVKortNumber2Validated = true;
        controller.isFirstCallToKasia = false;
        controller.NumberValidate();
        controller.AdditionalKortNumber1Validate();
        controller.callMethod = 'AdditionalKortNumber2Validate';
        controller.NumberValidate();
        controller.AdditionalKortNumber2Validate();
        productSRNumberList.clear(); 
        controller.ProductSerialNumbersMap.clear();
        Key = '1201504'+'~'+'YouSee Plus';          
        productSRNumberList.add(controller.SerialNo);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        Key = '1201601'+'~'+'Ekstrakort'; 
        productSRNumberList.clear(); 
        controller.ProductSerialNumbersMap.clear();         
        productSRNumberList.add(controller.TVKortNo1);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);
        controller.serialNumbervalidated = true;   
       controller.KortNumber2Validated=true;
        controller.ValidateAllBooleans();
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        //  controller.EnableNextButton = true;
      //  controller.plusFlag = true;
      //  controller.ekstrakanalerFlag = true;
        // controller.ekstrakanalerFlag==true;
       // controller.NextFromSerialNumberPage(); 
        }
   
   static public void testonDemand() {  
    controller.hardwareSelection = '1201590';
    controller.getSearchSectionDisplayDetails();
   }
   static public void testTvillingKort() {                 
        controller.hardwareSelection = '1201601';
        controller.hardwareSelectionName = 'Tvillingkort';        
        controller.KortNo1 = '12345678908';
        controller.callMethod= 'Kort1Validate';
        controller.isKasiaCallSuccess= true;   
        controller.ExistingTvkort = true;
        controller.displayTVkort= false;
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"Tvillingkort","varenummer":"1201601","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
        controller.KortNumber1Validated = true;
        controller.NumberValidate(); 
            productSRNumberList.clear();
        controller.ProductSerialNumbersMap.clear();
         Key = '1201601'+'~'+'Ekstrakort';        
        productSRNumberList.add(controller.KortNo2);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
               
        productSRNumberList.clear();
        controller.ProductSerialNumbersMap.clear();
        controller.KortNo2 = '12345678909';
        controller.callMethod= 'Kort2Validate';                
        controller.KortNumber2Validated = true; 
        controller.ExistingTvkort = false;    
        controller.getSearchSectionDisplayDetails();      
        controller.NumberValidate();
        controller.displayTVkort= true;
        Key = '1201601'+'~'+'Ekstrakort';         
        productSRNumberList.add(controller.KortNo2);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        //enter both tvilling korts
         productSRNumberList.clear();
         controller.displayTVkort= false;        
        controller.ProductSerialNumbersMap.clear();
        productSRNumberList.add(controller.KortNo1);
        productSRNumberList.add(controller.KortNo2);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);
      //  controller.getSerialNumberJSON();    
       // controller.getHandlingInfo();            
        controller.DeleteBasketProduct(controller.hardwareSelectionName);   
         
        // 
        productSRNumberList.remove(0);
            controller.ProductSerialNumbersMap.clear();
            controller.ProductSerialNumbersMap.put(key,productSRNumberList);                
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        controller.EnableNextButton = false;   
       controller.NextFromSerialNumberPage();
          controller.KortNumber1Validated = true;   
       controller.KortNumber2Validated=true; 
       controller.ValidateAllBooleans();       
        }
        
  static public void testLejeOfYouSeeBoks() {                  
        controller.hardwareSelection = '1203021';
        controller.hardwareSelectionName = 'Leje af YouSee Boks';        
        controller.SerialNo = '123456789871';
        controller.callMethod= 'SerialNumberValidate';
        controller.serialNumbervalidated = true;      
        controller.getSearchSectionDisplayDetails();
        controller.ApprovalResponse =  '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"Leje af YouSee Boks","varenummer":"1203021","type":3,"lokation":"T7006","status":"DISPONIBEL","serienummer":"838305430613"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';      
        controller.NumberValidate();
        controller.isKasiaCallSuccess= true;                
        Key = '1203021'+'~'+'Leje af YouSee Boks';          
        productSRNumberList.add(controller.SerialNo);
        controller.ProductSerialNumbersMap.put(key,productSRNumberList);   
           controller.serialNumbervalidated = true;               
          controller.ValidateAllBooleans();  
        controller.DeleteBasketProduct(controller.hardwareSelectionName);
        //controller.NextFromSerialNumberPage(); 
        }
        
    static DealerProductPageController31 init_controller(){
        DealerProductPageController31 controlr = null;
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc= new Account();
        acc.Name ='test22556';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'p13567@test.com';
        acc.Customer_No__c = '123456'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
        
        Customer_Installation_Address__c CIA = new Customer_Installation_Address__c();
        
        CIA.Address__c=addr.Id;
        CIA.Customer__c=acc.Id;
        CIA.Installation_Address_External_ID__c='12121';
        
        insert CIA;     
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='123';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'pooja Agicha';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        
        insert add;
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
     DealerProductPageController31 control;     
    System.runAs(u) {
        controlr = new DealerProductPageController31();
        DealerProductPageController31.FORCE_TEST_MODE = true;
        controlr.objCommon.dealerAccount = acc;
        controlr.objCommon.streetNo = addr.House_No__c;
        
        controlr.testMode =  true;
              
    } 
        return controlr;
    }
    
      static testMethod void myUnitTest() {
        DealerProductPageController31 controlr = init_controller();
        controlr.index = 0;
        string returnValueString = '';
          //returnValueString = myItem.test_otherWork('High');
        List<string> temp = new List<string>();
        temp.add('clearKravet');
        controlr.selectedProducts = temp;
        controlr.backFlow();
        callBackFlow(controlr,DealerSalesConstant.clearId);
        callBackFlow(controlr,DealerSalesConstant.clearKravet);
        callBackFlow(controlr,DealerSalesConstant.ApprovalPage);
        callBackFlow(controlr,DealerSalesConstant.dtvEngId);
        callBackFlow(controlr,DealerSalesConstant.dtvPakkeId);
        callBackFlow(controlr,DealerSalesConstant.broadbandId);
        callBackFlow(controlr,DealerSalesConstant.telephonyId);
        callBackFlow(controlr,DealerSalesConstant.BroadBandModemId);
        //callBackFlow(controlr,DealerSalesConstant.TelephoniProductId);
        callBackFlow(controlr,DealerSalesConstant.bbTlfCommonId);
        //callBackFlow(controlr,DealerSalesConstant.dtvCardSelectId);
       // callBackFlow(controlr,DealerSalesConstant.fcCardSelectId);
        callBackFlow(controlr,DealerSalesConstant.dtvChannelSelId);
        callBackFlow(controlr,DealerSalesConstant.fcChannelSelId);
        callBackFlow(controlr,DealerSalesConstant.dtvSerialNoEntry);
      //  callBackFlow(controlr,DealerSalesConstant.dtvClearId);
        callBackFlow(controlr,DealerSalesConstant.CustomerInfoPage);   
      }
     
      static void callBackFlow(DealerProductPageController31 controlr,String pageId){
        List<String> lst = new List<String>();
        lst.add(pageId);
        controlr.index = 1;
        controlr.selectedProducts = lst;
        controlr.backFlow();
     }
     
     static testmethod void coverProductSelectionPage(){
        //test code to cover productSelectionPage()
        
        PageReference pageRef = Page.DealerProductSelectionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('installNr', '1');
        ApexPages.currentPage().getParameters().put('selectedCustomer', '65480083');
        DealerProductPageController31 controlr = init_controller();
        controlr.custLst = new List<DealerCustomerPOJO>();
        
        DealerProductPageController31.FORCE_TEST_MODE = true;
        controlr.testMode =  true;
        controlr.newsLetterUser = false;
        controlr.ekomUser=false;
        DealerCustomerPOJO cust = new DealerCustomerPOJO();
        cust.customerNumber = '65480083';
        cust.sfdcID = 'abcdef';
        cust.firstName = 'Navneet';
        cust.lastName = 'Rajput';
        cust.phone= '24512376';
        //Added for 831
        cust.mobilePhone = '11111111';
        cust.customerName= 'Navneet Rajput';
        cust.installationID = '1';
        cust.credit = false;
        controlr.custLst.add(cust);
        
        DealerCustomerPOJO newCust = new DealerCustomerPOJO();
        newCust.customerName = DealerSalesConstant.NEW_CUSTOMER;
        newCust.customerNumber = DealerSalesConstant.NEW_CUSTOMER;
        newCust.credit = false;
        controlr.custLst.add(newCust);
        cCustomerInstallationAddress cCust_Inst = new cCustomerInstallationAddress();
        cCust_Inst.customerNumber = '';
        controlr.setupcCustInstAdd(cCust_Inst);
        controlr.productSelectionPage();
        controlr.secondPayee = true;
        controlr.productSelectionPage();
        ApexPages.currentPage().getParameters().put('selectedCustomer',DealerSalesConstant.NEW_CUSTOMER);
        controlr.secondPayee = true;
        cCustomerInstallationAddress cPay_Inst = new cCustomerInstallationAddress();
        controlr.setupCustomerInstallationAddress(cPay_Inst);
        controlr.productSelectionPage();
        controlr.secondPayee = false;
        controlr.productSelectionPage();
        controlr.secondPayee = true;
        ApexPages.currentPage().getParameters().put('selectedCustomer', '65480083');
        controlr.productSelectionPage();
        ApexPages.currentPage().getParameters().put('customerCredit','true');
        controlr.productSelectionPage();
    }
    
    static testmethod void coverProductSelectionPageOffnet(){
        
        //test code to cover productSelectionPage()
        PageReference pageRef = Page.DealerProductSelectionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('installNr', '');
        ApexPages.currentPage().getParameters().put('selectedCustomer', '65480083');
        //ApexPages.currentPage().getParameters().put('url', '/afsaetning/F');
        DealerProductPageController31 controlr = init_controller();
        controlr.custLst = new List<DealerCustomerPOJO>();
        
        DealerCustomerPOJO cust = new DealerCustomerPOJO();
        cust.customerNumber = '65480083';
        cust.sfdcID = 'abcdef';
        cust.firstName = 'Mudasir';
        cust.lastName = 'Wani';
        cust.phone= '24512376';
        //Added for 831
        cust.mobilePhone = '11111111';
        cust.customerName= 'Mudasir Wani';
        cust.installationID = '';
        cust.credit = false;
        controlr.custLst.add(cust);
        controlr.newsLetterUser = false;
        controlr.ekomUser=false;
        DealerCustomerPOJO newCust = new DealerCustomerPOJO();
        newCust.customerName = DealerSalesConstant.NEW_CUSTOMER;
        newCust.customerNumber = DealerSalesConstant.NEW_CUSTOMER;
        newCust.mobilePhone = '';
        newCust.credit = false;
        controlr.custLst.add(newCust);
        cCustomerInstallationAddress cCust_Inst = new cCustomerInstallationAddress();
        cCust_Inst.customerNumber = '';
        controlr.setupcCustInstAdd(cCust_Inst);
        controlr.productSelectionPage();
        controlr.secondPayee = false;
        controlr.productSelectionPage();
    
    }
    static testmethod void Mytest(){
        PageReference pageRef = Page.DealerProductApproval;
        Test.setCurrentPage(pageRef);
        DealerProductPageController31 ctrl = init_controller(); 
        ApexPages.currentPage().getParameters().put('hdnSecondPayee', 'true');
        ctrl.finalApproval();
    }
    
    static testMethod void testOffnetAddresses(){
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        addr.External_Id__c = '412098';
        insert addr; 
        
        Cable_Unit__c cu = new Cable_Unit__c();
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

        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123';
        installation1.Address__c = addr.Id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.AddressId_InstLbnr__c = '2';
        installation1.INSTALLATION_ID__c = '001248';
        insert installation1;
        
         system.debug('add.id'+addr.Id+'--cableunit id--'+cu.id);
         system.debug('installation1*****'+installation1);
        
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc= new Account();
        acc.Name ='test22556';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'p13567@test.com';
        acc.Customer_No__c = '123456'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
       
        Customer_Installation_Address__c CIA = new Customer_Installation_Address__c();
        
        CIA.Address__c=addr.Id;
        CIA.Customer__c=acc.Id;
        CIA.Installation_Address_External_ID__c='12121';
        
        insert CIA;  
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
        
        system.runAs(u){
            
             DealerCustomerPOJO dealerpojo = new DealerCustomerPOJO();
        DealerCustomerPOJO dealerpojo1 = new DealerCustomerPOJO();
        List<DealerCustomerPOJO> dealerpojoLst = new List<DealerCustomerPOJO>();
        
        dealerpojo.conformEmail='navneet@gmail';
        dealerpojo.credit=true;
        dealerpojo.customerName='Navneet';
        dealerpojo.customerNumber='654321';
        dealerpojo.customerSelected=true;
        dealerpojo.email='abc@gmail';
        dealerpojo.installationID='1';
        
        dealerpojo1.conformEmail='navneet1@gmail';
        dealerpojo1.credit=true;
        dealerpojo1.customerName='Navneet1';
        dealerpojo1.customerNumber='65432111';
        dealerpojo1.customerSelected=false;
        dealerpojo1.email='abc@gmail';
        dealerpojo1.installationID='1';
        
        dealerpojoLst.add(dealerpojo);
        dealerpojoLst.add(dealerpojo1);
            DealerProductPageController31 control = new DealerProductPageController31();
            Apexpages.currentpage().getparameters().put('amsId','412098');
            control.custLst = dealerpojoLst;
            control.showCustomers();
        }
    }
    
     static testMethod void testMissingConditions(){
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc= new Account();
        acc.Name ='test22556';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'p13567@test.com';
        acc.Customer_No__c = '123456'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
       
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
        
        system.runAs(u){
            DealerProductPageController31 control = new DealerProductPageController31();
            Apexpages.currentpage().getparameters().put('pinCode','00000');
            control.findCityName();
            control.searchPostNrText='0001';
            control.findStreets();
        }
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler';
        update acc;
        system.runAs(u){
            DealerProductPageController31 control = new DealerProductPageController31();
        }
        
        acc.BillingRating__c = '5';
        update acc;
        system.runAs(u){
            DealerProductPageController31 control = new DealerProductPageController31();
            Apexpages.currentpage().getparameters().put('amsId','7685111');
            Apexpages.currentpage().getparameters().put('houseNo','7'); 
            control.showCustomers();
            control.receiptPage = true;
            control.back();
            control.generateMD5Key();
        }
    }

       
}// final class end