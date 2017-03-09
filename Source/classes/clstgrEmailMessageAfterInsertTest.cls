@isTest
private class clstgrEmailMessageAfterInsertTest {

    static testMethod void testFeedback() {
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

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTFEEDBACK;
        update npOrder;

        EmailMessage m = new EmailMessage(TextBody='Banana');
        m.Incoming = true;
        m.ParentId = aCase.id;
        insert m;

        // Get from DB and compare:
        Case dbCase = [SELECT RecordTypeId, Status FROM Case WHERE Id = :aCase.Id];
        //noRT: System.assertEquals(dbCase.RecordTypeId, clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEFEEDBACKRECEIVED));
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NEW);

        NP_Order__c dbOrder = [SELECT Status__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Status__c, clsCasesNpHandlerController.NPO_STATUS_NPREJECTIONFEEDBACKRECEIVED);
    }

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

        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION;
        update npOrder;

        EmailMessage m = new EmailMessage(TextBody='Banana');
        m.Incoming = true;
        m.ParentId = aCase.id;
        insert m;
    }

    static testMethod void testReceivedEmailNotification() {
        Case aCase = new Case();
        aCase.Status = 'Reserved';
        aCase.Department__c = 'YFF';
        date untilDate = date.today();
        untilDate = untilDate .addDays(2);
        aCase.Reserve_Until__c = untilDate ;
        insert aCase;

        EmailMessage m = new EmailMessage(TextBody='Test');
        m.Incoming = true;
        m.ToAddress = 'foreningsservice@yousee.dk';
        m.ParentId = aCase.id;
        insert m;
    }
}