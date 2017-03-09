global class SC_DeleteSubscriptiononRequestedEndDate implements Schedulable{

    private static final String CRON_TEST_EXPR = '0 0 0 3 9 ? 2022';
    private static final String TEST_JOB_NAME = 'Selvbetjening: Dummy upadte on Subscription object'; 
    private static final String NEXT_RUN_TEST_DATE = '2022-09-03 00:00:00';  
    
    global void execute(SchedulableContext sc) {
        UpdateFuturePackage dummyUpdateBatch = new UpdateFuturePackage('DeleteSubcription');
        database.executebatch(dummyUpdateBatch);
     }
     
     /**
    * @description: This method is used to Test SC_DummyUpdateOnSubscription class.
    */
     public static testMethod void testScheduler() {        
        Test.startTest();       
        String jobId = System.schedule(TEST_JOB_NAME, CRON_TEST_EXPR, new SC_DeleteSubscriptiononRequestedEndDate());        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];        
        System.assertEquals(CRON_TEST_EXPR, ct.CronExpression);        
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals(NEXT_RUN_TEST_DATE, String.valueOf(ct.NextFireTime));          
        Test.stopTest();
    }
    
}