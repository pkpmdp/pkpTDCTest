global class SC_AssociateCaseAndOrderScheduler implements Schedulable{	
	/**
 	* SC_CheckPortalAdminRolesScheduler implements the Schedulable interface.
 	* The actual code being executed is located in SC_CheckPortalAdminRolesScheduler.
 	*/
    global static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';	
	public ServiceCenter_CustomSettings__c sc_Settings = ServiceCenter_CustomSettings__c.getInstance('Service-Center batch job email');
	
    global void execute(SchedulableContext SC) { 
        SC_AssociateCaseAndOrderImpl impl = new SC_AssociateCaseAndOrderImpl(false, null);
        //Scope must be one since we otherwise will get errors regarding too many sql queries.
        Database.executebatch(impl, 10);         
    }

    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('testSC_AssociateCaseAndOrderScheduler', SC_AssociateCaseAndOrderScheduler.CRON_EXP, new SC_AssociateCaseAndOrderScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_AssociateCaseAndOrderScheduler.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_AssociateCaseAndOrderScheduler.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }

}