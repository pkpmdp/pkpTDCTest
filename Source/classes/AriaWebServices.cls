public with sharing class AriaWebServices {
    public static final String SERVICE_PATH = 'api/ws/api_ws_class_dispatcher.php';
    public static boolean isApexTest = false;       
    
    public static HttpResponse makeCallForJson(String serviceUrl, String restCall, Long clientNo, String authKey, Map<String, String> params) {
        return makeCallForJson(serviceUrl, SERVICE_PATH, restCall, clientNo, authKey, params);
    } 
        
    public static HttpResponse makeCallForJson(String serviceUrl, String path, String restCall, Long clientNo, String authKey, Map<String, String> params) {
        if(serviceUrl == null || serviceUrl == '') {
            //throw new AriaAPIException('No Remote Site URL provided in configuration.');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Remote Site URL provided in configuration.'));
            return null;
        }        
        params.put('rest_call', restCall);
        params.put('client_no', String.valueOf(clientNo));
        params.put('auth_key', authKey);
        params.put('output_format','json');
        
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        try{
            HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
            Http h = new Http();
            if(!isApexTest){
                HttpResponse resp = h.send(req);
                if(resp.getBody().contains('sys-maint.html')||resp.getBody().contains('may be found')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.AriaException));
                    return null;
                }         
                return resp;
            }
            return null;
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    public static HttpResponse makeCallForJson(String restCall, String username, String password, Map<String, String> params) {        
        String serviceUrl = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_ServiceURL').Value__c;                
        params.put('rest_call', restCall);
        params.put('username', username);
        params.put('password', password);
        params.put('output_format','json');
        
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        
        String path = 'api/AriaQuery/objects.php';
        try{
            HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
            Http h = new Http();
            if(!isApexTest){
                HttpResponse resp = h.send(req);
                if(resp.getBody().contains('sys-maint.html')||resp.getBody().contains('may be found')){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.AriaException));
                     return null;
                }
                return resp;
            }
            return null;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    // START OF CARRIE-986 //
   public static HttpResponse makeCallForJson(String restCall, Long clientNo, String authKey, Map<String, String> params) {        
        String serviceUrl = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_ServiceURL').Value__c;                
        params.put('rest_call', restCall);
        params.put('client_no', String.valueOf(clientNo)); 
        params.put('auth_key', authKey); 
        params.put('output_format','json');
        
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        String path = 'api/AriaQuery/objects.php';
        try{
            HttpRequest req;
            //Added for SPOC-1618
            if(restCall == 'get_transaction_information'){
                req = makeRequest(serviceUrl + path, makeQs(params)+'&limit=1000');
            }
            else
                req = makeRequest(serviceUrl + path, makeQs(params));
            system.debug('Request ' + req);   
            Http h = new Http();
            if(!isApexTest){
                HttpResponse resp = h.send(req);
                if(resp.getBody().contains('sys-maint.html')||resp.getBody().contains('may be found')){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.AriaException));
                     return null;
                }
                return resp;
            }
            return null;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    } // END OF CARRIE-986 //
    
    private static String makeQs(Map<String, String> params) {
        String res = '';
        for(String key : params.keySet()) {
        	String val = params.get(key);
        	if(val.contains(',')){ // parameters passed as array
        		String[] values = val.split(',');
            	for(Integer i=0; i<values.size();i++)
            		res += key + '%5B'+i+'%5D' + '=' + urlEncode(values[i]) + '&';
        	}
        	else
        		res += key + '=' + urlEncode(params.get(key)) + '&';
        }        
        res = res.substring(0, res.length() - 1);
        return res;
    }
    
    private static HttpRequest makeRequest(String endpointUrl, String qs) {
        HttpRequest res = new HttpRequest();
        res.setEndpoint(endpointUrl);
        //res.setMethod('GET'); //CARRIE-1166
        res.setMethod('POST');
        System.debug('API Query: ' + qs);
        res.setBody(qs);
        //Added for SPOC-1618
        res.setTimeout(120000);
        System.debug('url in ariawebservice'+endpointUrl+' param :'+qs);        
        return res;
    }
    
    private static String urlEncode(String input) {
        return EncodingUtil.urlEncode(input, 'UTF-8');
    }
    
    /************************************ TEST METHODS ************************************/  
    @IsTest(SeeAllData=true) public static void testMakeCall() {
        Map<String, String> params = new Map<String, String>();
        AriaWebServices.isApexTest = true;
        AriaWebServices.makeCallForJson('https://secure.future.stage.ariasystems.net', 'test_call', 30000, 'test_key', params);
        AriaWebServices.makeCallForJson('test_call','user','password',params);
        AriaWebServices.makeCallForJson('test_call',4942283,'password',params); // CARRIE-986         
        System.assertNotEquals(null, params.get('rest_call'));
        System.assertNotEquals(null, params.get('auth_key'));
        System.assertNotEquals(null, params.get('client_no'));
        AriaWebServices.isApexTest = false;
        AriaWebServices.makeCallForJson('https://secure.future.stage.ariasystems.net', 'test_call', 30000, 'test_key', params);        
        AriaWebServices.isApexTest = false;
        AriaWebServices.makeCallForJson('test_call','user','password',params); 
        AriaWebServices.makeCallForJson('test_call',4942283,'password',params); // CARRIE-986 
    }
    
    @IsTest(SeeAllData=true) public static void testNoServiceUrlProvided() {
        Map<String, String> params = new Map<String, String>();
        AriaWebServices.isApexTest = true;
        try {           
            AriaWebServices.makeCallForJson('test_call','user','password',params);
            AriaWebServices.makeCallForJson('test_call',4942283,'password',params); // CARRIE-986 
            AriaWebServices.makeCallForJson(null, 'test_call', 30000, 'test_key', params);            
        } catch(AriaAPIException e1) {
            try {
                AriaWebServices.makeCallForJson('', 'test_call', 30000, 'test_key', params);                
            }
            catch(AriaAPIException e2) {}
        }       
    }
}