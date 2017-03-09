global class schDelete2YearsCustomerLog implements Schedulable{
	
	global static final String CRON_EXP = '0 0 0 3 9 ? 2022'; 
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';
    
	global void execute(SchedulableContext sc) {
        deleteCustomerLogHistory b = new deleteCustomerLogHistory(); 
        database.executebatch(b);
    }
    
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('Delete 2 Years Customer Log', schDelete2YearsCustomerLog.CRON_EXP, new schDelete2YearsCustomerLog());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(schDelete2YearsCustomerLog.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(schDelete2YearsCustomerLog.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}