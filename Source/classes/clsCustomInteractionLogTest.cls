@isTest
private class clsCustomInteractionLogTest {

    private static final String option1 = 'Telefonopkald';
    private static final String option2 = 'Informationsmøde';
    private static final String option3 = 'Møde';        
    private static final String option4 = 'Telefonmøde';
    private static final String option5 = 'Opfølgning';

    static testMethod void setEndCallData() {
        YSRecordTypes__c ysRecord = new YSRecordTypes__c(); //custom settings record must exist
        ysRecord.Name = 'YSRecordTypes';
        ysRecord.YS_Opgave_Task_Record_Type__c = '01220000000TyI9AAK';
        insert ysRecord;
       
        clsCustomInteractionLog cntrl = new clsCustomInteractionLog(null);      


        cntrl.CallDurationInSeconds = 10; //call duration
        cntrl.setCallEndData();
      
        Task storedTask = [Select id,CallDurationInSeconds,CallDisposition,Status,Priority from Task ORDER BY ActivityDate DESC LIMIT 5];  
        System.assertEquals(10, storedTask.CallDurationInSeconds);    
          
    }
    
    static testMethod void saveAndNew() {
        YSRecordTypes__c ysRecord = new YSRecordTypes__c(); //custom settings record must exist
        ysRecord.Name = 'YSRecordTypes';
        ysRecord.YS_Opgave_Task_Record_Type__c = '01220000000TyI9AAK';
        insert ysRecord;
            
        clsCustomInteractionLog cntrl = new clsCustomInteractionLog(null);      

        Task task = new Task();
        task.CallDurationInSeconds = 10; //call duration
      
        cntrl.task=task;

        cntrl.saveAndNew();
      
        Task storedTask = [Select id,CallDurationInSeconds,CallDisposition,Status,Priority from Task ORDER BY ActivityDate DESC LIMIT 5];  
        System.assertEquals(10, storedTask.CallDurationInSeconds);    
    }    
    
    static testMethod void writeReadSubjectItems() {
      User u1 = [SELECT Id FROM User WHERE Alias='sfern' AND Name='Roshan Sahatiya'];
      System.RunAs(u1){

        clsCustomInteractionLog cntrl = new clsCustomInteractionLog(null);      

        List<SelectOption> outOptions = cntrl.getSubjectItems();

        System.assert(outOptions.size() == 6);

        System.assertEquals(option1, outOptions[1].getValue());    
        System.assertEquals(option2, outOptions[2].getValue());    
        System.assertEquals(option3, outOptions[3].getValue());    
        System.assertEquals(option4, outOptions[4].getValue());    
        System.assertEquals(option5, outOptions[5].getValue());    
      }
    }
}