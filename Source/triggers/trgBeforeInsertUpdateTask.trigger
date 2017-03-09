trigger trgBeforeInsertUpdateTask on Task (before insert, before update) {
      YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
      Id YSTask = ysRecords.YS_Opgave_Task_Record_Type__c;
      System.debug('YSTask: '+YSTask);
      List<Task> taskList = new List<Task>(); 
      List<Id> IdList = new List<Id>();
      
      for(Task task : Trigger.new){
        IdList.add(task.WhoId);
      }
      //fetch contactsList to avoid governor limits of querying inside a for loop
      List<Contact> contactList = [Select Id, Name, Phone, HomePhone, MobilePhone from Contact where Id in: IdList];
      
      System.debug('contactList: '+contactList);
      for(Task task : Trigger.new){
         try{   
           System.debug('task.RecordTypeId: '+task.RecordTypeId+' YSContact: '+YSTask);
           if(task.RecordTypeId == YSTask){
             for(Contact contact : contactList){
                System.debug('contact.Id: '+contact.Id+'task.WhoId: '+task.WhoId);
                if(contact.Id == task.WhoId){
                    task.Home_phone__c = contact.HomePhone;
                    task.Workphone__c = contact.Phone;
                    task.Mobilephone__c = contact.MobilePhone;
                }
             }
             taskList.add(task);
           }
         }catch(Exception e){
             task.addError(Label.TechnicalErrorLabel);
         }   
      }
}//end of class