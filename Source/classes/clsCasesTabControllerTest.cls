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
private with sharing class clsCasesTabControllerTest {

    static testMethod void testRetrieveNextCase2() {
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);

        String dept = 'YKRB';
        String prod = 'Visitering';
        String typt = null;

        // Prepare test User Queue
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = dept;
        uq.Product__c = prod;
        uq.Type_Task__c = typt;
        upsert uq User__c;

        // Prepare test Address
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        insert add;

        // Prepare test Customer
        Account acc = new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Main';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;

        // Create test Cases
        List<Case> casesToCreate = new List<Case>();
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        for (Integer i=0; i<2; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Department__c = dept;
            c.Product_2__c = prod;
            c.Type_Task__c = typt;
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
 
        // Make sure following case's Last_Queue_Owner_ID__c is set
        Case case1 = [
            SELECT Last_Queue_Owner_ID__c, OwnerId, manual_assign__c FROM Case
            WHERE Id = :casesToCreate[0].Id
        ];
        case1.Last_Queue_Owner_ID__c = case1.OwnerId;
        case1.manual_assign__c = true;
        update case1;

        ApexPages.currentPage().getParameters().put('id', case1.Id);
        clsCasesTabController ctrl = new clsCasesTabController();
        PageReference p = ctrl.retrieveNextCase2();
        System.assert(p != null);
        // A successfull retrieveNextCase2 call returns: new PageReference('/' + nextCase.Id)
        System.assert(p.getUrl().startsWith('/500'));
    }

    // Test coverage for requirement to create Result records for Survey/Event/Financial Data records
    static testMethod void testCasesTabController() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
    
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        //uq.Department__c = System.label.PYSF+'TEST';
        //uq.Department__c = 'YFFTEST';
        uq.Product__c = 'TV';
        uq.Type_Task__c = 'Support';
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
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Subject = 'Complaint Letter ' + i;
            //c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123' + i;
            c.Department__c = '';
            c.Product_2__c = 'TV';
            c.Type_Task__c = 'Support';
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
        casesToCreate.clear();
        for (Integer i = 0; i < 5; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Subject = 'Complaint Letter ' + i;
            //c.Description = 'Department: '+System.label.PYSF+'\r\nCustomerID: 123' + i;
            //c.Description = 'Department: YFF\r\nCustomerID: 123' + i;
            c.Department__c = '';
            c.Product_2__c = 'TV';
            c.Type_Task__c = 'Support';
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;   
        
        // Test that the correct case records were returned
        clsCasesTabController controller = new clsCasesTabController();
        //System.assertEquals(100, controller.getCases().size());
        
        // Test changing the department picklist
        Case cf = new Case(Department__c='YKTEST');
        controller.setCaseFields(cf);
        controller.updateQueueCount();
        //System.assertEquals(0, controller.getCases().size());
        
        cf.Department__c = null;
        cf.Product_2__c = 'TV';
        cf.Type_Task__c = 'Support';
        controller.setCaseFields(cf);
        controller.updateQueueCount();
        //System.assertEquals(100, controller.getCases().size());
        
        // Test taking the next record
        clsCasesTabController.CaseCM expectedNextCaseCM = controller.getCases().get(0);
        PageReference p = controller.retrieveNextCase();
        //String url = p.getUrl();
        //System.assert(url.contains(expectedNextCaseCM.getId()));
        
        // Test editing case record in list
        ApexPages.currentPage().getParameters().put('caseId', expectedNextCaseCM.getId()); 
        p = controller.editCase();
        //System.assertEquals('/' + expectedNextCaseCM.getId() + '?retURL=%2F' + expectedNextCaseCM.getId(), p.getUrl());        
    }
    
    static testMethod void testCasesTabControllerWithCallBackCase() {
        RecordType recordType = [ Select Id From RecordType Where Name = 'Call Back Queue Owned Case'];
        
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
    
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = 'YOT';
        uq.Product__c = 'YOT Call Back';
        uq.Type_Task__c = 'Security';
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
        Test.startTest();
        for (Integer i = 0; i < 3; i++) {
            
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Subject = 'Complaint Letter ' + i;
            c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123' + i;
            c.Department__c = 'YOT';
            c.Product_2__c = 'YOT Call Back';
            c.Type_Task__c = 'Security';
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
      
        casesToCreate.clear();
        for (Integer i = 0; i < 3; i++) {
            
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Subject = 'Complaint Letter ' + i;
            c.Description = 'Department: YOT\r\nCustomerID: 123' + i;
            c.Department__c = 'YOT';
            c.Product_2__c = 'YOT Call Back';
            c.Type_Task__c = 'Broadband';
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
        Test.stopTest();
        // Test that the correct case records were returned
        clsCasesTabController controller = new clsCasesTabController();        
               
        // Test changing the department picklist
        Case cf = new Case(Department__c='YOT');
        controller.setCaseFields(cf);
        controller.updateQueueCount();
        //System.assertEquals(0, controller.getCases().size());
        

        cf.Department__c = 'YOT';
        cf.Product_2__c = 'YOT Call Back';
        cf.Type_Task__c = 'Security';
        controller.setCaseFields(cf);
        controller.updateQueueCount();
        controller.retrieveNextCaseId();
        System.debug(controller.getCases().size());
        System.assert(controller.getCases().size()>=3);
        clsCasesTabController.ShowCbCasesStatus showStatus = new  clsCasesTabController.ShowCbCasesStatus(true);
        System.debug('showStatus.getShowCbCaseCol()='+ showStatus.getShowCbCaseCol());
        System.debug('controller.getShowCbCasesStatus().getShowCbCaseCol()='
            +controller.getShowCbCasesStatus().getShowCbCaseCol());
        System.assertEquals(showStatus.getShowCbCaseCol(), controller.getShowCbCasesStatus().getShowCbCaseCol());
        System.debug('showStatus.getShowCaseCol()='+ showStatus.getShowCaseCol());
        System.debug('controller.getShowCbCasesStatus().getShowCaseCol()='+ controller.getShowCbCasesStatus().getShowCaseCol());
        System.assertEquals(showStatus.getShowCaseCol(), controller.getShowCbCasesStatus().getShowCaseCol());
        
        // Test taking the next record
        clsCasesTabController.CaseCM expectedNextCaseCM = controller.getCases().get(0);
        PageReference p = controller.retrieveNextCase();
        //String url = p.getUrl();
        //System.debug('url='+url);
        //System.debug('expectedNextCase.Id='+ expectedNextCaseCM.getId());
        //System.assert(url.contains(expectedNextCaseCM.getId()));
        
        // Test editing case record in list
        ApexPages.currentPage().getParameters().put('caseId', expectedNextCaseCM.getId()); 
        p = controller.editCase();
        //System.assertEquals('/' + expectedNextCaseCM.getId() + '?retURL=%2F' + expectedNextCaseCM.getId(), p.getUrl());
    }

    static testMethod void testCasesTabControllerPopup() {
        PageReference pageRef = Page.CasesEnhancedList;
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
        acc.Customer_No__c = '1234';
        insert acc;

        // Create case records
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'Reserved';
            c.Reserve_Until__c = Date.today()+10;
            c.Reservation_Reason__c = 'Test reservation reason ' + i;

            c.Subject = 'Complaint Letter ' + i;
            c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123' + i;
            //c.Department__c = System.label.PYSF;
            c.Department__c = 'YFF';
            c.Product_2__c = 'Visitering';
            c.Type_Task__c = '';
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
        
        String casesIds=null;
        for(Case c:casesToCreate){
            if (casesIds==null){
                casesIds=c.ID;
            }else{
                casesIds+=','+c.ID;
            }
        }
        
        Case c1 = new Case();
        c1 = casesToCreate[0];
       
        clsCasesTabController controller = new clsCasesTabController();       
        clsCasesTabController.CaseCM wrapCM = new clsCasesTabController.CaseCM(c1.Id, '12365'  , 'asdasd','web - Blockbuster','',acc.Id,'' ,
            'abc', acc.Id,'qwe',Date.today(), Date.today()+10, '',acc.Id,'');
        wrapCM.getCaseNumber();
        wrapCM.getSubject();
        wrapCM.getOrigin();
        wrapCM.getDescription();
        wrapCM.getAccountId();
        wrapCM.getContactId();
        wrapCM.getContactName();
        wrapCM.getTypeTask();
        wrapCM.getAccountName();
        wrapCM.getCreatedDate();
        wrapCM.getTargetDate();
        wrapCM.getCallBackTime();
        wrapCM.getCreatedBy();
        wrapCM.getCreatedByName();
        controller.setPopupCaseIds(casesIds);
        controller.initReservationReasons();
        System.assert(controller.getReservationReasonsJson()!=null);
        
        //call getters and setters to increase coverage
        System.assertEquals(casesIds,controller.getPopupCaseIds());
        controller.setReservationReasonsJson(null);
        System.assert(controller.getReservationReasonsJson()!=null);
    }
    
    static testMethod void testretrieveNextCase2Id() {
        PageReference pageRef = Page.CasesEnhancedList;
        Test.setCurrentPage(pageRef);

        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street1';
        add.House_No__c = '1';
        add.Town__c = 'Leeds1';
        add.Postcode__c = 'LS13';
        insert add;
        
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon1';
        acc.LastName = 'Smithq';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;

        // Create case records
        List<Case> casesToCreate = new List<Case>();
        
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'Reserved';
            c.Reserve_Until__c = Date.today()+10;
            c.Reservation_Reason__c = 'Test reservation reason ' + i;

            c.Subject = 'Complaint Letter ' + i;
            c.Description = 'Product: TV\r\nType: Support\r\nCustomerID: 123' + i;
            //c.Department__c = System.label.PYSF;
            c.Department__c = 'YFF';
            c.Product_2__c = 'Visitering';
            c.Type_Task__c = '';
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
        insert casesToCreate;
        
        String casesIds=null;
        for(Case c:casesToCreate){
            if (casesIds==null){
                casesIds=c.ID;
            }else{
                casesIds+=','+c.ID;
            }
        }
        clsCasesTabController controller = new clsCasesTabController(); 
        controller.retrieveNextCase2Id();
    }
    
    static testMethod void testretrieveNextCaseInConsoleLukOgnaeste(){
        PageReference pageRef = Page.CasesTab;
        Test.setCurrentPage(pageRef);
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];

        String dept = 'YKRB';
        String prod = 'Visitering';
        String typt = 'Outbound Call back bookings';

        // Prepare test User Queue
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = dept;
        uq.Product__c = prod;
        uq.Type_Task__c = typt;
        upsert uq User__c;

        // Prepare test Address
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        insert add;

        // Prepare test Customer
        Account acc = new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Main';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
        
        List<Case> casesToCreate = new List<Case>();
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
  
        for (Integer i=0; i<2; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Department__c = dept;
            c.Product_2__c = prod;      
            c.Type_Task__c = typt; 
            c.RecordTypeId = recordType.id;    
            c.setOptions(dmo);            
            casesToCreate.add(c);
        }
        insert casesToCreate;
        system.debug('======casesToCreate======'+casesToCreate);
        // Make sure following case's Owner id is set
        Case case1 = [
            SELECT Last_Queue_Owner_ID__c, OwnerId, manual_assign__c FROM Case
            WHERE Id = :casesToCreate[0].Id
        ];
        case1.OwnerId = case1.OwnerId;
        case1.Taken_Using_Next_Button__c = true;
        case1.manual_assign__c = true;
        update case1;
        
        system.debug('======case1======'+case1);
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'New';
        c.Department__c = dept;
        c.Product_2__c = prod;      
        c.Type_Task__c = typt; 
        c.RecordTypeId = recordType.id;        
        insert c;
            
        ApexPages.currentPage().getParameters().put('id', c.Id);
        clsCasesTabController ctrl = new clsCasesTabController();
        //PageReference p = ctrl.retrieveNextCaseInConsoleLukOgnaeste();
        ctrl.retrieveNextCaseInConsoleLukOgnaeste();
        //System.assert(p != null);
        // A successfull retrieveNextCase2 call returns: new PageReference('/' + nextCase.Id)
        //System.assert(p.getUrl().startsWith('/500'));
        
    }
    
    static testMethod void checkVar(){
        clsCasesTabController controller = new clsCasesTabController();
        PageReference pageRef = Page.CasesTab;
        

        String dept = 'YKRB';
        String prod = 'Visitering';
        String typt = null;

        // Prepare test User Queue
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = dept;
        uq.Product__c = prod;
        uq.Type_Task__c = typt;
        upsert uq User__c;

        // Prepare test Address
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        insert add;

        // Prepare test Customer
        Account acc = new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Main';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;

        // Create test Cases
        List<Case> casesToCreate = new List<Case>();
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        // Need assignment rules to be processed
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        for (Integer i=0; i<2; i++) {
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Status = 'New';
            c.Department__c = dept;
            c.Product_2__c = prod;
            c.Type_Task__c = typt;
            c.RecordTypeId = recordType.Id;
            c.setOptions(dmo);
            casesToCreate.add(c);
        }
         insert casesToCreate;  
         ApexPages.currentPage().getParameters().put('id', casesToCreate[0].Id);
         Test.setCurrentPage(pageRef);
         clsCasesTabController.CaseCM c1 = new clsCasesTabController.CaseCM(casesToCreate[0].Id,casesToCreate[0].CaseNumber,casesToCreate[0].Subject,casesToCreate[0].Origin,casesToCreate[0].Type_Task__c,null,'',casesToCreate[0].Description,casesToCreate[0].AccountId,casesToCreate[0].Account.Name ,casesToCreate[0].CreatedDate,casesToCreate[0].CreatedDate,casesToCreate[0].Call_Back__r.CB_time__c,casesToCreate[0].CreatedById,casesToCreate[0].CreatedBy.name);
         c1.CaseNumber = casesToCreate[0].CaseNumber;
         c1.Subject = casesToCreate[0].Subject;
         c1.Origin = casesToCreate[0].Origin;
         c1.Description = casesToCreate[0].Description;
         c1.AccountId = casesToCreate[0].AccountId;
         c1.AccountName = casesToCreate[0].Account.Name;
         c1.CreatedDate = casesToCreate[0].CreatedDate != null ? casesToCreate[0].CreatedDate.format() : null;
         c1.TargetDate = String.valueOf(casesToCreate[0].CreatedDate);
         c1.CallBackTime = casesToCreate[0].Call_Back__r.CB_time__c;
         ApexPages.currentPage().getParameters().put('id', casesToCreate[0].Id);
         controller.getCaseFields();
         controller.getDisableNextButton();
         controller.refreshCaseList();
         controller.workOnCase(casesToCreate[0].ID);
         //controller.editCaseId();
        //clsCasesTabController.CaseCM expectedNextCaseCM = controller.getCases().get(0);
        //expectedNextCaseCM.getCaseNumber();
    }
    
}