public class clsCaseCloseByCustomerController {
	
	private Case caseToBeClosed;
	public String caseStatus {get;set;}
	public String caseNo {get;set;}
	//public String AccountName {get;set;}
	public boolean closeAction {get;set;}
	public String subject {get;set;}
	//public String creationDate {get;set;}
	
	public clsCaseCloseByCustomerController(ApexPages.StandardController controller) {		
		Id id = ApexPages.currentPage().getParameters().get('id');
		string secur = ApexPages.currentPage().getParameters().get('secur');
		closeAction = false;
		if(id != null){
			caseToBeClosed = [Select Id, Status, SecurCode__c, CaseNumber, Account.Name, Subject, CreatedDate  from Case where Id = : id limit 1];
			caseStatus = caseToBeClosed.Status;
			//AccountName = caseToBeClosed.Account.Name;
			caseNo = caseToBeClosed.CaseNumber; 
			subject = caseToBeClosed.Subject;
			//creationDate = caseToBeClosed.CreatedDate.format();
			if (caseToBeClosed.Status == 'Closed')
				closeAction = true;			
		}		
	}
	
	public void closeCase(){			
		if(caseStatus != 'Closed' && caseToBeClosed.SecurCode__c !=''){
			CaseComment caseComment = new CaseComment();
			caseComment.CommentBody = 'Sag lukket af kunden via link i auto-svar';
			caseComment.parentId = caseToBeClosed.Id;	
			caseToBeClosed.Status = 'Closed';			
			caseStatus = 'Closed';
			//Customer can only close the case once. If he tries again he can see only case details.
			caseToBeClosed.SecurCode__c= '';
			closeAction = true;
			insert caseComment; 
			update caseToBeClosed;					
		}		 		
	}
	
	public Case getCase(){
		return caseToBeClosed;
	}
	static testMethod void testCaseCloseByCustomerController() {
    	Case testCase = new Case();
    	testCase.Subject = '';
    	testCase.Origin = 'Email - kundeservice@yousee.dk';    	
    	insert testCase;   
    	Test.setCurrentPage(Page.CaseCloseByCustomer); 
    	ApexPages.currentPage().getParameters().put('id', testCase.Id);
    	ApexPages.currentPage().getParameters().put('secur', testCase.SecurCode__c);  	
    	ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        clsCaseCloseByCustomerController controller = new clsCaseCloseByCustomerController(sc);
        controller.closeCase();
        system.assertEquals('Closed', controller.getCase().Status);
	 }
}