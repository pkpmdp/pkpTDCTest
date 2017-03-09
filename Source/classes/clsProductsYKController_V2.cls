public class clsProductsYKController_V2 {
    
    //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    // Member variables used to bind model data to Visualforce pages
    private User user;
    private Account account;
    private Lead lead;
    private Address__c address;
    private ProductItem[] existingProducts;
    private ProductItem[] potentialProducts;
    private ProductItem[] overnightProducts;
    private ProductItem[] sasProducts;    
    private ProductItem[] offerProducts;
    private CampaignHistoryItem[] campaignHistory;
    public string cableTypeIsNumber{get; set;}    
    private String existingProductsXmlResponse;
    private String potentialProductsXmlResponse;
    private String overnightProductsXmlResponse;    
    private String sasProductsXmlResponse;
    private String campaignHistoryXmlResponse;
    private String currentTab;
    
    //Testing
    private List<ProductItem> sampleOffers1 = new List<ProductItem>();
    private List<ProductItem> sampleOffers2 = new List<ProductItem>();
    
    private List<SelectOption> items;
    
    public Boolean getDisplayOvernight(){
        
        if(this.overnightProducts != null){
            if(this.overnightProducts.size() > 0)
                return true;
            else
                return false;
        }
        else
            return false;
    }
    public Boolean getDisplaySAS(){
        
        if(this.sasProducts != null){
            if(this.sasProducts.size() > 0)
                return true;
            else
                return false;
        }
        else
            return false;
    }
    
    public Boolean getDisplayOffers(){
        
        return getDisplayOvernight() || getDisplaySAS();
    }
    
    public Boolean getDisplayNoOffers(){
        
        return !getDisplayOffers();
    }
    // Controller is used for both the account and address Visualforce pages
    public clsProductsYKController_V2(ApexPages.StandardController controller) {
        // User information is needed when overnight products are accepted or declined
        this.user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
        // Controller extension is used on accounts, leads and addresses pages
        
        
        if (controller.getRecord() instanceOf  Account) {
            
            currentTab = 'offerProductsTab';
            this.account = (Account) controller.getRecord();
            updateOfferProducts();
            
        } else if (controller.getRecord() instanceOf  Lead) {
            currentTab = 'campaignHistoryTab';
            this.lead = (Lead) controller.getRecord();
        } else if (controller.getRecord() instanceOf  Address__c) {
            currentTab = 'existingProductsTab';
            this.address = (Address__c) controller.getRecord();
        }   
        
        /*
//Testing
ProductItem product1 = new ProductItem();
if(controller.getRecord() instanceOf  Account)
product1.account = (Account) controller.getRecord();
product1.customerId = 'Test1'; 
product1.subscription = 'Test1';
product1.active = 'Test1';
product1.billingStart = 'Test1';
product1.billingEnd = 'Test1';
product1.offerName = 'Test1';
product1.effectiveFromDate = 'Test1';
product1.expirationDate = 'Test1';
product1.businessGroup = 'Test1';
product1.firstName = 'Test1';
product1.lastName = 'Test1';
product1.description = 'Test1';
product1.price = 'Test1';
product1.seqId = 'Test1';
product1.response = 'Test1';
product1.scriptUrl = 'http://www.google.com';
sampleOffers1.add(product1);
ProductItem product2 = new ProductItem();
if(controller.getRecord() instanceOf  Account)
product2.account = (Account) controller.getRecord();
product2.customerId = 'Test2'; 
product2.subscription = 'KTV,BB,DKTV';
product2.active = 'Test2';
product2.billingStart = 'Test2';
product2.billingEnd = 'Test2';
product2.offerName = 'Test2';
product2.effectiveFromDate = 'Test2';
product2.expirationDate = 'Test2';
product2.businessGroup = 'Test2';
product2.firstName = 'Test2';
product2.lastName = 'Test2';
product2.description = 'Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 Test2 ';
product2.price = 'Test2';
product2.seqId = 'Test2';
product2.response = 'Test2';
product2.scriptUrl = 'http://www.salesforce.com';
product2.Street = 'Sample Street';
sampleOffers2.add(product2);
*/
        
    }
    
    public void setCurrentTab(String tab) {
        this.currentTab = tab;
    }
    
    public String getCurrentTab() {
        return this.currentTab;
    }
    
    public PageReference updateOfferProducts() {
        this.currentTab = 'offerProductsTab';
        populateOfferProducts();
        return null;
    }
    
    public PageReference updateExistingProducts() {
        this.currentTab = 'existingProductsTab';
        getExistingProducts();
        return null;
    }
    
    public PageReference updateCampaignHistory() {
        this.currentTab = 'campaignHistoryTab';
        getCampaignHistory();
        return null;
    }
    
    public PageReference updatePotentialProducts() {
        this.currentTab = 'potentialProductsTab';
        getPotentialProducts();
        return null;
    }
    
    // Method populates the existing products bind variable in the account and address Visualforce pages
    public List<ProductItem> getExistingProducts() {
        
        if (this.existingProducts == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,this.currentTab));
            
            if (this.currentTab == 'existingProductsTab') {       
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products'));
                
                // If we got this far we need to make the callout            
                // Set the parameters based upon the page the user is viewing
                
                if (this.account != null) {
                    // add value in calloutValue list to find out at callout method
                    //EDM-637 START
                    calloutParameter.add('null');
                    calloutValue.add(this.account.Customer_No__c);
                    existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutParameter,calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                } else if (this.address != null) {   
                    System.debug('getting existing products');  
                    calloutParameter.add('null');
                    calloutValue.add(this.address.External_Id__c);    
                    existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_ADDRESSES_METHOD, calloutParameter,calloutValue);                       
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                    //EDM-637 END
                }            
                this.existingProducts = parseProducts(existingProductsXmlResponse);
                ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products Response = ' + existingProductsXmlResponse);
                //ApexPages.addMessage(existingProductsResponse);
                
            }
        }           
        return this.existingProducts;                        
    }
    
    // Method populates the potential products bind variable in the address Visualforce page
    public List<ProductItem> getPotentialProducts() {
        System.debug('this.potentialProducts: ' + this.potentialProducts);
        if (this.potentialProducts == null) {
            System.debug('this.currentTab: ' + this.currentTab);
            if (this.currentTab == 'potentialProductsTab') {   
                // If we got this far we need to make the callout            
                System.debug('Going');
                if (this.address != null) {        
                    System.debug('getting potential products'); 
                    //String params = 'AMSAddressId=' + this.address.External_Id__c + ';CustomerNumber=' + '613699841';
                    // String params = 'AMSAddressId=' + this.address.External_Id__c;
                    //EDM-637 START
                    calloutParameter.add('null');
                    Net_Installations__c netInSt = new Net_Installations__c();                    
                    netInSt = clsConnectionUtils_Admin.getInstallationSeq(this.address.External_Id__c, this.address.Cable_type__c);
                    calloutValue.add('G');
                    calloutValue.add(this.address.External_Id__c);
                    if(netInSt != null){
                        calloutValue.add(netInSt.INSTALLATION_ID__c);
                        calloutValue.add(netInSt.Cable_Unit_No__c);
                        // System.debug('params: ' + params);
                        potentialProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.POTENTIAL_PRODUCTS_ADDRESSES_METHOD, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        //EDM-637 END
                        this.potentialProducts = parseProducts(potentialProductsXmlResponse);
                        this.potentialProducts.remove(0);
                    }
                }
            }
        }           
        return this.potentialProducts;                        
    }
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
    public List<ProductItem> getOvernightProducts() {
        
        Map<String, Offer_Name_Template_Mapping__c> templateMappings = Offer_Name_Template_Mapping__c.getAll();
        Offer_Name_Template_Mapping__c templateMapping  = templateMappings.get('Default Offer Name');
        String defaultEmailLink;
        if(templateMapping != null)
            defaultEmailLink = templateMapping.Template_Url__c;
        
        
        if (this.overnightProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                // If we got this far we need to make the callout
                if(this.account != null){
                    //EDM-637 START
                    calloutParameter.add('null');
                    calloutValue.add(this.account.Customer_No__c);
                    overnightProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.OVERNIGHT_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                    ApexPages.Message overnightResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Overnight Response = ' + overnightProductsXmlResponse);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                    //EDM-637 END
                    //ApexPages.addMessage(overnightResponse);
                    this.overnightProducts = parseProducts(overnightProductsXmlResponse);
                    for(productItem overnightProduct:overnightProducts){
                        
                        Offer_Name_Template_Mapping__c emailUrl = templateMappings.get(overnightProduct.getOfferName());
                        if(emailUrl != null)
                            overnightProduct.setScriptUrl(emailUrl.Template_Url__c);
                        else
                            overnightProduct.setScriptUrl(defaultEmailLink);
                    }
                }
                //Testing
                //this.overnightProducts = sampleOffers1; 
            }
        }
        return this.overnightProducts;                   
    } 
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
    public List<ProductItem> getSasProducts() {
        
        if (this.sasProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                // If we got this far we need to make the callout
                //String params = '1;248;cust_test;agentId123';
                if(this.account != null){  
                    Http http = new Http();
                    HttpRequest req = new HttpRequest();        
                    req.setEndpoint(clsConnectionUtils_Admin.getEndPoint(clsConnectionUtils_Admin.SAS_PRODUCTS_CUSTOMERS_METHOD));
                    // Campaign Id + ';' + Agent Id + ';' + Response
                    String body = '1;' + this.account.Street_YK__r.External_Id__c + ';' + this.account.Customer_No__c + ';' + this.user.MID__c;
                    System.debug('body: ' + body);
                    req.setBody(body);
                    req.setHeader('charset', 'utf-8');
                    req.setHeader('accept-encoding', 'gzip');
                    req.setCompressed(true);
                    req.setTimeout(30000);
                    try {
                        HttpResponse res = new HttpResponse();
                        res = http.send(req);
                        sasProductsXmlResponse = res.getBody();
                        ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + sasProductsXmlResponse);
                    }
                    catch (Exception e) {
                        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
                        ApexPages.addMessage(m);
                        return null;
                    }
                    this.sasProducts = parseSasProducts(sasProductsXmlResponse);
                }
                //Testing
                //this.sasProducts = sampleOffers2; 
            }
        }
        return this.sasProducts;                    
    } 
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
    public void populateOfferProducts() {
        if (this.offerProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                
                this.offerProducts = new List<ProductItem>();
                getOvernightProducts();
                getSasProducts();               
                if(this.overnightProducts != null)
                    offerProducts.addAll(this.overnightProducts); 
                if(this.sasProducts != null)
                    offerProducts.addAll(this.sasProducts);
            }
        }            
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
                    campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.CAMPAIGN_HISTORY_CUSTOMERS_METHOD, calloutParameter,calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                } else if (this.lead != null) {
                    calloutParameter.add('null');
                    calloutValue.add(this.lead.Affinium_Id__c + ';' + this.lead.Affinium_Id__c);
                    campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.CAMPAIGN_HISTORY_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
                    //EDM-637 END
                }                                    
                this.campaignHistory = parseCampaignHistory(campaignHistoryXmlResponse);
            }
        }
        return this.campaignHistory;
    }
    
    /* private String callout(String serviceName, String body) {
// Make the callout and check the response  
// EDM-637 start
String bodyText = '';
if(String.isNotBlank(INTEGRATION__c.getInstance(serviceName).Params__c)){
bodyText = INTEGRATION__c.getInstance(serviceName).Params__c;
}
String endpoint = clsConnectionUtils.getEndPoint(serviceName);
if(String.isNotBlank(bodyText))
endpoint = endpoint + '?' + bodyText + '=' + body;

System.debug('******endPoint*****'+endpoint);      
Http http = new Http();
HttpRequest req = new HttpRequest(); 
//req.setMethod('GET');
req.setMethod(String.isBlank(INTEGRATION__c.getInstance(serviceName).HttpMethod__c)?'GET':INTEGRATION__c.getInstance(serviceName).HttpMethod__c);
req.setEndpoint(endpoint);
req.setTimeout(15000);
if(String.isBlank(bodyText)) // bodyText blank indicates that params are not requried for request and hence we are setting the body
req.setBody((body == null ? '' : body));
else{
req.setBody('');
req.setHeader('charset', 'utf-8');
req.setHeader('accept-encoding', 'gzip');
req.setCompressed(true);
req.setTimeout(30000);
}
//EDM-637 End        
HttpResponse res;
try {
res = http.send(req);
System.debug('endpoint: ' + endpoint);
System.debug('res: ' + res);
//ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'http response=' + res);
//ApexPages.addMessage(resValue);

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
        //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'overnight http response=' + XmlResponse);
        //ApexPages.addMessage(resValue);
        
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseProduct(reader);
                        product.setProductType('Overnight');
                        products.add(product);
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
    
    private List<ProductItem> parseSasProducts(String XmlResponse) {        
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'sas http response=' + XmlResponse);
        //ApexPages.addMessage(resValue);
        
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'GETSASINFORMATIONRESPONSE') {
                        ProductItem product = parseSasProduct(reader);
                        product.setProductType('SAS');
                        products.add(product);
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
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    
                    //ApexPages.Message tagValue = new ApexPages.Message(ApexPages.Severity.INFO,'overnight.' + reader.getLocalName());
                    //ApexPages.addMessage(tagValue);
                    
                    if (reader.getLocalName() == 'CUSTOMERID') {
                        reader.next();
                        product.setCustomerId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUBSCRIPTION') {
                        reader.next();
                        product.setSubscription(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ACTIVE') {
                        reader.next();
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
                    } else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
                        reader.next();
                        product.setPrice(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SEQID') {
                        reader.next();
                        product.setSeqId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'URL') {
                        reader.next();
                        product.setScriptURL(checkEmptyElement(reader));                    
                    } else if (reader.getLocalName() == 'STREET') {
                        reader.next();
                        product.setStreet(checkEmptyElement(reader));   
                    } else if (reader.getLocalName() == 'HTMLLINE') {
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));                           
                    } else if (reader.getLocalName() == 'RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == '') {
                            product.setResponse('--None--');
                        } else {
                            product.setResponse(val);
                        }
                    }
                }  
            }
            reader.next();
        }
        return product;
    }
    
    private ProductItem parseSasProduct(XmlStreamReader reader) {
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'GETSASINFORMATIONRESPONSE') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    
                    //ApexPages.Message tagValue = new ApexPages.Message(ApexPages.Severity.INFO,'sas.' + reader.getLocalName());
                    //ApexPages.addMessage(tagValue);
                    
                    if (reader.getLocalName() == 'CUSTOMERID') {
                        reader.next();
                        product.setCustomerId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUBSCRIPTION') {
                        reader.next();
                        product.setSubscription(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ACTIVE') {
                        reader.next();
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
                    } else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
                        reader.next();
                        product.setSasPrice(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SEQID') {
                        reader.next();
                        product.setSeqId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'URL') {
                        reader.next();
                        product.setScriptURL(checkEmptyElement(reader));                    
                    } else if (reader.getLocalName() == 'STREET') {
                        reader.next();
                        product.setStreet(checkEmptyElement(reader));   
                    } else if (reader.getLocalName() == 'HTMLLINE') {
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));                           
                    } else if (reader.getLocalName() == 'LAST_RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == '') {
                            product.setResponse('--None--');
                        } else {
                            product.setResponse(val);
                        }
                    } else if (reader.getLocalName() == 'NAME') {
                        reader.next();
                        product.setResponseName(checkEmptyElement(reader));                           
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
                    }
                }  
            }
            reader.next();
        }
        return campaign;
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
        private String firstName;
        private String lastName;
        private String description;
        private String price;
        private String sasPrice;
        private String seqId;
        private String response;
        private String scriptUrl;
        private String street;
        private String productType;
        private String responseName;
        private String lastResponse;
        
        public String getCustomerId() {
            return customerId;
        }
        
        public void setCustomerId(String cId) {
            this.CustomerId = cId;
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
            if (act == '1') {
                this.active = 'Yes';    
            } else {
                this.active = 'No';
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
                if (p.length() > 0 && Pattern.matches('^[-+]*(?=.*[0-9].*$)\\d{0,7}(?:\\.\\d{0,9})?$', p)) {
                    this.account = new Account(Currency_Format__c=Decimal.valueOf(p));
                    
                }
            }
            
        }
        
        public String getSasPrice() {
            return this.sasPrice;
        }
        
        public void setSasPrice(String p) {
            
            this.sasPrice = p;
            
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
        
        public String getScriptUrl(){
            
            return this.scriptUrl;
        }
        
        public void setScriptUrl(String url){
            
            this.scriptUrl = url;
        }
        
        public String getStreet(){
            
            return this.Street;
        }
        
        public void setStreet(String Street){
            
            this.Street = Street;
        }
        
        public String getProductType(){
            
            return this.productType;
        }
        
        public void setProductType(String productType){
            
            this.productType = productType;
        }
        
        public String getResponseName(){
            
            return this.responseName;
        }
        
        public void setResponseName(String responseName){
            
            this.responseName = responseName;
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
    
    public class CampaignHistoryItem {
        
        public CampaignHistoryItem() {}
        
        private String campaignName;
        private String campaignType;
        private String channel;
        private String effectiveFromDate;
        private String expirationDate;
        private String productGroup;
        
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
        
        
        for (ProductItem product : this.offerProducts) {
            if(product.getProductType() == 'Overnight')
                //integer a =5;
                SendOvernightResponse(product);
            else if(product.getProductType() == 'SAS')
                //integer b =5;
                SendSasResponse(product);
        }
        
    }
    
    public void SendOvernightResponse(ProductItem offerProduct) {
        // Start the callout code
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setTimeout(15000);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint(clsConnectionUtils_Admin.OVERNIGHT_PRODUCTS_RESPONSE_METHOD));
        // Campaign Id + ';' + Agent Id + ';' + Response
        String body = offerProduct.getSeqId() + ';' + this.user.MID__c + ';' + offerProduct.getResponse();
        req.setBody(body);
        // Make the callout and check the response
        
        try {
            HttpResponse res = http.send(req);
            ApexPages.Message overnightResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Overnight Response = ' + res);
            //ApexPages.addMessage(overnightResponse);
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
    
    public void SendSasResponse(ProductItem offerProduct) {
        // Start the callout code
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setTimeout(15000);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint(clsConnectionUtils_Admin.SAS_PRODUCTS_RESPONSE_METHOD));
        // Campaign Id + ';' + Agent Id + ';' + Response
        String body = this.account.Street_YK__r.External_Id__c + ';' + offerProduct.getResponseName() + ';' + this.user.MID__c + ';' + offerProduct.getResponse();         
        req.setBody(body);
        ApexPages.Message sasRequest = new ApexPages.Message(ApexPages.Severity.INFO,'sas Redquest = ' + body);
        //ApexPages.addMessage(sasRequest);
        // Make the callout and check the response
        
        try {
            HttpResponse res = http.send(req);
            ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + res);
            //ApexPages.addMessage(sasResponse);
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
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Customer_No__c = '';
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
        clsProductsYKController_V2 controller = new clsProductsYKController_V2(sc);
        controller.setCurrentTab('existingProductsTab');       
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><BILLINGSTART/><DESCRIPTION/><URL/><STREET/><HTMLLINE/><RESPONSE>test</RESPONSE></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 2);
        System.assertEquals('existingProductsTab', controller.getCurrentTab());
        //System.assertEquals(null, controller.overnightProducts);
        //controller.retrievedExistingProducts = true;
        ProductItem existingProduct1 = controller.getExistingProducts()[0];
        System.assertEquals('604559100', existingProduct1.getCustomerId());
        System.assertEquals('BJARNE', existingProduct1.getFirstName());
        System.assertEquals('PETERSEN', existingProduct1.getLastName());
        System.assertEquals('Fuldpakke', existingProduct1.getSubscription());
        System.assertEquals('1', existingProduct1.getBusinessGroup());
        System.assertEquals('Yes', existingProduct1.getActive());
        existingProduct1.getBillingEnd();
        //System.assertEquals(500, existingProduct1.getAccount().Currency_Format__c);
        
        ProductItem existingProduct2 = controller.getExistingProducts()[1];
        System.assertEquals('604559100', existingProduct2.getCustomerId());
        System.assertEquals('BJARNE', existingProduct2.getFirstName());
        System.assertEquals('PETERSEN', existingProduct2.getLastName());
        System.assertEquals('Bredbånd 10 Mbit/1 Mbit', existingProduct2.getSubscription());
        System.assertEquals('3', existingProduct2.getBusinessGroup());
        System.assertEquals('Yes', existingProduct2.getActive());
        System.assertEquals('', existingProduct2.getBillingEnd());
        //System.assertEquals(1000, existingProduct2.getAccount().Currency_Format__c);
        
        controller.existingProductsXmlResponse = null;
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 0);
        
        controller.updateOfferProducts();
        controller.overnightProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>999</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE>2009-04-28T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2009-05-15T00:00:00.000</EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>998</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle2</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle2</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.overnightProducts = controller.parseProducts(controller.overnightProductsXmlResponse);        
        System.assertEquals(controller.overnightProducts.size(), 2);
        System.assertEquals('offerProductsTab', controller.getCurrentTab());
        System.assertEquals(null, controller.campaignHistory);
        
        ProductItem overnightProduct1 = controller.getOvernightProducts()[0];
        controller.submitResponses();
        System.assertEquals('Overnight Bundle', overnightProduct1.getOfferName());
        overnightProduct1.getEffectiveFromDate();
        overnightProduct1.getExpirationDate();
        //System.assertEquals('Webspeed', overnightProduct1.getProduct1());
        //System.assertEquals('Internet', overnightProduct1.getProductGroup1());
        System.assertEquals('--None--', overnightProduct1.getResponse());
        
        ProductItem overnightProduct2 = controller.getOvernightProducts()[1];
        System.assertEquals('Overnight Bundle2', overnightProduct2.getOfferName());
        System.assertEquals('', overnightProduct2.getEffectiveFromDate());
        System.assertEquals('', overnightProduct2.getExpirationDate());
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
        campaignHistory1.getEffectiveFromDate();
        campaignHistory1.getExpirationDate();
        System.assertEquals('DigitalTV', campaignHistory1.getProductGroup());
        
        CampaignHistoryItem campaignHistory2 = controller.getCampaignHistory()[1];
        System.assertEquals('Premiere september', campaignHistory2.getCampaignName());
        System.assertEquals('Sales Campaigns', campaignHistory2.getCampaignType());
        System.assertEquals('Email', campaignHistory2.getChannel());
        System.assertEquals('', campaignHistory2.getEffectiveFromDate());
        System.assertEquals('', campaignHistory2.getExpirationDate());
        System.assertEquals('DigitalTV', campaignHistory2.getProductGroup());
        
        // Get a handle on controller with address as focus record
        sc = new ApexPages.StandardController(add);     
        controller = new clsProductsYKController_V2(sc);               
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.getExistingProducts().size(), 2);
        controller.updatePotentialProducts();
        controller.potentialProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.potentialProducts = controller.parseProducts(controller.potentialProductsXmlResponse);
        System.assertEquals(controller.getPotentialProducts().size(), 2);
        
        // Get a handle on controller with lead as focus record
        sc = new ApexPages.StandardController(l);       
        controller = new clsProductsYKController_V2(sc);               
        controller.campaignHistoryXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>14411011</SEQID><OFFERTRACKID>959</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere Maj 2008</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000176</CAMPAIGNCODE><OFFERCODE>KO_000171</OFFERCODE><OFFERNAME>Premiere</OFFERNAME><OFFERVERSIONCODE>V181</OFFERVERSIONCODE><OFFERVERSIONNAME>maj 2008</OFFERVERSIONNAME><TRACKINGCODE>000000959</TRACKINGCODE><CELLCODE>A575</CELLCODE><CAMPAIGNTYPE>Upsale</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-05-13T00:00:00.000</CONTACTDATE><RUNDATE>05/13/2008</RUNDATE><EFFECTIVEFROMDATE>2008-05-13T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2008-05-31T00:00:00.000</EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>14738818</SEQID><OFFERTRACKID>1218</OFFERTRACKID><BUSINESSPARTYID>0003202365</BUSINESSPARTYID><CABLEUNITID>0005006055</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>2601469089</ZAPADDRESSID><CAMPAIGNNAME>Premiere september</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000211</CAMPAIGNCODE><OFFERCODE>KO_000278</OFFERCODE><OFFERNAME>Premiere september</OFFERNAME><OFFERVERSIONCODE>V309</OFFERVERSIONCODE><OFFERVERSIONNAME>Tekst_Læs mere</OFFERVERSIONNAME><TRACKINGCODE>000001218</TRACKINGCODE><CELLCODE>A847</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>DigitalTV</PRODUCT_GROUP><PRODUCT1>Selector HD</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2008-09-03T00:00:00.000</CONTACTDATE><RUNDATE>09/03/2008</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Email</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        //controller.retrievedCampaignHistory = true;
        System.assertEquals(controller.getCampaignHistory().size(), 2);
        
        sc = new ApexPages.StandardController(l); 
        controller = new clsProductsYKController_V2(sc); 
        
        controller.getDisplayOvernight();
        ProductItem pi1 = new ProductItem();
        controller.overnightProducts = new ProductItem[]{};
            controller.getDisplayOvernight();
        controller.overnightProducts.add(pi1);
        controller.getDisplayOvernight();
        
        controller.getDisplaySAS();
        ProductItem pi2 = new ProductItem();
        controller.sasProducts = new ProductItem[]{};
            controller.getDisplaySAS();
        controller.sasProducts.add(pi2);
        controller.getDisplaySAS();
        
        controller.getDisplayOffers();
        controller.getDisplayNoOffers();
        
        controller.account = acc;
        controller.address = add; 
        controller.updateExistingProducts();
        
        String sampleSASResponse = 
            '<GETSASINFORMATIONRESPONSE>' +
            '<CUSTOMERID/><ACTIVE/><BILLINGSTART/>' + 
            '<HTMLLINE>Default answer  for test</HTMLLINE>' +
            '<STREET>Ole Borchs Vej 48 2500 DK</STREET>' +
            '<INSTLBNR/>' +
            '<SCORE>0.02409639</SCORE>' +
            '<ADDRESSID>248</ADDRESSID>' +
            '<OFFERNAME>BB_CHURN</OFFERNAME>' +
            '<URL>http://spcsastgltst01/cishome/WEB/SPOCPAGE/Default.html</URL>' +
            '<SUBSCRIPTION>KTV,BB,DKTV,T</SUBSCRIPTION>' +
            '<EFFECTIVEFROMDATE/>' +
            '<EXPIRATIONDATE/>' +
            '<BUSINESS_GROUP/>' +
            '<businessArea/>' +
            '<FIRSTNAME/>' +
            '<LASTNAME/>' +
            '<DESCRIPTION/>' +
            '<PRICE/>' +
            '<totalPrice/>' +
            '<SEQID/>' +
            '<URL/>' +
            '<STREET/>' +
            '<HTMLLINE/>' +
            '<LAST_RESPONSE/>' +
            '</GETSASINFORMATIONRESPONSE>';
        
        controller.sasProducts = controller.parseSasProducts(sampleSASResponse);
        controller.getItems();
        controller.SendSasResponse(new ProductItem());
        controller.SendOvernightResponse(new ProductItem());
        ProductItem pg = new ProductItem();
        pg.getBillingStart();
        pg.getDescription();
        pg.getSasPrice();
        pg.getAccount();
        pg.getScriptUrl();
        pg.getStreet();
        pg.getProductType();
        pg.setResponseName('test');
        
    }
}