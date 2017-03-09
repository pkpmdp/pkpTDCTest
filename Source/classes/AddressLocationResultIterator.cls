global class AddressLocationResultIterator implements Iterator<AggregateResult> {
   AggregateResult [] results {get;set;}
   // tracks which result item is returned
   Integer index {get; set;} 
         
   global AddressLocationResultIterator() {
      index = 0;
      // Fire query here to load the results
     // String query = 'SELECT count(Name), Address__c FROM Net_Installations__c where location__c != null group by Address__c having count(Name) > 1'; // commented for SPOC-1472 
      String query = 'SELECT count(Name), Address__c FROM Net_Installations__c where location__c != null and Address__c!=null group by Address__c';
      results = Database.query(query);            
   } 
   
   global boolean hasNext(){ 
      return results != null && !results.isEmpty() && index < results.size(); 
   }    
   
   global AggregateResult next(){        
      return results[index++];            
   }       
}