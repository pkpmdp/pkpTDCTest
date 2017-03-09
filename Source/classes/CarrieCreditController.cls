/***********************************************************************************
************************************************************************************

* @class: CarrieCreditController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: This class is used to issue Cash and Sevice Credits for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarrieCreditController {
    private Aria_API_Configuration__c config { get; private set; }
    Aria_Account__c customer = new Aria_Account__c();
    public Decimal ariaAccountNo;
    public Boolean creditAllow{get;set;} 
    public String amount {get;set;}
    public String comments{get;set;}
    public String selectComments{get;set;}
    public String creditType {get; set;}
    public String creditReason{get; set;}
    public String creditReasonTax{get; set;} //CARRIE-657
    public Decimal credit;
    public Decimal tax;
    public List<SelectOption> commentsList{get;set;}
    public HttpResponse response;
    public PageReference pageRef = null;
    public String inputHiddenTax{get;set;}
    public String showForburg{get; set;}
    public Boolean hideService{get; set;}       
    Boolean callFailure {get;set;}
    String cashResponse;
    String cashResponseTax;
    String serviceResponse;
    String serviceResponseTax;
    public CarrieCreditController (ApexPages.StandardController controller){
    	hideService = true;
    	callFailure = false;
        customer = (Aria_Account__c)controller.getRecord(); 
        creditType='1';
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        ariaAccountNo = customer.Aria_Account_No__c;  
        Aria_Account__c ariaAcc = new Aria_Account__c();
        try{
        	ariaAcc = [select Id,Aria_Plan_Name__c from Aria_Account__c where Id = :controller.getRecord().Id];
        }
        catch(Exception ex){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        	return;
        }	
        showForburg=ariaAcc.Aria_Plan_Name__c  ;   
        creditAllow = false;
        validProfile();
        populateComments();
        //Start of CARRIE-1191
		this.creditReason= CarrieCommonUtil.CREDIT_REASON_MAP.get(1); //CARRIE-1123
       	this.creditReasonTax = CarrieCommonUtil.CREDIT_REASON_MAP.get(3);  // CARRIE-1191
        //End of CARRIE-1191
        cashResponse= '';
	    cashResponseTax= '';
	    serviceResponse= '';
	    serviceResponseTax= '';
    }
    
    /**
    * @description: This method validates profile whether a credit more than 5000dk can be issued or not 
    * @jiraIssue CARRIE-186
    */
    public Boolean validProfile(){
        Profile profile = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()];
        for (CarrieCreditProfiles__c creditProfiles : CarrieCreditProfiles__c.getAll().values()){
            if(profile.Name.equals(creditProfiles.Name)){
                creditAllow = true;
            }
        } 
         return creditAllow;
    }
    /**
    * @description: This method is used to issue a cash credit form salesforce.
    */
    public void cashCredit(){
        try{
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'apply_cash_credit', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new map<String,String> { 'account_no' => String.valueOf(ariaAccountNo),'credit_amount' => String.valueOf(credit),'credit_reason_code' => String.valueOf(creditReason),'comments' => String.valueOf(comments)}); 
        	system.debug('response from cash credit call ' +response.getBody());
        	cashResponse = response.getBody();
        	Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        	if(firstMap.get('error_code') != 0){
        		system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        		callFailure = true;
        	}
        }catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
             CarrieLog.LogException(e);
             callFailure = true;
        }
    }
    
    /**
    * @description: This method is used to issue a Tax on cash credit form salesforce.
    */
    public void cashCreditTax(){
        try{
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'apply_cash_credit', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new map<String,String> { 'account_no' => String.valueOf(ariaAccountNo),'credit_amount' => String.valueOf(tax),'credit_reason_code' => String.valueOf(creditReasonTax),'comments' => String.valueOf(comments)}); //CARRIE-657
        	system.debug('response from cash credit tax call ' +response.getBody());
        	cashResponseTax = response.getBody();
        	Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        	if(firstMap.get('error_code') != 0){
        		system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        		callFailure = true;
        	}
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            callFailure = true;
        }
    }
    
    /**
    * @description: This method is used to issue a service credit form salesforce.
    */
    public void serviceCredit(){
       try{
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'apply_service_credit', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new map<String,String> { 'account_no' => String.valueOf(ariaAccountNo),'credit_amount' => String.valueOf(credit),'credit_reason_code' => String.valueOf(creditReason),'comments' => String.valueOf(comments)});
            serviceResponse = response.getBody();
            Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        	if(firstMap.get('error_code') != 0){
        		system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        		callFailure = true;
        	} 
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            callFailure = true;
        }
    }
    
    /**
    * @description: This method is used to issue a Tax on service credit form salesforce.
    */
    public void serviceCreditTax(){
       try{
            response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'apply_service_credit', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c),new map<String,String> { 'account_no' => String.valueOf(ariaAccountNo),'credit_amount' => String.valueOf(tax),'credit_reason_code' => String.valueOf(creditReasonTax),'comments' => String.valueOf(comments)}); //CARRIE-657
            serviceResponseTax = response.getBody();
            Map<String, Object> firstMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        	if(firstMap.get('error_code') != 0){
        		system.debug('error_code ' + firstMap.get('error_code') + ' error_msg ' + firstMap.get('error_msg'));
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        		callFailure = true;
        	}
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
            callFailure = true;
        }
    }
    
    /**
    * @description: Checks if the amount, reason and comments are entered before issuing credit
    * @return: Error value
    */    
    public Boolean validate(){
        Boolean isValid=false;
        amount=amount.replace(',', '.');
        
        if(amount!=null && amount.length()>0){
            credit=0.8*Decimal.valueOf(amount);
            tax=0.2*Decimal.valueOf(amount);
        }else{
            inputHiddenTax='';
        } 
        if(selectComments.equals('Select')){
            Comments = '';
            }else{
            Comments=selectComments;
            }
        if (amount.length()>0 && creditReason.length()>0 && creditType!=null && creditType.length()>0 && creditReason!='0' && Comments.length()>0 ){
            
            if(creditType == '1'){
                cashCredit();
                cashCreditTax();
            	creditType='';
            }else{
                if(creditType == '2'){
                    serviceCredit();
                    serviceCreditTax();
                    creditType='';
                }                    
            }
        }else if(amount.length()==0){
            isValid = true;
            ApexPages.Message amountErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.amount);
            ApexPages.addMessage(amountErrorMsg);
        }else if(creditReason=='0'){
            isValid= true;
            ApexPages.Message creditReasonErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.creditReason);
            ApexPages.addMessage(creditReasonErrorMsg);
        }else if(Comments.length()==0){
            isValid= true;
            ApexPages.Message commentsErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.comments);
            ApexPages.addMessage(commentsErrorMsg);
        }
        else if((creditType == '1' && (cashResponse == '' || cashResponse == null || cashResponseTax == '' || cashResponseTax == null)) || 
        	(creditType == '2' && (serviceResponse == '' || serviceResponse == null || serviceResponseTax == '' || serviceResponseTax == null))){
        	isValid = true;
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        	system.debug('Invalid Response');  
        }	      
        return isValid;
    } 
        
    /**
    * @description: Use to issue a credit and redirect back to carrie home page.
    * @return: PageReference. 
    */
    public PageReference save() {
    	Boolean valid = validate();
    	system.debug('valid ' + valid + ' callFailure ' +callFailure);
        if (valid || callFailure == true){
            return new PageReference('/apex/carriecreditpage?Id='+customer.Id);
         }else{
         	CarrieBillingBatchController car = new CarrieBillingBatchController(customer);
         	car.refreshAriaAccount();
             pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+customer.Id); 
             pageRef.setRedirect(true); 
            return pageRef  ;
        }
    }
    
    /**
    * @description: Use to issue a credit and again redirect to carrie credit page for issuing another credit.
    * @return: PageReference. 
    */
    public PageReference saveNew() {
    	Boolean valid = validate();
    	system.debug('valid ' + valid + ' callFailure ' +callFailure);
        if(!valid || callFailure == false){
        	CarrieBillingBatchController car = new CarrieBillingBatchController(customer);
         	car.refreshAriaAccount();
            pageRef = new PageReference('/apex/carriecreditpage?Id='+customer.Id);
            pageRef.setRedirect(true); 
            return pageRef;
        }else{
            return null;    
        }
    }
    
    /**
    * @description: Use to redirect back to carrie home page.
    * @return: PageReference.
    */
    public PageReference redirectCustomerBillingPage() {
        pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+customer.Id); 
        pageRef.setRedirect(true); 
        return pageRef;
    }
 
    
    /**
    * @description: Use to show radio buttons on vf page and select the type of credit to be issued
    * @return: options Credit type
    */    
    public List<SelectOption> getCreditTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Cash kreditering'));
        if(!hideService){
        options.add(new SelectOption('2','Service kreditering'));
        }
        return options;
    }   
      
    /**
    * @description: Use to populate credit reasons  on vf page and select the reason to be associated with the credit
    * @return: options Credit Reasons
    */ 
    public List<SelectOption> getCreditReasons() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','Vælge'));
        //Start of Carrie-1191
        options.add(new SelectOption(CarrieCommonUtil.CREDIT_REASON_MAP.get(1),'Udbetales på kundens næste regning')); //CARRIE-1191
        //options.add(new SelectOption(CarrieCommonUtil.CREDIT_REASON_MAP.get(2),'Til udbetaling nu')); //CARRIE-1191, CARRIE-1223
        //options.add(new SelectOption('4950261','Udbetales på kundens næste regning')); // Carrie-657
        //options.add(new SelectOption('4950262','Til udbetaling nu')); // Carrie-657  */
        //End of Carrie-1191
		/*
        options.add(new SelectOption('3','Klage'));
        options.add(new SelectOption('4','Manglende signal'));
        options.add(new SelectOption('5','Kulance'));
        options.add(new SelectOption('6','Fejlopkrævning'));
        options.add(new SelectOption('7','Save'));
        options.add(new SelectOption('8','Productændring '));
        */
        return options;
    }   
        
    /**
    * @description: Use to populate credit comments  on vf page from custom settings and select the commnet to be associated with the credit
    * @return: Credit Comments
    */ 
    public void populateComments(){
        commentsList = new List<SelectOption>();
        for (CarrieCreditComments__c comments : CarrieCreditComments__c.getAll().values()){
            commentsList.add(new SelectOption(comments.Comments__c,comments.Comments__c));
        }
    }
}