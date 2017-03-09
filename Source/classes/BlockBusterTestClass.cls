@isTest(SeeAllData=true)
private class BlockBusterTestClass { 

    /*static testMethod void myUnitTestBlockbusterParse() {
        
        test.startTest();
        String strBody = '{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}';
        BlockBusterIssueRefundWrapper obj = new BlockBusterIssueRefundWrapper();
        obj = BlockbusterParse.parseIssueRefund(strBody);
        
        String strBody1 = '{"error_code":0,"refund_details":[{"refund_transaction_id":"83434866","refund_amount":3746.25,"create_date":"2014-11-04","create_user":"Taxes","reason_code":7,"reason_label":"Wrong undesired payment source charged","reason_description":"Wrong undesired payment source charged","ref_payment_transaction_id":81745985,"ref_payment_transaction_type":3,"ref_payment_transaction_desc":"Electronic Payment","ref_payment_amount":3746.25,"ref_payment_ref_code":null,"bill_seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","cc_id":null,"cc_type":null,"payment_src_suffix":null,"refund_check_num":null,"is_voided_ind":0,"invoice_reversals":[{"invoice_no":60064382,"invoice_bill_date":"2014-10-08","invoice_line_no":1,"total_line_debit":2997,"reversed_line_amount":2997,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":60064382,"invoice_bill_date":"2014-10-08","invoice_line_no":2,"total_line_debit":749.25,"reversed_line_amount":749.25,"reversed_line_start_date":null,"reversed_line_end_date":null}]},{"refund_transaction_id":"83436174","refund_amount":18.75,"create_date":"2014-11-04","create_user":"Taxes","reason_code":6,"reason_label":"Overpayment Duplicate payment","reason_description":"Overpayment Duplicate payment","ref_payment_transaction_id":81747332,"ref_payment_transaction_type":3,"ref_payment_transaction_desc":"Electronic Payment","ref_payment_amount":18.75,"ref_payment_ref_code":null,"bill_seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","cc_id":null,"cc_type":null,"payment_src_suffix":null,"refund_check_num":null,"is_voided_ind":0,"invoice_reversals":[{"invoice_no":60066243,"invoice_bill_date":"2014-10-08","invoice_line_no":1,"total_line_debit":15,"reversed_line_amount":15,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":60066243,"invoice_bill_date":"2014-10-08","invoice_line_no":2,"total_line_debit":3.75,"reversed_line_amount":3.75,"reversed_line_start_date":null,"reversed_line_end_date":null}]}],"error_msg":"OK"}';
        BlockBusterRefundDetailsWrapper obj1 = new BlockBusterRefundDetailsWrapper();
        obj1 = BlockbusterParse.parseRefundDetails(strBody1);
        
        String strBody2 = '{ "clipcards": [ { "ref": "d968de86058a339bb9892cbb4acd01ee", "product_id": "1", "price": "9900", "created_at": "2014-09-24 12:06:32", "title": "Klippekort", "num_clip": "3", "clips": [ { "id": "13", "expires_at": "2015-09-24 12:06:32", "updated_at": "2014-09-24 20:06:43", "state": "used", "price": "3900", "order_type": "rent_movie" }, { "id": "14", "expires_at": "2015-09-24 12:06:32", "updated_at": null, "state": "free", "price": null, "order_type": null }, { "id": "15", "expires_at": "2015-09-24 12:06:32", "updated_at": null, "state": "free", "price": null, "order_type": null } ] }, { "ref": "d46f9a14b15b9a41cbda8da1ca4e92e4", "product_id": "1", "price": "9900", "created_at": "2014-09-24 12:10:23", "title": "Klippekort", "num_clip": "3", "clips": [ { "id": "16", "expires_at": "2015-09-24 12:10:23", "updated_at": null, "state": "free", "price": null, "order_type": null }, { "id": "17", "expires_at": "2015-09-24 12:10:23", "updated_at": null, "state": "free", "price": null, "order_type": null }, { "id": "18", "expires_at": "2015-09-24 12:10:23", "updated_at": null, "state": "free", "price": null, "order_type": null } ] } ] }';
        List<BlockBusterKlipStatus> lst = BlockbusterParse.parseKlipsStatus(strBody2);
        
        String strBody3 = ' { "refunds": [ { "transaction_id": 1295632, "billing_entry_id": "114", "clip_id": "182", "ref": "ae94871abce00bd1298f578eaec1f3f7", "refunded_clip_price": 3300 }, { "transaction_id": 1295633, "billing_entry_id": "114", "clip_id": "183", "ref": "ae94871abce00bd1298f578eaec1f3f7", "refunded_clip_price": 3300 } ] }';
        List<BlockBusterCancelKlips> lst1 = BlockbusterParse.parseCancelKlips(strBody3);
        
        BlockBusterInsertUpdate.InsertRefundDetails(obj1);
        BlockBusterInsertUpdate.UpdateInvoicePayment(obj1);
        
        test.stopTest();
    }*/
    
    static testMethod void myUnitTestBlockbusterWrapper() {
        
        test.startTest();
        BlockBusterIssueRefundWrapper obj = new BlockBusterIssueRefundWrapper();
        obj.applied_total_refund_amount='49'; 
        obj.applied_total_reversal_amount='49';
        obj.error_code='0';
        obj.error_msg='OK';
        
        BlockBusterIssueRefundWrapper.IssueRefundlineItems o= new BlockBusterIssueRefundWrapper.IssueRefundlineItems();
        o.client_invoice_line_service_id='Blockbuster_Leje'; 
    o.invoice_line_comments='Blockbuster Leje (order5956971)';
    o.invoice_line_no='1';
    o.invoice_line_reversed_amount='39.2';
    o.invoice_line_reversing_date=null;
    o.invoice_line_service_no='11163621';
    o.invoice_no='60440190';

        //obj.reversed_invoice_lines.add(o);
        obj.transaction_id='83544580';
        
        BlockBusterRefundDetailsWrapper obj1 = new BlockBusterRefundDetailsWrapper();
        obj1.error_code = '0';
        obj1.error_msg = 'OK';
        
        BlockBusterRefundDetailsWrapper.refund_details ref = new BlockBusterRefundDetailsWrapper.refund_details();
        ref.bill_seq_no = 'Test Bill';
        ref.cc_id = 'CC';
        ref.cc_type = 'CC Type';
        ref.create_date = 'createddate';
        ref.create_user = 'User';
        ref.is_voided_ind = '0';
        ref.pay_method_id = 'Pay Method';
        ref.pay_method_name = 'Pay Method Name';
        ref.payment_src_suffix = 'payemnt src';
        ref.reason_code = '2';
        ref.reason_description = 'Description';
        ref.reason_label = 'label';
        ref.ref_payment_amount = 'ref payment amt';
        ref.ref_payment_ref_code = 'ref pay code';
        ref.ref_payment_transaction_desc = 'ref desc code';
        ref.ref_payment_transaction_id = 'ref pay tran id';
        ref.ref_payment_transaction_type = 'ref pay tran id';
        ref.refund_amount = '21';
        ref.refund_check_num = 'ref check num';
        ref.refund_transaction_id = 'ref trans id';
        
        /*BlockBusterRefundDetailsWrapper.refund_details.invoice_reversals inrev = new BlockBusterRefundDetailsWrapper.refund_details.invoice_reversals inrev();
        inrev.invoice_no = '12345';
        inrev.invoice_bill_date = 'date';
        inrev.invoice_line_no = '1';
    inrev.total_line_debit = 'debit';
    inrev.reversed_line_amount = 'lineamt';
    inrev.reversed_line_start_date = 'rev line start date';
    inrev.reversed_line_end_date = 'rev line end date';*/
    
    BlockBusterKlipStatus objklip = new BlockBusterKlipStatus();
    objklip.created_at = 'date';
    objklip.num_clip = 'numclip';
    objklip.price = 'price';
    objklip.product_id = 'productid';
    objklip.ref = 'ref';
    objklip.title = 'title';
    
    BlockBusterKlipStatus.clipDets clipdet= new BlockBusterKlipStatus.clipDets();
    clipdet.expires_at = 'Exp date';
    clipdet.id = 'clipid';
    clipdet.order_type = 'ordertype';
    clipdet.price = 'price';
    clipdet.state = 'state';
    clipdet.updated_at = 'updated at';
        test.stopTest();
    }
    
    static testMethod void myUnitTestBlockbusterCallOut() {
      Test.startTest(); 
    
    Account account = new Account(); 
      Aria_Account__c customer = new Aria_Account__c();
        
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
        
        List<Transaction__c> transactionList = new List<Transaction__c>();
        transactionList.add(transaction1);
        transactionList.add(transaction2);
        transactionList.add(transaction3);
        transactionList.add(transaction4);
        transactionList.add(transaction5);
        transactionList.add(transaction6);
        
        insert transactionList;
        
        Faktura__c faktura = new Faktura__c();
        faktura.Name='25453448';
        faktura.Aria_Account__c=customer.Id;
        faktura.Customer__c=account.Id;
        faktura.Aria_Event_No__c='38309686';
        faktura.Datoforudskrift__c=system.today();
        faktura.Momspligtigt_bel_b__c=1000.0;
        faktura.Betalingsfrist__c=system.today();
        faktura.Fakturanummer__c='25453448';
        insert Faktura;
        
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        
        subscription.Faktura_line_no__c = '25453448-1';
        subscription.Name = '25453448-1';
        subscription.Service_Name__c = 'Blockbuster Leje (order # 5977405)';
        subscription.Amount__c =  23.20;
        subscription.Faktura__c = Faktura.id;
        subscriptionList.add(subscription);
        
        
        Invoice_Subscription__c subscription1 = new Invoice_Subscription__c();
        subscription1.Faktura_line_no__c = '25453448-2';
        subscription1.Name = '25453448-2';
        subscription1.Service_Name__c = 'Value Added Tax (VAT)';
        subscription1.Faktura__c = Faktura.id;
        subscription1.Amount__c = 5.80;
        
        subscriptionList.add(subscription1);
        
        insert subscriptionList;
        
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
        
        List<Invoice_Payment__c>listInvPay = new List<Invoice_Payment__c>();
        listInvPay.add(invoicePayment);
        
        Id ids = [select Id from Faktura__c where Name = '00000' limit 1].Id;
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
        
        List<Payment_Invoice__c> paymentInvoiceList = new List<Payment_Invoice__c>();
        paymentInvoiceList.add(paymentInvoice);
        paymentInvoiceList.add(paymentInvoice1);
        insert paymentInvoiceList; 
        
        
        //HttpResponse resp = BlockBusterCallOut.IssueRefund(paymentInvoiceList, '2', subscriptionList);
        
        //BlockBusterInsertUpdate.mapPayNoToId.put('8260266',payment1);
        HttpResponse res1 = BlockBusterCallOut.RefundDetails(customer.Name);
        
        //HttpResponse res2 = BlockBusterCallOut.CancelKlips(faktura.Id);
        // SPOC-1978
        //HttpResponse res3 = BlockBusterCallOut.IssueRefundKlippikort(listInvPay, '2', subscriptionList,99,2.44);
        
        Test.stopTest(); 
    }
    
    @isTest static void myUnitTestBlockbusterODPServices() {

    Test.startTest(); 
    Account account = new Account(); 
      Aria_Account__c customer = new Aria_Account__c();
        HttpResponse resKlipStatus = BlockBusterODPServices.getKlipsStatus(account.customer_no__c);
        System.debug('resKlipStatus *** '+resKlipStatus);
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
        
      Test.setMock(HttpCalloutMock.class, new BlockBusterMockHttpResponse());
      Account acc = account;
      List<Faktura__c>lstFaktura = new List<Faktura__c>([SELECT ID,Aria_Account__r.Customer_No__c,Aria_Account__c From Faktura__c limit 1]);
      List<Aria_Account__c> listAriaacc = [SELECT Account__r.customer_no__c FROM Aria_Account__c WHERE Id =: lstFaktura[0].Aria_Account__c];
      system.debug('Customer no **** '+listAriaacc);
      String stautsRes = '{"clipcards":[{"ref":"7d4d8e4ad9cfaa759b8225b6c03ad4b4","product_id":"1","price":"9900","created_at":"2014-11-10 05:11:23","title":"Klippekort","num_clip":"3","clips":[{"id":"268","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"269","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"270","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"97c5e41ed3c91375912cbce05c47718d","product_id":"1","price":"9900","created_at":"2014-11-10 05:11:48","title":"Klippekort","num_clip":"3","clips":[{"id":"271","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"272","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"273","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"93db07a2ee07942dc916685bddeac3a4","product_id":"1","price":"9900","created_at":"2014-11-10 05:12:16","title":"Klippekort","num_clip":"3","clips":[{"id":"274","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"275","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"276","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"bac050dde7a5666b88d801d1a22378e1","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:26","title":"Klippekort","num_clip":"3","clips":[{"id":"412","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"413","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"414","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"d13a11881289d904c68b5cc7cb7e7094","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:38","title":"Klippekort","num_clip":"3","clips":[{"id":"415","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"416","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"417","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"03618b24a49e81f95f3d3dfddaed1502","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:52","title":"Klippekort","num_clip":"3","clips":[{"id":"418","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"419","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"420","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"88300c4bf21e9fd0a29d2edc076db5de","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:08","title":"Klippekort","num_clip":"3","clips":[{"id":"421","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"422","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"423","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"9b1bc64e8c37a7f58e65e557539156aa","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:30","title":"Klippekort","num_clip":"3","clips":[{"id":"424","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"425","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"426","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"008512ad1b9af4adff3d73f68ad9a1b9","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:48","title":"Klippekort","num_clip":"3","clips":[{"id":"427","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"428","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"429","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"89bb7bc0267bcf75d97acfb1c0d98538","product_id":"1","price":"9900","created_at":"2014-11-12 06:56:05","title":"Klippekort","num_clip":"3","clips":[{"id":"430","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"431","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"432","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2f4a5574747045512bc9fc8ff8c1a13f","product_id":"1","price":"9900","created_at":"2014-11-12 06:58:41","title":"Klippekort","num_clip":"3","clips":[{"id":"433","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"434","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"435","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"dfe6d5160494e0a2908b218e855e6846","product_id":"1","price":"9900","created_at":"2014-11-12 07:13:01","title":"Klippekort","num_clip":"3","clips":[{"id":"436","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"437","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"438","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"ed62821972fcee2a6ca6b051d103107d","product_id":"1","price":"9900","created_at":"2014-11-12 07:13:27","title":"Klippekort","num_clip":"3","clips":[{"id":"439","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"440","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"441","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2d5da5c4bce390c8c7f1f943e2204a52","product_id":"1","price":"9900","created_at":"2014-11-12 07:15:57","title":"Klippekort","num_clip":"3","clips":[{"id":"442","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"443","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"444","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2fd6db31fac45ee7553696fbd59f8cf3","product_id":"1","price":"9900","created_at":"2014-11-12 07:16:17","title":"Klippekort","num_clip":"3","clips":[{"id":"445","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"446","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"447","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"97229e0eeb4d8e30e61e1ed64312524e","product_id":"1","price":"9900","created_at":"2014-11-12 07:16:36","title":"Klippekort","num_clip":"3","clips":[{"id":"448","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"449","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"450","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"aab474fe0dc79c8c5466edd4753aad1b","product_id":"1","price":"9900","created_at":"2014-11-12 07:18:24","title":"Klippekort","num_clip":"3","clips":[{"id":"451","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"452","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"453","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"1e1108b3267203f3ae6cf9801e6c2b21","product_id":"1","price":"9900","created_at":"2014-11-12 07:18:44","title":"Klippekort","num_clip":"3","clips":[{"id":"454","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"455","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"456","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null}]}]}';
        //System.debug('stautsRes **** '+stautsRes);
      List<BlockBusterKlipStatus> listParsedKlips = BlockbusterParse.parseKlipsStatus(stautsRes);
        system.debug(' ***** listParsedKlips'+listParsedKlips);
        HttpResponse res3 = BlockBusterODPServices.getKlipsStatus('16314788');
        
        
        Test.setMock(HttpCalloutMock.class, new BlockBusterMockHttpResponse());
      HttpResponse res2 = BlockBusterODPServices.cancelKlips(listAriaacc[0].Account__r.customer_no__c,listParsedKlips[0].ref,'1');
      // Verify response received contains fake values
        
        String actualValue2 = res2.getBody();
        //String expectedValue2 = '{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}';
        //String expectedValue2 = '{"refunds":[{"transaction_id":1435880,"billing_entry_id":"376","clip_id":"268","ref":"7d4d8e4ad9cfaa759b8225b6c03ad4b4","refunded_clip_price":3300},{"transaction_id":1435881,"billing_entry_id":"376","clip_id":"269","ref":"7d4d8e4ad9cfaa759b8225b6c03ad4b4","refunded_clip_price":3300},{"transaction_id":1435882,"billing_entry_id":"376","clip_id":"270","ref":"7d4d8e4ad9cfaa759b8225b6c03ad4b4","refunded_clip_price":3300}]}';
        //System.assertEquals(actualValue2, expectedValue2);
        //System.assertEquals(200, res2.getStatusCode());
        
        
        
      // Verify response received contains fake values
        
        String actualValue3 = res3.getBody();
        //String expectedValue3 = '{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}';
        //System.assertEquals(actualValue3, expectedValue3);
        //System.assertEquals(200, res3.getStatusCode());
          test.stopTest();
    
    }
    
    static testMethod void myUnitTestBlockbusterBBRefundController() {
      Test.startTest(); 
    
    Account account = new Account(); 
      Aria_Account__c customer = new Aria_Account__c();
        
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
        payment1.Aria_Event_No__c='8260266';
        payment1.Payment_No__c='8260266';
        payment1.Name='8260266';
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
        
        List<Transaction__c> transactionList = new List<Transaction__c>();
        transactionList.add(transaction1);
        transactionList.add(transaction2);
        transactionList.add(transaction3);
        transactionList.add(transaction4);
        transactionList.add(transaction5);
        transactionList.add(transaction6);
        
        insert transactionList;
        
        Faktura__c faktura = new Faktura__c();
        faktura.Name='25453448';
        faktura.Aria_Account__c=customer.Id;
        faktura.Customer__c=account.Id;
        faktura.Aria_Event_No__c='38309686';
        faktura.Datoforudskrift__c=system.today();
        faktura.Momspligtigt_bel_b__c=1000.0;
        faktura.Betalingsfrist__c=system.today();
        faktura.Fakturanummer__c='25453448';
        insert Faktura;
        Faktura__c faktura1 = new Faktura__c();
        faktura1.Name='25453449';
        faktura1.Aria_Account__c=customer.Id;
        faktura1.Customer__c=account.Id;
        faktura1.Aria_Event_No__c='38309686';
        faktura1.Datoforudskrift__c=system.today();
        faktura1.Momspligtigt_bel_b__c=1000.0;
        faktura1.Betalingsfrist__c=system.today();
        faktura1.Fakturanummer__c='25453449';
        insert Faktura1;
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        
        subscription.Faktura_line_no__c = '25453448-1';
        subscription.Name = '25453448-1';
        subscription.Service_Name__c = 'Blockbuster Leje (order # 5977405)';
        subscription.Amount__c =  23.20;
        subscription.Faktura__c = Faktura.id;
        subscriptionList.add(subscription);
        
        
        Invoice_Subscription__c subscription1 = new Invoice_Subscription__c();
        subscription1.Faktura_line_no__c = '25453448-2';
        subscription1.Name = '25453448-2';
        subscription1.Service_Name__c = 'Value Added Tax (VAT)';
        subscription1.Faktura__c = Faktura.id;
        subscription1.Amount__c = 5.80;
        
        Invoice_Subscription__c subscription3 = new Invoice_Subscription__c();
        
        subscription3.Faktura_line_no__c = '25453449-1';
        subscription3.Name = '25453448-1';
        subscription3.Service_Name__c = 'Blockbuster Klippekort (order # 5977405)';
        subscription3.Amount__c =  79.20;
        subscription3.Faktura__c = Faktura.id;
        subscriptionList.add(subscription3);
        
        
        Invoice_Subscription__c subscription4 = new Invoice_Subscription__c();
        subscription4.Faktura_line_no__c = '25453449-2';
        subscription4.Name = '25453448-2';
        subscription4.Service_Name__c = 'Value Added Tax (VAT)';
        subscription4.Faktura__c = Faktura.id;
        subscription4.Amount__c = 19.80;
        subscriptionList.add(subscription4);
        
        insert subscriptionList;
        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
        invoicePayment.Account__c=account.Id;
        invoicePayment.Aria_Account__c=customer.Id;
        invoicePayment.Transaction_No__c='38309687';
        invoicePayment.Amount_Applied__c=1000.0;
        invoicePayment.Payment_date_time__c=system.today();
        invoicePayment.statement_no__c=199711714;
        invoicePayment.External_Name__c='25453448_38309687';
        invoicePayment.invoice_no__c=25453448;
        invoicePayment.Faktura__c = Faktura.Id;
        invoicePayment.Payment__c = payment2.Id;  
        invoicePayment.Transaction_Date__c = DateTime.Now(); 
        invoicePayment.Refund_BB__c = null;
		invoicePayment.Titel__c = 'Never Back Down';
        insert invoicePayment;
        
        List<Invoice_Payment__c>listInvPay = new List<Invoice_Payment__c>();
        listInvPay.add(invoicePayment);
        
        Id ids = [select Id from Faktura__c where Name = '00000' limit 1].Id;
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
        
        List<Payment_Invoice__c> paymentInvoiceList = new List<Payment_Invoice__c>();
        paymentInvoiceList.add(paymentInvoice);
        paymentInvoiceList.add(paymentInvoice1);
        insert paymentInvoiceList; 
    // Non-Klippikort test
    ApexPages.currentPage().getParameters().put('id',customer.id);
    ApexPages.currentPage().getParameters().put('Fid',null);
    ApexPages.StandardController standardController = new ApexPages.StandardController(account);
    SampleController refControl = new SampleController (standardController);
     
    refControl.getCreditTypes();
    refControl.getRefundcommentsList();
    Test.setMock(HttpCalloutMock.class, new BlockBusterMockHttpResponse());
    HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        
        HttpResponse res1 = new HttpResponse();
        res1.setHeader('Content-Type', 'application/json');
        res1.setBody('{"error_code":0,"refund_details":[{"refund_transaction_id":"83434866","refund_amount":3746.25,"create_date":"2014-11-04","create_user":"Taxes","reason_code":7,"reason_label":"Wrong undesired payment source charged","reason_description":"Wrong undesired payment source charged","ref_payment_transaction_id":81745985,"ref_payment_transaction_type":3,"ref_payment_transaction_desc":"Electronic Payment","ref_payment_amount":3746.25,"ref_payment_ref_code":null,"bill_seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","cc_id":null,"cc_type":null,"payment_src_suffix":null,"refund_check_num":null,"is_voided_ind":0,"invoice_reversals":[{"invoice_no":60064382,"invoice_bill_date":"2014-10-08","invoice_line_no":1,"total_line_debit":2997,"reversed_line_amount":2997,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":60064382,"invoice_bill_date":"2014-10-08","invoice_line_no":2,"total_line_debit":749.25,"reversed_line_amount":749.25,"reversed_line_start_date":null,"reversed_line_end_date":null}]},{"refund_transaction_id":"83436174","refund_amount":18.75,"create_date":"2014-11-04","create_user":"Taxes","reason_code":6,"reason_label":"Overpayment Duplicate payment","reason_description":"Overpayment Duplicate payment","ref_payment_transaction_id":81747332,"ref_payment_transaction_type":3,"ref_payment_transaction_desc":"Electronic Payment","ref_payment_amount":18.75,"ref_payment_ref_code":null,"bill_seq_no":2,"pay_method_id":13,"pay_method_name":"Tokenized Credit Card","cc_id":null,"cc_type":null,"payment_src_suffix":null,"refund_check_num":null,"is_voided_ind":0,"invoice_reversals":[{"invoice_no":60066243,"invoice_bill_date":"2014-10-08","invoice_line_no":1,"total_line_debit":15,"reversed_line_amount":15,"reversed_line_start_date":null,"reversed_line_end_date":null},{"invoice_no":60066243,"invoice_bill_date":"2014-10-08","invoice_line_no":2,"total_line_debit":3.75,"reversed_line_amount":3.75,"reversed_line_start_date":null,"reversed_line_end_date":null}]}],"error_msg":"OK"}');
        res1.setStatusCode(200);
        res1.setStatus('OK');
        
        refControl.resRefund = res;
        refControl.resrefDet = res1;
        refControl.respIssueRefund = refControl.resRefund.getBody();
        refControl.respRefundDetails = refControl.resrefDet.getBody();
        refControl.selectComments = 'Kulance';
        system.debug('answer==='+refControl.resRefund+'======='+refControl.resrefDet+'refControl.respIssueRefund ==='+refControl.respIssueRefund+'==='+refControl.respRefundDetails);
        refControl.pageActionFun();
        refControl.onGemClick();
        Map<String,Payment__c> mappay = new map<String,Payment__c>();
        mappay.put(payment1.Payment_No__c,payment1);
        BlockBusterInsertUpdate.mapPayNoToId = mappay;
    // Klippikort test
    ApexPages.currentPage().getParameters().put('id',customer.id);
    ApexPages.currentPage().getParameters().put('Fid',Faktura.id);
    ApexPages.StandardController standardController1 = new ApexPages.StandardController(account);
    SampleController refControl1 = new SampleController (standardController);
        refControl1.selectComments = 'Kulance';
        refControl1.onGemClick();
		refControl1.redirectPage();
        Test.stopTest();
    }
  static testMethod void testBlockBusterDateTypeTitle()
  {
    Test.startTest();
    RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'Blockbuster Customer Account'];  
        Account account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        Account account1 = new Account();                     
        account1.RecordTypeId =recordType1.Id;
        account1.Status_YK__c = 'Active';
        account1.FirstName = 'Test'; 
        account1.LastName = 'Test';
        account1.Invoice_Test__c = true;
        account1.Customer_response__c = 'Neutral omkring ændring';
        account1.Customer_No__c='981930'; 
        account1.Betaler_Id__c = '3648208';
        insert account1;
        
    Aria_Account__c customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = 'ACTIVE';
        insert customer;
        
        Aria_Account__c customer1 = new Aria_Account__c();
        customer1.Account__c  = account1.Id;
        customer1.Aria_Account_No__c=3648208;
        customer1.Name='3648207'; 
        customer1.Aria_Plan_Name__c='Temp';
        customer1.API_calls__c = 'Transaction Created';
        customer1.Regningsstatus__c = 'ACTIVE';
        insert customer1;
        
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
        
        List<Transaction__c> transactionList = new List<Transaction__c>();
        transactionList.add(transaction1);
        transactionList.add(transaction2);
        transactionList.add(transaction3);
        transactionList.add(transaction4);
        transactionList.add(transaction5);
        transactionList.add(transaction6);
        
        Faktura__c faktura = new Faktura__c();
        faktura.Aria_Account__c  = customer.Id ;
        faktura.Name = '123456';  
        faktura.Customer__c=account.Id;
        faktura.Fakturanummer__c ='123456';
        insert faktura;
        
        List<Faktura__c> fakturaList = new List<Faktura__c>();
        fakturaList.add(faktura);
        List<Faktura__c> invoiceList = new List<Faktura__c>();
        invoiceList.add(faktura);
        
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
        payment1.transaction_source_id__c = '123456';
        payment1.Credit_Reason__c = '';
        payment1.Comments__c = '';
        payment1.Amount__c = 1000.0;
        payment1.Payment_Date__c = system.today();
        insert payment1;
        
        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
        invoicePayment.Account__c = account.Id;
        invoicePayment.Aria_Account__c=customer.Id;
        invoicePayment.Transaction_No__c='38309687';
        invoicePayment.Amount_Applied__c=1000.0;
        invoicePayment.Payment_date_time__c=system.today();
        invoicePayment.statement_no__c=199711714;
        invoicePayment.External_Name__c='25453448_38309687';
        invoicePayment.invoice_no__c=123456;
        invoicePayment.Faktura__c = faktura.Id;
        invoicePayment.Payment__c = payment1.Id;   
        insert invoicePayment;
        
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        subscription.Name = '123456-1';
        subscription.Order_Number__c = '894561';
        subscription.Service_Name__c = 'Blockbuster Klippekort (order # 6005887)';
        subscription.Faktura__c = faktura.id;
        subscriptionList.add(subscription);
        
        insert subscriptionList;
        
        insert transactionList;
        
        set<string> setAriaAccNumber = new set<string>();
        setAriaAccNumber.add(String.valueOf(customer1.Aria_Account_No__c));
        setAriaAccNumber.add(String.valueOf(customer.Aria_Account_No__c));
    BlockBusterDateTypeTitle bbtitle = new BlockBusterDateTypeTitle();
    BlockBusterDateTypeTitle.BlockBusterDateTypeTitleMethod(String.valueOf(customer1.Aria_Account_No__c));
    bbtitle.getTypeTitle(setAriaAccNumber);    
    String transBody = '{ "error_code": 0, "error_msg": "OK", "starting_record": null, "total_records": 8, "transaction_information": [ { "aria_event_no": 85517152, "transaction_date": "2014-12-08 07:27:02", "acct_no": 3648207, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446291, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 123456, "total_amount_applied": 99, "related_amount_applied": null, "update_date": "2014-12-08 07:27:04", "void_date": null, "fully_applied_date": "2014-12-08 07:27:04", "related_transaction": [ { "aria_event_no": 85517153, "transaction_date": "2014-12-08 07:27:04", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446291, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229438, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:27:04", "void_date": null, "fully_applied_date": "2014-12-08 07:27:04", "related_amount": 99 } ] }, { "aria_event_no": 85517153, "transaction_date": "2014-12-08 07:27:04", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446291, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229438, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:27:04", "void_date": null, "fully_applied_date": "2014-12-08 07:27:04", "related_transaction": [ { "aria_event_no": 85517152, "transaction_date": "2014-12-08 07:27:02", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446291, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 62395213, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:27:04", "void_date": null, "fully_applied_date": "2014-12-08 07:27:04", "related_amount": 99 } ] }, { "aria_event_no": 85517163, "transaction_date": "2014-12-08 07:28:03", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446341, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 123456, "total_amount_applied": 99, "related_amount_applied": null, "update_date": "2014-12-08 07:28:04", "void_date": null, "fully_applied_date": "2014-12-08 07:28:04", "related_transaction": [ { "aria_event_no": 85517170, "transaction_date": "2014-12-08 07:28:04", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446341, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229442, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:28:04", "void_date": null, "fully_applied_date": "2014-12-08 07:28:04", "related_amount": 99 } ] }, { "aria_event_no": 85517170, "transaction_date": "2014-12-08 07:28:04", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446341, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229442, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:28:04", "void_date": null, "fully_applied_date": "2014-12-08 07:28:04", "related_transaction": [ { "aria_event_no": 85517163, "transaction_date": "2014-12-08 07:28:03", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446341, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 123456, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:28:04", "void_date": null, "fully_applied_date": "2014-12-08 07:28:04", "related_amount": 99 } ] }, { "aria_event_no": 85517148, "transaction_date": "2014-12-08 07:26:22", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446275, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 62395211, "total_amount_applied": 99, "related_amount_applied": null, "update_date": "2014-12-08 07:26:24", "void_date": null, "fully_applied_date": "2014-12-08 07:26:24", "related_transaction": [ { "aria_event_no": 85517149, "transaction_date": "2014-12-08 07:26:24", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446275, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229436, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:24", "void_date": null, "fully_applied_date": "2014-12-08 07:26:24", "related_amount": 99 } ] }, { "aria_event_no": 85517149, "transaction_date": "2014-12-08 07:26:24", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446275, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229436, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:24", "void_date": null, "fully_applied_date": "2014-12-08 07:26:24", "related_transaction": [ { "aria_event_no": 85517148, "transaction_date": "2014-12-08 07:26:22", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446275, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 62395211, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:24", "void_date": null, "fully_applied_date": "2014-12-08 07:26:24", "related_amount": 99 } ] }, { "aria_event_no": 85517150, "transaction_date": "2014-12-08 07:26:38", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446283, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 62395212, "total_amount_applied": 99, "related_amount_applied": null, "update_date": "2014-12-08 07:26:39", "void_date": null, "fully_applied_date": "2014-12-08 07:26:39", "related_transaction": [ { "aria_event_no": 85517151, "transaction_date": "2014-12-08 07:26:39", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446283, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229437, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:39", "void_date": null, "fully_applied_date": "2014-12-08 07:26:39", "related_amount": 99 } ] }, { "aria_event_no": 85517151, "transaction_date": "2014-12-08 07:26:39", "acct_no": 16855365, "user_id": "867hdbn3", "client_acct_id": null, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446283, "transaction_type": "Electronic Payment", "transaction_type_no": 3, "is_charge_type": 0, "type_specific_id": 84229437, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:39", "void_date": null, "fully_applied_date": "2014-12-08 07:26:39", "related_transaction": [ { "aria_event_no": 85517150, "transaction_date": "2014-12-08 07:26:38", "acct_no": 16855365, "amount": 99, "currency_cd": "dkk", "aria_statement_no": 490446283, "transaction_type": "Invoice", "transaction_type_no": 1, "is_charge_type": 1, "type_specific_id": 62395212, "total_amount_applied": 99, "related_amount_applied": 99, "update_date": "2014-12-08 07:26:39", "void_date": null, "fully_applied_date": "2014-12-08 07:26:39", "related_amount": 99 } ] } ] }';
    bbtitle.parsetrans(transBody);
    String orderresponse = '{ "error_code": 0, "error_msg": "OK", "order_items": [ { "line_no": 1, "client_sku": "2800002", "label": "Blockbuster Klippekort", "alt_label": "Blockbuster Klippekort", "long_desc": "Blockbuster Klippekort", "units": 1, "unit_amount": 79.2, "line_amount": 79.2, "line_comments": null } ] }';
    Map<String,String>mapInvNoToType = new Map<String,String>();
    mapInvNoToType.put('123456',orderresponse);
    bbtitle.parseorder(mapInvNoToType, setAriaAccNumber);
    bbtitle.getNewdate(setAriaAccNumber);  
    BlockBusterDateTypeTitle.getRefundDetails(String.valueOf(account1.id));  
    //bbtitle.setdateTypeTitle('batch',setAriaAccNumber);
    Test.stopTest();
  }
  
  static testMethod void testBlockBusterGetTypeTitleBatchTest()
  {
    test.startTest();
      RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
       Account account = new Account(); 
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        
       Aria_Account__c customer = new Aria_Account__c();
        customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = 'ACTIVE';
        insert customer;
     
    // Test.setMock(Database.AllowsCallouts, new BlockBusterGetTypeTitleBatch());
        Faktura__c faktura = new Faktura__c();
        faktura.Name='25453448';
        faktura.Aria_Account__c=customer.Id;
        faktura.Customer__c=account.Id;
        faktura.Aria_Event_No__c='38309686';
        faktura.Datoforudskrift__c=system.today();
        faktura.Momspligtigt_bel_b__c=1000.0;
        faktura.Betalingsfrist__c=system.today();
        faktura.Fakturanummer__c='25453448';
        insert Faktura;
     
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        
        subscription.Faktura_line_no__c = '25453448-1';
        subscription.Name = '25453448-1';
        subscription.Service_Name__c = 'Blockbuster Leje (order # 5977405)';
        subscription.Amount__c =  23.20;
        subscription.Faktura__c = Faktura.id;
        subscriptionList.add(subscription);
       insert subscriptionList;
     
        
 
         Set <String> s =new Set<String>();
        s.add(String.valueOf(customer.Aria_Account_No__c));
        // bbtitle.setdateTypeTitle(setAriaAccNumber);
        //s.add('614052397');
                
      string Query = 'SELECT Invoice_Number__c,Order_Number__c FROM Invoice_Subscription__c LIMIT 1';
        BlockBusterGetTypeTitleBatch batchdetails = new BlockBusterGetTypeTitleBatch(s,false);
      Database.QueryLocator QueryLoc;
      Database.BatchableContext BatchCont;
      QueryLoc= batchdetails.start(BatchCont);
      HttpResponse res = new HttpResponse();
       
      //batchdetails.BlockBusterGetTypeTitleBatch('Select Faktura_line_no__c From Invoice_Subscription__c', s);
      ID batchprocessid = Database.executeBatch(batchdetails);
      sYSTEM.debug('######EXECUTE BATCH'+batchprocessid);
     /*  batchdetails.start(null);
      batchdetails.execute(BatchCont,subscriptionList);*/
  
      //batchdetails.finish(BatchCont);        
      test.StopTest();
  }
  
  public static testMethod void testBlockBusterCreateAriaAccts(){
    
    Test.startTest();
    RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'Blockbuster Customer Account'];  
        Account account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        Account account1 = new Account();                     
        account1.RecordTypeId =recordType1.Id;
        account1.Status_YK__c = 'Active';
        account1.FirstName = 'Test'; 
        account1.LastName = 'Test';
        account1.Invoice_Test__c = true;
        account1.Customer_response__c = 'Neutral omkring ændring';
        account1.Customer_No__c='981930'; 
        account1.Betaler_Id__c = '3648208';
        insert account1;
        
    Aria_Account__c customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = 'ACTIVE';
        insert customer;
        
        Aria_Account__c customer1 = new Aria_Account__c();
        customer1.Account__c  = account1.Id;
        customer1.Aria_Account_No__c=3648208;
        customer1.Name='3648207'; 
        customer1.Aria_Plan_Name__c='Temp';
        customer1.API_calls__c = 'Transaction Created';
        customer1.Regningsstatus__c = 'ACTIVE';
        insert customer1;
        
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
        
        List<Transaction__c> transactionList = new List<Transaction__c>();
        transactionList.add(transaction1);
        transactionList.add(transaction2);
        transactionList.add(transaction3);
        transactionList.add(transaction4);
        transactionList.add(transaction5);
        transactionList.add(transaction6);
        
        Faktura__c faktura = new Faktura__c();
        faktura.Aria_Account__c  = customer.Id ;
        faktura.Name = '123456';  
        faktura.Customer__c=account.Id;
        faktura.Fakturanummer__c ='123456';
        insert faktura;
        
        List<Faktura__c> fakturaList = new List<Faktura__c>();
        fakturaList.add(faktura);
        List<Faktura__c> invoiceList = new List<Faktura__c>();
        invoiceList.add(faktura);
        
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
        payment1.transaction_source_id__c = '123456';
        payment1.Credit_Reason__c = '';
        payment1.Comments__c = '';
        payment1.Amount__c = 1000.0;
        payment1.Payment_Date__c = system.today();
        insert payment1;
        
        Invoice_Payment__c invoicePayment = new Invoice_Payment__c();
        invoicePayment.Account__c = account.Id;
        invoicePayment.Aria_Account__c=customer.Id;
        invoicePayment.Transaction_No__c='38309687';
        invoicePayment.Amount_Applied__c=1000.0;
        invoicePayment.Payment_date_time__c=system.today();
        invoicePayment.statement_no__c=199711714;
        invoicePayment.External_Name__c='25453448_38309687';
        invoicePayment.invoice_no__c=123456;
        invoicePayment.Faktura__c = faktura.Id;
        invoicePayment.Payment__c = payment1.Id;   
        insert invoicePayment;
        
        List<Invoice_Subscription__c> subscriptionList = new List<Invoice_Subscription__c>();
        Invoice_Subscription__c subscription = new Invoice_Subscription__c();
        subscription.Name = '123456-1';
        subscription.Order_Number__c = '894561';
        subscription.Service_Name__c = 'Blockbuster Klippekort (order # 6005887)';
        subscription.Faktura__c = faktura.id;
        subscriptionList.add(subscription);
        
        insert subscriptionList;
        
        insert transactionList;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(account);
        BlockBusterCreateAriaAccts objCreateAccts = new BlockBusterCreateAriaAccts(standardController);
        objCreateAccts.createAriaAccts();
        String response = '{ "error_code": 0, "error_msg": "OK", "starting_record": null, "total_records": 1, "account_details": [ { "acct_no": 16518585, "senior_acct_no": null, "user_id": "cprar55q", "password": "aphp8qyb", "status_cd": 1, "plan_no": 11154471, "first_name": "Vidhya", "mi": null, "last_name": "Prabhu", "address_1": null, "address_2": null, "city": null, "locality": null, "postal_code": null, "country": "DK", "phone_npa": null, "phone_nxx": null, "phone_suffix": null, "phone_extension": null, "intl_phone": null, "alt_email": null, "client_acct_id": null, "promo_cd": null, "resp_level_cd": 1, "pay_method": 13, "created": "2014-11-12 12:44:27", "last_updated": "2014-11-12 12:44:29", "client_1": null, "company_name": null, "current_billing_info": [ { "billing_first_name": "Vidhya", "billing_middle_initial": null, "billing_last_name": "Prabhu", "billing_address1": null, "billing_address2": null, "billing_city": null, "billing_state": null, "billing_locality": null, "billing_zip": null, "billing_country": "DK", "billing_phone_npa": null, "billing_phone_nxx": null, "billing_phone_suffix": null, "billing_phone_extension": null, "billing_intl_phone": null, "billing_email": null, "billing_pay_method": 13, "billing_cc_expire_mm": null, "billing_cc_expire_yyyy": null, "billing_bank_routing_num": null } ], "plan_name": "Blockbuster", "state_prov": null, "country_english": "Denmark", "promo_name": null, "no_provision_ind": 0, "bill_action_cd": 1, "status_name": "ACTIVE", "acct_balance": 0, "supp_field": [ { "supp_field_name": "Juridisk", "supp_field_value": "628276771" }, { "supp_field_name": "Betaler", "supp_field_value": "628276771" } ], "bill_day": 1, "supp_plan": [ ] } ] }';
        objCreateAccts.mapAccNoToAcc.put(account.Customer_No__c,account);
        objCreateAccts.parseResponse(response, objCreateAccts.mapAccNoToAcc);
        objCreateAccts.listBetaler.add(customer);
        objCreateAccts.getfurtheritems();
        objCreateAccts.getBBdatetime();
        //objCreateAccts.getRefundDetails();
        objCreateAccts.initializeRecordTypes();
        Test.stopTest();
  }
  
  /*
  public static testMethod void testBlockBusterRefundDetailsBatch()
  {
    Test.startTest();
    RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'Blockbuster Customer Account'];  
        Account account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        
        Aria_Account__c customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = '';
        //customer.Faktureret1__c = Date.today();
        //customer.Indbetalt__c = Date.today();
        insert customer;
        
        Faktura__c faktura = new Faktura__c();
        faktura.Name='25453448';
        faktura.Aria_Account__c=customer.Id;
        faktura.Customer__c=account.Id;
        faktura.Aria_Event_No__c='38309686';
        faktura.Datoforudskrift__c=system.today();
        faktura.Momspligtigt_bel_b__c=1000.0;
        faktura.Betalingsfrist__c=system.today();
        faktura.Fakturanummer__c='25453448';
        insert Faktura;
        
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
        
        string Query = 'SELECT Name ,ID, from Aria_Account__c LIMIT 1';
      BlockBusterRefundDetailsBatch batchdetails = new BlockBusterRefundDetailsBatch();
      /* Database.QueryLocator QueryLoc;
      Database.BatchableContext BatchCont;
      QueryLoc= batchdetails.start(BatchCont);
      HttpResponse res = new HttpResponse();*/
     /* //batchdetails.runTestMethod = true;  
      //batchdetails.BlockBusterGetTypeTitleBatch('Select Faktura_line_no__c From Invoice_Subscription__c', s);
      ID batchprocessid = Database.executeBatch(batchdetails,1);
      sYSTEM.debug('######EXECUTE BATCH testBlockBusterRefundDetailsBatch****** '+batchprocessid);
        
    Test.stopTest();
  }*/
  
}