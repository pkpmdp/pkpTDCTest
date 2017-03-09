public with sharing class BlockBusterRefundDetailsWrapper {

	public string error_code { get;set; }
	public string error_msg { get;set; }
	public List<refund_details> refund_details { get;set; }
	
	public class refund_details{
		public string refund_transaction_id{get;set;} //Payment id
		public string refund_amount{get;set;}
		public string create_date{get;set;}
		public string create_user{get;set;}
		public string reason_code{get;set;}
		public string reason_label{get;set;}
		public string reason_description{get;set;}
		public string ref_payment_transaction_id{get;set;} //transaction id
		public string ref_payment_transaction_type{get;set;} //transaction type
		public string ref_payment_transaction_desc{get;set;}
		public string ref_payment_amount{get;set;}
		public string ref_payment_ref_code{get;set;}
		public string bill_seq_no{get;set;}
		public string pay_method_id{get;set;}
		public string pay_method_name{get;set;}
		public string cc_id{get;set;}
		public string cc_type{get;set;}
		public string payment_src_suffix{get;set;}
		public string refund_check_num{get;set;}
		public string is_voided_ind{get;set;}
		public List<invoice_reversals>invoice_reversals{get;set;}
	}
	
	public class invoice_reversals{
		public string invoice_no{get;set;}
		public string invoice_bill_date{get;set;}
		public string invoice_line_no{get;set;}
		public string total_line_debit{get;set;}
		public string reversed_line_amount{get;set;}
		public string reversed_line_start_date{get;set;}
		public string reversed_line_end_date{get;set;}
	}
}