public with sharing class AnlaegNumberSearchController {

    Public String anlaegNumber{get;set;}
    Public List<Account> accounts{get;set;}
    Public List<Cable_Unit__c> cables{get;set;}
    
    
    Public AnlaegNumberSearchController(ApexPages.StandardController standardController){
        
        anlaegNumber = ApexPages.currentPage().getParameters().get('AnlaegNumber');
        while (anlaegNumber.length() < 10) {
            anlaegNumber = anlaegNumber.trim();    
            anlaegNumber = '0' + anlaegNumber;
        }
    }
    
    
    
    Public PageReference showAccount(){
            cables = [Select c.Cable_Unit_No__c, (Select Id From Accounts__r) From Cable_Unit__c c where c.Cable_Unit_No__c=: anlaegNumber];
            if(cables.size() > 0) {
              accounts = cables[0].Accounts__r;
              if(accounts.size()>0){
                return new PageReference('/' + accounts[0].Id);
              } else {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette anlægsnummer i Salesforce'));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette Kundenr i Salesforce'));
                    return null; 
              }
            } else {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette Kundenr i Salesforce'));
                                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette anlægsnummer i Salesforce'));
                    return null;  
            }
    }
    
    public static testMethod void testAnlaegNumberSearchController() {
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Cable_Unit_No__c = '0001234567';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        insert cableUnit;
        
        Account acc = new Account();
        acc.name = 'test';
        acc.Cable_Unit__c = cableUnit.id;
        acc.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        PageReference prf = Page.AnlaegNumberSearch;
        prf.getParameters().put('AnlaegNumber', '1234567'); 
        Test.setCurrentPage(prf);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        AnlaegNumberSearchController controller = new AnlaegNumberSearchController(stdController); 
        System.assertEquals('0001234567', controller.anlaegNumber);     
        System.assertNotEquals(null, controller.showAccount());
    }

}