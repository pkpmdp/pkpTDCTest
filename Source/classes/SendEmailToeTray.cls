public with sharing class SendEmailToeTray {
    private static boolean firstRun = true;
    public static boolean isFirstRun(){
        if(firstRun){
          firstRun = false;
          return true;
        }else{
            return firstRun;
        }
    }
    @InvocableMethod
    public static void sendEmail(List<case> caseList){
        System.debug('***case***'+caseList);
        Group g = new Group();
        Map<String, SendEmail__c> mapSendEmail = new Map<String, SendEmail__c>();
        mapSendEmail = SendEmail__c.getAll();
        if(!mapSendEmail.isEmpty()){
          g = [SELECT Id, Name, DeveloperName,Type, Email FROM Group WHERE DeveloperName =:mapSendEmail.get('QueueName').Value__c AND Type=:'Queue'];
        //g = [SELECT Id, Name, DeveloperName,Type, Email FROM Group WHERE Id =:'00GM0000001mIWP' AND Type=:'Queue'];
        OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = :mapSendEmail.get('SenderAddress').Value__c limit 1];
        System.debug('****owa***'+owa);
        Map<Id, case> mapCase = new Map<Id, case>();//Id is case Id
        Boolean str = isFirstRun();
        for(Case c: caseList){
            if(c.OwnerId == g.Id && str)
            	mapCase.put(c.Id, c);
        }
        if(!mapCase.isEmpty()){
        List<Attachment> listAtt = new List<Attachment>();
        listAtt = [SELECT Body,BodyLength,ContentType,Description,Id,Name,ParentId FROM Attachment WHERE ParentId IN: mapCase.keySet()];
       Map<Id, List<Attachment>> mapNew = new Map<Id, List<Attachment>>(); // Id is case id
        for(Attachment a: listAtt){
            if(mapNew.containsKey(a.ParentId)){
                List<Attachment> tempList = mapNew.get(a.ParentId);
                tempList.add(a);
                mapNew.put(a.ParentId, tempList);
            }else{
                mapNew.put(a.ParentId, new List<Attachment>{a});
                
            }
        }
            System.debug('****MapNew****'+mapNew);
         EmailTemplate eTemp = new EmailTemplate();
         eTemp = [Select Id, Name,DeveloperName FROM EmailTemplate WHERE DeveloperName=:mapSendEmail.get('EmailTemplate').Value__c];
         List<String> addEmail = new List<String>();
         if(mapSendEmail.get('AdditinalEmailAddress').Value__c != null)
             addEmail = mapSendEmail.get('AdditinalEmailAddress').Value__c.Split(';');
            List<Messaging.SingleEmailMessage> listSendEmail = new List<Messaging.SingleEmailMessage>();
         for(Id cId: mapCase.keySet()){
             Messaging.SingleEmailMessage se = new Messaging.SingleEmailMessage();
             se.setTemplateId(eTemp.Id);
             if(!addEmail.isEmpty())
             	se.setCcAddresses(addEmail);
             if(owa != null)
             	se.setOrgWideEmailAddressId(owa.Id);
             if(mapCase.get(cId).ContactId != null)
             	se.setTargetObjectId(mapCase.get(cId).ContactId);
             else{
                 Contact c = [SELECT Id FROM Contact WHERE Id=:System.label.ContactId];
                se.setTargetObjectId(c.Id);// if contactid is null on case use any contact.
             }
                 
             List<String> toAddress = new List<String>();
             if(mapSendEmail.get('ToAddress').Value__c != null)
             toAddress = mapSendEmail.get('ToAddress').Value__c.split(';');
             if(!toAddress.isEmpty())
             	se.setToAddresses(toAddress);
             se.setTreatTargetObjectAsRecipient(false); // not send mail to target object
             se.setWhatId(cId);
             se.setSaveAsActivity(false);
             
             if(!mapNew.isEmpty()){
                  System.debug('****mapNew.get(cId)****'+mapNew.get(cId));
               List<Messaging.EmailFileAttachment> listAttach = new List<Messaging.EmailFileAttachment>();
                 if(mapNew.get(cId) != null && mapNew.get(cId).size() != 0){
                     for(Attachment a: mapNew.get(cId)){
                     Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                     attach.setFileName(a.Name);
                     attach.setBody(a.Body);
                     listAttach.add(attach);
                       }
                     se.setFileAttachments(listAttach);
                 }
            }
             listSendEmail.add(se);
          }
          Messaging.sendEmail(listSendEmail);
    }  
        }
        
    }

}