global class deleteCustomerLogHistory implements Database.Batchable<SObject> {
    
    Double failedUpdates{get; set;}
 	String query12;
    global deleteCustomerLogHistory(){ 
        failedUpdates = 0;
    }
    
    global Database.queryLocator start(Database.BatchableContext ctx){  
    	
        DateTime twoYearsBack = datetime.newInstanceGmt(Date.Today().Year() - 2, Date.Today().month(), Date.Today().day());
        query12 = 'Select Id, Creation_Date__c,CreatedDate,Customer__c From Customer_Log__c WHERE Creation_Date__c <' + twoYearsBack; 
        System.debug('###Last 2 Years'+twoYearsBack+'query12'+query12);
        //return Database.getQueryLocator([Select Id, Creation_Date__c From Customer_Log__c WHERE Creation_Date__c < :twoYearsBack]);
        return Database.getQueryLocator([Select Id, Creation_Date__c,CreatedDate,Customer__c From Customer_Log__c WHERE Creation_Date__c < LAST_N_YEARS:1]);
        								 
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){
        List<Customer_Log__c> logToDelete = new List<Customer_Log__c>();
        List<Customer_Log__c> customerLogs = (List<Customer_Log__c>)scope;
        if(customerLogs.size() > 0){
	        for(Customer_Log__c logs : customerLogs){ 
	        	logToDelete.add(logs); 
	        }
        }    
        System.debug('######Log To Delete'+logToDelete);
        List<Database.DeleteResult> dsrs = Database.delete(logToDelete, false);
        Database.emptyRecycleBin(logToDelete);
        system.debug('####logToDelete'+logToDelete);
        for(Database.DeleteResult dsr : dsrs){
            if(!dsr.isSuccess()){
                failedUpdates++;
            }
        }
    }
    
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :ctx.getJobId()];
        String emailMessage = 'Your batch job '
             + 'AccountOwnerReassignment '
             + 'has finished.  It executed ' 
             + a.totalJobItems 
             + ' batches.  Of which, ' + a.jobitemsprocessed 
             + ' processed without any exceptions thrown and ' 
             + a.numberOfErrors +
             ' batches threw unhandled exceptions.'
             + '  Of the batches that executed without error, ' 
             + failedUpdates 
             + ' records were not updated successfully.';
        
        Messaging.SingleEmailMessage mail = 
              new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {a.createdBy.email};
        String[] toAddresses = new String[] {'amrish.surve@capgemini.com'};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch job completed');
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });  
    }
    

    /*public static testmethod void testBatchAccountOwnerReassignment(){
     	List<Customer_Log__c> custLog = new List<Customer_Log__c>();
		Account acc = new Account();
		acc.Name = 'TestKunde';
		acc.Type='kunde';
		insert acc;

		DateTime twoYearsBack = datetime.newInstanceGmt(Date.Today().Year() - 2, Date.Today().month(), Date.Today().day());
		Customer_Log__c c1 = new Customer_Log__c();
		c1.Creation_Date__c = twoYearsBack ;

		c1.Customer__c = acc.id;
		c1.Inquiry_Form__c = '5';
		c1.Inquiry_Type__c = '4';
		c1.Text__c = 'TEST';
		c1.User_MID__c = 'M55555';
		c1.User_Name__c = 'RSREE';
		insert c1;	
		
		id spId = c1.id;
		List<Customer_Log__c> spList = new List<Customer_Log__c>();
		spList = [Select Id From Customer_Log__c Where Id = :spId];
		Test.startTest();
		deleteCustomerLogHistory deleteSP = new deleteCustomerLogHistory();
		integer batchSize = 200;
		ID batchprocessid = Database.executeBatch(deleteSP, batchSize);
		deleteSP.start(null);
		deleteSP.execute(null, spList);
		//deleteSP.finish(null);
		System.abortJob(batchprocessid);	
		Database.DeleteResult[] drList = Database.delete(spList, false);
		Database.EmptyRecycleBinResult[] emptyRecycleBinResults = Database.emptyRecycleBin(spList);
		Test.stopTest();

    }*/
}