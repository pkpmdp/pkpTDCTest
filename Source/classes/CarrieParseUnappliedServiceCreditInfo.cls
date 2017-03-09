/***********************************************************************************
************************************************************************************

* @class: CarrieParseUnappliedServiceCreditInfo
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used  as wrapper class for constructing object from the json response for CarrieUnappliedCreditController.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieParseUnappliedServiceCreditInfo {
	public Long credit_id;
	public String create_date;
	public String create_user;
	public Double initial_amount;
	public Double amount_left_to_apply;
	public Long reason_cd;
	public String reason_text;
	public String comments;
	public String currency_cd;
	public Long service_no_to_apply;
	public String service_name_to_apply;
	public Long eligible_plan_no;
	public String eligible_plan_name;
	public Long elibible_service_no;
	public Long eligible_service_no;
	public String eligible_service_name;
	
	public CarrieParseUnappliedServiceCreditInfo( Long credit_id, String create_date, String create_user, Double initial_amount,Double amount_left_to_apply,Long reason_cd,String reason_text,String comments,String currency_cd,Long service_no_to_apply,String service_name_to_apply,Long eligible_plan_no,String eligible_plan_name,Long eligible_service_no,String eligible_service_name){
		this.credit_id = credit_id;
		this.create_date = create_date;
		this.create_user = create_user; 
		this.initial_amount = initial_amount;
		this.amount_left_to_apply = amount_left_to_apply;
		this.reason_cd = reason_cd;
		this.reason_text = reason_text;
		this.comments = comments;
		this.currency_cd = currency_cd;
		this.service_no_to_apply = service_no_to_apply;
		this.service_name_to_apply = service_name_to_apply;
		this.eligible_plan_no = eligible_plan_no;   
		this.eligible_plan_name = eligible_plan_name;
		this.eligible_service_no = eligible_service_no;
		this.elibible_service_no = eligible_service_no;
		this.eligible_plan_name = eligible_plan_name; 
	}
}