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
private class clsCBSchedCustValsControllerTest {
	
	public static Date TEST_VALID_FROM_IN_PAST = Date.newInstance(2000,1,1);
	public static Date TEST_VALID_FROM_IN_FUTURE = Date.newInstance(2020,1,1);
	public static Date TEST_FUTURE_DATE = Date.newInstance(2020,2,8);
	public static String[] TEST_FUTURE_DATE_URL_PARAM = new String[]{'02-02-2020','03-02-2020','04-02-2020','05-02-2020','06-02-2020','07-02-2020','08-02-2020'};
	public static String TEST_TYPE = 'Broadband';

    static testMethod void editCustValTest() {
        Test.startTest();

        CB_Schedule_Template__c template = createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
        createCustomVal();
		
		PageReference pageRef = Page.CB_SchedCustVals;
		Test.setCurrentPage(pageRef);
    	clsCBSchedCustValsController c;
    	
    	// initial parameters
    	for (Integer i=0;i<7;i++){
    		
		    ApexPages.currentPage().getParameters().clear();
	    	ApexPages.currentPage().getParameters().put('date', TEST_FUTURE_DATE_URL_PARAM[i]);
	    	ApexPages.currentPage().getParameters().put('type', TEST_TYPE);
	    
	    	//new template
	    	ApexPages.StandardController sc = new ApexPages.StandardController(new CB_Custom_Schedule__c());
	        c = new clsCBSchedCustValsController(sc);
	        System.assert(c.defAndCustVals!=null);
	        System.assert(c.defAndCustVals.size()==6);
	        System.assert(c.defVals!=null);
	        System.assert(c.defVals.size()==6);
			System.assert(c.getFormatedDay()!=null);
    	}
    	
		System.assert(c.defAndCustVals[0].custVal=='1');
		System.assertEquals(TEST_FUTURE_DATE, c.day);
		    	
		//test incorrect value
		c.defAndCustVals[1].custVal='a';
		c.quicksaveCustom();
		//check status in DB
		List<CB_Custom_Schedule__c> custValsInDb = [select id from CB_Custom_Schedule__c where CB_type__c=:TEST_TYPE and CB_time_from__c>=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0)) and CB_time_from__c<=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(15,0,0,0))];
		System.assert(custValsInDb.size()==1);
		
		//create new cust val
		c.defAndCustVals[1].custVal='3';
		c.quicksaveCustom();
		//check status in DB
		custValsInDb = [select id from CB_Custom_Schedule__c where CB_type__c=:TEST_TYPE and CB_time_from__c>=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0)) and CB_time_from__c<=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(15,0,0,0))];
		System.assert(custValsInDb.size()==2);


		//delete custVal
		c.defAndCustVals[1].custVal='';
		c.quicksaveCustom();
		//check status in DB
		custValsInDb = [select id from CB_Custom_Schedule__c where CB_type__c=:TEST_TYPE and CB_time_from__c>=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0)) and CB_time_from__c<=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(15,0,0,0))];
		System.assert(custValsInDb.size()==1);

		
		//save
		c.defAndCustVals[0].custVal='5';
		ApexPages.currentPage().getParameters().put('retUrl', '/apex/CallBackAdminPage');
		c.saveCustom();
		//check status in DB
		custValsInDb = [select 	Max_slots__c from CB_Custom_Schedule__c where CB_type__c=:TEST_TYPE and CB_time_from__c>=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(10,0,0,0)) and CB_time_from__c<=:DateTime.newInstance(TEST_FUTURE_DATE,Time.newInstance(15,0,0,0))];
		System.assert(custValsInDb.size()==1);
		System.assert(custValsInDb[0].Max_slots__c==5);
		
		
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

     private static void createCase(){
    	CB_Case__c cbCase1 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(TEST_FUTURE_DATE, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(TEST_FUTURE_DATE, Time.newInstance(11, 0, 0, 0)), CB_type__c = TEST_TYPE);
    	insert cbCase1;
    
	    Case case1 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = TEST_TYPE, Status = 'New', Call_Back__c = cbCase1.Id);
    	insert case1;
    }
    
}