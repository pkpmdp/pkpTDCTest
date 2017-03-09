// This trigger has been merged with another trigger name as 'tgrCompetitorAfterinsertAfterupdateBeforeDelete'.
// insert a new record in DeletedCompetitor__c every time a competitor__c gets deleted.
Trigger TgrCompetitorBeforeDelete on Competitor__c (before delete) {
   if (Trigger.isDelete){
  List<DeletedCompetitor__c> deletedRecords = new List<DeletedCompetitor__c>();
  
 
    for(Competitor__c competitor: trigger.old){
      DeletedCompetitor__c deletedcomp = new DeletedCompetitor__c();
      deletedcomp.CompetitorID__c = competitor.Id;
      deletedcomp.Customer__c = competitor.customer__c;
      deletedcomp.Competitor_role__c = competitor.Competitor_role__c;
      deletedcomp.Competitor__c = competitor.Competitor__c;
      deletedRecords.add(deletedcomp);
     }  
  
  
  //Update database with deleted competitors
    if(deletedRecords.size() != 0) {
        Database.SaveResult[] resultsAccount = Database.insert(deletedRecords);
        }
   }
}