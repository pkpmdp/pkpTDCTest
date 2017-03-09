@isTest
private class tgrTaskBefDeletetest{
    @testSetup static void testData() {
        //Inserting custom settings
        AdminProfiles__c sysadmin =new AdminProfiles__c();
        sysadmin.name='SystemAdminstraor';
        sysadmin.StringId__c='00e20000000v9G1AAI';
        insert(sysadmin);
        AdminProfiles__c youseeadmn=new AdminProfiles__c();
        youseeadmn.name='YouseeSystemAdministrator';
        youseeadmn.StringId__c='00e20000001UQpwAAG';
        insert(youseeadmn);
        // To avoid 'Attempt to de-reference a null object' error
        // in tgrContactBeforeInsert and trgBeforeInsertUpdateTask
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        if (ysRecords == null) {
            ysRecords = new YSRecordTypes__c(Name='YSRecordTypes');
            ysRecords.YS_Contact_Record_Type__c = '012M0000000Clg3';
            insert ysRecords;
        }
        Task obj = new Task(subject='Testtask');
        Task obj2 = new Task(subject='Testtask2');
        insert obj;
        insert obj2;
    }

    public static testMethod void Test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User();
        u = new User(alias = 'Tasktnnk', email='testttaskClastUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Tasklass', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles', username='testtasktrigguser@test.com',MID__c = 'M86868');
        System.runAs(u){
            Test.startTest();
            List<Task> Tasklst= [Select subject,isdeleted from Task where subject='Testtask'];
            System.debug('Task obj to be deleted '+Tasklst );
            System.debug('Task obj to be deleted isdeleted '+Tasklst[0].isdeleted );
            Delete Tasklst;
            Test.stopTest();
        }
        List<Task> Taskvrfy= [Select isdeleted from Task where subject='Testtask' ALL ROWS]; 
        System.assertEquals(Taskvrfy[0].isdeleted,true);
        System.debug('Is deleted true' + Taskvrfy[0].isdeleted);
    } 
    
    public static testMethod void Testnonadmin(){
    try{
        //Task obj3 = new Task(subject='Testtask3');
        //insert obj3;
        Profile p = [SELECT Id FROM Profile WHERE Name='YouSee SAY User'];
        System.debug('profile id' + p.id);
        User u = new User();
        u = new User(alias = 'Tssktnnk', email='ttstttaskClastUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Tssklass', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles', username='testtssktrigguser@test.com',MID__c = 'M88868');
        insert u;
        Test.startTest();
        System.runAs(u){
            Task obj3 = new Task(subject='Testtask3');
            insert obj3;
            List<Task> Tasklst= [Select subject from Task where id= :obj3.id];
            System.debug('Task obj to be deleted '+Tasklst );
            Delete Tasklst;
            Test.stopTest();
        }
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.Delete_Task_Error)? true : false;
            System.debug('Inside exception message'+ e.getMessage() );
            //System.AssertEquals(expectedExceptionThrown, true);
        }
        
    }
}