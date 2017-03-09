@isTest
private class batchDeleteSalesProposalsTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        // Create some test Sales proposal records to be deleted by the batch job.
        //Salesproposal__c[] sp1 = new List<Salesproposal__c>();
         
        Salesproposal__c sp = new Salesproposal__c( Name = 'Salesproposal', RESPTracking_CD__c = 'TestTracking1', AMSNo__c = 'TestAMSNo1', SFIDORIG__c = 'TestSFIDORIG', Effective_From_Date__c = Date.valueOf('2013-09-24'), Expiration_Date__c = Date.valueOf('2013-10-26'));
        insert sp;
       // id spId = sp.id;
       
        //List<Salesproposal__c> spList = new List<Salesproposal__c>();
        //spList = [Select Id,Expiration_Date__c From Salesproposal__c Where Id = :spId];
        Test.startTest();
        List<Salesproposal__c> spList = new List<Salesproposal__c>();
        spList.add(sp);
        batchDeleteSalesproposals deleteSP = new batchDeleteSalesproposals();
        integer batchSize = 200;
        ID batchprocessid = Database.executeBatch(deleteSP, batchSize);
        //deleteSP.start(null);
       deleteSP.execute(null, spList);
        //deleteSP.finish(null);
        //System.abortJob(batchprocessid);  
        //Database.DeleteResult[] drList = Database.delete(spList, false);
        //Database.EmptyRecycleBinResult[] emptyRecycleBinResults = Database.emptyRecycleBin(spList);
        Test.stopTest();
    }
}