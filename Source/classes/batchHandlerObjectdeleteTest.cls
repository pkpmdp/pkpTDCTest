@isTest(SeeAllData=true)
private class batchHandlerObjectdeleteTest {
    
     public static testMethod void Test() { 

        /*Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Complaint Letter ' ;
        insert c;
        
        Handler__c handler = new Handler__c();
        handler.Case__c = c.Id;
        handler.CreatedDate= date.newinstance(2001,12,12);
        insert handler; */

        /*Test.startTest();
        batchHandlerObjectdelete obj = new batchHandlerObjectdelete();
        Database.executeBatch(obj);
        Test.stopTest();
        
        List<Handler__c > lst = [SELECT Id,CreatedDate FROM Handler__c WHERE CreatedDate < N_DAYS_AGO:395];
        System.assertEquals(lst.size(), 0); */
        
        /*String caseJSON = '{"attributes":{"type":"Case","url":"/services/data/v25.0/sobjects/Case/500M0000004srFoIAI"},"Id":"500M0000004srFoIAI","Status":"Open"}'; 
        Case c = (Case) JSON.deserialize(caseJSON, Case.class ); 
        System.debug('Test case:' + c.createdDate); 
        System.debug('Test caseId:' + c.Id); 
        System.debug('Test caseStatus:' + c.status); 
        update c;*/ 
        /*Case c1 = new Case(); 
        c1.Id = c.Id; 
        c1.status = 'New'; 
        update c1; 
         
        System.debug('Test caseStatus1:' + c1.status); */
        /*System.debug('Test case1 createddate' + c.createdDate) ;
        
        String handleJSON = '{"attributes":{"type":"Handler__c","url":"/services/data/v25.0/sobjects/Handler__c/a17M000000341olIAA"},"Case__c":"500M0000004srFoIAI","CreatedDate":"1999-01-01T17:54:26.000+0000","Id":"a17M000000341olIAA"}'; 
        Handler__c handle = (Handler__c) JSON.deserialize(handleJSON , Handler__c.class );
        System.debug('Test handle:' + handle.createdDate); 
        System.debug('Test handleId:' + handle.Id);
        
        //insert handle;
        
        Handler__c handle1= new Handler__c ();
        handle1.Id=handle.Id;
        update handle1;
        
        System.debug('Test handle:' +handle.createdDate );*/
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User();
        u = new User(alias = 'standtn', email='testClassUsenr@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawlan', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='tesbatchnClassUser@test.com',MID__c = 'M87600');
            
        System.runAs(u){
        List<Handler__c > lstbef = [SELECT CreatedDate,Id FROM Handler__c WHERE CreatedDate < N_DAYS_AGO:395 order by CreatedDate Limit 1 ];
        System.debug('Before test' + lstbef);
        Test.startTest();
        batchHandlerObjectdelete obj = new batchHandlerObjectdelete();
        Database.executeBatch(obj);
        Test.stopTest();
        
        List<Handler__c > lst = [SELECT CreatedDate,Id FROM Handler__c WHERE CreatedDate < N_DAYS_AGO:395 order by CreatedDate Limit 1 ];
        //System.debug('lst result' +lst[0].createdDate);
        System.debug('Querry result' + lst);
        //System.assertEquals(lst.size(), 0);
        if(lstbef != null && lst != null  ){
        System.assertNotEquals(lstbef[0].Id,lst[0].Id);
        }
        
        }

        }
}