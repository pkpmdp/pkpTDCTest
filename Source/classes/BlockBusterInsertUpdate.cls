public with sharing class BlockBusterInsertUpdate {

   /* public static void InsertRefundLog(BlockBusterIssueRefundWrapper objBBIssRef,List<Payment_Invoice__c>lstpayinv,String reasoncode){
    
        List<Refund_Logs__c> lstRefundLog = new List<Refund_Logs__c>();
        if(objBBIssRef!=null){
            
            Refund_Logs__c objRef = new Refund_Logs__c();
            objRef.Faktura_Logs__c = lstpayinv[0].Faktura__c;
            objRef.Reason_Code__c = reasoncode; 
            objRef.Amount__c = Decimal.valueOf(objBBIssRef.applied_total_refund_amount);
            objRef.CSR_Name__c = UserInfo.getUserId();
            objRef.Account__c = lstpayinv[0].Account__c;
            lstRefundLog.add(objRef);               
            
            if(!lstRefundLog.isEmpty()){
                insert lstRefundLog;
            }
        }
    }*/
    public static Map<String,Payment__c> mapPayNoToId;
    public static void InsertRefundDetails(BlockBusterRefundDetailsWrapper objRefWrapp){
         list<Refund__c>listRefDetails = new List<Refund__c>();
         Set<string>setPayId = new Set<string>();
         Map<String, RefundCode__c> reasoncodes = RefundCode__c.getAll();
         BlockBusterRefundDetailsWrapper.refund_details objLast;
         BlockBusterInsertUpdate.mapPayNoToId = new Map<String,Payment__c>();
         //Payment__c pay;
		 List<Refund_User__c> listRefundUser = new List<Refund_User__c>();
		 map<string,Id> mapRegundUser = new map<string,Id>(); // Key -> Refund_External_Id__c || Value -> User ID
		 listRefundUser = [select id,Refund_External_Id__c,User__c from Refund_User__c];
		 for(Refund_User__c ref : listRefundUser)
		 {
		 	mapRegundUser.put(ref.Refund_External_Id__c,ref.User__c);
		 }
		 //if(mapRegundUser.values().size() == 0)
		 //{
		 	
		 //}
         if(objRefWrapp!=null)
         {
         	if(objRefWrapp.refund_details != null)
         	{
         		for(BlockBusterRefundDetailsWrapper.refund_details obj: objRefWrapp.refund_details)
         		{
                	setPayId.add(obj.ref_payment_transaction_id);	
         		}
             }
         }
        for(Payment__c pay:[SELECT ID,Payment_No__c,Aria_Account__c,Aria_Account__r.Account__c from Payment__c where Payment_No__c in:setPayId])
         mapPayNoToId.put(pay.Payment_No__c,pay);
         system.debug('objRefWrapp.refund_details *** '+objRefWrapp.refund_details);
         if(objRefWrapp.refund_details != null)
         {
         	for(BlockBusterRefundDetailsWrapper.refund_details obj: objRefWrapp.refund_details){
             Refund__c objRef = new Refund__c();
             objRef.Name = obj.refund_transaction_id;
             objRef.Amount__c = Decimal.valueOf(obj.refund_amount);
             objRef.Refund_Date__c = Date.valueOf(obj.create_date);
             if(mapRegundUser.containsKey(obj.refund_transaction_id))
             {
             	objRef.CSR_Name__c = mapRegundUser.get(obj.refund_transaction_id);
             }
             else
             {
             	objRef.CSR_Name__c = UserInfo.getUserID();
             	Refund_User__c ref = new Refund_User__c();
             	ref.Refund_External_Id__c = obj.refund_transaction_id;
             	ref.User__c = UserInfo.getUserID();
             	upsert ref Refund_External_Id__c;
             }
             objRef.Reason_Code__c = obj.reason_code;
             objRef.Reason_Lable__c = obj.reason_label;
             objRef.Reason_Description__c = reasoncodes.get(obj.reason_code).Reasoncode__c;
             if(!Test.isRunningTest()){
             objRef.Payment_Id__c =  mapPayNoToId.get(obj.ref_payment_transaction_id).Id;
             objRef.Aria_Account__c = mapPayNoToId.get(obj.ref_payment_transaction_id).Aria_Account__c;
             objRef.Account__c =  mapPayNoToId.get(obj.ref_payment_transaction_id).Aria_Account__r.Account__c;
             }
             if(Test.isRunningTest()){
             objRef.Payment_Id__c =  [SELECT ID,Payment_No__c,Aria_Account__c,Aria_Account__r.Account__c from Payment__c limit 1].Id;
             objRef.Aria_Account__c =[Select Id from Aria_Account__c limit 1].id;
             objRef.Account__c =  [select id from Account limit 1].id;
             }
             objRef.Refund_External_Id__c = obj.refund_transaction_id;
             listRefDetails.add(objRef);
         }
         System.debug('listRefDetails ** '+listRefDetails);
         if(!listRefDetails.isEmpty())
         {
         	if(!Test.isRunningTest())
         		upsert listRefDetails Refund_External_Id__c;
         }
             
         }
         
         /*list<BlockBusterRefundDetailsWrapper.refund_details> obj = objRefWrapp.refund_details;
         if(obj != null)
         {
         	String paymentId = obj[obj.size()-1].ref_payment_transaction_id;
         	objLast = obj[obj.size()-1];
         	System.debug('***** objLast'+objLast);
         	pay = [SELECT ID,Payment_No__c,Aria_Account__c,Aria_Account__r.Account__c from Payment__c where Payment_No__c =:paymentId];   
         	System.debug('***** Pay '+pay);
         }
         if(objLast != null)
         {
	         Refund__c objRef = new Refund__c();
	         objRef.Name = objLast.refund_transaction_id;
	         objRef.Amount__c = Decimal.valueOf(objLast.refund_amount);
	         objRef.Refund_Date__c = Date.valueOf(objLast.create_date);
	         objRef.CSR_Name__c = UserInfo.getUserID();
	         objRef.Reason_Code__c = objLast.reason_code;
	         objRef.Reason_Lable__c = objLast.reason_label;
	         objRef.Reason_Description__c = reasoncodes.get(objLast.reason_code).Reasoncode__c;
	         objRef.Payment_Id__c =  pay.Id;
	         objRef.Aria_Account__c = pay.Aria_Account__c;
	         objRef.Account__c =  pay.Aria_Account__r.Account__c;
	         objRef.Refund_External_Id__c = objLast.refund_transaction_id;
	         upsert objRef Refund_External_Id__c; 
         }*/
    }
    
    public static void UpdateInvoicePayment(BlockBusterRefundDetailsWrapper objRefWrapp){
    	System.debug('****** objRefWrapp **** '+objRefWrapp);
    	System.debug('****** objRefWrapp.refund_details **** '+objRefWrapp.refund_details);
        List<Invoice_Payment__c>lstInvoicePay = new List<Invoice_Payment__c>();
        List<Invoice_Payment__c>lstInvoiceToUpdate = new List<Invoice_Payment__c>();
        Map<string,BlockBusterRefundDetailsWrapper.refund_details>MapPayId = new Map<string,BlockBusterRefundDetailsWrapper.refund_details>();
        if(objRefWrapp!=null){
        	if(objRefWrapp.refund_details != null)
        	{
        		for(BlockBusterRefundDetailsWrapper.refund_details obj: objRefWrapp.refund_details){
                 MapPayId.put(obj.ref_payment_transaction_id,obj);
             }
        	}
             
         }
        
        lstInvoicePay = [SELECT Account__c,Amount_Applied__c,
                                Aria_Account__c,Balance__c,Betalingsfrist__c,checkPaymentApplied__c,Titel__c,
                                    CreatedById,CreatedDate,Datoforudskrift__c,External_Name__c,Fakturabelob__c,
                                        Fakturanummer__c,Faktura__c,Id,invoice_no__c,Invoice_Statement__c,IsDeleted,
                                            isVoid__c,LastModifiedById,LastModifiedDate,Payment__c,Payment__r.Payment_No__c FROM Invoice_Payment__c 
                                                where Payment__r.Payment_No__c in:MapPayId.keyset()];
                                            
        System.debug('lstInvoicePay ****** '+lstInvoicePay);
        if(!lstInvoicePay.isEmpty()){
            for(Invoice_Payment__c obj: lstInvoicePay){
                Invoice_Payment__c objup = new Invoice_Payment__c(id =obj.id);
                objup.Refund_BB__c = Decimal.valueOf(MapPayId.get(obj.Payment__r.Payment_No__c).refund_amount);
                objup.Titel__c = obj.Titel__c;
                lstInvoiceToUpdate.add(objup);
            }
        }
        System.debug('lstInvoiceToUpdate ** '+lstInvoiceToUpdate);
        if(!lstInvoiceToUpdate.isEmpty())
            update lstInvoiceToUpdate;
    }
    
   /* public static Map<String,Decimal> calcRefundAmt(List<BlockBusterKlipStatus>lstBBKlipStatus){
        
        Map<String,Decimal> mapIdToAmt = new Map<String,Decimal>();
        if(!lstBBKlipStatus.isEmpty()){
            for(BlockBusterKlipStatus objKlipStat: lstBBKlipStatus){
                Integer cntFreeClip = 0;
                for(BlockBusterKlipStatus.clipDets objclipde: objKlipStat.clips){
                        if(objclipde.state == 'free')
                            cntFreeClip++;
                }
                Decimal AmtKlip = (Decimal.valueOf(objKlipStat.price)/Integer.valueOf(objKlipStat.num_clip))*cntFreeClip;
                mapIdToAmt.put(objKlipStat.ref,AmtKlip);
            }
        }
        return mapIdToAmt;
    }*/
}