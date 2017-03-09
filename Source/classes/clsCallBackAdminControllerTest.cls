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
private class clsCallBackAdminControllerTest {
	
	public static Date TEST_VALID_FROM_IN_PAST = Date.newInstance(2000,1,1);
	public static Date TEST_CURRENTLY_VALID = Date.newInstance(2011,1,1);
	public static Date TEST_VALID_FROM_IN_FUTURE = Date.newInstance(2020,1,1);
	public static Date TEST_FUTURE_DATE = Date.newInstance(2020,2,2);
	public static String TEST_TYPE = 'Broadband';

    static testMethod void deleteTemplateFromPastTest() {
		Test.startTest();
		String templateId1 =createTemplate(TEST_VALID_FROM_IN_PAST,TEST_TYPE);
		String templateId3 =createTemplate(TEST_CURRENTLY_VALID,TEST_TYPE);
		String templateId2 =createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
		createCustomVal();
		
		PageReference pageRef = Page.CallBackAdminPage;
    	Test.setCurrentPage(pageRef);
        clsCallBackAdminController c = new clsCallBackAdminController();
        

        System.assert(c.getTemplates()!=null);
        System.assert(c.getTemplates().size()>0);

	    ApexPages.currentPage().getParameters().put('templateId', templateId1);
		c.editTemplate();
		Integer origTemplateSize=c.getTemplates().size();
		//delete template from the past
		c.deleteTemplate();
		Integer newTemplateSize=c.getTemplates().size();
		//size should decrease
		System.assert(origTemplateSize>newTemplateSize);
        
        Test.stopTest();
    }
    
    static testMethod void deleteTemplateFromFutureTest() {
		Test.startTest();
		String templateId1 =createTemplate(TEST_VALID_FROM_IN_PAST,TEST_TYPE);
		String templateId3 =createTemplate(TEST_CURRENTLY_VALID,TEST_TYPE);
		String templateId2 =createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
		createCustomVal();
		
		PageReference pageRef = Page.CallBackAdminPage;
    	Test.setCurrentPage(pageRef);
        clsCallBackAdminController c = new clsCallBackAdminController();
        

        System.assert(c.getTemplates()!=null);
        System.assert(c.getTemplates().size()>0);

        //Try to delete template from the future with valid cust value
        Integer origTemplateSize=c.getTemplates().size();
        Integer origCustSize=c.getCustVals().size();
        ApexPages.currentPage().getParameters().clear();
	    ApexPages.currentPage().getParameters().put('templateId', templateId2);
	    //try to delete this template - delete should not be successfull
		c.deleteTemplate();
		Integer newTemplateSize=c.getTemplates().size();
		Integer newCustSize=c.getCustVals().size();
		
		//neither template nor custVal should not be deleted because of trigger validation
		System.assert(origTemplateSize==newTemplateSize);
		System.assert(origCustSize==newCustSize);

        Test.stopTest();
    }

    static testMethod void deleteValidTemplateTest() {
		Test.startTest();
		String templateId1 =createTemplate(TEST_VALID_FROM_IN_PAST,TEST_TYPE);
		String templateId3 =createTemplate(TEST_CURRENTLY_VALID,TEST_TYPE);
		String templateId2 =createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
		createCustomVal();
		
		PageReference pageRef = Page.CallBackAdminPage;
    	Test.setCurrentPage(pageRef);
        clsCallBackAdminController c = new clsCallBackAdminController();
        

        System.assert(c.getTemplates()!=null);
        System.assert(c.getTemplates().size()>0);

		//Try to delete currently valid template
		for(clsCallBackAdminController.TemplateWithStyle item:c.getTemplates()){
	        if (clsCallBackUtil.isCurrentlyValid(item.item)){
		        Integer origTemplateSize=c.getTemplates().size();
		        ApexPages.currentPage().getParameters().clear();
			    ApexPages.currentPage().getParameters().put('templateId', item.item.Id);
			    //try to delete this template - delete should not be successfull
				c.deleteTemplate();
				Integer newTemplateSize=c.getTemplates().size();
				//template should not be deleted because of trigger validation
				System.assert(origTemplateSize==newTemplateSize);
				break;	            
	        }
		}

        Test.stopTest();
    }
    

    static testMethod void deleteCustValueTest() {
		Test.startTest();
		String templateId1 =createTemplate(TEST_VALID_FROM_IN_PAST,TEST_TYPE);
		String templateId3 =createTemplate(TEST_CURRENTLY_VALID,TEST_TYPE);
		String templateId2 =createTemplate(TEST_VALID_FROM_IN_FUTURE,TEST_TYPE);
		createCustomVal();
		
		PageReference pageRef = Page.CallBackAdminPage;
    	Test.setCurrentPage(pageRef);
        clsCallBackAdminController c = new clsCallBackAdminController();
        

        System.assert(c.getTemplates()!=null);
        System.assert(c.getTemplates().size()>0);

		//Delete cust value
		//last custVal should be our 
		clsCallBackCustomDay custDay = c.getCustVals()[c.getCustVals().size()-1];
		Integer origCustSize=c.getCustVals().size();
	    ApexPages.currentPage().getParameters().put('date', custDay.getUrlFormatedDay());
	    ApexPages.currentPage().getParameters().put('type', TEST_TYPE);
		String formatedDay = custDay.getFormatedDay();
		System.assert(formatedDay!=null);
		//delete should be succesfull	    
		c.deleteCustomDay();
        Integer newCustSize=c.getCustVals().size();
        System.assert(origCustSize>newCustSize);
        
        // create case
        createCase();
        //Try to delete template from the future with valid cust value
        Integer origTemplateSize=c.getTemplates().size();
        ApexPages.currentPage().getParameters().clear();
	    ApexPages.currentPage().getParameters().put('templateId', templateId2);
	    //try to delete this template - delete should not be successfull
		c.deleteTemplate();
		Integer newTemplateSize=c.getTemplates().size();
		
		//template should not be deleted because of trigger validation
		System.assert(origTemplateSize==newTemplateSize);
        
        Test.stopTest();
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
    
    private static String createTemplate(Date validFrom,String cbType){
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
    	
    	return template.Id;
    }
    
    private static void createCase(){
    	CB_Case__c cbCase1 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(TEST_FUTURE_DATE, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(TEST_FUTURE_DATE, Time.newInstance(11, 0, 0, 0)), CB_type__c = TEST_TYPE);
    	insert cbCase1;
    
	    Case case1 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = TEST_TYPE, Status = 'New', Call_Back__c = cbCase1.Id);
    	insert case1;
    }
}