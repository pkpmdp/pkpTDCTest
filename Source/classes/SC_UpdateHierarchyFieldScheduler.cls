global class SC_UpdateHierarchyFieldScheduler implements Schedulable {
	global static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';	
	
	public ServiceCenter_CustomSettings__c sc_Settings = ServiceCenter_CustomSettings__c.getInstance('Service-Center batch job email');
		
	global void execute(SchedulableContext sc) {      
      SC_UpdateHierarchyFieldImpl batchjob = new SC_UpdateHierarchyFieldImpl(sc_Settings.Value__c, false, null); 
      Database.executebatch(batchjob, 1);      
   }   

    /**
     * Test method.
     */
    global static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('SC_UpdateHierarchyFieldScheduler', SC_UpdateHierarchyFieldScheduler.CRON_EXP, new SC_UpdateHierarchyFieldScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_UpdateHierarchyFieldScheduler.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_UpdateHierarchyFieldScheduler.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}