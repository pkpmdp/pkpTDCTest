/************************************************************************************************
*             <Class Name>			: CustomerTeamDetails
*             <@Author Name>		: Vijay
*
*             <Business reason for creating this web service in one line.>
*             : Used for Party Actor Functionality wherein Kiss UI is Calling below web service for fetching Customer Team Details of salesforce
*             @ChangeList
*             Issue#                   Date                      Comment            
*			  Internal review		   7/10/13					 Using String class function to check null & not null(Changes Done by Vijay)
*************************************************************************************************/

@RestResource(urlMapping='/customerteam/*')
global class CustomerTeamDetails {
    
    @HttpGet
    global static List<CustomerTeamWrapper> doGetAction(){
         String action = RestContext.request.params.get('action');
         if(String.isBlank(action)){
            return new List<CustomerTeamWrapper>();
         }
         if('getaccountteam'.equalsIgnoreCase(action)){
            return getCustomerTeamDetails();
         }
            return null;  
    }
    
    @HttpPost
    global static List<StaffMemberWrapper> doPostAction(){
        String action = RestContext.request.params.get('action');
        if(String.isBlank(action)){
            return new List<StaffMemberWrapper>();
        }
        if('postaccountteam'.equalsIgnoreCase(action)){
            return getStaffMemberDetails(); 
        }
            return null;
    }
    
    global static String modifyCableUnitNo(String cu){
        Integer accLength = cu.length();
        Integer remLength = 10 - accLength;
        String tempLength = '';
        if(cu.length() < 10){
          for(Integer i = 0; i < remLength; i++){
            tempLength += '0';
          }
          cu = tempLength + cu; 
        }
        return cu;
    }
    
    global static List<CustomerTeamWrapper> getCustomerTeamDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String cableUnitNumber;
        String cableUnitNo =  req.params.get('cableunitno');
        
        if(String.isNotBlank(cableUnitNo)){
        	cableUnitNumber = modifyCableUnitNo(cableUnitNo);
            System.debug('$$cableUnitNumber$$'+cableUnitNumber);
        }else{
            return new List<CustomerTeamWrapper>();
        }
        List<Account_Team__c> customerTeamList = [SELECT Id,Cable_Unit__c,Customer_Team_Member_Kiss_Id__c,Customer_Team_Role__r.Code__c,Customer_Team_Role__r.Name FROM Account_Team__c where Cable_Unit__c = :cableUnitNumber];
        if(customerTeamList != null && customerTeamList.size() > 0){
            return mapToCustomerTeamList(customerTeamList);
        }else{
            return new List<CustomerTeamWrapper>();
        }
    }
    
    public static List<CustomerTeamWrapper> mapToCustomerTeamList(List<Account_Team__c> customerTeamList){
    	List<CustomerTeamWrapper> listWrapper = new List<CustomerTeamWrapper>();
	    for(Account_Team__c at : customerTeamList){
	        CustomerTeamWrapper atWrapper = new CustomerTeamWrapper();
	        atWrapper.staffActorId = at.Id;
	        atWrapper.staffId = at.Customer_Team_Member_Kiss_Id__c;
	        atWrapper.roleName = at.Customer_Team_Role__r.Name;
	        atWrapper.roleCode = at.Customer_Team_Role__r.Code__c;
	        listWrapper.add(atWrapper);
	    }
    	return listWrapper;
	}

    global static List<StaffMemberWrapper> getStaffMemberDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        
        List<String> modCuList1 = new List<String>();
        String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        System.debug('$$jsonwrap$$'+jsonwrap);
        List<String> idList = new List<String>();
        for(String id1 : jsonwrap){
            idList.add(id1);
        }
        System.debug('$$idList$$'+idList);
        if(!idList.isEmpty()){
        //	for(Integer i =0; i < idList.size(); i++){
        		modCuList1.addAll(CheckCableUnitNumber(idList)); 
        	//	System.debug('^^^Method Called'+modCuList1);
        	//}
        }
        if(jsonwrap == null){
            return new List<StaffMemberWrapper>();
        }
        System.debug('$$$$$$idList$$'+idList);
        //if(!modCuList1.isEmpty()){
        	List<Account_Team__c> staffMemberList = [SELECT Id,Customer_Kiss_Id__c ,Customer_Team_Member_Lookup_Code__c ,Customer_Team_Member_Name__c,Customer_Team_Role_Lookup_Code__c,Customer__r.Cable_Unit_No__c FROM Account_Team__c where Customer__r.Cable_Unit_No__c IN :modCuList1];
        		if(staffMemberList != null && staffMemberList.size() > 0){
            		return getMapToStaffList(staffMemberList);
            	}else{
           		 	return new List<StaffMemberWrapper>();
        		}  
    	 //  } 
    	  //return null; 
     }
    
    global static List<String> CheckCableUnitNumber(List<String> cunumber){
    	List<String> modCuList = new List<String>();
    	
    	if(cunumber != null && cunumber.size() > 0){
    		for(String str1 : cunumber){
		    	if(str1 != null && str1 != ''){
		    		while(str1.length() < 10){
		    			str1 = '0' + str1;
		    		}
		    		modCuList.add(str1);
		    	}
    		}
    		return modCuList;
    	}
    	System.debug('######Final CuNumber'+cunumber+'####modCuList'+modCuList);
    	return null;
    	
    } 
        
    public static List<StaffMemberWrapper> getMapToStaffList(List<Account_Team__c> staffMemberList){
        List<StaffMemberWrapper> staffListWrapper = new List<StaffMemberWrapper>();
        for(Account_Team__c atc : staffMemberList){
            StaffMemberWrapper staffWrapper = new StaffMemberWrapper();
            staffWrapper.cableUnitNumber = atc.Customer__r.Cable_Unit_No__c;
            /* Change For SF-160 changes
            staffWrapper.customerId = atc.Customer_Kiss_Id__c;*/
            staffWrapper.userId = atc.Customer_Team_Member_Lookup_Code__c ;
            staffWrapper.fullName = atc.Customer_Team_Member_Name__c;
            staffWrapper.role = atc.Customer_Team_Role_Lookup_Code__c;
            staffListWrapper.add(staffWrapper);
        }
        
        return staffListWrapper;
    }  

    global class CustomerTeamWrapper {
       public String staffActorId;
       public String staffId;
       public String roleName;
       public String roleCode;
       
    }

    global class StaffMemberWrapper {
       public String cableUnitNumber;
       /* Change for SF-160 changes
       public String customerId;*/
       public String userId;
       public String fullName;
       public String role;
    }
    
    
}