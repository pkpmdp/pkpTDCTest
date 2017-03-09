public class clsGenerateResultsController {
	Survey_Event_Financial_Data__c sefd = new Survey_Event_Financial_Data__c();
	
	public clsGenerateResultsController(ApexPages.StandardController controller) {    	
        this.sefd = [Select Id, Template__c, Results_Generated__c From Survey_Event_Financial_Data__c Where Id = :controller.getId()];
    }
    
    public PageReference generateResults() {
        // Check results haven't already been generated
        if (this.sefd.Results_Generated__c == false) {
    	    // Retrieve the questions associated with the template
    	    List<Template_Question__c> templateQuestions = [Select Id, Question_Repository__c, Flow_Order__c From Template_Question__c Where Survey_Template__c = :this.sefd.Template__c Order By Flow_Order__c];
    	    // Initialise a list to store the new results records
    	    List<Result__c> resultsToCreate = new List<Result__c>();
            // Create a result record for each of the questions associated with the template
            for (Template_Question__c templateQuestion : templateQuestions) {
    		    Result__c result = new Result__c();
    		    result.Survey_Event_Financial_Data__c = sefd.Id;
    		    result.Question_No__c = templateQuestion.Question_Repository__c;
    		    result.Flow_Order__c = templateQuestion.Flow_Order__c;
    		    resultsToCreate.add(result);    		
    	    }
    	    // Perform the DML to create the records
    	    Database.SaveResult[] results = Database.insert(resultsToCreate, false);
    	    // Check that all the inserts were successful
    	    Boolean success = true;
    	    for (Database.SaveResult result : results) {
    	    	if ( ! result.isSuccess() ) {
    	    		success = false;
    	    	}
    	    }
    	    // If successful then update the Survey/Event/Financial Data record - shouldn't be possible to do this again
    	    if ( success) {
    	        this.sefd.Results_Generated__c = true;
    	        Database.SaveResult sefdResult = Database.update(this.sefd);
    	    }
        }
    	// Navigate the user back to the Survey/Event/Financial Data page
    	PageReference success = new PageReference('/' + this.sefd.Id);
    	return success;    	
    }
}