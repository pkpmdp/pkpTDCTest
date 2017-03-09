public class ContactLoginController {
    public String cuid{get;set;}
    public String secur{get;set;}
    private Contact contact;
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
        String contactRecordType = ysRecords.YS_Contact_Record_Type__c;

    public ContactLoginController(ApexPages.StandardController controller) {
        cuid = '';
        secur = '';
    }
    
    public PageReference Login() {
      if(HasValidationErrors())
          return null;
      else {
             while (cuid.length() < 10) {                
               cuid = '0' + cuid;
             }
             List<Account_Contact_Role__c> acrs = [Select a.Customer__c, a.Contact__c, a.Contact__r.SecurityCode__c From Account_Contact_Role__c a where a.Customer__r.Cable_Unit_No__c = :cuid AND a.Contact__r.SecurityCode__c = :secur];
             if(acrs.size() != 0) {
                String accID = acrs[0].Customer__c;
                ID conID = acrs[0].Contact__c;
                Id id = conID;
                PageReference pageRef = new PageReference('/apex/ContactPermission');
                pageRef.getParameters().put('id', id);
                pageRef.getParameters().put('aid', accID);
                return pageRef.setRedirect(true);                       
             } else {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Det indtastede Kundenr eller sikkerhedskode er ikke registreret i vores systemer. Prøv at taste oplysningerne igen.'));
                return null;
             }                         
          }
      }
    
    public boolean HasValidationErrors(){
        boolean errors = false;
        if(cuid == null || cuid == '' || secur == null || secur==''){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Det indtastede Kundenr eller sikkerhedskode er ikke registreret i vores systemer. Prøv at taste oplysningerne igen.'));
            errors = true;
        }
        return errors;
    } 

}