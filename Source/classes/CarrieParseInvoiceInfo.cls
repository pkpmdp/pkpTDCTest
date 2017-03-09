/***********************************************************************************
************************************************************************************

* @class: CarrieParseInvoiceInfo
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used  as wrapper class for constructing object from the json response for carrieinvoicecontroller.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieParseInvoiceInfo {
    public Long invoice_no;
    public Long acct_no;
    public Double debit;
    public Double credit;
    public String bill_date;
    public String due_date;
    public String paid_date;
    public String notify_date;
    public String from_date;
    public String to_date;
    public String currency_cd;
    public Double balance_forward;
    public Double total_due;
    public String comments;
    public String additional_comments;
    public String last_updated;
    public String transaction_type;
    public String user_id;
    public Long aria_event_no;
    public Long aria_statement_no;
    public String acct_statement_seq_str;
    public String second_acct_statement_seq_str;
    public List<InvoiceLineItem> invoice_line;
    
    public Double statement_balance_forward;

        
    public CarrieParseInvoiceInfo(Long invoice_no, Long acct_no, Double debit, Double credit, String bill_date, String due_date, String paid_date, String notify_date, String from_date, String to_date, String currency_cd, Double balance_forward, Double total_due, String comments, String additional_comments, String last_updated, String transaction_type, String user_id, Long aria_event_no, Long aria_statement_no, String acct_statement_seq_str, String second_acct_statement_seq_str, List<InvoiceLineItem> invoice_line){
        this.invoice_no = invoice_no;
        this.acct_no = acct_no;
        this.debit = debit;
        this.credit = credit;
        this.bill_date = bill_date;
        this.due_date = due_date;
        this.paid_date = paid_date;
        this.notify_date = notify_date;
        this.from_date = from_date;
        this.to_date = to_date;
        this.currency_cd = currency_cd;
        this.balance_forward = balance_forward;
        this.total_due = total_due;
        this.comments = comments;
        this.additional_comments = additional_comments;
        this.last_updated = last_updated;
        this.transaction_type = transaction_type;
        this.user_id = user_id;
        this.aria_event_no = aria_event_no;
        this.aria_statement_no = aria_statement_no;
        this.acct_statement_seq_str = acct_statement_seq_str;
        this.second_acct_statement_seq_str = second_acct_statement_seq_str;
        this.invoice_line = invoice_line.clone();
        this.statement_balance_forward = statement_balance_forward;
    }
    
    /**
    * @description: This class is used to getinformation about InvoiceLineItem .
    */
    public class InvoiceLineItem{
        public Long client_no;
        public Long line_item_no;
        public Double amount;
        public String comments;
        public Long plan_no;
        public String plan_name;
        public Long service_no;
        public String service_name;
        public String ledger_code;
        public Long coa_id;
        public String coa_description;
        public Double usage_units;
        public Double usage_rate;
        public Long usage_type_no;
        public String start_date;
        public String end_date;
        public string order_no;    
        public List<InvoiceLineTax> invoice_line_tax;
        
        public  InvoiceLineItem(){
        }
        
        public  InvoiceLineItem(Long client_no, Long line_item_no, Double amount, String comments, Long plan_no, String plan_name, Long service_no, String service_name, String ledger_code, Long coa_id, String coa_description, Double usage_units, Double usage_rate, Long usage_type_no, String start_date, String end_date, String order_no,List<InvoiceLineTax> invoice_line_tax){
            this.client_no = client_no;
            this.line_item_no = line_item_no;
            this.amount = amount;
            this.comments = comments;
            this.plan_no = plan_no;
            this.plan_name = plan_name;
            this.service_no = service_no;
            this.service_name = service_name;
            this.ledger_code = ledger_code;
            this.coa_id = coa_id;
            this.coa_description = coa_description;
            this.usage_units = usage_units;
            this.usage_rate = usage_rate;
            this.usage_type_no = usage_type_no;
            this.start_date = start_date;
            this.end_date = end_date;
            this.order_no=order_no;
            this.invoice_line_tax = invoice_line_tax.clone();
        }
            
    }
    
    /**
    * @description: This class is used to getinformation about InvoiceLineTax .
    */
    public class InvoiceLineTax{
        public Long tax_id;
        public Long client_no;
        public Double amount;
        public Double before_credit_amount;
        public String jurisdiction;
        public String description;
        public Long is_excluded; 
        
        public InvoiceLineTax(){
        }
        
        public InvoiceLineTax(Long tax_id, Long client_no, Double amount, Double before_credit_amount, String jurisdiction, String description, Long is_excluded){
            this.tax_id = tax_id;
            this.client_no = client_no;
            this.amount = amount;
            this.before_credit_amount = before_credit_amount;
            this.jurisdiction = jurisdiction;
            this.description = description;
            this.is_excluded = is_excluded; 
        }
    }
}