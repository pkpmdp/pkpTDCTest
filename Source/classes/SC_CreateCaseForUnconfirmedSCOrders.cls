global with sharing class SC_CreateCaseForUnconfirmedSCOrders implements Schedulable{	
	/**
 	* SC_CreateCaseForUnconfirmedSCOrders implements the Schedulable interface.
 	* The actual code being executed is located in SC_CreateCaseForUnconfirmedSCOrders.
 	*/
    global static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';	
	public ServiceCenter_CustomSettings__c sc_Settings = ServiceCenter_CustomSettings__c.getInstance('Service-Center batch job email');
	
    global void execute(SchedulableContext SC) { 
        SC_CreateCaseForUnconfirmedSCOrdersImpl impl = new SC_CreateCaseForUnconfirmedSCOrdersImpl(sc_Settings.Value__c, false, null);
        //Scope must be one since we otherwise will get errors regarding too many sql queries.
        Database.executebatch(impl,1);                 
    }
    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();
		
        // Verify Scheduled Job
        String jobId = System.schedule('testSC_CreateCaseForUnconfirmedSCOrders', SC_CreateCaseForUnconfirmedSCOrders.CRON_EXP, new SC_CreateCaseForUnconfirmedSCOrders());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_CreateCaseForUnconfirmedSCOrders.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_CreateCaseForUnconfirmedSCOrders.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}