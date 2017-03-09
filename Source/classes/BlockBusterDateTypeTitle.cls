global class BlockBusterDateTypeTitle {

	public Aria_API_Configuration__c config { get; public set; }  
	public Map<String,String>mapInvToType;
    public Map<String,String>mapInvToTitle;  
	public BlockBusterDateTypeTitle(){
		mapInvToType = new Map<String,String>();
        mapInvToTitle = new Map<String,String>();
	}
	webservice static void BlockBusterDateTypeTitleMethod(String strAccId){
		
		system.debug('==strAccId====='+strAccId);
		Set<String>setAr1 = new Set<String>();
     	for(Account a:[SELECT name,Betaler_id__c,Customer_No__c FROM Account where id =:strAccId])
     	setAr1.add(a.Betaler_id__c); 
     	BlockBusterDateTypeTitle obj = new BlockBusterDateTypeTitle();
     	obj.getTypeTitle(setAr1);
	}

	Map<String,String>mapTrantodate = new Map<String,String>();
	public void getNewdate(Set<String>setAriaAccNumber){
		
		
    	String transQueryString = '';
    	config = CarrieCommonUtil.validateAPIConfiguration(config);
    	Integer count = 0;
    	String transactionResp;
    	for(String strBet:setAriaAccNumber){
    		
    		if(count == setAriaAccNumber.size()-1)  { // to create the query string to pass to get_transaction_information service
    			transQueryString += 'acct_no='+strBet;
    		}
    		else
    			transQueryString += 'acct_no='+strBet+' OR';
    	}
    	
		//Fetch transaction response from Aria 
    	HttpResponse transactionResponse;
    	transactionResponse = AriaWebServices.makeCallForJson('get_transaction_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => transQueryString });
    	if(transactionResponse!=null){ 
    		system.debug('transaction response in batch ' +transactionResponse.getBody());
        	transactionResp = transactionResponse.getBody(); 
        	mapTrantodate = parsetrans(transactionResp);
        	system.debug('in getNewdate===='+mapTrantodate); 
    	}  
	} 
	   
	public void getTypeTitle(Set<String>setAriaAccNumber){
	
	    List<Invoice_Subscription__c>listInv = new List<Invoice_Subscription__c>();
    	Integer totalCallouts = Limits.getCallouts();
        Integer CalloutLimit = Limits.getLimitCallouts();
        Integer remainingCallout = CalloutLimit-totalCallouts;
        System.debug('******totalCallouts****'+totalCallouts+' *****CalloutLimit****'+CalloutLimit);
		if(setAriaAccNumber.size() == 1){
			listInv = Database.query('Select Id,Order_Number__c,Invoice_Number__c,Service_Name__c,Faktura__c,Faktura__r.Fakturanummer__c,Faktura__r.Aria_Account__c ,Faktura__r.Aria_Account__r.Name,Faktura__r.Aria_Account__r.Account__c,Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c From Invoice_Subscription__c where Faktura__r.Aria_Account__r.Name in: setAriaAccNumber and Order_Number__c!=null and Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c =\'Blockbuster Customer Account\' and (NOT Service_Name__c LIKE \'%koda%\') order by Createddate desc');
            
            if(!listInv.isEmpty() && listInv.size() < remainingCallout)
				getTypeTitleRefresh(listInv,setAriaAccNumber);
            else if(!listInv.isEmpty() && listInv.size()> remainingCallout){ // Commented for callout exceed error
				//if(!listInv.isEmpty()){
                //BlockBusterGetTypeTitleBatch objBBTYpeTitle = new BlockBusterGetTypeTitleBatch('Select Id,Order_Number__c,Invoice_Number__c,Service_Name__c,Faktura__c,Faktura__r.Fakturanummer__c,Faktura__r.Aria_Account__c ,Faktura__r.Aria_Account__r.Name,Faktura__r.Aria_Account__r.Account__c,Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c From Invoice_Subscription__c where Faktura__r.Aria_Account__r.Name in: setAriaAccNumber and Order_Number__c!=null and Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c =\'Blockbuster Customer Account\' and (NOT Service_Name__c LIKE \'%koda%\') order by Order_Number__c ,Name asc',setAriaAccNumber);			
                if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){
                
                BlockBusterGetTypeTitleBatch objBBTYpeTitle = new BlockBusterGetTypeTitleBatch(setAriaAccNumber,false);
                Database.executeBatch(objBBTYpeTitle,1);
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Concurrent_Batch_Err_Message));	
            }
		}
		 
		
	}
	
 }
	
	public void getTypeTitleRefresh(List<Invoice_Subscription__c>listInvsubs,Set<String>setAriaAccNumber){
		Map<String,String>MapInvoiceNoToTitle = new Map<String,String>();
        config = CarrieCommonUtil.validateAPIConfiguration(config);
      /*  Integer totalCallouts = Limits.getCallouts();
        Integer CalloutRemain = Limits.getLimitCallouts();
        System.debug('******totalCallouts****'+totalCallouts+' *****CalloutRemain****'+CalloutRemain);*/
		for(Invoice_Subscription__c obj:listInvsubs ){
			//config = CarrieCommonUtil.validateAPIConfiguration(config);
			
	        system.debug('===listInvSubs=='+listInvSubs);
	        String orderResponseBody;      
	        HttpResponse orderResponse;  
	        orderResponse = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c,'get_order_items',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'order_no' => obj.Order_Number__c});
	        //system.debug('billing response in batch ' +orderResponse.getBody());
	        if(orderResponse!=null){
	        	orderResponseBody = orderResponse.getBody();
	        	MapInvoiceNoToTitle.put(obj.Faktura__r.Fakturanummer__c,orderResponseBody);
			}
		}
        Integer totalCallouts1 = Limits.getCallouts();
        Integer CalloutRemain1 = Limits.getLimitCallouts();
        System.debug('******totalCallouts****'+totalCallouts1+' *****CalloutRemain****'+CalloutRemain1);
		parseorder(MapInvoiceNoToTitle,setAriaAccNumber);
	}
	
	public void setdateTypeTitle(Set<String>setAriaAccNumber){
		system.debug('mapInvToType==in3=='+mapInvToType);
	    system.debug('mapInvToTitle==in3=='+mapInvToTitle);
	    system.debug('setAriaAccNumber==in3=='+setAriaAccNumber);
		List<Transaction__c> updateTranList = new List<Transaction__c>();
		List<Transaction__c> listTransToUpdate = new List<Transaction__c>();
		List<Invoice_Payment__c> listInvPayUpdate = new List<Invoice_Payment__c>();
      	Map<String,List<Transaction__c>>mapBetalerIdToTransList = new Map<String,List<Transaction__c>>();
      	
      	updateTranList =  [Select Id,charge_amt__c,type__c,Titel__c,Transaction_date__c,Transaction_No__c,credit_amt__c, end_balance__c, start_balance__c, 
      							Aria_Account__r.name, Transaction_Source_ID__c, Transaction_Type__c
                                        From Transaction__c where Aria_Account__r.name in:setAriaAccNumber and Aria_Account__r.Account__r.RecordTypeName__c = 'Blockbuster Customer Account' order by Name asc, Aria_Account__c];
         
         set<Decimal> Invoicetransactionno= new set<Decimal> ();
         if(!updateTranList.isEmpty()){
	         for(Transaction__c trans : updateTranList ){   
		                if(trans.Transaction_Type__c ==1)                                                                    
		                	Invoicetransactionno.add(Decimal.valueOf(trans.Transaction_Source_ID__c));
		                                             
	         }   
         }                              
         List<Invoice_Payment__c> InvList = new List<Invoice_Payment__c>();
                InvList =  [Select i.Id,i.Transaction_date__c,i.invoice_no__c,i.Aria_Account__r.name,i.Transaction_No__c,Refund_button__c,Fakturanummer__c,Faktura__c,Faktura__r.HasKlips__c ,Titel__c,Faktura__r.Aria_Account__r.Account__c,Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c
                                        From Invoice_Payment__c i where i.Aria_Account__r.name in: setAriaAccNumber and Fakturanummer__c in: Invoicetransactionno and Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c ='Blockbuster Customer Account' order by i.Name asc, i.Aria_Account__c];
                                        
        
        
        if(!updateTranList.isEmpty()){
        	for(Transaction__c trans : updateTranList )
               {   
               System.debug('Invoice Transaction_Source_ID__c @@@@ '+trans.Transaction_Source_ID__c);
                    Transaction__c objTrans = new Transaction__c(id=trans.id);
                    if(transwithdate.keySet().contains(trans.Transaction_Source_ID__c))
                    {
                        //SPOC-1955
                        string transStrDate = transwithdate.get(trans.Transaction_Source_ID__c);
                        Datetime transDateDTFrmat = datetime.valueof(transStrDate);
                        string transDate = transDateDTFrmat.format('dd-MM-yyyy'); 
                        String localTime = transDateDTFrmat.format('HH:mm');
                        //trans.Transaction_date__c=transwithdate.get(trans.Transaction_Source_ID__c);
                        objTrans.Transaction_date__c = transDate+' '+localTime;
                        //END SPOC-1955
                    }              
                    if(mapInvToType.keySet().contains(trans.Transaction_Source_ID__c))
                    {
                    	System.debug('Invoice Type @@@@ '+(mapInvToType).get(trans.Transaction_Source_ID__c));
                        objTrans.type__c=mapInvToType.get(trans.Transaction_Source_ID__c);  
                        
                    }
                    // SPOC-1941/1913
                    if(mapInvToTitle.keySet().contains(trans.Transaction_Source_ID__c) && (objTrans.type__c == 'Blockbuster Leje' || objTrans.type__c == 'Blockbuster Køb' || objTrans.type__c == '' || objTrans.type__c == null))
                    {
                    	System.debug('Invoice Type @@@@ '+mapInvToTitle.get(trans.Transaction_Source_ID__c));
                        objTrans.Titel__c = mapInvToTitle.get(trans.Transaction_Source_ID__c);  
                        
                    }
                    if(mapInvToTitle.keySet().contains(trans.Transaction_Source_ID__c) && objTrans.type__c == 'Blockbuster Klippekort')
                    {
                        objTrans.Titel__c = 'Klippekort';
                    }
                    listTransToUpdate.add(objTrans);
                }     
                
        	}
        	
        	if(!InvList.isEmpty()){
        		for(Invoice_Payment__c objInv: InvList){
        			       			
        			Invoice_Payment__c objInvUpdate = new Invoice_Payment__c(id=objInv.Id);
        			
        			system.debug('objInv.Fakturanummer__c'+objInv.Fakturanummer__c);
        			system.debug('mapInvToTitle'+mapInvToTitle);
        			system.debug('transwithdate'+transwithdate);
        			system.debug('mapInvToType'+mapInvToType);
        			
        			
        			/*if(objInv.Refund_button__c != null)
                    {
                        objInvUpdate.Titel__c = BlockBusterDateTypeTitle.mapInvToTitle.get(String.valueOf(objInv.Fakturanummer__c));
                    }
                    if(objInv.Refund_button__c == null)
                    {
                        objInvUpdate.Titel__c = 'Klippekort'; 
                    }*/
                    if(objInv.Faktura__r.HasKlips__c == 0 && mapInvToTitle.keySet().contains(String.valueOf(objInv.Fakturanummer__c)))
                    {
                        objInvUpdate.Titel__c = mapInvToTitle.get(String.valueOf(objInv.Fakturanummer__c));
                        System.debug('****objInvUpdate.Titel__c***'+objInvUpdate.Titel__c);
                        listInvPayUpdate.add(objInvUpdate);
                    }
                    if(objInv.Faktura__r.HasKlips__c != 0)
                    {
                        objInvUpdate.Titel__c = 'Klippekort';
                        listInvPayUpdate.add(objInvUpdate);
                    }
                    
                    
        		}
        	}
        	Database.SaveResult[] srUpdateTrans;
        	Database.SaveResult[] srUpdateInv;
        	Integer errCount = 0;
        	system.debug('transactions to be updated'+listTransToUpdate);
        	system.debug('Invoice Payment to be updated'+listInvPayUpdate);
        	if(!listTransToUpdate.isEmpty())
        		srUpdateTrans = Database.update(listTransToUpdate,true);
        		
        	if(!listInvPayUpdate.isEmpty()){}
        		srUpdateInv = Database.update(listInvPayUpdate,true);
        		
        	/*if(setAriaAccNumber.size() == 1)
        	{
        		if(!Test.isRunningTest()){
	        		for(Database.SaveResult  sr :  srUpdateTrans)
	        		{
	        			if(sr.isSuccess())
	        				errCount = 0;
	        			else
	        				errCount++;
	        		}
	        		for(Database.SaveResult  sr :  srUpdateInv)
	        		{
	        			if(sr.isSuccess())
	        				errCount = 0;
	        			else
	        				errCount++;
	        		}
	        		if(errCount == 0)
	        		{
	        			CarrieBatchUtil insertRec = new CarrieBatchUtil();
	        			if(!Test.isRunningTest())
	        				insertRec.sendEmailforRefresh(batchId,false,InvList[0].Aria_Account__r.name);
	        		}
	        	}	
        	}*/
		}
		
	public Map<String,String>transwithdate = new Map<String,String>();
	public Map<String,String> parsetrans(String strbody){
			String error = '0';
            boolean flag = false;
            
    		JSONParser parser = JSON.createParser(strbody);
            while (parser.nextToken() != null) {
                if(parser.getCurrentName()=='error_code'){
                    error = parser.getText();
                    flag=true; 
                }
                if(flag && error=='0'){ 
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while (parser.nextToken() != null) {
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                transdate parsetran;
                                parsetran = (transdate)parser.readValueAs(transdate.class);
                                transwithdate.put(parsetran.type_specific_id,parsetran.transaction_date);

                             }
                         }
                    }
                }
           }
           return transwithdate;   
	}
	
	public class transdate{
        public String transaction_date;
        public String type_specific_id;
       
        /*public transdate(){
        }
        
        public transdate(String transaction_date,String type_specific_id){
            this.transaction_date= transaction_date;
            this.type_specific_id= type_specific_id;
           
        }*/
    }
    
    
    
    
    public void parseorder(Map<String,String>mapInvNoToType,Set<String>setAriaAcc){
    	
       system.debug('parseorder===mapInvNoToType==='+mapInvNoToType);
       
       for(String Inv:mapInvNoToType.keySet()){
	       String error = '0';
	       boolean flag = false;
	       String comments = '';
	       JSONParser parser = JSON.createParser(mapInvNoToType.get(Inv));
	        while (parser.nextToken() != null) {
	                if(parser.getCurrentName()=='error_code'){
	                    error = parser.getText();
	                    flag=true; 
	                }
	                if(flag && error=='0'){ 
	                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
	                        while (parser.nextToken() != null) {
	                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
	                                OrderItem parseorder;
	                                parseorder = (OrderItem)parser.readValueAs(OrderItem.class);
	                                if(parseorder.client_sku != '2800004')
	                                {
		                                String strtype='';
		                                
	                                	if(parseorder.client_sku =='2800001'){
		                                    strtype='Blockbuster Leje';
		                                    comments=parseorder.line_comments;
		                                     mapInvToType.put(Inv,strtype);
		                                     mapInvToTitle.put(Inv,comments);
		                                    
		                                }
		                                if(parseorder.client_sku =='2800002'){
		                                    strtype='Blockbuster Klippekort';
		                                    comments=parseorder.line_comments;
		                                    mapInvToType.put(Inv,strtype);
		                                    mapInvToTitle.put(Inv,comments);
		                                    
		                                }
		                                if(parseorder.client_sku =='2800003'){
		                                    strtype='Blockbuster Køb';
		                                    comments=parseorder.line_comments;
		                                    mapInvToType.put(Inv,strtype);
		                                    mapInvToTitle.put(Inv,comments);
		                                    
		                                }
	                                }
	                          }
	                     }
	                 }
	             }
	         }    
	    }
	    
	    
	    system.debug('mapInvToType===='+mapInvToType);
	    system.debug('mapInvToTitle===='+mapInvToTitle);
	    system.debug('setAriaAcc===='+setAriaAcc);
	    getNewdate(setAriaAcc);
	    setdateTypeTitle(setAriaAcc);
    }
	    
	    
	    public class OrderItem{
        public String client_sku;
        public String line_comments;
       
        /*public OrderItem(){
        }
        
        public OrderItem(String client_sku,String line_comments){
            this.client_sku= client_sku;
            this.line_comments= line_comments;
           
        }*/
    }
    
    webservice static void getRefundDetails(String AccNo) 
   {
        /*BlockBusterRefundDetailsWrapper objBBRefundDetails;
        String respRefundDetails; 
        List<Account> lstAria = new List<Account>();
        lstAria = [SELECT Id,name,Betaler_Id__c FROM Account where id=:AccNo];
        HttpResponse hr = BlockBusterCallOut.RefundDetails(lstAria[0].Betaler_Id__c);
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
        }*/
        BlockBusterDateTypeTitle obj = new BlockBusterDateTypeTitle();
     	obj.RefundDetails(AccNo);
   }
   
   public void RefundDetails(String AccNo){
   	    BlockBusterRefundDetailsWrapper objBBRefundDetails;
        String respRefundDetails; 
        List<Account> lstAria = new List<Account>();
        lstAria = [SELECT Id,name,Betaler_Id__c FROM Account where id=:AccNo];
       if(!lstAria.isEmpty() && lstAria[0].Betaler_Id__c != null){//change for Carrie
        HttpResponse hr = BlockBusterCallOut.RefundDetails(lstAria[0].Betaler_Id__c);
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
   	}
   }
    
}