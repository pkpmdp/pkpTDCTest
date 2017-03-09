global class CasesViewCustomerCasesWS{ 
    webService static Integer getTestString(ID caseId) {
        
        Case caseData = [SELECT AccountId FROM Case WHERE Id = :caseId];

        Integer relatedCasesCount = [
            SELECT COUNT() 
            FROM Case 
            Where 
                AccountId != null AND
                AccountId = :caseData.AccountId AND
                Id != :caseId
        ];
               
        return relatedCasesCount;
    }

    @isTest(SeeAllData=true)
    static void getTestStringTest() {
		Account testAccount = new Account(Name = 'Test account', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert testAccount;
        
        Case testCase1 = new Case();
        testCase1.AccountID = testAccount.Id;
        insert testCase1;
        
        System.assertEquals(CasesViewCustomerCasesWS.getTestString(testCase1.Id), 0);
        
        Case testCase2 = new Case();
        testCase2.AccountID = testAccount.Id;
        insert testCase2;
        
        System.assertEquals(CasesViewCustomerCasesWS.getTestString(testCase1.Id), 1);
    }
}