@isTest
private class LoginTriggerTestClass{  

    static testMethod void testCreateRecord(){
        ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer';
        forhandlerInformation1.Page_Type__c = 'Login Page';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
    } 
   
     static testMethod void testUpdate(){                            
       ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer';
        forhandlerInformation1.Page_Type__c = 'Login Page';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;

        forhandlerInformation1.Sequence_Number__c = 2;
        update forhandlerInformation1;
         
              
     }
     
     static testMethod void testDeleteInBetween(){                            
       ForhandlerInformations__c forhandlerInformation1 = new ForhandlerInformations__c();   
        forhandlerInformation1.Description__c = 'Test for Bestil Varer';
        forhandlerInformation1.Page_Type__c = 'Login Page';
        forhandlerInformation1.Sequence_Number__c = 1;
        insert forhandlerInformation1;
               
        delete forhandlerInformation1;                                           
     }
 
     
  }