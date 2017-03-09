global class SC_QueryOnNetInstallation implements Schedulable{
   global static final String CRON_EXP = '0 0 0 3 9 ? 2022'; 
   global static final String CRON_EXP_DATE = '2022-09-03 00:00:00';
   global static String cableUnitNumber = '0004000790';
   //global static String statusList = '(\'1\',\'2\',\'9\')'; 
   global static String databaseQuery; 
   //global static Date mydateTime = date.today();  
   //global static String SysDate = String.valueOf(myDateTime);
   global static String streetname = 'Adelgade'; 
   public List<Net_Installations__c> instList = new List<Net_Installations__c>();
   global void execute(SchedulableContext SC) {
   databaseQuery = 'select inst.Id,inst.Location__c, inst.INSTALLATION_ID__c,inst.Cable_Unit__r.Name,inst.Address__r.Name,inst.Installation_Status_Code__c,inst.Address__r.Street__c, inst.HasFuturePackage__c,'+'inst.Name,inst.Address__r.Entrance__c,inst.Address__r.Floor__c,inst.Address__r.Town__c,inst.Address__r.External_Id__c,'+'inst.Address__r.Door_No__c,inst.Address__r.District__c,inst.Address__r.House_No__c,inst.Address__r.PostCode__c, inst.Installation_Formula_Status__c,inst.Image_Status_Text__c  '+ 'From Net_Installations__c inst where';
   databaseQuery += ' inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cableUnitNumber + '\' and inst.Address__r.Name =\''+ streetname + '\'';
   databaseQuery += ' order by inst.Address__r.Name, inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c,inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c limit 1000';
   PageControllerBase pb = new PageControllerBase(); 
       if(databaseQuery != null){  
                    pb.setQuery(databaseQuery);        
       } 
       instList = Database.query(databaseQuery);   
       System.debug('$List.size()$'+instList.size()+'##############databaseQuery '+databaseQuery);             
    }

   
  /**
     * Test method.
     */
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();

        // Verify Scheduled Job
        String jobId = System.schedule('SC_QueryOnNetInstallation', SC_QueryOnNetInstallation.CRON_EXP, new SC_QueryOnNetInstallation());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(SC_QueryOnNetInstallation.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(SC_QueryOnNetInstallation.CRON_EXP_DATE, String.valueOf(ct.NextFireTime));

        // Stop Test
        Test.stopTest();
    }
    
}