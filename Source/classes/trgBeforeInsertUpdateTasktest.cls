@isTest
private class trgBeforeInsertUpdateTasktest{

    public static testMethod void Test(){
        // To avoid 'Attempt to de-reference a null object' error
        // in tgrContactBeforeInsert and trgBeforeInsertUpdateTask
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        if (ysRecords == null) {
            ysRecords = new YSRecordTypes__c(Name='YSRecordTypes');
            ysRecords.YS_Contact_Record_Type__c = '012M0000000Clg3';
            ysRecords.YS_Opgave_Task_Record_Type__c='01220000000TyI9AAK';
            insert ysRecords;
        }
        //Task obj = new Task(subject='Testtask');
        //Task obj2 = new Task(subject='Testtask2');
        //insert obj;
        //insert obj2;
        
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
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject = 'Opfølgning';
        t.Objective__c = 'Weasel Exception';
        
        t.ActivityDate = Date.today();
        t.WhoId = cnt.Id;
        t.Subject = 'Opfølgning';
        t.Type = clsCasesNpHandlerController.TASK_TYPE;
        t.Priority = clsCasesNpHandlerController.TASK_PRIORITY;
        t.RecordTypeId= ysRecords.YS_Opgave_Task_Record_Type__c;
        insert t;


    }











}