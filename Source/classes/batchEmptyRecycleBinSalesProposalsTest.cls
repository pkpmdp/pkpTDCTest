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
private class batchEmptyRecycleBinSalesProposalsTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        // The query used by the batch job.
        //String query = 'SELECT ID FROM Salesproposal__c where IsDeleted = true limit 5 ALL ROWS';
        
        // Create some test Sales proposal records to be deleted by the batch job.
         	   Salesproposal__c[] sp1 = new List<Salesproposal__c>();
         
           	   Salesproposal__c sp = new Salesproposal__c(
               Name = 'Salesproposal',
               RESPTracking_CD__c = 'TestTracking1',
               AMSNo__c = 'TestAMSNo1',
               SFIDORIG__c = 'TestSFIDORIG',
	           Effective_From_Date__c = Date.valueOf('2013-09-24'),
	           Expiration_Date__c = Date.valueOf('2013-10-26'));
       		   insert sp;
       		   id spId = sp.id;
       
	   		   List<Salesproposal__c> spList = new List<Salesproposal__c>();
	   		   spList = [Select Id From Salesproposal__c Where Id = :spId ALL ROWS];
	  		   Test.startTest();
	  		   clsEmptyRecycleBinSalesProposal deleteSP = new clsEmptyRecycleBinSalesProposal();
	  		   integer batchSize = 200;
	  		   ID batchprocessid = Database.executeBatch(deleteSP, batchSize);
	  		   deleteSP.start(null);
               deleteSP.execute(null, spList);
               deleteSP.finish(null);
               System.abortJob(batchprocessid);	
	           Database.DeleteResult[] drList = Database.delete(spList, false);
	           Database.EmptyRecycleBinResult[] emptyRecycleBinResults = Database.emptyRecycleBin(spList);
	           
	    	   Test.stopTest();
		
       
       

       
    }
}