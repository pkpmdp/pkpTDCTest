trigger tgrAccountEmail on Account (before update) {


    if(Trigger.isUpdate){
        List<Account> account = new List<Account>();
        for(Account acc: Trigger.new){
            account.add(acc);
        }
    System.debug('********IN tgrAccountEmail trigger***********');
    List<Permission__c>  permissionList =[SELECT E_kommunikation__c,Customer__c,Customer__r.RecordTypeId FROM Permission__c where Customer__c IN :account and Customer__r.RecordType.DeveloperName ='YK_Customer_Account'];
        if(permissionList != null && permissionList.size() > 0){
            Map<String, Permission__c> permissionMap = new Map<String, Permission__c>();
          
            for(Permission__c permission: permissionList){
                permissionMap.put(permission.Customer__c, permission);
            }
      
            for(Account ac: account){
                if(permissionMap.keySet().contains(ac.Id)){
                    boolean EcommFlag = permissionMap.get(ac.id).E_kommunikation__c == null ? false : permissionMap.get(ac.id).E_kommunikation__c;
                    if(ac.PersonEmail == null && EcommFlag ){
                        System.debug('Email: '+ ac.PersonEmail + 'E Comm: '+ EcommFlag );
                        ac.addError('Feltet mail må ikke være tomt, da kunden er tilmeldt E-kommunikation'); 
                    }
                }
            }
        }
    }

}