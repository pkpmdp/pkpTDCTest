public class MasseContactRoleController {  
    public Account_Contact_Role__c acr {get;set;}
    public Account customer {get;set;} 
    public Contact contact{get;set;}
    public ApexPages.StandardController controller;
    private Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap;  
    Public List<string> leftselected{get;set;} 
    public boolean isShow{get;set;} 
    public boolean showRole{get;set;}
    Public List<string> rightselected{get;set;}  
    List<Lookup_Contact_Roles__c> availableRoles = new List<Lookup_Contact_Roles__c>(); 
    List<Lookup_Contact_Roles__c> currentRoles = new List<Lookup_Contact_Roles__c>(); 
    List<Account_Contact_Role__c> originalACR = new List<Account_Contact_Role__c>() ; 
    List<Account_Contact_Role__c> newList = new List<Account_Contact_Role__c>();
    List<Account_Contact_Role__c> updateList = new List<Account_Contact_Role__c>();  
    List<Account_Contact_Role__c> removeList = new List<Account_Contact_Role__c>();
    private Id contactId, accountId, acrId;
    String retURL;
    public String indblikId = Indblikadresse__c.getValues('ID').ID__c;
    
    public MasseContactRoleController (ApexPages.standardController controller){     
         this.controller = controller; 
         leftselected = new List<String>();  
         rightselected = new List<String>();   
         isShow = false;
         showRole = false;      
         String existingContactId = ApexPages.currentPage().getParameters().get('cid');
         String masseCreatedAccid = ApexPages.currentPage().getParameters().get('aid');
         String newCreatedContactId = ApexPages.currentPage().getParameters().get('newid');
         String rlaccid = ApexPages.currentPage().getParameters().get('rlaccid');
         System.debug('****Wen debug get parameters'+rlaccid);
         if((existingContactId == null || existingContactId == '') && newCreatedContactId !=null) {
             contactId = newCreatedContactId;
         } else {
             contactId = existingContactId;
         }
         if((masseCreatedAccid==null || masseCreatedAccid=='')&&rlaccid!=null&&rlaccid!='null') {
             accountId = rlaccid;
         } else {
             accountId = masseCreatedAccid;
         }
         acrId = ApexPages.currentPage().getParameters().get('acr');         
         this.acr =  (Account_Contact_Role__c)controller.getRecord();
         if(contactId != null && accountId == null){                                      
            List<Contact> contacts = Database.query('Select Id, Name from Contact where Id= :contactId'); 
            acr.Contact__c = contacts[0].id; 
            retURL = contactId;  
         } else if(contactId == null && accountId != null) {
                List<Account> accounts = Database.query('Select Id, Name from Account where Id= :accountId');
                acr.Customer__c = accounts[0].id;
                retURL = accountId;
         } else if(contactId == null && accountId == null && acrId != null) {
            List<Account_Contact_Role__c> acrs = Database.query('Select Id, Name, Customer__c, Contact__c from Account_Contact_Role__c where Id= :acrId'); 
            acr.Contact__c = acrs[0].Contact__c;
            acr.Customer__c = acrs[0].Customer__c;
            getContactRoles();
            retURL = acrs[0].Customer__c;
         } else if (contactId != null && accountId != null && acrId == null) {
            acr.Contact__c = contactId;
            acr.Customer__c = accountId;
            getContactRoles();
            retURL = accountId;
         }
         System.debug('wen indblik'+indblikId);              
    }
    
    
    public PageReference saveContactRole() {
        if(HasValidationErrors())
            return null;
        else {
        sortSelected();
        try {
                if(newList.size() > 0) {
                        System.debug('new'+newList.size());
                        insert newList;
                } 
                if(updateList.size() > 0) {
                        System.debug('update'+updateList.size());
                        update updateList;
                }
                if(removeList.size() > 0) {
                        System.debug('delete'+removeList.size());
                        delete removeList;
                }
                //
                //update updateList;
                //delete removeList;
                PageReference pageRef = new PageReference('/'+retURL);
                return pageRef; 
          } catch (DmlException e) {
                String errorMessage = e.getDMLMessage(0);
                if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                   
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
                    return null;
                }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));
                System.debug('upsert error');
                return null; 
            } 
          }
        }
    }
    
    private void sortSelected() {
        Map <String, Account_Contact_Role__c> tempOMap = new Map <String, Account_Contact_Role__c>();
        
        for(Account_Contact_Role__c a : originalACR) {
                tempOMap.put(a.Role__c, a);
        }
        for(Lookup_Contact_Roles__c lc : currentRoles) {
                Account_Contact_Role__c c = tempOMap.get(lc.id);
                if(c != null) {
                        c.Contact__c = this.acr.Contact__c;
                        if(lc.id == indblikId)
                        c.Total_Insight__c = this.acr.Total_Insight__c;
                    updateList.add(c);
                }
                else {
                        Account_Contact_Role__c a = new Account_Contact_Role__c();
                        a.Contact__c = this.acr.Contact__c;
                        a.Customer__c = this.acr.Customer__c;
                        a.Role__c = lc.id;
                        if(lc.id == indblikId)
                        a.Total_Insight__c = this.acr.Total_Insight__c;
                        newList.add(a);
                }
        }
        removeList = (List<Account_Contact_Role__c>)removeDuplicate(originalACR, updateList);
    } 
    
    public boolean HasValidationErrors(){
        boolean errors = false;
        if(acr.Contact__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Kontakt: Du skal vælge en kontaktperson'));
            errors = true;
        }
        if(acr.Customer__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Kunde: Du skal vælge en kunde'));
            errors = true;
        }
        return errors;
    }
        
    
    public PageReference save(){
       return saveContactRole();
       
    }
    
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/'+retURL);
        return pageRef; 
    }
    
    public PageReference getContactRoles() {
        System.debug('try to get contact roles');
        availableRoles.clear(); 
        currentRoles.clear(); 
        originalACR.clear();
        showRole = true;
        /*for (Lookup_Contact_Roles__c b : [select Id, Name, Active__c from Lookup_Contact_Roles__c where Active__c='Ja' order by Name]) {
                availableRoles.add(b);
        } */
        for(Account_Contact_Role__c a : [Select a.Total_Insight__c, a.Role__r.Name, a.Role__r.Id, a.Role__c, a.Customer__c, a.Contact__c From Account_Contact_Role__c a where a.Customer__c = :this.acr.Customer__c AND a.Contact__c = :this.acr.Contact__c]){
                currentRoles.add(a.Role__r);
                originalACR.add(a);
                if(a.Role__r.Id == indblikId) {
                        isShow = true;
                        this.acr.Total_Insight__c = a.Total_Insight__c;
                }             
        }
        /*if(currentRoles.size() != 0)
                availableRoles = removeDuplicate(availableRoles, currentRoles);*/
        kissRuleValidation();
        availableRoles = removeDuplicate(availableRoles, currentRoles);   
        availableRoles.sort();
        currentRoles.sort();
        return null;
    }
    
    private void kissRuleValidation() {
        Account customer = [select a.id, a.name, a.type from Account a where a.id =: this.acr.Customer__c];
        Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
        for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Unlimited__c, Required__c, Possible__c, Type__c, Contact_Roles__c from KISS_Role_Validation_Rules__c where Type__c =:customer.type]){
                String key = rule.Contact_Roles__c + ':' + rule.Type__c;
                if (KISSRulesMap.get(key) == null) {
                KISSRulesMap.put(key, rule);    
                }
        }
                Map <String, Integer> acrCurrentRolesMap = new Map <String, Integer>();    
                for(AggregateResult acrCurrentRoles : [Select Customer__c customerId, Role__c roleId, count(ID) total from Account_Contact_Role__c where customer__c = :customer.Id group by Customer__c, Role__c]){
                        String key2 = String.valueOf(acrCurrentRoles.get('customerId')) + ':' + String.valueOf(acrCurrentRoles.get('roleId'));
                        if(acrCurrentRolesMap.get(key2) == null) {
                                acrCurrentRolesMap.put(key2, Integer.valueOf(acrCurrentRoles.get('total'))); 
                        }         
                }
                Map<Id, Lookup_Contact_Roles__c> available_roles = new Map<Id, Lookup_Contact_Roles__c>();
                Set<Id> kids = new Set<Id>();
                for(KISS_Role_Validation_Rules__c a : [Select k.Contact_Roles__r.Id, k.Contact_Roles__r.name from KISS_Role_Validation_Rules__c k where k.Type__c = :customer.type]) {
                        kids.add(a.Contact_Roles__r.Id);
                        //system.debug('Wen kidsset'+a.Contact_Roles__r.name);
                }
                for(Lookup_Contact_Roles__c role_type: [Select Id, Active__c, name from Lookup_Contact_Roles__c where Active__c = 'Ja' and Id IN :kids]){
                        String key = role_type.Id + ':' + customer.type;
                        KISS_Role_Validation_Rules__c rule = KISSRulesMap.get(key);
                        
                        String currentRolesKey = customer.Id + ':' + role_type.Id;
                        Integer CurrentRoles = Integer.valueOf(acrCurrentRolesMap.get(currentRolesKey));
                        System.debug('Wen currentRoles'+CurrentRoles);
                        if( (CurrentRoles == null) || 
                            ((CurrentRoles != null && rule.Unlimited__c == false && rule.Possible__c > CurrentRoles) || (CurrentRoles!=null && rule.Unlimited__c == true)) ){
                            System.debug('Wen in the if');
                            if(available_roles.get(role_type.Id) == null) {
                                //available_roles.put(key, role_type);
                                availableRoles.add(role_type);
                                System.debug('availableMap'+role_type.name);
                            } 
                        }  
                } 
        }
                  
            
     
    private List<sObject> removeDuplicate(List<sObject> list1, List<sObject> list2){
        Map <String, sObject> tempMap = new Map <String, sObject>();
        List<sObject> tempList = new List<sObject>();
        for(sObject a: list2) {
                tempMap.put(a.id, a);
        }       
        for(sObject b: list1) {
                sObject c = tempMap.get(b.id);
                if(c == null){
                        if(b.getSObjectType() == Lookup_Contact_Roles__c.sObjectType)
                                tempList.add((Lookup_Contact_Roles__c)b);
                    else if(b.getSObjectType() == Account_Contact_Role__c.sObjectType)
                        tempList.add((Account_Contact_Role__c)b); 
                } 
        } 
        tempList.sort();
        return tempList;
    } 
     
     public PageReference selectclick2(){  
         rightselected.clear();  
         List<Lookup_Contact_Roles__c> selectedList = new List<Lookup_Contact_Roles__c>();
         for (String s: leftselected) {
                for(Lookup_Contact_Roles__c  l: availableRoles) {
                        if(s == l.id) {
                                //system.debug('selectedList'+l.name+','+s+','+l.id);
                                selectedList.add(l);
                        }
                }
                if(s == indblikId) { 
                 isShow = true; 
            }   
         }
         availableRoles = (List<Lookup_Contact_Roles__c>)removeDuplicate(availableRoles, selectedList);
         currentRoles.addAll(selectedList); 
         availableRoles.sort();
         currentRoles.sort();
         return null;
     }  
     
     
     public PageReference unselectclick2(){  
         leftselected.clear();  
         List<Lookup_Contact_Roles__c> selectedList = new List<Lookup_Contact_Roles__c>();
         for (String s: rightselected) {
                for(Lookup_Contact_Roles__c  l: currentRoles) {
                        if(s == l.id) {
                                //system.debug('selectedList'+l.name+','+s+','+l.id);
                                selectedList.add(l);
                        }
                }
                if(s == indblikId) { 
                 isShow = false; 
                 //system.debug('you have selected indblik'+isShow);
            }   
         }
         currentRoles = (List<Lookup_Contact_Roles__c>)removeDuplicate(currentRoles, selectedList);
         availableRoles.addAll(selectedList); 
         availableRoles.sort();
         currentRoles.sort();
         return null;
     }  

     
     
      public List<SelectOption> getunSelectedValues2(){  
         List<SelectOption> options = new List<SelectOption>();    
         for(Lookup_Contact_Roles__c  l: availableRoles) {
             options.add(new SelectOption(String.valueOf(l.id), l.name));  
         }      
         return options;  
     }    
     
     public List<SelectOption> getSelectedValues2(){  
         List<SelectOption> optionsSelected = new List<SelectOption>();  
         for(Lookup_Contact_Roles__c  l: currentRoles) {
             optionsSelected.add(new SelectOption(String.valueOf(l.id), l.name));  
         }
         return optionsSelected;          
     } 
     
    
}