public with sharing class CarrieBetalingsHistory {

	public String strBetalingsNo;
	private Aria_API_Configuration__c config { get; private set; }
	public List<BetalingsOuterWrapper> listBetalingsWrapper{get;set;}
	public BetalingsWrapper objBetWrapper;
	public BetalingsOuterWrapper objBetOutWrapper;
	public CarrieBetalingsHistory(ApexPages.StandardController ctlr){
		
		strBetalingsNo = System.currentPageReference().getParameters().get('Ariaacc');
		listBetalingsWrapper = new List<BetalingsOuterWrapper>();
		objBetWrapper = new BetalingsWrapper();
		objBetOutWrapper = new BetalingsOuterWrapper();
	}
	public pagereference retrieveBetalingsHistory(){
		config = CarrieCommonUtil.validateAPIConfiguration(config);
        HttpResponse response;
        response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_acct_payment_methods', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new Map<String, String> { 'acct_no' => strBetalingsNo});
		
		if(response!=null){ 
       		system.debug('Response from Betalings method'+response.getBody());
       		parseResponse(response.getBody());
        }
        else{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Refresh_Error));
        	
        }
		return null;
	}
	
	public pagereference parseResponse(String responseBody){
		
		 //String responseBody=response.getBody();
		 try{
	           JSONParser parser = JSON.createParser(responseBody);
				while (parser.nextToken() != null) {
		        // Start at the array of response.
			        system.debug('parser.getCurrentToken()=1=='+parser.getCurrentToken());
			        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			            
		                // Advance to the start object marker to       			              
	                    // Read entire response object, including its array of line items.
	                    BetalingsOuterWrapper inv = (BetalingsOuterWrapper)parser.readValueAs(BetalingsOuterWrapper.class);
	                    for(BetalingsWrapper obj: inv.acct_pay_methods){
	                    	String startDate = obj.from_date_time.substring(0,10);
	                    	String startDatetime = obj.from_date_time.substring(11,(obj.from_date_time.length()));
	                    	List<String>lstEndDateArray = startDate.split('-');
	                    	obj.from_date_time = lstEndDateArray[2]+'-'+lstEndDateArray[1]+'-'+lstEndDateArray[0]+ ' '+ startDatetime;
	                    	
	                    	if(obj.to_date_time!='Present'){
		                    	String tilDate = obj.to_date_time.substring(0,10);
		                    	String enddatetime = obj.to_date_time.substring(11,(obj.to_date_time.length()));
		                    	List<String>lstTilDateArray = tilDate.split('-');
	                    	    obj.to_date_time = lstTilDateArray[2]+'-'+lstTilDateArray[1]+'-'+lstTilDateArray[0]+ ' '+ enddatetime;
	                    	    
	                    	}
	                    }
	                    system.debug('BetalingsOuterWrapper: ' + inv);
	                    // For debugging purposes, serialize again to verify what was parsed.
	                    String s = JSON.serialize(inv);
	                    system.debug('Serialized invoice: ' + s);
    					listBetalingsWrapper.add(inv);
			        }
	    		}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return null;
	}
	
	public class BetalingsWrapper {
	   public String first_name{get;set;}
       public String middle_initial{get;set;}
       public String last_name{get;set;}
       public String address1{get;set;}
       public String address2{get;set;}
       public String city{get;set;}
       public String state{get;set;}
       public String zipcode{get;set;}
       public String country{get;set;}
       public String locality{get;set;}
       public String phone{get;set;}
       public String cell_phone{get;set;}
       public String work_phone{get;set;}
       public String email{get;set;}
       public String company_name{get;set;}
       public String seq_no{get;set;}
       public String pay_method_id{get;set;}
       public String pay_method_name{get;set;}
       public String persistent_ind{get;set;}
       public String from_date{get;set;}
       public String to_date{get;set;}
       public String cc_exp_mm{get;set;}
       public Integer cc_exp_yy{get;set;}
       public String cc_id{get;set;}
       public String cc_type{get;set;}
       public String bank_routing{get;set;}
       public String bank_name{get;set;}	
       public String bank_acct_type{get;set;}
       public String suffix{get;set;}
       public String current_pay_method{get;set;}
       public String bill_info_api_receipt_id{get;set;}
       public String address3{get;set;}
       public String from_date_time{get;set;}
       public String to_date_time{get;set;}
       public String bkup_pay_method_ind{get;set;}
	
	}
	
	public class BetalingsOuterWrapper{
		
		public List<BetalingsWrapper> acct_pay_methods{get;set;}
		public Integer error_code{get;set;}
		public String error_msg{get;set;}

	}
}