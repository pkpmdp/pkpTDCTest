/***********************************************************************************
************************************************************************************

* @class: CarrieServiceCredits
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get unapplied Service Credits for a customer.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieServiceCredits {
    private Aria_API_Configuration__c config { get; private set; }
    public Decimal AriaAccountNo ;
    public Id AriaAccountId;
    public Id customerId;
     
    public CarrieServiceCredits (Aria_Account__c customer){
        customerId = customer.Account__c;
        AriaAccountId = customer.Id;
        AriaAccountNo = customer.Aria_Account_No__c;
    }
    
    /**
    * @description: This method makes API call to Aria System for getting unapplied Service Credits for a customer.
    * @return: Response From Aria.
    */
    public String getAriaResponse(){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        HttpResponse response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_unapplied_service_credits', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'acct_no' => String.valueOf(AriaAccountNo) }); 
        if(response!=null){ // Changes done for SUPPORT-2959
        	system.debug('Response from Service Credit Controller: '+response.getBody());
        	return response.getBody();
        }
        else{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Refresh_Error));
        	return '';
        }
        
    }
    
    /**
    * @description: This method is used to parse the json response from Aria.
    * @param: Response json response from Aria.
    * @return: List Of Credits.
    */
    public List<Unapplied_Credit__c> getServiceCreditDetails(String data,Boolean isbatch){
        try{
            Unapplied_Credit__c credit;
            List<Unapplied_Credit__c> creditList = new List<Unapplied_Credit__c>();
            JSONParser parser = JSON.createParser(data);
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            CarrieParseUnappliedServiceCreditInfo parseUnappliedServiceCredit;
                            parseUnappliedServiceCredit = (CarrieParseUnappliedServiceCreditInfo)parser.readValueAs(CarrieParseUnappliedServiceCreditInfo.class);
                            credit = new Unapplied_Credit__c();
                            credit.Customer__c = customerId;
                            credit.Aria_Account__c = AriaAccountId;
                            credit.Name = ''+parseUnappliedServiceCredit.credit_id;
                            credit.External_Name__c = ''+parseUnappliedServiceCredit.credit_id;
                            credit.Aria_event_no__c= ''+parseUnappliedServiceCredit.credit_id;  
                            credit.Credit_Reason1__c =parseUnappliedServiceCredit.reason_text;
                            String comments = parseUnappliedServiceCredit.comments;
                            if(comments == null || comments=='{none}'){
                                credit.Comments__c ='';
                                credit.commentsLong__c='';
                            }else{
                                if(comments.length()>25){
                                    credit.Comments__c = comments.substring(0,22)+'...';
                                }else{
                                    credit.Comments__c = comments;
                                }
                                credit.commentsLong__c =comments;
                            }
                            credit.Date__c = date.valueOf(parseUnappliedServiceCredit.create_date);
                            Decimal amount = parseUnappliedServiceCredit.initial_amount;
                            if(amount!=null){
                                credit.Amount__c = amount;
                            }else{
                                credit.Amount__c=0;
                            }
                            credit.Unapplied_Amount1__c = parseUnappliedServiceCredit.amount_left_to_apply;
                            creditList.add(credit);
                            credit.Credit_type__c = 'Service';
                        }
                    }   
                }
            }
            return creditList;
        }catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            if(!isbatch)
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            CarrieLog.LogException(e);
            return new List<Unapplied_Credit__c>();
        }
    }
}