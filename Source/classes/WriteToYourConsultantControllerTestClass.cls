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
private class WriteToYourConsultantControllerTestClass {

    public static Account acc;
       
    	public static User u;
        static testMethod void Test1() {
                Boolean pageFlag = false;
                Boolean sendCopy = true;
                Address__c add = new Address__c();
                add.Active__c= true;
                add.District__c ='test';
                add.Door_No__c ='1';
                add.Entrance__c = 'ABC';
                add.Floor__c = '4';
                add.House_No__c ='34';
                add.Name = 'test1';
                add.Town__c = 'ABS';
                add.Postcode__c = '4000076';
                add.Street__c='ordrupVej';
               // add.Side__c='TV';
                insert add;
                 
                RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
            
                Account acct = new Account(Name='Simferna');
            	acct.Street_YK__c = add.Id;
                acct.RecordTypeId = recordType.Id;
                insert acct;
            
                ID ProID = [ Select id from Profile where name = 'Customer Portal Manager Custom'].id;
                Contact  C2 = new Contact(AccountID = acct.Id, FirstName = 'Test', LastName = 'User', Street_P__c = add.Id, Description = 'For Testing Purpose', Email = 'test_user@test.com', Phone = '22222', MobilePhone = '9870214578', HomePhone = '124578', AlternateEmail__c = 'test_user1@test.com');
                insert C2;
                User u1 = new User( email='test-user@fakeemail.com', contactid = C2.id, profileid = ProID,
                                 UserName='test-user@fakeemail.com', alias='tuser1', 
                                 CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                                 EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test', 
                                 LastName = 'User',MID__c = 'M87268');
                                 
                System.runAs(u1){
                Test.startTest();   
                PageReference pageRef = Page.WriteToYourConsultant;
                Test.setCurrentPage(pageRef);
                Apexpages.currentpage().getHeaders().put('Host','c.cs7.visual.force.com');
                Apexpages.currentpage().getparameters().put('previousPage','/apex/ViewAgreementsPage');
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','test@gmail.com');
                ApexPages.currentPage().getParameters().put('accid',acct.id);  
                WriteToYourConsultantController.TEST_MODE = true;
                
                WriteToYourConsultantController controller = new WriteToYourConsultantController();
                controller.tempFlag = true;
                //controller.TEST_MODE1 = true;
                
                controller.getContactDetail();
                controller.returnToAgreement();
                controller.getMailDescription();
                controller.getSendCopy(); 
                controller.getEditProfile();
                controller.getPageFlag();
                
                controller.setPageFlag(false);
                controller.backToContactPersonPage();
                controller.setPageFlag(true);
                controller.setMailDescription('asjdfkdsf');
                controller.setSendCopy(true);
                controller.setEditProfile(true); 
                controller.setPageFlag(true);
                WriteToYourConsultantController.TEST_MODE1 = true;   
                controller.setSendCopy(false);
                controller.sendCopy = true;
                controller.retURL = Apexpages.currentpage().getHeaders().get('Host');
                controller.sendMail();
             
             	controller.sendCopy = false;
                controller.retURL = Apexpages.currentpage().getHeaders().get('Host');
                controller.sendMail();
                
                controller.sendCopy = true;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','');
                controller.retURL = Apexpages.currentpage().getHeaders().get('Host');
                controller.sendMail();
                
                controller.sendCopy = false;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','');
                controller.retURL = Apexpages.currentpage().getHeaders().get('Host');
                controller.sendMail();
                
                controller.sendCopy = true;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','test@gmail.com');
                String s = 'aaaaa';
                controller.retURL = s;
                controller.sendMail();
                
                controller.sendCopy = false;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','test@gmail.com');
                String s1 = 'aaaaa';
                controller.retURL = s1;
                controller.sendMail();
                
                controller.sendCopy = true;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','');
                String s2 = 'aaaaa';
                controller.retURL = s2;
                controller.sendMail();
                
                controller.sendCopy = false;
                ApexPages.currentPage().getParameters().put('YouSeeContactEmail','');
                String s3 = 'aaaaa';
                controller.retURL = s3;
                controller.sendMail();
                
                
                acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =:acct.Id];
                    //ApexPages.currentPage().getHeaders().put('Host',('c.cs7.visual.force.com'));
 
                if(sendCopy){
                //if(controller.getSendCopy()){
                    controller.sendMail();
                }

                if(pageFlag == false){
                    PageReference backPageRef = Page.ViewAgreementsPage;
                    backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                    backPageRef.setRedirect(true);
                    Test.setCurrentPage(backPageRef);
                }
                
                String fullUrl = URL.getCurrentRequestUrl().toExternalForm();
                if(fullUrl.contains('ViewAgreementPage')){
                    controller.setPageFlag(false);
                }
                    if(!controller.getPageFlag()){
                        String newPage = '/apex/ViewAgreementsPage';
                        PageReference backPageRef = new PageReference(newPage);
                        backPageRef.getParameters().putAll(ApexPages.CurrentPage().getParameters());
                        backPageRef.setRedirect(true);
                        Test.setCurrentPage(backPageRef);
                    }   
               }
           
    } 
    
    
    
}