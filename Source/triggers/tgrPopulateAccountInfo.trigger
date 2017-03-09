trigger tgrPopulateAccountInfo on Lead (before insert) {
    
    Public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');  
    Public  String yousee13SiteGuestUserProfile = yousee13.SiteGuestUserId__c;
    Public String yousee13LeadRecordType = yousee13.Lead_RecordType__c;  
    
    if(Trigger.isBefore && Trigger.IsInsert && UserInfo.getUserId() != yousee13SiteGuestUserProfile){
        for(Lead ld : Trigger.new) {
             if(ld.RecordTypeId == yousee13LeadRecordType && ld.Account_YS_Live_13__c != null) {
                System.debug(' VISHAL LOG : ld.Account_YS_Live_13__c ' + ld.Account_YS_Live_13__c);
                Account acc = [select a.id, a.type, a.Name, a.Customer_No__c, a.Cable_Unit_No__c, a.Cable_Unit_Name__c, a.Anlaeg_No__c, a.Anlaeg_Name__c from Account a where a.id = :ld.Account_YS_Live_13__c AND a.IsPersonAccount =false limit 1];
                
                if(acc != null) {
                    if(acc.Cable_Unit_No__c != null){ 
                        ld.Anlaeg_No__c = acc.Cable_Unit_No__c;
                        //ld.Anlaeg_No__c = acc.Anlaeg_No__c;
                    }   
                    if(acc.Anlaeg_Name__c != null){ 
                        ld.Anlaeg_Name__c = acc.Cable_Unit_Name__c;
                        //ld.Anlaeg_Name__c = acc.Anlaeg_Name__c;
                    }
                    System.debug(' VISHAL LOG : Customer_No__c ' + acc.Customer_No__c);
                    //ld.Account_YS_Live_13__c = acc.id;
                    ld.Customer_Number__c = acc.Customer_No__c;               
                    ld.Company = acc.name;
                }    
                
             }
        }
    }
}