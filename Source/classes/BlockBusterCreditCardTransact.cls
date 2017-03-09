public with sharing class BlockBusterCreditCardTransact {

	public String customernumber{get;set;}
	public String orderid{get;set;}
	public String createtime{get;set;}
	public String type {get;set;}
	public String title{get;set;}
	public String product_id{get;set;}
	public String totalprice{get;set;}
	public String koda{get;set;}
	public String errorcode{get;set;}
	public String err{get;set;}
	
	public BlockBusterCreditCardTransact(String errCd,String errMsg){
		errorcode = errCd;
		err = errMsg;
	}
	public BlockBusterCreditCardTransact(){
		
	}
	
}