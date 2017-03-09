/**
 * Implementation for a scheduled job Release Call Back Slots
 */
public class ReleaseCallBackSlotSchedulerImpl{
  private static Integer CB_CASE_TIMEOUT = 2; //hours
  private static String CASE_STATUS_CANCELLED='Cancelled';
  private static String CASE_STATUS_NEW='New';
  private static Case xCase = new Case();
  private static RecordType xCaseRecordType; 
  static{
    xCase.Department__c = 'YOT';
    xCase.Product_2__c = 'YOT Call Back';
    xCaseRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Call_Back_Open_Case'];
  }


    /**
     * Select each Call Back Case with Call_Back_Open_Case Record type where created Date < now-CB_CASE_TIMEOUT
     */
    public void runJob() {
        runJob(CB_CASE_TIMEOUT);
    }

    private void runJob(Integer timeout) {
        Datetime createdBefore = Datetime.now().addHours((-1*timeout));
        //system.debug('createdBefore '+createdBefore);
        List<Case> forgottenCases=[select Id,Status,Description from Case where Department__c=:xCase.Department__c and Product_2__c=:xCase.Product_2__c and RecordTypeId=:xCaseRecordType.Id and Status=:CASE_STATUS_NEW and CB_phone_number__c=null and CreatedDate<=:createdBefore for update];
        for(Case forgottenCase:forgottenCases){
            forgottenCase.Status = CASE_STATUS_CANCELLED;
            String prevDesc='';
            if(forgottenCase.Description!=null){
                prevDesc=forgottenCase.Description+'\n';
            }
            forgottenCase.Description=prevDesc+'This Case was identified as forgotten case because its initial status was not changed more than '+CB_CASE_TIMEOUT+' hours. It was automatically cancelled by Scheduled job \'Release Call Back Slots\'.';
        }
        update forgottenCases;          
    }
    
    
    public static testMethod void testScheduler() {
        // Begin Tests
        Test.startTest();
        
        Date TEST_VALID_FROM_IN_FUTURE = Date.newInstance(2020,1,1);
        Date TEST_FUTURE_DATE = Date.newInstance(2020,2,2);
        String TEST_TYPE = 'Broadband';

        //create forgotten case
        
        CB_Case__c newCbCase = new CB_Case__c(CB_time_from__c = Datetime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0)), CB_time_to__c = Datetime.newInstance(TEST_FUTURE_DATE,Time.newInstance(11,0,0,0)), CB_type__c = TEST_TYPE, CB_time__c = 'Test 02-02-2020 10:00-11:00');
        insert newCbCase;
        String cbCaseId=newCbCase.Id;
        Case newCase = new Case(Department__c = xCase.Department__c, Product_2__c = xCase.Product_2__c, Type_Task__c = TEST_TYPE, RecordTypeId = xCaseRecordType.Id, Status = CASE_STATUS_NEW, Origin = xCase.Origin, AccountId = null, Call_Back__c = cbCaseId);
        insert newCase;

        //check status        
        Case dbCase = [select Status from Case where Id =: newCase.Id];
        System.assertNotEquals(CASE_STATUS_CANCELLED,dbCase.Status);
        List<CB_Case__c> cbCases=[select Id from CB_Case__c where Id=:cbCaseId];
        System.assertEquals(1,cbCases.size());      

        //run job with zero timeout
        //system.debug([select Id,Status,Description, Department__c,Product_2__c,RecordTypeId,CB_phone_number__c,CreatedDate from Case where Id=:newCase.Id]);
        ReleaseCallBackSlotSchedulerImpl jobImpl=new ReleaseCallBackSlotSchedulerImpl();
        jobImpl.runJob(0);

        //check result
        dbCase = [select Status from Case where Id =: newCase.Id];
        System.assertEquals(CASE_STATUS_CANCELLED,dbCase.Status);
        cbCases=[select Id from CB_Case__c where Id=:cbCaseId];
        System.assertEquals(0,cbCases.size());      
        
        // Stop Test
        Test.stopTest();
    }
    
}