@isTest (SeeAllData=true) 
private class CarrieBillingBatchControllerTest{
    static Account account = new Account(); 
    static Aria_Account__c customer = new Aria_Account__c();
    
    private static void insertData(){
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        
        customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = 'ACTIVE';
        insert customer;
        
        Payment__c payment1 = new Payment__c();
        payment1.hasInvoice__c = '';
        payment1.Payment_Type__c = 'Check';
        payment1.Appplied_Amount__c = 1000.0;
        payment1.Aria_Account__c = customer.Id;
        payment1.Aria_Event_No__c='38309600';
        payment1.Payment_No__c='38309600';
        payment1.Name='38309600';
        payment1.isVoid__c='';
        payment1.CommentsLong__c='';
        payment1.Customer__c=account.Id;
        payment1.transaction_source_id__c = '8260266';
        payment1.Credit_Reason__c = '';
        payment1.Comments__c = '';
        payment1.Amount__c = 1000.0;
        payment1.Payment_Date__c = system.today();
        insert payment1;
        
        Payment__c payment2 = new Payment__c();
        payment2.hasInvoice__c = '';
        payment2.Payment_Type__c = 'Check'; 
        payment2.Appplied_Amount__c = 1000.0;
        payment2.Aria_Account__c = customer.Id;
        payment2.Aria_Event_No__c='38309687';
        payment2.Payment_No__c='38309687';
        payment2.Name='38309687';
        payment2.isVoid__c='';
        payment2.CommentsLong__c='';
        payment2.Customer__c=account.Id;
        payment2.transaction_source_id__c='8263266';
        payment2.Credit_Reason__c='';
        payment2.Comments__c='';
        payment2.Amount__c=1000.0;
        payment2.Payment_Date__c = system.today();
        insert payment2;
        
         Payment__c payment3= new Payment__c();
        payment3.hasInvoice__c = '';
        payment3.Payment_Type__c = 'Electronic Payment'; 
        payment3.Appplied_Amount__c = 1000.0;
        payment3.Aria_Account__c = customer.Id;
        payment3.Aria_Event_No__c='38309689';
        payment3.Payment_No__c='38309689';
        payment3.Name='38309689';
        payment3.isVoid__c='Voided';
        payment3.CommentsLong__c='';
        payment3.Customer__c=account.Id;
        payment3.transaction_source_id__c='6543217';
        payment3.Credit_Reason__c='';
        payment3.Comments__c='';
        payment3.Amount__c=1000.0;
        payment3.Payment_Date__c = system.today();
        insert payment3;
        
        
        
        Transaction__c transaction9 = new Transaction__c();
        transaction9.Name='38309698';
        transaction9.Aria_Account__c=customer.Id;
        transaction9.Customer__c=account.Id;
        transaction9.Credit_Amt__c=1000.0;
        transaction9.Posting_Date__c=system.today();
        transaction9.Description__c='Voided Electronic Payment#6543217';
        transaction9.Transaction_Source_ID__c='6543217';
        transaction9.Transaction_Type__c=-3;
        transaction9.Transaction_no__c='38309698';
        
        Transaction__c transaction1 = new Transaction__c();
        transaction1.Name='38309600';
        transaction1.Aria_Account__c=customer.Id;
        transaction1.Customer__c=account.Id;
        transaction1.Credit_Amt__c=1000.0;
        transaction1.Posting_Date__c=system.today();
        transaction1.Description__c='Credit #8263266';
        transaction1.Transaction_Source_ID__c='8260266';
        transaction1.Transaction_Type__c=2;
        transaction1.Transaction_no__c='38309600';
        
        Transaction__c transaction2 = new Transaction__c();
        transaction2.Name='38309687';
        transaction2.Aria_Account__c=customer.Id;
        transaction2.Customer__c=account.Id;
        transaction2.Credit_Amt__c=1000.0;
        transaction2.Posting_Date__c=system.today();
        transaction2.Description__c='Check #8263266';
        transaction2.Transaction_Source_ID__c='8263266';
        transaction2.Transaction_Type__c=2;
        transaction2.Transaction_no__c='38309687';
        
        Transaction__c transaction3 = new Transaction__c();
        transaction3.Name='38309686';
        transaction3.Aria_Account__c=customer.Id;
        transaction3.Customer__c=account.Id;
        transaction3.Credit_Amt__c=1000.0;
        transaction3.Posting_Date__c=system.today();
        transaction3.Description__c='Invoice #25453448';
        transaction3.Transaction_Source_ID__c='25453448';
        transaction3.Transaction_Type__c=1;
        transaction3.Transaction_no__c='38309686';
        transaction3.Charge_Amt__c=1000.0;
        
        
        
        Transaction__c transaction4 = new Transaction__c();
        transaction4.Name='35067081';
        transaction4.Aria_Account__c=customer.Id;
        transaction4.Customer__c=account.Id;
        transaction4.Credit_Amt__c=0.0;
        transaction4.Posting_Date__c=system.today();
        transaction4.Description__c='Invoice #23993077';
        transaction4.Transaction_Source_ID__c='23993077';
        transaction4.Transaction_Type__c=1;
        transaction4.Transaction_no__c='35067081';
        
        Transaction__c transaction5 = new Transaction__c();
        transaction5.Name='32417485';
        transaction5.Aria_Account__c=customer.Id;
        transaction5.Customer__c=account.Id;
        transaction5.Credit_Amt__c=0.0;
        transaction5.Posting_Date__c=system.today();
        transaction5.Description__c='Invoice #22664771';
        transaction5.Transaction_Source_ID__c='22664771';
        transaction5.Transaction_Type__c=1;
        transaction5.Transaction_no__c='32417485';
        
        Transaction__c transaction6 = new Transaction__c();
        transaction6.Name='28209543';
        transaction6.Aria_Account__c=customer.Id;
        transaction6.Customer__c=account.Id;
        transaction6.Credit_Amt__c=0.0;
        transaction6.Posting_Date__c=system.today();
        transaction6.Description__c='Invoice #20088399';
        transaction6.Transaction_Source_ID__c='20088399';
        transaction6.Transaction_Type__c=1;
        transaction6.Transaction_no__c='28209543';
        
        Transaction__c transaction7 = new Transaction__c();
        transaction7.Name='28209512';
        transaction7.Aria_Account__c=customer.Id;
        transaction7.Customer__c=account.Id;
        transaction7.Credit_Amt__c=0.0;
        transaction7.Posting_Date__c=system.today();
        transaction7.Description__c='voided Invoice #20088398';
        transaction7.Transaction_Source_ID__c='20088398';
        transaction7.Transaction_Type__c=-1;
        transaction7.Transaction_no__c='28209512';
        
       
        
        Transaction__c transaction8 = new Transaction__c();
        transaction8.Name='35067076';
        transaction8.Aria_Account__c=customer.Id;
        transaction8.Customer__c=account.Id;
        transaction8.Credit_Amt__c=0.0;
        transaction8.Posting_Date__c=system.today();
        transaction8.Description__c='Invoice #25453497';
        transaction8.Transaction_Source_ID__c='25453497';
        transaction8.Transaction_Type__c=-1;
        transaction8.Transaction_no__c='35067076';
        
        List<Transaction__c> transactionList = new List<Transaction__c>();
        transactionList.add(transaction1);
        transactionList.add(transaction2);
        transactionList.add(transaction3);
        transactionList.add(transaction4);
        transactionList.add(transaction5);
        transactionList.add(transaction6);
        transactionList.add(transaction7);
        transactionList.add(transaction8);

        transactionList.add(transaction9);


        insert transactionList;
        
        Faktura__c faktura = new Faktura__c();
        faktura.Name='25453448';
        faktura.Aria_Account__c=customer.Id;
        faktura.Customer__c=account.Id;
        faktura.Aria_Event_No__c='38309686';
     //   faktura.Titel__c;
        faktura.Datoforudskrift__c=system.today();
        faktura.Momspligtigt_bel_b__c=1000.0;
        faktura.Betalingsfrist__c=system.today();
        faktura.Fakturanummer__c='25453448';
        insert Faktura;
        
         Faktura__c faktura1 = new Faktura__c();
        faktura1.Name='20088398';
        faktura1.Aria_Account__c=customer.Id;
        faktura1.Customer__c=account.Id;
        faktura1.Aria_Event_No__c='38309686';
     //   faktura.Titel__c;
        faktura1.Datoforudskrift__c=system.today();
        faktura1.Momspligtigt_bel_b__c=1000.0;
        faktura1.Betalingsfrist__c=system.today();
        faktura1.Fakturanummer__c='20088398';
                insert faktura1;
        
        
        Faktura__c faktura2 = new Faktura__c();
        faktura2.Name='25453497';
        faktura2.Aria_Account__c=customer.Id;
        faktura2.Customer__c=account.Id;
        faktura2.Aria_Event_No__c='38309686';
        faktura2.isVoid__c='Voided';
        faktura2.Datoforudskrift__c=system.today();
        faktura2.Momspligtigt_bel_b__c=1000.0;
        faktura2.Betalingsfrist__c=system.today();
        faktura2.Fakturanummer__c='25453497';
         insert faktura2;

        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
        invoicePayment.Account__c=account.Id;
        invoicePayment.Aria_Account__c=customer.Id;
        invoicePayment.Transaction_No__c='38309687';
        invoicePayment.Amount_Applied__c=1000.0;
        invoicePayment.Payment_date_time__c=system.today();
        invoicePayment.statement_no__c=199711714;
        invoicePayment.External_Name__c='25453448_38309687';
        invoicePayment.invoice_no__c=25453448;
        invoicePayment.Faktura__c = faktura.Id;
        invoicePayment.Payment__c = payment2.Id;   
        insert invoicePayment;
        
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        
        subscription.Faktura_line_no__c = '25453448-1';
        subscription.Name = '25453448-1';
        subscription.Service_Name__c = 'Blockbuster Leje (order # 5977405)';
        subscription.Amount__c =  23.20;
        subscription.Faktura__c = faktura.id;
        subscription.Order_Number__c = '5977405';
        subscription.Invoice_Number__c = '25453448';
        subscriptionList.add(subscription);
        
        
        Invoice_Subscription__c subscription1 = new Invoice_Subscription__c();
        subscription1.Faktura_line_no__c = '25453448-2';
        subscription1.Name = '25453448-2';
        subscription1.Service_Name__c = 'Value Added Tax (VAT)';
        subscription1.Faktura__c = faktura.id;
        subscription1.Order_Number__c = '5977405';
        subscription1.Invoice_Number__c = '25453448';
        subscription1.Amount__c = 5.80;
        
        
        subscriptionList.add(subscription1);
        
        insert subscriptionList;
        Id ids = [select Id from Faktura__c where Name = '00000' limit 1].Id;
        Id id1s = [select Id from Faktura__c where Name = '25453448' limit 1].Id;

        Payment_Invoice__c paymentInvoice = new Payment_Invoice__c();
        paymentInvoice.Account__c=account.Id;
        paymentInvoice.CommentsLong__c=null;
        paymentInvoice.Aria_Account__c=customer.Id;
        paymentInvoice.Transaction_No__c='38309600';
        paymentInvoice.Amount_Applied__c=null;
        paymentInvoice.Applied_Against__c=null;
        paymentInvoice.External_Name__c='null_38309600';
        paymentInvoice.Faktura__c = ids;
        paymentInvoice.Payment__c = payment1.Id;   
        
        Payment_Invoice__c paymentInvoice1 = new Payment_Invoice__c();
        paymentInvoice1.Account__c=account.Id;
        paymentInvoice1.CommentsLong__c=null;
        paymentInvoice1.Aria_Account__c=customer.Id;
        paymentInvoice1.Transaction_No__c='38309687';
        paymentInvoice1.Amount_Applied__c=1000.0;
        paymentInvoice1.Payment_date_time__c=system.today();
        paymentInvoice1.External_Name__c='25453448_38309687';
        paymentInvoice1.Faktura__c = faktura.Id;
        paymentInvoice1.Payment__c = payment2.Id; 
        
         
        Payment_Invoice__c paymentInvoice3 = new Payment_Invoice__c();
        paymentInvoice3.Account__c=account.Id;
        paymentInvoice3.CommentsLong__c=null;
        paymentInvoice3.Aria_Account__c=customer.Id;
        paymentInvoice3.Transaction_No__c='38309698';
        paymentInvoice3.Amount_Applied__c=1000.0;
        paymentInvoice3.Payment_date_time__c=system.today();
        paymentInvoice3.External_Name__c='38309689_38309698';
        paymentInvoice3.Faktura__c =faktura1.Id;
        paymentInvoice3.Payment__c = payment3.Id; 
        
        List<Payment_Invoice__c> paymentInvoiceList = new List<Payment_Invoice__c>();
        paymentInvoiceList.add(paymentInvoice);
        paymentInvoiceList.add(paymentInvoice1);
        paymentInvoiceList.add(paymentInvoice3);

        insert paymentInvoiceList;
        
        Unapplied_Credit__c unAppObj = new Unapplied_Credit__c();
        unAppObj.Name='4567888';
        unAppObj.Unapplied_Amount1__c=20;
        unAppObj.Aria_Account__c=customer.Id;
        unAppObj.Customer__c=customer.Account__c;
        unAppObj.Amount__c = 30;
        unAppObj.External_Name__c ='4567888-987765';
        unAppObj.Credit_type__c = 'Cash';
        insert unAppObj;

        Unapplied_Credit__c unAppObj1 = new Unapplied_Credit__c();
        unAppObj1.Name='4567889';
        unAppObj1.Unapplied_Amount1__c=30;
        unAppObj1.Aria_Account__c=customer.Id;
        unAppObj1.Customer__c=customer.Account__c;
        unAppObj1.Amount__c = 40;
        unAppObj1.Credit_type__c = 'Cash';
        unAppObj1.External_Name__c='4567889-987745';
        insert unAppObj1;

        Applied_Credit__c appObj = new Applied_Credit__c();
        appObj.Amount__c = 20;
        appObj.External_Name__c = '4567889-987745';
        appObj.name = '4567889';
        appObj.Faktura__r = new Faktura__c(Fakturanummer__c = '00000'); 
        appObj.Credit_Bel_b__c= 40;
        appObj.Account__c =customer.Account__c;
        appObj.Aria_Account__c =customer.Id;
        insert appObj;

        Applied_Credit__c appObj1 = new Applied_Credit__c();
        appObj1.Amount__c = 30;
        appObj1.name = '4567888';
        appObj1.External_Name__c = '4567888-987765';
        appObj1.Faktura__r = new Faktura__c(Fakturanummer__c = '00000'); 
        appObj1.Credit_Bel_b__c= 30;
        appObj1.Account__c =customer.Account__c;
        appObj1.Aria_Account__c =customer.Id;
        
        insert appObj1;
        
        Applied_Credit__c appObj2 = new Applied_Credit__c();
        appObj2.Amount__c = 30;
        appObj2.name = '4567889';
        appObj2.External_Name__c = '4567889-987764';
        appObj2.Faktura__r = new Faktura__c(Fakturanummer__c = '25453497'); 
        appObj2.Credit_Bel_b__c= 30;
        appObj2.Account__c =customer.Account__c;
        appObj2.Aria_Account__c =customer.Id;
        appObj2.Applied_Against__c = 'Invoice';

        insert appObj2;
    }
    
    static testMethod void testBillingController(){
        insertData();
        Test.StartTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
        CarrieBillingBatchController customerBilling =new CarrieBillingBatchController(standardController);
        
        customerBilling.getSelectAccounts();
        customerBilling.redirectCreateCredit();
        customerBilling.redirectUsage();
        
        customerBilling.accountResponse = '{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":1,"account_details":[{"acct_no":3648207,"senior_acct_no":null,"user_id":"poonam","password":"poonamthergaonka","status_cd":1,"plan_no":10263511,"first_name":"Poonam","mi":null,"last_name":"Thergaonkar","address_1":"Block AGodrej and Boyce Compound","address_2":"LBS MargVikhroliWest","city":"Mumbai","locality":null,"postal_code":"400079","country":"IN","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":"98464548787a","alt_email":"poonam.thergaonkar@capgemini.com","client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2012-06-18 21:26:00","last_updated":"2012-09-26 01:33:37","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"Poonam","billing_middle_initial":null,"billing_last_name":"Thergaonkar","billing_address1":"Block AGodrej and Boyce Compound","billing_address2":"LBS MargVikhroliWest","billing_city":"Mumbai","billing_state":null,"billing_locality":null,"billing_zip":"400079","billing_country":"IN","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":"98464548787a","billing_email":"poonam.thergaonkar@capgemini.com","billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"DTV","state_prov":null,"country_english":"India","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"613702384"}],"bill_day":18,"supp_plan":[{"supp_plan_no":10532741,"supp_plan_name":"Telefoni Fast pris"},{"supp_plan_no":10532745,"supp_plan_name":"Telefoni Fastpris"}]}]}';
        customerBilling.invoiceResponse = '{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":4,"invoice_details":[{"invoice_no":20088399,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-06-19 05:37:50","due_date":"2012-07-19 05:37:50","paid_date":"2012-06-19 05:37:50","notify_date":"2012-06-19 05:42:52","from_date":"2012-06-18 00:00:00","to_date":"2012-09-17 00:00:00","currency_cd":"dkk","balance_forward":null,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-06-19 05:37:50","transaction_type":null,"user_id":"poonam","aria_event_no":28209543,"aria_statement_no":153119250,"acct_statement_seq_str":"153119250","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":0,"comments":"Recurring Fee","plan_no":10263511,"plan_name":"DTV","service_no":102,"service_name":"Recurring Fee","ledger_code":"Setup Fees COA Code","coa_id":1001,"coa_description":"Setup Fees COA Code","usage_units":1,"usage_rate":0,"usage_type_no":null,"start_date":"2012-06-18 00:00:00","end_date":"2012-09-17 00:00:00","order_no":9395217}]},{"invoice_no":22664771,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-09-05 01:35:29","due_date":"2012-10-05 01:35:29","paid_date":"2012-09-05 01:35:30","notify_date":"2012-09-05 01:40:50","from_date":"2012-09-18 00:00:00","to_date":"2012-12-17 00:00:00","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-09-05 01:35:29","transaction_type":null,"user_id":"poonam","aria_event_no":32417485,"aria_statement_no":175807791,"acct_statement_seq_str":"175807791","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":0,"comments":"Recurring Fee","plan_no":10263511,"plan_name":"DTV","service_no":102,"service_name":"Recurring Fee","ledger_code":"Setup Fees COA Code","coa_id":1001,"coa_description":"Setup Fees COA Code","usage_units":1,"usage_rate":0,"usage_type_no":null,"start_date":"2012-09-18 00:00:00","end_date":"2012-12-17 00:00:00","order_no":9395212}]},{"invoice_no":23993077,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-09-26 01:33:36","due_date":"2012-10-26 01:33:36","paid_date":"2012-09-26 01:33:36","notify_date":null,"from_date":null,"to_date":null,"currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-09-26 01:33:36","transaction_type":null,"user_id":"poonam","aria_event_no":35067081,"aria_statement_no":187794615,"acct_statement_seq_str":"187794615","second_acct_statement_seq_str":null,"invoice_line":null},{"invoice_no":25453448,"acct_no":3648207,"debit":1000,"credit":1000,"bill_date":"2012-11-16 17:57:52","due_date":"2012-12-16 17:57:52","paid_date":"2012-11-16 17:58:16","notify_date":"2012-11-16 17:57:52","from_date":"2012-11-16 17:57:51","to_date":"2012-11-16 17:57:51","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":null,"additional_comments":"Comments","last_updated":"2012-11-16 17:57:52","transaction_type":null,"user_id":"poonam","aria_event_no":38309686,"aria_statement_no":199711714,"acct_statement_seq_str":"199711714","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":1000,"comments":"Activation Fee (order # 3634612)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":1,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-11-16 17:57:51","end_date":"2012-11-16 17:57:51","order_no":9395213}]}]}';
        customerBilling.paymentResponse = '{"history":[{"transaction_id":38309600,"transaction_type":2,"transaction_desc":"Credit #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8260266,"transaction_ref_code":"12221"},{"transaction_id":38309687,"transaction_type":2,"transaction_desc":"Check #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8263266,"transaction_ref_code":"12221"},{"transaction_id":38309686,"transaction_type":1,"transaction_desc":"Invoice #25453448","transaction_amount":1000,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":199711714,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":"Comments","transaction_source_id":25453448,"transaction_ref_code":null},{"transaction_id":35067081,"transaction_type":1,"transaction_desc":"Invoice #23993077","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-26","transaction_void_date":null,"statement_no":187794615,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":23993077,"transaction_ref_code":null},{"transaction_id":32417485,"transaction_type":1,"transaction_desc":"Invoice #22664771","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-05","transaction_void_date":null,"statement_no":175807791,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":22664771,"transaction_ref_code":null},{"transaction_id":28209543,"transaction_type":1,"transaction_desc":"Invoice #20088399","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-06-19","transaction_void_date":null,"statement_no":153119250,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":20088399,"transaction_ref_code":null}],"error_code":0,"error_msg":"OK"}';
        customerBilling.transactionResponse ='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":8,"transaction_information":[{"aria_event_no":28209543,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119250,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":20088399,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":null,"fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":28209512,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119251,"transaction_type":"voided Invoice","transaction_type_no":-1,"is_charge_type":1,"type_specific_id":20088398,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":"2012-06-19 05:41:57","fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":32417485,"transaction_date":"2012-09-05 01:35:30","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":175807791,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":22664771,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-05 01:39:20","void_date":null,"fully_applied_date":"2012-09-05 01:35:30","related_transaction":[]},{"aria_event_no":35067081,"transaction_date":"2012-09-26 01:33:36","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":187794615,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":23993077,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-26 01:38:13","void_date":null,"fully_applied_date":"2012-09-26 01:33:36","related_transaction":[]},{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":null,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]},{"aria_event_no":38309600,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Cash","transaction_type_no":10,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309605,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Electronic Payment","transaction_type_no":3,"is_charge_type":0,"type_specific_id":8263268,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]}]}';

        //customerBilling.transactionResponse = '{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":5,"transaction_information":[{"aria_event_no":28209543,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119250,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":20088399,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":null,"fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":32417485,"transaction_date":"2012-09-05 01:35:30","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":175807791,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":22664771,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-05 01:39:20","void_date":null,"fully_applied_date":"2012-09-05 01:35:30","related_transaction":[]},{"aria_event_no":35067081,"transaction_date":"2012-09-26 01:33:36","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":187794615,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":23993077,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-26 01:38:13","void_date":null,"fully_applied_date":"2012-09-26 01:33:36","related_transaction":[]},{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":null,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]},{"aria_event_no":38309600,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Cash","transaction_type_no":10,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]}]}';
        customerBilling.creditResponse = '{"error_code":0,"error_msg":"OK","unapplied_service_credits":null}';
        customerBilling.refreshAriaAccount();
        customerBilling.callToCasper();
        //added for SPOC_1916
        /*CarrieInsertRecordsBatch CIRB= new CarrieInsertRecordsBatch();
        CIRB.transactionResponse1='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":8,"transaction_information":[{"aria_event_no":28209543,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119250,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":20088399,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":null,"fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":28209512,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119251,"transaction_type":"voided Invoice","transaction_type_no":-1,"is_charge_type":1,"type_specific_id":20088398,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":"2012-06-19 05:41:57","fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":32417485,"transaction_date":"2012-09-05 01:35:30","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":175807791,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":22664771,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-05 01:39:20","void_date":null,"fully_applied_date":"2012-09-05 01:35:30","related_transaction":[]},{"aria_event_no":35067081,"transaction_date":"2012-09-26 01:33:36","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":187794615,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":23993077,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-26 01:38:13","void_date":null,"fully_applied_date":"2012-09-26 01:33:36","related_transaction":[]},{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":null,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]},{"aria_event_no":38309600,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Cash","transaction_type_no":10,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309605,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Electronic Payment","transaction_type_no":3,"is_charge_type":0,"type_specific_id":8263268,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]}]}';
        string trres='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":8,"transaction_information":[{"aria_event_no":28209543,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119250,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":20088399,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":null,"fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":28209512,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119251,"transaction_type":"voided Invoice","transaction_type_no":-1,"is_charge_type":1,"type_specific_id":20088398,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":"2012-06-19 05:41:57","fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":32417485,"transaction_date":"2012-09-05 01:35:30","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":175807791,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":22664771,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-05 01:39:20","void_date":null,"fully_applied_date":"2012-09-05 01:35:30","related_transaction":[]},{"aria_event_no":35067081,"transaction_date":"2012-09-26 01:33:36","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":187794615,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":23993077,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-26 01:38:13","void_date":null,"fully_applied_date":"2012-09-26 01:33:36","related_transaction":[]},{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":null,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]},{"aria_event_no":38309600,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Cash","transaction_type_no":10,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309605,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Electronic Payment","transaction_type_no":3,"is_charge_type":0,"type_specific_id":8263268,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]}]}';
        CIRB.orderresponse='{"error_code":0,"error_msg":"OK","order_items":[{"line_no":1,"client_sku":"2800001","label":"Blockbuster Leje","alt_label":"Blockbuster Leje","long_desc":"Blockbuster Film Leje","units":1,"unit_amount":10,"line_amount":10,"line_comments":"Cop out"}]}';
        String orderres='{"error_code":0,"error_msg":"OK","order_items":[{"line_no":1,"client_sku":"2800002","label":"Blockbuster Leje","alt_label":"Blockbuster Leje","long_desc":"Blockbuster Film Leje","units":1,"unit_amount":10,"line_amount":10,"line_comments":"Cop out"}]}';
		CarrieInsertRecordsBatch.getRefundDetails(customer.Name);
        CIRB.get_order_items(account.Id);
        CIRB.parsetrans(trres);
        CIRB.parseorder(orderres,'9395213');
        String res =CIRB.getAriaResponse('3648207');*/
        Test.stopTest();
    }
    public static testMethod void testBetalingsWrapper(){
        CarrieBetalingsHistory.BetalingsWrapper bs=new CarrieBetalingsHistory.BetalingsWrapper();
        bs.first_name='sheetal';
        bs.middle_initial='b';
        bs.last_name='john';
        bs.address1='xyz';
        bs.address2='abc';
        bs.city='mumbai';
        bs.state='maharashtra';
        bs.zipcode='123';
        bs.country='india';
        bs.locality='xyz';
        bs.phone='234566';
        bs.cell_phone='88789770970';
        bs.work_phone='234665';
        bs.email='s@gamil.com';
        bs.company_name='cg';
        bs.seq_no='12';
        bs.pay_method_id='1';
        bs.pay_method_name='abc';
        bs.persistent_ind='qwe';
       // bs.from_date='15-7-2015;
        //bs.to_date='20-8-2015';
        bs.cc_exp_mm='2';
        bs.cc_exp_yy=8;
        bs.cc_id='1';
        bs.cc_type='ab';
        bs.bank_routing='ash';
        bs.bank_name='sbi';
        bs.bank_acct_type='saving';
        bs.suffix='a';
        bs.current_pay_method='abc';
        bs.bill_info_api_receipt_id='123';
        bs.address3='435';
        bs.bkup_pay_method_ind='12';
    }    
    public static testmethod void testBetalingsOuterWrapper(){
      CarrieBetalingsHistory.BetalingsOuterWrapper bo=new CarrieBetalingsHistory.BetalingsOuterWrapper(); 
        bo.error_code=123;
        bo.error_msg='error';
    }     
  
    
    static testMethod void testCarrieBetalingsHistory(){
        insertData();
        Test.StartTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
        CarrieBetalingsHistory betalingHist =new CarrieBetalingsHistory(standardController);
         // CarrieBetalingsHistory betalingHist1 =new CarrieBetalingsHistory();
        betalingHist.retrieveBetalingsHistory();
        //betalingHist.abc();
      
        
        
        String response = '{"acct_pay_methods":[{"first_name":"HANS","middle_initial":null,"last_name":"GRANH00d8J","address1":"S00f8parken 8","address2":"Annisse","city":"Helsinge","state":null,"zipcode":"3200","country":"DK","locality":null,"phone":null,"cell_phone":null,"work_phone":null,"email":null,"company_name":null,"seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","persistent_ind":1,"from_date":"2014-02-14","to_date":"Present","cc_exp_mm":null,"cc_exp_yy":null,"cc_id":null,"cc_type":null,"bank_routing":null,"bank_name":null,"bank_acct_type":null,"suffix":null,"current_pay_method":1,"bill_info_api_receipt_id":null,"address3":null,"from_date_time":"2014-02-14 13:00:48","to_date_time":"Present","bkup_pay_method_ind":"0"},{"first_name":"HANS","middle_initial":null,"last_name":"GRANH00d8J","address1":"S00f8parken 8   ","address2":"Annisse","city":"Helsinge","state":null,"zipcode":"3200","country":"DK","locality":null,"phone":null,"cell_phone":null,"work_phone":null,"email":null,"company_name":null,"seq_no":1,"pay_method_id":4,"pay_method_name":"Net Terms 30","persistent_ind":1,"from_date":"2014-02-14","to_date":"2014-02-14","cc_exp_mm":null,"cc_exp_yy":null,"cc_id":null,"cc_type":null,"bank_routing":null,"bank_name":null,"bank_acct_type":null,"suffix":null,"current_pay_method":0,"bill_info_api_receipt_id":null,"address3":null,"from_date_time":"2014-02-14 12:11:10","to_date_time":"2014-02-14 13:00:48","bkup_pay_method_ind":"0"}],"error_code":0,"error_msg":"OK"}';
        betalingHist.parseResponse(response);
        // SPOC - 1939 Test class issue
        CarrieGlobalConstants cr = new CarrieGlobalConstants();
        cr.samplemethod();
        
        Test.stopTest();
    }       
}