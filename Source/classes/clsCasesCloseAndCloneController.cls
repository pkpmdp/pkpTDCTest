public with sharing class clsCasesCloseAndCloneController {
    private Case oldCase;
    private EmailMessage oldEmailMessage;
    private List<Attachment> oldAttachments;

    public clsCasesCloseAndCloneController(ApexPages.StandardController controller) {
        oldCase = [Select Id, 
            ownerId,
            AccountId, 
            recordTypeId,
            Address_old__c,
            BusinessHoursId,
            Customer_Number__c,
            Department__c,
            Description,
            Details__c,
            product_2__c,
            Type_Task__c,
            Origin,
            Subject         
        From Case Where Id = :controller.getId()];
        for (EmailMessage msg : [Select Id, FromAddress, CcAddress, BccAddress, FromName, Headers, HtmlBody, Incoming, MessageDate, ParentId, Status, Subject, TextBody, ToAddress From EmailMessage Where ParentId = :oldCase.Id And Status In ('0', '1') Order By CreatedDate DESC LIMIT 1]) {
            oldEmailMessage = msg;
        }   
        if (oldEmailMessage != null) {
            oldAttachments = new List<Attachment>();
            for (Attachment a : [Select Id, Body, ContentType, Name From Attachment Where ParentId = :oldEmailMessage.Id Order By CreatedDate ASC]) {
                oldAttachments.add(a);
            }
        }
    }
     
    public PageReference closeAndClone() {
        // Close the old case
        oldCase.Status = 'Closed';
        oldCase.Internal_Comments_Close_Reason__c = 'Closed and Cloned';
        try {
            update oldCase;
        } catch (Exception e) {
            // If save was not successful then navigate user to previous case
            ApexPages.addMessages(e);
            return null;
            //return new PageReference('/' + oldCase.Id);
        }
        // Clone the case
        Case newCase = new Case(); 
        newCase.OwnerId = oldCase.OwnerId;
        newCase.AccountId =oldCase.AccountId;
        newCase.Contact = oldCase.Contact;
        newCase.recordTypeId = oldCase.recordTypeId;
        newCase.Address_old__c = oldCase.Address_old__c;
        newCase.BusinessHoursId = oldCase.BusinessHoursId;
        newCase.Customer_Number__c = oldCase.Customer_Number__c;
        //newCase.Department__c = oldCase.Department__c;
        newCase.manual_assign__c = true;
        newCase.Description = oldCase.Description;
        newCase.Details__c = oldCase.Details__c;
        //newCase.product_2__c = oldCase.product_2__c;
        //newCase.Type_Task__c = oldCase.Type_Task__c; 
        newCase.Origin = oldCase.Origin;
        newCase.Subject = oldCase.Subject; 
        newCase.keep_recordtype__c = false;
        
        try {
            System.debug('newCase Before Insert:' + newCase);
            insert newCase;
            System.debug('newCase After Insert:' + newCase);
        } catch (Exception  e) {
            ApexPages.addMessages(e);
            return null;
            //return new PageReference('/' + oldCase.Id);
        }
        // If we got this far try to clone the email message and any attachments
        if (oldEmailMessage != null) {
            EmailMessage newEmailMessage = new EmailMessage();
            newEmailMessage.ParentId = newCase.Id;
            newEmailMessage.FromAddress = oldEmailMessage.FromAddress;
            newEmailMessage.CcAddress = oldEmailMessage.CcAddress;
            newEmailMessage.BccAddress = oldEmailMessage.BccAddress;
            newEmailMessage.FromName = oldEmailMessage.FromName;
            newEmailMessage.Headers = oldEmailMessage.Headers;
            newEmailMessage.HtmlBody = oldEmailMessage.HtmlBody;
            newEmailMessage.Incoming = oldEmailMessage.Incoming;
            newEmailMessage.MessageDate = oldEmailMessage.MessageDate;
            newEmailMessage.Status = oldEmailMessage.Status;
            newEmailMessage.Subject = oldEmailMessage.Subject;
            newEmailMessage.TextBody = oldEmailMessage.TextBody;
            newEmailMessage.ToAddress = oldEmailMessage.ToAddress;
            try {
                insert newEmailMessage;
            } catch (Exception e) {
                return new PageReference('/' + newCase.Id);
            }
            // Finally the attachments
            List<Attachment> newAttachments = new List<Attachment>();
            for (Attachment a : oldAttachments) {
                Attachment newAttachment = new Attachment();
                newAttachment.Body = a.Body;
                newAttachment.ContentType = a.ContentType;
                newAttachment.Name = a.Name;
                newAttachment.ParentId = newEmailMessage.Id;
                newAttachments.add(newAttachment);
            }
            try {
                insert newAttachments;
            } catch (Exception e) {}
        }
        // Navigate the user to the cloned case
        return new PageReference('/' + newCase.Id);
    }
    
    static testMethod void testCloseAndClone() {
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
                
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
        acc.Customer_No__c = '1234';
        insert acc;
        
        // Create case records
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Description = 'Product: TV\r\nType: Support\r\n';
        c.RecordTypeId = recordType.Id;
        c.setOptions(dmo);
        c.OwnerId = System.UserInfo.getUserId();
        c.allow_Edit__c = true;
        insert c;
        
        EmailMessage newEmailMessage = new EmailMessage();
        newEmailMessage.ParentId = c.Id;
        newEmailMessage.FromAddress = 'test@test.dk';
        newEmailMessage.CcAddress = '';
        newEmailMessage.BccAddress = '';
        newEmailMessage.FromName = 'Test';
        newEmailMessage.Headers = null;
        newEmailMessage.HtmlBody = null;
        newEmailMessage.Incoming = true;
        newEmailMessage.MessageDate = System.now();
        newEmailMessage.Status = '0';
        newEmailMessage.Subject = 'Subject';
        newEmailMessage.TextBody = 'Test body';
        newEmailMessage.ToAddress = 'test@test.dk';
        insert newEmailMessage;
        
        Attachment newAttachment = new Attachment();
        newAttachment.Body = Blob.valueOf('');
        newAttachment.ContentType = 'text';
        newAttachment.Name = 'Attachment';
        newAttachment.ParentId = newEmailMessage.Id;
        insert newAttachment;
        
        PageReference pageRef = Page.CasesCloseAndClone;
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController sc = new ApexPages.StandardController(c); 
        // Test that the correct case records were returned
        clsCasesCloseAndCloneController controller = new clsCasesCloseAndCloneController(sc);
        PageReference p = controller.closeAndClone();
        String url = p.getUrl();
        String id = url.substring(1);
        System.assertNotEquals(c.Id, id);
    }
}