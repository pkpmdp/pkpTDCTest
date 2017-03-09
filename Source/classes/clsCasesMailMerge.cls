public with sharing class clsCasesMailMerge extends clsPageControllerBase {
    // Private member variable
	private MailmergeTemplate mmTemplate;
    private Task relatedTask;
    private Boolean createNewTask;
 	private clsAutoCompleteController myComponentController { get; set; }
    
    //Constructor
	public clsCasesMailMerge() {
        mmTemplate = new MailmergeTemplate();
        relatedTask = new Task(WhatId=ApexPages.currentPage().getParameters().get('caseId'));
        createNewTask = true;
    }
	    
	public override void setComponentController(clsComponentControllerBase compController) {
        myComponentController = (clsAutoCompleteController)compController;
    }
	
    public override clsComponentControllerBase getMyComponentController() {
        return myComponentController;
    }
	
    public Task getRelatedTask() {
 		return relatedTask;
 	}
 	
 	public void setRelatedTask(Task t) {
 		relatedTask = t;
 	}
 	
 	public Boolean getCreateNewTask() {
 		return createNewTask;
 	}
 	
 	public void setCreateNewTask(Boolean flag) {
 		createNewTask = flag;
 	}
 	
 	public MailmergeTemplate getMmTemplate() {
 		return mmTemplate;
 	}
 	
 	public void setMmTemplate(MailmergeTemplate t) {
 		mmTemplate = t;
	}

    public PageReference generate() {
    	Map<String, String> m = myComponentController.getResultIds();
        String templateId = m.get(mmTemplate.Name);	        
        if (templateId == null) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please select a valid mail merge template'));
        	return null;
        } else {
    	    String url;
/*
    	    MailmergeTemplate t = [Select Id, Name, FileName From MailmergeTemplate Where Id = :templateId];
    	    External_Attachment_Del__c ead = new External_Attachment_Del__c();
    	    ead.Name = t.Name;
    	    ead.File_Path__c = 'c:\\' + t.FileName;
    	    ead.Case__c = relatedTask.WhatId;
    	    insert ead;
*/
    	    //if (createNewTask) {
    	      //  url = '/mail/mmgen.jsp?retURL=%2F00T%2Fe%3Ftitle%3DMail%2BMerge%26who_id%3D%26what_id%3D' + relatedTask.WhatId + '%26followup%3D1%26tsk5%3D' + EncodingUtil.urlEncode(EncodingUtil.urlEncode(mmTemplate.Name, 'UTF-8'), 'UTF-8') + '%26retURL%3D%252F' + relatedTask.WhatId + '&dataURL=%2Fservlet%2Fservlet.SForceCommander%3Fp_type%3Dmailmerge%26id%3D' + relatedTask.WhatId + '%26did%3D' + templateId;
    	    //} else {
    	    	url = '/mail/mmgen.jsp?retURL=%2F' + relatedTask.WhatId + '&dataURL=%2Fservlet%2Fservlet.SForceCommander%3Fp_type%3Dmailmerge%26id%3D' + relatedTask.WhatId + '%26did%3D' + templateId;
            //}
            
            return new PageReference(url);
        }
    }
    
    public PageReference cancel() {
        return new PageReference('/' + relatedTask.WhatId);    	
    }
    
    static testMethod void testCasesMailMerge() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        // Unable to create MailmergeTemplates due to DML limitation, full coverage not possible
        /*
        User thisUser = [ select Id from User where LastName = 'Sheward' LIMIT 1];
        System.runAs ( thisUser ) {
            List<MailmergeTemplate> mmTemplatesToInsert = new List<MailmergeTemplate>(); 
            for (Integer i = 0; i < 10; i++) {
                MailmergeTemplate mmTemplate = new MailmergeTemplate();
                mmTemplate.Filename = 'Unit Test xxx' + i;
                mmTemplate.Name = 'Unit Test xxx' + i;
                mmTemplate.Body = Blob.valueOf('Test');
                mmTemplatesToInsert.add(mmTemplate);
            }
             insert mmTemplatesToInsert;
        }
        */
        
        PageReference pageRef = Page.CasesMailMerge;        
        Test.setCurrentPage(pageRef);
    
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = 'YFFTEST';
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
        
        // Create case record
        List<Case> casesToCreate = new List<Case>();
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Description = 'Department: YFFTEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c.RecordTypeId = recordType.Id;
        insert c;
        
        Case c1 = new Case();
        c1.AccountId = acc.Id;
        c1.Status = 'Open';
        c1.Subject = 'Complaint Letter ';
        c1.Description = 'Department: YFFTEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c1.RecordTypeId = recordType.Id;
        insert c1;

        ApexPages.currentPage().getParameters().put('caseId', c.Id);
        
        // Not sure how else to test the virtual methods since they are overriden
        clsPageControllerBase pageControllerBase = new clsPageControllerBase();
        System.assertNotEquals(null, pageControllerBase.getThis());
        System.assertEquals(null, pageControllerBase.getMyComponentController());
        clsComponentControllerBase componentControllerBase = new clsComponentControllerBase();
        pageControllerBase.setComponentController(componentControllerBase);
        System.assertNotEquals(null, pageControllerBase.getMyComponentController());
        
        // Instantiate page controller and component controller
        clsCasesMailMerge pageController = new clsCasesMailMerge();
        clsAutoCompleteController componentController = new clsAutoCompleteController(); 
        
        // Establish handshake between the controllers
        pageController.setComponentController(componentController);
        componentController.pageController = pageController;
                
        // Test overriden method
        componentControllerBase = pageController.getMyComponentController();
        System.assertNotEquals(null, componentControllerBase);
        
        // Check that the constructor set the link to the case record
        System.assertEquals(c.Id, pageController.getRelatedTask().WhatId);
        
        // Simulate the user changing the link to the case
        pageController.setRelatedTask(new Task(WhatId=c1.Id));
        System.assertEquals(c1.Id, pageController.getRelatedTask().WhatId);
        
        // By default the controller should create a new task
        System.assertEquals(true, pageController.getCreateNewTask());
        
        // Just to be safe run the setter for the property
        pageController.setCreateNewTask(true);
        
        System.assertEquals(new MailmergeTemplate(), pageController.getMMTemplate());
        
        // Call the setter
        pageController.setMMTemplate(new MailmergeTemplate());
        
        // Test the component controller initialisation
        System.assertEquals(false, componentController.getHasParams());
        System.assertEquals(false, componentController.getHasnoresults());
        System.assertEquals(new Map<String, String>(), componentController.getResultIds());
        
        ApexPages.currentPage().getParameters().put('objectname', 'MailmergeTemplate');
        ApexPages.currentPage().getParameters().put('aname', '******UNITTEST12345******');
        
        // No mail merge template match the input text
        PageReference p = componentController.searchSuggestions();
        System.assertEquals(0, componentController.getResultIds().size());
        System.assertEquals(1, componentController.getResultsName().size());
        System.assertEquals('No Results', componentController.getResultsName()[0]);
        
        // Not expecting anything back here - no template was selected
        p = pageController.generate();
        System.assertEquals(null, p);
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assertEquals(1, messages.size());
        System.assertEquals('Please select a valid mail merge template', messages.get(0).getDetail());
         
        // Method doesn't seem to be called but added for coverage
        componentController.avoidRefresh();
        
        // Check the cancel button navigation
        p = pageController.cancel();
        System.assertEquals('/' + pageController.getRelatedTask().WhatId, p.getUrl());
        
    }
}