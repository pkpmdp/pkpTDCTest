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
private class EditOwnContactDataControllerSCTestClass {

    static testMethod void myUnitTest() {
        //Test.startTest();
                
        try{
            Test.startTest();
            Address__c addr = new Address__c();                                     
            addr.Town__c = 'AH'; 
            addr.Postcode__c = '421002';
            addr.Door_No__c = '301';
            //addr.Side__c = 'A';
            addr.Floor__c ='Third';
            addr.House_No__c = 'testData';
            addr.Street__c = 'AH';    
            addr.Entrance__c = 'A';        
            insert addr;
                    
            Account acc = new Account();
            acc.Name ='testData';
            acc.Street_YK__c = addr.Id;
            acc.Phone = '223223';
            acc.Email__c = 'abc@abc.com';    
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();     
            insert acc; 
            
            Contact contact = new Contact();                  
            contact.FirstName='MTest';
            contact.LastName='MTest';
            contact.email='MTest@Mtest.com';
            contact.MobilePhone='12121212';
            contact.HomePhone='154552';
            contact.Phone='2354456';
            contact.Street_P__c=addr.id;
            contact.AccountId=acc.id;
            //contact.isContactable__c=true;
            //contact.isNewsletter__c=true;
            insert contact;        
            
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDCHANGED);
            ApexPages.CurrentPage().getParameters().put('conId', contact.id);
            EditOwnContactDataController editDataObj = new EditOwnContactDataController();
           
             
            editDataObj.getContact();
            //ServiceCenterTestUtil.setContact();
            editDataObj.setContact(contact);
            editDataObj.setContactDetails();
            editDataObj.save();
            editDataObj.cancel();        
            editDataObj.fetchAddressDetails();
            
            // To handle Exception
            contact = new Contact();
            editDataObj.setContact(contact);
            editDataObj.save();
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDFAILED);
            editDataObj.setStatus();
            ApexPages.CurrentPage().getParameters().put('conId', '');
            editDataObj.setContactDetails();
            //editDataObj.verify();
        }catch (System.DmlException e){
            System.debug('Error : ' + e.getDmlMessage(0));
            Test.stopTest(); 
        }
    }
    
    static testMethod void testContact(){
        try{
            Test.startTest();
            Address__c addr = new Address__c();                                     
            addr.Town__c = 'AH'; 
            addr.Postcode__c = '421002';
            addr.Door_No__c = '301';
            //addr.Side__c = 'A';
            addr.Floor__c ='Third';
            addr.House_No__c = 'testData';
            addr.Street__c = 'AH';    
            addr.Entrance__c = 'A';        
            insert addr;
                    
            Account acc = new Account();
            acc.Name ='testData';
            acc.Street_YK__c = addr.Id;
            acc.Phone = '223223';
            acc.Email__c = 'abc@abc.com';      
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();   
            insert acc; 
            
            Contact tempcontact = new Contact();                  
            tempcontact.FirstName='MTest';
            tempcontact.LastName='MTest';
            tempcontact.email='MTest@Mtest.com';
            tempcontact.MobilePhone='12121212';
            tempcontact.HomePhone='154552';
            tempcontact.Phone='2354456';
            tempcontact.Street_P__c=addr.id;
            tempcontact.AccountId=acc.id;
            //contact.isContactable__c=true;
            //contact.isNewsletter__c=true;
            insert tempcontact;        
            
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDCHANGED);
            ApexPages.CurrentPage().getParameters().put('conId', tempcontact.id);
            EditOwnContactDataController editDataObj = new EditOwnContactDataController();
           
             
            editDataObj.getContact();
            //ServiceCenterTestUtil.setContact();
            editDataObj.setContact(tempcontact);
            editDataObj.setContactDetails();
            editDataObj.save();
            editDataObj.cancel();        
            editDataObj.fetchAddressDetails();
            
            // To handle Exception
            Contact contact = new Contact();
            //contact = new Contact();
            editDataObj.setContact(contact);
            editDataObj.save();
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDFAILED);
            editDataObj.setStatus();
            ApexPages.CurrentPage().getParameters().put('conId', '');
            editDataObj.setContactDetails();
            //editDataObj.verify();
        }catch (System.DmlException e){
            System.debug('Error : ' + e.getDmlMessage(0));
            Test.stopTest(); 
            //System.Test.stopTest();  
        }
    }
    
    static testMethod void testMessage(){
        try{
            Test.startTest();
            Address__c addr1 = new Address__c();                                     
            addr1.Town__c = 'AD'; 
            addr1.Postcode__c = '400042';
            addr1.Door_No__c = '504';
            //addr1.Side__c = 'A';
            addr1.Floor__c ='Fifth';
            addr1.House_No__c = 'testData';
            addr1.Street__c = 'AH';    
            addr1.Entrance__c = 'A';        
            insert addr1;
                    
            Account acc1 = new Account();
            acc1.Name ='testData1';
            acc1.Street_YK__c = addr1.Id;
            acc1.Phone = '2232457';
            acc1.Email__c = 'test@test.com';    
            acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();     
            insert acc1; 
            
            Contact tempcontact1 = new Contact();                  
            tempcontact1.FirstName='MyTest';
            tempcontact1.LastName='MyTest';
            tempcontact1.email='MyTest@Mytest.com';
            tempcontact1.MobilePhone='12111222';
            tempcontact1.HomePhone='158963';
            tempcontact1.Phone='2354456';
            tempcontact1.Street_P__c=addr1.id;
            tempcontact1.AccountId=acc1.id;
            //contact.isContactable__c=true;
            //contact.isNewsletter__c=true;
            insert tempcontact1;        
            
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDCHANGED);
            ApexPages.CurrentPage().getParameters().put('conId', tempcontact1.id);
            EditOwnContactDataController editDataObj = new EditOwnContactDataController();
           
             
            editDataObj.getContact();
            //ServiceCenterTestUtil.setContact();
            editDataObj.setContact(tempcontact1);
            editDataObj.setContactDetails();
            editDataObj.save();
            editDataObj.cancel();        
            editDataObj.fetchAddressDetails();
            
            // To handle Exception
            Contact contact1 = new Contact();
            //contact = new Contact();
            editDataObj.setContact(contact1);
            editDataObj.save();
            apexpages.currentpage().getparameters().put(contactConstClass.STATUS, contactConstClass.PASSWORDFAILED);
            editDataObj.setStatus();
            ApexPages.CurrentPage().getParameters().put('conId', '');
            editDataObj.setContactDetails();
            List<Contact> existContact = new List<Contact>();
            system.debug('$Before Checking contact$'+existContact+'$TempContact1$'+tempContact1);
            if(tempcontact1.Email != null){
                system.debug('$Email$'+tempcontact1.Email);
                existContact = [Select c.Phone, c.Name, c.MobilePhone, c.Id, c.HomePhone, c.HierarchyAccount__c, c.Email, c.AccountId,c.IsPersonAccount From Contact c where c.Email =: tempcontact1.email AND c.IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
                System.debug('editcontactcontroller---chkContactExists --->'+existContact);
   
            }
                system.debug('$End$');
            if(existContact != null && existContact.size() > 0 ){
                system.debug('$IN$');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_MinProfilPageMsg);
                ApexPages.addMessage(errorMsg);
                system.debug('$OUT$');
            }
                
            //editDataObj.verify();
        }catch (System.DmlException e){
            System.debug('Error : ' + e.getDmlMessage(0));
            Test.stopTest(); 
            //System.Test.stopTest();  
        }
    }
}