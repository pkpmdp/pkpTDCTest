trigger Amazon_Modified_Fields_Update_tgr on Cloud_File__c (after insert, after update) {
    
    Map<Id,Cloud_File__c> map_CloudFile = new Map<Id,Cloud_File__c>();
    List<Cloud_File__c> lst_toUpdate=new List<Cloud_File__c>();
    if(Trigger.isUpdate || Trigger.isInsert){
        System.debug('BooleanValue***'+AmazonUtil.skipTrigger);
        if(AmazonUtil.skipTrigger == false){
            System.debug('Inside Update');
            map_CloudFile =Trigger.newMap;        
           AmazonUtil.skipTrigger = true;
       /* for(Cloud_File__c a: Trigger.new){
                map_CloudFile.put(a.Id,a);
            }
            */
            
        List<Cloud_File__c> objList=map_CloudFile.values();
        Map<string,Dataload_No_Outboud_Users__c> map_noOutboundUsers=Dataload_No_Outboud_Users__c.getAll();
        List<Dataload_No_Outboud_Users__c> list_Obj= map_noOutboundUsers.values();
        Set<String> userIDSet=new Set<String>();
        for(Dataload_No_Outboud_Users__c objId : list_Obj)
        {
            userIDSet.add(objId.User_Id__c);
        }
        system.debug('##userIDSet:'+userIDSet);
       //Set<String> userIDSet =new Set<String>{'005D0000002nz1qIAA','005D0000002njAMIAY','005M0000004cVgBIAU'};
        String userID=UserInfo.getUserId();
        if(!userIDSet.contains(userId)){// skip for Dataload_nooutboud_user
            for(Cloud_File__c obj : objList)
            {
               Cloud_File__c newObj=new Cloud_File__c(Id=obj.Id);
               //newObj.Id = obj.Id;
               
                    system.debug('#in change');
                   // system.debug('#LastModifiedById:'+obj.LastModifiedById+' #LastModifiedDate:'+obj.LastModifiedDate);
                    newObj.Cloud_File_Last_Modified_By__c=obj.LastModifiedById;
                    newObj.Cloud_File_Last_Modified_Date__c=obj.LastModifiedDate;
                    system.debug('#Cloud_File_Last_Modified_By__c:'+newObj.Cloud_File_Last_Modified_By__c+' #Cloud_File_Last_Modified_Date__c:'+newObj.Cloud_File_Last_Modified_Date__c);
                    lst_toUpdate.add(newObj);
               
            }
        }
        if(lst_toUpdate.size()>0)
        {
         update lst_toUpdate;
        }
       }
     }
}