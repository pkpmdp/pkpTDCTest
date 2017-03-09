/**
 * This class contains unit tests for validating the behavior of Apex classes and triggers
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
private class clsConvertLeadYKControllerTest {
    
    // Test coverage for requirement to copy lead address to contact for YS lead conversions
    static testMethod void testConvertYSLead() {
    	
    	// Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
       // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create lead record        
    	Lead l = new Lead();
    	l.FirstName = 'Tom';
    	l.LastName = 'Jones';
    	l.Email = 'test@testaccount123.dk';
    	l.RecordTypeId = '012200000000nzVAAQ';
    	l.Street_Lookup__c = add.Id;
    	l.Phone = '01322788767';
    	l.Type__c = 'Kunde';
    	l.Status = 'Åben';
    	l.Estimated_Potential__c = 100;
    	l.No_Email_Address__c = false;
    	//l.No_Thank_You__c = 'Ja';
    	insert l;
    	
    	// Create lead information request record
    	Lead_Information_Request__c lir = new Lead_Information_Request__c();
        lir.Lead__c = l.Id;
        lir.Email__c = l.Email;
        lir.Date_Requested__c = System.now();
        lir.Template__c = 'Play';
        insert lir;

        // Get a handle on lead convert Visualforce page controller                 
    	ApexPages.StandardController sc = new ApexPages.StandardController(l);    	
        clsConvertLeadYKController controller = new clsConvertLeadYKController(sc);
        
        // Set the duplicate account variables to null - this will be a new account
        controller.getDuplicateAccounts();
        controller.duplicateAccountId = '';
        
        // Set the converted lead status
        List<SelectOption> options = controller.getConvertedLeadStatuses();
        SelectOption option = options [0];
        controller.convertedLeadStatus = option.getValue();
        
        // Convert the lead record
        PageReference p = controller.convertLead();
        
        // Make sure an account record was created
        System.assertEquals(p.getUrl().subString(0, 4), '/001');
        
        // Retrieve the account id
        Id accountId = p.getUrl().subString(1);
        
        // Query for customer information requests that were created by the controller code        
        List<Customer_Information_Request__c> customerInformationRequests = [Select Id From Customer_Information_Request__c Where Account__c = : accountId];
        
        // Only one record should have been created
        System.assert(customerInformationRequests.size() == 1);
    	
    }
    
}