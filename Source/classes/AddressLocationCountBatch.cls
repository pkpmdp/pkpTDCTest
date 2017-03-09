global class AddressLocationCountBatch implements Database.Batchable<AggregateResult>{
   
  public String query;
  public Map<ID, Decimal> addrLocationMap{get;set;}
 
   /**
    * @description: This method is used to initialize and execute the Query.
    * @param: Database.BatchableContext.
    * @return: Database.QueryLocator.
    */
  /* global Database.QueryLocator start(Database.BatchableContext BC){
     try{
      
      query = 'SELECT count(Name), Address__c FROM Net_Installations__c where location__c != null group by Address__c having count(Name) > 1';
        return Database.getQueryLocator(query);
     }
     catch(Exception e){
       CarrieLog.LogException(e);
       return null; 
     }
   } */

   global Iterable<AggregateResult> start(Database.BatchableContext info){
        
        return new AddressLocationResultIterable();
    }



   /**
    * @description: This method is used to perform the batch update operation.
    * @param: Database.BatchableContext, scope.
    */
    
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   try{
   system.debug('batch record size: '+scope.size());
    if(scope.size()>0){
        List<Address__c> addr = new List<Address__c>();
     for(sObject sob : scope){
         AggregateResult a = (AggregateResult) sob;
         Address__c add1 = new Address__c();
         add1.Id = (ID)a.get('Address__c');
         add1.Location_Count__c = Integer.valueOf(a.get('expr0'));
         addr.add(add1);
     }

    update addr;
    } 
    }
    catch(Exception e){
    System.debug('Exception in exec in AddressLocationCountBatch: '+e.getMessage());
    }
   }
      
    /**
    * @description: This method is used to perform the final notification like sending email, logging etc.
    * @param: Database.BatchableContext.
    */
   global void finish(Database.BatchableContext BC){
    system.debug('Job AddressLocationCountBatch ID is ----------'+BC.getJobId());
   }
   
      
   /**
    * @description: This method is used to Test AddressLocationCountBatch class.
    */
   public static testMethod void testExecuteBatch(){
    Test.startTest();
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
        Lookup_Post_Code__c postcodeLookup;
        String postcode = '2000';
        
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;
		Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        //cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Segment__c = '5';
        insert cableUnitTest;     
        Net_Installations__c installation = new Net_Installations__c();
	    installation.Address_Id__c = addr.id;
	    installation.Address__c = addr.id;
	    installation.Cable_Unit__c = cableUnitTest.Id;
	    installation.AddressId_InstLbnr__c = '1';
	    installation.INSTALLATION_ID__c = '456789';
	    installation.Location__c = 'abc';
	    insert installation;
	    AddressLocationResultIterator addLoc = new AddressLocationResultIterator();
	    AddressLocationResultIterable addRL = new AddressLocationResultIterable();
	    AddressLocationCountBatch countbatch= new AddressLocationCountBatch(); 
	    Database.executeBatch(countbatch);
    Test.stopTest();    
   }
}