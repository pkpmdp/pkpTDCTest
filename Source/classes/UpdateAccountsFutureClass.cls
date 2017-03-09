global class UpdateAccountsFutureClass {



  @future 
  Public static void updateAccounts(SET<Id> listComp) {
       System.debug('##Before Update#'+listComp);
       List<Id> AccId= new List<Id>();
       Set<id> DeletedIds = new Set<Id>();
       List<account> Acctoupdate = new List<account>();
       map<Id,string> mapTid = new map<Id,string>();
       map<Id,string> mapTV = new map<Id,string>();
       List<Competitor__c> compTid = new List<Competitor__c>();
       List<Competitor__c> compTV = new List<Competitor__c>();
       
       List<Competitor__c> lstCompetitors= [select id, Customer__c,Competitor__c,Competitor_role__c from Competitor__c where id IN: listComp ];
       
       for(Competitor__c competitor : lstCompetitors){
        If(competitor.Competitor_role__c=='Tidligere leverandør' &&  competitor.Competitor__c !=null ){
            if(!mapTid.containsKey(competitor.Customer__c))
                mapTid.put(competitor.Customer__c, competitor.Competitor__c);
            else
                mapTid.put(competitor.Customer__c, mapTid.get(competitor.Customer__c)+ ' , ' + competitor.Competitor__c);
        }else if(competitor.Competitor_role__c=='TV/Radio Leverandør' &&  competitor.Competitor__c !=null ) {
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
        
        For(Account acc : [Select Tidligere_leverandor__c,TV_Radio_Leverandor__c  FROM Account WHERE Id IN :allAccountIds]){
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
       database.update(Acctoupdate, false);
       System.debug('##Before Update#'+Acctoupdate);
    
  }
}