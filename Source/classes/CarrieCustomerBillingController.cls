/***********************************************************************************
************************************************************************************

* @class: CarrieCustomerBillingController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: This is the main controller for displaying all billing details

************************************************************************************ 
***********************************************************************************/
public class CarrieCustomerBillingController {
	private Aria_API_Configuration__c config { get; private set; }
    public ApexPages.StandardController controller { get; set; }
    public Aria_Account__c customer{ get; set; }
    public List<Invoice_Payment__c> invoicePaymentLst{get;set;}
    public List<String> lookupHoverList{get;set;} 
    public String billingResponse{get;set;}
    public String invoiceResponse{get;set;}
    public String paymentResponse{get;set;}
    public String invoicePaymentResponse{get;set;} 
    public String serviceCreditResponse{get;set;}
    public CarrieBillingController billingController;
    public CarrieInvoiceController invoiceController {get;set;}
    public CarriePaymentController paymentController {get;set;}
    public CarrieParseJsonTransaction invoicePaymentController {get;set;}
    public CarrieServiceCredits  serviceCredit {get;set;}
    public Aria_Account__c oppty { get; set; }
    public Decimal AriaAccountNo{get;set;}
    public Decimal CasperNo{get;set;}
    public List<Unapplied_Credit__c> creditList;
    public String selectAccount{get; set;}
    public List<Aria_Account__c> billingAccount;
    public String AriaNo{get;set;}
    public String showForbrug{get;set;}
    public List<Payment__c>youbioPaymentList{get;set;} 
    public List<Applied_Credit__c> youbioAppCredList{get;set;}
    public List<Payment__c> creditpymList{get;set;} 
    //public List<Refund__c>youbioRefundList{get;set;}   //@jira CARRIE 754
    //public String refundResponse{get;set;}
    //public CarrieRefundController refundController {get;set;} 
    public List<Transaction__c> transLst{get;set;} //Carrie-752
    public Double transClosingBal {get;set;}//Carrie-752
    public List<Payment_Invoice__c>telefonyPaymentList{get;set;} //CARRIE-789
    
    
    public List<Invoice_Payment__c>telephonyInvoiceList{get;set;} //CARRIE-1255
    
    Map<String,Double> invoiceSaldoMap; //Carrie-1255
    
    public CarrieCustomerBillingController (ApexPages.StandardController controller) {
    	
    	config = CarrieCommonUtil.validateAPIConfiguration(config);
        this.controller = controller;
        AriaAccountNo =  ((Aria_Account__c) controller.getRecord()).Aria_Account_No__c;
        system.debug('aria account no: '+AriaAccountNo);
        lookupHoverList = new List<String>();
        // oppty = (Aria_Account__c) controller.getRecord();
        loadRecord();
        if(oppty.Aria_Plan_Name__c=='YouBio'){ 
            showForbrug='false';
        }else{ 
            showForbrug='true'; 
        }
        invoiceSaldoMap = new Map<String,Double>();
    } 
    
    /**
    * @description: This method is used to redirect to the CarrieCreditPage. 
    * @return: PageReference - carrieCreditpage.
    */
    public pagereference redirectCreateCredit(){
        PageReference pageRef = new PageReference('/apex/carriecreditpage?Id='+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;
    } 
       
    public List<SelectOption> getSelectAccounts() {
        List<SelectOption> options = new List<SelectOption>();
        try{
            List<Aria_Account__c> listAcct = [select Id,Aria_Plan_Name__c from Aria_Account__c where Account__c =: oppty.Account__c ];
            for(Aria_Account__c a : listAcct){
                if(a.Aria_Plan_Name__c=='YouSee'){
                    options.add(new SelectOption(''+a.Id,'Øvrige produkter'));
                }else{
                    options.add(new SelectOption(''+a.Id,a.Aria_Plan_Name__c));
                }
            }
            selectAccount=''+controller.getRecord().Id;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return options;
    }
    
    /**
    * @description: This method is used to redirect to the CarrieCustomerUsagePage.
    * @return: PageReference - CarrieCustomerUsagePage.
    */
    public pagereference redirectUsage(){
        PageReference pageRef = new PageReference('/apex/CarrieCustomerUsagePage?Id='+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;
    }   
    
    /**
    * @description: This method is used to redirect to the CarrieCustomerTransactionPage.
    * @return: PageReference - CarrieCustomerTransactionPage. CARRIE-752
    */
    public pagereference redirectTransaction(){
        PageReference pageRef = new PageReference('/apex/CarrieCustomerTransactionPage?Id='+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;
    }             
    
    /**
    * @description: This method is used to get Account related information.
    */ 
    private void loadRecord() {
        // oppty = [select Id, Aria_Account_No__c,Betaler__c,Regningsstatus__c,Aria_Pay_Method__c,CurrentSaldo__c, Account__c, Account__r.Customer_No__c, Aria_Plan_Name__c from Aria_Account__c where Id = :controller.getRecord().Id];
        //CARRIE-752
        oppty = [select Id, Aria_Account_No__c,Betaler__c,Regningsstatus__c,Aria_Pay_Method__c,CurrentSaldo__c, Account__c, Account__r.Customer_No__c, Aria_Plan_Name__c, Start_Balance__c, End_Balance__c from Aria_Account__c where Id = :controller.getRecord().Id];
    }
    
    /**
    * @description: This method is used to redirect to Casper.
    * @return: PageReference - Casper.
    */ 
    public PageReference callToCasper(){
        clsCasperButton.sendToCasper(oppty.Account__c);
        return null;
    }
    
    /**
    * @description: This method is used to delete Credits with type 'Cash'.
    */
    public void deleteCredits(){
       delete [select Id from Unapplied_Credit__c where Unapplied__c = 0 and Credit_type__c='Cash' and Customer__c =: oppty.Account__c and Aria_Account__c =:oppty.Id];
    }
    
    /**
    * @description: This method is used to delete the dummyInvoice.
    */
    public void deleteDummyInvoice(){
        List<Invoice_Payment__c> deleteDummyInvoiceList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Invoice_Payment__c i where i.Amount_Applied__c=0 and i.checkPaymentApplied__c>0 and Account__c =: oppty.Account__c and Aria_Account__c =: oppty.Id];
        delete deleteDummyInvoiceList;
    }
    
    /**
    * @description: This method is used to delete the dummyPayment.
    */
    public void deleteDummyPayment(){
        List<Payment_Invoice__c > deleteDummyPaymentList = [Select i.checkPaymentApplied__c, i.Name,i.External_Name__c, i.Amount_Applied__c From Payment_Invoice__c i where i.Amount_Applied__c=0 and i.checkPaymentApplied__c>0 and Account__c =: oppty.Account__c and Aria_Account__c =: oppty.Id];
        system.debug('deleteDummyPaymentList ' +deleteDummyPaymentList);
        delete deleteDummyPaymentList;
    }
    
    /**
    * @description: This method is used to seperate applied cash credit from payment_invoice object.
    */
    public void deletePaymentCredits(){
        List<Payment_Invoice__c> deletePaymentList = [select Id ,transaction_source_id__c,Payment_Date__c,External_Name__c, Fakturanummer__c ,CommentsLong__c,Account__c,Amount__c,Amount_Applied__c,Aria_Account__c,Transaction_No__c ,Faktura__c,Comments__c,Applied_Against__c, Credit_Reason__c from Payment_Invoice__c where Account__c =: oppty.Account__c and Aria_Account__c =: oppty.Id and Payment_Type__c='Credit' ]; //carrie-1010 , CARRIE-657
        List<Applied_Credit__c  > addServiceCreditList =  new List<Applied_Credit__c    >();
        for(Payment_Invoice__c deletePayment : deletePaymentList){
            Applied_Credit__c    addServiceCredit = new Applied_Credit__c   ();
          	//addServiceCredit.External_Name__c = deletePayment.Transaction_No__c+'_'+deletePayment.Fakturanummer__c;//carrie-1010
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
       
    /**
    * @description: This method is used to delete unapplied service credits.
    */  
    public void deleteServiceCredits(){
        Map<String,String> serviceCreditMap = new Map<String,String>();
        List<Unapplied_Credit__c> deleteCredit = new List<Unapplied_Credit__c>(); 
        for(Unapplied_Credit__c credit : creditList){
           serviceCreditMap.put(credit.External_Name__c,credit.External_Name__c);
        }
        List<Unapplied_Credit__c> deleteServiceCredit = [select Id,External_Name__c from Unapplied_Credit__c where Credit_type__c='Service' and Customer__c =: oppty.Account__c and Aria_Account__c  =: oppty.Id];     
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
 
    /**
    * @description: This method is used to initialize all the object .
    */
    public void initializeObjectclass(){
        CasperNo = decimal.valueOf(oppty.Account__r.Customer_No__c);
        billingController = new CarrieBillingController(CasperNo, controller.getRecord().Id);       
    }
    
    /**
    * @description: This method is used to fetch  payments for YouBio.
    */         
   	public List<Payment__c> getYouBioPayments()  {
    	List<Payment__c> pym = new List<Payment__c>();
        try{
            pym = [Select s.Name, s.Payment_Date__c, s.Payment_Type__c, s.Amount__c, s.isVoid__c, s.YouBioPymLink__c From Payment__c s where s.Aria_Account__c =: oppty.Id and s.Payment_Type__c !='Credit' and s.Name !='00000'order by s.Name desc];         
        } //CARRIE-789
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return pym;
    }    
    // end of jira CARRIE 753
     
    //Start of CARRIE-789
    public List<Payment_Invoice__c> getTelefonyPayments()  {
    	List<Payment_Invoice__c> pym1 = new List<Payment_Invoice__c>();
        try{
            pym1 = [Select s.Name, s.Payment__c, s.Payment_Date__c, s.Payment_Type__c, s.Amount__c, s.Fakturanummer__c, s.Amount_Applied__c, s.isVoid__c From Payment_Invoice__c s where s.Aria_Account__c =: oppty.Id and s.Payment_Type__c !='Credit' and s.Name !='00000'order by s.Payment__r.name desc, s.Fakturanummer__c desc]; 
        } 
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return pym1; 
    } 
    //End of CARRIE-789
   
    //Begin CARRIE-1255
    /**
    * @description: This method is used to fetch all invoices for the selected aria account. 
    * This method was added as the columns in Invoice-Payment related list on Aria Account page layout increased to 11 after adding isVoid field 
    */ 
    public List<Invoice_Payment__c> getTelephonyInvoice(){
   		List<Invoice_Payment__c> inv = new List<Invoice_Payment__c>();
   		try{
   			inv = [SELECT Id,Name,isVoid__c,Amount_Applied__c,Balance__c,Betalingsfrist__c,Datoforudskrift__c,Fakturabelob__c,Faktura__c,Invoice_Statement__c,Saldo__c,Service_Credit__c FROM Invoice_Payment__c where Aria_Account__c =: oppty.Id and Name !='00000' order by sort__c desc];   		
   		}
   		catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return inv;
   		
    }   
    //End of Carrie-1255
    
    //Refund //jira CARRIE 754
    //Start
    /*public List<Refund__c> getYouBioRefunds()  {
        List<Refund__c> ref = new List<Refund__c>();
        try{
         ref = [SELECT r.Name,r.Id,r.Account__c,r.Amount__c,r.Aria_Account__c,r.Payment_Id__c,r.Reason_Code__c,
                r.Reason_Description__c,r.Reason_Lable__c,r.Refund_Date__c,r.Refund_External_Id__c,r.Created_By__c FROM Refund__c r 
                WHERE r.Aria_Account__c =: oppty.Id and r.Name !='00000' order by r.Name desc];
        }
        catch(Exception e){
          //  CarrieLog.LogException(e);
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return ref;
    } */
    //End
     
    /**
    * @description: This method is used to fetch credit for YouBio.
    */    
    public List<Payment__c> getYouBioCredits()  {
        List<Payment__c> credit = new List<Payment__c>();
        try{ 
            credit = [Select s.Name, s.youbioCredit__c,s.YouBioLink__c , s.Payment_Date__c,s.Payment_type__c,s.Comments__c, s.CommentsLong__c, s.Amount__c, s.Credit_Reason__c From Payment__c s where s.Aria_Account__c =: oppty.Id and s.Payment_Type__c ='Credit' and s.Name !='00000' order by s.Payment_Date__c desc, s.Name asc];
        } //CARRIE-657
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return credit;
    }
    
    public void getPaymentInvoiceDetails(){
        try{            
            paymentController = new CarriePaymentController(oppty);
            //refundController = new CarrieRefundController(oppty); 
            //if(showForbrug == 'true') { @jira CARRIE 753
	            invoiceController = new CarrieInvoiceController (oppty);
	            invoicePaymentController = new CarrieParseJsonTransaction(oppty);
	            serviceCredit = new CarrieServiceCredits (oppty);
           // } 
        }catch(Exception e){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e); 
        }
    }
    
    /**
    * @description: This method makes API call to Aria System.
    */
    public PageReference getBillingDetails(){
        try{
            initializeObjectclass();
            AriaNo = string.valueof(AriaAccountNo);
            billingResponse = billingController.getAriaResponse(CasperNo);   
            getPaymentInvoiceDetails();
            paymentResponse = paymentController.getAriaResponse();  
            //refundResponse = refundController.getAriaResponse();          
            //if(showForbrug == 'true') { @jira CARRIE 753
	            invoiceResponse = invoiceController.getAriaResponse();  
	            invoicePaymentResponse = invoicePaymentController.getAriaResponse();
	            serviceCreditResponse = serviceCredit.getAriaResponse();
	            billingDMLExecution();
	            //youbioRefundList = getYouBioRefunds();
	            telefonyPaymentList = getTelefonyPayments(); //CARRIE-789
	            telephonyInvoiceList = getTelephonyInvoice(); //CARRIE-1255
            //}             
            if(showForbrug == 'false') {
                //billingYouBioDMLExecution(); @jira CARRIE 753
                youbioPaymentList = getYouBioPayments();
                creditpymList = getYouBioCredits();
            }
        }catch(Exception e){       
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return null; 
    } 
    
    /**
    * @description: This method is used to perform DML operation for YouBio Product.
    */
    /* public void billingYouBioDMLExecution(){
        try{
            billingAccount = billingController.getBillingDetails(billingResponse, oppty); 
            CarriePaymentWrapper paymentWrapper = paymentController.getPaymentDetails(paymentResponse);
            CarrieRefundWrapper refundWrapper = refundController.getRefundDetails(refundResponse);
            upsert billingAccount Aria_Account_No__c;  
            if(paymentWrapper.paymentList != null){ 
                List<Payment__c> paymentList = paymentWrapper.paymentList;
                List<Payment__c> payemntList = paymentList.deepClone(); 
                upsert payemntList Payment_No__c;
            }
            
            //Refund
            //Start
            if(refundWrapper.refundList != null){ 
                List<Refund__c> refundList = refundWrapper.refundList;
                List<Refund__c> refundsList = refundList.deepClone(); 
                upsert refundsList Refund_External_Id__c;
            }
            //End
            
            this.customer = [Select a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Id = :controller.getRecord().Id];
            checkDummyInvoice_Payment();         
        }catch(Exception e){ 
            system.debug('e...'+e);         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e); 
        }
    }  */
    
  
    /**
    * @description: This method is used to perform DML operation for Other Product.
    */
    public void billingDMLExecution(){
        try{           
           	billingAccount = billingController.getAriaAccounts(billingResponse); 
           	
            CarrieInvoiceWrapper invoiceWrapper =  invoiceController.getInvoiceDetails(invoiceResponse);
            List<Applied_Credit__c  > serviceCreditList = invoiceWrapper.serviceCreditList;
            if(invoiceWrapper.invoiceMap != null){
                for(String var : invoiceWrapper.invoiceMap.values()){
                    lookupHoverList.add(var);
                }
            }
            CarriePaymentWrapper paymentWrapper = paymentController.getPaymentDetails(paymentResponse);
            List<Payment__c> paymentList = paymentWrapper.paymentList;
            List<Transaction__c> transList = paymentWrapper.transList; //CARRIE-752
            
            system.debug('Payment List  '+paymentList);
        	system.debug('Transaction list  ' +transList);
            /*CarrieRefundWrapper refundWrapper = refundController.getRefundDetails(refundResponse);
            List<Refund__c> refundList = refundWrapper.refundList; */
            CarrieInvoicePaymentWrapper invoicePaymentWrapper = invoicePaymentController.getTransactionDetails(paymentWrapper.mapInsertedPayment,invoiceWrapper.invoiceMap,paymentWrapper.mapLongComments ,invoicePaymentResponse,invoiceWrapper.dummyInvoiceMap);
            Map<String,String> StatementNo = invoicePaymentWrapper.statementNo;
            List<Invoice_Payment__c> invoicePaymentList = invoicePaymentWrapper.invoicePaymentList;
            List<Payment_Invoice__c> paymentInvoiceList = invoicePaymentWrapper.paymentInvoiceList;
            // List<InvoiceWithDummy__c>  dummyInvoiceList = invoicePaymentWrapper.dummyInvoiceList;
            // List<PaymentWithDummy__c>  dummyPaymentList = invoicePaymentWrapper.dummyPaymentList;
       
            creditList = serviceCredit.getServiceCreditDetails(serviceCreditResponse,false);             
            System.debug('billingAccount: '+billingAccount);            
            upsert billingAccount Aria_Account_No__c;  
            
            List<Faktura__c> invoiceList = new List<Faktura__c>(); 
            if(invoiceWrapper!=null){  
                Integer cnnnt=0;
                if(invoiceWrapper.invoiceList!=null){  
                    for(Faktura__c fakturaList : invoiceWrapper.invoiceList){
                        if(StatementNo != null){ 
                            fakturaList.Statement_no__c = StatementNo.get(fakturaList.Name);
                            invoiceList.add(fakturaList);
                            cnnnt++; 
                        }
                    }
                } 
                system.debug('invoiceList ' +invoiceList);
                upsert invoiceList  Fakturanummer__c;
                List<Invoice_Usage__c> invoiceUsageList = invoiceWrapper.invoiceUsageList;
                List<Invoice_Subscription__c> invoiceSubscriptionList = invoiceWrapper.invoiceSubscriptionList;          
                system.debug('invoiceSubscriptionList ' +invoiceSubscriptionList);
                if(invoiceSubscriptionList != null){
                    upsert invoiceSubscriptionList Faktura_line_no__c;
                }
                system.debug('invoiceUsageList ' +invoiceUsageList);
                if(invoiceUsageList != null){ 
                    upsert invoiceUsageList Faktura_line_no__c;
                }
                system.debug('serviceCreditList ' +serviceCreditList);
                if(serviceCreditList != null){
                    upsert serviceCreditList External_Name__c;
                }
                // upsert dummyInvoiceList External_Name__c;
                // upsert dummyPaymentList External_Name__c;
            } 
            if(paymentList != null){ 
                List<Payment__c> payemntList = paymentList.deepClone(); 
                upsert payemntList Payment_No__c;
            }
            
            //start of Carrie 752 
            if(transList != null){ 
                List<Transaction__c> transactionList = transList.deepClone(); 
                upsert transactionList Transaction_No__c;
            } // end of Carrie 752 
            
            /*if(refundList != null){ 
                List<Refund__c> refundsList = refundList.deepClone(); 
                upsert refundsList Refund_External_Id__c;
            } */
             
            checkDummyInvoice_Payment();
            system.debug('invoicePaymentList ' +invoicePaymentList);
            if(invoicePaymentList!=null){           
                upsert invoicePaymentList External_Name__c;
            	//system.debug('invoice-payment: '+invoicePaymentList);
            }
             system.debug('paymentInvoiceList ' +paymentInvoiceList);
            if(paymentInvoiceList!=null){
                upsert paymentInvoiceList External_Name__c; 
            }
            String previousInvoice = null;
            String previousPayment = null; //CARRIE-1078
            double fakturaSaldo = 0;
            double saldo = 0;
            //Integer count = 0; //CARRIE-1078
            //Integer serviceCount = 0; //CARRIE-1078
            invoicePaymentLst =  [SELECT Account__c,Amount_Applied__c,Aria_Account__c,Balance__c,Betalingsfrist__c,checkPaymentApplied__c,Datoforudskrift__c,External_Name__c,Fakturabelob__c,Fakturanummer__c,Faktura__c,Faktura__r.Fakturanummer__c,Id,invoice_no__c,Invoice_Statement__c,isVoid__c,Momspligtigt_bel_b__c,Name,Payment_date_time__c,Payment_date__c,Payment__c,Payment__r.Name,Payment__r.Payment_No__c,Payment__r.Amount__c,Payment__r.isVoid__c,Saldo__c,Service_Credit__c,sort__c,statement_no__c,Transaction_No__c FROM Invoice_Payment__c where Account__c =: oppty.Account__c and Aria_Account__c =: oppty.Id  order by Fakturanummer__c asc ,Payment__r.Name asc];
            
            List<Invoice_Payment__c> updateInvoicePaymentList = new List<Invoice_Payment__c>();
            //Start of CARRIE-1078
            /*if(invoicePaymentList!=null && invoicePaymentList.size()>0 ){
                Integer sortCount = 0;                
                 for(Invoice_Payment__c invoicePayment : invoicePaymentLst){
                    if(previousInvoice==null){
                        previousInvoice = invoicePayment.Faktura__r.Fakturanummer__c;  
                        serviceCount = 1;                                 
                    }else{
                    }
                    if(previousInvoice == invoicePayment.Faktura__r.Fakturanummer__c){
                        count++;
                        if(count==1){
                            fakturaSaldo = fakturaSaldo + invoicePayment.Amount_Applied__c;
                            if(invoicePayment.Service_Credit__c >0 && serviceCount==1){
                                invoicePayment.Balance__c = invoicePayment.Fakturabelob__c - decimal.valueOf(fakturaSaldo) - invoicePayment.Service_Credit__c;
                            }else{
                            invoicePayment.Balance__c = invoicePayment.Fakturabelob__c - decimal.valueOf(fakturaSaldo);
                            }                        
                            fakturaSaldo = invoicePayment.Balance__c;
                            saldo = fakturaSaldo;
                            invoicePayment.Saldo__c = saldo;
                        }
                        if(count>1){
                            fakturaSaldo = fakturaSaldo - invoicePayment.Amount_Applied__c ;
                            invoicePayment.Balance__c = decimal.valueOf(fakturaSaldo);
                            fakturaSaldo = invoicePayment.Balance__c;
                            saldo = saldo - invoicePayment.Amount_Applied__c;
                            invoicePayment.Saldo__c = saldo;
                        } 
                    }else{
                        previousInvoice = invoicePayment.Faktura__r.Fakturanummer__c;
                        serviceCount = 1;
                        count = 1;
                        fakturaSaldo = 0;
                        fakturaSaldo = invoicePayment.Amount_Applied__c;
                        if(invoicePayment.Service_Credit__c >0 && serviceCount==1){
                            invoicePayment.Balance__c = invoicePayment.Fakturabelob__c - decimal.valueOf(fakturaSaldo) - invoicePayment.Service_Credit__c;
                        }else{
                            invoicePayment.Balance__c = invoicePayment.Fakturabelob__c - decimal.valueOf(fakturaSaldo);
                        }
                        fakturaSaldo = invoicePayment.Balance__c;
                        saldo = saldo + fakturaSaldo;
                        invoicePayment.Saldo__c = saldo;
                    }
                    invoicePayment.sort__c = sortCount;
                    updateInvoicePaymentList.add(invoicePayment);
                    sortCount++;
                    serviceCount++;
                } */

            //Start of jira CARRIE-752
            double startBalance = 0; 
            double endBalance = 0;
            double chargeAmt = 0;
            double creditAmt =0; 
            // Start of  CARRIE-789
            double transType = 0; 
            string transSourceId = ' '; 
            List<String> updateVoidList = new List<String>(); 
            List<String> updateVoidInvoiceList = new List<String>();       
            // end of  CARRIE-789
            List<Transaction__c> updateTransactionList = new List<Transaction__c>();
                        
            transLst =  [Select i.Id,i.charge_amt__c,i.credit_amt__c, i.end_balance__c, i.start_balance__c, i.Aria_Account__r.name, i.Transaction_Source_ID__c, i.Transaction_Type__c
                                From Transaction__c i where i.customer__c =: oppty.Account__c and i.Aria_Account__c =: oppty.Id  order by i.Name asc, i.Aria_Account__c];
            

			if(transList!=null && transList.size()>0 ){
              	startBalance = 0;
              	//oppty.Start_Balance__c =  decimal.valueOf(startBalance);                  
              	for(Transaction__c trans : transLst){                                         
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
                    updateTransactionList.add(trans);
                    // Start of Carrie-789
                    transType = trans.Transaction_Type__c;
                    transSourceId = trans.Transaction_Source_ID__c;
                    if(transType == -2 || transType == -3){
                        updateVoidList.add(transSourceId); 
                    }                     
                    // End of Carrie-789
                    //Start Carrie-1255 (voided invoice)
                    /* Store the transaction ids of voided invoices in a list. This list is used to update isVoid field 
                    */
                    if(transType == -1){
                    	system.debug('*********** transSourceId ' +transSourceId);
                    	updateVoidInvoiceList.add(transSourceId);
                    }
                    //End for Carrie-1255
                }
                System.debug('updateVoidList' + updateVoidList); //Carrie-789
               	// oppty.End_Balance__c =  decimal.valueOf(transClosingBal);
              	//  update oppty;
              	system.debug('update updateTransactionList; ' +updateTransactionList);
                update updateTransactionList;
                
                //Added for Carrie-1255   
                //This code is moved here to fetch latest changes from transaction object
	            calculateSaldofromTransaction();             
				if(invoicePaymentLst!=null && invoicePaymentLst.size()>0 ){
	             	Integer sortCount = 0;
	                for(Invoice_Payment__c invoicePayment : invoicePaymentLst){                	
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
	                    //invoicePayment.Saldo__c = decimal.valueOf(saldo);
	                    invoicePayment.Saldo__c = invoiceSaldoMap.get(invoicePayment.Faktura__r.Fakturanummer__c);
	                    system.debug('invoicePayment.Saldo__c ' +invoicePayment.Saldo__c);
	                    invoicePayment.sort__c = sortCount;                	
	                    updateInvoicePaymentList.add(invoicePayment);
	                    sortCount++;    
	                } //End of CARRIE-1078 
	                update updateInvoicePaymentList;
	            }
	            system.debug('after update saldo  ' +updateInvoicePaymentList);
                // Start of Carrie-789
                Payment__c[] updateVoidPymList = [Select Id, name, Payment_no__c From Payment__c 
                                where customer__c =: oppty.Account__c and Aria_Account__c =: oppty.Id and transaction_source_id__c IN :updateVoidList];
                for (Payment__c pym  : updateVoidPymList){
                    pym.isVoid__c='Voided';                                      
                }
                system.debug('updateVoidPymList ' +updateVoidPymList);
                update updateVoidPymList; 
                // End of Carrie-789 
                
                //Start Carrie-1255                
                updateVoidedInvoices(updateVoidInvoiceList); 
        		/* For Payment-Invoice records, where the invoice is voided, 
        		the invoice should be disassociated and a dummy invoice should be added to the payment invoice record.
        		*/        		
	        	Id dummyInvoiceID = [Select Id,Name from Faktura__c where Fakturanummer__c = '00000'].Id;
	        	List<Payment_Invoice__c> updatePayment = new List<Payment_Invoice__c>();
	        	updatePayment = [Select Id,Name,Faktura__c,Transaction_No__c,Amount_Applied__c from Payment_Invoice__c where Faktura__r.Fakturanummer__c in: updateVoidInvoiceList];
	        	
	        	for(Payment_Invoice__c paym : updatePayment){
	        	 	paym.Faktura__c = dummyInvoiceID;
	        	 	paym.Amount_Applied__c = 0;	        	 	
	        	}
	        	update updatePayment;
	        	system.debug('updatepayment ' +updatePayment);
	        	/* When an invoice is voided and there are credits applied to that invoice,
	        	* the credits should me moved to unapplied section from applied section.
	        	*/
	        	List<Applied_Credit__c> voidedInvAppCredit = new List<Applied_Credit__c>();
	        	List<Unapplied_Credit__c> unappCred = new List<Unapplied_Credit__c>();
	        	voidedInvAppCredit = [Select Account__c,Amount_1__c,Amount__c,Applied_Against__c,Aria_Account__c,CommentsLong__c,Comments__c,CreatedById,CreatedDate,Credit_Bel_b__c,credit_formula1__c,Credit_Reason__c,credit_type__c,Date__c,External_Name__c,Faktura_link__c,Faktura__c,Id,IsDeleted,isVoid__c,LastModifiedById,LastModifiedDate,Name,SystemModstamp FROM Applied_Credit__c where Faktura__c != '' and Faktura__r.Name != '00000' and Faktura__r.isVoid__c = 'Voided' and Applied_Against__c = 'Invoice' and Aria_Account__c =: oppty.Id and Faktura__r.Fakturanummer__c in : updateVoidInvoiceList];
                Set<String> appCreditNames = new Set<String>();
                for(Applied_Credit__c  appCred : voidedInvAppCredit){
               		appCreditNames.add(appCred.Name);
                }
                system.debug('Applied Credit Names ' +appCreditNames);
                List<Payment__c> payCredits = new List<Payment__c>();
                payCredits = [Select Id,Name,Customer__c,Amount__c,Aria_Account__c, Comments__c,Unapplied__c, CommentsLong__c, Payment_Date__c, transaction_source_id__c from Payment__c where transaction_source_id__c in: appCreditNames];
                system.debug('payCredits ' +payCredits);
                Map<String,Payment__c> paymentMap = new Map<String,Payment__c>();
                for(Payment__c pay : payCredits){
                	paymentMap.put(pay.transaction_source_id__c,pay);
                }
                for(Applied_Credit__c aCred : voidedInvAppCredit){
                	Unapplied_Credit__c newCredits = new Unapplied_Credit__c();
                	newCredits.Customer__c = paymentMap.get(aCred.Name).Customer__c;
                	newCredits.Amount__c =  paymentMap.get(aCred.Name).Amount__c;
                	newCredits.Date__c = paymentMap.get(aCred.Name).Payment_Date__c;
                	newCredits.Aria_Account__c = paymentMap.get(aCred.Name).Aria_Account__c;
                	newCredits.Name = paymentMap.get(aCred.Name).transaction_source_id__c;
                	newCredits.Comments__c = paymentMap.get(aCred.Name).Comments__c; 
                	newCredits.commentsLong__c = paymentMap.get(aCred.Name).CommentsLong__c;
            		newCredits.Indbetalinger__c = paymentMap.get(aCred.Name).Id;
            		newCredits.credit_type__c = 'Cash';
            		newCredits.External_Name__c = paymentMap.get(aCred.Name).Name; 
            		newCredits.isVoid__c = aCred.isVoid__c;
            		newCredits.Unapplied_Amount1__c = paymentMap.get(aCred.Name).Unapplied__c;
            		unappCred.add(newCredits);		
                }
                system.debug('unappCred ' +unappCred);
                delete voidedInvAppCredit ;
                upsert unappCred External_Name__c;
                system.debug('unappCred after upsert' +unappCred);
                //End Carrie-1255                
            } 
            //End of jira CARRIE-752
                   
            deleteCredits();
            deleteServiceCredits();
            upsert creditList External_Name__c;
            this.invoicePaymentLst = new List<Invoice_Payment__c>();
            this.invoicePaymentLst =  [Select i.Id,i.Balance__c,i.Saldo__c, i.Payment__r.Payment_Type__c,i.Payment_date__c,i.Transaction_No__c, i.Payment__r.Amount__c, i.Payment__r.Payment_Method__c, i.Payment__r.Payment_Date__c, i.Payment__r.Name, i.Payment__c, i.Faktura__r.Fakturanummer__c,i.Momspligtigt_bel_b__c, i.Faktura__r.Momspligtigt_bel_b__c, i.Faktura__r.Pris_pr_md__c, i.Faktura__r.Betalingsfrist__c, i.Faktura__r.Datoforudskrift__c, i.Faktura__c, i.Amount_Applied__c,i.Fakturanummer__c From Invoice_Payment__c i where i.Account__c = :oppty.Account__c and Aria_Account__c =: oppty.Id  order by i.Fakturanummer__c asc ,i.Payment__r.Name asc];
            this.transLst = [Select i.Id,i.charge_amt__c,i.credit_amt__c,i.end_balance__c, i.start_balance__c, i.Aria_account__r.name
                                From Transaction__c i where i.customer__c =: oppty.Account__c and i.Aria_Account__c =: oppty.Id  order by i.Name asc]; //@jira CARRIE-752 
       		//this.customer = [Select a.Total_Credits__c, a.CurrentSaldo__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c,a.IsPersonAccount, a.Id, a.Faktureret1__c, a.Days_in_Dunning__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c, a.Aria_Account_No__c, a.AddressId__c,a.Betaler__c From Account a  where a.Id = :controller.getRecord().Id];
            this.customer = [Select a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Id = :controller.getRecord().Id];
            deletePaymentCredits();  
            deleteDummyInvoice(); 
            deleteDummyPayment();
            updateVoidedCashCredits(paymentWrapper.voidedCredits); //carrie-979
            
            deleteOtherUnaapliedCredits(); //carrie-1010
        }catch(Exception e){  
            system.debug('e...'+e);      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e); 
        }
    } 
    
    /**
    * @description: This method checks for the dummy Invoice and Payment. 
    */
    public void checkDummyInvoice_Payment(){
        List<Payment__c> checkPaymentList = [select Name from Payment__c where Name = '00000' limit 1];
        List<Faktura__c> checkInvoiceList = [select Name from Faktura__c where Name = '00000' limit 1];
        if(checkPaymentList.size()==0){
            Payment__c dummyPayment = new Payment__c(); 
            dummyPayment.Customer__c = oppty.Account__c;
            dummyPayment.Aria_Account__c = oppty.Id;
            dummyPayment.Name = '00000';
            dummyPayment.Amount__c = 0;
            dummyPayment.Appplied_Amount__c = 0;
            dummyPayment.Payment_No__c = '00000';
            upsert dummyPayment;    
        }
        if(checkInvoiceList.size()==0){
            Faktura__c dummyInvoice = new Faktura__c(); 
            dummyInvoice.Customer__c = oppty.Account__c;
            dummyInvoice.Aria_Account__c = oppty.Id;
            dummyInvoice.Name = '00000';
            dummyInvoice.Betaling__c = 0;    
            dummyInvoice.Fakturanummer__c = '00000';
            upsert dummyInvoice;    
        }
    }
    
    /**
    * @description: This method is used to update the Voided cash credits @CARRIE-979. 
    */
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
    * @description: This method is used to update the Voided invoices @CARRIE-1255. 
    */
    public void updateVoidedInvoices(List<String> voidedInvoiceIds){
    	List<Faktura__c> voidInvoiceList = new List<Faktura__c>();
    	system.debug('voidedInvoiceIds' +voidedInvoiceIds);
    	voidInvoiceList = [SELECT id,Aria_Account__c,Fakturanummer__c, isVoid__c FROM Faktura__c where customer__c =: oppty.Account__c and Aria_Account__c =: oppty.Id and Fakturanummer__c in: voidedInvoiceIds];
    	system.debug('updateVoidedInvoices ' +voidInvoiceList);
    	for(Faktura__c voidInvoice : voidInvoiceList){
    		if(voidInvoice.isVoid__c != 'Voided')
    			voidInvoice.isVoid__c = 'Voided';
    		system.debug('prachi ' +invoicePaymentController.voidedDateTime.get(Long.valueOf(voidInvoice.Fakturanummer__c)));
    		if(invoicePaymentController.voidedDateTime != null && invoicePaymentController.voidedDateTime.keySet().contains(Long.valueOf(voidInvoice.Fakturanummer__c)))
    			voidInvoice.Void_Date__c = DateTime.valueOf(invoicePaymentController.voidedDateTime.get(Long.valueOf(voidInvoice.Fakturanummer__c)));
    	} 
    	update voidInvoiceList;
    }

    //start carrie-1010
    /**
    * @description: This method is used to delete unapplied cash credit @CARRIE-1010. 
    */
    public void deleteOtherUnaapliedCredits(){
    List<Unapplied_Credit__c> deleteList = new List<Unapplied_Credit__c>();
    List<Unapplied_Credit__c> updateUnappliedList = new List<Unapplied_Credit__c>();
    Map<String,Unapplied_Credit__c> deleteUnappliedMap = new Map<String,Unapplied_Credit__c>();
    for(Unapplied_Credit__c a: [select Name,Id,Unapplied_Amount1__c from Unapplied_Credit__c where Credit_type__c='Cash' and Customer__c =:oppty.Account__c and Aria_Account__c =:oppty.Id]){
        deleteUnappliedMap.put(a.Name,a);
        
    }
    system.debug(deleteUnappliedMap);
    if(deleteUnappliedMap.size()>0){
    AggregateResult[] groupedResults = [SELECT sum(Amount__c), name, max(Credit_Bel_b__c) from Applied_Credit__c where Account__c =:oppty.Account__c and Aria_Account__c =:oppty.Id and name in:deleteUnappliedMap.keyset() group by name];
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
   //end carrie-1010
   
   //Added for Carrie-1255
   public void calculateSaldofromTransaction(){
		List<Transaction__c> transactionList = new List<Transaction__c>();
		transactionList = [SELECT Aria_Account__c,Charge_Amt__c,Id,Name,End_Balance__c,Start_Balance__c,Transaction_no__c,Transaction_Source_ID__c,Transaction_Type__c FROM Transaction__c where Aria_Account__c = : oppty.Id and Transaction_Type__c = 1.0 and Charge_Amt__c > 0.0 order by Name asc];
		system.debug('transactionList ' +transactionList);
		Transaction__c lastTransaction = [Select Aria_Account__c,Charge_Amt__c,Id,Name,End_Balance__c, Start_Balance__c,Transaction_no__c,Transaction_Source_ID__c,Transaction_Type__c FROM Transaction__c where Aria_Account__c = : oppty.Id order by Name desc limit 1];
		Integer count = 0;		
		for(Transaction__c trans : transactionList){
			//For all invoices other than the last one
			if(count != transactionList.size()-1){
				invoiceSaldoMap.put(trans.Transaction_Source_ID__c,transactionList[count+1].Start_Balance__c);
			}
			//for last invoice
			else if(count == transactionList.size()-1){
				invoiceSaldoMap.put(trans.Transaction_Source_ID__c,lastTransaction.End_Balance__c); 
			}			
			count++;
		}
		system.debug('invoiceSaldoMap ' +invoiceSaldoMap);		
	}
	//End Carrie-1255
}