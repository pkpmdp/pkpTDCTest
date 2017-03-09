public class clsProductsYKController {
    // Member variables used to bind model data to Visualforce pages
    //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private User user;
    private Account account;
    private Lead lead;
    private Address__c address;
    //private ProductItem[] existingProducts;
    private ProductItem[] potentialProducts;
    private ProductItem[] overnightProducts;
    private CampaignHistoryItem[] campaignHistory;
        
    private String existingProductsXmlResponse;
    private String potentialProductsXmlResponse;
    private String overnightProductsXmlResponse;
    private String campaignHistoryXmlResponse;
    private String currentTab;
    private List<SelectOption> items;
    public Set<String> producOfferList{get; set;}
    private Map<String, String> instMap;
    public boolean isDisableInputs{get; set;}
    public boolean isDisableProductOfferButton{get; set;} //spoc 2244
    public boolean isRenderTable{get; set;}
    public List<ProductItem> existingProducts{get; set;} 
    public boolean isrenderTableext{get; set;}
    public boolean existingProductsTableFilter{get; set;} //SPOC 2244
    public boolean potentialProductsTableFilter{get; set;} //SPOC 2244
    public boolean broadbandWOTv{get;set;}
    public list<string> listChkbox;
    public string arrPage{get; set;}
    // Controller is used for both the account and address Visualforce pages
     public static String mBillUrl = YouSeeCustomSettings__c.getInstance('mBillingUrlAccount').Setting_Value__c;
    public static String mBillOnphoneUrl = YouSeeCustomSettings__c.getInstance('mBillingOnphoneUrl').Setting_Value__c;
    
    public clsProductsYKController(ApexPages.StandardController controller) {
        // User information is needed when overnight products are accepted or declined
        isrenderTableext = false;
        listChkbox = new list<string>();
        if(UserInfo.getLanguage() == 'en_US')
        {
            listChkbox.add('Yes');
        }
        else if(UserInfo.getLanguage() == 'da')
        {
            listChkbox.add('Ja');
        }
        arrPage = JSON.Serialize(listChkbox);
        producOfferList = new Set<String>{'Grundpakke','Mellempakke','Fuldpakke','MP Bland Selv','FP Bland Selv','Agentpakke 2 med Bland Selv','Agentpakke 3 med Bland Selv','Fuldpakke med Bland Selv','Mellempakke med Bland Selv','Fuldpakke (BS)','Mellempakke (BS)'};
        this.user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
        // Controller extension is used on accounts, leads and addresses pages
        if (controller.getRecord() instanceOf  Account) {
            //currentTab = 'existingProductsTab';
            this.account = (Account) controller.getRecord();
        } else if (controller.getRecord() instanceOf  Lead) {
            //currentTab = 'campaignHistoryTab';
            this.lead = (Lead) controller.getRecord();
        } else if (controller.getRecord() instanceOf  Address__c) {
            //currentTab = 'existingProductsTab';
            //controller.addFields(new list<String>{'Cableunit_number__c','Cable_type__c'});
            this.address = (Address__c) controller.getRecord();
        } 
        isDisableInputs = true;
        isDisableProductOfferButton = true;  
        isRenderTable = false;
        existingProductsTableFilter = potentialProductsTableFilter = false;  //SPOC 2244
        broadbandWOTv = false;
    }
    
    public void setCurrentTab(String tab) {
        this.currentTab = tab;
    }
    
    public String getCurrentTab() {
        return this.currentTab;
    }
    
    public PageReference updateOvernightProducts() {
        this.currentTab = 'overnightProductsTab';
        getOvernightProducts();
        return null;
    }
    
    public PageReference updateCampaignHistory() {
        this.currentTab = 'campaignHistoryTab';
        getCampaignHistory();
        return null;
    }
    
    public PageReference updatePotentialProducts() {
        potentialProductsTableFilter = true; //SPOC 2244
        isDisableProductOfferButton = false; //spoc 2244
        this.currentTab = 'potentialProductsTab';
        getPotentialProducts();
        return null;
    }
    public PageReference loadDataAction()
    {       
        existingProductsTableFilter = true; //SPOC 2244
        isrenderTableext = true;
        isDisableInputs = false;
        isRenderTable = true;
        getExistingProducts1();
        return null;
    }
    
    // Method populates the existing products bind variable in the account and address Visualforce pages
    public List<ProductItem> getExistingProducts1() {
        if (this.existingProducts == null) {
            if (this.currentTab == 'existingProductsTab') {       
                // If we got this far we need to make the callout            
                // Set the parameters based upon the page the user is viewing
                if (this.account != null) {
                   //EDM-637 START
                    // add value in calloutValue list to find out at callout method
                    calloutParameter.add('null');
                    calloutValue.add(this.account.Customer_No__c);
                    existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                } else if (this.address != null) {   
                   // System.debug('getting existing products');   
                    getLocationAddress();   
                    
                   calloutParameter.add('null');
                    calloutValue.add(this.address.External_Id__c);    
                    existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_ADDRESSES_METHOD, calloutParameter,calloutValue);                       
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                //EDM-637 END
                }            
                this.existingProducts = parseProducts(existingProductsXmlResponse);
            }
            //Fetch O-Customer type from Salesforce
            if(this.existingProducts != null && this.existingProducts.size() > 0){
               setCustomerType();    
            }
        }           
        return this.existingProducts;                        
    }
    
    public void setCustomerType(){
        Set <String> customerIds = new Set<String>();
        for(ProductItem item : this.existingProducts){
            if(item.customerId != null && !customerIds.contains(item.customerId)){
                customerIds.add(item.customerId);   
            }    
        }        
        List<Account> accs = null;
        try{
            accs = [Select Id, Customer_type__c, Customer_No__c from Account where Customer_No__c IN :customerIds];
        }
        catch(Exception e){ system.debug('No accounts returned');}
        
        
        if(accs.size() > 0){
            Map<String,String> accMap = new Map<String,String>();
                for(Account item : accs){
                    if(accMap.get(item.Customer_No__c) == null)
                        accMap.put(item.Customer_No__c, item.Customer_type__c);
            }
            
            for(ProductItem item : this.existingProducts){
                if(item.customerId != null){                    
                    item.customerType = (accMap.get(item.customerId));    
                }
            }//End for-structure
        }//End if        
    }//End setCustomerType
    

    // Method populates the potential products bind variable in the address Visualforce page
     public List<ProductItem> getPotentialProducts() {
       // System.debug('this.potentialProducts: ' + this.potentialProducts);
        if (this.potentialProducts == null) {
          //  System.debug('this.currentTab: ' + this.currentTab);
            if (this.currentTab == 'potentialProductsTab') {   
                 // If we got this far we need to make the callout            
             //   System.debug('Going');
                if (this.address != null) {        
              //      System.debug('getting potential products'); 
                    //EDM-637 START
                     //String params = 'AMSAddressId=' + this.address.External_Id__c + ';CustomerNumber=' + '613699841';
                    //String params = 'AMSAddressId=' + this.address.External_Id__c;
                   // System.debug('params: ' + params);
                   this.address = [Select Id, Name, External_Id__c, Cable_type__c FROM Address__c WHERE Id=:this.address.Id];
                    calloutParameter.add('AMSAddressId');
                    calloutValue.add(this.address.External_Id__c);
                    Net_Installations__c netInSt = clsConnectionUtils_Admin.getInstallationSeq(this.address.External_Id__c, this.address.Cable_type__c);
                    if(netInSt != null){
                        calloutValue.add(netInSt.INSTALLATION_ID__c);
                    	calloutValue.add(netInSt.Cable_Unit_No__c);
                    
                    calloutValue.add('');
                    //calloutValue.add('7569698');
                    potentialProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.POTENTIAL_PRODUCTS_ADDRESSES_METHOD, calloutParameter, calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                    this.potentialProducts = parseProducts(potentialProductsXmlResponse);
                    }
                    system.debug('potentialProducts *** '+potentialProducts);
                  //EDM-637 END                    
                }
            }
        }           
        return this.potentialProducts;                        
    }
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
    public List<ProductItem> getOvernightProducts() {
        if (this.overnightProducts == null) {   
            if (this.currentTab == 'overnightProductsTab') {
                // If we got this far we need to make the callout
                //EDM-637 START
                calloutParameter.add('null');
                calloutValue.add(this.account.Customer_No__c);
                overnightProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.OVERNIGHT_PRODUCTS_CUSTOMERS_METHOD, calloutParameter,calloutvalue);
                calloutParameter = new List<String>();
                calloutValue = new List<string>();
                this.overnightProducts = parseProducts(overnightProductsXmlResponse);
                //EDM-637 END
            }
        }
        return this.overnightProducts;                    
    } 

    // Method populates the campaign history bind variable in the account Visualforce page
    public List<CampaignHistoryItem> getCampaignHistory() {
        if (this.campaignHistory == null) {
            if (this.currentTab == 'campaignHistoryTab') {
                // If we got this far we need to make the callout
                if (this.account != null) {
                //EDM-637 START
                calloutParameter.add('null');
                calloutValue.add(this.account.Customer_No__c + ';' + this.account.Customer_No__c);
                    campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.CAMPAIGN_HISTORY_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                calloutParameter = new List<String>();
                calloutValue = new List<string>();
                } else if (this.lead != null) {
                    calloutParameter.add('null');
                    calloutValue.add(this.lead.Affinium_Id__c);
                    campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.CAMPAIGN_HISTORY_LEADS_METHOD, calloutParameter, calloutvalue); //+ ';' + this.lead.Affinium_Id__c
                   calloutParameter = new List<String>();
                   calloutValue = new List<string>();
                   //EDM-637 END
                }                                    
                this.campaignHistory = parseCampaignHistory(campaignHistoryXmlResponse);
            }
        }
        return this.campaignHistory;
    }
        
    /*private String callout(String endpoint, String body) {
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(15000);
        req.setBody((body == null ? '' : body));        
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res: ' + res);
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response 
                String response = res.getBody();
                System.debug('response' + response);
                return response;                
            }
        }
        return null;    
    }
    */
    private List<ProductItem> parseProducts(String XmlResponse) {       
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseProduct(reader);
                        if((product.getAccountType()=='0' || product.getAccountType()=='2') && producOfferList.contains(product.getOfferName())){
                            product.account.Currency_Format__c=null;
                        }
                        products.add(product);
                        //system.debug('products ******** '+products);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return products;
        }
        return products;
    }

    private ProductItem parseProduct(XmlStreamReader reader) {
        ProductItem product = new ProductItem(); 
        String brodBandwithoutTvValue = '';
        map<String,String> broadBandKeyToValMap = new map<String,String>();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    system.debug('*****reader.getLocalName*******' + reader.getLocalName());
                    if(reader.getLocalName() == 'serviceAreaKey' && String.isBlank(brodBandwithoutTvValue)){
                        reader.next();
                        brodBandwithoutTvValue = reader.getText();
                        if(String.isNotBlank(brodBandwithoutTvValue)){
                            for(String str : brodBandwithoutTvValue.split('::')){
                                /* String key = str.split(':')[0].removeStart('"');
                                key = key.removeEnd('"'); */
                                broadBandKeyToValMap.put(str.split(':')[0],str.split(':')[1]);
                            }
                            if(broadBandKeyToValMap.containsKey('"bb-uden-clear-perm"'))
                                broadbandWOTv = Boolean.valueOf(broadBandKeyToValMap.get('"bb-uden-clear-perm"'));
                            
                        }
                        
                        
                        /* system.debug('******serviceAreaKey val **' + reader.getText());
                        system.debug('******broadBandKeyToValMap val **' + broadBandKeyToValMap.get('"bb-uden-clear-perm"')); */
                    }
                    if (reader.getLocalName() == 'CUSTOMERID') {
                        reader.next();
                        product.setCustomerId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUBSCRIPTION') {
                        reader.next();
                        product.setSubscription(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ACTIVE') {
                        reader.next();
                        //system.debug('Active value ******* '+checkEmptyElement(reader));
                        product.setActive(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGSTART') {
                        reader.next();
                        product.setBillingStart(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGEND') {
                        reader.next();
                        product.setBillingEnd(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'OFFERNAME') || (reader.getLocalName() == 'productShortName')) {
                        reader.next();
                        product.setOfferName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EFFECTIVEFROMDATE') {
                        reader.next();
                        product.setEffectiveFromDate(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EXPIRATIONDATE') {
                        reader.next();
                        product.setExpirationDate(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'BUSINESS_GROUP') || (reader.getLocalName() == 'businessArea')) {
                        reader.next();
                        product.setBusinessGroup(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'FIRSTNAME') {
                        reader.next();
                        product.setFirstName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'LASTNAME') {
                        reader.next();
                        product.setLastName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'DESCRIPTION') {
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));
                    }else if (reader.getLocalName() == 'customerType'){
                        reader.next();
                        product.setAccountType(checkEmptyElement(reader));
                        //System.debug('$$product.getCustomerType()'+Integer.valueOf(checkEmptyElement(reader)));
                    }else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
                        reader.next();
                        product.setPrice(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SEQID') {
                        reader.next();
                        product.setSeqId(checkEmptyElement(reader));
                    }else if (reader.getLocalName() == 'AMSADDRESSID') {
                        reader.next();
                        product.setAmsAddressId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'INSTALLATIONSEQ') {
                        reader.next();
                        product.setInstallationSeq(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'CABLEUNIT') {
                        reader.next();
                        product.setCableUnit(checkEmptyElement(reader));
                    }
                     else if (reader.getLocalName() == 'CABLETYPE') {
                        reader.next();
                        product.setCableType(checkEmptyElement(reader));
                    }                   
                     else if (reader.getLocalName() == 'PRODUCTTYPE') {
                        reader.next();
                        product.setProductType(checkEmptyElement(reader));
                    }                   
                     else if (reader.getLocalName() == 'SUBSCRIPTIONTYPE') {
                        reader.next();
                        product.setSubscriptionType(checkEmptyElement(reader));
                    }
                    else if (reader.getLocalName() == 'PRODUCTSTART') {
                        reader.next();
                        product.setProductStart(checkEmptyElement(reader));                           
                    }
                    else if (reader.getLocalName() == 'PRODUCTEND') {
                        reader.next();
                        product.setProductEnd(checkEmptyElement(reader));                           
                    }
                    else if (reader.getLocalName() == 'RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == '') {
                            product.setResponse('--None--');
                        } else {
                            product.setResponse(val);
                        }
                    }
                    
                    if(product.getAmsAddressId() != null && product.getInstallationSeq() != null && product.getCableUnit() != null){
                        String keyInst = product.getAmsAddressId() + product.getInstallationSeq() + product.getCableUnit();
                       // System.debug(' ##################################### Key inside Get products  #####################################' + keyInst);
                        String locn = instMap.get(keyInst);
                       // System.debug(' ##################################### AmsAddressId  #####################################' + product.getAmsAddressId());
                       // System.debug(' ##################################### InstallationSeq  #####################################' + product.getInstallationSeq());
                       // System.debug(' ##################################### CableUnit  #####################################' + product.getCableUnit());
                        if(locn != null){
                            product.setLocation(instMap.get(keyInst));
                        }   
                    }
                }
                  
            }
            reader.next();
        }
        return product;
    }

    private List<CampaignHistoryItem> parseCampaignHistory(String XmlResponse) {
        List<CampaignHistoryItem> campaignHistory = new List<CampaignHistoryItem>() ;
        if (XmlResponse == null) return campaignHistory;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        CampaignHistoryItem product = parseCampaignHistoryItem(reader);
                        campaignHistory.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing campaign history: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return campaignHistory;
        }
        return campaignHistory;
    }

    private CampaignHistoryItem parseCampaignHistoryItem(XmlStreamReader reader) {
        CampaignHistoryItem campaign = new CampaignHistoryItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'CAMPAIGNNAME') {
                        reader.next();
                        campaign.setCampaignName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'CAMPAIGNTYPE') {
                        reader.next();
                        campaign.setCampaignType(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'CHANNEL') {
                        reader.next();
                        campaign.setChannel(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EFFECTIVEFROMDATE') {
                        reader.next();
                        campaign.setEffectiveFromDate(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EXPIRATIONDATE') {
                        reader.next();
                        campaign.setExpirationDate(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'PRODUCT_GROUP') {
                        reader.next();
                        campaign.setProductGroup(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'OFFERNAME') {                      
                        reader.next();
                        campaign.setOfferName(checkEmptyElement(reader));                    
                    } else if (reader.getLocalName() == 'OFFERVERSIONNAME') {                       
                        reader.next();
                        campaign.setOfferVersionName(checkEmptyElement(reader));
                    }   
                }  
            }
            reader.next();
        }
        return campaign;
    }
    
    public void getLocationAddress(){
        List<Net_Installations__c> netInstallationList =  new List<Net_Installations__c>();
        netInstallationList = [Select n.Name, n.Location__c, n.INSTALLATION_ID__c, n.Cable_Unit_No__c From Net_Installations__c n where n.Address__c =: this.address.id];
        instMap = new Map<String, String>();
        for(Net_Installations__c installation : netInstallationList){
                if(installation.Name != null && installation.INSTALLATION_ID__c != null && installation.Cable_Unit_No__c != null){
                    String keyInst = installation.Name + installation.INSTALLATION_ID__c + installation.Cable_Unit_No__c;
                  //  System.debug(' ##################################### Key inside Get Location  ##################################### ' + keyInst);
                  //  System.debug(' ##################################### AmsAddressId  #####################################' + installation.Name);
                //    System.debug(' ##################################### InstallationSeq  #####################################' + installation.INSTALLATION_ID__c);
                 //   System.debug(' ##################################### CableUnit  #####################################' + installation.Cable_Unit_No__c);
                    instMap.put(keyInst, installation.Location__c);
                }
        }
    }
     
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
                  
    public class ProductItem {
        
        public ProductItem() {}
        
        private Account account;
        private String customerId; 
        private String subscription;
        private String active;
        private String billingStart;
        private String billingEnd;
        private String offerName;
        private String effectiveFromDate;
        private String expirationDate;
        private String businessGroup;
        private String businessArea;//spoc-2244
        private String firstName;
        private String lastName;
        private String description;
        private String price;
        private String seqId;
        private String response;
        private String customerType;
        private String amsAddressId;
        private String installationSeq;
        private String accountType;
        private String cableUnit;
        private String location;
        private String cableType;
        private String productType;
        private String subscriptionType;
        private boolean showLink = false;
        private String linkUrl ;
        private String productStart; //2244 new col
        private String productEnd; //2244 new col
        public String getProductStart(){
            return productStart;
        }
        
        public void setProductStart(String productStart){
            this.productStart = formatDate(productStart);
        }
        
        public String getProductEnd(){
            return productEnd;
        }
        
        public void setProductEnd(String productEnd){
            this.productEnd = formatDate(productEnd);
        }
        public String getBusinessArea(String businessArea)
        {
            return businessArea;
        }
        public void setBusinessArea(String businessArea)
        {
            this.businessArea = businessArea;
        }
        
        public boolean getShowLink(){
            return showLink;
        }
        public string getLinkUrl(){
            return linkUrl;
        }
        public void calculateLink(){
          String vMobileNumber = '';
          if (this.businessGroup == 'Mobilt bredbånd' && (this.subscription.contains('Mindst') || this.subscription.contains('Meget') || this.subscription.contains('Mere') || this.subscription.contains('Mest'))){
            if (this.subscription.indexOf('-') > 0){
                     vMobileNumber = this.subscription.left(this.subscription.indexOf('-')).trim();
                    if (vMobileNumber.length() == 8){
                        linkUrl = clsProductsYKController.mBillUrl + 'account='+vMobileNumber;
                    }
                    else {
                        linkUrl = mBillOnphoneUrl;
                    }
                    this.showLink = true;
            }
            else 
            linkUrl = ''; 
          }
        }
        
        //grajput START
        public String getCableType() {
            return cableType;
        }
            
        public void setCableType(String cableType) {
            this.cableType = cableType;
        }
        
        public String getProductType() {
            return productType;
        }
            
        public void setProductType(String productType) {
            this.productType = productType;
        }
        
        public String getSubscriptionType() {
            return subscriptionType;
        }
            
        public void setSubscriptionType(String subscriptionType) {
            this.subscriptionType = subscriptionType;
        }       
        //grajput END
        
        
        public String getLocation() {
            return location;
        }
            
        public void setLocation(String location) {
            this.location = location;
        }
        
        public String getCableUnit() {
            return cableUnit;
        }
            
        public void setCableUnit(String cableUnit) {
            this.cableUnit = cableUnit;
        }
        
        public String getInstallationSeq() {
            return installationSeq;
        }
            
        public void setInstallationSeq(String installationSeq) {
            this.installationSeq = installationSeq;
        }
        
        public String getAmsAddressId() {
            return amsAddressId;
        }
            
        public void setAmsAddressId(String amsAddressId) {
            this.amsAddressId = amsAddressId;
        }
                        
        public String getCustomerId() {
            return customerId;
        }
            
        public void setCustomerId(String cId) {
            this.CustomerId = cId;
        }
        public String getAccountType(){
            return accountType;
        }
        
        public void setAccountType(String accountType){
            this.accountType = accountType;
        }

        public String getSubscription() {
            return this.subscription;
        }
            
        public void setSubscription(String sub) {
            this.subscription = sub;
        }
        
        public String getActive() {
            return this.active;
        }
            
        public void setActive(String act) {
        //listChkbox = new list<string>();
        /*if(act == '1')
        {
             this.active = 'Yes'; 
        }
        else
        {
            this.active = 'No';
        }*/
        //('Lang ************ '+UserInfo.getLanguage());
            if (act == '1' && UserInfo.getLanguage() == 'en_US') {
                
                this.active = 'Yes'; 
                //listChkbox.add(active);   
            }
            else if(act == '1' && UserInfo.getLanguage() == 'da') 
            {
                this.active = 'Ja';
                //listChkbox.add(active); 
            }
            else if(act != '1' && UserInfo.getLanguage() == 'da') 
            {
                this.active = 'Nej';
                //listChkbox.add(active); 
            }
            else {
                this.active = 'No';
                //listChkbox.add(active); 
            }
        }
        
        public String getBillingStart() {
            return this.billingStart;
        }
            
        public void setBillingStart(String billingStart) {
            this.billingStart = formatDate(billingStart);            
        }
                
        public String getBillingEnd() {
            return this.billingEnd;
        }
            
        public void setBillingEnd(String billingEnd) {
            this.billingEnd = formatDate(billingEnd);            
        }
        
        public String getOfferName() {
            return this.offerName;
        }
            
        public void setOfferName(String off) {
            this.offerName = off;
        }

        public String getEffectiveFromDate() {
            return this.effectiveFromDate;
        }
            
        public void setEffectiveFromDate(String effectiveFromDate) {
            this.effectiveFromDate = formatDate(effectiveFromDate);            
        }

        public String getExpirationDate() {
            return this.expirationDate;
        }
            
        public void setExpirationDate(String expirationDate) {
            this.expirationDate = formatDate(expirationDate);    
        }

        public String getBusinessGroup() {
            return this.businessGroup;
        }
            
        public void setBusinessGroup(String bg) {
            this.businessGroup = bg;
        }

        public String getFirstName() {
            return this.firstName;
        }
            
        public void setFirstName(String fn) {
            this.firstName = fn;
        }

        public String getLastName() {
            return this.lastName;
        }
            
        public void setLastName(String ln) {
            this.lastName = ln;
        }
        
        public String getDescription() {
            return this.description;
        }
            
        public void setDescription(String descr) {
            this.description = descr;
        }
        
        public void setPrice(String p) {
            if (p != null) {
                if (p.length() > 0) {
                    this.account = new Account(Currency_Format__c=Decimal.valueOf(p));
                }
            }
        }

        public String getSeqId() {
            return this.seqId;
        }
            
        public void setSeqId(String sid) {
            this.seqId = sid;
        }
                
        public String getResponse() {
            return this.response;
        }

        public void setResponse(String r) {
            this.response = r;
        }
                    
        public Account getAccount() {
            return this.account;
        }
        
        public void setCustomerType(String customerType) {          
            this.customerType = customerType;
        }
        
        public String getCustomerType() {
            return this.customerType;
        }      
        
        private String formatDate(String strDate) {
            try {
                if(strDate != null && !(''.equals(strDate))){
                    Date dt = Date.valueOf(strDate);
                    return dt.format();
                }else{
                    return '';
                }   
            } catch(Exception e) {
                return '';
            }
        }
    }
    
    public class CampaignHistoryItem {
        
        public CampaignHistoryItem() {}
               
        private String campaignName;
        private String campaignType;
        private String channel;
        private String effectiveFromDate;
        private String expirationDate;
        private String productGroup;
        private String offerName;       
        private String offerVersionName;
            
        public String getCampaignName() {
            return campaignName;
        }
            
        public void setCampaignName(String campaignName) {
            this.campaignName = campaignName;
        }
         
        public String getCampaignType() {
            return campaignType;
        }
            
        public void setCampaignType(String campaignType) {
            this.campaignType = campaignType;
        }
        
        public String getChannel() {
            return channel;
        }
            
        public void setChannel(String channel) {
            this.channel = channel;
        }
        
        public String getEffectiveFromDate() {
            return this.effectiveFromDate;
        }
            
        public void setEffectiveFromDate(String efd) {
            this.effectiveFromDate = formatDate(efd);
        }

        public String getExpirationDate() {
            return this.expirationDate;
        }
            
        public void setExpirationDate(String ed) {
            this.expirationDate = formatDate(ed);
        }
        
        public String getProductGroup() {
            return this.productGroup;
        }
            
        public void setProductGroup(String pg) {
            this.productGroup = pg;
        }
        
        public void setOfferName(String offerName) {        
            this.offerName = offerName;
        }
        
        public String getOfferName() {
            return this.offerName;
        }

        public void setOfferVersionName(String offerVersionName) {          
            this.offerVersionName = offerVersionName;
        }
        
        public String getOfferVersionName() {
            return this.offerVersionName;
        }
        
        private String formatDate(String strDate) {
            try {
                Date dt = Date.valueOf(strDate);
                return dt.format();
            } catch(Exception e) {
                return '';
            }
        }
                  
    }
 
    public void submitResponses() {
        for (ProductItem product : this.overnightProducts) {
            SendOfferResponse(product);
        }
    }
    
    public void SendOfferResponse(ProductItem overnightProduct) {
        // Start the callout code
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setTimeout(15000);
        req.setEndpoint(clsConnectionUtils_Admin.END_POINT + clsConnectionUtils_Admin.OVERNIGHT_PRODUCTS_RESPONSE_METHOD);
        // Campaign Id + ';' + Agent Id + ';' + Response
        String body = overnightProduct.getSeqId() + ';' + this.user.MID__c + ';' + overnightProduct.getResponse();
        req.setBody(body);
        // Make the callout and check the response
        try {
            HttpResponse res = http.send(req);
            System.debug(res);
            if (res.getStatusCode() == 200) {
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.INFO, 'Responses Submitted');
                ApexPages.addMessage(m);
            } else {
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Unable to log response at this time: ' + res.getStatus());
                ApexPages.addMessage(m);
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
        }
    }
    
    public List<SelectOption> getItems() {
        if (this.items == null) {
            this.items = new List<SelectOption>();
            this.items.add(new SelectOption('--None--','--None--'));
            this.items.add(new SelectOption('Accepteret','Accepteret'));
            this.items.add(new SelectOption('Overvejer','Overvejer'));
            this.items.add(new SelectOption('Afslået','Afslået'));
        }
        return this.items;
    }       
    
    
            
    static testMethod void testDisplayCustomer() {
        
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
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
         Net_Installations__c netInstallold = new Net_Installations__c();
        netInstallold.Name = '123456';
        netInstallold.Installation_Status__c = 'Plug Outlet';
        netInstallold.Installation_Status_Code__c = '1';
        netInstallold.INSTALLATION_ID__c = '45678';
        netInstallold.Cable_Unit__c = cableUnitTest.Id;
        netInstallold.Address__c=add.id;
        netInstallold.Installation_Status_Code__c='1'; 
        insert netInstallold;
        
         Net_Installations__c netInstallold1 = new Net_Installations__c();
        netInstallold1.Name = '123456';
        netInstallold1.Installation_Status__c = 'Plug Outlet';
        netInstallold1.Installation_Status_Code__c = '1';
        netInstallold1.INSTALLATION_ID__c = '45678';
        netInstallold1.Cable_Unit__c = cableUnitTest.Id;
        netInstallold1.Address__c=add.id;
        netInstallold1.Installation_Status_Code__c='1';
        insert netInstallold1;
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        // Create lead record        
        Lead l = new Lead();
        l.FirstName = 'Tom';
        l.LastName = 'Jones';
        l.Email = 'test@testaccount123.dk';
        l.RecordTypeId = '012200000000nzVAAQ';
        l.Street_Lookup__c = add.Id;
        l.Phone = '01322788767';
        l.Type__c = 'Kunde';
        l.Status = 'Åben';
        l.Estimated_Potential__c = 100;
        l.No_Email_Address__c = false;
        //l.No_Thank_You__c = 'Ja';
        insert l;
        
        // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsProductsYKController controller = new clsProductsYKController(sc);
        controller.setCurrentTab('existingProductsTab');       
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 2);
        System.assertEquals('existingProductsTab', controller.getCurrentTab());
        System.assertEquals(null, controller.overnightProducts);
        //controller.retrievedExistingProducts = true;
        //ProductItem existingProduct1 = controller.getExistingProducts()[0];
        //System.assertEquals('604559100', existingProduct1.getCustomerId());
        /*System.assertEquals('BJARNE', existingProduct1.getFirstName());
        System.assertEquals('PETERSEN', existingProduct1.getLastName());
        System.assertEquals('Fuldpakke', existingProduct1.getSubscription());
        System.assertEquals('1', existingProduct1.getBusinessGroup());
        System.assertEquals('Yes', existingProduct1.getActive());
        System.assertEquals('01-01-1900', existingProduct1.getBillingEnd());
        System.assertEquals(500, existingProduct1.getAccount().Currency_Format__c);

        ProductItem existingProduct2 = controller.getExistingProducts()[1];
        System.assertEquals('604559100', existingProduct2.getCustomerId());
        System.assertEquals('BJARNE', existingProduct2.getFirstName());
        System.assertEquals('PETERSEN', existingProduct2.getLastName());
        System.assertEquals('Bredbånd 10 Mbit/1 Mbit', existingProduct2.getSubscription());
        System.assertEquals('3', existingProduct2.getBusinessGroup());
        System.assertEquals('Yes', existingProduct2.getActive());
        System.assertEquals('', existingProduct2.getBillingEnd());
        System.assertEquals(1000, existingProduct2.getAccount().Currency_Format__c);
        */
        controller.existingProductsXmlResponse = null;
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 0);
        
        controller.updateOvernightProducts();
        controller.overnightProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>999</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE>2009-04-28T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2009-05-15T00:00:00.000</EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>998</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle2</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle2</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.overnightProducts = controller.parseProducts(controller.overnightProductsXmlResponse);        
        System.assertEquals(controller.overnightProducts.size(), 2);
        System.assertEquals('overnightProductsTab', controller.getCurrentTab());
        System.assertEquals(null, controller.campaignHistory);

        ProductItem overnightProduct1 = controller.getOvernightProducts()[0];
        System.assertEquals('Overnight Bundle', overnightProduct1.getOfferName());
        //System.assertEquals('28-04-2009', overnightProduct1.getEffectiveFromDate());
        //System.assertEquals('15-05-2009', overnightProduct1.getExpirationDate());
        //System.assertEquals('Webspeed', overnightProduct1.getProduct1());
        //System.assertEquals('Internet', overnightProduct1.getProductGroup1());
        System.assertEquals('--None--', overnightProduct1.getResponse());
        
        ProductItem overnightProduct2 = controller.getOvernightProducts()[1];
        System.assertEquals('Overnight Bundle2', overnightProduct2.getOfferName());
        //System.assertEquals('', overnightProduct2.getEffectiveFromDate());
        //System.assertEquals('', overnightProduct2.getExpirationDate());
        //System.assertEquals('Webspeed', overnightProduct2.getProduct1());
        //System.assertEquals('Internet', overnightProduct2.getProductGroup1());
        System.assertEquals('--None--', overnightProduct2.getResponse());
        
        controller.updateCampaignHistory();
        controller.campaignHistoryXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>14411011</SEQID><OFFERTRACKID>959</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere Maj 2008</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000176</CAMPAIGNCODE><OFFERCODE>KO_000171</OFFERCODE><OFFERNAME>Premiere</OFFERNAME><OFFERVERSIONCODE>V181</OFFERVERSIONCODE><OFFERVERSIONNAME>maj 2008</OFFERVERSIONNAME><TRACKINGCODE>000000959</TRACKINGCODE><CELLCODE>A575</CELLCODE><CAMPAIGNTYPE>Upsale</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-05-13T00:00:00.000</CONTACTDATE><RUNDATE>05/13/2008</RUNDATE><EFFECTIVEFROMDATE>2008-05-13T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2008-05-31T00:00:00.000</EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>14738818</SEQID><OFFERTRACKID>1218</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere september</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000211</CAMPAIGNCODE><OFFERCODE>KO_000278</OFFERCODE><OFFERNAME>Premiere september</OFFERNAME><OFFERVERSIONCODE>V309</OFFERVERSIONCODE><OFFERVERSIONNAME>Tekst_Læs mere</OFFERVERSIONNAME><TRACKINGCODE>000001218</TRACKINGCODE><CELLCODE>A847</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector HD</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-09-03T00:00:00.000</CONTACTDATE><RUNDATE>09/03/2008</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        System.assertEquals(controller.campaignHistory.size(), 2);
        System.assertEquals('campaignHistoryTab', controller.getCurrentTab());
        
        CampaignHistoryItem campaignHistory1 = controller.getCampaignHistory()[0];
        System.assertEquals('Premiere Maj 2008', campaignHistory1.getCampaignName());
        System.assertEquals('Upsale', campaignHistory1.getCampaignType());
        System.assertEquals('Email', campaignHistory1.getChannel());
        //System.assertEquals('13-05-2008', campaignHistory1.getEffectiveFromDate());
        //System.assertEquals('31-05-2008', campaignHistory1.getExpirationDate());
        System.assertEquals('DigitalTV', campaignHistory1.getProductGroup());
        
        CampaignHistoryItem campaignHistory2 = controller.getCampaignHistory()[1];
        System.assertEquals('Premiere september', campaignHistory2.getCampaignName());
        System.assertEquals('Sales Campaigns', campaignHistory2.getCampaignType());
        System.assertEquals('Email', campaignHistory2.getChannel());
        //System.assertEquals('', campaignHistory2.getEffectiveFromDate());
        //System.assertEquals('', campaignHistory2.getExpirationDate());
        System.assertEquals('DigitalTV', campaignHistory2.getProductGroup());
        
        // Get a handle on controller with address as focus record   
        sc = new ApexPages.StandardController(add);     
        controller = new clsProductsYKController(sc);                
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        //System.assertEquals(controller.getExistingProducts().size(), 2);
        
        controller.potentialProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.potentialProducts = controller.parseProducts(controller.potentialProductsXmlResponse);
        System.assertEquals(controller.getPotentialProducts().size(), 2);
       
        // Get a handle on controller with lead as focus record
        sc = new ApexPages.StandardController(l);       
        controller = new clsProductsYKController(sc);               
        controller.campaignHistoryXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>14411011</SEQID><OFFERTRACKID>959</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere Maj 2008</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000176</CAMPAIGNCODE><OFFERCODE>KO_000171</OFFERCODE><OFFERNAME>Premiere</OFFERNAME><OFFERVERSIONCODE>V181</OFFERVERSIONCODE><OFFERVERSIONNAME>maj 2008</OFFERVERSIONNAME><TRACKINGCODE>000000959</TRACKINGCODE><CELLCODE>A575</CELLCODE><CAMPAIGNTYPE>Upsale</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-05-13T00:00:00.000</CONTACTDATE><RUNDATE>05/13/2008</RUNDATE><EFFECTIVEFROMDATE>2008-05-13T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2008-05-31T00:00:00.000</EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>14738818</SEQID><OFFERTRACKID>1218</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere september</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000211</CAMPAIGNCODE><OFFERCODE>KO_000278</OFFERCODE><OFFERNAME>Premiere september</OFFERNAME><OFFERVERSIONCODE>V309</OFFERVERSIONCODE><OFFERVERSIONNAME>Tekst_Læs mere</OFFERVERSIONNAME><TRACKINGCODE>000001218</TRACKINGCODE><CELLCODE>A847</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector HD</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-09-03T00:00:00.000</CONTACTDATE><RUNDATE>09/03/2008</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        controller.loadDataAction();
        //controller.callout('http://TDCGroupTRIAL79207.jitterbit.eu/devonpre/1', '123456');
        controller.address = add;
        controller.updatePotentialProducts();
        controller.getLocationAddress();
        controller.existingProducts = new List<clsProductsYKController.ProductItem>();
        controller.existingProducts.add(new clsProductsYKController.ProductItem());
        controller.setCustomerType();
        controller.getItems();
        //controller.submitResponses();
        controller.SendOfferResponse(new clsProductsYKController.ProductItem());
        ProductItem pi = new ProductItem();
        pi.getProductStart();
        pi.setProductStart('GP');
        pi.setProductEnd('productEnd');
        pi.getProductEnd();
        pi.getShowLink();
        pi.getLinkUrl();
        pi.calculateLink();
        pi.getCableType();
        pi.setCableType('COAX');
        pi.getProductType();
        pi.setProductType('test');
        pi.getSubscriptionType();
        pi.setSubscriptionType('test');
        pi.getLocation();
        pi.setLocation('left');
        pi.getCableUnit();
        pi.setCableUnit('123456');
        pi.getInstallationSeq();
        pi.setInstallationSeq('12345');
        pi.setAmsAddressId('test');
        pi.getCustomerId();
        pi.setAccountType('test');
        pi.getSubscription();
        pi.getActive();
        pi.getBillingStart();
        pi.setBillingStart('test');
        pi.getBillingEnd();
        pi.getEffectiveFromDate();
        pi.getExpirationDate();
        pi.getBusinessGroup();
        pi.getFirstName();
        pi.getLastName();
        pi.getDescription();
        pi.setDescription('test');
        pi.getAccount();
        pi.setCustomerType('test');
        pi.getCustomerType();
        CampaignHistoryItem chi = new CampaignHistoryItem();
        chi.getEffectiveFromDate();
        chi.getExpirationDate();
        chi.getOfferName();
        chi.getOfferVersionName();
        //controller.retrievedCampaignHistory = true;
        System.assertEquals(controller.getCampaignHistory().size(), 2);
           
    }
}