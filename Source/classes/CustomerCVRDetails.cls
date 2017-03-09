@RestResource(urlMapping='/customers/*')
global class CustomerCVRDetails {
    
    @HttpGet
    global static List<CustomerCVRWrapper> getAction(){
        String action = RestContext.request.params.get('action');
        if(String.isBlank(action)){
            return new List<CustomerCVRWrapper>();
        }
        if('getcustomercvr'.equalsIgnoreCase(action)){
            return getCustomerCVRDetails();
        }
        return null;
    }
    
   
    
    global static List<CustomerCVRWrapper> getCustomerCVRDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String cableunit_no =  req.params.get('cableunitno'); 
        
        if(String.isBlank(cableunit_no)){
            return new List<CustomerCVRWrapper>();
        }
        if(String.isNotBlank(cableunit_no)){
                while(cableunit_no.length() < 10){
                    cableunit_no = '0' + cableunit_no;
                }
        }
        List<Account> customerList = [SELECT Id,CVR_Number__c,Customer_No__c,Cable_unit_no__c,RecordTypeId FROM Account WHERE Cable_unit_no__c = :cableunit_no];
        if(customerList != null && customerList.size() > 0){
            return getMapToCustomerList(customerList);
        }else{
            return new List<CustomerCVRWrapper>();
        }
    }
    
    public static List<CustomerCVRWrapper> getMapToCustomerList(List<Account> accList){
		List<CustomerCVRWrapper> listWrapper = new List<CustomerCVRWrapper>();
		for(Account acc : accList){
			CustomerCVRWrapper accWrapper = new CustomerCVRWrapper();
			if(!String.IsBlank(acc.CVR_Number__c)){
				accWrapper.cvrno = acc.CVR_Number__c;
				listWrapper.add(accWrapper);
			}
		}
		return listWrapper;
	}

   

	global class CustomerCVRWrapper {
		public String cvrno;
	}
}