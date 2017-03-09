/***********************************************************************************
************************************************************************************

* @class: CarrieInvoiceController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get invoice related information for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarrieInvoiceController {
	private Aria_API_Configuration__c config { get; private set; } //CARRIE-986
    public Id customerId;
    public Decimal AriaAccountNo;
    public Id AriaAccountId;   
    //private static String UserName = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_UserName').Value__c; //CARRIE-986
    //private static String Password = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_Password').Value__c; //CARRIE-986
    public List<Faktura__c> latestInvoice {get;set;}
    
    public CarrieInvoiceController (Aria_Account__c customer) {
        customerId = customer.Account__c;
        AriaAccountId = customer.Id;
        AriaAccountNo = customer.Aria_Account_No__c; 
    }
   
    /**
    * @description: This method makes API call to Aria System for getting invoice related information.
    * @return: Response From Aria.
    */
    public String getAriaResponse(){
        getLatestInvoice();
        config = CarrieCommonUtil.validateAPIConfiguration(config); //CARRIE-986
        HttpResponse response;
        //Carrie Support-4305 and Support-4282
       // if(latestInvoice!=null && latestInvoice.size()>0){
            //response = AriaWebServices.makeCallForJson('get_invoice_details',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND invoice_no>'+latestInvoice[0].Name}); //CARRIE-986
        //    response = AriaWebServices.makeCallForJson('get_invoice_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo+' AND invoice_no>'+latestInvoice[0].Name});
        //    response = AriaWebServices.makeCallForJson('get_invoice_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no=27076804 AND invoice_no>'+latestInvoice[0].Name});
       // }else{
            //response = AriaWebServices.makeCallForJson('get_invoice_details',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo});  //CARRIE-986
            response = AriaWebServices.makeCallForJson('get_invoice_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountNo,'limit' => '10000'}); 
            //response = AriaWebServices.makeCallForJson('get_invoice_information',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no=26313679'}); 
      //  }   
        if(response!=null){ // Changes done for SUPPORT-2959
        	system.debug('Response from Invoice Controller: '+response.getBody());
        	return response.getBody();
        }
        else{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Refresh_Error));
        	return '';
        }
        
    }
    
    /**
    * @description: This method  is use to parse the json response from Aria.
    * @param: Response json response from Aria.
    * @return: CarrieInvoiceWrapper.
    */
    public  CarrieInvoiceWrapper getInvoiceDetails(String data) { 
        try{
            Map<string,string> invoiceMap = new Map<string,string>();
            Map<string,string> dummyInvoiceMap = new Map<string,string>();
            List<Faktura__c> invoicelist = new List<Faktura__c>();
            List<Invoice_Subscription__c> invoiceSubscriptionList = new List<Invoice_Subscription__c>();
            List<Invoice_Usage__c> invoiceUsageList = new List<Invoice_Usage__c>();
            List<Applied_Credit__c> appliedCreditList = new List<Applied_Credit__c>();
            Faktura__c invoice;
            String error = '0';
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
                                CarrieParseInvoiceInfo parseInvoice;
                                parseInvoice = (CarrieParseInvoiceInfo)parser.readValueAs(CarrieParseInvoiceInfo.class);
                                invoice = new Faktura__c();
                                invoice.Customer__c = customerId;
                                if(parseInvoice.debit>0){

                                system.debug('latest AriaAccountId: '+AriaAccountId);
                                invoice.Aria_Account__c = AriaAccountId;
                                invoice.Fakturanummer__c = ''+parseInvoice.invoice_no;
                                invoice.Name = ''+parseInvoice.invoice_no;
                                invoice.Aria_Event_No__c=''+parseInvoice.aria_event_no;
                                invoice.Datoforudskrift__c = date.valueOf(parseInvoice.bill_date);
                              //  invoice.Invoice_date__c = datetime.valueOf(parseInvoice.bill_date);
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
                                            //System.debug('Service No is ' + serviceNo);
                                            if(serviceNo==0 || comments.contains('Account Service Credit')){
                                                Integer service_No = 0;
                                                if (invoiceLineItem.comments != null) {
                                                   // comments = invoiceLineItem.comments;
                                                    comments = comments.replace('"','');
                                                    String substringComments = comments.substring(comments.indexOf('No. ')+4, comments.length());
                                                    service_No = Integer.valueof(substringComments.trim());                                        
                                                }                        
                                                Applied_Credit__c appliedCredit= new Applied_Credit__c();
                                                appliedCredit.Name = String.valueOf(service_No);
                                                appliedCredit.External_Name__c = appliedCredit.Name+'_'+invoice.Fakturanummer__c;
                                                appliedCredit.Date__c= date.valueOf(parseInvoice.bill_date);
                                                appliedCredit.credit_type__c= 'Service';
                                                appliedCredit.Amount__c = -amount;
                                                appliedCredit.Credit_Bel_b__c =null;
                                                appliedCredit.Faktura__r = fakturaLink;
                                                appliedCredit.Account__c = customerId;
                                                appliedCredit.Aria_Account__c = AriaAccountId;
                                                appliedCredit.Applied_Against__c = 'Invoice';    //carrie-1010                                    
                                                appliedCreditList.add(appliedCredit);
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
                                invoiceMap.put(invoice.Name,invoice.Name);
                                parser.skipChildren();
                                }
                                else{
                                String dummyInvoice = ''+parseInvoice.invoice_no;
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
            system.debug('latest Invoice: '+invoicelist);
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
    * @description: This method  is used to get the latest Invoice number .
    */
    public void getLatestInvoice(){
        latestInvoice = [Select f.Id,f.Name,Fakturanummer__c From Faktura__c f where f.Aria_Account__r.Aria_Account_No__c  =: AriaAccountNo and Aria_Account__c =:AriaAccountId and (NOT Name like '00000') order by Fakturanummer__c desc limit 1];
    }
}