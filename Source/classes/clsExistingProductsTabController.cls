public with sharing class clsExistingProductsTabController{
   //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private User user;
    private Account account;
    private ProductItem[] existingProducts;
    private String existingProductsXmlResponse;
    private String overnightProductsXmlResponse;    

    private List<SelectOption> items;
    
    public static String STATUS_NONE = '--None--';
    public static String STATUS_ACCEPTERET = 'Accepteret';
    public static String STATUS_OVERVEJER = 'Overvejer';
    public static String STATUS_AFSLAET = 'Afslået';
    
    public clsExistingProductsTabController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
    }

    public PageReference pageAction(){
        if (this.account != null) {
            updateExistingProducts();
        }
        return null;
    }

    public PageReference updateExistingProducts() {
        getExistingProducts();
        return null;
    }

    // Method populates the existing products bind variable in the account and address Visualforce pages
    public List<ProductItem> getExistingProducts() {
                
        if (this.existingProducts == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,this.currentTab));
                
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products'));
    
            // If we got this far we need to make the callout            
            // Set the parameters based upon the page the user is viewing
            
            if (this.account != null) {
                //EDM-637 START
                calloutParameter.add('null');
                calloutValue.add(this.account.Customer_No__c);
                existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
            //EDM-637 END
            }            
            this.existingProducts = parseProducts(existingProductsXmlResponse);
            ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products Response = ' + existingProductsXmlResponse);
            //ApexPages.addMessage(existingProductsResponse);
        }           
        return this.existingProducts;                        
    }

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
        
        public Integer Index{get; private set;} 
        
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


    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {            
            return reader.getText();
        }       
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
    
    
    public List<SelectOption> getItems() {
        if (this.items == null) {
            this.items = new List<SelectOption>();
            this.items.add(new SelectOption(STATUS_NONE,STATUS_NONE));
            this.items.add(new SelectOption(STATUS_ACCEPTERET,STATUS_ACCEPTERET));
            this.items.add(new SelectOption(STATUS_OVERVEJER,STATUS_OVERVEJER));
            this.items.add(new SelectOption(STATUS_AFSLAET,STATUS_AFSLAET));
        }
        return this.items;
    }

   static testMethod void testDisplayCustomer() {
       INTEGRATION__c inte1 = new INTEGRATION__c();
        inte1.Name = 'YK7Inbound';
        inte1.HttpMethod__c = 'GET';
        inte1.IsBodyAppended__c = true;
        inte1.Service__c = 'END_POINT_YOUPROD2';
        inte1.Params__c = null;
        insert inte1; 
       // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Salesproposal__c sp = new Salesproposal__c();
        sp.CustomerID__c = acc.Customer_No__c;
        sp.Description__c = 'test text';
        sp.Name = 'tv';
        sp.SFID__c = '0012';
        sp.SFIDORIG__c = '0012';
        sp.RESPTracking_CD__c = '1200';
        DateTime dt = System.now();
        Date myDate = Date.newInstance(dt.year(), dt.month(), dt.day());
        sp.Effective_From_Date__c = myDate;
        sp.Expiration_Date__c = myDate;
        insert sp;
            
        // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsExistingProductsTabController controller = new clsExistingProductsTabController(sc);
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>BredbÃƒÆ’Ã‚Â¥nd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><BILLINGSTART/><DESCRIPTION/><URL/><STREET/><HTMLLINE/><RESPONSE>test</RESPONSE></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 2);
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
        System.assertEquals('BredbÃƒÆ’Ã‚Â¥nd 10 Mbit/1 Mbit', existingProduct2.getSubscription());
        System.assertEquals('3', existingProduct2.getBusinessGroup());
        System.assertEquals('Yes', existingProduct2.getActive());
        System.assertEquals('', existingProduct2.getBillingEnd());
        //System.assertEquals(1000, existingProduct2.getAccount().Currency_Format__c);
        
        controller.existingProductsXmlResponse = null;
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 0);
       
        controller.updateExistingProducts();
        controller.pageAction();
        ProductItem pg = new ProductItem();
        pg.Index = 0;
        pg.getBillingStart();
        pg.getOfferName();
        pg.setOfferName('test');
        pg.getEffectiveFromDate();
        pg.setEffectiveFromDate('test');
        pg.getExpirationDate();
        pg.setExpirationDate('test');
        pg.getDescription();
        pg.getSasPrice();
        pg.setSasPrice('test');
        pg.getSeqId();
        pg.setSeqId('test');
        pg.getResponse();
        pg.getAccount();
        pg.getScriptUrl();
        pg.getStreet();
        pg.getProductType();
        pg.getResponseName();
        pg.setResponseName('test');
        
        controller.getItems();
    }
}