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
@isTest(SeeAllData = true)
private class DealerWebConferenceRegisterTestClass {
	private static User u;
	private static Account acc;
	private static Contact contact;
    //static Pagereference pr;
    
	static void createTestData() { 
    
 	Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //Commented for DW-720: Side__c is going to be deleted from SFDC
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        acc = new Account();
        acc.Name ='test12';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;       
        
         //Insert a new contact
        contact = new Contact();              
        contact.FirstName='MTest';       
        contact.LastName='MTest';       
        contact.email='MTest@Mtest.com';       
        contact.MobilePhone='12234556';       
        contact.HomePhone='23455689';        
        contact.Phone='2354456';        
        contact.Street_P__c=addr.Id;  
        contact.AccountId = acc.id;    
        insert contact; 
        
        Profile p = [select id 
                      from profile 
                     where name = 'YouSee Customer Portal User' 
                     limit 1];   
        
        String testemail = 'puser000@amamama.com';
        u = new User(profileId = p.id, username = 'testemail@gmail.com', email = 'testemail@gmail.com', 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = contact.id, MID__c = 'est');
       
        System.debug('user u @@ - '+u);
        
                 
	}  
     static testMethod void AddMoreAttendees() {
     	createTestData();
     	Test.startTest();
        System.runAs(u) {         

          ApexPages.StandardController controller;                                                  
          DealerWebConferenceRegisterController confController = new DealerWebConferenceRegisterController(controller);
          confController.getForhandlerData();
          confController.getCurrentDealerDetails();
          
          // adding contact with transportation not required
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001234';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.AddMoreAttendees();
          
           // adding contact with transportation required
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001235';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.wrapCons.contact.Transportation_Required__c = 'Ja';
          confController.pickupVal = 'Nyborg Banegård';
          confController.pickupRoute = 'route1';
          confController.AddMoreAttendees();
         
          Test.stoptest();  
      }    
     	
    } 
     static testMethod void deleteRow() {
     	createTestData();
     	Test.startTest();
        System.runAs(u) {         
          
          ApexPages.StandardController controller;                                                  
          DealerWebConferenceRegisterController confController = new DealerWebConferenceRegisterController(controller);
          confController.getForhandlerData();
          
          // Delete contact with no transportation.
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001234';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.AddMoreAttendees();
    	  confController.rowsId = '0';
    	  confController.deleteRow();
    	   
    	  // Delete contact heaving transportation.
    	  confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001235';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.wrapCons.contact.Transportation_Required__c = 'Ja';
          confController.pickupVal = 'Nyborg Banegård';
          confController.pickupRoute = 'route1';
          confController.AddMoreAttendees();
    	  confController.rowsId = '0';
    	  confController.deleteRow();          
        }
    }
   
      
   static testMethod void editAndSaveWithTransport() {
     	createTestData();
     	Test.startTest();
        System.runAs(u) {         

          ApexPages.StandardController controller;                                                  
          DealerWebConferenceRegisterController confController = new DealerWebConferenceRegisterController(controller);
          confController.getForhandlerData();
          ApexPages.CurrentPage().getParameters().put('pickupVal', 'Nyborg Banegård');
          ApexPages.CurrentPage().getParameters().put('route1', 'route1');
          
           // editing contact with transportation
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001234';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.wrapCons.contact.Transportation_Required__c = 'Ja';
          confController.pickupVal = 'Nyborg Banegård';
          confController.pickupRoute = 'route1';
          confController.AddMoreAttendees();
          confController.rowsId = '0';
          confController.editRow();
          confController.editAndSave();
        
        }
    }
    
    static testMethod void cancelEdit() {
     	createTestData();
     	Test.startTest();
        System.runAs(u) {         

          ApexPages.StandardController controller;                                                  
          DealerWebConferenceRegisterController confController = new DealerWebConferenceRegisterController(controller);
          confController.getForhandlerData();
          
           // editing contact with transportation
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001234';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.wrapCons.contact.Transportation_Required__c = 'Ja';
          confController.pickupVal = 'Nyborg Banegård';
          confController.pickupRoute = 'route1';
          confController.AddMoreAttendees();
          confController.rowsId = '0';
          confController.editRow();
          confController.cancelEdit();
        
        }
    }
    static testMethod void RegisterAttendees() {
    	createTestData();
     	Test.startTest();
        System.runAs(u) {         

          ApexPages.StandardController controller;                                                  
          DealerWebConferenceRegisterController confController = new DealerWebConferenceRegisterController(controller);
          confController.getForhandlerData();
        
          
          // register contacts
          confController.wrapCons.contact.FirstName = 'mudasir';
          confController.wrapCons.contact.Conference_Mobile_Phone__c = '00001235';
          confController.wrapCons.contact.LastName = 'wani';
          confController.wrapCons.contact.Email = 'mudasir@mmm.com';
          confController.wrapCons.contact.Transportation_Required__c = 'Ja';
          confController.pickupVal = 'Nyborg Banegård';
          confController.pickupRoute = 'route1';
          confController.AddMoreAttendees();
          confController.RegisterAttendees();
          confController.sendEmail();
          confController.redirectToHome();
          
         Test.stoptest();  
      }   
    }
    
}