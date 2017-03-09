public with sharing class ActiveErrorsController {
  // current customer ID (from URL)
  private String idCustomer;
  // list of sObjects from DB
  private List<ActiveErrors__c> lst;
  
  // constructor
  public ActiveErrorsController(ApexPages.StandardController controller) {
    Map<String, String> mapParams = ApexPages.currentPage().getParameters();       
    if (mapParams.containsKey('CustomerId')){
      this.idCustomer = mapParams.get('CustomerId');
    }
  }
  
  // returns a list of records
  public List<ActiveErrors__c> getItems() {
    if (this.lst == null) {
      this.lst = [SELECT Id, ActiveErrorId__c, Name, Dot__c, Prio__c, PostCode__c, Address__c, Created__c, HF_number__c, Subject__c, ReachTime__c, Created_By__c, Technique__c, KKIB__c, Status__c FROM ActiveErrors__c WHERE Customer__c = :this.idCustomer];
    }
    return this.lst;
  }
  
  // get URL to BIER system
  public String getBierUrl(){
    return OperativeTroubleshootingController.BIER_URL_AE;
  }
  
  // Unit Test method
  static testMethod void testOperativeTroubleshootingController(){
 	Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = '0000');
    insert add;
        
    Account acc = new Account(Name = 'Test Account 1', Customer_No__c = '123456789', Street_YK__c = add.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
    insert acc;
    
    ActiveErrors__c ae1 = new ActiveErrors__c(Customer__c = acc.Id, Name = '1');
    ActiveErrors__c ae2 = new ActiveErrors__c(Customer__c = acc.Id, Name = '2');
    ActiveErrors__c ae3 = new ActiveErrors__c(Customer__c = null, Name = '3');
    insert new ActiveErrors__c[]{ae1, ae2, ae3};
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', acc.Id);
    
    // constructor
    ActiveErrorsController ctrl = new ActiveErrorsController(new ApexPages.StandardController(acc));
    
    // check getBierUrl
    system.assert(ctrl.getBierUrl() == OperativeTroubleshootingController.BIER_URL_AE);
    
    // check getItems
    List<ActiveErrors__c> lst = ctrl.getItems();
    system.assert(lst != null && lst.size() == 2);
  }
}