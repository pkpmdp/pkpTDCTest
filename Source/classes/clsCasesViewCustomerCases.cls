public with sharing class clsCasesViewCustomerCases {
    
    private List<Case> cases;
    private String relatedCaseId;
    private Case relatedCase;
    private Boolean viewRelatedCasesList;
    private Boolean viewMiniProfile;
    public String alert;
    private Boolean showPageTitle = false;

    public clsCasesViewCustomerCases(ApexPages.StandardController controller) {
        viewRelatedCasesList = true;
        viewMiniProfile = false;
        Case c = (Case) controller.getRecord();
        if (c.AccountId == null) {
            cases = new List<Case>();   
        } else {
            cases = [Select ClosedDate, Urgent__c, Internal_Comments_Close_Reason__c, Id, CaseNumber, Subject, Description, Status, Department__c, Product_2__c, Type_Task__c, Origin, Deadline__c, Cancellation_Reason__c, Alerts__c, OwnerId, Owner.Name, CreatedDate, BusinessHours.Name From Case Where AccountId != null And AccountId = :c.AccountId and Id != :c.Id];
        }

        showPageTitle = (System.currentPagereference().getParameters().get('withTitle') == '1') ? true : false;
    }

    public Boolean getShowTitle(){
        return showPageTitle ;
    }

    public String getAlert() {
        if(relatedCase.Alerts__c == 'None')
            alert = '';
        else
            alert = relatedCase.Alerts__c;
        return alert;       
    }    
    
    public String getRelatedCaseId() {
        return relatedCaseId;
    }
    
    public void setRelatedCaseId(String id) {
        relatedCaseId = id;
        for (Case c : cases) {
            if (c.Id == relatedCaseId) {
                relatedCase = c;
            }
        }
    }
    
    public Case getRelatedCase() {
        return relatedCase;
    }        

    public Boolean getViewRelatedCasesList() {
        return viewRelatedCasesList;
    }
    
    public Boolean getViewMiniProfile() {
        return viewMiniProfile;
    }
    
    public List<Case> getCases() {
        return cases;
    }
    
    public PageReference navigateToCase() {
        viewRelatedCasesList = false;
        viewMiniProfile = true; 
        return null;
    }
    
    public PageReference navigateToListView() {
        viewRelatedCasesList = true;
        viewMiniProfile = false;    
        return null;
    }
    
    static testMethod void testCasesTabController() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
    
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = null;
        uq.Product__c = null;
        uq.Type_Task__c = null;
        upsert uq User__c;
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        // Modified due to implementation of KKD-82
        //acc.Customer_No__c = '1234TEST1234';
        insert acc;
        
        // Create case records
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Case firstCase;
        String subject = 'Complaint Letter Test';
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'Open';
            c.Subject = subject;
            c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123' + i;
            c.RecordTypeId = recordType.Id;
            c.OwnerId = UserInfo.getUserId();
            c.setOptions(dmo);
            casesToCreate.add(c);
            if (i == 0) firstCase = c;
        }
        Database.SaveResult[] results = Database.insert(casesToCreate);
        
        // Test that the correct case records were returned
        Test.setCurrentPage(Page.CasesViewCustomerCases);
        ApexPages.StandardController sc = new ApexPages.StandardController(firstCase);
        clsCasesViewCustomerCases controller = new clsCasesViewCustomerCases(sc);
        
        // Should be one less in array because the focus record is not displayed
        List<Case> cases = controller.getCases();
        System.assertEquals(9, cases.size());
        
        // Now check navigation to the preview panel
        controller.setRelatedCaseId(cases.get(0).Id);
        PageReference p = controller.navigateToCase();
        System.assertEquals(null, p);
        System.assertEquals(controller.getRelatedCaseId(), cases.get(0).Id);
        System.assertEquals(controller.getRelatedCase(), cases.get(0));
        System.assertEquals(false, controller.getViewRelatedCasesList());
        System.assertEquals(true, controller.getViewMiniProfile());
        
        // Finally make sure the user can navigate back to the list view
        p = controller.navigateToListView();
        System.assertEquals(null, p);
        System.assertEquals(true, controller.getViewRelatedCasesList());
        System.assertEquals(false, controller.getViewMiniProfile());

        // Test of getShowTitle
        System.assertEquals(controller.getShowTitle(), false);
        ApexPages.currentPage().getParameters().put('withTitle', '1');
        controller = new clsCasesViewCustomerCases(sc);
        System.assertEquals(controller.getShowTitle(), true);
    }
}