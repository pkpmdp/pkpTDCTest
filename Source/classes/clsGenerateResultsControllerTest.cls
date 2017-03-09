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
private class clsGenerateResultsControllerTest {
    
    // Test coverage for requirement to create Result records for Survey/Event/Financial Data records
    static testMethod void testGenerateResults() {
        
        PageReference pageRef = Page.GenerateResults;
        Test.setCurrentPage(pageRef);
       
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        //acc.IsPersonAccount = true;                  
        insert acc;
        // Create template record
        Template__c t = new Template__c();
        t.Name = 'December 09 Customer Satisfaction Survey';
        t.Type__c = 'Arrangement';
        t.Sub_Type__c = 'Teater';
        t.Status__c = 'Active';
        insert t;	
        Question_Repository__c qr1 = new Question_Repository__c();
        qr1.Question__c = 'On a scale of 1-10 how satisfied are you with the customer service you recieve from YouSee?';
        insert qr1; 
        Question_Repository__c qr2 = new Question_Repository__c();
        qr2.Question__c = 'Would you recommend YouSee products to friends and family?';
        insert qr2; 
        Question_Repository__c qr3 = new Question_Repository__c();
        qr3.Question__c = 'How satisfied would you say you are?';
        insert qr3; 
        Question_Repository__c qr4 = new Question_Repository__c();
        qr4.Question__c = 'Which area would you say YouSee could improve on?';
        insert qr4; 
        Template_Question__c tq1 = new Template_Question__c();
        tq1.Survey_Template__c = t.Id;        
        tq1.Question_Repository__c = qr1.Id;
        tq1.Flow_Order__c = 1;
        insert tq1;
        Template_Question__c tq2 = new Template_Question__c();
        tq2.Survey_Template__c = t.Id;
        tq2.Question_Repository__c = qr2.Id;
        tq2.Flow_Order__c = 2;
        insert tq2;
        Template_Question__c tq3 = new Template_Question__c();
        tq3.Survey_Template__c = t.Id;
        tq3.Question_Repository__c = qr3.Id;
        tq3.Flow_Order__c = 3;
        insert tq3;
        Template_Question__c tq4 = new Template_Question__c();
        tq4.Survey_Template__c = t.Id;
        tq4.Question_Repository__c = qr4.Id;
        tq4.Flow_Order__c = 4;
        insert tq4;
        Survey_Event_Financial_Data__c sefd = new Survey_Event_Financial_Data__c();
        sefd.Template__c = t.Id;
        sefd.Customer__c = acc.Id;
        insert sefd;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sefd);
        clsGenerateResultsController controller = new clsGenerateResultsController(sc);
        
        controller.generateResults();
        
        List<Result__c> results = [Select Id From Result__c Where Survey_Event_Financial_Data__c = :sefd.Id];
        System.assertEquals(results.size(), 4);
    }
}