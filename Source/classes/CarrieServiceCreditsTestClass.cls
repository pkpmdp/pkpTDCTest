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

* @class: CarrieServiceCreditsTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieServiceCredits , CarrieParseUnappliedServiceCreditInfo.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieServiceCreditsTestClass {
	
	/**
	* @description: This method is used to test general methods of CarrieServiceCredits
	*/	
	static testMethod void testServiceCredit() {
		Decimal ariaAccountNo = 3666081;
		Id customerId;
		User user = CarrieTestUtil.insertUser();
		Aria_Account__c customer  = CarrieTestUtil.insertAccount();
       	customerId = customer.Id   ;
       	
       	system.runAs(user){
			Test.startTest(); 
       		CarrieServiceCredits serviceCredit= new CarrieServiceCredits(customer);
       		String response='{"error_code":0,"error_msg":"OK","unapplied_service_credits":[{"credit_id":411195,"create_date":"2012-07-26","create_user":"client API","initial_amount":null,"amount_left_to_apply":240,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 300","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411197,"create_date":"2012-07-26","create_user":"client API","initial_amount":60,"amount_left_to_apply":60,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 300","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411339,"create_date":"2012-07-26","create_user":"client API","initial_amount":4800,"amount_left_to_apply":4800,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 6000","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411341,"create_date":"2012-07-26","create_user":"client API","initial_amount":abcd,"amount_left_to_apply":1200,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 6000","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null}]}';
       		serviceCredit.getServiceCreditDetails(response,true);
       		String response1='{"error_code":0,"error_msg":"OK","unapplied_service_credits":[{"credit_id":411195,"create_date":"2012-07-26","create_user":"client API","initial_amount":null,"amount_left_to_apply":240,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":null,"currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411197,"create_date":"2012-07-26","create_user":"client API","initial_amount":60,"amount_left_to_apply":60,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test for the more then 25 character string","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411339,"create_date":"2012-07-26","create_user":"client API","initial_amount":4800,"amount_left_to_apply":4800,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 6000","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null},{"credit_id":411341,"create_date":"2012-07-26","create_user":"client API","initial_amount":abcd,"amount_left_to_apply":1200,"reason_cd":4,"reason_text":"serviceCredit no longer desired","comments":"test 6000","currency_cd":"dkk","service_no_to_apply":0,"service_name_to_apply":"Account Credit","eligible_plan_no":null,"eligible_plan_name":null,"eligible_service_no":null,"eligible_service_name":null}]}';
       		serviceCredit.getServiceCreditDetails(response1,false);       		
       		Test.stopTest();
       	}
	}
	
	/**
	* @description: This method is used to test general methods of CarrieParseUnappliedServiceCreditInfo
	*/
	static testMethod void parseServiceCredit() {
		User user = CarrieTestUtil.insertUser();
		
		system.runAs(user){
			Test.startTest(); 
	   		Long credit_id=411195;
			String create_date='2012-07-26';
			String create_user='client API';
			Double initial_amount=240;
			Double amount_left_to_apply=240;
			Long reason_cd=4;
			String reason_text='rvice no longer desi';
			String comments='est 30';
			String currency_cd='dkk';
			Long service_no_to_apply=0;
			String service_name_to_apply='Account Credi';
			Long eligible_plan_no=null;
			String eligible_plan_name=null;
			Long eligible_service_no=null;
			String eligible_service_name=null;
			
			CarrieParseUnappliedServiceCreditInfo parseServiceCreditInfo = new CarrieParseUnappliedServiceCreditInfo( credit_id,  create_date,  create_user,  initial_amount, amount_left_to_apply, reason_cd, reason_text, comments, currency_cd, service_no_to_apply, service_name_to_apply, eligible_plan_no, eligible_plan_name, eligible_service_no, eligible_service_name);
		}
    }
}