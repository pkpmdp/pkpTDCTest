/***********************************************************************************
************************************************************************************

* @class: CarrieParseJsonTransaction
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used  to link between invoices and payments for a customer.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieParseJsonTransaction {
    public Id customerId;
    public Decimal AriaAccountNo;
    public Id AriaAccountId;
    private Aria_API_Configuration__c config { get; private set; }
    //private static String UserName = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_UserName').Value__c; //CARRIE-986
    //private static String Password = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_Password').Value__c; //CARRIE-986
    public List<Payment_Invoice__c> latestEventNo;
    public List<Payment_Invoice__c> latestDummyEventNo;
    public List<Invoice_Payment__c> latestInvoice;
    public Map<Long,String> voidedDateTime = new Map<Long,String>();
    public CarrieParseJsonTransaction (Aria_Account__c customer){ 
        customerId = customer.Account__c;
        AriaAccountId = customer.Id;
        AriaAccountNo = customer.Aria_Account_No__c;
        config = CarrieCommonUtil.validateAPIConfiguration(config);   
    }
    
    /**
    * @description: This method makes API call to Aria System for getting transaction related information.
    * @return: Response From Aria.
    */
    public String getAriaResponse(){
        HttpResponse response;
        getLatestEventNo();
        if(latestEventNo!=null && latestEventNo.size()>0){
            if(latestDummyEventNo.size()>0){                        
                //response = AriaWebServices.makeCallForJson('get_transaction_information',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND aria_event_no > '+latestDummyEventNo[0].Transaction_No__c}); //CARRIE-986
                response = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND transaction_type_no != -3 AND aria_event_no > '+latestDummyEventNo[0].Transaction_No__c});            
            }else{
                //response = AriaWebServices.makeCallForJson('get_transaction_information',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND aria_event_no > '+latestEventNo[0].Transaction_No__c}); //CARRIE-986
                response = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND transaction_type_no != -3 AND aria_event_no > '+latestEventNo[0].Transaction_No__c});           
            }
        }else if(latestInvoice!=null && latestInvoice.size()>0){
            //response = AriaWebServices.makeCallForJson('get_transaction_information',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND aria_event_no > '+latestInvoice[0].Transaction_No__c}); //CARRIE-986
            response = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND transaction_type_no != -3 AND aria_event_no > '+latestInvoice[0].Transaction_No__c});
        }else{
            //response = AriaWebServices.makeCallForJson('get_transaction_information',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2' }); //CARRIE-986
            response = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND transaction_type_no != -2 AND transaction_type_no != -3'});   
        }
        if(response!=null){ // Changes done for SUPPORT-3185
            system.debug('Response from Parse json Transaction'+response.getBody());
            return response.getBody();
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Refresh_Error));
            return '';
        }
        
    }
    
    /**
    * @description: This method is use to parse the json response from Aria.
    * @param: insertedPayment Map of the Payment 
    * @param: insertedInvoice Map of the Invoice
    * @param: commentsLong Map of comments
    * @param: Response json response from Aria.
    * @return: CarrieInvoicePaymentWrapper.
    */
    public CarrieInvoicePaymentWrapper getTransactionDetails(Map<string,string> mapInsertedPayment,Map<string,string> invoiceMap,Map<string,string> mapLongComments , String data,Map<string,string> dummyInvoiceMap){
        try{
            CarrieInvoicePaymentWrapper invoicePaymentWrapper = new CarrieInvoicePaymentWrapper();
            List<CarrieParseTransactionInfo> transactionList = new List<CarrieParseTransactionInfo>();
            List<Invoice_Payment__c> invoicePaymentList = new List<Invoice_Payment__c>();
            List<Payment_Invoice__c> paymentInvoiceList = new List<Payment_Invoice__c>();
            Set<Id> deleteVInvoice = new Set<Id>();
            
            //Set<Id> updateVoidedInvoicePayment = new Set<Id>();
            //List<Payment_Invoice__c> deleteVIPayment = new List<Payment_Invoice__c>();
            
            // List<PaymentWithDummy__c> dummyPaymentList = new List<PaymentWithDummy__c>();
            // List<InvoiceWithDummy__c> dummyInvoiceList = new List<InvoiceWithDummy__c>();
            Map<String,String> deDuplicateInvPay = new Map<String,String>();
            deDuplicateInvPay.put('0000','0000');
            Map<String,String> statementNo = new Map<String,String>();
            String error = '0';
            
            //Begin Carrie-1255
            /*This block is added to get a list of existing invoice-payment records for the selected aria account.
            */
            List<Invoice_Payment__c> invPayList = new List<Invoice_Payment__c>(); 
            invPayList = [Select i.External_Name__c, i.Id,i.Balance__c,i.Service_Credit__c,i.Saldo__c,i.Fakturabelob__c, i.Payment__r.Payment_Type__c,i.Payment_date__c,i.Transaction_No__c, i.Payment__r.Amount__c, i.Payment__r.Payment_Method__c, i.Payment__r.Payment_Date__c, i.Payment__r.Name, i.Payment__c, i.Faktura__r.Fakturanummer__c,i.Momspligtigt_bel_b__c, i.Faktura__r.Momspligtigt_bel_b__c, i.Faktura__r.Pris_pr_md__c, i.Faktura__r.Betalingsfrist__c, i.Faktura__r.Datoforudskrift__c, i.Faktura__c, i.Amount_Applied__c,i.Fakturanummer__c,i.isVoid__c From Invoice_Payment__c i where i.Aria_Account__c =: AriaAccountId order by i.Fakturanummer__c asc ,i.Payment__r.Name asc];
            Map<String,List<Invoice_Payment__c>> invPayMap = new Map<String,List<Invoice_Payment__c>>();
            for(Invoice_Payment__c inv : invPayList){
                List<Invoice_Payment__c> iPList = new List<Invoice_Payment__c>();
                if(invPayMap.keySet().contains(inv.Faktura__r.Fakturanummer__c)){
                    ipList.addAll(invPayMap.get(inv.Faktura__r.Fakturanummer__c));
                }
                ipList.add(inv);
                invPayMap.put(inv.Faktura__r.Fakturanummer__c,ipList);
            }
            system.debug('invPayMap ' +invPayMap);
            //End Carrie-1255
            
            boolean flag = false;
            JSONParser parser = JSON.createParser(data);
            while (parser.nextToken() != null) {
                if(parser.getCurrentName()=='error_code'){
                    error = parser.getText();
                    flag=true;
                }
                if(flag && error=='0'){
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while (parser.nextToken() != null) {
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                CarrieParseTransactionInfo parseTransaction = (CarrieParseTransactionInfo)parser.readValueAs(CarrieParseTransactionInfo.class);
                                transactionList.add(parseTransaction);
                                system.debug('parseTransaction ' +parseTransaction);
                                if(parseTransaction.transaction_type_no == 1){
                                    system.debug('getTransactionDetails parseTransaction.transaction_type_no == 1: invoice');
                                    if(statementNo.size()==0){
                                        statementNo.put(''+parseTransaction.type_specific_id,''+parseTransaction.aria_statement_no);  
                                    }else if(statementNo.get(''+parseTransaction.type_specific_id)==null){
                                        statementNo.put(''+parseTransaction.type_specific_id,''+parseTransaction.aria_statement_no);
                                    }
                                    if(parseTransaction.related_transaction.size()==0){
                                     if(dummyInvoiceMap.get(''+parseTransaction.type_specific_id)==null && parseTransaction.amount>0){
                                        system.debug('getTransactionDetails parseTransaction.related_transaction.size()==0: invoice without transaction');
                                        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                        invoicePayment.External_Name__c = parseTransaction.type_specific_id+'_'+'00000';//newly added
                                        invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);
                                        invoicePayment.invoice_no__c = decimal.valueOf(''+parseTransaction.type_specific_id);
                                        invoicePayment.Payment__r = new Payment__c(Payment_No__c = '00000');                                 
                                        invoicePayment.account__c = customerId;
                                        invoicePayment.Aria_Account__c = AriaAccountId;
                                        invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;                                       
                                        invoicePayment.Amount_Applied__c = 0;
                                        invoicePayment.statement_no__c = parseTransaction.aria_statement_no;
                                        invoicePaymentList.add(invoicePayment);
                                        /*InvoiceWithDummy__c dummyInvoice = new InvoiceWithDummy__c();
                                        dummyInvoice.External_Name__c = invoicePayment.External_Name__c;
                                        dummyInvoice.Name = invoicePayment.External_Name__c;
                                        dummyInvoice.account__c = customerId;                                        
                                        dummyInvoiceList.add(dummyInvoice);*/
                                        }
                                    }else{
                                        system.debug('getTransactionDetails parseTransaction.related_transaction.size()!=0: invoice with transaction');
                                        if(latestEventNo.size()>0 || latestInvoice.size()>0){
                                            for(CarrieParseTransactionInfo.RelatedTransaction relatedTransaction : parseTransaction.related_transaction){
                                                //CARRIE-880 Added Condition relatedTransaction.transaction_type_no!=8
                                                //CARRIE-1295 Added Condition relatedTransaction.transaction_type_no!=-12
                                                //SUPPORT-1980 Added Condition relatedTransaction.transaction_type_no!=6 
                                                if(relatedTransaction.transaction_type_no!=18 && relatedTransaction.transaction_type_no!=13 && relatedTransaction.transaction_type_no!=12 && relatedTransaction.transaction_type_no!=8 && relatedTransaction.transaction_type_no!=-1 && relatedTransaction.transaction_type_no!=-12 && relatedTransaction.transaction_type_no!=6){ //CARRIE-1248
                                                    system.debug('getTransactionDetails not voided invoice');
                                                    if(statementNo.size()==0){
                                                        statementNo.put(''+parseTransaction.type_specific_id,''+relatedTransaction.aria_statement_no);   
                                                    }else if(statementNo.get(''+parseTransaction.type_specific_id)==null){
                                                        statementNo.put(''+parseTransaction.type_specific_id,''+relatedTransaction.aria_statement_no);
                                                    }     
                                                                              
                                                    if(deDuplicateInvPay.get(parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no)==null){                                                         
                                                        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                                        Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                        invoicePayment.External_Name__c = parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no;//newly added
                                                        invoicePayment.Payment_date_time__c =  Datetime.valueOf(relatedTransaction.transaction_date);                                                
                                                        invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);                     
                                                        invoicePayment.Payment__r = new Payment__c(Payment_No__c = ''+relatedTransaction.aria_event_no); 
                                                        invoicePayment.account__c = customerId;
                                                        invoicePayment.Aria_Account__c = AriaAccountId;
                                                        invoicePayment.statement_no__c = parseTransaction.aria_statement_no;
                                                        invoicePayment.invoice_no__c = decimal.valueOf(''+parseTransaction.type_specific_id);                               
                                                        invoicePayment.Transaction_No__c = ''+relatedTransaction.aria_event_no;
                                                        invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                        invoicePaymentList.add(invoicePayment);
                                                        paymentInvoice.External_Name__c = parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no;//newly added
                                                        //paymentInvoice.Payment_date_time__c =  Datetime.valueOfGmt(parseTransaction.transaction_date);                                            
                                                        paymentInvoice.Payment_date_time__c = invoicePayment.Payment_date_time__c;
                                                        paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);                                                                       
                                                        paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+relatedTransaction.aria_event_no); 
                                                        paymentInvoice.account__c = invoicePayment.account__c  ;
                                                        paymentInvoice.Aria_Account__c = invoicePayment.Aria_Account__c;                       
                                                        paymentInvoice.Transaction_No__c = invoicePayment.Transaction_No__c;
                                                        paymentInvoice.Amount_Applied__c = invoicePayment.Amount_Applied__c;
                                                        paymentInvoice.CommentsLong__c = mapLongComments.get(''+relatedTransaction.aria_event_no);
                                                        //start Carrie-1010
                                                        if(relatedTransaction.transaction_type_no==10){
                                                        paymentInvoice.Applied_Against__c = parseTransaction.transaction_type;  
                                                        }
                                                        //end Carrie-1010
                                                        paymentInvoiceList.add(paymentInvoice);
                                                        deDuplicateInvPay.put(invoicePayment.External_Name__c,invoicePayment.External_Name__c);
                                                    }
                                                }                                               
                                            }
                                        }
                                    }
                                }
                                //Begin Carrie-1255
                                /*This block is added to include voided invoices in invoice payment object.
                                */
                                else if(parseTransaction.transaction_type_no==-1 && parseTransaction.related_transaction.size()>0){
                                    for(CarrieParseTransactionInfo.RelatedTransaction relatedTransaction : parseTransaction.related_transaction){
                                        if(relatedTransaction.transaction_type_no==1){
                                            if(statementNo.size()==0){
                                                statementNo.put(''+parseTransaction.type_specific_id,''+parseTransaction.aria_statement_no);  
                                            }else if(statementNo.get(''+parseTransaction.type_specific_id)==null){
                                                statementNo.put(''+parseTransaction.type_specific_id,''+parseTransaction.aria_statement_no);
                                            }   
                                            String keys = String.valueOf(parseTransaction.type_specific_id);
                                            /*If an existing invoice is voided and is associated to a payment, delete the invoice
                                            *Existing invoices which are associated with a payment, will not be fetched in the next block, as we are comparing it with dummy payment id
                                            *This block insures that invoices are refreshed without having to clean up aria account.
                                            */
                                            if(invPayMap.keySet().contains(keys)) {                                             
                                                for(Invoice_Payment__c invPayment : invPayMap.get(keys)){
                                                    if(invPayment.Payment__r.Name != '00000'){
                                                        deleteVInvoice.add(invPayment.Id);
                                                        //updateVoidedInvoicePayment.add(invPayment.Payment__c);
                                                    }
                                                }                                                       
                                            }  
                                            /*Add a new invoice-payment record for newly voided invoice 
                                            */                                      
                                            if(deDuplicateInvPay.get(relatedTransaction.type_specific_id+'_'+ '00000')==null){
                                                system.debug('creating invoice payment, payment invoice for voided invoice');
                                                Invoice_Payment__c invoicePayment = new Invoice_Payment__c();                                             
                                                invoicePayment.External_Name__c = relatedTransaction.type_specific_id+'_'+'00000';//newly added
                                                invoicePayment.Payment_date_time__c =  Datetime.valueOfGmt(relatedTransaction.transaction_date);                                                
                                                invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                     
                                                invoicePayment.Payment__r = new Payment__c(Payment_No__c = '00000'); 
                                                invoicePayment.account__c = customerId;
                                                invoicePayment.Aria_Account__c = AriaAccountId;
                                                invoicePayment.statement_no__c = relatedTransaction.aria_statement_no;
                                                invoicePayment.invoice_no__c = decimal.valueOf(''+relatedTransaction.type_specific_id);                               
                                                invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;
                                                invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                invoicePaymentList.add(invoicePayment);                                   
                                                deDuplicateInvPay.put(invoicePayment.External_Name__c,invoicePayment.External_Name__c);
                                                voidedDateTime.put(relatedTransaction.type_specific_id,relatedTransaction.void_date);
                                            }
                                        }
                                    }
                                }
                                //End Carrie-1255
                                else{
                                    system.debug('getTransactionDetails if transaction is not an invoice');
                                    //CARRIE-1295. Added condition parseTransaction.transaction_type_no!=-12
                                    //SUPPORT-1377. Added condition parseTransaction.transaction_type_no!=17
                                    //SUPPORT-1980 Added Condition parseTransaction.transaction_type_no!=6 
                                    if(parseTransaction.related_transaction.size()>0 && parseTransaction.transaction_type_no!=-3 && parseTransaction.transaction_type_no!=13 && parseTransaction.transaction_type_no!=12 && parseTransaction.transaction_type_no!=8 && parseTransaction.transaction_type_no!=-1 && parseTransaction.transaction_type_no!=-12 && parseTransaction.transaction_type_no!=17 && parseTransaction.transaction_type_no!=6){ //CARRIE-789 //CARRIE-1248
                                       for(CarrieParseTransactionInfo.RelatedTransaction relatedTransaction : parseTransaction.related_transaction){
                                            
                                            //if(relatedTransaction.transaction_type_no!=-3 && relatedTransaction.transaction_type_no!=13 && relatedTransaction.transaction_type_no!=12 && relatedTransaction.transaction_type_no!=8)
                                            if(relatedTransaction.transaction_type_no==1 || relatedTransaction.transaction_type_no==-2){ //Carrie 979 and for avoiding carrieException 
                                                if(statementNo.size()==0){
                                                    statementNo.put(''+relatedTransaction.type_specific_id,''+relatedTransaction.aria_statement_no);  
                                                }else if(statementNo.get(''+relatedTransaction.type_specific_id)==null){
                                                    statementNo.put(''+relatedTransaction.type_specific_id,''+relatedTransaction.aria_statement_no);
                                                } 
                                                if(deDuplicateInvPay.get(relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no)==null && relatedTransaction.transaction_type_no != -2){ //CARRIE-798
                                                    system.debug('parseTransaction.transaction_type_no ' +parseTransaction.transaction_type_no);
                                                    Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                                    Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                    invoicePayment.External_Name__c = relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no;//newly added
                                                    invoicePayment.Payment_date_time__c =  Datetime.valueOfGmt(relatedTransaction.transaction_date);                                                
                                                    invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                     
                                                    invoicePayment.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no); 
                                                    invoicePayment.account__c = customerId;
                                                    invoicePayment.Aria_Account__c = AriaAccountId;
                                                    invoicePayment.statement_no__c = relatedTransaction.aria_statement_no;
                                                    invoicePayment.invoice_no__c = decimal.valueOf(''+relatedTransaction.type_specific_id);                               
                                                    invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;
                                                    invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                    invoicePaymentList.add(invoicePayment);
                                                    paymentInvoice.External_Name__c = relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no;//newly added
                                                    //paymentInvoice.Payment_date_time__c =   Datetime.valueOfGmt(parseTransaction.transaction_date);                                              
                                                    paymentInvoice.Payment_date_time__c = invoicePayment.Payment_date_time__c;
                                                    paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                                                                       
                                                    paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no); 
                                                    paymentInvoice.account__c = invoicePayment.account__c  ; 
                                                    paymentInvoice.Aria_Account__c = invoicePayment.Aria_Account__c;                    
                                                    paymentInvoice.Transaction_No__c = invoicePayment.Transaction_No__c;
                                                    paymentInvoice.Amount_Applied__c = invoicePayment.Amount_Applied__c;
                                                    paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                    //start Carrie-1010
                                                    if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                    //end Carrie-1010
                                                    paymentInvoiceList.add(paymentInvoice);                                                
                                                    deDuplicateInvPay.put(invoicePayment.External_Name__c,invoicePayment.External_Name__c);
                                                }
                                                //Start of CARRIE-789
                                                else if(relatedTransaction.transaction_type_no == -2){
                                                    Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                    paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                                    paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                    paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                    paymentInvoice.account__c = customerId;
                                                    paymentInvoice.Aria_Account__c = AriaAccountId;
                                                    paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                    paymentInvoice.Amount_Applied__c = 0;
                                                    paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                    //start Carrie-1010
                                                    if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;//newly added
                                                        paymentInvoice.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                    if(parseTransaction.transaction_type_no==2){
                                                        paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;//newly added
                                                    }
                                                    //end Carrie-1010
                                                    paymentInvoiceList.add(paymentInvoice);
                                                }  
                                                //End of CARRIE-789 
                                            //start of carrie-789
                                            } else if((relatedTransaction.transaction_type_no==-3 && parseTransaction.transaction_type_no==3)){
                                                Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                                paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                paymentInvoice.account__c = customerId;
                                                paymentInvoice.Aria_Account__c = AriaAccountId;
                                                paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                paymentInvoice.Amount_Applied__c = 0;
                                                paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                //start Carrie-1010
                                                if(parseTransaction.transaction_type_no==10){
                                                    paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                }
                                                //end Carrie-1010
                                                paymentInvoiceList.add(paymentInvoice);
                                                //start Carrie-1010
                                            } else if(relatedTransaction.transaction_type_no!=1 && parseTransaction.transaction_type_no==10){
                                                Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                system.debug('credit id: '+relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no);
                                                paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;
                                                paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                paymentInvoice.account__c = customerId;
                                                paymentInvoice.Aria_Account__c = AriaAccountId;
                                                paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                paymentInvoice.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                paymentInvoiceList.add(paymentInvoice);                                       
                                            }// end of carrie-1010
                                           //End of CARRIE-789
                                        }
                                    }else if((parseTransaction.transaction_type_no == 2 || parseTransaction.transaction_type_no == 3)&& parseTransaction.related_transaction.size()==0){ //CARRIE-1253
                                        Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                        paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                        paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                        paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                        paymentInvoice.account__c = customerId;
                                        paymentInvoice.Aria_Account__c = AriaAccountId;
                                        paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                        paymentInvoice.Amount_Applied__c = 0;
                                        paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                        paymentInvoiceList.add(paymentInvoice);
                                        /*PaymentWithDummy__c dummyPayment = new PaymentWithDummy__c();
                                        dummyPayment.Name = paymentInvoice.External_Name__c;
                                        dummyPayment.External_Name__c = paymentInvoice.External_Name__c;
                                        dummyPayment.account__c = customerId;
                                        dummyPaymentList.add(dummyPayment);*/
                                    }
                                }                                
                                parser.skipChildren();
                            }
                        }
                    }
                }else{
                    parser.getCurrentToken(); 
                    parser.nextToken();
                    if(flag){
                        break;
                    }
                }
            }
            
            
            invoicePaymentWrapper.statementNo = statementNo;
            invoicePaymentWrapper.invoicePaymentList = invoicePaymentList;
            system.debug('parse json invoice-PaymentList'+invoicePaymentList);
            invoicePaymentWrapper.paymentInvoiceList = paymentInvoiceList;
            system.debug('parse json paymentInvoiceList'+paymentInvoiceList);
            //invoicePaymentWrapper.deleteVoidedInvoice = deleteVInvoice;
            //invoicePaymentWrapper.dummyInvoiceList = dummyInvoiceList;
            //invoicePaymentWrapper.dummyPaymentList = dummyPaymentList;
            //Start for 1255
            /* This block is added to delete existing voided invoices which are associated to a payment
            */
            system.debug('deleteVInvoice ' +deleteVInvoice);
            List<Invoice_Payment__c> deleteInvoiceList = new List<Invoice_Payment__c>();
            deleteInvoiceList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Invoice_Payment__c i where Id in: deleteVInvoice];
            system.debug('deleteInvoiceList ' +deleteInvoiceList);
            if(deleteInvoiceList.size()>0){
                //Delete existing voided invoice with payment != 00000
                delete deleteInvoiceList;               
            }
            system.debug('prachiiii ' +voidedDateTime);
            
            return invoicePaymentWrapper;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            return new CarrieInvoicePaymentWrapper();     
        }
    }
    
    /**
    * @description: This method is used to get the latest aria event no.
    */
    public void getLatestEventNo(){
        latestDummyEventNo = new List<Payment_Invoice__c>();
        latestEventNo = new List<Payment_Invoice__c>();
        latestInvoice = new List<Invoice_Payment__c>();
        latestDummyEventNo =    [SELECT Transaction_No__c FROM Payment_Invoice__c where Aria_Account__r.Aria_Account_No__c =: AriaAccountNo and Aria_Account__c =:AriaAccountId and Amount_Applied__c=0 order by transaction_no__c asc limit 1];
        latestEventNo = [SELECT Transaction_No__c FROM Payment_Invoice__c where Aria_Account__r.Aria_Account_No__c =: AriaAccountNo and Aria_Account__c =:AriaAccountId order by transaction_no__c desc limit 1];
        
        if(latestDummyEventNo.size()==0 && latestEventNo.size()==0)
        latestInvoice = [select id,Fakturanummer__c,Transaction_No__c from Invoice_Payment__c where Aria_Account__r.Aria_Account_No__c =: AriaAccountNo and Aria_Account__c =:AriaAccountId and Amount_Applied__c>=0 order by Name desc limit 1];
        
        system.debug('latestEventNo Response..'+latestDummyEventNo+latestEventNo+latestInvoice);
    }
}