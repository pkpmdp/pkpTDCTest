trigger trackthedeletiontrigger on Account_Contact_Role__c (before delete) {
    
    System.debug('**** In trigger');
    List<History_Log_External_Contact_Role__c> logList = new List<History_Log_External_Contact_Role__c>();
for (Account_Contact_Role__c a : trigger.old){
    if(a.RoleName__c== 'Selvbetjeningsadministrator' || a.RoleName__c=='Selvbetjeningsbruger')
    {
        History_Log_External_Contact_Role__c log = new History_Log_External_Contact_Role__c();
        //log.Customer_Name__c=a.LastModifiedById;
        system.debug('log.Customer_Name__c***'+a.LastModifiedById);
        String del = userinfo.getName();
        Datetime d = Datetime.now();
        del += ' '+ d.format('dd-MM-YYYY hh:mm');
        log.Deleted_Contact_by_1__c = del;
        log.Cable_Unit_No__c=a.CableUnit__c;
        log.Action__c='Delete';
        
        log.Old_RoleName__c=a.RoleName__c;
        log.Old_ContactId__c=a.Contact__c;
        //log.Account__c=a.Contact__c;
       
        //Contact con = [select Id , AccountId FROM Contact WHERE Id = : a.Contact__c];
       log.Account__c = a.Customer__c;
       logList.add(log);
       //system.debug('log id*****'+log.Id);
    } 
     
}
    if(!logList.isEmpty())
    {
        insert logList;
    }
    
}