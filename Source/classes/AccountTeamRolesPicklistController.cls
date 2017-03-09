public class AccountTeamRolesPicklistController {

    public Account_Team__c teamRole {get;set;}
    public Account customer {get;set;}
    private String retURL = '';
    public enum Operation {NewObj, Edit,Clone}
    public Operation mode;
    public String mode_string {get{return mode.name();}}    
    public ApexPages.StandardController controller;  
    private Map <String, KISS_Role_Validation_Rules__c> KISSRulesMap; 
    
    //Retriving environment unique field ids for customer lookup fields
    public YSFieldIDs__c ysFieldIds = YSFieldIDs__c.getInstance('YSFieldIDs');
    private String CUSTOMER_FIELD_ID = ysFieldIds.InternalRoleCustomerLookup__c;    
    
    public AccountTeamRolesPicklistController(ApexPages.standardController controller){ 
        this.controller = controller;
        Id id = ApexPages.currentPage().getParameters().get('id');
        System.debug('%%%%ID'+id);
        String clone = ApexPages.currentPage().getParameters().get('clone');
        mode = Operation.NewObj;        
        if(id != null){ 
            this.teamRole = Database.query('SELECT Id, Customer_Team_Role__c, Customer__c, Customer_Team_Member__c FROM Account_Team__c WHERE id = :id'); 
            if(clone != null)
                mode = Operation.Clone;
            else{               
                mode = Operation.Edit;  
            }       
        }
        else{
            this.teamRole =   (Account_Team__c)controller.getRecord();
            mode = Operation.NewObj;
        }
        
        if(teamRole.Customer__c != null){
            this.customer = [Select Id, Name, Type from Account where Id= :teamRole.Customer__c];
        }   
        //RetUrl skal kun bruges ved redigering
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        KISSRulesMap  = new Map <String, KISS_Role_Validation_Rules__c>();
        for(KISS_Role_Validation_Rules__c rule : [select Id, Name, Type__c, Customer_Team_Role__c, Customer_Team_Role__r.Name from KISS_Role_Validation_Rules__c where Type__c = 'YouSee Customer Teams' and Customer_Team_Role__c <>'' and Customer_Team_Role__r.Active__c='Ja']){                
            KISSRulesMap.put(rule.Name, rule);      
        }
    }
    
    public boolean HasValidationErrors(){
        boolean errors = false;
        if(teamRole.Customer_Team_Member__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'YouSee kontakt: Du skal vælge en kontaktperson'));
            errors = true;
        }
        if(teamRole.Customer_Team_Role__c == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Rolle: Du skal vælge en rolle'));
            errors = true;
        }
        if(teamRole.Customer__c == null){
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
                upsert teamRole.clone(false, true);
            else
                upsert teamRole;    
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
    
    public PageReference save(){
    	String customerFieldId = YSFieldIDs__c.getInstance('YSFieldIDs').Customer_Team__c;
        if (HasValidationErrors())
            return null;        
        try {
            if (mode == Operation.Clone)
                upsert teamRole.clone(false, true);
            else
                upsert teamRole;     
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
        //return (new ApexPages.StandardController(teamRole)).view();
        system.debug('customer team in save : '+teamRole);       
        String cId = String.valueOf(teamRole.Customer__c);
        PageReference pageRef = new PageReference('/'+cId);
        cId = cId.subString(0, 15); 
        //pageRef.setRedirect(true);
        //pageRef.setAnchor(cId+'_'+customerFieldId+'_target');
        pageRef.setAnchor(cId+'_'+customerFieldId+'_target');
		return pageRef;
    }
    
        
    public SelectOption[] getContactRoles() {
        SelectOption[] contactRoles = new SelectOption[]{};
        contactRoles.add(new SelectOption('','--Vælg rolle--'));        
        /* Old version before lookup
        for (Lookup_Account_Team_Role__c b : [select Id, Name, Active__c from Lookup_Account_Team_Role__c where Active__c='Ja' order by Name]) {
            if(KISSRulesMap.get(b.Name) != null)
                contactRoles.add(new SelectOption(b.Id, b.Name));
        }
        */
        for (KISS_Role_Validation_Rules__c rule : KISSRulesMap.values()){            
        	contactRoles.add(new SelectOption(rule.Customer_Team_Role__c, rule.Customer_Team_Role__r.Name));
        }        
        return contactRoles;
    }
    
    public static testMethod void testController(){
    	Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
    	
        Lookup_Account_Team_Role__c role1 = 
            new Lookup_Account_Team_Role__c(Name = 'Rolle1', Start_Date__c = Date.valueOf('2011-01-01'),
                                        End_Date__c = Date.valueOf('2100-01-01'), SourceId__c = 'rolle1-Id',
                                        Code__c = 'Rolle1'); 
        insert role1;
        
        KISS_Role_Validation_Rules__c rule1 = 
            new KISS_Role_Validation_Rules__c( Name = 'Rolle1',
                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role1.Id);
       	insert rule1;
       	
        Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c();
        member1.SourceId__c = 'test23';
        member1.Code__c = 'M9852314176';
        Lookup_Account_Team_Member__c member2 = new Lookup_Account_Team_Member__c();
        member2.SourceId__c = 'test45';
        member1.Code__c = 'M45698712';
        
        insert member1;
        insert member2;
        
        //Test create action
        Account_Team__c teamRole = new Account_Team__c();
        teamRole.Customer_Team_Member__c = member1.Id;
        teamRole.Customer__c = acc.Id;
        teamRole.Customer_Team_Role__c = role1.Id;            
        ApexPages.StandardController sc = new ApexPages.StandardController(teamRole);
        AccountTeamRolesPicklistController con = new AccountTeamRolesPicklistController(sc);                        
        con.customer = acc;
        con.teamRole = teamRole;
        
        con.save();
        system.debug('Inserted new at: AT-org:' + teamRole.Id + ' AT-controller: ' + con.teamRole.Id);          
        System.assertEquals(teamRole.Id, con.teamRole.Id);
        System.assertNotEquals(0, con.getContactRoles().size()); 
        
        
        //Test save-new
        Account_Team__c teamRole2 = new Account_Team__c();
        teamRole2.Customer_Team_Member__c = member2.Id;
        teamRole2.Customer__c = acc.Id;
        teamRole2.Customer_Team_Role__c = role1.Id;           
        sc = new ApexPages.StandardController(teamRole2);
        con = new AccountTeamRolesPicklistController(sc);           
        con.customer = acc;
        con.teamRole = teamRole2;
        con.saveNew();
        System.assertEquals(teamRole2.Id, con.teamRole.Id);
        
        //Test validation errors
        Account_Team__c teamRole3 = new Account_Team__c();            
        teamRole3.Customer__c = acc.Id;                   
        sc = new ApexPages.StandardController(teamRole3);
        con = new AccountTeamRolesPicklistController(sc);                       
        con.customer = acc;
        con.teamRole = teamRole3;           
        con.save();
        System.assertEquals(null, con.teamRole.Id);
               
    }
    
    public static testMethod void testControllerID(){
    	
    	Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
    	
        Lookup_Account_Team_Role__c role1 = 
            new Lookup_Account_Team_Role__c(Name = 'Rolle1', Start_Date__c = Date.valueOf('2011-01-01'),
                                        End_Date__c = Date.valueOf('2100-01-01'), SourceId__c = 'rolle1-Id',
                                        Code__c = 'Rolle1'); 
        insert role1;
        
        KISS_Role_Validation_Rules__c rule1 = 
            new KISS_Role_Validation_Rules__c( Name = 'Rolle1',
                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role1.Id);
       	insert rule1;
       	
        Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c();
        member1.SourceId__c = 'test23';
        member1.Code__c = 'M9852314176';
        Lookup_Account_Team_Member__c member2 = new Lookup_Account_Team_Member__c();
        member2.SourceId__c = 'test45';
        member1.Code__c = 'M45698712';
        
        insert member1;
        insert member2;
        
        //Test create action
        Account_Team__c teamRole = new Account_Team__c();
        teamRole.Customer_Team_Member__c = member1.Id;
        //teamRole.Customer__c = acc.Id;
        teamRole.Customer_Team_Role__c = role1.Id;            
        ApexPages.StandardController sc = new ApexPages.StandardController(teamRole);
        PageReference pageRef = Page.AccountTeamRolesPicklistView;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('Id',teamRole.Id);
        System.debug('TEST CODE'+ApexPages.currentPage().getParameters().get('id'));
        AccountTeamRolesPicklistController con = new AccountTeamRolesPicklistController(sc);                        
        con.customer = acc;
        con.teamRole = teamRole;
        
        con.save();
        system.debug('Inserted new at: AT-org:' + teamRole.Id + ' AT-controller: ' + con.teamRole.Id);          
        System.assertEquals(teamRole.Id, con.teamRole.Id);
        System.assertNotEquals(0, con.getContactRoles().size()); 
        
        
        //Test save-new
        Account_Team__c teamRole2 = new Account_Team__c();
        teamRole2.Customer_Team_Member__c = member2.Id;
        teamRole2.Customer__c = acc.Id;
        teamRole2.Customer_Team_Role__c = role1.Id;           
        sc = new ApexPages.StandardController(teamRole2);
        con = new AccountTeamRolesPicklistController(sc);           
        con.customer = acc;
        con.teamRole = teamRole2;
        con.saveNew();
        System.assertEquals(teamRole2.Id, con.teamRole.Id);
        
        //Test validation errors
        Account_Team__c teamRole3 = new Account_Team__c();            
        teamRole3.Customer__c = acc.Id;                   
        sc = new ApexPages.StandardController(teamRole3);
        con = new AccountTeamRolesPicklistController(sc);                       
        con.customer = acc;
        con.teamRole = teamRole3;           
        con.save();
        System.assertEquals(null, con.teamRole.Id);
               
    }
}