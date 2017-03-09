public class fritValgSpocController {	
    public String accountID{get;set;}
    public Account account{get;set;}
    public Address__c address;
    public String amsID{get;set;}
    public String installationID{get;set;}
    public String JSONResponse{get;set;}
    public String oldJson{get;set;}
    public ApexPages.StandardController controller;
    public List<Account> accounts{get;set;}
    public List<Address__c> addresses{get;set;}
    public JsonObject jsonObj237 {get;set;}
    public String url{get; set;}
    public String etag{get; set;}
    public String kundeData{get; set;}
    public String arrayInit{get; set;}
    public String customerSubType{get; set;}
    public String aftalenr;
    public boolean addressFlag{get; set;}
    public String body;
    public String ADDRESS_SERVICE_URL = 'adresse/installationer/';
    public String SERVICE_URL;
    public String AFSAETNING_SERVICE_NAME = 'afsaetning';
    public String ADDRESS_SERVICE_NAME = 'adresse';
    public String GET_METHOD = 'GET';
    public String PUT_METHOD = 'PUT';
    public String POST_METHOD = 'POST';
    public String SALES_CHANNEL = '/K';
    public boolean newAftale{get;set;}
    public String choosedAftale{get;set;}
    public String anlaegsnr{get;set;}
    public String runFlag{get;set;}
    public String customerNr{get;set;}
    public String klientSystem{get; set;}
    public String klientFunction{get; set;}
    public String klientBruger{get; set;}
    public String statusCode{get; set;}
    public boolean isNewKundeFlag{get; set;}
    public String fullAddress{get; set;}
    public String title{get; set;}
    public static boolean TEST_MODE = false;
    
    public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    private final String END_POINT = castIronEndPoint.END_POINT__c;
    public END_POINT__c KasiaEndPoint = END_POINT__c.getInstance('Kasia_EndPoint');
    private final String kasia_EndPoint =  KasiaEndPoint.END_POINT__c;
        
    public fritValgSpocController(ApexPages.StandardController controller) {
        System.debug('************in the controller constructor begin');
        statusCode = '0';
        customerNr = '0';
        accountID = '0';
        this.controller = controller;
        addressFlag = false;
        if(System.currentPageReference().getParameters().get('amsID') != null){
            System.debug('*******Null check********' + System.currentPageReference().getParameters().get('amsID'));
            addressFlag = true;
            amsID = System.currentPageReference().getParameters().get('amsID');
            addresses = [Select a.Id, a.External_Id__c, a.Town__c, a.Street__c, a.Postcode__c, a.House_No__c From Address__c a where a.External_Id__c =: amsID limit 1];
            address = addresses[0];
            fullAddress = address.Street__c + ', ' + address.House_No__c + ', ' + address.Postcode__c; 
            account = new Account(); 
        }
        if(!addressFlag){   
            SObject obj = controller.getRecord();
            account = (Account)obj;
            accountID = account.Id;
            System.debug('accountID: '+accountID);
            accounts = [Select a.name, a.Customer_No__c, a.Salutation, a.FirstName, a.LastName, a.Phone, a.Home_Phone__c, a.PersonHomePhone, a.PersonMobilePhone, a.PersonEmail, a.No_Email__c, a.Permission__c, a.No_Thankyou__c, a.AddressId__c, a.Street_YK__c, a.CustomerSubType__c From Account a where a.id =: accountID limit 1];
            if(accounts.size() > 0) {
                account = accounts[0];
                amsID = account.AddressId__c;
                customerSubType = account.CustomerSubType__c;                         
            }
        }
        installationID = callToInstallationService(amsID);
        System.debug('$$$$$ installationID: ' + installationID);
        SERVICE_URL = '/'+AFSAETNING_SERVICE_NAME+'/'+amsID+'/'+installationID+SALES_CHANNEL;
        if(!addressFlag){
            customerNr = account.Customer_No__c;
            SERVICE_URL = SERVICE_URL + '/' + customerNr;    
        }
        
        System.debug('first call: '+GET_METHOD+SERVICE_URL);
        //preprod        
        //String response = callout('http://213.174.69.111:7890/Kasia20', 'GET /afsaetning/'+amsID+'/'+installationID+'/K/'+customerNr+' !#$ !#$ ');
        String response = callout2('', GET_METHOD, SERVICE_URL, '', AFSAETNING_SERVICE_NAME);
        JSONResponse = response;
        oldJson = response;
        newAftale = true;
        System.debug('************in the controller constructor finish');              
    }
    
    public String callToInstallationService(String amsId){
        String SERVICE_URL = ADDRESS_SERVICE_URL + amsId;
        System.debug('before call: ' + SERVICE_URL);
        Integer index;
        String addressJsonResponse = '', status = '', installationNr = '1';
        try {
            //calling address service for amsid
            addressJsonResponse = callout2('', GET_METHOD, SERVICE_URL, '', ADDRESS_SERVICE_NAME);
            if(TEST_MODE){
                addressJsonResponse = '[{"under_flytning":"N","dummy":"N","anlaeg":"0002000139","status":1,"installation_lbnr":"1","lokation":""}]';
            }
            /************ Changes made for FRITVALG-237 ************/
            if(addressJsonResponse != ''){        
				List<Object> addressList = (List<Object>)JSON.deserializeUntyped(addressJsonResponse);
				system.debug('addressList in callToInstallationService ----------' +addressList);
				for(Object add : addressList){
					Map<String, Object> addressMap = (Map<String, Object>)add;
					system.debug('addressMap' + addressMap);				
					status =  String.valueOf(addressMap.get('status'));	
					if(status == '1' || status == '2'){
		            	installationNr =  String.valueOf(addressMap.get('installation_lbnr'));
		            }
	            	system.debug(status + ' <-- status + installationNr --> ' + installationNr);
				}				
            }
            return installationNr;
        } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Response error in installation service, please contact system administrator');
                ApexPages.addMessage(m);
        }
        return '';
    }
    
    public PageReference callToKasia(){
        //String serviceURL = url.split('dk')[1];
        String body = '{"kunde-data":' + kundeData + ', "array-init":' + arrayInit + '}';
        return callToKasia2(PUT_METHOD, url, body);
    }
    
    public PageReference callToCasper(){
       if(!TEST_MODE)
         clsCasperButton.sendToCasper(accountID);
       //System.debug('casper value : ' + f);
       return null;
    }
    
    private String callout2(String body, String serviceMethod, String serviceUrl, String etag, String application) {
        // Make the callout and check the response
        System.debug('*********call out general method begin');  
        System.debug('header: '+'application/vnd.yousee.kasia2.'+application+'+json;version=1;charset=UTF-8');
        System.debug('serviceUrl: '+serviceUrl);
        System.debug('serviceMethod: '+serviceMethod);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String response = ''; 
        req.setMethod('GET');
        req.setEndpoint(END_POINT+'/Kasia20');
        req.setHeader('charset', 'utf-8');
        req.setHeader('accept-encoding', 'gzip');
        req.setHeader('accept', 'application/vnd.yousee.kasia2.'+application+'+json;version=1;charset=UTF-8');
        req.setHeader('If-Match', etag);
        req.setHeader('serviceUrl', serviceUrl);
        req.setHeader('serviceMethod', serviceMethod);
        req.setHeader('salesChannel', 'K');
        req.setBody((body == null ? '' : body));
        req.setCompressed(true);
        req.setTimeout(30000);        
        HttpResponse res;
        try {
            if(!TEST_MODE)
              res = http.send(req);
        } catch (Exception e) {
            System.debug('****call castiron error');
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null || TEST_MODE) {
            if (TEST_MODE || (res.getStatusCode() == 200 || res.getStatusCode() == 201)) { //res.getStatusCode() will get the castiron response code(call between salesforce and castiron)
              try{   // Good response
                if(!TEST_MODE){ 
                  response = res.getBody();
                  System.debug('response----->' + response);
                }else{
                    response = '{"errorcode":"404","fejl":"Not Found","exception":"java.lang.AssertionError: Assert failed: (chk 404 (is-empty? %))"}';
                } 
                 
                if(response.contains('\"errorcode\":\"404\"')){
                  if(response.contains('fejl')){     
                    JSONObject jsonObj = new JSONObject(response);
                    system.debug('==>Error response for 404 : ============== :' + jsonObj.getValue('fejl').str);
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, jsonObj.getValue('fejl').str);
                    ApexPages.addMessage(m);
                  }else{
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Ingen installationsmulighed');
                    ApexPages.addMessage(m);                                        
                  } 
                  if(!TEST_MODE)  
                      return '';  
                }
                if(TEST_MODE){
                    response = '{"errorcode":"500","errormessage":"Not Found","exception":"java.lang.AssertionError: Assert failed: (chk 404 (is-empty? %))"}';
                }
                if(response.contains('\"errorcode\":\"500\"')){ 
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Response error 500, please contact system administrator.');
                    ApexPages.addMessage(m);
                    if(!TEST_MODE)  
                      return '';
                }
                system.debug('response in callout2: '+response);
                return response; 
              }catch (Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, res.getBody());
                ApexPages.addMessage(m);
                if(!TEST_MODE)  
                   return '';
              }                    
            } else {
                System.debug('****Castiron return code is not 200');
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Response error from Castiron, please contact system administrator.');
                ApexPages.addMessage(m);
                if(!TEST_MODE)    
                  return '';
            }
         } else {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'JSON Response is null.');
            ApexPages.addMessage(m); 
         }
        System.debug('*********call out general method finish');
        return '';    
    }
    
    public PageReference chooseAftale() {
        runFlag = 'true';
        //String serviceURL = choosedAftale.split('dk')[1];
        String body = '{"kunde-data":' + kundeData + ', "array-init":' + arrayInit + '}';
        return callToKasia2(PUT_METHOD, choosedAftale, body);                
    }
    
     public PageReference bookOrder(){
        try{
            String bestilInfo = '', accountIdNewCustomer = '';
            //String serviceURL = url.split('dk')[1];
            String userid=  UserInfo.getUserId();
            List<User> users = [Select u.MID__c From User u where u.id=: userid];
            String mid = users.get(0).MID__c;        
            System.debug('$$$addressFlag: '+addressFlag+ 'isNewKundeFlag: $$$'+isNewKundeFlag);
            if(addressFlag){
                accountIdNewCustomer = createKundeInKasia(amsID, account.FirstName, account.LastName);
            }   
            if(isNewKundeFlag){
                bestilInfo = '{"kundeid" : "' + accountIdNewCustomer + '", "klient-system" : "TRIPLE", "klient-funktion" : "' + klientFunction + '", "klient-bruger" : "' + mid + '"}';
            }else{
                bestilInfo = '{"klient-system" : "TRIPLE", "klient-funktion" : "' + klientFunction + '", "klient-bruger" : "' + mid + '"}';
            }   
            //serviceUrl = '/afsaetning/bestil';
            String body = '{"kunde-data":' + kundeData + ', "array-init":' + arrayInit + ', "bestil-info":' + bestilInfo + '}';
            System.debug('Request$$$: '+body);
            String response = callout2(body, POST_METHOD, url, etag, 'afsaetning');
            system.debug('response in bookOrder: '+response);
            if(response != null){                                   
                String returnCode = response.split(';')[0]; //this returnCode will get the kasia2 response code(call between castiron and kasia2)
                system.debug('returnCode: '+returnCode);
                if(returnCode == '200' || returnCode == '201' || TEST_MODE){ //201 is success code for order service, other services's success code is 200 
                    statusCode = returnCode;
                    JSONResponse = response.split(';')[1];
                    system.debug('JSONResponse in bookOrder: '+JSONResponse+' response:'+response);
                    if(addressFlag){
                        customerNr = createKundeInSalesForce(accountIdNewCustomer);
                        addressFlag = false;    
                    }
                    System.debug('******addressFlag*****'+addressFlag); 
                }else if(returnCode == '500' && response.contains('produktvalideringsfejl: Der findes aktivitet')){
                    JSONResponse = '';
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Det er ikke muligt at gennemføre ordren på denne adresse, da der er igangværende abonnement ændringer på adressen. Kontakt venligst Forhandler support.');
                    ApexPages.addMessage(m);
                }else{
                    JSONResponse = '';
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, response);
                    ApexPages.addMessage(m); 
                }
            }
        }catch(exception ex){
                 ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,ex.getMessage());
                 ApexPages.addMessages(ex); 
        }
        return null;                
    }
    
    public PageReference reset(){
        runFlag = 'false';
        SERVICE_URL = '/'+AFSAETNING_SERVICE_NAME+'/'+amsID+'/'+installationID+SALES_CHANNEL;
        if(!addressFlag){
            SERVICE_URL = '/'+AFSAETNING_SERVICE_NAME+'/'+amsID+'/'+installationID+SALES_CHANNEL+'/'+customerNr;    
        }
        
        //preprod        
        //String response = callout('http://213.174.69.111:7890/Kasia20', 'GET /afsaetning/'+amsID+'/'+installationID+'/K/'+customerNr+' !#$ !#$ ');
        String response = callout2('', GET_METHOD, SERVICE_URL, '', AFSAETNING_SERVICE_NAME);
        JSONResponse = response;
        system.debug('JSONResponse in reset: '+JSONResponse);
        oldJson = response;
        statusCode = '0';
        newAftale = false;
        return null;        
    } 
    
    private PageReference callToKasia2(String method, String serviceUrl, String requestBody) {
        //preprod
        //String response = callout('http://213.174.69.111:7890/Kasia20', request);
        String response = callout2(requestBody, method, serviceUrl, etag, AFSAETNING_SERVICE_NAME);
        //kenfig
        //String response = callout('http://192.66.36.100:7890/Kasia20', request);
        if(response != null) {
            String returnCode = response.split('; ')[0]; //this returnCode will get the kasia2 response code(call between castiron and kasia2)
            if(returnCode == '200' || returnCode == '201'){ //201 is success code for order service, other services's success code is 200 
                statusCode = returnCode;
                JSONResponse = response.split('; ')[1];
                system.debug('JSONResponse in callToKasia2: '+JSONResponse);
            } else {
                JSONResponse = '';
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Response error from kasia2, please contact system administrator');
                ApexPages.addMessage(m); 
            }
        }
        System.debug('************in the callTokasia method finish: '+statusCode);
        return null;    
    }
    
    public String createKundeInSalesForce(String customerNr){
        try{
            RecordType accRT = [select id from recordtype where name = 'YK Customer Account'];
            account.Type='Kunde';
            account.RecordTypeId=accRT.id; 
            account.Customer_No__c = customerNr;
            account.ownerid = UserInfo.getUserId();                                                                                   
            account.Street_YK__c = address.Id;
                                      
            insert account;
            if(account != null){
                customerNr = account.Customer_No__c;
                account.name = account.FirstName + ' ' + account.LastName;
            }
            System.debug('*********************' + customerNr);
            System.debug('first name: '+account.FirstName);
            System.debug('last name: '+account.LastName);
            
            return customerNr;
        }catch(Exception ex) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Error in saving kunde details, please contact system administrator', ex.getMessage());
            ApexPages.addMessage(m); 
        }
        return '';
    }
    
    private String createKundeInKasia(String ams_id,String first_name,String last_name){
        try{
                String kundeBody ='{'+'"kundeart": "Enkel",'+
                                      '"kundetype": "Normal",'+
                                      '"amsid": "'+ams_id+'",'+
                                      '"fornavn": "'+first_name+'",'+
                                      '"efternavn": "'+last_name+'",'+
                                      '"stempel":{"af": "salesforce","fkt": "opret","sys": "TRIPLE"}}';
                
                //String body = 'POST /kunde/   !#$  !#$ ' + kundeBody;
                String response = null;
                if(!TEST_MODE){
                    response = callout2(kundeBody, POST_METHOD, kasia_EndPoint+'/kunde/', '', 'kunde');
                }
                system.debug('Kunde response: '+response);
                
                if(response!=null && !TEST_MODE){
                    JSONObject jsonObj = new JSONObject(response);
                    system.debug('Kunde ID : ============== :' + jsonObj.getValue('kunde').obj.getValue('kundeid').str);
                    return jsonObj.getValue('kunde').obj.getValue('kundeid').str;
                }else if(TEST_MODE){
                    return '2114585';
                }else{
                    return null;
                }
                
            }
        catch(exception ex){
                throw ex;
                return null;
        }
    }
   
}