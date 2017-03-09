/**
 * This class contains unit tests for validating the behavior of Apex classes and triggers
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
private with sharing class clsCasesViewAttachmentTest {
 
    private static void createUserQueue() {
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = 'YFFTEST';
        upsert uq User__c;
    }
    
    private static Address__c createAddress() {
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;    
        return add;
    }
    
    private static Account createAccount(Address__c add) {
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
        return acc;
    }
    
    private static Case createCase(Account acc, RecordType recordType) {
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Description = 'Department: YFFTEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c.RecordTypeId = recordType.Id;
        insert c;
        return c;
    }    
    
    private static EmailMessage createEmailMessage(Case c) {
        EmailMessage em = new EmailMessage();
        em.ParentId = c.Id;
        em.FromAddress = 'customer@question.com';
        em.ToAddress = 'agent@support.com';
        em.Subject = 'Complaint Letter';
        em.TextBody = 'Department: YFFTEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        em.Incoming = true;
        insert em;    
        return em;
    }
    
    private static void createEmailMessageAttachment(EmailMessage em, String contentType) {
        Attachment att = new Attachment();
        att.Name = 'Email Attachment';
        att.ParentId = em.Id;
        att.Body = EncodingUtil.base64decode('Some text');
        att.ContentType = contentType;
        insert att;    
    }
    
    private static void createCaseAttachment(Case cs, String contentType) {
        Attachment att = new Attachment();
        att.Name = 'Case Attachment';
        att.ParentId = cs.Id;
        att.Body = EncodingUtil.base64decode('Some text Some text Some text Some text Some text Some text Some text Some text Some text');
        att.ContentType = contentType;
        insert att;            
    }
    
 
    static testMethod void testCasesViewAttachment1() {               
    /** EmailMessage for Case                               - yes
     *  Attachment (content type supported) in EmailMessage - yes
     *  Attachment in Case                                  - no     
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        EmailMessage emailMsg = createEmailMessage(cs);
        createEmailMessageAttachment(emailMsg, 'text/plain');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(true, controller.getRender());
        System.assertEquals(false, controller.getRenderLink());
        System.assertEquals(false, controller.getRenderMoreThanOneF());               

        // KH : Added to test trigger EmailMessageBeforeDelete
        try {
        delete emailMsg;
        } catch (Exception e) {
            System.debug ('Cannot Delete EmailMessage ' + e.getMessage());      
        }
    }

    static testMethod void testCasesViewAttachment2() {               
    /** EmailMessage for Case                                         - yes
     *  Multiple attachments (content type supported) in EmailMessage - yes
     *  Attachment in Case                                            - no     
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        EmailMessage emailMsg = createEmailMessage(cs);
        createEmailMessageAttachment(emailMsg, 'text/plain');
        createEmailMessageAttachment(emailMsg, 'text/plain');
                
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(true, controller.getRender());
        System.assertEquals(false, controller.getRenderLink());
        System.assertEquals(true, controller.getRenderMoreThanOneF());               
    }  
    
    static testMethod void testCasesViewAttachment3() {               
    /** EmailMessage for Case                                         - no
     *  Single attachment (content type supported) in Case            - yes
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        createCaseAttachment(cs, 'text/plain');
                
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(true, controller.getRender());
        System.assertEquals(false, controller.getRenderLink());
        System.assertEquals(false, controller.getRenderMoreThanOneF());               
    }        
    
    static testMethod void testCasesViewAttachment4() {               
    /** EmailMessage for Case                                         - no
     *  Multiple attachments (content type supported) in Case         - yes
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        createCaseAttachment(cs, 'text/plain');
        createCaseAttachment(cs, 'text/plain');
                
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(true, controller.getRender());
        System.assertEquals(false, controller.getRenderLink());
        System.assertEquals(true, controller.getRenderMoreThanOneF());               
    }     
    
    static testMethod void testCasesViewAttachment5() {               
    /** EmailMessage for Case                                         - yes
     *  Attachment for email                                          - yes
     *  Multiple attachments (content type supported) in Case         - yes
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        EmailMessage emailMsg = createEmailMessage(cs);
        createEmailMessageAttachment(emailMsg, 'text/plain');                
        createCaseAttachment(cs, 'text/plain');
        createCaseAttachment(cs, 'text/plain');
                
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(true, controller.getRender());
        System.assertEquals(false, controller.getRenderLink());
        System.assertEquals(true, controller.getRenderMoreThanOneF());               
    }
    
    static testMethod void testCasesViewAttachment6() {               
    /** EmailMessage for Case                                         - no
     *  Single attachment (content type supported) in Case            - yes
     *  Unsupported content type  
     */
    
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
 
        createUserQueue();
        Address__c address    = createAddress();
        Account account       = createAccount(address);
        Case cs               = createCase(account,recordType);
        createCaseAttachment(cs, 'xxx');
                
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        clsCasesViewAttachment controller = new clsCasesViewAttachment(sc);
                                
        System.assertNotEquals(null, controller.getAttachment());
        System.assertEquals(false, controller.getRender());
        System.assertEquals(true, controller.getRenderLink());
        System.assertEquals(false, controller.getRenderMoreThanOneF());               
    }                      
    
}