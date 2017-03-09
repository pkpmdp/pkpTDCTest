public class clsFbLeadConverterControler {
    
    private ApexPages.standardController controller;
    private Lead lead; 
    private Id accountId;
    private Id contactId;
    private Id caseId;
    private Boolean showConfirmation;
    public Account account {get; set;}
    // This is a temp conversation used for automatic creation of hoover and lookup functionality of visualforce page 
    public sf4twitter__Twitter_Conversation__c c {get; set;}
    
    public clsFbLeadConverterControler(ApexPages.StandardController stdController) {
        this.showConfirmation = false;
        this.c = new sf4twitter__Twitter_Conversation__c();
        
        controller = stdController;
        Id leadId = controller.getId();
        
        if (leadId != null) {
            this.lead = [SELECT Id, Name, IsConverted FROM Lead WHERE Id = : leadId];
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: No Lead Id is given.');
            ApexPages.addMessage(myMsg);
        }
        
        try {
            accountId = ApexPages.currentPage().getParameters().get('accId');
            caseId = ApexPages.currentPage().getParameters().get('caseId');
        } catch (StringException e) {
            accountId = null;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: ' + e.getMessage() );
            ApexPages.addMessage(myMsg);
        }
        
        if (accountId != null) {
            this.account = [ SELECT Id, Name, OwnerId FROM Account WHERE Id = : accountId ];
            c.sf4twitter__Account__c = account.id; 
            c.sf4twitter__Lead__c = leadId;
        } else {
            this.account = new Account(); 
            this.account.OwnerId = UserInfo.getUserId();
        }
    }
    
    public PageReference chooseAction() {
        if (lead == null){
            return null;
        }
 
        if (lead.IsConverted) {
            PageReference acctPage = controller.view();
            return acctPage;
        }
        
        // If accountId is given show the confirmation
        if (accountId != null) {
            this.showConfirmation = true;
        }
        
        return null;
    }
    
    public Boolean getshowConfirmation() {
        return showConfirmation;
    }
    
    void updateCase() {
        Case cs = [ SELECT Id, description, AccountId FROM Case Where Id = : caseId ];
        if (cs.description != null)
            cs.description = cs.description.substringAfter(clsFbLeadConvertUtil.CASE_DESC_SEPARATOR);
        cs.AccountId = accountId;
        cs.ContactId = contactId;

        update cs;
    }
    
    public PageReference convertLead() {
        
        // If the account was not provided in the link but it was chosen manualy on the page,
        // copy its id from temporal conversation object.
        if (accountId == null && c.sf4twitter__Account__c != null)
            accountId = c.sf4twitter__Account__c;
        
        system.debug('### Converting lead: ' + lead.Id + ' to account: ' + accountId);
        
        Database.LeadConvertResult lcr;
        try {
            lcr = clsFbLeadConvertUtil.convertLead(lead.Id, accountId, account.OwnerId);
        } catch (Exception e) {
            System.debug(e);
            // There was an exception so display the error message to the user
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));              
            return ApexPages.currentPage();
        }
        
        if (lcr.isSuccess()) {
            // Navigate the user to the new account
            PageReference pr = new PageReference ('/' + lcr.getAccountId());
            
            // If case id was given, remove links from description and attach account and contact to it
            if (caseId != null) {
                contactId = lcr.getContactId();
                updateCase();
            }
            
            return pr;                    
        } else {
            // Navigate the user to the lead convert screen displaying the error message
            for (Database.Error error : lcr.getErrors()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, error.getMessage()));              
            }   
            PageReference pr = ApexPages.currentPage();
            return pr;
        }
    }
    
    @isTest
    private static void prepareRequiredSettings() {
        // Prepare KKD-14's required data
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;             
        insert custSeq;
        // Add custom setting required by tgrPopulateAccountInfo
        Yousee13Campaign__c yousee13 = new Yousee13Campaign__c(Name='Registration');
        insert yousee13;
    }
    
    
    @isTest
    public static void testAutomaticConversion() {
    	
    	YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        // Prepare data
        prepareRequiredSettings();
        String ykLeadType = System.Label.RecordTypeYKLead;
        Account a = new Account(FirstName='Test', LastName='Account');
        insert a;
        Lead l = new Lead(FirstName='Test', LastName='Lead', Email='my@email.com',RecordTypeID = ykLeadType);
        insert l;
        Case c = new Case(Description = 'Test text 1' + clsFbLeadConvertUtil.CASE_DESC_SEPARATOR + 'Test text 2');
        insert c;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', l.Id);
        ApexPages.currentPage().getParameters().put('accId', a.Id);
        ApexPages.currentPage().getParameters().put('caseId', c.Id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(l);
        clsFbLeadConverterControler controller = new clsFbLeadConverterControler(stdController);
        
        controller.chooseAction();
        
        // Confirmation should be displayed
        System.assert(controller.getshowConfirmation());
        
        // Convert the lead
        PageReference nextPage = controller.convertLead();
        
        Test.stopTest();
        
        // Test that account detail page is displayed after the conversion
        System.assertEquals('/'+a.id, nextPage.getUrl());
        
        // Test whether the lead was correcly converted
        Account a2 = [ SELECT Id, Name, PersonEmail, OwnerId FROM Account WHERE Id = : a.id ];
        Lead l2 = [ SELECT Id, Name, Email, IsConverted FROM Lead WHERE Id = : l.id ];
        Case c2 = [ SELECT Id, AccountId, Description FROM Case WHERE Id = : c.id ];
        
        System.assert(l2.IsConverted);
        System.assertEquals('Test Account', a2.Name);
        System.assertEquals(l.Email, a2.PersonEmail);
        System.assertEquals('Test text 2', c2.Description);
    }
    
    @isTest
    public static void testManualConversion() {
        // Prepare data
        prepareRequiredSettings();
        String ykLeadType = System.Label.RecordTypeYKLead;
        Account a = new Account(FirstName='Test', LastName='Account');
        insert a;
        Lead l = new Lead(FirstName='Test', LastName='Lead', Email='my@email.com',RecordTypeID = ykLeadType);
        insert l;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(l);
        clsFbLeadConverterControler controller = new clsFbLeadConverterControler(stdController);
        
        controller.chooseAction();
        
        // Confirmation should not be displayed
        System.assert(!controller.getshowConfirmation());
        
        // Set manually which account should be used
        controller.c.sf4twitter__Account__c = a.id;
        
        // Convert the lead
        PageReference nextPage = controller.convertLead();
        
        Test.stopTest();
        
        // Test that account detail page is displayed after the conversion
        System.assertEquals('/'+a.id, nextPage.getUrl());
        
        // Test whether the lead was correcly converted
        Account a2 = [ SELECT Id, Name, PersonEmail, OwnerId FROM Account WHERE Id = : a.id ];
        Lead l2 = [ SELECT Id, Name, Email, IsConverted FROM Lead WHERE Id = : l.id ];
        
        System.assert(l2.IsConverted);
        System.assertEquals('Test Account', a2.Name);
        System.assertEquals(l.Email, a2.PersonEmail);
    }
    
    @isTest
    public static void testDoubleConversion() {
        // Prepare data
        prepareRequiredSettings();
        String ykLeadType = System.Label.RecordTypeYKLead;
        Account a = new Account(FirstName='Test', LastName='Account');
        insert a;
        // Set lead as alredy converted
        Lead l = new Lead(FirstName='Test', LastName='Lead', Email='my@email.com',RecordTypeID = ykLeadType);
        insert l;
        
        // Convert the lead
        Database.LeadConvertResult lcr = clsFbLeadConvertUtil.convertLead(l.Id, a.Id, null);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', l.Id);
        ApexPages.currentPage().getParameters().put('accId', a.Id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(l);
        clsFbLeadConverterControler controller = new clsFbLeadConverterControler(stdController);
        
        PageReference nextPage = controller.chooseAction();
        
        // Try to manually convert the lead to get the database error
        PageReference currentPage = ApexPages.currentPage();
        PageReference nextPage2 = controller.convertLead();
        
        Test.stopTest();
        
        // Test that the converted lead info page is displayed directly
        System.assertEquals(('/'+l.id).left(16), nextPage.getUrl().left(16));
        
        // Test that it stays on current page after the error in database
        System.assertEquals(currentPage, nextPage2);
        
    }
    
    @isTest
    public static void testWrongIds() {
        // Set lead as alredy converted
        prepareRequiredSettings();
        String ykLeadType = System.Label.RecordTypeYKLead;
        Lead l = new Lead(FirstName='Test', LastName='Lead', Email='my@email.com',RecordTypeID = ykLeadType);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', null);
        ApexPages.currentPage().getParameters().put('accId', 'test');
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(l);
        clsFbLeadConverterControler controller = new clsFbLeadConverterControler(stdController);
        
        PageReference nextPage = controller.chooseAction();
        
        Test.stopTest();
        
        // Test that the page is not redirected 
        System.assertEquals(null, nextPage);
    }
}