/**
 * ReturnToQueueScheduler implements the Schedulable interface.
 * The actual code being executed is located in ReturnToQueueImpl.
 */
global class ReturnToQueueScheduler implements Schedulable {
    private static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    private static final String CRON_EXP_DATE = '2022-09-03 00:00:00';

    global void execute(SchedulableContext SC) {
        ReturnToQueueImpl impl = new ReturnToQueueImpl();
        impl.runJob(null); // Pass null-value as testCaseId to indicate production call.
    }

    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('testReturnToQueueScheduler', ReturnToQueueScheduler.CRON_EXP, new ReturnToQueueScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(ReturnToQueueScheduler.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(ReturnToQueueScheduler.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}