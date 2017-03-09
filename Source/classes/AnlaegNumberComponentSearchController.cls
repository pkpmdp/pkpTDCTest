public  class AnlaegNumberComponentSearchController {

    Public String anlaegNumber{get;set;}
    Public List<Account> accounts{get;set;}
    Public List<Cable_Unit__c> cables{get;set;}
    Public String accountid {get;set;}
    Public String result {get;set;}
    Public String cunumber{get; set;}
    
    Public AnlaegNumberComponentSearchController(ApexPages.StandardController standardController){
        
        anlaegNumber = ApexPages.currentPage().getParameters().get('AnlaegNumber');
        while (anlaegNumber.length() < 10) {
            anlaegNumber = anlaegNumber.trim();    
            anlaegNumber = '0' + anlaegNumber;
        }
    }
    
    Public AnlaegNumberComponentSearchController(){
        
       /* anlaegNumber = ApexPages.currentPage().getParameters().get('AnlaegNumber');
        if(anlaegNumber != null){
                while (anlaegNumber.length() < 10) {
                        anlaegNumber = anlaegNumber.trim();    
                        anlaegNumber = '0' + anlaegNumber;
                }
         } */
    }
    
    Public void showAccount(){
             System.debug('## inside showAccount');
            //anlaegNumber = Apexpages.currentPage().getParameters().get('firstparam');
           // System.debug('dispalyin parameter' + Apexpages.currentPage().getParameters().get('firstparam'));
            //System.debug('analeg number@@@@@@@' + anlaegNumber  );
            System.debug('cunumber@@@@'   + cunumber);
            //anlaegNumber ='0995043458';
            anlaegNumber =cunumber;
        System.debug('anlaegNumber***************'   + anlaegNumber);
            if(anlaegNumber != null){
                            while (anlaegNumber.length() < 10) {
                                    anlaegNumber = anlaegNumber.trim();    
                                    anlaegNumber = '0' + anlaegNumber;
                            }
                 }
            System.debug('analeg number222222222' + anlaegNumber  );
            cables = [Select c.Cable_Unit_No__c, (Select Id From Accounts__r) From Cable_Unit__c c where c.Cable_Unit_No__c=: anlaegNumber];
        system.debug('cables********'+cables);
            if(cables.size() > 0) {
              accounts = cables[0].Accounts__r;
              if(accounts.size()>0){
                accountid = accounts[0].Id;
                System.debug('accountid@@@@' + accountid ); 
                result = 'positive';
                System.debug('Result#####'+ result);
                //return new PageReference('https://cs7.salesforce.com/'+ accounts[0].Id);
              } else {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette Kundenr i Salesforce'));
                    result = 'negative';
                    //return null; 
              }
            } else {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Der findes desværre ingen kunder med dette Kundenr i Salesforce'));
                    result ='negative';
                    //return null;  
            }
    }
    
    /*public static testMethod void testAnlaegNumberSearchController() {
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
    } */

}