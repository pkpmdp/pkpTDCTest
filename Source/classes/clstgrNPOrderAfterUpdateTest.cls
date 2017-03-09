@isTest
private class clstgrNPOrderAfterUpdateTest {

    static testMethod void testConfirm() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CONFIRM;
        update npOrder;
    }

    static testMethod void testFirst() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST;
        update npOrder;
    }

    static testMethod void testSecond() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND;
        update npOrder;
    }

    static testMethod void testClosed() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASECANCELED));
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_CANCELLED);

        /*
        NP Order Status is updated by a time based WF Rule
        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPORDERCANCELED);
        */
    }

    static testMethod void testFirstRF() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_FIRST_RF;
        update npOrder;
    }

    static testMethod void testSecondRF() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_SECOND_RF;
        update npOrder;
    }

    static testMethod void testClosedRF() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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

        npOrder.In_Port_Notification_Status__c = clsCasesNpHandlerController.NP_ORDER_INPORT_STATUS_CLOSED_RF;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEOPEN));
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_CLOSED);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_CLOSED);
    }

    static testMethod void testLaunch() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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
        String custNumber = '987654321';
        String custPhone = '01234567';
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Customer_Number__c = custNumber;
        npOrder.Telephone_Number__c = custPhone;
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED;
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

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPLAUNCHMSG;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [
            SELECT Status, NP_Customer_Number_Srch__c, NP_Telephone_Number_Srch__c
            FROM Case WHERE Id = :aCase.Id
        ];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
        System.assertEquals(custPhone, dbCase.NP_Telephone_Number_Srch__c);
        System.assertEquals(custNumber, dbCase.NP_Customer_Number_Srch__c);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPLAUNCHMSG);
    }

    static testMethod void testSendRejectionFeedbackRequest() {
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
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
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.AccountId = acc.id;
        aCase.NP_Order__c = npOrder.id;
        insert aCase;

        // Send rejection feedback request
        npOrder.OCH_Error_Code__c = '380';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED;
        update npOrder;

        // Get from DB and compare:
        Case dbCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPFEEDBACKREQUESTED);
    }
}