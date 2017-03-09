/***********************************************************************************
************************************************************************************

* @class: CarrieParsePaymentInfo
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used  as wrapper class for constructing object from the json response for carriepaymentcontroller.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieParsePaymentInfo {
    public Long transaction_id;
    public Long transaction_type;
    public Long statement_no;
    public Long transaction_source_id;
    public String transaction_ref_code;
    public Double transaction_amount;
    public Double transaction_applied_amount;
    public String transaction_desc;
    public String transaction_currency;
    public String transaction_create_date;
    public String transaction_void_date;
    public String transaction_void_reason;
    public String client_receipt_id;
    public String transaction_comments;
    public String credit_reason_code_description;//Carrie-657 
    public String csr_comments; //Carrie-657 
    
    Public Long seq_statement_id;
    //Refund
    //Start
   /* public Long refund_transaction_id;
    public Double refund_amount;
    public Date create_date;
    public String reason_code;
    public String reason_label;
    public String reason_description;
    public String ref_payment_transaction_id;
    public String create_user; */
    //End
    
    public CarrieParsePaymentInfo(Long transaction_id,Long transaction_type,Long statement_no,Long transaction_source_id,Double transaction_amount,Double transaction_applied_amount,String transaction_desc, String transaction_currency, String transaction_create_date, String transaction_void_date, String transaction_void_reason, String client_receipt_id,String transaction_comments,String credit_reason_code_description, String csr_comments,String transaction_ref_code,Long seq_statement_id){ //,Long refund_transaction_id,Double refund_amount,Date create_date,String reason_code,String reason_label,String reason_description,String ref_payment_transaction_id,String create_user){
        this.client_receipt_id = client_receipt_id;
        this.statement_no = statement_no;
        this.transaction_amount = transaction_amount; 
        this.transaction_applied_amount = transaction_applied_amount;
        this.transaction_comments = transaction_comments;
        this.transaction_create_date = transaction_create_date;
        this.transaction_currency = transaction_currency;
        this.transaction_desc = transaction_desc;
        this.transaction_id = transaction_id;
        this.transaction_ref_code = transaction_ref_code;
        this.transaction_source_id = transaction_source_id;
        this.transaction_type = transaction_type;   
        this.transaction_void_date = transaction_void_date;
        this.transaction_void_reason = transaction_void_reason; 
        this.credit_reason_code_description = credit_reason_code_description; //Carrie-657 
        this.csr_comments = csr_comments; //Carrie-657 
        
        this.transaction_ref_code=transaction_ref_code;
        this.seq_statement_id=seq_statement_id;
        
        //Refund
        //Start
        /*this.refund_transaction_id = refund_transaction_id;
        this.refund_amount = refund_amount;
        this.create_date = create_date;
        this.reason_code = reason_code;
        this.reason_label = reason_label;
        this.reason_description = reason_description;
        this.ref_payment_transaction_id = ref_payment_transaction_id;
        this.create_user = create_user; */
        //End
    }
}