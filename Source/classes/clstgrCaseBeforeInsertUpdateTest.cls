@isTest
private class clstgrCaseBeforeInsertUpdateTest {

    static testMethod void testNpInportIncompleteOrder() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEINCOMPLETE), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE, dbOrder.Status__c);
    }

    static testMethod void testNpOutportIncompleteOrder() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Current_Customer_Id__c = null;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
        
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEREJECTED), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE, dbOrder.Status__c);
    }

    static testMethod void testNpOutportMinimalValidOrder() {
        String code = '77777';
        // Instantiate an NP Operator
        NP_Operator__c operator = new NP_Operator__c(Name='YouSee', Code__c=code, Email__c='a@b.com');
        insert operator;

        // Instantiate a Customer
        String custNumber = '666';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        custNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:acc.id ].Customer_No__c;

        // Instantiate an NP Order
        String custPhone = '12345678';
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = custPhone;
        //npOrder.Customer_Number__c = custNumber; // Will be set automatically
        npOrder.Current_Customer_Id__c = custNumber;
        npOrder.Customer_Number_Kasia__c = custNumber;
        npOrder.External_Operator_Code__c = code;    // Will be translated to Name
        npOrder.Order_Id__c = 1;
        npOrder.Series_Count__c = 0;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        Case dbCase = [
            SELECT Status, RecordTypeId, NP_Order__r.Telephone_Number__c,
            NP_Order__r.External_Operator__c, Customer_Number__c,
            NP_Telephone_Number_Srch__c, NP_Customer_Number_Srch__c
            FROM Case WHERE Id = :aCase.Id
        ];

        // status & record type should be changed by trigger
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEOPEN), dbCase.RecordTypeId);
        System.assertEquals(custPhone, dbCase.NP_Order__r.Telephone_Number__c);
        System.assertEquals(operator.Id, dbCase.NP_Order__r.External_Operator__c);
        System.assertEquals(custNumber, dbCase.Customer_Number__c);
        System.assertEquals(custPhone, dbCase.NP_Telephone_Number_Srch__c);
        System.assertEquals(custNumber, dbCase.NP_Customer_Number_Srch__c);

        NP_Order__c dbOrder = [
            SELECT Status__c, Customer_Number__c, Current_Customer_Id__c, Authorization_Approved__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT, dbOrder.Status__c);
        System.assertEquals(dbOrder.Customer_Number__c, dbOrder.Current_Customer_Id__c);
        System.assert(dbOrder.Authorization_Approved__c);
    }

    static testMethod void testNpOutportNumberSeriesOnInsert() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Series_Count__c = 1;
        npOrder.Current_Customer_Id__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case        
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
        
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEREJECTED), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c, Disapproval_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT, dbOrder.Status__c);
        System.assertEquals(clsCasesNpHandlerController.ERR_330, dbOrder.Disapproval_Reason__c);
    }

    static testMethod void testNpOutportNumberSeriesOnUpdate() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER;
        insert npOrder;

        // Instantiate a Case        
        Case aCase = new Case();
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        //noRT: aCase.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEOPEN);
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
        
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEOPEN), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Disapproval_Reason__c, Series_Count__c, Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(null, dbOrder.Disapproval_Reason__c);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER, dbOrder.Status__c);

        dbOrder.Series_Count__c = 1;
        dbOrder.Current_Customer_Id__c = '666';
        dbOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        update dbOrder;

        dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEREJECTED), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        dbOrder = [SELECT Status__c, Disapproval_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT, dbOrder.Status__c);
        System.assertEquals(clsCasesNpHandlerController.ERR_330, dbOrder.Disapproval_Reason__c);
    }

    static testMethod void testNpOutportNoMatchOrder() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '911';
        npOrder.Current_Customer_Id__c = '666';
        npOrder.Series_Count__c = 0;
        npOrder.Customer_Number_Kasia__c = '007'; // does not match Current_Customer_Id__c
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
       
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c, Disapproval_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT, dbOrder.Status__c);
        System.assertEquals(clsCasesNpHandlerController.ERR_339, dbOrder.Disapproval_Reason__c);
    }

    static testMethod void testNpOutportInactiveSubscriptionOrder() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '911';
        npOrder.Current_Customer_Id__c = '666';
        npOrder.Series_Count__c = 0;
        npOrder.Customer_Number_Kasia__c = '0'; // subscription is inactive for more than 6 months
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
       
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c, Disapproval_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT, dbOrder.Status__c);
        System.assertEquals(clsCasesNpHandlerController.ERR_349, dbOrder.Disapproval_Reason__c);
    }

    static testMethod void testNpInportAcceptedOrder() {
        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String custPhone = '01234567';
        String custEmail = 'john@doe.com';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = custEmail;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;

        // Instantiate an NP Error Code
        String errCode = '3xx';
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=true, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = custPhone;
        npOrder.Customer_Email__c = custEmail;
        npOrder.Customer_Number__c = custNumber;
        npOrder.NP_Date__c = Date.today();
        npOrder.OCH_Error_Code__c = errCode;
        npOrder.OCH_Error_Message__c = errCode + ' - banana';
        npOrder.Is_Frequent_Code__c = true;
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.Id;
        aCase.Customer_Number__c = custNumber;
        insert aCase;

        Case dbCase = [
            SELECT NP_Telephone_Number_Srch__c, NP_Customer_Number_Srch__c
            FROM Case WHERE Id = :aCase.Id
        ];
        System.assertEquals(custPhone, dbCase.NP_Telephone_Number_Srch__c);
        System.assertEquals(custNumber, dbCase.NP_Customer_Number_Srch__c);

        custNumber = custNumber + '0';
        custPhone = custPhone  + '0';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        npOrder.Telephone_Number__c = custPhone;
        npOrder.Customer_Number__c = custNumber;
        update npOrder;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED;
        update npOrder;

        dbCase = [
            SELECT NP_Telephone_Number_Srch__c, NP_Customer_Number_Srch__c
            FROM Case WHERE Id = :aCase.Id
        ];
        System.assertEquals(custPhone, dbCase.NP_Telephone_Number_Srch__c);
        System.assertEquals(custNumber, dbCase.NP_Customer_Number_Srch__c);

        NP_Order__c dbOrder = [
            SELECT NP_Launch_Date__c, NP_Alert_Date__c, OCH_Error_Code__c, OCH_Error_Message__c, Is_Frequent_Code__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assert(dbOrder.NP_Launch_Date__c != null);
        System.assert(dbOrder.NP_Alert_Date__c != null);
        System.assertEquals(null, dbOrder.OCH_Error_Code__c);
        System.assertEquals(null, dbOrder.OCH_Error_Message__c);
        System.assert(!dbOrder.Is_Frequent_Code__c);
    }

    static testMethod void testNpInportRejectedOrder_RareErrorCode() {
        // Instantiate an NP Error Code
        String errCode = '33x'; // A rare error code
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=false, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String custEmail = 'john@doe.com';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = custEmail;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '01234567';
        npOrder.Customer_Email__c = custEmail;
        npOrder.Customer_Number__c = custNumber;
        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.Id;
        aCase.Customer_Number__c = custNumber;
        insert aCase;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        update npOrder;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED;
        npOrder.OCH_Error_Message__c = errCode + ' - banana';
        update npOrder;

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NEW, dbCase.Status);
        NP_Order__c dbOrder = [SELECT Status__c, OCH_Error_Code__c, OCH_Error_Message__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK, dbOrder.Status__c);
    }

    static testMethod void testNpInportRejectedOrder_FrequentErrorCode() {
        // Instantiate an NP Error Code
        String errCode = '338'; // A frequent error code
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=false, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String custEmail = 'john@doe.com';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = custEmail;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '01234567';
        npOrder.Customer_Email__c = custEmail;
        npOrder.Customer_Number__c = custNumber;
        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.Id;
        aCase.Customer_Number__c = custNumber;
        insert aCase;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        update npOrder;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED;
        npOrder.OCH_Error_Message__c = errCode + ' - banana';
        update npOrder;

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED, dbOrder.Status__c);
    }

    static testMethod void testNpInportCanceledOrder() {
        // Instantiate a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String custEmail = 'john@doe.com';
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.Customer_No__c = custNumber;
        acc.PersonEmail = custEmail;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        custNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:acc.id ].Customer_No__c;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '01234567';
        npOrder.Customer_Email__c = custEmail;
        npOrder.Customer_Number__c = custNumber;
        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.NP_Order__c = npOrder.id;
        aCase.AccountId = acc.Id;
        aCase.Customer_Number__c = custNumber;
        insert aCase;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED;
        update npOrder;

        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASECANCELED), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPRESERVED, dbCase.Status);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED, dbOrder.Status__c);

        try {
            dbOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION;
            update dbOrder;
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains(clsCasesNpHandlerController.ERR_NPINPORT_CANNOT_CANCEL_AGAIN));
        }
    }

/*
    static testMethod void testNpOutportClose() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Series_Count__c = 0;
        npOrder.Telephone_Number__c = '12345678';
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPORDERARRIVED;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;
        
        Case dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASEOPEN), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_NPOUTPORTINCOMPLETE, dbCase.Status);

        dbCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPORDERREJECTED;
        update dbCase;

        dbCase = [SELECT Status, RecordTypeId FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOUTPORTCASECLOSED), dbCase.RecordTypeId);
        System.assertEquals(clsCasesNpHandlerController.CASE_STATUS_CLOSED, dbCase.Status);
    }
*/

static testMethod void changeRecordTypeTestForCallBack() {
        
        RecordType caseRecordTypeNew = [ Select Id From RecordType Where 
            Name = 'Call Back Queue Owned Case'];
        RecordType caseRecordTypeClosed = [ Select Id From RecordType Where 
            Name = 'Call Back Closed Case'];
        RecordType caseRecordTypeNoDoc = [ Select Id From RecordType Where 
            Name = 'Call Back Open Case - No Document'];
        RecordType caseRecordTypeYks = [ Select Id From RecordType Where 
            Name = 'Call Back YKS Sag Case'];
       
        CB_Case__c cb = new CB_Case__c();
        cb.CB_time_from__c = date.today();
        cb.CB_time_to__c = date.today();
        cb.CB_type__c = 'Security'; 
        insert cb; 
            
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Complaint Letter '; 
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YOT';
        c.Product_2__c = 'YOT Call Back';
        c.Type_Task__c = 'Security';
        c.RecordTypeId = caseRecordTypeNew.Id;
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeNew.Id);
         
        c = new Case();
        c.Status = 'Open';
        c.Subject = 'Complaint Letter '; 
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YKS';
        c.RecordTypeId = caseRecordTypeYks.Id;
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        casesToCreate.add(c);        
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeYks.Id);
            
        c = new Case();
        c.Status = 'Closed';
        c.Subject = 'Complaint Letter '; 
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YOT';
        c.Product_2__c = 'YOT Call Back';
        c.Type_Task__c = 'Security';
        c.RecordTypeId = caseRecordTypeClosed.Id;
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        casesToCreate.add(c);        
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeClosed.Id);
    
    }
    
    static testMethod void changeRecordTypeTestForOutbound() {
        
        RecordType caseRecordTypeNew = [ Select Id From RecordType Where 
            Name = 'Outbound Queue Owned Case'];
        RecordType caseRecordTypeClosed = [ Select Id From RecordType Where 
            Name = 'Outbound Closed Case'];
        RecordType caseRecordTypeOpen = [ Select Id From RecordType Where 
            Name = 'Outbound Open Case'];

       
        CB_Case__c cb = new CB_Case__c();
        cb.CB_time_from__c = date.today();
        cb.CB_time_to__c = date.today();
        cb.CB_type__c = 'Green Lamp'; 
        insert cb; 
            
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Complaint Letter '; 
        c.Origin = 'SAS System';
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YKRL';
        c.Product_2__c = 'Green Lamp';
        c.Type_Task__c = '1 Call';
        c.RecordTypeId = caseRecordTypeNew.Id;
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeNew.Id);
         
        /* 
        c = new Case();
        c.Status = 'Open';
        c.Subject = 'Complaint Letter '; 
        c.Origin = 'SAS System';
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YKRL';
        c.Product_2__c = 'Green Lamp';
        c.Type_Task__c = '1 Call';
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        casesToCreate.add(c);        
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeOpen.Id);
        */
            
        c = new Case();
        c.Status = 'Closed';
        c.Subject = 'Complaint Letter '; 
        c.Origin = 'SAS System';
        c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123'; 
        c.Department__c = 'YKRL';
        c.Product_2__c = 'Green Lamp';
        c.Type_Task__c = '1 Call';
        c.RecordTypeId = caseRecordTypeClosed.Id;
        c.Call_Back__c = cb.Id;
        c.setOptions(dmo);
        casesToCreate.add(c);        
        insert c;
        System.assertEquals(c.RecordTypeId , caseRecordTypeClosed.Id);
    
    }

}