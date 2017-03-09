/*
    @Author: mkha@yousee.dk
    Test-class: clsContactTest
    
    Scope: This trigger is fired after updating contacts. 
    
    Tasks:
    T1: If the contact record on a Service-Center portal user is updated, then we update the corresponding user record with e-mail and first and lastname. 
    The user name is not updated. It's important that portal user records are always in sync with the associated contact record to ensure data quality
    
    Bypass:
    B1. Cast Iron bypasses most of the logic except adding dummy accounts. The bypass is implemented for performance purposes since the validation is aimed at end users.   
    B2. Person Account contacts are excluded from validation
    
*/
trigger tgrContactAfterUpdate on Contact (after update) {
    //Fetch YS contact record type 
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
    String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;  
    private static ID userDataLoadId = ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId').Value__c : null;
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    private static ID userAPIId = ServiceCenter_CustomSettings__c.getInstance('UserAPINOId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserAPINOId').Value__c : null;
    
    //B1: Retrieve ID for Cast Iron User for bypassing validation. Code Commented for SF-1364  
    //public static User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    
    // Code Changes for SF-1364
    
    /*Set<Id> userset = new Set<Id>();
    List<User> userList = new List<User>();
    
    userList = [Select Id, Name From User where Name = 'API No Outbound User' or Name = 'Dataload No Outbound User' or Name = 'CI CastIron' limit 3];
    System.debug('#########UserList Details'+userList+'####Size'+userList.size());
    for(User us : userList){
        userset.add(us.Id);
    }*/
    
    //B1: Cast Iron is bypassed, Code Commented for SF-1364
    //if (UserInfo.getUserId() != CastIron.Id){   
    if (UserInfo.getUserId() != userDataLoadId && UserInfo.getUserId() != userCIId && UserInfo.getUserId() != userAPIId){ 
        List <User> portalUsersToBeUpdated = new List<User>();  
        //Map<Id, Contact> ContactMap = new Map<Id, Contact>();
        Set<Id> contactsToBeUpdated = new Set<Id>();
        if(Trigger.isUpdate){        
            for(Contact con: Trigger.new){
                    //T1 + B2: Find contacts where e-mail, first or last name has changed and add it to a map            
                    if( ( Trigger.oldMap.get(con.Id).Email != con.Email ||
                          Trigger.oldMap.get(con.Id).FirstName != con.FirstName ||
                          Trigger.oldMap.get(con.Id).LastName != con.LastName) &&
                        !contactsToBeUpdated.contains(con.Id) && con.IsPersonAccount == false && con.RecordTypeId == ysContactRecordType){
                            contactsToBeUpdated.add(con.Id);
                    }
            }
          System.debug('Contact Set with update on User object: ' + contactsToBeUpdated);
        }//Close If update
       
       //Update user object in separate transaction to avoid mixed dml issue in Salesforce.
       if(contactsToBeUpdated.size() > 0 && !System.isBatch() && !System.isFuture() && !System.isScheduled() && !Recursioncontrol.runonce){
            try{
                clsAsyncMethods.updateUserObject(contactsToBeUpdated);
            }catch(Exception e){
                system.debug('Exception caught when synchronizing contact with portal users' + e.getMessage()); 
            }
       }
    }//Close NON API User
}//End class