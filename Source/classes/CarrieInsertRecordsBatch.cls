Global class CarrieInsertRecordsBatch {
    
    public static Map<String,String> paymentMap = new Map<String,String>();
    public static Map<String,String> ordermap= new Map<String,String>();
     public static Map<String,String> ordercommap= new Map<String,String>();
     public static Map<String,String> transwithdate= new Map<String,String>();

     public string orderresponse='';
     public String transactionResponse1='';
    
    public static Set<Id> ariaAccIds = new Set<Id>();
    public static Map<String,Id> accIdMap = new Map<String,Id>();
    public static Map<String,Id> ariaAccIdMap = new Map<String,Id>();
    public static Set<String> eventSet = new Set<String>();
    public static Set<String> invoiceSet = new Set<String>();
    public static Set<String> voidedInvoices = new Set<String>(); 
    public static Aria_Account__c ariaAccId = new Aria_Account__c();
    public static List<Unapplied_Credit__c> creditList = new List<Unapplied_Credit__c>();
   

    List<Aria_Account__c> ariaAccountList = new List<Aria_Account__c>();
    private Aria_API_Configuration__c config { get; private set; }
    public CarrieInsertRecordsBatch(){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
    }
    
    public void updateAriaAccounts(List<Aria_Account__c> ariaAccounts, Boolean isBatch, String response){
        Map<String,Id> AccountIdMap = new Map<String,Id>();
        Map<String,Double> balanceMap = new Map<String,Double>();
        system.debug('ariaAccounts ' +ariaAccounts);
        for(Aria_Account__c aria : ariaAccounts){
            AccountIdMap.put(aria.Name,aria.Account__c);
        }  
        system.debug('AccountIdMap ' +AccountIdMap);
        //Update aria accounts as failed if the api calls fail. There will be no further processing
        Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        if(firstMap.get('error_code') != 0){
            system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
            if(isBatch){ 
            	System.debug('Is Batch ***** '+isBatch);
                for(Aria_Account__c aria : ariaAccounts){
                    aria.API_calls__c = 'get_account_details: error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'); 
                }
                update ariaAccounts;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            }
        }
        if((firstMap.get('error_code') != 0 && !isBatch) || firstMap.get('error_code') == 0){
            CarrieBatchUtil insertRecords = new CarrieBatchUtil();
            List<Aria_Account__c> billingAccount = new List<Aria_Account__c>();
            billingAccount = insertRecords.getAriaAccounts(response,AccountIdMap);
            try{
                if(billingAccount.size()>0){
                	System.debug('billingAccount.size()'+billingAccount.size()+' *****  billingAccount '+billingAccount);
                    //Update Aria Accounts 
                    system.debug('billingAccount ' +billingAccount);
                    /*for(Aria_Account__c o:billingAccount){
                        o.Updated__c = 'Batch for Payment Mode';
                    }*/
                    upsert billingAccount Aria_Account_No__c;
                }   
            }
            catch(Exception ex){
                if(!isBatch){
	                System.debug('Is Batch ***** '+isBatch);
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                }
                CarrieLog.LogException(ex);
                system.debug('EXCEPTION :' + ex.getMessage());
            }
        }
    }
    
    public void updatePaymentTransactions(List<Aria_Account__c> ariaAccs, Boolean isBatch,String response){
        CarriePaymentController paymentController = new CarriePaymentController(ariaAccs[0]);
        Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        if(firstMap.get('error_code') != 0){
            system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
            if(isBatch){
                ariaAccs[0].API_calls__c = 'get_acct_trans_history: error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'); 
                update ariaAccs; 
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            }
        }
        if((firstMap.get('error_code') != 0 && !isBatch) || firstMap.get('error_code') == 0){
            CarriePaymentWrapper paymentWrapper = paymentController.getPaymentDetails(response);
            List<Payment__c> paymentList = paymentWrapper.paymentList;
            List<Transaction__c> transList = paymentWrapper.transList;
            
            system.debug('Payment List in batch '+paymentList);
            system.debug('Transaction list in batch ' +transList);
            
            try{
                //Upsert Payments
                if(paymentList != null){ 
                    List<Payment__c> payemntList = paymentList.deepClone(); 
                    upsert payemntList Payment_No__c;
                }
                
                //Upsert Transactions
                if(transList != null){ 
                    List<Transaction__c> transactionList = transList.deepClone(); 
                    upsert transactionList Transaction_No__c;
                }

                //Update end balance in transactions and select voided payments from transactions
                List<Transaction__c> updateTransactionList = new List<Transaction__c>();
                updateTransactionList =  [Select i.Id,i.charge_amt__c,i.credit_amt__c, i.end_balance__c, i.start_balance__c, i.Aria_Account__r.name, i.Transaction_Source_ID__c, i.Transaction_Type__c
                                        From Transaction__c i where i.Aria_Account__c =: ariaAccs[0].Id  order by i.Name asc, i.Aria_Account__c];
                double startBalance = 0; 
                double endBalance = 0;
                double chargeAmt = 0;
                double creditAmt =0; 
                Double transClosingBal = 0;
                List<String> voidedPayments = new List<String>();
                for(Transaction__c trans : updateTransactionList){                                         
                    if(trans.Charge_Amt__c != null){
                        chargeAmt= trans.Charge_Amt__c;
                    }
                    if(trans.Credit_Amt__c != null){
                       creditAmt= trans.Credit_Amt__c;
                    }                   
                    endBalance = startBalance + chargeAmt - creditAmt;
                    trans.start_balance__c = decimal.valueOf(startBalance);
                    startBalance = endBalance;
                    chargeAmt=0; creditAmt =0;
                    transClosingBal = endBalance;
                    //Add voided payments to a list
                    if(trans.Transaction_Type__c == -2 || trans.Transaction_Type__c == -3){
                        voidedPayments.add(trans.Transaction_Source_ID__c); 
                    }                                 
                }  
                
                system.debug('transaction List ' +updateTransactionList);                       
                update updateTransactionList;
                
                Payment__c[] updateVoidPymList = new List<Payment__c>();
                updateVoidPymList = [Select Id, name, Payment_no__c From Payment__c where Aria_Account__c =: ariaAccs[0].Id and transaction_source_id__c IN :voidedPayments];
                system.debug(' voided payments update ' +updateVoidPymList);
                for (Payment__c pym  : updateVoidPymList){
                    pym.isVoid__c='Voided';                                      
                }
                system.debug('updateVoidPymList ' +updateVoidPymList);
                update updateVoidPymList;
                
                // The code snippet below does the following:
                // 1. Find latest transaction date from response and compare with aria account's last modified date
                // 2. If transaction date > last modified date, the aria account has been updated (New transactions created)
                // 3. Update API_calls__c field depending upon date comparison
                
                List<DateTime> transdateTime = paymentWrapper.latestTransactionDate;
                transdateTime.sort();
                transdateTime.add(ariaAccs[0].LastModifiedDateAria__c);
                transdateTime.sort();
                system.debug('transdateTime ' +transdateTime ); 
                Aria_Account__c ariaAc = new Aria_Account__c();
                ariaAc = [Select LastModifiedDateAria__c, API_calls__c from Aria_Account__c where Id =: ariaAccs[0].Id];
                if(ariaAc.LastModifiedDateAria__c != transdateTime[transdateTime.size()-1]){
                    ariaAc.API_calls__c = 'Transaction Created';
                    //Added to last batch for Carrie: 
                    //ariaAc.LastModifiedDateAria__c = system.now();
                    ariaAc.Updated__c = 'Batch';
                }
                else{
                    ariaAc.API_calls__c = '';
                    ariaAc.Updated__c = '';
                }
                update ariaAc;
                
                //Insert dummy payment and invoice
                CarrieBatchUtil insertRecords = new CarrieBatchUtil();
                insertRecords.checkDummyInvoice_Payment(ariaAccs[0].Id,ariaAccs[0].Account__r.Id);     
            }
            catch(Exception ex){
                if(!isBatch)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                CarrieLog.LogException(ex);
                system.debug('EXCEPTION :' + ex.getMessage());
            }
        }
    }
    
    public void updateInvoicePayments(List<Aria_Account__c> ariaAccounts, Boolean isBatch,String transactionResp,String invoiceResp){
        String transQueryString = ''; 
        String invoiceQueryString = '';
        
        for(Aria_Account__c aria : ariaAccounts){
            ariaAccIds.add(aria.Id);
            ariaAccIdMap.put(aria.Name,aria.Id);
            accIdMap.put(aria.Name,aria.Account__c);
        }
        system.debug('ariaAccIdMap ' +ariaAccIdMap);
        system.debug('accIdMap ' +accIdMap);
        
        List<Payment__c> paymentList = new List<Payment__c>();
        paymentList = [Select Name, CommentsLong__c,LastModifiedDate from Payment__c where Aria_Account__c in: ariaAccIds and LastModifiedDate >=: system.today()];
        system.debug('paymentList ' +paymentList);
        for(Payment__c paym : paymentList){
            paymentMap.put(paym.Name,paym.CommentsLong__c);
        }
        
        List<Payment_Invoice__c> payInvList = new List<Payment_Invoice__c>();
        payInvList = [SELECT Transaction_No__c,Aria_Account__c,Aria_Account__r.Aria_Account_No__c FROM Payment_Invoice__c where Aria_Account__c in: ariaAccIds];
        for(Payment_Invoice__c pay : payInvList){
            eventSet.add(String.valueOf(pay.Aria_Account__r.Aria_Account_No__c)); 
        }
        List<Invoice_Payment__c> invPayList = new List<Invoice_Payment__c>();
        invPayList = [select id,Fakturanummer__c,Transaction_No__c,Aria_Account__c,Aria_Account__r.Aria_Account_No__c from Invoice_Payment__c  where Aria_Account__c in: ariaAccIds and Amount_Applied__c>=0];
        for(Invoice_Payment__c inv : invPayList){
            invoiceSet.add(String.valueOf(inv.Aria_Account__r.Aria_Account_No__c)); 
        }
          
        //Update aria accounts as failed if the api calls fail. There will be no further processing
        Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(transactionResp);
        if(firstMap.get('error_code') != 0){
            system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
            if(isBatch){
                for(Aria_Account__c aria : ariaAccounts){
                    aria.API_calls__c = 'get_transaction_information: error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'); 
                }
                update ariaAccounts; 
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            }
        }
        if((firstMap.get('error_code') != 0 && !isBatch) || firstMap.get('error_code') == 0){

            //Update aria accounts as failed if the api calls fail. There will be no further processing
            Map<String, Object> secondMap = (Map<String, Object>)JSON.deserializeUntyped(invoiceResp);
            if(secondMap.get('error_code') != 0){
                system.debug('error_code ' + secondMap.get('error_code') + ' error_msg ' + secondMap.get('error_msg'));
                if(isBatch){
                    for(Aria_Account__c aria : ariaAccounts){
                        aria.API_calls__c = 'get_invoice_information: error_code ' + secondMap.get('error_code') + ' error_msg ' + secondMap.get('error_msg'); 
                    }
                    update ariaAccounts; 
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                }
            }
            if((secondMap.get('error_code') != 0 && !isBatch) || secondMap.get('error_code') == 0){
                CarrieBatchUtil insertRecords = new CarrieBatchUtil();
                Set<Id> upserted = new Set<Id>();
                //Fetch transactions to get voided invoice transaction ids
                List<Transaction__c> transactionList = new List<Transaction__c>();
                transactionList =  [Select i.Transaction_Source_ID__c, i.Transaction_Type__c From Transaction__c i where i.Aria_Account__c in: ariaAccIds];
                for(Transaction__c trans : transactionList){
                    if(trans.Transaction_Type__c == -1)
                        voidedInvoices.add(trans.Transaction_Source_ID__c);
                }
                system.debug('voidedInvoices ' +voidedInvoices);
                
                CarrieInvoiceWrapper invoiceWrapper = insertRecords.getInvoiceDetails(invoiceResp);
                CarrieInvoicePaymentWrapper invoicePaymentWrapper = insertRecords.getTransactionDetails(transactionResp,invoiceWrapper.dummyInvoiceMap);
                system.debug('invoiceWrapper in carrieinsertrecordsbatch'+invoiceWrapper);
                system.debug('invoicePaymentWrapper in carrieinsertrecordsbatch'+invoicePaymentWrapper);
                
                List<Applied_Credit__c  > serviceCreditList = invoiceWrapper.serviceCreditList;
                List<Invoice_Usage__c> invoiceUsageList = invoiceWrapper.invoiceUsageList;
                List<Invoice_Subscription__c> invoiceSubscriptionList = invoiceWrapper.invoiceSubscriptionList;    
                List<Faktura__c> invoiceList = new List<Faktura__c>();
                invoiceList = invoiceWrapper.invoiceList;   
                
                List<Invoice_Payment__c> invoicePaymentList = invoicePaymentWrapper.invoicePaymentList;
                List<Payment_Invoice__c> paymentInvoiceList = invoicePaymentWrapper.paymentInvoiceList;
                
                //In case of manual refresh, we are filtering the api call on the basis of latest event number.
                //Hence, older invoices which have been voided recently will not be picked up by the for loop below.
                //Add this code cover all voided invoices
                system.debug('invoiceList '+invoiceList);
                if(invoiceList.size() == 0){
                    List<Faktura__c> faktura = new List<Faktura__c>();
                    faktura = [SELECT id,Aria_Account__c,Fakturanummer__c, isVoid__c FROM Faktura__c where Aria_Account__c in: ariaAccIds and Fakturanummer__c in: voidedInvoices];
                    invoiceList.addAll(faktura);
                }
                //Add voided date to voided invoices
                for(Faktura__c voidInvoice : invoiceList){
                    if(voidedInvoices.contains(voidInvoice.Fakturanummer__c)){
                        if(voidInvoice.isVoid__c != 'Voided')
                            voidInvoice.isVoid__c = 'Voided';
                        if(insertRecords.voidedDateTime != null && insertRecords.voidedDateTime.keySet().contains(Long.valueOf(voidInvoice.Fakturanummer__c)))
                            voidInvoice.Void_Date__c = DateTime.valueOf(insertRecords.voidedDateTime.get(Long.valueOf(voidInvoice.Fakturanummer__c)));
                    }
                } 
                try{
                    //Upsert Invoice
                    system.debug('invoiceList ' +invoiceList);
                    upsert invoiceList Fakturanummer__c;
                
                    //Upsert Invoice subscriptions
                    system.debug('invoiceSubscriptionList ' +invoiceSubscriptionList);
                    if(invoiceSubscriptionList != null){
                        upsert invoiceSubscriptionList Faktura_line_no__c;
                    }
                    //Upsert Invoice Usages
                    system.debug('invoiceUsageList ' +invoiceUsageList);
                    if(invoiceUsageList != null){ 
                        upsert invoiceUsageList Faktura_line_no__c;
                        
                    }
                    //Invoice invoice paymentt list
                    system.debug('invoicePaymentList ' +invoicePaymentList);
                    if(invoicePaymentList!=null){           
                        upsert invoicePaymentList External_Name__c;
                    }
                    
                    //Upsert payment invoice list
                    system.debug('paymentInvoiceList ' +paymentInvoiceList);
                    if(paymentInvoiceList!=null){
                        upsert paymentInvoiceList External_Name__c; 
                    }
                    
                    //For voided invoices that had an associated payment, disassociate the invoice from the payment.
                    Id dummyInvoiceID = [Select Id,Name from Faktura__c where Fakturanummer__c = '00000'].Id;
                    system.debug('voidedInvoices ' +voidedInvoices);
                    List<Payment_Invoice__c> updatePayment = new List<Payment_Invoice__c>();
                    updatePayment = [Select Id,Name,Faktura__c,Transaction_No__c,Amount_Applied__c from Payment_Invoice__c where Faktura__r.Fakturanummer__c in: voidedInvoices];
                    for(Payment_Invoice__c paym : updatePayment){
                        paym.Faktura__c = dummyInvoiceID;
                        paym.Amount_Applied__c = 0; 
                    }
                    update updatePayment;
                    
                    //update invoice payments with new saldo
                    insertRecords.updateSaldo();
                    List<Invoice_Payment__c> iPSaldo = new List<Invoice_Payment__c>();
                    iPSaldo = insertRecords.invPaymentSaldo;
                    
                    update iPSaldo;
                    
                    //Update applied credits
                    system.debug('serviceCreditList ' +serviceCreditList);
                    if(serviceCreditList != null){
                        upsert serviceCreditList External_Name__c;
                    }
                    
                    List<Applied_Credit__c> voidedInvAppCredit = new List<Applied_Credit__c>();
                    List<Unapplied_Credit__c> unappCred = new List<Unapplied_Credit__c>();
                    voidedInvAppCredit = [Select Account__c,Amount_1__c,Amount__c,Applied_Against__c,Aria_Account__c,CommentsLong__c,Comments__c,Credit_Bel_b__c,credit_formula1__c,Credit_Reason__c,credit_type__c,Date__c,External_Name__c,Faktura_link__c,Faktura__c,Id,isVoid__c,Name FROM Applied_Credit__c where Faktura__c != '' and Faktura__r.Name != '00000' and Faktura__r.isVoid__c = 'Voided' and Applied_Against__c = 'Invoice' and Aria_Account__c =: ariaAccIds and Faktura__r.Fakturanummer__c in : voidedInvoices];
                    Set<String> appCreditNames = new Set<String>();
                    for(Applied_Credit__c  appCred : voidedInvAppCredit){
                        appCreditNames.add(appCred.Name);
                    }
                    system.debug('Applied Credit Names ' +appCreditNames);
                    List<Payment__c> payCredits = new List<Payment__c>();
                    payCredits = [Select Id,Name,Customer__c,Amount__c,Aria_Account__c, Comments__c,Unapplied__c, CommentsLong__c, Payment_Date__c, transaction_source_id__c from Payment__c where transaction_source_id__c in: appCreditNames];
                    system.debug('payCredits ' +payCredits);
                    Map<String,Payment__c> payMap = new Map<String,Payment__c>();
                    for(Payment__c pay : payCredits){
                        payMap.put(pay.transaction_source_id__c,pay);
                    }
                    for(Applied_Credit__c aCred : voidedInvAppCredit){
                        Unapplied_Credit__c newCredits = new Unapplied_Credit__c();
                        newCredits.Customer__c = payMap.get(aCred.Name).Customer__c;
                        newCredits.Amount__c =  payMap.get(aCred.Name).Amount__c; 
                        newCredits.Date__c = payMap.get(aCred.Name).Payment_Date__c;
                        newCredits.Aria_Account__c = payMap.get(aCred.Name).Aria_Account__c;
                        newCredits.Name = payMap.get(aCred.Name).transaction_source_id__c;
                        newCredits.Comments__c = payMap.get(aCred.Name).Comments__c; 
                        newCredits.commentsLong__c = payMap.get(aCred.Name).CommentsLong__c;
                        newCredits.Indbetalinger__c = payMap.get(aCred.Name).Id;
                        newCredits.credit_type__c = 'Cash';
                        newCredits.External_Name__c = payMap.get(aCred.Name).Name; 
                        newCredits.isVoid__c = aCred.isVoid__c;
                        newCredits.Unapplied_Amount1__c = payMap.get(aCred.Name).Unapplied__c;
                        unappCred.add(newCredits);      
                    }
                    system.debug('unappCred ' +unappCred);
                    delete voidedInvAppCredit ;
                    upsert unappCred External_Name__c;
                    
                    //Delete statements.                
                    delete [select Id from Unapplied_Credit__c where Unapplied__c = 0 and Credit_type__c='Cash' and Aria_Account__c in: ariaAccIds];
               
               
                }
                catch(Exception ex){
                    if(!isBatch)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                    CarrieLog.LogException(ex);
                    system.debug('EXCEPTION :' + ex.getMessage());
                }
            }
        }
    }

    public void updateOthers(Set<Id> ariaAccounts){
        CarrieBatchUtil car = new CarrieBatchUtil();
        car.deletePaymentCredits(ariaAccounts);
        
        List<Invoice_Payment__c> deleteDummyInvoiceList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Invoice_Payment__c i where i.Amount_Applied__c=0 and i.checkPaymentApplied__c>0 and Aria_Account__c in: ariaAccounts];
        delete deleteDummyInvoiceList;
        List<Payment_Invoice__c > deleteDummyPaymentList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Payment_Invoice__c i where i.Amount_Applied__c=0 and i.checkPaymentApplied__c>0 and Aria_Account__c in: ariaAccounts];
        system.debug('deleteDummyPaymentList ' +deleteDummyPaymentList);
        delete deleteDummyPaymentList;
        
        String paymentType = CarrieCommonUtil.TRANS_METHOD_MAP.get(-10);
        List<Payment__c> paymentList = new List<Payment__c>();
        List<String> voidedCreds = new List<String>();
        paymentList = [SELECT transaction_source_id__c from Payment__c where Payment_Type__c =: paymentType and Aria_Account__c in: ariaAccounts];
        for(Payment__c pay : paymentList){
            voidedCreds.add(pay.transaction_source_id__c);
        }
        car.updateVoidedCashCredits(voidedCreds);
        car.deleteOtherUnaapliedCredits(ariaAccounts);
    }
    
    public void updateCredits(List<Aria_Account__c> ariaAccounts, Boolean isBatch,String creditResponse){
    	System.debug('In CarrieInsertRecordsBatch ******** updateCredits method');
        CarrieServiceCredits serCred = new CarrieServiceCredits(ariaAccounts[0]);
        CarrieBatchUtil car = new CarrieBatchUtil();
        ariaAccId = ariaAccounts[0];
        system.debug('******* updateCredits ariaAccId '+ariaAccId);
        Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(creditResponse);
        if(firstMap.get('error_code') != 0){
            system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
            if(isBatch){
                for(Aria_Account__c aria : ariaAccounts){
                    aria.API_calls__c = 'get_unapplied_service_credits: error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'); 
                }
                update ariaAccounts; 
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            }
        }
        if((firstMap.get('error_code') != 0 && !isBatch) || firstMap.get('error_code') == 0){
            try{
                Set<Id> ids = new Set<Id>();
                ids.add(ariaAccId.Id);
                creditList = serCred.getServiceCreditDetails(creditResponse,isBatch);       
                car.deleteServiceCredits(); 
                upsert creditList External_Name__c;
                updateOthers(ids);
            }
            catch(Exception ex){
                if(!isBatch)    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                CarrieLog.LogException(ex); 
                system.debug('EXCEPTION :' + ex.getMessage());
            }
        }
    }   
      /**
    * @description: This class is used to getinformation about Order Items.
    */
    /*public class OrderItem{
        public String client_sku;
        public String line_comments;
       
        public OrderItem(){
        }
        
        public OrderItem(String client_sku,String line_comments){
            this.client_sku= client_sku;
            this.line_comments= line_comments;
           
        }
    }
      /**
    * @description: This class is used to getinformation about Transaction date.
    */
    /*public class transdate{
        public String transaction_date;
        public String type_specific_id;
       
        public transdate(){
        }
        
        public transdate(String transaction_date,String type_specific_id){
            this.transaction_date= transaction_date;
            this.type_specific_id= type_specific_id;
           
        }
    }*/
    
  /*webservice static void getRefundDetails(String AccNo) 
   {
        BlockBusterRefundDetailsWrapper objBBRefundDetails;
        String respRefundDetails; 
        List<Aria_Account__c> lstAria = new List<Aria_Account__c>();
        lstAria = [SELECT Id,name,Betaler_Id__c FROM Account where id=:]
        HttpResponse hr = BlockBusterCallOut.RefundDetails(AriaAccNo);
        if(hr!=null){
            respRefundDetails =  hr.getBody();  
            if(respRefundDetails!=''){
                objBBRefundDetails = new BlockBusterRefundDetailsWrapper();
                objBBRefundDetails = BlockbusterParse.parseRefundDetails(respRefundDetails);
                System.debug('objBBRefundDetails **** '+objBBRefundDetails);
                if(objBBRefundDetails!=null){
                    if(objBBRefundDetails.error_msg=='OK'){
                            BlockBusterInsertUpdate.InsertRefundDetails(objBBRefundDetails);
                            BlockBusterInsertUpdate.UpdateInvoicePayment(objBBRefundDetails);
                    }
                }
            }
        }
   }*/
}