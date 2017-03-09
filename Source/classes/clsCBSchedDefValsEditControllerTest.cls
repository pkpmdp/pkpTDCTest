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
private class clsCBSchedDefValsEditControllerTest {

	public static Date TEST_VALID_FROM_IN_PAST = Date.newInstance(2000,1,1);
	public static Date TEST_VALID_FROM_IN_FUTURE = Date.newInstance(2020,1,1);
	public static Date TEST_FUTURE_DATE = Date.newInstance(2020,2,2);
	public static String TEST_TYPE = 'Broadband';

    static testMethod void createTemplateTest() {
		Test.startTest();
		
		PageReference pageRef = Page.CB_Sched_def_vals_edit;
    	Test.setCurrentPage(pageRef);
    	
    	//new template
    	ApexPages.StandardController sc = new ApexPages.StandardController(new CB_Schedule_Template__c());
        clsCBSchedDefValsEditController c = new clsCBSchedDefValsEditController(sc);
        
        c.getTemplate().Period__c=7;
        c.getTemplate().Working_hours_from__c=10;
        c.getTemplate().Working_hours_to__c=16;
        c.getTemplate().Valid_from__c=TEST_VALID_FROM_IN_FUTURE;

        //test required type task
        c.getCaseFields().Type_Task__c=null;
        c.quickSaveAll();
        //not saved
		System.assert(c.getTemplate().id==null);

        c.getCaseFields().Type_Task__c=TEST_TYPE;
        
        //test missing intervals
        c.quickSaveAll();
        //not saved
		System.assert(c.getTemplate().id==null);
        
        //add 1 line
        c.newLine();
        c.getDefVals()[0].item.Time_from__c = 10;
		c.getDefVals()[0].item.Time_to__c = 11;
		System.assert(c.getDefVals().size()==1);
        
        //populate working hours
		c.populate();
		System.assert(c.getDefVals().size()==6);
		System.assert(c.getDefValItems().size()==6);
		//add new lines
		c.newLine();
		c.newLine();
		c.newLine();
		System.assert(c.getDefVals().size()==9);
		System.assert(c.getDefValItems().size()==9);
		
        //test interval within working hours and interval start time<end time
        c.quickSaveAll();
        //not saved
		System.assert(c.getTemplate().id==null);

        //test overlapping interval
		c.getDefVals()[6].item.Time_from__c = 11;
		c.getDefVals()[6].item.Time_to__c = 12;
		c.getDefVals()[7].item.Time_from__c = 10;
		c.getDefVals()[7].item.Time_to__c = 13;
		c.getDefVals()[8].item.Time_from__c = 11;
		c.getDefVals()[8].item.Time_to__c = 14;
        c.quickSaveAll();
        //not saved
		System.assert(c.getTemplate().id==null);
		
		//delete overlaping lines
		ApexPages.currentPage().getParameters().put('rowId', String.valueOf(c.getDefVals()[8].rowId));
		c.deleteLine();
		ApexPages.currentPage().getParameters().clear();
		ApexPages.currentPage().getParameters().put('rowId', String.valueOf(c.getDefVals()[7].rowId));
		c.deleteLine();
		ApexPages.currentPage().getParameters().clear();
		ApexPages.currentPage().getParameters().put('rowId', String.valueOf(c.getDefVals()[6].rowId));
		c.deleteLine();
		System.assert(c.getDefVals().size()==6);

		//quick save
		c.quickSaveAll();
		//succesfull save
		System.assert(c.getTemplate().id!=null);
		
		//save
		ApexPages.currentPage().getParameters().put('retUrl', '/apex/CallBackAdminPage');
		c.saveAll();

		
        Test.stopTest();
    }
    
        static testMethod void editTemplateTest() {
 		Test.startTest();
		
		PageReference pageRef = Page.CB_Sched_def_vals_edit;
    	Test.setCurrentPage(pageRef);

		CB_Schedule_Template__c template =createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(template);
        clsCBSchedDefValsEditController c = new clsCBSchedDefValsEditController(sc);
				
		System.assert(c.getDefVals()[0].getMonStyle()!=null);
		System.assert(c.getDefVals()[0].getTueStyle()!=null);
		System.assert(c.getDefVals()[0].getWedStyle()!=null);
		System.assert(c.getDefVals()[0].getThuStyle()!=null);
		System.assert(c.getDefVals()[0].getFriStyle()!=null);
		System.assert(c.getDefVals()[0].getSatStyle()!=null);
		System.assert(c.getDefVals()[0].getSunStyle()!=null);

		
		
		//template is not used so no redirect
		PageReference redirect; 
		redirect = c.redirectIfUsed();
		System.assert(redirect==null);

		//create customVal, so redirect to CB_Sched_def_vals_used_edit
		createCustomVal();
		redirect = c.redirectIfUsed();
		System.assert(redirect!=null);
		
		//create incompatibile custom value with valid from -1 day
		createIncompatCustomVal();
		//try to move valid from - 10 days to overlap incompatible interval
		c.getTemplate().Valid_from__c=TEST_VALID_FROM_IN_FUTURE-10;
		//try to save
		c.quickSaveAll();
		//check field in DB
		CB_Schedule_Template__c templateInDB = [select Valid_from__c from CB_Schedule_Template__c where id=:template.id];
		//date not changed - there is still old value
		System.assertEquals(templateInDB.Valid_from__c,TEST_VALID_FROM_IN_FUTURE);
		
		//update intervals according incompatible interval to make it compatible
		c.getDefVals()[1].item.Time_from__c = 10;
		ApexPages.currentPage().getParameters().clear();
		ApexPages.currentPage().getParameters().put('rowId', String.valueOf(c.getDefVals()[0].rowId));
		c.deleteLine();

		c.quickSaveAll();
		templateInDB = [select Valid_from__c from CB_Schedule_Template__c where id=:template.id];
		//date in DB changed
		System.assertEquals(templateInDB.Valid_from__c,TEST_VALID_FROM_IN_FUTURE-10);
		
		//create CB Case for test date - 20 days
		createCase();
		//try to move valid from - 21 days to overlap created case
		c.getTemplate().Valid_from__c=TEST_VALID_FROM_IN_FUTURE-21;
		//try to save
		c.quickSaveAll();
		//check field in DB
		templateInDB = [select Valid_from__c from CB_Schedule_Template__c where id=:template.id];
		//date not changed - there is still old value
		System.assertEquals(templateInDB.Valid_from__c,TEST_VALID_FROM_IN_FUTURE-10);
		
		
        Test.stopTest();
        	
        }
        
    private static CB_Schedule_Template__c createTemplate(Date validFrom,String cbType){
    	CB_Schedule_Template__c template = new CB_Schedule_Template__c();
    	template.CB_type__c=cbType;
    	template.Period__c = 7;
    	template.Valid_from__c = validFrom;
    	template.Working_hours_from__c = 10;
    	template.Working_hours_to__c = 16;
    	insert template;
    	
    	List<CB_Default_Schedule__c> defVals = new List<CB_Default_Schedule__c>();
    	for (Integer i=10;i<16;i++){
    		CB_Default_Schedule__c defVal = new CB_Default_Schedule__c();
    		defVal.Time_from__c=i;
    		defVal.Time_to__c=i+1;
    		defVal.Template__c=template.id;
    		defVal.Monday__c=3;
    		defVal.Tuesday__c=3;
    		defVal.Wednesday__c=3;
    		defVal.Thursday__c=3;
    		defVal.Friday__c=3;
    		defVal.Saturday__c=0;
    		defVal.Sunday__c=0;
    		defVals.add(defVal);
    	} 
    	insert defVals;
    	
    	return template;
    }
    
    private static void createCustomVal(){
    	CB_Custom_Schedule__c custVal = new CB_Custom_Schedule__c();
    	custVal.CB_time_from__c = Datetime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0));
    	custVal.CB_time_to__c = Datetime.newInstance(TEST_FUTURE_DATE,Time.newInstance(11,0,0,0));
    	custVal.CB_date__c = TEST_FUTURE_DATE;
    	custVal.CB_type__c = TEST_TYPE;
    	custVal.Max_slots__c = 1;
    	
    	insert custVal;
    }    

    private static void createIncompatCustomVal(){
    	CB_Custom_Schedule__c custVal = new CB_Custom_Schedule__c();
    	custVal.CB_time_from__c = Datetime.newInstance(TEST_VALID_FROM_IN_FUTURE-1,Time.newInstance(10,0,0,0));
    	custVal.CB_time_to__c = Datetime.newInstance(TEST_VALID_FROM_IN_FUTURE-1,Time.newInstance(12,0,0,0));
    	custVal.CB_date__c = TEST_FUTURE_DATE;
    	custVal.CB_type__c = TEST_TYPE;
    	custVal.Max_slots__c = 1;
    	
    	insert custVal;
    }    
 
     private static void createCase(){
    	CB_Case__c cbCase1 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(TEST_FUTURE_DATE-20, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(TEST_FUTURE_DATE-20, Time.newInstance(11, 0, 0, 0)), CB_type__c = TEST_TYPE);
    	insert cbCase1;
    
	    Case case1 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = TEST_TYPE, Status = 'New', Call_Back__c = cbCase1.Id);
    	insert case1;
    }
    
}