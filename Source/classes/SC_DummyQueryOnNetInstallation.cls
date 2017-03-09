global class SC_DummyQueryOnNetInstallation implements Schedulable{

   global static final String CRON_EXP = '0 0 0 3 9 ? 2022'; 
   global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';
   global static String cableUnitNumber = '0004000790';
   global static String statusList = '(\'1\',\'2\',\'11\')'; 
   global static String databaseQuery; 
   global static Date mydateTime = date.today();  
   global static String SysDate = String.valueOf(myDateTime);
   global static String streetname = 'Adelgade';
   global static List<Net_Installations__c> netInstList = new List<Net_Installations__c>();
   global void execute(SchedulableContext SC) {
   databaseQuery = 'select inst.Id,inst.Location__c, inst.INSTALLATION_ID__c,inst.Cable_Unit__r.Name,inst.Address__r.Name,inst.Installation_Status_Code__c,inst.Address__r.Street__c, inst.HasFuturePackage__c,'+'inst.Name,inst.Address__r.Entrance__c,inst.Address__r.Floor__c,inst.Address__r.Town__c,inst.Address__r.External_Id__c,'+'inst.Address__r.Door_No__c,inst.Address__r.District__c,inst.Address__r.House_No__c,inst.Address__r.PostCode__c, inst.Installation_Formula_Status__c,inst.Image_Status_Text__c  '+ 'From Net_Installations__c inst where';
   databaseQuery += ' inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cableUnitNumber + '\' and inst.Start_Date__c <='+ SysDate+'T23:59:00.000Z' + ' and inst.Installation_Status_Code__c IN'+ statusList + ' and inst.Address__r.Name =\''+ streetname + '\'';
   databaseQuery += ' order by inst.Address__r.Name, inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c,inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c limit 1000';
   PageControllerBase pb = new PageControllerBase(); 
        if(databaseQuery != null){  
                pb.setQuery(databaseQuery);        
        }  
         netInstList = Database.query(databaseQuery);
         System.debug('$List.size()$'+netInstList.size()+' ##############databaseQuery'+databaseQuery);               
}    
    /**
     * Test method.
     */
   public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('SC_DummyQueryOnNetInstallation', SC_DummyQueryOnNetInstallation.CRON_EXP, new SC_DummyQueryOnNetInstallation());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_DummyQueryOnNetInstallation.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_DummyQueryOnNetInstallation.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
}