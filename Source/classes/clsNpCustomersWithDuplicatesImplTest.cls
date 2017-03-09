@isTest(SeeAllData=true)
/**
 * A test class for clsNpCustomersWithDuplicatesImpl.
 */
private class clsNpCustomersWithDuplicatesImplTest {
    public static testMethod void testAll() {
        // Prepare custom settings
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues(clsNpCustomersWithDuplicatesImpl.csName);
        if (cs == null) {
            cs = new YouSeeCustomSettings__c(
                Name=clsNpCustomersWithDuplicatesImpl.csName,
                Setting_Value__c='kamih@yousee.dk'
            );
            insert cs;
        }

        // Prepare a Customer
        String customerNumber = '987654321';
        Account acc = new Account(Name = 'John Doe');
        acc.Customer_No__c = customerNumber;
        // a DKTV customer will make unit testing easier
        acc.DKTV_Customer_Number__c = '911';
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'john@doe.com';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;

        // Instantiate a new NP Order record - waiting for an authorization
        NP_Order__c npOrderW = new NP_Order__c();
        npOrderW.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION;
        npOrderW.Customer_Number__c = customerNumber;
        insert npOrderW;

        // Instantiate a Case record (NP: waiting for an authorization)
        Case aCaseW = new Case();
        aCaseW.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCaseW.AccountId = acc.id;
        insert aCaseW;

        // To avoid: System.LimitException: Too many SOQL queries: 101
        // when unit testing
        aCaseW.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCaseW.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCaseW.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCaseW.NP_Order__c = npOrderW.id;
        update aCaseW;

        // Instantiate a NP Order record - accepted by the donor
        NP_Order__c npOrderA = new NP_Order__c();
        npOrderA.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTACCEPTED;
        npOrderA.Notify_Kasia_Flag__c = '24-06-2013 23:25, NP Request Accepted, Success';
        npOrderA.Customer_Number__c = customerNumber;
        npOrderA.Telephone_Number__c = '911';
        insert npOrderA;

        // Instantiate a Case record (NP: accepted by the donor)
        Case aCaseA = new Case();
        aCaseA.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCaseA.AccountId = acc.id;
        insert aCaseA;

        // To avoid: System.LimitException: Too many SOQL queries: 101
        // when unit testing
        aCaseA.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCaseA.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCaseA.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCaseA.NP_Order__c = npOrderA.id;
        update aCaseA;

        // Get from DB and verify the test data
        Case dbCaseW = [
            SELECT Customer_Number__c, Type_Task__c, NP_Status__c FROM Case WHERE Id = :aCaseW.Id
        ];
        System.assertEquals(dbCaseW.Customer_Number__c, customerNumber);
        System.assertEquals(dbCaseW.NP_Status__c, clsNpCustomersWithDuplicatesImpl.waitAuthStatus);
        NP_Order__c dbOrderA = [
            SELECT Customer_Number__c, Notify_Kasia_Flag__c FROM NP_Order__c WHERE Id = :npOrderA.Id
        ];
        System.assertEquals(dbOrderA.Customer_Number__c, customerNumber);
        System.assert(
            dbOrderA.Notify_Kasia_Flag__c != null &&
            dbOrderA.Notify_Kasia_Flag__c.trim().endsWith('NP Request Accepted, Success')
        );

        // Run the runJob and validate the result:
        // the test customer must be identified as a customer with duplicate NP in-port cases
        String result = (new clsNpCustomersWithDuplicatesImpl()).runJob();
        System.assert(result.contains(customerNumber));
    }
}