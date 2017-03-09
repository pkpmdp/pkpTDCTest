public class clsPayerLegalCustomerController {
	public Cable_Unit__c cableUnit {get;set;}
	public boolean hasLegal {get;set;}
	public boolean hasPayer {get;set;}
	private Account account;
	//Constructor
    public clsPayerLegalCustomerController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
        this.account = [Select Cable_Unit__c from Account where Id = : account.Id];
        this.cableUnit = [Select Legal_Account_No__c, Legal_Account_No__r.Name, Legal_Account_No__r.PersonEmail, Legal_Account_No__r.Home_Phone__c, 
        			      Legal_Account_No__r.PersonMobilePhone, Legal_Account_No__r.Phone, Payment_Account_No__c, Payment_Account_No__r.Name, 
        			      Payment_Account_No__r.PersonEmail, Payment_Account_No__r.Home_Phone__c, Payment_Account_No__r.PersonMobilePhone, 
        			      Payment_Account_No__r.Phone from Cable_Unit__c where Id = : account.Cable_Unit__c];
    	hasLegal = false;
    	if(cableUnit.Legal_Account_No__c !=null)
    		hasLegal = true;
    	hasPayer = false;
    	if(cableUnit.Payment_Account_No__c !=null)
    		hasPayer = true;
        
    }
}