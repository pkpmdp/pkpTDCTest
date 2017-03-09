/***********************************************************************************
************************************************************************************

* @class: CarrieInvoicePaymentWrapper
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used as a wrapper class for CarrieParseJsonTransaction .

************************************************************************************ 
***********************************************************************************/
public with sharing class CarrieInvoicePaymentWrapper {
    public Map<String,List<Payment__c>> InvoicePaymentMap{get; set;}
    public Map<String,String> defaultInvoice{get; set;}
    public Map<String,String> otherInvoice{get; set;}
    public Map<String,String> statementNo{get; set;}
    public Map<String,String> transdate{get; set;}//added for SPOC-1916

    public Map<String,Invoice_Payment__c> defaultInvoiceObjects{get; set;}
    public List<Invoice_Payment__c> invoicePaymentList{get;set;}
    public List<Payment_Invoice__c> paymentInvoiceList{get;set;}
    public List<Invoice_Payment__c> deleteVoidedInvoice {get;set;}
    public List<Payment_Invoice__c> deleteVoidedInvoicePayment {get;set;}

    public CarrieInvoicePaymentWrapper(){
    }

}