public with sharing class clsCasesBackToQueueController {


    private ApexPages.StandardController controller;
    public String isConsole{get;set;}

    public clsCasesBackToQueueController(ApexPages.StandardController c) {
        controller = c;
    }
    
    // KH: Added action method backToQueueAndNext()
    public PageReference backToQueueAndNext() {
        PageReference casesTab = backToQueue();
        clsCasesTabController classesTabController = new clsCasesTabController();
        return classesTabController.retrieveNextCase();
    }
    
    public PageReference backToQueueConsole() {
        backToQueue();
        return new PageReference('/'+this.controller.getRecord().Id+'?isdtp=vw');
    }
    
    //Aref: modified method to conditionally fire assignment rules
    public PageReference backToQueue() {
        clsCasesReassign util = new clsCasesReassign();
        Case c = (Case) this.controller.getRecord();
        c = [select Status,manual_assign__c,Reserve_Until__c,OwnerId from Case where id=:c.Id];
                
        /*
        if(c.Reserve_Until__c != null){
            
            if(c.Reserve_Until__c > Date.today())
                util.reassignCases(new Case[]{c}, false);
            else 
                util.reassignCases(new Case[]{c}, true);
        }
        else{
            
            util.reassignCases(new Case[]{c}, true);
        }
        */
        
        /*
        if(c.Status == 'Reserved')
            util.reassignCases(new Case[]{c}, false);
        else 
            util.reassignCases(new Case[]{c}, true);
        
        */
       // if(c.OwnerId == UserInfo.getUserId()){
            if(c.Status != 'Reserved'){
                c.manual_assign__c = false;
                try{
                    Database.update(c);
                } catch (DMLException e){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                    return null;
                }   
            }
            
            
            
            if(isConsole == 'false')
                return Page.CasesTab;
            else
                return Page.CasesTab;
           // } //end of if
       /* else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You cannot use this function. Case is owned by another user.'));
             return null;   
        } */
    }
    
    // Test coverage for requirement to search for customers to link to cases by address
    static testMethod void testCasesViewAttachment() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        PageReference pageRef = Page.CasesSearchCustomerResults;
        Test.setCurrentPage(pageRef);
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        System.assert (add.id != null, 'Cannot insert address');
        
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
        
        System.assert (acc.id != null, 'Cannot insert account');
        
        // Create case record
        List<Case> casesToCreate = new List<Case>();
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.OwnerId = UserInfo.getUserId();
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Department__c = 'YKRB';
        c.RecordTypeId = recordType.Id;
        insert c;
        
        System.assert (c.id != null, 'Cannot insert account');
        
        // Navigate to the case and instantiate the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        clsCasesBackToQueueController controller = new clsCasesBackToQueueController(sc);
        //PageReference p = controller.backToQueue();
        PageReference p = controller.backToQueueAndNext();
        //System.assertEquals('/apex/casestab', p.getUrl());
        c = [Select Id, OwnerId From Case Where Id = :c.Id];
        //System.assertNotEquals(UserInfo.getUserId(), c.OwnerId);
        controller.backToQueueConsole();
        
    }  
}