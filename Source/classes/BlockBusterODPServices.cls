public with sharing class BlockBusterODPServices {

    public static final String strODPDomain = System.Label.ODPDomain;
    public static final String strPath = strODPDomain+'rest/billing/';
    public static final BlockBusterODP__c BBODPCust = BlockBusterODP__c.getInstance(); 
    
    public static HttpResponse getKlipsStatus(String AriaAcc){
        
        String endPoint = strPath+'clipcard_status/flavour/'+BBODPCust.flavour__c+'/customernumber/'+AriaAcc;
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        req.setHeader('X-API-Key',BBODPCust.APIKey__c);
        Blob headerValue = Blob.valueOf(BBODPCust.username__c+':'+BBODPCust.password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endPoint);
        req.setMethod('GET'); 
        system.debug('request==='+req);
        if(!test.isRunningTest())
        	res = http.send(req);
        
        //System.debug('RESPONSE========>'+res.getBody());
        return res;
    }
    
    public static HttpResponse cancelKlips(string lstFaktura,String ref,string includeused){
        
        System.debug('***lstFaktura***'+lstFaktura+'****includeused*****'+includeused);
        String endPoint = strPath+'clipcard_refund/';
        system.debug('Cancel klip ******* '+ref);
            //flavour/'+BBODPCust.flavour__c+'/customernumber/'+lstFaktura+'/clipcardref/'+ref;
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        req.setHeader('X-API-Key',BBODPCust.APIKey__c);
        Blob headerValue = Blob.valueOf(BBODPCust.username__c+':'+BBODPCust.password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        /*Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('flavour',BBODPCust.flavour__c);
        mapEmp.put('customernumber',lstFaktura);
        mapEmp.put('clipcardref',ref);
        String JSONString = JSON.serialize(mapEmp); */
        //May required customer no.
        String body = 'flavour=blockbuster&customernumber='+lstFaktura+'&clipcardref='+ref+'&includeused='+includeused;
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(body);
        req.setTimeout(2000);
        if(!Test.isRunningTest())
        {
        	system.debug('request==='+req);
        res = http.send(req);
        //System.debug('Cancel klip ******* RESPONSE========>'+res.getBody());
        }
        
        return res;
    }
    
    public static HttpResponse getCreditTransaction(String CustomerNo){
        
        String endPoint = strPath+'creditcard_transaction/flavour/'+BBODPCust.flavour__c+'/customernumber/'+CustomerNo;
        system.debug('endPoint ******* '+endPoint);
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        req.setHeader('X-API-Key',BBODPCust.APIKey__c);
        Blob headerValue = Blob.valueOf(BBODPCust.username__c+':'+BBODPCust.password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endPoint);
        req.setMethod('GET'); 
        system.debug('request==='+req);
        if(!test.isRunningTest())
        	res = http.send(req);
        if(test.isRunningTest())
        {
        	//HttpResponse res = new HttpResponse();
        	res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"creditcardtransactions":[{"customernumber":"628281511","orderid":"1436454","createtime":"2014-12-16 15:35:02","type":"movie","title":"Never Back Down","product_id":"VODK0000014320010001","totalprice":"2900","koda":"74"},{"customernumber":"628281511","orderid":"1436453","createtime":"2014-12-16 15:32:13","type":"movie","title":"Frank Hvam - Upassende","product_id":"VODK1900000400010001","totalprice":"3900","koda":"96"},{"customernumber":"628281511","orderid":"1436452","createtime":"2014-12-16 15:31:24","type":"movie","title":"Cop Out","product_id":"VODK0500001450010001","totalprice":"2900","koda":"81"},{"customernumber":"628281511","orderid":"1436450","createtime":"2014-12-16 15:29:45","type":"movie","title":"Monster High - Monsterfusion","product_id":"VODK0600005410010001","totalprice":"3900","koda":"96"},{"customernumber":"628281511","orderid":"1436449","createtime":"2014-12-16 15:15:22","type":"movie","title":"Ormen","product_id":"VODK0600001540010001","totalprice":"1900","koda":"81"},{"customernumber":"628281511","orderid":"1436448","createtime":"2014-12-16 15:14:36","type":"movie","title":"Librarian 2","product_id":"VODK0000011670010001","totalprice":"2900","koda":"74"}]}');
        	res.setStatusCode(200);
        	
        }
        system.debug('getCreditTransaction RESPONSE========>'+res.getBody());
        return res;
    }
    
    public static HttpResponse cancelCreditTransaction(String CustomerNo,String orderid){
        
        String endPoint = strPath+'creditcard_refund';
        system.debug('endPoint ******* '+endPoint);
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        req.setHeader('X-API-Key',BBODPCust.APIKey__c);
        Blob headerValue = Blob.valueOf(BBODPCust.username__c+':'+BBODPCust.password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endPoint);
        String body = 'flavour='+BBODPCust.flavour__c+'&customernumber='+CustomerNo+'&orderid='+orderid;
		req.setBody(body);
        req.setMethod('PUT'); 
        system.debug('body   '+body);
        system.debug('request==='+req);
        if(!test.isRunningTest())
        	res = http.send(req);
        if(test.isRunningTest())
        {
        	//HttpResponse res = new HttpResponse();
        	res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"Refunded orderid":"1436250"}');
        	res.setStatusCode(200);
        	
        }
                	
        System.debug('cancelCreditTransaction RESPONSE========>'+res.getBody());
        return res;
    }
    
}