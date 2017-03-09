public with sharing class BlockBusterIssueRefundWrapper {

	public class IssueRefundlineItems{
		public string invoice_no{get;set;}
		public string invoice_line_no{get;set;}
		public string invoice_line_service_no{get;set;}
		public string invoice_line_reversed_amount{get;set;}
		public string invoice_line_reversing_date{get;set;}
		public string invoice_line_comments{get;set;}
		public string client_invoice_line_service_id {get;set;}
	}
	public string error_code{get;set;}
	public string error_msg{get;set;}
	public string applied_total_refund_amount{get;set;}
	public string applied_total_reversal_amount{get;set;}
	public string transaction_id{get;set;}
	public List<IssueRefundlineItems> reversed_invoice_lines{get;set;}
	
}