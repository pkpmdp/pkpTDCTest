/*********************************************************
*	trigger trigCustomerSubscription_BeforeInsertUpdate
*
*	Created for Oasis-49
*	This is used to determine the Customer, Address and Product
*	records for the corresponding customer number, address ams id
*	and varenummer respectively.
*
*********************************************************/

trigger trigCustomerSubscription_BeforeInsertUpdate on Customer_Subscription__c (before insert, before update) {
	Set<String> setCustomerNo = new Set<String>();
	Set<String> setAmsId = new Set<String>();
	Set<String> setVarenummer = new Set<String>();
	List<Customer_Subscription__c> listCustomerSubscription = new List<Customer_Subscription__c>();				
	
	
	for(Customer_Subscription__c cs: trigger.new) {
		listCustomerSubscription.add(cs);
		setCustomerNo.add(cs.Customer_Number__c);
		setAmsId.add(cs.Address_AMS_Id__c);
		setVarenummer.add(cs.Varenummer__c);
	}
	
	// get the related customer records in map
	Map<String, String> mapCustomer = new Map<String, String>();							//key=customerNo, value = account Id
	for(Account a: [select Id, Customer_No__c from Account where Customer_No__c in :setCustomerNo]) {
		mapCustomer.put(a.Customer_No__c, a.Id);
	}
	
	// get the related Address records
	Map<String, String> mapAddress = new Map<String, String>();
	for(Address__c a: [select Id,external_id__c  from address__c where external_id__c in :setAmsId]) {
		mapAddress.put(a.external_id__c, a.Id);
	}
	
	// get the related product records
	Map<String, String> mapProducts = new Map<String, String>();
	for(Product__c p: [select Id, Product_ID__c from Product__c p where p.Product_ID__c in :setVarenummer]) {
		mapProducts.put(p.Product_ID__c, p.Id);
	}
	
	// loop over customer sibscription, and get 
	// references from the above maps
	for(Customer_Subscription__c cs: listCustomerSubscription) {
		cs.Customer__c = mapCustomer.get(cs.Customer_Number__c);
		cs.Address__c = mapAddress.get(cs.Address_AMS_Id__c);
		cs.Product__c = mapProducts.get(cs.Varenummer__c); 
	}
	

}