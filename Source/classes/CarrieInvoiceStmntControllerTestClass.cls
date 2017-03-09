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

* @class: CarrieInvoiceStmntControllerTestClass
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Test Class for CarrieInvoiceStatementController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class CarrieInvoiceStmntControllerTestClass {
	
	/**
	* @description: This method is used to test general methods of CarrieInvoiceStatementController
	*/
	static testMethod void testInvoiceStatement() {
		User user = CarrieTestUtil.insertUser();
		
		system.runAs(user){
			CarrieInvoiceStatementController invoiceStatement = new CarrieInvoiceStatementController();
			invoiceStatement.makeCall=false;
			//positive scenarios
			invoiceStatement.data = '{"error_code":0,"out_statement":"<html><head></head><body><div id=\'content\'>hi</div><div>hisdfgsdfgdfg</div><div >hisdjfgfcoshjmeriotuoecmilfjsiljfgldrhfgh</div></body></html>","mime_type":"texthtml","error_msg":"OK"}'; 
			String req = invoiceStatement.Req;
		    invoiceStatement = new CarrieInvoiceStatementController();
			//negative scenarios
			invoiceStatement.data = '{"error_code":2,"out_statement":"<html><head></head><body><div id=\'content\'>hi</div><div>hisdfgsdfgdfg</div><div >hisdjfgfcoshjmeriotuoecmilfjsiljfgldrhfgh</div></body></html>","mime_type":"texthtml","error_msg":"OK"}';
			String str = invoiceStatement.Req;
		}
	}
}