/***********************************************************************************
************************************************************************************

* @class: CarrieBatchUtil
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 25/08/2013
* @description: Util class. Contains common methods for inserting records during batch run

************************************************************************************ 
***********************************************************************************/

public class CarrieBatchUtil { 
    
    public Map<String,Id> pageLayoutRecordType{get;set;}
    public Map<Long,String> voidedDateTime = new Map<Long,String>();
     
    public CarrieBatchUtil(){
        pageLayoutRecordType = new Map<String,Id>();
        initializeRecordTypes();
    }
    
    public void initializeRecordTypes(){    
        List<String> recordTypeName = new List<String>();
        recordTypeName.add('Carrie_Blockbuster');
        recordTypeName.add('Carrie_Telephony');
        recordTypeName.add('Carrie_YouBio');
        pageLayoutRecordType = new Map<String,Id>();
        List<RecordType> recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName in : recordTypeName ];
        for(RecordType rt :recordtypes){
            pageLayoutRecordType.put(rt.DeveloperName,rt.Id);           
        }
    }
    
    /**
    * @description: Construct list of aria accounts from response
    * @return: List of Aria Accounts
    */
    public List<Aria_Account__c> getAriaAccounts(String response,Map<String,Id> idMap) {
        List<Aria_Account__c> Accountlist = new List<Aria_Account__c>();
        try{
            CarrieBillingWrapper billingWrapper = new CarrieBillingWrapper();            
            billingWrapper = CarrieBillingWrapper.parse(response);
            for(CarrieBillingWrapper.Account_details a : billingWrapper.account_details){ 
                Aria_Account__c AriaAcct = new Aria_Account__c();
                AriaAcct.Aria_Account_No__c = a.acct_no;
                AriaAcct.Name = ''+a.acct_no;
                AriaAcct.Account__c = idMap.get(String.valueOf(a.acct_no));
                AriaAcct.Aria_Plan_Name__c = a.plan_name;
                AriaAcct.Regningsstatus__c = a.status_name;
                AriaAcct.Aria_Pay_Method__c = CarrieCommonUtil.PAY_METHOD_MAP.get(a.pay_method);
                AriaAcct.CurrentSaldo__c = a.acct_balance;
                AriaAcct.End_Balance__c = a.acct_balance; // issue 752
                AriaAcct.Start_Balance__c = 0; // issue 752
                if(a.plan_name.equalsIgnoreCase('YouBio')){
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_YouBio');              
                }
                if(a.plan_name.equalsIgnoreCase('Blockbuster')){
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_Blockbuster');              
                }
                if(a.plan_name.equalsIgnoreCase('YouSee')){
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_Telephony');
                }                
                for(CarrieBillingWrapper.Supp_field supp : a.Supp_field){
                    if(supp.supp_field_name =='Betaler'){
                        AriaAcct.Betaler__c = supp.supp_field_value;
                    }
                }
                Accountlist.add(AriaAcct);                  
            }
        }catch(Exception e){
            system.debug('EXCEPTION ' +e.getMessage());
        }
        return Accountlist;
    }
    
    /**
    * @description: Construct CarrieInvoiceWrapper object from aria response
    * @return: CarrieInvoiceWrapper object
    */
    public  CarrieInvoiceWrapper getInvoiceDetails(String data) { 
        try{
            Map<String,Id> accIdMap = new Map<String,Id>();
            Map<String,Id> arAccIdMap = new Map<String,Id>();
            Set<String> voidedInvoices = new Set<String>();
            
            accIdMap = CarrieInsertRecordsBatch.accIdMap;
            arAccIdMap = CarrieInsertRecordsBatch.ariaAccIdMap;
            voidedInvoices = CarrieInsertRecordsBatch.voidedInvoices;
            
            Map<string,string> invoiceMap = new Map<string,string>();
            Map<string,string> dummyInvoiceMap = new Map<string,string>();
            List<Faktura__c> invoicelist = new List<Faktura__c>();
            List<Invoice_Subscription__c> invoiceSubscriptionList = new List<Invoice_Subscription__c>();
            List<Invoice_Usage__c> invoiceUsageList = new List<Invoice_Usage__c>();
            List<Applied_Credit__c> appliedCreditList = new List<Applied_Credit__c>();
            Faktura__c invoice;
            String error = '0';
            boolean flag = false;
            //Added for Carrie-1368
            
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
                                CarrieParseInvoiceInfo parseInvoice;
                                parseInvoice = (CarrieParseInvoiceInfo)parser.readValueAs(CarrieParseInvoiceInfo.class);
                                invoice = new Faktura__c();
                                Integer serviceCreditCount = 0;
                                invoice.Customer__c = accIdMap.get(String.valueOf(parseInvoice.acct_no));
                                if(parseInvoice.debit>0){ // including invoices with amt >0
                                    invoice.Aria_Account__c = arAccIdMap.get(String.valueOf(parseInvoice.acct_no));
                                    invoice.Fakturanummer__c = ''+parseInvoice.invoice_no;
                                    if(voidedInvoices.contains(String.valueOf(parseInvoice.invoice_no)))
                                        invoice.isVoid__c = 'Voided';
                                    invoice.Name = ''+parseInvoice.invoice_no;
                                    invoice.Aria_Event_No__c=''+parseInvoice.aria_event_no;
                                    invoice.Datoforudskrift__c = date.valueOf(parseInvoice.bill_date);
                                    invoice.Betalingsfrist__c = date.valueOf(parseInvoice.due_date);
                                    invoice.Momspligtigt_bel_b__c = parseInvoice.debit;
                                    if(parseInvoice.invoice_line!=null && parseInvoice.invoice_line.size()>0){
                                        for(CarrieParseInvoiceInfo.InvoiceLineItem invoiceLineItem : parseInvoice.invoice_line){
                                            String fromDate='';
                                            if (invoiceLineItem.start_date != null) {                                        
                                                fromDate =''+date.valueOf(invoiceLineItem.start_date).format();
                                            }
                                            String toDate='';
                                            if (invoiceLineItem.end_date !=null) {
                                                toDate =''+date.valueOf(invoiceLineItem.end_date).format();
                                            }
                                            Decimal usageRate =invoiceLineItem.usage_rate;
                                            String planName = '';
                                            if (invoiceLineItem.plan_name != null) {
                                                planName = invoiceLineItem.plan_name;
                                                planName = planName.replace('"','');
                                            }
                                            String serviceName = '';
                                            if (invoiceLineItem.service_name != null) {
                                                serviceName = invoiceLineItem.service_name;
                                                serviceName = serviceName.replace('"','');
                                            }
                                            Decimal amount = invoiceLineItem.amount;
                                            Decimal usage_units = invoiceLineItem.usage_units;
                                            Long lineItemNo =invoiceLineItem.line_item_no;
                                            Long serviceNo = invoiceLineItem.service_No;
                                            Faktura__c fakturaLink =  new Faktura__c(Fakturanummer__c = invoice.Fakturanummer__c);
                                            String comments = '';
                                            comments = invoiceLineItem.comments;
                                            if(invoiceLineItem.usage_type_no==null){
                                                if(serviceNo==0 || comments.contains('Account Service Credit')){
                                                    Integer service_No = 0;
                                                    if (invoiceLineItem.comments != null) {
                                                        comments = comments.replace('"','');
                                                        String substringComments = comments.substring(comments.indexOf('No. ')+4, comments.length());
                                                        service_No = Integer.valueof(substringComments.trim());                                        
                                                    }                        
                                                    Applied_Credit__c appliedCredit= new Applied_Credit__c();
                                                    appliedCredit.Name = String.valueOf(service_No);
                                                    //Added for Carrie-1368
                                                    appliedCredit.External_Name__c = appliedCredit.Name+'_'+invoice.Fakturanummer__c + '_'+serviceCreditCount;
                                                    appliedCredit.Date__c= date.valueOf(parseInvoice.bill_date);
                                                    appliedCredit.credit_type__c= 'Service';
                                                    appliedCredit.Amount__c = -amount;
                                                    appliedCredit.Credit_Bel_b__c =null;
                                                    appliedCredit.Faktura__r = fakturaLink; 
                                                    appliedCredit.Account__c = accIdMap.get(String.valueOf(parseInvoice.acct_no));
                                                    appliedCredit.Aria_Account__c = arAccIdMap.get(String.valueOf(parseInvoice.acct_no));
                                                    appliedCredit.Applied_Against__c = 'Invoice';    //carrie-1010                                    
                                                    appliedCreditList.add(appliedCredit);
                                                    serviceCreditCount++;
                                                }else{
                                                    Invoice_Subscription__c  invoiceSubscription = new Invoice_Subscription__c();
                                                    if (invoiceLineItem.comments != null) {
                                                        comments = invoiceLineItem.comments;
                                                    }else{
                                                        comments=''; 
                                                    }
                                                    invoiceSubscription.Name = invoice.Fakturanummer__c+'-'+lineItemNo;
                                                    invoiceSubscription.Faktura_line_no__c = invoiceSubscription.Name;
                                                    invoiceSubscription.Comments__c=comments;
                                                    invoiceSubscription.units__c = usage_units ;
                                                    invoiceSubscription.Amount__c = amount;
                                                    invoiceSubscription.Service_Name__c = comments;
                                                    invoiceSubscription.Plan_Name__c = planName;
                                                    invoiceSubscription.Faktura__r = fakturaLink;
                                                    invoiceSubscription.Invoice_Number__c = invoice.Fakturanummer__c;
                                                    invoiceSubscription.Pris_pr_md__c = usageRate;
                                                    if(fromDate != null && fromDate.length() > 0 && toDate != null && toDate.length() > 0 ){
                                                        invoiceSubscription.Periode__c = fromDate+' -- ' +toDate;
                                                    }else{
                                                        invoiceSubscription.Periode__c = '';
                                                    }
                                                    invoiceSubscription.Order_Number__c=invoiceLineItem.order_no; 
                                                    invoiceSubscriptionList.add(invoiceSubscription); 
                                                }
                                            }else{
                                                Invoice_Usage__c invoiceUsage = new Invoice_Usage__c();
                                                if (invoiceLineItem.comments != null) {
                                                    comments = invoiceLineItem.comments;
                                                }else{
                                                    comments='';
                                                }
                                                invoiceUsage.Name = invoice.Fakturanummer__c+'-'+lineItemNo;
                                                invoiceUsage.Faktura_line_no__c = invoiceUsage.Name;
                                                invoiceUsage.Comments__c=comments;
                                                invoiceUsage.Amount__c = amount;
                                                invoiceUsage.Service_Name__c = comments;
                                                invoiceUsage.Plan_Name__c = planName;
                                                invoiceUsage.Faktura__r = fakturaLink;
                                                invoiceUsage.Invoice_Number__c = invoice.Fakturanummer__c;
                                                invoiceUsage.Price_Per_Unit__c = usageRate;
                                                if(fromDate != null && fromDate.length() > 0 && toDate != null && toDate.length() > 0 ){
                                                    invoiceUsage.Periode__c = fromDate+' -- ' +toDate;
                                                }else{
                                                    invoiceUsage.Periode__c = '';
                                                }
                                                invoiceUsageList.add(invoiceUsage);
                                            }
                                        }
                                    }
                                    invoicelist.add(invoice);
                                    system.debug('invoicelist in Carriebatchutil'+invoicelist);
                                    invoiceMap.put(invoice.Name,invoice.Name);
                                    parser.skipChildren();
                                }
                                else{
                                    String dummyInvoice = ''+parseInvoice.invoice_no; // invoices with amt= 0
                                    dummyInvoiceMap.put(dummyInvoice ,dummyInvoice );
                                }
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
            CarrieInvoiceWrapper invoiceWrapper = new  CarrieInvoiceWrapper();
            invoiceWrapper.dummyInvoiceMap = dummyInvoiceMap;
            invoiceWrapper.invoiceMap = invoiceMap;
            invoiceWrapper.serviceCreditList = appliedCreditList;
            invoiceWrapper.invoiceList = invoicelist;
            invoiceWrapper.invoiceSubscriptionList = invoiceSubscriptionList;
            invoiceWrapper.invoiceUsageList = invoiceUsageList;
            return invoiceWrapper;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            return new CarrieInvoiceWrapper();
        }
    }
    
    /**
    * @description: Construct CarrieInvoicePaymentWrapper from Aria response
    * @return: CarrieInvoicePaymentWrapper object
    */
    public CarrieInvoicePaymentWrapper getTransactionDetails(String data,Map<string,string> dummyInvoiceMap){
        try{
            Map<string,string> mapLongComments = new Map<string,string>(); 
            Map<String,Id> accIdMap = new Map<string,Id>();
            Map<String,Id> arAccIdMap = new Map<string,string>();
            Set<String> eventSet = new Set<String>();
            Set<String> invoiceSet = new Set<String>();
            
            mapLongComments = CarrieInsertRecordsBatch.paymentMap;
            accIdMap = CarrieInsertRecordsBatch.accIdMap;
            arAccIdMap = CarrieInsertRecordsBatch.ariaAccIdMap;
            eventSet = CarrieInsertRecordsBatch.eventSet;
            invoiceSet = CarrieInsertRecordsBatch.invoiceSet;
            system.debug('accIdMap ' +accIdMap);
            system.debug('arAccIdMap ' +arAccIdMap);
            
            CarrieInvoicePaymentWrapper invoicePaymentWrapper = new CarrieInvoicePaymentWrapper();
            List<CarrieParseTransactionInfo> transactionList = new List<CarrieParseTransactionInfo>();
            List<Invoice_Payment__c> invoicePaymentList = new List<Invoice_Payment__c>();
            List<Payment_Invoice__c> paymentInvoiceList = new List<Payment_Invoice__c>();
            Map<String,String> transdate= new Map<String,String>();
            Map<String,String> deDuplicateInvPay = new Map<String,String>();
            deDuplicateInvPay.put('0000','0000');
            Map<String,String> statementNo = new Map<String,String>();
            String error = '0';
           
            Set<Id> deleteVInvoice = new Set<Id>();
            
            //Begin Carrie-1255
            /*This block is added to get a list of existing invoice-payment records for the selected aria account.
            */
            List<Invoice_Payment__c> invPayList = new List<Invoice_Payment__c>(); 
            invPayList = [Select i.External_Name__c, i.Id,i.Balance__c,i.Service_Credit__c,i.Saldo__c,i.Fakturabelob__c, i.Payment__r.Payment_Type__c,i.Payment_date__c,i.Transaction_No__c, i.Payment__r.Amount__c, i.Payment__r.Payment_Method__c, i.Payment__r.Payment_Date__c, i.Payment__r.Name, i.Payment__c, i.Faktura__r.Fakturanummer__c,i.Momspligtigt_bel_b__c, i.Faktura__r.Momspligtigt_bel_b__c, i.Faktura__r.Pris_pr_md__c, i.Faktura__r.Betalingsfrist__c, i.Faktura__r.Datoforudskrift__c, i.Faktura__c, i.Amount_Applied__c,i.Fakturanummer__c,i.isVoid__c From Invoice_Payment__c i where i.Aria_Account__c in: CarrieInsertRecordsBatch.ariaAccIds order by i.Fakturanummer__c asc ,i.Payment__r.Name asc];
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
                            System.debug('inside a');
                                CarrieParseTransactionInfo parseTransaction = (CarrieParseTransactionInfo)parser.readValueAs(CarrieParseTransactionInfo.class);
                                System.debug('inside b');
                                transdate.put(String.valueof(parseTransaction.type_specific_id),parseTransaction.transaction_date);
                                transactionList.add(parseTransaction);
                                if(parseTransaction.transaction_type_no == 1){
                                    if(parseTransaction.related_transaction.size()==0){
                                    System.debug('inside related transaction null');
                                         if(dummyInvoiceMap.get(''+parseTransaction.type_specific_id)==null && parseTransaction.amount>0){
                                            Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                            invoicePayment.External_Name__c = parseTransaction.type_specific_id+'_'+'00000';//newly added
                                            invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);
                                            invoicePayment.invoice_no__c = decimal.valueOf(''+parseTransaction.type_specific_id);
                                            invoicePayment.Payment__r = new Payment__c(Payment_No__c = '00000');                                 
                                            invoicePayment.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                            invoicePayment.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                            invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;                                       
                                            invoicePayment.Amount_Applied__c = 0;
                                            invoicePayment.statement_no__c = parseTransaction.aria_statement_no;
                                            //Added for SPOC-1916
                                             System.debug('Vlaue of parse --->'+parseTransaction.transaction_date);
                                            invoicePayment.transaction_date__c =DateTime.valueOf(parseTransaction.transaction_date);
											invoicePayment.Transaktionsdato_BB__c = DateTime.valueOf(parseTransaction.transaction_date).format('dd-MM-yyyy')+' '+DateTime.valueOf(parseTransaction.transaction_date).format('HH:mm');
                                            invoicePaymentList.add(invoicePayment);                                        
                                        }
                                    }else{
                                        if(eventSet.contains(String.valueOf(parseTransaction.acct_no)) || invoiceSet.contains(String.valueOf(parseTransaction.acct_no))){
                                            for(CarrieParseTransactionInfo.RelatedTransaction relatedTransaction : parseTransaction.related_transaction){
                                                if(relatedTransaction.transaction_type_no!=18 && relatedTransaction.transaction_type_no!=13 && relatedTransaction.transaction_type_no!=12 && relatedTransaction.transaction_type_no!=8 && relatedTransaction.transaction_type_no!=-1 && relatedTransaction.transaction_type_no!=-12 && relatedTransaction.transaction_type_no!=6){ //CARRIE-1248
                                                    if(deDuplicateInvPay.get(parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no)==null){                                                         
                                                        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                                        Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                        invoicePayment.External_Name__c = parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no;//newly added
                                                        invoicePayment.Payment_date_time__c =  Datetime.valueOf(relatedTransaction.transaction_date);                                                
                                                        invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);                     
                                                        invoicePayment.Payment__r = new Payment__c(Payment_No__c = ''+relatedTransaction.aria_event_no); 
                                                        invoicePayment.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                        invoicePayment.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                        invoicePayment.statement_no__c = parseTransaction.aria_statement_no;
                                                        invoicePayment.invoice_no__c = decimal.valueOf(''+parseTransaction.type_specific_id);                               
                                                        invoicePayment.Transaction_No__c = ''+relatedTransaction.aria_event_no;
                                                        invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                        //Added for SPOC-1916
                                                        invoicePayment.Transaction_date__c = datetime.valueof(relatedTransaction.transaction_date);
                                                        invoicePayment.Transaktionsdato_BB__c = DateTime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+DateTime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                        
                                                        invoicePaymentList.add(invoicePayment);
                                                        
                                                        paymentInvoice.External_Name__c = parseTransaction.type_specific_id+'_'+relatedTransaction.aria_event_no;//newly added
                                                        paymentInvoice.Payment_date_time__c = invoicePayment.Payment_date_time__c;
                                                        paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = ''+parseTransaction.type_specific_id);                                                                       
                                                        paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+relatedTransaction.aria_event_no); 
                                                        paymentInvoice.account__c = invoicePayment.account__c  ;
                                                        paymentInvoice.Aria_Account__c = invoicePayment.Aria_Account__c;                       
                                                        paymentInvoice.Transaction_No__c = invoicePayment.Transaction_No__c;
                                                        paymentInvoice.Amount_Applied__c = invoicePayment.Amount_Applied__c;
                                                        paymentInvoice.CommentsLong__c = mapLongComments.get(''+relatedTransaction.aria_event_no);
                                                         //Added for SPOC-1916
                                                        paymentInvoice.Transaction_date__c = Datetime.valueOf(relatedTransaction.transaction_date);
                                                        paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                        if(relatedTransaction.transaction_type_no==10){
                                                            paymentInvoice.Applied_Against__c = parseTransaction.transaction_type;  
                                                        }
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
                                            String keys = String.valueOf(parseTransaction.type_specific_id);
                                            /*If an existing invoice is voided and is associated to a payment, delete the invoice
                                            *Existing invoices which are associated with a payment, will not be fetched in the next block, as we are comparing it with dummy payment id
                                            *This block insures that invoices are refreshed without having to clean up aria account.
                                            */
                                            if(invPayMap.keySet().contains(keys)) {                                             
                                                for(Invoice_Payment__c invPayment : invPayMap.get(keys)){
                                                    if(invPayment.Payment__r.Name != '00000'){
                                                        deleteVInvoice.add(invPayment.Id);
                                                    }
                                                }                                                       
                                            }  
                                            /*Add a new invoice-payment record for newly voided invoice 
                                            */                                      
                                            if(deDuplicateInvPay.get(relatedTransaction.type_specific_id+'_'+ '00000')==null){
                                                Invoice_Payment__c invoicePayment = new Invoice_Payment__c();                                             
                                                invoicePayment.External_Name__c = relatedTransaction.type_specific_id+'_'+'00000';//newly added
                                                invoicePayment.Payment_date_time__c =  Datetime.valueOfGmt(relatedTransaction.transaction_date);                                                
                                                invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                     
                                                invoicePayment.Payment__r = new Payment__c(Payment_No__c = '00000'); 
                                                invoicePayment.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                invoicePayment.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                invoicePayment.statement_no__c = relatedTransaction.aria_statement_no;
                                                invoicePayment.invoice_no__c = decimal.valueOf(''+relatedTransaction.type_specific_id);                               
                                                invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;
                                                invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                //Added for SPOC-1916
                                                invoicePayment.Transaction_date__c =Datetime.valueOf(relatedTransaction.transaction_date); 
                                                invoicePayment.Transaktionsdato_BB__c = DateTime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+DateTime.valueOf(relatedTransaction.transaction_date).format('HH:mm');      
                                                invoicePaymentList.add(invoicePayment);                                   
                                                deDuplicateInvPay.put(invoicePayment.External_Name__c,invoicePayment.External_Name__c);
                                                voidedDateTime.put(relatedTransaction.type_specific_id,relatedTransaction.void_date);
                                            }
                                        }
                                    }
                                }
                                //End Carrie-1255                                                          
                                else{
                                    if(parseTransaction.related_transaction.size()>0 && parseTransaction.transaction_type_no!=-3 && parseTransaction.transaction_type_no!=13 && parseTransaction.transaction_type_no!=12 && parseTransaction.transaction_type_no!=8 && parseTransaction.transaction_type_no!=-1 && parseTransaction.transaction_type_no!=-12 && parseTransaction.transaction_type_no!=17 && parseTransaction.transaction_type_no!=6){ //CARRIE-789 //CARRIE-1248
                                       for(CarrieParseTransactionInfo.RelatedTransaction relatedTransaction : parseTransaction.related_transaction){
                                           if(relatedTransaction.transaction_type_no==1 || relatedTransaction.transaction_type_no==-2){ //Carrie 979 and for avoiding carrieException 
                                                if(deDuplicateInvPay.get(relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no)==null && relatedTransaction.transaction_type_no != -2){ //CARRIE-798
                                                    Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
                                                    Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                    invoicePayment.External_Name__c = relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no;//newly added
                                                    invoicePayment.Payment_date_time__c =  Datetime.valueOfGmt(relatedTransaction.transaction_date);                                                
                                                    invoicePayment.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                     
                                                    invoicePayment.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no); 
                                                    invoicePayment.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                    invoicePayment.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                    invoicePayment.statement_no__c = relatedTransaction.aria_statement_no;
                                                    invoicePayment.invoice_no__c = decimal.valueOf(''+relatedTransaction.type_specific_id);                               
                                                    invoicePayment.Transaction_No__c = ''+parseTransaction.aria_event_no;
                                                    invoicePayment.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                    //Added for SPOC-1916
                                                    invoicePayment.Transaction_date__c =DateTime.valueOf(relatedTransaction.transaction_date); 
                                                    invoicePayment.Transaktionsdato_BB__c = DateTime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+DateTime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                    invoicePaymentList.add(invoicePayment);
                                                    paymentInvoice.External_Name__c = relatedTransaction.type_specific_id+'_'+parseTransaction.aria_event_no;//newly added
                                                    paymentInvoice.Payment_date_time__c = invoicePayment.Payment_date_time__c;
                                                    paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = ''+relatedTransaction.type_specific_id);                                                                       
                                                    paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no); 
                                                    paymentInvoice.account__c = invoicePayment.account__c  ; 
                                                    paymentInvoice.Aria_Account__c = invoicePayment.Aria_Account__c;                    
                                                    paymentInvoice.Transaction_No__c = invoicePayment.Transaction_No__c;
                                                    paymentInvoice.Amount_Applied__c = invoicePayment.Amount_Applied__c;
                                                    paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                    //Added for SPOC-1916
                                                    paymentInvoice.Transaction_date__c =Datetime.valueOf(relatedTransaction.transaction_date);
                                                    paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                    if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                    paymentInvoiceList.add(paymentInvoice);                                                
                                                    deDuplicateInvPay.put(invoicePayment.External_Name__c,invoicePayment.External_Name__c);
                                                }
                                                //Start of CARRIE-789
                                                else if(relatedTransaction.transaction_type_no == -2){
                                                    Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                    paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                                    paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                    paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                    paymentInvoice.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                    paymentInvoice.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                    paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                    paymentInvoice.Amount_Applied__c = 0;
                                                    paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                    //Added for SPOC-1916
                                                    paymentInvoice.Transaction_date__c =Datetime.valueOf(relatedTransaction.transaction_date);
                                                    paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                    if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;//newly added
                                                        paymentInvoice.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                    if(parseTransaction.transaction_type_no==2){
                                                        paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;//newly added
                                                    }
                                                    paymentInvoiceList.add(paymentInvoice);
                                                }  
                                            } else if((relatedTransaction.transaction_type_no==-3 && parseTransaction.transaction_type_no==3)){
                                                Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                                paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                paymentInvoice.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                paymentInvoice.Aria_Account__c =arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                paymentInvoice.Amount_Applied__c = 0;
                                                //Added for SPOC-1916
                                                    paymentInvoice.Transaction_date__c =Datetime.valueOf(relatedTransaction.transaction_date);
                                                    paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                if(parseTransaction.transaction_type_no==10){
                                                    paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                }
                                                paymentInvoiceList.add(paymentInvoice);
                                            } else if(relatedTransaction.transaction_type_no!=1 && parseTransaction.transaction_type_no==10){
                                                Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                                system.debug('credit id: '+relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no);
                                                paymentInvoice.External_Name__c = relatedTransaction.aria_event_no+'_'+parseTransaction.aria_event_no;
                                                paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                                paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                                paymentInvoice.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                paymentInvoice.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                                paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                                paymentInvoice.Amount_Applied__c = relatedTransaction.related_amount_applied;
                                                paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                                //Added for SPOC-1916
                                                paymentInvoice.Transaction_date__c =Datetime.valueOf(relatedTransaction.transaction_date);
                                                paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(relatedTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(relatedTransaction.transaction_date).format('HH:mm');
                                                if(parseTransaction.transaction_type_no==10){
                                                        paymentInvoice.Applied_Against__c = relatedTransaction.transaction_type;    
                                                    }
                                                paymentInvoiceList.add(paymentInvoice);                                       
                                            }
                                        }
                                    }else if((parseTransaction.transaction_type_no == 2 || parseTransaction.transaction_type_no == 3)&& parseTransaction.related_transaction.size()==0){ //CARRIE-1253
                                        Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
                                        paymentInvoice.External_Name__c = '00000'+'_'+parseTransaction.aria_event_no;//newly added
                                        paymentInvoice.Faktura__r = new Faktura__c(Fakturanummer__c = '00000');                                                                            
                                        paymentInvoice.Payment__r = new Payment__c(Payment_No__c = ''+parseTransaction.aria_event_no);
                                        paymentInvoice.account__c = accIdMap.get(String.valueOf(parseTransaction.acct_no));
                                        paymentInvoice.Aria_Account__c = arAccIdMap.get(String.valueOf(parseTransaction.acct_no));
                                        paymentInvoice.Transaction_no__c = ''+parseTransaction.aria_event_no;                    
                                        paymentInvoice.Amount_Applied__c = 0;
                                        paymentInvoice.CommentsLong__c = mapLongComments.get(''+parseTransaction.aria_event_no);
                                        //Added for SPOC-1916
                                        paymentInvoice.Transaction_date__c =Datetime.valueOf(parseTransaction.transaction_date);
                                        paymentInvoice.Transaction_DateBB__c = Datetime.valueOf(parseTransaction.transaction_date).format('dd-MM-yyyy')+' '+Datetime.valueOf(parseTransaction.transaction_date).format('HH:mm');
                                        paymentInvoiceList.add(paymentInvoice);
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
            invoicePaymentWrapper.invoicePaymentList = invoicePaymentList;
            system.debug('parse json invoice-PaymentList'+invoicePaymentList);
            invoicePaymentWrapper.paymentInvoiceList = paymentInvoiceList;
            system.debug('parse json paymentInvoiceList'+paymentInvoiceList);
            invoicePaymentWrapper.transdate= transdate;

            system.debug('Trsaction list from gettrasaction-->'+transdate);

            List<Invoice_Payment__c> deleteInvoiceList = new List<Invoice_Payment__c>();
            deleteInvoiceList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Invoice_Payment__c i where Id in: deleteVInvoice];
            system.debug('deleteInvoiceList ' +deleteInvoiceList);
            if(deleteInvoiceList.size()>0){
                //Delete existing voided invoice with payment != 00000
                delete deleteInvoiceList;               
            }
            return invoicePaymentWrapper;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            return new CarrieInvoicePaymentWrapper();     
        }
    }
    
    /**
    * @description: This method checks for the dummy Invoice and Payment. 
    */
    public void checkDummyInvoice_Payment(Id arAcId, Id accId){
        List<Payment__c> checkPaymentList = [select Name from Payment__c where Name = '00000' limit 1];
        List<Faktura__c> checkInvoiceList = [select Name from Faktura__c where Name = '00000' limit 1];
        if(checkPaymentList.size()==0){
            Payment__c dummyPayment = new Payment__c(); 
            dummyPayment.Customer__c = accId;
            dummyPayment.Aria_Account__c = arAcId;
            dummyPayment.Name = '00000';
            dummyPayment.Amount__c = 0;
            dummyPayment.Appplied_Amount__c = 0;
            dummyPayment.Payment_No__c = '00000';
            upsert dummyPayment;    
        }
        if(checkInvoiceList.size()==0){
            Faktura__c dummyInvoice = new Faktura__c(); 
            dummyInvoice.Customer__c = accId;
            dummyInvoice.Aria_Account__c = arAcId;
            dummyInvoice.Name = '00000';
            dummyInvoice.Betaling__c = 0;    
            dummyInvoice.Fakturanummer__c = '00000';
            upsert dummyInvoice;    
        }
    }
    
    public List<Invoice_Payment__c> invPaymentSaldo = new List<Invoice_Payment__c>();
    
    public void updateSaldo(){ 
        //calculateSaldofromTransaction();  
        List<Aria_Account__c> ariaAcc = new List<Aria_Account__c>();
        ariaAcc = [Select Id,Aria_Account_No__c, 
                    (SELECT Account__c,Amount_Applied__c,Aria_Account__c,Balance__c,Betalingsfrist__c,checkPaymentApplied__c,Datoforudskrift__c,
                    External_Name__c,Fakturabelob__c,Fakturanummer__c,Faktura__c,Faktura__r.Fakturanummer__c,Id,invoice_no__c,Invoice_Statement__c,
                    isVoid__c,Momspligtigt_bel_b__c,Name,Payment_date_time__c,Payment_date__c,Payment__c,Payment__r.Name,Payment__r.Payment_No__c,
                    Payment__r.Amount__c,Payment__r.isVoid__c,Saldo__c,Service_Credit__c,sort__c,statement_no__c,Transaction_No__c 
                    FROM Invoice_Payments__r order by Fakturanummer__c asc ,Payment__r.Name asc)
                  From Aria_Account__c a where Id in: CarrieInsertRecordsBatch.ariaAccIds and Id in (Select Aria_Account__c from Invoice_Payment__c)];
                  
        for(Aria_Account__c aria : ariaAcc){
            List<Invoice_Payment__c> invPaymentList = new List<Invoice_Payment__c>();
            invPaymentList = aria.Invoice_Payments__r;
            Integer sortCount = 0;
            String previousInvoice = '';
            String previousPayment = ''; 
            double fakturaSaldo = 0;
            double saldo = 0;
            for(Invoice_Payment__c invoicePayment : invPaymentList){                    
                system.debug('Invoice Number : ' +invoicePayment.Faktura__r.Fakturanummer__c);                                                                  
                if(previousInvoice != invoicePayment.Faktura__r.Fakturanummer__c && previousPayment != invoicePayment.Payment__r.name){
                    fakturaSaldo = (invoicePayment.Fakturabelob__c - invoicePayment.Service_Credit__c) - invoicePayment.Amount_Applied__c;
                }
                // Scenario when multiple Payments applied on same invoice
                else if (previousInvoice == invoicePayment.Faktura__r.Fakturanummer__c && previousPayment != invoicePayment.Payment__r.name){
                    fakturaSaldo = fakturaSaldo - invoicePayment.Amount_Applied__c ;
                }
                // Scenario when Same Payments applied on multiple invoice
                else if (previousInvoice != invoicePayment.Faktura__r.Fakturanummer__c && previousPayment == invoicePayment.Payment__r.name){
                    fakturaSaldo = invoicePayment.Fakturabelob__c - invoicePayment.Amount_Applied__c  - invoicePayment.Service_Credit__c;
                }                                      
                previousInvoice = invoicePayment.Faktura__r.Fakturanummer__c;  
                previousPayment = invoicePayment.Payment__r.name;
                invoicePayment.Balance__c = decimal.valueOf(fakturaSaldo);
                //invoicePayment.Saldo__c = invoiceSaldoMap.get(invoicePayment.Faktura__r.Fakturanummer__c);
                //system.debug('invoicePayment.Saldo__c ' +invoicePayment.Saldo__c);
                invoicePayment.sort__c = sortCount;  
                invPaymentSaldo.add(invoicePayment);                
                sortCount++;    
            }   
        }                    
    }   

    public void deleteServiceCredits(){
        List<Unapplied_Credit__c> creditList = new List<Unapplied_Credit__c>();
        creditList = CarrieInsertRecordsBatch.creditList;
        Map<String,String> serviceCreditMap = new Map<String,String>();
        List<Unapplied_Credit__c> deleteCredit = new List<Unapplied_Credit__c>(); 
        for(Unapplied_Credit__c credit : creditList){
           serviceCreditMap.put(credit.External_Name__c,credit.External_Name__c);
        }
        List<Unapplied_Credit__c> deleteServiceCredit = [select Id,External_Name__c from Unapplied_Credit__c where Credit_type__c='Service' and Aria_Account__c  =: CarrieInsertRecordsBatch.ariaAccId.Id];     
        if(creditList!=null && creditList.size()>0 && deleteServiceCredit.size()>0){
            for(Unapplied_Credit__c credits :deleteServiceCredit){
                if(serviceCreditMap.get(credits.External_Name__c)==null){
                    deleteCredit.add(credits);
                }
            }
        }else{
            if(creditList.size()==0){
                deleteCredit = deleteServiceCredit;
            }
        }
        delete deleteCredit;
    } 
    
    public void deletePaymentCredits(Set<Id> ariaAccounts){
        List<Payment_Invoice__c> deletePaymentList = [select Id ,transaction_source_id__c,Payment_Date__c,External_Name__c, Fakturanummer__c ,CommentsLong__c,Account__c,Amount__c,Amount_Applied__c,Aria_Account__c,Transaction_No__c ,Faktura__c,Comments__c,Applied_Against__c, Credit_Reason__c from Payment_Invoice__c where Aria_Account__c in: ariaAccounts and Payment_Type__c='Credit' ]; //carrie-1010 , CARRIE-657
        List<Applied_Credit__c  > addServiceCreditList =  new List<Applied_Credit__c    >();
        for(Payment_Invoice__c deletePayment : deletePaymentList){
            Applied_Credit__c    addServiceCredit = new Applied_Credit__c   ();
            addServiceCredit.External_Name__c = deletePayment.External_Name__c; // carrie-1010
            addServiceCredit.Name = deletePayment.transaction_source_id__c;
            addServiceCredit.Amount__c = deletePayment.Amount_Applied__c;
            addServiceCredit.Credit_Bel_b__c = deletePayment.Amount__c;
            addServiceCredit.CommentsLong__c = deletePayment.CommentsLong__c;
            addServiceCredit.Comments__c=deletePayment.Comments__c;
            addServiceCredit.Faktura__c =deletePayment.Faktura__c;
            addServiceCredit.Account__c=deletePayment.Account__c;
            addServiceCredit.Aria_Account__c = deletePayment.Aria_Account__c;
            addServiceCredit.credit_type__c='Cash';
            addServiceCredit.Date__c = deletePayment.Payment_Date__c;
            addServiceCredit.Applied_Against__c = deletePayment.Applied_Against__c; //carrie-1010
            addServiceCredit.Credit_Reason__c = deletePayment.Credit_Reason__c; //CARRIE-657
            addServiceCreditList.add(addServiceCredit);
        }
        upsert addServiceCreditList External_Name__c;
        delete deletePaymentList;
    }
    
    public void deleteOtherUnaapliedCredits(Set<Id> ariaAccounts){
        List<Unapplied_Credit__c> deleteList = new List<Unapplied_Credit__c>();
        List<Unapplied_Credit__c> updateUnappliedList = new List<Unapplied_Credit__c>();
        Map<String,Unapplied_Credit__c> deleteUnappliedMap = new Map<String,Unapplied_Credit__c>();
        for(Unapplied_Credit__c a: [select Name,Id,Unapplied_Amount1__c from Unapplied_Credit__c where Credit_type__c='Cash' and Aria_Account__c =:CarrieInsertRecordsBatch.ariaAccId.Id]){
            deleteUnappliedMap.put(a.Name,a);
        }
        system.debug(deleteUnappliedMap);
        if(deleteUnappliedMap.size()>0){
            AggregateResult[] groupedResults = [SELECT sum(Amount__c), name, max(Credit_Bel_b__c) from Applied_Credit__c where Aria_Account__c =: CarrieInsertRecordsBatch.ariaAccId.Id and name in:deleteUnappliedMap.keyset() group by name];
            for (AggregateResult ar : groupedResults)  {
                system.debug('delete unapplied: '+ar);
                String bb = ''+ar.get('name');
                Double AmountApplied =  double.valueOf(ar.get('expr0'));
                Double CreditAmount =  double.valueOf(ar.get('expr1'));
                if((AmountApplied==CreditAmount) && deleteUnappliedMap.get(bb)!=null){
                    deleteList.add(deleteUnappliedMap.get(bb));
                }else if(deleteUnappliedMap.get(bb)!=null){
                    Double Balance = CreditAmount - AmountApplied;
                    Unapplied_Credit__c updateUnapplied = (Unapplied_Credit__c) deleteUnappliedMap.get(bb);         
                    if(Balance!= updateUnapplied.Unapplied_Amount1__c){             
                        updateUnapplied.Unapplied_Amount1__c =  Balance;
                        updateUnappliedList.add(updateUnapplied);
                    }   
                }
            }
        }
        system.debug('update unapplied: '+updateUnappliedList);
        update updateUnappliedList;
        system.debug('delete cash credit : '+deleteList);
        delete deleteList;
    }   
    
    public void updateVoidedCashCredits(List<String> voidedcreditIds){
        List<Applied_Credit__c> UpdateCashCredits = new List<Applied_Credit__c>();
        List<Unapplied_Credit__c> UpdateCashCreditsUnapplied = new List<Unapplied_Credit__c>();
        system.debug('update voided cash credit'+voidedcreditIds);
        for(Applied_Credit__c voidedCash : [SELECT id,External_Name__c, isVoid__c FROM Applied_Credit__c where Name in :voidedcreditIds]){
            voidedCash.isVoid__c = 'voided';
            UpdateCashCredits.add(voidedCash);
        }
        for(Unapplied_Credit__c voidedCash : [SELECT id,External_Name__c, isVoid__c FROM Unapplied_Credit__c where Name in :voidedcreditIds]){
            voidedCash.isVoid__c = 'voided';
            UpdateCashCreditsUnapplied.add(voidedCash);
        }
        update UpdateCashCredits;
        update UpdateCashCreditsUnapplied;
        
    }
    
    /**
    *   @description: This method sends an email to the creator of that batch, after the end of batch execution. 
    *   Email includes batch class name, number of errors, error description and debug log ids in case of error
    */
    public void sendEmail(Id batchId, Boolean doUpdate){
    	System.debug('In CarrieBatchUtil ******** Sendemail method');
        AsyncApexJob a = [SELECT Id, ApexClass.Name, ExtendedStatus, CompletedDate,CreatedDate, CreatedBy.Name, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: batchId];
        List<ApexLog> logs = new List<ApexLog>();
        logs = [SELECT Id, LogUser.Name, Operation, Status FROM ApexLog 
                where Operation like '%Batch%' 
                and LogUser.Name like 'Namita%' 
                and Status != 'Success'
                and StartTime <=: a.CompletedDate 
                and StartTime >=: a.CreatedDate ];
                
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String htmlBody = 'Hi ' + a.CreatedBy.Name + ', <br/><br/>' +
                        'Processing of Apex Job ' +a.Id+ 
                        ' is Completed. Please find the complete details below: <br/><br/>' +
                        'Batch class name : ' +a.ApexClass.Name+ ' <br/>' +
                        'Total batches : ' +a.TotalJobItems + ' <br/>' +
                        'Number of errors: ' +a.NumberOfErrors+ ' <br/>' +
                        'Batches processed: ' + a.JobItemsProcessed +'<br/>'; 
        if(a.ExtendedStatus != '' && a.ExtendedStatus != null){
            htmlBody += 'Extended Status : ' +a.ExtendedStatus +' <br/><br/>';
        }   
        if(logs.size() > 0) 
            htmlBody += 'Debug log details : <br/><br/>';
        for(ApexLog log : logs){
            htmlBody += 'Debug log Id: ' + log.Id + '<br/>' +
                        'Status : ' + log.Status + '<br/><br/>';
        }                                   
        //Gather cc addresses from custom settings
        List<String> ccIds = new List<String>();
        String ccAddresses = CarrieCustomSettings__c.getInstance('CCEmailForUsage').Value__c; 
        if(ccAddresses != ''){
            if(ccAddresses.contains(','))   
                ccIds = ccAddresses.split(',');
            else
                ccIds.add(ccAddresses);
        }
        try{        
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            //String[] ccAddresses = new String[] {'roshan.sahatiya@capgemini.com', 'gaurav.b.mishra@capgemini.com'};
            mail.setCcAddresses(ccIds);
            mail.setSubject('Apex Batch Job Status ' + a.Status);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex){
            system.debug('error while sending email');
        }
    }
    
  /*  public void sendEmailforRefresh(Id batchId, Boolean doUpdate, String arianame){
    	System.debug('In CarrieBatchUtil **sendEmailforRefresh****** Sendemail method');
        AsyncApexJob a = [SELECT Id, ApexClass.Name, ExtendedStatus, CompletedDate,CreatedDate, CreatedBy.Name, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: batchId];
        List<ApexLog> logs = new List<ApexLog>();
        logs = [SELECT Id, LogUser.Name, Operation, Status FROM ApexLog 
                where Operation like '%Batch%' 
                and LogUserId =: UserInfo.getUserId()
                and Status != 'Success'
                and StartTime <=: a.CompletedDate 
                and StartTime >=: a.CreatedDate ];
                
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String htmlBody = 'Kære ' + a.CreatedBy.Name + ', <br/><br/>' +
                          'Transaktion information for Blockbuster Aria konto '+arianame+' er nu opdateret i SPOC.';
   
        if(logs.size() > 0) 
            htmlBody = 'Kære ' + a.CreatedBy.Name + ', <br/><br/>' +
                       'Transaktion information for Blockbuster Aria konto '+arianame+' kunne ikke opdateres.';
        
       
        try{        
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            //String[] ccAddresses = new String[] {'roshan.sahatiya@capgemini.com', 'gaurav.b.mishra@capgemini.com'};
            //mail.setCcAddresses(ccIds);
            mail.setSubject('Updated Transactions' + a.Status);
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex){
            system.debug('error while sending email');
        }
    }*/
}