public with sharing class ConsoleKundeLog_CT{

    public String currentId{get;set;}
    public String strNotes{get;set;}
    public Customer_Log__c objNotes{get;set;}
    public Boolean enable{get;set;}
    
    public ConsoleKundeLog_CT()
    { 
        ConsoleCustTypeCustomLog__c obj = ConsoleCustTypeCustomLog__c.getInstance(UserInfo.getProfileId());
        enable = obj.isPicklistVisible__c;
        strNotes = '';
        objNotes = new Customer_Log__c();
        objNotes.Inquiry_Type__c = obj.Inquirytypevalue__c;
        
    }
    public ConsoleKundeLog_CT(ApexPages.standardController ctlr){
        
    }
     
    
    public pagereference btnSave(){
        
        //objNotes = new Customer_Log__c();
        system.debug('==in here=='+currentId);
        if(strNotes!=''){
            //objNotes = new Customer_Log__c(Customer__c = currentId ,Text__c = strNotes);
            objNotes.Customer__c=currentId ;
            objNotes.Text__c = strNotes;
            insert objNotes;
            system.debug('====objNotes'+objNotes);
            strNotes = '';
            //objNotes.Inquiry_Type__c = '3';
            
        }
        return null;
    }
}