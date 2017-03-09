public class BlockBusterCreateAriaAccts {

    public List<Aria_Account__c> listAriaAcc = new List<Aria_Account__c>();
    public Map<String,Account>mapAccNoToAcc = new Map<String,Account>();
    public Aria_API_Configuration__c config { get; public set; }
    public List<Aria_Account__c> listBetaler {get;set;}
    public Map<String,Id> pageLayoutRecordType{get;set;}
    public string AccId;
    public String ArialastModDate{get;set;}
    public String Betalerid{get;set;}
    
    public BlockBusterCreateAriaAccts(ApexPages.StandardController ctlr){ 
        AccId = ctlr.getId();
        Betalerid = '';
        initializeRecordTypes();
        listBetaler = new List<Aria_Account__c>();
        Account objAcc = [SELECT id,Betaler_Id__c FROM Account WHERE id =: AccId];
        if(objAcc.Betaler_Id__c != null){
            Aria_Account__c objAriaAc = [SELECT id,name,LastModifiedDateAria__c FROM Aria_Account__c WHERE Account__c =: AccId limit 1];        
            if(objAriaAc != null)
                //ArialastModDate = objAriaAc.LastModifiedDateAria__c.format('dd-MM-yyyy HH:mm a');
                ArialastModDate = 'Synchronized';
        }
        else
            ArialastModDate = '';       
    }
    
    public pagereference createAriaAccts(){
        system.debug('inside the createAriaAccts method');
        String AriaResponse = '';
        errmesage = '';
        initializeRecordTypes();
        List<Account> listAcc = new List<Account>();
        
        if(listBetaler.isempty()){
	        for(Account objAcc:[SELECT id,name,Customer_No__c from Account where id =: AccId])
	            mapAccNoToAcc.put(objAcc.Customer_No__c,objAcc);
	            
	        system.debug(mapAccNoToAcc);
	        config = CarrieCommonUtil.validateAPIConfiguration(config);
	            
	        if(mapAccNoToAcc.size()!=null)
	            AriaResponse = InsertAriaAccs(mapAccNoToAcc);
	            
	        system.debug('string response'+AriaResponse);
	            
	        listBetaler = parseResponse(AriaResponse,mapAccNoToAcc); 
	        system.debug('list of the aria accounts'+listBetaler);
        }
        List<Aria_Account__c> deleteAriaAccount = [Select a.Name From Aria_Account__c a where a.Account__c=:AccId and a.Name NOT IN :lstStr ];
            delete deleteAriaAccount;
        try{
        	if(!listBetaler.isEmpty())
            	upsert listBetaler Aria_Account_No__c;
        }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception);
            ApexPages.addMessage(errorMsg);
            CarrieLog.LogException(e);
            return null;
        }
        
        for(Aria_Account__c objAriaAcc: listBetaler){
            
            Account objAcc = new Account(id=objAriaAcc.Account__c);
            objAcc.Betaler__c = objAriaAcc.Betaler__c;
            objAcc.Betaler_ID__c = objAriaAcc.name;
            listAcc.add(objAcc);
        }
        
        if(!listAcc.isEmpty()){
            
            update listAcc;
            
        }
            
        return null;    
    }
    
    public String errmesage{get;set;}
    public pagereference getfurtheritems(){
        
        
        system.debug('listBetaler inside getfurtheritems '+listBetaler);
        String response;
        
        if(!listBetaler.isEmpty()){
        // Retrieve the Transactions
        CarriePaymentController paymentController = new CarriePaymentController(listBetaler[0]);
        if(!Test.isRunningTest())
            response = paymentController.getAriaResponse();        
        
        //Retrive the Invoices
        //Start consturct query string
        String billingQueryString = '';   
        String transQueryString = '';
        String invoiceQueryString = '';
        Set<Id> accountIds = new Set<Id>();
        Integer count = 0;
        for(Aria_Account__c aria : listBetaler){
            accountIds.add(aria.Id);
            if(count == listBetaler.size()-1)  {
                transQueryString += 'acct_no='+aria.Name + ' AND transaction_type_no != -2 AND transaction_type_no != -3';
                invoiceQueryString += 'acct_no='+aria.Name;
                billingQueryString += 'acct_no='+aria.Name;
            }
            else{
                transQueryString += 'acct_no='+aria.Name+' OR ';
                invoiceQueryString += 'acct_no='+aria.Name+' OR '; 
                billingQueryString += 'acct_no='+aria.Name+' OR ';
            }
            count++;
        }
        
        HttpResponse billingResponse;  
        billingResponse = AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => billingQueryString});
        String billingResp;
        if(!Test.isRunningTest()){
            system.debug('billing response in batch ' +billingResponse.getBody());
            billingResp = billingResponse.getBody();
        }
        
        //Fetch transaction response from Aria
        HttpResponse transactionResponse;
        transactionResponse = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => transQueryString });
        String transactionResp;
        
        if(!Test.isRunningTest()){
            system.debug('transaction response in batch ' +transactionResponse.getBody());
            transactionResp = transactionResponse.getBody();
        }
        
        //Fetch invoice response from Aria
        HttpResponse invoiceResponse; 
        invoiceResponse = AriaWebServices.makeCallForJson('get_invoice_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => invoiceQueryString });
        String invoiceResp;
        if(!Test.isRunningTest()){
            system.debug('invoiceResponse response in batch ' +invoiceResponse.getBody());
            invoiceResp = invoiceResponse.getBody();
        }
            
        String unappCredQueryString = listBetaler[0].Name;
        //Fetch unapplied service credits response from aria
        HttpResponse unappCredResponse;
        unappCredResponse = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_unapplied_service_credits', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'acct_no' => unappCredQueryString });
        String creditResponse;
        if(!Test.isRunningTest()){
            system.debug('unapplied credit response in batch ' +unappCredResponse.getBody());
            creditResponse = unappCredResponse.getBody();  
        } 
        
        CarrieInsertRecordsBatch carMan = new CarrieInsertRecordsBatch();
        if(!Test.isRunningTest()){
        	carMan.updatePaymentTransactions(listBetaler,true,response);
            carMan.updateAriaAccounts(listBetaler,true,billingResp);
            carMan.updateInvoicePayments(listBetaler,true,transactionResp,invoiceResp);
            carMan.updateCredits(listBetaler,true,creditResponse);
            carMan.updateOthers(accountIds);  
            }
        }
        
        return null;
        
    }
    
    public pagereference getBBdatetime(){
        
        system.debug('inside getBBdatetime ');
        if(!listBetaler.isEmpty()){
            Set<String>setAr1 = new Set<String>();
            setAr1.add(listBetaler[0].Name);
            BlockBusterDateTypeTitle obj = new BlockBusterDateTypeTitle(); 
            obj.getTypeTitle(setAr1);   
        }
            
        return null;
    }
    
    public pagereference getRefundDetails(){
        
        if(!listBetaler.isEmpty()){
            BlockBusterDateTypeTitle obj = new BlockBusterDateTypeTitle();
            obj.RefundDetails(listBetaler[0].Account__c);
            
            listBetaler[0].LastModifiedDateAria__c = System.now();
            update listBetaler;
            
            //ArialastModDate = listBetaler[0].LastModifiedDateAria__c.format('dd-MM-yy HH:mm a');
            //ArialastModDate = 'Synchronized';
            Betalerid = listBetaler[0].Name;
     
        }
        else{
            ArialastModDate = 'No ARIA account associated';
        }
        
        return null;
    }
    
    public String InsertAriaAccs(Map<string,Account>mapAcnoToacc){
        
        String ariaaccString = '';
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        Integer count = 0;
        for(String strBet:mapAcnoToacc.keyset()){
            
            if(count == mapAcnoToacc.keyset().size()-1)  { // to create the query string to pass to get_transaction_information service
                ariaaccString += 'supp_field_value='+strBet;
            }
            else
                ariaaccString += 'supp_field_value='+strBet+' OR ';
        }
        system.debug('ariaaccString===='+ariaaccString);
        
        HttpResponse response =AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => ariaaccString});       
        if(response != null){
          return response.getBody();
        }
        else
            return null;
        
        
    }
    
    /*
    * @description: Inner class for betaler accounts.
    */
    public class BetalerAccounts{
      public String name{get;set;}
      public  String AriaNo{get;set;}
      public String CustNo{get;set;}
      public String plan{get;set;}
  
      public BetalerAccounts(){}
  }
  
  List<String>lstStr = new List<String>();
  public List<Aria_Account__c> parseResponse(String strData,Map<String,Account>mapAccNoToAcc1){
    
        List<Aria_Account__c> Accountlist = new List<Aria_Account__c>();
        try{
            Aria_Account__c AriaAcct;
            String error = '';
            CarrieBillingWrapper billingWrapper = new CarrieBillingWrapper();
            billingWrapper = CarrieBillingWrapper.parse(strData);
            
            for(CarrieBillingWrapper.Account_details a : billingWrapper.account_details){
                
                    AriaAcct = new Aria_Account__c();
                    AriaAcct.Aria_Account_No__c = a.acct_no;
                    AriaAcct.Name = ''+a.acct_no;
                    lstStr.add(AriaAcct.Name);
                    AriaAcct.Account__c = mapAccNoToAcc1.get(a.supp_field[0].supp_field_value).id;
                    AriaAcct.Aria_Plan_Name__c = a.plan_name;
                    AriaAcct.Regningsstatus__c = a.status_name;
                    AriaAcct.Aria_Pay_Method__c = CarrieCommonUtil.PAY_METHOD_MAP.get(a.pay_method);
                    AriaAcct.CurrentSaldo__c = a.acct_balance;
                    AriaAcct.End_Balance__c = a.acct_balance; // issue 752
                    AriaAcct.Start_Balance__c = 0; // issue 752
                    if(a.plan_name.equalsIgnoreCase('YouBio')){
                        AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_YouBio');              
                   
                    }else if(a.plan_name.equalsIgnoreCase('Blockbuster')){
                        AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_Blockbuster');           
       
                    }else{
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
            system.debug('error message======'+e.getMessage());
        }
        return Accountlist;
  }
  
  public void initializeRecordTypes(){
      List<String> recordTypeName = new List<String>();
        recordTypeName.add('Carrie_Telephony');
        recordTypeName.add('Carrie_YouBio');
        recordTypeName.add('Carrie_Blockbuster');
        pageLayoutRecordType = new Map<String,Id>();
        List<RecordType> recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName in : recordTypeName];
        for(RecordType rt :recordtypes){
            pageLayoutRecordType.put(rt.DeveloperName,rt.Id);
        }
    }
}