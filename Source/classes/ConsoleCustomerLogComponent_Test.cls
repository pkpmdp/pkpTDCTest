@isTest(SeeAllData=true)
private class ConsoleCustomerLogComponent_Test {

    static testMethod void testMethodConsoleCustomerLogComponent_Test() {
        
        RecordType objRec = [Select id,Name from RecordType where Name = 'YK Customer Account'];
        
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        system.debug('CustomerNumberSeq__c----->'+custSeq);
        
        PageReference pageRef = Page.CasesUpdateKundenr;
        Test.setCurrentPage(pageRef);
        
        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c(Name = 'Andelsboligforening1',Code__c = 'ANMC',
        											SourceId__c = 'ABCDE');
        insert objLookUp;
        
        Account objAccount = new Account(RecordTypeId = objRec.Id,Lastname = 'Test Console Account',FirstName = 'Test First Name',
        								Status_YK__c = 'Active',Customer_Segment_Lookup__c = objLookUp.id,Customer_No__c = '123456789');
        
        insert objAccount;
       
       	Customer_Log__c objLog = new Customer_Log__c();
       	objLog.Text__c = 'Test Customer Log Description';
       	objLog.Customer__c = objAccount.id;
       	insert objLog;
       	
       	Customer_Log__c objLog1 = new Customer_Log__c();
       	objLog1.Text__c = 'Test Customer Log Description1';
       	objLog1.Customer__c = objAccount.id;
       	insert objLog1;
       	
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ConsoleCustomerLogComponent_CT objConsoleCustLog = new ConsoleCustomerLogComponent_CT(sc);
        
        objConsoleCustLog.AccStrIdforLog = objAccount.id;
        objConsoleCustLog.invoke();
        ConsoleCustomerLogComponent_CT ct = new ConsoleCustomerLogComponent_CT();
        Test.stopTest();
    }
}