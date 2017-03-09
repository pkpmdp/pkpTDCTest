/***********************************************************************************
************************************************************************************

* @class: CarrieInvoicePaymentController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get payment related information on the payment page .

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieInvoicePaymentController{
	private Aria_API_Configuration__c config { get; private set; }
    public Payment__c payment{get;set;}
    public String showForbrug{get;set;}
    public boolean isBatch {get; set;}   
    
    public CarrieInvoicePaymentController(ApexPages.StandardController controller) {
    	isBatch = false;
        payment = (Payment__c)controller.getRecord();
        if(payment.Aria_Account__r.Aria_Plan_Name__c=='YouBio' && payment.Payment_Type__c =='Credit'){ 
        	showForbrug='false';
        }else{
        	showForbrug ='true';
        }
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        if(config == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a valid Aria API configuration.'));     
        }
    }
    
    /**
    * @description: This method is used to  redirect to Carrie Home Page.
    * @return: PageReference
    */
    public PageReference redirectHomePage(){
    	PageReference pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+payment.Aria_Account__c); 
    	pageRef.setRedirect(true);
		return pageRef;
    }
}