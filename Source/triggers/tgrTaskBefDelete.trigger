trigger tgrTaskBefDelete on Task (before delete)
{
   Id ProfileId = UserInfo.getProfileId();
   System.debug('User profile id:' + ProfileId);
   
   private static Id SysAdm = AdminProfiles__c.getInstance('SystemAdminstraor').StringId__c;
   System.debug('Sysadmid&&&&&' + SysAdm );
   private static Id YouseeAdm =AdminProfiles__c.getInstance('YouseeSystemAdministrator').StringId__c;
   System.debug('YouseeAdm@@@@@' + YouseeAdm ); 
   //List<Profile> profiles=[Select Id from Profile where name='System Administrator' or name='YouSee System Administrator'];

   for(Task obj :Trigger.old){
       if(ProfileId != SysAdm  && ProfileId != YouseeAdm){
          obj.addError(Label.Delete_Task_Error);
   
       }
   }
}