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
private class clsConvertLeadUtilTest {
    
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
    	l.Company = 'ACME';
    	l.RecordTypeId = '012200000000nzaAAA';    	
    	l.Street_Lookup__c = add.Id;
    	l.Phone = '01322788767';
    	l.Type__c = 'Kunde';
    	l.Status = 'Åben';
    	l.Estimated_Potential__c = 100;
    	l.No_Email_Address__c = false;
    	//l.No_Thank_You__c = 'Ja';
    	insert l;
    	
    	// Initialise lead convert object
    	Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        
        // Set convert status
        LeadStatus convertStatus = [Select Id, MasterLabel From LeadStatus Where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
    	/* Temporarily disabled on September 30th 2011 
    	// Convert lead
    	Database.LeadConvertResult result = Database.ConvertLead(lc); 
    	
    	// Now retrieve the generated contact record
    	Id contactId = result.getContactId();    	
    	Contact c = [Select Id, Street_P__c From Contact Where Id = : contactId];
    	
    	// Confirm the street lookup id was copied across
    	System.assertEquals(l.Street_Lookup__c, c.Street_P__c);
    	*/
    }
    
}