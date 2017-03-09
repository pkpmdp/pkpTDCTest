public with sharing class ActiveActivitiesController{
  // current customer ID (from URL)
  private String idCustomer;
  // list of sObjects from DB
  private List<ActiveActivities__c> lst;
  
  // constructor
  public ActiveActivitiesController(ApexPages.StandardController controller) {
    Map<String, String> mapParams = ApexPages.currentPage().getParameters();       
    if (mapParams.containsKey('CustomerId')){
      this.idCustomer = mapParams.get('CustomerId');
    }
  }
  
  // returns a list of records

  public List<ActiveActivities__c> getItems() {
    if (this.lst == null){
        this.lst = [SELECT Id, Name, ActiveActivityID__c, Dot__c, Res_type__c, Customer_no__c, Address__c, PostCode__c, Recieved__c, Planned__c, Product__c, Worktype__c, Info__c, Note__c, Cabletype__c, Transferred_to_Bier__c FROM ActiveActivities__c WHERE Customer__c = :this.idCustomer];
    }
    return this.lst;
  }

  // get URL to BIER system page
  public String getBierUrl(){
    return OperativeTroubleshootingController.BIER_URL_AA;
  }
  
  // Unit Test method
  static testMethod void testOperativeTroubleshootingController(){
    // create testing data    
    Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = '0000');
    insert add;
    
    
        
    Account acc = new Account(Name = 'Test Account 1', Customer_No__c = '123456789', Street_YK__c = add.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
    insert acc;
    
    ActiveActivities__c aa1 = new ActiveActivities__c(Customer__c = acc.Id, Name = '1');
    ActiveActivities__c aa2 = new ActiveActivities__c(Customer__c = acc.Id, Name = '2');
    ActiveActivities__c aa3 = new ActiveActivities__c(Customer__c = null, Name = '3');
    insert new ActiveActivities__c[]{aa1, aa2, aa3};
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('CustomerId', acc.Id);
    
    // constructor
    ActiveActivitiesController ctrl = new ActiveActivitiesController(new ApexPages.StandardController(acc));
    
    // check getBierUrl
    system.assert(ctrl.getBierUrl() == OperativeTroubleshootingController.BIER_URL_AA);
    
    // check getItems
    List<ActiveActivities__c> lst = ctrl.getItems();
    system.assert(lst != null && lst.size() == 2);
  }
}