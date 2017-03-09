public with sharing class clsCasesReassign {

    public void reassignCases(List<Case> cases, Boolean pUseDefaultRule) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = pUseDefaultRule;
        List<Case> casesToUpdate = new List<Case>();
        for (Case c : cases) {
            c.setOptions(dmo);	
    	    casesToUpdate.add(c);
        }
        Database.SaveResult[] results = Database.update(casesToUpdate);
    }
    
}