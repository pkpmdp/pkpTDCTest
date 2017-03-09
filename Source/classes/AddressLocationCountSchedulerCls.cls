global class AddressLocationCountSchedulerCls implements Schedulable{
    
    private static final String CRON_TEST_EXPR = '0 0 0 3 9 ? 2022';
    private static final String TEST_JOB_NAME = 'testAddressLocationCountSchedulerCls'; 
    private static final String NEXT_RUN_TEST_DATE = '2022-09-03 00:00:00';  
    
    /**
    * @description: This method is used to execute the AddressLocationCountBatch.
    * @param: SchedulableContext.
    */
    global void execute(SchedulableContext sc) {
        AddressLocationCountBatch dataBatch = new AddressLocationCountBatch();
        database.executebatch(dataBatch);
     }
     
     /**
    * @description: This method is used to Test AddressLocationCountSchedulerCls class.
    */
     public static testMethod void testScheduler() {        
        Test.startTest();       
        String jobId = System.schedule(TEST_JOB_NAME, CRON_TEST_EXPR, new AddressLocationCountSchedulerCls());        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];        
        System.assertEquals(CRON_TEST_EXPR, ct.CronExpression);        
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals(NEXT_RUN_TEST_DATE, String.valueOf(ct.NextFireTime));          
        Test.stopTest();
    }    
}