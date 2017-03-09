/***********************************************************************************
************************************************************************************

* @class: CarrieCommonUtil
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: This is a utility class. 

************************************************************************************
***********************************************************************************/
public class CarrieCommonUtil {
    private static String apiException = Label.AriaApiException;
    public CarrieCommonUtil(){
    }
    
    /**
    * @description: This method is used to fetch the account details .
    * @param: Id of the customer.
    * @return: account.
    */
    public static Aria_Account__c getAccountDetails(Id accountId) {
        Aria_Account__c account = [select Id, Aria_Account_No__c, Name,Account__c,Account__r.Customer_No__c, Aria_Pay_Method__c from Aria_Account__c where Id =: accountId];
        return account;
    }

    /**
    * @description: This method is used to validate the Configuration.
    * @param: Aria_API_Configuration__c.
    * @return: Aria_API_Configuration__c.
    */
    public static Aria_API_Configuration__c validateAPIConfiguration(Aria_API_Configuration__c config){
        config = AriaUtil.getLatestConfig();
        if(config == null) {
            //throw new AriaAPIException(apiException)  ;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,apiException));              
        }
        return config;
    }
    
    /**
    * @description: This method is used to show the text based on Transaction Type .
    * @param:  Transaction type .
    * @return: Sting value of the transaction type .
    */
    public static final Map<Long,String> TRANS_METHOD_MAP = new Map<Long,String>   
     {
        1 => 'Invoice',
        2 => 'Check',
        3 => 'Electronic Payment',
        4 => 'Balance transfer to account',
        5 => 'Balance ransfer from account',
        6 => 'Write Off',
        8 => 'Refund-related Reversal',
        10 => 'Credit',
        12 => 'Electronic refund disbursement',
        13 => 'Refund amount is payed by check', 
        11 => 'Overpayment credit is not applicable',
        14 => 'External charge',
        15 => 'A finance charge',
        16 => 'A previously voided charge transaction re-enabled',
        17 => 'A previously voided payment transaction re-enabled',
        18 => 'A total of amounts due after all charges and payments have been applied to an account.',
        -1 => 'A reversal of a previously generated invoices ', 
        -2 => 'A reversal of a previously applied payment via paper check.',
        -3 => 'Voided electronic Payment',
        -4 => 'Voided balance transfer to account',
        -5 => 'A reversal of transfer of responsibility for payment of a balance from another account',
        -6 => 'A reversal of a charge of an amount to expense or loss in order to reduce the value of earnings.',
        -7 => 'A reversal of a reduction of the outstanding account balance without receipt of payment for activity external to Aria Systems.',
        -8 => 'A reversal of a return of monies to the same form of payment used to pay for the original charge.',
        -10 => 'A reversal of a reduction of the outstanding account balance without receipt of payment.',    
        -11 => 'voided credit from overpayment is not applicable',
        -12 => 'A reversal of application of return of payment via credit card or electronic check.',
        -13 => 'A reversal of application of return of payment via paper check is not applicable.',
        -14 => 'Voided external charge',
        -15 => 'A reversal of a finance charge.',
        -16 => 'Reversed reinstated charge transaction',
        -17 => 'Voided reinstated payment transaction',
        -18 => 'A reversal of total of amounts due after all charges and payments have been applied to an account.',
        -19 => 'Voided 3rd party payment.',
        -20 => 'Voided 3rd party payment refund'
    };
    /*public static String getTransactionType(Long typeStr){
        String strType = String.valueOf(typeStr);
        if (typeStr == 1) strType  = 'Invoice';
        else if (typeStr == 2) strType  = 'Check';
        else if (typeStr == 3) strType  = 'Electronic Payment';
        else if (typeStr == 4) strType  = 'Balance transfer to account';
        else if (typeStr == 5) strType  = 'Transfer from account';
        else if (typeStr == 6) strType  = 'Write Off';
        else if (typeStr == 8) strType  = 'Refund-related Reversal';
        else if (typeStr == 10) strType = 'Credit';
        else if (typeStr == 12) strType = 'Electronic refund disbursement';
        else if (typeStr == 13) strType = 'Refund amount is payed by check'; 
        else if (typeStr == 11) strType = 'Overpayment credit is not applicable';
        else if (typeStr == 14) strType = 'External charge';
        else if (typeStr == 15) strType = 'A finance charge';
        else if (typeStr == 16) strType = 'A previously voided charge transaction re-enabled';
        else if (typeStr == 17) strType = 'A previously voided payment transaction re-enabled';
        else if (typeStr == 18) strType = 'A total of amounts due after all charges and payments have been applied to an account.';
        else if (typeStr == -1) strType  = 'A reversal of a previously generated invoices '; 
        else if (typeStr == -2) strType  = 'A reversal of a previously applied payment via paper check.';
        else if (typeStr == -3) strType  = 'Voided electronic Payment';
        else if (typeStr == -4) strType  = 'Voided balance transfer to account';
        else if (typeStr == -5) strType  = 'A reversal of transfer of responsibility for payment of a balance from another account';
        else if (typeStr == -6) strType  = 'A reversal of a charge of an amount to expense or loss in order to reduce the value of earnings.';
        else if (typeStr == -7) strType  = 'A reversal of a reduction of the outstanding account balance without receipt of payment for activity external to Aria Systems.';
        else if (typeStr == -8) strType  = 'A reversal of a return of monies to the same form of payment used to pay for the original charge.';
        else  if (typeStr == -10) strType = 'A reversal of a reduction of the outstanding account balance without receipt of payment.';    
        else if (typeStr == -11) strType = 'voided credit from overpayment is not applicable';
        else if (typeStr == -12) strType = 'A reversal of application of return of payment via credit card or electronic check.';
        else if (typeStr == -13) strType = 'A reversal of application of return of payment via paper check is not applicable.';
        else if (typeStr == -14) strType = 'Voided external charge';
        else if (typeStr == -15) strType = 'A reversal of a finance charge.';
        else if (typeStr == -16) strType = 'Reversed reinstated charge transaction';
        else if (typeStr == -17) strType = 'Voided reinstated payment transaction';
        else if (typeStr == -18) strType = 'A reversal of total of amounts due after all charges and payments have been applied to an account.';
        else if (typeStr == -19) strType = 'Voided 3rd party payment.';
        else if (typeStr == -20) strType = 'Voided 3rd party payment refund';
        return strType;
    }*/
    
    /**
    * @description: This method is used to show the text based on Pay method .
    * @param:  Pay method .
    * @return: Sting value of the Pay method .
    */
    public static final Map<Long,String> PAY_METHOD_MAP = new Map<Long,String>{
         -1 => 'External Payment',
         0 => 'Other',
         1 => 'Credit card ', 
         2 => 'Electronic Check (ACH)',
         3 => 'Pre-paid',
         4 => 'Net terms 30',
         5 => 'Net terms 10',
         6 => 'Net terms 15',
         7 => 'Net terms 60',
         8 => 'Click&Buy',
         9 => 'Net Terms 0',
         10 => 'PayByCash',
         11 => 'PayPal Express Checkout',
         12 => 'Net Terms 45',
         13 => 'Tokenized Credit Card', 
         14 => 'Net Terms 25',
         15 => 'Net Terms 35',
         16 => 'Net Terms 75',
         17 => 'Net Terms 90',
         18 => 'Net Terms 120',
         20 => 'NETS'
    };
    /* public static String getPaymentMethod(Long intPay){
        String strPay = String.valueOf(intPay);
        if (intPay == -1) strPay  = 'External Payment';
        else if (intPay == 0) strPay  = 'Other';
        else if (intPay == 1) strPay  = 'Credit card '; 
        else if (intPay == 2) strPay  = 'Electronic Check (ACH)';
        else if (intPay == 3) strPay  = 'Pre-paid';
        else if (intPay == 4) strPay  = 'Net terms 30';
        else if (intPay == 5) strPay  = 'Net terms 10';
        else if (intPay == 6) strPay  = 'Net terms 15';
        else if (intPay == 7) strPay  = 'Net terms 60';
        else if (intPay == 8) strPay  = 'Click&Buy';
        else if (intPay == 9) strPay  = 'Net Terms 0';
        else if (intPay == 10) strPay = 'PayByCash';
        else if (intPay == 11) strPay = 'PayPal Express Checkout';
        else if (intPay == 12) strPay = 'Net Terms 45';
        else if (intPay == 13) strPay = 'Tokenized Credit Card'; 
        else if (intPay == 14) strPay = 'Net Terms 25';
        else if (intPay == 15) strPay = 'Net Terms 35';
        else if (intPay == 16) strPay = 'Net Terms 75';
        else if (intPay == 17) strPay = 'Net Terms 90';
        else if (intPay == 18) strPay = 'Net Terms 120';
        return strPay;
    }*/
    /**
    * @description: This method is used to show the Aria Credit reason code 
    *               based on Carrie Dummy Reason Code .
    * @param:  Dummy Credit Reason Code .
    * @return: String value of the Aria Credit Reason Code .
    * @purpose: To maintain different credit reason code in PreProd
    *            and Production ( CARRIE-1191 )
    */
    public static final Map<Long,String> CREDIT_REASON_MAP = new Map<Long,String>{
        // Below codes are for PreProd Environment
        /* 1 => '4950261',    // Service Credit Reason Code
         2 => '4950262',     // Cash Credit Reason Code
         3 => '4950263'    // Tax Reson Code */
         // Below codes are for Production Environment
         1 => '3750262',    // Service Credit Reason Code
         2 => '3750263',     // Cash Credit Reason Code
         3 => '3750261'    // Tax Reson Code 
    };  
}