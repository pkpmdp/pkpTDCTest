// Common functions used between all the YKSpoc classes will be housed here
//
// @Author - Sarabdeep Ahluwalia
// @Date - 2/9/2013
//
global class YKSpocUtils {

// check if the logged in user is a YK Admin
 public static Boolean isYKAdmin(Id loggedInUserId){
		Map<String,YKAdminProfiles__c> mapAdminProfs = YKAdminProfiles__c.getAll();
	    Set<String> setAdminProfiles = mapAdminProfs.keySet();
	            
	    User loginUsr = [SELECT Id, ProfileId, Profile.Name FROM User
	                    WHERE Id =:loggedInUserId];
	                    
	    if(setAdminProfiles.contains(loginUsr.Profile.Name)){
	         return true;
	    }    
	    return false;       
	}
	
  public static List<SelectOption> getDepartmentType(){
  	 return getPicklistValues(NewsArticle__c.Department__c.getDescribe());
  }
  
  private static List<SelectOption> getPicklistValues(Schema.DescribeFieldResult fieldResult) 
    {
    		List<SelectOption> picklistValues = new List<SelectOption>();    		
	        for(Schema.PicklistEntry e : fieldResult.getPickListValues())
	        {	               
	            picklistValues.add(new SelectOption(e.getLabel(), e.getValue())); 
	        } 
	        return  picklistValues;  
    }
}