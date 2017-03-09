global class SC_CheckPortalAdminRolesScheduler implements Schedulable{	
	/**
 	* SC_CheckPortalAdminRolesScheduler implements the Schedulable interface.
 	* The actual code being executed is located in SC_CheckPortalAdminRolesScheduler.
 	*/
    global static final String CRON_EXP = '0 0 0 3 9 ? 2022';
    global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';	
	public ServiceCenter_CustomSettings__c sc_Settings = ServiceCenter_CustomSettings__c.getInstance('Service-Center batch job email');
	
    global void execute(SchedulableContext SC) { 
        SC_CheckPortalAdminRolesImpl impl = new SC_CheckPortalAdminRolesImpl(sc_Settings.Value__c, false, null);
        //Scope must be one since we otherwise will get errors regarding too many sql queries.
        Database.executebatch(impl, 1);         
    }

    /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('testSC_CheckPortalAdminRolesScheduler', SC_CheckPortalAdminRolesScheduler.CRON_EXP, new SC_CheckPortalAdminRolesScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_CheckPortalAdminRolesScheduler.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_CheckPortalAdminRolesScheduler.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }

}

/* This code can be used in after trigger for contact roles, but
//Service-Center: Recreate all contact roles created in portal. Before running this batch we make sure that no other batchjob of same type is running. Otherwise we would get a runtime-exception.
       if(!System.isFuture() && portalMode == true && Trigger.isInsert && UserInfo.getUserId() != CastIron.Id){
            ApexClass batchClass = [Select id, name from apexclass where name = 'SC_UpdateHierarchyFieldImpl'];
            AsyncApexJob[] activeJobs = [Select id from AsyncApexJob where(ApexClassId = :batchClass.Id and (Status = 'Queued' or Status = 'Processing'))];                    
            if(activeJobs.size() == 0){
                SC_AcquireExternalIdForContactRolesImpl impl = new SC_AcquireExternalIdForContactRolesImpl(null, false, null, trigger.NewMap.keySet());
                //Scope must be one since we otherwise will get errors regarding too many sql queries.
                //Use a try in case of any runtime exception.
                try{
                    Database.executebatch(impl, 1);
                }
                catch (Exception e){
                    //Error is not handled because this is not a critical batchjob
                    system.debug(e.getMessage());
                } 
            }  
       }       
*/