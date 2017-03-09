/***********************************************************************************
************************************************************************************
* @class: CarriePaymentWrapper
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used as wrapper class for carriepaymentcontroller.
************************************************************************************ 
***********************************************************************************/
public with sharing class CarriePaymentWrapper {
    public Payment__c payment{get;set;}
    public List<Payment__c> paymentList{get;set;}
    public Map<string,string> mapInsertedPayment{get;set;}
    public Map<string,string> mapLongComments{get;set;}  
    public Map<string,List<Payment__c>> mapPayment;
    public Transaction__c trans{get;set;} //@CARRIE-752
    public List<Transaction__c> transList{get;set;} //@CARRIE-752
    public Map<string,string> mapInsertedTrans{get;set;} //@CARRIE-752
    public Map<string,List<Transaction__c>> mapTrans;   //@CARRIE-752   
    public List<String> voidedCredits {get;set;} //carrie-979
    //Added for new batch
    public List<DateTime> latestTransactionDate = new List<DateTime>();
    public CarriePaymentWrapper(){
    }
    
    /**
    * @description: This method is used to set payment .
    */
    public void setMapPayment(Map<string,List<Payment__c>> mapPayment){
        this.mapPayment = mapPayment;
    }
    
    /**
    * @description: This method is used to get the Map of payment .
    * @return: List of payment.
    */
    public Map<string,List<Payment__c>> getMapPayment(){
        return mapPayment;
    }
    //Start of CARRIE-752
    /**
    * @description: This method is used to set Transaction .
    */
    public void setMapTrans(Map<string,List<Transaction__c>> mapTrans){
        this.mapTrans = mapTrans;
    }
    
    /**
    * @description: This method is used to get the Map of Transaction .
    * @return: List of payment.
    */
    public Map<string,List<Transaction__c>> getMapTrans(){
        return mapTrans;
    }
    //end of CARRIE-752    
}