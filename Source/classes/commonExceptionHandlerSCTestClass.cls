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
private class commonExceptionHandlerSCTestClass {
	
	//public errorLogDetails errorLog = new errorLogDetails();
	
    static testMethod void myUnitTest() {
        //errorLogDetails errorLog = new errorLogDetails();
        Exception e;
        //e.setMessage('Attempt to dereference null object');
        String className = 'ViewAddressesForInstallationsController';
        String moduleName = 'Change Tv-Package';
        String errorLog = 'DML currently not allowed';
        String testLevel = 'Medium';
        Boolean showindebuglog = false; 
        String functionname1 = 'handleException()';
        Boolean debugLogs = false;
        Boolean putonerrorstack = false;
        String cableUnitNumber = '0005037310';
        Blob errorLog1 = Blob.valueOf(errorLog);
        CommonExceptionHandlerCls empty1 = new CommonExceptionHandlerCls();
        CommonExceptionHandlerCls param = new CommonExceptionHandlerCls(className,moduleName); 
    	
    	empty1.logErrorMessage(errorLog, debugLogs,testLevel);
    	
    	PageReference testPage = Page.exception;
    	Test.setCurrentPage(testPage);
    	empty1.redirectToCommonErrorPage();
    	empty1.sendLogMail(errorLog1);
    	//empty1.prepareMessage(e, modulename, functionname1);
    	//empty1.prepareMessage(e, modulename, functionname1);
    	//empty1.handleException(e, functionname1, showindebuglog, putonerrorstack, cableUnitNumber);
    	//empty1.prepareMessage(e, modulename, functionname1);
    }
    
    
    
}