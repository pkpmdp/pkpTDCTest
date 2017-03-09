trigger tgrAccountPermissionAfterInsertUpdate on Account (after insert, after update) {

if(!RecursionControlPermission.runonce){
    RecursionControlPermission.runonce = true;
    List<String> UsersToSkip = new List<String> { 'Kasia2 User' , 'Dataload User' , 'Dataload No Outbound User'};
    Map<ID,User> UserMap = new Map<ID,User>([select id, name from user where name in:UsersToSkip ]);    
    User currentUser = [select mid__c from user where id=:UserInfo.getUserId()];
    String userMid = currentUser.mid__c;
 List<Permission__c> permList;
        Permission__c perm;
       If(Trigger.isInsert){
        permList = new List<Permission__c>();           
         for (Account acc : Trigger.new) {
        if(acc.IsPersonAccount && UserMap.get(acc.CreatedById)==null){
        perm = new Permission__c();
        perm.Customer__c = acc.id;
        perm.customerID__c = acc.Customer_No__c;
       //replaced "default" with current user's mid for spoc-1612
            if(acc.PersonMobilePhone!=null && acc.PersonEmail!=null){ // added for SPOC-1458 
                    perm.Driftsinfo_pa_SMS__c= true;        
                    perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                    perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                }else if(acc.PersonMobilePhone==null && acc.PersonEmail!=null){
                    perm.Driftsinfo_pa_email__c = true;
                    perm.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
                    perm.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
                }else if(acc.PersonMobilePhone!=null && acc.PersonEmail==null){
                    perm.Driftsinfo_pa_SMS__c= true;        
                    perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                    perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                }
        permList.add(perm); 
        }
    }
    

    insert permList;
    
        
       }else if(Trigger.isUpdate){
        permList = new List<Permission__c>();
       Map<Id,Permission__c> permListMap = new Map<Id,Permission__c>();
       for(permission__c p : [select Id,customer__c,Driftsinfo_pa_SMS__c,Driftsinfo_pa_SMS_Opdateret_af__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,Driftsinfo_pa_email__c,Driftsinfo_pa_email_Opdateret_af__c,Driftsinfo_pa_email_Opdateret_Dato__c,E_kommunikation__c,E_kommunikation_Opdateret_af__c,E_kommunikation_Opdateret_Dato__c,Marketing_Permission__c,Marketing_permission_Opdateret_af__c,Marketing_permission_Opdateret_Dato__c,Nej_til_Telefonopkald__c,Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c,Nej_til_markedsforing__c,Nej_til_markedsforing_Opdateret_af__c,Nej_til_markedsforing_Opdateret_Dato__c from permission__c where customer__c in :Trigger.newMap.keyset()]){
        permListMap.put(p.customer__c,p);
       }
       if(permListMap.size()>0){
        for (Account acc : Trigger.new) {
        if(acc.IsPersonAccount && UserMap.get(acc.LastModifiedById)==null && permListMap.get(acc.Id)!=null){
        perm = permListMap.get(acc.Id);
        if ((acc.PersonEmail != Trigger.oldMap.get(acc.Id).PersonEmail) || (acc.PersonMobilePhone !=    Trigger.oldMap.get(acc.Id).PersonMobilePhone) ) { 
            perm.UpdOnAccMobileEmailChange__c=acc.PersonEmail +', '+acc.PersonMobilePhone;
        }
        
        if(Trigger.oldMap.get(acc.Id).PersonEmail==null && Trigger.oldMap.get(acc.Id).PersonMobilePhone==null && (acc.PersonMobilePhone!=null || acc.PersonEmail!=null)){
        //perm = new Permission__c();           
        
            if(acc.PersonMobilePhone!=null && acc.PersonEmail!=null){ // added for SPOC-1458 
                perm.Driftsinfo_pa_SMS__c= true;        
                perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                }else if(acc.PersonMobilePhone==null && acc.PersonEmail!=null){
                perm.Driftsinfo_pa_email__c = true;
                perm.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
                }else if(acc.PersonMobilePhone!=null && acc.PersonEmail==null){
                perm.Driftsinfo_pa_SMS__c= true;        
                perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                }
         
           }/*commented for SPOC-1612 else if(Trigger.oldMap.get(acc.Id).PersonMobilePhone==null && acc.PersonMobilePhone!=null){
                perm.Driftsinfo_pa_SMS__c= true;        
                perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                
        }*/
        //If we have customer with PersonEmail and PersonMobilePhone then only sms is checked in permission.
        //If someone removes the PersonMobilePhone then email should be checked in permission.
        
      /*  if(Trigger.oldMap.get(acc.Id).PersonEmail !=null && Trigger.oldMap.get(acc.Id).PersonMobilePhone != null && !perm.Driftsinfo_pa_email__c && acc.PersonEmail != null  && perm.Driftsinfo_pa_SMS__c && acc.PersonMobilePhone == null){
                    perm.Driftsinfo_pa_email__c = true;
                    perm.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
                    perm.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
                   
                    perm.Driftsinfo_pa_SMS__c= false;        
                    perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                    perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';            
        }*/
        if(acc.PersonMobilePhone==null && perm.Driftsinfo_pa_SMS__c){
                perm.Driftsinfo_pa_SMS__c= false;        
                perm.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
                
            
        }
        if(acc.PersonEmail==null && perm.Driftsinfo_pa_email__c){
                perm.Driftsinfo_pa_email__c = false;
                perm.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
                perm.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
                
            
        }
        if(acc.PersonEmail==null && perm.E_kommunikation__c){
                perm.E_kommunikation__c = false;
                perm.E_kommunikation_Opdateret_Dato__c = Date.today();
                perm.E_kommunikation_Opdateret_af__c = 'automatisk'; 
                
            
        }
        permList.add(perm);
        }
        
       }
       
       update permList;
       
       }
       }
       
       }
       //end of pemission insert or update
}