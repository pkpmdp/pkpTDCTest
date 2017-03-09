@isTest
private class clsPermissionCheckTest {

    // Tests the creation of new PermissionCheck records for updated Accounts
    static testMethod void testPermissionCheckUpdatedAccount() {
        // To avoid: List has no rows for assignment to SObject Trigger.tgrNewCustomer: line 20
        // Inspiration: clstgrNewCustomerTest Apex class
        List<CustomerNumberSeq__c> custSeqList = [SELECT lastNumber__c FROM CustomerNumberSeq__c];
        if (custSeqList.size() < 1) {
            CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
            custSeq.lastNumber__c = clstgrNewCustomerTest.TESTNUM;
            insert custSeq;
        }

        // Create test Accounts (Permission = False)
        Id personAccountRecordTypeId = [
            SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'
        ].Id;
        List<Account> accs = new List<Account>();
        Account acc1 = new Account(FirstName='John_01', LastName='Doe_01');
        acc1.RecordTypeId = personAccountRecordTypeId;
        accs.add(acc1);
        Account acc2 = new Account(FirstName='John_02', LastName='Doe_02');
        acc2.RecordTypeId = personAccountRecordTypeId;
        accs.add(acc2);
        insert accs;

        // Update mutliple Accounts (Permission = True)
        acc1.Permission__c = 'Ja';
        acc1.PersonEmail = 'john@doe.com';
        acc2.Permission__c = 'Ja';
        acc2.PersonEmail = 'john@doe.com';
        update accs;

        // Check DB
        Account dbAcc = [SELECT Permission__c, CreatedById FROM Account WHERE Id = :acc1.Id];
        List<Permission_Check__c> dbPchs = [
            SELECT Permission__c, Permission_Check_Timestamp__c, User_Id__c
            FROM Permission_Check__c WHERE Account__c = :acc1.Id ORDER BY Name DESC
        ];
        System.assert(dbPchs[0].Permission__c);
        System.assert(dbPchs[0].Permission_Check_Timestamp__c == null);
        System.assertEquals(dbPchs[0].User_Id__c, dbAcc.CreatedById);
        dbAcc = [SELECT Permission__c, CreatedById FROM Account WHERE Id = :acc2.Id];
        dbPchs = [
            SELECT Permission__c, Permission_Check_Timestamp__c, User_Id__c
            FROM Permission_Check__c WHERE Account__c = :acc2.Id ORDER BY Name DESC
        ];
        System.assert(dbPchs[0].Permission__c);
        System.assert(dbPchs[0].Permission_Check_Timestamp__c == null);
        System.assertEquals(dbPchs[0].User_Id__c, dbAcc.CreatedById);

        // Update a single Account (Permission = False)
        acc1.Permission__c = 'Nej';
        update acc1;

        // Check DB
        dbAcc = [SELECT Permission__c, CreatedById FROM Account WHERE Id = :acc1.Id];
        dbPchs = [
            SELECT Permission__c, Permission_Check_Timestamp__c, User_Id__c
            FROM Permission_Check__c WHERE Account__c = :acc1.Id ORDER BY Name DESC
        ];
        System.assert(!dbPchs[0].Permission__c);
        System.assert(dbPchs[0].Permission_Check_Timestamp__c != null);
        System.assertEquals(dbPchs[0].User_Id__c, dbAcc.CreatedById);

        // Update a single Account (Permission = True)
        acc1.Permission__c = 'Ja';
        update acc1;

        // Check DB
        dbAcc = [SELECT Permission__c, CreatedById FROM Account WHERE Id = :acc1.Id];
        dbPchs = [
            SELECT Permission__c, Permission_Check_Timestamp__c, User_Id__c
            FROM Permission_Check__c WHERE Account__c = :acc1.Id ORDER BY Name DESC
        ];
        System.assert(dbPchs[0].Permission__c);
        System.assert(dbPchs[0].Permission_Check_Timestamp__c != null);
        System.assertEquals(dbPchs[0].User_Id__c, dbAcc.CreatedById);
    }
}