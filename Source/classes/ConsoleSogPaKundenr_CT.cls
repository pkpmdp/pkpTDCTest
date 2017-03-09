public with sharing class ConsoleSogPaKundenr_CT {

	public Id strAccountId {get;set;}
	public String strAccountName {get;set;}
	public String strSearchKunde{get;set;}
	public List<Cable_Unit__c> cables{get;set;}
	public List<Account> accounts{get;set;}
	public String strErrMessage {get;set;}
	public Boolean blnErrMessage{get;set;}
	public ConsoleSogPaKundenr_CT(){
		
		//strAccountId = '';
		strSearchKunde = '';
		strAccountName = '';
		cables = new List<Cable_Unit__c>();
		accounts = new List<Account>();
		strErrMessage = '';
		blnErrMessage = false;
	}
	
	public pagereference btnSearch(){
		
			strSearchKunde = strSearchKunde.trim();
	        /*while (strSearchKunde.length() < 10) {
	                
	            strSearchKunde = '0' + strSearchKunde;
	        }*/
	        strErrMessage = '';
	        system.debug('ghjggj'+strSearchKunde);
			//cables = [Select c.Cable_Unit_No__c, (Select Id,Name, From Accounts__r) From Cable_Unit__c c where c.Cable_Unit_No__c=: strSearchKunde];
	        accounts = [Select Id,Name,Customer_No__c From Account where Customer_No__c =:strSearchKunde];
	        if(!accounts.isEmpty()) {
	    		system.debug('ghjggjvvvvv'+accounts);
	    		strAccountId = accounts[0].id;
	    		strAccountName = accounts[0].name;
	    	} 
	    	else {
	    		strErrMessage = 'Der findes desværre ingen kunder med dette Kundenr i Salesforce';
	    		blnErrMessage = true;
	            return null; 
	    	}
	        
	   return null;
    }
		
}