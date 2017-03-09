public class clsCallBackCaseOpenController {

	private Account account;
	private Integer casesCount;
	
	public clsCallBackCaseOpenController(ApexPages.StandardController controller) {
		SObject obj = controller.getRecord();
        if (obj.getsObjectType() == Schema.Account.SObjectType) {
            account = (Account) obj;
            casesCount = [SELECT COUNT() FROM Case WHERE 
            // Call_Back__c != NULL
            status IN ('Escalated','More Information Needed','New' ,'Postponed' , 'Re-Opened',
            'Reserved','NP Reserved') AND
            Department__c = 'YOT'  AND           
            isQueueCase__c = 'True' AND AccountId = :account.Id];	
        }
	}
	
	public Boolean getOpenCBCase() {
		return (casesCount != null && casesCount > 0);
	}
	
	public String getOpenCBCaseLabel() {
		if (getOpenCBCase())
			return System.Label.Yes;
		else
			return System.Label.No;
	}
}