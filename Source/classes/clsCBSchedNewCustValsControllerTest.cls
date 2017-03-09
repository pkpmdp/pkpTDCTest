/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
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
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class clsCBSchedNewCustValsControllerTest {
	
	public static Date TEST_FUTURE_DATE = Date.newInstance(2020,2,2);
	public static String TEST_FUTURE_DATE_URL_PARAM = '02-02-2020';
	public static String TEST_TYPE = 'Broadband';

    static testMethod void createCustValTest() {
        Test.startTest();
		PageReference pageRef = Page.CB_SchedCustValsNew;
    	Test.setCurrentPage(pageRef);
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(new CB_Custom_Schedule__c());
        clsCBSchedNewCustValsController c = new clsCBSchedNewCustValsController(sc);
        
        System.assert(c.getProxyObject()!=null);
        
        //test validation with empty values
        c.proxyObject.CB_date__c=null;
        c.getCaseFields().Type_Task__c=null;
        System.assert(c.next()==null);

		//test validation with date in the past
        c.proxyObject.CB_date__c=Date.today()-1;
        c.getCaseFields().Type_Task__c=TEST_TYPE;
        System.assert(c.next()==null);

		//succesfull pass
        c.proxyObject.CB_date__c=Date.today();
        c.getCaseFields().Type_Task__c=TEST_TYPE;
        System.assert(c.next()!=null);

    }
}