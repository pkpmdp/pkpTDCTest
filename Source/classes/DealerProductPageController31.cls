/**********************************************************************************
************************************************************************************

* @class: DealerProductPageController31
* @author: Capgemini Consulting India Pvt. Ltd.
* @date Modified: 13/10/2016
* @description: Class is used for test Prod salesflow part of DealerWeb directly without login to dealerweb.

************************************************************************************ 
***********************************************************************************/

 public class DealerProductPageController31 {
  public boolean isFirstCallToKasia{get;set;} 
    public boolean clearFlag{get;set;}
    public boolean plusFlag{get;set;}
    public boolean ekstrakanalerFlag{get;set;} 
    public String  smartCardNumber{get;set;}
    public boolean broadbandTelephonyCommonFlag{get;set;}
    public boolean telefoniFlag{get;set;}
    public boolean TlfBroadbandFlag{get;set;}
    public boolean onlyBroadbandFlag {get;set;}
    //Dw-861 - 5/3/15 - flag for BSXX flow
    public boolean dtvtaflag{get;set;}
    //DW-851
    public boolean onlySPFlag {get;set;}
    public boolean SPBroadbandFlag{get;set;}
    public boolean SPTlfFlag{get;set;}
    //public String creditOptSelected{get;set;}
    public boolean SPTlfBroadbandFlag{get;set;}
    //DW-851
    public boolean onlyCLBroadbandflag {get;set;}  
    
    public String searchPostNrText{get;set;}  
    public String amsId{get;set;}
    public String firstJsonResponse{get;set;}
    public String jsonResponse{get;set;}
    
    public boolean telFlag{get; set;}
    // public String secondJSONResponse{get;set;} 
    public static string JsonHardwareselection;
    // testing
    public static String netInstallationNr  {get;set;}
    public cCustomerInstallationAddress cCustInstAdd{get;set;}
    public void setupcCustInstAdd(cCustomerInstallationAddress CustInstAddNumber){
        cCustInstAdd=CustInstAddNumber;
    }
    
    public void setupCustomerInstallationAddress(cCustomerInstallationAddress customerInstAddress){
        payeeCustInstAdd=customerInstAddress;
    }
    //public DealerCustomerPOJO dealerProdPojo{get;set;}
    //public DealerCustomerPOJO payeeCustomerPojo{get;set;}
    public List<String> selectedProducts;       
    public String displayProperty{get;set;}
    //public String displayProperty1{get;set;}   
    public List<SalesFlow_Informationer__c> filteredInformationList{get;set;}
    public Map<String,Map<String,List<Product>>> productMap= new Map<String,Map<String,List<Product>>>();    
    public Integer index = 0;
    public string clearTv{get;set;}
    public string bredband{get;set;}
    //public string SPbredband{get;set;}
    public string telefoni{get;set;}
    public string plus{get;set;}
    public string ekstrakanaler{get;set;}
   // public string pakkeForSlagMessage{get;set;}
    public boolean showCustomerBlock{get;set;}
    public boolean showCustomerAddress{get;set;}
    public String newNumber{get;set;}
    //public String ExistingNumber{get;set;}   
    public boolean receiptPage {get;set;}
    public boolean checkBBFlag {get;set;}
    public boolean checkTLFFlag {get;set;}
    public boolean checkSPBBFlag {get;set;}
    public boolean checkCLFlag{get;set;}//DW-855
    public String parseJSON;
    public List<String>listOfJsonTelNum; 
  //  public Boolean badCreditRating{get;set;}    
    public string SerialNo{set;get;}
    public string KortNo1{set;get;}
    public string KortNo2{set;get;}
    public boolean SerialNoSection{get;set;}
    public String TvBox{set; get;}//DW-880
    public boolean tvBoxSection{get;set;} //DW-880
    public boolean KortSection1{get;set;}
    public boolean KortSection2{get;set;}
    public boolean BilledelegitimationSection{get;set;}
    boolean Validated = false;
    string SerialNovar;
    public string dummySerialNo{set;get;}
    public Boolean testMode { get; set; }
    public static Boolean FORCE_TEST_MODE = false;
    string response;
    boolean Approved = false;
    public string error{get;set;}
    List<string> ValidatenosLst = new List<string>();
    public string hardwareSelection{get;set;}
    //public string selectedRadio{get;set;}
    public string KortNr{get;set;}
    //public String kortNumber{get;set;}
    public Set<String> selectedIdSet = new Set<String>();
    public String url{get; set;}
    public String etag{get; set;}
    public String kundeData{get; set;}
    //public String productKotnavn{get; set;}
    //public String kundeId{get; set;}
    public String arrayInit{get; set;}
    public String telePhoneDirectoryName{get;set;}
    public String telePhoneDirectoryID{get;set;} 
    public list<ProductOfferWrapper>ProductOfferWrapperList {get;set;}
    public String extTelephoneId{get;set;}
    public String newTelephoneId{get;set;}
    public String tlfNumberForNumberPorting {get;set;}
    public String emailIdForNumberporting {get;set;}
    public String dateForNumberPorting {get;set;}
    public boolean clearForNewCustomerFlag {get;set;}
    public boolean KortNumber2Validated {get;set;} { KortNumber2Validated = false;}    
    public boolean KortNumber1Validated {get;set;} {KortNumber1Validated =  false;}
    public boolean serialNumbervalidated {get;set;} {serialNumbervalidated = false;} 
    public boolean serialNumberTVBoxvalidated {get;set;} {serialNumbervalidated = false;}//DW-880
     public string tvBoksURL;//DW-880
    //public string ApprovalListResponse{get;set;}
    //public string ApprovedJsonResponse{get;set;} 
    public string callMethod {get;set;}
    public boolean ExistingTvkort {get;set;} {ExistingTvkort = false;}
    public string TVKortNo1 {get;set;} 
    public string TVKortNo2 {get;set;} 
    public boolean displayTVkort {get;set;} {displayTVkort = false;}
    boolean AdditionalTvKort = false;
    public boolean AdditionalTVKortNumber1Validated {get;set;} {AdditionalTVKortNumber1Validated = false;}
    public boolean AdditionalTVKortNumber2Validated {get;set;} {AdditionalTVKortNumber2Validated = false;}
    public boolean isKasiaCallSuccess {get;set;} {isKasiaCallSuccess = false;}
    public Map<String,List<string>> ProductSerialNumbersMap = new  Map<String,List<string>>();
    public boolean EnableNextButton {get;set;} {EnableNextButton=  false;} 
    public boolean subscriptionFlag {get;set;} {subscriptionFlag = true;}
    public string hardwareSelectionName {get;set;}
    public Map<String,List<string>> ProductSerialNumbersMapProp {get {return ProductSerialNumbersMap;}}
    List<string> productSRNumberList ;//= new List<string>();
    string Key;
    string oldHardwareProduct='';
    // following code is use to get end point from salesflow custom link
    public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    //private final String END_POINT = castIronEndPoint.END_POINT__c;
    private final String END_POINT = 'https://TDCGroupTRIAL79207.jitterbit.eu/prod/1/Kasia20'; //clsConnectionUtils_Admin.getEndPoint('Kasia20');
    public boolean enableTvlkortFlag {get;set;} {enableTvlkortFlag=false;}
    public string SelectedIDRadioValue {set;get;}  
    public boolean accInserted = false;
    public String produktUrl{get; set;}
    public string  productJsonResponse{get;set;} 
    public boolean broadbandUpgradationFlag {get;set;}
    public void settingDealerValues(List<DealerCustomerPOJO> customerListObj){
        custLst=customerListObj;
    }
    // Declared Telephony variables
    public List <String> telephoneNumberLst;
    public String selectedNumber{get;set;}
    public String selectedNumberForNP{get;set;}
    public boolean telephoniFlag{get;set;}
    //public String npHref {get;set;}
    public String NPMergedstring {get;set;}
    public string bundleProductValue{set;get;}
    public boolean canDealerSellTlfprod {get;set;}
    // getting logged in dealer Id 
    public commonclass objCommon; 
    Public String loggedInDealerId = '';
    public boolean ValidatedState{get;set;}
    private boolean isSerailNoProduct = false;
    public String productsSelected{get; set;}
    public ID accountIdNewCustomer{get; set;}
    public SalesFlowText1 salesFlowObj{get;set;}   
    public String CampaignColorAndDescriptionJson{get;set;}
    // following code is used to get Kasia_EndPoint point from custom settings.
    public END_POINT__c KasiaEndPoint = END_POINT__c.getInstance('Kasia_EndPoint');
    private final String kasia_EndPoint =  KasiaEndPoint.END_POINT__c;
    public String selectedAbonnementerAftalenr{get;set;}
    // Receipt page variables.
    public String receiptValgtResponse{get;set;}
    public String priceJsonResponse{get;set;}
    public String productJsonArray{get;set;}
    public Map<String,String> productSummaryMap{get;set;}
    public String oneTimePriceForBBnTFValue{get;set;}
    //Carrie-805
    boolean placeOrderCall;  
    //DW-689
    public boolean isYouBioSelected {get ; set ;}
    public boolean isYouBioBoxSelected {get ; set ;}{isYouBioBoxSelected = false;}
    public boolean isYouBioAbnSelected {get ; set ;}{isYouBioAbnSelected = false;}
    private String dibsTransactionId; 
    
    public String youBioPriceJson{get;set;}
    public String existingYoubio {get ; set ; }
    //DW-755
    
    public List<Net_Installations__c> netInstall {get; set;}
    //Added for DealerWeb-746
    public Boolean badCreditRating{get;set;}{badCreditRating = false;}
    //Added for 755
    boolean createKundeCall;
   
    DealerwebSearch_Util dwSearchUtil;
    DealerwebKasiaServices_Util1 dwKasiaServicesUtil;
    public boolean isBlandSelvFlow{get;set;}
    public boolean isBlandSelvSelected{get;set;}
    public boolean isFreeChoicePageFlag{get;set;}
    public boolean isDtvChannelSelectionPageFlag{get;set;}
    public String currentPageId{get;set;}{currentPageId='';}
    public list<Dealerweb_OrderedProduct_Report__c> ProductReportList=new list<Dealerweb_OrderedProduct_Report__c>();//added for salesflow
    
    //DW-844 modification START
    public string TVKortNo3 {get;set;} 
    public string TVKortNo4 {get;set;} 
    public boolean AdditionalTVKortNumber3Validated {get;set;} {AdditionalTVKortNumber3Validated = false;}
    public boolean AdditionalTVKortNumber4Validated {get;set;} {AdditionalTVKortNumber4Validated = false;}
    public string prodArray {get; set;} //DW-855
    public Boolean tvKortSelected {get; set;}{tvKortSelected = false;}
    public string isTelephninBasket{get; set;} // DW-855
    //public string isTelephninBasket1 = ApexPages.CurrentPage().getParameters().get('telephninbasket');
        //DW-844 modification END
    public Boolean isTelephninBasket1;
    public string responseCode;//EDM-637 KASIA20 service changes
    //CONSTRUCTOR
    public DealerProductPageController31(){  
      map<string,DealerWebProducts__c> mapDWProds = DealerWebProducts__c.getAll();
      string[] listProdNames = new string[]{};
      for(DealerWebProducts__c prod : mapDWProds.values())
      {
        listProdNames.add(prod.Name);
        //system.debug(listProdNames);
      }
      prodArray = JSON.serialize(listProdNames);
      //system.debug('cloudArray ******* '+cloudArray);
      orderId = '';
      hasMultipleInstallations = false; 
      netInstall = new List<Net_Installations__c>();
      isYouBioSelected = false;
      existingYoubio = 'false';
      isOffnetAddress = false;
      placeOrderCall = false;
      receiptPage=false;
      custLst = new List<DealerCustomerPOJO>();
      custLstInactive = new List<DealerCustomerPOJO>();
      custLstActive = new List<DealerCustomerPOJO>();
      showAddressSearchButton = true;
      showCustomerBlock=false;
      showCustomerAddress=true;
      telephoniFlag=false;
      streetSuggestion ='[]'; 
      productJsonResponse = '{}';
      hasCustomerYouSeeCard=false;
      dummySerialNo = '0';
      isBlandSelvFlow = false;
      isBlandSelvSelected = false;
      isFreeChoicePageFlag = false;
      isDtvChannelSelectionPageFlag = false;
      broadbandTelephonyCommonFlag = false;
      telefoniFlag = false;
      //DW-865
      dtvtaflag=false;
      //DW-851
      onlySPFlag =false;
      //DW-855
      onlyCLBroadbandflag=false;
      SPBroadbandFlag=false;
      SPTlfFlag=false;
      SPTlfBroadbandFlag=false;
      //DW-851
      telePhoneDirectoryName = '';
      selectedNumberForNP = '';
      currentPageId = '';
      productSummaryMap = new  Map<String,String>();
      List<product2> ProductList = [select Product_Summary__c,Product_Number__c,Campaign__c, Offer__c from Product2 where Isactive=true];
      ProductOfferWrapperList = new List<ProductOfferWrapper>();
     
     //Added for 755
     netInstallationNr = '';
     createKundeCall = false;
     
     for(Product2 prd:ProductList)
        {
             
                ProductOfferWrapper PrdWrapper = new ProductOfferWrapper();
                PrdWrapper.ProductNumber = prd.Product_Number__c;
                PrdWrapper.ProductOfferExists = prd.Offer__C;//string.valueOf(prd.Offer__C);
                PrdWrapper.ProductCampaignExists = prd.Campaign__c;
                PrdWrapper.ProductSummary = Prd.Product_Summary__c;
                productSummaryMap.put(prd.Product_Number__c,Prd.Product_Summary__c);
                ProductOfferWrapperList.add(PrdWrapper);
        }
                JsonHardwareselection = jsonResponse;
                System.debug('jsonresponse value-->'+jsonResponse);
                
              // Need to uncomment following code after configuration of this page with delaer web   
               objCommon = new commonclass(); 
                if (objCommon.dealerAccount.Dealer_Number__c!= null && objCommon.dealerAccount.Dealer_Number__c!=''){
                    loggedInDealerId = objCommon.dealerAccount.Dealer_Number__c;
                }
                system.debug('objCommon.productsDealerCanSell----------------------'+objCommon.productsDealerCanSell);
               if (objCommon.productsDealerCanSell.contains('Telefoni')){
                    canDealerSellTlfprod=true;
               } else {
                    canDealerSellTlfprod=false;
               }             
               system.debug('salesFlowObj ' +salesFlowObj);
               
               dwSearchUtil = new DealerwebSearch_Util();
               dwKasiaServicesUtil = new DealerwebKasiaServices_Util1();
           
    }
    
    /**
    * @description: Call the SalesFlowText class to generate messages to be displayed on the page
    * @related to: Issue 472
    */ 
    public void initializeText(){
        String url = ApexPages.currentPage().getUrl();              
        salesFlowObj = new SalesFlowText1();
        salesFlowObj.retrieveSalesForceInfoText(url);        
    }    
    /* Cloud Product custom settings = //DW-855
    public list<string> getCloudProds()
    {
      map<string,DealerWebCloudProds__c> mapCloud = DealerWebCloudProds__c.getAll();
      for(DealerWebCloudProds__c cloudList : mapCloud.values())
      {
        list<string> listProdNames = new list<string>();
        listProdNames.add(cloudList.DealerProduct_Name__c);
        cloudArray = JSON.serialize(listProdNames);
      }
      
    }*/
    /**  ADDRESS AND CUSTOMER SEARCH FUNCTIONALITY START   ************************/
    
    public String cityName{get;set;}
    public String streetSuggestion{get;set;}
    public String searchAddressMsg {get;set;} 
    public boolean showAddressSearchButton{get;set;}
    public List<DealerCustomerPOJO> custLst{get;set;}
    public String searchStreetText{get;set;}
    public String searchHouseText{get;set;}
    public List<Address__c> addresses{get;set;}
    
    /**
    * @method     : findCityName
    * @Description: Find the name of the city for a given postal code and return the same.
    *               If no result is found then return '@@##' string.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation:  The method is invocated from DealerCustomerSearch page by entering the pincode in the textbox provided against the Postnummer.
    */
    public void findCityName(){
        String pinNumber = ApexPages.CurrentPage().getParameters().get('pinCode');
        cityName = dwSearchUtil.findCityName(pinNumber);
    }
    
    /**
    * @method     : findStreets
    * @Description: This method is used to display the street suggestions on a visual force page namely DealerCustomerSearch.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation:  The method is invocated from DealerCustomerSearch page by entering the letter of city in the textbox provided against the Vejnavn.
    */
    public void findStreets(){
       String street =  ApexPages.CurrentPage().getParameters().get('streetName')+'%';
       streetSuggestion = dwSearchUtil.findStreets(street,searchPostNrText);
       system.debug('streetSuggestion ---- '+streetSuggestion);
    }
    
    /**
    * @method     : searchAddress
    * @Description: This method is used to search the addresses associated to the given street name and  postal code number.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation:  The method is invocated from DealerCustomerSearch page by clicking on "Søg Adresse" button.
    */
    public void searchAddress(){
        System.debug('**** searchAddress ************');
        showAddressSearchButton = true;
        searchAddressMsg='';
        if(custLst!=null){
             resetCustomerLists(custLst);
        }
        system.debug('Inside searchAddress #################------------');
        String streetName = ApexPages.CurrentPage().getParameters().get('streetName');
        searchStreetText = streetName;
        String houseNo = ApexPages.CurrentPage().getParameters().get('houseNo');
        searchHouseText = houseNo;
        List<Address__c> addrs = dwSearchUtil.searchAddress(streetName, searchPostNrText,houseNo);                          
                                      
        if(addrs!= null && addrs.size()>0){
            //system.debug('If addrs size is greater than 0.');
            addresses = addrs;            
        }
        else {            
            addresses = null;
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Adressen findes ikke.');
            ApexPages.addMessage(m);
        } 
    }
    
    Map<String,Net_Installations__c> netInstallMap;
    public boolean isOffnetAddress {get ; set ;}
    public String addressJsonResponse{get; set;}
    public boolean hasMultipleInstallations {get ; set; }
    public Boolean secondPayee=false;
    public cCustomerInstallationAddress payeeCustInstAdd{get;set;}
    public List<DealerCustomerPOJO> custLstInactive{get;set;} 
    public List<DealerCustomerPOJO> custLstActive{get;set;}
    
    /**
    * @method     : showCustomers
    * @Description: Find the customers on a given address.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation:  The method is invocated from DealerCustomerSearch page by clicking on the link in the Vejnavn column which appeared when "Søg Adresse" button is clicked.
    */
    public void showCustomers(){        
    try{
        if(custLst!=null){ 
               resetCustomerLists(custLst);
        }
        system.debug('$$$$$$$$$$$ customers: 1' + custLst.size());
        system.debug('$$$$$$$$$$$ active: 1' + custLstActive.size());
        system.debug('$$$$$$$$$$$ inactive: 1' + custLstInactive.size());
        amsId = ApexPages.CurrentPage().getParameters().get('amsId');
        system.debug('inside showCustomers---------------########--------'+amsId);
        String serviceAddressURL='adresse/installationer/'+amsId;
        Address__c  addr = dwSearchUtil.selectAnAddress(amsId);
        netInstallMap = new Map<String,Net_Installations__c>();
        netInstallMap = dwSearchUtil.getnetInstallationsOnAddress(addr);
        system.debug('netInstallMap ' +netInstallMap.size());
        //Added for DW-689 to display message for Offnet Addresses
        if(netInstallMap.size() == 0){
          isOffnetAddress = true;
          addressJsonResponse = '';
          hasMultipleInstallations = false;
        }
        else {
          isOffnetAddress = false;          
          if(serviceAddressURL != null){
            System.debug('before call');
            System.debug('endpoint: ' + END_POINT);
            System.debug('serviceUrl: ' + serviceAddressURL);
            testMode = FORCE_TEST_MODE;
              //calling address service for amsid
              //addressJsonResponse = callout2(END_POINT+'/Kasia20','', 'GET', serviceAddressURL, '','adresse');
              //addressJsonResponse = dwKasiaServicesUtil.afsaetningKasiaService(END_POINT+'/Kasia20', '', 'GET', serviceAddressURL,'', 'adresse', netInstallMap, broadbandTelephonyCommonFlag, telefoniFlag, isYouBioSelected, placeOrderCall, netInstallationNr, createKundeCall, testMode);
              //EDM-637 START
              addressJsonResponse = dwKasiaServicesUtil.afsaetningKasiaService(END_POINT, '', 'GET', serviceAddressURL,'', 'adresse', netInstallMap, broadbandTelephonyCommonFlag, telefoniFlag, isYouBioSelected, placeOrderCall, netInstallationNr, createKundeCall, testMode);
              //EDM-637 END
              // jsonResponse = addressJsonResponse;
              System.debug('addressJsonResponse->'+addressJsonResponse);
              //Added for DW-755 to display message for addresses with multiple installations
              if(addressJsonResponse != null && addressJsonResponse != ''){
                List<Object> addressJSONMap = (List<Object>)JSON.deserializeUntyped(addressJsonResponse);
              if(addressJSONMap.size() > 1){
                hasMultipleInstallations = true;
              }
              else{
                hasMultipleInstallations = false;
              }
            }
          }
        }
        if(secondPayee && payeeCustInstAdd != null){  
             payeeCustInstAdd.addr = addr;
             payeeCustInstAdd.amsId = amsId;                      
        }else {
            cCustInstAdd = new cCustomerInstallationAddress();
            cCustInstAdd.addr = addr;
            cCustInstAdd.amsId = amsId;
            secondPayee = false;
        }
        //Added for 689
        if(isOffnetAddress){
            custLstActive = dwSearchUtil.activeOffnetCustomers(amsId);
            custLst.addAll(custLstActive);
        }
        else{ 
             custLst = dwSearchUtil.onNetCustomers(amsId);
             custLstActive = dwSearchUtil.activeOnNetCustomersList;
             custLstInactive = dwSearchUtil.inActiveOnNetCustomersList;
        }
        
        DealerCustomerPOJO newCust = new DealerCustomerPOJO();
        newCust.customerName = DealerSalesConstant.NEW_CUSTOMER;
        newCust.customerNumber = DealerSalesConstant.NEW_CUSTOMER;
        newCust.credit = false;
       
        // DW - 770
        custLst.add(newCust);
        custLstActive.add(newCust); 
        
        system.debug('custLst iii ' +custLst);
        showCustomerBlock=true;
        showCustomerAddress=false;
        system.debug('At the end of showCustomers.');
        system.debug('$$$$$$$$$$$ customers: 2' + custLst.size());
        system.debug('$$$$$$$$$$$ active: 2' + custLstActive.size());
        system.debug('$$$$$$$$$$$ inactive: 2' + custLstInactive.size());
        }catch(Exception e){   
            ApexPages.addMessages(e);
        }
     } 
     
    /**  ADDRESS AND CUSTOMER SEARCH FUNCTIONALITY ENDS   ************************/ 
    
    public Set<string> getProductSerialNumbersMapKeys()
        {
           return ProductSerialNumbersMapProp.keyset();
        }
    public void dummyAction(){
        displayProperty='display:none';
    }
    
    public void dummyAction1(){
        setDisplayProperty('display:Block');
    }
    
    public String getDisplayProperty(){
       return displayProperty;
    }  
    
    public void setDisplayProperty(String prop){
    
        this.displayProperty=prop;
    }
    public String AMSidForSingleAddress='';
   
    
    
    /************************************************************************************************************************************/
    public Boolean getCustomerFlag(){
        return (custLst != null && custLst.size()>0);
    }
     //FOR APPROVAL PAGE
    public cCustomerInstallationAddress getCustomerInstallationAddress(){
        if(secondPayee){
            return payeeCustInstAdd;
        }else{
            return cCustInstAdd;
        }
    }
    public string totalPrice {get;set;}
     /**COMMON METHODS***************************************************************************************************************/
    public PageReference back(){
        
        showCustomerBlock=true;
        showCustomerAddress=false;
        system.debug('custLst: '+custLst);
       // system.debug('**receiptPage***'+receiptPage);
        if(!receiptPage)
        {
                String perviousPage = ApexPages.CurrentPage().getParameters().get('perviousPage');
                System.debug('perviousPage -->>  '+perviousPage);
                PageReference pageRef = new PageReference(perviousPage);
                //PageReference pageRef = Page.DealerCustomerSearch;
                //PageReference pageRef = Page.CustomersForAddressPage;
                return pageRef.setRedirect(false);
        }
        else
        {
                receiptPage = false;
                return Page.DealerProductApproval1;
        }
    }
    
    public PageReference backToDealerProduct(){
        showCustomerBlock=false;
        showCustomerAddress=true;
        showAddressSearchButton = false;
        String perviousPage = ApexPages.CurrentPage().getParameters().get('perviousPage');
        PageReference pageRef = new PageReference(perviousPage);
    
        return pageRef.setRedirect(false);
    }
    
    public PageReference cancel(){
        PageReference pageRef = Page.DealerCustomerSearch1;       
        pageRef.setRedirect(true);             
        return pageRef; 
    }
    /* FIRST CALL TO KASIA*/
     private String callout2(String endpoint, String body, String serviceMethod, String serviceUrl, String etag,string application) { 
        System.debug('endpoint: ' + endpoint);
        System.debug('body: ' + body);
        System.debug('serviceMethod: ' + serviceMethod);
        System.debug('serviceUrl: ' + serviceUrl);
        System.debug('etag: ' + etag);
        
        // This code block should be removed when moved to test.
        if(serviceUrl.contains(':41004'))
        serviceUrl = serviceUrl.replace(':41004','');
        // Make the callout and check the response 
        System.debug('*********call out general method begin');        
        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setMethod(INTEGRATION__c.getInstance('Kasia20').HttpMethod__c); 
        req.setEndpoint(endpoint); 
        req.setHeader('charset', 'utf-8'); 
        req.setHeader('accept-encoding', 'gzip'); 
        req.setHeader('accept', 'application/vnd.yousee.kasia2.'+application+'+json;version=1;charset=UTF-8'); 
        req.setHeader('content_type','application/vnd.yousee.kasia2.kunde+json;version=1');
        //this is done by castiron before and now we need to specify it in client
        //afsaetning+
        req.setHeader('if_match', etag); 
        req.setHeader('serviceUrl', serviceUrl); 
        req.setheader('serviceMethod', serviceMethod); //put, get, post etc.
        req.setHeader('salesChannel', 'F');  
        system.debug('placeOrderCall ' +placeOrderCall);
        //Added for Carrie-805, to pass x-aria switch in header for telephony orders
        //Added isYouBioSelected for 689
        if(System.Label.DealerWebEnvironment == 'Test' && (broadbandTelephonyCommonFlag==true || telefoniFlag==true || isYouBioSelected == true) && placeOrderCall){
          req.setHeader('x-aria-switch','carrie1');
          //system.debug('added header for x-aria switch');
        }
       
        system.debug(netInstall.size() + ' ' + netInstallationNr + ' ' +createKundeCall);

      //Added for Multiple Installations scenario : DW-755

      if(netInstall.size() >0 && netInstallationNr != '' && netInstallationNr != null && createKundeCall){
      req.setHeader('Net_Installation_Id ', netInstallationNr);
      system.debug('added header for Net Installation Id ' + netInstallationNr);
   }
        
        
        req.setBody((body == null ? '' : body)); //equal to the requestBody before, the real body that is sent to kasia2 service
       // req.setCompressed(true); -- shailesh 11-aug 
        req.setTimeout(80000);         
        HttpResponse res; 
        try { 
        
            System.debug('request in callout2->'+req);
            testMode = FORCE_TEST_MODE;                           
            if(!(testMode)){
            res = http.send(req); 
            }
             System.debug('res: ' + res);
            responseCode = String.valueOf(res.getStatusCode());
             if (res != null) {                 
                    if (res.getStatusCode() == 200 ||res.getStatusCode()==201) {                        
                        // Good response || res.getStatusCode() == 201
                        response = res.getBody();
                        
                        System.debug('response Testing' + response);
                        return response;
                    }
                    else{
                        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Incorrect JSON Response.');
                        ApexPages.addMessage(m); 
                        return null; 
                    }
                }
                else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'JSON Response is null.');
                    ApexPages.addMessage(m);  
                    return null; 
                }
        } 
        catch (Exception e) { 
            System.debug('****call castiron error'); 
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage()); 
            ApexPages.addMessage(m);   
            return null;                          
        }   
    } 
         
   // Make second call to Casia
         public String secondCallToCasia(String url,String arrayInit,String kundeData,String etag){
                try{
                 // url = 'afsaetning/opret/1101601';
                String body = '{"kunde-data":'+kundeData+',"array-init":"'+arrayInit+'"}';
                //String request ='PUT /afsaetning/opdater/dummy-1/1301123  !#$  -900150296  !#$ ' + body; 
                system.debug('-----------prepare body for making secong call--------------------------------'+body+' and the url is *************'+url);
                // This code block should be removed when moved to test.
                if(url.contains(':41004'))
                url = url.replace(':41004','');
                // code block ends.
                system.debug(' the url is *************'+url);
                String response;
                if(String.isBlank(body))
                  response = callout2(END_POINT, body, 'GET', url,etag,'afsaetning');
          		else
                  response = callout2(END_POINT, body, 'PUT', url,etag,'afsaetning');
          
                system.debug('---------second call response --------@@@@@@@@@@@@@@--------------'+response);
                 System.debug('Endpoint::'+END_POINT);    
                    return response;
                }
                catch(exception ex){
                        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,  ex.getMessage());
            ApexPages.addMessage(m); 
            return null;
                }
        } 
    //HANDLE NAVIGATION
    private PageReference getDestinationPageName(String pageId){
     System.debug('pageId#'+pageId);
     currentPageId='';
     currentPageId=pageId;
     isFreeChoicePageFlag = false;
     isDtvChannelSelectionPageFlag = false;
     PageReference pageIdRef = null;
        if(pageId == DealerSalesConstant.clearId){
            pageIdRef = Page.clearProductsPage1;
        } else if(pageId == DealerSalesConstant.clearKravet){
            pageIdRef = Page.clearKravet1;
        }else if(pageId ==DealerSalesConstant.ApprovalPage){
            pageIdRef = Page.DealerProductApproval1;
        }
        //DW-861 3/5/3015 - BSXX selection page
        else if(pageId ==DealerSalesConstant.dtvtaId){
            pageIdRef = Page.dealerbsprods1;
        }
        else if(pageId == DealerSalesConstant.dtvEngId){// || (pageId == DealerSalesConstant.dtvPakkeId)){
            pageIdRef = Page.DtvHardwareSelection1;
        }else if(pageId == DealerSalesConstant.dtvPakkeId){
                pageIdRef = Page.DtvHardwareSelection1;
            //pageIdRef = Page.fcHardwareSelection;   
        }else if(pageId == DealerSalesConstant.broadbandId){
            pageIdRef = Page.BroadBandProductPage1;
        }else if(pageId == DealerSalesConstant.telephonyId){
            pageIdRef = Page.telefoniProductsPage1;                        
        }else if(pageId == DealerSalesConstant.BroadBandModemId){
            //Here needs to put Modem Page ref
            pageIdRef = Page.BroadBandModemPage1;                        
        }/**else if (pageId == DealerSalesConstant.TelephoniProductId){ 
                pageIdRef = Page.telephoniDetailsPage;
        }*/
        else if (pageId == DealerSalesConstant.bbTlfCommonId){
                pageIdRef = Page.telefoniProductsForPhone1;
        }
        else if (pageId == DealerSalesConstant.youBioId){
                pageIdRef = Page.DealerYouBioProductSelection1;
        }/**else if((pageId ==DealerSalesConstant.dtvCardSelectId) || (pageId ==DealerSalesConstant.fcCardSelectId)){
            pageIdRef = Page.DtvSmartCardSelection; 
        }*/
        else if(pageId ==DealerSalesConstant.dtvChannelSelId ){// || (pageId ==DealerSalesConstant.fcChannelSelId)){
            isDtvChannelSelectionPageFlag = true;
            pageIdRef = Page.DtvChannelSelectionPage1;
        }else if(pageId ==DealerSalesConstant.fcChannelSelId){
            isFreeChoicePageFlag = true;
            pageIdRef = Page.FreeChoice; 
        }else if( (pageId ==DealerSalesConstant.dtvSerialNoEntry) || pageId ==DealerSalesConstant.fcSerialNoEntry){
            pageIdRef = Page.SerialNumberEntryPage1; 
        }/**else if(pageId ==DealerSalesConstant.dtvClearId){
            pageIdRef = Page.DtvClearProducts;
        }*/
        else if(pageId ==DealerSalesConstant.CustomerInfoPage){
            pageIdRef = Page.CustomerInfoPage1; 
        } 
        system.debug('Pageref ***** '+pageIdRef);
        return pageIdRef;               
    }
    
    private void addIntermediatePageToFlow(String pageId){
        currentPageId='';
        currentPageId=pageId;
       /* if(pageId == 'dtvEngId' && isBlandSelvSelected){
            //currentPageId = 'dtvEngIdBS';
        }*/
        system.debug('Inside addIntermediatePageToFlow----------------------------'+selectedProducts+'  and pageid added is $$$$$$----'+pageId);
        //Code added for Bland Selv
        Boolean addProductToList = true;
        system.debug('selectedIdSet values are -'+selectedIdSet);
        if(selectedProducts.size() > 0){ 
            for(Integer selProd =0;selProd < selectedProducts.size();selProd++){
                if(selectedProducts[selProd] == currentPageId){
                    addProductToList = false;
                    break;
                }
            }
        }
        system.debug('addProductToList['+addProductToList+']');
        currentPageId=pageId;
        if(selectedProducts.size()-1 == index){
            if(addProductToList){
                selectedProducts.add(pageId);//selectedIdSet
            }
        }else{
            if(addProductToList){
                if(selectedIdSet.contains(selectedProducts[index+1])){
                selectedProducts.add(index+1,pageId);
                }else{
                    system.debug('Inside addIntermediatePageToFlow------else--------');
                    selectedProducts[index+1] = pageId;
                }
            }
            
        }
        system.debug('selectedProducts----------------------------'+selectedProducts);
    }
        // METHOD TO MANAGE NAVIGATION  
    public PageReference nextFlow(){
        PageReference pageRef = null;
        system.debug('isBlandSelvFlow  *******************   '+isBlandSelvFlow);
        system.debug('selectedProducts =============================> '+selectedProducts+ '------size' +selectedProducts.size());
        system.debug('index =============================> '+index);
        system.debug('ProductSerialNumbersMap *******************    '+ProductSerialNumbersMap);
        index++;
        system.debug('next page index =============================> '+index);               
        if(selectedProducts.size() == index){
            pageRef = Page.CustomerInfoPage1;
        }else{
            pageRef = getDestinationPageName(selectedProducts[index]);
            system.debug('selectedProducts[index]-------'+selectedProducts[index]+'  ---$$$$$$$$$$ '  + pageRef);
            //getSelectedProductsForPage();                 
        }
        pageRef.setRedirect(false);             
        return pageRef; 
    } 
    
     public PageReference backFlow(){
       system.debug('index in backflow ' +index+'---selectedProducts.size()---'+selectedProducts.size());
       system.debug('selectedProducts................ '+selectedProducts);
       system.debug('backflow Called................');
       system.debug('JsonHardwareselection **************************************'+JsonHardwareselection);
       System.debug('In Backflow...  '+ jsonResponse);
       String indexedSelectedProduct = '';
       if(index ==0){
        indexedSelectedProduct = selectedProducts[index];
       }else{
        indexedSelectedProduct = selectedProducts[index-1];
       }
       system.debug('isBlandSelvSelected ***'+isBlandSelvSelected+ '-----indexedSelectedProduct  is **'+indexedSelectedProduct+'--plusFlag***'+plusFlag);
       if(isBlandSelvSelected && indexedSelectedProduct =='clearKravet'){
            //remove DtvHardwareSelection page
            removeDtvEngIdBSAndDtvSerialNoEntryBS();
            isBlandSelvSelected= false;
            hasCustomerYouSeeCard = false;
        }
        //ResetSerialPageValues();
        PageReference pageRef = null;
        if(index==0){
            pageRef = Page.DealerProductSelectionPage1;
        }else{
            index--;
                system.debug('inside else................ '+selectedProducts[index]);
            pageRef = getDestinationPageName(selectedProducts[index]);
        }
        pageRef.setRedirect(false);   
        return pageRef; 
    }
    // public String mergeFields{get;set;}
   public Set <String> productTypeSet;// = new Set <String>();
   public List <String> productNameLst;// = new List <String>(); 
   public List<String> temp1;
    
   public void parseProducts(String productStr){
        List<String> firstSplit= productStr.split('#&#',0);
        system.debug('firstSplit------------- '+ firstSplit);
        productTypeSet = new Set <String>();
        productNameLst = new List <String>();
        temp1=new List <String>();
        
        for (String parseStr : firstSplit){
                temp1.clear();  
                temp1= parseStr.split('!#@',0);
                //productMap.put( temp1[1],temp1[0]);
                if (temp1.size()>0){
                    productTypeSet.add(temp1[1]);
                    productNameLst.add(temp1[0]);
                }
        }
        system.debug('productTypeSet-----####################-----------'+productTypeSet);
        //system.debug('productNameLst-----###################------------'+productNameLst);
   } 
    
   public void subsequentCallToKasia(){
        String respCode = secondCallToCasia();
   }
    
   // public String mergeFields{get;set;}
   public string secondCallToCasia(){
        String href='';
        String url='';
        //string responseCode=null;
        system.debug('Inside nextFlow1---------------------------------->');    
        //PageReference pageRef = null;
        try {
                List<String> mergeFieldsList;// = new List<String>();
                List<String> hrefList=new List<String>();
                List<String> selectedProductLst;
                String selectedProds = ApexPages.CurrentPage().getParameters().get('selectedProds');
                parseProducts(selectedProds);
                system.debug('Actual selectedProds----------'+selectedProds);
                String mergeFields = ApexPages.CurrentPage().getParameters().get('mergedstring');
                system.debug('mergeFields-----------------'+mergeFields);
                if (mergeFields!=null && mergeFields!=''){
                    mergeFieldsList = mergeFields.split('@@@',0);
                    system.debug('mergeFieldsList.size()------------'+mergeFieldsList.size());
                    kundeData = mergeFieldsList[0];
                    arrayInit = mergeFieldsList[1];
                    etag = mergeFieldsList[2];
                }
                String newString;
                system.debug('productNameLst size['+productNameLst.size()+'] productNameLst----------------------------'+productNameLst);
                if (productNameLst.size()>0){
                    for (String tempStr:productNameLst){
                            //String newString = tempStr.substring(31,tempStr.length());
                           if (tempStr!=null && tempStr!=''){
                                newString= tempStr;     //.split('dk')[1];
                           }
                            if (newString!=null && newString!=''){
                                hrefList.add(newString);
                            }
                    }
                }
                
                system.debug('kundeData-----after second call----------------'+kundeData);
                system.debug('arrayInit-----after second call----------------'+arrayInit);
                system.debug('etag---------after second call-------'+etag);
                system.debug('hrefList is ##################### '+hrefList); 
                if (hrefList.size()==1){
                    String singleHref = hrefList[0];
                    system.debug('this is  singleHref **************************** '+singleHref);
                    jsonResponse = secondCallToCasia(singleHref,arrayInit,kundeData,etag);
                    if(jsonResponse != '' && jsonResponse != NULL){
                      //responseCode=jsonResponse.substring(0,3); commented because Kasia20 service response body does not contains the status code and we have created new Response code to get status code and assigned status at callout2
                      system.debug('responseCode is---------second call---------->'+responseCode);
                      if(responseCode=='200'){
                          isFirstCallToKasia=false;                          
                          //jsonResponse=jsonResponse.substring(5,jsonResponse.length()); Commented because service does not contains response code and we are getting directly response body
                          //jsonResponse=secondJSONResponse;
                          system.debug('responseCode--of secong call---------------------from clear product selection ----------------------------------'+jsonResponse);
                      }
                    } 
                      system.debug('jsonResponse is-------------second call------------------>'+jsonResponse);
                }
                else {                    
                    for (String hrefVal:hrefList){
                        //String newString = hrefVal.substring(31,hrefVal.length());
                        //List <String> newString= hrefVal.split('dk')[1];
                        jsonResponse = secondCallToCasia(hrefVal,arrayInit,kundeData,etag);
                        system.debug('In loop jsonResponse is ----------------------------'+jsonResponse);
                        //responseCode='200';
                        system.debug('product size()>1-------'+jsonResponse);
                        /*if (jsonResponse!=null){ //Commented because Response body does not contains response code
                            responseCode=jsonResponse.substring(0,3);
                        }*/
                        system.debug('responseCode-----product size()>1----'+responseCode);
                        if(responseCode=='200'){
                                isFirstCallToKasia=false;
                                /*if (jsonResponse!=null){ Commented because Response body does not contains response code
                                    jsonResponse=jsonResponse.substring(5,jsonResponse.length());
                                }*/
                                system.debug('Updated JSON---'+jsonResponse);
                                //jsonResponse=secondJSONResponse;
                            } else {
                                break;
                            }
                    }
                }
                
        } catch (Exception ex) {
                throw ex;
                responseCode=null;
           //system.debug('Exception :'+e.getMessage());
        }
        system.debug('jsonResponse for testing -------------------------------'+jsonResponse);
       return responseCode;    
    }
    
    // need to conform about following fields 
    private string ssoMail='';
    private string ssoPassword='Test1234';
    // DW-855
    public Pagereference settelephnflag()
    {
      //system.debug('in settelephnflag *********** ');
      isTelephninBasket1 = true;
      return null;
    }
    
    private string getBestilInfo(){ 
      //string isTelephninBasket1 = ApexPages.CurrentPage().getParameters().get('telephninbasket');
      system.debug('chk its value ********* isTelephninBasket1 '+isTelephninBasket1);
        string bestilInfo=null;
        system.debug('Customer Number :cCustInstAdd.customerNumber = ' +cCustInstAdd.customerNumber);
        system.debug('totalPrice = ' +totalPrice);
        try{
                if(totalPrice==null || totalPrice==''){
                    totalPrice='0.00';
                }
                system.debug('cCustInstAdd.customerNumber-------------------------------'+cCustInstAdd);
                if( cCustInstAdd.customerNumber!=null && cCustInstAdd.customerNumber.length()>0 && totalPrice.length()>0 ){
                        string betalerBrev; //True if there is second payee(betalerid)
                        string betalerid; //Customer number of payee customer
                        
                        
                        if(secondPayee){
                                betalerBrev='true';
                                betalerid=payeeCustInstAdd.customerNumber;
                        }
                        else
                                betalerBrev='false';
                        
                        if (cCustInstAdd.isNewCustomer){
                            bestilInfo='{"kundeid" : "' + cCustInstAdd.customerNumber + '",' +'"betaler-brev" : "' + betalerBrev + '",' + '"juridisk-brev" : "true",' + '"klient-system" : "FORHANDLER_WEB",' +'"klient-funktion" : "Bestil",' + '"klient-bruger" : "FORHANDLER_WEB",';
                        } else {
                                //bestilInfo='{"kundeid" : "' + cCustInstAdd.customerNumber + '",' +
                            bestilInfo= '{"betaler-brev" : "' + betalerBrev + '",' +'"juridisk-brev" : "true",' +'"klient-system" : "FORHANDLER_WEB",' +'"klient-funktion" : "Bestil",' +'"klient-bruger" : "FORHANDLER_WEB",';
                        }
                                                
                        if(secondPayee){
                                bestilInfo+=' "betalerid" : "' + betalerid + '",';
                        }
                        // Following code is used to form bestil for broadband and telephoni
                       // system.debug('broadbandTelephonyCommonFlag ******** '+broadbandTelephonyCommonFlag+'isTelephninBasket ************ '+isTelephninBasket);
                        if (broadbandTelephonyCommonFlag==true || telefoniFlag==true || isTelephninBasket1 == true) {
                           System.debug('** telefoniFlag ********** broadbandTelephonyCommonFlag **');    
                                /*if (cCustInstAdd.isNewCustomer){
                                       // bestilInfo+=' "sso-mail" : "' + emailIdForNumberporting + '",';
                                       // bestilInfo+=' "sso-passwd" : "' + ssoPassword + '",';
                                       
                                } */
                                   
                                if (tlfNumberForNumberPorting!=null && tlfNumberForNumberPorting!=''){
                                        bestilInfo+=' "ordre-bekraeft-mobil" : "' + tlfNumberForNumberPorting +'",';
                                }
                                /*if (emailIdForNumberporting!=null && emailIdForNumberporting!=''){
                                        bestilInfo+=' "ordre-bekraeft-email" : "' + emailIdForNumberporting + '",';
                                }*/
                                if (selectedNumberForNP!=null && selectedNumberForNP!=''){
                                  System.debug('** Selected Number **'+ selectedNumber);
                                    bestilInfo+=' "telefonbog" : "' + telePhoneDirectoryName +'",'+' "tlfnr" : "' + selectedNumberForNP +'",';  
                                }   
                                if (selectedNumber!=null && selectedNumber!=''){
                                    System.debug('** Selected Number **'+ selectedNumber);
                                    bestilInfo+=' "telefonbog" : "' + telePhoneDirectoryName +'",'+' "tlfnr" : "' + selectedNumber +'",';   
                                } 
                                                     
                        }
                        if (onlyBroadbandFlag==true) {                              
                                if (tlfNumberForNumberPorting!=null && tlfNumberForNumberPorting!=''){
                                       bestilInfo+=' "ordre-bekraeft-mobil" : "' + tlfNumberForNumberPorting +'",';
                                }
                                if (emailIdForNumberporting!=null && emailIdForNumberporting!=''){
                                        bestilInfo+=' "ordre-bekraeft-email" : "' + emailIdForNumberporting + '",';
                                }               
                        }
                        
                        bestilInfo +='"forhandlerid" : "'+loggedInDealerId+'",' + //User id of logged in Dealer '"salgsagent" : "Hans Jensen",' +
                                     '"salgsagent" : "'+loggedInDealerId+'",' +
                                     '"totalpris"  : "' + totalPrice.replace('.', ',') +'"';
                        
                        //Added for 689
                        if(isYouBioSelected && existingYoubio == 'false'){
                          if(dibsTransactionId != '' && dibsTransactionId != null){
                            system.debug('adding dibs info to bestil');
                            bestilInfo += ',"dibs-info" : '+
                            '{' +
                  '"ticket":"' + dibsTransactionId +'"' +
                            '}';
                          }
                        }
                        bestilInfo += '}' ;
                        system.debug('bestilInfo-------------------------------------------------------------------------->'+bestilInfo);                             
                }
        }
        catch(exception ex){
                throw ex;
        }
        system.debug('Printing bestilInfo from getBestilInfo() method----: '+bestilInfo);
        return bestilInfo;
    }
    
    public void insertCustomer() {
        try {
            if(!accInserted) {
                RecordType accRT = [select id from recordtype where name = 'YK Customer Account'];
                List<Account> accExistCustCheck= new List<Account>();                
                System.debug('customer no->'+cCustInstAdd.customerNumber);                
                if(cCustInstAdd.customerNumber != null){
                    accExistCustCheck = [select Net_Installation__c,Customer_No__c from Account where Customer_No__c =: cCustInstAdd.customerNumber limit 1];
                    system.debug('Net_Installation__c in insertCustomer ' +accExistCustCheck[0].Net_Installation__c);
                    system.debug('installNr in insertCustomer ' +cCustInstAdd.installationID);
                    system.debug('netInstallMap.get(cCustInstAdd.installationID).Id; ' +netInstallMap.get(cCustInstAdd.installationID).Id);
                    if(accExistCustCheck.size() > 0 && (accExistCustCheck[0].Net_Installation__c != netInstallMap.get(cCustInstAdd.installationID).Id)){
                      accExistCustCheck[0].Net_Installation__c = netInstallMap.get(cCustInstAdd.installationID).Id;
                      //update accExistCustCheck;
                      system.debug('accExistCustCheck after update ' +accExistCustCheck);
                    }
                }
                if(accExistCustCheck.size() == 0){
                  system.debug('installNr in insertCustomer ' +cCustInstAdd.installationID);
                    User castIronUser = [Select id from User where name = 'CI CastIron' limit 1];
                    Account acc = new Account(Lastname=cCustInstAdd.lastName,Firstname=cCustInstAdd.firstName, 
                                              Type='Kunde',RecordTypeId=accRT.id, PersonMobilePhone=cCustInstAdd.mobilePhone, 
                                              PersonEmail=cCustInstAdd.email, Customer_No__c=cCustInstAdd.customerNumber, 
                                              Phone=cCustInstAdd.contactNumber, Street_YK__c=cCustInstAdd.addr.id, ownerid = UserInfo.getUserId());
                                              
                    acc.Net_Installation__c = netInstallMap.get(cCustInstAdd.installationID).Id;
                    insert acc;
                    if(acc != null){
                        accountIdNewCustomer = acc.id;
                    }   
                  //  acc.ownerId =castIronUser.id;
                  //  update acc;
                    accInserted = true;
                    System.debug('account inserted->'+acc);
                }
            }
        }
        catch(Exception ex) {
            accInserted = false;
            System.debug('account inserted failed->'+accInserted);
        }
    }
    
      
    
    public void placeOrder(){  
              
        String customerNumber = '';
        //PageReference pageRef = Page.DealerProductapproval;
        // Added by navneet for making final call through UI 
        system.debug('dateForNumberPorting---------placeOrder--------------------------------'+dateForNumberPorting);
        system.debug('inside oprder placing function ======= jsonResponse is------------------------------------------'+jsonResponse); 
        //url = '/afsaetning/bestil';
        Boolean isUpdateSuccessful = true;
        //Added for 689
        Boolean isCreateSuccessful = true;
        try{                    
                 system.debug('emailIdForNumberporting in place order' +emailIdForNumberporting);      
                if(cCustInstAdd.isNewCustomer){
                    //Added Newsletter condition for 756
                        if(broadbandTelephonyCommonFlag==true || telefoniFlag==true || isYouBioSelected == true || (wantNewsLetter && emailIdForNumberporting != null) ||(registerEkom && emailIdForNumberporting != null))
                            /* Added extra parameter in the Create kunde Call, since we need to point to the new create Kunde Service where we need to pass the Permissions
                            * We have added one extra node for passing the Permissions in the JSON request. - DEALERWEb - 798
                            */
                            customerNumber=createKunde(cCustInstAdd.amsId,cCustInstAdd.firstName,cCustInstAdd.lastName,emailIdForNumberporting,wantNewsLetter,registerEkom);
                        else
                            customerNumber=createKunde(cCustInstAdd.amsId,cCustInstAdd.firstName,cCustInstAdd.lastName,'', false,false);
                        if(customerNumber!=null && customerNumber.trim().length() > 0){
                                System.debug('Customer Numer   -->   '+customerNumber);
                                cCustInstAdd.customerNumber = customerNumber;
                        }
                        else{
                                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Customer number of purchasing customer is null.');
                                ApexPages.addMessage(m);
                                isCreateSuccessful = false;
                        }
                }                
                //Added isYouBioSelected for 689
                //Added Newsletter condition for 756
             //   else if(!cCustInstAdd.isNewCustomer && (broadbandTelephonyCommonFlag==true || telefoniFlag==true || isYouBioSelected == true || (wantNewsLetter && emailIdForNumberporting != null)))
             else if(!cCustInstAdd.isNewCustomer && (emailIdForNumberporting != null))
             {
                isUpdateSuccessful = updateKunde(emailIdForNumberporting);
                 system.debug('place order update kunde');
             }
            //system.debug('broadbandTelephonyCommonFlag in place order' + broadbandTelephonyCommonFlag);
            //system.debug('telefoniFlag in place order' + telefoniFlag);
            if(payeeCustInstAdd!=null && payeeCustInstAdd.isNewCustomer){
                    // Added one extra parameter wantNewsletter = false in the below createKunde method.
                    customerNumber=createKunde(payeeCustInstAdd.amsId,payeeCustInstAdd.firstName,payeeCustInstAdd.lastName,'', false,false);
                    if(customerNumber!=null  && customerNumber.trim().length() > 0){
                            payeeCustInstAdd.customerNumber = customerNumber;
                    }
                    else{
                            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Customer number of payee customer is null.');
                            ApexPages.addMessage(m);
                            isCreateSuccessful = false; 
                    }
            }
            if(isUpdateSuccessful && isCreateSuccessful){
             /// system.debug('broadbandTelephonyCommonFlag ******** '+broadbandTelephonyCommonFlag+'telefoniFlag ************ '+telefoniFlag);
                string bestilInfo=getBestilInfo();
                //Added for 689
                system.debug('existingYoubio ' +existingYoubio);
                system.debug('### bestilInfo ###: ' +bestilInfo);
                if(bestilInfo!=null){
                        string endpoint=END_POINT+'/Kasia20';    //**Replace this with global endpoint
                        //String body = '{"kunde-data":'+kundeData+',"array-init": "'+arrayInit+'" ,"bestil-info":'+bestilInfo+'}';
                        system.debug('kundeData in final call====================kundeData============================================'+kundeData);
                        system.debug('Array init in final call====================final call============================================='+arrayInit);
                        system.debug('### href ###: ' +url);
                        system.debug('### etag ###: ' +etag);
                        system.debug('----------------------------- productsSelected --------------------------------'+productsSelected);
                        system.debug('----------------------------- accountIdNewCustomer --------------------------------'+accountIdNewCustomer);
                        if(kundeData!=null && arrayInit!=null &&  bestilInfo!=null && url!=null && etag!=null){
                                String body;
                                body = '{"kunde-data":'+kundeData+',"array-init":"'+arrayInit+'","bestil-info":'+bestilInfo+'}';
                               // url = url.split('dk')[1];
                                system.debug('### body ###: ' +body);
                                String response = null;
                                placeOrderCall = true;
                                response = callout2(END_POINT,body, 'PUT', url, etag,'afsaetning');
                                system.debug('JSON response: '+response);
                                     
                                if(response != null){                                   
                                        /*String returnCode = response.substring(0,3); commented because response code not present in response body
                                        system.debug('returnCode: '+returnCode);*/
                                        // DW-861
                                        if(responseCode == '201' || responseCode == '200'){
                                             
                                               //condition for emailIdForNumberporting is added because it is mendatory field for subscription. 
                                               //And it should never be removed becaue if we once call the service without emailId it will not work after that in any condion untill reset.                                                   
                                               /*if((wantNewsLetter || registerEkom) && emailIdForNumberporting != null && emailIdForNumberporting != ''){
                                                   system.debug('emailIdForNumberporting ' +emailIdForNumberporting);
                                                  System.debug('wantnewletter chked->'+wantNewsLetter+'..email->'+cCustInstAdd.email+'...amsid->'+cCustInstAdd.amsId+'...firstname->'+cCustInstAdd.firstName+'..lastname->'+cCustInstAdd.lastName+'...newcust->'+cCustInstAdd.isNewCustomer+'...sfdcid->'+cCustInstAdd.sfdcID);
                                                //addSubscription(cCustInstAdd.email,cCustInstAdd.amsId,cCustInstAdd.firstName,cCustInstAdd.lastName,cCustInstAdd.isNewCustomer?'':cCustInstAdd.sfdcID);
                                                
                                                  addSubscription(cCustInstAdd.customerNumber,emailIdForNumberporting,cCustInstAdd.amsId,cCustInstAdd.firstName,cCustInstAdd.lastName,cCustInstAdd.isNewCustomer?'':cCustInstAdd.sfdcID);
                                                }*/
                                                
                                                //netInstallationNr = cCustInstAdd.installationID;
                                                insertCustomer();
                                                 Sales_Agent__c salesAgent = new Sales_Agent__c(); 
                                                 System.debug('slaesagent no->'+salesAgentNumber.length());
                                                 if(salesAgentNumber.length() > 0){
                                                       System.debug('before salesAgentNumber->'+salesAgentNumber);
                                                        salesAgent.salegernummer__c=salesAgentNumber;
                                                       System.debug('after salesAgentNumber->'+ salesAgent.salegernummer__c);
                                                        insert salesAgent;
                                                 }
                                               /*  
                                                 try{
                                                    createDealerProductsSales(productsSelected, accountIdNewCustomer, response);
                                                 }catch(Exception e){
                                                    System.debug(' Exception while creating Dealer Products Sales ' + e.getMessage());
                                                 }  
                                                 */
                                                 System.debug('salesAgent->'+salesAgent);
                                                 receiptPage = true;
                                                 
                                               
                                                 ApexPages.Message m = new ApexPages.Message(ApexPages.severity.info, 'Ordren er sendt');
                                                 ApexPages.addMessage(m);
                                                  
                                                 System.debug('  SelectedId Set Products which the Dealer has sold  ' + selectedIdSet);
                                                 //Added here for 710
                                                 dpReceiptGeneration.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse,productSummaryMap, telephoniFlag, selectedNumber,NPFutureDate, NPCurrentDate, broadbandTelephonyCommonFlag, onlyBroadbandFlag, plusFlag, ekstrakanalerFlag, broadbandUpgradationFlag, telefoniFlag,telePhoneDirectoryName,selectedNumberForNP);       
                                                 isYouBioBoxSelected = dpReceiptGeneration.updateYouBioBoxSelectedStatus();
                                                 isYouBioAbnSelected = dpReceiptGeneration.updateYouBioAbnSelectedStatus();
                                              ///added for salesflow dashboard                                         
                                                 addProductForReport();
                                           
                                                                               
                                                 
                                            }else if(responseCode == '500' && response.contains('produktvalideringsfejl: Der findes aktivitet')){
                                                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Det er ikke muligt at gennemføre ordren på denne adresse, da der er igangværende abonnement ændringer på adressen. Kontakt venligst Forhandler support.');
                                                ApexPages.addMessage(m);
                                            }else {
                                                  ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, response);
                                                  ApexPages.addMessage(m); 
                                            }
                                }
                                        else{
                                                  ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Response is null from Kasia.');
                                              ApexPages.addMessage(m);
                                        }
                                        
                        }
                        else{
                                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Value of one of parameter among kundeData,arrayInit,bestilInfo,href and etag is null.bestilInfo: ' +bestilInfo +',kundeData: '+kundeData+',arrayInit: '+arrayInit+ ',url: '+url+',etag: '+etag);
                                        ApexPages.addMessage(m);
                        }
                }
                else{
                        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Bestil info is null.');
                                ApexPages.addMessage(m);
                }
            }   
            else{
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Kundens informationer kunne ikke opdateres. Kontakt Forhandlersupport på 70 13 37 00');
                ApexPages.addMessage(m);
            } 
                                             
        }
            
        catch(exception ex){
                 ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,ex.getMessage());
                 ApexPages.addMessages(ex); 
        }  
           
    }
    
    public void addProductForReport()
        {
            string productname;
        getInstallationProducts();
        system.debug('===selectedProducts===='+ getInstallationProducts());
       
        set<string> lstproduct=new set<string>();
        for(Abonnementers Abonnemen:getInstallationProducts()){
        lstproduct.add(Abonnemen.ProductCategory);
        }
        system.debug('-------Abonnementers---------'+lstproduct);
        for(string product:lstproduct)
        {
        system.debug('******************************'+product);
        if(product=='Kable TV'){
        productname='clear';    
        }
        else{
        productname=product;    
        }
         system.debug('******************************'+productname);        
        Dealerweb_OrderedProduct_Report__c productReport = new Dealerweb_OrderedProduct_Report__c();
        productReport.Dealer__c =objCommon.dealerAccount.id;
        productReport.Date__c = Date.today();
        productReport.ProductCategory__c = productname;
        productReport.Sales_Channel__c = 'Salesflow';
        productReport.KundensAdresse__c = cCustInstAdd.addr.Street__c;
        productReport.Kundens_Postnr__c = cCustInstAdd.addr.Postcode__c;
        productReport.KundensBy__c = cCustInstAdd.addr.District__c;
        productReport.Kundens_fornavn__c = cCustInstAdd.firstName;
        productReport.Kundens_efternavn__c =cCustInstAdd.lastName; 
        productReport.Kundens_email__c = emailIdForNumberporting;
        productReport.Kundens_mobilnr__c = tlfNumberForNumberPorting;
        ProductReportList.add(productReport);
        }
        
        system.debug('This is my addProductForReport  objCommon.dealerAccount'+objCommon.dealerAccount+'---------pdktCtogry is '+ProductReportList);
        try{
          insert ProductReportList;
        }catch(Exception ex){
            system.debug('there is an exception in addProductForReport----'+ex.getMessage());
        }
        
        
        }
    
    
    /*
    // used for Dashboards & reports for Sales Statistics
    public void createDealerProductsSales(String productSold, Id customerId, String jsonResponse){
        User dealer = [Select AccountId from User where id =: UserInfo.getUserId()];
        String[] productArray = productSold.split(',');
        List<DealerProductsSales__c>  produtsList = new List<DealerProductsSales__c>(); 
        DealerProductsSales__c productSales; 
        
        for(String products : productArray){
            productSales = new DealerProductsSales__c();
            String[] product = products.split('-');
            productSales.ProductCategory__c = product[0];
            productSales.Product__c = product[1];
            productSales.Customer__c = customerId;
            productSales.OrderPlacedDateTime__c = System.today();
            productSales.Dealer__c = dealer.AccountId;
            productSales.OrderId__c = getUuid(jsonResponse);
            produtsList.add(productSales);
        }
        System.debug('The product List size ------> '+ produtsList);
        insert produtsList;
    }
    
    // used for getting the UUID from the json response
    public  String getUuid(String jsonResponse){
        try{
            //String jsonResponse = '201; {"dsl":"uuid : cf84e435-fecf-49b2-9362-14239a43826a;\nversion : 1.20;\nkunde med installations adresse {\n  kunde nr : 616190712;\n  adresse id : 1282801;\n  installations nr : 1;\n}\nsalgskanal : F;\nklient system : FORHANDLER_WEB;\nklient bruger : FORHANDLER_WEB;\nklient funktion : Bestil;\nforhandler {\n  forhandler id : T8017;\n  salgs agent : T8017;\n  total pris : 100,00;\n}\nbreve {\n  juridisk : false;\n  betaler : false;\n}\nordre linier {\n  opret DTV aftale {\n    opret abonnement 1201505 med sn 1201505_32908135273 med gebyr 1250032;\n  }\n}\n","order-output":"\"cf84e435-fecf-49b2-9362-14239a43826a\"","ETag":"531748896"}';
            String[] response = jsonResponse.substring(13).split(':');
            String uuid = response[1].split(';')[0];
            System.debug('UUID ------------> '+ uuid);
            return uuid.trim();
        }catch(Exception e){
            System.debug('Exception in UUID ------------> ');
            return '';
        }   
    }
    
    */
    Boolean receiptSaved = false;
    public Id AttachmentID {get;set;} 
     
     public void saveReceipt()
    {      
                Pagereference pr = Page.DealerProductReceipt1;
            Blob b;
                if(!(testMode)){
                    b = pr.getcontent(); 
                    system.debug('Blob Data in string format @@@@@@@@@@@@ '+b.tostring());
                    system.debug('string in the blob !!!!!!!  '+b);
                } 
                else{
                     b = Blob.valueof('Dummy Content in email body for Apex Test Run');            
                   
                }   
               
                Document receipt = new Document();
                receipt.folderId = [select id from folder where Name='Customer Form Documents'].id;
                receipt.Name = cCustInstAdd.customerNumber + '.htm'; 
                receipt.body = b;
            
                insert receipt; 
              
                AttachmentID = receipt.id;
            receiptSaved = true;
    }
    
    public pagereference printReceipt()
    {
        if(!receiptSaved)
           saveReceipt();
        
        return Page.DealerProductReceipt1;
    }
    
   // @future(callout=true)
    public void addSubscription(string custNumber,string email,string addressID,string fName,string lName,string sfdcID)
    {   
        try{
            HttpRequest req = new HttpRequest();
            
             //Set HTTPRequest Method
             req.setMethod('GET');
 
            //Set HTTPRequest header proporties
             req.setHeader('content-type', 'application/json');
             req.setHeader('Accept', 'application/json');
             
             //Set HTTPRequest Endpoint
             if(sfdcID != ''){
               req.setEndpoint(END_POINT+'/tilmeldPermission?email='+email.toLowerCase()+'&permissionType=permission&createdBy=DealerWeb&isNewCustomer=false&Customer_No='+custNumber+'&UserId=' + objCommon.dealerAccount.Dealer_Number__c + '&addressid='+addressID);
               System.debug('Update Newsletter for existing customer ' + sfdcID);
             }
             else{
               req.setEndpoint(END_POINT+'/tilmeldPermission?email='+email.toLowerCase()+'&permissionType=permission&createdBy=DealerWeb&isNewCustomer=true&UserId=' + objCommon.dealerAccount.Dealer_Number__c + '&addressid='+addressID);
             }
             //req.setEndpoint('http://213.174.75.96:7890/tilmeldPermission?email='+email+'&permissionType=permission&createdBy=DealerWeb&addressid='+addressID);
            
               
            //Set HTTP Request Body
            //req.setBody(JSONString);
             
            Http http = new Http();
             
            HTTPResponse res = http.send(req);
             
             //Helpful debug messages
             System.debug(res.toString());
             System.debug('STATUS:'+res.getStatus());
             System.debug('STATUS_CODE:'+res.getStatusCode());
             System.debug('Content: ' + res.getBody());
             //System.debug('Content Type: ' + res.getHeader('Content-Type'));
             
             //Check for the status code and mark the subscription flag as 'False' if code !=200
             if(res.getStatusCode() != 200)
             {
               subscriptionFlag = false;
               System.debug('Subscription Flag: '+subscriptionFlag);
             }
                        
                        /*
                        // I have generated a new class from wsdl and named it as NewsletterStubTest--Mudasir.
                        NewsletterStub.Provide_ServicePort  stub = new NewsletterStub.Provide_ServicePort ();
                        //NewsletterStubTest.Provide_ServicePort  stub = new NewsletterStubTest.Provide_ServicePort ();
                        NewsletterStub.inputParams_element sub = new NewsletterStub.inputParams_element();
                        //NewsletterStubTest.inputParams_element sub = new NewsletterStubTest.inputParams_element();
                        sub.Email = email;
                        sub.AddressID = addressID;
                        sub.firstName = fName;
                        sub.lastName = lName;
                        sub.Permission = 'Afventer accept';
                        sub.SalesforceId = sfdcID==null?'':sfdcID;
                        system.debug('Newsletter sub:'+sub);
                        NewsletterStub.Result_element  resp = null;
                        //NewsletterStubTest.Result_element  resp = null;
                        testMode = FORCE_TEST_MODE;                           
                        if(!(testMode)){
                          system.debug('Not a test Mode in addSubscription function');
                          system.debug('value of sub is '+sub);
                            resp = stub.Provide_Service(sub);   
                        }                     
                        system.debug('Newsletter response:'+resp);  
                        */
        }
        
        catch(Exception ex)
        {
            System.debug('inside execption->'+ex.getMessage());
                subscriptionFlag = false; 
        }
    }
    
     /** Method to update customer's email ID
    *   Refer DW-645
    **/
    /*
    Changed the below method for DEALERWEB - 798 : Added Permissions
    */
    private boolean updateKunde(String email){  
        system.debug('this is my mobiltelefon *****updateKunde  &_________$$$'+tlfNumberForNumberPorting);    
        String httpResp = '';
        Boolean updateSuccessful = false;
        system.debug('broadbandTelephonyCommonFlag ' +broadbandTelephonyCommonFlag);        
        system.debug('telefoni ' +telefoniFlag);    
        try{
            String kundeBody = '';  
            kundeBody = '{' +
                            '"email": "'+emailIdForNumberporting.toLowerCase()+'",'+
                            '"klient-system": "DealerWeb",'+
                            '"klient-funktion": "opret",';
            if(tlfNumberForNumberPorting != null && tlfNumberForNumberPorting != '')                
                kundeBody += '"mobiltelefon": "'+tlfNumberForNumberPorting+'",';
            if(cCustInstAdd.contactNumber != null && cCustInstAdd.contactNumber != '')
                kundeBody += '"privattelefon": "' + cCustInstAdd.contactNumber+'",';    
                            
            if(email !='' && (wantNewsletter && registerEkom)){
                kundeBody += '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                String mydatestringis = DateTime.Now().format('yyyy/MM/dd');
                mydatestringis = mydatestringis.replace( '/', '-');
                kundeBody += '"permissions":{"marketing_permission":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}';
                kundeBody += ',"E_kommunikation":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
            }else if(email !='' && wantNewsletter){
                kundeBody += '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                String mydatestringis = DateTime.Now().format('yyyy/MM/dd');
                mydatestringis = mydatestringis.replace( '/', '-');
                kundeBody += '"permissions":{"marketing_permission":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
            }
            else if(email !='' && registerEkom ){
                kundeBody += '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                String mydatestringis = DateTime.Now().format('yyyy/MM/dd');
                mydatestringis = mydatestringis.replace( '/', '-');
                kundeBody += '"permissions":{"E_kommunikation":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
            }
            else{
                kundeBody += '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'"}';
            }          
            system.debug('kundeBody ' +kundeBody);          
            String response = '';
            testMode = FORCE_TEST_MODE;                           
            if(!(testMode)){
                response = callout2(END_POINT,kundeBody, 'PUT' , kasia_EndPoint+'/kunde/'+cCustInstAdd.customerNumber, '','kunde');
                if(!response.startsWith('{')&&response.startsWith(',')){
                    response = response.replaceFirst(',', '');
                    response = '{'+response;
                }
                    
            }
            
            if(response != null && response != ''){
                    JSONObject jsonObj = new JSONObject(response);
                    //String responseCode =  jsonObj.getValue('responsecode').str; Commented because response code not present in response body
                    if(responseCode=='204'|| responseCode=='200')
                        updateSuccessful = true;
            }
            system.debug('Kunde response in updateKunde: '+response);
            system.debug('update Successful : ' +updateSuccessful);
        }
        catch(Exception ex){
            throw ex;       
        }    
        return updateSuccessful;
    }     
    private String createKunde(String ams_id,String first_name,String last_name,String customerEmail, Boolean wantNewsletter,Boolean registerEkom){
        try{
            //system.debug('this is my mobiltelefon *****&&&&&&&&&&&&&&&&&&&&&&&_________$$$'+cCustInstAdd.contactNumber);
            createKundeCall = true;
            if(cCustInstAdd.installationID != null && netInstallMap.containsKey(cCustInstAdd.installationID))
              netInstallationNr = netInstallMap.get(cCustInstAdd.installationID).Id;
            System.debug('Net Installation ID ' +netInstallationNr);
            String kundeBody = '';
             String mydatestringis = DateTime.Now().format('yyyy/MM/dd');
             mydatestringis = mydatestringis.replace( '/', '-');                
            kundeBody ='{'+
                        '"kundeart": "Enkel",'+
                        '"kundetype": "Normal",'+
                        '"amsid": "'+ams_id+'",';
                if(tlfNumberForNumberPorting != null && tlfNumberForNumberPorting != '')                
                    kundeBody += '"mobiltelefon": "'+tlfNumberForNumberPorting+'",';
                if(cCustInstAdd.contactNumber != null && cCustInstAdd.contactNumber != '')
                    kundeBody += '"privattelefon": "' + cCustInstAdd.contactNumber+'",';    
                    
                if(customerEmail !='' && (wantNewsletter && registerEkom)){
                    System.debug('Create Kunde - Email ID ' + customerEmail);
                    System.debug('Create Kunde - Newsletter ' + wantNewsletter);
                    kundeBody += '"email": "'+emailIdForNumberporting.toLowerCase()+'",';
                      
                    kundeBody += '"fornavn": "'+first_name+'",'+
                                '"efternavn": "'+last_name+'",'+
                                '"klient-system": "DealerWeb",'+
                                '"klient-funktion": "opret",'+
                                '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                                    
                    kundeBody += '"permissions":{"marketing_permission":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}';
                    kundeBody += ',"E_kommunikation":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';      
                   }
                else if(customerEmail !='' && wantNewsletter)
                {
                    kundeBody += '"email": "'+emailIdForNumberporting.toLowerCase()+'",';
                      
                    kundeBody += '"fornavn": "'+first_name+'",'+
                                '"efternavn": "'+last_name+'",'+
                                '"klient-system": "DealerWeb",'+
                                '"klient-funktion": "opret",'+
                                '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                                    
                    kundeBody += '"permissions":{"marketing_permission":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
                }
                else if(customerEmail !='' && registerEkom)
                {
                    kundeBody += '"email": "'+emailIdForNumberporting.toLowerCase()+'",';    
                    kundeBody += '"fornavn": "'+first_name+'",'+
                                '"efternavn": "'+last_name+'",'+
                                '"klient-system": "DealerWeb",'+
                                '"klient-funktion": "opret",'+
                                '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';  
                                    
                    kundeBody += '"permissions":{"E_kommunikation":{"updated_date": "'+mydatestringis+'","enabled":true,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
                }  
                else{
                    System.debug('Create Kunde - Email ID ' + customerEmail);
                    kundeBody += '"email": "'+emailIdForNumberporting.toLowerCase()+'",';
                  
                    kundeBody += '"fornavn": "'+first_name+'",'+
                                '"efternavn": "'+last_name+'",'+
                                '"klient-system": "DealerWeb",'+
                                '"klient-funktion": "opret",'+
                                '"klient-bruger": "'+objCommon.dealerAccount.Dealer_Number__c+'",';
                    
                    kundeBody += '"permissions":{"marketing_permission":{"updated_date": "'+mydatestringis+'","enabled":false,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
                    kundeBody += ',"E_kommunikation":{"updated_date": "'+mydatestringis+'","enabled":false,"changed_by":"'+objCommon.dealerAccount.Dealer_Number__c+'"}}}';
                    
               }
                      
           system.debug('kundeBody in createKunde ' +kundeBody);
            
            //String body = 'POST /kunde/   !#$  !#$ ' + kundeBody;
            String response = null;
            testMode = FORCE_TEST_MODE;                           
            if(!(testMode)){
                 system.debug('Value for Kasia_EndPoint is ---------------'+kasia_EndPoint);
                response = callout2(END_POINT,kundeBody, 'PUT' , kasia_EndPoint+'/kunde/', '','kunde');
                 system.debug('Response for Kasia_EndPoint is ---------------'+response);
            }
            system.debug('Kunde response: '+response);
            
            //String response = callout('http://192.66.36.144:7890/Kasia20', body); //**Replace this with global endpoint&& response.length() > 4
            if(response!=null){
                    JSONObject jsonObj = new JSONObject(response);
                 system.debug('22222responsejson'+jsonObj);
                  system.debug('Kunde ID : ============== :' + jsonObj.getValue('kunde').obj.getValue('kundeid').str);
                  //system.debug('Kunde ID : ============== :' + jsonObj.getValue('kundeid').str);
                    return jsonObj.getValue('kunde').obj.getValue('kundeid').str;
                    //return jsonObj.getValue('kundeid').str;
            }
            else{
                    return null;
            }
        }catch(exception ex){
                throw ex;
                return null;
        }
    }
     /*****************************END OF COMMON SECTION***********************************************************************/
     /**PRODUCT SELECTION PAGE**********************************************************************************************************/
    public PageReference productSelectionPage(){
        String instID = '';
        hardwareSelection=null;
        smartCardNumber = '0';
        selectedIdSet.clear();
        PageReference pageRef = Page.DealerProductSelectionPage1;
        String installNr = ApexPages.CurrentPage().getParameters().get('installNr');
        System.debug('installnr--->'+installNr);
        String kundeNumber = ApexPages.CurrentPage().getParameters().get('selectedCustomer');
        System.debug('kundeNumber  --->'+kundeNumber);
        testMode = FORCE_TEST_MODE;                           
        if(!(testMode)){
            if((kundeNumber != null || kundeNumber != '') && kundeNumber !='Ny Kunde'){
                //Fetching the status of newsletter
                Account perList = new Account();
                perList = [Select (Select Marketing_Permission__c, E_kommunikation__c from Permissions__r) From Account WHERE Customer_No__c=:kundeNumber limit 1]; 
                if(!perList.Permissions__r.isEmpty()){
                    newsLetterUser = perList.Permissions__r[0].Marketing_Permission__c;
                    ekomUser=perList.Permissions__r[0].E_kommunikation__c;
                }else{
                    newsLetterUser = false;
                    ekomUser=false;
                }
            }else{
                newsLetterUser = false;
                ekomUser=false;
            }
        }
        if(newsLetterUser)
        wantNewsletter = true;
        badCreditRating = false;
        system.debug('--newsLetterUser      --------    '+newsLetterUser);
        system.debug('-----------kundeNumber    '+kundeNumber);
        if(ekomUser)
        registerEkom = true;
        //this code is added for dw-615.
        List<SalesFlow_Informationer__c> CampaignColorAndDescription =[Select info.CampaignColor__c, info.Description__c,info.SubGroup_Information__c from SalesFlow_Informationer__c info where info.Page_Type__c ='Product Selection Page' and info.Group_Information__c ='Product Information' order by Sequence_Number__c DESC];
        system.debug('CampaignColorAndDescription value is -------------'+CampaignColorAndDescription);
        CampaignColorAndDescriptionJson = JSON.serialize(CampaignColorAndDescription);
        system.debug('CampaignColorAndDescriptionJson in controller is --------'+CampaignColorAndDescriptionJson);
     //   String customerCredit = ApexPages.CurrentPage().getParameters().get('customerCredit');
      //  system.debug('customerCredit  --   '+customerCredit);
   /*     if('true' == customerCredit){
           badCreditRating = true;
        }else{
           badCreditRating = false;
        }*/
        
         for(DealerCustomerPOJO pojo : custLst){
           if(pojo.customerNumber.equals(kundeNumber)){
                pojo.customerSelected = true;
                badCreditRating = pojo.credit;
            }
            else{
                pojo.customerSelected = false; 
            }   
        }
        if(secondPayee && cCustInstAdd.customerNumber.equals(kundeNumber) && !kundeNumber.equals(DealerSalesConstant.NEW_CUSTOMER)){
                ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Betaler skal være en anden person end køber');
            ApexPages.addMessage(myMsg); 
                return null;
        }
        //commented for DealerWeb-746
        /**
        if(badCreditRating){
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Kunden kan ikke købe produkter, Kunden er i restance og der må ikke sælges produkter til kunden.Der må ikke udfyldes manuelle blanketter.Ring venligst til Forhandlersupport på 70 13 37 00.');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        */
        //String url = ''; 
       // String url = '/afsaetning/'+amsId+'/'+installNr+'/F'; 
        String url = '/afsaetning/'+amsId+'/';
                  
        for(DealerCustomerPOJO pojo : custLst){
            if(pojo.customerNumber.equals(kundeNumber)){
               // pojo.customerSelected = true;
              // instID = '1';
               //if(pojo.installationID != null)
                //instID = pojo.installationID; 
               //url = '/afsaetning/'+amsId+'/'+pojo.installationID+'/F'; //null check for installationId needs to be applied
                if(secondPayee){ 
                    //payeeCustomerPojo = pojo; 
                    if(pojo.customerName.equals(DealerSalesConstant.NEW_CUSTOMER)){
                        pageRef = Page.CustomerInfoPage1;  
                        payeeCustInstAdd.isNewCustomer =true; 
                        //emailIdForNumberporting = '';
                        system.debug('dw-245 ' + installNr);
                        //Added for DW-245
                        if(installNr != null && installNr != '0')
                            payeeCustInstAdd.installationID = installNr;                                             
                                             
                    } else {
                        pageRef = Page.DealerProductApproval1;
                        if (pojo.firstName!=null){
                          payeeCustInstAdd.firstName = String.escapeSingleQuotes(pojo.firstName);
                            payeeCustInstAdd.firstName = pojo.firstName;
                        }
                        if (pojo.lastName!=null){
                          payeeCustInstAdd.lastName = String.escapeSingleQuotes(pojo.lastName);
                            payeeCustInstAdd.lastName = pojo.lastName;  
                        }
                        if (pojo.phone!=null){
                            payeeCustInstAdd.contactNumber=pojo.phone;  
                        }
                        //Added for DW-831
                        if(pojo.mobilePhone != null){
                            payeeCustInstAdd.mobilePhone = pojo.mobilePhone;
                        }
                        if (pojo.customerNumber!=null){
                            payeeCustInstAdd.customerNumber=pojo.customerNumber;    
                        }
                        payeeCustInstAdd.isNewCustomer =false;
                        if (pojo.sfdcID!=null){
                            payeeCustInstAdd.sfdcID = pojo.sfdcID;  
                        }
                        if (pojo.installationID!=null){
                            payeeCustInstAdd.installationID = pojo.installationID;  
                        }
                        if (pojo.email!=null){
                            cCustInstAdd.email=pojo.email;
                            cCustInstAdd.conformEmailID=pojo.conformEmail;
                            //emailIdForNumberporting = pojo.email;
                            system.debug('SP ALERTTTTTTTT ' + emailIdForNumberporting + ' POJO: ' +pojo.email);
                            
                        } else {
                            cCustInstAdd.email='';
                            cCustInstAdd.conformEmailID='';
                        }
                    }                      
                } else {
                    //Redirect user to YouBio selection page if YouBio is selected
                    /*if(isYouBioSelected)
                      pageRef = Page.DealerYouBioProductSelection;*/
                        //dealerProdPojo = pojo;
                        if(!pojo.customerName.equals(DealerSalesConstant.NEW_CUSTOMER)){
                            if (pojo.firstName!=null){
                            cCustInstAdd.firstName = String.escapeSingleQuotes(pojo.firstName);
                            system.debug('First Name after split ' + cCustInstAdd.firstName);
                            }
                            if (pojo.lastName!=null){ 
                            cCustInstAdd.lastName = String.escapeSingleQuotes(pojo.lastName);
                            system.debug('Last Name after split ' + cCustInstAdd.lastName);
                            }
                            if (pojo.phone!=null){
                                cCustInstAdd.contactNumber=pojo.phone;  
                            }
                            //Added for DW-831
                            if(pojo.mobilePhone != null){
                                cCustInstAdd.mobilePhone = pojo.mobilePhone;
                                tlfNumberForNumberPorting = pojo.mobilePhone;
                            }
                            cCustInstAdd.isNewCustomer =false;
                            if (pojo.customerNumber!=null){
                                cCustInstAdd.customerNumber=pojo.customerNumber;    
                            }
                            if (pojo.sfdcID!=null){
                                cCustInstAdd.sfdcID = pojo.sfdcID;  
                            }
                            if (pojo.installationID!=null){
                                cCustInstAdd.installationID = pojo.installationID;  
                            }
                           // url += '/'+pojo.customerNumber; 
                           if(pojo.installationID != null && pojo.installationID != '0'){
                              url += pojo.installationID+'/F/'+pojo.customerNumber;
                           }
                           else if(pojo.installationID == '' || pojo.installationID == null || pojo.installationID == '0'){
                             url = '/afsaetning/F/' + pojo.customerNumber;
                             system.debug('url for offnet customers ' +url);
                           }
                           system.debug('pojo.email ' +pojo.email);
                            if (pojo.email!=null){
                                cCustInstAdd.email=pojo.email;
                                cCustInstAdd.conformEmailID=pojo.conformEmail;
                                emailIdForNumberporting = pojo.email;
                                system.debug('NSP ALERTTTTTTTT ' + emailIdForNumberporting + ' POJO: ' +pojo.email);
                            } else {
                                cCustInstAdd.email='';
                                cCustInstAdd.conformEmailID='';
                            }
                        } else {
                                cCustInstAdd.firstName = '';
                                cCustInstAdd.lastName = '';
                                cCustInstAdd.contactNumber='';
                                //Added for DW-831
                                cCustInstAdd.mobilePhone = '';
                                cCustInstAdd.isNewCustomer =true;
                                cCustInstAdd.customerNumber = '';
                                cCustInstAdd.email='';
                                cCustInstAdd.conformEmailID='';
                                cCustInstAdd.sfdcID = '';
                                cCustInstAdd.installationID = installNr;
                                emailIdForNumberporting = '';
                                system.debug('cCustInstAdd.installationID ' + cCustInstAdd.installationID + ' installNr ' +installNr );
                                if(installNr != null && installNr != '0'){
                                 url += installNr+'/F';
                                }
                                 
                                else if(installNr == '' || installNr == null || installNr == '0'){
                                 url = '/afsaetning/F';
                                 system.debug('url for offnet new customers ' +url);
                            } 
                                
                        }
                        //Calling Kasia first time
                        //url += ' !#$ !#$'; 
                        System.debug('cCustInstAdd->'+cCustInstAdd);
                        // Code added for Dealerweb-746 where we need to allow a dealer to sell the youbio products to a bad payee customer.
                        if(badCreditRating){
                     url = '/afsaetning/F/'+kundeNumber;
                           system.debug('url for bad Credit Rating customers ' +url);                    
                        }
                        //code end for Dealerweb-746.
                        System.debug('URL 1 -----------> ' + url);
                    //Support-4469 Start
                    try{
                        if(Test.isRunningTest())
                    {
                        firstJsonResponse = '{"111001":{"pris":"2876.00","radiokoda":"0.00","koda":"0.00","produkt":"1111001","mindstepris":"3595.00","betalingsperiode":"enkelt","links":[{"rel":"mindstepris-beregning","href":"http://preprod-kasia.yousee.dk/afsaetning/mindstepris-beregning-uden-binding/0005017038///0/1111001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"moms":"719.00","fejlkode":0,"copydan":"0.00","totalpris":"3595.00"},"links":[{"rel":"priser","href":"http://preprod-kasia.yousee.dk/afsaetning/priser/0005017038/F/E/1","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"},{"rel":"priser-nysalg","href":"http://preprod-kasia.yousee.dk/afsaetning/priser/nysalg/0005017038/F/E/1","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}';
                    }else{
                        firstJsonResponse = callout2(END_POINT,'', 'GET', url, '','afsaetning');
                    }
                        
                        System.debug('firstJsonResponse afsaetning ***** '+firstJsonResponse);
                    
                    Map<String, Object> firstJsonResponseMap1 = (Map<String, Object>)JSON.deserializeUntyped(firstJsonResponse);
                    System.debug('*****firstJsonResponseMap1.get(links)****'+firstJsonResponseMap1.get('links'));
                       String linksNode =   JSON.serialize(firstJsonResponseMap1.get('links'));
                        System.debug('*******str***********'+linksNode);
                        List<DealerProductPageController3.PriserJSON> priserList = new List<DealerProductPageController3.PriserJSON>();
                        List<String> linksNodeSplit = linksNode.split('},');
                        for(Integer i=0; i< linksNodeSplit.size(); i++)
                        {
                            DealerProductPageController3.PriserJSON pri=  new DealerProductPageController3.PriserJSON();
                            if(i == 0){
                                linksNodeSplit[i]= linksNodeSplit[0].remove('[')+'}';
                                System.debug('****pri.parse(linksNodeSplit[i])****'+pri.parse(linksNodeSplit[i]));
                                pri = pri.parse(linksNodeSplit[i]);
                                pri.href = pri.href.remove(System.label.PriserRemoveURL);
                                priserList.add(pri);
                            }
                            else{
                                if(i==1){
                                    linksNodeSplit[1] = linksNodeSplit[1].remove(']');
                                    pri = pri.parse(linksNodeSplit[i]);
                                    pri.href = pri.href.remove(System.label.PriserRemoveURL);
                                    System.debug('****pri.parse(linksNodeSplit[i])****'+pri.parse(linksNodeSplit[i]));
                                    priserList.add(pri);
                                }
                            }
                            if(kundeNumber == 'Ny Kunde'){
                                if(pri.rel == 'priser-nysalg'){
                                    System.debug('***Inside Ny salg +pri.href '+pri.href);
                                    youBioPriceJson = callout2(END_POINT,'', 'GET', pri.href, '','priser');
                                }
                            }
                            else{
                                if(pri.rel == 'priser')
                                {
                                     System.debug('***Inside salgs pri.href '+pri.href);
                                    youBioPriceJson = callout2(END_POINT,'', 'GET', pri.href, '','priser');
                                }
                            }
                        }
                     //Support-4469 End 
                     //
                    system.debug('jsonresponse &&&&&&&&'+jsonResponse);
                        //code added to call Pricer service for YouBio and combine the two responses.
                      // youBioPriceJson = callout2(END_POINT+'/Kasia20','', 'GET', 'afsaetning/priser/intet/F', '','priser');
                          system.debug('value of callout is '+youBioPriceJson);
                       /* if((url =='/afsaetning/F') || (url =='/afsaetning/F/' + pojo.customerNumber))
                        {
                          youBioPriceJson = callout2(END_POINT+'/Kasia20','', 'GET', 'afsaetning/priser/intet/F', '','afsaetning');
                          system.debug('value of youBioPriceJson is '+youBioPriceJson);*/
                          if(youBioPriceJson != null && youBioPriceJson!= '' && !youBioPriceJson.contains('\"errorcode\"')){                        
                             // Good response || res.getStatusCode() == 201
                             Map<String, Object> jsonResponseMap = (Map<String, Object>)JSON.deserializeUntyped(youBioPriceJson);  
                             Map<String, Object> firstJsonResponseMap = (Map<String, Object>)JSON.deserializeUntyped(firstJsonResponse);
                                System.debug('******firstJsonResponseMap****'+firstJsonResponseMap);
                            Set <String> keysOfYouBioPriceJson = jsonResponseMap.keyset();
                             for (String nodesYouBioPriceJson :keysOfYouBioPriceJson){
                             if(nodesYouBioPriceJson != 'ETag'){
                                 firstJsonResponseMap.put(nodesYouBioPriceJson,jsonResponseMap.get(nodesYouBioPriceJson));
 
                             }
                            }
                                
                            firstJsonResponse = JSON.serialize(firstJsonResponseMap);
                              System.debug('firstJsonResponse -----------> ' + firstJsonResponse);
                         }else{
                            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Error while trying to fetch product prices. Please try again.');
                             ApexPages.addMessage(m); 
                             return null; 
                         }
                    }catch(Exception e){
                  ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Error while trying to fetch product prices. Please try again.');
                        ApexPages.addMessage(m); 
                        return null; 
              }
                       //}
                        //End of Pricer service code for YouBio.   
                        //firstJsonResponse = callout('http://192.66.36.144:7890/Kasia20', url);        //**Replace this with global endpoint
                        System.debug('firstJsonResponse -----------> ' + firstJsonResponse);
                        jsonResponse=firstJsonResponse;
                        //JSON response with  youbio box only 
                        isFirstCallToKasia=true;
                        system.debug('-----------pageRef    '+pageRef);
                }
                system.debug('emailIdForNumberporting = ' +emailIdForNumberporting);   
                break;
            }   
                   
        }      
        return pageRef;
    }
    //INVOKED FROM PRODUCT SELECTION PAGE 
    public PageReference startSalesFlow(){
      selectedProducts = new List<String>(); 
      //productMap = new Map<String,Map<String,List<Product>>>();      
      String idString = ApexPages.CurrentPage().getParameters().get('selectedProdIds');
      System.debug('idString   --   '+idString);      
      List<String> ids = idString.split('@', 0);
      //String dataString = ApexPages.CurrentPage().getParameters().get('existingElementsLength');      
      //List<String> dataLen = dataString.split('@', 0); 
      selectedIdSet.clear();     
      selectedIdSet.addAll(ids);             
      Integer p = ids.size();
      PageReference pageRef = null;
      plusFlag = false; 
      ekstrakanalerFlag = false;
      for(Integer k = 0; k < p; k++){
          if(ids.get(k) == DealerSalesConstant.clearId){
             clearFlag = true;
             isYouBioSelected = false;
             selectedProducts.add(DealerSalesConstant.clearId);
           //  selectedProducts.add(DealerSalesConstant.clearKravet);           
          }else if(ids.get(k) == DealerSalesConstant.dtvEngId){
             plusFlag = true;
             isYouBioSelected = false;
             selectedProducts.add(DealerSalesConstant.dtvEngId);  
          }
          // DW-861 - 3/5/2015 - selecting BSXX Flow
          else if(ids.get(k) == DealerSalesConstant.dtvtaId){
             dtvtaflag = true;
             isYouBioSelected = false;
             //system.debug('dtvtaflag $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+dtvtaflag);
             selectedProducts.add(DealerSalesConstant.dtvtaId);  
          }
          else if(ids.get(k) == DealerSalesConstant.dtvPakkeId){
             ekstrakanalerFlag = true;
             isYouBioSelected = false;
             if(!selectedIdSet.contains(DealerSalesConstant.dtvEngId)){
                selectedProducts.add(DealerSalesConstant.dtvPakkeId);
             }
          }else if(ids.get(k) == DealerSalesConstant.broadbandId){
            //system.debug('broadbandTelephonyCommonFlag ****** ');
             broadbandTelephonyCommonFlag = true;
             isYouBioSelected = false;
             selectedProducts.add(DealerSalesConstant.broadbandId);                           
          }else if(ids.get(k) == DealerSalesConstant.telephonyId){ 
            //system.debug('telefoniFlag ****** ');         
             telefoniFlag = true;
             isYouBioSelected = false;
             selectedProducts.add(DealerSalesConstant.telephonyId);                                 
          }else if(ids.get(k) == DealerSalesConstant.bbModemId){
            isYouBioSelected = false;
            selectedProducts.add(DealerSalesConstant.bbModemId);
          }else if(ids.get(k) == DealerSalesConstant.youBioId){
            isYouBioSelected = true;
            selectedProducts.add(DealerSalesConstant.youBioId);
          }
      }
     //System.debug('plusFlag: '+ plusFlag);
     //System.debug('ekstrakanalerFlag: '+ ekstrakanalerFlag);
    // System.debug('@@ selectedProducts @@ '+ selectedProducts);
      if(selectedProducts.size() > 0){
           pageRef = getDestinationPageName(selectedProducts[0]);     
           //selectedProducts.remove(0);
      }
      for(SalesFlow_Informationer__c salesflowInformation :[Select Sequence_Number__c, Description__c From SalesFlow_Informationer__c where Page_Type__c='Digital TV Page']){
            DTVInformationMap.put(salesflowInformation.Sequence_Number__c,salesflowInformation.Description__c);
            system.debug('salesflowInformation ******* '+salesflowInformation);
      } 
      pageRef.setRedirect(false);               
      return pageRef; 
    }
   // following methods are not used
   /* 
    private Integer getElementPosition(List<String> selectedProducts, String screenId){
        //If element not found in the list 999 is returned
        Integer elementPosition = 999;
        for(Integer i=0; i <selectedProducts.size(); i++){
            if(screenId == selectedProducts.get(i)){
                elementPosition = i;
            }
        }
        return elementPosition;
    }
    
    private void addProduct(List<String> selectedProducts, String screenId){        
        if(selectedProducts.size() > 0){
           selectedProducts.add(0, screenId);
        }else{
           selectedProducts.add(screenId);
        }       
    }
    */
    
    public boolean hasCustomerYouSeeCard{get;set;}
    public void setHasCustomerYouSeeCard(){
        hasCustomerYouSeeCard=true;
    }
    
    
     /**************************END OF PRODUCT SELECTION PAGE SECTION******************************************************************************/
     //**************************Bland selv Product Dealerweb-865*************************************
     public Pagereference afterBSProductSelection(){
       string responseCode=null;
                try{
                    responseCode=secondCallToCasia();
                    system.debug('The response code is -------------> '+responseCode); 
                    if(responseCode!='200' || responseCode==null){
                        ApexPages.Message myMsg;
                        myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Second Call to Kasia is not successfull.');
                        ApexPages.addMessage(myMsg);
                        return null;                        
                     }else
                       return RedirectToClearKravetNextPage();
                }
                catch(Exception ex){
                        throw ex;
                        return null;
                } 
       
     }
      public PageReference RedirectToClearKravetNextPage(){
        isBlandSelvFlow = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isBlandSelvProduct'));
        isBlandSelvSelected = isBlandSelvFlow;
        boolean isKortOrBox  = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isKortOrBox'));
       Integer numberOfYouseeKorts = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('numberOfYouseeKorts'));
        
        if((isBlandSelvFlow && isKortOrBox) && numberOfYouseeKorts < 2){
      return nextPageFlow();
      }
      else if((isKortOrBox && isBlandSelvFlow) ||  numberOfYouseeKorts > 1){
        return addDtvHardwareSelectionPage();
      }else
        return nextFlow();
              
       
    } 
     /**************************END OF PRODUCT SELECTION PAGE SECTION******************************************************************************/
     
    /*CLEAR PRODUCT SELECTION PAGE*******************************************************************************************************/
       /*CLEAR PRODUCT SELECTION PAGE*******************************************************************************************************/
 //------------ DEALERWEB-880--------------------------------
     public boolean isTVMedProd(String jsonResponse){
       System.debug('jsonResponse in isTVMedProd ******** '+jsonResponse);
        Map<String, Object> jsonResponseObject = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        Map<String, Object> kundeDataJsonMap = (Map<String, Object>)jsonResponseObject.get('kunde-data');
        if(kundeDataJsonMap!=null){
            List<Object> valgtObjList = (List<Object>)kundeDataJsonMap.get('valgt');
            for (Object valgtObj : valgtObjList) {
                system.debug('valgtObjList ****** '+valgtObj);
                Map<String, Object> valgtObjJsonMap = (Map<String, Object>)valgtObj;
                if(valgtObjJsonMap!=null && valgtObjJsonMap.get('aftaletype')=='clear'){
                    List<Object> varerObjList = (List<Object>)valgtObjJsonMap.get('varer');
                    for (Object varerObj : varerObjList) {
                         Map<String, Object> varerObjJsonMap = (Map<String, Object>)varerObj;
                         if(varerObjJsonMap!=null && varerObjJsonMap.get('varetype')=='kyd'){
                            return true;
                         }
                    }
                }
                else if(valgtObjJsonMap!=null && valgtObjJsonMap.get('aftaletype')=='dtv'){
                    system.debug('aftaletype ******** '+valgtObjJsonMap.get('aftaletype'));
                    List<Object> varerObjList = (List<Object>)valgtObjJsonMap.get('varer');
                    for (Object varerObj : varerObjList) {
                         Map<String, Object> varerObjJsonMap = (Map<String, Object>)varerObj;
                         if(varerObjJsonMap!=null && varerObjJsonMap.get('varenr')=='1201507'){
                             system.debug('varerObjJsonMap.get(varenr) '+varerObjJsonMap.get('varenr'));
                            return true;
                         }
                    }
                }else return false;         
            }
        }
        
        return false;    
    }
     //------------ DEALERWEB-880--------------------------------
  
  private boolean isKraevetFlow(String jsonResponse){
      if(Test.isRunningTest())
      {
        jsonResponse = '{"clear-kraevet-valg":{"min":0,"max":1,"varer":[{"kundetype":"I","navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/-1720309137/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Pakkeskift uden beregning","sortering":"11-11-1141","produktgruppe":"1BK","varenr":"1119008","varetype":"kyd","sorteringsgruppe":"01-9999","sorteringsgruppenavn":"Tilslutnings- og omkoblingsgebyr","kortnavn":"Omk. gratis","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/-1720309137/1119008","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"tlf-kraevet-valg":{"min":0,"max":1,"varer":[{"kundetype":"I","navn":"Oprettelse af telefoni","sortering":"3","produktgruppe":"4TK","varenr":"1401111","varetype":"kyd","kortnavn":"Oprettelse","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1401111","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"kunde-data":{"dtv-uden-clear":false,"kundetype":"I","link-history":[{"index":0,"time":"18-03-2015 07:24:36","array-state":[{"task":"init-afsaetning","status":"ok"},{"task":"bind-array-vars","status":"ok"},{"task":"response","status":"ok"},{"task":"get-userselections","status":"ok"}]},{"array-state":[{"task":"set-userselections","status":"ok"},{"removed":["V.FO2.KYD(-4000)=NONE","V.FO2.GA(-2000)=NONE","V.FO1.GA(-1000)='+1101101+'"],"task":"bind-array-vars","status":"rollback-success"},{"task":"response","status":"ok"},{"task":"get-userselections","status":"ok"}],"index":1,"time":"18-03-2015 07:26:52","link":"/opret/1206002"}],"kabeltype":"coax","adresse-kreditvalideret":true,"kampagner":[{"id":"20150204BS20","navn":"Bland Selv 20 uden køb af GP gratis den første måned","type":"Casper","betingelse-opfyldt":false,"kampagne-udnyttet":false,"opfyldt":false},{"id":"20140810PS","navn":"Voucher tildeling til 60 mbit og 100 mbit","type":"Casper","betingelse-opfyldt":false,"kampagne-udnyttet":false,"opfyldt":false},{"id":"20150223BB","navn":"80/30 Mbit 1. måned til 0 kr.","type":"Casper","betingelse-opfyldt":false,"kampagne-udnyttet":false,"opfyldt":false},{"id":"YouBioGratisMaanedenUd","navn":"Gratis YouBio måneden ud","type":"Kupon","betingelse-opfyldt":false,"kampagne-udnyttet":false,"opfyldt":false,"master-plan":"YouBio"},{"id":"20150302CMore","navn":"Bredbånd kampagne 80/30 Mbit 1. mdr. til 0 kr.","type":"Casper","betingelse-opfyldt":false,"kampagne-udnyttet":false,"opfyldt":false}],"alle-i-kundeid":["610053061"],"salgskanal":"Forhandler","laase":"000000","instnr":"60032","bb-uden-clear":false,"boligtype":"E","topgruppe":"4","aftaler":[{"abonnementer":[{"status":"aktiv","navn":"Mellempakke","aktiveringsdato":"01-12-2006","digi-info":"CL","bindingsdato":"31-05-2007","sortering":"11-01-0020","instnr":"60032","produktgruppe":"1MP","varenr":"1101101","abonnementsid":"1720309137","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"20","kortnavn":"Mellempakke","links":[{"rel":"pakkeindhold","href":"http://preprod-kasia.yousee.dk/afsaetning/pakkeindhold/0005017038/1101101","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP","CLEAR1LT"],"amsid":"6593519"}],"kreditvalideret":true,"aftaletype":"clear","kundetype":"I","kundeid":"610053061","aftalenr":"-1720309137"}],"links":[{"rel":"kunde","href":"http://preprod-kasia.yousee.dk/kunde/610053061","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"},{"rel":"adresse","href":"http://preprod-kasia.yousee.dk/adresse/6593519","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"kundeid":"610053061","valgt":[{"aftalenr":"-1720309137","aftaletype":"clear","kundetype":"I","kundeid":"610053061","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/-1720309137/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"varer":[{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP","varenr":"1101001","abonnementsid":"1720309137","beregnet-handlings-dato":"01-04-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/-1720309137/1101001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]},{"aftalenr":"dummy-1","aftaletype":"dtv","kundetype":"I","kundeid":"610053061","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/dummy-1/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"varer":[{"navn":"Bland selv 20","digi-info":"BSPak","sortering":"20-00-00000000000401","antal-bland-selv":"20","produktgruppe":"2BP","varenr":"1206002","beregnet-handlings-dato":"18-03-2015","varetype":"ta","sorteringsgruppe":"02-0092","sorteringsgruppenavn":"Bland selv tv","kortnavn":"Bland selv 20","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/dummy-1/1206002","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]}],"amsid":"6593519","bstv-tilladt":true,"stikstatus":"1","anlaegsnr":"0005017038"},"bb-ga-valg":{"min":0,"max":1,"varer":[{"kundetype":"I","navn":"Bredbånd 60Mbit/12Mbit","sortering":"31-13-00000000000220","produktgruppe":"3WH","varenr":"1301121","varetype":"ga","sorteringsgruppe":"03-31-0020","sorteringsgruppenavn":"SAVE Hastighedsprodukter","vaegtning":"220","kortnavn":"60/12 MbitF","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301121","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 50 Mbit/5 Mbit","sortering":"31-13-00000000000260","produktgruppe":"3WH","varenr":"1301124","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"260","kortnavn":"50/5 Mbit","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301124","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 40 Mbit/4 Mbit","sortering":"31-13-00000000000230","produktgruppe":"3WH","varenr":"1301123","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"230","kortnavn":"40/4 Mbit","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301123","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 20 Mbit/1 Mbit","sortering":"31-13-00000000000190","produktgruppe":"3WH","varenr":"1301129","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"190","kortnavn":"20/1 Mbit","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301129","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 20 Mbit/2 Mbit","sortering":"31-13-00000000000190","produktgruppe":"3WH","varenr":"1301132","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"190","kortnavn":"20/2 Mbit F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301132","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 10 Mbit/1 Mbit","sortering":"31-13-00000000000170","produktgruppe":"3WH","varenr":"1301131","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"170","kortnavn":"10/1 Mbit F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301131","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 30 Mbit/6 Mbit","sortering":"31-13-00000000000175","produktgruppe":"3WH","varenr":"1301143","varetype":"ga","sorteringsgruppe":"03-31-0030","sorteringsgruppenavn":"BB Light Produkter","vaegtning":"219","kortnavn":"30/6 Mbit F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301143","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 15 Mbit/3 Mbit","sortering":"31-13-00000000000175","produktgruppe":"3WH","varenr":"1301142","varetype":"ga","sorteringsgruppe":"03-31-0030","sorteringsgruppenavn":"BB Light Produkter","vaegtning":"219","kortnavn":"15/3 Mbit F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301142","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd BlandSelv 15/3-30/6 M","sortering":"31-13-00000000000175","produktgruppe":"3WH","varenr":"1301151","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"175","kortnavn":"BS 15/3-30/6 F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301151","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd BlandSelv 15/3 Mbit","sortering":"31-13-00000000000220","produktgruppe":"3WH","varenr":"1301909","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"219","kortnavn":"BS 15/3 Mbit F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301909","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd BlandSelv 60/12 Mbit","sortering":"31-13-00000000000300","produktgruppe":"3WH","varenr":"1301912","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"299","kortnavn":"BS 60/12M F","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301912","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd BlandSelv 50/20 Mbit","sortering":"31-13-00000000000280","produktgruppe":"3WH","varenr":"1301926","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"279","kortnavn":"BS 50/20 Mbit P","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1301926","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 30 Mbit/3 Mbit","sortering":"31-13-00000000000225","produktgruppe":"3WH","varenr":"1319019","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"225","kortnavn":"30/3 Mbit","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1319019","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Bredbånd 10 Mbit/1 Mbit","sortering":"31-13-00000000000170","produktgruppe":"3WH","varenr":"1319017","varetype":"ga","sorteringsgruppe":"03-31-0010","sorteringsgruppenavn":"BB Hastighedsprodukter","vaegtning":"170","kortnavn":"10/1 Mbit","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1319017","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"youbio-eng-valg":{"min":0,"max":-1,"links":[{"rel":"opret-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"varer":[{"kundetype":"I","navn":"YouBio Boks","sortering":"18","produktgruppe":"7YD","varenr":"1702010","max":10,"varetype":"yd","kortnavn":"YouBio Boks Butik","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1702010","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"bb-ta-valg":{"min":0,"max":-1,"links":[{"rel":"opret-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"varer":[{"kundetype":"I","navn":"YouSee WiFi tjeneste","sortering":"31-13-00000000000100","produktgruppe":"3WW","varenr":"1321002","varetype":"ta","sorteringsgruppe":"03-31-0120","sorteringsgruppenavn":"WIFI","kortnavn":"NIX YouSee Wifi","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1321002","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"YouSee Cloud Unlimited","sortering":"32-19-0010","produktgruppe":"3WB","varenr":"1302009","varetype":"ta","sorteringsgruppe":"03-31-0100","sorteringsgruppenavn":"Sikkerhedspakker","kortnavn":"Cloud Unlimited","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1302009","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"YouSee Secure 250 Test","sortering":"32-19-0015","produktgruppe":"3WB","varenr":"1302010","varetype":"ta","sorteringsgruppe":"03-31-0100","sorteringsgruppenavn":"Sikkerhedspakker","kortnavn":"Secure 250 Test","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1302010","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"YouSee Secure 100 Test","sortering":"32-19-0014","produktgruppe":"3WB","varenr":"1302011","varetype":"ta","sorteringsgruppe":"03-31-0100","sorteringsgruppenavn":"Sikkerhedspakker","kortnavn":"Secure 100 Test","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1302011","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Sikkerhedspakken","sortering":"32-19-0010","produktgruppe":"3WS","varenr":"1302003","max":10,"varetype":"ta","sorteringsgruppe":"03-31-0100","sorteringsgruppenavn":"Sikkerhedspakker","kortnavn":"SikkerhedBB","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1302003","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"array-init":"[2343 365]H4sIAAAAAAAAALVdy24dSXLdG/A/eMcxZkRU1rsw8IJXogSBVFPoy1aPVg22RXOIpqmGmgLsH/CP+cdcr1uVkXEiT3gxvZi5Yp3KjHdGRj7q/fPx5fztzd/Oj3dPD39c3T3fPf2pLIp//be3X7/9/e75y9P9t7/+8z+931Avj78dX+5evv+xoEL88PD16fHh9r9/v1+eXe7PqvPD4fvr68uLH5dHxf6oPH9z+8l49rfzq7tf75/2Jv/9691/xa1++Prl/j+XRz/c/HAp3vz+/OV+f/O94OLxYeNTcPDm7uXr8ud/KYvQvCqqV6HfAeH8cLx9fHq6+/KiXg7jyw/3x8cv9883v//96/23BfEqxPRCSCjG/4RAHKjahWpdqM5J18Xzy93TxX+M/3OCFDH/F/fPX749Pj/YElpaP79RL7enR+/Vo9p+VNmPSvtRcDy6AA1ejPb0PFvVh/svh6OFWOSTQK5nat9d/ClMfzkLVRFCGc7+sv6qt1/V9ms4/arK7df2Rr3h6u1pc3o6hOL0qxi2v51wQ9nOv8aHYdh+dWd/WR3oembl0923x/PLq/OzUBZlMXRnJ8qXf4Z3H7MvdI14oWvYC20tXmhr9kJTiReair0wCip+oS7ZC6O04xeqwF4oC/HCGEDUC7sFTOGlmPU+/2oS4O3F+Vl5+1PUYCjqPq+kViqpZfT2Ukk9VVInldRRJbVSSS1XkpR5TWVeSZlXQOaJlCTTA7dMaTcttZtG8tBQHmrJQ614qGZzqK7er7joUYhMKow2UsxBYPwVtl/l9CsnEanVgWq1l1rtqVY7KcKOirCVImypCBspwsYS4c+3WoSrsx0uhLMV3eqbRSBuJ6UxUGn0Uho9lUYnpdFRabRSGq3lFB/vfvvtfmT9w//+DxJLhJnTs3C8XZtt26Zuy7oZ4/rxNi8dyexAme0lsz1ltpPMdozZ289n56tiW8J1DC62uLEw3xRVT3p68/70ctWbPe2SkowPlPFeMt4zxndyGg85svXh/9F6p1s/RbAD6vjzm8n9Pu/9NUVRwQGRG2pMSNtKldVDZY2J+uW6drnEdeIS7TgCXUOXAFZRUmYujgkLXZO3uoWqdx8TRx0GwvjFj2lHJXslYqRAA9PV5zfbyBS2kWn6Va6/wva3cPpbueGGoui3Xx0M5mA8LONuZ0OaG55/VcikdgkvrAxJT1Fz1UTdkkZPv5akfUzA16R9+tWsv6pi+zUl3qDbH+VoI2mr427HfGD8b2pu/jUTUIcxzhXbL+ks7f42GOY+Rh23q7TnX+X2KxWUUPvr69Sr2sWrtsBYsNAVxmlJFFzGfxJTe/3n1Dr7Lu6z7kMr/1038t+d/PdQ1JLmVkWGk5EdNlKrMQ6eJlRlcZpkjb/y+ZVktjCZ3aQTpHQCfaHopTitELGRJHsoaA+F7KGgPYQgSQr0haKTPNApZil5MMPV1kMpSSqplCRJBSUpBMlDoC8UrWSaTtkkDwXnQZJUcJJKyUNJ9SB5KCgPIUimA32haKSU6JStlqZRU/OupFjNzG7XgxQrlVIoJdMll5JkOjCmx4xFSglM4+YBYIvfuemUFGBDBVhLAdZcgNJqqDwKKY+Cy6OUAizpC0EKMLB58JgsSImDmd8i8T9HuLANuWHy5vVXN2SZb6U+Wq4PaZ819eJK6sNMlHcFSn1w8ZZSvCUtM0jxFki8iQKlPgJ9oSilAvlMXOqho3popV+01C8aqbiGKq6Wiqup4iqpuEoprotKSt1qrzlDkOUjrleppoKrqZR6LbkhSL0GptdpHiIMgc+9pSH01BA6aQgdNwSp14bqtZZ6rZVe202vOW1K5VBZF1LWBZd1KZVTUqeTynHMLoLUZuDTkUKq36oevoUTzqRuIi3DnHjvpiQto6eW0ckQ0dEQ0UpT0lMdZQRSp1xFUuIFl3gpVVRynUoVBV7nl2IdqFh7KdZeibWO4mJdnMoY9VIbPP3Kj+Od1ERHNdHI4NrQ4FpX3EQrqd6Kq1fWAqnwg1wJC3olLMwOFY6XUwkpzC63vnFaLe3msmD3+c2E6OJ0oJBtXPwwtzFmyNtIVEi3vfp5QlTNmKSkiLX4uPRSNsVumDYdZbaNEPZSMaa0jOZMFh27C9p0pJTWM6JeEHNZaKCUpvJQbWwT/xOinRHtgmjLStMhuB2JGIjmJnmkEtPy4NymlGpuUzpUL1Xai6ajoL2kmjsVkhYrrItaaV94wySxIS8PpBfNS0rpyRuOmzfk5RGAV2peUkoTvbTaxgS3fUG9YeK2yyMqh1cGakHMG1ozBkW8EN/3UFqTSNdpiWle0jY0LykdmhdDcxEvWd8f/6sbI56+fb/EsUpLTPOSUqp5MeiIeKExSEWYRC9DY41RES96BJoQ1W01+0sYs5A0JiuE8mwtD+2Voo1qr68bvPSaUs1LKrGU0o6PL7WOQUkbilstMR3pls0xeh3XlAeTehVIPJ0kpqPlTAdY5bVlavjcyV+AXrQ80lgYZkS4DXMbYxNgBJLc6sxAS4zLQ8exWR6XV2enPDOlVMtD+5yUaWUh9l6oxLqS+pyyIOVzatzXUmdeqTOUBFGXSrdaL1r7woLqstN+G4/Zk62T0XSgY1TPNbdvMsB0lCBPVm2UKUJbEI0wTKZjDKLxo8z7XDkOHySHGTwS05SmEqO2rmS6In7erJBF3ErHU82tznIkomKUTgxTbo2Iu/t+S7xh2MtTpu8rG9My1XlQKg+GqMjcI/RVb2Uob7ZZUspLOyPaD9fzXAxlOcrGaj0DTmSqEDqeMon1YCaeWKEjJpP8o9qXhGy9aJmmesnbR2XnuFc3J72omYW2ZOr7lTGaRrGQjoQKoWRa0eyipFKvWLQsAtN+cEQYnSmlmiMyrbXUtb9wvRgyPfEyVDyDVbUc7Q1s3N9XbUyZlnwUM3Qb6YV7FJeYrpAkdtoQeYwypWM2kOnic0t1A1UVtDcwvQQW6apAdRssb4hyOua3nUVpJA/u+8SSK51taSukFmRF/ig60NmrxUskUxal9vUCbMmoppRKjI0eRdfQOXIPqnBpPsZma0HNPbQ88tFy4sWoOa6jWAHmt1oe1Aotbnd5gIrAsrS2VxSpBTFLrkvllWsMur5cYlClta8lpr1hiTA3Gx1pDpPUcQtdh9G9kMyxMceoiJe83xZDADlMSkfe1lFFUVhQj0bTtBc2s5hmScacMOI2LzFkpykC5Q5J9ZzUtkYEWBl5dxizi8t3c3aBsj4tj/x4O8nDyNcjedBVDVLLmXgxKjXRapORr+9xTHm25ja7EjCvFNF1IDWb17wY4/6J0q5QY4Pm1qg5RlLPV0gmSlM6dC8sBnl8n1sylalVC44oNUaPaO3VmImfVnhBnU6vrXHt0zaUN2he8is0Ey9kfa7Q8VSvNGsrXMa54zYnzPYyS8yq5F0vcd2lfRodlCVrieXXgSaJGTKNJGatRu4SM0axq2pFsKg9HaM16h+7v4A6bhqDZC835//IsyxL68m+rIvn4+9vflpO2x+Oy/+//Xg4LqBqMCAfNkiYSL9EU68hVjZE9IEhugIjDscF0RRi+fpSKSotdsE2WoPSHdEYlO6I2qA0kgfltk/byC8NYHnUDMHl0VF5tFQeDZcH54VS2lNKO0ppS+mw7DTqhfNC21Da121ohAywchKAEAVFyAVM3EufIPKTkctoOMEbUyCllI5C0aF5oQiRGGFK8xEmTXoxpWkvmlKKUBLLL8ZGejFSp4hbY0qMuWWUFlS3siiLuU2lnl8ExdxyG6MIqn1ZyMS8pDLNL+lhXtJejH3CmE1qwlTtsraI2UzDdX7OhQXBEJWi1DjvjaVIrduU83HzEB3Jc1MHLO5UVPkEFCtEj46pQlgGxsaLNM3VMk03mGKlMvuvgDxyk5yI0u0sf6T2/E4orDJDIcZeKaxULe5UZRSh1J7fbwUTK4pAQ3xqGHluQ0Bqz+3Fxaaj49Ky3+rTan4tCPKpceleUuNKpZ6fD0LdVjrqJPVoJdP8/jNsp9zGeFigFsQorZD2ExujFsSSs3R3CLZTigCJ1ZI0X6CwkCuLLC8n02M1iqnqErZJnYilNqm1lDs/gJNsoulkNxoe7tgECqXyqdXShFDZZP4sBLJJPh2Q63BRG8Z+JOwbGpHb0QYtH0g9sdqS+hftBU0YUt9IzTu/Kw5HeZ2P5WpY2F9YhC5Nb8DnB7A36MlxejUJnFRT++64fSvrVV7kGB10MEo9kY8ffMJDfYTGjKCKUPndp7HlJVeigZeTjamRIIwFVezG1EkrOoBxJ7V6MbZp41BAKSWz6SmsGaYTBQsDYWxsx+HEStb0vWV2wMnPjNJjYnHSiLcmgoATUJKUOD2fEFS0DT4hoNVaNNykYcGSKd4agAOHVePCG5igR3E7rY0QZ2zFw15JfY7SEUDVJ93eyP3FsPXIG4wyhLGlGNu6Ud82jiQAmSZbAuOhE9aFEhMmsT49+4cdhZatWbhO9kVjN2DLGqw8mu7CipW6zjZr0w2M3ZPQQBs2u9KhNr+/Ejub4SjGTh3sjszI5aka6EoNd1jKC3c2ZR/5kzla++n+ORwWKB2gsJeGBaOX7Q4+PR+NIoYuVAjTCTpRzm+ewVHHmPKllzXFgy8+URohjB3quo30nCYOatasfo9cpLpge3uUBLC41FkWEcU2EnUGXdrPn2DAsY3Fx17VL/PneKEPtTxy0ZjCPbXm6b1RazP2OePIRZOAhs/jeVyidFjxIIopFGHVL40zHzgs8Hpu3m/TE9jQG1QKqBBWghd5Ns0WVC02v58W+xyT+n7/lukNlo1FfkvtozUmAMZOeZxxsOmwXpDSEwBj/cPYbY8925CHsX8UezbVS0XlwSnlPmfZR5QtkPQejJXa9w2Eunsax4V8zTQ9Twa9Xo3W+Z2jEyJ/9wtEWBtGjBsRYFxQebWOPjy2MI81c9Hdp7k/9iml+Z34uDDA1pt6q3IfRTBW7TZ9KYpg1B9bPiPixQUWF7gv7XfS2dHHSK+Nsy3Q61tewqDRh8eWmkcwGlu4fVjj+V7Qo23o1cb8/UI4juW3taW31GiPSk+u4DiWai5/qxOMDipDzp86wVEq9Zf8uRScRdFeeEWF28eguRVzih6Vc9NoSbejWjmBcXZyQuRPv+CYrEegNCazzaaO3KRjc060JUfYenLzD6C043MKR5RSOx7y59rinBEUFvNHVXG4NgzDOG4CewHLykux5ahJ1FGYkmg1b5ykx1GYtmEhohibxsf8rWawF9VG/qwKzuJo1FFzJh1BaYwF83LhISDq5M+64Sic8qI/ZIFjM41nNKfS85P8GWycp7Ko2VG72q8ttaM3j8088rLxTu+W0ZHXikX4dNJivWArjw7YLDWVx9BxSKciaPObWtNDosCBa8cQpzYMrYgfDqeICkJ6WiigMZeblUrW8gfmcZrNC3w0fHNKOR3UvIO1xhsFeB6+U/vIX1yIw3cqsfyFPSDAt6iNCWFdwIrDN9mt0LPtQOnh3UhixgUCOMDzMEzboJOs/WOldnrLNun1dAHVzHOiOMYn8vQ8lvK59KtEuUCq9mepdI7u8DNdKQotVCF8PLLc0bjVDocF7tJ0o4s6MJi/4RM7PXHpzlxLMW4ewWEhRajb/aHlqzKYThd5MshOd5qFoe3bY9n9D2RATG4ZwUGCOrjjaCidr/XUwa3BLAoSxBYqh/e0dO7ZGAoxzkVjP6d0ODwwpTR/6yzy80YduMzf0L4ggG/kr0zGozUzK502569dhsarSjzaR9l0rFIJvp70kdNtgx5p89dT4IkXnzRxR+Tlf735NbPNOHIcOnRZZ8wjt+BDhjbH1GC1XbkMlhsbVRCdb+q5Yv62WGywLAGtelrHAFOpdNjh5kgRPA5ah/mjcYGunPDRxzruHxkvn3wavWzfI9ObiozLnLBd6+l9aqDc/Lhx8XP+/LYJOu+w5raR+ekZkusoA0+PrRsVIoPiy4o8SZDGcMM4uP1JG0n+9mUY2qyzDcbdZIsZuQRr5WdR5CL19M4cfCLjooZhZV+RCfC4FNNxcQ7uhLnEV8Vcij+ezZsHRoGOT66OL+cfjz893Nfhl/MP358eHxZMWJ8djtXw7uP4PFS/hD5GFCvi9v6Pl3ff7l4e/7j5/VtVfPj18QXBDseyGJtpfwkl6uf1h6/f7qduiqSbmJAcGa+f7u++vf0IuogpeJcHzB8SPhzQw7wQDsfbpwf84uev3w+PX3+8+/XuBfJ1GNsdfgl1+vCTnBC9CsX2MebybH6+qXp8Fin74tex2endy6tPd08PL+eXI6A5kfRJR77lcN2rsshjWoZZtqRkMeup9CxmPaaU72tZSqAY1tc6C6X0ML7WtIK0My/tUgyjZ91SQdthMlwPvzHePfJx8B6ovtZrKCiG2eF6AwnFMJtfb5ihmIHLOXDMXASg7Tj4oj643p1C23HYWHDIJ3Cdzts3aDvcfnj8WU+p0b6YnNcTQLQdLueCymfd988wNbefQPW1biamNHtkSMeUjo87651WtB0PXx5d0HFn2dBE+6L2Mzh0Orh04eHLEcc8fsH5Wm/2ohhHzPSMcQ4fdMmwcsTeytMOz0nmOw0phtrPUgqhGOoXy6YljJnu51mfrKlllJPKk3eqgSVvvcg0ILfVGQ2Ic7AEM28Moe0g60zbQdaZtoM0lLbD+8LZDKgNUAynB2cqYBJKMchbwJolxSBvSTHIW1IMlw/OUNPajUPvcFQD26BoOw5dNA7baBx22HA5z3UrivHI0KF3mKWBJTGKcdgGzGJTjEM+rQfj0Ffr0HvrsLHWoYuWy3AuS1GMI/50Dpo7RwzvHDLsHDbfOeTcOeTTOfTeeeTj0FfvaAdmD6CgyTCescAzVvYOGXrGbs842Htk6Oir9/DukLNnTBkcuhgcvA8OegaHrQ4OmuEsMW3HoXfPGDd4MB56HLbqGC9whQWsRVOMR84Ofy8d8ikdeSasPKYYx3haOnI2WHlMafbw7tCXqy+Hf5UOG3Pwjiu8YBmHYhz2UzlkWHnoccinMm1sWiY2J3nT8qD5UF7fgVuX93HlMXUmIssbhBjGzuDl9SkMU5sWI/dLUwynuXLw3thRW26QZBg7Asq90xTj0JftCfJAN23H9Jb5yLZppdOJJNu+xSVsuHl5yRrD2IFRHgbAmOmuGptYcTUvbkAeQqUYU+5ylz3FcHoyMwx58QPFmIqShwEpxvRbubebYjxy9tDjkbOHd49tcL4ymYK8TJVh7FgjjzJTDJdzZvYgj6NSjMMO7Zmc3DpM+XLYoT1Lk5fZ0HY8cnbYmD3Tlff4UYzHfrhOM9U4edSdYhxxzK4yyuP9tB2HPduzann8g2I473j9KG3HwZc985bXUtB2HHK287yoHYe/2xXWqB1HX3Y1N7Ixj606/MJBT2Z1IsJ4aHaMBQ69Zyr90Q5Gh97t6qnc9U0xDlu183t5ypRiHDbfOmzMri7LXaAM4xjfM3m5PMxPMQ59OfLMTDUlwjhk6MhbMnPaCOPQqSO3yczHIoxDF54cyTFWZqpoEcYhZ3vlUx44ohiHfOzV4wjj4Mue88tz1gxjV3wjjEM+dsU3wjjkY1dhI74ctmFXu6N2HH3ZlfWoHYef2lXzCOPhy9GXXcuQx+MoxqF3u/IXYRy829XBCOPQl12/izCmnKcbbs3Chvy8AG5A3q5MMaZg5J1kFGM6sbwsh2HsAVCezUww8LIKgikB7/CWTorR8oE3NxEMkg+8qZe2w2lGeodfscu30yG9ww+nUQyT4foBQtoOk2EJlzPhN/4ohtsPShDg18FoO5x3bofrV2xoX4yv9abyLGb91CfFUHrgpld4y1ses9yZkMcMKDGEX4RjGBDH4EcJ8/QsH4PMYzpfO4zm9VOkOczpe3m0HaavEo4F8B530lcNCi3wYywYI2+Ez2IKeMgGHhPFGPnhYYrxtIPGwQhz+sxMvp3l9st8O2XGv+Q3tHKY0y1wjB7bv+R1RLQdwvvpDhSK0XzNN3fpNA3eoaBeTTGaBHhymGK0mcNLjhkG1Jrhdcq0L61q+K34PKZ1yKd1yLl1yKdFcq6wquElbOpViUHLW/C+Y4rRooW3x1OMFgm8b4W0gzIPeIdPHrN8Vo2004EpIbwRh+qCYpavXlAM1xdaYoaX1lEM12kHXBx+eo62Q3mv0LIU/GYgbUeHE/iRMaYLUPqD3x+kGC6f3sF7z/mq0JIuvIyQYbjeA8r+4bebWUxw0IxmEfCrlUyGoKQJv2vM2nH4BZplwe/LUIynL0bzehcE453Hn+UGVIrhcbUHZTT4PV/aDtNpBWcI8H5wijHbkV8EYhjbNuQ30Wg7pgzlV8/ymOXua9IOWpqBd+8wjD2+y+9h5TEdWr6BHwukfJk2Jr+CR/nifaHtIvCbDNQ2TL1fLZhpvyyy1Wk2Mn8qESWh88Pp9kvz4dvcm/Ljxbjr6YO4dtfi+05GA+K71FlMCY+Aw89WUgySd4pB/hFj6tE9kE+nGLOd6FvpZjsRxtOOzdeiTDxjhZ9TNTDixmoDIz7tijHrR+wn+ZjtyA/dG31lLThr+7uGtNRaPLGDH25Qr06Om9w5rDATCcltiRSjFddhMuHNUurVBAPiHfw4I8VoP4bfMqEYbe/w0miKQWJLMTquwIsHMUZec00xJs3yZk+KMWmW185RDKoUTreKvapTu6qNv1fG31v49xujh/8DtmJre17TAAA=","links":[{"rel":"priser","href":"http://preprod-kasia.yousee.dk/afsaetning/priser/0005017038/F/E/1","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"},{"rel":"priser-nysalg","href":"http://preprod-kasia.yousee.dk/afsaetning/priser/nysalg/0005017038/F/E/1","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"tlf-eng-valg":{"min":0,"max":-1,"links":[{"rel":"opret-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"varer":[{"kundetype":"I","navn":"Overflytning af nuværende telefonnummer","sortering":"8","produktgruppe":"4YD","varenr":"1417006","max":1,"varetype":"yd","kortnavn":"Nummerportering","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1417006","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"dtv-eng-valg":{"min":0,"max":-1,"varer":[{"kundetype":"I","navn":"Ombytning HD-boks","sortering":"21-00-00000000000100","produktgruppe":"2YD","varenr":"1218387","max":10,"varetype":"yd","sorteringsgruppe":"02-0010","sorteringsgruppenavn":"Leje af bokse","kortnavn":"nPVR ombyt u/dele","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1218387","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"serienummertype":"single"},{"kundetype":"I","navn":"Ombytning YouSee boks","sortering":"21-00-00000000000110","produktgruppe":"2YD","varenr":"1218386","max":10,"varetype":"yd","sorteringsgruppe":"02-0010","sorteringsgruppenavn":"Leje af bokse","kortnavn":"PVR ombyt u/dele","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1218386","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"serienummertype":"single"},{"kundetype":"I","navn":"DEMO HD-Standardboks","sortering":"21-00-00000000000540","produktgruppe":"2YD","varenr":"1218385","max":10,"varetype":"yd","sorteringsgruppe":"02-0020","sorteringsgruppenavn":"Køb af bokse","kortnavn":"DEMO HD-Boks","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1218385","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"serienummertype":"single"},{"kundetype":"I","navn":"K.nøgle - Vejl, Kold & St. And","sortering":"21-00-00000000000300","produktgruppe":"2YD","varenr":"1250109","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Vejl+Kold+St.An","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250109","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Grønne kuverter","sortering":"21-00-00000000000360","produktgruppe":"2YD","varenr":"1250009","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"Grønne kuverter","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250009","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Thisted & Morsø","sortering":"21-00-00000000000290","produktgruppe":"2YD","varenr":"1250119","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Thisted+Morsø","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250119","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Ølgod","sortering":"21-00-00000000000310","produktgruppe":"2YD","varenr":"1250108","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.nøgle - Ølgod","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250108","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Ålborg & Nørresundby","sortering":"21-00-00000000000320","produktgruppe":"2YD","varenr":"1250118","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Ålbor+Nørresund","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250118","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Sønderjylland","sortering":"21-00-00000000000280","produktgruppe":"2YD","varenr":"1250107","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Sønderjylland","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250107","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Mariagerfjord","sortering":"21-00-00000000000260","produktgruppe":"2YD","varenr":"1250117","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Mariagerfjord","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250117","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Fyn","sortering":"21-00-00000000000190","produktgruppe":"2YD","varenr":"1250106","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.nøgle - Fyn","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250106","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Frederikshavn","sortering":"21-00-00000000000180","produktgruppe":"2YD","varenr":"1250116","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Frederikshavn","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250116","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Holb, Ringst & Næstv","sortering":"21-00-00000000000230","produktgruppe":"2YD","varenr":"1250105","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Holb+Ringst+Næs","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250105","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Pris/Produktark S002","sortering":"21-00-00000000000400","produktgruppe":"2YD","varenr":"1250005","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"Pris/Pr.ark S002","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250005","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Horsens","sortering":"21-00-00000000000110","produktgruppe":"2YD","varenr":"1250115","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K. Horsens","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250115","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Guldborgsund & Næstv","sortering":"21-00-00000000000210","produktgruppe":"2YD","varenr":"1250104","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Guldborgs+Næstv","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250104","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Favrs, Rand, Silkb & Århus","sortering":"21-00-00000000000170","produktgruppe":"2YD","varenr":"1250114","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Fav+Rand+Silk+Å","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250114","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Greve, Rosk. & Solrød","sortering":"21-00-00000000000200","produktgruppe":"2YD","varenr":"1250103","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Grev+Rosk+Solrø","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250103","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Skive & Viborg","sortering":"21-00-00000000000270","produktgruppe":"2YD","varenr":"1250113","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Skive+Viborg","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250113","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K. nøgle - Bornholm","sortering":"21-00-00000000000140","produktgruppe":"2YD","varenr":"1250102","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Bornholm","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250102","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Hern, Holsteb, Lemv","sortering":"21-00-00000000000220","produktgruppe":"2YD","varenr":"1250112","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Hern+Holsteb+Le","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250112","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Hovedst. & Jyllinge","sortering":"21-00-00000000000240","produktgruppe":"2YD","varenr":"1250101","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Hovedst+Jylling","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250101","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Oprettelse Ekstrakort","sortering":"21-00-00000000000020","produktgruppe":"2YD","varenr":"1250034","max":10,"varetype":"yd","sorteringsgruppe":"02-0000","sorteringsgruppenavn":"Programkort","kortnavn":"Opr. Ekstrakort","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250034","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Velkomstmappe fyldt","sortering":"21-00-00000000000390","produktgruppe":"2YD","varenr":"1250001","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"Velkom.map Fyldt","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Esbjerg","sortering":"21-00-00000000000160","produktgruppe":"2YD","varenr":"1250111","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.nøgle - Esbjerg","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250111","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Digital kortlæser","sortering":"21-00-00000000000160","produktgruppe":"2YD","varenr":"1213008","max":10,"varetype":"yd","sorteringsgruppe":"02-0020","sorteringsgruppenavn":"Køb af bokse","kortnavn":"Digital kortlæser","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1213008","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"serienummertype":"single"},{"kundetype":"I","navn":"YouSee Dongle","sortering":"21-00-00000000000180","produktgruppe":"2YD","varenr":"1211006","max":10,"varetype":"yd","sorteringsgruppe":"02-1000","sorteringsgruppenavn":"Hardware","kortnavn":"YouSee Dongle","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1211006","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Produktark S004","sortering":"21-00-00000000000430","produktgruppe":"2YD","varenr":"1250011","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"Produktark S004","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250011","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Bram, Gør, Host. & Vejrup","sortering":"21-00-00000000000150","produktgruppe":"2YD","varenr":"1250110","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.Bram+Gør+Host+V","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250110","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Adresselabel - Dig. lager","sortering":"21-00-00000000000340","produktgruppe":"2YD","varenr":"1250010","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"Adr.label dig.lag","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250010","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"K.nøgle - Køge","sortering":"21-00-00000000000250","produktgruppe":"2YD","varenr":"1250120","max":10,"varetype":"yd","sorteringsgruppe":"02-9000","sorteringsgruppenavn":"Forbrugsartikler","kortnavn":"K.nøgle - Køge","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250120","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Standardboks m/Canal+ 12 mdr.","sortering":"21-00-00000000000180","produktgruppe":"2YD","varenr":"1213006","max":10,"varetype":"yd","sorteringsgruppe":"02-0020","sorteringsgruppenavn":"Køb af bokse","kortnavn":"St.boks Canal+12m","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1213006","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"serienummertype":"single"},{"kundetype":"I","navn":"Nedkobling på Bland Selv","sortering":"21-00-00000000000021","produktgruppe":"2BY","varenr":"1250035","varetype":"yd","sorteringsgruppe":"02-0000","sorteringsgruppenavn":"Programkort","kortnavn":"Nedkobl BS","links":[{"rel":"opdater","href":"http://preprod-kasia.yousee.dk/afsaetning/opdater/dummy-1/1250035","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"tlf-ga-valg":{"min":0,"max":1,"varer":[{"kundetype":"I","navn":"Telefoni Fastpris","sortering":"20","produktgruppe":"4T","varenr":"1401002","varetype":"ga","vaegtning":"20","kortnavn":"Telefoni Fastpris","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1401002","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Telefoni Forbrug","sortering":"10","produktgruppe":"4T","varenr":"1401005","varetype":"ga","vaegtning":"10","kortnavn":"Telefoni Forbrug","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1401005","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"kundetype":"I","navn":"Telefoni Fastpris Ekstra","sortering":"30","produktgruppe":"4T","varenr":"1401009","varetype":"ga","vaegtning":"30","kortnavn":"Fastpris Ekstra","links":[{"rel":"opret","href":"http://preprod-kasia.yousee.dk/afsaetning/opret/1401009","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]}]},"produktgruppe-min-max":{"2LE":{"min":0,"antal":0,"max":[0,1],"ok":true},"2BS":{"min":0,"antal":0,"max":20,"ok":true}},"ETag":"-3691912610"}';
        
      }
      Map<String, Object> jsonResponseObject = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
      Map<String, Object> kundeDataJsonMap = (Map<String, Object>)jsonResponseObject.get('kunde-data');
      if(kundeDataJsonMap!=null){
        List<Object> valgtObjList = (List<Object>)kundeDataJsonMap.get('valgt');
        for (Object valgtObj : valgtObjList) {
          Map<String, Object> valgtObjJsonMap = (Map<String, Object>)valgtObj;
          if(valgtObjJsonMap!=null && valgtObjJsonMap.get('aftaletype')=='clear'){
            List<Object> varerObjList = (List<Object>)valgtObjJsonMap.get('varer');
            for (Object varerObj : varerObjList) {
                Map<String, Object> varerObjJsonMap = (Map<String, Object>)varerObj;
                if(varerObjJsonMap!=null && varerObjJsonMap.get('varetype')=='kyd'){
              return true;
             }
            }
        }else if(valgtObjJsonMap!=null && valgtObjJsonMap.get('aftaletype')=='dtv'){
          List<Object> varerObjList = (List<Object>)valgtObjJsonMap.get('varer');
            for (Object varerObj : varerObjList) {
                Map<String, Object> varerObjJsonMap = (Map<String, Object>)varerObj;
                if(varerObjJsonMap!=null && varerObjJsonMap.get('varetype')=='yd'){
              return true;
             }
            }
        }else return false;      
      }
      }
      
      return false;    
    }
    private boolean isProductInBasket(String varenr){
      Map<String, Object> jsonResponseObject = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
      Map<String, Object> kundeDataJsonMap = (Map<String, Object>)jsonResponseObject.get('kunde-data');
      if(kundeDataJsonMap!=null){
        List<Object> valgtObjList = (List<Object>)kundeDataJsonMap.get('valgt');
        for (Object valgtObj : valgtObjList) {
          Map<String, Object> valgtObjJsonMap = (Map<String, Object>)valgtObj;
          List<Object> varerObjList = (List<Object>)valgtObjJsonMap.get('varer');
          for (Object varerObj : varerObjList) {
           Map<String, Object> varerObjJsonMap = (Map<String, Object>)varerObj;
           if(varerObjJsonMap!=null && varerObjJsonMap.get('varenr')==varenr){
           return true;
           }
          }
        }
      }
      return false;
      
    }     
  public PageReference afterClearProductSelection(){
      tvBoksURL = ApexPages.CurrentPage().getParameters().get('tvBoksLink');
      system.debug('tvBoksURL ********** '+tvBoksURL);
        string responseCode=null;
        try{
            responseCode=secondCallToCasia();
            system.debug('The response code is -------------> '+responseCode); 
            if(responseCode!='200' || responseCode==null){
                ApexPages.Message myMsg;
                myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Second Call to Kasia is not successfull.');
                ApexPages.addMessage(myMsg);
                return null;                        
             }
             else{
                 //system.debug('hasCustomerClearProduct: ' +hasCustomerClearProduct);
                //if(hasCustomerClearProduct!='true')
                system.debug('dtvtaflag afterClearProductSelection$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+dtvtaflag);
                boolean isKraevetFlow = isKraevetFlow(jsonResponse);
                system.debug('BSXXXXX isKraevetFlow ['+isKraevetFlow+']');
                //DW-871 - Skip clearkravet page as no Fee in BSXX flow
                 if(isKraevetFlow){  
              addIntermediatePageToFlow(DealerSalesConstant.clearKravet);
              return nextFlow();  
              } else {
                if(currentPageId!=DealerSalesConstant.clearId){
                  //DW-866 - add Kort page for BSXX if kort not in existing list.
                 boolean isKortOrBox  = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isKortOrBox'));
                  Integer numberOfYouseeKorts = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('numberOfYouseeKorts'));
                  System.debug('BSXXXXX isKortOrBox ['+isKortOrBox+'] numberOfYouseeKorts ['+numberOfYouseeKorts+']');
                  if(!isKortOrBox){
                    plusFlag = true;
                    return addDtvHardwareSelectionPage();
            }
            else
             return nextFlow(); 
                }else
             return nextFlow();
              }
             
         }                            
        }
        catch(Exception ex){
                throw ex;
                return null;
        }               
   }
     
   public PageReference RedirectToClearKravetPage(){
        isBlandSelvFlow = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isBlandSelvProduct'));
        isBlandSelvSelected = isBlandSelvFlow;
        system.debug('the value of isBlandSelvFlow in  RedirectToClearKravetPage******************* '+isBlandSelvFlow);
        clearForNewCustomerFlag=true;
        
        boolean isKraevetFlow = isKraevetFlow(jsonResponse);
      system.debug('BSXXXXX isKraevetFlow ['+isKraevetFlow+']');
      //DW-871 - Skip clearkravet page as no Fee in BSXX flow
       if(isKraevetFlow){  
        addIntermediatePageToFlow(DealerSalesConstant.clearKravet);
           return nextFlow();  
         } else {
           if(currentPageId!=DealerSalesConstant.clearId){
           //DW-866 - add Kort page for BSXX if kort not in existing list.
            boolean isKortOrBox  = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isKortOrBox'));
              Integer numberOfYouseeKorts = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('numberOfYouseeKorts'));
              System.debug('BSXXXXX XXXXXXX isKortOrBox ['+isKortOrBox+'] numberOfYouseeKorts ['+numberOfYouseeKorts+']');
              if(!isKortOrBox){
                plusFlag = true;
          return addDtvHardwareSelectionPage();
        }
        else return nextFlow(); 
      }else
        return nextFlow();
        } 
    }    
   
    
    private String convertSetToJson(Set<String> prods){
        String prodsJson = '[]';
        if(prods.size()>0){
          prodsJson = '[';  
          for(String prod : prods){
             prodsJson+='"'+ prod + '",'; 
          }
          prodsJson= prodsJson.subString(0,prodsJson.length()-1)+']';
                    system.debug('prodsJson '+prodsJson);
          
        }
        return prodsJson;
    }
    
    public String getProductSelection(){
      system.debug('getproductselection page*******');
                return convertSetToJson(selectedIdSet);
    }
        
    public PageReference next(){
        PageReference pageRef = Page.CustomerInfoPage1;             
        return pageRef;
    }  
    
    public PageReference goToBroadbandProductsPage(){
        PageReference pageRef = Page.CustomerInfoPage1;             
        return pageRef;
    }
    
    public Boolean getIsNewCustomer(){
    system.debug('getisnewcustomer');
        boolean returnValue=false;
        if(secondPayee){
            if(payeeCustInstAdd!=null)
                if(payeeCustInstAdd.isNewCustomer!=null)
                    returnValue = payeeCustInstAdd.isNewCustomer;
            //return payeeCustInstAdd.isNewCustomer;
            //return (payeeCustomerPojo != null && payeeCustomerPojo.customerName.equals(DealerSalesConstant.NEW_CUSTOMER));
        }else{
            if(cCustInstAdd!=null)
                if(cCustInstAdd.isNewCustomer!=null)
                    returnValue=cCustInstAdd.isNewCustomer;
            //return cCustInstAdd.isNewCustomer;
            //return (dealerProdPojo != null && dealerProdPojo.customerName.equals(DealerSalesConstant.NEW_CUSTOMER));
        }
        system.debug('returnValue********'+returnValue);
        return returnValue;
    }
    
    public Boolean getSecondPayee() {
        return secondPayee;
    }
    
    public void setSecondPayee(Boolean secondPayee){
        this.secondPayee=secondPayee;
    } 
    Map<Decimal, string> approvalInformationMap = new Map<Decimal, string>(); 
    public string getApprovalInfo1() {
        if(approvalInformationMap.containsKey(1)){
            return approvalInformationMap.get(1);
        }
        else{
            return null;    
        }       
    }
    public string getApprovalInfo2() {
        if(approvalInformationMap.containsKey(2)){
            return approvalInformationMap.get(2);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfo15() {
        if(approvalInformationMap.containsKey(15)){
            return approvalInformationMap.get(15);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoForBSXX() {
        if(approvalInformationMap.containsKey(16)){
            return approvalInformationMap.get(16);
        }
        else{
            return null;    
        }       
    }
    
   /* public string getApprovalInfo3() {
        if(approvalInformationMap.containsKey(3)){
            return approvalInformationMap.get(3);
        }
        else{
            return null;    
        }       
    }*/
   
    public string getApprovalInfoForClearFlow2() {
        if(approvalInformationMap.containsKey(8)){
            return approvalInformationMap.get(8);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoForYouSeePlusOrFreechoice() {
        if(approvalInformationMap.containsKey(9)){
            return approvalInformationMap.get(9);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoForBBorTF() {
        if(approvalInformationMap.containsKey(13)){
            return approvalInformationMap.get(13);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoForBB() {
        if(approvalInformationMap.containsKey(11)){
            return approvalInformationMap.get(11);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoForTelefoni() {
        if(approvalInformationMap.containsKey(12)){
            return approvalInformationMap.get(12);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfo4() {
        if(approvalInformationMap.containsKey(4)){
            return approvalInformationMap.get(4);
        }
        else{
            return null;    
        }       
    }
    
    //added for YouBio flow 689
      public string getApprovalInfoForYouBio() {
        if(approvalInformationMap.containsKey(14)){
            return approvalInformationMap.get(14);
        }
        else{
            return null;    
        }       
    }
    
    public string getApprovalInfoIalt() {
        
        /* Please do not delete this commented code - Niraj
        
        
        if(clearFlag == true){
                if(approvalInformationMap.containsKey(4)){
                    return approvalInformationMap.get(4);
                }
                else{
                    return null;    
                }
        }
        else if( plusFlag==true  || ekstrakanalerFlag==true || broadbandTelephonyCommonFlag==true) {
                if(approvalInformationMap.containsKey(6)){
                    return approvalInformationMap.get(6);
                }
                else{
                    return null;    
                }
        }
        else if(telefoniFlag==true){
                if(approvalInformationMap.containsKey(7)){
                    return approvalInformationMap.get(7);
                }
                else{
                    return null;    
                }
        }   
        else
                return null;  */
        return 'Alle Abonnementer opkræves af YouSee. Systemet viser, om du evt. skal opkræve kunden pris på oprettelsen.';
              
    }
    
    public string getApprovalInfoForClear1() {
        if(approvalInformationMap.containsKey(5)){
            return approvalInformationMap.get(5);
        }
        else{
            return null;    
        }       
    }
    public boolean wantNewsLetter{get;set;}
    public boolean newsLetterUser{get;set;}
    public Account dealerAccount{get;set;}
    public commonClass obj{get;set;}
    public string salesAgentNumber{get;set;}
    public boolean ekomUser{get;set;}
    public boolean registerEkom{get;set;}
   /* public class Product{
        String productName;
        String productNumber;
        String href;
        String price;
        String productNode;
    }
    public class ProductForDisplay{
        public string businessArea{get;set;}
        public string productName{get;set;} 
        public string price{get;set;}   
    }
  */
    public String resetBBFlags{get;set;}
        public String resetSPFlags{get;set;}
        public string resetCLFlag{get;set;} //DW-855
    public String resetTlfFlags{get;set;} 
    
    public PageReference finalApproval(){           
        system.debug('mobile number: '+tlfNumberForNumberPorting);
      //  system.debug('landline number: ' +cCustInstAdd.contactNumber);
        system.debug('email address : ' +emailIdForNumberporting);          
                PageReference pageRef = Page.DealerProductApproval1;
        try{
                System.debug('secondPayee parameter->'+ApexPages.CurrentPage().getParameters().get('hdnSecondPayee'));
                
                // DW-689 : Fetching dibs transaction Id
                if(Apexpages.currentPage().getParameters().containsKey('dibsTransactionId') && 
                   Apexpages.currentPage().getParameters().get('dibsTransactionId') != '' &&
                   Apexpages.currentPage().getParameters().get('dibsTransactionId') != NULL){
                  dibsTransactionId = Apexpages.currentPage().getParameters().get('dibsTransactionId');
                }
                system.debug('##### dibsTransactionId   ' + dibsTransactionId);
                // DW-689 : Fetching dibs transaction Id
                
                if(ApexPages.CurrentPage().getParameters().get('hdnSecondPayee')=='true')
                    secondPayee=true;
                else
                    secondPayee=false;
                System.debug('secondPayee->'+secondPayee+'..payeeCustInstAdd->'+payeeCustInstAdd);
                if(secondPayee == true && payeeCustInstAdd==null){
                    payeeCustInstAdd = new cCustomerInstallationAddress();
                    pageRef = Page.DealerCustomerSearch1;
                    searchPostNrText = null;
                    searchStreetText = null;
                    searchHouseText = null;                    
                    cityName = null;
                    addresses = null;
                    custLst = new List<DealerCustomerPOJO>();
                    custLstActive = new List<DealerCustomerPOJO>();
                    custLstInactive = new List<DealerCustomerPOJO>();
                    showCustomerBlock=false;
                    showCustomerAddress=true;
                    System.debug('inside finalapproval');
                    
                }
                
                obj = new commonClass();
                System.debug('obj.dealerAccount->'+obj.dealerAccount);
                if(obj != null || obj.dealerAccount != null){
                    dealerAccount=obj.dealerAccount;
                    System.debug('dealer account->'+obj.dealerAccount);
                }                                                          
                for(SalesFlow_Informationer__c salesflowInformation :[Select Sequence_Number__c, Description__c From SalesFlow_Informationer__c where Page_Type__c='Approval Page']){
                   System.debug('salesflowInformation->'+salesflowInformation);
                    approvalInformationMap.put(salesflowInformation.Sequence_Number__c,salesflowInformation.Description__c);
                    system.debug('approvalInformationMap******'+approvalInformationMap.put(salesflowInformation.Sequence_Number__c,salesflowInformation.Description__c));
               }
               
               resetBbTlfFlagForSletOperation();
               
        }
        catch(Exception ex){
            throw ex;
        } 
        system.debug('from customerInfo -----JSON RESPONSE------------'+jsonResponse);
        return pageRef;      
    }
    
    public void resetBbTlfFlagForSletOperation(){
        
         // following section meant for hiding broadband and telephoni related function if customer cancel any subscription from customerInfoPage
           resetBBFlags = ApexPages.CurrentPage().getParameters().get('resetBBFlags');
           resetSPFlags= ApexPages.CurrentPage().getParameters().get('resetSPFlags');
           resetCLFlag = ApexPages.CurrentPage().getParameters().get('resetCLFlag');
           resetTlfFlags = ApexPages.CurrentPage().getParameters().get('resetTlfFlags');
           
           system.debug('resetBBFlags-------------------------------'+resetBBFlags);
           system.debug('resetSPFlags-------------------------------'+resetSPFlags);
           system.debug('resetTlfFlags------------------------------'+resetTlfFlags);
           if (resetBBFlags=='true'){
                system.debug('resetBBFlags----------------ITS VALID---------------'+resetBBFlags);
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,false,false,false,false);
                if (resetTlfFlags=='false'){
                    setBroadBandTelephonyFlagsForCustomerInfoPages(true,false,false,false,false,false,false,false,false,false);
                }
                if(resetSPFlags=='false')
                {
                  setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,true,false,false,false);
                }               
           }
           if (resetTlfFlags=='true'){
                system.debug('resetTlfFlags------------------------------'+resetTlfFlags);
                //setBroadBandTelephonyFlagsForCustomerInfoPages(boolean telefoniFlag,boolean onlyBroadbandFlag,boolean broadbandTelephonyCommonFlag,boolean TlfBroadbandFlag,boolean isFromBroadBand,boolean isFromTelephony);
                checkTLFFlag = false;
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,false,false,false,false);
                if (resetBBFlags=='false'){
                    system.debug('resetBBFlags----------------ITS VALID---------------'+resetBBFlags);
                    setBroadBandTelephonyFlagsForCustomerInfoPages(false,true,false,false,false,false,false,false,false,false);
                }
                
                if(resetSPFlags=='false')
                {
                  setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,true,false,false,false);
                }
                
           }
            if (resetSPFlags=='true'){
                system.debug('resetSPFlags------------------------------'+resetSPFlags);
                //setBroadBandTelephonyFlagsForCustomerInfoPages(boolean telefoniFlag,boolean onlyBroadbandFlag,boolean broadbandTelephonyCommonFlag,boolean TlfBroadbandFlag,boolean isFromBroadBand,boolean isFromTelephony);
                checkSPBBFlag = false;
                
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,false,false,false,false);
                if (resetBBFlags=='false'){
                    system.debug('resetBBFlags----------------ITS VALID---------------'+resetBBFlags);
                    setBroadBandTelephonyFlagsForCustomerInfoPages(false,true,false,false,false,false,false,false,false,false);
                }
                
                if(resetTLFFlags=='false')
                {
                  setBroadBandTelephonyFlagsForCustomerInfoPages(true,false,false,false,false,false,false,false,false,false);
                }
                // DW-855                
           }             
        
    }
  
    //Reading dynamic data
     public List<SalesFlow_Informationer__c> getInformation(){ 
       filteredInformationList = new List<SalesFlow_Informationer__c>();
       List<SalesFlow_Informationer__c> informationList = [Select info.Description__c, info.End_Date__c, info.Group_Information__c, 
                    info.Dealer__r.Name, info.SubGroup_Information__c From SalesFlow_Informationer__c info 
                    where info.Page_Type__c =: 'Product Selection Page' ];      
       integer days = 0;        
       Date todayDate;   
       
       for(SalesFlow_Informationer__c info : informationList) {    
           if(info.End_Date__c != null){             
                days = todayDate.daysBetween(info.End_Date__c);   
       }                     
       if((info.End_Date__c == null) ||  (info.End_Date__c != null && days > 0)) {  
               filteredInformationList.add(info);                 
           }   
           
        if(info.SubGroup_Information__c == 'YouSee Clear (kabel-tv)'){
                  clearTv = info.Description__c;                               
        }   //If end
        if(info.SubGroup_Information__c == 'YouSee Bredbånd'){
                bredband = info.Description__c; 
        }
        if(info.SubGroup_Information__c == 'YouSee Telefoni'){
                telefoni = info.Description__c; 
        }
       if(info.SubGroup_Information__c == 'YouSee Ekstrakanaler'){
                ekstrakanaler = info.Description__c; 
        }
        if(info.SubGroup_Information__c == 'YouSee plus'){
                plus = info.Description__c; 
        }
        }
        system.debug('filteredInformationList'+filteredInformationList);
                   
       return filteredInformationList;     
    } 
    
    // Telephoni flow. Following method returns all the available telephone numbers  
    
    public pageReference getAvailableTelephoneNumbers(){
            system.debug('NewNumber is-------------'+newNumber);
            system.debug('END_POINT is------------------'+END_POINT);
            telephoniFlag=true;
            string serviceUrl='';
            string application = '';
            
            if (newNumber!=null && newNumber!=''){
              newNumber = '4842' + '_' + newNumber + '_';
               // serviceUrl = '/afsaetning/findtelefonnummer/'+newNumber+'/100';
              serviceUrl = '/telefoni-v1/numre/ledige?nummer=' + newNumber + '&antal=100';
              application = 'telefoni-v1';
            } else {
                newNumber='4842' + '_1_';
                serviceUrl = '/telefoni-v1/numre/ledige?nummer=' + newNumber + '&antal=100';
                application = 'telefoni-v1';
            }
            String parseJSON = callout2(END_POINT+'/Kasia20', '','GET' , serviceUrl,'' ,application);
            system.debug('parseJSON--------------------------------'+parseJSON);
            if (parseJSON!=null){
                listOfJsonTelNum = getTelephoneNumbers(parseJSON);
            }
          
            return null;
                
    }
    
    // following method parse the list of available telephone numbers 

    
    public List<String> getTelephoneNumbers(String jSting){
        
        List<String> tempTelnumbers;
        List <String> DummyTel=new List<String>();
        telephoneNumberLst = new List<String>();
        
        if (jSting!=null && jSting!=''){
            tempTelnumbers=jSting.split(',');
        }
        String newStr;
        if (tempTelnumbers.size()>0){
            for (String telIterator:tempTelnumbers){
         // response changed for new telefoni service DW-699       
                //if (telIterator.contains('tlfnummer')) {
                if(telIterator.contains('nummer')){
                    DummyTel=telIterator.split(':');
                    if(DummyTel[1].contains('4842'))
                      telephoneNumberLst.add(DummyTel[1].substring(1,9));
                }
            }
            system.debug('inside if telIterator---#############-----'+telephoneNumberLst);
            return telephoneNumberLst;
        } else {
            telephoneNumberLst.add('');
            return telephoneNumberLst; 
        }
        
    }
    
    //following method display list of available telephone numbers on telephony page 
    
    public List<SelectOption> getSelectedTelephones(){
       List<SelectOption> options= new List<SelectOption>();    
       //options.add(new SelectOption('Intet nummer valgt','Intet nummer valgt'));
       options.add(new SelectOption('Intet nummer valgt','Intet nummer valgt'));
       if (telephoneNumberLst!=null){
           for(String item : telephoneNumberLst) {
                options.add(new SelectOption(item,item));
                System.debug('List Of Options in select List '+ options);
            }
       } 
       return options;
    }
    
    public pageReference displayNewPhoneNumber(){
            telFlag = true;
            //System.debug('** In DisplayNewPhoneNumber**');
            if(selectedNumber != null && selectedNumber.equals('Intet nummer valgt')){
                selectedNumber = '';
                telFlag = false;
            }
            else{
                telFlag = true;
            }
                return null;
            /*if(selectedNumber.contains('Intet nummer valgt')){
                selectedNumber = null;
                telFlag = false;
            }
            else
            {
                telFlag = true; 
                //System.debug('*Flag1*'+telefoniFlagForRendering);
            }
            
            
            return null;  */
           
    }
    
    public boolean isFromBroadBand {get;set;}
    public boolean isFromTelephony {get;set;}
    public String setCustomerInfoFlag {get;set;} 
    public boolean bbSunscriptionIsPresent {get;set;}
    
    
     public PageReference afterTelephonyProductSelection(){
        
                String isBroadbandSubscriptionNotAvailable = ApexPages.CurrentPage().getParameters().get('isBroadbandSubscriptionNotAvailable1');
                system.debug('isBroadbandSubscriptionNotAvailable----------------afterTelephonyProductSelection----'+isBroadbandSubscriptionNotAvailable);
                if (isBroadbandSubscriptionNotAvailable=='false'){
                    bbSunscriptionIsPresent=true;
                }
                if (isBroadbandSubscriptionNotAvailable=='true'){
                    bbSunscriptionIsPresent=false;
                }
        
                isFromBroadBand=false;
                isFromTelephony=true;
                telefoniFlag=true;
                onlyBroadbandFlag=false;
                //broadbandTelephonyCommonFlag=false;
                
                //addIntermediatePageToFlow(DealerSalesConstant.TelephoniProductId); 
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
        return nextFlow();
                
   }
   
    // Number porting 
    public String NPFutureDate {get;set;}
    public String NPCurrentDate {get;set;}
    
    public PageReference callOutNPAction(){
        system.debug('in callOutNPAction ******** ');
        selectedNumberForNP = ApexPages.CurrentPage().getParameters().get('npTffNumber');
        system.debug('Inside callOutNPAction function -------------------------------------->'+selectedNumberForNP);
        NPMergedstring = ApexPages.CurrentPage().getParameters().get('NPMergedstring');
        NPFutureDate = ApexPages.CurrentPage().getParameters().get('npFutureDate');
        NPCurrentDate = ApexPages.CurrentPage().getParameters().get('activationDateForTlfBB');
        
        system.debug('NPFutureDate----------------------------'+NPFutureDate);
        system.debug('NPCurrentDate-------------------------'+NPCurrentDate);
        
        List<String> NPMergeFieldsList = new List<String>();
        String NpProduct;
        String responseCode;
        String npHref;  
        if (NPMergedstring!=null && NPMergedstring!=''){
            NPMergeFieldsList = NPMergedstring.split('@@@',0);
            system.debug('NPMergeFieldsList.size()------------'+NPMergeFieldsList.size());
            kundeData = NPMergeFieldsList[0];
            arrayInit = NPMergeFieldsList[1];
            etag = NPMergeFieldsList[2];
            npHref=NPMergeFieldsList[3];
            system.debug('Kunde data========================='+kundeData);
            system.debug('arrayInit========================='+arrayInit);
            system.debug('etag========================='+etag);
            system.debug('npHref-------------------------------------?'+npHref);
        }
        if (npHref!=null && npHref!=''){
            NpProduct = npHref;      //.split('dk')[1];
            system.debug('NpProduct---------------------------------'+NpProduct);
            jsonResponse = CallToCasiaForNumberPorting(NpProduct,arrayInit,kundeData,etag);
            system.debug('product size()>1--Json response for NP -----'+jsonResponse);
            if (jsonResponse!=null && jsonResponse!=''){
                responseCode=jsonResponse.substring(0,3);
                system.debug('responseCode-----product size()>1----'+responseCode);
            }
        }
        if(responseCode=='200'){
                isFirstCallToKasia=false;
                jsonResponse=jsonResponse.substring(5,jsonResponse.length());
                system.debug('Updated JSON- for Number Porting----------------------'+jsonResponse);
                //jsonResponse=secondJSONResponse;
                system.debug('selectedNumberForNP-----------------############--------'+selectedNumberForNP);
                system.debug('Updated JSON- for Number Porting----------------Last------'+jsonResponse);
                return RedirectToCustomerInfoPage();
        } else {
        
             return null;
        }
                   
    }
    
    private String CallToCasiaForNumberPorting(String NpProduct,String arrayInit,String kundeData,String etag){
       // string dateForNumberPorting;
        system.debug('Inside Third call to casia--------------------------------------------------------------');
        if (NPFutureDate!=null && NPFutureDate!=''){
                dateForNumberPorting = NPFutureDate;
        } else if (NPCurrentDate!=null && NPCurrentDate!=''){
                dateForNumberPorting = NPCurrentDate;
        }
        // ***** DW-648 ***** //
        // ***** Modified 05/09/2012 ***** //
        if(dateForNumberPorting.contains('.'))
            dateForNumberPorting = dateForNumberPorting.replaceAll('\\.','-');
        if(dateForNumberPorting.contains('/'))
            dateForNumberPorting = dateForNumberPorting.replaceAll('/','-');    
        system.debug('dateForNumberPorting----------------CallToCasiaForNumberPorting------------------------------'+dateForNumberPorting);
        //String handlingInfo = '{"aarsag" : "2", "ignorer-binding" :  "false" ,"leverings-dato" : "'+dateForNumberPorting+'", "serienumre" : { "varenr1" : " ", "varenr2" : " " } }';
        String handlingInfo = '{"leverings-dato" : "'+dateForNumberPorting+'"}';
        String body = '{"kunde-data":'+kundeData+',"array-init":"'+arrayInit+'","handlings-info":'+handlingInfo+'}';
        //String body = '{"kunde-data":'+kundeData+',"array-init":"'+arrayInit+'"}';
        //String href= NpProduct;
        String response = callout2(END_POINT+'/Kasia20',body,'PUT', NpProduct,etag,'afsaetning');
       
        system.debug('dateForNumberPorting----------------after casia call------------------------------'+dateForNumberPorting);
        system.debug('--------JSON RESPONSE------------'+response);
        
        return response;                
    }
   
   // Ended telephoni functionality By Navneet
   
   /*************************************SERIAL NUMBER ENTRY PAGE**********************************************************************/ 
            
      /* Display the sections , based on the product selected */
       public PageReference getSearchSectionDisplayDetails()
       { 
                this.oldHardwareProduct = hardwareSelection;
                //error ='';
                system.debug('Error @@@@@@@@@@@@@@@@@@@@@@   '+error);
                system.debug('hardwareSelection------------ '+hardwareSelection);
                
                //hardwareSelection = '1201590';
                if(hardwareSelection == '1201601')//TwillingKort
                { 
                    SerialNoSection = false;
                    //Modified for DW-844
                    KortSection1 = false;            
                    KortSection2 = false;
                    tvKortSelected = true;
                    BilledelegitimationSection = false;
                    tvBoxSection = false;
                }
                if(hardwareSelection == '1201505')//YouSee Kort
                {
                    SerialNoSection = false;
                    KortSection1 = false;            
                    KortSection2 = true;
                    BilledelegitimationSection = false;
                    tvBoxSection = false;
                }
                if(hardwareSelection == '1201504') // yousee plus
                {
                    SerialNoSection = true;
                    KortSection1 = false;            
                    KortSection2 = true;
                    BilledelegitimationSection = true;
                    tvBoxSection = false;
                }
                if((hardwareSelection == '1203021') || (hardwareSelection == '1203020')) //   Leje af YouSee Boks/Leje of Hd boks // only hardware serial no
                {
                    SerialNoSection = true;
                    KortSection1 = false;           
                    KortSection2 = false;
                    BilledelegitimationSection = true;
                    tvBoxSection = false;
                }
                if(hardwareSelection == '1201590') // KortandserialNo // On demand
                {
                    SerialNoSection = false;
                    KortSection1 = true;            
                    KortSection2 = true;
                   BilledelegitimationSection = false;
                   tvBoxSection = false;
                }
                
                 if(hardwareSelection == '1218385') // //1218385 HD-standardboks uden harddisk uden YouSee Kort-1218385
                {
                    SerialNoSection = true;
                    KortSection1 = false;            
                    KortSection2 = false;
                   BilledelegitimationSection = false;
                   tvBoxSection = false;
                } 
                if(hardwareSelection == '1201507' || hardwareSelection == '1201508' || hardwareSelection == '1201509') // //1201507 TV-Boksboks
                {
                    tvBoxSection = true;
                    SerialNoSection = false;
                    KortSection1 = false;            
                    KortSection2 = false;
                   BilledelegitimationSection = false;
                }
                if(hardwareSelection == 'HDstandardboksWithCard')//HDstandardboksWithCard
                { 
                    SerialNoSection = true;
                    KortSection1 = false;            
                    KortSection2 = true;
                    BilledelegitimationSection = false;
                }
                initializeText();
                return null;    
       }
       
      public void DeleteBasketProduct(string delProduct)
       {
            System.debug('**delProduct->'+delProduct+'..keysets->'+ProductSerialNumbersMap.keyset());
            Map<string,List<string>> tempMap = new Map<string,List<string>>();
            for(string key : ProductSerialNumbersMap.keyset())
             tempMap.put(key,ProductSerialNumbersMap.get(key));
            for(string key : tempMap.keyset()){
                // Delete a Tvillingkort
                System.debug('delProduct->'+key.indexOf('delProduct'));
               System.debug('key->'+key);
                System.debug('Inside for loop TV-->'+key.indexOf('Tvillingkort'));
                System.debug('Inside for loop delpr-->'+key.indexOf('YouSee Kort'));
                //if(key.indexOf('Tvillingkort') != -1 && delProduct.indexOf('Tvillingkort') != -1){ //equalsIgnoreCase('Tvillingkort')
                 if((key.indexOf('Tvillingkort') != -1 && delProduct.indexOf('Tvillingkort') != -1) ||(key.indexOf('Ekstrakort') != -1 && delProduct.indexOf('Ekstrakort') != -1)){ //equalsIgnoreCase('Tvillingkort')
                    // Delete an additional tvillingkort
                   system.debug('inside tv kort if.......');
                    
                    if(displayTVkort)
                    {
                        system.debug('In display TV kort if');
                        //DW-844 modifications START
                        if(tempMap.get(key).size()==4)
                        {
                            TVKortNo4 = '';
                            AdditionalTVKortNumber4Validated = false;
                        }
                        else if(tempMap.get(key).size()==3)
                        {
                            TVKortNo3 = '';
                            AdditionalTVKortNumber3Validated = false;
                        }
                        else if(tempMap.get(key).size()==2)
                        {
                          TVKortNo2 = '';
                            AdditionalTVKortNumber2Validated = false;
                        }
                        else
                        {
                            TVKortNo1 = '';
                            AdditionalTVKortNumber1Validated = false;
                        }
                        //DW-844 modifications END
                    }
                    
                    // Delete a Tvillingkort (not additional)
                    else
                    {
                        System.debug('inside else .......');
                        if(tempMap.get(key).size()>1)
                        {
                            //Commented for DW-844
                            //KortNo2 = '';
                            //KortNumber2Validated = false;
                            if(tempMap.get(key).size()==4)
                            {
                                TVKortNo4 = '';
                                AdditionalTVKortNumber4Validated = false;
                            }
                            else if(tempMap.get(key).size()==3)
                            {
                                TVKortNo3 = '';
                                AdditionalTVKortNumber3Validated = false;
                            }
                            else if(tempMap.get(key).size()==2)
                            {
                                TVKortNo2 = '';
                                AdditionalTVKortNumber2Validated = false;
                            }
                        }
                        else
                        { system.debug('In else ');
                            if(ExistingTvkort)
                            {system.debug('In existingkort');
                                KortNo2 = '';
                                KortNumber2Validated = false;
                                EnableNextButton = false;
                            }
                            else
                            {
                                system.debug('In delete all');
                                //Commented for DW-844
                                TVKortNo4 = '';
                                AdditionalTVKortNumber4Validated = false;
                                TVKortNo3 = '';
                                AdditionalTVKortNumber3Validated = false;
                                TVKortNo2 = '';
                                AdditionalTVKortNumber2Validated = false;
                                TVKortNo1 = '';
                                AdditionalTVKortNumber1Validated = false;
                                /*KortNo1 = '';
                                KortNumber1Validated = false;
                                KortNo2 = '';
                                KortNumber2Validated = false;*/
                                
                                enableTvlkortFlag = false;
                                displayTVkort = false;
                                EnableNextButton = false;
                            }
                        }
                    }
                    
                    // common for map clearing logic
                  {
                        System.debug('****');
                        if(tempMap.get(key).size()>1){
                        System.debug('if key--->'+key);
                        //Modified for DW-844
                         ProductSerialNumbersMap.get(key).remove(tempMap.get(key).size()-1);
                        }else{
                            System.debug('elsekey--->'+key);
                         ProductSerialNumbersMap.remove(key);
                        }
                   }
                }                
                // Delete a non-Tvillingkort
               // else if(key.contains(delProduct)){
               else if(key.indexOf(delProduct) != -1){
              // else{  
                     System.debug('tvKortSelected **->'+tvKortSelected);
                    System.debug('key inside else **->'+key);
                    ProductSerialNumbersMap.remove(key); // common for map clearing logic
                    enableTvlkortFlag = false;
                    displayTVkort = false;
                    System.debug('delProduct->'+delProduct);
                    //if(delProduct.equalsIgnoreCase('YouSee Kort')) 
                     if(delProduct.indexOf('YouSee Kort') != -1)
                    {
                        System.debug('inside kort');
                         KortNo2 = '';
                         EnableNextButton = false;
                         KortNumber2Validated = false;
                    }
                    
                    //if(delProduct=='YouSee Plus')
                    //if(delProduct.equalsIgnoreCase('YouSee Plus'))
                    if(delProduct.indexOf('YouSee Plus') != -1)
                    {
                        system.debug('insisde yousee plus if....');
                         KortNo2 = '';
                         SerialNo = '';
                         KortNumber2Validated = false;
                         EnableNextButton = false;
                         serialNumbervalidated = false;
                         SelectedIDRadioValue = '';
                    }
                    
                   // if(delProduct.equalsIgnoreCase('DEMO HD-Standardboks') || delProduct.equalsIgnoreCase('Leje af YouSee Boks') || delProduct.equalsIgnoreCase('Leje af HD Boks'))
                     if((delProduct.indexOf('DEMO HD-Standardboks') != -1) || (delProduct.indexOf('Leje af YouSee Boks') != -1) || (delProduct.indexOf('Leje af HD Boks') != -1))
                    {
                        System.debug('del product hdstandard');
                        SerialNo = '';
                        EnableNextButton = false;
                        serialNumbervalidated = false;
                        SelectedIDRadioValue = ''; 
                    }
                    
                    
                    //if(delProduct.equalsIgnoreCase('HD-standardboks uden harddisk med YouSee Kort'))
                    if(delProduct.indexOf('HD-standardboks uden harddisk med YouSee Kort') != -1)
                    {
                        System.debug('inside delproduct');
                        KortNo2 = '';
                        KortNumber2Validated = false;
                        EnableNextButton = false;
                        SerialNo = '';
                        serialNumbervalidated = false;
                    }
                     System.debug('tvKortSelected **->'+tvKortSelected);
                }
            }

       } 
               

           // once back is clicked on the serial number page , reset all the flags and fields
           public void ResetSerialPageValues(){               
                this.error = '';
                this.SerialNo = '';
                this.KortNo1 = '';
                this.KortNo2 = '';
                this.TVKortNo1 = '';
                this.TVKortNo2 = '';
                this.serialNumbervalidated = false;
                this.KortNumber1Validated = false;
                this.KortNumber2Validated = false;      
                this.AdditionalTvKort = false;
                this.AdditionalTVKortNumber1Validated = false;
                this.AdditionalTVKortNumber2Validated = false;
                this.Approved = false;
                this.ExistingTvkort = false;
                this.AdditionalTvKort = false; 
                this.displayTVkort = false;
                this.KortNumber1Validated = false;
                this.KortNumber2Validated = false;
                this.serialNumbervalidated = false;
                TvBox ='';
               tvBoxSection = false;
                serialNumberTVBoxvalidated =false;
                EnableNextButton = false;
                enableTvlkortFlag = false;
                //ProductSerialNumbersMap.clear();                
                //productSRNumberList.clear();
                KortNr = '';
                SelectedIDRadioValue = '';
                //DW-844 modifications START
                this.TVKortNo3 = '';
                this.TVKortNo4 = '';
                this.AdditionalTVKortNumber3Validated = false;
                this.AdditionalTVKortNumber4Validated = false;
                //DW-844 modifications END
           }

       /*This is the entry point  - once the validate button is clicked, this method and calle and basd ont eh parameters , it decides which validation to call */
       public PageReference NumberValidate(){
               error='';
               system.debug('callMethod              '+callMethod);
               system.debug('bundleProductValue ********************   '+bundleProductValue); 
              
             /*  if(bundleProductValue !='' || bundleProductValue.length()>0)
               {
                    YouSeePlusBundleList = bundleProductValue.split(',');   
               }*/
               
                try{
                    if(callMethod == 'Kort1Validate')
                    { 
                             KortNumber1Validate();
                    } 
                    if(callMethod == 'TvBoxSerialNumberValidate'){
                        TvBoxValidate();
                    }
                    if(callMethod == 'Kort2Validate')
                    {
                            KortNumber2Validate();
                    }
                    if(callMethod == 'SerialNumberValidate')
                    {
                        System.debug('inside callMethod SerialNumberValidate');
                            SerialNumberValidate();
                    }
                    if(callMethod == 'AdditionalKortNumber1Validate')
                    {
                            AdditionalTvKort = true;
                            AdditionalKortNumber1Validate();
                    }
                    if(callMethod == 'AdditionalKortNumber2Validate')
                    {
                            AdditionalTvKort = true;
                            AdditionalKortNumber2Validate();
                    }
                    //DW-844 modification START
                    if(callMethod == 'AdditionalKortNumber3Validate')
                    {
                            AdditionalTvKort = true;
                            AdditionalKortNumber3Validate();
                    }
                    if(callMethod == 'AdditionalKortNumber4Validate')
                    {
                            AdditionalTvKort = true;
                            AdditionalKortNumber4Validate();
                    }
                    //DW-844 modification END
                }
                catch(Exception e)
                {
                    System.debug(e.getMessage()+'$$$$$');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
                }
                return null;
     }
     //DW-880 TV Box Validation
     public void TvBoxValidate(){
         
         Approved= false;
         if(this.TvBox.length() == 30)
         {
             Approved = true;
             
             //ValidateAllBooleans();
             //if(!Approved){
             //           this.KortNumber1Validated = false;
             //            EnableNextButton = false;                
              //  }
             //   else
            //    {
                        //this.KortNumber1Validated = true;
                        if(url !='')
                        {     
                            system.debug('TvBox *** '+TvBox+' TvBox.length() '+TvBox.length()+' url '+url);
                                isSerailNoProduct = true;
                                callToKasia(); 
                        }
            else if(url =='')//EDM-756
             {  
                 system.debug('tvBoksURL ********* '+tvBoksURL);
                 url=tvBoksURL;
                 //url = 'http://kasia.yousee.dk/afsaetning/serienr/dummy-1/1201507';
                 //url='http://preprod-kasia.yousee.dk/afsaetning/opret/1101601';
                 isSerailNoProduct = true;
                 callToKasia(); 
             }
                        if(isKasiaCallSuccess)
                        {
                                this.serialNumberTVBoxvalidated = true;
                                ValidateAllBooleans();
                        }
             //   }  
         }
     }
          /* KORT 1 Validation*/
       public void KortNumber1Validate()
       {
                Approved= false;
                //KortNumbervalidate(this.KortNo1.trim());
            /** Added for DW-880 instead of below code**/
                Approved = true;
                //this.KortNumber1Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
             /*   String Res =  callApprovalws(this.KortNo1.trim());
                if(Res != '' || Res.length()>0)
                {
                    ParseApprovalResponse(Res);
                } */            
                if(!Approved){
                        this.KortNumber1Validated = false;
                         EnableNextButton = false;                
                }
                else
                {
                        //this.KortNumber1Validated = true;
                        if(url !='')
                        {                                   
                                isSerailNoProduct = true;
                                callToKasia(); 
                        }
                        if(isKasiaCallSuccess)
                        {
                                this.KortNumber1Validated = true;
                                ValidateAllBooleans();
                        }
                }      
                
      }
        
       /* KORT 2 Validation */
       public void KortNumber2Validate(){        
           /** Added for DW-880 instead of below code**/
                Approved = true;
                //this.KortNumber2Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/            
        /* Approved= false;
            String Res =  callApprovalws(this.KortNo2.trim());
            ParseApprovalResponse(Res);*/
            if(!Approved){
               this.KortNumber2Validated = false;  
                EnableNextButton = false;                     
            }else{
                dummySerialNo = this.KortNo2.trim();
                if(url !=''){
                  // if you plus product then check serial number is validated or not, if not then throw error . In case of yousee Plus 
                  // we call kasai method only once.
                  //if(hardwareSelection == '1201504' || hardwareSelection == 'HDstandardboksWithCard') // yousee Plus or HDstandardboksWithCard
                  if(hardwareSelection == '1201504'){ // yousee Plus or HDstandardboksWithCard
                    if(serialNumbervalidated == true){
                       isSerailNoProduct = true;
                       callToKasia();
                    }
                    this.KortNumber2Validated = true;
                    ValidateAllBooleans(); 
                    /*else (Not commented by Shefali)
                    {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Validate Serial Number'));
                    }*/
                 }else{
                        // for any other product directly call kasia.
                        isSerailNoProduct = true;
                        callToKasia();
                 }
              }
              if(isKasiaCallSuccess){
                 this.KortNumber2Validated = true;
                 ValidateAllBooleans(); 
              }
            }       
      }
     
        /* additional tv KORT 1 Validation - Additional Tvilling kort checkbox of tvilling kort*/
       public void AdditionalKortNumber1Validate(){  
            /** Added for DW-880 instead of below code**/
                Approved = true;
                //this.AdditionalTVKortNumber1Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
          /*  Approved= false;
            // KortNumbervalidate(this.TVKortNo1.trim());
            String Res =  callApprovalws(TVKortNo1.trim());
            ParseApprovalResponse(Res);*/
            if(!Approved){
                    this.AdditionalTVKortNumber1Validated = false;  
                     EnableNextButton = false;          
             }else{                                                      
                if(url !=''){
                    isSerailNoProduct = true;
                    callToKasia(); 
                }
                if(isKasiaCallSuccess){
                        this.AdditionalTVKortNumber1Validated = true;
                        ValidateAllBooleans();
                }
             }  
             system.debug('added for dw-844 EnableNextButton ' +EnableNextButton);    
      }
      
      /* additional tv KORT 2 Validation */
       public void AdditionalKortNumber2Validate(){     
            /** Added for DW-880 instead of below code**/
                Approved = true;
                //this.AdditionalTVKortNumber2Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
                
         /*   Approved= false;
            // KortNumbervalidate(this.TVKortNo2.trim());
            String Res =  callApprovalws(TVKortNo2.trim());
            ParseApprovalResponse(Res);*/
            if(!Approved){
                this.AdditionalTVKortNumber2Validated = false;
                 EnableNextButton = false;                   
             }else{
                if(url !=''){
                    isSerailNoProduct = true;
                    callToKasia(); 
                }
                if(isKasiaCallSuccess){
                    this.AdditionalTVKortNumber2Validated = true;
                    ValidateAllBooleans();
                }
             }
      }
        
       //DW-844 modification START
       /* additional tv KORT 3 Validation */
       public void AdditionalKortNumber3Validate(){   
            /** Added for DW-880 instead of below code**/
                Approved = true;
               // this.AdditionalTVKortNumber3Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
          /*  Approved= false;
            String Res =  callApprovalws(TVKortNo3.trim());
            ParseApprovalResponse(Res);*/
            if(!Approved){
                this.AdditionalTVKortNumber3Validated = false;
                 EnableNextButton = false;                   
             }else{
                if(url !=''){
                    isSerailNoProduct = true;
                    callToKasia(); 
                }
                if(isKasiaCallSuccess){
                    this.AdditionalTVKortNumber3Validated = true;
                    ValidateAllBooleans();
                }
             } 
      }
      
      /* additional tv KORT 4 Validation */
       public void AdditionalKortNumber4Validate(){ 
            /** Added for DW-880 instead of below code**/
                Approved = true;
               // this.AdditionalTVKortNumber4Validated = true;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
                
           /* Approved= false;
            // KortNumbervalidate(this.TVKortNo2.trim());
            String Res =  callApprovalws(TVKortNo4.trim());
            ParseApprovalResponse(Res);*/
            if(!Approved){
                this.AdditionalTVKortNumber4Validated = false;
                 EnableNextButton = false;                   
             }else{
                if(url !=''){
                    isSerailNoProduct = true;
                    callToKasia(); 
                }
                if(isKasiaCallSuccess){
                    this.AdditionalTVKortNumber4Validated = true;
                    ValidateAllBooleans();
                }
             } 
      }
      
      //DW-844 modification END
      
        /* Serial Number Validation*/   
           public void SerialNumberValidate(){
               /** Added for DW-880 instead of below code**/
                Approved = true;
               // this.serialNumbervalidated = false;
                //ValidateAllBooleans();
                /**** commented for DW-880 #Shefali ***/
                
               SerialNovar = this.SerialNo.trim();
               //dummySerialNo = this.SerialNo.trim();
               //system.debug('===>'+dummySerialNo);
              // Approved= false;// Commented for DW-880
              //        SerialNovalidate();
               /*String Res =   callApprovalws(SerialNovar); // Commented for DW-880
               System.debug('Res->'+Res);// Commented for DW-880
               ParseApprovalResponse(Res);// Commented for DW-880
*/
               if(!Approved){
                System.debug('approved value->'+Approved+'..and Hardware selection value->'+hardwareSelection);
                        this.serialNumbervalidated = false;
                        EnableNextButton = false; 
                           //ValidateAllBooleans();   
               }
               else
               {        
                        //this.serialNumbervalidated = true;
                        system.debug('URL..................  '+url);
                        if(url !='')
                        {
                               // if(hardwareSelection == '1201504' || hardwareSelection == 'HDstandardboksWithCard')// if you plus product then check serial number is validated or not . 
                                      if(hardwareSelection == '1201504')// if you plus product then check serial number is validated or not .
                                        {
                                            if(KortNumber2Validated == true)
                                            {   
                                                    isSerailNoProduct = true;
                                                    callToKasia();
                                            }
                                            this.serialNumbervalidated = true;
                                            ValidateAllBooleans(); 
                                            /*      else
                                            {
                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Validate Serial Number'));
                                            }*/
                                        }
                                        else
                                        {
                                          //  for any other product directly call kasia. 
                                          isSerailNoProduct = true; 
                                          callToKasia();       
                                        }                           
                        }
                        if(isKasiaCallSuccess)
                        {
                            System.debug('inside isKasiaCallSuccess chk');
                        
                                this.serialNumbervalidated = true;
                                        ValidateAllBooleans();
                        }             
              } 
           }
     
         public string ApprovalResponse; // decalred outside of method because of the testmethod.
           /* Call Approval ws*/
           private string callApprovalws(string SerialNumber)
           {
                //string ApprovalResponse;
                //string body = 'GET /logistik/hardware/'+SerialNumber+'   !#$ !#$';              
             
                string Appurl = '/logistik/hardware/'+SerialNumber;
            //string methodType = 'GET';
            testMode = FORCE_TEST_MODE;                           
            if(!(testMode)){
                ApprovalResponse='';
                //Interface_EndPoint__c IendPoint = Interface_EndPoint__c.getValues('CI PreProd EndPoint');                
                //String endpoint = IendPoint.EndPoint__c;
                String endpoint=END_POINT;
                try{
                ApprovalResponse = callout2(END_POINT+'/Kasia20','', 'GET', Appurl, '','logistik');
                }catch(exception e)
                {
                    throw e;
                }
                //ApprovalResponse = callout(endpoint, body);                        
                //response =      HttpRequestResponse.makeHttpCall(body, methodType,ENDPOINT);              
            }
            return ApprovalResponse;
           }
  
 
           /* Parse Approval Response */
           private void ParseApprovalResponse(string Appres)
           {
            try{
                    if(Appres != null &&  Appres != '' && Appres.length() > 0 )
                    {                                                              
                        JSONObject j = new JSONObject( Appres );                                                                                             
                        if(j.has('logistik'))                    
                        {
                            JSONObject.value vs =  j.getValue('logistik');
                            if(j.getValue('responsecode').str != '200'){                                            
                                Approved= false; 
                                if(vs.obj.has('error') )
                                {                                                                                                                                                                                                                                             
                                    error = j.getValue('logistik').obj.getValue('error').str;                            
                                }
                                else
                                {
                                    error = j.getValue('logistik').str;
                                }
                    
                            }
                            else{                    
                                //string DealerNumber =  j.getString('lokation'); 
                                string DealerNumber =  j.getValue('logistik').obj.getValue('lokation').str;                                           
                                string status =   j.getValue('logistik').obj.getValue('status').str;                              
                                // Dealer number hardcoding needs to be removed
                                //System.debug('******   '+DealerNumber);
                                System.debug('loggedInDealerId->'+loggedInDealerId);
                                
                                String userLoggedIn = objCommon.dealerAccount.Dealer_Number__c;
                                
                              /**  if (objCommon.dealerAccount.Dealer_Number__c!= null && objCommon.dealerAccount.Dealer_Number__c!=''){
                                    userLoggedIn = objCommon.dealerAccount.Dealer_Number__c;
                                 } else {
                                    userLoggedIn='T7006';
                                } */
                                if(userLoggedIn == DealerNumber)
                                {
                                // DealerWeb Issue 383 - status = UNDER_OMBYTNING, should not be valid one instead give message to dealer to return the box.    
                                 if(status.equalsIgnoreCase('disponibel')) // added as per the defect Dealerweb-272
                                 {                              
                                    boolean AddTvKortflag = false;
                                    
                                    if((CallMethod == 'AdditionalKortNumber2Validate') || (CallMethod == 'AdditionalKortNumber1Validate') || (CallMethod == 'AdditionalKortNumber3Validate') || (CallMethod == 'AdditionalKortNumber4Validate'))
                                    {
                                        AddTvKortflag =  true;
                                    }
                                
                                    // purpose of adding AddTvKortflag condition is  - if additional tvilling kort condition is called that time hardware selection fron DTV Hardware selection page is yousee plus
                                    // in that case contion is written in such a way so that it should not enter into this block.
                                    if((hardwareSelection == '1201504') && (!AddTvKortflag))                                
                                    {                         
                                      // system.debug('YouSeePlusBundleList[0] *****  '+YouSeePlusBundleList[0]);
                                        //if((j.getValue('logistik').obj.getValue('varenummer').str == '1201505') || (j.getValue('logistik').obj.getValue('varenummer').str == '1203021'))
                                        system.debug('****** Bundle product '+bundleProductValue);
                                        if((j.getValue('logistik').obj.getValue('varenummer').str == '1201505') || (j.getValue('logistik').obj.getValue('varenummer').str == bundleProductValue))
                                        {
                                                Approved = true;
                                                System.debug('approved--1201505'); 
                                        }
                                        else
                                        {
                                                Approved = false;
                                            error= 'Serienummeret svarer ikke til YouSee Plus. ';
                                        }
                                    }
                                    else if((hardwareSelection == 'HDstandardboksWithCard') && (!AddTvKortflag))
                                    {
                                        if((j.getValue('logistik').obj.getValue('varenummer').str == '1218385') || (j.getValue('logistik').obj.getValue('varenummer').str == '1201505'))
                                        {
                                                Approved = true;
                                        }
                                        else
                                        {
                                                Approved = false;
                                            error= 'Serienummeret svarer ikke til HD-standardboks med YouSee Kort. ';
                                        }
                                    }                              
                                    //else if(this.AdditionalTvKort)
                                    else if(this.displayTVkort)
                                    {
                                        if((j.getValue('logistik').obj.getValue('varenummer').str == '1201601')) // Additional tvilling kort
                                        {
                                                Approved = true;
                                        }
                                        else
                                        {
                                                Approved = false;
                                            error= 'Serienummeret svarer ikke til Ekstrakort. ';
                                        }
                                    }
                                    else
                                    {                                       
                                        if(j.getValue('logistik').obj.getValue('varenummer').str == hardwareSelection)
                                        {
                                                Approved = true;
                                        }
                                        else
                                        {
                                                Approved = false;
                                            //error= 'Serienummer does not match ';
                                            error = 'Serienummer stemmer ikke overens med korttype'; 
                                        }
                                    }
                                 }
                                 else
                                 {
                                    Approved = false;
                                    //error= 'Kan ikke bruge serienummeret for et hardware med '+ status +' status';
                                    if(status.equalsIgnoreCase('UNDER_OMBYTNING')){
                                        error = 'Boksen kan ikke sælges, da den er under ombytning. Boksen skal returneres til YouSee.';
                                    }else {
                                        error =  'Kan ikke bytte hardware med status '+ status +'. Husk at varemodtage'; // as per defect dealerweb - 285. 
                                    }
                                 }
                                } 
                                else
                                {
                                    Approved = false;
                                    //error= 'Serienummer stemmer ikke overens med YouSee’s informationer oom lagertilstand. Har du husket at væremodtage dine varer fra YouSee?';
                                     error = 'Serienummer er ikke disponibelt'; // dealerweb defect 286
        
                                }
                            }
                        }                      
                
                
                    }
               }
                Catch(Exception e)
                {
                        error = e.getMessage();
                }
           }
  
          
          /*Next from the serial number Page*/
       public PageReference NextFromSerialNumberPage()
       {
       boolean flag = true;
             system.debug('this is NextFromSerialNumberPage *isBlandSelvFlow value is ****************'+isBlandSelvFlow);
             string err = 'Please Validate Serial number';                                      
             //if((hardwareSelection == '1218385') || (hardwareSelection == '1201601') || (hardwareSelection == '1203021') || (hardwareSelection == '1203020')) //tvillingkort/Hdboks without card /Leje of yousee boks- redirect it to Customer info page
             if((hardwareSelection == '1218385') || (hardwareSelection == '1201601') ||  (hardwareSelection == '1203020')) //tvillingkort/Hdboks without card /Leje of yousee boks- redirect it to Customer info page  
                 {
                    if(EnableNextButton){
                        return nextFlow();
                    }else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,err));
                            return null;
                    }                        
                 }
               /*DW-880 TV Box*/if((hardwareSelection == '1201507') || (hardwareSelection == '1201508') ||  (hardwareSelection == '1201509')) //TV boks- redirect it to Customer info page  
                 {
                    if(EnableNextButton){
                        return nextFlow();
                    }else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,err));
                            return null;
                    }                        
                 }
                if((hardwareSelection == '1201505') || (hardwareSelection == 'HDstandardboksWithCard') || (hardwareSelection == '1203021') || (hardwareSelection == '1201504')){     
                //if((hardwareSelection == '1201505') || (hardwareSelection == 'HDstandardboksWithCard') || (hardwareSelection == '1201504')){
                        if(EnableNextButton){
                            system.debug('this is EnableNextButton ****************isBlandSelvFlow----'+isBlandSelvFlow+'***ekstrakanalerFlag********'+ekstrakanalerFlag+'plusFlag ******'+plusFlag+'-broadbandTelephonyCommonFlag---'+broadbandTelephonyCommonFlag+'--telefoniFlag---'+telefoniFlag);
                            //Redirect to customerinfo page if it is a Bland Selv product Flow.
                            //if(isBlandSelvFlow){
                            //if(isBlandSelvFlow && (ekstrakanalerFlag==false && plusFlag==false)){
                            if(((isBlandSelvFlow && ekstrakanalerFlag==false) && plusFlag==false) && (broadbandTelephonyCommonFlag == false && telefoniFlag == false)){
                                 addIntermediatePageToFlow(DealerSalesConstant.CustomerInfoPage);
                            } 
                            else if(plusFlag==false && ekstrakanalerFlag==true){
                                addIntermediatePageToFlow(DealerSalesConstant.fcChannelSelId);
                            }else if(plusFlag==true && ekstrakanalerFlag==true){
                                 addIntermediatePageToFlow(DealerSalesConstant.dtvChannelSelId);
                            }else if(telefoniFlag && broadbandTelephonyCommonFlag){
                                addIntermediatePageToFlow(DealerSalesConstant.broadbandId);
                            }else if(broadbandTelephonyCommonFlag){
                                addIntermediatePageToFlow(DealerSalesConstant.broadbandId);
                            }else if(telefoniFlag){
                                addIntermediatePageToFlow(DealerSalesConstant.telephonyId);
                            }else{                             
                               
                            }
                            return nextFlow();
                        }else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,err));
                                return null;
                        }                                
                 
                   }
                   System.debug('plusFlag $$$$: '+plusFlag + 'ekstrakanalerFlag $$$$: '+ ekstrakanalerFlag);
                   return null;
       } 
       
    public String createHandlingInfo(){
            String handling_info = '"handlings-info" : { "serienumre" : {';
            if(hardwareSelection == '1201601'){      // tvilling kort
                if(ExistingTvkort){                      
                    handling_info += '"'+hardwareSelection+'" : "'+ KortNo2+'"';
                }else{                             
                    if(Approved){//KortNumber2Validated || KortNumber1Validated
                       //Commenting the code section below and adding new section for DW-844
                       /*if(callMethod == 'Kort1Validate'){
                            handling_info += '"'+hardwareSelection+'" : "'+ KortNo1+'"';
                       }
                       if(callMethod == 'Kort2Validate' ){
                            handling_info += '"'+hardwareSelection+'" : "'+ KortNo2+'"';
                       } */
                       //DW-844 modification START
                        if(callMethod == 'AdditionalKortNumber1Validate'){
                            handling_info += '"'+1201601+'" : "'+ TVKortNo1+'"';
                            system.debug('inside if handling_info.......'+handling_info);  
                        }
                        if(callMethod == 'AdditionalKortNumber2Validate'){
                            handling_info += '"'+1201601+'" : "'+ TVKortNo2+'"';  
                        }
                        if(callMethod == 'AdditionalKortNumber3Validate'){
                            handling_info += '"'+1201601+'" : "'+ TVKortNo3+'"';
                            system.debug('inside if handling_info.......'+handling_info);  
                        }
                        if(callMethod == 'AdditionalKortNumber4Validate'){
                            handling_info += '"'+1201601+'" : "'+ TVKortNo4+'"';  
                        }
                        //DW-844 modification END                             
                    }  
                }
            }else if(hardwareSelection == '1201504' && ((callMethod =='SerialNumberValidate' || callMethod =='Kort2Validate'))){  // YouSee plus
                   system.debug('inside yousee plus');
                    handling_info += '"'+bundleProductValue+'" : "'+ SerialNovar+'",';  // for serial number
                    handling_info += '"'+1201505+'" : "'+ KortNo2+'"';   // for box
            }else if(hardwareSelection == 'HDstandardboksWithCard' && ((callMethod =='SerialNumberValidate' || callMethod =='Kort2Validate'))){ //HDstandardboksWithCard
                    if(Approved){//KortNumber2Validated || serialNumbervalidated
                        if(callMethod == 'SerialNumberValidate' ){
                            handling_info += '"'+1218385+'" : "'+ SerialNovar+'",';  // for kort
                        }
                        if(callMethod == 'Kort2Validate'){
                            handling_info += '"'+1201505+'" : "'+ KortNo2+'"';   // for box
                        }
                   }                                                
            }else if(hardwareSelection == '1201505' && callMethod == 'Kort2Validate'){   // YouSee Kort
                   handling_info += '"'+hardwareSelection+'" : "'+ KortNo2+'"';  // for kort
            }else if((hardwareSelection == '1203021') ||(hardwareSelection == '1203020')){ // Leje of yousee Boks/Leje of HD Boks
                   handling_info += '"'+hardwareSelection+'" : "'+ SerialNovar+'"';  // for box
            }else if(hardwareSelection == '1218385' && callMethod =='SerialNumberValidate'){   // HDBOKS witout card
                   handling_info += '"'+hardwareSelection+'" : "'+ SerialNovar+'"';  // for box
            }//DW-880
            else if((hardwareSelection == '1101601' || hardwareSelection == '1101701' ||hardwareSelection == '1101801' || hardwareSelection == '1201507' || hardwareSelection == '1201508' || hardwareSelection == '1201509') && callMethod =='TvBoxSerialNumberValidate')
            {
               handling_info ='"handlings-info" : { "serienumre" : "'+ TvBox+'",';//
                system.debug('@@@@@@@handlinginfo'+handling_info);
               // handling_info+='"serienummertype": "single",';
                handling_info += '"'+hardwareSelection+'" : "'+ TvBox+'"'; //EDM-756 Commented
                /*handling_info ='"handlings-info" : { "serienumre" : "'+ TvBox+'"';
                handling_info+=',"varenr":"'+hardwareSelection+'"';*/
                handling_info+='}';//EDM-756
            } //End DW-880
            if(displayTVkort){ // for additional tvilling kort
            system.debug('displayTVkort... '+displayTVkort);
            system.debug('AdditionalKortNumber1Validate ==== '+callMethod);
             system.debug('TVKortNo1 ==== '+TVKortNo1);
                   if(Approved){//AdditionalTVKortNumber1Validated || AdditionalTVKortNumber2Validated
                        if(callMethod == 'AdditionalKortNumber1Validate')
                        {
                            handling_info += '"'+1201601+'" : "'+ TVKortNo1+'"';
                            system.debug('inside if handling_info.......'+handling_info);  
                        }
                        if(callMethod == 'AdditionalKortNumber2Validate')
                        {
                            handling_info += '"'+1201601+'" : "'+ TVKortNo2+'"';  
                        }
                        //DW-844 modification START
                        if(callMethod == 'AdditionalKortNumber3Validate')
                        {
                            handling_info += '"'+1201601+'" : "'+ TVKortNo3+'"';
                            system.debug('inside if handling_info.......'+handling_info);  
                        }
                        if(callMethod == 'AdditionalKortNumber4Validate')
                        {
                            handling_info += '"'+1201601+'" : "'+ TVKortNo4+'"';  
                        }
                        //DW-844 modification END
                   }  
           }
        if((hardwareSelection != '1101601' || hardwareSelection != '1101701' ||hardwareSelection != '1101801' || hardwareSelection != '1201507' || hardwareSelection != '1201508' || hardwareSelection != '1201509') && callMethod !='TvBoxSerialNumberValidate') //EDM-756
          handling_info +='}}';  
          return handling_info;    
       }     
         
   public void ValidateAllBooleans()
    {//hardwareSelection : product Number,hardwareSelectionName : Product name 
        string err = 'Please Validate Serial number';        
        Key = hardwareSelection + '~'+ hardwareSelectionName;
        productSRNumberList = new List<string>();
                
         if(hardwareSelection == '1201601')// tvilling kort
               {        system.debug('**************************'+ExistingTvkort);
                        // with one existing tvilling kort- then kort 2 must be validated
                        if(ExistingTvkort){
                                if(KortNumber2Validated)
                                {                               
                                        productSRNumberList.add(KortNo2.trim());
                                       ProductSerialNumbersMap.put(key,productSRNumberList);                                       
                                        EnableNextButton = true;
                                }
                       
                        }
                        // with no existing tvilling kort
                        else{
                            //Commented this for DW-844 as we now use common fields for existing and new Yousee Kort users
                         /*if(KortNumber2Validated || KortNumber1Validated)
                        {
                               if(KortNumber1Validated)
                               { productSRNumberList.add(KortNo1.trim());}
                               if(KortNumber2Validated)
                                {productSRNumberList.add(KortNo2.trim());}
                               
                                ProductSerialNumbersMap.put(key,productSRNumberList);                             
                                EnableNextButton = true;
                        }*/
                        //Added additional conditions for DW-844
                          if(AdditionalTVKortNumber1Validated || AdditionalTVKortNumber2Validated || AdditionalTVKortNumber3Validated || AdditionalTVKortNumber4Validated)
                                {  
                                    List<string> temp = new List<string>();  
                                    if(AdditionalTVKortNumber1Validated){ 
                                        temp.add(TVKortNo1.trim());
                                    }
                                        if(AdditionalTVKortNumber2Validated)
                                        {temp.add(TVKortNo2.trim());}
                                        //DW-844 modification START
                                        if(AdditionalTVKortNumber3Validated)
                                        {temp.add(TVKortNo3.trim());}
                                        if(AdditionalTVKortNumber4Validated)
                                        {temp.add(TVKortNo4.trim());} 
                                        //DW-844 modification END                                           
                                       Key = '1201601' + '~'+ 'Ekstrakort';
                                        //Modified for testing DW-844.. Replace before deploying to Production
                                       // Key = '1201601' + '~'+ 'Tvillingkort';
                                        ProductSerialNumbersMap.put(Key,temp);
                                        EnableNextButton = true;
                                        System.debug('inside--Key>'+Key);
                               }
                        }
               }                           
               
                // if YouSee Plus - youSee Plus is a combination of Leje of yousee Boks and YouSee kort.
                if(hardwareSelection == '1201504')
                {system.debug('inside yousee plus');
                        if(KortNumber2Validated && serialNumbervalidated)
                        {       List<string> temp = new List<String>();
                                productSRNumberList.add(SerialNovar);                                                              
                                key = bundleProductValue+ '~'+ hardwareSelectionName;
                                ProductSerialNumbersMap.put(key,productSRNumberList); //  YouSee Boks
                                temp.add(KortNo2.trim());                              
                                key = '1201505' + '~'+ hardwareSelectionName;
                                ProductSerialNumbersMap.put(key,temp); // YouSee Kort
                                EnableNextButton = true;
                                enableTvlkortFlag = true;
                                // additional tvilling kort is selected                      
                                
                                //system.debug('inside yousee plus'+EnableNextButton);
                                
                       }                       
                  
                }
                      
                // if HDstandardboksWithCard - It is combination of HDSTandardBoks + YouSee kort
                if(hardwareSelection == 'HDstandardboksWithCard')
                {
                    System.debug('KortNumber2Validated->'+KortNumber2Validated+'..serialNumbervalidated->'+serialNumbervalidated);
                        if(KortNumber2Validated && serialNumbervalidated)
                        {       List<string> temp = new List<String>();
                                productSRNumberList.add(SerialNovar);
                                key = '1218385' + '~'+ hardwareSelectionName;
                                ProductSerialNumbersMap.put(key,productSRNumberList); 
                                temp.add(KortNo2.trim());
                                key = '1201505' + '~'+ hardwareSelectionName;
                                ProductSerialNumbersMap.put(key,temp);                                
                                EnableNextButton = true;
                                enableTvlkortFlag = true;
                                System.debug('key for hdwithcard->'+key+'..map->'+ProductSerialNumbersMap);
                       }
                  
                }
               
                if(hardwareSelection == '1201505')// yousee Kort
                {
                        if(KortNumber2Validated)
                        {       
                                productSRNumberList.add(KortNo2.trim());
                                ProductSerialNumbersMap.put(key,productSRNumberList);                             
                                EnableNextButton = true;
                                enableTvlkortFlag = true; 
                        }
                                
                }
               
               // Leje of yousee Boks
               if((hardwareSelection == '1203021') ||(hardwareSelection == '1203020')) // Leje of yousee Boks/Leje of HD Boks
                {
                        if(serialNumbervalidated)
                        {
                                productSRNumberList.add(SerialNovar);
                                ProductSerialNumbersMap.put(key,productSRNumberList);                            
                                EnableNextButton = true;
                        }
                                
                }
               //DW-880
                if((hardwareSelection == '1201507') ||(hardwareSelection == '1201508') || (hardwareSelection == '1201509')) // Leje of yousee Boks/Leje of HD Boks
                {
                        if(serialNumberTVBoxvalidated)
                        {
                                productSRNumberList.add(TvBox);
                                ProductSerialNumbersMap.put(key,productSRNumberList);                            
                                EnableNextButton = true;
                            	enableTvlkortFlag = true; 
                        }
                                
                }
                if(hardwareSelection == '1218385')// HDBOKS witout card
                {
                        if(serialNumbervalidated)
                        {
                            System.debug('hardwareSelection'+hardwareSelection+'..serialNumbervalidated'+serialNumbervalidated);
                                productSRNumberList.add(SerialNovar);
                                ProductSerialNumbersMap.put(key,productSRNumberList);                              
                                EnableNextButton = true;
                                enableTvlkortFlag = true;
                        }
                        
                }
                system.debug('end of method'+EnableNextButton);
                //yousee kort , YouSee plus , HD Standrd Kort with Box and w/o box
                 if((hardwareSelection == '1201505') || (hardwareSelection == 'HDstandardboksWithCard') || (hardwareSelection == '1201504') || (hardwareSelection == '1218385'))
                 {                                      
                          if(displayTVkort)
                           {
                                //Added additional conditions for DW-844
                                  if(AdditionalTVKortNumber1Validated || AdditionalTVKortNumber2Validated || AdditionalTVKortNumber3Validated || AdditionalTVKortNumber4Validated)
                                        {  
                                            List<string> temp = new List<string>();  
                                            if(AdditionalTVKortNumber1Validated){ 
                                                temp.add(TVKortNo1.trim());
                                            }
                                                if(AdditionalTVKortNumber2Validated)
                                                {temp.add(TVKortNo2.trim());}
                                                //DW-844 modification START
                                                if(AdditionalTVKortNumber3Validated)
                                                {temp.add(TVKortNo3.trim());}
                                                if(AdditionalTVKortNumber4Validated)
                                                {temp.add(TVKortNo4.trim());} 
                                                //DW-844 modification END                                           
                                                Key = '1201601' + '~'+ 'Ekstrakort';
                                               // Key = '1201601' + '~'+ 'Tvillingkort';
                                                ProductSerialNumbersMap.put(Key,temp);
                                                EnableNextButton = true;
                                                System.debug('inside--Key>'+Key);
                                        }
                                        else
                                        {     
                                            System.debug('inside else ****'+EnableNextButton);                                           
                                                EnableNextButton = false;
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please validate Tvilling kort'));
                                               // return null;
                                        }
                                }
                        
                 
                 }
                
    }
    
  /**  public String getSerialNumberJSON(){
        String SerialNumbersJSON = '';
        if(ProductSerialNumbersMap.size() > 0){
            SerialNumbersJSON = '"serienumre" : {';
            for(String key : ProductSerialNumbersMap.keySet()){
                List<String> keySplitList = key.split('~');
                for(String serialNumber : ProductSerialNumbersMap.get(key)){
                    SerialNumbersJSON =SerialNumbersJSON + '"'+keySplitList[0]+'" : "'+serialNumber+'",';
                }
            }
            SerialNumbersJSON = SerialNumbersJSON.subString(0,SerialNumbersJSON.length()-1);
            SerialNumbersJSON = SerialNumbersJSON + '}';
        }
        System.debug('SerialNumbersJSON  -  '+SerialNumbersJSON);
        return SerialNumbersJSON;
    } */
    
    /*public String getHandlingInfo(){
        
        String setNumberPortingDate=''; 
        system.debug('NPFutureDate-----------------------------------------'+NPFutureDate);
        system.debug('NPCurrentDate-----------------------------------------'+NPCurrentDate);
        String handlingInfo = '{"aarsag" : "2", "ignorer-binding" :  "false"';*/
       /* if (dateForNumberPorting!=null && dateForNumberPorting!='' && dateForNumberPorting.length() > 0){
           handlingInfo = handlingInfo + ',' +'"leverings-dato" : "'+dateForNumberPorting+'"';
        }*/
        
        /*if (NPFutureDate!=null && NPFutureDate!=''){
                 setNumberPortingDate = NPFutureDate;
        } else if (NPCurrentDate!=null && NPCurrentDate!=''){
                 setNumberPortingDate = NPCurrentDate;
         }
        system.debug('setNumberPortingDate--------------------------'+setNumberPortingDate);
        if (setNumberPortingDate!=null && setNumberPortingDate!=''){
           handlingInfo = handlingInfo + ',' +'"leverings-dato" : "'+setNumberPortingDate+'"';
        }
        
        if(ProductSerialNumbersMap.size() > 0){
            handlingInfo = handlingInfo + ',' + getSerialNumberJSON();
        }
        handlingInfo = handlingInfo + '}';
        return handlingInfo;
    }*/
    
 /***************************************END OF SERIAL NUMBER ENTRY PAGE**************************************************************************************/
    /********************************DTV HARDWARE SELECTION PAGE*************************************************************************/
    public Map<Decimal, string> DTVInformationMap = new Map<Decimal, string>(); 
    public string getDTVInfo1() {
        if(DTVInformationMap.containsKey(1)){
            return DTVInformationMap.get(1);
        }
        else{
            return null;    
        }       
    }
     public string getDTVInfo2() {
        if(DTVInformationMap.containsKey(2)){
            return DTVInformationMap.get(2);
        }
        else{
            return null;    
        }       
    }
   /* public PageReference RedirectToDTVSmartCardSelection(){
        if(selectedProducts[index] == DealerSalesConstant.dtvEngId){     
            addIntermediatePageToFlow(DealerSalesConstant.dtvCardSelectId);             
        }
        else if(selectedProducts[index] == DealerSalesConstant.dtvPakkeId){      
            addIntermediatePageToFlow(DealerSalesConstant.fcCardSelectId);             
        }
        return nextFlow();
    }*/
    public Pagereference backtoHardwareSelection(){
          System.debug('In Backflow before return...  '+ jsonResponse);
        return Page.DtvHardwareSelection1;
        // System.debug('In Backflow after return...  '+ jsonResponse);
    }  
   /*********************************************************************************************************************************/
   /*******************************SMART CARD SELECTION PAGE************************************************************************/
    public PageReference RedirectToDTVChannelSelection(){
       /*system.debug('smartCardNumber: '+KortNr);
        system.debug('selectedProducts[index]: '+selectedProducts[index]);
        system.debug('DealerSalesConstant.dtvCardSelectId]: '+DealerSalesConstant.dtvCardSelectId);
        system.debug('DealerSalesConstant.fcCardSelectId]: '+DealerSalesConstant.fcCardSelectId);*/
       // if(selectedProducts[index] == DealerSalesConstant.dtvCardSelectId){ 
        addIntermediatePageToFlow(DealerSalesConstant.dtvChannelSelId); 
        /*if(selectedProducts[index] == DealerSalesConstant.dtvEngId){       
            addIntermediatePageToFlow(DealerSalesConstant.dtvChannelSelId);             
        }
        else if(selectedProducts[index] == DealerSalesConstant.dtvPakkeId){ 
        //else if(selectedProducts[index] == DealerSalesConstant.fcCardSelectId){      
            addIntermediatePageToFlow(DealerSalesConstant.fcChannelSelId);
                         
        }*/       
        return nextFlow();
    }  
    
    public PageReference RedirectToSerialNumberEntryPage(){
        
        system.debug('hard...................'+hardwareSelection);
        system.debug('hard...................'+hardwareSelectionName);
       System.debug('#'+ApexPages.CurrentPage().getParameters().get('produktUrl')+'#');       
       String produktUrl = ApexPages.CurrentPage().getParameters().get('produktUrl');
        if(produktUrl != null && produktUrl != ''){
         System.debug('inside if produktUrl value-->'+produktUrl);
         String serviceProducktURL = produktUrl.replaceFirst(kasia_EndPoint,'');      //produktUrl;       //.split('dk')[1];
         //Comment after regression testing
         //String serviceProducktURL = produktUrl.replaceFirst('http://preprod-kasia.yousee.dk','');   
         system.debug('serviceProducktURL value in RedirectToSerialNumberEntryPage-->'+serviceProducktURL);
       //Added for testing DW-653.. 
       //serviceProducktURL = produktUrl.split('dk')[1];
       
         try{
            System.debug('before call');
            //calling product service for Bundled Product- Yousee Plus
        productJsonResponse = callout2(END_POINT+'/Kasia20','', 'GET', serviceProducktURL, '','produkt');
            System.debug('productJsonResponse->'+productJsonResponse);
         }catch(exception ex){
             ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,  ex.getMessage());
            ApexPages.addMessage(m); 
            return null;
          }
        }
        System.debug('index->'+index);
        System.debug('selectedProducts[index]->'+selectedProducts[index]);
        if(selectedProducts[index] == DealerSalesConstant.dtvEngId){     
            system.debug('inside first if ************ '+selectedProducts[index]);
            addIntermediatePageToFlow(DealerSalesConstant.dtvSerialNoEntry);             
        }
        else if(selectedProducts[index] == DealerSalesConstant.dtvPakkeId){      
                system.debug('inside 2nd if ************ '+selectedProducts[index]);
            addIntermediatePageToFlow(DealerSalesConstant.fcSerialNoEntry);             
        }
    
     if(this.oldHardwareProduct != hardwareSelection)// if selection is same then do not reset values on harsware page.
     {
        ResetSerialPageValues();     
     }
        
        return nextFlow();
    } 
    public PageReference RedirectToFreeChoiceChannelSelectionPage(){
        addIntermediatePageToFlow(DealerSalesConstant.fcChannelSelId);  
        return nextFlow();       
    }
    public PageReference RedirectToApprovalPage(){
        addIntermediatePageToFlow(DealerSalesConstant.ApprovalPage);  
        return nextFlow();      
    }  
    public string selectedLaterPortingDateRadioID{get;set;}
    public string selectedCurrentPortingDateRadioID{get;set;}
     
    public PageReference RedirectToCustomerInfoPage(){
        
        newTelephoneId='';
        extTelephoneId='';
        NPCurrentDate='';
        NPFutureDate='';
        selectedLaterPortingDateRadioID='';
        selectedCurrentPortingDateRadioID='';
        
        if (ApexPages.CurrentPage().getParameters().get('npTffNumber')!='' && ApexPages.CurrentPage().getParameters().get('npTffNumber')!=null){
            
            selectedNumberForNP = ApexPages.CurrentPage().getParameters().get('npTffNumber');
            system.debug('selectedNumberForNP--------------In NExT Back Flow----------------'+selectedNumberForNP);   
        }
        if (ApexPages.CurrentPage().getParameters().get('radioValue')!=null && ApexPages.CurrentPage().getParameters().get('radioValue')!=''){
                telePhoneDirectoryName = ApexPages.CurrentPage().getParameters().get('radioValue');
                system.debug('telePhoneDirectoryName---'+telePhoneDirectoryName);
        }
        if (ApexPages.CurrentPage().getParameters().get('radioID')!=null && ApexPages.CurrentPage().getParameters().get('radioID')!=''){
                telePhoneDirectoryID = ApexPages.CurrentPage().getParameters().get('radioID');
                system.debug('telePhoneDirectoryID---'+telePhoneDirectoryID);
        }
        if (ApexPages.CurrentPage().getParameters().get('newTlfID')!=null && ApexPages.CurrentPage().getParameters().get('newTlfID')!=''){
                newTelephoneId = ApexPages.CurrentPage().getParameters().get('newTlfID');
                system.debug('newTelephoneId---'+newTelephoneId);
        }
        if (ApexPages.CurrentPage().getParameters().get('extTlfID')!=null && ApexPages.CurrentPage().getParameters().get('extTlfID')!=''){
                extTelephoneId = ApexPages.CurrentPage().getParameters().get('extTlfID');
                system.debug('extTelephoneId---'+extTelephoneId);
        }
        if (ApexPages.CurrentPage().getParameters().get('npFutureDate')!=null && ApexPages.CurrentPage().getParameters().get('npFutureDate')!=''){
                NPFutureDate = ApexPages.CurrentPage().getParameters().get('npFutureDate');
                system.debug('NPFutureDate-----------------------------------'+NPFutureDate);   
        } 
        if (ApexPages.CurrentPage().getParameters().get('activationDateForTlfBB')!=null && ApexPages.CurrentPage().getParameters().get('activationDateForTlfBB')!=''){
                NPCurrentDate = ApexPages.CurrentPage().getParameters().get('activationDateForTlfBB');
                system.debug('NPCurrentDate----------'+NPCurrentDate);      
        }
        if (ApexPages.CurrentPage().getParameters().get('laterPortingDate')!=null && ApexPages.CurrentPage().getParameters().get('laterPortingDate')!=''){
                selectedLaterPortingDateRadioID = ApexPages.CurrentPage().getParameters().get('laterPortingDate');
                system.debug('selectedLaterPortingDateRadioID----------'+NPCurrentDate);        
        }
         if (ApexPages.CurrentPage().getParameters().get('portingDate')!=null && ApexPages.CurrentPage().getParameters().get('portingDate')!=''){
                selectedCurrentPortingDateRadioID = ApexPages.CurrentPage().getParameters().get('portingDate');
                system.debug('selectedCurrentPortingDateRadioID----------'+NPCurrentDate);      
        }
        //addIntermediatePageToFlow(DealerSalesConstant.CustomerInfoPage);
        if(ProductSerialNumbersMap.size()>0){
          if(selectedProducts[(selectedProducts.size()-1)] == 'dtvPakkeId')
            removePageIds('dtvPakkeId');
        }  
        resetBbTlfFlagForSletOperation();
        
        return nextFlow();
      //  PageReference pageRef = Page.CustomerInfoPage;             
       // return pageRef;
    } 
    /*******************************CALL TO CASIA WHERE WE NEED RESPONSE ON SAME PAGE************************************************************************/
    public void callToKasia(){
      String selectedProds = ApexPages.CurrentPage().getParameters().get('selectedProds');
      system.debug('selectedProds in call'); 
       system.debug('kasia call *****'+url);
        if(url.contains('~'))
        {
          if(url.contains('Bredbånd')){  
                  checkBBFlag = false;
                }
                if(url.contains('Telefoni')){
                  checkTLFFlag = false;
                }
                if(url.contains('Sikkerhedspakken')){
                  checkSPBBFlag = false;
                }  
                //DW -855
                if(url.contains('YouSee Cloud 100 Test')){
                  checkCLFlag = false;
                 checkSPBBFlag = false;

                }   
          string tempurl = url.split('~')[0];
          string delProduct = url.split('~')[1];      
          url = tempurl;
          delProduct = delProduct.trim();
          DeleteBasketProduct(delProduct);
        } 
        // This code block should be removed when moved to test.
        if(url.contains(':41004'))
        url = url.replace(':41004','');
        // code block ends.
        String serviceURL = url;    //.split('dk')[1];
        System.debug('serviceURL: 41004'+serviceURL);
        
        // code added to incorporate the chage of handling infor for every PUT call wherever required
        String handlinInfo = '';
        if(isSerailNoProduct && !serviceURL.contains('slet')){
            handlinInfo = ','+ createHandlingInfo();    
            isSerailNoProduct = false;
        }
        // - end code
        
        String body = '{"kunde-data":' + kundeData + ', "array-init":"' + arrayInit + '"'+handlinInfo+'}';
        System.debug('Body with handling info sr --  '+body);
        //String request = 'PUT ' + serviceURL + '  !#$ ' + etag + '  !#$ ' + body;
       // System.debug('request'+request);
        String response = callout2(END_POINT,body, 'PUT', serviceURL, etag,'afsaetning');
        
        //String response = callout('http://192.66.36.144:7890/Kasia20', request);      //**Replace this with global endpoint
        system.debug('Got response from kasia **************  '+response);
        if(response!=null){
                //String returnCode = response.split('; ')[0]; commented because response code not present on response body
                if(responseCode == '200'){ 
                    isFirstCallToKasia=false;
                    jsonResponse = response;
                    isKasiaCallSuccess = true;
                } else {
                     //jsonResponse = '';
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,response);
                     //ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'wrong response, contact system administrator');
                    ApexPages.addMessage(m);
                    isKasiaCallSuccess = false;
                  //  error = response; 
                }
                System.debug('2 call '+ jsonResponse);
               
                resetBbTlfFlagForSletOperation();
               
        }
        else{
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Response is null from Kasia.');
                ApexPages.addMessage(m);
        }
        //system.debug('JsonHardwareselection **************************************'+JsonHardwareselection);
       // return null; 
    } 
   // code for telephony and broadband product selection
      public String SPProduct{get;set;}
      public string CLProduct{get;set;}
   public String BBProduct{get;set;}
   public String TLFProduct{get;set;}
   public String BBProductType;
   public String BBProductName; 
   public String TLFProductType;
   public String TLFProductName; 
   public String SPProductType;
   public String SPProductName;
   
   public string CLProductName;
   public string CLProductType;
   public Set<String> selectedProductType = new Set<String>();
   public static Integer cnt{get;set;}
    
   public PageReference selectedTLFValue(){
        if (cnt==0){
                selectedProductType.clear();
                //   cnt=cnt+1;
        }
        system.debug('TLFProduct-----------************---'+TLFProduct);
        List<String> TLFProductLst=new List<String>();
        if (TLFProduct!=null && TLFProduct!=''){
                TLFProductLst=TLFProduct.split('@@');
                TLFProductName=TLFProductLst[0];
                TLFProductType=TLFProductLst[1];
                system.debug('TLFProductType--------------------#######---------'+TLFProductType);
                selectedProductType.add(TLFProductType);
        }
        if (TLFProductName!=null && TLFProductName!=''){
            checkTLFFlag = true;
            String serviceURL = TLFProductName;    //.split('dk')[1];
            secondCallToCasia1(serviceURL);
        }
        system.debug('TLFProductName is----'+TLFProductName+'-----TLFProductType-----'+TLFProductType);
        return null;    
   }
    
   public PageReference selectedBBValue() {
    if (cnt==0){
                selectedProductType.clear();
                cnt++;
        }
        system.debug('count is -------------------'+cnt);
        system.debug('BBProduct----------************----------------'+BBProduct);
        List<String> BBProducctLst=new List<String>();
        if (BBProduct!=null && BBProduct!=''){
                BBProducctLst=BBProduct.split('@@');
                BBProductName=BBProducctLst[0];
                BBProductType=BBProducctLst[1];
                system.debug('BBProductType is ----------######################----------'+BBProductType);
                selectedProductType.add(BBProductType);
        }
        String serviceURL = BBProductName;    // .split('dk')[1];
       checkBBFlag =true;
       // checkSPBBFlag = true;
        secondCallToCasia1(serviceURL);
        system.debug('BBProductName is----'+BBProductName+'-----BBProductType-----'+BBProductType);
        
        return null;
   }     
    public PageReference selectedSPValue() {
    if (cnt==0){
                selectedProductType.clear();
                cnt++;
        }
        system.debug('count is -------------------'+cnt);
        system.debug('SPProduct----------************----------------'+SPProduct);
        List<String> SPProducctLst=new List<String>();
        if (SPProduct!=null && SPProduct!=''){
                SPProducctLst=SPProduct.split('@@');
                SPProductName=SPProducctLst[0];
                SPProductType=SPProducctLst[1];
                system.debug('SPProductType is ----------######################----------'+SPProductType);
                selectedProductType.add(SPProductType);
        }
         if (SPProductName!=null && SPProductName!=''){
        String serviceURL = SPProductName;    // .split('dk')[1];
        checkSPBBFlag = true;
        secondCallToCasia1(serviceURL);
         }
        system.debug('SPProductName is----'+SPProductName+'-----SPProductType-----'+SPProductType);
        
        return null;
   } 
   // DW-855
   public PageReference selectedCLValue() {
   if (cnt==0){
                selectedProductType.clear();
                cnt++;
        }
        List<String> CLProductLst=new List<String>();
        if (CLProduct!=null && CLProduct!='')
        {
            CLProductLst= CLProduct.split('@@');
            CLProductName = CLProductLst[0];
            CLProductType = CLProductLst[1];
            selectedProductType.add(CLProductType);
            
        }
        String serviceURL = CLProductName ;
        checkCLFlag = true;
        secondCallToCasia1(serviceURL);
        return null;
    }    
   // redandant code need to modify later
        
          string respCode = '200';
         // String arrayInit='';
     // String kundeData='';
     // String etag='';
        //String href='';
     // String url='';
      
                
      public void secondCallToCasia1(String href){
        
        String returnCode='';   
        try {
                List<String> mergeFieldsList;
                String mergeFields = ApexPages.CurrentPage().getParameters().get('mergedstring');
                system.debug('mergeFields-----------------'+mergeFields);
                if (mergeFields!=null && mergeFields!=''){
                    mergeFieldsList = mergeFields.split('@@@',0);
                    system.debug('mergeFieldsList.size()------------'+mergeFieldsList.size());
                    kundeData = mergeFieldsList[0];
                    arrayInit = mergeFieldsList[1];
                    etag = mergeFieldsList[2];
                }
               if (href!=null && arrayInit!=null && kundeData!=null && etag!=null) {
                    jsonResponse = secondCallToCasia(href,arrayInit,kundeData,etag);
                    //if (jsonResponse!=null && jsonResponse!=''){
                      //  returnCode = jsonResponse.split('; ')[0];
                   // }
               }         
               //if(returnCode == '200'){
                    isFirstCallToKasia=false;
                    //jsonResponse = jsonResponse.split('; ')[1];
                    system.debug('success:- jsonResponse-----------------------'+jsonResponse);
              // } 
            //else {
                  /*   jsonResponse = '';
                     ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'wrong response, contact system administrator');
                     ApexPages.addMessage(m); */
             //  }
                system.debug('success:- jsonResponse--------------secondCallToCasia1--End-------'+jsonResponse);
                
        } catch (Exception ex) {
                throw ex;
                respCode=null;
           //system.debug('Exception :'+e.getMessage());
        }
       //return responseCode;    
    }
    
    
    
    public PageReference afterBroadBandOrTelephonyProductSelection(){
                
        String redirectToNewPage = ApexPages.CurrentPage().getParameters().get('redirectToNewPage');
       
        String isBroadbandSubscriptionPresent = ApexPages.CurrentPage().getParameters().get('isBroadbandSubscriptionPresent');
        String isBroadbandSubscriptionNotAvailable = ApexPages.CurrentPage().getParameters().get('isBroadbandSubscriptionNotAvailable');
        List<String> bbTlfMergedString; 
        bbTlfMergedString = redirectToNewPage.split('@@');
        
        if (isBroadbandSubscriptionNotAvailable=='false'){
            bbSunscriptionIsPresent=true;
        }
        if (isBroadbandSubscriptionNotAvailable=='true'){
            bbSunscriptionIsPresent=false;
        }
        system.debug('redirectToNewPage--------contents-----'+redirectToNewPage);
        if (redirectToNewPage.contains('bb')&& redirectToNewPage.contains('TLF') && redirectToNewPage.contains('ta')){
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,true,false,true,false,false,false,false,true);
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
            
        
        } else if ((redirectToNewPage.contains('bb')) && redirectToNewPage.contains('TLF')){
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,true,false,true,false,false,false,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
             
        } else if ((redirectToNewPage.contains('bb')) && redirectToNewPage.contains('ta')){
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,true,false,false,true,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.BroadBandModemId);
             
        }
         else if ((redirectToNewPage.contains('TLF')) && redirectToNewPage.contains('ta')){
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,true,false,false,false,true,false);
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
             
        }
        else if ((redirectToNewPage.contains('bb'))){
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,true,false,false,false,false,false,false,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.BroadBandModemId);
             
        }
         else if ((redirectToNewPage.contains('ta'))){
             system.debug('ta ');
                setBroadBandTelephonyFlagsForCustomerInfoPages(false,false,false,false,false,false,true,false,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.CustomerInfoPage);
             
        }
         else if (redirectToNewPage.contains('TLF')){
             system.debug('TLF ');
                setBroadBandTelephonyFlagsForCustomerInfoPages(true,false,false,false,false,false,false,false,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
        }
         /*else if (redirectToNewPage.contains('TLF') && (redirectToNewPage.contains('ta')) && (redirectToNewPage.contains('bb'))){
                setBroadBandTelephonyFlagsForCustomerInfoPages(true,true,true,false,false,false,true,false,false,false);
                addIntermediatePageToFlow(DealerSalesConstant.bbTlfCommonId);
        }*/
          return nextFlow();       
   }
   
   private void setBroadBandTelephonyFlagsForCustomerInfoPages(boolean telefoniFlag,boolean onlyBroadbandFlag,boolean broadbandTelephonyCommonFlag,boolean TlfBroadbandFlag,boolean isFromBroadBand,boolean isFromTelephony,boolean onlySPFlag,boolean SPBroadbandFlag,boolean SPTlfFlag,boolean SPTlfBroadbandFlag){
        this.telefoniFlag = telefoniFlag;
        this.onlyBroadbandFlag = onlyBroadbandFlag;
        this.broadbandTelephonyCommonFlag = broadbandTelephonyCommonFlag;
        this.TlfBroadbandFlag = TlfBroadbandFlag;
        this.isFromBroadBand = isFromBroadBand;
        this.isFromTelephony = isFromTelephony;
        this.onlySPFlag=onlySPFlag;
        this.SPBroadbandFlag=SPBroadbandFlag;
        this.SPTlfFlag=SPTlfFlag;
        this.SPTlfBroadbandFlag=SPTlfBroadbandFlag;
   }
   
   public Pagereference fetchProductOffer() {
       return null;
   }
   /*
    public class ProductOfferWrapper {
                Public String ProductNumber{get;set;}
                public boolean ProductOfferExists{get;set;}
                public boolean ProductCampaignExists{get;set;} 
                public string ProductSummary {get;set;} 
                
        }
  
 */
    public PageReference redirectToFrontPage(){
        return Page.forhandlerHomePage;
    }
 
    public String getProductDealerCanSell(){       
        return convertSetToJson(objCommon.productsDealerCanSell);       
    }
 
  
  public void addYoubioProducts(){
    string responseCode='';  
    system.debug('existingYoubio is BEFORE -------------> '+existingYoubio); 
    existingYoubio = ApexPages.CurrentPage().getParameters().get('existingYoubio');
    system.debug('existingYoubio is AFTER-------------> '+existingYoubio); 
        try{
            responseCode = secondCallToCasia();
            system.debug('The response code is -------------> '+responseCode);   
            if(responseCode!='200' || responseCode==null){
              ApexPages.Message myMsg;
              myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Second Call to Kasia is not successfull.');
              ApexPages.addMessage(myMsg); 
              //return null;                        
            }
             else{
                 //Go to customer information page
                 /*PageReference pageRef = new PageReference('/apex/CustomerInfoPage');
                 pageRef.setRedirect(false);
                 return pageRef;*/
             }                          
        }
        catch(Exception ex){
            throw ex;
            //return null;
        }         
    //return null;
  }
  
  public PageReference redirectCustomerInfo(){
    index++;
    PageReference pageRef = new PageReference('/apex/CustomerInfoPage1');
    pageRef.setRedirect(false);
     return pageRef;
  }
  //to add DtvHardwareSelection page if Bland Selv is in basket for clear flow.
  public PageReference addDtvHardwareSelectionPage(){
      if(dtvtaflag)
        plusFlag = true;
        addIntermediatePageToFlow(DealerSalesConstant.dtvEngId);
        isBlandSelvFlow = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isBlandSelvProduct'));
        Integer numberOfYouseeKorts = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('numberOfYouseeKorts'));
        isBlandSelvSelected = isBlandSelvFlow;
        system.debug('the value of isBlandSelvFlow in  addDtvHardwareSelectionPage******************* '+isBlandSelvFlow+'---and numberOfYouseeKorts is -'+numberOfYouseeKorts);
        if(numberOfYouseeKorts >1){
            hasCustomerYouSeeCard = true;
        }
        return nextFlow();  
  }
  //To add serialNumber Page if TV Boks is in basket for clear flow.
     public PageReference addSerialNumberPage()
     {
         hardwareSelection = '1201507'; 
         addIntermediatePageToFlow(DealerSalesConstant.dtvSerialNoEntry);
         return nextFlow();
     }
  //to add DtvHardwareSelection page if Bland Selv is in basket for clear flow.
  public PageReference nextPageFlow(){
        isBlandSelvSelected = true;
        //Added the below line of code to check whether a Bland Selv product is added.
        isBlandSelvFlow = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isBlandSelvProduct')); 
        system.debug('the value of isBlandSelvFlow in  nextPageFlow******************* '+isBlandSelvFlow); 
        return nextFlow();  
  }
  //to avoid DtvHardwareSelection page if Bland Selv is not selected.
  public PageReference nextClearFlow(){
        //Added the below line of code to check whether a Bland Selv product is added.
        isBlandSelvFlow = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isBlandSelvProduct')); 
        system.debug('the value of isBlandSelvFlow in  nextClearFlow******************* '+isBlandSelvFlow); 
        return nextFlow();
  }
  //This method is used to delete dtvEndIdBS and dtvSerialNoEntryBS enteries in selectedProducts list 
  //if we are comming back on clearProductsPage when previous choosen product was a blandselv.
  private void removeDtvEngIdBSAndDtvSerialNoEntryBS(){
      System.debug('this is the value of selectedProducts.size()--------'+selectedProducts.size());
        for(Integer indexNo=0;indexNo < selectedProducts.size();indexNo++){
            //Integer indexNo =  Integer.valueof(selPro.trim());
            system.debug('This is the value of selectedProducts[indexNo]-----------'+selectedProducts[indexNo]);
            if(selectedProducts[indexNo] == 'dtvEngId' || selectedProducts[indexNo] == 'dtvSerialNoEntry'){
            selectedProducts.remove(indexNo);
            indexNo--;
            }
        }
        system.debug('these are final selected products after removeDtvEngIdBSAndDtvSerialNoEntryBS****************' +selectedProducts);
  }
  private void removePageIds(String pageId){
      system.debug('selectedProducts--------'+selectedProducts+' pageid to remove'+pageId);
      system.debug('selectedProducts.size()--------'+selectedProducts.size());
        for(Integer indexNo=0;indexNo < selectedProducts.size();indexNo++){
            //Integer indexNo =  Integer.valueof(selPro.trim());
            system.debug(' selectedProducts[indexNo]-----------'+selectedProducts[indexNo]);
            if(selectedProducts[indexNo] == pageId){
              selectedProducts.remove(indexNo);
            }
        }
        system.debug('these are final selected products after removeDtvEngIdBSAndDtvSerialNoEntryBS****************' +selectedProducts);
  }
  public String md5Coded2 { get; set; }   
    public String orderId {get; set;}             
    public void generateMD5Key(){
      md5Coded2 = orderId = '';
      DIBS_Settings__c dibsSet = DIBS_Settings__c.getInstance(); 
      
    string currencyMD5 = dibsSet.Currency_MD5__c;
    string orderIdMD5 = dibsSet.Order_ID_MD5__c;
      string key1 = dibsSet.Key1__c;
      string key2 = dibsSet.Key2__c;
      string merchant = dibsSet.Merchant_Id__c;
      orderId = dibsSet.Order_Id__c;
      string curr = dibsSet.Currency__c;
      Datetime myDT = Datetime.now(); 
    String myDate = myDT.format('ddMMyyyyhhmmss');
    orderId += myDate;
    system.debug('orderId ' +orderId);
      String input = key1 + 'merchant=' + merchant + orderIdMD5  + orderId + currencyMD5 + curr + '&amount=100';
      system.debug('input pppp: ' +input);
      String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(input)));
      system.debug('md5Coded ' +md5Coded);
      md5Coded = key2 + md5Coded;
      system.debug('md5Coded pppp: ' +md5Coded);
      md5Coded2 = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(md5Coded)));
    system.debug('md5Coded2 ' + md5Coded2);
    }
   
    private void resetCustomerLists(List<DealerCustomerPOJO> custLst){
        if (custLst.size()>0){
                    custLst.clear();
                    custLstActive.clear();
                    custLstInactive.clear();
                }
        
    }
    
    //Receipt page Data Generation.
    DealerProductReceiptGeneration dpReceiptGeneration= new DealerProductReceiptGeneration();
    public List<Abonnementers> getAbonometers() {
    system.debug('dpReceiptGeneration.abonometers'+dpReceiptGeneration.abonometers);
        return dpReceiptGeneration.abonometers;
    } 
    public List<Abonnementers> getAbonnementerProducts() {
         system.debug('This is my abonnometer List'+JSON.serialize(dpReceiptGeneration.abonnementerProducts));
         return dpReceiptGeneration.abonnementerProducts;
    }
    public List<Abonnementers> getInstallationProducts() {
    system.debug('dpReceiptGeneration.installationProducts'+dpReceiptGeneration.installationProducts);
        return dpReceiptGeneration.installationProducts;
    }
    public String getTotalAbnPriceValue(){ 
         return dpReceiptGeneration.totalAbnPrice.toPlainString();
    }   
    public String getTotalInsPriceValue(){
         return String.valueOf(dpReceiptGeneration.totalInsPrice);
    }
    
    public List<Abonnementers> getInstProdSrlNumbers() {
        return dpReceiptGeneration.getInstProdSrlNumbers(productJsonArray);  
    }
    public List<Abonnementers> getInstallationProductsAndTlfInfo() {
        system.debug('This is my installationProductsAndTlfInfo List');
        return dpReceiptGeneration.installationProductsAndTlfInfo;
    }
     public class PriserJSON {
 
    public String mediatype;
    public String href;
    public String rel;
 
    
    public PriserJSON parse(String json) {
        return (PriserJSON) System.JSON.deserialize(json, PriserJSON.class);
    }
}
}