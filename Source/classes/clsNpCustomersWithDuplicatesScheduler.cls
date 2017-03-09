global class clsNpCustomersWithDuplicatesScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        // Actual code being executed has been implemented in:
        clsNpCustomersWithDuplicatesImpl impl = new clsNpCustomersWithDuplicatesImpl();
        impl.runJob();
    }

    // Test method to test schedulability
    public static testMethod void testScheduler() {
        // CRON expression: midnight on June 24
        String CRON_EXP = '0 0 0 24 6 ? 2099';
        String CRON_EXP_DATE = '2099-06-24 00:00:00';

        Test.startTest();
        String jobId = System.schedule(
            'testNpCustomersWithDuplicatesScheduler', CRON_EXP, new clsNpCustomersWithDuplicatesScheduler()
        );
        CronTrigger ct = [
            SELECT CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId
        ];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // As this is a test, job executes immediately after Test.stopTest()
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(CRON_EXP_DATE, String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}