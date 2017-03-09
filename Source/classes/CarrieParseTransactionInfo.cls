/***********************************************************************************
************************************************************************************

* @class: CarrieParseTransactionInfo
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used  as wrapper class for constructing object from the json response for CarrieParseJsonTransaction.

************************************************************************************ 
***********************************************************************************/
public class CarrieParseTransactionInfo {
	public Long aria_event_no;
	public DateTime transaction_date1;
	public String transaction_date;
	public Long acct_no;
	public String user_id;
	public String client_acct_id;
	public Double amount;
	public string currency_cd;
	public Long aria_statement_no;
	public string transaction_type;
	public Integer transaction_type_no;
	public Integer is_charge_type;
	public Long type_specific_id;
	public Double total_amount_applied;
	public Double related_amount_applied;
	public DateTime update_date1;
	public DateTime fully_applied_date1;
	public DateTime void_date1;
	public String update_date;
    public String fully_applied_date;
    public String void_date;
    
	public List<RelatedTransaction> related_transaction;
    
    public CarrieParseTransactionInfo(Long aria_event_no, String transaction_date, Long acct_no, String user_id, String client_acct_id, Double amount, string currency_cd, Long aria_statement_no, string transaction_type, Integer transaction_type_no, Integer is_charge_type, Long type_specific_id, Double total_amount_applied, Double related_amount_applied, String update_date,String fully_applied_date,String void_date, List<RelatedTransaction> related_transaction) {
	    this.aria_event_no = aria_event_no;
	    this.transaction_date = transaction_date;
	    this.transaction_date1 = datetime.valueOf(transaction_date);
	    this.acct_no =  acct_no;
	    this.user_id = user_id;
	    this.client_acct_id = client_acct_id;
	    this.amount = amount;
	    this.currency_cd = currency_cd;
	    this.aria_statement_no = aria_statement_no;
	    this.transaction_type = transaction_type;
	    this.transaction_type_no = transaction_type_no;
	    this.is_charge_type = is_charge_type;
	    this.type_specific_id = type_specific_id;
	    this.total_amount_applied = total_amount_applied;
	    this.related_amount_applied = related_amount_applied;
	    this.update_date1 = datetime.valueOf(update_date);
	    this.fully_applied_date1 = datetime.valueOf(fully_applied_date);
	    if(void_date!=null){
	    this.void_date1 = datetime.valueOf(void_date);
	    }else{
	    this.void_date1 = null;	
	    }
	    this.related_transaction = related_transaction.clone();
    }
    
    /**
	* @description: This class is used to getinformation about RelatedTransaction .
	*/
	public class RelatedTransaction {
	    public Long aria_event_no;
	    public DateTime transaction_date1;
	    public String transaction_date;
	    public Long acct_no;
	    public Double amount;
	    public string currency_cd;
	    public Long aria_statement_no;
	    public string transaction_type;
	    public Integer transaction_type_no;
	    public Integer is_charge_type;
	    public Long type_specific_id;
	    public Double total_amount_applied;
	    public Double related_amount_applied;
	    public DateTime update_date1;
	    public DateTime fully_applied_date1;
	    public String update_date;
	    public String fully_applied_date;
	    public Double related_amount;
	    public String void_date;
    
     	public RelatedTransaction(){
     	}
    	
    	public RelatedTransaction(Long aria_event_no,String transaction_date,Long acct_no,Double amount,string currency_cd,Long aria_statement_no,string transaction_type,Integer transaction_type_no,Integer is_charge_type,Long type_specific_id,Double total_amount_applied,Double related_amount_applied,String update_date,String fully_applied_date,String void_date,Double related_amount){
			this.aria_event_no =aria_event_no;
			this.transaction_date1 =datetime.valueOf(transaction_date);
			this.transaction_date =transaction_date;
			this.acct_no =acct_no;
			this.amount =amount;
			this.currency_cd =currency_cd;
			this.aria_statement_no =aria_statement_no;
			this.transaction_type =transaction_type;
			this.transaction_type_no =transaction_type_no;
			this.is_charge_type =is_charge_type;
			this.type_specific_id =type_specific_id;
			this.total_amount_applied =total_amount_applied;
			this.related_amount_applied =related_amount_applied;
			this.update_date1 =datetime.valueOf(update_date);
			this.fully_applied_date1 =datetime.valueOf(fully_applied_date);
			this.update_date =update_date;
			this.fully_applied_date =fully_applied_date;
			this.void_date = void_date;
			this.related_amount =related_amount;
    	}
	}
}