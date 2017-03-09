public class CarrieBillingBatchController{ 
    public Decimal AriaAccountNo {get; set;}
    public Aria_Account__c ariaAcc {get; set;}
    public ApexPages.StandardController controller {get; set;}
    public String selectAccount {get; set;} 
    public boolean showForbrug {get; set;}
    public boolean IsBB {get; set;}
    /*start for spoc-1874*/
    public boolean ISBBs {get; set;}
    /*end for spoc-1874*/
    
    public List<Transaction__c> transList {get; set;}
    public List<Invoice_Payment__c> invoicePaymentList {get; set;}
    public List<Payment_Invoice__c> paymentInvoiceList {get; set;}
    public List<Payment__c> paymentCreditList {get; set;}
    public List<Applied_Credit__c> appCreditList {get; set;}
    public List<Unapplied_Credit__c> unappCreditList {get; set;}
    
    private Aria_API_Configuration__c config { get; private set; }
    
    public String accountResponse;
    public String invoiceResponse;
    public String paymentResponse;
    public String transactionResponse;
    public String creditResponse;
    
    //Pagination variables
    public integer invoiceCounter {get; set;}  //keeps track of the offset
    public integer invoiceTotalSize {get; set;}
    public integer invoiceRows {get; set;}
    
    public integer paymentCounter {get; set;} //keeps track of the offset
    public integer paymentTotalSize {get; set;}
    public integer paymentRows {get; set;}
    
    public integer appCredCounter {get; set;}  //keeps track of the offset
    public integer appCredTotalSize {get; set;}
    public integer appCredRows {get; set;}
    
    public integer unappCredCounter {get; set;} //keeps track of the offset
    public integer unappCredTotalSize {get; set;}
    public integer unappCredRows {get; set;}
    
    public integer transCounter {get; set;} //keeps track of the offset
    public integer transTotalSize {get; set;}
    public integer transRows {get; set;}
    
    public integer ybCredCounter {get; set;}  //keeps track of the offset
    public integer ybCredTotalSize  {get; set;}
    public integer ybCredRows {get; set;}
    
    //public String strURLAriaAcc{get;set;}
    
    public boolean creditCreated;
    
    CarrieBillingControllerBatch billingController ;
    CarrieInvoiceController invoiceController ; 
    CarriePaymentController paymentController ;
    CarrieParseJsonTransaction transactionController ;
    CarrieServiceCredits serviceCredit ;
    
    public CarrieBillingBatchController(ApexPages.StandardController controller) {
        this.controller = controller;
        invoiceCounter = paymentCounter = appCredCounter = unappCredCounter = transCounter = ybCredCounter = 0;
        invoiceRows = paymentRows = appCredRows = unappCredRows = transRows = ybCredRows = 5;
        transList = new List<Transaction__c>();
        invoicePaymentList = new List<Invoice_Payment__c>();
        paymentInvoiceList = new List<Payment_Invoice__c>();
        paymentCreditList = new List<Payment__c>();
        appCreditList = new List<Applied_Credit__c>();
        unappCreditList = new List<Unapplied_Credit__c>();
        
        accountResponse = '';
        invoiceResponse = '';
        paymentResponse = '';
        transactionResponse = '';
        creditResponse = '';
        ariaAcc = new Aria_Account__c(); 
        ariaAcc = [Select Name, Updated__c, Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Id = :controller.getRecord().Id];
        if(ariaAcc.Aria_Plan_Name__c == 'YouBio'){
            showForbrug = false;
            IsBB=true;
            /*start for spoc-1874*/
           ISBBs=false;
           /*end for spoc-1874*/
        }else if(ariaAcc.Aria_Plan_Name__c == 'Blockbuster'){
            showForbrug = false;
            IsBB=false;
            /*start for spoc-1874*/
            IsBBs=true;
            /*end for spoc-1874*/
        }
        else{ 
            showForbrug = true;
            IsBB=true;
            /*start for spoc-1874*/
           ISBBs=false;
           /*end for spoc-1874*/

        }
        creditCreated = false;
        //strURLAriaAcc = '/' + controller.getRecord().Id + '?nooverride=1';
        //getBillingDetails();
    }
    
    public CarrieBillingBatchController(Aria_Account__c aria){
        ariaAcc = new Aria_Account__c(); 
        ariaAcc = [Select Name, Updated__c,Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Id = :aria.Id];
        accountResponse = '';
        invoiceResponse = '';
        paymentResponse = '';
        transactionResponse = '';
        creditResponse = '';
        creditCreated = true;
    }
    
    private void getBillingDetails(){
        transTotalSize = invoiceTotalSize = paymentTotalSize = appCredTotalSize = unappCredTotalSize = ybCredTotalSize = 0;
        transList = [SELECT Name, Aria_Account__c, Description__c, Posting_Date__c, Credit_Amt__c, Charge_Amt__c, End_Balance__c, Start_Balance__c, Transaction_no__c, Transaction_Source_ID__c, Transaction_Type__c 
                                FROM Transaction__c 
                                WHERE Aria_Account__c =: ariaAcc.Id 
                                order by Name desc];
        invoicePaymentList = [SELECT Id,Name,isVoid__c,Amount_Applied__c,Balance__c,Betalingsfrist__c,Titel__c,Datoforudskrift__c,Fakturabelob__c,Faktura__c, Faktura__r.Name,Invoice_Statement__c,Saldo__c,Service_Credit__c,Refund__C,Remaining_coupons__c
                                FROM Invoice_Payment__c 
                                WHERE Aria_Account__c =: ariaAcc.Id AND Name !='00000' 
                                order by Datoforudskrift__c desc];
        paymentInvoiceList = [SELECT Name, Id, Payment__c, Payment__r.Name, Payment_Date__c, Payment_Type__c, Amount__c, Fakturanummer__c, Amount_Applied__c, isVoid__c 
                                FROM Payment_Invoice__c 
                                WHERE Aria_Account__c =: ariaAcc.Id AND Payment_Type__c !='Credit' AND Name !='00000' 
                                order BY Payment__r.name desc, Fakturanummer__c desc];
        appCreditList = [SELECT Id, Name, Date__c, credit_type__c, credit_formula1__c, Credit_Reason__c, CommentsLong__c, Comments__c, Faktura__c, Faktura_link__c, Applied_Against__c, Amount__c, Amount_1__c, isVoid__c 
                                FROM Applied_Credit__c 
                                WHERE Aria_Account__c =: ariaAcc.Id 
                                order by Date__c desc];
        unappCreditList = [SELECT Id, Name, Date__c, Credit_type__c, Amount__c, Credit_Reason__c, Comments__c, commentsLong__c, Unapplied__c, Unapplied_Amount1__c, isVoid__c 
                                FROM Unapplied_Credit__c 
                                WHERE Aria_Account__c =: ariaAcc.Id 
                                order by Date__c desc];
                             
        if(showForbrug == false){                               
            paymentCreditList = [SELECT Name, Id, transaction_source_id__c,youbioCredit__c,YouBioLink__c , Payment_Date__c,Payment_type__c,Comments__c, CommentsLong__c, Amount__c, Credit_Reason__c 
                                FROM Payment__c 
                                WHERE Aria_Account__c =: ariaAcc.Id AND Payment_Type__c ='Credit' AND Name !='00000' 
                                order by Payment_Date__c desc, Name asc];
            ybCredTotalSize = paymentCreditList.size();     
        }                                           
        transTotalSize = transList.size();
        invoiceTotalSize = invoicePaymentList.size();
        paymentTotalSize = paymentInvoiceList.size();
        appCredTotalSize = appCreditList.size();
        unappCredTotalSize = unappCreditList.size();
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
    /**sample page redirecting for sample button start of spoc-1874*/
    public pagereference redirectSamplePage()
          {
        PageReference pageRef = new PageReference('/apex/samplepage?Id='+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;  
          }
    /** end of spoc-1874*/
    /**
    * @description: This method is used to redirect to the CarrieCustomerUsagePage.
    * @return: PageReference - CarrieCustomerUsagePage.
    */
    public PageReference redirectUsage(){
        PageReference pageRef = new PageReference('/apex/CarrieCustomerUsagePage?Id='+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;
    }  
     
    public PageReference refreshAriaAccount(){
        CarrieInsertRecordsBatch carMan = new CarrieInsertRecordsBatch();
        List<Aria_Account__c> ariaAccounts = new List<Aria_Account__c>();
        ariaAccounts.add(ariaAcc);
        invoiceCounter = paymentCounter = appCredCounter = unappCredCounter = transCounter = ybCredCounter = 0;
        invoiceRows = paymentRows = appCredRows = unappCredRows = transRows = ybCredRows = 5;   
        setClassVariables();
        if(!Test.isRunningTest()){
            accountResponse = billingController.getAriaAccountResponse(ariaAcc.Name);
            paymentResponse = paymentController.getAriaResponse();    
            invoiceResponse = invoiceController.getAriaResponse();  
            transactionResponse = transactionController.getAriaResponse(); 
            creditResponse = serviceCredit.getAriaResponse();
        }
        try{
            carMan.updateAriaAccounts(ariaAccounts,false,accountResponse);
            carMan.updatePaymentTransactions(ariaAccounts,false,paymentResponse);
            carMan.updateInvoicePayments(ariaAccounts,false,transactionResponse,invoiceResponse);
            carMan.updateCredits(ariaAccounts,false,creditResponse);
        }
        
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        
        ariaAcc = [Select Name, Updated__c, Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where a.Id = :ariaAcc.Id];
        ariaAcc.LastModifiedDateAria__c = system.now();
        ariaAcc.Updated__c = 'Manual';
        ariaAcc.API_calls__c = '';
        update ariaAcc;
        system.debug('ariaAccount after proc ' +ariaAcc);
        getBillingDetails();
        return null; 
    }
    
    public List<SelectOption> getSelectAccounts() {
        List<SelectOption> options = new List<SelectOption>();
        try{
            List<Aria_Account__c> listAcct = [select Id,Aria_Plan_Name__c from Aria_Account__c where Account__c =: ariaAcc.Account__c ];
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
    * @description: This method is used to redirect to Casper.
    * @return: PageReference - Casper.
    */ 
    public PageReference callToCasper(){
        //system.debug('=====inside here======='+ariaAcc.Account__c);
        Boolean stats = clsCasperButton.sendToCasper(ariaAcc.Account__c);
        //system.debug('====stats======='+stats);
        return null;
    }
    
    public void setClassVariables(){
        try{            
            billingController = new CarrieBillingControllerBatch(decimal.valueOf(ariaAcc.Account__r.Customer_No__c),ariaAcc.Id);
            paymentController = new CarriePaymentController(ariaAcc);
            invoiceController = new CarrieInvoiceController (ariaAcc);
            transactionController = new CarrieParseJsonTransaction(ariaAcc);
            serviceCredit = new CarrieServiceCredits (ariaAcc);
        }catch(Exception e){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e); 
        }
    }
    
    public PageReference refreshNewAccounts(){
        Integer existingTransactions = 0;
        existingTransactions = [Select count() from Transaction__c where Aria_Account__c =: ariaAcc.Id];
        system.debug('Number of existing transactions for aria account: ' + existingTransactions);
        //If there are not transactions (for new accounts) refresh aria accounts
        if(existingTransactions == 0)
            refreshAriaAccount();
        getBillingDetails();
        return null;
    }
}