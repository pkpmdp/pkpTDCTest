public with sharing class clsConsoleSaleTabController{
   	private User user;
    private Account account;
    private ProductItem[] existingProducts;
    private List<Salesproposal__c> overnightProducts;
    private ProductItem[] sasProducts;    
    private String existingProductsXmlResponse;
    private String overnightProductsXmlResponse;    
    private String sasProductsXmlResponse;
	//EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private List<SelectOption> items;
    public static String STATUS_NONE = '--None--';
    public static String STATUS_ACCEPTERET = 'Accepteret';
    public static String STATUS_OVERVEJER = 'Overvejer';
    public static String STATUS_AFSLAET = 'Afslået';
    public clsConsoleSaleTabController(ApexPages.StandardController controller){
        this.account = (Account) controller.getRecord();
    }
	public PageReference pageAction(){
        if (this.account != null) {
            updateExistingProducts();
            updateOfferProducts();
            updateEmptyCustomerResponse();
        }
        return null;
    }
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
        System.debug('wen debug overnight'+ getDisplayOvernight() + 'debug sas' + getDisplaySAS());
        return getDisplayOvernight() || getDisplaySAS();
     }
     public Boolean getDisplayNoOffers(){       
        return !getDisplayOffers();
     }
     public PageReference updateOfferProducts(){
        getOvernightProducts();
        //getSasProducts();  
        return null;
    }
	public PageReference updateExistingProducts(){
        getExistingProducts();
        return null;
    }
    public PageReference updateEmptyCustomerResponse(){
    /*
    If we will check Product Offers Tab this value Customer_Response__c="" than
    will be changed (updated) to Customer_Response__c="--None--" for viewed customerNo
    */
        if(this.account != null){
            for (Salesproposal__c props : [Select  s.Customer_Response__c
                from Salesproposal__c s where s.CustomerID__c
                =: this.account.Customer_No__c AND s.Is_Responded__c = 'No'
                AND s.Customer_Response__c = '']){
                    props.Customer_Response__c = STATUS_NONE;                     
                    update props;
             }
        }
        return null;
    }
// Method populates the existing products bind variable in the account and address Visualforce pages
    public List<ProductItem> getExistingProducts(){
        if (this.existingProducts == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,this.currentTab));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products'));
    		// If we got this far we need to make the callout            
            // Set the parameters based upon the page the user is viewing
            if (this.account != null) {
                 //EDM-637 START
                calloutparameter.add('null');
                calloutValue.add(this.account.Customer_No__c);
                // added to change the pointing of YK7 inbound callout from CI to JITTERBIT.
                existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                calloutParameter = new List<String>();
                calloutValue = new List<string>();
            //EDM-637 END
            }            
            this.existingProducts = parseProducts(existingProductsXmlResponse);
            ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products Response = ' + existingProductsXmlResponse);
            //ApexPages.addMessage(existingProductsResponse);
        }           
        return this.existingProducts;                        
    }
	public PageReference saveStatus(){
      string parID = ApexPages.CurrentPage().getParameters().get('op_id');      
      for (Salesproposal__c prod : this.overnightProducts){
        if (prod.Id == parID){
            prod.Customer_Response__c = ApexPages.CurrentPage().getParameters().get('op_type');
            update prod;
            //system.debug('saveStatus: ' + prod.Customer_Response__c + ' : ' + parID);             
            break;
        }
      }
      LoadOvernightProducts();
      return null;
    }
    public string getStatusNone(){
      return STATUS_NONE;
    }
    private void LoadOvernightProducts(){
      if(this.account != null){                                    
        this.overnightProducts = [Select s.Street_Name__c, s.Customer_Response__c, s.RESPTracking_CD__c, s.Price__c, s.OwnerId, s.Name, s.LastModifiedDate, s.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, s.Expiration_Date__c, s.Effective_From_Date__c, s.Description__c, s.Description_URL__c, s.CustomerID__c, s.CreatedDate, s.CreatedById, s.Campaign_Name__c, s.AMSNo__c, s.Priority__c from Salesproposal__c s where s.CustomerID__c =: this.account.Customer_No__c AND s.Is_Responded__c = 'No' ORDER BY Priority__c DESC LIMIT 3 ];
      }
    }
    public List<Salesproposal__c> getOvernightProducts() {
        if (this.overnightProducts == null) {   
            LoadOvernightProducts();
        }
        return this.overnightProducts;
    }
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
   public List<ProductItem> getSasProducts() {        
        if (this.sasProducts == null) {   
            // If we got this far we need to make the callout
            //String params = '1;248;cust_test;agentId123';
             if(this.account != null){  
                String params = '1;' + this.account.Street_YK__r.External_Id__c + ';' + this.account.Customer_No__c + ';' + this.user.MID__c;
                System.debug('params: ' + params);                
                sasProductsXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.New_SAS_PRODUCTS_CUSTOMERS_METHOD, params);
                ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + sasProductsXmlResponse);
                //ApexPages.addMessage(sasResponse);
                this.sasProducts = parseSasProducts(sasProductsXmlResponse);                
            }
            //Testing
            //String str1 = '<GETSASINFORMATIONRESPONSE> <CUSTOMERID>621580039</CUSTOMERID> <ACTIVE>YES</ACTIVE> <BILLINGSTART/> <HTMLLINE>Default answer for test</HTMLLINE> <STREET>Ole Borchs Vej 48 2500 DK</STREET> <INSTLBNR/> <SCORE>0.02409639</SCORE> <ADDRESSID>248</ADDRESSID> <OFFERNAME>BB_CHURN</OFFERNAME> <URL>http://spcsastgltst01/cishome/WEB/SPOCPAGE/Default.html</URL> <SUBSCRIPTION>KTV,BB,DKTV,T</SUBSCRIPTION> <EFFECTIVEFROMDATE/> <EXPIRATIONDATE/> <BUSINESS_GROUP/> <businessArea/> <FIRSTNAME>Thorleif</FIRSTNAME> <LASTNAME>Larsen</LASTNAME> <DESCRIPTION>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas bibendum adipiscing gravida. Nulla vestibulum euismod turpis, at tempus dolor tincidunt mollis. Etiam dignissim lorem a ante pulvinar ac iaculis arcu euismod. Nulla luctus, justo vel vehicu</DESCRIPTION> <PRICE>99</PRICE> <totalPrice/> <SEQID/> <URL/> <LAST_RESPONSE/> </GETSASINFORMATIONRESPONSE>';
            //this.sasProducts = parseSasProducts(str1); 
        }
        return this.sasProducts;                    
    } 
    private List<ProductItem> parseProducts(String XmlResponse){       
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'overnight http response=' + XmlResponse);
        //ApexPages.addMessage(resValue);            
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()){
                if (reader.getEventType() == XmlTag.START_ELEMENT){
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseProduct(reader);
                        product.setProductType('Overnight');
                        products.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e){
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return products;
        }
        return products;
    }    
    private List<ProductItem> parseSasProducts(String XmlResponse){        
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'sas http response=' + XmlResponse);
        //ApexPages.addMessage(resValue);         
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT){
                    if (reader.getLocalName() == 'GETSASINFORMATIONRESPONSE'){
                        ProductItem product = parseSasProduct(reader);
                        product.setProductType('SAS');
                        product.Index = products.size();
                        products.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e){
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return products;
        }
        return products;
    }   
    private ProductItem parseProduct(XmlStreamReader reader){
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT){
                if (reader.getLocalName() == 'row'){
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT){                   
                    //ApexPages.Message tagValue = new ApexPages.Message(ApexPages.Severity.INFO,'overnight.' + reader.getLocalName());
                    //ApexPages.addMessage(tagValue);                    
                    if (reader.getLocalName() == 'CUSTOMERID'){
                        reader.next();
                        product.setCustomerId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUBSCRIPTION'){
                        reader.next();
                        product.setSubscription(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ACTIVE'){
                        reader.next();
                        product.setActive(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGSTART'){
                        reader.next();
                        product.setBillingStart(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGEND'){
                        reader.next();
                        product.setBillingEnd(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'OFFERNAME') || (reader.getLocalName() == 'productShortName')) {
                        reader.next();
                        product.setOfferName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EFFECTIVEFROMDATE'){
                        reader.next();
                        product.setEffectiveFromDate(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EXPIRATIONDATE'){
                        reader.next();
                        product.setExpirationDate(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'BUSINESS_GROUP') || (reader.getLocalName() == 'businessArea')) {
                        reader.next();
                        product.setBusinessGroup(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'FIRSTNAME'){
                        reader.next();
                        product.setFirstName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'LASTNAME'){
                        reader.next();
                        product.setLastName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'DESCRIPTION') {
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
                        reader.next();
                        product.setPrice(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SEQID'){
                        reader.next();
                        product.setSeqId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'URL'){
                        reader.next();
                        product.setScriptURL(checkEmptyElement(reader));                    
                    } else if (reader.getLocalName() == 'STREET'){
                        reader.next();
                        product.setStreet(checkEmptyElement(reader));   
                    } else if (reader.getLocalName() == 'HTMLLINE'){
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));                           
                    } else if (reader.getLocalName() == 'RESPONSE'){
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

    private ProductItem parseSasProduct(XmlStreamReader reader){
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT){
                if (reader.getLocalName() == 'GETSASINFORMATIONRESPONSE'){
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {                   
                    //ApexPages.Message tagValue = new ApexPages.Message(ApexPages.Severity.INFO,'sas.' + reader.getLocalName());
                    //ApexPages.addMessage(tagValue);                    
                    if (reader.getLocalName() == 'CUSTOMERID'){
                        reader.next();
                        product.setCustomerId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUBSCRIPTION'){
                        reader.next();
                        product.setSubscription(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ACTIVE'){
                        reader.next();
                        product.setActive(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGSTART'){
                        reader.next();
                        product.setBillingStart(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'BILLINGEND'){
                        reader.next();
                        product.setBillingEnd(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'OFFERNAME') || (reader.getLocalName() == 'productShortName')) {
                        reader.next();
                        product.setOfferName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EFFECTIVEFROMDATE'){
                        reader.next();
                        product.setEffectiveFromDate(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'EXPIRATIONDATE'){
                        reader.next();
                        product.setExpirationDate(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'BUSINESS_GROUP') || (reader.getLocalName() == 'businessArea')) {
                        reader.next();
                        product.setBusinessGroup(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'FIRSTNAME'){
                        reader.next();
                        product.setFirstName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'LASTNAME'){
                        reader.next();
                        product.setLastName(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'DESCRIPTION'){
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));
                    } else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
                        reader.next();
                        product.setSasPrice(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SEQID'){
                        reader.next();
                        product.setSeqId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'URL'){
                        reader.next();
                        product.setScriptURL(checkEmptyElement(reader));                    
                    } else if (reader.getLocalName() == 'STREET'){
                        reader.next();
                        product.setStreet(checkEmptyElement(reader));   
                    } else if (reader.getLocalName() == 'HTMLLINE'){
                        reader.next();
                        product.setDescription(checkEmptyElement(reader));                           
                    } else if (reader.getLocalName() == 'LAST_RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == ''){
                            product.setResponse('--None--');
                        } else {
                            product.setResponse(val);
                        }
                    } else if (reader.getLocalName() == 'NAME'){
                        reader.next();
                        product.setResponseName(checkEmptyElement(reader));                           
                    } 
                }  
            }
            reader.next();
        }
        return product;
    }

    public class ProductItem{        
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
        public String getCustomerId(){
            return customerId;
        }            
        public void setCustomerId(String cId){
            this.CustomerId = cId;
        }
        public String getSubscription(){
            return this.subscription;
        }           
        public void setSubscription(String sub){
            this.subscription = sub;
        }       
        public String getActive(){
            return this.active;
        }          
        public void setActive(String act){
            if (act == '1'){
                this.active = 'Yes';    
            } else {
                this.active = 'No';
            }
        }       
        public String getBillingStart(){
            return this.billingStart;
        }
            
        public void setBillingStart(String billingStart){
            this.billingStart = formatDate(billingStart);            
        }
                
        public String getBillingEnd(){
            return this.billingEnd;
        }
            
        public void setBillingEnd(String billingEnd){
            this.billingEnd = formatDate(billingEnd);            
        }        
        public String getOfferName(){
            return this.offerName;
        }            
        public void setOfferName(String off){
            this.offerName = off;
        }
        public String getEffectiveFromDate(){
            return this.effectiveFromDate;
        }           
        public void setEffectiveFromDate(String effectiveFromDate){
            this.effectiveFromDate = formatDate(effectiveFromDate);            
        }
        public String getExpirationDate(){
            return this.expirationDate;
        }            
        public void setExpirationDate(String expirationDate){
            this.expirationDate = formatDate(expirationDate);    
        }
        public String getBusinessGroup(){
            return this.businessGroup;
        }            
        public void setBusinessGroup(String bg){
            this.businessGroup = bg;
        }
        public String getFirstName(){
            return this.firstName;
        }            
        public void setFirstName(String fn){
            this.firstName = fn;
        }
        public String getLastName(){
            return this.lastName;
        }           
        public void setLastName(String ln){
            this.lastName = ln;
        }       
        public String getDescription(){
            return this.description;
        }           
        public void setDescription(String descr){
            this.description = descr;
        }       
        public void setPrice(String p){            
            if (p != null) {
                if (p.length() > 0 && Pattern.matches('^[-+]*(?=.*[0-9].*$)\\d{0,7}(?:\\.\\d{0,9})?$', p)) {
                    this.account = new Account(Currency_Format__c=Decimal.valueOf(p));                   
                }
            }            
        }        
        public String getSasPrice(){
            return this.sasPrice;
        }        
        public void setSasPrice(String p){           
            this.sasPrice = p;            
        }       
        public String getSeqId(){
            return this.seqId;
        }           
        public void setSeqId(String sid){
            this.seqId = sid;
        }               
        public String getResponse(){
            return this.response;
        }
        public void setResponse(String r){
            this.response = r;
        }                  
        public Account getAccount(){
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
        private String formatDate(String strDate){
            try {
                Date dt = Date.valueOf(strDate);
                return dt.format();
            } catch(Exception e) {
                return '';
            }
        }
    }
    private String checkEmptyElement(XmlStreamReader reader){
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {            
            return reader.getText();
        }       
    }  
    private String callout(String endpoint, String body){
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));
        req.setTimeout(15000);        
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
    public PageReference saveSASResponse(){
        Integer parIndex = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('op_id'));       
        if (this.sasProducts != null && this.sasProducts.size() > parIndex){
            this.sasProducts[parIndex].Response = ApexPages.CurrentPage().getParameters().get('op_type');
            SendSasResponse(this.sasProducts[parIndex]);
            this.sasProducts = null;
            this.sasProducts = this.getSasProducts();
        }
        return null;
    }      
    public void SendSasResponse(ProductItem offerProduct) {
        // Start the callout code
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setTimeout(15000);
        req.setEndpoint(clsConnectionUtils.END_POINT + clsConnectionUtils.New_SAS_PRODUCTS_RESPONSE_METHOD);
        // Campaign Id + ';' + Agent Id + ';' + Response
        String body = this.account.Street_YK__r.External_Id__c + ';' + offerProduct.getResponseName() + ';' + this.user.MID__c + ';' + offerProduct.getResponse()+';'+ this.account.Customer_No__c;         
        req.setBody(body);
        ApexPages.Message sasRequest = new ApexPages.Message(ApexPages.Severity.INFO,'sas Redquest = ' + body);
        //ApexPages.addMessage(sasRequest);
        // Make the callout and check the response
        try {
            HttpResponse res = http.send(req);
            ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + res);
            //ApexPages.addMessage(sasResponse);
            System.debug('send sas response' + res);
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
            this.items.add(new SelectOption(STATUS_NONE,STATUS_NONE));
            this.items.add(new SelectOption(STATUS_ACCEPTERET,STATUS_ACCEPTERET));
            this.items.add(new SelectOption(STATUS_OVERVEJER,STATUS_OVERVEJER));
            this.items.add(new SelectOption(STATUS_AFSLAET,STATUS_AFSLAET));
        }
        return this.items;
    }
    
//-------------------------------------------------------------------
 private List<DisplayAddress> addresses;
public List<DisplayAddress> getAddresses(){
        List<Customer_Related_Address__c> relatedAddresses = [select Installation_Address__c, Juridical_Address__c, Payer_Address__c, Installations_Status__c, Cable_Type__c from Customer_Related_Address__c where Customer__c=:account.id];
        return populateDisplayAddressList(relatedAddresses);
    }
  private List<DisplayAddress> populateDisplayAddressList(List<Customer_Related_Address__c> relatedAddresses){
   List<DisplayAddress> result = new List<DisplayAddress>();
        List<DisplayAddress> installAddr = new List<DisplayAddress>();
        List<DisplayAddress> juridicAddr = new List<DisplayAddress>();
        List<DisplayAddress> payerAddr = new List<DisplayAddress>();
        List<DisplayAddress> usageAddr = new List<DisplayAddress>();
 List<String> addressIDs = new List<String>();
 for(Customer_Related_Address__c relatedAddress:relatedAddresses){
              if (relatedAddress.Installation_Address__c!=null){
                addressIDs.add(relatedAddress.Installation_Address__c);
            }
            if (relatedAddress.Juridical_Address__c!=null){
                addressIDs.add(relatedAddress.Juridical_Address__c);
            }
            if (relatedAddress.Payer_Address__c!=null){
                addressIDs.add(relatedAddress.Payer_Address__c);
            }
        }
      List<Address__c> addresses = [select Id, Name , Street__c, Full_Address__c , Cableunit_number__c from Address__c where Id IN :addressIDs];
  for(Customer_Related_Address__c relatedAddress:relatedAddresses){
            if (relatedAddress.Installation_Address__c!=null){
                installAddr.add(new DisplayAddress(relatedAddress.Installation_Address__c,Label.Customer_Address_Type_Installation,relatedAddress.Installations_Status__c,relatedAddress.Cable_Type__c, addresses));
            }
            if (relatedAddress.Juridical_Address__c!=null){
                juridicAddr.add(new DisplayAddress(relatedAddress.Juridical_Address__c,Label.Customer_Address_Type_Legal,null,null,addresses));
            }
            if (relatedAddress.Payer_Address__c!=null){
                payerAddr.add(new DisplayAddress(relatedAddress.Payer_Address__c,Label.Customer_Address_Type_Billing,null,null,addresses));
            }
            /*
            if (relatedAddress.Usage_Address__c!=null){
                usageAddr.add(new DisplayAddress(relatedAddress.Usage_Address__c,Label.Customer_Address_Type_User));
            }*/
        }
     Account acc = [select Id, Street_YK__c From Account where Id=:account.Id];
        if(juridicAddr.size() == 0){
            List<Address__c> addressesJur = [select Id, Name, Full_Address__c, Cable_type__c, Anaeleg_Status__c, Street__c From Address__c where Id=:acc.Street_YK__c];
            if(addressesJur.size() > 0){
                juridicAddr.add(new DisplayAddress(addressesJur[0].Id,Label.Customer_Address_Type_Legal,null,null,addressesJur));  
            }
        }
        if(installAddr.size() == 0){
            List<Customer_Installation_Address__c> cias = [Select Id, Address__c, Customer__c, Installations_Status__c, LastModifiedDate From Customer_Installation_Address__c where Address__c=:acc.Street_YK__c order by LastModifiedDate desc];
             if(cias.size() > 0){
                Customer_Installation_Address__c cia = cias[0];
                Address__c address = [select Id, Name, Full_Address__c, Cable_type__c, Cableunit_number__c From Address__c where Id=:cia.Address__c];
                DisplayAddress dia = new DisplayAddress();
                dia.address = address;
                dia.addressType=Label.Customer_Address_Type_Installation;
                dia.installationsStatus = cia.Installations_Status__c;
                dia.cableType = address.Cable_type__c;
                dia.cableUnitNo = address.Cableunit_number__c;
                installAddr.add(dia);
            } 
        }
     result.addAll(installAddr);
        result.addAll(juridicAddr);
        result.addAll(payerAddr);
        result.addAll(usageAddr);
        return result;
    }
   public class DisplayAddress {
        public DisplayAddress(){
       }
 public DisplayAddress(String addressId,String addressType,String installationsStatus, String cableType, List<Address__c> addresses){
            this.address = getAddressFromList(addresses,addressId);
            this.addressType=addressType;
            this.installationsStatus = installationsStatus;
            this.cableType = cableType;
            //this.cableUnitNo = cableUnitNo;
            setCableUnitNo();
        }
       private Address__c getAddressFromList(List<Address__c> addresses,String addressId){
             for(Address__c address:addresses){
                 if(address.Id == addressId){
                     return address;
                 }
             }
             return null;
        }
         private void setCableUnitNo(){
          this.cableUnitNo = (this.address != null && 
            addressType==Label.Customer_Address_Type_Installation) ?  
              this.address.Cableunit_number__c : null;           
        }
         public Address__c address {get;set;}
        public String addressType {get;set;}
        public String installationsStatus{get;set;}
        public String cableType{get;set;}
        public String cableUnitNo{get;set;}
   }         
 static testMethod void testDisplayCustomer() {
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
        /*
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
       */
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
        clsConsoleSaleTabController controller = new clsConsoleSaleTabController(sc);
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>BredbÃƒÆ’Ã‚Â¥nd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><BILLINGSTART/><DESCRIPTION/><URL/><STREET/><HTMLLINE/><RESPONSE>test</RESPONSE></row></rows><OFFERNAME></OFFERNAME>';
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
      controller.SendSasResponse(existingProduct1);
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
       controller.updateOfferProducts();
        //controller.overnightProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>999</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE>2009-04-28T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2009-05-15T00:00:00.000</EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>998</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle2</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle2</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.overnightProducts = controller.getOvernightProducts();        
        System.assertEquals(controller.overnightProducts.size(), 1);
/*        sc = new ApexPages.StandardController(l); 
        controller = new clsConsoleSaleTabController(sc); 
*/  controller.getDisplayOvernight();
        Salesproposal__c pi1 = new Salesproposal__c();
        controller.overnightProducts = new List<Salesproposal__c>();
        controller.getDisplayOvernight();
        controller.overnightProducts.add(pi1);
        controller.getDisplayOvernight();
        controller.getDisplaySAS();
        ProductItem pi2 = new ProductItem();
        controller.sasProducts = new ProductItem[]{};
        controller.getDisplaySAS();
        controller.sasProducts.add(pi2);
        controller.getDisplaySAS();
        controller.getSasProducts();
       controller.getDisplayOffers();
        controller.getDisplayNoOffers();
        controller.account = acc;
        controller.updateExistingProducts();
        controller.pageAction();    
        String a = '';
      //   controller.getBillingStart('');
       //   controller.saveSASResponse();
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
        ApexPages.currentPage().getParameters().put('op_type', clsConsoleSaleTabController.STATUS_ACCEPTERET);
        ApexPages.currentPage().getParameters().put('op_id', '1234456'); 
        controller.saveSASResponse();
    }
    static testMethod void testDisplayCustomer_RPA_CR() {                
        Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        Account acc = new Account(Name = 'Test Account 1', Street_YK__c = add.Id, Customer_No__c = '123456789');
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc;
         Salesproposal__c sp1 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0011', SFIDORIG__c = '0011', RESPTracking_CD__c = '1100', Customer_Response__c = clsConsoleSaleTabController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 1);
        Salesproposal__c sp2 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0012', SFIDORIG__c = '0012', RESPTracking_CD__c = '1200', Customer_Response__c = clsConsoleSaleTabController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 2);
        Salesproposal__c sp3 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0013', SFIDORIG__c = '0013', RESPTracking_CD__c = '1300', Customer_Response__c = clsConsoleSaleTabController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 3);
        insert new Salesproposal__c[]{sp1, sp2, sp3};
        clsConsoleSaleTabController ctrlRPA = new clsConsoleSaleTabController(new ApexPages.StandardController(acc));
        system.assert(ctrlRPA.getStatusNone() == clsConsoleSaleTabController.STATUS_NONE);        
       ctrlRPA.updateOfferProducts();
        List<Salesproposal__c> lst2 = ctrlRPA.getOvernightProducts();
        system.assert(lst2 != null && lst2.size() == 3);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsConsoleSaleTabController.STATUS_ACCEPTERET);
        ApexPages.currentPage().getParameters().put('op_id', sp1.Id);  
        system.assert(sp1.Customer_Response__c == clsConsoleSaleTabController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        system.assert(lst2 != null && lst2.size() == 2);
        sp1 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp1.Id];
        system.assert(sp1.Customer_Response__c == clsConsoleSaleTabController.STATUS_ACCEPTERET);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsConsoleSaleTabController.STATUS_OVERVEJER);
        ApexPages.currentPage().getParameters().put('op_id', sp2.Id);
        system.assert(sp2.Customer_Response__c == clsConsoleSaleTabController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        system.assert(lst2 != null && lst2.size() == 2);
        sp2 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp2.Id];
        system.assert(sp2.Customer_Response__c == clsConsoleSaleTabController.STATUS_OVERVEJER);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsConsoleSaleTabController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().put('op_id', sp3.Id);
        system.assert(sp3.Customer_Response__c == clsConsoleSaleTabController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        system.assert(lst2 != null && lst2.size() == 1);
        sp3 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp3.Id];
        system.assert(sp3.Customer_Response__c == clsConsoleSaleTabController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsConsoleSaleTabController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().put('op_id', sp2.Id);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        system.assert(lst2 != null && lst2.size() == 0);
        sp2 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp2.Id];
        system.assert(sp2.Customer_Response__c == clsConsoleSaleTabController.STATUS_AFSLAET);
    }
    static testMethod void testUpdateEmptyCustomerResponse(){
        Address__c add = new Address__c(Street__c = 'Main Street',
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        Account acc = new Account(Name = 'Test Account 1',
            Street_YK__c = add.Id, Customer_No__c = '123456789');
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acc;
   Salesproposal__c sp1 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c,
            SFID__c = '0011', SFIDORIG__c = '0011',
            RESPTracking_CD__c = '1100',
            Customer_Response__c = '',
            Effective_From_Date__c = Date.today(),
            Expiration_Date__c = Date.today(), Priority__c = 1);
        Salesproposal__c sp2 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c,
            SFID__c = '0012', SFIDORIG__c = '0012',
            RESPTracking_CD__c = '1200',
            Customer_Response__c = '',
            Effective_From_Date__c = Date.today(),
            Expiration_Date__c = Date.today(), Priority__c = 2);
        insert new Salesproposal__c[]{sp1, sp2};
 
        clsConsoleSaleTabController ctrlRPA = new clsConsoleSaleTabController(new ApexPages.StandardController(acc));
        //system.assert(ctrlRPA.getStatusNone() == clsConsoleSaleTabController.STATUS_NONE);
        ctrlRPA.updateEmptyCustomerResponse();
        for (Salesproposal__c prop : [Select s.Id, s.Customer_Response__c
            from Salesproposal__c s where s.Id =: sp1.Id or  s.Id =: sp2.Id ]){
                system.assert(clsConsoleSaleTabController.STATUS_NONE==prop.Customer_Response__c);
        }
    }
    static testMethod void getAddressesFromCiaTest() {
        INTEGRATION__c inte = new INTEGRATION__c();
        inte.Name = 'YK7Inbound';
        inte.HttpMethod__c = 'GET';
        inte.IsBodyAppended__c = true;
        inte.Service__c = 'JITTERBIT';
        inte.Params__c = 'customerid';
        insert inte;
        Test.startTest();
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new  CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        insert custSeq;
       Address__c address1 = new Address__c();
        insert address1;
       Account customer = new Account(FirstName = 'John', LastName = 'Doe');
        customer.Street_YK__c = address1.Id;            
        insert customer;
        Customer_Related_Address__c cra = new Customer_Related_Address__c();
        cra.Customer__c=customer.id;
        cra.Payer_Address__c=address1.id;
        Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
        cia.Address__c = address1.id;
        cia.Customer__c = customer.id;
        insert cia;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
        clsConsoleSaleTabController c1 = new clsConsoleSaleTabController(sc1);        
        List<clsConsoleSaleTabController.DisplayAddress> da1 = c1.getAddresses();
        insert cra;
        ApexPages.StandardController sc = new ApexPages.StandardController(customer);
        clsConsoleSaleTabController c = new clsConsoleSaleTabController(sc);  
        List<clsConsoleSaleTabController.DisplayAddress> da = c.getAddresses();
        c.getDisplayOvernight();
        c.getExistingProducts();
        c.getSasProducts();
        c.getItems();
        clsConsoleSaleTabController.ProductItem prodItem = new clsConsoleSaleTabController.ProductItem();
        prodItem.getBillingStart();
        prodItem.getEffectiveFromDate();
            prodItem.getExpirationDate();
            prodItem.getDescription();
            prodItem.getSasPrice();
            prodItem.getSeqId();
        prodItem.getResponse();
        prodItem.getAccount();
        prodItem.getScriptUrl();
        prodItem.getStreet();
        prodItem.setResponseName('test');
        prodItem.getResponseName();
        prodItem.getProductType();
        prodItem.getOfferName();
        Test.stopTest();            
    }    
}