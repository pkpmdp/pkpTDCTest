@isTest
private class clstgrCaseAfterInsertUpdateTest {
    public static final Id SLA_PROCESS_ID = '552D00000008PUY';
    public static final String CASE_DEPARTMENT = 'YFF';
    public static final String CASE_PRODUCT = 'Visitering';

    static testMethod void testNpInportCompleteOrder() {
        String custEmail = 'john@doe.com';
        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = 'xx'+custEmail;
        acc.PersonEmail = null;
        acc.No_Email__c = true;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        custNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:acc.id ].Customer_No__c;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Customer_Number__c = custNumber;
        npOrder.Telephone_Number__c = '01234567';
        npOrder.Customer_Email__c = custEmail;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        Date aDate = Date.today();

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.Customer_Number__c = custNumber;
        insert aCase;

        Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
        NP_Order__c dbOrder = [
            SELECT In_Port_Notification_Status__c, First_Reminder_Date__c, Second_Reminder_Date__c, Order_Close_Date__c,
                Customer_Email__c, Customer_Name__c, Status__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assertEquals(clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM, dbOrder.In_Port_Notification_Status__c);
        System.assertEquals(aDate.addDays(config.First_Delay__c.intValue()), dbOrder.First_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Second_Delay__c.intValue()), dbOrder.Second_Reminder_Date__c.date());
        System.assertEquals(aDate.addDays(config.Third_Delay__c.intValue()), dbOrder.Order_Close_Date__c.date());
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION, dbOrder.Status__c);

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        Account dbAccount = [SELECT Id, PersonEmail, Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals(dbAccount.PersonEmail, dbOrder.Customer_Email__c);
        System.assertEquals(dbAccount.Name, dbOrder.Customer_Name__c);
    }
    
    static testMethod void testNpInportCompleteOrderDKTV() {
        /* When there is a DKTV Flow flag set on NP Case,
           confirm the order automatically and
           do not send any authorization request to the customer (SPOC-570, DKTV-106)
        */
        String custEmail = 'john@doe.com';
        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String DKTVnumber = '11110001111';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = 'xx'+custEmail;
        acc.PersonEmail = null;
        acc.No_Email__c = true;
        acc.DKTV_Customer_Number__c = DKTVnumber;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        custNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:acc.id ].Customer_No__c;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Customer_Number__c = custNumber;
        npOrder.Telephone_Number__c = '01234567';
        npOrder.Customer_Email__c = custEmail;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        Date aDate = Date.today();

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.Customer_Number__c = custNumber;
        aCase.NP_DKTV_Flow__c = true;
        insert aCase;

        NP_Order__c dbOrder = [
            SELECT In_Port_Notification_Status__c, External_Customer_Number__c,
                Customer_Email__c, Customer_Name__c, Status__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assertEquals(dbOrder.In_Port_Notification_Status__c, null);
        System.assertEquals(DKTVnumber, dbOrder.External_Customer_Number__c);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED, dbOrder.Status__c);

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        Account dbAccount = [SELECT Id, PersonEmail, Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals(dbAccount.PersonEmail, dbOrder.Customer_Email__c);
        System.assertEquals(dbAccount.Name, dbOrder.Customer_Name__c);
    }

    static testMethod void testMilestoneUpdate(){
        Account testAcc = new Account(Name='Test account entitlement');
        testAcc.Dummy_Account__c = true;
        try{
            insert testAcc;
        } catch (Exception e){
            System.debug('Error updating milestones:' + e.getMessage());
        }
    
        Entitlement testEnt = new Entitlement(Name = 'Test entitlement');
        testEnt.AccountId = testAcc.id;
        testEnt.SlaProcessId = clstgrCaseAfterInsertUpdateTest.SLA_PROCESS_ID;
        try {
            insert testEnt;
        } catch (Exception e){
            System.debug('Error updating milestones:' + e.getMessage());
        }
        
        Case testCase = new Case();
        testCase.EntitlementId = testEnt.id;
        testCase.Department__c = clstgrCaseAfterInsertUpdateTest.CASE_DEPARTMENT;
        testCase.Product_2__c = clstgrCaseAfterInsertUpdateTest.CASE_PRODUCT;
        try {
            insert testCase;
        } catch (Exception e){
            System.debug('Error updating milestones:' + e.getMessage());
        }
        
        List<CaseMilestone> tmpMilestonesList = [SELECT Id,CompletionDate,IsCompleted,IsViolated,MilestoneTypeId,StartDate,TargetDate FROM CaseMilestone WHERE CaseId = :testCase.Id];
  
        //System.assert(tmpMilestonesList.isEmpty() == false, 'Case milestones list is empty, should have some items!');
        
        Integer itemCountBeforeClose = 0;
        for(CaseMilestone tmpCM: tmpMilestonesList){
            System.assertEquals(tmpCM.CompletionDate, null, 'Case milestone '+ itemCountBeforeClose +' - CompletionDate is not null');
            System.assertEquals(tmpCM.IsCompleted, false, 'Case milestone '+ itemCountBeforeClose +' - IsCompleted is true, should be false!');
            itemCountBeforeClose++;
        }
        
        testCase.Status = 'Closed';
        try{
            update testCase;
        } catch (Exception e){
            System.debug('Error updating milestones:' + e.getMessage());
        }

        tmpMilestonesList = [SELECT Id,CompletionDate,IsCompleted,IsViolated,MilestoneTypeId,StartDate,TargetDate FROM CaseMilestone WHERE CaseId = :testCase.Id];
        
        Integer itemCountAfterClose = 0;
        for(CaseMilestone tmpCM: tmpMilestonesList){
            System.assertNotEquals(tmpCM.CompletionDate, null, 'Case milestone '+ itemCountAfterClose +' - CompletionDate is null, should have value!');
            System.assertEquals(tmpCM.IsCompleted, true, 'Case milestone '+ itemCountAfterClose +' - IsCompleted is false, should be true!');
            itemCountAfterClose++;
        }
        
        System.assert(itemCountBeforeClose == itemCountAfterClose, 'Count of CaseMailstone items before close and after close should be the same!');
    }

    static testMethod void testSurveySent() {
        Account acc = new Account(Name='Joe Doe');
        acc.Survey_sent_date__c = null;
        acc.Dummy_Account__c = true;
        insert acc;

        Case aCaseA = new Case();
        aCaseA.AccountId = acc.id;
        aCaseA.Status = 'Closed';
        aCaseA.Udsendt_survey_test__c = false;
        insert aCaseA;

        Case aCaseB = new Case();
        aCaseB.AccountId = acc.id;
        aCaseB.Status = 'Closed';
        aCaseB.Udsendt_survey_test__c = false;
        aCaseB.Survey_Cancellation__c = false;
        insert aCaseB;

        Case aCaseC = new Case();
        aCaseC.AccountId = acc.id;
        aCaseC.Status = 'Closed';
        aCaseC.Udsendt_survey_test__c = false;
        aCaseC.Survey_Cancellation__c = false;
        insert aCaseC;

        // Validate test data
        Account dbAcc = [SELECT Survey_sent_date__c FROM Account WHERE Id = :acc.Id];
        System.assert(dbAcc.Survey_sent_date__c == null);
        Case dbCaseA = [SELECT AccountId, Udsendt_survey_test__c, Status FROM Case WHERE Id = :aCaseA.Id];
        System.assert(dbCaseA.AccountId != null);
        System.assert(!dbCaseA.Udsendt_survey_test__c);
        System.assert(dbCaseA.Status == 'Closed');
        Case dbCaseB = [SELECT AccountId, Udsendt_survey_test__c, Survey_Cancellation__c, Status FROM Case WHERE Id = :aCaseB.Id];
        System.assert(dbCaseB.AccountId != null);
        System.assert(!dbCaseB.Udsendt_survey_test__c);
        System.assert(!dbCaseB.Survey_Cancellation__c);
        System.assert(dbCaseB.Status == 'Closed');
        Case dbCaseC = [SELECT AccountId, Udsendt_survey_test__c, Survey_Cancellation__c, Status FROM Case WHERE Id = :aCaseC.Id];
        System.assert(dbCaseC.AccountId != null);
        System.assert(!dbCaseC.Udsendt_survey_test__c);
        System.assert(!dbCaseC.Survey_Cancellation__c);
        System.assert(dbCaseC.Status == 'Closed');

        // Trigger the action (SPOC-1269)
        aCaseA.Udsendt_survey_test__c = true;
        update aCaseA;

        // Validate the result
        dbAcc = [SELECT Survey_sent_date__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(dbAcc.Survey_sent_date__c, Date.today());
        dbCaseA = [SELECT Udsendt_survey_test__c, Survey_Cancellation__c FROM Case WHERE Id = :aCaseA.Id];
        System.assert(dbCaseA.Udsendt_survey_test__c);
        System.assert(!dbCaseA.Survey_Cancellation__c);
        dbCaseB = [SELECT Survey_Cancellation__c FROM Case WHERE Id = :aCaseB.Id];
        System.assert(dbCaseB.Survey_Cancellation__c);
        dbCaseC = [SELECT Survey_Cancellation__c FROM Case WHERE Id = :aCaseC.Id];
        System.assert(dbCaseC.Survey_Cancellation__c);
    }
}