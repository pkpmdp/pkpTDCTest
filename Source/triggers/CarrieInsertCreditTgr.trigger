/***********************************************************************************
************************************************************************************

* @class: CarrieInsertCreditTgr
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Trigger is fired on Payment Object after a payment is inserted and payment type is credit.

************************************************************************************ 
***********************************************************************************/
trigger CarrieInsertCreditTgr on Payment__c (after insert) {
    try{
        List<Unapplied_Credit__c> insertCredit = new List<Unapplied_Credit__c>(); 
        Unapplied_Credit__c newCredits;
        for(Payment__c payment : Trigger.new){
            if( payment.Amount__c > 0 && payment.Payment_Type__c == 'Credit'){
                newCredits = new Unapplied_Credit__c();
                newCredits.Amount__c =  payment.Amount__c;
                newCredits.Date__c = payment.Payment_Date__c;
                newCredits.Customer__c = payment.Customer__c;
                newCredits.Aria_Account__c = payment.Aria_Account__c;
                newCredits.Name = payment.transaction_source_id__c;
                newCredits.Indbetalinger__c = payment.Id;
                newCredits.Unapplied_Amount1__c = payment.Unapplied__c;
                newCredits.Credit_type__c = 'Cash';
                newCredits.Comments__c = payment.Comments__c; 
                newCredits.commentsLong__c = payment.CommentsLong__c;
                newCredits.External_Name__c = payment.Name;
                insertCredit.add(newCredits);
            }
        }
        upsert insertCredit External_Name__c;
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
    }
}