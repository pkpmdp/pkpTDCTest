/**
 * @Test Class: DealerWebConferenceFollowUpTest 
 * @author: Capgemini Consulting India Pvt. Ltd.
 * @version History : 1.0
 * @date: 14/02/2013
 * @description: This class contains unit tests for validating the behavior of DealerWebConferenceFollowUp Apex class.
*/
   
@isTest(SeeAllData = true)
private class DealerWebConferenceFollowUpTestClass {
   
    private static Account acc;
    private static Contact contactWithTransport1;
    private static Contact contactWithTransport2;
    private static Contact contactWithoutTransport;
    private static Contact contactAlreadyRegistered;
    static void createTestData() { 
    
    Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '5499';
        addr.Door_No__c = '301';
        //Commented for DW-720: Side__c is going to be deleted from SFDC
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name ='Forhandlerweb'];
        acc = new Account();
        acc.Name ='test127';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;       
        
         //Insert a new contact
        contactWithTransport1 = new Contact();              
        contactWithTransport1.FirstName='MTest';       
        contactWithTransport1.LastName='MTest';       
        contactWithTransport1.email='MTest@Mtest.com';       
        contactWithTransport1.Street_P__c=addr.Id;  
        contactWithTransport1.AccountId = acc.id;
        contactWithTransport1.Phone = '00000001';
        contactWithTransport1.Conference_Mobile_Phone__c = '80801111'; 
        contactWithTransport1.IsConferenceContact__c = true;
        contactWithTransport1.Stillingsbetegnelse__c='Andet';
        contactWithTransport1.Onskes_programplanen__c = true;
        contactWithTransport1.Transportation_Required__c ='Ja';
        contactWithTransport1.Valg_rute__c ='Aabenraa-Haderslev-Kolding-Nyborg';
        contactWithTransport1.Valg_opsamlingsby__c='Kolding Banegård';
        contactWithTransport1.Pickup_Time__c = 'Kl. 07.45';
        contactWithTransport1.Drop_Time__c = 'Kl. 20.15';
        insert contactWithTransport1; 
        
        contactWithTransport2 = new Contact();              
        contactWithTransport2.FirstName='MTest';       
        contactWithTransport2.LastName='MTest';       
        contactWithTransport2.email='MTest@Mtest.com';       
        contactWithTransport2.Street_P__c=addr.Id;  
        contactWithTransport2.AccountId = acc.id;
        contactWithTransport2.Phone = '00000001';
        contactWithTransport2.Conference_Mobile_Phone__c = '80804444'; 
        contactWithTransport2.IsConferenceContact__c = true;
        contactWithTransport2.Stillingsbetegnelse__c='Andet';
        contactWithTransport2.Onskes_programplanen__c = true;
        contactWithTransport2.Transportation_Required__c ='Ja';
        contactWithTransport2.Valg_rute__c ='Aabenraa-Haderslev-Kolding-Nyborg';
        contactWithTransport2.Valg_opsamlingsby__c='Kolding Banegård';
        contactWithTransport2.Pickup_Time__c = 'Kl. 07.45';
        contactWithTransport2.Drop_Time__c = 'Kl. 20.15';
        insert contactWithTransport2; 
        
        contactWithoutTransport = new Contact();              
        contactWithoutTransport.FirstName='MTest';       
        contactWithoutTransport.LastName='MTest';       
        contactWithoutTransport.email='MTest@Mtest.com';       
        contactWithoutTransport.Street_P__c=addr.Id;  
        contactWithoutTransport.AccountId = acc.id;
        contactWithoutTransport.Phone = '00000002';
        contactWithoutTransport.Conference_Mobile_Phone__c = '80802222'; 
        contactWithoutTransport.IsConferenceContact__c = true;
        contactWithoutTransport.Stillingsbetegnelse__c='Andet';
        contactWithoutTransport.Transportation_Required__c ='Nej';
        contactWithoutTransport.Onskes_programplanen__c = true;
        insert contactWithoutTransport; 
        
        contactAlreadyRegistered = new Contact();
        contactAlreadyRegistered.FirstName='MTest';       
        contactAlreadyRegistered.LastName='MTest';       
        contactAlreadyRegistered.email='MTest@Mtest.com';       
        contactAlreadyRegistered.Street_P__c=addr.Id;  
        contactAlreadyRegistered.AccountId = acc.id;
        contactAlreadyRegistered.Phone = '00000003';
        contactAlreadyRegistered.Conference_Mobile_Phone__c = '80803333'; 
        contactAlreadyRegistered.IsConferenceContact__c = true;
        contactAlreadyRegistered.Stillingsbetegnelse__c='Andet';
        contactAlreadyRegistered.Transportation_Required__c ='Nej';
        contactAlreadyRegistered.Onskes_programplanen__c = true;
        contactAlreadyRegistered.Participated_in_Conference__c = true;
        insert contactAlreadyRegistered;
      } 
      
      //Positive scnerio 
      private testMethod static void searchAndRegisterContact(){
          createTestData();
          
          // for contact with transport
          DealerWebConferenceFollowUp followUpController= new DealerWebConferenceFollowUp();
          followUpController.getRoutes();
          followUpController.mobileNumber='80801111';
          String ticketNo = [SELECT Ticket_Number__c FROM Contact WHERE Conference_Mobile_Phone__c = '80801111' LIMIT 1].Ticket_Number__c;
          followUpController.ticketNumber = ticketNo;
          followUpController.searchContact();
          followUpController.registerParticipant();
          
          // for contact without transport 
          followUpController= new DealerWebConferenceFollowUp();
          followUpController.mobileNumber='80802222';
          ticketNo = [SELECT Ticket_Number__c FROM Contact WHERE Conference_Mobile_Phone__c = '80802222' LIMIT 1].Ticket_Number__c;
          followUpController.ticketNumber = ticketNo;
          followUpController.searchContact();
          followUpController.registerParticipant();
          
          //for blank search
          followUpController= new DealerWebConferenceFollowUp();
          followUpController.searchContact();
          followUpController.registerParticipant();
          
          //for invalid search
          followUpController= new DealerWebConferenceFollowUp();
          followUpController.mobileNumber='80800000';
          followUpController.searchContact();
          followUpController.registerParticipant();
      }
      
      private testMethod static void displayNotArrivedContacts(){
      	  createTestData();
      	  
      	  DealerWebConferenceFollowUp followUpController= new DealerWebConferenceFollowUp();
      	  
      	  // for contact with transport, not arrived
      	  followUpController.pickup = 'Kolding Banegård';
      	  followUpController.displayNotArrivedList();
      	  
      	  // for contact without transport, not arrived
      	  followUpController.pickup = 'Egen Transport';
      	  followUpController.displayNotArrivedList();
      	  
      	  // for all contacts, not arrived
      	  followUpController.pickup = 'Alle';
      	  followUpController.displayNotArrivedList();
      }
      
      private testMethod static void paginationMethods(){
      	  createTestData();
      	  
      	  DealerWebConferenceFollowUp followUpController= new DealerWebConferenceFollowUp();
      	  
      	  // for contact with transport, not arrived
      	  followUpController.pickup = 'Kolding Banegård';
      	  followUpController.countType = 'notArrived';
      	  followUpController.displayNotArrivedList();
      	  followUpController.showNext();
      	  followUpController.showPrevious();
      	  followUpController.showLast();
      	  followUpController.showFirst();
      }
      
      private testMethod static void errorConditions(){
      	  DealerWebConferenceFollowUp followUpController= new DealerWebConferenceFollowUp();
      	  
      	  followUpController.mobileNumber = 'abcdef';
      	  followUpController.ticketNumber = 'abcdef';
      	  followUpController.searchContact();
      }
 }