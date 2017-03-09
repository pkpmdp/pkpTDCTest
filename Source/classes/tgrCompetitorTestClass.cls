@isTest
public class tgrCompetitorTestClass{
  
  static testMethod void testCompetitors() {
        
     // Inserting an account
     
      Account parentAcc = new Account();
      parentAcc.Name = 'testData_customer';
      parentAcc.Type = 'Hierarki';
      parentAcc.RecordTypeId = '012200000000o7ZAAQ';
      parentAcc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
      insert parentAcc;
      
    // Inserting few Competitors    
      Competitor__c competitor = new competitor__c();
      competitor.Competitor_role__c= 'TV/Radio Leverandør';
      competitor.Competitor__c='AFIK';
      competitor.Customer__c= parentAcc.id;
      insert competitor;
      
      
      Competitor__c competitor1 = new competitor__c();
      competitor1.Competitor_role__c= 'Tidligere leverandør';
      competitor1.Competitor__c='Boxer';
      competitor1.Customer__c= parentAcc.id;
      insert competitor1;
     
    
      
    // Deleting competitors
      delete competitor;
      delete competitor1;
        
      
  }
}