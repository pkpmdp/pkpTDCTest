public class netfeeinvoicesPDFBillsController {

     public Blob myBlob{get;set;}
     public String bData{get;set;}
     public String Accno;
     public String billSeqNo;
     public String AccId;
     public static final String endPoint = System.Label.NetsFeeBCEndPoint;
     public static final String CPREndPoint = System.Label.CPREndpoint;
     public static final String CPRkasiaEndPoint = System.Label.CPRBCEndPoint;
     public static final String strCertName;
     public String strMid;
     public String strIp;
     

     public netfeeinvoicesPDFBillsController (){
         Accno = System.currentPageReference().getParameters().get('accNo');
         billSeqNo = System.currentPageReference().getParameters().get('billSeqNo');
         AccId =  System.currentPageReference().getParameters().get('accId');  
     } 
    
     public String strPdfUrl{get;set;}
     public String strMimeType{get;set;}
     public void GetBillAsDocument(){
     
            String invoiceNumber=Apexpages.currentPage().getParameters().get('invoiceNumber');
            Http httpProtocol=new Http();
            HttpRequest request=new HttpRequest(); 
            request.setClientCertificateName(Label.NetsFeeCert);
            strMid = NetsFeeCallOut.GetUserMid();
            strIp = NetsFeeCallOut.GetUserIPAddress();
            String endpoint2=endPoint+'account/'+Accno+'/bill/'+billSeqNo+'/pdf?billSpecificationIndicator=true';
            request.setEndPoint(endpoint2);
            request.setHeader('x-tdc-userid',strMid);
            request.setHeader('x-tdc-remote-addr',strIp!=null?strIp:'203.191.35.23');
            request.setHeader('x-tdc-imp-userid',UserInfo.getUserId());
            request.setHeader('Content-Type', 'application/x-pdf');
            request.setTimeout(120000);
            request.setMethod('GET');
            HttpResponse response=new HttpResponse(); 
         System.debug('******request****** '+request);
            response=httpProtocol.send(request);
         System.debug('*****response***** '+response);
          system.debug('response.getBody()====='+response.getBody());
            strPdfUrl = '';
            bData = '';
            try{
                if(response!=null){
                    if(response.getStatusCode() != 500 && response.getStatus() != 'Error'){
                        Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(response.getBody(),Map<String,String>.class);        
                        system.debug('response for attachment===='+responseMap);
                        if(responseMap.containsKey('file')){
                            bData = responseMap.get('file');  
                            strMimeType = responseMap.get('mimeType');
                            //strPdfUrl = insertAttachment(bData,strMimeType);  
                            strPdfUrl = insertAttachment(bData,strMimeType);            
                        }
                      else
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                    }       
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                    //return null;
                }
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                
            }
         }
         
    public String insertAttachment(String encodeData,String strMimeType){
        
         List<Attachment> lstAttach = new List<Attachment>(); 
         lstAttach = [SELECT id from Attachment WHERE ParentId =:AccId AND Description ='NetsFee'];
         if(!lstAttach.isEmpty())
            delete lstAttach;
         
         Attachment att=new Attachment();
         att.Body = EncodingUtil.base64Decode(encodeData);
         att.parentId = AccId;
         att.Name = billSeqNo+'.'+strMimeType;
         att.Description = 'NetsFee';    
         insert att;

         return att.id;
        
         
    } 
     
     public static HttpResponse getBills(String accNo,Date stdt,Date enddt,String mid,String ip, String uid){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setClientCertificateName(Label.NetsFeeCert);
        String endpoint2 = endPoint+'account/'+accNo+'/bill?mode=all&fromDate='+(string.valueOf(stdt)).substring(0,10)+'&toDate='+(string.valueOf(enddt)).substring(0,10); 
        request.setEndPoint(endpoint2);
        request.setTimeout(120000);
        request.setMethod('GET');
        system.debug('headers==='+mid+'==ip=='+ip+'===uid=='+uid);
        request.setHeader('x-tdc-userid',mid);
        request.setHeader('x-tdc-remote-addr',ip!=null?ip:'203.191.35.23');
        request.setHeader('x-tdc-imp-userid',uid);
         System.debug('****request*****'+request);
        HttpResponse response=new HttpResponse();
        try{
            response=httpProtocol.send(request);  
            System.debug('****response*****'+response);
             system.debug('response.getBody()====='+response.getBody());
            return response;
        } 
        /*catch(System.CalloutException e){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }*/ 
        catch(Exception e){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        
           
    }
    // Added parameter SUPPORT-4681
    public static HttpResponse payBills(String accNo,String strInv,String strOrderId,String strIp,String transId,Decimal dblAmt,String expdate,String mid,String ip, String uid,string strcardmask){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setClientCertificateName(Label.NetsFeeCert);
        String endpoint2 = endPoint+'account/'+accNo+'/bill/'+strInv+'/payment'; 
        request.setEndPoint(endpoint2);
        request.setTimeout(120000);
        request.setMethod('POST');
   
        audit objAudit = new audit(NetsFeeCallOut.GetUserIPAddress(),'satarupa.roy@capgemini.com');
    
        PayClassOuter objPay = new PayClassOuter(dblAmt,NetsFeeCallOut.strDIBSmerchantId,strOrderId,transId,'PaymentMethod',objAudit,expdate,'DK',strcardmask,'','satarupa.roy@capgemini.com');

        //String JSONString = JSON.serialize(mapEmp); 
        String JSONString = JSON.serialize(objPay);
        //JSONString = JSONString.unescapeEcmaScript();
        system.debug('Request for paybills====>'+JSONString);
        request.setHeader('x-tdc-userid',mid);
        request.setHeader('x-tdc-remote-addr',strIp!=null?strIp:'203.191.35.23');
        request.setHeader('x-tdc-imp-userid',uid);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSONString);
         System.debug('****request*****'+request);
        HttpResponse response=new HttpResponse();
        response=httpProtocol.send(request);        
         System.debug('****response*****'+response);
         system.debug('response.getBody()====='+response.getBody());
         if(response!=null){
             System.debug('Response bills '+response.getbody());
             return response;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
            return null;
        }
        return null;
    }
    
    
    
    /*public static HttpResponse cancelRegistration(String accNo,String inv){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setClientCertificateName('NetsFee');
        String endpoint2 = endPoint+'account/'+accNo+'/bill/'+inv+'/unsubscribeFromAutomaticPayment'; 
        request.setEndPoint(endpoint2);
        request.setTimeout(120000);
        request.setMethod('GET');
        request.setHeader('x-tdc-userid',NetsFeeCallOut.GetUserMid());
        request.setHeader('x-tdc-remote-addr',NetsFeeCallOut.GetUserIPAddress());
        request.setHeader('x-tdc-imp-userid',UserInfo.getUserId());
        HttpResponse response=new HttpResponse();
        response=httpProtocol.send(request);        
        
         if(response!=null){
             System.debug('Response  '+response.getbody());
             return response;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeePFErrorMessage));
            return null;
        }
    }*/
    
    public class PayClassOuter{
    
        Decimal amount;
        String  merchantId;
        String paymentOrderId;
        String paymentToken;
        String paymentMethod;
        audit auditInfo;        
        String cardExpDate;
        String cardIssuingCountry;
        String cardNumberMasked;
        String cardPrefix;
        String notificationEmail;
        
        public PayClassOuter(Decimal amt1, String strmerchantId1, String strOrderId1, String transId1,String paymentMethod1, Audit lstAuditInfo1, String expdate1, String cardIssuingCountry1, String cardNumberMasked1, String cardPrefix1,String notificationEmail1)
        {
            amount = amt1;
            merchantId = strmerchantId1;
            paymentOrderId = strOrderId1;
            paymentToken = transId1;
            paymentMethod = paymentMethod1;
            auditInfo = lstauditInfo1;
            cardExpDate = expdate1;
            cardIssuingCountry = cardIssuingCountry1;
            cardNumberMasked = cardNumberMasked1;
            cardPrefix = cardPrefix1;
            notificationEmail = notificationEmail1;
            
        }
    }
    
    public class audit{
        String ipAddress;
        String emailAddress;
        
        public audit(String strIp1, String stremail1){
            ipAddress = strIp1;
            emailAddress = stremail1;
        }   
    
    }
    
    public static HttpResponse getCPRResponse(String strEncrypCPR,String mid,String ip, String uid,String AccId){
        List<Customer_Log__c>listCustLog = new List<Customer_Log__c>();
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setClientCertificateName(Label.NetsFeeCert);
        String endpoint2 = CPREndPoint+'/tdcinternal/cprdetails?cprNumber='+strEncrypCPR; 
        request.setEndPoint(endpoint2);
        request.setTimeout(120000);
        request.setMethod('GET');
        request.setHeader('x-tdc-userid',mid);
        request.setHeader('x-tdc-remote-addr',ip!=null?ip:'203.191.35.23');
        request.setHeader('x-tdc-imp-userid',uid);
        HttpResponse response=new HttpResponse();
        system.debug('request====='+request);
        try{
            response=httpProtocol.send(request); 
           system.debug('response====='+response);
            system.debug('response.getBody()====='+response.getBody());
            return response;
        }  
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage()));
            Customer_Log__c objNotes = new Customer_Log__c();
            objNotes.Customer__c=AccId;
            objNotes.Text__c = response.getStatusCode()+' : '+e.getmessage();
            objNotes.Inquiry_Form__c = 'CPR error';
            listCustLog.add(objNotes);
            
            if(!listCustLog.isEmpty())
                insert listCustLog;
            return null;
        }
       
    }
    
    public static HttpResponse saveTokasia(String custNo, String strcprNo,String mid,String ip, String uid,String AccId){
        List<Customer_Log__c>listCustLog = new List<Customer_Log__c>();
        HttpRequest request=new HttpRequest();
        Http httpProtocol = new Http();
        system.debug('ip'+ip);
        request.setClientCertificateName(Label.NetsFeeCert);
        String endpoint2= CPRkasiaEndPoint+'kasia2/kunde/'+custNo+'/registrer-cprnummer';
        request.setEndPoint(endpoint2);
        request.setHeader('x-tdc-userid',mid);
        request.setHeader('x-tdc-remote-addr',ip!=null?ip:'203.191.35.23');
        request.setHeader('x-tdc-imp-userid',UserInfo.getUserId());
        request.setHeader('accept','application/vnd.yousee.kasia2+json;version=1');
        request.setHeader('Content-Type', 'application/json');
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('cprnummer',strcprNo);
        String JSONString = JSON.serialize(mapEmp); 
        request.setBody(JSONString);
        request.setTimeout(30000);//120000
        request.setMethod('POST');
        system.debug('request = '+request);
        HttpResponse response=new HttpResponse(); 
        
        try{
            response=httpProtocol.send(request);
             system.debug('response====='+response);
             system.debug('response.getBody()====='+response.getBody());
            return response;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage()));
            Customer_Log__c objNotes = new Customer_Log__c();
            objNotes.Customer__c=AccId;
            objNotes.Text__c = response.getStatusCode()+' : '+e.getmessage();
            objNotes.Inquiry_Form__c = 'CPR error';
            listCustLog.add(objNotes);
            
            if(!listCustLog.isEmpty())
                insert listCustLog;
            return null;
        }
        
    }

}