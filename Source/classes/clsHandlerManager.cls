public class clsHandlerManager {

/* KM: Original version of the takeOwnership(Map<Id, Case> casesMap) method
    Public static void takeOwnership(Map<Id, Case> casesMap){
        
        List<Case> cases = [Select Id, ownerId, owner.Name from Case where Id IN :casesMap.keySet()];
        
        List<Handler__c> insertHandlers = new List<Handler__c>();
        for(Case case2:cases){
            
            Handler__c handler = new Handler__c();
            handler.case__c = case2.Id;
            handler.userId__c = case2.ownerId;
            handler.UserName__c = case2.owner.Name;
            handler.externalkey__c = handler.case__c + handler.userId__c;
            handler.OwnershipTakenTimeStamp__c = DateTime.now();
            
            insertHandlers.add(handler);
        }
        
        if(insertHandlers.size() > 0){
            
            Database.insert(insertHandlers);
                
        }

    }
*/
    public static void takeOwnership(Map<Id, Case> casesMap) {
        // Select required Case data
        List<Case> cases = [
            SELECT Id, OwnerId, Owner.Name, isClosed,
                CreatedDate, Department__c, Product_2__c, Status, Type_Task__c
            FROM Case WHERE Id IN :casesMap.keySet()
        ];

        // Collect owner role names
        Set<Id> userIds = new Set<Id>();
        Map<Id,String> userIdToRoleName = new Map<Id,String>();
        // Collect unreleased handlers external keys
        Set<String> allExtKeys = new Set<String>();
        Set<String> unreleasedExtKeys = new Set<String>();
        for (Case c : cases) {
            if ((''+c.OwnerId).startsWith('005')) {
                // case owner could be a user or a queue (user id starts with 005)
                userIds.add(c.OwnerId);
            }
            allExtKeys.add('' + c.Id + c.OwnerId);
        }
        for (User u : [SELECT Id, UserRole.Name FROM User WHERE Id IN :userIds]) {
            userIdToRoleName.put(u.Id, u.UserRole.Name);
        }
        for (Handler__c hndlr : [SELECT externalkey__c FROM Handler__c
            WHERE externalkey__c IN :allExtKeys AND OwnershipReleasedTimeStamp__c = null]
        ) {
            unreleasedExtKeys.add(hndlr.externalkey__c);
        }

        // Create handlers
        List<Handler__c> insertHandlers = new List<Handler__c>();
        for (Case c : cases) {
            String extKey = '' + c.Id + c.OwnerId;
            // Avoid duplicities (two unreleased handlers for the same case & user)
            if (!unreleasedExtKeys.contains(extKey)) {
                Handler__c handler = new Handler__c();
                handler.Case__c = c.Id;
                handler.Closed__c = c.isClosed;
                handler.UserId__c = c.OwnerId;
                handler.UserName__c = c.Owner.Name;
                handler.externalkey__c = extKey;
                handler.OwnershipTakenTimeStamp__c = DateTime.now();
                handler.Department__c = c.Department__c;
                handler.Open__c = !c.isClosed;
                handler.Product__c = c.Product_2__c;
                handler.Role__c = userIdToRoleName.get(c.OwnerId);
                handler.Status__c = c.Status;
                handler.Type_Task__c = c.Type_Task__c;
                insertHandlers.add(handler);
            }
        }
        if (insertHandlers.size() > 0) {
            Database.insert(insertHandlers);
        }
    }

    Public static void releaseOwnership(List<Case> cases){

        Set<String> externalKeys = new Set<String>();
        for(Case case2:cases){
            
            String handlerExternalKey = '';
            handlerExternalKey = handlerExternalKey + case2.Id;
            handlerExternalKey = handlerExternalKey + case2.ownerId;
            externalKeys.add(handlerExternalKey);
            
        }
        
        List<Handler__c> casesHandlers = [Select Id, case__c,  userId__c, externalkey__c, OwnershipTakenTimeStamp__c, OwnershipReleasedTimeStamp__c from Handler__c where externalkey__c IN : externalKeys AND OwnershipReleasedTimeStamp__c = null Order By CreatedDate Desc];
        
        List<Handler__c> insertHandlers = new List<Handler__c>();
        List<Handler__c> updateHandlers = new List<Handler__c>();
        for(Case case2:cases){
            
            Handler__c caseHandler;
            String handlerExternalKey = '';
            handlerExternalKey = handlerExternalKey + case2.Id;
            handlerExternalKey = handlerExternalKey + case2.ownerId;
            for(Handler__c casesHandler:casesHandlers){
                
                if(handlerExternalKey == casesHandler.externalkey__c){
                    caseHandler = casesHandler;
                    break;
                }
            }
            
            if(caseHandler != null){
                
                caseHandler.OwnershipReleasedTimeStamp__c = DateTime.Now();
                updateHandlers.add(caseHandler);
            }
        }
        
        if(updateHandlers.size() > 0){ 
            update updateHandlers;
        }

    }

    // A clone of the releaseOwnership(List<Case> cases) method
    // Sets a value for ClosedByUser__c to indicate whether the case has just been closed
    // and a value for ClosedTimeStamp__c to keep track when the closing took place
    Public static void releaseOwnership(List<Case> cases, Set<Id> closedCases){

        Set<ID> externalKeys = new Set<ID>();
        for (Case case2:cases) {
            externalKeys.add(case2.Id);
        }

        List<Handler__c> casesHandlers = [
            SELECT Id, Case__c, UserId__c, externalkey__c, OwnershipTakenTimeStamp__c, OwnershipReleasedTimeStamp__c,
                ClosedByUser__c, ClosedTimeStamp__c
            FROM Handler__c
            WHERE Case__c IN : externalKeys
            ORDER BY CreatedDate DESC
        ];
        
        List<Handler__c> insertHandlers = new List<Handler__c>();
        List<Handler__c> updateHandlers = new List<Handler__c>();
        for (Case case2 : cases) {
            Boolean wasClosed = closedCases.contains(case2.Id);
            Boolean wasReleased = false;
            Datetime nowDT = DateTime.Now();
            String handlerExternalKey = '';
            handlerExternalKey = handlerExternalKey + case2.Id;
            handlerExternalKey = handlerExternalKey + case2.ownerId;
            for (Handler__c casesHandler : casesHandlers) {
                if (case2.Id == casesHandler.Case__c) {
                    if (!wasReleased && handlerExternalKey == casesHandler.externalkey__c
                        && casesHandler.OwnershipReleasedTimeStamp__c == null
                    ) {
                        // release ownership on the 'open' handler
                        casesHandler.OwnershipReleasedTimeStamp__c = nowDT;
                        if (wasClosed) {
                            casesHandler.ClosedByUser__c = true;
                            casesHandler.ClosedTimeStamp__c = nowDT;
                        }
                        updateHandlers.add(casesHandler);
                        wasReleased = true;
                    } else if (wasClosed && casesHandler.ClosedTimeStamp__c == null) {
                        // set ClosedTimeStamp__c on all preceding 'not closed' handlers
                        casesHandler.ClosedTimeStamp__c = nowDT;
                        updateHandlers.add(casesHandler);
                    }
                }
            }
        }

        if (updateHandlers.size() > 0) { 
            update updateHandlers;
        }
    }

    static testmethod void testOwnershipHandler(){
        
        QueueSobject queue = [Select q.SobjectType, q.QueueId, q.Id From QueueSobject q where sObjectType = 'Case' limit 1];
        
        Case case2 = new Case();
        insert case2;
        
        case2.OwnerId = queue.QueueId;
        update case2;
        
        case2.Status = 'Closed';
        update case2;
        
    }
}