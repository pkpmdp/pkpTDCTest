public with sharing class BlockBusterCallOut { 

    private static Aria_API_Configuration__c config { get; private set; }
    public static final IntegrationIP__c Ip = IntegrationIP__c.getInstance();
    
    public static HttpResponse IssueRefund(List<Invoice_Payment__c>lstPayInv,String reascode,List<Invoice_Subscription__c>lstInvSubs){
        
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        //Test class changes
        HttpResponse response = new HttpResponse();
        
        String InvNo,lineNo,amt;
        InvNo = lineNo = amt = '';
        for(Invoice_Subscription__c obj: lstInvSubs){
            
            InvNo += obj.Invoice_Number__c+ ',';
            lineNo += obj.Faktura_line_no__c.substring(obj.Faktura_line_no__c.indexOf('-')+1,obj.Faktura_line_no__c.length())+ ',';
            amt += String.valueOf(obj.Amount__c)+ ','; 
        }
        String invoice_no = InvNo.substring(0, InvNo.length() - 1);
        String line_no = lineNo.substring(0, lineNo.length() - 1);
        String amt1 = amt.substring(0, amt.length() - 1);
        
        system.debug('===invoice_no======'+invoice_no+'===line_no=='+line_no+'====amt1====='+amt1);
        if(!Test.isRunningTest())
        {
         response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'issue_refund_to_acct',config.Client_No__c.longValue() ,String.valueOf(config.Auth_Key__c),new Map<String, String> { 'acct_no' => string.valueOf(lstPayInv[0].Aria_Account__r.Aria_Account_No__c) , 'payment_transaction_id' => lstPayInv[0].Transaction_No__c , 'reason_code' => reascode , 'do_write' => 'true', 'auto_calc_refund' => 'true', 'invoice_no' => invoice_no, 'invoice_line_no' => line_no, 'invoice_line_reversing_amount' => amt1});       
        system.debug('responce Issue non_klip ***** '+response.getBody());        
        }
        //Test class changes
        if(test.isRunningTest())
        {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"reversed_invoice_lines":[{"invoice_no":64789557,"invoice_line_no":1,"invoice_line_service_no":11163621,"invoice_line_reversed_amount":22.61,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Leje (order # 6031775)","client_invoice_line_service_id":"Blockbuster_Leje"},{"invoice_no":64789557,"invoice_line_no":2,"invoice_line_service_no":11195959,"invoice_line_reversed_amount":0.74,"invoice_line_reversing_date":null,"invoice_line_comments":"KODA (order # 6031775)","client_invoice_line_service_id":"10126237"},{"invoice_no":64789557,"invoice_line_no":3,"invoice_line_service_no":10004,"invoice_line_reversed_amount":5.65,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":29,"applied_total_reversal_amount":29,"transaction_id":"93903248","error_code":0,"error_msg":"OK"}');
            response.setStatusCode(200);
        }            
            
            return response;
    } 
    
    public static HttpResponse IssueRefundKlippikort(List<Invoice_Payment__c> lstPayInv,string reasoncode,List<Invoice_Subscription__c>lstInvSubs,Decimal amount,Decimal koda,Boolean isFullRefund)
    {
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        HttpResponse response;
        
        String InvNo,lineNo,amt,amtFull;
        InvNo = lineNo = amt = amtFull = '';
        Decimal tax = 0.0;
        Decimal taxable = 0.0;
        taxable = (amount-koda)/1.25;
        tax = taxable*0.25;
        Integer countLoop = 0;
        for(Invoice_Subscription__c obj: lstInvSubs){
            countLoop++;
            InvNo += obj.Invoice_Number__c+ ',';
            lineNo += obj.Faktura_line_no__c.substring(obj.Faktura_line_no__c.indexOf('-')+1,obj.Faktura_line_no__c.length())+ ',';
            amtFull += String.valueOf(obj.Amount__c)+ ','; 
        }
        amt =String.valueOf(taxable.setScale(2,RoundingMode.UP))+','+String.valueOf(koda)+','+String.valueOf(tax.setScale(2,RoundingMode.DOWN));
        String invoice_no = InvNo.substring(0, InvNo.length() - 1);
        String line_no = lineNo.substring(0, lineNo.length() - 1);
        String amt1 = amt.substring(0, amt.length() - 1);
        if(!Test.isRunningTest()){
            if(isFullRefund == false)
                response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'issue_refund_to_acct',config.Client_No__c.longValue() ,String.valueOf(config.Auth_Key__c),new Map<String, String> { 'acct_no' => string.valueOf(lstPayInv[0].Aria_Account__r.Aria_Account_No__c) , 'payment_transaction_id' => lstPayInv[0].Transaction_No__c , 'reason_code' => reasoncode , 'do_write' => 'true', 'auto_calc_refund' => 'true', 'invoice_no' => invoice_no, 'invoice_line_no' => line_no, 'invoice_line_reversing_amount' => amt});       
            //SPOC - 2037
            else
            {
                response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'issue_refund_to_acct',config.Client_No__c.longValue() ,String.valueOf(config.Auth_Key__c),new Map<String, String> { 'acct_no' => string.valueOf(lstPayInv[0].Aria_Account__r.Aria_Account_No__c) , 'payment_transaction_id' => lstPayInv[0].Transaction_No__c , 'reason_code' => reasoncode , 'do_write' => 'true', 'auto_calc_refund' => 'true', 'invoice_no' => invoice_no, 'invoice_line_no' => line_no, 'invoice_line_reversing_amount' => amtFull});       
            }
                                
         system.debug('respince Issue klip ***** '+response.getBody());
        }
            return response;
    }
    
    public static HttpResponse RefundDetails(String bet){
        
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        //Test class changes
        HttpResponse response = new HttpResponse();
        if(!Test.isRunningTest()){
         response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_refund_details',config.Client_No__c.longValue() ,String.valueOf(config.Auth_Key__c),new Map<String, String> { 'acct_no' => bet});
        system.debug('respince details ***** '+response.getBody());
        }
        //Test class changes
        if(test.isRunningTest())
        {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"error_code":0,"refund_details":[{"refund_transaction_id":"93903248","refund_amount":29,"create_date":"2015-04-02","create_user":"Taxes","reason_code":3,"reason_label":"Customer dissatisfaction","reason_description":"Customer dissatisfaction","ref_payment_transaction_id":88228237,"ref_payment_transaction_type":3,"ref_payment_transaction_desc":"Electronic Payment","ref_payment_amount":29,"ref_payment_ref_code":null,"bill_seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","cc_id":null,"cc_type":null,"payment_src_suffix":null,"refund_check_num":null,"is_voided_ind":0,"invoice_reversals":[{"invoice_no":64789557,"invoice_bill_date":"2015-01-27","invoice_line_no":1,"total_line_debit":22.61,"reversed_line_amount":22.61,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":64789557,"invoice_bill_date":"2015-01-27","invoice_line_no":2,"total_line_debit":0.74,"reversed_line_amount":0.74,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":64789557,"invoice_bill_date":"2015-01-27","invoice_line_no":3,"total_line_debit":5.65,"reversed_line_amount":5.65,"reversed_line_start_date":null,"reversed_line_end_date":null}]}],"error_msg":"OK"}');
            response.setStatusCode(200);
        }  
            return response;      
    }
    
    //Email after refund is done
    public static void refundMsging(Account acc,DateTime TransDate,Decimal price,list<Invoice_Subscription__c> invSub,List<BlockBusterCancelKlips> listCanclklip)
    {
        Double koda = 0.0;
        Double totalKoda = 0.0;
        String fname;
        String lname;
        /*for(BlockBusterCancelKlips can : listCanclklip)
        {
            //koda = Double.valueOf(can.refunded_koda);
            totalKoda += koda/100; 
            system.debug('can.refunded_koda *******'+can.refunded_koda);
            
        }*/
        system.debug('price '+price);
        totalKoda=Decimal.valueOf(listCanclklip[0].refunded_koda)/100;//Implementation for Spoc-1978 
        Decimal total_uden_Moms = (price-totalKoda)/1.25;
        Decimal total_moms = 0.25*total_uden_Moms;
        String trandt = TransDate.format('dd-MM-yyyy HH:mm:ss');
        Datetime transformated = Datetime.valueOf(trandt);
        system.debug('Total koda ***** '+totalKoda);
        String endPoint = Ip.Refund_IP_For_Message__c;
        String method = Ip.HttpMethod__c;
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        if(acc.FirstName == '-' && acc.LastName == '-')
        {
            fname = acc.PersonEmail;
            lname = '';
        }
        else
        {
            fname = acc.FirstName;
            lname = acc.LastName;
        }
        String JSONString ='{"kontaktform": "RefundKvitteringBlockbuster","receiver":{ "email": "'+acc.PersonEmail+'",'+'"mobil": "", "kundenummer": "'+acc.Customer_No__c+'" }'+
        ',"data": { "ordredato": "'+trandt+'","engangsydelse": [{ "pris": "'+price+'", "navn": "Klippekort refundering af klip" }], "engangsydelse_totalpris": "'+price+'","koda": "'+totalKoda+'","kundeid": "'+acc.Customer_No__c+'",'+
                                                        '"total_uden_moms": "'+total_uden_Moms+'",'+
                                                        '"fornavn": "'+fname+'",'+
                                                        '"total_moms": "'+ total_moms +'",'+
                                                        '"efternavn": "'+lname+'"}}';
        req.setEndpoint(endPoint);
        req.setMethod(method);
        req.setBody(JSONString);
        if(!test.isRunningTest())
            res = http.send(req);
        system.debug('res123 '+res.getBody());
    }
    
    //Email after refund is done
    public static void refundMsgingForNonKlipKort(List<Invoice_Payment__c>lstInvPay, BlockBusterCreditCardTransact BBCredTransObj)
    {
        
        Double koda = 0.0;
        system.debug('can clip koda ******* '+koda);
        koda = Double.valueOf(BBCredTransObj.koda)/100;
        Double totalpric =  Double.valueOf(BBCredTransObj.totalprice)/100;
        system.debug('KODA ********* '+koda);
        //String endPoint = Ip.Refund_IP__c+':7890/BlockBusterRefndMesg';
        String endPoint = Ip.Refund_IP_For_Message__c;
        String method = Ip.HttpMethod__c;
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        Http http = new Http();
        Decimal total_uden_Moms = (totalpric - koda)/1.25;
        Decimal total_moms = 0.25*total_uden_Moms;
        
        Datetime d = lstInvPay[0].Transaction_Date__c;
        String Transdate = d.format('dd-MM-YYYY HH:mm:ss');
        
        String firstname,lastname;
        if(lstInvPay[0].Account__r.FirstName =='-'){
            firstname = lstInvPay[0].Account__r.PersonEmail;
            lastname = '';
        }
        else{
            firstname = lstInvPay[0].Account__r.FirstName;
            lastname =  lstInvPay[0].Account__r.LastName;
        }
        
        String JSONString ='{"kontaktform": "RefundKvitteringBlockbusterMovie","receiver":{ "email": "'+lstInvPay[0].Account__r.PersonEmail+'",'+'"mobil": "", "kundenummer": "'+lstInvPay[0].Account__r.Customer_No__c+'" }'+
        ',"data": { "ordredato": "'+TransDate+'","engangsydelse": [{ "pris": "'+totalpric+'", "navn": "Refundering af film" }], "engangsydelse_totalpris": "'+totalpric+'","koda": "'+koda+'","kundeid": "'+lstInvPay[0].Account__r.Customer_No__c+'",'+
                                                        '"total_uden_moms": "'+total_uden_Moms+'",'+
                                                        '"fornavn": "'+firstname+'",'+
                                                        '"total_moms": "'+ total_moms +'",'+
                                                        '"efternavn": "'+lastname+'"}}';
        system.debug('******* JSONString ** '+JSONString);   
        req.setEndpoint(endPoint);
        req.setMethod(method);
        req.setBody(JSONString);
        system.debug('Request ***** '+req); 
        if(!test.isRunningTest())
            res = http.send(req);
        //system.debug('****** msmging responce ****** '+res.getBody());
    }
    
   /* public static HttpResponse CancelKlips(Id FakturaId,String ref){
        List<Faktura__c> lstInv = new List<Faktura__c>();
        lstInv = [Select Id, Fakturanummer__c , Aria_Account__r.Customer_No__c,Aria_Account__r.Name From Faktura__c WHERE Id=:FakturaId];
        HttpResponse response;
        if(!lstInv.isEmpty()){
          if(!Test.isRunningTest())
             response = BlockBusterODPServices.cancelKlips(lstInv,ref);
        } 
         return response;      
    }
    */
}