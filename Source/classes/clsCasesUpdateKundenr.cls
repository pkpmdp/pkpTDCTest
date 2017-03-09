public with sharing class clsCasesUpdateKundenr {

	public String strCaseId{get;set;}
	public String strCustNumber{get;set;}
	public string strCaseAccountId{get;set;}
	public String strNewCaseAccountId{get;set;}
	public clsCasesUpdateKundenr(ApexPages.StandardController Ctlr){
		 
		 strCaseId = Ctlr.getId();	 
		 List<Case>lstCase = [Select id,AccountId From Case where id =:strCaseId];
		 if(!lstCase.isEmpty())
		 	strCaseAccountId = lstCase[0].AccountId;
	
	}
	
	public pagereference btnSave(){
		Case objCasetoupdate = new Case(id=strCaseId);
		objCasetoupdate.Customer_Number__c = strCustNumber;
		update objCasetoupdate;		
		
		
		Case objcase = [select AccountId , id from Case where id =:strCaseId];
		if(objcase.AccountId!=null)
			strNewCaseAccountId = objcase.AccountId;
		return null;
	}
	
	static testMethod void testclsCasesUpdateKundenr(){
		
		Map<String,String>mapRecTypeNameToId = new Map<String,String>();
		for(RecordType recordType : [Select Id,name From RecordType Where Name = 'Queue Owned Case' or Name = 'YS Customer Account'])
			mapRecTypeNameToId.put(recordType.name,recordType.id);
		
		PageReference pageRef = Page.CasesUpdateKundenr;
        Test.setCurrentPage(pageRef);
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;

        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c();
        objLookUp.Name = 'Andelsboligforening1';
        objLookUp.Code__c = 'ANMC';
        objLookUp.SourceId__c = 'ABCDE';
        insert objLookUp;
        
        // Create customer record
        Account acc = new Account();
        acc.Name = 'Jon Smith';
        acc.Customer_Segment_Lookup__c = objLookUp.id;
        acc.RecordTypeId = mapRecTypeNameToId.get('YS Customer Account');
        acc.Customer_No__c = '1234';
        insert acc;
        
        // Create 2nd Customer record
        Account acc1 = new Account();
        acc1.Name = 'Peter Parker';      
        acc1.Customer_Segment_Lookup__c = objLookUp.id;
        acc1.RecordTypeId = mapRecTypeNameToId.get('YS Customer Account');
        acc1.Customer_No__c = '7777';
        insert acc1;

        // Create case record
        List<Case> casesToCreate = new List<Case>();
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Description = 'Department: '+System.label.PYSF+'TEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c.RecordTypeId = mapRecTypeNameToId.get('Queue Owned Case');
        insert c;
        
        // Navigate to the search page and instantiate the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        clsCasesUpdateKundenr controller = new clsCasesUpdateKundenr(sc);
       
       	Test.startTest(); 
        controller.strCustNumber = '7777';
        controller.btnSave();
        Test.stopTest();
        
	} 
}