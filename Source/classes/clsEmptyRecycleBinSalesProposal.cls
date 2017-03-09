global class clsEmptyRecycleBinSalesProposal implements Database.Batchable<SObject> {

	global clsEmptyRecycleBinSalesProposal(){ 
    
    }
    
    global Database.queryLocator start(Database.BatchableContext ctx){
    	String lblLimit = System.Label.Sales_Proposal;        
    	String query = 'SELECT ID,IsDeleted FROM Salesproposal__c where IsDeleted = true limit ' + lblLimit + ' ALL ROWS'; 
        return Database.getQueryLocator(query);
        								 
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){
        List<Salesproposal__c> logToDelete = new List<Salesproposal__c>();
        List<Salesproposal__c> salesLogs = (List<Salesproposal__c>)scope;
        if(salesLogs.size() > 0){
	        for(Salesproposal__c logs : salesLogs){ 
	        	logToDelete.add(logs); 
	        }
        }    
        Database.emptyRecycleBin(logToDelete);
    }
    
    global void finish(Database.BatchableContext ctx){
    
    }
}