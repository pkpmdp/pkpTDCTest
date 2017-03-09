/***********************************************************************************
************************************************************************************

* @class: CarrieInvoiceWrapper
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used as wrapper class for carrieinvoicecontroller.

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieInvoiceWrapper {
    public List<Faktura__c> invoiceList{get;set;}
    public List<Faktura__c> previousInvoiceList;
    public Map<String, List<Invoice_Usage__c>> usageMap;
    public Map<String, List<Invoice_Subscription__c>> subscriptionMap;
    public List<Invoice_Subscription__c> invoiceSubscriptionList{get;set;}
    public List<Invoice_Usage__c> invoiceUsageList{get;set;}
    public Map<string,string> invoiceMap{get;set;}
    public List<Applied_Credit__c> serviceCreditList{get;set;}
    public Map<string,string> dummyInvoiceMap{get;set;}
    
    public CarrieInvoiceWrapper(){
        
    }
    
    public CarrieInvoiceWrapper (List<Faktura__c> invoiceList,List<Faktura__c> previousInvoiceList,Map<String, List<Invoice_Subscription__c>> subscriptionMap,Map<String, List<Invoice_Usage__c>> usageMap, List<Invoice_Subscription__c> invoiceSubscriptionList, List<Invoice_Usage__c> invoiceUsageList){
        if(invoiceList!=null){
            this.invoiceList = invoiceList;
        }else{
            this.invoiceList = new List<Faktura__c>();
        }
        if(previousInvoiceList!=null){
            this.previousInvoiceList = previousInvoiceList;
        }else{
            this.previousInvoiceList = new List<Faktura__c>();
        }
        if(subscriptionMap!=null){
            this.subscriptionMap = subscriptionMap;
        }else{
            this.subscriptionMap = new Map<String, List<Invoice_Subscription__c>>();
        }
        if(usageMap!=null){
            this.usageMap = usageMap;
        }else{
            this.usageMap = new Map<String, List<Invoice_Usage__c>>();
        }
        if(invoiceSubscriptionList!=null){
            this.invoiceSubscriptionList = invoiceSubscriptionList;
        }else{
            this.invoiceSubscriptionList = new List<Invoice_Subscription__c>();
        }
        if(invoiceUsageList!=null){
            this.invoiceUsageList = invoiceUsageList;
        }else{
            this.invoiceUsageList = new List<Invoice_Usage__c>();
        }
    }
    
    /**
    * @description: This method is used to get the List of invoices .
    * @return: List of invoices.
    */
    public List<Faktura__c> getPreviousInvoiceList(){
        return previousInvoiceList;
    }
    
    /**
    * @description: This method is used to get the map of  Subscription.
    * @return: Subscription Map.
    */
    public Map<String, List<Invoice_Subscription__c>> getSubscriptionMap(){
        return subscriptionMap;
    }
    
    /**
    * @description: This method is used to get the map of Usgae.
    * @return: Usgae Map.
    */
    public Map<String, List<Invoice_Usage__c>> getUsageMap(){
        return usageMap;
    }
}