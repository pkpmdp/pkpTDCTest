public class ContactRolesPicklistController {   
    public Account_Contact_Role__c acr {get;set;}
    public Account_Contact_Role__c oldACR = new Account_Contact_Role__c();
    public Account customer {get;set;}  
    public enum Operation {NewObj, Edit,Clone, Error}
    private Operation mode;
    public Id id;
    public String mode_string {get{return mode.name();}}
    private String retURL = '';
    public ApexPages.StandardController controller;
    private Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap; 
    
    //Retriving environment unique field ids for customer lookup fields
    public YSFieldIDs__c ysFieldIds = YSFieldIDs__c.getInstance('YSFieldIDs');
    private String CUSTOMER_FIELD_ID = ysFieldIds.ExternalRoleCustomerLookup__c;    
    private String CONTACT_FIELD_ID = ysFieldIds.ExternalRoleContactLookup__C;
     
    public ContactRolesPicklistController(ApexPages.standardController controller){ 
        System.debug('start******');
        this.controller = controller;
        id = ApexPages.currentPage().getParameters().get('id');
        String clone = ApexPages.currentPage().getParameters().get('clone');
        
        mode = Operation.NewObj;
        if(id != null){                      
            this.acr = [SELECT Id, Role__c, Customer__c, Contact__c, Total_Insight__c FROM Account_Contact_Role__c WHERE id = :id];
            oldACR = this.acr;
            if(clone != null)
                mode = Operation.Clone;
            else
                mode = Operation.Edit;                  
        }else {          
            this.acr =  (Account_Contact_Role__c)controller.getRecord();
            mode = Operation.NewObj;                        
        }
        system.debug('Michel - mode: ' + mode);
        
        KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
        
        //RetUrl skal kun bruges ved redigering
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        if(acr.Customer__c != null){
            this.customer = [Select Id, Name, Type from Account where Id= :acr.Customer__c];
            /* Old code using maps, but this did'nt work with sorting role names.
            for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Type__c, Contact_Roles__c, Contact_Roles__r.Name from KISS_Role_Validation_Rules__c where Type__c = :customer.Type and Contact_Roles__c <>'' and Contact_Roles__r.Active__c='Ja' order by Contact_Roles__r.Name]){             
                //KISSRulesMap.put(rule.Name, rule);      
            } 
            */  
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Kontaktpersonroller må kun oprettes via kundebilledet.'));
            mode = Operation.Error; 
        }
        system.debug('Michel - mode: ' + mode);
    }
    
    public boolean HasValidationErrors(){
        boolean errors = false;
        if(acr.Contact__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Kontakt: Du skal vælge en kontaktperson'));
            errors = true;
        }
        if(acr.Role__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Rolle: Du skal vælge en kontaktrolle'));
            errors = true;
        }
        if(acr.Customer__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Kunde: Du skal vælge en kunde'));
            errors = true;
        }
        return errors;
    }
        
    public PageReference saveNew(){
        if (HasValidationErrors())
            return null;
        try {
            if (mode == Operation.Clone)
                upsert acr.clone(false, true);
            else
                upsert acr;      
        } catch(System.DMLException e){
            String errorMessage = e.getDMLMessage(0);
            if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));    
                system.debug(errorMessage);
            }
            return null;            
        }
        
        Schema.DescribeSObjectResult describeResult = controller.getRecord().getSObjectType().getDescribe();
        PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e');
        pr.setRedirect(true);
        pr.getParameters().put('retURL', retURL);
        pr.getParameters().put(CUSTOMER_FIELD_ID, customer.Name);
        pr.getParameters().put(CUSTOMER_FIELD_ID + '_lkid', customer.Id);       
        return pr;
    }
    
    public PageReference saveNewAndDuplicate(){
        if (HasValidationErrors())
            return null;
            
        List<Account_Contact_Role__c> acrList = [SELECT Id, Role__c, Customer__c, Contact__c, Total_Insight__c FROM Account_Contact_Role__c
                            WHERE Id =: id];
        System.debug('acrList.size(): '+acrList.size());
        Account_Contact_Role__c acrRole;
        Contact contact;                    
        try {
            /*if(acrList.size() > 0 && acrList.get(0).Role__c == acr.Role__c){
                upsert acr;
            }*/
            if(acrList.size() > 0){
                acrRole = acrList.get(0);
            }else{
                acrRole = new Account_Contact_Role__c(); 
                acrRole.Customer__c = acr.Customer__c;
            }
            acrRole.Role__c = acr.Role__c;
            acrRole.Contact__c = acr.Contact__c;
            acrRole.Total_Insight__c = acr.Total_Insight__c;
            upsert acrRole;
            contact = [Select id, name from Contact where id =: acrRole.Contact__c]; 
        } catch(System.DMLException e){
            String errorMessage = e.getDMLMessage(0);
            if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));    
                system.debug(errorMessage);
            }
            return null;            
        }
        Schema.DescribeSObjectResult describeResult = controller.getRecord().getSObjectType().getDescribe();
        PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e');
        pr.setRedirect(true);
        pr.getParameters().put('retURL', retURL);
        pr.getParameters().put(CUSTOMER_FIELD_ID, customer.Name);
        pr.getParameters().put(CUSTOMER_FIELD_ID + '_lkid', customer.Id);
        pr.getParameters().put('CF' + CONTACT_FIELD_ID, contact.Name);
        pr.getParameters().put('CF' + CONTACT_FIELD_ID + '_lkid', acrRole.Contact__c);
        return pr;
    }
    
    public PageReference save(){
        String customerFieldId = YSFieldIDs__c.getInstance('YSFieldIDs').Customer__c;
        if (HasValidationErrors())
            return null;        
        try {
            if (mode == Operation.Clone)
                upsert acr.clone(false, true);
            else
                upsert acr;   
        } catch(System.DMLException e){ 
            String errorMessage = e.getDMLMessage(0);
            if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                                   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
            }
            else{                   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));
                system.debug(errorMessage);
            }               
            return null;
        }
        system.debug('customer in save : '+customer);       
        //return (new ApexPages.StandardController(customer)).view();
        String cId = String.valueOf(customer.Id);
        PageReference pageRef = new PageReference('/'+cId);
        cId = cId.subString(0, 15); 
        pageRef.setAnchor(cId+'_'+customerFieldId+'_target');
        return pageRef;
    }
    
    public SelectOption[] getContactRoles() {
        SelectOption[] contactRoles = new SelectOption[]{};
        contactRoles.add(new SelectOption('','--Vælg rolle--'));
        /* Old version before lookup
        for (Lookup_Contact_Roles__c b : [select Id, Name, Active__c from Lookup_Contact_Roles__c where Active__c='Ja' order by Name]) {
            if(KISSRulesMap.get(b.Name) != null)
                contactRoles.add(new SelectOption(b.Id, b.Name));
        }
        */
        for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Type__c, Contact_Roles__c, Contact_Roles__r.Name from KISS_Role_Validation_Rules__c where Type__c = :customer.Type and Contact_Roles__c <>'' and Contact_Roles__r.Active__c='Ja' order by Contact_Roles__r.Name]){             
                contactRoles.add(new SelectOption(rule.Contact_Roles__c, rule.Contact_Roles__r.Name));     
        }
        /* Old code using maps.       
        for (KISS_Role_Validation_Rules__c rule : KISSRulesMap.values()){            
            contactRoles.add(new SelectOption(rule.Contact_Roles__c, rule.Contact_Roles__r.Name));
        }        
        */        
        return contactRoles;
    }
    
    public static testMethod void testController(){
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        
        Account_Contact_Role__c testAcr = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, acc.Id);
        
        Lookup_Contact_Roles__c role1 = 
            new Lookup_Contact_Roles__c(Name = 'Rolle10', Start_Date__c = Date.valueOf('2011-01-01'),
                                        End_Date__c = Date.valueOf('2011-12-31'), SourceId__c = 'rolle10-Id',
                                        Code__c = 'Rolle10' );
        insert role1;
        KISS_Role_Validation_Rules__c rule1 = 
            new KISS_Role_Validation_Rules__c( Name = 'Rolle10',
                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role1.Id);
        insert rule1;
                                               
         //Test create action
        Account_Contact_Role__c acr = new Account_Contact_Role__c();
        acr.Contact__c = contact.Id;
        acr.Customer__c = acc.Id;
        acr.Role__c = role1.Id;         
        ApexPages.StandardController sc = new ApexPages.StandardController(acr);
        //ApexPages.currentPage().getParameters().put('ID', testAcr.Id);
        //ApexPages.currentPage().getParameters().put('clone', 'clone');
        ContactRolesPicklistController con = new ContactRolesPicklistController(sc);                        
        con.customer = acc;
        con.acr = acr;        
        con.save();
        system.debug('Inserted new acr: Acr-org:' + acr.Id + ' Acr-controller: ' + con.acr.Id);         
        System.assertEquals(acr.Id, con.acr.Id);
        System.assertNotEquals(0, con.getContactRoles().size()); 
        
        
        //Test save-new
        Account_Contact_Role__c acr2 = new Account_Contact_Role__c();
        acr2.Contact__c = contact.Id;
        acr2.Customer__c = acc.Id;
        acr2.Role__c = role1.Id;            
        sc = new ApexPages.StandardController(acr2);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr2;
        con.saveNew();
        System.assertEquals(acr.Id, con.acr.Id);
        
        //Test save-new and duplicate
        Account_Contact_Role__c acr3 = new Account_Contact_Role__c();
        acr3.Contact__c = contact.Id;
        acr3.Customer__c = acc.Id;
        acr3.Role__c = role1.Id;          
        sc = new ApexPages.StandardController(acr3);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr3;
        con.saveNewAndDuplicate();
        System.assertEquals(acr3.Id, con.acr.Id); 
        
        //Test validation errors
        Account_Contact_Role__c acr4 = new Account_Contact_Role__c(); 
        //acr4.Role__c = role1.Id; 
        acr4.Customer__c = acc.Id;                  
        sc = new ApexPages.StandardController(acr4);
        con = new ContactRolesPicklistController(sc);                       
        con.customer = acc;
        con.acr = acr4;         
        con.save();
        System.assertEquals(null, con.acr.Id);  
        
        //Test save-new - validation errors
        Account_Contact_Role__c acr5 = new Account_Contact_Role__c();
        acr5.Contact__c = contact.Id;
        acr5.Customer__c = acc.Id;
        //acr5.Role__c = role1.Id;          
        sc = new ApexPages.StandardController(acr5);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr5;
        con.saveNew();
        System.assertEquals(null, con.acr.Id);         
        
        //Schema.DescribeSObjectResult describeResult = sc.getRecord().getSObjectType().getDescribe();
        /*       
        Lookup_Contact_Roles__c role1 = 
            new Lookup_Contact_Roles__c(Name = 'Rolle10', Start_Date__c = Date.valueOf('2011-01-01'),
                                        End_Date__c = Date.valueOf('2011-12-31'), SourceId__c = 'rolle10-Id',
                                        Code__c = 'Rolle10' );
        
        KISS_Role_Validation_Rules__c rule1 = 
            new KISS_Role_Validation_Rules__c( Name = 'Rolle10',
                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde');
        
        Address__c address = new Address__c(Name= 'Klostervangen', Active__c = true, External_Id__c = 'test454',
                                                House_No__c = '34', Postcode__c = '3360');
        insert address;
                                                
        Contact contact = new Contact();
        contact.FirstName = 'test';
        contact.LastName = 'test';
        contact.MobilePhone = 'test';
        contact.Street_P__c = address.Id;
        
        Contact contact2 = new Contact();
        contact2.FirstName = 'test';
        contact2.LastName = 'test';
        contact2.MobilePhone = 'test';
        contact2.Street_P__c = address.Id;
        
        insert contact;
        insert contact2;
        insert role1;  
        insert rule1;
        
        //Test create action
        
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        Account acc = new Account();
        acc.Name = 'Test Customer';
        acc.Customer_No__c = '5436789';
        acc.recordtypeId = customerRecordType2;         
        acc.Cable_Unit__c = cableUnit.Id;
        insert acc;
        
        Account_Contact_Role__c acr = new Account_Contact_Role__c();
        acr.Contact__c = contact.Id;
        acr.Customer__c = acc.Id;
        acr.Role__c = role1.Id;         
        ApexPages.StandardController sc = new ApexPages.StandardController(acr);
        ContactRolesPicklistController con = new ContactRolesPicklistController(sc);                        
        con.customer = acc;
        con.acr = acr;
        con.mode = Operation.Edit;
        con.save();
        system.debug('Inserted new acr: Acr-org:' + acr.Id + ' Acr-controller: ' + con.acr.Id);         
        System.assertEquals(acr.Id, con.acr.Id);
        System.assertNotEquals(0, con.getContactRoles().size());                                    
        //System.assertNotEquals(con.acr.Id, null);
        
        
        //Test save-new
        Account_Contact_Role__c acr2 = new Account_Contact_Role__c();
        acr2.Contact__c = contact2.Id;
        acr2.Customer__c = acc.Id;
        acr2.Role__c = role1.Id;            
        sc = new ApexPages.StandardController(acr2);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr2;
        con.saveNew();
        //System.assertNotEquals(con.acr.Id, null);
        
        //Test validation errors
        Account_Contact_Role__c acr3 = new Account_Contact_Role__c(); 
        //acr3.Role__c = role1.Id; 
        acr3.Customer__c = acc.Id;                  
        sc = new ApexPages.StandardController(acr3);
        con = new ContactRolesPicklistController(sc);                       
        con.customer = acc;
        con.acr = acr3;         
        con.save();
        //System.assertEquals(con.acr.Id, null);  
        
        //Test save-new - validation errors
        Account_Contact_Role__c acr4 = new Account_Contact_Role__c();
        acr4.Contact__c = contact2.Id;
        acr4.Customer__c = acc.Id;
        acr2.Role__c = role1.Id;          
        sc = new ApexPages.StandardController(acr4);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr4;
        con.saveNew();
        //System.assertEquals(con.acr.Id, null); 
        
        //Test save-new - validation errors
        Account_Contact_Role__c acr5 = new Account_Contact_Role__c();
        acr5.Contact__c = contact2.Id;
        acr5.Customer__c = acc.Id;
        acr5.Role__c = role1.Id;          
        sc = new ApexPages.StandardController(acr5);
        con = new ContactRolesPicklistController(sc);           
        con.customer = acc;
        con.acr = acr5;
        con.saveNewAndDuplicate();         
        */
    }  
    
    /*public static testMethod void testblankCustomer(){
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();     
        String roleName = 'Role' + String.valueOf(Crypto.getRandomInteger());
        
        Lookup_Contact_Roles__c role = new Lookup_Contact_Roles__c(Name = roleName, Start_Date__c = Date.valueOf('2011-01-01'), End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = String.valueOf(Crypto.getRandomInteger()), Code__c = roleName );
        insert role;        
        
        KISS_Role_Validation_Rules__c rule = new KISS_Role_Validation_Rules__c( Name = roleName, Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role.Id );
        insert rule;
                
        Account_Contact_Role__c acr = new Account_Contact_Role__c(Contact__c = contact.Id, Role__c = role.Id); 
        //Insert fake-KISS-ID to bypass validation. We dont have time to wait for Cast iron update (ex. 4 secs)
        acr.ContactRoleExternalID__c = acr + String.valueOf(Crypto.getRandomInteger());
        insert acr;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acr);
        ApexPages.currentPage().getParameters().put('ID', acr.Id);
        ApexPages.currentPage().getParameters().put('clone', 'clone');
        ContactRolesPicklistController con = new ContactRolesPicklistController(sc);
        con.HasValidationErrors();               
    }*/
    
}