public class clsConnectionUtils_Admin {
    //It's not  used in any callout.
    public static final String END_POINT =
        END_POINT__c.getInstance('END_POINT_YOUPROD2') != null ?
        END_POINT__c.getInstance('END_POINT_YOUPROD2').END_POINT__c + '/' :
        null
    ;
    public static final String WEB_TO_CASE_METHOD = 'sfapiWebToCase'; 
    public static final String EXISTING_PRODUCTS_CUSTOMERS_METHOD = 'YK7Inbound';
    public static final String EXISTING_PRODUCTS_ADDRESSES_METHOD = 'YK8Inbound';    
    public static final String POTENTIAL_PRODUCTS_ADDRESSES_METHOD = 'YK6Inbound';
    public static final String OVERNIGHT_PRODUCTS_CUSTOMERS_METHOD = 'YK5Inbound';
    public static final String SAS_PRODUCTS_CUSTOMERS_METHOD = 'SAS_Churn';
    public static final String CAMPAIGN_HISTORY_CUSTOMERS_METHOD = 'YK13InboundCustomer';
    public static final String CAMPAIGN_HISTORY_LEADS_METHOD = 'YK13InboundLead';
    public static final String OVERNIGHT_PRODUCTS_RESPONSE_METHOD = 'YK5Update';   
    public static final String SAS_PRODUCTS_RESPONSE_METHOD = 'SAS_Churn_Update';        
    public static final String UPDATE_CASPER_METHOD = 'YK9_FindInCasper';
    public static final String UPDATE_CASPER_ADDRESS_METHOD = 'YK9_FindInCasperAddress';
    public static final String EXISTING_ACTIVITY_LOGS_METHOD = 'YK3getCustomerInquiries';
    public static final String ADD_ACTIVITY_LOG_METHOD = 'YK3addCustomerInquiry';
    public static final String MOBILEBB_METHOD = 'GetMobbForbrug';
    public static final String NEW_CAMPAIGN_HISTORY_CUSTOMER = 'ContactHistoryInboundCustomer';
    public static final String NEW_CAMPAIGN_HISTORY_LEAD = 'ContactHistoryInboundLead';
    public static final String CASE_SEARCH_BY_ANLAEGNR = 'GetDebitorInbound';
    public static final String New_SAS_PRODUCTS_RESPONSE_METHOD = 'UpdateSASOffers';
    public static final String New_SAS_PRODUCTS_CUSTOMERS_METHOD = 'GetSASOffers';
    public static final String REPROVISION_METHOD = 'getCustomerProductGroup';
    public static final String MDB_BUTTON_METHOD = 'getCasperId';
    public static final String LATEST_PRODUCT_USAGE_METHOD = 'getProductLatestUsages';   
    //KM: public static final String SERVICECENTER_ENDPOINT = END_POINT__c.getInstance('END_POINT').END_POINT__c + '/';
    public static final String SERVICECENTER_ENDPOINT =
        END_POINT__c.getInstance('END_POINT') != null ?
        END_POINT__c.getInstance('END_POINT').END_POINT__c + '/' :
        null
    ;
    public static final String QUICK_PRODUCT_INFO_METHOD = 'getSPOC21Activities';
    public static final String SMS_SERVICE_METHOD = 'SPOC440SMSMockup';
    public static final String CUSTOMER_ADDRESSES_METHOD = 'getCustomerAddress';
    public static final String CABLEUNITNOTE_METHOD = 'getAnlaegBemaerkninger';
    public static final String ORDER_INFO_SPOC_WEASEL_METHOD = 'getOrderInfo';
    
    public static String getEndPoint(String serviceName){
        String serName = INTEGRATION__c.getInstance(serviceName) != null ?  
                         END_POINT__c.getInstance(INTEGRATION__c.getInstance(serviceName).Service__c) != null ?
                         END_POINT__c.getInstance(INTEGRATION__c.getInstance(serviceName).Service__c).END_POINT__c + '/' : null : null; //if above statement is not null execute this
                         
        serName += serviceName;
        return serName;
    }
    
    //EDM-637 START
    public Static String callout1(String serviceName, List<String> callParameter, List<String>callValue) {
        // Make the callout and check the response  
        // EDM-637 start
        String bodyText = '';
        String body='';
        List<String> str  = new List<String>();
        if(String.isNotBlank(INTEGRATION__c.getInstance(serviceName).Params__c)){
            bodyText = INTEGRATION__c.getInstance(serviceName).Params__c;
             str =  bodyText.split(';');
        }
        String endpoint = clsConnectionUtils_Admin.getEndPoint(serviceName);
       
        if(INTEGRATION__c.getInstance(serviceName).isBodyAppended__c == false){
            for(Integer i=0;i<callValue.size(); i++){
                if(i>0)
                    endpoint = endpoint + '&';
                else
                    endpoint += '?';
                 if(!str.isEmpty())
                    endpoint = endpoint +  str[i] + '=' + callValue[i];
                 else
                    endpoint = endpoint + callValue[i];
            }
        }else{
            for(Integer i=0;i<callValue.size(); i++){
                 if(callParameter[i] == 'null'){
                    body = body + callValue[i];
                     system.debug('body'+body);
            }
            else{
                body = body + callParameter[i] + '=' + callValue[i];
                system.debug('body'+body);
            }
        }
        }   
        /*
        String endpoint = clsConnectionUtils_Admin.getEndPoint(serviceName);
        if(String.isNotBlank(bodyText))
            endpoint = endpoint + '?' + bodyText + '=' + body;
        */
        system.debug('body'+body);
        System.debug('******endPoint*****'+endpoint);      
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        //req.setMethod('GET');
        req.setMethod(String.isBlank(INTEGRATION__c.getInstance(serviceName).HttpMethod__c)?'GET':INTEGRATION__c.getInstance(serviceName).HttpMethod__c);
        req.setEndpoint(endpoint);
        req.setTimeout(120000);
        system.debug('**********body*********'+body);
        if(String.isBlank(bodyText)) 
            // bodyText blank indicates that params are not requried for request and hence we are setting the body
           // req.setBody((body == null ? '' : body));
        {
           system.debug('**********body*********'+body);
            system.debug('**********bodyText*********'+bodyText);
            req.setBody((body == null ? '' : body));
        }
        //SPOC-2244 For YK7
        /*else{
            req.setBody('');
            req.setHeader('charset', 'utf-8');
            req.setHeader('accept-encoding', 'gzip');
            req.setCompressed(true);
            req.setTimeout(120000);
        }*/
            
        HttpResponse res;
        try {
            system.debug('req'+req);
            res = http.send(req);
            System.debug('endpoint: ' + endpoint);
            System.debug('res: ' + res);
            //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'http response=' + res);
            //ApexPages.addMessage(resValue);
          //  calloutParameter = new list<String>();
          //  calloutValue = new List<String>();        
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response 
                String response = res.getBody().trim();
                System.debug('response' + response);
                return response;                
            }
        }
        return null;    
    }
    //EDM-637 END
    //SPOC-2244
    public Static Net_Installations__c getInstallationSeq(string amsId,string CableType)
    {
        
        list<Net_Installations__c> listsngleInstalltn = new list<Net_Installations__c>();
        for(Net_Installations__c ni : [select Id,INSTALLATION_ID__c,Cable_Type_del__c, Cable_Unit_No__c from Net_Installations__c where Name=:amsId and Cable_Type_del__c=:CableType])
        {
            listsngleInstalltn.add(ni);
        }
        if(listsngleInstalltn.isEmpty())
        	return null;
        else
            return listsngleInstalltn[0];
    }
}