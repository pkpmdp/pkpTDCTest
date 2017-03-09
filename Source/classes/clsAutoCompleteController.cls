//Controller used for the AutoComplete Enhancement
public with sharing class clsAutoCompleteController extends clsComponentControllerBase {

    // Private member variable
	private List<String> resultsname = new List<String>();
	private Map<String, String> resultsIds = new Map<String, String>();
	private Boolean hasparams = false;
	private Boolean hasnoresults = false;

    // Getters and Setters
    public Boolean getHasparams() {
        return hasparams;
 	}
 	
 	public void clearValues() {
 	    hasparams = false;
 	}
 	
 	public Boolean getHasnoresults() {
 	    return hasnoresults;	
 	}

	public void avoidRefresh() {
	}
 	
    public Map<String, String> getResultIds() {
    	return resultsIds;
    }
    
    public PageReference searchSuggestions() {
	    // Initalize variables, hasparams just indicates that a search has started
        resultsname.clear();   
        resultsIds.clear();
        hasparams = true;
        hasnoresults = false;

		// Obtain current parameters
        String sobjectname = System.currentPageReference().getParameters().get('objectname');
        String stext = '%'+System.currentPageReference().getParameters().get('aname')+'%';
        
        // Limit Suggestions to 10 Results
        Integer iLimit = 100;
        
        // Validate if there's an input and get results
     
        if (stext.length() > 2) {
	        try {
	            String sql = 'select id, name from ' + sobjectname + ' where name like \''+stext+'\' limit '+ iLimit;
		        for (sobject x : Database.query(sql)) {
		            String id  = (String)(x.get('id'));
		            String s  = (String)(x.get('name'));		            
		            resultsname.add(s);	
		            resultsids.put(s, id);
    	        }
		    } catch (Exception e) {
			    resultsname.add('Unexpected Error, please contact support');	
		    }
        }        
        return null;
    }
  
    public List<String> getResultsname() {
	    // Make sure to clear past values
	    clearValues();
	    if (resultsname.isEmpty()) {
		    hasnoresults = true;
			resultsname.add('No Results');
	    }
	    return resultsname;
    }       
}