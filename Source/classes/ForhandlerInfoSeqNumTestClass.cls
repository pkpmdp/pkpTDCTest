@isTest
private class ForhandlerInfoSeqNumTestClass{  

    static testMethod void testCreateRecord(){
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;                
    } 
   
     static testMethod void testAppendToLast(){                               
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
         ForhandlerInformations__c forhandlerInformation4 = new ForhandlerInformations__c();   
        forhandlerInformation4.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation4.Page_Type__c = 'Bestil Varer';
        forhandlerInformation4.Group_Information__c = 'Godkend Page';
        forhandlerInformation4.SubGroup_Information__c = 'Top';
        forhandlerInformation4.Sequence_Number__c = 4;
        insert forhandlerInformation4;                          
     }
     
     static testMethod void testCreateInBetween(){                            
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
         ForhandlerInformations__c forhandlerInformation4 = new ForhandlerInformations__c();   
        forhandlerInformation4.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation4.Page_Type__c = 'Bestil Varer';
        forhandlerInformation4.Group_Information__c = 'Godkend Page';
        forhandlerInformation4.SubGroup_Information__c = 'Top';
        forhandlerInformation4.Sequence_Number__c = 2;
        insert forhandlerInformation4;                            
     }
     
     static testMethod void testDeleteInBetween(){                            
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
        delete forhandlerInformation2;                                           
     }
     
     static testMethod void testDeleteFirst(){                            
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
        delete forhandlerInformation1;                                           
     }
     
     static testMethod void testDeleteLast(){                             
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
        delete forhandlerInformation3;                                           
     }
     
     static testMethod void testUpdateSeqToLower(){
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        forhandlerInformation2.Sequence_Number__c = 1;
        upsert forhandlerInformation2;
     }
     
     static testMethod void testUpdateSeqToGreater(){
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer1';
        forhandlerInformation1.Page_Type__c = 'Bestil Varer';
        forhandlerInformation1.Group_Information__c = 'Godkend Page';
        forhandlerInformation1.SubGroup_Information__c = 'Top';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
        
        ForhandlerInformations__c forhandlerInformation2 = new ForhandlerInformations__c();   
        forhandlerInformation2.Description__c = 'Test for Bestil Varer2';
        forhandlerInformation2.Page_Type__c = 'Bestil Varer';
        forhandlerInformation2.Group_Information__c = 'Godkend Page';
        forhandlerInformation2.SubGroup_Information__c = 'Top';
        forhandlerInformation2.Sequence_Number__c = 2;
        insert forhandlerInformation2;
        
        ForhandlerInformations__c forhandlerInformation3 = new ForhandlerInformations__c();   
        forhandlerInformation3.Description__c = 'Test for Bestil Varer3';
        forhandlerInformation3.Page_Type__c = 'Bestil Varer';
        forhandlerInformation3.Group_Information__c = 'Godkend Page';
        forhandlerInformation3.SubGroup_Information__c = 'Top';
        forhandlerInformation3.Sequence_Number__c = 3;
        insert forhandlerInformation3;
        
        commonClass.isRecursiveTrigger=false;
        
        forhandlerInformation1.Sequence_Number__c = 2;
        upsert forhandlerInformation1;
     }

  }