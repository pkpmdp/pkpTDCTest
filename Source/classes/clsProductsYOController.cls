public with sharing class clsProductsYOController {
    // Member variables used to bind model data to Visualforce pages
     //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private User user;
    private Account account;
    private Lead lead {get;set;}
    private Address__c address;
    //private ProductItem[] existingProducts;
    private ProductItem[] potentialProducts;
    private List<Salesproposal__c> overnightProducts;
    private ProductItem[] sasProducts;    
    private ProductItem[] offerProducts;
    private CampaignHistoryItem[] campaignHistory;
    private ReprovisionItem[] reprovision;
    private List<Reprovision__c> reprovisionsFromTable;
    private UsageResponse usageResponse;
   private String existingProductsXmlResponse;
    private String potentialProductsXmlResponse;
    private String overnightProductsXmlResponse;    
    private String sasProductsXmlResponse;
    private String campaignHistoryXmlResponse;
    private String reprovisionXmlResponse;
    private String currentTab;
    public static String STATUS_NONE = '--None--';
    public static String STATUS_ACCEPTERET = 'Accepteret';
    public static String STATUS_OVERVEJER = 'Overvejer';
    public static String STATUS_AFSLAET = 'Afslået';
    public static String STATUS_NOT_PROCESSED = 'Not processed';
    public static String STATUS_PROCESSED = 'Processed';
    public static String STATUS_FAILURE = 'Failure';
    public boolean displayErrMsg{get; set;}
    public boolean isDisplayButton{get; set;}
    public List<ProductItem> existingProducts{get; set;}
    public boolean isRenderErrextprod{get; set;}
     public boolean isRenderTableOP{get; set;}
    public boolean isDisplayButtonOP{get; set;}
    public List<ProductItem> displayOvernight{get; set;}
    public boolean isRenderErrOverrod{get; set;}
    public string cableTypeIsNumber{get; set;}
    //Testing
    private List<ProductItem> sampleOffers1 = new List<ProductItem>();
    private List<ProductItem> sampleOffers2 = new List<ProductItem>();
   private List<SelectOption> items;
    /*public Boolean getDisplayErrMsg(){
        return (this.account != null && this.account.Customer_No__c.startsWith('Pending'))
            || ApexPages.getMessages().size()>0;
    }*/
  public String getErrMsg(){
      /*  if (getDisplayErrMsg()){
            return System.Label.ERR_msg_under_constr;
        } else {
            //Show only first error message
            return ((ApexPages.Message)(ApexPages.getMessages()[0])).getSummary();
        }*/
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
        //System.debug('wen debug overnight'+ getDisplayOvernight() + 'debug sas' + getDisplaySAS());
        return getDisplayOvernight() || getDisplaySAS();
     }
    // Controller is used for both the account and address Visualforce pages
    public clsProductsYOController(ApexPages.StandardController controller) {
    displayErrMsg = false;
    isRenderErrextprod = false;
    isDisplayButton = true;
   isRenderTableOP = false;
    isDisplayButtonOP = true;
    //isRenderErrOverrod = false;
    system.debug('displayErrMsg '+displayErrMsg);
        // User information is needed when overnight products are accepted or declined
        this.user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
        // Controller extension is used on accounts, leads and addresses pages           
        if (controller.getRecord() instanceOf  Account) {           
            currentTab = 'existingProductsTab';
            this.account = (Account) controller.getRecord();
           // updateExistingProducts(); 
        } else if (controller.getRecord() instanceOf  Lead) {
            currentTab = 'campaignHistoryTab';
            this.lead = (Lead)controller.getRecord();
            this.lead = [Select id, AmsID__c from Lead where id = : this.lead.id];
        } else if (controller.getRecord() instanceOf  Address__c) {
            currentTab = 'existingProductsTab';
            this.address = (Address__c) controller.getRecord();
        }
    }
    public void setCurrentTab(String tab) {
        this.currentTab = tab;
    }
   public String getCurrentTab() {
        return this.currentTab;
    }
    public PageReference updateOfferProducts() {
    isRenderTableOP = true;
    isDisplayButtonOP = false; 
        this.currentTab = 'offerProductsTab';
        getOvernightProducts();
        system.debug('overnightProducts  '+overnightProducts.size());
        if(overnightProducts.size() == 0)
        {
            system.debug('In ovp If '+overnightProducts);
            isRenderErrOverrod = true;
            isRenderTableOP = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This Account does not have Products Offers'));
        }
        //getSasProducts();
        updateEmptyCustomerResponse();  
        return null;
    }
    public PageReference updateExistingProducts() {
        displayErrMsg = true;
    isDisplayButton  = false;
    system.debug('updateExistingProducts   '+displayErrMsg);
        this.currentTab = 'existingProductsTab';
        getExistingProducts1();
        if(existingProducts == null && existingProducts.size()==0)
        {     isRenderErrextprod = true;
            displayErrMsg  = false;}
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
    public PageReference updateReprovision() {
        this.currentTab = 'reprovisionTab';
        getReprovision();
        return null;
    }
    private Boolean wasUpdated(String productGroupId){
        for (Reprovision__c repr : this.reprovisionsFromTable){
            if (repr.Product_Group_Id__c == productGroupId){
              repr.Satus__c = STATUS_NOT_PROCESSED;
              repr.Mid__c = this.user.MID__c;
              repr.Reprovision_Date__c =  System.now();
              update repr; 
              updateReprovisionFromObject(repr);     
              //system.debug('doReprovision: ' + productGroupId );           
              return true;
            }
        }
        return false;
    }
   public PageReference doReprovision(){
        string productGroupId = ApexPages.CurrentPage().getParameters().get('productGroupId');
        if (!wasUpdated(productGroupId)){               
            Reprovision__c rep = new Reprovision__c();
            rep.Customer__c = this.account.Id;
            rep.Customer_No__c = this.account.Customer_No__c;
            rep.Mid__c =  this.user.MID__c;
            rep.Product_Group_Id__c = productGroupId;
            rep.Satus__c = STATUS_NOT_PROCESSED;
            rep.Reprovision_Date__c = System.now();
            insert rep;
            updateReprovisionFromObject(rep); 
       }
      return null;
     }
   private void updateReprovisionFromObject(Reprovision__c rep){
         for (ReprovisionItem item : this.reprovision){
            if (item.getProductGroupId() == rep.Product_Group_Id__c){
                item.setMid(rep.Mid__c);
                item.setStatus(rep.Satus__c);
                item.setDateOfReprovision(rep.Reprovision_Date__c);
                item.setCustomerNo(rep.Customer_No__c);
                break;
            }           
         }
    }
    public PageReference saveStatus(){
      string parID = ApexPages.CurrentPage().getParameters().get('op_id');
      
      for (Salesproposal__c prod : this.overnightProducts){
        if (prod.Id == parID){
          prod.Customer_Response__c = ApexPages.CurrentPage().getParameters().get('op_type');
          update prod;
          
          //system.debug('saveStatus: ' + parType + ' : ' + parID);         
          break;
        }
      }
      LoadOvernightProducts();
      return null;
    }
    
    public string getStatusNone(){
      return STATUS_NONE;
    }
    public PageReference updateEmptyCustomerResponse(){
    /*
    If we will check Product Offers Tab this value Customer_Response__c="" than
    will be changed (updated) to Customer_Response__c="--None--" for viewed customerNo
    */
        if(this.account != null && this.getCurrentTab()=='offerProductsTab'){
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
    public List<ProductItem> getExistingProducts1() {
        if (this.existingProducts == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,this.currentTab));
            if (this.currentTab == 'existingProductsTab') {       
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products'));
         // If we got this far we need to make the callout            
                // Set the parameters based upon the page the user is viewing
                if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                    //EDM-637 START
                    // add value in calloutValue list to find out at callout method
                    calloutParameter.add('null');
                    calloutValue.add(this.account.Customer_No__c);
                    existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
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
               if(this.existingProducts != null && this.existingProducts.size() > 0){
                    setPayerIDCustomerIDs();    
                }
            ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products Response = ' + existingProductsXmlResponse);
                //ApexPages.addMessage(existingProductsResponse);
            }
        }           
        return this.existingProducts;                        
    }
   public void setPayerIDCustomerIDs(){
        List<Account> accs = new List<Account>();
        String inClause = '';
       for(ProductItem item : this.existingProducts){
            if(item.getPayerID() != null){
                inClause = inClause + '\'' + item.getPayerID().trim() + '\',';
            }    
        }
        if(inClause.length() > 8){
            inClause = inClause.substring(0, inClause.length()-1);
            inClause = '(' + inClause + ')';
            String query = '';
            query = 'Select Id, Customer_No__c From Account WHERE Customer_No__c IN ' + inClause;
            accs = Database.query(query);
        } 
        Map<String,String> accMap = new Map<String,String>();
        for(Account item : accs){
            accMap.put(item.Customer_No__c, item.Id);
        }
        for(ProductItem item : this.existingProducts){
            if(item.getPayerID() != null){
                item.setPayerCustomerID(accMap.get(item.getPayerID().trim()));
                if(!item.getPayerID().trim().equals(account.Customer_No__c)){
                    item.setPayerCustomerStyle('font-weight:bold;');
                }
            }
        } 
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
                    String params = 'AMSAddressId=' + this.address.External_Id__c;
                    System.debug('params: ' + params);
                    calloutParameter.add('null');
                	Net_Installations__c netInSt = new Net_Installations__c();
                    netInSt = clsConnectionUtils_Admin.getInstallationSeq(this.address.External_Id__c, this.address.Cable_type__c);
                    calloutValue.add('G');
                    calloutValue.add(this.address.External_Id__c);
                    if(netInSt != null){
                        calloutValue.add(netInSt.INSTALLATION_ID__c);
                    	calloutValue.add(netInSt.Cable_Unit_No__c);
                    	potentialProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.POTENTIAL_PRODUCTS_ADDRESSES_METHOD, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        //potentialProductsXmlResponse = callout('http://TDCGroupTRIAL79207.jitterbit.eu/devonpre/YK6Inbound', params);
                        this.potentialProducts = parseProducts(potentialProductsXmlResponse);
                        this.potentialProducts.remove(0);
                   }
                } else if ( this.account != null && Account.Street_YK__r.External_Id__c != null){
                    //('getting potential products');
                    String params = 'AMSAddressId=' + Account.Street_YK__r.External_Id__c;
                  //  System.debug('params: ' + params);
                    calloutParameter.add('null');
                    Net_Installations__c netInSt = new Net_Installations__c();
                    netInSt = clsConnectionUtils_Admin.getInstallationSeq(this.account.Street_YK__r.External_Id__c, this.account.Street_YK__r.Cable_type__c);
                    calloutValue.add('G');
                    calloutValue.add(this.account.Street_YK__r.External_Id__c); 
                    if(netInSt != null){
                        calloutValue.add(netInSt.INSTALLATION_ID__c);
                    	calloutValue.add(netInSt.Cable_Unit_No__c);
                   		calloutValue.add(this.account.Customer_No__c);
                        potentialProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.POTENTIAL_PRODUCTS_ADDRESSES_METHOD, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        this.potentialProducts = parseProducts(potentialProductsXmlResponse);
                        this.potentialProducts.remove(0);
                    }
                }
            }
        }           
        return this.potentialProducts;                        
    }
    public List<Salesproposal__c> getOvernightProducts() {
        if (this.overnightProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {                
                LoadOvernightProducts();                
            }
        }       
        //system.debug('OvernightProducts: ' + (this.overnightProducts == null ? 'null' : string.valueOf(this.overnightProducts.size()))); 
        return this.overnightProducts;
    }    
   private void LoadOvernightProducts(){
      if(this.account != null){
        this.overnightProducts = [Select s.Street_Name__c, s.Customer_Response__c, s.RESPTracking_CD__c, s.Price__c, s.OwnerId, s.Name, 
                      s.LastModifiedDate, s.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, s.Expiration_Date__c, 
                      s.Effective_From_Date__c, s.Description__c, s.Description_URL__c, s.CustomerID__c, s.CreatedDate, s.CreatedById, 
                      s.Campaign_Name__c, s.AMSNo__c, s.Priority__c from Salesproposal__c s 
                      where s.CustomerID__c =: this.account.Customer_No__c AND s.Is_Responded__c = 'No' AND (Display__c = 'YOT' OR Display__c = 'Begge')
                      ORDER BY Priority__c DESC LIMIT 3 ];
        //system.debug('LoadOvernightProducts: ' + (this.overnightProducts == null ? 'null' : string.valueOf(this.overnightProducts.size())));
      } else if (this.lead != null) {
        this.overnightProducts = [Select s.Street_Name__c, s.Customer_Response__c, s.RESPTracking_CD__c, s.Price__c, s.OwnerId, s.Name, 
                      s.LastModifiedDate, s.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, s.Expiration_Date__c, 
                      s.Effective_From_Date__c, s.Description__c, s.Description_URL__c, s.CustomerID__c, s.CreatedDate, s.CreatedById, 
                      s.Campaign_Name__c, s.AMSNo__c from Salesproposal__c s 
                      where s.AMSNo__c =: this.lead.Address_External_Id__c AND s.Is_Responded__c = 'No' AND (Display__c = 'YOT' OR Display__c = 'Begge')
                      ORDER BY Priority__c DESC LIMIT 3 ];
      }
    }
     // Method populates the overnight products bind variable in the account and address Visualforce pages
    public List<ProductItem> getSasProducts() {
        if (this.sasProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                // If we got this far we need to make the callout
                //String params = '1;248;cust_test;agentId123';
                 if(this.account != null && !this.account.Customer_No__c.startsWith('Pending')){  
                    String params = '1;' + this.account.Street_YK__r.External_Id__c + ';' + this.account.Customer_No__c + ';' + this.user.MID__c;
                    System.debug('params: ' + params);
                     calloutParameter.add('null');
                	 calloutValue.add(params); 
                    sasProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.New_SAS_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + sasProductsXmlResponse);
                    //ApexPages.addMessage(sasResponse);
                    this.sasProducts = parseSasProducts(sasProductsXmlResponse);
                }
                //Testing
                //String str1 = '<GETSASINFORMATIONRESPONSE> <CUSTOMERID>621580039</CUSTOMERID> <ACTIVE>YES</ACTIVE> <BILLINGSTART/> <HTMLLINE>Default answer for test</HTMLLINE> <STREET>Ole Borchs Vej 48 2500 DK</STREET> <INSTLBNR/> <SCORE>0.02409639</SCORE> <ADDRESSID>248</ADDRESSID> <OFFERNAME>BB_CHURN</OFFERNAME> <URL>http://spcsastgltst01/cishome/WEB/SPOCPAGE/Default.html</URL> <SUBSCRIPTION>KTV,BB,DKTV,T</SUBSCRIPTION> <EFFECTIVEFROMDATE/> <EXPIRATIONDATE/> <BUSINESS_GROUP/> <businessArea/> <FIRSTNAME>Thorleif</FIRSTNAME> <LASTNAME>Larsen</LASTNAME> <DESCRIPTION>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas bibendum adipiscing gravida. Nulla vestibulum euismod turpis, at tempus dolor tincidunt mollis. Etiam dignissim lorem a ante pulvinar ac iaculis arcu euismod. Nulla luctus, justo vel vehicu</DESCRIPTION> <PRICE>99</PRICE> <totalPrice/> <SEQID/> <URL/> <LAST_RESPONSE/> </GETSASINFORMATIONRESPONSE>';
                //this.sasProducts = parseSasProducts(str1);                  
            }
        }        
        return this.sasProducts;                    
    } 
   // Method populates the overnight products bind variable in the account and address Visualforce pages
// Method populates the campaign history bind variable in the account Visualforce page
    public List<CampaignHistoryItem> getCampaignHistory() {
        if (this.campaignHistory == null) {
            if (this.currentTab == 'campaignHistoryTab') {
               // If we got this far we need to make the callout
                //EDM-637 START
                if(this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                	calloutParameter.add('null');
                	calloutValue.add(this.account.Customer_No__c);
                    calloutParameter.add('null');
                	calloutValue.add(this.account.Street_YK__r.External_Id__c);
                    campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_CUSTOMER, calloutParameter, calloutValue);
                	calloutParameter = new List<String>();
                	calloutValue = new List<string>();
                    //EDM-637 END
                } else if (this.lead != null) {
                    campaignHistoryXmlResponse = callout(clsConnectionUtils_Admin.END_POINT + clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_LEAD, this.lead.AmsID__c);
                }                                    
                this.campaignHistory = parseCampaignHistory(campaignHistoryXmlResponse);
            }
        }
        return this.campaignHistory;
    }
   // Method populates the reprovision bind variable in the account Visualforce page
    public List<ReprovisionItem> getReprovision() {     
        if (this.reprovision == null) {
            if (this.currentTab == 'reprovisionTab') {
                // If we got this far we need to make the callout
                if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                    reprovisionXmlResponse = callout(clsConnectionUtils_Admin.END_POINT + clsConnectionUtils_Admin.REPROVISION_METHOD, this.account.Customer_No__c);
                }                                
                this.reprovision = parseReprovision(reprovisionXmlResponse);
            }
        }
        return this.reprovision;
    }
     private String callout(String endpoint, String body) {
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
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 
                System.Label.ERR_msg_contact_admin +  e.getMessage(), e.getMessage());
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
                        product.Index = products.size();
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
                    } else if (reader.getLocalName() == 'PAYERID') {
                        reader.next();
                        product.setPayerID(checkEmptyElement(reader));                           
                    } else if (reader.getLocalName() == 'PRODUCTVARIANT') {
                        reader.next();
                        product.setproductVariant(checkEmptyElement(reader));                           
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
        if (XmlResponse == null || XmlResponse == '') return campaignHistory;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse); 
        //parser return text in multiple blocks
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Contacthistory') {
                        CampaignHistoryItem product = parseCampaignHistoryItem(reader);
                        campaignHistory.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing new campaign history: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return campaignHistory;
        }
        return campaignHistory;
    }
    private void setReprovisionsFromTable(){
        if (this.account != null){
            this.reprovisionsFromTable = [Select r.Customer__c , r.Customer_No__c , r.Mid__c ,
                r.Product_Group_Id__c, r.Reprovision_Date__c, r.Satus__c 
                from Reprovision__c r where r.Customer__c = :this.account.Id];
        }           
    }   
    private List<ReprovisionItem> parseReprovision(String XmlResponse) {        
        List<ReprovisionItem> reprovision = new List<ReprovisionItem>() ;
        if (XmlResponse == null) return reprovision;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse); 
        setReprovisionsFromTable();
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'ProductGroup') {
                        ReprovisionItem product = parseReprovisionItem(reader);
                        reprovision.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing new campaign history: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return reprovision;
        }
        return reprovision;
    }
private CampaignHistoryItem parseCampaignHistoryItem(XmlStreamReader reader) {
        String subject, category, type, sender, receiver, timeString, responseStatus, contentURL, infoText = null;
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'Contacthistory') {
                    break;
                }
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Emne') {
                        reader.next();
                        subject = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Kategory') {
                        reader.next();
                        category = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Type') {
                        reader.next();
                        type = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Afsender') {
                        reader.next();
                        sender = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Modtager') {
                        reader.next();
                        receiver = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Tidspunkt') {
                        reader.next();
                        timeString = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Status') {
                        reader.next();
                        responseStatus = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'ContentURL') {
                        reader.next();
                        contentURL = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'InfoTekst') {
                        reader.next();
                        infoText = checkEmptyElement(reader);
                    }
                }
            }
            reader.next();
        }
        return new CampaignHistoryItem(
            subject, category, type, sender, receiver, timeString, responseStatus, contentURL, infoText
        );
    }
private ReprovisionItem parseReprovisionItem(XmlStreamReader reader) {
        ReprovisionItem repr = new ReprovisionItem(this.reprovisionsFromTable);     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'ProductGroup') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'ProductGroupId') {
                        reader.next();
                        repr.setProductGroupId(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'ProductGroupName') {
                        reader.next();
                        repr.setProductGroupName(checkEmptyElement(reader)); 
                    }
                                     
                }  
            }
            reader.next();
        }
        return repr;
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
        private String payerID;
        private String payerCustomerID;
        private String payerCustomerStyle = '';
/* Addedd product variant as part of SPOC-1665*/
        private String productVariant;
       public Integer Index{get; private set;}
       public String getPayerCustomerStyle() {
            return payerCustomerStyle;
        }
public void setPayerCustomerStyle(String payerCustomerStyle) {
            this.payerCustomerStyle = payerCustomerStyle;
        }
       public String getPayerCustomerID() {
            return payerCustomerID;
        }
public void setPayerCustomerID(String payerCustomerID) {
            this.payerCustomerID = payerCustomerID;
        }
       public String getPayerID() {
            return payerID;
        }
public void setPayerID(String payerID) {
            this.payerID = payerID;
        }        
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
/* Added as part of SPOC-1665*/
        public String getproductVariant(){
            return this.productVariant;
        }
        public void setproductVariant(String productVariant){
            this.productVariant = productVariant;
        }
    }
public class CampaignHistoryItem {
        public String subject {get; set;} //Emne
        public String category {get; set;} //Kategory
        public String type {get; set;} //Type
        public String sender {get; set;} //Afsender
        public String receiver {get; set;} //Modtager
        public String timeDate {get; set;} //Tidspunkt
        public String responseStatus {get; set;} //Status
        public String contentURL {get; set;} //ContentURL
        public String infoText {get; set;} //InfoTekst
        public String mouseOverText {get; set;} //InfoTekst || Emne
        CampaignHistoryItem (
            String subject, String category, String type, String sender,
            String receiver, String timeString, String responseStatus,
            String contentURL, String infoText
        ) {
            this.subject = subject;
            this.category = category;
            this.type = type;
            this.sender = sender;
            this.receiver = receiver;
            try {
                Date dt = Date.valueOf(timeString);
                this.timeDate = dt.format();
            } catch(Exception e) {
                this.timeDate = '';
            }
            this.responseStatus = responseStatus;
            this.contentURL = contentURL;
            this.infoText = infoText;
            this.mouseOverText = infoText == '' ? subject : infoText;
        }
    }
public class ReprovisionItem {
        
        public ReprovisionItem(List<Reprovision__c> reprovisionsFromTable) {
            this.reprovisionsFromTable = reprovisionsFromTable;
        }
        private String productGroupId ;
        private String productGroupName;
        private String customerNo;
        private String dateOfReprovision;
        private String mid;
        private String status;
        private List<Reprovision__c> reprovisionsFromTable;
        public String getProductGroupName() {
            return productGroupName;
        }
        public void setProductGroupName(String cId) {
            this.productGroupName = cId;
        }
        public String getStatus() {
            return status;
        }
        public void setStatus(String cId) {
            this.status = cId;
        }
        public String getMid() {
            return mid;
        }
        public void setMid(String cId) {
            this.mid = cId;
        }
        public String getDateOfReprovision() {
            return dateOfReprovision;
        }
        public void setDateOfReprovision(DateTime cId) {            
            this.dateOfReprovision = clsProductsYOController.convertDateToString(cId);
        }        
        public String getProductGroupId() {
            return productGroupId;
        }
       public void setProductGroupId(String cId) {
            this.productGroupId = cId;            
            for (Reprovision__c repr : this.reprovisionsFromTable){
                if ( repr.Product_Group_Id__c == this.productGroupId ){
                    setDateOfReprovision(repr.Reprovision_Date__c);
                    setCustomerNo(repr.Customer_No__c);
                    setMid(repr.Mid__c);
                    setStatus(repr.Satus__c);
                    break;
                }
            }
            
        }
      public String getCustomerNo() {
            return this.customerNo;
        }
       public void setCustomerNo(String sub) {
            this.customerNo = sub;
        }
                  
    }
    public static String convertDateToString(DateTime dt){
            return dt.format('dd-MM-yyyy HH:mm:ss');
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
        req.setEndpoint(clsConnectionUtils_Admin.END_POINT + clsConnectionUtils_Admin.New_SAS_PRODUCTS_RESPONSE_METHOD);
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
    // LatestProductUsage BEGIN --->
    public PageReference updateLatestProductUsage() {
        this.currentTab = 'latestProductUsageTab';
        this.usageResponse = getUsageResponse();
        return null;
    }
private UsageResponse getUsageResponse() {
        if (this.usageResponse == null) {
             if (this.currentTab == 'latestProductUsageTab'){
                if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                	//EDM-637 START
                	calloutParameter.add('null');
                	calloutValue.add(account.Customer_No__c);        
                    String usageXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.LATEST_PRODUCT_USAGE_METHOD, calloutParameter, calloutValue);
                    this.usageResponse = parseLatestProductUsage(usageXmlResponse);
                	calloutParameter = new List<String>();
                	calloutValue = new List<string>();
                //EDM-637 END
                }
            }
        }
        return usageResponse;
    }
    public List<LatestProductUsage> getLatestProductUsage() {
        return this.usageResponse == null? null: getUsageResponse().latestProductUsages;                
    }
public List<ProductUsage> getProductUsage() {
        return this.usageResponse == null? null: getUsageResponse().productUsages;
     }
    public List<ReturnPathActivatedItem> getReturnPathActivated() {
        return this.usageResponse == null? null: getUsageResponse().returnPathActivated;        
    }
    public UsageResponse parseLatestProductUsage(String xmlResponse) {
        UsageResponse result = new UsageResponse();
        ProductUsage bb,mobb,telefoni;
        List<ProductUsage> productUsages = new List<ProductUsage>();
        if (xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            while (reader.hasNext()) {
                System.debug('Element ' + reader.getLocalName());
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'lastUseDates') {
                        result.latestProductUsages = parseLatestProductUsageItem(reader);
                    }
                    else if(reader.getLocalName() == 'bb' && (bb = parseProductUsage(reader))!= null 
                        && ( bb.productName!= '' )){//  || bb.percentUse!='' ||  bb.usage!='' || bb.maxLimit!='')){                         
                            productUsages.add(bb);                      
                    }
                    else if(reader.getLocalName() == 'mobb'&& (mobb = parseProductUsage(reader))!= null 
                        && (mobb.productName!= '')){ //|| mobb.percentUse!='' ||  mobb.usage!='' || mobb.maxLimit!='')){
                            productUsages.add(mobb);                        
                    }
                    else if(reader.getLocalName() == 'telefoni' && (telefoni = parseProductUsage(reader))!= null 
                        && (telefoni.productName!= '')) {// || telefoni.percentUse!='' ||  telefoni.usage!='' || telefoni.maxLimit!='')){
                            productUsages.add(telefoni);                        
                    }
                    else if(reader.getLocalName() == 'boxUseDates'){
                        result.returnPathActivated = parseReturnPathActivated(reader);
                    }
                }
                reader.next();
            }
        }
        result.productUsages=productUsages;
        return result;
    }
    private ProductUsage parseProductUsage(XmlStreamReader reader) {
        ProductUsage result = new ProductUsage();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'bb' || reader.getLocalName() == 'mobb' || reader.getLocalName() == 'telefoni') {
                    result.forbrugType=reader.getLocalName();
                    break;
                }   
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'productName') {
                    reader.next();
                    result.productName=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'percentUse') {
                    reader.next();
                    result.percentUse=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'usage') {
                    reader.next();
                    result.usage=String.valueOf(clsBBForbrug.convertkByteToGB(reader));
                } else if (reader.getLocalName() == 'maxLimit') {
                    reader.next();
                    result.maxLimit=String.valueOf(clsBBForbrug.convertMBtoGB(reader));
                } 
            }
            reader.next();
        }
        return result;
    }
    private List<LatestProductUsage> parseLatestProductUsageItem(XmlStreamReader reader) {
        LatestProductUsage prodWebTV = new LatestProductUsage();
        LatestProductUsage prodPlay = new LatestProductUsage();
        LatestProductUsage prodCinema = new LatestProductUsage();
        LatestProductUsage prodStartForFra = new LatestProductUsage();
        LatestProductUsage prodArchive = new LatestProductUsage();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'lastUseDates') {
                    break;
                }  
            } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('-Element ' + reader.getLocalName());
                if (reader.getLocalName() == 'webTV') {
                    reader.next();
                    prodWebTV.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'webTV_date') {
                    reader.next();
                    prodWebTV.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'play') {
                    reader.next();
                    prodPlay.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'play_date') {
                    reader.next();
                    prodPlay.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'cinema') {
                    reader.next();
                    prodCinema.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'cinema_date') {
                    reader.next();
                    prodCinema.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'startForFra') {
                    reader.next();
                    prodStartForFra.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'startForFra_date') {
                    reader.next();
                    prodStartForFra.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'archive') {
                    reader.next();
                    prodArchive.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'archive_date') {
                    reader.next();
                    prodArchive.latestUsage=formatDate(reader);
                } 
            }
            reader.next();
        }
         List<LatestProductUsage> latestProductUsages = new List<LatestProductUsage>();
        latestProductUsages.add(prodWebTV);
        latestProductUsages.add(prodPlay);
        latestProductUsages.add(prodCinema);
        latestProductUsages.add(prodStartForFra);
        latestProductUsages.add(prodArchive);
        return latestProductUsages;
    }
    private List<ReturnPathActivatedItem> parseReturnPathActivated(XmlStreamReader reader) {
        List<ReturnPathActivatedItem> result = new List<ReturnPathActivatedItem>();
        ReturnPathActivatedItem item = new ReturnPathActivatedItem();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'boxUseDates') {
                    result.add(item);
                    break;
                }   
            }           
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'Boxusefirstdate') {
                    reader.next();
                    item.boxUseFirstDate=formatDate(reader);
                } else if (reader.getLocalName() == 'Boxuselastdate') {
                    reader.next();
                    item.returnPathDate=formatDate(reader);
                } 
            }
            reader.next();
        }
        return result;
    }
    public String formatDate(XmlStreamReader reader) {
        String strDate = checkEmptyElement(reader);
        return formatDate(strDate);
    }
    public String formatDate(String strDate) {  
        try {
            Date dt = Date.valueOf(strDate);
            return dt.format();
        } catch(Exception e) {
            return '';
        }
    }
    public class LatestProductUsage {
        public String service{get;set;}
        public String latestUsage{get;set;}
        
        public LatestProductUsage() {
        }   
        public LatestProductUsage(String service, String latestUsage) {
            this.service = service;
            this.latestUsage = latestUsage;
        }   
    }
public class ProductUsage {
        public String forbrugType{get; set;}
        public String productName{get;set;}
        public String percentUse{get;set;}
        public String usage{get;set;}
        public String maxLimit{get;set;}
        public String getForbrugUrl(){
            String forbrugUrl ='';
            if (productName!=''){
                if (forbrugType == 'bb'){
                    forbrugUrl =  '/apex/BBForbrug?id='+ ApexPages.currentPage().getParameters().get('id')
                    +'&productName='+  EncodingUtil.urlEncode(productName, 'UTF-8')+'&maxLimit='+ maxLimit + '&usage='+ usage + '&percentUse='+ percentUse;
                }else if (forbrugType == 'mobb'){
                    forbrugUrl = '/apex/mobilBBForbrug?id='+ ApexPages.currentPage().getParameters().get('id');
                }
            } 
            return forbrugUrl;
        }        
    }
    public class UsageResponse {
        public List<LatestProductUsage> latestProductUsages;
        public List<ProductUsage> productUsages;
        public List<ReturnPathActivatedItem> returnPathActivated;
}
public class ReturnPathActivatedItem {
        public String returnPathDate{get;set;}
        public String boxUseFirstDate{get;set;}
    }
// LatestProductUsage END --->
   static testMethod void testDisplayCustomer() {
    RecordType rd = [SELECT DeveloperName,Id FROM RecordType where Name = 'YK Customer Account'];
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       LatestProductUsage lt = new LatestProductUsage('test', 'test');
       ProductUsage pg = new ProductUsage();
       pg.getForbrugUrl();
        /*Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;*/
		// Create account record
        Account acc = new Account();
        acc.FirstName = 'Test Account 1';
        acc.LastName = 'Test2';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
        acc.RecordTypeId = rd.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
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
        sp.Department__c = 'YO';
        insert sp;
         // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsProductsYOController controller = new clsProductsYOController(sc);
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><PAYERID>604559100</PAYERID></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><BILLINGSTART/><DESCRIPTION/><URL/><STREET/><HTMLLINE/><RESPONSE>test</RESPONSE><PAYERID>604559101</PAYERID></row></rows>';
		controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        controller.setPayerIDCustomerIDs();
        System.assertEquals(controller.existingProducts.size(), 2);
        System.assertEquals('existingProductsTab', controller.getCurrentTab());
        //System.assertEquals(null, controller.overnightProducts);
        //controller.retrievedExistingProducts = true;
        /* existingProduct1 = controller.getExistingProducts()[0];
        System.assertEquals('604559100', existingProduct1.getCustomerId());
        System.assertEquals('BJARNE', existingProduct1.getFirstName());
        System.assertEquals('PETERSEN', existingProduct1.getLastName());
        System.assertEquals('Fuldpakke', existingProduct1.getSubscription());
        System.assertEquals('1', existingProduct1.getBusinessGroup());
        System.assertEquals('Yes', existingProduct1.getActive());
        existingProduct1.getBillingEnd();
        existingProduct1.getPayerCustomerStyle();
        existingProduct1.getPayerCustomerID();*/
		//System.assertEquals(500, existingProduct1.getAccount().Currency_Format__c);
		/*ProductItem existingProduct2 = controller.getExistingProducts()[1];
        System.assertEquals('604559100', existingProduct2.getCustomerId());
        System.assertEquals('BJARNE', existingProduct2.getFirstName());
        System.assertEquals('PETERSEN', existingProduct2.getLastName());
        System.assertEquals('Bredbånd 10 Mbit/1 Mbit', existingProduct2.getSubscription());
        System.assertEquals('3', existingProduct2.getBusinessGroup());
        System.assertEquals('Yes', existingProduct2.getActive());
        System.assertEquals('', existingProduct2.getBillingEnd());*/
        //System.assertEquals(1000, existingProduct2.getAccount().Currency_Format__c);
        controller.existingProductsXmlResponse = null;
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        System.assertEquals(controller.existingProducts.size(), 0);
        controller.updateOfferProducts();
        //controller.overnightProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><SEQID>999</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE>2009-04-28T00:00:00.000</EFFECTIVEFROMDATE><EXPIRATIONDATE>2009-05-15T00:00:00.000</EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row><row><SEQID>998</SEQID><OFFERTRACKID>30</OFFERTRACKID><BUSINESSPARTYID>604559100</BUSINESSPARTYID><CABLEUNITID>0000003104</CABLEUNITID><ADDRESSID xsi:nil="true"/><ZAPADDRESSID>1018664021 02TH</ZAPADDRESSID><CAMPAIGNNAME>Overnight Bundle2</CAMPAIGNNAME><CAMPAIGNCODE>KK_0000040</CAMPAIGNCODE><OFFERCODE>KO_000016</OFFERCODE><OFFERNAME>Overnight Bundle2</OFFERNAME><OFFERVERSIONCODE>V018</OFFERVERSIONCODE><OFFERVERSIONNAME>O-kunder</OFFERVERSIONNAME><TRACKINGCODE>000000030</TRACKINGCODE><CELLCODE>A214</CELLCODE><CAMPAIGNTYPE>Sales Campaigns</CAMPAIGNTYPE><PRODUCT_GROUP>Internet</PRODUCT_GROUP><PRODUCT1>Webspeed</PRODUCT1><CONTROLOFFER>No</CONTROLOFFER><CONTACTDATE>2009-04-29T00:00:00.000</CONTACTDATE><RUNDATE>29-04-2009</RUNDATE><EFFECTIVEFROMDATE></EFFECTIVEFROMDATE><EXPIRATIONDATE></EXPIRATIONDATE><CHANNEL>Overnight</CHANNEL><CANCELLATIONFLAGDATE xsi:nil="true"/><CANCELLATIONFLAGVALUE xsi:nil="true"/><DEBITORACCOUNT>604559100</DEBITORACCOUNT><AGENTID xsi:nil="true"/><RESPONSE xsi:nil="true"/></row></rows>';
        controller.overnightProducts = controller.getOvernightProducts();        
        //System.assertEquals(controller.overnightProducts.size(), 1);
        System.assertEquals('offerProductsTab', controller.getCurrentTab());
        System.assertEquals(null, controller.campaignHistory);
		String campaignHistoryXmlResponseStr = '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<Contacthistories xmlns="http://yousee.dk/sas/contacthistory">\n<Contacthistory>\n<Emne>NKU 2012</Emne>\n<Kategory>NKU</Kategory>\n<Type>DM</Type>\n' +
                    '<Afsender>YouSee</Afsender>\n<Modtager>M1</Modtager>\n<Tidspunkt>2011-10-09T17:12:33.000</Tidspunkt>\n<Status>S1</Status>\n<ContentURL/>\n' +
                    '<InfoTekst>I1</InfoTekst>\n</Contacthistory>\n<Contacthistory>\n<Emne>Tv2 bliver i YouSees pakker</Emne>\n<Kategory>Generel Retention</Kategory>\n' +
                    '<Type>Email</Type>\n<Afsender>YouSee</Afsender>\n<Modtager/>\n<Tidspunkt>2011-09-08T13:32:42.000</Tidspunkt>\n<Status/>\n<ContentURL>http://ecm.yousee.dk</ContentURL>\n' +
                    '<InfoTekst/>\n</Contacthistory>\n</Contacthistories>';
        controller.updateCampaignHistory();
        controller.campaignHistoryXmlResponse = campaignHistoryXmlResponseStr;
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        System.assertEquals(controller.campaignHistory.size(), 2);
        System.assertEquals('campaignHistoryTab', controller.getCurrentTab());
		CampaignHistoryItem campaignHistory1 = controller.getCampaignHistory()[0];
        System.assertEquals('NKU 2012', campaignHistory1.subject);
        System.assertEquals('NKU', campaignHistory1.category);
        System.assertEquals('DM', campaignHistory1.type);
        System.assertEquals('YouSee', campaignHistory1.sender);
        System.assertEquals('M1', campaignHistory1.receiver);
        //System.assertEquals('09-10-2011', campaignHistory1.timeDate);
        System.assertEquals('S1', campaignHistory1.responseStatus); 
        System.assertEquals('', campaignHistory1.contentURL);
        System.assertEquals('I1', campaignHistory1.infoText);
        System.assertEquals('I1', campaignHistory1.mouseOverText);
		CampaignHistoryItem campaignHistory2 = controller.getCampaignHistory()[1];
        System.assertEquals('Tv2 bliver i YouSees pakker', campaignHistory2.subject);
        System.assertEquals('Generel Retention', campaignHistory2.category);
        System.assertEquals('Email', campaignHistory2.type);
        System.assertEquals('YouSee', campaignHistory2.sender);
        System.assertEquals('', campaignHistory2.receiver);
        //System.assertEquals('08-09-2011', campaignHistory2.timeDate);
        System.assertEquals('', campaignHistory2.responseStatus);
        System.assertEquals('http://ecm.yousee.dk', campaignHistory2.contentURL);
        System.assertEquals('', campaignHistory2.infoText);
        System.assertEquals('Tv2 bliver i YouSees pakker', campaignHistory2.mouseOverText);
		// Get a handle on controller with address as focus record
        sc = new ApexPages.StandardController(add);     
        controller = new clsProductsYOController(sc);               
        controller.existingProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.existingProducts = controller.parseProducts(controller.existingProductsXmlResponse);
        //System.assertEquals(controller.getExistingProducts().size(), 2);
        controller.updatePotentialProducts();
        controller.potentialProductsXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row></rows>';
        controller.potentialProducts = controller.parseProducts(controller.potentialProductsXmlResponse);
        //System.assertEquals(controller.getPotentialProducts().size(), 2);
       // Get a handle on controller with lead as focus record
        sc = new ApexPages.StandardController(l);       
        controller = new clsProductsYOController(sc);               
        controller.campaignHistoryXmlResponse = campaignHistoryXmlResponseStr;
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        //controller.retrievedCampaignHistory = true;
        System.assertEquals(controller.getCampaignHistory().size(), 2);
        sc = new ApexPages.StandardController(l); 
        controller = new clsProductsYOController(sc); 
        controller.getDisplayOvernight();
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
        controller.getDisplayOffers();        
        controller.account = acc;
        controller.address = add; 
        controller.updateExistingProducts();
        String sampleSASResponse = 
        '<GETSASINFORMATIONRESPONSE><CUSTOMERID/><ACTIVE/><BILLINGSTART/><HTMLLINE>Default answer  for test</HTMLLINE>' +
            '<STREET>Ole Borchs Vej 48 2500 DK</STREET><INSTLBNR/><SCORE>0.02409639</SCORE><ADDRESSID>248</ADDRESSID>' +
            '<OFFERNAME>BB_CHURN</OFFERNAME><URL>http://spcsastgltst01/cishome/WEB/SPOCPAGE/Default.html</URL>' +
            '<SUBSCRIPTION>KTV,BB,DKTV,T</SUBSCRIPTION><EFFECTIVEFROMDATE/><EXPIRATIONDATE/><BUSINESS_GROUP/>' +
            '<businessArea/><FIRSTNAME/><LASTNAME/><DESCRIPTION/><PRICE/><totalPrice/><SEQID/><URL/><STREET/><HTMLLINE/>' +
            '<LAST_RESPONSE/></GETSASINFORMATIONRESPONSE>';
        List<ProductItem> lstSAS = controller.parseSasProducts(sampleSASResponse);
        system.assert(lstSAS != null && lstSAS.size() == 1);
        system.assert(lstSAS[0].Response == clsProductsYOController.STATUS_NONE);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsProductsYOController.STATUS_OVERVEJER);
        ApexPages.currentPage().getParameters().put('op_id', '0');
        controller.saveSASResponse();
       controller.getItems();
		controller.updateLatestProductUsage();
		controller.getUsageResponse();
		controller.getLatestProductUsage();
		controller.getProductUsage();
		controller.getReturnPathActivated(); 
    }
    static testMethod void testDisplayReprovision() {
        RecordType rd = [SELECT DeveloperName,Id FROM RecordType where Name = 'YK Customer Account'];
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        /*Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;*/
        // Create account record
        Account acc = new Account();
        acc.FirstName = 'Test Account 1';
        acc.LastName = 'Account 3';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
        acc.RecordTypeId = rd.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
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
        DateTime dt = System.now(); 
        String dateTimeOfRep = clsProductsYOController.convertDateToString(dt);
        User user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
        Reprovision__c rep = new Reprovision__c();
        rep.Customer__c = acc.Id;
        rep.Customer_No__c = acc.Customer_No__c;
        rep.Mid__c =  user.MID__c;
        rep.Product_Group_Id__c = '2';
        rep.Satus__c = 'Processed';
        rep.Reprovision_Date__c = dt;
        insert rep;
        // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsProductsYOController controller = new clsProductsYOController(sc);
        controller.setCurrentTab('reprovisionTab');
        controller.displayOvernight = new List<ProductItem>();
        //controller.reprovisionXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Fuldpakke</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND>1900-01-01T00:00:00.000</BILLINGEND><BUSINESS_GROUP>1</BUSINESS_GROUP><PRICE>500</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED></row><row><LEADCUSTOMERID>0001313983</LEADCUSTOMERID><CUSTOMERID>604559100</CUSTOMERID><ADDRESSID>0001829022</ADDRESSID><FIRSTNAME>BJARNE</FIRSTNAME><LASTNAME>PETERSEN</LASTNAME><SUBSCRIPTION>Bredbånd 10 Mbit/1 Mbit</SUBSCRIPTION><ACTIVE>1</ACTIVE><BILLINGEND></BILLINGEND><BUSINESS_GROUP>3</BUSINESS_GROUP><PRICE>1000</PRICE><LAST_MODIFIED>2009-04-17T11:13:26.000</LAST_MODIFIED><BILLINGSTART/><DESCRIPTION/><URL/><STREET/><HTMLLINE/><RESPONSE>test</RESPONSE></row></rows>';
        controller.reprovisionXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><tns:Response xmlns:tns="http://www.example.org/test/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.example.org/test/ yo360_03_reprovisioning_groups.xsd "><ProductGroups><ProductGroup><ProductGroupId>1</ProductGroupId><ProductGroupName>Cabel TV</ProductGroupName></ProductGroup><ProductGroup><ProductGroupId>2</ProductGroupId><ProductGroupName>Broadband</ProductGroupName></ProductGroup></ProductGroups></tns:Response>';
        controller.reprovision = controller.parseReprovision(controller.reprovisionXmlResponse);
        System.assertEquals(controller.reprovision.size(), 2);
        System.assertEquals('reprovisionTab', controller.getCurrentTab());
        //System.assertEquals(null, controller.overnightProducts);
        //controller.retrievedExistingProducts = true;
        ReprovisionItem reprovision = controller.getReprovision()[0];
        System.assertEquals('1', reprovision.getProductGroupId());
        System.assertEquals('Cabel TV', reprovision.getProductGroupName());
        System.assertEquals(null, reprovision.getStatus());
        System.assertEquals(null, reprovision.getMid());
        System.assertEquals(null, reprovision.getDateOfReprovision());
        System.assertEquals(null, reprovision.getCustomerNo());
        //System.assertEquals(500, existingProduct1.getAccount().Currency_Format__c);
        ReprovisionItem reprovision1 = controller.getReprovision()[1];
        System.assertEquals('2', reprovision1.getProductGroupId());
        System.assertEquals('Broadband', reprovision1.getProductGroupName());
        System.assertEquals('Processed', reprovision1.getStatus());
        System.assertEquals(User.MID__c, reprovision1.getMid());
        System.assertEquals(dateTimeOfRep, reprovision1.getDateOfReprovision());
        System.assertEquals(acc.Customer_No__c, reprovision1.getCustomerNo());
        //ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('productGroupId', '1');
        controller.doReprovision();        
        controller.setCurrentTab('reprovisionTab');
        reprovision = controller.getReprovision()[0];
        System.assertEquals('1', reprovision.getProductGroupId());
        System.assertEquals('Cabel TV', reprovision.getProductGroupName());
        System.assertEquals(clsProductsYOController.STATUS_NOT_PROCESSED, reprovision.getStatus());
        System.assertEquals(User.MID__c, reprovision.getMid());
        //System.assertEquals(, reprovision.getDateOfReprovision());
        System.assertEquals(acc.Customer_No__c, reprovision.getCustomerNo());          
    	DateTime myDate = DateTime.newInstance(2000, 5, 10, 2, 30, 20);       
       clsProductsYOController.convertDateToString(myDate);
		controller.reprovisionXmlResponse = null;
        controller.reprovision = controller.parseReprovision(controller.reprovisionXmlResponse);
        System.assertEquals(controller.reprovision.size(), 0);
          controller.getErrMsg();
          ProductItem pt = new ProductItem();
		pt.getPayerCustomerStyle();
		pt.getPayerCustomerID();
		pt.getCustomerId();
		pt.getSubscription(); 
		pt.getActive();
		pt.getBillingStart();
		pt.getBillingEnd();
		pt.getOfferName();
		pt.getEffectiveFromDate();
		pt.getExpirationDate();
		pt.getBusinessGroup();
		pt.getFirstName();
		pt.getLastName();
		pt.getDescription();
		pt.getSasPrice(); 
		pt.getSeqId();
		pt.getAccount();
		pt.getScriptUrl();
		pt.getStreet();
		pt.getProductType();
		pt.setResponseName('test');
		pt.setproductVariant('test');
		pt.getproductVariant();
    }
    // return path activated + save status
    static testMethod void testDisplayCustomer_RPA_CR() {
        Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        /*Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;*/
		RecordType rd = [SELECT DeveloperName,Id FROM RecordType where Name = 'YK Customer Account'];
        Account acc = new Account(FirstName = 'Test Account 1', LastName = 'Test Account 4', Street_YK__c = add.Id, Customer_No__c = '123456789',RecordTypeId = rd.id);
        insert acc;
        Salesproposal__c sp1 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0011', SFIDORIG__c = '0011', RESPTracking_CD__c = '1100', Customer_Response__c = clsProductsYOController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 1, Department__c = 'YO');
        Salesproposal__c sp2 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0012', SFIDORIG__c = '0012', RESPTracking_CD__c = '1200', Customer_Response__c = clsProductsYOController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 2, Department__c = 'YO');
        Salesproposal__c sp3 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0013', SFIDORIG__c = '0013', RESPTracking_CD__c = '1300', Customer_Response__c = clsProductsYOController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 3, Department__c = 'YO');
        Salesproposal__c sp4 = new Salesproposal__c(CustomerID__c = acc.Customer_No__c, SFID__c = '0014', SFIDORIG__c = '0014', RESPTracking_CD__c = '1400', Customer_Response__c = clsProductsYOController.STATUS_NONE, Effective_From_Date__c = Date.today(), Expiration_Date__c = Date.today(), Priority__c = 3, Department__c = 'YK');
        insert new Salesproposal__c[]{sp1, sp2, sp3, sp4};
        clsProductsYOController ctrlRPA = new clsProductsYOController(new ApexPages.StandardController(acc));
        system.assert(ctrlRPA.getStatusNone() == clsProductsYOController.STATUS_NONE);
        ctrlRPA.updateOfferProducts();
        List<Salesproposal__c> lst2 = ctrlRPA.getOvernightProducts();
        //system.assert(lst2 != null && lst2.size() == 3);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsProductsYOController.STATUS_ACCEPTERET);
        ApexPages.currentPage().getParameters().put('op_id', sp1.Id);        
        system.assert(sp1.Customer_Response__c == clsProductsYOController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        //system.assert(lst2 != null && lst2.size() == 2);
        sp1 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp1.Id];
        //system.assert(sp1.Customer_Response__c == clsProductsYOController.STATUS_ACCEPTERET);
       ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsProductsYOController.STATUS_OVERVEJER);
        ApexPages.currentPage().getParameters().put('op_id', sp2.Id);
        system.assert(sp2.Customer_Response__c == clsProductsYOController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        //system.assert(lst2 != null && lst2.size() == 2);
        sp2 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp2.Id];
        //system.assert(sp2.Customer_Response__c == clsProductsYOController.STATUS_OVERVEJER);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsProductsYOController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().put('op_id', sp3.Id);
        system.assert(sp3.Customer_Response__c == clsProductsYOController.STATUS_NONE);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        //system.assert(lst2 != null && lst2.size() == 1);
        sp3 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp3.Id];
        //system.assert(sp3.Customer_Response__c == clsProductsYOController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('op_type', clsProductsYOController.STATUS_AFSLAET);
        ApexPages.currentPage().getParameters().put('op_id', sp2.Id);
        ctrlRPA.saveStatus();
        lst2 = ctrlRPA.getOvernightProducts();
        //system.assert(lst2 != null && lst2.size() == 0);
        sp2 = [SELECT Customer_Response__c FROM Salesproposal__c WHERE Id = :sp2.Id];
        //system.assert(sp2.Customer_Response__c == clsProductsYOController.STATUS_AFSLAET);
    }
    // LatestProductUsage BEGIN --->
    static testMethod void testLatestProductUsage() {
        /*
           <Response xmlns="http://yousee.dk/box/usages"> 
           <customerID>605590333</customerID> 
           <youseePlus> 
              <serialNr/> 
              <greenLamp/> 
           </youseePlus> 
           <lastUseDates> 
              <webTV>Web-TV</webTV> 
              <webTV_date/> 
              <play>Play</play> 
              <play_date>2011-03-14T00:00:00Z</play_date> 
              <cinema>Cinema</cinema> 
              <cinema_date>2011-09-03T12:38:48Z</cinema_date> 
              <startForFra>Start forfra</startForFra> 
              <startForFra_date>2011-09-06T22:30:46Z</startForFra_date> 
              <archive>Arkiv</archive> 
              <archive_date>2011-09-03T16:37:37Z</archive_date> 
              <plus>YouSee Plus</plus> 
              <plus_date/> 
           </lastUseDates> 
           <bb> 
              <productName>Bredbånd 50 Mbit/5 Mbit</productName> 
              <percentUse/> 
              <usage>15040586</usage> 
              <maxLimit>50000</maxLimit> 
           </bb> 
           <mobb> 
              <productName/> 
              <percentUse/> 
              <usage/> 
              <maxLimit/> 
           </mobb> 
           <telefoni> 
              <productName/> 
              <percentUse/> 
              <usage/> 
              <maxLimit/> 
           </telefoni> 
           <returnPath>2010-12-01T00:00:00Z</returnPath> 
           <boxUseDates> 
              <Boxusefirstdate>2010-08-25T21:12:16Z</Boxusefirstdate> 
              <Boxuselastdate>2011-09-07T22:07:56Z</Boxuselastdate> 
           </boxUseDates> 
        </Response> 
        */
        Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        /*Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;*/
        RecordType rd = [SELECT DeveloperName,Id FROM RecordType where Name = 'YK Customer Account'];
        Account acc = new Account(FirstName = 'Test Account 1', LastName = 'Test Account 6', Street_YK__c = add.Id, Customer_No__c = '123456789', RecordTypeId = rd.id);
        insert acc;
        clsProductsYOController controller = new clsProductsYOController(new ApexPages.StandardController(acc));
        controller.updateReprovision();
        controller.usageResponse = controller.parseLatestProductUsage('<?xml version="1.0" encoding="UTF-8"?><Response xmlns="http://yousee.dk/box/usages"><customerID>605590333</customerID><youseePlus><serialNr/><greenLamp/></youseePlus><lastUseDates><webTV>Web-TV</webTV><webTV_date/><play>Play</play><play_date>2011-03-14T00:00:00Z</play_date><cinema>Cinema</cinema><cinema_date>2011-09-03T12:38:48Z</cinema_date><startForFra>Start forfra</startForFra><startForFra_date>2011-09-06T22:30:46Z</startForFra_date><archive>Arkiv</archive><archive_date>2011-09-03T16:37:37Z</archive_date><plus>YouSee Plus</plus><plus_date/></lastUseDates><bb><productName>Bredbånd 50 Mbit/5 Mbit</productName><percentUse/><usage>15040586</usage><maxLimit>50000</maxLimit></bb><mobb><productName/><percentUse/><usage/><maxLimit/></mobb><telefoni><productName/><percentUse/><usage/><maxLimit/></telefoni><returnPath>2010-12-01T00:00:00Z</returnPath><boxUseDates><Boxusefirstdate>2010-08-25T21:12:16Z</Boxusefirstdate><Boxuselastdate>2011-09-07T22:07:56Z</Boxuselastdate></boxUseDates></Response>');
        system.assert(controller.usageResponse.latestProductUsages[0].service=='Web-TV');
        system.assert(controller.usageResponse.latestProductUsages[0].latestUsage=='');
        system.assert(controller.usageResponse.latestProductUsages[1].service=='Play');
        system.assert(controller.usageResponse.latestProductUsages[1].latestUsage==controller.formatDate('2011-03-14T00:00:00Z'));
        system.assert(controller.usageResponse.latestProductUsages[2].service=='Cinema');
        system.assert(controller.usageResponse.latestProductUsages[2].latestUsage==controller.formatDate('2011-09-03T12:38:48Z'));
        system.assert(controller.usageResponse.latestProductUsages[3].service=='Start forfra');
        system.assert(controller.usageResponse.latestProductUsages[3].latestUsage==controller.formatDate('2011-09-06T22:30:46Z'));
        system.assert(controller.usageResponse.latestProductUsages[4].service=='Arkiv');
        system.assert(controller.usageResponse.latestProductUsages[4].latestUsage==controller.formatDate('2011-09-03T16:37:37Z'));
        system.assert(controller.usageResponse.productUsages[0].productName=='Bredbånd 50 Mbit/5 Mbit');
        system.assert(controller.usageResponse.productUsages[0].percentUse=='');
        //convert to units system.assert(controller.usageResponse.productUsages[0].usage=='15040586');
        //convert to units system.assert(controller.usageResponse.productUsages[0].maxLimit=='50000');
        system.assert(controller.usageResponse.returnPathActivated[0].returnPathDate==controller.formatDate('2011-09-07T22:07:56Z'));
        system.assert(controller.usageResponse.returnPathActivated[0].boxUseFirstDate==controller.formatDate('2010-08-25T21:12:16Z'));
	}
// LatestProductUsage END --->
static testMethod void testUpdateEmptyCustomerResponse(){
        Address__c add = new Address__c(Street__c = 'Main Street',
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        RecordType rd = [SELECT DeveloperName,Id FROM RecordType where Name = 'YK Customer Account'];
        /*Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;*/
		Account acc = new Account(FirstName = 'Test Account 1', LastName = 'Test Account 9',
            Street_YK__c = add.Id, Customer_No__c = '123456789', RecordTypeId = rd.id);
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
 		clsProductsYOController ctrlRPA = new clsProductsYOController(new ApexPages.StandardController(acc));
        ctrlRPA.setCurrentTab('offerProductsTab');
        ctrlRPA.updateOfferProducts();
        for (Salesproposal__c prop : [Select s.Id, s.Customer_Response__c
            from Salesproposal__c s where s.Id =: sp1.Id or  s.Id =: sp2.Id ]){
                system.assert(clsProductsYKController_V3.STATUS_NONE==
                    prop.Customer_Response__c);
        }
    }
}