trigger attachmentsRollUp on Attachment (after insert, after update, after delete, after undelete) {
    
    //Subset of attachment ids
    Set<Id> setAtachmentIds = new Set<Id>();
    
    //List to contain the final list of News Article to be updated
    List<NewsArticle__c> listNewsArtiToBeUpdated = new List<NewsArticle__c>();
    
    //Map will contain one News Article Id to totsl count of Notes attached to it
    Map<Id, Double> mapNewsArti = new Map<Id, Double>();
    
    //Initial all values for all News Articles in Trigger.new (inserts, updates, undeletes)
    //Set all map values to 0, so we can begin making summaries in the next step
    if(Trigger.isupdate || Trigger.isInsert || Trigger.isUndelete){
        for(Attachment a : Trigger.new){
            //Initialize count for Notes for News Articles
            setAtachmentIds.add(a.ParentId);
            mapNewsArti.put(a.ParentId, 0);                      
        }
    }else if(Trigger.isDelete){
        for(Attachment a : Trigger.old){
            //Initialize counnt for Notes for News Articles
            setAtachmentIds.add(a.ParentId);
            mapNewsArti.put(a.ParentId, 0);
        }
    }
    
    //Start counting Notes for News Articles currently existing in the database
    for(Attachment a : [SELECT Id, ParentId, IsDeleted, Name FROM Attachment WHERE ParentId IN :setAtachmentIds AND
                  IsDeleted = False ALL ROWS]){
        mapNewsArti.put(a.ParentId, mapNewsArti.get(a.ParentId) + 1);      
    }
    
    //Put all affected News Articles in a list of News Articles to update
    for(NewsArticle__c l : [SELECT Id, Name, Number_of_Attachments__c, IsDeleted 
                  FROM NewsArticle__c WHERE Id IN : setAtachmentIds AND
                  IsDeleted = False ALL ROWS]){
        l.Number_of_Attachments__c = mapNewsArti.get(l.id);
        
        listNewsArtiToBeUpdated.add(l);
    }
    
    update listNewsArtiToBeUpdated;    
}