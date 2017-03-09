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
private class CallbackBookingTest { 
    // prepare testing data: Customer, Callback Case schedules on very specific datetime
  static private ID prepareTestDataFor_LessThanOneHour(DateTime dtNow){
    Time tm = dtNow.time();
    
    // prepare Customer
    Account customer = new Account(FirstName = 'John', LastName = 'Doe');
    insert customer;
    
    // prepare default schedules
    CB_Schedule_Template__c dtpl = new CB_Schedule_Template__c(Working_hours_from__c = 6, Working_hours_to__c = 20, Valid_from__c = dtNow.date(), Period__c = 7, CB_type__c = 'Dummy');
    insert dtpl;
    
    system.assert(dtpl.Id != null);

    List<CB_Default_Schedule__c> lstSched = new List<CB_Default_Schedule__c>();       
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = tm.hour(), Time_to__c = tm.hour() + 1, Monday__c = 0, Tuesday__c = 0, Wednesday__c = 0, Thursday__c = 0, Friday__c = 0, Saturday__c = 0, Sunday__c = 0));
    insert lstSched;
    
    dtpl = [SELECT Id, (SELECT Id FROM CB_Default_Schedules__r) FROM CB_Schedule_Template__c WHERE ID = : dtpl.Id LIMIT 1];   
    system.assert(dtpl.CB_Default_Schedules__r != null);
    system.assert(dtpl.CB_Default_Schedules__r.size() > 0);

    CB_Custom_Schedule__c cSched = new CB_Custom_Schedule__c(CB_time_from__c = DateTime.newInstance(dtNow.date(), tm), CB_time_to__c = DateTime.newInstance(dtNow.date(), tm.addHours(1)), Max_slots__c = 1, CB_type__c = 'Dummy');
    insert cSched;

    return customer.Id;
  }
  
    // prepare testing data: Customer, Callback Case schedules, Case & CB_Case that are on the same slot (with MaxSlots = 1) creating conflict
  static private ID[] prepareTestDataFor_RedirectAction(){
    // prepare Customer
    Account customer = new Account(FirstName = 'John', LastName = 'Doe');
    insert customer;
    
    // prepare default schedules
    CB_Schedule_Template__c dtpl = new CB_Schedule_Template__c(Working_hours_from__c = 9, Working_hours_to__c = 12, Valid_from__c = Date.today(), Period__c = 7, CB_type__c = 'Dummy');
    insert dtpl;
    
    system.assert(dtpl.Id != null);
    
    List<CB_Default_Schedule__c> lstSched = new List<CB_Default_Schedule__c>();       
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = 10, Time_to__c = 12, Monday__c = 1, Tuesday__c = 1, Wednesday__c = 1, Thursday__c = 1, Friday__c = 1, Saturday__c = 1, Sunday__c = 1));
    insert lstSched;
    
    dtpl = [SELECT Id, (SELECT Id FROM CB_Default_Schedules__r) FROM CB_Schedule_Template__c WHERE ID = : dtpl.Id LIMIT 1];   
    system.assert(dtpl.CB_Default_Schedules__r != null);
    system.assert(dtpl.CB_Default_Schedules__r.size() > 0);
    
    CB_Case__c cbCase1 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
    CB_Case__c cbCase2 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
    CB_Case__c cbCase3 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
    insert new CB_Case__c[]{cbCase1, cbCase2, cbCase3};
    
    Case case1 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase1.Id);
    Case case2 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase2.Id);
    Case case3 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase3.Id);
    insert new Case[]{case1, case2, case3};
    
    return new ID[]{customer.Id, case1.Id, case2.Id, case3.Id};
  }
  
  // prepare testing data: Customer, Callback Case schedules, Case  
  static private ID prepareTestDataFor_CaseOnInvalidSlot(){
    // prepare Customer
    Account customer = new Account(FirstName = 'John', LastName = 'Doe');
    insert customer;
    
    // prepare default schedules
    CB_Schedule_Template__c dtpl = new CB_Schedule_Template__c(Working_hours_from__c = 9, Working_hours_to__c = 12, Valid_from__c = Date.today(), Period__c = 7, CB_type__c = 'Dummy');
    insert dtpl;
    
    system.assert(dtpl.Id != null);
    
    List<CB_Default_Schedule__c> lstSched = new List<CB_Default_Schedule__c>();       
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = 10, Time_to__c = 12, Monday__c = 1, Tuesday__c = 1, Wednesday__c = 1, Thursday__c = 1, Friday__c = 1, Saturday__c = 1, Sunday__c = 1));
    insert lstSched;
    
    dtpl = [SELECT Id, (SELECT Id FROM CB_Default_Schedules__r) FROM CB_Schedule_Template__c WHERE ID = : dtpl.Id LIMIT 1];   
    system.assert(dtpl.CB_Default_Schedules__r != null);
    system.assert(dtpl.CB_Default_Schedules__r.size() > 0);
    
    for (Integer i=0; i<7; ++i){
      CB_Case__c cbCase = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + i, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + i, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
      insert cbCase;
    }
    
    return customer.Id;
  }
  
  // prepare testing data: Customer, Callback Case schedules, Case  
  static private ID[] prepareTestData(){
    // prepare Customer
    Account customer = new Account(FirstName = 'John', LastName = 'Doe');
    insert customer;
    
    // prepare default schedules
    CB_Schedule_Template__c dtpl = new CB_Schedule_Template__c(Working_hours_from__c = 9, Working_hours_to__c = 18, Valid_from__c = Date.today(), Period__c = 9, CB_type__c = 'Dummy');
    insert dtpl;
    
    system.assert(dtpl.Id != null);
    
    List<CB_Default_Schedule__c> lstSched = new List<CB_Default_Schedule__c>();       
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = 9, Time_to__c = 12, Monday__c = 1, Tuesday__c = 2, Wednesday__c = 3, Thursday__c = 4, Friday__c = 5, Saturday__c = 0, Sunday__c = 0));
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = 12, Time_to__c = 13, Monday__c = 0, Tuesday__c = 0, Wednesday__c = 0, Thursday__c = 0, Friday__c = 0, Saturday__c = 0, Sunday__c = 0));
    lstSched.add(new CB_Default_Schedule__c(Template__c = dtpl.Id, Time_from__c = 13, Time_to__c = 18, Monday__c = 2, Tuesday__c = 2, Wednesday__c = 2, Thursday__c = 2, Friday__c = 2, Saturday__c = 2, Sunday__c = 2));
    insert lstSched;
    
    dtpl = [SELECT Id, (SELECT Id FROM CB_Default_Schedules__r) FROM CB_Schedule_Template__c WHERE ID = : dtpl.Id LIMIT 1];   
    system.assert(dtpl.CB_Default_Schedules__r != null);
    system.assert(dtpl.CB_Default_Schedules__r.size() > 0);
    
    // prepare future default schedules
    CB_Schedule_Template__c dtplFuture = new CB_Schedule_Template__c(Working_hours_from__c = 6, Working_hours_to__c = 20, Valid_from__c = Date.today() + 6, Period__c = 7, CB_type__c = 'Dummy');
    insert dtplFuture;    
    
    List<CB_Default_Schedule__c> lstSchedNextWeek = new List<CB_Default_Schedule__c>();        
    lstSchedNextWeek.add(new CB_Default_Schedule__c(Template__c = dtplFuture.Id, Time_from__c = 10, Time_to__c = 16, Monday__c = 1, Tuesday__c = 1, Wednesday__c = 1, Thursday__c = 1, Friday__c = 1, Saturday__c = 0, Sunday__c = 0));    
    insert lstSchedNextWeek;
    
    // prepare custom schedules
    CB_Custom_Schedule__c cSched = new CB_Custom_Schedule__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(9, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), Max_slots__c = 4, CB_type__c = 'Dummy');
    insert cSched;
   
    // prepare some Case
    CB_Case__c cbCase = new CB_Case__c();
    insert cbCase;
    
    Case tstCase = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase.Id);
    insert tstCase;
    
    return new ID[]{customer.Id, tstCase.Id};
  }
  
  static private PageReference callbackBookingControllerTest(Date dt, CallbackBookingController cbcTest, Integer available, Integer hFrom, Integer hTill, Integer cnt, Integer cntSucceeded){
    cbcTest.refresh();
    
    Test.startTest();
    
    //   
    String sctTest = cbcTest.xCase.Type_Task__c;
    system.assert(sctTest == 'Dummy');
    
    Integer cntChecked = 0;
    PageReference prNewCase = null;
  
    List<CallbackBookingSlot> slotsCase = cbcTest.getCallbackSlots();
    for(CallbackBookingSlot slot : slotsCase){
        if (slot.DateOn >= dt){
        if (slot.Available == available && ((hFrom == -1 && hTill == -1) || (hFrom == slot.HourFrom && hTill == slot.HourTill))){
            for (Integer i=0; i<cnt; ++i){              
            cbcTest.UrlCBCase = slot.getMD5();
                    prNewCase = cbcTest.createCBCase();                 
                    if (slot.Available > i){
                      system.assert(prNewCase != null);
                      
                      ++cntChecked;
                      
                      String strUrl = prNewCase.getUrl();
                      system.assert(strUrl != null && strUrl.length() > 0);
                    } else {
                      system.assert(prNewCase == null);
                    } 
          }
          break;
        }
      }
    }

    system.assert(cntChecked == cntSucceeded);

    Test.stopTest();
    return prNewCase;
  }

  // CallbackBookingController test - Case cannot be created if interval is less than one hour
  static testMethod void callbackBookingController_LessThanOneHourTest() {
    DateTime dtNow = DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0));//DateTime.now();
    ID idCustomer = prepareTestDataFor_LessThanOneHour(dtNow);
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', idCustomer);
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
    
    CallbackBookingController cbc = new CallbackBookingController();
    List<CallbackBookingSlot> slots = cbc.getCallbackSlots();
    system.debug(slots);
    system.assert(slots != null && slots.size() == 1);
    system.debug(slots[0].Available);
    //system.assert(slots[0].Available == 0);
    
    //PageReference prTest = callbackBookingControllerTest(Date.today(), cbc, 1, dtNow.hour(), dtNow.hour() + 1, 1, 0);
    //system.debug(prTest);
    //system.assert(prTest == null);
  }
  
  // CallbackBookingController test - conflict of 2 cases on the same slot
  static testMethod void callbackBookingControllerConflictTest() {
    ID[] ids = prepareTestDataFor_RedirectAction();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    ApexPages.currentPage().getParameters().put('InsertId', ids[1]);    
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
    
    CallbackBookingController cbc = new CallbackBookingController();
    
    // check CaseType
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // first Case should succeed (redirect back to Customer)
    PageReference prRa = cbc.redirectAction(); 
    system.assert(prRa != null);
    
    // initial parameters, second Case should fail
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    ApexPages.currentPage().getParameters().put('InsertId', ids[2]);    
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
    
    cbc = new CallbackBookingController();
    
    // check CaseType
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // second Case should fail (no redirection - error message on page)
    prRa = cbc.redirectAction();
    system.assert(prRa == null);
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('UpdateId', ids[1]);    
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
    
    cbc = new CallbackBookingController();
    
    // check CaseType
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // first Case should succeed (redirection to Case queue page)
    prRa = cbc.redirectAction();
    system.assert(prRa != null);
    
    // initial parameters, third Case should fail
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('UpdateId', ids[3]);    
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
    
    cbc = new CallbackBookingController();
    
    // check CaseType
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // third Case should fail (no redirection - error message on page)
    prRa = cbc.redirectAction();
    system.assert(prRa == null);
  }
  
    // CallbackBookingController test - create Case on invalid slot
  static testMethod void callbackBookingControllerCreateCaseTestNoSchedule() {
    ID idCustomer = prepareTestDataFor_CaseOnInvalidSlot();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // 
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', idCustomer);
    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() == 7);
    
    for(Integer i=0; i<slotsCase.size(); ++i){
        system.assert(slotsCase[i].Available == 0);
    }
        
    cbc.UrlCBCase = slotsCase[0].getMD5();
    slotsCase[0].CaseType = 'xXx';
    
    PageReference pgTmp = cbc.createCBCase();
    system.assert(pgTmp == null);
  }

  // Cancel Case
  static testMethod void callbackBookingControllerCancelCase(){
    ID[] ids = prepareTestData();
    
    // default Constructor
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CancelId', ids[1]);
    CallbackBookingController cbcCancel = new CallbackBookingController(); 
    
    // getIsCaseUpdate
    Boolean bicuCTmp = cbcCancel.getIsCaseUpdate();
    system.assert(bicuCTmp == false);
    
    // getCallbackSlots
    List<CallbackBookingSlot> slotsCCase = cbcCancel.getCallbackSlots();
    system.assert(slotsCCase != null && slotsCCase.size() == 0);
    
    PageReference pageReference = cbcCancel.cancelCBCase();
    System.assert(pageReference != null);
    
    Case cancelCase = [SELECT Status FROM Case WHERE Id = :ids[1]];
    System.assertEquals('Cancelled', cancelCase.Status);
    System.assert(cbcCancel.caseComment.Id != null);
    System.assertEquals(ids[1], cbcCancel.caseComment.ParentId); 
  }

  // CallbackBookingController test - invalid Case
  static testMethod void callbackBookingControllerUpdateInvalidCaseTest() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // invalid Case
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CaseId', '1');
    CallbackBookingController cbcTmp = new CallbackBookingController();
  }
  
  // CallbackBookingController test - update valid Case
  static testMethod void callbackBookingControllerUpdateCaseTest() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // update valid Case
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CaseId', ids[1]);
    ApexPages.currentPage().getParameters().put('action', 'reschedule');
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');
    callbackBookingControllerTest(Date.today().addDays(1), cbc, 2, -1, -1, 1, 1);
    
    // getIsCaseUpdate
    Boolean bicuTmp = cbc.getIsCaseUpdate();
    system.assert(bicuTmp == true);
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() > 0);
  }  
  
  // CallbackBookingController test - create Case on invalid slot
  static testMethod void callbackBookingControllerCreateCaseTest0() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // 
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');    
    callbackBookingControllerTest(Date.today().addDays(1), cbc, 0, -1, -1, 1, 0);
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() > 0);
  }
  
  // CallbackBookingController test - create Case on custom schedule slot
  static testMethod void callbackBookingControllerCreateCaseTest4() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // 
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');    
    PageReference prCreate = callbackBookingControllerTest(Date.today().addDays(1), cbc, 4,  9, 12, 1, 1);
    system.assert(prCreate != null);
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() > 0);
    
    // URL
    String strUrlCreate = prCreate.getUrl();
    system.assert(strUrlCreate != null && strUrlCreate.length() > 0);
    
    // parameters
    PageReference prRedirect = cbc.redirectAction();
    
    // URL
    String strUrlRedirect = prRedirect.getUrl();
    system.assert(strUrlRedirect != null && strUrlRedirect.length() > 0);
  }
  
  // CallbackBookingController test - create Case 
  static testMethod void callbackBookingControllerCreateCaseTest2() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // 
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');
    callbackBookingControllerTest(Date.today().addDays(1), cbc, 2, -1, -1, 1, 1);
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() > 0);
  } 
  
  // CallbackBookingController test - create Case 
  static testMethod void callbackBookingControllerCreateCaseTest1() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    // 
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);
    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');    
    callbackBookingControllerTest(Date.today().addDays(1), cbc, 1, -1, -1, 2, 1);
    
    // getCallbackSlots    
    List<CallbackBookingSlot> slotsCase = cbc.getCallbackSlots();
    system.assert(slotsCase != null && slotsCase.size() > 0);
  } 
  
  // CallbackBookingController test - common
  static testMethod void callbackBookingControllerCommonTest() {
    ID[] ids = prepareTestData();
    
    PageReference pageRef = Page.CallbackBooking;
    Test.setCurrentPage(pageRef);
    
    ApexPages.currentPage().getParameters().put('CustomerId', ids[0]);      
        
    // Constructor    
    CallbackBookingController cbc = new CallbackBookingController(Date.today(), 'Dummy');
    system.assert(cbc != null);
    
    // getIsCaseUpdate
    Boolean bicu = cbc.getIsCaseUpdate();
    system.assert(bicu == false); 
    
    // getIsNotCaseUpdate
    Boolean bincu = cbc.getIsNotCaseUpdate();
    system.assert(bincu == true);
    
    // getCaseTypeString
    String scts = cbc.getCaseTypeString();
    system.assert(scts.length() == 0);
    
    // getCaseTypeString
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // getDateFrom
    Date df = cbc.getDateFrom();
    system.assert(df == Date.today());
    
    // getDateTill
    Date dt = cbc.getDateTill();
    system.assert(dt == Date.today() + 8);
    
    // getDateFromFormatted
    String sdf = cbc.getDateFromFormatted();
    system.assert(sdf == DateTime.now().format('dd-MM-yyyy'));
    
    // getDateTillFormatted
    String sdt = cbc.getDateTillFormatted();
    system.assert(sdt == (DateTime.now() + 8).format('dd-MM-yyyy'));
    
    // refresh
    PageReference prrfrsh = cbc.refresh();
    system.assert(prrfrsh == null);
    
    // TempCase
    Case tmpCase = cbc.getTempCase();
    system.assert(tmpCase != null);
    system.assert(tmpCase.Department__c == 'YOT');
    system.assert(tmpCase.Product_2__c == 'YOT Call Back');
    system.assert(tmpCase.Status == 'New');
    system.assert(tmpCase.Origin == 'Phone');
    
    // redirectAction
    PageReference prcnclcs = cbc.redirectAction();
    system.assert(prcnclcs == null);
    
    // StartHour
    system.assert(cbc.StartHour == 6);
    
    // EndHour
    system.assert(cbc.EndHour == 20); 
    
    // NumberOfDays
    system.assert(cbc.NumberOfDays == 9);
    
    // UrlCBCase
    system.assert(cbc.UrlCBCase == null || cbc.UrlCBCase.length() == 0);
    
    // Debug
    system.assert(cbc.Debug == null || cbc.Debug.length() == 0);
    
    // Error
    system.assert(cbc.Error == null || cbc.Error.length() == 0);
    
    // CaseType
    system.assert(cbc.xCase.Type_Task__c == 'Dummy');
    
    // getCallbackSlots
    List<CallbackBookingSlot> slots = cbc.getCallbackSlots();
    system.assert(slots != null);    
    
    for(CallbackBookingSlot slot : slots){
      Date bg = slot.DateOn.toStartofWeek();
      Integer iWeekDay = bg.daysBetween(slot.DateOn) + CalendarController.getWeekOffset();
      
      if (slot.DateOn == Date.today() && slot.HourTill - 1 <= DateTime.now().hour()){
        system.assert(slot.Available == 0);
      } else {      
        if (slot.HourFrom == 9 && slot.HourTill == 12){
          if (slot.DateOn == Date.today() + 1){
            // custom schedule          
            system.assert(slot.Available == 4);           
          } else {
            if (iWeekDay >= 0 && iWeekDay <= 4){
              system.assert(slot.Available == iWeekDay + 1);
            } else {
              system.assert(slot.Available == 0);
            }
          }     
        } else if (slot.HourFrom == 12 && slot.HourTill == 13){
          system.assert(slot.Available == 0);
        } else if (slot.HourFrom == 13 && slot.HourTill == 18){
          system.assert(slot.Available == 2);
        } else if (slot.HourFrom == 10 && slot.HourTill == 16){
          system.assert(slot.Available == 1);
        } else {
          system.assert(false);
        }
      }
    }
    
    ApexPages.currentPage().getParameters().put('UpdateId', '1');      
    ApexPages.currentPage().getParameters().put('InsertId', '1');
    ApexPages.currentPage().getParameters().put('Type', 'Dummy');
        
    // Constructor    
    CallbackBookingController cbcDummy = new CallbackBookingController(Date.today(), 'Dummy');
  }

}