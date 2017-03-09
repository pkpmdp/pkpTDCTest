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
private class clsTransferCaseControllerTest {
        public static final String ATT_NAME_1 = 'TestAttachment1';
        public static final String ATT_NAME_2 = 'TestAttachment2';
        
         
        static testMethod void sendEmailTest() {
            Test.startTest();

            //Account customer = new Account(FirstName = 'John', LastName = 'Doe', PersonEmail='madu@tdc.dk', RecordTypeId='012200000000o09AAA');
            Account customer = new Account(FirstName = 'John', LastName = 'Doe', RecordTypeId='012200000000o09AAA');
            insert customer;
            
            Case testCase = new Case(Department__c = 'CCE', Product_2__c = 'DigiTV CCE', Type_Task__c = 'Tilmelding', Status = 'New', Account=customer, AccountId=customer.Id);
            insert testCase;
            
            Attachment att1 = new Attachment(Name=ATT_NAME_1,Body=Blob.valueOf('123'),ParentId=testCase.Id);
            Attachment att2 = new Attachment(Name=ATT_NAME_2,Body=Blob.valueOf('abcdefgh\n'),ParentId=testCase.Id); 
            insert new Attachment[]{att1,att2}; 
             
            PageReference pageRef = Page.TransferCase;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', testCase.id);
            ApexPages.currentPage().getParameters().put('retUrl', '%2F'+testCase.id);
            
            clsTransferCaseController c = new clsTransferCaseController();        
            c.initialise();

            List<Attachment> atts = c.attachments;
            System.assert(atts!=null);
            System.assertEquals(2,atts.size());

            //delete one attachment
            ApexPages.currentPage().getParameters().put('attId', att2.id);
            c.delAtt();
            System.assertEquals(1,c.attachments.size());

            //send email with all addresses empty
            c.bcc='';
            PageReference result = c.sendEmail();
            System.assertEquals(null,result);

            //white space
            c.to=' ';
            result = c.sendEmail();
            System.assertEquals(null,result);

            //invalid email
            c.to='aaa';
            result = c.sendEmail();
            System.assertEquals(null,result);

            //valid email
            c.to='madu@tdc.dk,madu@yousee.dk';
            result = c.sendEmail();
            System.assert(result != null);

            result = c.cancel();
            System.assert(result != null);
            
            Test.stopTest();
        }
}