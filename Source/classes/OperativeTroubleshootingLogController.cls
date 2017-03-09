public with sharing class OperativeTroubleshootingLogController {
    //
    private transient List<Operative_Troubleshooting_Log__c> logs;
    
  // constructor
  public OperativeTroubleshootingLogController(ApexPages.StandardController controller) {
    this.logs = new List<Operative_Troubleshooting_Log__c>([SELECT Id, Date__c, Comment__c, Name FROM Operative_Troubleshooting_Log__c WHERE Operative_Info__c = : controller.getId() ORDER BY Id DESC]);
  }
  
  // Initialize setCon and return a list of records
  public List<Operative_Troubleshooting_Log__c> getLogs() {
    return this.logs;
  }  
  
  // Unit Test method
  static testMethod void testOperativeTroubleshootingLogController(){
    // create testing data
    Operative_Troubleshooting__c ot = new Operative_Troubleshooting__c();
    insert ot;
                        
    Operative_Troubleshooting_Log__c log1 = new Operative_Troubleshooting_Log__c(Operative_Info__c = ot.Id, Date__c = DateTime.valueOf('2010-10-08 14:21:00'), Name = 'Jesper Aamand Enevoldsen', Comment__c = 'Status skiftet til Bekræftet.');
    insert log1;
    
    Operative_Troubleshooting_Log__c log2 = new Operative_Troubleshooting_Log__c(Operative_Info__c = ot.Id, Date__c = DateTime.valueOf('2010-10-08 14:21:00'), Name = 'Jesper Aamand Enevoldsen', Comment__c = 'opdaterede forventet varighed til "2010-10-08 15:00".opdaterede næsten opdatering med 1 time(r).');
    insert log2;
    
    // create controller
    OperativeTroubleshootingLogController ctrl = new OperativeTroubleshootingLogController(new ApexPages.StandardController(ot));    
    
    // check getLogs method
    List<Operative_Troubleshooting_Log__c> logs = ctrl.getLogs();
    system.assert(logs != null && logs.size() == 2);
    
    // check results
    for(Operative_Troubleshooting_Log__c log : logs){
      system.assert(log.Date__c == DateTime.valueOf('2010-10-08 14:21:00'));
      system.assert(log.Name == 'Jesper Aamand Enevoldsen');
      system.assert(log.Comment__c != null && log.Comment__c.length() > 0);
    }
  }
}