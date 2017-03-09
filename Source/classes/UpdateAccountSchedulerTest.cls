@isTest

class UpdateAccountSchedulerTest {

    private static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    private static final String CRON_EXP_DATE = '2022-09-03 00:00:00';

    public static testMethod void testScheduler() {
        Test.startTest();

        String jobId = System.schedule('testUpdateAccountScheduler', CRON_EXP, new UpdateAccountScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        Test.stopTest();
    }
}