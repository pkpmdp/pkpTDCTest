public class ViewInvoiceGeneralController{
    private String legalAccNumber;
    private String paymentAccNumber;
    private String cableunitName;
    private String legalAccId;
    private String paymentAccId;
    public String cableUnitNumber;
    public String portalBrugerRole {get; set;}
    public String siteCoreUrl{get; set;}
    public String accountId{get;set;}//support-5377
    public Boolean renderSection{get;set;}//Support-5377
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewInvoiceGeneralController','View invoices');
    public String getLegalAccId(){
        //System.debug('Legal Account id'+legalAccId);
        return legalAccId;
    }
    public String getPaymentAccId(){
        //System.debug('Payment Account Id'+paymentAccId);
        return paymentAccId;
    }
    public String getLegalAccNumber(){
        //System.debug('Legal Account Number'+legalAccNumber);
        return legalAccNumber;
    }
    public String getPaymentAccNumber(){
        //System.debug('Payment Account Number'+paymentAccNumber);
        return paymentAccNumber;
    }
    public String getCableunitName(){
        //System.debug('CableUnitName'+cableunitName);
        return cableunitName;
    }
    public ViewInvoiceGeneralController() { 
        try {
              	portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
                siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
             accountId = ApexPages.CurrentPage().getParameters().get('accountId');
            
             cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
             Boolean cableUnitNotMatch = false;
             renderSection = true;
            
                List <Cable_Unit__c> cuList=[Select c.Name,c.Legal_Account_No__c,c.Payment_Account_No__c ,
                                                c.Legal_Account_No__r.customer_No__c, c.Payment_Account_No__r.customer_No__c 
                                                from Cable_Unit__c c where c.Cable_Unit_No__c =: ApexPages.CurrentPage().getParameters().get('cableunitnumber') limit 1];
                 //system.debug('Cable unit list'+cuList); 
                  list<Account> accList = new list<Account>();
                  accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];  
                  if(!accList.isEmpty()){
                 system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
             if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
             } 
                 else{
                 if(cuList!= null && cuList.size() > 0){
                    cableunitName  = cuList[0].Name;
                    
                    legalAccNumber = cuList[0].Legal_Account_No__r.customer_No__c;
                    
                    // Hard coded for checking
                    //paymentAccNumber = '611472946';
                    paymentAccNumber = cuList[0].Payment_Account_No__r.customer_No__c;
                    //system.debug('$Legal Account Number$'+legalAccNumber+'$Payment Account Number$'+paymentAccNumber);
                    legalAccId = cuList[0].Legal_Account_No__c;
                    paymentAccId = cuList[0].Payment_Account_No__c; 
                    //System.debug('*1*'+cableunitName+'*2*'+legalAccNumber+'*3*'+paymentAccNumber+'*4*'+legalAccId+'*5*'+paymentAccId);        
                }
           }
       }
            else{
                renderSection=false;
            }
        }
            catch (Exception e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
         }                       
    }
}