public with sharing class KundeNumberSearchController {

   // public Flow.Interview.Customer_Search_Test my_interview { get; set; }
    //Public String KundeNumber{get;set;} 
    public String Customer_Search_Test { get; set; }

    public KundeNumberSearchController() {

    }

 
    Public String KundeNumber{get;set;}
    Public List<Account> accounts{get;set;}
    public string result{get;set;}
    public string accId{get; set;}
    Public KundeNumberSearchController (ApexPages.StandardController standardController){
         KundeNumber= ApexPages.currentPage().getParameters().get('KundeNumber');
         KundeNumber= KundeNumber.trim();        
    }
    
    Public void showAccountbykundenumber(){
            System.debug('KundeNumber:' +KundeNumber);
           accounts= [Select Id,name,Customer_No__c from Account where Customer_No__c=: KundeNumber];
           System.debug('accounts:' +accounts);
           if(accounts.size()>0){
               result = 'positive';
               accId = accounts[0].Id;
            //    return new PageReference('/' + accounts[0].Id);
           }else if(KundeNumber.length() < 10 && !KundeNumber.startswith('H')){
               while (KundeNumber.length() < 10) {
                KundeNumber= '0' + KundeNumber;
                }
                accounts= [Select Id,name,Customer_No__c from Account where Customer_No__c=: KundeNumber]; 
               if(accounts.size()>0){
                   result = 'positive';
                   accId = accounts[0].Id;
                //    return new PageReference('/' + accounts[0].Id);
               }else{
                   result = 'negative';
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med kundenummer '+KundeNumber +' i SPOC'));
                //return null; 
               }
                
           }else{
               result = 'negative';
              //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med kundenummer '+KundeNumber +' i SPOC'));
                //return null; 
           }
     } 
}