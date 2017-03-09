@isTest
private class clstgrNPOrderBeforeInsertUpdateTest {

    static testMethod void testNpOrderNoExtOperatorCode() {
        NP_Operator__c operator = new NP_Operator__c(Name='YouSee', Code__c='77777', Email__c='a@b.com');
        insert operator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.External_Operator__c = operator.Id;
        insert npOrder;

        NP_Order__c dbOrder = [SELECT External_Operator_Code__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(operator.Code__c, dbOrder.External_Operator_Code__c);
    }

    static testMethod void testNpOrderNoExtOperatorName() {
        NP_Operator__c operator = new NP_Operator__c(Name='YouSee', Code__c='77777', Email__c='a@b.com');
        insert operator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.External_Operator_Code__c = operator.Code__c;
        insert npOrder;

        NP_Order__c dbOrder = [SELECT External_Operator__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(operator.Id, dbOrder.External_Operator__c);
    }

    static testMethod void testUpdatedNpDateInPort() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        Date dt = Date.today();
        npOrder.NP_Date__c = dt;
        npOrder.NP_Launch_Date__c = dt;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE;
        insert npOrder;

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT NP_Date_Original__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.NP_Date_Original__c, dt);

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.NP_Date__c = dt.addDays(5);
        update npOrder;

        // Get from DB and compare:
        dbOrder = [SELECT NP_Launch_Date__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assert(dbOrder.NP_Launch_Date__c > dt);
    }

    static testMethod void testUpdatedNpDateOutPort() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        Date dt = Date.today().addDays(1);
        npOrder.NP_Date__c = dt;
        npOrder.Order_Id__c = 42;
        npOrder.Authorization_Received__c = true;
        npOrder.Authorization_Approved__c = true;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT NP_Date_Original__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.NP_Date_Original__c, dt);

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTCONFIRMED;
        update npOrder;

        String errMsg = '';
        try {
            npOrder.NP_Date__c = Date.today().addDays(2);
            npOrder.Confirmation_Status__c = 'banana';
            update npOrder;
    
            // Get from DB and compare:
            Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
            System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

            dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
            System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT);
        } catch (System.DmlException ex) {
            errMsg = ex.getMessage();
        }
        System.assert(errMsg.contains(clsCasesNpHandlerController.ERR_NPOUTPORT_CANNOT_RECONFIRM));
    }

    static testMethod void testRejection() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Authorization_Received__c = true;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NEW;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.Disapproval_Reason__c = 'banana';
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTREJECT);
    }

    static testMethod void testApproval() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(1);
        npOrder.Order_Id__c = 42;
        npOrder.Authorization_Received__c = true;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NEW;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.Authorization_Approved__c = true;
        npOrder.Customer_Number__c = '666';
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTACCEPT);
    }

/* Multiple OCH errors are out of scope
    static testMethod void testMultiOchError() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Authorization_Received__c = true;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NEW;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.OCH_Error_Message__c = '338 - aaa, 349 - bbb, 339 - ccc';
        update npOrder;

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT OCH_Error_Code__c, Is_Frequent_Code__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals('339', dbOrder.OCH_Error_Code__c);
        System.assert(!dbOrder.Is_Frequent_Code__c);
    }
*/

    static testMethod void testRequestCancellation() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(30);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.Cancellation_Reason__c = 'Kunden annullerer ordren';
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPORDERREQUESTCANCELLATION);
    }

    static testMethod void testWeaselRejection() {
        // Instantiate an NP Error Code
        String errCode = '380';
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=false, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(30);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c, Is_Never_Rejected__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED);
        System.assert(dbOrder.Is_Never_Rejected__c);

        //npOrder.OCH_Error_Code__c = 'xXx';
        npOrder.OCH_Error_Message__c = '66162638: ' + errCode + ' - The TelephoneNumber is present in another active flow';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED;
        update npOrder;

        // Get from DB and compare:
        dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        dbOrder = [SELECT Status__c, OCH_Error_Code__c, Is_Never_Rejected__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED);
        System.assertEquals(dbOrder.OCH_Error_Code__c, errCode);
        System.assert(!dbOrder.Is_Never_Rejected__c);
    }

    static testMethod void testWeaselRejectionAutoResume() {
        // Prepare the proper error code
        String errCode = clsCasesNpHandlerController.ERR_CODE_AUTO_RESUME_ON_REJECT;

        // Instantiate an NP Operator
        NP_Operator__c op = new NP_Operator__c(
            Name='TDC', Code__c='88888', Email__c='a@b.com', Authorization_Required__c=true
        );
        insert op;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(30);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.External_Operator__c = op.Id;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c, Is_Never_Rejected__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED);
        System.assert(dbOrder.Is_Never_Rejected__c);

        EmailMessage email = new EmailMessage();
        email.ParentId = aCase.Id;
        email.Subject = 'Subject';
        email.TextBody = 'Text Text';
        email.HtmlBody = '';
        insert email;

        npOrder.Authorization_Email_ID__c = email.Id;
        npOrder.External_Customer_Number__c = '12345';
        npOrder.OCH_Error_Message__c = 'CustomerId: ' + errCode + ' - Donor does not support Customer ID validation, please send NP Create without Customer-ID';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED;
        update npOrder;

        // Get from DB and compare:
        dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        dbOrder = [SELECT Status__c, OCH_Error_Code__c, Is_Never_Rejected__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED);
        System.assertEquals(dbOrder.OCH_Error_Code__c, null);
        System.assert(!dbOrder.Is_Never_Rejected__c);
    }

/* To be fixed (e-mail address needed)
    static testMethod void testOchRejection() {
        // Instantiate an NP Error Code
        String errCode = '380';
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=true, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(30);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        //npOrder.OCH_Error_Code__c = '380';
        npOrder.OCH_Error_Message__c = errCode + ' - The Claimant of the porting is not the subscriber of the telephone number.';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTREJECTED;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c, OCH_Error_Code__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED);
        System.assertEquals(dbOrder.OCH_Error_Code__c, errCode);
    }
*/

/* To be fixed (e-mail address needed)
    static testMethod void testAcceptance() {
        // Instantiate an NP Error Code
        String errCode = '33x';
        NP_Error_Code__c npErr = new NP_Error_Code__c(
            Name=errCode, Frequent_Code__c=true, Days_To_First_Reminder__c=1,
            Days_To_Second_Reminder__c=2, Days_To_Cancel_Order__c=3
        );
        insert npErr;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.NP_Date__c = Date.today().addDays(30);
        npOrder.Telephone_Number__c = '12345678';
        npOrder.OCH_Error_Message__c = errCode + ' - Banana';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c, OCH_Error_Message__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED);
        System.assertEquals(dbOrder.OCH_Error_Message__c, null);
    }
*/

    static testMethod void testNpConfiguration() {
        // Test Custom Settings: Number Porting Configuration
        Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CUTOVER');
        System.Assert(config != null);
        System.Assert(config.First_Delay__c != null);
        System.Assert(config.Second_Delay__c != null);
        // System.Assert(config.Third_Delay__c != null);
        config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
        System.Assert(config != null);
        System.Assert(config.First_Delay__c != null);
        System.Assert(config.Second_Delay__c != null);
        System.Assert(config.Third_Delay__c != null);
    }

    static testMethod void testValidationOnUpdate() {
        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Authorization_Received__c = true;
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        npOrder.NP_Date__c = Date.today();
        npOrder.Order_Id__c = 42;
        npOrder.Series_Count__c = 0;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NEW);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE);
    }

    static testMethod void testExternalOperatorUpdate() {
        // Instantiate 2 NP Operators
        NP_Operator__c opYS = new NP_Operator__c(Name='YouSee', Code__c='77777', Email__c='a@b.com');
        insert opYS;
        NP_Operator__c opTDC = new NP_Operator__c(Name='TDC', Code__c='88888', Email__c='a@b.com');
        insert opTDC;

        // Instantiate an NP Order
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Telephone_Number__c = '12345678';
        npOrder.Customer_Number__c = '666';
        npOrder.External_Operator__c = opYS.Id;
        npOrder.Order_Id__c = 42;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT External_Operator_Code__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.External_Operator_Code__c, opYS.Code__c);

        String errMsg = '';
        try {
            // this should not pass the validation
            dbOrder.External_Operator__c = opTDC.Id;
            update dbOrder;
        } catch (System.DmlException ex) {
            errMsg = ex.getMessage();
        }
        // Check if we got a validation error on External_Operator__c field
        System.assert(errMsg.contains('External_Operator__c'));

        dbOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
        dbOrder.External_Operator__c = opYS.Id;
        update dbOrder;

        dbOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        dbOrder.External_Operator_Code__c = opTDC.Code__c;
        update dbOrder;

        // Get from DB and compare:
        dbOrder = [SELECT External_Operator__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.External_Operator__c, opTDC.Id);
    }

    static testMethod void testAuthorizationForwardingNewOrder() {
        Test.startTest();
        String name = 'TestTDC';
        String code = '7777';
        NP_Operator__c npOperator =
            new NP_Operator__c(Name=name, Code__c=code, Email__c='a@b.com', Authorization_Required__c=true)
        ;
        insert npOperator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
        insert npOrder;

        Case aCase = new Case();
        aCase.NP_Order__c = npOrder.id;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        insert aCase;
        Test.stopTest();

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NEW);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE);

        EmailMessage email = new EmailMessage();
        email.ParentId = aCase.Id;
        email.Subject = 'Subject';
        email.TextBody = 'Text Text';
        email.HtmlBody = '';
        insert email;

        // Confirm the order
        npOrder.Authorization_Email_ID__c = email.Id;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
        update npOrder;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        update aCase;

        // New order created in Weasel
        npOrder.Order_Id__c = 1;
        npOrder.External_Operator_Code__c = code;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        update npOrder;

        // Get from DB and compare:
        dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        dbOrder = [SELECT Status__c, External_Operator__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED);
        System.assertEquals(dbOrder.External_Operator__c, npOperator.Id);
    }

    static testMethod void testAuthorizationForwardingResumedOrder() {
        String name = 'TestTDC';
        String code = '7777';
        NP_Operator__c npOperator =
            new NP_Operator__c(Name=name, Code__c=code, Email__c='a@b.com', Authorization_Required__c=true)
        ;
        insert npOperator;

        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Order_Id__c = 1;
        npOrder.External_Operator_Code__c = code;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED;
        insert npOrder;

        Case aCase = new Case();
        aCase.NP_Order__c = npOrder.id;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        insert aCase;

        EmailMessage email = new EmailMessage();
        email.ParentId = aCase.Id;
        email.Subject = 'Subject';
        email.TextBody = 'Text Text';
        email.HtmlBody = '';
        insert email;

        npOrder.Authorization_Email_ID__c = email.Id;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c, External_Operator__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED);
        System.assertEquals(dbOrder.External_Operator__c, npOperator.Id);

        Test.startTest();

        // Resume the order
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
        update npOrder;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        update aCase;

        // Resumed order created in Weasel - unknown ext. operator code
        String codeX = code + 'x';
        npOrder.Order_Id__c = 2;
        npOrder.External_Operator_Code__c = codeX;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        update npOrder;

        Test.stopTest();

        // Get from DB and compare:
        dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NEW);

        dbOrder = [
            SELECT Status__c, External_Operator__c, External_Operator_Code__c
            FROM NP_Order__c WHERE Id = :npOrder.Id
        ];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED);
        System.assertEquals(dbOrder.External_Operator__c, null);
        System.assertEquals(dbOrder.External_Operator_Code__c, codeX);
    }

    static testMethod void testDirectCloseOutPort() {
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
        
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPOUTPORTINCOMPLETE, dbOrder.Status__c);

        // Direct close of an out-port should be allowed for specific user(s) only
        // Custom settings: Dataload No Outbound Users
        Dataload_No_Outboud_Users__c uCS = Dataload_No_Outboud_Users__c.getAll().values()[0];
        User u = [SELECT Id FROM User WHERE Id = :uCS.User_Id__c];
        System.runAs(u) {
            npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_CLOSED;
            update npOrder;
        }

        dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_CLOSED, dbOrder.Status__c);
    }
}