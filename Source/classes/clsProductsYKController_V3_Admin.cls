public with sharing class clsProductsYKController_V3_Admin {
    // Member variables used to bind model data to Visualforce pages
    //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private User user;
    private Account account;
    private Lead lead {get;set;}
    private Address__c address;
    private ProductItem[] existingProducts;
    public list<ProductItem> filteredList{get; set;} //SPOC-2244
    private ProductItem[] potentialProducts;
    private List<Salesproposal__c> overnightProducts;
    private static Boolean YouBioAndTelefoniProducts;
    private ProductItem[] sasProducts;    
    private ProductItem[] offerProducts;
    private CampaignHistoryItem[] campaignHistory;
    public list<ProductItem> listFiltered{get; set;}
    public string radioValue{get; set;}  //SPOC-2244 
    public string selectedCableType{get; set;} //SPOC-2244 
    public string selectedProductType{get; set;}//SPOC-2244   
    public boolean isBasicSubSelected{get; set;}//SPOC-2244
    public boolean isAddOnSub{get; set;}//SPOC-2244
    public boolean isOneTimeSub{get; set;}//SPOC-2244
    public boolean isRenderProductPageBlock{get; set;} //SPOC-2244
    public boolean isDisableInputs{get; set;} //SPOC-2244
    public string buttonLabl{get; set;}//SPOC-2244
    public boolean isButtonClicked;//SPOC-2244
    public boolean isTVSelected{get; set;}//SPOC-2244
    public boolean isDigiSelected{get; set;}//SPOC-2244
    public boolean isBBSelected{get; set;}//SPOC-2244
    public boolean isVoiPSelected{get; set;}//SPOC-2244
    public list<ProductItem> listToDisplay{get; set;}//SPOC-2244
    public boolean displayExtTable{get; set;}
    private String existingProductsXmlResponse;
    private String potentialProductsXmlResponse;
    private String overnightProductsXmlResponse; 
    private static String youBioProductsXmlResponse;  
    private String sasProductsXmlResponse;
    private String campaignHistoryXmlResponse;
    private String currentTab;
    private UsageResponse usageResponse;
    public static String STATUS_NONE = '--None--';
    public static String STATUS_ACCEPTERET = 'Accepteret';
    public static String STATUS_OVERVEJER = 'Overvejer';
    public static String STATUS_AFSLAET = 'Afslået';
    public Set<String> producOfferList{get; set;}
    public boolean displayNoOffers {get; set;}
    public boolean isDisableInputs1{get; set;}
    public boolean overnightProductsTableFilter  {get;set;} //added by grajput spoc 2244
    public boolean existingProductsTableFilter {get;set;} //added by grajput spoc 2244   
    public list<string> listChkbox;
    public boolean displaypoteltialTable{get; set;} //spoc 2244
    public string arrPage{get; set;}
    public Boolean broadbandWOTv{get;set;}// to display the broadband without tv
    public string cableTypeIsNumber{get; set;}
    /*Added code for SPOC-2234 */
    /* public String getPreInstallaedModem(){
return account.Pr_installeret_udstyr__c;
}*/
    /* Commented for SPOC-1392 
public static String mBillUrl = YouSeeCustomSettings__c.getInstance('mBillingUrlAccount').Setting_Value__c;
public static String mBillOnphoneUrl = YouSeeCustomSettings__c.getInstance('mBillingOnphoneUrl').Setting_Value__c;*/
    
    //Testing
    private List<ProductItem> sampleOffers1 = new List<ProductItem>();
    private List<ProductItem> sampleOffers2 = new List<ProductItem>();
    
    private List<SelectOption> items;
    public static Boolean subYouBio{get; set;}
    
    public Boolean getDisplayErrMsg(){
        return (this.account != null && this.account.Customer_No__c.startsWith('Pending'))
            || ApexPages.getMessages().size()>0;
    }
    
    public String getErrMsg(){
        if (getDisplayErrMsg()){
            return System.Label.ERR_msg_under_constr;
        } else {
            //Show only first error message
            return ((ApexPages.Message)(ApexPages.getMessages()[0])).getSummary();
        }
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
        //  return getDisplayOvernight() || getDisplaySAS();
        return null; // changes for 2266
    }
    // Changed for 2266
    /*public Boolean getDisplayNoOffers(){

return !getDisplayOffers();
}*/ 
    
    public String strBrands = ''; 
    // Controller is used for both the account and address Visualforce pages
    public clsProductsYKController_V3_Admin(ApexPages.StandardController controller) {
        overnightProductsTableFilter = existingProductsTableFilter = false; //added by grajput spoc 2244
        isRenderProductPageBlock = true;
        isDisableInputs = true;
        buttonLabl = 'load Data';
        isButtonClicked = false;
        displayNoOffers = false;
        isDisableInputs1 = true;
        displayExtTable = false;
        displaypoteltialTable = false;
        broadbandWOTv = false;
        //isDisableProductTypeList = true;
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
            subYouBio = false;
        // User information is needed when overnight products are accepted or declined
        this.user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
        // Controller extension is used on accounts, leads and addresses pages
        if (controller.getRecord() instanceOf  Account) {           
            currentTab = 'offerProductsTab';
            //this.account = (Account) controller.getRecord();
            String accId = controller.getId();
            this.account = [select Id, Customer_No__c, Street_YK__c, Street_YK__r.External_Id__c,Street_YK__r.Cable_type__c,Street_YK__r.Cableunit_number__c,Brands__c from Account where id=:accId];
            //System.debug('Account:No:'+this.account.Customer_No__c+' Street:'+this.account.Street_YK__c+' Brand:'+this.account.Brands__c);
            //updateOfferProducts(); //moved to pageAction method
            strBrands = this.account.Brands__c;
            
        } else if (controller.getRecord() instanceOf  Lead) {
            currentTab = 'campaignHistoryTab';
            this.lead = (Lead)controller.getRecord();
            this.lead = [Select id, AmsID__c from Lead where id = : this.lead.id];
        } else if (controller.getRecord() instanceOf  Address__c) {
            currentTab = 'existingProductsTab';
            this.address = (Address__c) controller.getRecord();
        }               
    }
    
    public PageReference loadDataAction()
    {
        //system.debug('******** In Page action method ************* ');
        existingProductsTableFilter = true; //added by grajput spoc 2244
        isRenderProductPageBlock = true;
        isDisableInputs = false;
        //buttonLabl = 'Search';    commented by grajput spoc 2244
        displayExtTable = true;
        //if(isButtonClicked == false)
        //{
        isButtonClicked = true;
        if (this.account != null) 
        {
            String isConsole = ApexPages.currentPage().getParameters().get('inContextPane');
            if(isConsole != null && 'true'.equals(isConsole)){
                updateCampaignHistory();
            }
            //updateOfferProducts();    commented by grajput spoc 2244
            updateExistingProducts();
        }
        //}
        /*else
{
filterList();
}*/
        
        return null;
    }
    
    
    public void setCurrentTab(String tab) {
        this.currentTab = tab;
    }
    
    public String getCurrentTab() {
        return this.currentTab;
    }
    
    public PageReference updateOfferProducts() {
        /*overnightProductsTableFilter = true;  //added by grajput spoc 2244
this.currentTab = 'offerProductsTab';
isDisableInputs1 = false;
getOvernightProducts();
if(overnightProducts.size()==0 || overnightProducts == null)
{
isDisableInputs1 = false;
displayNoOffers = true;            
}
//getSasProducts(); */ 
        
        return null;
    }
    
    public PageReference updateExistingProducts() {
        this.currentTab = 'existingProductsTab';
        getExistingProducts();
        if(existingProducts.size()==0)
            displayExtTable = false;
        return null;
    }
    
    public PageReference updateCampaignHistory() {
        this.currentTab = 'campaignHistoryTab';
        getCampaignHistory();
        return null;
    }
    
    public PageReference updatePotentialProducts() {
        isDisableInputs1 = false;
        displaypoteltialTable = true;
        overnightProductsTableFilter = true;
        this.currentTab = 'potentialProductsTab';
        getPotentialProducts();
        return null;
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
            this.overnightProducts = [
                Select s.Street_Name__c, s.Customer_Response__c, s.RESPTracking_CD__c, s.Price__c, s.OwnerId, s.Name, 
                s.LastModifiedDate, s.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, s.Expiration_Date__c, 
                s.Effective_From_Date__c, s.Description__c, s.Description_URL__c, s.CustomerID__c, s.CreatedDate, 
                s.CreatedById, s.Campaign_Name__c, s.AMSNo__c, s.Priority__c 
                from Salesproposal__c s 
                where s.CustomerID__c =: this.account.Customer_No__c AND s.Is_Responded__c = 'No'  AND (Display__c = 'YKRF' OR Display__c = 'Begge')
                ORDER BY Priority__c DESC LIMIT 3 ];
        } else if (this.lead != null) {
            this.overnightProducts = [
                Select s.Street_Name__c, s.Customer_Response__c, s.RESPTracking_CD__c, s.Price__c, s.OwnerId, 
                s.Name, s.LastModifiedDate, s.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, 
                s.Expiration_Date__c, s.Effective_From_Date__c, s.Description__c, s.Description_URL__c, 
                s.CustomerID__c, s.CreatedDate, s.CreatedById, s.Campaign_Name__c, s.AMSNo__c from Salesproposal__c s 
                where s.AMSNo__c =: this.lead.Address_External_Id__c AND s.Is_Responded__c = 'No' AND (Display__c = 'YKRF' OR Display__c = 'Begge')
                ORDER BY Priority__c DESC LIMIT 3 ];
        }
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
    public List<ProductItem> getExistingProducts() {
        
        if (this.existingProducts == null) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,this.currentTab));
            
            if (this.currentTab == 'existingProductsTab') {       
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products'));
                
                // If we got this far we need to make the callout            
                // Set the parameters based upon the page the user is viewing
                if(!Test.isRunningTest()){
                    if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                        //system.debug('in 1st method');
                        calloutParameter.add('null');
                        calloutValue.add(this.account.Customer_No__c);  
                        existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(System.Label.Yk7Inbound_Admin, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        //system.debug('existingProductsXmlResponse ****** '+existingProductsXmlResponse);
                        //existingProductsXmlResponse = callout('http://tdcgrouptrial79207.jitterbit.eu/devonpre/2/YK7Inbound?customerid='+this.account.Customer_No__c, '');               
                    } else if (this.address != null) {   
                        //  System.debug('getting existing products');
                        calloutParameter.add('null');
                        calloutValue.add(this.address.External_Id__c);      
                        existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(System.Label.Yk8Inbound_Admin, calloutParameter, calloutValue);                       
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        //system.debug('existingProductsXmlResponse ****** '+existingProductsXmlResponse);
                    }
                }      
                //  system.debug('c' + existingProductsXmlResponse);      
                this.existingProducts = parseProducts(existingProductsXmlResponse);
                listFiltered = new list<ProductItem>();
                listFiltered.addAll(existingProducts);
                 if(this.existingProducts != null && this.existingProducts.size() > 0){
                    setCustomerType();
                }
                //    system.debug('existingProduct Parsed Response ****** '+existingProducts);
                if(this.existingProducts != null && this.existingProducts.size() > 0){
                    setPayerIDCustomerIDs();    
                }
                
                ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.INFO,'Existing Products Response = ' + existingProductsXmlResponse);
                //ApexPages.addMessage(existingProductsResponse);
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
        // System.debug('this.potentialProducts: ' + this.potentialProducts);
        if (this.potentialProducts == null) {
            //  System.debug('this.currentTab: ' + this.currentTab);
            if (this.currentTab == 'potentialProductsTab') {   
                // If we got this far we need to make the callout            
                // System.debug('Going');
                if(!Test.isRunningTest()){
                    if (this.address != null) {        
                        // System.debug('getting potential products'); 
                        //String params = 'AMSAddressId=' + this.address.External_Id__c + ';CustomerNumber=' + '613699841';
                        String params = 'AMSAddressId=' + this.address.External_Id__c;
                        // System.debug('params: ' + params);
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
                    } else if ( this.account != null && account.Street_YK__r.External_Id__c != null){
                        //('getting potential products');
                        String params = 'AMSAddressId=' + account.Street_YK__r.External_Id__c;
                        //  System.debug('params: ' + params);
                        calloutParameter.add('AMSAddressId');
                        calloutValue = new List<String>();
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
                            //potentialProductsXmlResponse = callout('http://TDCGroupTRIAL79207.jitterbit.eu/devonpre/YK6Inbound', params);
                            this.potentialProducts = parseProducts(potentialProductsXmlResponse);
                            this.potentialProducts.remove(0);
                        }
                        system.debug('potentialProducts List '+potentialProducts);
                    }
                }
            }            
        }           
        return this.potentialProducts;                        
    }
    
    public List<Salesproposal__c> getOvernightProducts() {
        if (this.overnightProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                //  System.debug('wen debug i am here');                
                LoadOvernightProducts();
            }
        }
        //System.debug('wen debug i am here**'+this.overnightProducts);
        return this.overnightProducts;
    }
    
    // Method populates the overnight products bind variable in the account and address Visualforce pages
    public List<ProductItem> getSasProducts() {
        
        if (this.sasProducts == null) {   
            if (this.currentTab == 'offerProductsTab') {
                // If we got this far we need to make the callout
                //String params = '1;248;cust_test;agentId123';
                if(this.account != null && !this.account.Customer_No__c.startsWith('Pending')){  
                    String params = '1;' + this.account.Street_YK__r.External_Id__c + ';' + this.account.Customer_No__c + ';' + this.user.MID__c;
                    // System.debug('params: ' + params);
                    if(!Test.isRunningTest()){
                        calloutParameter.add('null');
                        calloutValue.add(params); 
                        sasProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.New_SAS_PRODUCTS_CUSTOMERS_METHOD, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                        //system.debug('sasProductsXmlResponse ******** '+sasProductsXmlResponse);
                    }
                    ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + sasProductsXmlResponse);
                    //ApexPages.addMessage(sasResponse);
                    this.sasProducts = parseSasProducts(sasProductsXmlResponse);
                    
                }
                //Testing
                /*
String str1 = '<GETSASINFORMATIONRESPONSE> <CUSTOMERID>621580039</CUSTOMERID> <ACTIVE>YES</ACTIVE> <BILLINGSTART/>'+ 
' <HTMLLINE>Default answer for test</HTMLLINE> <STREET>Ole Borchs Vej 48 2500 DK</STREET> <INSTLBNR/>'+ 
' <SCORE>0.02409639</SCORE> <ADDRESSID>248</ADDRESSID> <OFFERNAME>BB_CHURN</OFFERNAME>'+ 
' <URL>http://spcsastgltst01/cishome/WEB/SPOCPAGE/Default.html</URL>'+ 
' <SUBSCRIPTION>KTV,BB,DKTV,T</SUBSCRIPTION> <EFFECTIVEFROMDATE/> <EXPIRATIONDATE/>'+ 
' <BUSINESS_GROUP/> <businessArea/> <FIRSTNAME>Thorleif</FIRSTNAME> <LASTNAME>Larsen</LASTNAME>'+ 
' <DESCRIPTION>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas bibendum adipiscing gravida.'+ 
' Nulla vestibulum euismod turpis, at tempus dolor tincidunt mollis. Etiam dignissim lorem a ante pulvinar '+ 
'ac iaculis arcu euismod. Nulla luctus, justo vel vehicu</DESCRIPTION> <PRICE>99</PRICE> <totalPrice/>'+ 
' <SEQID/> <URL/> <LAST_RESPONSE/> </GETSASINFORMATIONRESPONSE>';
*/
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
                if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {
                    if(!Test.isRunningTest()){
                        if(this.account.Brands__c == 'Blockbuster'){
                            // System.debug('Blockbuster');
                            calloutParameter.add('null');
                            calloutValue.add(this.account.Customer_No__c);
                            calloutParameter.add('null');
                            calloutValue.add('-1');
                            campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_CUSTOMER, calloutParameter, calloutValue);
                            calloutParameter = new List<String>();
                            calloutValue = new List<string>();
                        }else{
                            // System.debug('YouSee');
                            calloutParameter.add('null');
                            calloutValue.add(this.account.Customer_No__c);
                            calloutParameter.add('null');
                            calloutValue.add(this.account.Street_YK__r.External_Id__c);
                            campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_CUSTOMER, calloutParameter, calloutValue);
                            calloutParameter = new List<String>();
                            calloutValue = new List<string>();
                        }
                    }
                } else if (this.lead != null) {
                    if(!Test.isRunningTest()){
                        calloutParameter.add('null');
                        calloutValue.add(this.lead.AmsID__c+';'+this.lead.id);
                        campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_LEAD, calloutParameter, calloutValue);
                        calloutParameter = new List<String>();
                        calloutValue = new List<string>();
                    }
                }                                    
                this.campaignHistory = parseCampaignHistory(campaignHistoryXmlResponse);
            }
        }
        return this.campaignHistory;
    }
    
    /*private String callout(String endpoint, String body) {
// Make the callout and check the response  
system.debug('Body ********* '+body);      
Http http = new Http();
HttpRequest req = new HttpRequest(); 
req.setMethod('GET');
//req.setMethod('POST');
req.setEndpoint(endpoint);
req.setBody((body == null ? '' : body));
req.setTimeout(60000);        
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
                        //product.setProductType('Overnight');
                        //product.calculateLink();
                        if((product.getAccountType()=='0' || product.getAccountType()=='2') && producOfferList.contains(product.getOfferName())){
                            product.account.Currency_Format__c=null;
                        }
                        if(this.currentTab == 'existingProductsTab' && product.getAccountType()== '1') //SPOC-2244 remove proce if kundetype is organiseret
                         product.account = new Account(Currency_Format__c=null);
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
        String brodBandwithoutTvValue = '';
        map<String,String> broadBandKeyToValMap = new map<String,String>();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    
                    //ApexPages.Message tagValue = new ApexPages.Message(ApexPages.Severity.INFO,'overnight.' + reader.getLocalName());
                    //ApexPages.addMessage(tagValue);
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
                    } else if (reader.getLocalName() == 'DISCOUNT') { //SPOC-2203
                        reader.next();
                        product.setDiscount(checkEmptyElement(reader));
                        
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
                    } else if (reader.getLocalName() == 'customerType'){
                        reader.next();
                        product.setAccountType(checkEmptyElement(reader));
                        // System.debug('$$product.getCustomerType()'+Integer.valueOf(checkEmptyElement(reader)));
                    }else if ((reader.getLocalName() == 'PRICE') || (reader.getLocalName() == 'totalPrice')) {
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
                        product.setSubType(checkEmptyElement(reader));                           
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
                    }  //SPOC-2244 additional parameter
                    else if (reader.getLocalName()=='PRODUCTKEY' || (reader.getLocalName() == 'productKey')) {
                        reader.next();
                        product.setproductKey(checkEmptyElement(reader)); 
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
                    } 
                    
                    else if (reader.getLocalName() == 'STREET') {
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
            subject, category, type, sender, receiver, timeString, responseStatus, contentURL, infoText,strBrands
        );
    }
    
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
    
    // LatestProductUsage BEGIN --->
    public PageReference updateLatestProductUsage() {
        this.currentTab = 'latestProductUsageTab';
        this.usageResponse = getUsageResponse();
        return null;
    }
    
    private UsageResponse getUsageResponse() {
        if (this.usageResponse == null) {
            if (this.currentTab == 'latestProductUsageTab') {   
                if (this.account != null && !this.account.Customer_No__c.startsWith('Pending')) {     
                    calloutParameter.add('null');
                    calloutValue.add(account.Customer_No__c);
                    if(!Test.isRunningTest()){   
                        String usageXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.LATEST_PRODUCT_USAGE_METHOD, calloutParameter, calloutValue);
                        this.usageResponse = parseLatestProductUsage(usageXmlResponse);
                    }
                    calloutParameter = new List<String>();
                    calloutValue = new List<string>();
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
    
    //addedd for SPOC-1572
    public List<bbHistoryItem> getBBHistoryItem() {   
        return this.usageResponse == null? null: getUsageResponse().bbHistoryItem;        
    }
    
    private UsageResponse parseLatestProductUsage(String xmlResponse) {
        UsageResponse result = new UsageResponse();
        ProductUsage bb,mobb,telefoni;
        List<ProductUsage> productUsages = new List<ProductUsage>();
        if (xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            while (reader.hasNext()) {
                // System.debug('Element ' + reader.getLocalName());
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
                    else if(reader.getLocalName() == 'bbHistories'){
                        result.bbHistoryItem = parseBBHistory(reader);                        
                        system.debug('bbbhistory: '+result.bbHistoryItem);
                        
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
                    String maxLimitGB = String.valueOf(clsBBForbrug.convertMBtoGB(reader));
                    if (maxLimitGB.equals('0.0')) {
                        result.maxLimit=System.Label.No.toUpperCase();
                    } else {
                        result.maxLimit=maxLimitGB + ' GB';
                    }                    
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
                // System.debug('-Element ' + reader.getLocalName());
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
        public List<bbHistoryItem> bbHistoryItem;    //broadband history SPOC-1572
        
    }
    
    public class ReturnPathActivatedItem {
        public String returnPathDate{get;set;}
        public String boxUseFirstDate{get;set;}
    }
    
    //start of broadband History SPOC-1572
    private List<BBHistoryItem> parseBBHistory(XmlStreamReader reader) {
        List<BBHistoryItem> BBHistoryItemList = new List<BBHistoryItem>();
        BBHistoryItem result = new BBHistoryItem();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'bbHistories') {
                    break;
                }   
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'bbHistory') {
                    result=parseBBHistoryItem(reader);
                    BBHistoryItemList.add(result);
                }
            }
            reader.next();
        }
        
        return BBHistoryItemList;
        
    }
    
    private BBHistoryItem parseBBHistoryItem(XmlStreamReader reader) {
        String bbProduct, bbProductName, bbValidFrom, bbValidTo;     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'bbHistory') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'product') {
                        reader.next();
                        bbProduct = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'productName') {
                        reader.next();
                        bbProductName = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'validFrom') {
                        reader.next();
                        bbValidFrom = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'validTo') {
                        reader.next();
                        bbValidTo = checkEmptyElement(reader);
                    }
                }
            }
            reader.next();
        }
        return new BBHistoryItem(bbProduct,bbProductName, bbValidFrom, bbValidTo);
    }
    
    public class BBHistoryItem {
        public String bbProduct{get;set;}
        public String bbProductName {get; set;} 
        public String bbValidFrom {get; set;} 
        public String bbValidTo {get; set;} 
        
        public BBHistoryItem(){}
        
        public BBHistoryItem (String bbProduct, String bbProductName, String bbValidFrom, String bbValidTo) {
            this.bbProduct = bbProduct;
            this.bbProductName = bbProductName;            
            try {
                system.debug('bbValidFrom: '+bbValidFrom);              
                this.bbValidFrom  = ConvertDateTime(bbValidFrom);               
            } catch(Exception e) {
                this.bbValidFrom = '';
            }
            try {
                system.debug('bbValidTo: '+bbValidTo);              
                this.bbValidTo = ConvertDateTime(bbValidTo);               
            } catch(Exception e) {
                this.bbValidTo = '';
            }
            
        }
        private String ConvertDateTime(String datetimestr){
            DateTime dt = (DateTime)json.deserialize('"'+datetimestr+'"', datetime.class);
            return dt.format('dd-MM-yyyy HH:mm:ss');
        }
    }
    
    
    //end of broadband history SPOC-1572
    // LatestProductUsage END --->
    
    
    public class ProductItem {
        
        public ProductItem() {}        
        private Account account;
        private String customerId; 
        private String subscription;
        private String Discount;//SPOC 2203
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
        private String customerType;
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
        private String accountType; 
        private String cabletype; 
        private String subType;
        private String productStart; //2244 new col
        private String productEnd; //2244 new col
        private String subscriptionType; //2244 new col
        private String productKey; //Spoc-2244 col
        //private String producttype;
        // Added as per new requirement on 29/8/13 to add product Variant in colums to display
        private String productVariant;
        private Boolean youBioTelefoniSub = false;
        public Boolean getYouBioTelefoniSub(){
            return youBioTelefoniSub;
        }        
        public Integer Index{get; private set;}
        
        // Added for SPOC-1392
        /* commented for SPOC-1392
private String linkUrl ;
private boolean showLink = false;

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
linkUrl = clsProductsYKController_V3_Admin.mBillUrl + 'account='+vMobileNumber;
}
else {
linkUrl = mBillOnphoneUrl;
}
this.showLink = true;
}
else 
linkUrl = ''; 
}
}*/
         public void setCustomerType(String customerType) {          
            this.customerType = customerType;
        }
        public String getCustomerType() {
            return this.customerType;
        }
        //        
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
        
        public String getAccountType(){
            return accountType;
        }
        
        public void setAccountType(String accountType){
            this.accountType = accountType;
        }
        
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
        public String getSubscriptionType() {
            return subscriptionType;
        }
        
        public void setSubscriptionType(String subscriptionType) {
            this.subscriptionType = subscriptionType;
        }  
        public String getPayerID() {
            return payerID;
        }
        
        public void setPayerID(String payerID) {
            this.payerID = payerID;
        }
        public String getCableType() {
            return cabletype;
        }
        
        public void setCableType(String cabletype) {
            this.cabletype= cabletype;
        }
        public String getSubType() {
            return subType;
        }
        public void setSubType(String subType) {
            this.subType= subType;
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
        
        public String getDiscount() { //SPOC-2203
            return this.Discount;
        }
        
        public void setDiscount(String Dis) { //SPOC-2203
            this.Discount = Dis;
        }
        
        public String getActive() {
            return this.active;
        }
        
        public void setActive(String act) {
            /*if (act == '1') {
this.active = 'Yes';    
} else {
this.active = 'No';
}*/
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
        
        public String getproductVariant(){
            
            return this.productVariant;
        }
        
        public void setproductVariant(String productVariant){
            this.productVariant = productVariant;
        }
        
        public String getproductKey(){ //SPOC-2244 additional parameter
            return productKey;
        }
        public void setproductKey(String productKey){
            this.productKey = (productKey);
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
            String contentURL, String infoText,String brand
        ) {
            // CARRIE-977: When there is no subject & there is a URL,
            // set subject to '-' so that it is possible to click the link
            this.subject = (subject == '' && contentURL != '') ? '-' : subject;
            
            this.category = category;
            this.type = type;
            this.sender = sender;
            this.receiver = receiver;
            
            try {
                
                if( brand == 'Blockbuster'){              
                    String st = timeString.replace('T', ' ').replace('.000', '');
                    this.timeDate = datetime.valueOf(st).format('dd-MM-yyyy')+' '+datetime.valueOf(st).format('HH:mm');
                }
                else{
                    Date dt = Date.valueOf(timeString);
                    this.timeDate = dt.format();
                }
                
            } catch(Exception e) {
                system.debug(e.getmessage());
                this.timeDate = '';
            }
            this.responseStatus = responseStatus;
            this.contentURL = contentURL;
            this.infoText = infoText;
            this.mouseOverText = infoText == '' ? subject : infoText;
        }
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
        if(!Test.isRunningTest()){
            try {
                HttpResponse res = http.send(req);
                ApexPages.Message sasResponse = new ApexPages.Message(ApexPages.Severity.INFO,'SAS Response = ' + res);
                //ApexPages.addMessage(sasResponse);
                //System.debug('send sas response' + res);
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
    
    public static Boolean getYouBioAndTelefoniProducts(String custID) {
        // System.debug('$$$$Inside method getYouBioAndTelefoniProducts');
        if (custID != null) {
            youBioProductsXmlResponse = YouBiocallout(clsConnectionUtils_Admin.END_POINT + clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, custID);
        }     
        system.debug('@!!!!!!!!!Last ' + youBioProductsXmlResponse);      
        YouBioAndTelefoniProducts = parseYouBioProducts(youBioProductsXmlResponse);
        return YouBioAndTelefoniProducts;                        
    }
    
    private static Boolean parseYouBioProducts(String XmlResponse) { 
        // System.debug('###Inside parseYouBioProducts');      
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return null;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseTempProduct(reader);
                        if(product.getBusinessGroup()=='youbio' || product.getBusinessGroup()=='telefoni'){
                            //System.debug('$$$$$Inside youbio & telefoni ');
                            //product.youBioTelefoniSub = true;
                            subYouBio = true;
                        }
                        products.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return null;
        }
        return subYouBio;
    }
    
    
    private static ProductItem parseTempProduct(XmlStreamReader reader) {
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    
                    if ((reader.getLocalName() == 'BUSINESS_GROUP') || (reader.getLocalName() == 'businessArea')) {
                        reader.next();
                        product.setBusinessGroup(checkEmptyYouBioElement(reader));
                    }
                }  
            }
            reader.next();
        }
        return product;
    }
    
    private static String checkEmptyYouBioElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
    
    private static String YouBiocallout(String endpoint, String body) {
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
            system.debug('body '+body);
            // System.debug('endpoint: ' + endpoint);
            /// System.debug('res: ' + res);
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
                //  System.debug('response' + response);
                return response;                
            }
        }
        return null;     
    }
}