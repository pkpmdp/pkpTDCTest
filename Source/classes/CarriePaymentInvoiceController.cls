/***********************************************************************************
************************************************************************************

* @class: CarriePaymentInvoiceController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get invoice related information on the invoice page .

************************************************************************************ 
***********************************************************************************/
public with sharing class CarriePaymentInvoiceController{
    private Aria_API_Configuration__c config { get; private set; }
    public Faktura__c invoice {get;set;}       
    public boolean amtflag {get;set;}
    public List<Invoice_Subscription__c> invLineList {get;set;}  
    public List<Invoice_Usage__c> invUsageList {get;set;} // CARRIE-934
	public boolean isBatch {get; set;}
	
    public CarriePaymentInvoiceController(ApexPages.StandardController controller){
        amtflag = false;
        isBatch = false;
        invoice = (Faktura__c)controller.getRecord(); 
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        try{ 
            amtflag = validatePayment();
            invLineList = getInvSubscriptions(); 
            invUsageList = getInvUsages();  // CARRIE-934
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
           CarrieLog.LogException(e);
        }
    }
    
    /**
    * @description: This method is used to  check whether there is a payment for an invoice.
    * @return: if paymentlist is null returns True else False
    */       
    private boolean validatePayment(){
        List<Invoice_Payment__c> paymentList = [select p.Amount_Applied__c from Invoice_Payment__c p where P.Faktura__r.Id =:invoice.Id and p.Amount_Applied__c=0];
        if(paymentList.size()==0) {
            return true; 
        }else {
            return false; 
        }
    }
   
    /**
    * @description: This method is used to  redirect to Carrie Home Page.
    * @return: PageReference
    */
	public PageReference redirectHomePage(){
		PageReference pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+invoice.Aria_Account__c);
        pageRef.setRedirect(true);
		return pageRef;
    }
    
    /**
    * @description: This method is used to fetch Faktura Line subscriptions
    * @return: List<Invoice_Subscription__c> jira issue CARRIE-718
    */   
     public List<Invoice_Subscription__c> getInvSubscriptions()  {
        List<Invoice_Subscription__c> invline = new List<Invoice_Subscription__c>();
        try{
         invline = [Select s.Name, s.Service_Name__c, s.Units__c, s.Pris_pr_md__c, s.Periode__c, s.Amount__c
                     From Invoice_Subscription__c s 
                      Where s.Faktura__r.id =: invoice.Id   order by s.Name];
        }
        catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return invline;
     }
     
    /**
    * @description: This method is used to fetch Faktura Line subscriptions
    * @return: List<Invoice_Usages__c> jira issue CARRIE-934
    */   
     public List<Invoice_Usage__c> getInvUsages()  {
        List<Invoice_Usage__c> invUsage = new List<Invoice_Usage__c>();
        try{
         invUsage = [Select s.Name, s.Plan_Name__c, s.Service_Name__c, s.Periode__c, s.Price_Per_Unit__c, s.Amount__c
                      From Invoice_Usage__c s 
                      Where s.Faktura__r.id =: invoice.Id   order by s.Name];
        }
        catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
        }
        return invUsage;
     } 
}