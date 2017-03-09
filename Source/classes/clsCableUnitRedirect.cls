public with sharing class clsCableUnitRedirect {
    public clsCableUnitRedirect(){
        cableUnitNo = ApexPages.currentPage().getParameters().get('cableUnitNo');
    }
    
    public String cableUnitNo;
    
    public PageReference redirectToCableUnit(){
        PageReference pageReference = null;
        List<Cable_Unit__c> cuList = [select id from Cable_Unit__c where Cable_Unit_No__c=:cableUnitNo];
        if(cuList.size()>0){
            pageReference = new PageReference('/'+cuList[0].Id);
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cable Unit '+cableUnitNo+' not found.')); 
        }
        return pageReference;
    }
    
    static testMethod void testRedirectToCableUnit() {
        clsCableUnitRedirect controller = new clsCableUnitRedirect();
        controller.cableUnitNo='Not existing CU Number';
        System.assertEquals(null,controller.redirectToCableUnit());
        String TEST_CABLE_UNIT_NO='12345';
        
        Cable_Unit__c testCableUnit = new Cable_Unit__c();
        testCableUnit.Name = 'YS test';
        testCableUnit.Cable_Unit_No__c = TEST_CABLE_UNIT_NO;
        testCableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        testCableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        testCableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        testCableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        testCableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                    
        testCableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert testCableUnit;
        
        controller.cableUnitNo = TEST_CABLE_UNIT_NO;
        System.assert(controller.redirectToCableUnit()!=null);
    }
 
    
}