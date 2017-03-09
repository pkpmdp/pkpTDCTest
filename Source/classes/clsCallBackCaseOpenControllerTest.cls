@isTest
/**
    A test class for clsCallBackCaseOpenController.
*/
private class clsCallBackCaseOpenControllerTest {

    public static testMethod void testCBCase() {
    	Account account = new Account(Name='testCBCase', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert account;
        
        // scenario when case has no Case
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        clsCallBackCaseOpenController controller = new clsCallBackCaseOpenController(sc);
        System.assertEquals(System.Label.No, controller.getOpenCBCaseLabel());
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Case testCase = new Case();
        testCase.AccountId = account.Id;
        testCase.Department__c = 'YOT';
        testCase.Product_2__c = 'YOT Call Back';
        testCase.Type_Task__c = 'Broadband';
        testCase.setOptions(dmo);
        insert testCase;
            
        sc = new ApexPages.StandardController(account);
        controller = new clsCallBackCaseOpenController(sc);
        
        // scenario when case has one CB_Case
        CB_Case__c cbCase = new CB_Case__c();
        insert cbCase;
        
        testCase.Call_Back__c = cbCase.Id;
        update testCase;
        
        sc = new ApexPages.StandardController(account);
        controller = new clsCallBackCaseOpenController(sc);
        
        System.assertEquals(System.Label.Yes, controller.getOpenCBCaseLabel());
    }
}