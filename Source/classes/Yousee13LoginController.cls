public class Yousee13LoginController {
    public String cuid{get;set;}
    public String secur{get;set;}
    public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');      
    public String CampJF = yousee13.Jylland_Fyn_Campaign__c;//'701M0000000EAOv';
    public String CampSj = yousee13.Sjaelland_Campaign__c;//'701M0000000EAOm';
    public String CampSk = yousee13.Copenhagen_Campaign__c;//'701M0000000EAOk';
    public String cmid{get;set;}
    public String region{get;set;}

    public Yousee13LoginController(ApexPages.StandardController controller) {
        cuid = '';
        secur = '';
    }
    
    public PageReference Login() {
        if(HasValidationErrors()) {
            return null;
        } else {
            /*while (cuid.length() < 10) {                
               cuid = '0' + cuid;
            }*/
            
            PageReference pageRef = null;
            pageRef = new PageReference('/apex/Yousee13Deltage');
         
            List<Account_Contact_Role__c> acrs = [Select a.Customer__r.HierarchyCustomerNumber__c, a.Customer__r.Post_Code__c,a.Customer__r.Type, a.Customer__r.Cable_Unit_Post_Code__c, a.Customer__r.Customer_No__c,a.Customer__c, a.Contact__c, a.Contact__r.SecurityCode__c, a.Contact__r.Post_Code_P__c From Account_Contact_Role__c a where a.Customer__r.Customer_No__c = :cuid AND a.Contact__r.SecurityCode__c = :secur];
            if(acrs.size() == 0){
            	acrs = [Select a.Customer__r.HierarchyCustomerNumber__c, a.Customer__r.Type, a.Customer__r.Post_Code__c, a.Customer__r.Cable_Unit_Post_Code__c, a.Customer__r.Customer_No__c,a.Customer__c, a.Contact__c, a.Contact__r.SecurityCode__c, a.Contact__r.Post_Code_P__c From Account_Contact_Role__c a where  a.Customer__r.HierarchyCustomerNumber__c = :cuid AND a.Contact__r.SecurityCode__c = :secur];
            }
            if(acrs.size() != 0) {
                String accID = acrs[0].Customer__c;
                String conID = acrs[0].Contact__c;
                String postCode = '';
                if('Kunde'.equals(acrs[0].Customer__r.Type))
                	postCode = acrs[0].Customer__r.Cable_Unit_Post_Code__c;
                else if('Hierarki'.equals(acrs[0].Customer__r.Type)){
                	//old version postCode = acrs[0].Contact__r.Post_Code_P__c;
                	//new version
                	postCode = acrs[0].Customer__r.Post_Code__c;
                	
                	if('H-313269'.equals(acrs[0].Customer__r.HierarchyCustomerNumber__c)){ // Speciel handling of "Indblik" customer H-313269
                		pageRef = new PageReference('/apex/Yousee13DeltageIndblikPage');   // SF- 987
                	}
                	
            	}	
                //Id id = conID;
                findCampaignMember(conID, postCode);
                if(cmid == null){
                	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Den kombination af kundenr. og sikkerhedskode du har tastet er ikke korrekt. Prøv at taste oplysningerne igen.'));
                	return null;
                }
                
                pageRef.getParameters().put('acc', accID);
                //pageRef.getParameters().put('aid', accID);
                pageRef.getParameters().put('cmid', cmid);
                pageRef.getParameters().put('loc', region);
                return pageRef.setRedirect(true);                       
             } else {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Det indtastede kundenummer eller sikkerhedskode er ikke registreret i vores systemer. Prøv at taste oplysningerne igen.'));
                return null;
             }
        }
        
    }
    
    private void findCampaignMember(String contactId, String postCode) {
        String campaignId;
        if(postCode >= String.valueOf(5000)) {
            campaignId = CampJF;
            region = 'jf'; //Jylland & Fyn	
        }else if(postCode >= String.valueOf(3000)) {
            campaignId = CampSj;
            region = 'sj'; //Sjælland
        }else {
            campaignId = CampSk;
            region = 'sk'; //Stor København
        }      
        List<CampaignMember> cms = [Select c.contact.Post_Code_P__c, c.Show__c, c.Id, c.HasResponded, c.Deltage__c, c.contact.email, c.contact.name, c.ContactId, c.CampaignId, c.Bus__c From CampaignMember c where c.ContactId = :contactId AND c.CampaignId = :campaignId];
        if(cms.size()>0) {
            cmid = cms[0].id;
            system.debug('wen campaign member'+cmid);
        }
        else
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Den kombination af kundenr. og sikkerhedskode du har tastet er ikke korrekt. Prøv at taste oplysningerne igen.'));          
    }
    
    public boolean HasValidationErrors(){
        boolean errors = false;
        if(cuid == null || cuid == '' || secur == null || secur==''){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Det indtastede kundenummer eller sikkerhedskode er ikke registreret i vores systemer. Prøv at taste oplysningerne igen.'));
            errors = true;
        }
        return errors;
    } 
}