@isTest
/**
 * A test class for clsCasesNpAuthorizationCreateController.
 */
private class clsCasesNpAuthorizationCreateCtrlTest {

    public static testMethod void testSaveEmpty() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpAuthorizationCreate;
        Test.setCurrentPage(pageRef);

        // Instantiate a Case record
        Case aCase = new Case();

        // Instantiate and construct the controller class.
        clsCasesNpAuthorizationCreateController ctrl =
            new clsCasesNpAuthorizationCreateController(new ApexPages.standardController(aCase))
        ;

        // Save:
        pageRef = ctrl.save();
        // Check that the save() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);
    }

    public static testMethod void testSaveFull() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.CasesNpAuthorizationCreate;
        Test.setCurrentPage(pageRef);

        // Prepare a Customer
        String custName = 'John Doe';
        String custNumber = '987654321';
        String custPhone = '12345678';
        Account acc = new Account(name=custName);
        acc.Customer_No__c = custNumber;
        acc.Phone = custPhone;
        acc.Dummy_Account__c = true;
        insert acc;
        System.debug('>>>>> Account created: ' + acc.Id);
        custNumber = [SELECT Id,Customer_No__c FROM Account WHERE Id =:acc.id ].Customer_No__c;

        // Prepare a Contact
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.HomePhone = custPhone;
        insert cnt;
        System.debug('>>>>> Contact created: ' + cnt.Id);

        // Instantiate a Case record
        Case aCase = new Case();

        // Instantiate and construct the controller class.
        clsCasesNpAuthorizationCreateController ctrl =
            new clsCasesNpAuthorizationCreateController(new ApexPages.standardController(aCase))
        ;

        // fill NP related fields to NP Order record of the controller
        ctrl.npOrder.Customer_Number__c = custNumber;

        // Save:
        pageRef = ctrl.save();
        // Check that the save() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Case dbCase = [
            SELECT Department__c, Product_2__c, Type_Task__c, Customer_Number__c, Phone_Number__c, Status,
                NP_Order__r.Customer_Name__c, NP_Order__r.Authorization_Received__c, NP_Order__r.Status__c
            FROM Case
            WHERE Id = :aCase.Id
        ];

        System.assertEquals(clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT, dbCase.Department__c);
        System.assertEquals(clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT, dbCase.Product_2__c);
        System.assertEquals(clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT, dbCase.Type_Task__c);
        System.assertEquals(custNumber, dbCase.Customer_Number__c);
        System.assertEquals(custName, dbCase.NP_Order__r.Customer_Name__c);
        System.assertEquals(custPhone, dbCase.Phone_Number__c);
        System.assertEquals(true, dbCase.NP_Order__r.Authorization_Received__c);
        System.assertEquals(clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER, dbCase.NP_Order__r.Status__c);
        System.assertEquals(dbCase.Status, clsCasesNpHandlerController.CASE_STATUS_NPRESERVED);
    }
}