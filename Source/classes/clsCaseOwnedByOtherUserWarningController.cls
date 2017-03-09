public with sharing class clsCaseOwnedByOtherUserWarningController {
	
	Case case2;
	
	public clsCaseOwnedByOtherUserWarningController(ApexPages.StandardController controller) {
        case2 = [Select Id, OwnerId, Owner.Name From Case Where Id = :controller.getId()];
        
    }
    
    Public Pagereference checkOwner(){
    	
    	String caseOwnerId = case2.OwnerId;
    
    	if(case2.OwnerId != System.UserInfo.getUserId() && case2.Owner.Name != 'API User' && caseOwnerId.startsWith('005')){
    		
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'VIGTIGT!!! Ændringer på denne sag vil IKKE blive gemt, da du ikke står som sagens ejer.'));
    	
    	}
    	return null;
    }
	
}