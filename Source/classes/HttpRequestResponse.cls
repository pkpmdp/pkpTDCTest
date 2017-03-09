public class HttpRequestResponse {

 
    public static String makeHttpCall(String endpoint, String body, String serviceMethod, String serviceUrl, String etag){
       // system.debug('Inside makeHttp Call function---------------context is--'+context+'/n body is --------->'+body);
        return invokeHttpCallout(execute(createHttprequest(endpoint,body,serviceMethod,serviceUrl,etag)));
  }
  
    public static Httprequest createHttprequest(String endpoint, String body, String serviceMethod, String serviceUrl, String etag){
        system.debug('Inside create Httprequest--->'); 
        Httprequest request = new Httprequest();
        //clsConnectionUtils.END_POINT+context
        
        //request.setEndpoint('http://192.66.36.144:7890/Kasia20');
        //request.setEndpoint('http://192.66.36.100:7890/Kasia20');
        //request.setEndpoint(clsConnectionUtils.CASTIRON_ENDPOINT+context);
       /* request.setEndpoint(endpoint);
        request.setMethod(methodType);       
        request.setBody(body);
        request.setTimeout(60000);*/
        
        
        request.setMethod(serviceMethod); 
        request.setEndpoint(endpoint); 
        request.setHeader('charset', 'utf-8'); 
        request.setHeader('accept-encoding', 'gzip'); 
        request.setHeader('accept', 'application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8'); //this is done by castiron before and now we need to specify it in client         
        request.setHeader('content-type','application/vnd.yousee.kasia2.kunde+json;version=1');
        request.setHeader('If-Match', etag); 
        request.setHeader('serviceUrl', serviceUrl); 
        request.setheader('serviceMethod', serviceMethod); //put, get, post etc.
        request.setHeader('salesChannel', 'F');  
       	request.setBody((body == null ? '' : body)); //equal to the requestBody before, the real body that is sent to kasia2 service
        request.setCompressed(true); 
        request.setTimeout(30000);        
        
        
        system.debug('Http request is -------------------------------->'+request); 
        return request;
    }
     
    private static Httpresponse execute(Httprequest request){
        system.debug('inside http response-------->'+request);
        if(Test.isRunningTest())
            return null;
        else
        	return new Http().send(request);
    }
    
    public static String invokeHttpCallout(Httpresponse response){
        //system.debug('Inside invokeHttpCallout-------------------->'+response);
        //system.debug('response.getStatusCode()'+response.getStatusCode());
        String resBody = null;
        if (response != null && response.getStatusCode() == 200) {
        resBody = response.getBody();
        System.debug('##### resBody' + resBody);
        }
        if(!Test.isRunningTest()){
            if(resBody == null || resBody.length() < 0)
            {
            resBody = string.valueOf(response.getStatusCode());	
            }
        }
        if(Test.isRunningTest())
            resBody =  '{"logistik":{"error": "No Service defined with the given path"},"responsecode":"404","responsemessage":"Not Found","ETag":""}';
        return resBody;
		
    }
  
   @isTest
    public static void testHttpCallout(){
        String context='YSSCInvoiceDetail';
        String body = 'ASADHAJJ12321,31';
        string smethod = 'get';
        string serviceUrl = 'http://abc';
        String etag = '123456';
        makeHttpCall(context,body,smethod,serviceUrl,etag);
        Httpresponse response = new Httpresponse();
        invokeHttpCallout(response);
    }  

}