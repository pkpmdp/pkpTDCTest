/**
 * ReleaseCallBackSlotScheduler implements the Schedulable interface.
 * The actual code being executed is located in ReleaseCallBackSlotSchedulerImpl.
 */
global class ReleaseCallBackSlotScheduler implements Schedulable{
    private static final String CRON_EXPR = '0 0 * * * ?';//runs every hour
    private static final String CRON_TEST_EXPR = '0 0 0 3 9 ? 2022';// schedule for test reason sometime in a future
    private static final String NEXT_RUN_TEST_DATE = '2022-09-03 00:00:00';
    private static final String JOB_NAME = 'Release Call Back slots';
    private static final String TEST_JOB_NAME = 'testReleaseCallBackSlotScheduler';

    global void execute(SchedulableContext SC) {
        ReleaseCallBackSlotSchedulerImpl jobImpl=new ReleaseCallBackSlotSchedulerImpl();
        jobImpl.runJob();
    }
    
    /* 
     * Schedule method
     */
    public static String schedule(){return System.schedule(JOB_NAME,CRON_EXPR,new ReleaseCallBackSlotScheduler());}
    
    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule(TEST_JOB_NAME, CRON_TEST_EXPR, new ReleaseCallBackSlotScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_TEST_EXPR, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(NEXT_RUN_TEST_DATE, String.valueOf(ct.NextFireTime));
	
        // Stop Test
        Test.stopTest();
    }
}