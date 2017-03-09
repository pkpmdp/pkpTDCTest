global class schDeleteRecycleBin implements Schedulable{
	global static final String CRON_EXP = '0 0 0 3 9 ? 2022'; 
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';
    
    global void execute(SchedulableContext sc) {
        clsEmptyRecycleBinSalesProposal b = new clsEmptyRecycleBinSalesProposal(); 
        database.executebatch(b);
    }
    
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('Empty Recycle Bin For SalesProposal', schDeleteRecycleBin.CRON_EXP, new schDeleteRecycleBin());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(schDeleteRecycleBin.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(schDeleteRecycleBin.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}