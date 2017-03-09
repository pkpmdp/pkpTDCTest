/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ManualOrderingDocumentSeqNumTestClass {

    static testMethod void testCreateRecord(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
    }
    
    static testMethod void testCreateInBetween(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
        
        commonClass.isRecursiveTrigger=false;
        
        ManualOrderingDocument__c manualOrderingDoc4 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc4.SequenceNumber__c = 2;
        manualOrderingDoc4.FieldType__c = 'Text';
        manualOrderingDoc4.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc4;
    }
    
    static testMethod void testDeleteInBetween(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
        
        commonClass.isRecursiveTrigger=false;
        
        delete manualOrderingDoc2;
    }
    
    static testMethod void testDeleteFirst(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
        
        commonClass.isRecursiveTrigger=false;
        
        delete manualOrderingDoc1;
    }
    
    static testMethod void testUpdateSeqToLower(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
        
        commonClass.isRecursiveTrigger=false;
        
        manualOrderingDoc2.SequenceNumber__c = 1;
        upsert manualOrderingDoc2;        
    }
    
    static testMethod void testUpdateSeqToGreater(){
        ManualOrderingDocument__c manualOrderingDoc1 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc1.SequenceNumber__c = 1;
        manualOrderingDoc1.FieldType__c = 'Text';
        manualOrderingDoc1.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc1;
        
        ManualOrderingDocument__c manualOrderingDoc2 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc2.SequenceNumber__c = 2;
        manualOrderingDoc2.FieldType__c = 'Text';
        manualOrderingDoc2.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc2;
        
        ManualOrderingDocument__c manualOrderingDoc3 = new ManualOrderingDocument__c();   
        if(manualOrderingDoc1.ManualOrderDocument__r != null) {
            manualOrderingDoc1.ManualOrderDocument__r.RecordType__c = 'Digitalt Kabel-tv';
        }
        manualOrderingDoc3.SequenceNumber__c = 3;
        manualOrderingDoc3.FieldType__c = 'Text';
        manualOrderingDoc3.Description__c = 'Kundens nuværende tv-pakke:';
        insert manualOrderingDoc3;
        
        commonClass.isRecursiveTrigger=false;
        
        manualOrderingDoc1.SequenceNumber__c = 2;
        upsert manualOrderingDoc1;        
    }
}