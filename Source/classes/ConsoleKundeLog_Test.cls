@isTest
private class ConsoleKundeLog_Test {

    static testMethod void testMethodConsoleKundeLog_Test() {
        
        RecordType objRec = [Select id,Name from RecordType where Name = 'YK Customer Account'];
        
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        insert custSeq;
        
        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c(Name = 'Andelsboligforening1',Code__c = 'ANMC',
        											SourceId__c = 'ABCDE');
        insert objLookUp;
        
        Account objAccount = new Account(RecordTypeId = objRec.Id,LastName = 'Test Console Account',FirstName = 'Test Console FirstName',
        								Status_YK__c = 'Active',Customer_Segment_Lookup__c = objLookUp.id,Customer_No__c = '123456789');
        
        insert objAccount;
        Test.startTest();
        
        ConsoleKundeLog_CT objConsoleKundeLog_CT = new ConsoleKundeLog_CT();
        objConsoleKundeLog_CT.strNotes = 'Testing Log';
        objConsoleKundeLog_CT.currentId = objAccount.id;
        objConsoleKundeLog_CT.btnSave();
        Test.stopTest();
    }
}