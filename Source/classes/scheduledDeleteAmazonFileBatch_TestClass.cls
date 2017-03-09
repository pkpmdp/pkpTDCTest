@istest
class scheduledDeleteAmazonFileBatch_TestClass {
public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testMethod void testScheduler() {
  
        // Begin Tests
        Test.startTest();
        // Verify Scheduled Job
        String jobId = System.schedule('scheduledDeleteAmazonFileBatch',CRON_EXP,new scheduledDeleteAmazonFileBatch());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
       

        // Stop Test
        Test.stopTest();
    }

}