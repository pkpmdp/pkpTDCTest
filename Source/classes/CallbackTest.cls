/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CallbackTest {
    // CallbackBookingSlot test
  static testMethod void callbackBookingSlotTest() {
    // Constructor
    CallbackBookingSlot slot = new CallbackBookingSlot(Date.newInstance(2011, 1, 1), 9, 10, 1, 'xXx');
    system.assert(slot != null);
    
    // properties
    system.assert(slot.DateOn == Date.newInstance(2011, 1, 1));
    system.assert(slot.HourFrom == 9);
    system.assert(slot.HourTill == 10);
    system.assert(slot.Available == 1);
    system.assert(slot.CaseType == 'xXx');
    system.assert(slot.Debug == null || slot.Debug.length() == 0);
    
    // MD5 property
    String str = slot.getMD5();
    system.assert(str != null && str.length() > 0);
    
    // Interval property
    String strInterval = slot.getInterval();
    system.assert(strInterval == '1');
  }
  
  // CalendarController.Hour test
  static testMethod void hourTest() {
    // Constructor
    CallbackBookingSlot[] slots = new CallbackBookingSlot[]{new CallbackBookingSlot(Date.newInstance(2011, 1, 1), 9, 10, 1, 'xXx')};
    CalendarController.Hour hour = new CalendarController.Hour(slots);    
    system.assert(hour != null);
    
    // getSlots
    CallbackBookingSlot[] slotsRet = hour.getSlots();
    system.assert(slotsRet != null);
    system.assert(slotsRet.size() == slots.size());
    system.assert(slotsRet[0] == slots[0]);
  }
  
  // CalendarController.Day test
  static testMethod void dayTest() {
    // Constructor
    CalendarController.Day day = new CalendarController.Day(Date.newInstance(2011, 1, 1), 9, 18, new CallbackBookingSlot[]{new CallbackBookingSlot(Date.newInstance(2011, 1, 1), 9, 10, 1, 'xXx')});
    system.assert(day != null);
    
    // dayOfWeek 1.1.2011 is Saturday (day 5)
    Integer idow = day.dayOfWeek();
    system.assert(idow == 5);
    
    // getDayLabel 1.1.2011 should return Saturday 
    String sdow = day.getDayLabel();
    system.assert(sdow != null);
    system.assert(sdow.length() > 0);
    
    // getDayOfMonth 1.1.2011 is the first day of month
    Integer idom = day.getDayOfMonth();
    system.assert(idom == 1);
    
    // getFormatted 1.1.2011 formatted
    String sf = day.getFormatted();
    system.assert(sf != null);
    system.assert(sf.length() > 0);
    
    // getWorkingHours
    List<CalendarController.Hour> lsthours = day.getWorkingHours();
    system.assert(lsthours != null);
    system.assert(lsthours.size() == 10);
  }
  
  // CalendarController.Week test
  static testMethod void weekTest() {
    // Constructor
    CalendarController.Week week = new CalendarController.Week(Date.newInstance(2011, 1, 1), 9, 18, 7, new CallbackBookingSlot[]{new CallbackBookingSlot(Date.newInstance(2011, 1, 1), 9, 10, 1, 'xXx')});
    system.assert(week != null);
    
    // getWorkingHours
    List<Integer> workhours = week.getWorkingHours();
    system.assert(workhours != null);
    system.assert(workhours.size() == 10);
    system.assert(workhours[0] == 9);
    
    // getDays
    List<CalendarController.Day> days = week.getDays();
    system.assert(days != null);
    system.assert(days.size() == 7);
  }
  
  // CalendarController test
  static testMethod void calendarControllerTest() {
    // Constructor
    CalendarController cls = new CalendarController();
    system.assert(cls != null);
    
    cls.BaseDate = Date.newInstance(2011, 1, 1);
    cls.StartHour = 9;
    cls.EndHour = 18;
    cls.NumberOfDays = 7;
    cls.CallbackSlots = new CallbackBookingSlot[]{new CallbackBookingSlot(Date.newInstance(2011, 1, 1), 9, 10, 1, 'xXx')};
   
    // GetDayLabelString
    for (integer i=-10; i<20; ++i){
      String str = CalendarController.GetDayLabelString(i);
      system.assert(str != null);
      system.assert(str.length() > 0);
    }
        
    // getWeekOffset 
    Integer wo = CalendarController.getWeekOffset();
//    system.assert(wo == 0 || wo == 1);
    
    // getWeek
    CalendarController.Week w = cls.getWeek(); 
    system.assert(w != null);
  }
  
  // tgrCaseAfterInsertUpdate test
  static testMethod void tgrCaseAfterInsertUpdateCBCaseTest() {
  	
  	Integer MAX_QUERY = Limits.getLimitQueries();
	Integer NUM_QUERY = MAX_QUERY - 1;
	
    // create CB Cases
    List<CB_Case__c> lstCBCases = new CB_Case__c[]{new CB_Case__c(), new CB_Case__c(), new CB_Case__c(), new CB_Case__c(), new CB_Case__c(), new CB_Case__c()};
    insert lstCBCases;
    
    // create Cases
    RecordType rcCase = [SELECT Id FROM RecordType WHERE DeveloperName = 'Call_Back_Open_Case'];
    List<Case> lstAllCases =  new List<Case>();
    for(CB_Case__c cbc : lstCBCases){
        lstAllCases.add(new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Broadband', RecordTypeId = rcCase.Id, Status = 'New', Call_Back__c = cbc.Id));
    }
    
    List<Case> lstCases =  new List<Case>();
              
    Test.startTest();
    
    // insert Cases individually and as a collection
    try{        
      for(integer i=0; i<lstAllCases.size(); ++i){
        if (i<3){
            // individually
          insert lstAllCases[i];
        } else {            
            lstCases.add(lstAllCases[i]);
        }
      }
      
      // as a collection
      insert lstCases;
            
    } catch (system.DmlException e){
        system.debug(e);
        system.assert(false);
    }
    
    // check Cases from DB after trigger -> nothing should be chagned, 'cause trigger is only on UPDATE
    for(integer i=0; i<lstAllCases.size(); ++i){
      Case cs = [SELECT Id, Call_Back__c FROM Case WHERE Id = :lstAllCases[i].Id LIMIT 1];
      system.assert(cs.Call_Back__c == lstCBCases[i].Id);
    }
    
    // change status
    lstAllCases[0].Status = 'Closed';
    lstAllCases[1].Status = 'New';
    lstAllCases[2].Status = 'Cancelled';
    lstAllCases[3].Status = 'Closed';
    lstAllCases[4].Status = 'New';
    lstAllCases[5].Status = 'Cancelled';
    
    try{
        // update individually      
      for(integer i=0; i<lstAllCases.size(); ++i){
        if (i<3){
          update lstAllCases[i];
        }
      }
      
      // and as a collection
      update lstCases;
      
    } catch (system.DmlException e){
        system.debug(e);
      system.assert(false);
    }
    
    // check Cases from DB after trigger -> Closed and Cancelled Cases should have Call_Back__c lookup set to null
    for(integer i=0; i<lstAllCases.size(); ++i){
      Case cs = [SELECT Id, Call_Back__c, Status FROM Case WHERE Id = :lstAllCases[i].Id LIMIT 1];
      if (cs.Status == 'Closed' || cs.Status == 'Cancelled'){
        system.debug(cs);
        system.debug(cs.Call_Back__c);
//MKHA          system.assert(cs.Call_Back__c == null);
      } else {
        system.assert(cs.Call_Back__c == lstCBCases[i].Id);
      }
      
      //System.assertEquals(NUM_QUERY, Limits.getQueries());
      // check CB_Cases for existence; those previously assigned to Case with 'Closed' or 'Cancelled' status should be deleted
      /*List<CB_Case__c> cbc = [SELECT Id FROM CB_Case__c WHERE Id = :lstAllCases[i].Call_Back__c LIMIT 1];
      if (cs.Status == 'Closed' || cs.Status == 'Cancelled'){
        system.assert(cbc == null || cbc.size() == 0);
      } else {
        system.assert(cbc != null && cbc.size() == 1 && cbc[0].Id != null);
      }*/
    }
    
    Test.stopTest();
  }  
}