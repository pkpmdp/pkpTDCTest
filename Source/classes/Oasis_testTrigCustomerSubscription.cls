/**
*  TestClass for trigger on Customer Subscription
  
*
 */
@isTest
private  class Oasis_testTrigCustomerSubscription {
  
   static testmethod void invokeTrigger(){
    Product__c prod = setDummyProduct();
      Address__c addr = setupDummyAddress();
      Cable_Unit__c cu = setupCableUnit();
      Net_Installations__c installation = setupDummyInstallation(addr, cu);
    Customer_Subscription__c cs = setupDummyCustomerSubscription(addr, installation, prod);
  }
  
  
  
  // Creating Test Data
  
   static Product__c setDummyProduct(){
      Product__c prod = new Product__c();
        prod.Name = 'Lille Tillægspakke';
        prod.Product_ID__c = '12345';
        insert prod;
        return prod;
    }
    
     static Address__c setupDummyAddress()
    {
       Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
      return addr;
    }
    
      static Cable_Unit__c setupCableUnit() {
        
        Lookup_Post_Code__c postcodeLookup;
        String postcode = '2000';
        
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;  
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_Post_Code__c = postcode;
        cableUnitTest.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cableUnitTest.Segment__c = '5';
        insert cableUnitTest;   
        return cableUnitTest;
        
    }
    
     static Net_Installations__c setupDummyInstallation(Address__c addr, Cable_Unit__c cu)
    {
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = addr.id;
        installation.Address__c = addr.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        installation.INSTALLATION_ID__c = '123456';
        insert installation;
        return installation;
    }
  static Customer_Subscription__c setupDummyCustomerSubscription(Address__c addr, Net_Installations__c inst,Product__c prod)
    {
      Customer_Subscription__c cs = new Customer_Subscription__c();
      cs.Address__c = addr.Id;
      cs.Product__c = prod.Id;
      cs.Installation_Id__c = inst.installation_id__c;
      
      insert cs;
      return cs;
    }
}