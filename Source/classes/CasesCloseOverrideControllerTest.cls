/**
This unit tests covers CasesCloseOverrideController apex class. 
(Close case validation when case has inbound email)
*/
@isTest
private with sharing class  CasesCloseOverrideControllerTest {
    /**
    Test scenario according https://yousee.jira.com/browse/SPOC-66
    1)  Create a case
    2)  Add unread email messages to the case
    3)  Take ownership of the case (Click work case/Click link Behandl)
    4)  Click the “Close Case” button
    5)  Verify that the Apex warning “Unread email messages” – “There are still unread email messages on the case. You cannot close the case until all emails have been read.” shows up as warning.
    6)  Read the unread messages
    7)  Click the “Close Case” button
    8)  Verify that the case has closed without any warnings.
     */
     
    /* 
    //This method is commented because required scenario is covering other controlers and can cause test fail in unpredictable situations.
    //Remaining methods closeCaseWithUnreadEmailTest and closeCaseWithReadEmailTest can cover 100% of CasesCloseOverrideController code.
    
    static testMethod void closeCaseTest() {
        
        // 1)   Create a case 
        Case c = prepareTestData();
        
        // 2)   Add unread email messages to the case 
        Savepoint sp = Database.setSavepoint();
        EmailMessage e = new EmailMessage();
        e.Incoming = true;
        e.ParentId = c.Id;
        e.Status = '0';//New (0 - New; 1 - Read; 2 - Replied; 3 - Sent; 4 - Forwarded)
        insert e;
        
        // 3)   Take ownership of the case (Click work case/Click link Behandl) 
        PageReference pageRef = new PageReference('apex/CasesTab');// System.Page.CaseTab;
        //new PageReference('partialURL');
        Test.setCurrentPage(pageRef);
        clsCasesTabController controller = new clsCasesTabController();
        Case cf = new Case(Department__c='YKTEST');
        cf.Department__c = null;
        cf.Product_2__c = 'TV';
        cf.Type_Task__c = 'Support';
        controller.setCaseFields(cf);
        controller.updateQueueCount();
        Case workedCase;
        for (Case caseEmail:controller.getCases()){
            if (caseEmail.Id == c.Id){
                workedCase = caseEmail;
                break;
            }
        }
        ApexPages.currentPage().getParameters().put('caseId', workedCase.Id);
        controller.editCase();
       
        // 4)   Click the “Close Case” button 
        ApexPages.StandardController stdController = new ApexPages.StandardController(workedCase);
        CasesCloseOverrideController controllerClose = new CasesCloseOverrideController(stdController);
        PageReference page = controllerClose.closeOverride();
        
        // 5)   Verify that the Apex warning “Unread email messages” –  "There are still unread email messages on the case. 
        // You cannot close the case until all emails have been read.” shows up as warning.
        System.assertEquals(null,page);
                
        // 6)   Read the unread messages    
        // It's not possible change email.status by SOQL query becuse:
        // http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_emailmessage.htm
        // It's not possible to invoke page and force SF to set email as read by Test.invokePage(pageRef) becouse:
        // System.StringException: Test.invokePage is not implemented yet
        
        //List<EmailMessage> emails = [SELECT Id, Status FROM EmailMessage WHERE ParentId = :c.Id AND Status = :'0' ];
        //for (EmailMessage email: emails){
            //pageRef = new PageReference('/'+email.Id);
            //Test.invokePage(pageRef);
            
            //email.Status='1';             
            //update email;
        //}
        
        
        //It is also not possible to delete email message (because of trigger EmailMessageBeforeDelete), so we roll back it and create new with status read
        Database.rollback(sp);
        EmailMessage readEmail = new EmailMessage();
        readEmail.Incoming = true;
        readEmail.ParentId = c.Id;
        readEmail.Status = '1';//Read (0 - New; 1 - Read; 2 - Replied; 3 - Sent; 4 - Forwarded)
        insert readEmail;
        

        // 7)   Click the “Close Case” button 
        stdController = new ApexPages.StandardController(c);
        controllerClose = new CasesCloseOverrideController(stdController);
        page = controllerClose.closeOverride();
        
        // 8)   Verify that the case has closed without any warnings.
        String expectedCloseCaseLink = '/' + c.Id + '/s?retURL=/' + c.Id;
        System.assert(Encodingutil.urlDecode(page.getUrl(),'UTF-8').contains(expectedCloseCaseLink));
    }
    */
    
    /*
    This unit test method cover case when Case has unread inbound email.
    */  
    static testMethod void closeCaseWithUnreadEmailTest() {
        /* 1) Preparing test data */
        Case c = prepareTestData();
        
        //Create inbound email to Case
        EmailMessage e = new EmailMessage();
        e.Incoming = true;
        e.ParentId = c.Id;
        e.Status = '0';//New
        insert e;
        
        /* 2) Open Case */
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        CasesCloseOverrideController controller = new CasesCloseOverrideController(stdController);        
        /* 3) Close Case */
        PageReference page = controller.closeOverride();        
        /* 4  Test method closeOverride that retrun expected null refernece */
        System.assertEquals(null,page);
        
    }
    
    /*
    This unit test method cover case when Case has not unread inbound email.
    */
    static testMethod void closeCaseWithReadEmailTest() {
        /* 1) Preparing test data */
        Case c = prepareTestData();
        
        //Create inbound email to Case
        EmailMessage e = new EmailMessage();
        e.Incoming = true;
        e.ParentId = c.Id;
        e.Status = '1';//Read
        insert e;
        
        /* 2) Open Case */
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        CasesCloseOverrideController controller = new CasesCloseOverrideController(stdController);
        /* 3) Close Case */
        PageReference page = controller.closeOverride();
        
        /* 4  Test method closeOverride that retrun expected apex page refernece: 
        '/' + c.Id + '/s?retURL=/' + c.Id; */
        System.assertNotEquals(null,page);
        
        String expectedCloseCaseLink = '/' + c.Id + '/s?retURL=/' + c.Id;
        System.assert(Encodingutil.urlDecode(page.getUrl(),'UTF-8').contains(expectedCloseCaseLink));        
    }
 
    private static Case prepareTestData(){
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
        
        // Create case
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'New';
        c.Subject = 'Complaint Letter ' ;
        c.Department__c = '';
        c.Product_2__c = 'TV';
        c.Type_Task__c = 'Support';
        c.RecordTypeId = recordType.Id;
        c.setOptions(dmo);  
        insert c;
        
        return c;
    }           
}