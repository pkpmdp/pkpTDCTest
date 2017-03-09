/*
    @Author: mkha@yousee.dk and wm@yousee.dk
    Test-class: clsContactTest
    
    Scope: This trigger is fired before inserting and updating contacts. 
    
    Tasks:
    T1. On insert and update events, a dummy account is added to the contact. This is to ensure that contacts can be shared in the YS project.  
    
    Validations:
    V1. The field Status__c cannot be set to 'Inaktiv' if the contact has one or more contact roles (YS project) - see also https://yousee.jira.com/browse/CRM-154.
    V2. Validation on unique email. No contacts must share the same standard email to avoid error in customer portals (YS project). See also https://yousee.jira.com/browse/CRM-155
    V3. If the contact is a Service-Center portal user or administrator, the hierarchy account cannot be changed or nullified (Service-Center project). 
    
    Bypass:
    B1. Cast Iron bypasses most of the logic except adding dummy accounts. The bypass is implemented for performance purposes since the validation is aimed at end users.
    B2. Temporary contacts used in NP project to send e-mails to customers are bypassed
    B3. Person Account contacts are excluded from validation    
*/
trigger tgrContactBeforeInsert on Contact (before update, before insert) {
    //T1: Add dummy account on insert and update events
    system.debug('Before bulk inserting dummy account');
    clsContactsAddAccount util = new clsContactsAddAccount();
    util.addDummyAccounts(Trigger.new);    
    system.debug('Finished inserting dummy account');
       
    //Retrive ID for Cast Iron User for bypassing validation. code commented for SF-1364   
    //public static User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    
    // Code Changes for SF-1364
    /*Set<Id> userset = new Set<Id>();
    List<User> userList = new List<User>();
    
    userList = [Select Id, Name From User where Name = 'API No Outbound User' or Name = 'Dataload No Outbound User' or Name = 'CI CastIron' limit 3];
    System.debug('#########UserList Details'+userList+'####Size'+userList.size());
    for(User us : userList){
        userset.add(us.Id);
    }*/
    
    private static ID userDataLoadId = ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId').Value__c : null;
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    private static ID userAPIId = ServiceCenter_CustomSettings__c.getInstance('UserAPINOId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserAPINOId').Value__c : null;
    //private static ID yoaProfileId = ServiceCenter_CustomSettings__c.getInstance('OKTKPAgent_ProfileID') != null ? ServiceCenter_CustomSettings__c.getInstance('OKTKPAgent_ProfileID').Value__c : null;
    
    //Fetch YS contact record type 
    /*public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;*/
    
    String ysContactRecordType = System.Label.YS_Contact_Record_Type;

    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger') != null ?  ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c : null;
    system.debug('Retrieved user role id for Service-Center portal user: ' + portalUserRoleId);
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c : null;
    system.debug('Retrieved user role id for Service-Center administrator: ' + portalUserAdministratorRoleId);      
    
    //B1: CI user is bypassed code commented for SF-1364
    //if (UserInfo.getUserId() != CastIron.Id){
    
    if (UserInfo.getUserId() != userDataLoadId && UserInfo.getUserId() != userCIId && UserInfo.getUserId() != userAPIId ){
        system.debug('Inside bypassed Cast Iron logic');    
        //V2: Map to store candidates for duplicate email check
        Map<String, Contact> duplicateEmailCandidateMap = new Map<String, Contact>();
        
        if (Trigger.isUpdate){
            system.debug('Inside Trigger.isUpdate');
            //Gather all contact Id's in a unique Set        
            Set <Id> contactIdSet = new Set<Id>();
            for(Contact con: Trigger.new){
                if(!contactIdSet.contains(con.Id) && con.RecordTypeId == ysContactRecordType)
                    contactIdSet.add(con.Id);
            }
            system.debug('Number of YS contact Ids to be processed' + contactIdSet.size());
            Map<Id, Contact> contactMap = new Map<Id, Contact>();
            Set<Id> contactWithPortalUser = new Set<Id>(); 
            if(contactIdSet.size() > 0){
                //V1: Identify those contacts that have related roles.
                for(Contact con: [select Id from Contact where Id IN (Select Contact__c from Account_Contact_Role__c where Contact__c IN : contactIdSet)]){
                    if(contactMap.get(con.Id) == null)
                        contactMap.put(con.Id, con);              
                }
                system.debug('V1: Found ' + contactmap.size() + ' that have related contact roles');
                
                system.debug('V1: contactIdSet --------> ' + contactIdSet);
                system.debug('V1: portalUserAdministratorRoleId --------> ' + portalUserAdministratorRoleId);
                system.debug('V1: portalUserRoleId --------> ' + portalUserRoleId);
                
                //V3: Identify contacts who are also portal users in Service-Center
                for(Contact contactWithUser: [Select Id from Contact where Id IN : contactIdSet and HierarchyAccount__c IN (Select Customer__c from Account_Contact_Role__c where Contact__c IN : contactIdSet and (Role__c = :portalUserAdministratorRoleId OR Role__c = :portalUserRoleId)) ]){
                    if(!contactWithPortalUser.contains(contactWithUser.Id))
                        contactWithPortalUser.add(contactWithUser.Id);
                }           
                /* Old version caused some issues
                Set<Id> contactWithPortalUser = new Set<Id>();  
                for(User portalUser: [Select ContactId from User where IsActive = true and ContactId IN : contactIdSet and (ProfileId = : serviceCenterPortalUserProfileId OR ProfileId = :serviceCenterPortalAdministratorProfileId)]){
                    if(!contactWithPortalUser.contains(portalUser.ContactId))
                        contactWithPortalUser.add(portalUser.ContactId);
                }
                */                  
                system.debug('V3: Found ' + contactWithPortalUser.size() + ' that are Service-Center portal users');
            }//End for structure for initializing YS validations
            
            for(Contact con: Trigger.new){
                system.debug('Looping through contacts');
                //B2+B3: Person account contacts and temporary contacts excluded from validation
                if(!con.isPersonAccount && !con.Temporary_contact__c && con.RecordTypeId == ysContactRecordType){
                    /* Update custom fields to capture information about user changes (except Cast Iron). The fields are used because Cast Iron
                       overwrites standard field lastModifiedBy every night in Service-Center batch jobs
                    */
                    con.Last_Change_User__c = UserInfo.getUserId();
                    con.Last_Change_Time__c = DateTime.now();    
                    system.debug('Inside if-structure = contact is not personAccount or temporary contact');
                    //V1: Validation on inactive field
                    if (Trigger.oldMap.get(con.Id).Status__c != con.Status__c && contactMap.get(con.Id)!= null && con.Status__c == 'Inaktiv')
                    {
                        system.debug('V1: Validation error. Contact has external role');
                        con.AddError(Label.YS_ContactHasExternalRole);
                    }
                    
                    //V3: Service-Center validation flow on hierarchy account
                    if(contactWithPortalUser.contains(con.Id)){
                        if(con.HierarchyAccount__c == null){
                            system.debug('V3: Validation error. Contact/user has a null value in hierarchy account');
                            con.addError(Label.SC_HierarchyAccount_Update_Error);                           
                        }                                
                        else if(Trigger.oldMap.get(con.Id).HierarchyAccount__c != con.HierarchyAccount__c){
                            system.debug('V3: Validation error. Contact/user has been assigned a new hierarchy account');
                            con.addError(Label.SC_HierarchyAccount_Cannot_be_Changed);
                        }
                    }                   
                    
                    //V2: Unique email validation for updated email field on existing contacts
                    if(con.Email != null){                                                                  
                        //Null check for e-mail is conducted in various scenarios
                        if ( ( Trigger.oldMap.get(con.Id).Email == null) || 
                             ( Trigger.oldMap.get(con.Id).Email != null && con.Email.trim() != Trigger.oldMap.get(con.Id).Email.trim()))                 
                        {                       
                            //Add contact to map for duplicate check                        
                            if(duplicateEmailCandidateMap.get(con.Email) == null)
                                duplicateEmailCandidateMap.put(con.Email, con);
                            system.debug('V2: Existing contact having updated e-mail: ' + con.Email + ' added for duplicate check');                                                        
                        }
                    }
                }
            }//End outer for structure      
        }//End Trigger.isUpdate
        else{
            //V2: Validation of e-mail for new contacts
            for(Contact con: Trigger.new){                          
                if(con.RecordTypeId == ysContactRecordType && con.Email != null && duplicateEmailCandidateMap.get(con.Email) == null && !con.isPersonAccount && !con.Temporary_contact__c){
                    duplicateEmailCandidateMap.put(con.Email, con);
                    system.debug('V2: New contact having e-mail: '+ con.email + ' added for duplicate check');  
                }  
                
                
                      
            }//End for-structure
        }//End else structure
        System.debug('recusrssivePreventController.flag@@@@@@@@@@@@'+recusrssionPreventController.flag);
         
        if(recusrssionPreventController.flag == true){
            if (duplicateEmailCandidateMap.size() > 0){
                //V2, B2+B3: Common check for duplicate email
                for (Contact con : [Select Id, Email from Contact where RecordTypeId = :ysContactRecordType and IsPersonAccount = false and Temporary_contact__c = false and Email IN : duplicateEmailCandidateMap.KeySet()]){          
                    Contact conError = duplicateEmailCandidateMap.get(con.Email);               
                    if(conError != null){
                        conError.addError(Label.YS_ContactHasDuplicateEmail);
                        system.debug('V2: Contact having e-mail ' + con.Email + ' already exists on ' + conError.Id);   
                    }           
                }
            }
            recusrssionPreventController.flag = false;
        }
    }//Close Cast Iron clause
        
}//End trigger