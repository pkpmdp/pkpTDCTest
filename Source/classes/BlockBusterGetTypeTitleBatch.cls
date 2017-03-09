global class BlockBusterGetTypeTitleBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{ 

    private Aria_API_Configuration__c config { get; private set; }  
    public Map<String,String> MapInvoiceNoToTitle = new Map<String,String>();
    public Set<String>setSingleAriaAcc = new Set<String>();
    public String Query;
    public final Set<String>setAriaAccNumber;
    public final Boolean isUnappbatch;
    
    public BlockBusterGetTypeTitleBatch(Set<String>setId,Boolean isUnappliedbatch){  
        //This string will determine the scheduled class which called the batch class. 
        //Required to construct different query strings for differnt schedulars.
        //scheduledClass = batchClass;
        setAriaAccNumber = setId;  
        isUnappbatch = isUnappliedbatch;
        
        if(!isUnappbatch)
        	Query = 'Select Id,Order_Number__c,Invoice_Number__c,Service_Name__c,Faktura__c,Faktura__r.Fakturanummer__c,Faktura__r.Aria_Account__c ,Faktura__r.Aria_Account__r.Name,Faktura__r.Aria_Account__r.Account__c,Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c From Invoice_Subscription__c where Faktura__r.Aria_Account__r.Name in: setAriaAccNumber and Order_Number__c!=null and Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c =\'Blockbuster Customer Account\' and (NOT Service_Name__c LIKE \'%koda%\') order by Order_Number__c ,Name asc';
        else if(isUnappbatch) 
			Query = 'Select Id,Order_Number__c,Invoice_Number__c,Service_Name__c,Faktura__c,Faktura__r.Fakturanummer__c,Faktura__r.Aria_Account__c ,Faktura__r.Aria_Account__r.Name,Faktura__r.Aria_Account__r.Account__c,Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c From Invoice_Subscription__c where Faktura__r.Aria_Account__r.Name !=null and Order_Number__c!=null and Faktura__r.Aria_Account__r.Account__r.RecordTypeName__c =\'Blockbuster Customer Account\' and (NOT Service_Name__c LIKE \'%koda%\') order by Order_Number__c ,Name asc';     
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(Query); 
    }   
     
    global void execute(Database.BatchableContext BC, List<sObject> InvSubs){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        List<Invoice_Subscription__c> listInvSubs = new List<Invoice_Subscription__c>();
        listInvSubs = (List<Invoice_Subscription__c>)InvSubs;
        system.debug('===listInvSubs=='+listInvSubs);
        String orderResponseBody;      
        HttpResponse orderResponse;  
        orderResponse = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c,'get_order_items',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'order_no' => listInvSubs[0].Order_Number__c});
        //system.debug('billing response in batch ' +orderResponse.getBody());
        if(orderResponse!=null){
        	orderResponseBody = orderResponse.getBody(); 
        	MapInvoiceNoToTitle.put(listInvSubs[0].Faktura__r.Fakturanummer__c,orderResponseBody);
        	setSingleAriaAcc.add(listInvSubs[0].Faktura__r.Aria_Account__r.Name);
        	BlockBusterDateTypeTitle BBDateTypeTitle = new BlockBusterDateTypeTitle();
            BBDateTypeTitle.parseorder(MapInvoiceNoToTitle,setSingleAriaAcc);
    	}
    }
    
    global void finish(Database.BatchableContext BC){
    	system.debug('MapInvoiceNoToTitle==in finish======='+MapInvoiceNoToTitle);
        //BlockBusterDateTypeTitle BBDateTypeTitle = new BlockBusterDateTypeTitle();
        //BBDateTypeTitle.parseorder(MapInvoiceNoToTitle,setAriaAccNumber);
        
        /*CarrieBatchUtil insertRec = new CarrieBatchUtil();
        insertRec.sendEmail(BC.getJobId(),false);*/
        
        if(!Test.isRunningTest() && setAriaAccNumber.size()>1){
        	
            CarrieFinalUpdateBatch  carrie = new CarrieFinalUpdateBatch();
            Database.executeBatch(carrie,1500);
        }
        
    }
  
}