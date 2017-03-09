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

* @class: CarrieCustomerBillingControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieCustomerBillingController.

************************************************************************************ 
***********************************************************************************/
@isTest
private class CarrieCustomerBillingControllerTestClass {
    
    /**
    * @description: This method is used to test general methods of CarrieCustomerBillingController
    */
    static testMethod void testCustomerBilling() {
        User user = CarrieTestUtil.insertUser();
        Aria_Account__c customer  = CarrieTestUtil.insertAccount(); 
        
        system.runAs(user){
            ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
            CarrieCustomerBillingController customerBilling =new CarrieCustomerBillingController(standardController);
            customerBilling.youbioPaymentList = new List<Payment__c>();
    		customerBilling.youbioAppCredList = new List<Applied_Credit__c>();
    		customerBilling.creditpymList = new List<Payment__c>();
            customerBilling.transClosingBal = 0.0;
            customerBilling.billingResponse='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":1,"account_details":[{"acct_no":3648207,"senior_acct_no":null,"user_id":"poonam","password":"poonamthergaonka","status_cd":1,"plan_no":10263511,"first_name":"Poonam","mi":null,"last_name":"Thergaonkar","address_1":"Block AGodrej and Boyce Compound","address_2":"LBS MargVikhroliWest","city":"Mumbai","locality":null,"postal_code":"400079","country":"IN","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":"98464548787a","alt_email":"poonam.thergaonkar@capgemini.com","client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2012-06-18 21:26:00","last_updated":"2012-09-26 01:33:37","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"Poonam","billing_middle_initial":null,"billing_last_name":"Thergaonkar","billing_address1":"Block AGodrej and Boyce Compound","billing_address2":"LBS MargVikhroliWest","billing_city":"Mumbai","billing_state":null,"billing_locality":null,"billing_zip":"400079","billing_country":"IN","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":"98464548787a","billing_email":"poonam.thergaonkar@capgemini.com","billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"DTV","state_prov":null,"country_english":"India","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"613702384"}],"bill_day":18,"supp_plan":[{"supp_plan_no":10532741,"supp_plan_name":"Telefoni Fast pris"},{"supp_plan_no":10532745,"supp_plan_name":"Telefoni Fastpris"}]}]}'; /*FIX FOR SUPP PLAN */
            customerBilling.invoiceResponse='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":4,"invoice_details":[{"invoice_no":20088399,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-06-19 05:37:50","due_date":"2012-07-19 05:37:50","paid_date":"2012-06-19 05:37:50","notify_date":"2012-06-19 05:42:52","from_date":"2012-06-18 00:00:00","to_date":"2012-09-17 00:00:00","currency_cd":"dkk","balance_forward":null,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-06-19 05:37:50","transaction_type":null,"user_id":"poonam","aria_event_no":28209543,"aria_statement_no":153119250,"acct_statement_seq_str":"153119250","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":0,"comments":"Recurring Fee","plan_no":10263511,"plan_name":"DTV","service_no":102,"service_name":"Recurring Fee","ledger_code":"Setup Fees COA Code","coa_id":1001,"coa_description":"Setup Fees COA Code","usage_units":1,"usage_rate":0,"usage_type_no":null,"start_date":"2012-06-18 00:00:00","end_date":"2012-09-17 00:00:00"}]},{"invoice_no":22664771,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-09-05 01:35:29","due_date":"2012-10-05 01:35:29","paid_date":"2012-09-05 01:35:30","notify_date":"2012-09-05 01:40:50","from_date":"2012-09-18 00:00:00","to_date":"2012-12-17 00:00:00","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-09-05 01:35:29","transaction_type":null,"user_id":"poonam","aria_event_no":32417485,"aria_statement_no":175807791,"acct_statement_seq_str":"175807791","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":0,"comments":"Recurring Fee","plan_no":10263511,"plan_name":"DTV","service_no":102,"service_name":"Recurring Fee","ledger_code":"Setup Fees COA Code","coa_id":1001,"coa_description":"Setup Fees COA Code","usage_units":1,"usage_rate":0,"usage_type_no":null,"start_date":"2012-09-18 00:00:00","end_date":"2012-12-17 00:00:00"}]},{"invoice_no":23993077,"acct_no":3648207,"debit":0,"credit":0,"bill_date":"2012-09-26 01:33:36","due_date":"2012-10-26 01:33:36","paid_date":"2012-09-26 01:33:36","notify_date":null,"from_date":null,"to_date":null,"currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":"4942283","additional_comments":null,"last_updated":"2012-09-26 01:33:36","transaction_type":null,"user_id":"poonam","aria_event_no":35067081,"aria_statement_no":187794615,"acct_statement_seq_str":"187794615","second_acct_statement_seq_str":null,"invoice_line":null},{"invoice_no":25453448,"acct_no":3648207,"debit":1000,"credit":1000,"bill_date":"2012-11-16 17:57:52","due_date":"2012-12-16 17:57:52","paid_date":"2012-11-16 17:58:16","notify_date":"2012-11-16 17:57:52","from_date":"2012-11-16 17:57:51","to_date":"2012-11-16 17:57:51","currency_cd":"dkk","balance_forward":0,"total_due":0,"comments":null,"additional_comments":"Comments from order no. 3634612: \"\"","last_updated":"2012-11-16 17:57:52","transaction_type":null,"user_id":"poonam","aria_event_no":38309686,"aria_statement_no":199711714,"acct_statement_seq_str":"199711714","second_acct_statement_seq_str":null,"invoice_line":[{"client_no":4942283,"line_item_no":1,"amount":1000,"comments":"Activation Fee (order # 3634612)","plan_no":null,"plan_name":null,"service_no":10131849,"service_name":"Actrivation Fee","ledger_code":"1001","coa_id":10090603,"coa_description":"1001","usage_units":1,"usage_rate":1000,"usage_type_no":null,"start_date":"2012-11-16 17:57:51","end_date":"2012-11-16 17:57:51"}]}]}';
            customerBilling.paymentResponse='{"history":[{"transaction_id":38309600,"transaction_type":2,"transaction_desc":"Credit #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8260266,"transaction_ref_code":"12221"},{"transaction_id":38309687,"transaction_type":2,"transaction_desc":"Check #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8263266,"transaction_ref_code":"12221"},{"transaction_id":38309686,"transaction_type":1,"transaction_desc":"Invoice #25453448","transaction_amount":1000,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":199711714,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":"Comments from order no. 3634612: \"\"","transaction_source_id":25453448,"transaction_ref_code":null},{"transaction_id":35067081,"transaction_type":1,"transaction_desc":"Invoice #23993077","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-26","transaction_void_date":null,"statement_no":187794615,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":23993077,"transaction_ref_code":null},{"transaction_id":32417485,"transaction_type":1,"transaction_desc":"Invoice #22664771","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-05","transaction_void_date":null,"statement_no":175807791,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":22664771,"transaction_ref_code":null},{"transaction_id":28209543,"transaction_type":1,"transaction_desc":"Invoice #20088399","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-06-19","transaction_void_date":null,"statement_no":153119250,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":20088399,"transaction_ref_code":null}],"error_code":0,"error_msg":"OK"}';
            customerBilling.invoicePaymentResponse ='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":5,"transaction_information":[{"aria_event_no":28209543,"transaction_date":"2012-06-19 05:37:50","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":153119250,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":20088399,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-06-19 05:41:57","void_date":null,"fully_applied_date":"2012-06-19 05:37:50","related_transaction":[]},{"aria_event_no":32417485,"transaction_date":"2012-09-05 01:35:30","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":175807791,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":22664771,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-05 01:39:20","void_date":null,"fully_applied_date":"2012-09-05 01:35:30","related_transaction":[]},{"aria_event_no":35067081,"transaction_date":"2012-09-26 01:33:36","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":0,"currency_cd":"dkk","aria_statement_no":187794615,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":23993077,"total_amount_applied":0,"related_amount_applied":null,"update_date":"2012-09-26 01:38:13","void_date":null,"fully_applied_date":"2012-09-26 01:33:36","related_transaction":[]},{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":null,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]},{"aria_event_no":38309600,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Cash","transaction_type_no":10,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{}]},{"aria_event_no":38309687,"transaction_date":"2012-11-16 17:58:16","acct_no":3648207,"user_id":"poonam","client_acct_id":null,"amount":1000,"currency_cd":"dkk","aria_statement_no":0,"transaction_type":"Check","transaction_type_no":2,"is_charge_type":0,"type_specific_id":8263266,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_transaction":[{"aria_event_no":38309686,"transaction_date":"2012-11-16 17:57:52","acct_no":3648207,"amount":1000,"currency_cd":"dkk","aria_statement_no":199711714,"transaction_type":"Invoice","transaction_type_no":1,"is_charge_type":1,"type_specific_id":25453448,"total_amount_applied":1000,"related_amount_applied":1000,"update_date":"2012-11-16 17:58:16","void_date":null,"fully_applied_date":"2012-11-16 17:58:16","related_amount":1000}]}]}';
            customerBilling.serviceCreditResponse='{"error_code":0,"error_msg":"OK","unapplied_service_credits":null}';
            customerBilling.getSelectAccounts();
            customerBilling.initializeObjectclass(); 
            customerBilling.getPaymentInvoiceDetails();
            customerBilling.billingDMLExecution();
            customerBilling.getYouBioPayments();
            customerBilling.getYouBioCredits();
            customerBilling.redirectCreateCredit();
            customerBilling.redirectUsage();
            customerBilling.redirectTransaction();//CARRIE-752
            customerBilling.callToCasper();
            customerBilling.getbillingDetails();
            
            //start carrie-1010
            Faktura__c invoice = new Faktura__c();
            invoice.Customer__c = customer.Account__c;
            invoice.Aria_Account__c = customer.Id;
            invoice.Fakturanummer__c = '20088399';
            invoice.Name = '20088399';
            invoice.Aria_Event_No__c='28209543';
            invoice.Momspligtigt_bel_b__c = 100;
            insert invoice;

            Payment__c pay = new Payment__c();
            pay.Customer__c = customer.Account__c;
	        pay.Aria_Account__c = customer.Id;
	        pay.hasInvoice__c = '';
	        pay.Name = '38309600';
	        pay.transaction_source_id__c='8260266';
	        pay.Aria_Event_No__c = '38309600';
	        pay.Payment_No__c  = '38309600';
	        pay.Appplied_Amount__c =500;
	        pay.Amount__c = 1000;
	        pay.Payment_Type__c='Credit';
	        insert pay;
            Payment_Invoice__c pi = new Payment_Invoice__c();            
            pi.External_Name__c = '89674-98765';
            pi.CommentsLong__c = 'asdsd sdfdsfsd fsdfsd';
            pi.Account__c = customer.Account__c;
            pi.Aria_Account__c = customer.Id;
            pi.Amount_Applied__c = 10;
            pi.Faktura__r = new Faktura__c(Fakturanummer__c = '20088399');
            pi.Payment__r = new Payment__c(Payment_No__c = '38309600');
            insert pi;
            //end carrie-1010
            customerBilling.deletePaymentCredits();
            //customerBilling.callToCasper();
            customerBilling.deleteCredits();
            customerBilling.deleteDummyInvoice();
            customerBilling.deleteDummyPayment(); 
            customerBilling.checkDummyInvoice_Payment();
            //customerBilling.billingYouBioDMLExecution(); 
            //customerBilling.getYouBioRefunds(); //Refund
            customerBilling.getTelefonyPayments(); //CARRIE-789 
            //start carrie-1010
            Unapplied_Credit__c un = new Unapplied_Credit__c();
        un.Name='4567888';
        un.Unapplied_Amount1__c=20;
        un.Aria_Account__c=customer.Id;
        un.Customer__c=customer.Account__c;
        un.Amount__c = 30;
        un.External_Name__c ='4567888-987765';
        un.Credit_type__c = 'Cash';
        insert un;
        Unapplied_Credit__c un1 = new Unapplied_Credit__c();
        un1.Name='4567889';
        un1.Unapplied_Amount1__c=30;
        un1.Aria_Account__c=customer.Id;
        un1.Customer__c=customer.Account__c;
        un1.Amount__c = 40;
        un1.Credit_type__c = 'Cash';
        un1.External_Name__c='4567889-987745';
        insert un1;
        
        Applied_Credit__c ap = new Applied_Credit__c();
        ap.Amount__c = 30;
        ap.name = '4567888';
        ap.External_Name__c = '4567888-987765';
        ap.Faktura__r = new Faktura__c(Fakturanummer__c = '00000'); 
        ap.Credit_Bel_b__c= 30;
        ap.Account__c =customer.Account__c;
        ap.Aria_Account__c =customer.Id;
        insert ap;
        Applied_Credit__c ap1 = new Applied_Credit__c();
        ap1.Amount__c = 20;
        ap.External_Name__c = '4567889-987745';
        ap1.name = '4567889';
        ap1.Faktura__r = new Faktura__c(Fakturanummer__c = '00000'); 
        ap1.Credit_Bel_b__c= 40;
        ap1.Account__c =customer.Account__c;
        ap1.Aria_Account__c =customer.Id;
        insert ap1;
        customerBilling.deleteOtherUnaapliedCredits(); 
        // end carrie-1010
        
        }
    }
    static testMethod void testCustomerBilling1(){
         
           //ref = customerBilling.callToCasper();
            RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account cust = new Account();
        cust.RecordTypeId =recordType.Id;
        cust.Status_YK__c = 'Active';
        cust.FirstName = 'Temp1'; //SPOC-1396
        cust.LastName = 'Temp';
        cust.Invoice_Test__c = true;
        cust.Customer_response__c = 'Neutral omkring ændring';
        cust.Customer_No__c='991910';  
        insert cust;
         
        
        Aria_Account__c ariaCustomer = new Aria_Account__c();
        ariaCustomer.Account__c  = cust.Id;
        ariaCustomer.Aria_Account_No__c=3648217;
        ariaCustomer.Name='3648217'; 
        ariaCustomer.Aria_Plan_Name__c='YouBio';
        insert ariaCustomer;
            
         Aria_Account__c ariaCustomer1 = new Aria_Account__c();
        ariaCustomer1.Account__c  = cust.Id;
        ariaCustomer1.Aria_Account_No__c=3675217;
        ariaCustomer1.Name='3657617'; 
        ariaCustomer1.Aria_Plan_Name__c='YouSee';
        insert ariaCustomer1;
            
        Unapplied_Credit__c unCredit = new Unapplied_Credit__c();
         unCredit.Amount__c = 7.47;
         unCredit.Aria_Account__c = ariaCustomer1.Id;
         unCredit.commentsLong__c = 'Telefoni Forbrug';
         unCredit.Comments__c = 'Telefoni Forbrug';
         //unCredit.Credit_Reason__c = 'New Service Plan Pro-Ration';
         unCredit.Credit_type__c = 'Service';
         unCredit.Customer__c = cust.Id;
         unCredit.Date__c = Date.today();
         //unCredit.External_Name__c = '45571908';
         unCredit.Name = '13925668';
         unCredit.Unapplied_Amount1__c = 5.6;
         //unCredit.Unapplied__c = 5.6;
         insert unCredit;
         Faktura__c invoice1 = new Faktura__c();
            invoice1.Customer__c = cust.Id;
            invoice1.Aria_Account__c = ariaCustomer1.Id;
            invoice1.Fakturanummer__c = '20088567';
            invoice1.Name = '20088399';
            invoice1.Aria_Event_No__c='28209543';
            invoice1.Momspligtigt_bel_b__c = 100;
            insert invoice1; 
        
            Applied_Credit__c apCredit = new Applied_Credit__c();
            apCredit.Name = '13925668';
            apCredit.Account__c = cust.Id;
            apCredit.Amount__c = 2.0;
            apCredit.Applied_Against__c = 'Invoice';
            apCredit.Aria_Account__c = ariaCustomer1.Id;
            apCredit.CommentsLong__c = 'Fejl i abonnement';
            apCredit.Comments__c = 'test';
            apCredit.Credit_Bel_b__c = 2.0;
            apCredit.Credit_Reason__c = 'test';
            apCredit.credit_type__c = 'Cash';
            apCredit.Date__c = Date.today();
            apCredit.Faktura__c  = invoice1.Id;
            insert apCredit;
        
       
            Transaction__c  tra = new Transaction__c();
            tra.Aria_Account__c =  ariaCustomer1.Id;
            tra.Charge_Amt__c = 5.6;
            tra.Credit_Amt__c = 2.5;
            tra.Customer__c = cust.Id;
            tra.Description__c = 'test';
            tra.Name = '13925668';
            tra.Transaction_Type__c = 1.0;
            tra.Transaction_no__c = '13925668';
            tra.Transaction_Source_ID__c = '19837387';
            tra.Posting_Date__c = Date.today();
            insert tra;
        
          ApexPages.StandardController standardController1 = new ApexPages.StandardController(ariaCustomer);
            CarrieCustomerBillingController customerBilling1 =new CarrieCustomerBillingController(standardController1);
            customerBilling1.checkDummyInvoice_Payment();
            
              ApexPages.StandardController standardController3 = new ApexPages.StandardController(ariaCustomer1);
            CarrieCustomerBillingController customerBilling3 =new CarrieCustomerBillingController(standardController3);
            customerBilling3.oppty = ariaCustomer1;
            customerBilling3.getSelectAccounts();
            customerBilling3.oppty = ariaCustomer1;
            List<Unapplied_Credit__c> liunCredit = new List<Unapplied_Credit__c>();
            liunCredit.add(unCredit);
            customerBilling3.creditList = liunCredit;
            customerBilling3.deleteServiceCredits();
            customerBilling3.oppty = null;
            customerBilling3.getTelephonyInvoice();
            customerBilling3.getTelefonyPayments();
             customerBilling3.getYouBioPayments();
            customerBilling3.getYouBioCredits();
            customerBilling3.getPaymentInvoiceDetails();
            customerBilling3.showForbrug = 'false';
            customerBilling3.oppty = ariaCustomer1;
            customerBilling3.getBillingDetails();
            List<String> str = new List<String>();
            str.add('13925668');
            customerBilling3.updateVoidedCashCredits(str);
            List<String> voidedInvoiceIds = new List<String>();
            voidedInvoiceIds.add('20088567');
            customerBilling3.getPaymentInvoiceDetails();
            customerBilling3.updateVoidedInvoices(voidedInvoiceIds);
            customerBilling3.calculateSaldofromTransaction();
            customerBilling3.checkDummyInvoice_Payment();
            customerBilling3.oppty = ariaCustomer1;
            //customerBilling3.paymentResponse='{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":8,"history":[{"transaction_id":38309600,"transaction_type":2,"transaction_desc":"Credit #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8260266,"transaction_ref_code":"12221"},{"transaction_id":38309687,"transaction_type":2,"transaction_desc":"Check #8263266","transaction_amount":-1000,"transaction_applied_amount":1000,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":0,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":8263266,"transaction_ref_code":"12221"},{"transaction_id":38309686,"transaction_type":1,"transaction_desc":"Invoice #25453448","transaction_amount":1000,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-11-16","transaction_void_date":null,"statement_no":199711714,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":"Comments from order no. 3634612: \"\"","transaction_source_id":25453448,"transaction_ref_code":null},{"transaction_id":35067081,"transaction_type":1,"transaction_desc":"Invoice #23993077","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-26","transaction_void_date":null,"statement_no":187794615,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":23993077,"transaction_ref_code":null},{"transaction_id":32417485,"transaction_type":1,"transaction_desc":"Invoice #22664771","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-09-05","transaction_void_date":null,"statement_no":175807791,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":22664771,"transaction_ref_code":null},{"transaction_id":28209543,"transaction_type":1,"transaction_desc":"Invoice #20088399","transaction_amount":0,"transaction_applied_amount":null,"transaction_currency":"dkk","transaction_create_date":"2012-06-19","transaction_void_date":null,"statement_no":153119250,"transaction_void_reason":null,"client_receipt_id":null,"transaction_comments":null,"transaction_source_id":20088399,"transaction_ref_code":null}]}';
            //customerBilling3.getPaymentInvoiceDetails();
           /* Transaction__c  tra1 = new Transaction__c();
            tra1.Aria_Account__c =  customer.Id;
            tra1.Charge_Amt__c = 5.6;
            tra1.Credit_Amt__c = 2.5;
            tra1.Customer__c = customer.Account__c;
            tra1.Description__c = 'test';
            tra1.Name = '13921324';
            tra1.Transaction_Type__c = 1.0;
            tra1.Transaction_no__c = '46575668';
            tra1.Transaction_Source_ID__c = '19837853';
            tra1.Posting_Date__c = Date.today();
            insert tra1;*/
            //customerBilling3.oppty = null;
            //customerBilling3.oppty = customer;
            customerBilling3.billingDMLExecution();
        
    }
    // Test class for CarrieInvoicePaymentWrapper
   static testMethod void CarrieInvoicePaymentWrapper_Test(){
        
        CarrieInvoicePaymentWrapper obj = new CarrieInvoicePaymentWrapper();
        obj.defaultInvoice = new Map<String, String>();
        obj.defaultInvoice.put('test','test');
        obj.otherInvoice = new Map<String, String>();
        obj.otherInvoice.put('test','test');
        obj.transdate = new Map<String, String>();
        obj.transdate.put('test','test');
        obj.defaultInvoiceObjects = new Map<String, Invoice_Payment__c>();
        obj.defaultInvoiceObjects.put('test',new Invoice_Payment__c());
        obj.deleteVoidedInvoice = new List<Invoice_Payment__c>();
        obj.deleteVoidedInvoice.add(new Invoice_Payment__c());
        obj.deleteVoidedInvoicePayment = new List<Payment_Invoice__c>();
        obj.deleteVoidedInvoicePayment.add(new Payment_Invoice__c());
        obj.InvoicePaymentMap = new Map<String,List<Payment__c>>();
        List<Payment__c> test = new  List<Payment__c>();
        test.add(new Payment__c());
		obj.InvoicePaymentMap.put('test',test);
    }
    
    
    
}