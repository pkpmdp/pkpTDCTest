@isTest(seeAllData=true)
public class SendEmailToeTrayTest {

    static testMethod void SendEmailToeTrayTest1(){
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test 1';
        c.AccountId = acc.Id;
        c.Street_P__c = add.Id;
        c.Street_S__c = add.Id;
        c.MobilePhone = '12345678';
        insert c;
        
        Group g = [SELECT Id, Name, DeveloperName,Type, Email FROM Group WHERE DeveloperName =:SendEmail__c.getInstance('QueueName').Value__c AND Type=:'Queue'];
        Case cs = new case();
        cs.Department__c  = 'Sitel';
        cs.Product_2__c = 'Sager til eTray';
        cs.Origin = 'Phone';
        cs.ContactId = c.Id;
        cs.AccountId = acc.Id;
        cs.Subject = 'test';
        cs.Status = 'New';
        cs.OwnerId = g.Id;
        insert cs;
        
        Attachment at = new Attachment();
        at.Body = Blob.valueOf('RnJhOiBTdHJlYW1TZXJ2Z');
        at.ContentType = 'text/plain';
        at.Name='DPrint af 610 447 491 0020 1.txt';
        at.ParentId = cs.Id;
        insert at;
        Test.startTest();
        SendEmailToeTray.sendEmail(new List<case>{cs});
        
        Attachment at1 = new Attachment();
        at1.Body = Blob.valueOf('RnJhOiBTdHJlYW1TZXJ2Z');
        at1.ContentType = 'text/plain';
        at1.Name='DPrint af 610 447 491 0020 1.txt';
        at1.ParentId = cs.Id;
        insert at1;
        SendEmailToeTray.sendEmail(new List<case>{cs});
        Test.stopTest();
    }
}