/***********************************************************************************
************************************************************************************

* @class: CarrieLogSchedulerCls
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 05/07/2012
* @description: Class is used to schedule the carrieLogBatch class.

************************************************************************************
***********************************************************************************/
global class CarrieLogSchedulerCls implements Schedulable{
	
    private static final String CRON_TEST_EXPR = '0 0 0 3 9 ? 2022';
    private static final String TEST_JOB_NAME = 'testCarrieLogSchedulerCls'; 
    private static final String NEXT_RUN_TEST_DATE = '2022-09-03 00:00:00';  
    
    /**
    * @description: This method is used to execute the carriLogBatch.
    * @param: SchedulableContext.
    */
    global void execute(SchedulableContext sc) {
        CarrieLogBatch dataBatch = new CarrieLogBatch();
        database.executebatch(dataBatch);
     }
     
     /**
    * @description: This method is used to Test CarrieLogSchedulerCls class.
    */
     public static testMethod void testScheduler() {        
        Test.startTest();       
        String jobId = System.schedule(TEST_JOB_NAME, CRON_TEST_EXPR, new CarrieLogSchedulerCls());        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];        
        System.assertEquals(CRON_TEST_EXPR, ct.CronExpression);        
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals(NEXT_RUN_TEST_DATE, String.valueOf(ct.NextFireTime));          
        Test.stopTest();
    }    
}