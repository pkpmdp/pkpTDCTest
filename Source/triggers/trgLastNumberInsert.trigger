trigger trgLastNumberInsert on CustomerNumberSeq__c (before insert) {
 Integer numOfRows = [ Select count() from  CustomerNumberSeq__c ];
 If ( numOfRows > 0 ) {
     for (CustomerNumberSeq__c seq: System.Trigger.New) {
         seq.lastNumber__c.addError('Only one row in this table is permitted');
     }
 } 
}