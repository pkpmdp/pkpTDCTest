global class GiftCodesScheduler implements Schedulable{

    private static final String CRON_TEST_EXPR = '0 0 0 3 9 ? 2022';
    private static final String TEST_JOB_NAME = 'testGiftCodesScheduler'; 
    private static final String NEXT_RUN_TEST_DATE = '2022-09-03 00:00:00';    


    global void execute(SchedulableContext SC){ 
        GiftCodesSchedulerImpl jobImpl = new GiftCodesSchedulerImpl();
        jobImpl.runJob(); 
    }
    
    public static testMethod void testScheduler() {        
        Test.startTest();       
        String jobId = System.schedule(TEST_JOB_NAME, CRON_TEST_EXPR, new GiftCodesScheduler());        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];        
        System.assertEquals(CRON_TEST_EXPR, ct.CronExpression);        
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals(NEXT_RUN_TEST_DATE, String.valueOf(ct.NextFireTime));          
        Test.stopTest();   
    }
    
}