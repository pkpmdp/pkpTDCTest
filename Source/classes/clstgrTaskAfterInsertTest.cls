@isTest
private class clstgrTaskAfterInsertTest {

    static testMethod void testAll() {
        // To avoid 'Attempt to de-reference a null object' error
        // in tgrContactBeforeInsert and trgBeforeInsertUpdateTask
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        if (ysRecords == null) {
            ysRecords = new YSRecordTypes__c(Name='YSRecordTypes');
            ysRecords.YS_Contact_Record_Type__c = '012M0000000Clg3';
            insert ysRecords;
        }
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;

        // Prepare a Customer
        Account acc = new Account(name='John Doe', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'banana@banana.net';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.AccountId = acc.id;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Push the flow forward: the porting order has been authorized by the customer
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        update npOrder;

        Test.startTest();

        // This task is created by CI when the createNumber call fails with a specific error
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject = 'Opfølgning';
        t.Objective__c = 'Weasel Exception';
        t.Description = 'Number ' + npOrder.Telephone_Number__c +
            ' is owned by 01079 and is not elegible for number portation.'
        ;
        t.ActivityDate = Date.today();
        t.WhatId = aCase.Id;
        t.Subject = 'Opfølgning';
        t.Type = clsCasesNpHandlerController.TASK_TYPE;
        t.Priority = clsCasesNpHandlerController.TASK_PRIORITY;
        insert t;

        Test.stopTest();

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_CANCELLED);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED);
    }
}