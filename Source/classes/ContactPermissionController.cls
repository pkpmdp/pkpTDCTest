public class ContactPermissionController {
    public String name{get;set;} 
    public String email{get;set;}
    public boolean permission{get;set;}
    public boolean isSaved{get;set;}
    public String mobile{get;set;}
    private Contact contact;
    public String anlaegsnr{get;set;}
    public String firstName{get;set;}
    public String lastName{get;set;}
    public List<Role> originalRoles = new List<Role>{new Role('1','Bestyrelsesmedlem'),
new Role('2','Administrator'),
new Role('3','Vicevært/Varmemester'),
new Role('0','Formand'),new Role('4','Beboer'),new Role('5','Andet')};  
    public List<String> leftselected{get;set;}  
    public List<String> rightselected{get;set;}  
    public String accountID{get;set;}
    public String cuID{get;set;}
    List<Role> leftvalues1 = new List<Role>();
    List<Role> rightvalues1 = new List<Role>(); 
    public YS_Campaign__c ysCampaigns = YS_Campaign__c.getInstance('ContactPermission');    
    public String permissionCampaign = ysCampaigns.CampaignID__c;  
    public String eNewsRole = ysCampaigns.RoleID__c;
    
    public ContactPermissionController(ApexPages.StandardController controller) {
      Id cid = ApexPages.currentPage().getParameters().get('id');
      accountID = ApexPages.currentPage().getParameters().get('aid');
      isSaved = false;
      if(accountID == null || cid == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl.'));
      }
      if(cid != null) {
        contact = [Select c.RecordTypeId, c.Name, c.FirstName, c.LastName, c.MobilePhone, c.Permission__c, c.Id, c.Email, c.Business_Email__c, c.Account.Cable_Unit_No__c, c.AccountId, c.SecurityCode__c, (Select Name, Contact__c, RoleName__c From Account_Contact_Roles__r) From Contact c where c.id = :cid limit 1];
        List<Account_Contact_Role__c> acrs = [Select a.Customer__c, a.Contact__c, a.Customer__r.Cable_Unit_No__c From Account_Contact_Role__c a where a.Customer__c = :accountID AND a.Contact__c = :cid];
        if(acrs.size() != 0)
            cuID = acrs[0]. Customer__r.Cable_Unit_No__c;
      }
      if(contact.Name != null || contact.Name != '')
        name = contact.Name;
      firstName = contact.FirstName;
      lastName = contact.LastName;  
      email = contact.Email;
      mobile = contact.MobilePhone;
      //permission = contact.Permission__c;
      permission = false;
      String cableNo = cuID;
      if(cableNo != null)
        anlaegsnr = cableNo.replaceFirst('^0+(?!$)', '');       
      leftselected = new List<String>();  
      rightselected = new List<String>();  
      //leftvalues.addAll(originalValues);
      leftvalues1 = originalRoles;   
    }
    
    public PageReference saveContact() {
        String CPRAction = '';
        String ACRAction = '';
        String CMAction = '';
        ContactPermissionRole__c cpr;
        CampaignMember cm;
        Account_Contact_Role__c newsRole;
        if(HasValidationErrors())
            return null;
        else {
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = email;
        contact.MobilePhone = mobile;
        contact.Permission__c = permission;
        //add enewsrole if customer gives permission and doesn't have this role before
        if(contact.Permission__c == true && !hasPermissionBefore(contact)) {
                newsRole = new Account_Contact_Role__c();
                newsRole.Customer__c = accountID;
                newsRole.Contact__c = contact.id;
                newsRole.Role__c = eNewsRole;
                System.debug('wen debug accountid'+contact.Account.id);
                ACRAction = 'insert';
        }     
        List<ContactPermissionRole__c> cprs = [Select c.Role__c, c.Name, c.Id, c.Contact__c From ContactPermissionRole__c c where c.Contact__c = : contact.id];
        List<CampaignMember> cms = [Select c.ContactId, c.CampaignId From CampaignMember c where c.ContactId =: contact.Id AND c.CampaignId = : permissionCampaign];
        if(cms.size() != 0) {
            cm = cms[0];
            CMAction = 'update';
        } else {
            cm = new CampaignMember();
            cm.ContactId = contact.Id;
            cm.CampaignId = permissionCampaign;
            CMAction = 'insert'; 
        } 
        if(contact.Permission__c == true)
            cm.status = 'Besvaret med permission';
        else if(contact.Permission__c == false)
            cm.status = 'Besvaret uden permission';
        if(cprs.size() != 0) {
            cpr = cprs[0];
            CPRAction = 'update';
        }
        else {
            cpr = new ContactPermissionRole__c();
            CPRAction = 'insert';
        }
        cpr.Contact__c = contact.id;
        String selected = '';
        for(Role s : rightvalues1){  
            selected = selected+s.name+';'; 
        }
        //System.debug('wen multi pick'+selected);
        cpr.Role__c = selected;
        try {
            update contact;
            if(CPRAction == 'insert') {
                insert cpr;
            }
            else if(CPRAction == 'update')
                update cpr;
            if(CMAction == 'insert')
                insert cm;
            else if(CMAction == 'update')
                update cm;
            //add enewsrole if customer gives permission and doesn't have this role before  
            /**2012-11-27 these following two lines are commented out, because there are several CU in prod doesn't have correct address information
                        thus it fails to create new role;;Taken code back in the afternoon 2012-11-27
            **/
            if(ACRAction == 'insert' && newsRole != null)
                insert newsRole;
            isSaved = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Tak fordi du har opdateret dine oplysninger.'));
            return ApexPages.currentPage();
        }catch (DmlException e) {
                String errorMessage = e.getDMLMessage(0);
                if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                   
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
                    return null;
                }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl.'));
                return null; 
         }
        }
        }       
    }
    
    private boolean HasValidationErrors(){
        boolean errors = false;
        if(firstName == null || firstName == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste fornavn.'));
            errors = true;
        }
        if(lastName == null || lastName == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste efternavn.'));
            errors = true;
        }        
        if(email == null || email == ''){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste e-mail.'));
            errors = true;
        } else if(HasUsedByOthers()) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'E-mail adresse er allerede registreret i vores system. Vær opmærksom på at hver e-mail adresse kun kan være tilknyttet en person. Du kan ikke bruge en e-mail til en fællespostkasse.'));
            errors = true;
        } else {
            String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+'; 
            Boolean formatOK = Pattern.matches(pat, email);
            if(formatOK == false){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste en gyldig e-mail adresse'));
                errors = true;   
            }
        }
        return errors;
    } 
    
    private boolean HasUsedByOthers() {
        List<contact> contacts = [Select c.Id, c.Email From Contact c where c.Email = :email AND c.IsPersonAccount=false];
        if(contacts.size()>1){
                return true;
        }else if(contacts.size() == 1 && contacts[0].id != contact.id)
                return true;
        else
            return false;
    }
    
    private boolean hasPermissionBefore(Contact contact) {
        boolean hasPermission = false;
        List<Account_Contact_Role__c> acrs = [Select c.Role__c from Account_Contact_Role__c c where c.Contact__c = :contact.id];
        for(Account_Contact_Role__c acr : acrs)
                if(acr.Role__c == eNewsRole)
                        hasPermission = true;
        return hasPermission;           
    }
           
     private List<Role> removeDuplicate(List<Role> list1, List<Role> list2){
         Map <String, Role> tempMap = new Map <String, Role>();
         List<Role> tempList = new List<Role>();
         for(Role a: list2) {
             tempMap.put(a.position, a); 
         }       
         for(Role b: list1) {
             Role c = tempMap.get(b.position);
             if(c == null)
                 tempList.add(b);
         }
         tempList.sort();
         return tempList;    
     } 
       
     public void selectclick() {
         rightselected.clear();
         List<Role> selectedList = new List<Role>();
         for(String s:leftselected){
             for (Role r: leftvalues1){
                 if(s == r.name)
                     selectedList.add(r);
             }
         }
         leftvalues1 = (List<Role>)removeDuplicate(leftvalues1, selectedList);
         rightvalues1.addAll(selectedList);
         leftvalues1.sort();
         rightvalues1.sort();
     }
     
      
    public void unselectclick(){
        leftselected.clear();
        List<Role> selectedList = new List<Role>();
         for(String s:rightselected){
             for (Role r: rightvalues1){
                 if(s == r.name)
                     selectedList.add(r);
             }
         }
        rightvalues1 = (List<Role>)removeDuplicate(rightvalues1, selectedList);
        leftvalues1.addAll(selectedList); 
        leftvalues1.sort();  
        rightvalues1.sort();
    }
       

     public List<SelectOption> getunSelectedValues(){  
         List<SelectOption> options = new List<SelectOption>();  
         List<Role> tempList = new List<Role>();  
         tempList.addAll(leftvalues1);  
         tempList.sort();           
         for(Role s : tempList)  {
             options.add(new SelectOption(s.name,s.name));  
             }
         return options;  
     }  

    

     public List<SelectOption> getSelectedValues(){  
         List<SelectOption> options1 = new List<SelectOption>();  
         List<Role> tempList = new List<Role>();  
         tempList.addAll(rightvalues1);  
         tempList.sort();  
         for(Role s : tempList)  
            options1.add(new SelectOption(s.name,s.name));  
         return options1;  
     }  
    
       
}