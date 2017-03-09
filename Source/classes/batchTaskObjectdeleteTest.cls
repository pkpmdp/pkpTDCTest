@isTest
private class batchTaskObjectdeleteTest {

public static testMethod void Test() {
	// To avoid 'Attempt to de-reference a null object' error
    // in tgrContactBeforeInsert and trgBeforeInsertUpdateTask
    YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        if (ysRecords == null) {
            ysRecords = new YSRecordTypes__c(Name='YSRecordTypes');
            ysRecords.YS_Contact_Record_Type__c = '012M0000000Clg3';
            insert ysRecords;
        }
    //Inserting custom settings
        AdminProfiles__c sysadmin =new AdminProfiles__c();
        sysadmin.name='SystemAdminstraor';
        sysadmin.StringId__c='00e20000000v9G1AAI';
        insert(sysadmin);
        AdminProfiles__c youseeadmn=new AdminProfiles__c();
        youseeadmn.name='YouseeSystemAdministrator';
        youseeadmn.StringId__c='00e20000001UQpwAAG';
        insert(youseeadmn);
    //Inserting Task object    
        Task obj = new Task(subject='Testtask');
        insert obj;
        
	    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	    User u = new User();
	    u = new User(alias = 'stndtnnk', email='testtaskClassUser@test.com',title='kunderådgiver',emailencodingkey='UTF-8', lastname='Tasklast', languagelocalekey='en_US',            localesidkey='en_US', profileid = p.Id,            timezonesidkey='America/Los_Angeles', username='testtaskbatchuser@test.com',MID__c = 'M86666');
	    System.runAs(u){        
	    
	    List<Task> lstbef = [SELECT Id FROM Task WHERE subject='Testtask' ];
	    System.debug('Before test' + lstbef);
	    Test.startTest();
	    batchTaskObjectdelete batchobj = new batchTaskObjectdelete();        
	    Database.executeBatch(batchobj); 
	    Test.stopTest();
	
	 
	    List<Task> lst = [SELECT Id FROM Task WHERE subject='Testtask'];
		
		System.assertEquals(lst.size(),0);
 
 }
    


}
}