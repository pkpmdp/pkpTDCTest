public with sharing class clsEntitlementCalculator {
   
    public static void calculateEntitlement(List<Case> cases){
        
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues('Default Entitlement ID');
        
        if(cs != null){
            
            Id entitlementId = cs.Setting_Value__c;
            if(entitlementId != null){
                
                for(Case case2 : cases){
                    
                    case2.EntitlementId = entitlementId;
                    
                }
            }
                
        }
        
    }
    
    static testmethod void testCalculateEntitlement(){
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        Case case2 = new Case();
        insert case2;
        
        Case case3 = [Select Id, EntitlementId from Case where Id = :case2.Id];
        System.debug('case3=' + case3);
    }
}