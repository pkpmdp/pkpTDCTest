//Trigger to update the Account fields based on the Competitor role of Competitors and
//inserting a new record in DeletedCompetitor__c every time a competitor__c gets deleted.


trigger TgrCompetitorAfterinsertAfterupdateBeforeDelete on Competitor__c (after insert, after update, before delete) {
List<Id> AccId= new List<Id>();
Set<id> DeletedIds = new Set<Id>();
List<account> Acctoupdate = new List<account>();
map<Id,string> mapTid = new map<Id,string>();
map<Id,string> mapTV = new map<Id,string>();
List<Competitor__c> compTid = new List<Competitor__c>();
List<Competitor__c> compTV = new List<Competitor__c>();
if(Trigger.isInsert)
  {
    for(Competitor__c competitor: trigger.New)
        {
              If((competitor.Competitor_role__c=='Tidligere leverandør') ||(competitor.Competitor_role__c=='TV/Radio Leverandør'))
                  {
                     
                      If(competitor.Competitor__c !=null)
                          AccId.add(competitor.Customer__c); 
                  }
        }
   }
   

else if(Trigger.isUpdate)
  {
    for(Competitor__c competitor: trigger.New)
        {
              If((competitor.Competitor_role__c=='Tidligere leverandør') ||(competitor.Competitor_role__c=='TV/Radio Leverandør'))
              {
                Competitor__c oldCompetitor = Trigger.oldMap.get(competitor.ID);
                     If((oldCompetitor.Competitor_role__c!= Competitor.Competitor_role__c) || (oldCompetitor.Competitor__c != Competitor.Competitor__c ))
                          {
                           
                           AccId.add(competitor.Customer__c); 
                          }
              }
        }
   }
   
 else if(Trigger.isDelete)
  {
    for(Competitor__c competitor: trigger.Old)
        {
              If((competitor.Competitor_role__c=='Tidligere leverandør') ||(competitor.Competitor_role__c=='TV/Radio Leverandør'))
              AccId.add(competitor.Customer__c);
              DeletedIds.add(competitor.Id);
        }
    }
        
   If(Accid.size()!=0)
     {
     List<Competitor__c> lstCompetitors = new List<Competitor__c>();
     If(Trigger.isinsert || Trigger.isUpdate)
     lstCompetitors = [select id, Competitor_role__c, Customer__c, Competitor__c from Competitor__c where Customer__c IN :AccId and (Competitor_role__c='Tidligere leverandør' or Competitor_role__c='TV/Radio Leverandør')];
     else if(Trigger.isDelete)
        lstCompetitors = [select id, Competitor_role__c, Customer__c, Competitor__c from Competitor__c where Customer__c IN :AccId and Id NOT in :DeletedIds AND (Competitor_role__c='Tidligere leverandør' or Competitor_role__c='TV/Radio Leverandør')]; 
      
   // If Its the last Competitor of matching criteria(list returns null), and after deletion of this, account's both fields should be blank
      if(lstCompetitors.size() == 0)
      {
           for(Competitor__c c: [Select Customer__c From Competitor__c  Where Id IN :deletedIds])
           {
                  Account acc = new Account(Id = c.Customer__c);
                  acc.Tidligere_leverandor__c ='';
                  acc.TV_Radio_Leverandor__c  ='';
                  AcctoUpdate.add(acc);
           }
      }
      Set<Id> setCompetitor = new Set<Id>();
      //setCompetitor.addAll(lstCompetitors);
      for(Competitor__c  c : lstCompetitors){
          setCompetitor.add(c.id);
      
      }
     System.debug('^^^'+setCompetitor);
     // getting value from the list and putting into respective maps based on the matching criteria.
       UpdateAccountsFutureClass.updateAccounts(setCompetitor);
 /*      
      for(Competitor__c competitor : lstCompetitors)
      {
        If(competitor.Competitor_role__c=='Tidligere leverandør' &&  competitor.Competitor__c !=null )
           {
            if(!mapTid.containsKey(competitor.Customer__c))
                mapTid.put(competitor.Customer__c, competitor.Competitor__c);
            else
            mapTid.put(competitor.Customer__c, mapTid.get(competitor.Customer__c)+ ' , ' + competitor.Competitor__c);
          }
        
         else if(competitor.Competitor_role__c=='TV/Radio Leverandør' &&  competitor.Competitor__c !=null ) 
         {
         if(!mapTV.containsKey(competitor.Customer__c))
                mapTV.put(competitor.Customer__c, competitor.Competitor__c);
           else
            mapTV.put(competitor.Customer__c, mapTV.get(competitor.Customer__c)+ ' , ' + competitor.Competitor__c);
                  
         
         }
      }
      set<Id> allAccountIds = new set<Id>();
      allAccountIds.addAll(mapTid.KeySet());
      allAccountIds.addAll(mapTV.KeySet());
     
     // setting the value of account's field from Maps and updating account. 
        
        For(Account acc : [Select Tidligere_leverandor__c,TV_Radio_Leverandor__c  FROM Account WHERE Id IN :allAccountIds])
        {
         acc.Tidligere_leverandor__c ='';
          acc.TV_Radio_Leverandor__c  ='';
        if(mapTid.containsKey(acc.Id))
            acc.Tidligere_leverandor__c = mapTid.get(acc.Id);
        if(mapTV.containsKey(acc.Id))
              acc.TV_Radio_Leverandor__c  = mapTV.get(acc.Id);
        Acctoupdate.add(acc); 
        }
        
       //update Acctoupdate;
      // UpdateAccountsFutureClass.updateAccounts(Acctoupdate[0].TV_Radio_Leverandor__c,Acctoupdate.Tidligere_leverandor__c);
       //database.update(Acctoupdate, false);
   */    
  }
  
  
  // insert a new record in DeletedCompetitor__c every time a competitor__c gets deleted.
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