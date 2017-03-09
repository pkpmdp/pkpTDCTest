public with sharing class NetsFeeCallOut {

    public static boolean isApexTest = false;  
    public static final String endPoint = System.Label.NetsFeePSEndPoint;
    public static final String strClientSource = System.Label.NetsFeePSClientSource;
    public static final String strBillingSystem = System.Label.NetsFeePSBillingSystem;
    public static final String strDIBSmerchantId = NetsFee_DIBS_Settings__c.getInstance().Merchant_Id__c;
    public static final String stripspId = 'DIBS';
    public static final String strOrderId = NetsFee_DIBS_Settings__c.getInstance().Order_Id__c;
    
    public static String GetUserIPAddress() {
    
        string ReturnValue = '';
        Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();
        if(mapHeaders != null){
            ReturnValue = mapHeaders.get('True-Client-IP');
            if(ReturnValue == null){
                ReturnValue = mapHeaders.get('X-Salesforce-SIP');
            }
        }
        system.debug('USER IP ADDRESS: ' + ReturnValue);
        return ReturnValue;
    } 
    
    public static String GetUserMid(){
        
        String strMID = [Select MID__c from User where Id =:UserInfo.getUserId()].MID__c ;
        return strMID;
    }
    
    
    public static HttpResponse CallForPaymentProfile(String strAccNo,String strIp){
        
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','getCustomerPaymentProfile_v2');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',strAccNo);
        String JSONString = JSON.serialize(mapEmp);    
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        try{
            res = http.send(req);
            return res;
  
        } catch(Exception e){
            system.debug('in exception eee');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' fra betalingsservice'));
            return null;
        }
        
    }
    
    public static HttpResponse CallForUpdateToGIRO(String strAccNo, String strIp){
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','updatePaymentMethodGiro');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',strAccNo);
        String JSONString = JSON.serialize(mapEmp);    
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        
        try{
            res = http.send(req);
            return res;
  
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' from Payment Services'));
            return null;
        }   
    }
	// Added parameter carsmask for SUPPORT-4681
    public static HttpResponse CallForUpdateToCC(String AccNo,String strIp,String strUserId,Map<String,String>mapPaymentProfToInfo,String transId,String cardExp,List<Permission__c>lstPerm,String cardMask){
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();     
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp = new Map<String,object>();
        mapEmp.put('service','updatePaymentMethodCC');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('userId',strUserId);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',AccNo);
        mapEmp.put('ipspId',stripspId);
        mapEmp.put('ipspAccountId',strDIBSmerchantId);
        mapEmp.put('department','');
        mapEmp.put('ticketId',transId);
        mapEmp.put('expirationDate',cardExp);
        mapEmp.put('cNmbrLast4digunmskd',cardMask);
        mapEmp.put('cardPrefix','');
        mapEmp.put('cardIssuingCountry',''); 
        if(mapPaymentProfToInfo.get('paymentNotificationMethod')=='')
            mapEmp.put('paymentNotificationMethod','NONE');
        else
            mapEmp.put('paymentNotificationMethod',mapPaymentProfToInfo.get('paymentNotificationMethod'));
            System.debug('***********mapEmp'+mapEmp);
        //SPOC-2092     
        if(mapPaymentProfToInfo.get('paymentNotificationMethod') == 'EMAIL' || mapPaymentProfToInfo.get('paymentNotificationMethod')== 'EMAIL+SMS'){
            if(mapPaymentProfToInfo.get('emailAddr')!='') {
                mapEmp.put('emailAddr',mapPaymentProfToInfo.get('emailAddr'));
                System.debug('@@@@@@@@@@mapEmp'+mapEmp);
                }
            else {                  
                if(lstPerm!=null && !lstPerm.isEmpty()){
                    if(lstPerm[0].Customer__r.PersonEmail!=null){
                         mapEmp.put('emailAddr',lstPerm[0].Customer__r.PersonEmail);
                          System.debug('#############mapEmp'+mapEmp);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EmailMissing));
                        return null;
                    }   
                }
            }
        }
        else
            mapEmp.put('emailAddr',mapPaymentProfToInfo.get('emailAddr')!=''?mapPaymentProfToInfo.get('emailAddr'):((lstPerm!=null && !lstPerm.isEmpty())?lstPerm[0].Customer__r.PersonEmail:''));
            System.debug('***********mapEmp'+mapEmp);
        if(mapPaymentProfToInfo.get('paymentNotificationMethod') == 'SMS' || mapPaymentProfToInfo.get('paymentNotificationMethod')== 'EMAIL+SMS'){ 
          if(mapPaymentProfToInfo.get('mobileNo')!='') 
                mapEmp.put('mobileNo',mapPaymentProfToInfo.get('mobileNo'));
            else {                  
                if(lstPerm!=null && !lstPerm.isEmpty()){
                    if(lstPerm[0].Customer__r.PersonMobilePhone!=null){
                         mapEmp.put('mobileNo',lstPerm[0].Customer__r.PersonMobilePhone);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Mobile_ph_is_mandatory));
                        return null;
                    }   
                }
            }
        }
        else
            mapEmp.put('mobileNo',mapPaymentProfToInfo.get('mobileNo')!=''?mapPaymentProfToInfo.get('mobileNo'):((lstPerm!=null && !lstPerm.isEmpty())?lstPerm[0].Customer__r.PersonMobilePhone:''));
         //SPOC-2092 End   
        String JSONString = JSON.serialize(mapEmp); 
        system.debug('JSONString========>'+JSONString);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        system.debug('@@@@@@@@@ response'+res.getBody());
        
        try{
            res = http.send(req);
             system.debug('@@@@@@@@@ response'+res.getBody());
            return res;
           
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' from Payment Services'));
            return null;
        }
    }
    
    public static HttpResponse CallForUpdateInvoiceMedia(String AccNo,String strIp,String strMed){
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();   
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','updateInvoiceMedia');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',AccNo);
        mapEmp.put('newInvoiceMedia',strMed);
        String JSONString = JSON.serialize(mapEmp);    
        System.debug('JSONString==paper======>'+JSONString);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        
        //Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
        System.debug('RESPONSE========>'+res.getBody());
        //System.debug('responseMap========>'+responseMap);  
        try{
            res = http.send(req);
            return res;
  
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' from Payment Services'));
            return null;
        }
        
    }
    
    public static HttpResponse CallForUpdateInvoiceMediaEmail(String AccNo,String strIp,String strMed,String strEmail,List<Permission__c>lstPerm){
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();     
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','updateInvoiceMediaWithEmail');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',AccNo);
        mapEmp.put('newInvoiceMedia',strMed);
        //SPOC-2092 
        if(strEmail!='') 
                mapEmp.put('emailAddr',strEmail);
         else {                 
            if(lstPerm!=null && !lstPerm.isEmpty()){
                if(lstPerm[0].Customer__r.PersonEmail!=null){
                     mapEmp.put('emailAddr',lstPerm[0].Customer__r.PersonEmail);
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EmailMissing));
                    return null;
                }   
            }
        }
        //SPOC-2092 End
        String JSONString = JSON.serialize(mapEmp);    
        system.debug('JSONString=1==='+JSONString);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        
        //Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
        System.debug('RESPONSE========>'+res.getBody());
        //System.debug('responseMap========>'+responseMap);
        try{
            res = http.send(req);
            return res;
  
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' from Payment Services'));
            return null;
        }
        
        
    }
    
    public static HttpResponse CallForUpdateNotificationMethod(String AccNo,String strIp,List<Permission__c>listPermission,Map<String,String>mapPaymentProfToInfo ){
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();  
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','updatePaymentNotificationMethod');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',AccNo);
        if(mapPaymentProfToInfo.get('paymentNotificationMethod')=='')
            mapEmp.put('paymentNotificationMethod','NONE');
        else
            mapEmp.put('paymentNotificationMethod',mapPaymentProfToInfo.get('paymentNotificationMethod'));
        //SPOC-2092 
        if(mapPaymentProfToInfo.get('paymentNotificationMethod') == 'EMAIL' || mapPaymentProfToInfo.get('paymentNotificationMethod')== 'EMAIL+SMS'){
            if(mapPaymentProfToInfo.get('emailAddr')!='') 
                mapEmp.put('emailAddr',mapPaymentProfToInfo.get('emailAddr'));
            else {                  
                if(listPermission!=null && !listPermission.isEmpty()){
                    if(listPermission[0].Customer__r.PersonEmail!=null){
                         mapEmp.put('emailAddr',listPermission[0].Customer__r.PersonEmail);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EmailMissing));
                        return null;
                    }   
                }
            }
        }
        else
            mapEmp.put('emailAddr',mapPaymentProfToInfo.get('emailAddr')!=''?mapPaymentProfToInfo.get('emailAddr'):((listPermission!=null && !listPermission.isEmpty())?listPermission[0].Customer__r.PersonEmail:''));
            
        if(mapPaymentProfToInfo.get('paymentNotificationMethod') == 'SMS' || mapPaymentProfToInfo.get('paymentNotificationMethod')== 'EMAIL+SMS'){ 
          if(mapPaymentProfToInfo.get('mobileNo')!='') 
                mapEmp.put('mobileNo',mapPaymentProfToInfo.get('mobileNo'));
            else {                  
                if(listPermission!=null && !listPermission.isEmpty()){
                    if(listPermission[0].Customer__r.PersonMobilePhone!=null){
                         mapEmp.put('mobileNo',listPermission[0].Customer__r.PersonMobilePhone);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Mobile_ph_is_mandatory));
                        return null;
                    }   
                }
            }
        }
        else
            mapEmp.put('mobileNo',mapPaymentProfToInfo.get('mobileNo')!=''?mapPaymentProfToInfo.get('mobileNo'):((listPermission!=null && !listPermission.isEmpty())?listPermission[0].Customer__r.PersonMobilePhone:''));
        //SPOC-2092 - End       
        String JSONString = JSON.serialize(mapEmp); 
        system.debug('JSONString=2==='+JSONString);
        req.setEndpoint(clsConnectionUtils_Admin.getEndPoint('AccessPaymentService'));
        String method = INTEGRATION__c.getInstance('AccessPaymentService') != null ? INTEGRATION__c.getInstance('AccessPaymentService').HttpMethod__c : 'GET';
        req.setMethod(method);
        req.setBody(JSONString);
        
        System.debug('RESPONSE========>'+res.getBody());
        try{
            res = http.send(req);
            return res;
  
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+' from Payment Services'));
            return null;
        }
    }
    
    /*public static HttpResponse CallForpayService(String AccNo,String strIp,String strInv,String transId,Decimal DcmlAmt){
        
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('service','payInvoice');
        mapEmp.put('clientSource',strClientSource);
        mapEmp.put('ipAddr',strIp);
        mapEmp.put('billingSystem',strBillingSystem);
        mapEmp.put('accountNo',AccNo);
        mapEmp.put('ipspId',stripspId);
        mapEmp.put('ipspAccountId',strDIBSmerchantId);
        mapEmp.put('department','');
        mapEmp.put('invoiceNo',strInv);
        mapEmp.put('transactionNo',transId);
        mapEmp.put('paymentId',strOrderId);
        mapEmp.put('amount',DcmlAmt);
        mapEmp.put('currency','');
        String JSONString = JSON.serialize(mapEmp);   
        system.debug('JSONString==payservioce======'+JSONString);
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(JSONString);
        res = http.send(req);
        //Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
        System.debug('RESPONSE========>'+res.getBody());
        //System.debug('responseMap========>'+responseMap);
        if(res!=null){
            Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
            if(responseMap.get('status') == '0')
            return res;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeePFErrorMessage));
            return null;
        }
        
        return res;
    }*/
}