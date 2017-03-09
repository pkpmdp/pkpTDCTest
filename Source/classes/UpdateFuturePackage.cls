global class UpdateFuturePackage implements Database.Batchable<sObject>{
    

    global static Date mydateTime = date.today();  
    //global static String SysDate = String.valueOf(myDateTime);
    public String query; 
    String scheduledClass= '';
    public UpdateFuturePackage(String batchName){
        scheduledClass=batchName;
        }
    
   

    global Database.QueryLocator start(Database.BatchableContext BC){
            if(scheduledClass=='MockSubcriptionUpdate'){
                query ='SELECT Address__c,End_Date__c,Future_Subscription__c,Id,Name,Net_Installation__c,Product__c,Requested_End_Date__c,Requested_Start_Date__c,Start_Date__c,Net_Installation__r.HasFuturePackage__c FROM Subscription__c where End_Date__c <= :mydateTime and Net_Installation__c != null and Net_Installation__r.HasFuturePackage__c = true';
            }
            else if(scheduledClass=='DeleteSubcription'){
              query = 'SELECT Address__c,End_Date__c,Future_Subscription__c,Id,Name,Net_Installation__c,Product__c,Requested_End_Date__c,Requested_Start_Date__c,Start_Date__c,Net_Installation__r.HasFuturePackage__c FROM Subscription__c where Requested_End_Date__c <= :mydateTime';
            }
            
            try{
                return Database.getQueryLocator(query);
             }
            catch(Exception e){
                    System.debug('###Error Message###'+e.getMessage());
                    return null; 
            }
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Subscription__c> subList = new List<Subscription__c>();
        for(sObject s : scope){
            Subscription__c sub = (Subscription__c)s;
            subList.add(sub);
        }
        // For Cancellation Scenarios updating net installations hasfuturepackage
        if(subList.size() > 0 && subList != null){
            if(scheduledClass=='MockSubcriptionUpdate')
                update subList;
            else if(scheduledClass=='DeleteSubcription')
                delete subList;
        }   
    }

    global void finish(Database.BatchableContext BC){ 
        system.debug('Job Cancellation Scenarions ID is ----------'+BC.getJobId()); 
        /*String[] toAddresses;
        String emailmessage;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        toAddresses = new String []{'amsur@yousee.dk','mya@yousee.dk','amrish.surve@capgemini.com'};
        emailmessage = 'Send Time : ' + System.now();
        mail.setSubject('Service-Center batch job completed: Dummy Update on Subscription');
        mail.setToAddresses(toAddresses);
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail }); 
        System.debug('%%%%% After email send toAddresses0'+toAddresses);*/
    }

}