public class clstgrLastNumberInsertTest {
    
    public static Decimal TESTNUM = 68999998;
    
    static testMethod void getPreparedData() {
        List<CustomerNumberSeq__c> custSeqList = [ Select lastNumber__c from  CustomerNumberSeq__c ];
        CustomerNumberSeq__c custSeq; 
        custSeq = new  CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;              
        try {
            insert custSeq;
            
            custSeq = new  CustomerNumberSeq__c();
            custSeq.lastNumber__c = TESTNUM;              
            insert custSeq;
        }catch (DmlException e) {
            System.assert( e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }        
    }
}