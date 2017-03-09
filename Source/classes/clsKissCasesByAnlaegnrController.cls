public with sharing class clsKissCasesByAnlaegnrController {

    public List<Opportunity> opptyCaseList{get;set;}
    
    public clsKissCasesByAnlaegnrController(ApexPages.StandardController stdController) {
        Account acct = (Account)stdController.getRecord();
        opptyCaseList = [Select o.id,o.StageName, o.Sales_Type__c, o.Name,o.Exp_Deploy_Date__c, o.Case_Type__c, o.CreatedDate From Opportunity o 
                        where  o.Cable_Unit__c in (Select Cable_Unit__c from Account where id =:acct.Id) ORDER BY o.CreatedDate DESC ];
    }
    
    public List<Opportunity> getOpptyCaseList(){
        return opptyCaseList;
    }
    
    public static testMethod void testController() {
      
      Cable_Unit__c cu = new Cable_Unit__c();
      cu.Name = '12345';
      cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
      cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
      cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
      cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
      cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
      cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
      insert cu;
      
      Account acc = new Account();
      acc.name = 'test account';
      acc.Cable_Unit__c = cu.id;
      acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
      insert acc;
      
      Opportunity opp = new Opportunity();
      opp.Name = 'test Opportunity';
      opp.Cable_Unit__c = cu.id;
      opp.StageName = 'Idrift';
      opp.CloseDate = Date.valueOf('2019-10-22');
      insert opp;
      Apexpages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(acc);
      clsKissCasesByAnlaegnrController controller = new clsKissCasesByAnlaegnrController(stdCtrl);
      System.assertEquals(1, controller.getOpptyCaseList().size());
    }


/**
    private List<Opportunity> cases;
    private Account acc;
    private ApexPages.StandardController controller;
    
    public clsKissCasesByAnlaegnrController(ApexPages.StandardController controller) {
        controller = controller;
        acc = (Account) controller.getRecord();
        acc = [Select Cable_Unit__c from Account where id =: acc.id limit 1];
    }
    
    public List<Opportunity> getCases() {
     System.debug('account cable Unit'+acc.Cable_Unit__c);
     if(acc.Cable_Unit__c != null)   
         cases = [Select o.StageName, o.Sales_Type__c, o.Name, o.Exp_Deploy_Date__c, o.CloseDate, o.Case_Type__c, o.Cable_Unit__c From Opportunity o where o.Cable_Unit__c =: acc.Cable_Unit__c];
     return cases;   
    }
    
    public static testMethod void testController() {
        Cable_Unit__c cu = new Cable_Unit__c();
        cu.Cable_Unit_No__c = '12345';
        insert cu;
        Account acc = new Account();
        acc.name = 'test account';
        acc.Cable_Unit__c = cu.id;
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.Cable_Unit__c = cu.id;
        opp.StageName = 'Idrift';
        opp.CloseDate = Date.valueOf('2019-10-22');
        insert opp;
        Apexpages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(acc);
        clsKissCasesByAnlaegnrController controller = new clsKissCasesByAnlaegnrController(stdCtrl);
        System.assertEquals(1, controller.getCases().size());
    }
*/
}