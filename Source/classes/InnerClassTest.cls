@isTest
private class InnerClassTest {

    static testMethod void myUnitTest() {
    	
    	Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301'; 
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
    	
        Product pro = new Product();
        DealerCustomerPOJO dealerPojo = new DealerCustomerPOJO();
        ProductForDisplay pro_offer = new ProductForDisplay();
        ProductOfferWrapper pro_offer_wrapr = new ProductOfferWrapper();
        cCustomerInstallationAddress cCust = new cCustomerInstallationAddress();
        cCust.addr = addr;
        cCust.getAddr1();
        cCust.getAddr2();
    }
}