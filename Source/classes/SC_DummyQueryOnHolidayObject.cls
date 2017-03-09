/*
	This scheduled code is implemented as a temporary workaround to SC-503 where queries against
	Holiday object takes more than one minut. This batch makes dummy queries aginst Holiday object to ensure that
	data is properly cached with Salesforce to avoid isues with package change functionality.	
	
	Use this statement to schedule code in developer console:
	System.schedule('Selvbetjening: Temp job til Holiday object', ' 0 30 6-20 ? * MON-SUN', new SC_DummyQueryOnHolidayObject());
*/

global class SC_DummyQueryOnHolidayObject implements Schedulable{	
	/**
 	* SC_DummyQueryOnHolidayObject implements the Schedulable interface. 
 	*/
    global static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';		
	
    global void execute(SchedulableContext SC) { 
    	Date mydate = date.today();
		Integer numberDays = date.daysInMonth(mydate.year(), mydate.month());
		Date startDate = date.newInstance(mydate.year(),mydate.month(),mydate.day());
		Date dueDate = date.newInstance(mydate.year(),mydate.month(),numberDays);
		List<Holiday> holidayList = [Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h where h.ActivityDate >: date.today() and h.ActivityDate <=: dueDate];           
    }

    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('SC_DummyQueryOnHolidayObject', SC_DummyQueryOnHolidayObject.CRON_EXP, new SC_DummyQueryOnHolidayObject());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_DummyQueryOnHolidayObject.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_DummyQueryOnHolidayObject.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }

}