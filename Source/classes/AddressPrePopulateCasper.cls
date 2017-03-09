public with sharing class AddressPrePopulateCasper {
		
		public Address__c Address1{get;set;} 
		public String addressId {get;set;}
		public String address {get;set;}
		public List<Net_Installations__c> netInst {get;set;}
		
		public AddressPrePopulateCasper(ApexPages.StandardController controller) {
			Address1 = (Address__c) controller.getRecord();
			addressId = Address1.Id;
			address = Address1.Street__c;
			netInst = [select Name,Id,Start_Date__c, Status__c,INSTALLATION_ID__c, Cable_Unit_No__c,Cable_Unit__c, Address__c,Location__c from Net_Installations__c where Address__c=:addressId];
		}

		public AddressPrePopulateCasper(){
			addressId = ApexPages.CurrentPage().getParameters().get('addressId');
			address = ApexPages.CurrentPage().getParameters().get('address');
			netInst = [select Name,Id,Start_Date__c, Status__c,INSTALLATION_ID__c, Cable_Unit_No__c,Cable_Unit__c, Address__c,Location__c from Net_Installations__c where Address__c=:addressId];
		}

		public PageReference sendToCasper(){
			PageReference pf;
			Id selectedAddressId = ApexPages.currentPage().getParameters().get('selectedAddressId');
			if(netInst!=null && netInst.size()>1){
				 Net_Installations__c inst = [select Start_Date__c,INSTALLATION_ID__c from Net_Installations__c where id=:selectedAddressId];
				 Datetime dt = inst.Start_Date__c;
				 clsCasperButton.sendToCasperAddressInstallationId(addressId, inst.INSTALLATION_ID__c, inst.Start_Date__c);
			}
			pf = new PageReference('/'+addressId);
			return pf;
		} 
		
		public PageReference redirectPageToStandard(){
			PageReference pf;
			if(netInst!=null && netInst.size()>1){
				return null;
			}else if(netInst!=null && netInst.size()==1){
				clsCasperButton.sendToCasperAddressInstallationId(addressId, netInst[0].INSTALLATION_ID__c, netInst[0].Start_Date__c);
			}
			else{
				clsCasperButton.sendToCasperAddressInstallationId(addressId, null, null);
			}
			pf = new PageReference('/'+addressId);
			return pf;
		} 
}