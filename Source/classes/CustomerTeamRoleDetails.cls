@RestResource(urlMapping='/customerteamrole/*')
global class CustomerTeamRoleDetails{
	
	@HttpGet
	global static List<CustomerTeamRoleWrapper> getAction(){
		String action = RestContext.request.params.get('action');
		if(action == null || action == ''){
			return new List<CustomerTeamRoleWrapper>();
		}
		if('getroleId'.equalsIgnoreCase(action)){
        	return getSingleCustomerTeamRoleDetails();
    	}
    	if('all'.equalsIgnoreCase(action)){
    		return getAllCustomerTeamRoleDetails();
    	}
    	if('active'.equalsIgnoreCase(action)){
    		return getActiveCustomerTeamRoleDetails();
    	}
    		return null;
	}
	
    global static List<CustomerTeamRoleWrapper> getSingleCustomerTeamRoleDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String roleId =  req.params.get('roleid'); 
        
   		if(roleId == null && roleId == ''){
        	return new List<CustomerTeamRoleWrapper>();
   		}
        List<Lookup_Account_Team_Role__c> customerTeamRoleList = [SELECT Active__c,Code__c,Name,Id,Start_Date__c,End_Date__c FROM Lookup_Account_Team_Role__c WHERE ID =: roleId];
        if(customerTeamRoleList != null && customerTeamRoleList.size() > 0){
        	return getMapTocustomerTeamRoleList(customerTeamRoleList);
	    }else{
	        return new List<CustomerTeamRoleWrapper>();
	    }
    }
    
    public static List<CustomerTeamRoleWrapper> getMapTocustomerTeamRoleList(List<Lookup_Account_Team_Role__c> customerTeamRoleList){
    	List<CustomerTeamRoleWrapper> listWrapper = new List<CustomerTeamRoleWrapper>();
	    for(Lookup_Account_Team_Role__c latcr : customerTeamRoleList){
	        CustomerTeamRoleWrapper latcrWrapper = new CustomerTeamRoleWrapper();
	        latcrWrapper.roleName = latcr.Name;
	        latcrWrapper.roleCode = latcr.Code__c;
	        latcrWrapper.roleId = latcr.Id;
	        latcrWrapper.startDate = latcr.Start_Date__c;
	        latcrWrapper.endDate = latcr.End_Date__c;
	        listWrapper.add(latcrWrapper);
	    }
    	return listWrapper;
	}

	global static List<CustomerTeamRoleWrapper> getAllCustomerTeamRoleDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        //commented existing
        //List<Lookup_Contact_Roles__c> customerTeamRoleList = [SELECT Code__c,Id,Name,Active__c FROM Lookup_Contact_Roles__c WHERE Active__c ='Ja'];
        
        List<Lookup_Account_Team_Role__c> customerTeamRoleList = [SELECT Active__c,Code__c,Name,Id,Start_Date__c,End_Date__c FROM Lookup_Account_Team_Role__c];
        if(customerTeamRoleList != null && customerTeamRoleList.size() > 0){
        	return getMapTocustomerTeamRoleList(customerTeamRoleList);
	    }else{
	        return new List<CustomerTeamRoleWrapper>();
	    }
    }
    
    global static List<CustomerTeamRoleWrapper> getActiveCustomerTeamRoleDetails(){
    	RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Lookup_Account_Team_Role__c> customerTeamRoleList = [SELECT Active__c,Code__c,Name,Id,Start_Date__c,End_Date__c FROM Lookup_Account_Team_Role__c WHERE Active__c ='Ja'];
        if(customerTeamRoleList != null && customerTeamRoleList.size() > 0){
        	return getMapTocustomerTeamRoleList(customerTeamRoleList);
	    }else{
	        return new List<CustomerTeamRoleWrapper>();
	    }
    }

    

global class CustomerTeamRoleWrapper {
   public String roleName;
   public String roleCode;
   public String roleId;
   //public Boolean aktiv;
   public Date startDate;
   public Date endDate;
   
   }

}