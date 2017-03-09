@isTest
private class FastEditCaseControllerTest {

    static testMethod void saveGoToQueue() {
    	
      YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
	  setting.Name = 'No_case_assignment_customerinformation';
	  setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
	  insert setting;
		
      Case cse = new Case();
      insert cse;
      ApexPages.currentPage().getParameters().put('id',''+cse.id);
      
      FastEditCaseController cntrl = new FastEditCaseController();      
      DateTime dt = DateTime.newInstance(DateTime.now().getTime()+86400000);

      cntrl.setStatus('Reserved');
      cntrl.setReserveUntil(dt);
      cntrl.setReservationReason('reason text'); 
      cntrl.setNumberOfTaskInThisCase(5.3);
      cntrl.saveGoToQueue();
    }
     
    static testMethod void retrieveNextCase() {
    	
     YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
	 setting.Name = 'No_case_assignment_customerinformation';
	 setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
	 insert setting;
        
      Case cse = new Case();
      insert cse;
      ApexPages.currentPage().getParameters().put('id',''+cse.id);
      FastEditCaseController fec = new FastEditCaseController();
      fec.getCaseToSave();
      fec.cancel();
      fec.save();
      
      FastEditCaseController cntrl = new FastEditCaseController();      
      DateTime dt = DateTime.newInstance(DateTime.now().getTime()+86400000);

      cntrl.setStatus('Reserved');
      cntrl.setReserveUntil(dt);
      cntrl.setReservationReason('reason text'); 
      cntrl.setNumberOfTaskInThisCase(5.3);
      cntrl.retrieveNextCase();    
    }
}