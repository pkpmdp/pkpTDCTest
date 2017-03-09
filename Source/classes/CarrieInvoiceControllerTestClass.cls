/**
* This class contains unit tests for validating the behavior of Apex classes and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
*
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*/
 
/***********************************************************************************
************************************************************************************

* @class: CarrieInvoiceControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieInvoiceController ,CarrieInvoiceWrapper, CarrieParseInvoiceInfo.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieInvoiceControllerTestClass {
    
    /**
    * @description: This method is used to test general methods of CarrieInvoiceStatementController
    */
    static testMethod void testInvoiceDetails() {
        //Decimal ariaAccountNo = 3666081;
        Id customerId;
        User user = CarrieTestUtil.insertUser();
        Aria_Account__c customer  = CarrieTestUtil.insertAccount(); 
        customerId = customer.Id   ;
        
        system.runAs(user){
            Test.startTest(); 
            CarrieInvoiceController invoice = new CarrieInvoiceController (customer);
            String response ='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":6,"invoice_details":[{"invoice_no":21191591,"acct_no":3666081,"debit":10000,"credit":10000,"bill_date":"2012-07-22 19:02:07","due_date":"2012-08-21 19:02:07","paid_date":"2012-07-26 19:09:38","notify_date":"2012-07-22 19:02:07","from_date":"2012-07-22 19:02:06","to_date":"2012-07-22 19:02:06","currency_cd":"dkk","balance_forward":1700,"total_due":1700,"comments":null,"additional_comments":"Comments from order no. 2156079: ","last_updated":"2012-07-22 19:02:07","transaction_type":null,"user_id":"jonas","aria_event_no":29969187,"aria_statement_no":162850317,"acct_statement_seq_str":"162850317","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":10000,"comments":null,"plan_no":null,"plan_name":null,"service_no":0,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":10,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-07-22 19:02:06","end_date":"2012-07-22 19:02:06"},{"client_no":4942283,"line_item_no":2,"amount":-800,"comments":null,"plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":3,"amount":-800,"comments":null,"plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":4,"amount":-320,"comments":"Account Service Credit No. 407177","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":5,"amount":-80,"comments":"Account Service Credit No. 407179","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":6,"amount":-80,"comments":"Account Service Credit No. 407291","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":7,"amount":-20,"comments":"Account Service Credit No. 407293","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":8,"amount":-80,"comments":"Account Service Credit No. 407783","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null},{"client_no":4942283,"line_item_no":9,"amount":-20,"comments":"Account Service Credit No. 407785","plan_no":null,"plan_name":null,"service_no":0,"service_name":"Account Credit","ledger_code":"Recurring Flat Fees COA Code","coa_id":1000,"coa_description":"Recurring Flat Fees COA Code","usage_units":null,"usage_rate":null,"usage_type_no":null,"start_date":null,"end_date":null}]},{"invoice_no":20872669,"acct_no":3666081,"debit":3500,"credit":3500,"bill_date":"2012-07-07 17:47:01","due_date":"2012-08-06 17:47:01","paid_date":"2012-07-26 18:56:07","notify_date":"2012-07-07 17:47:01","from_date":"2012-07-07 17:47:01","to_date":"2012-07-07 17:47:01","currency_cd":"dkk","balance_forward":1000,"total_due":1000,"comments":null,"additional_comments":"Comments from order no. 2145865: ","last_updated":"2012-07-07 17:47:01","transaction_type":null,"user_id":"jonas","aria_event_no":29284047,"aria_statement_no":160521654,"acct_statement_seq_str":"160521654","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":2000,"comments":"Activation Fee (order # 2145865)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":2,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-07-07 17:47:01","end_date":"2012-07-07 17:47:01"},{"client_no":4942283,"line_item_no":2,"amount":1500,"comments":"YouSee Boks (order # 2145865)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":3,"usage_rate":500,"usage_type_no":null,"start_date":"2012-07-07 17:47:01","end_date":"2012-07-07 17:47:01"}]},{"invoice_no":20873857,"acct_no":3666081,"debit":4000,"credit":4000,"bill_date":"2012-07-07 17:52:53","due_date":"2012-08-06 17:52:53","paid_date":"2012-07-07 17:54:14","notify_date":"2012-07-07 17:52:53","from_date":"2012-07-07 17:52:53","to_date":"2012-07-07 17:52:53","currency_cd":"dkk","balance_forward":3000,"total_due":3000,"comments":null,"additional_comments":"Comments from order no. 2145869: ","last_updated":"2012-07-07 17:52:53","transaction_type":null,"user_id":"jonas","aria_event_no":29285399,"aria_statement_no":160521696,"acct_statement_seq_str":"160521696","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":4000,"comments":"Activation Fee (order # 2145869)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":4,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-07-07 17:52:53","end_date":"2012-07-07 17:52:53"}]},{"invoice_no":20882287,"acct_no":3666081,"debit":0,"credit":0,"bill_date":"2012-07-08 01:33:02","due_date":"2012-08-07 01:33:02","paid_date":"2012-07-08 01:33:03","notify_date":"2012-07-08 01:40:04","from_date":"2012-07-07 00:00:00","to_date":"2012-10-06 00:00:00","currency_cd":"dkk","balance_forward":3000,"total_due":3000,"comments":"4942283","additional_comments":null,"last_updated":"2012-07-08 01:33:02","transaction_type":null,"user_id":"jonas","aria_event_no":29303211,"aria_statement_no":160605150,"acct_statement_seq_str":"160605150","second_acct_statement_seq_str":null,"invoice_line":null},{"invoice_no":20872639,"acct_no":3666081,"debit":2000,"credit":2000,"bill_date":"2012-07-07 17:16:09","due_date":"2012-08-06 17:16:09","paid_date":"2012-07-07 17:21:06","notify_date":"2012-07-07 17:16:09","from_date":"2012-07-07 17:16:09","to_date":"2012-07-07 17:16:09","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":null,"additional_comments":"Comments from order no. 2145843: ","last_updated":"2012-07-07 17:16:09","transaction_type":null,"user_id":"jonas","aria_event_no":29283975,"aria_statement_no":160521472,"acct_statement_seq_str":"160521472","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":2000,"comments":"Activation Fee (order # 2145843)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":2,"usage_rate":1000,"usage_type_no":12345,"start_date":"2012-07-07 17:16:09","end_date":"2012-07-07 17:16:09"}]},{"invoice_no":20872645,"acct_no":3666081,"debit":3000,"credit":3000,"bill_date":"2012-07-07 17:21:31","due_date":"2012-08-06 17:21:31","paid_date":"2012-07-21 23:51:37","notify_date":"2012-07-07 17:21:31","from_date":"2012-07-07 17:21:31","to_date":"2012-07-07 17:21:31","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":null,"additional_comments":"Comments from order no. 2145847: ","last_updated":"2012-07-07 17:21:31","transaction_type":null,"user_id":"jonas","aria_event_no":29283989,"aria_statement_no":160521514,"acct_statement_seq_str":"160521514","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":3000,"comments":"Activation Fee (order # 2145847)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":3,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-07-07 17:21:31","end_date":"2012-07-07 17:21:31"}]}]}';
	        invoice.getInvoiceDetails(response);
            invoice.getLatestInvoice();
            Test.stopTest();
        }
    }
    
    /**
    * @description: This method is used to test general methods of CarrieInvoiceWrapper
    */
    static testMethod void testInvoiceWrapper() {
        User user = CarrieTestUtil.insertUser();
        Aria_Account__c customer  = CarrieTestUtil.insertAccount(); 
        
        system.runAs(user){
            Test.startTest(); 
            Faktura__c faktura = new Faktura__c();
            faktura.Aria_Account__c  = customer.Id ;
            faktura.Name = '21191591';
            insert faktura;
            
            List<Faktura__c> fakturaList = new List<Faktura__c>();
            fakturaList.add(faktura);
            List<Faktura__c> invoiceList = new List<Faktura__c>();
            invoiceList.add(faktura);
            
            List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
            Invoice_Subscription__c subscription = new Invoice_Subscription__c();
            subscription.Name = '21191591-1';
            subscriptionList.add(subscription);
            
            List<Invoice_Usage__c> usageList = new List<Invoice_Usage__c>();
            Invoice_Usage__c usage = new Invoice_Usage__c();
            usage.Name = '21191591-2';
            usageList.add(usage);
            
            Map<string,string> insertedInvoice = new Map<string,string>();
            insertedInvoice.put('21191591','21191591');
            
            Map<string,List<Invoice_Subscription__c>> insertedSubscription = new Map<string,List<Invoice_Subscription__c>>();
            insertedSubscription.put('21191591-1',subscriptionList);
            
            Map<string,List<Invoice_Usage__c>> insertedUsgage = new Map<string,List<Invoice_Usage__c>>();
            insertedUsgage.put('21191591-2',usageList);
            
            CarrieInvoiceWrapper invoiceWrapper = new CarrieInvoiceWrapper(fakturaList,invoiceList,insertedSubscription,insertedUsgage,subscriptionList,usageList);
            invoiceWrapper.getPreviousInvoiceList();
            invoiceWrapper.getUsageMap();
            invoiceWrapper.getSubscriptionMap();
            
            List<Faktura__c> nullFakturaList; 
            List<Faktura__c> nullInvoiceList;
            List<Invoice_Subscription__c> nullSubscriptionList ;
            List<Invoice_Usage__c> nullUsageList;
            Map<string,string> nullInsertedInvoice ;
            Map<string,List<Invoice_Subscription__c>> nullInsertedSubscription;
            Map<string,List<Invoice_Usage__c>> nullInsertedUsage;
            
            CarrieInvoiceWrapper nullInvoiceWrapprer =new CarrieInvoiceWrapper(nullFakturaList,nullInvoiceList,nullInsertedSubscription,nullInsertedUsage,nullSubscriptionList,nullUsageList);
            nullInvoiceWrapprer.getPreviousInvoiceList();
            nullInvoiceWrapprer.getUsageMap();
            nullInvoiceWrapprer.getSubscriptionMap();
            Test.stopTest();
    
        }
    }
    
    /**
    * @description: This method is used to test general methods of CarrieParseInvoiceInfo
    */
    static testMethod void testParseInvoice() {
        User user = CarrieTestUtil.insertUser();
        
        system.runAs(user){
            Test.startTest(); 
            Long invoice_no=21191591;
            Long acct_no=3666081;
            Double debit=10000;
            Double credit=100000;
            String bill_date='2012-07-22 19:02:07';
            String due_date='2012-07-22 19:02:07';
            String paid_date='2012-07-22 19:02:07';
            String notify_date='2012-07-22 19:02:07';
            String from_date='2012-07-22 19:02:07';
            String to_date='2012-07-22 19:02:07';
            String currency_cd='dkk';
            Double balance_forward=1700;
            Double total_due=1700;
            String comments=null;
            String additional_comments='Comments from order no.';
            String last_updated='2012-07-22 19:02:07';
            String transaction_type=null;
            String user_id='jonas';
            Long aria_event_no=29969187;
            Long aria_statement_no=162850317;
            String acct_statement_seq_str='162850317';
            String second_acct_statement_seq_str=null;
            List<CarrieParseInvoiceInfo.InvoiceLineItem> invoice_line= new List<CarrieParseInvoiceInfo.InvoiceLineItem>();
            
            CarrieParseInvoiceInfo.InvoiceLineItem lineItem = new CarrieParseInvoiceInfo.InvoiceLineItem();
            Long client_no=4942283;
            Long line_item_no=1;
            Double amount=10000;
            comments='temp';
            Long plan_no=2;
            String plan_name='temp';
            Long service_no=10131849;
            String service_name='ActrivationFee';
            String ledger_code='1001';
            Long coa_id=10090603;
            String coa_description='1001';
            Double usage_units=10;
            Double usage_rate=1000;
            Long usage_type_no=2;
            String start_date='2012-07-22 19:02:07';
            String end_date='2012-07-22 19:02:07';
            String order_no = '123456';
            lineItem.client_no=client_no;
            lineItem.line_item_no=line_item_no;
            lineItem.amount=amount;
            lineItem.comments=comments;
            lineItem.plan_no=plan_no;
            lineItem.plan_name=plan_name;
            lineItem.service_no=service_no;
            lineItem.service_name=service_name;
            lineItem.ledger_code=ledger_code;
            lineItem.coa_id=coa_id;
            lineItem.coa_description=coa_description;
            lineItem.usage_units=usage_units;
            lineItem.usage_rate=usage_rate;
            lineItem.usage_type_no=usage_type_no;
            lineItem.start_date=start_date;
            lineItem.end_date=end_date;
            invoice_line.add(lineItem);
            
            List<CarrieParseInvoiceInfo.InvoiceLineTax> invoice_line_tax= new List<CarrieParseInvoiceInfo.InvoiceLineTax>();
            CarrieParseInvoiceInfo.InvoiceLineTax lineTax = new CarrieParseInvoiceInfo.InvoiceLineTax();
            Long tax_id=123;
            client_no=123;
            amount=1000;
            Double before_credit_amount=100;
            String jurisdiction='Temp';
            String description='Temop';
            Long is_excluded=1; 
            lineTax.tax_id=tax_id;
            lineTax.client_no=client_no;
            lineTax.amount=amount;
            lineTax.before_credit_amount=before_credit_amount;
            lineTax.jurisdiction=jurisdiction;
            lineTax.description=description;
            lineTax.is_excluded=is_excluded;
            invoice_line_tax.add(lineTax);
            
            CarrieParseInvoiceInfo parseInvoice =new CarrieParseInvoiceInfo( invoice_no,  acct_no,  debit,  credit,  bill_date,  due_date,  paid_date,  notify_date,  from_date,  to_date,  currency_cd,  balance_forward,  total_due,  comments,  additional_comments,  last_updated,  transaction_type,  user_id,  aria_event_no,  aria_statement_no,  acct_statement_seq_str,  second_acct_statement_seq_str, invoice_line);
            CarrieParseInvoiceInfo.InvoiceLineItem parseInvoiceLineItem = new CarrieParseInvoiceInfo.InvoiceLineItem(client_no,line_item_no, amount, comments,  plan_no,plan_name, service_no,  service_name, ledger_code,  coa_id, coa_description,  usage_units, usage_rate,usage_type_no,start_date, end_date, order_no, invoice_line_tax);       
            CarrieParseInvoiceInfo.InvoiceLineTax parseInvoiceLineTax=new  CarrieParseInvoiceInfo.InvoiceLineTax( tax_id,  client_no, amount,  before_credit_amount, jurisdiction,  description, is_excluded);      
            Test.stopTest();
        }   
    }
}