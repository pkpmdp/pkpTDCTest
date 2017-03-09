/***********************************************************************************
************************************************************************************

* @class: Yousee13RegisterControllerTestClass
* @version History : 1.0
* @date: 21/01/2013
* @description: Test Class for Yousee13RegisterController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class Yousee13RegisterControllerTestClass {   
   
   		static Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');  
   		static  String campaignId = yousee13.Jylland_Fyn_Campaign__c;
   
	    static testMethod void testPositiveFlow() {
	     	
	     	Address__c addr  = getNewAddresses();        
	        /* Commented as failing in TEST
	        Account account = getNewAccount(); */
	        Account account = getNewAccount1(addr);
	        Contact contact = getNewContact(addr, account); 
	     	
	    	CampaignMember campaign = new CampaignMember(); 
	        campaign.CampaignId = campaignId;
	        campaign.Deltage__c = true;
	        campaign.Bus__c = 'XXXXXX';
	        campaign.show__c = true;
	        campaign.Contact = contact;
	        campaign.ContactId = contact.id;  
	        campaign.Spor__c = '2';
	        insert campaign; 
	        
	    	campaignId = ApexPages.currentPage().getParameters().put('cmid', campaign.id);
	    	Yousee13RegisterController yousee13cntr = new Yousee13RegisterController();
	    	yousee13cntr.updateCampaignStatus();
	    }
    
    	static testMethod void testPositiveFlow2() {
	     	
	     	Address__c addr  = getNewAddresses();        
	         Account account = getNewAccount1(addr);
	        Contact contact = getNewContact(addr, account); 
	     	
	    	CampaignMember campaign = new CampaignMember(); 
	        campaign.CampaignId = campaignId;
	        campaign.Deltage__c = true;
	        campaign.Bus__c = 'XXXXXX';
	        campaign.show__c = true;
	        campaign.Contact = contact;
	        campaign.ContactId = contact.id;  
	        insert campaign; 
	        
	    	campaignId = ApexPages.currentPage().getParameters().put('cmid', campaign.id);
	    	Yousee13RegisterController yousee13cntr = new Yousee13RegisterController();
	    	yousee13cntr.updateCampaignStatus();
	    	yousee13cntr.generateShowTime();
	    }
    
	    static Address__c getNewAddresses(){
            Address__c addr  = new Address__c();      
            addr.Town__c = 'AH';        
            addr.Postcode__c = '421002';        
            addr.Door_No__c = '301';        
            addr.Side__c = 'A';        
            addr.Floor__c = 'Third';        
            addr.House_No__c = 'testData';        
            addr.Street__c = 'AH';        
            addr.Entrance__c = 'A';        
            insert addr;
            return  addr;
	    }
    
    	// Customer No 86788 not exist in TEST failing test Class in TEST -- Change via Inserting an Account
	    static Account getNewAccount(){
            Account account = new Account();        
            account = [Select a.Name, a.Latest_Phase__c, a.Latest_Sales_Type__c,a.Existing_Phase__c, a.Type, a.Cable_Unit_Name__c  From Account a where a.Customer_No__c=: '86788'];
            return account;
	    }
	    
	    static Account getNewAccount1(Address__c addr){
            Account acc = new Account();        
            acc.Name ='test12';        
            acc.Phone = '223223';        
            acc.Email__c = 'abc333@xyz.com';
            acc.Street_YK__c = addr.Id;         
            acc.Street_YK__r = addr;
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
            insert acc;
            return acc;
        }
    
	    static Contact getNewContact(Address__c addr, Account acc){
            Contact contact = new Contact(); 
       		contact.FirstName = 'Martina';
       		contact.LastName = 'Spsehansen';
       		contact.Email = 'Martin112@yahoo.co.in';
       		contact.Phone = '2222221';
       		contact.MobilePhone = '3333331';
       		contact.HomePhone = '444445441';
       		contact.Street_P__c = addr.Id;
       		contact.Account_YS_Live_13__c = acc.Id;
       		contact.KissPartyId__c = 'KAS.P2---4015110456';
       		insert contact;
            return contact;
	    }
}