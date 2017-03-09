public class POLeadPermissionELQController {
    private ApexPages.standardController controller;
    public Boolean permission{get;set;}
    public Lead lead;
    public Boolean isUnknownAddress{get;set;}

    public POLeadPermissionELQController(ApexPages.StandardController controller) {
       controller = controller;
       lead = [SELECT YSPermission__c, Address_merge_field__c FROM Lead WHERE Id = :((Lead) controller.getRecord()).Id];
       if(lead.Address_merge_field__c != null) {
           if(lead.Address_merge_field__c.startsWith('Ukendt adresse'))
               isUnknownAddress = true;
           else
               isUnknownAddress = false;  
       }   
    }
    
    public void updatePermission() {
       lead.YSPermission__c = permission;
       update lead;    
    }

}