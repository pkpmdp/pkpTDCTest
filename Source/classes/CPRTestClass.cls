@isTest(SeeAllData=true)
private class CPRTestClass {

    static testMethod void testclassCPRStatus() {
        
        Test.startTest();
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
     	
     	Account account = new Account(); 
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        
        ApexPages.Standardcontroller obj = new ApexPages.Standardcontroller(account);
        CPR_Status objTestClass = new CPR_Status(obj);
        objTestClass.strCPRNumber = '';
        objTestClass.btnCallOutToBC();
        objTestClass.strCPRNumber = '070661-4184';
        objTestClass.btnCallOutToBC();
        objTestClass.strCPRNumber = '0706614184';
        objTestClass.btnCallOutToBC(); 
        objTestClass.strCPRNumber = '0706614184';
        objTestClass.btnCallOutToBC();
        objTestClass.strCPRNumber = '0706614';
        objTestClass.btnCallOutToBC();
        objTestClass.strCPRNumber = 'abcd';
        objTestClass.btnCallOutToBC();
        
        String resp = '{"error": {"code":"4008", "message":"An error was returned to CPR adapter method getPersonByCpr2: StatusCode 172, error description: Personen xxxxxx-xxxx findes ikke i CPR.", "stack trace":"dk.tdc.businesscore.exceptions.AdapterResultException: An error was returned to CPR adapter method getPersonByCpr2: StatusCode 172, error description: Personen 210178-2193 findes ikke i CPR.\r\n\tat dk.tdc.businesscore.integration.adapter.actors.CprAdapterActor.getPersonByCpr2(CprAdapterActor.java:73)\r\n\tat dk.tdc.businesscore.integration.adapter.api.CprAdapter$$ProxiedByAWDelegation$$1427494537670.aw$original$AW$getPersonByCpr2$AW$dk_tdc_businesscore_integration_adapter_api_CprAdapter$$ProxiedByAWDelegation$$1427494537670(Unknown Source)\r\n\tat dk.tdc.businesscore.integration.adapter.api.CprAdapter$$ProxiedByAWDelegation$$1427494537670_1_591604113_139642445__AW_JoinPoint.proceed(Unknown Source)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1$$anonfun$apply$1$$anonfun$apply$2.apply(TypedActor.scala:220)\r\n\tat scala.util.DynamicVariable.withValue(DynamicVariable.scala:57)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1$$anonfun$apply$1.apply(TypedActor.scala:217)\r\n\tat scala.util.DynamicVariable.withValue(DynamicVariable.scala:57)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1.apply(TypedActor.scala:216)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1.apply(TypedActor.scala:214)\r\n\tat akka.actor.Actor$class.apply(Actor.scala:478)\r\n\tat akka.actor.TypedActor.apply(TypedActor.scala:114)\r\n\tat akka.actor.LocalActorRef.invoke(ActorRef.scala:860)\r\n\tat akka.dispatch.MessageInvocation.invoke(MessageHandling.scala:26)\r\n\tat akka.dispatch.ExecutableMailbox$class.processMailbox(ExecutorBasedEventDrivenDispatcher.scala:214)\r\n\tat akka.dispatch.ExecutorBasedEventDrivenDispatcher$$anon$1.processMailbox(ExecutorBasedEventDrivenDispatcher.scala:129)\r\n\tat akka.dispatch.ExecutableMailbox$class.run(ExecutorBasedEventDrivenDispatcher.scala:186)\r\n\tat akka.dispatch.ExecutorBasedEventDrivenDispatcher$$anon$1.run(ExecutorBasedEventDrivenDispatcher.scala:129)\r\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)\r\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)\r\n\tat java.lang.Thread.run(Thread.java:662)\r\n\tat akka.dispatch.MonitorableThread.run(ThreadPoolBuilder.scala:181)\r\n", "request ID":"db19ce30-48c5-437a-871c-2d9f8f5ff5cb", "timestamp":"11/03-2015 11:08:32"}}';
        objTestClass.createtable(resp);
        String resp1 = '{"firstName":"Jens","lastName":"Mortensen","cprStatus":"01","locality":"","street":"Boulevarden","streetnumber":"101","houseLetter":"","floor":"01","floorside":"mf","zipCode":"6800","city":"Varde","co":"","placeName":"","streetCode":"5731","muncipality":"Varde","muncipalityCode":"573"}';
        objTestClass.createtable(resp1);
        objTestClass.btnSaveToKasia();
        objTestClass.respBodyForKasia = '"OK"';
        objTestClass.AccId = account.Id; 
        objTestClass.listCPRResp[0].NameFull = 'Test Name';
        objTestClass.btnSaveToSpoc();            
        objTestClass.btnsaveMismatchtoLog();  
        objTestClass.AccId = account.Id;
        //objTestClass.savematchdatatolog();
        objTestClass.btnCancel();
        CPR_Status.CPRResponse cpr =new CPR_Status.CPRResponse ();
        cpr.cprStatus='';
        cpr.locality='';
        cpr.co='';
        cpr.placeName='';
        cpr.streetCode='';
        cpr.muncipality='';
        cpr.muncipalityCode='';
        cpr.StreetFull='';
        cpr.HouseFull='';
        CPR_Status.errresponse err=new CPR_Status.errresponse();
        err.code ='';
        err.message='';
        err.stacktrace='';
        err.requestID ='';
        err.timestamp ='';
        objTestClass.respBodyForKasia = '"NOK"';
        objTestClass.btnSaveToSpoc();
        CPR_Status objTestClass1 = new CPR_Status();
        Test.stopTest();
    }
    
    static testMethod void testclassCPRUtil(){
        Account account = new Account(); 
         RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];                    
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        
    	CPRUtil.encryptCPR('0706614184');
        ApexPages.Standardcontroller obj = new ApexPages.Standardcontroller(account);
        CPR_Status objTestClass = new CPR_Status(obj);
        objTestClass.strCPRNumber = '0706614184';
        objTestClass.btnCallOutToBC(); 
        objTestClass.statusCode = 500;
        objTestClass.btnCallOutToBC(); 
    }
    
    static testMethod void testclassBaseConverter(){
    	BaseConverter.generateBase32Number(314111422, 32);
    	BaseConverter.stringByteToInteger('01011');
        
    }
   /* @isTest static void testCallOutCPR(){
    	// Set mock callout class 
        Test.startTest();
        netfeeinvoicesPDFBillsController objNF1 = new netfeeinvoicesPDFBillsController();
        Test.setMock(HttpCalloutMock.class, new CPRMockCallOut());	
        
        HttpResponse res = netfeeinvoicesPDFBillsController.getCPRResponse('12345',NetsFeeCallOut.GetUserMid(),'203.191.35.23',UserInfo.getUserId());
        
        // Verify response received contains fake values
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"error": {"code":"4008", "message":"An error was returned to CPR adapter method getPersonByCpr2: StatusCode 172, error description: Personen xxxxxx-xxxx findes ikke i CPR.", "stack trace":"dk.tdc.businesscore.exceptions.AdapterResultException: An error was returned to CPR adapter method getPersonByCpr2: StatusCode 172, error description: Personen 210178-2193 findes ikke i CPR.\r\n\tat dk.tdc.businesscore.integration.adapter.actors.CprAdapterActor.getPersonByCpr2(CprAdapterActor.java:73)\r\n\tat dk.tdc.businesscore.integration.adapter.api.CprAdapter$$ProxiedByAWDelegation$$1427494537670.aw$original$AW$getPersonByCpr2$AW$dk_tdc_businesscore_integration_adapter_api_CprAdapter$$ProxiedByAWDelegation$$1427494537670(Unknown Source)\r\n\tat dk.tdc.businesscore.integration.adapter.api.CprAdapter$$ProxiedByAWDelegation$$1427494537670_1_591604113_139642445__AW_JoinPoint.proceed(Unknown Source)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1$$anonfun$apply$1$$anonfun$apply$2.apply(TypedActor.scala:220)\r\n\tat scala.util.DynamicVariable.withValue(DynamicVariable.scala:57)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1$$anonfun$apply$1.apply(TypedActor.scala:217)\r\n\tat scala.util.DynamicVariable.withValue(DynamicVariable.scala:57)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1.apply(TypedActor.scala:216)\r\n\tat akka.actor.TypedActor$$anonfun$receive$1.apply(TypedActor.scala:214)\r\n\tat akka.actor.Actor$class.apply(Actor.scala:478)\r\n\tat akka.actor.TypedActor.apply(TypedActor.scala:114)\r\n\tat akka.actor.LocalActorRef.invoke(ActorRef.scala:860)\r\n\tat akka.dispatch.MessageInvocation.invoke(MessageHandling.scala:26)\r\n\tat akka.dispatch.ExecutableMailbox$class.processMailbox(ExecutorBasedEventDrivenDispatcher.scala:214)\r\n\tat akka.dispatch.ExecutorBasedEventDrivenDispatcher$$anon$1.processMailbox(ExecutorBasedEventDrivenDispatcher.scala:129)\r\n\tat akka.dispatch.ExecutableMailbox$class.run(ExecutorBasedEventDrivenDispatcher.scala:186)\r\n\tat akka.dispatch.ExecutorBasedEventDrivenDispatcher$$anon$1.run(ExecutorBasedEventDrivenDispatcher.scala:129)\r\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)\r\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)\r\n\tat java.lang.Thread.run(Thread.java:662)\r\n\tat akka.dispatch.MonitorableThread.run(ThreadPoolBuilder.scala:181)\r\n", "request ID":"db19ce30-48c5-437a-871c-2d9f8f5ff5cb", "timestamp":"11/03-2015 11:08:32"}}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(500, res.getStatusCode());
        Test.stopTest();
    }*/
    
}