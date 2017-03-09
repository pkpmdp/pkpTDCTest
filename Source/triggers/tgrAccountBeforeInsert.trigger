/*
    @Author: mkha@yousee.dk and wm@yousee.dk
    Test-class: clsAccountTest
    
    Scope: This trigger is fired before inserting and updating accounts (business and person accounts). 
    
    Tasks:
    T1. On insert, if the parent field is populated, update the superiorAccount field to point at the topmost customer (Service-Center project).
    T2. On insert and update for business customers, insert a default Customer Satisfaction 'Ikke relevant' if the current value is null (YS project).  
    
    Validations:
    V1. A customer cannot be reparented if the current customer (hierarchy or cable unit) has any user related roles (YS/Service-Center project).
    V2. Only one cable unit or hierarchy customer be added to a new customer hierarchy at one time (YS/Service-Center project). 
    
    Bypass:
    B1. Cast Iron bypasses most of the logic except mandatory tasks. The bypass is implemented for performance purposes since the validation is aimed at end users.
        
    Switch: 
    S1. Trigger switch that is controlled using custom settings
*/

trigger tgrAccountBeforeInsert on Account (before insert, before update) {    
    //Retrieve Salesforce Ids for Service-Center user roles from custom settings
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger') != null ?  ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c : null;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c : null;
    private static ID userDataLoadId = ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserDataloadNoOutboundId').Value__c : null;
    private static ID userCIId = ServiceCenter_CustomSettings__c.getInstance('UserCIID') != null ? ServiceCenter_CustomSettings__c.getInstance('UserCIID').Value__c : null;
    private static ID userAPIId = ServiceCenter_CustomSettings__c.getInstance('UserAPINOId') != null ? ServiceCenter_CustomSettings__c.getInstance('UserAPINOId').Value__c : null;
    Map<ID,User> UserMap = new Map<ID,User>([select id, name from user where name='Kasia2 User']); // added for skipping rule for marketing permission SPOC-1578
    //B1: Retrieve ID for Cast Iron User for bypassing validation, commented for SF-1364
    //User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];
    
    /*Set<Id> userset = new Set<Id>();
    List<User> userList = new List<User>();
    
    userList = [Select Id, Name From User where Name = 'API No Outbound User' or Name = 'Dataload No Outbound User' or Name = 'CI CastIron' limit 3];
    System.debug('#########UserList Details'+userList+'####Size'+userList.size());
    for(User us : userList){
        userset.add(us.Id);
    }*/
    
    //S1. Retrieve switch control settings from custom settings
    YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl'); 
    Boolean runTrigger = false;
    YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
    
    //Execute code only if trigger is set to true     
    if (config != null && (runTrigger = config.AccountBeforeInsert__c) == true){        
        //T2: Retrieve default update Id from customer satisfaction table
        List<Lookup_Customer_Satisfaction__c> lcss = [Select Id, Name from Lookup_Customer_Satisfaction__c where Name = 'Ikke relevant' limit 1];
        Lookup_Customer_Satisfaction__c lcs;   
        if(lcss.size() > 0)
            lcs = lcss[0]; 
        
        //Sets to store Salesforce ids for business customers
        Set<Id> businessCustomers = new Set<Id>();            
        Set <Id> parentIds = new Set<Id>();     
        
        for(Account acc: Trigger.new){ 
          //Critical code - don't change
          //This code is added to reset the field isNew to false after creation. This is implemented to handle issues in Cast Iron
          if (Trigger.isUpdate && acc.isPersonAccount == true && acc.isNew__c == true){
                  acc.isNew__c = false;                   
            }          
            //Collecting necessary ids for validation purposes - business customers only
            if(!businessCustomers.contains(acc.Id) && acc.IsPersonAccount == false)
                businessCustomers.add(acc.Id);
            
            //Used for various validations on insert and update         
            if(!parentIds.contains(acc.ParentId) && acc.IsPersonAccount == false)
                parentIds.add(acc.ParentId);            
            //T2: Insert default value if customer satisfaction is null
            if(acc.IsPersonAccount == false && acc.Customer_Satisfaction_Lookup__c == null && lcs != null)
                acc.Customer_Satisfaction_Lookup__c = lcs.Id;
        }        
        
        
        /*  
        //Addedd code for SPOC-1511 for validating personmobile and personHomephone 
        Map<ID,User> UserMap = new Map<ID,User>([select id, name from user where name='Kasia2 User']); 
        if(Trigger.new.size()==1 && !userset.contains(UserInfo.getUserId()) && UserMap.get(UserInfo.getUserId())==null){
            Account acc = Trigger.new[0];           
            List<ICHNumberPlanRange__c> validRangeMobPhone = new List<ICHNumberPlanRange__c>();
            List<ICHNumberPlanRange__c> validRangeHomePhone = new List<ICHNumberPlanRange__c>();
            if(acc.PersonMobilePhone!=null && acc.PersonMobilePhone.length()>0){
            validRangeMobPhone = [select id from ICHNumberPlanRange__c where FirstPhoneNumber__c <=:Double.valueOf(acc.PersonMobilePhone) and LastPhoneNumber__c >= :Double.valueOf(acc.PersonMobilePhone) and NumberType__c='GSM' limit 1];
            if(validRangeMobPhone.size()==0)
            acc.addError('Invalid range for Mobile number');
            }
            if(acc.Home_Phone__c!=null && acc.Home_Phone__c.length()>0){
            validRangeHomePhone = [select id from ICHNumberPlanRange__c where FirstPhoneNumber__c <=:Double.valueOf(acc.Home_Phone__c) and LastPhoneNumber__c >= :Double.valueOf(acc.Home_Phone__c) and NumberType__c='FIXED' limit 1];
            if(validRangeHomePhone.size()==0)acc.addError('Invalid range for Home Phone number');   
            }
            
        }
        */
        
        //Addedd code for validation for marketing permission SPOC-1578
        if(Trigger.new.size()==1 && UserInfo.getUserId() != userDataLoadId && UserInfo.getUserId() != userCIId && UserInfo.getUserId() != userAPIId){
            Account acc = Trigger.new[0]; 
            Permission__c permission;
            if(acc.isPersonAccount == true && UserMap.get(UserInfo.getUserId())==null){            
            if(Trigger.isUpdate && (acc.PersonMobilePhone==null && acc.Home_Phone__c==null && acc.PersonEmail == null)){
	            try{ //added for SUPPORT-1481
		          	List<Permission__c> permList = new List<Permission__c>();
		          	permList = [select Marketing_Permission__c from permission__c where customer__c = :acc.id limit 1];     
		          	if(permList.size() > 0){
		            	permission = permList[0];
		          	}	           
		            if(permission != null && permission.Marketing_Permission__c == true)
	            		acc.addError(System.label.Marketing_permission_validation_on_Account); 
	            }catch(System.QueryException e){}
	            
	            }
          }  
        }
        //end of validation for marketing permission SPOC-1578        
        
        //B1 + S1: This logic should not be executed if user is Cast Iron or if customer is a person account
        //if (businessCustomers.size() > 0 && UserInfo.getUserId() != CastIron.Id){
        
        
        // changes done for SF-1364 
        //if (businessCustomers.size() > 0 && !userset.contains(UserInfo.getUserId())){ 
            
            
        if (businessCustomers.size() > 0 && UserInfo.getUserId() != userDataLoadId && UserInfo.getUserId() != userCIId && UserInfo.getUserId() != userAPIId){   
            Map <Id, Id> superiorAccountInformation = new Map <Id, Id>();        
            Set <Id> customerWithUserRoles = new Set<Id>(); 
            Set <Id> customerHasChilds = new Set<Id>();
            Set <Id> portalActiveNewCustomer = new Set<Id>();   
            
            //Prepare data for validation
            //T1: Identify the superior account reference for parent customers - provided that the customer has a parent            
            for(Account acc: [Select Id, SuperiorAccount__c from Account where isPersonAccount = false and Id IN : parentIds]){         
                //T1: Map storing information about the superior account for the customer being inserted/updated
                if(acc.SuperiorAccount__c != null){
                    //T1: If the parent is not null and if the parent has a reference to a superior account then insert the superior reference Id.
                    superiorAccountInformation.put(acc.Id, acc.SuperiorAccount__c);
                }           
                else{
                    //T1: If the parent is not null and if the parent has no reference to a superior account then insert reference to the parent account.
                    superiorAccountInformation.put(acc.Id, acc.Id);
                }
            } 
             
            if(Trigger.isUpdate){
                //V1: Adds customers having user roles for later validation
                for(Account account : [Select Id from Account where isPersonAccount = false and Id IN : businessCustomers and ID IN (Select Customer__c from Account_Contact_Role__c where (Role__c = : portalUserRoleId OR Role__c = : portalUserAdministratorRoleId) and Customer__c IN : businessCustomers) ]){
                    if(!customerWithUserRoles.contains(account.Id))
                        customerWithUserRoles.add(account.Id);          
                }
                //V2: Adds new parent customers having user roles for later validation      
                for(Account account : [Select Id from Account where isPersonAccount = false and ID IN : parentIds and ID IN (Select Customer__c from Account_Contact_Role__c where (Role__c = : portalUserRoleId OR Role__c = : portalUserAdministratorRoleId) and Customer__c IN : parentIds) ]){
                    if(!portalActiveNewCustomer.contains(account.Id))
                        portalActiveNewCustomer.add(account.Id);            
                }
                //V2: Adds customers having childs nodes for later validation           
                for(Account account : [Select Id, ParentId from Account where isPersonAccount = false and ParentId IN :businessCustomers]){
                    if(!customerHasChilds.contains(account.ParentId))
                        customerHasChilds.add(account.ParentId);
                }           
          }
            //Process validations
            for(Account acc: trigger.new){
                //V1+V2: Process validations for YS/Service-center related functionality
                if(Trigger.isUpdate){ 
                    if(acc.ParentId != null && Trigger.oldMap.get(acc.Id).ParentId != acc.ParentId){                      
                        if(customerWithUserRoles.contains(acc.Id))
                            acc.addError(Label.SC_New_Hierarchy_Portal_Users);
                        else if(customerHasChilds.contains(acc.Id) && portalActiveNewCustomer.contains(acc.ParentId))
                            acc.addError(Label.SC_New_Hierarchy_Child_Nodes);
                    }
                }                 
                //T1:If parent is not null, retrieve the superiorAccount reference
                if(acc.ParentId != null){                       
                  acc.SuperiorAccount__c = superiorAccountInformation.get(acc.ParentId);
                }               
                else //T1: If parent is null, superiorAccount is nullified. A lookup cannot point at this node
                  acc.SuperiorAccount__c  = null;
                                                       
            }//End for structure            
            
            /* Old version where superiorAccount is only set on Trigger.Insert actions
            for(Account acc: trigger.new){              
                if(Trigger.isInsert){
                    //T1:If parent is not null, retrieve the superiorAccount reference
                    if(acc.ParentId != null){                       
                        acc.SuperiorAccount__c = superiorAccountInformation.get(acc.ParentId);
                    }               
                    else //T1: If parent is null, superiorAccount is nullified. A lookup cannot point at this node
                        acc.SuperiorAccount__c  = null;         
                }
                //V1+V2: Process validations for YS/Service-center related functionality
                else if(Trigger.isUpdate){ 
                    if(acc.ParentId != null && Trigger.oldMap.get(acc.Id).ParentId != acc.ParentId){
                        if(customerWithUserRoles.contains(acc.Id))
                            acc.addError(Label.SC_New_Hierarchy_Portal_Users);
                        else if(customerHasChilds.contains(acc.Id) && portalActiveNewCustomer.contains(acc.ParentId))
                            acc.addError(Label.SC_New_Hierarchy_Child_Nodes);                       
                    }
                }                               
            }//End for structure
            */
            
        }//End if business customer not empty                                                      
    }//End outer switch    
}//End trigger class