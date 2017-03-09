public with sharing class CableUnitLink {
    Address__c address;
    list<Cable_Unit__c> listCLUnit;
    public integer listSize{get; set;}
    list<Cable_Unit__c> cableUnits=new list<Cable_Unit__c>();
    public CableUnitLink(ApexPages.StandardController controller) {
        address = (Address__c) controller.getRecord();
        address = [SELECT Id, Name, Cableunit_number__c FROM Address__c WHERE Id=:address.Id];
        system.debug('che'+address);
        listCLUnit = getCableUnitList();
        //<!-- <apex:outputLink value="{!link}" id="theLink">{!Address__c.Cableunit_number__c}</apex:outputLink>    -->
        
    }
        
    public List<Cable_Unit__c> getCableUnitList(){
        
    	List<string> listformattedCableUnits = formatCableUnits(); // SPOC-2241
    	List<string> listFinalCableUnit = new list<string>();
    	if(listformattedCableUnits.size()==0)        // SPOC-2241
    	{
    		return null;
    	}
       
         cableUnits = [select id,Cable_Unit_No__c from Cable_Unit__c where 
            Cable_Unit_No__c in : listformattedCableUnits ];
            
        if (cableUnits.size()==0){
            return null;
        } 
    
        listSize = cableUnits.size();
        return cableUnits;
    
        
       // return ((Cable_Unit__c)cableUnits.get(0)).Id;
          
    }
    // SPOC-2241
    public list<string> formatCableUnits()
    {
    	list<string> listCableUnits = new list<string>();
    	Boolean isContainComma;
      
        if(address != null && address.Cableunit_number__c != null){
            system.debug('check1');
    		isContainComma = address.Cableunit_number__c.contains(',');
       
    	if(isContainComma)
    	{
    		listCableUnits = address.Cableunit_number__c.split(',');
    	}
    	else
    	{
    		listCableUnits.add(address.Cableunit_number__c);
    	}
    }
       
      
    	return listCableUnits;
    
    }
    
    /*public PageReference getLink(){
        if (listCLUnit.size() > 0) return null;
        return new PageReference('/'+ id);      
    }  */  
    
    public Boolean getExistLink(){
        if (listCLUnit == NULL|| listCLUnit.size() == 0 ) 
            return false;
        return true;        
    } 

    
    /*
    static testMethod void testLinkWithNull(){
        Address__c add = new Address__c(Street__c = 'TestingMain Street',
            Town__c = 'TestingLeeds', Postcode__c = 'TestingLS1');
        add.Cableunit_number__c = '0001';
        insert add;
        ApexPages.StandardController sc = new ApexPages.StandardController(add);
        CableUnitLink controller = new CableUnitLink(sc);
        system.assert(null == controller.getLink());        
    }*/

    static testMethod void testLinkWithRecord(){
        /*Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        add.Cableunit_number__c = '222';
        insert add;
        
        Cable_Unit__c cabUnit = new Cable_Unit__c();
        cabUnit.Name = 'cu_kundeCust_testing'; 
        cabUnit.Cable_Unit_No__c = '222';
        cabUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cabUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cabUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cabUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cabUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cabUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cabUnit;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(add);
        CableUnitLink controller = new CableUnitLink(sc);
        PageReference expectedPage = new PageReference('/'+ cabUnit.Id);       
  //      system.assert(expectedPage.getUrl() == ((PageReference)controller.getLink()).getUrl());    
        //controller.getExistLink();
        controller.getLink();
         controller.getExistLink();*/
        
    }
    

}