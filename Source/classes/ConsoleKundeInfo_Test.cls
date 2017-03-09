@isTest(SeeAllData=true)
private class ConsoleKundeInfo_Test {

    static testMethod void testMethodConsoleKundeInfo_Test() {
       
        RecordType objRec = [Select id,Name from RecordType where Name = 'YK Customer Account'];
        
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        system.debug('CustomerNumberSeq__c----->'+custSeq);
        
        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c(Name = 'Andelsboligforening1',Code__c = 'ANMC',
        											SourceId__c = 'ABCDE');
        insert objLookUp;
        
        Account objAccount = new Account(RecordTypeId = objRec.Id,Lastname = 'Test Console Account',FirstName = 'Test First Name',
        								Status_YK__c = 'Active',Customer_Segment_Lookup__c = objLookUp.id,Customer_No__c = '123456789');
        
        insert objAccount;
       
        Test.startTest();
        ConsoleKundeInfo_CT objConsoleKundeInfo_CT = new ConsoleKundeInfo_CT();
        objConsoleKundeInfo_CT.currentId1 = objAccount.id;
        objConsoleKundeInfo_CT.getaccList();
         objConsoleKundeInfo_CT.getaccListSitel();
        Test.stopTest();
    }
}