/***********************************************************************************
************************************************************************************

* @class: CarriePaymentController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get payment related information for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarriePaymentController {
    private Aria_API_Configuration__c config { get; private set; }
    public Decimal AriaAccountNo ;
    public Id customerId;
    public Id AriaAccountId;
    public List<Payment__c> latestpayment{get;set;}
    public Map<string,string> mapPayment;
    public Map<String,String> mapLongComments;
    public List<Payment__c> paymentList;
    public Payment__c payment;
    public String latestPaymentdate;
    public String AriaPlanName{get;set;}
    public Transaction__c trans; //@CARRIE-752
    public Map<string,string> mapTrans; //@CARRIE-752
    public List<Transaction__c> transList; //@CARRIE-752
    public List<Transaction__c> latestTransaction {get;set;} //@CARRIE-752    
    public List<String> voidedCreditIds{get;set;} //@carrie-979
     
    public CarriePaymentController (Aria_Account__c customer){
        customerId = customer.Account__c;
        AriaAccountId = customer.Id;
        AriaAccountNo = customer.Aria_Account_No__c;
        AriaPlanName = customer.Aria_Plan_Name__c;
    }
    
    /**
    * @description: This method makes API call to Aria System for getting payment related information.
    * @return: Response From Aria.
    */
    public String getAriaResponse(){
    if(AriaPlanName!='YouBio'){
        getLatestPayment();
        }
        getLatestTransaction(); //CARRIE-752
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        HttpResponse response;
        if(latestPayment!=null && latestPayment.size()>0 && latestTransaction!=null && latestTransaction.size()>0){
            latestPaymentdate=String.valueOf(latestpayment[0].Payment_Date__c);
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_acct_trans_history', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new Map<String, String> { 'account_no' => String.valueOf(AriaAccountNo), 'record_limit' => '2000', 'start_date'=>latestPaymentdate, 'include_void_transactions' => 'TRUE'});
        }else{
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_acct_trans_history', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new Map<String, String> { 'account_no' => String.valueOf(AriaAccountNo), 'record_limit' => '2000' , 'include_void_transactions' => 'TRUE'});
        }
        system.debug('Response from Payment Controller'+response.getBody());
        return response.getBody();
    }
 
    /**
    * @description: This method  is use to parse the json response from Aria.
    * @param: Response json response from Aria.
    * @return: CarriePaymentWrapper.
    */
    public CarriePaymentWrapper getPaymentDetails(String data){
        try{
            CarriePaymentWrapper paymentWrapper = new CarriePaymentWrapper();
            paymentList = new List<Payment__c>();
            voidedCreditIds = new List<String>(); //carrie-979    
            mapPayment = new Map<string,string>(); 
            mapLongComments = new Map<String,String>();
            transList = new List<Transaction__c>(); //CARRIE-752
            mapTrans= new Map<string,string>(); //CARRIE-752
            String error = '0';
            boolean flag = false;
            JSONParser parser = JSON.createParser(data);
            List<DateTime> dateTimeList = new List<DateTime>();
            while (parser.nextToken() != null) {
                if(parser.getCurrentName()=='error_code'){
                    error = parser.getText();
                    flag=true;
                }
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            CarrieParsePaymentInfo parsePayment;
                            parsePayment = (CarrieParsePaymentInfo)parser.readValueAs(CarrieParsePaymentInfo.class);
                            //Added for new batch
                             String myDate = parsePayment.transaction_create_date;
							DateTime newDate = DateTime.valueOf(myDate + ' 00:00:00');
                            dateTimeList.add(newDate);
                            if(latestpayment!=null && latestpayment.size()>0){
                                if(parsePayment.transaction_id > integer.valueOf(latestpayment[0].Name)){
                                constructPayment(parsePayment);
                                }
                            }else{
                                constructPayment(parsePayment);
                            }
                            constructTransaction(parsePayment); //CARRIE-752
                        }
                    }
                }
            }
            dateTimeList.sort();
            if(latestPayment!=null){
                        for(Payment__c addPaymentInfo : latestPayment){
                if(mapLongComments.size()>0){ 
                    if(mapLongComments.get(addPaymentInfo.Name)==null){
                    mapLongComments.put(addPaymentInfo.Name,addPaymentInfo.CommentsLong__c);
                    }   
                }else{
                    mapLongComments.put(addPaymentInfo.Name,addPaymentInfo.CommentsLong__c);
                }
            }
            }
            paymentWrapper.paymentList = paymentList;
            paymentWrapper.mapInsertedPayment =  mapPayment;
            paymentWrapper.mapLongComments = mapLongComments;
            paymentWrapper.transList = transList; //CARRIE-752
            paymentWrapper.mapInsertedTrans =  mapTrans; //CARRIE-752
            paymentWrapper.voidedCredits = voidedCreditIds;//carrie-979
            //Added for new batch
            paymentWrapper.latestTransactionDate = dateTimeList;
            return paymentWrapper;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            return new CarriePaymentWrapper();
        }
    }
    
    /**
    * @description: This method  is used to create payment object .
    */
    public void constructPayment(CarrieParsePaymentInfo parsePayment){
        payment = new Payment__c();
        payment.Customer__c = customerId; 
        payment.Aria_Account__c = AriaAccountId;
        payment.hasInvoice__c = '';
        payment.Name = ''+parsePayment.transaction_id;
        payment.transaction_source_id__c=''+parsePayment.transaction_source_id;
        payment.Aria_Event_No__c = ''+parsePayment.transaction_id;
        payment.Payment_No__c  = ''+parsePayment.transaction_id;   
        
        //Start of CARRIE-657
        if(parsePayment.credit_reason_code_description == null){
            payment.Credit_Reason__c = '';	
        }else {
			payment.Credit_Reason__c = parsePayment.credit_reason_code_description;
        }
        //End of CARRIE-657           
        if(AriaPlanName=='YouBio'){
        if(parsePayment.transaction_void_date==null){
        	payment.isVoid__c='';
        }else{
        	payment.isVoid__c='Voided';
        	payment.Void_Date__c = Date.valueOf(parsePayment.transaction_void_date);
        }
            Long paymnetType = parsePayment.transaction_type;
            payment.Payment_Type__c = CarrieCommonUtil.TRANS_METHOD_MAP.get(paymnetType);
            if(paymnetType == 2 || paymnetType == 3 || paymnetType == 10 || paymnetType==18 || paymnetType==15){
                payment.Payment_Date__c = date.valueOf(parsePayment.transaction_create_date);
                if(parsePayment.transaction_applied_amount!=null){
                        payment.Appplied_Amount__c = parsePayment.transaction_applied_amount;
                }else{
                    payment.Appplied_Amount__c = 0;
                }
                payment.Amount__c = -parsePayment.transaction_amount;
                String commnets = parsePayment.transaction_comments;
                if((commnets==null)||(commnets=='{none}')){
                    payment.Comments__c='';
                    payment.CommentsLong__c ='';
                }else{
                    payment.CommentsLong__c  = parsePayment.transaction_comments;
                    if(parsePayment.transaction_comments.length()>25){
                        String longComments = parsePayment.transaction_comments.substring(0, 22);
                        longComments = longComments +'...';                                         
                        payment.Comments__c= longComments;
                    }else{
                        payment.Comments__c= parsePayment.transaction_comments;
                    }
                    mapLongComments.put(payment.Name,payment.CommentsLong__c);
                }
                paymentList.add(payment);
                mapPayment.put(payment.Name,payment.Name);
            }else if(parsePayment.transaction_type == -10){ //carrie-979
            	voidedCreditIds.add(''+parsePayment.transaction_source_id); //carrie-979            	
            }
            }else{
            	
            if(parsePayment.transaction_void_date==null){ ////carrie-979 & CARRIE-789
             	payment.isVoid__c='';
            }else{
            	payment.isVoid__c='Voided';
            	payment.Void_Date__c = Date.valueOf(parsePayment.transaction_void_date);
            }
            Long paymnetType = parsePayment.transaction_type;
            payment.Payment_Type__c = CarrieCommonUtil.TRANS_METHOD_MAP.get(paymnetType);
            system.debug('paymnetType ' +paymnetType);
            if(paymnetType == 2 || paymnetType == 3 || paymnetType == 10 || paymnetType==18 || paymnetType==15){
                payment.Payment_Date__c = date.valueOf(parsePayment.transaction_create_date);
                if(parsePayment.transaction_applied_amount!=null){
                        payment.Appplied_Amount__c = parsePayment.transaction_applied_amount;
                }else{
                    payment.Appplied_Amount__c = 0;
                }
                payment.Amount__c = -parsePayment.transaction_amount;
                String commnets = parsePayment.transaction_comments;
                if((commnets==null)||(commnets=='{none}')){
                    payment.Comments__c='';
                    payment.CommentsLong__c ='';
                }else{
                    payment.CommentsLong__c  = parsePayment.transaction_comments;
                    if(parsePayment.transaction_comments.length()>25){
                        String longComments = parsePayment.transaction_comments.substring(0, 22);
                        longComments = longComments +'...';                                         
                        payment.Comments__c= longComments;
                    }else{
                        payment.Comments__c= parsePayment.transaction_comments;
                    }
                    mapLongComments.put(payment.Name,payment.CommentsLong__c);
                }
                paymentList.add(payment);
                mapPayment.put(payment.Name,payment.Name);
            }
            else if(parsePayment.transaction_type == -10){ //carrie-979
            	voidedCreditIds.add(''+parsePayment.transaction_source_id); //carrie-979            	
            }
        }
    }
    
    /**
    * @description: This method  is used to get the latest Payment number .
    */
    public void getLatestPayment(){
        latestPayment = [SELECT Name,Payment_Date__c,CommentsLong__c FROM Payment__c where Aria_Account__r.Aria_Account_No__c =: AriaAccountNo and Aria_Account__c =:AriaAccountId and  Customer__c =: customerId  and (NOT Name like '00000') order by Name desc];
    }
    
    /** Start of CARRIE-752
    * @description: This method  is used to create transaction object CARRIE-752
    */
    public void constructTransaction(CarrieParsePaymentInfo parsePayment){
        trans = new Transaction__c();
        trans.Customer__c = customerId; 
        trans.Aria_Account__c = AriaAccountId;
        trans.Name = ''+parsePayment.transaction_id;  
        trans.Transaction_No__c  = ''+parsePayment.transaction_id;            
        trans.Posting_Date__c = date.valueOf(parsePayment.transaction_create_date);
        trans.Description__c = parsePayment.transaction_desc; 
        trans.Transaction_Source_Id__c = ''+parsePayment.transaction_source_id; //Carrie-789
        trans.Transaction_Type__c = parsePayment.transaction_type; //Carrie-789
        Double transAmt = parsePayment.transaction_amount; 
        if(transAmt >0){
                trans.Charge_Amt__c = parsePayment.transaction_amount; }
        else{
                trans.Credit_Amt__c = -parsePayment.transaction_amount;}       
        transList.add(trans);
        mapTrans.put(trans.Name,trans.Name); 
    }
    
   /**
    * @description: This method  is used to get the latest Transaction number .
    */
    public void getLatestTransaction(){
        latestTransaction = [SELECT Name,Posting_Date__c FROM Transaction__c where Aria_Account__r.Aria_Account_No__c =: AriaAccountNo and Aria_Account__c =:AriaAccountId and  Customer__c =: customerId  order by Name desc];
    }
    // End of CARRIE-752    
}