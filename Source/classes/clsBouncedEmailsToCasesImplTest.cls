@isTest
/**
 * A test class for clsBouncedEmailsToCasesImpl.
 */
private class clsBouncedEmailsToCasesImplTest {
    public static testMethod void testAll() {
    	
    	YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
        // Prepare 2 Accounts
        // First initialize Custom Settings
        List<CustomerNumberSeq__c> custSeqs = [SELECT lastNumber__c FROM  CustomerNumberSeq__c];
        if (custSeqs.size() < 1) {
            CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c(lastNumber__c=60000000);
            insert custSeq;
        }
        Account accF = new Account(FirstName='John', LastName='Fuldmagt');
        accF.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        accF.PersonEmail = 'banana@banana.net';
        insert accF;

        Account dbAcc = [SELECT PersonEmailBouncedDate, PersonEmailBouncedReason FROM Account WHERE Id = :accF.Id];
        System.assertEquals(dbAcc.PersonEmailBouncedDate, null);
        System.assertEquals(dbAcc.PersonEmailBouncedReason, null);

        // Simulate a bounced email notification (Bounced FM)
        Datetime dt = Datetime.now();
        accF.PersonEmailBouncedDate = dt;
        accF.PersonEmailBouncedReason = 'A reason';
        update accF;

        dbAcc = [SELECT PersonEmailBouncedDate, PersonEmailBouncedReason FROM Account WHERE Id = :accF.Id];
        System.assert(dbAcc.PersonEmailBouncedDate != null);
        System.assert(dbAcc.PersonEmailBouncedReason != null);

        // 'Fuldmagt' Account needs an NP Case waiting for the authorization
        NP_Order__c npo = new NP_Order__c();
        npo.Status__c = 'NP Request Confirmation';
        insert npo;
        Case aCase = new Case();
        aCase.NP_Order__c = npo.Id;
        aCase.AccountId = accF.Id;
        insert aCase;
        
        Account accV = new Account(FirstName='John', LastName='Visitering');
        accV.RecordTypeId = accF.RecordTypeId;
        accV.PersonEmail = 'banana@banana.net';
        insert accV;

        dbAcc = [SELECT PersonEmailBouncedDate, PersonEmailBouncedReason FROM Account WHERE Id = :accV.Id];
        System.assertEquals(dbAcc.PersonEmailBouncedDate, null);
        System.assertEquals(dbAcc.PersonEmailBouncedReason, null);

        // Simulate a bounced email notification (YKRB Vistering)
        accV.PersonEmailBouncedDate = dt;
        accV.PersonEmailBouncedReason = 'A reason';
        update accV;

        dbAcc = [SELECT PersonEmailBouncedDate, PersonEmailBouncedReason FROM Account WHERE Id = :accV.Id];
        System.assert(dbAcc.PersonEmailBouncedDate != null);
        System.assert(dbAcc.PersonEmailBouncedReason != null);

        // Look up both Groups
        Group fGroup = [SELECT Id FROM Group WHERE Name = 'YKRB Telefoni Bounced FM' AND Type = 'Queue'];
        System.assert(fGroup != null);
        Group vGroup = [SELECT Id FROM Group WHERE Name = 'YKRB Visitering' AND Type = 'Queue'];
        System.assert(vGroup != null);

        // Run the runJob and validate the result:
        Test.startTest();
        (new clsBouncedEmailsToCasesImpl()).runJob();
        Test.stopTest();
        // New 'Bounced FM' and 'YKRB Vistering' Cases should have been created
        Boolean caseCreated = false;
        List<Case> dbCases = [
            SELECT Description FROM Case
            WHERE Department__c = 'YKRB' AND Product_2__c = 'Telephony YKRB' AND Type_Task__c = 'Bounced FM' AND
                CreatedDate >= :dt AND Subject = 'Fuldmagt Returneret' AND OwnerId = :fGroup.Id
        ];
        for (Case c : dbCases) {
            if (c.Description.contains(accF.Id)) {
                caseCreated = true;
                break;
            }
        }
        //System.assert(caseCreated, 'The expected \'Bounced FM\' Case was not created!');
        caseCreated = false;
        dbCases = [
            SELECT Description FROM Case
            WHERE Department__c = 'YKRB' AND Product_2__c = 'Visitering' AND
                CreatedDate >= :dt AND Subject = 'Returneret e-mail - til behandling' AND OwnerId = :vGroup.Id
        ];
        for (Case c : dbCases) {
            if (c.Description.contains(accV.Id)) {
                caseCreated = true;
                break;
            }
        }
        System.assert(caseCreated, 'The expected \'YKRB Visitering\' Case was not created!');
    }
}