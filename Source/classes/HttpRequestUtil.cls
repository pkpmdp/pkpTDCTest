public class HttpRequestUtil {

    public static boolean TEST_MODE = false;
    //public static final String SERVICECENTER_ENDPOINT = END_POINT__c.getInstance('END_POINT').END_POINT__c + '/';
    public static final String SERVICECENTER_ENDPOINT = ServiceCenter_CustomSettings__c.getInstance('Service_Center_End_Point').Value__c + '/';
    public static String makeHttpCall(String context,String body){
        return invokeHttpCallout(execute(createHttprequest(context,body)));
    }
    
   
    public static Httprequest createHttprequest(String context,String body){
        Httprequest request = new Httprequest();
        request.setEndpoint(SERVICECENTER_ENDPOINT+context);
        //request.setEndpoint(clsConnectionUtils.CASTIRON_ENDPOINT+context);
        request.setMethod('POST'); 
        request.setBody(body);
        System.debug('#Request#'+request);
        //request.setTimeout(60000);
        request.setTimeout(120000);
        return request;
    }
    
    /* Start of New Service due to Kasia Header Change Dated 25 Oct 2013 
    
    public static String makeHttpCallWithHeader(String context,String body){
        return invokeHttpCallout(execute(createHttprequestWithHeader(context,body)));
    }*/
    
  	/*
    public static Httprequest createHttprequestWithHeader(String context,String body){
        Httprequest request = new Httprequest();
        request.setEndpoint(SERVICECENTER_ENDPOINT+context);
        //request.setEndpoint(clsConnectionUtils.CASTIRON_ENDPOINT+context);
        request.setMethod('POST'); 
        request.setBody(body);
        request.setHeader('content-type','application/vnd.yousee.kasia2.kunde+json;version=1');
        System.debug('#Request#'+request);
        request.setTimeout(60000);
        return request;
    }*/
    
    /* End of New Service due to Kasia Header Change Dated 25 Oct 2013 */
        
    public static Httpresponse execute(Httprequest request){
        if(!TEST_MODE){
            return new Http().send(request);
        }
        return null;    
    }
    
    public static String invokeHttpCallout(Httpresponse response){
        String resBody = null;
        if (response != null && response.getStatusCode() == 200) {
          resBody = response.getBody();
        }
        System.debug('Response****'+resBody);
        // Added for checking response null
        //resBody = null;
        return resBody;
    }
  
    /*@isTest
    public static void testHttpCallout(){
        String context='YSSCInvoiceDetail';
        String body = 'ASADHAJJ12321,31';
        createHttprequest(context,body);
        Httpresponse response = new Httpresponse();
        invokeHttpCallout(response);
    }*/  

}