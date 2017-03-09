global class SC_CheckPortalAdminRolesImpl implements Database.Batchable<sObject>, Database.Stateful {   
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    
    public Double failedUpdates{get; set;}  
    public String email {get; set;}
    public User YS_Sales_User {get; set;}
    public boolean isTest {get; set;}
    public Id testAcr {get; set;}
    public Double totalAdminRoles {get; set;}   
    
    //This batch job only activates cable units.
    global SC_CheckPortalAdminRolesImpl(String email, boolean isTest, Id testAcr){
         failedUpdates = 0;
         this.totalAdminRoles = 0;         
         this.email = email;
         this.isTest = isTest;
         this.testAcr = testAcr;               
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';        
        if(isTest){
            query = 'Select Id from Account where IsPersonAccount = false and Id = : testAcr';          
        }
        else{                  
            query = 'Select Id from Account where IsPersonAccount = false and ParentId <>\'\' and SuperiorAccount__c IN (Select Customer__c from Account_Contact_Role__c where Role__c = :portalUserAdministratorRoleId)';
        }
        return Database.getQueryLocator(query);        
     }  
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){        
        //Must be run with scope = 1 - always 
        List<Account_Contact_Role__c> newAdminRoles = new List<Account_Contact_Role__c>();
        for(Account node: [Select Id, SuperiorAccount__c from Account where Id IN : scope]){
            newAdminRoles.clear();
            List<Account_Contact_Role__c> adminRoles = null;
            //First we obtain the user access roles from production environment
            try{
                adminRoles = [Select Id, Contact__c from Account_Contact_Role__c where Role__c = :portalUserAdministratorRoleId and Customer__c = : node.SuperiorAccount__c];
            }catch(Exception e){}
            
            //To handle barebone test runs
            if(adminRoles == null || adminRoles.size() == 0)
                continue;
                    
            //First we identify all registered portal admins on superior hierarchy node
            Set <Id> adminContacts = new Set <Id>();            
            for(Account_Contact_Role__c adminRole: adminRoles){
                if(!adminContacts.contains(adminRole.Contact__c))
                    adminContacts.add(adminRole.Contact__c);                                        
            }
            system.debug('Michel: ' + adminContacts);
            for(Contact contact: [Select Id from Contact where IsPersonAccount = false and Id IN : adminContacts and Id NOT IN (Select Contact__c from Account_Contact_Role__c where Role__c =:portalUserAdministratorRoleId and Customer__c = :node.Id and Contact__c IN : adminContacts)]){
                system.debug('Inside');
                Account_Contact_Role__c acr_new = new Account_Contact_Role__c(Contact__c = contact.Id, Role__c = portalUserAdministratorRoleId, Customer__c = node.Id);
                newAdminRoles.add(acr_new);     
            }
        }//End outer for
        totalAdminRoles += newAdminRoles.size();
        
        Database.SaveResult[] insertResult;     
        try {       
            insertResult = Database.insert(newAdminRoles, false);
                                        
        } catch (Exception e) {                                                         
            System.debug('Failed creating new admin roles (SC_CheckPortalAdminRolesImpl#execute): ' + e.getMessage());          
        }
        
        if(insertResult != null){
            for(Database.SaveResult ua : insertResult){
                 if(!ua.isSuccess()){
                     failedUpdates++;                                  
                } 
            }
        }//End if
    }
    
    global void finish(Database.BatchableContext ctx){ 
        if(email != null && email !=''){
            AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
                            FROM AsyncApexJob WHERE id = :ctx.getJobId()];
            String emailMessage = 'The batch job (Apex class: SC_CheckPortalAdminRolesImpl) has completed.\n\n' 
                                + 'The batch job checks if all portal admins have access to all nodes in the customer hierarchy. If not, the necessary roles of type Selvbetjeingsadministrator are created.\n'
                                + 'Number of new admin roles created: ' + totalAdminRoles + '.\n'
                                + 'Number of transactions: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
                                + ' processed without any exceptions thrown. \n'                           
                                + 'Numbers of transactions that threw unhandled exceptions: ' + a.numberOfErrors + '.\n'
                                + 'Of the transactions that executed without error, ' + failedUpdates
                                + ' records were not updated successfully.';                            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {email}; 
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Service-Center Batch Job Summary');
            mail.setSubject('Service-Center batch job completed: Check portal admin roles in customer hierarchy');
            mail.setPlainTextBody(emailMessage);
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        } 
     } 
     
     public static testMethod void testExecuteBatch(){
        Account superiorHierarchyAccount = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Account cableUnit = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        
        cableUnit.ParentId = superiorHierarchyAccount.Id;        
        cableUnit.SuperiorAccount__c = superiorHierarchyAccount.Id;
        update cableUnit;    
        
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
        /*Account_Contact_Role__c acr = new Account_Contact_Role__c(
                                      Role__c = portalUserAdministratorRoleId, 
                                      Customer__c = superiorHierarchyAccount.Id,
                                      Contact__c = contact.Id);
        insert acr;*/
        
        User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];            
        Test.startTest();
        System.runAs(CastIron){
            //Run batch job as Cast Iron. Batch job is invoked with only one id to save ressources.
            SC_CheckPortalAdminRolesImpl impl = new SC_CheckPortalAdminRolesImpl('mkha@yousee.dk', true, cableUnit.Id);
            Database.executeBatch(impl, 1);             
        } 
        Test.stopTest();
    }       
}

/*
global class SC_CheckPortalAdminRolesImpl implements Database.Batchable<sObject>, Database.Stateful {   
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    
    public Double failedUpdates{get; set;}  
    public String email {get; set;}
    public User YS_Sales_User {get; set;}
    public boolean isTest {get; set;}
    public Id testAcr {get; set;}
    public Double totalAdminRoles {get; set;}   
    
    //This batch job only activates cable units.
    global SC_CheckPortalAdminRolesImpl(String email, boolean isTest, Id testAcr){
         failedUpdates = 0;
         this.totalAdminRoles = 0;         
         this.email = email;
         this.isTest = isTest;
         this.testAcr = testAcr;               
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';        
        if(isTest){
            query = 'Select Id from Contact where Id = : testAcr';
            //query = 'Select Id from Account where IsPersonAccount = false and Id = : testAcr';
        }
        else{ 
            query = 'Select Id from Contact where IsPersonAccount = false and HierarchyAccount__c<>\'\' and HierarchyAccount__c IN (Select Customer__c from Account_Contact_Role__c where Role__c = :portalUserAdministratorRoleId)';                  
            //query = 'Select Id from Account where IsPersonAccount = false and ParentId = null and Id IN (Select Customer__c from Account_Contact_Role__c where Role__c = :portalUserAdministratorRoleId)';
        }
        return Database.getQueryLocator(query);
     }
     
     global void execute(Database.BatchableContext ctx, List<Sobject> scope){       
        //For each superior hierarchy account, build a list of all child nodes  
        for(Contact contact: [Select Id, HierarchyAccount__c from Contact where Id IN : scope]){
            //To handle barebone tests
            if(contact.HierarchyAccount__c == null)
                continue; 
            
            Account_Contact_Role__c adminRole = null;
            try{
                //First we determine if this contact has any admin role on hierarchy account
                adminRole = [Select Id from Account_Contact_Role__c where Role__c =:portalUserAdministratorRoleId and Contact__c = :contact.Id and Customer__c = :contact.HierarchyAccount__c limit 1];
            }catch(Exception e){system.debug('No admin for contact: ' + contact.Id);}
            
            //We don't need to continue for contacts having ordinary roles.            
            if(adminRole == null)   
                continue;
                                           
            boolean endOfStructure = false;            
            List<Account> levelAccounts = new List<Account>();
            Set<Id> levelAccountIds = new Set<Id>();
            Set <Id> allAccountIds = new Set<Id>();            
            Integer level = 0;
            while (!endOfStructure ){                               
                try{
                    if(level == 0 )
                        levelAccounts = [select Id from Account WHERE ParentId = :contact.HierarchyAccount__c];
                    else{
                        levelAccounts.clear();  
                        levelAccounts = [select Id from Account WHERE ParentId IN : levelAccountIds];
                    }
                }
                catch(Exception e){
                    System.debug(e.getMessage());   
                }           
                level++;                
                if(levelAccounts.size() == 0)  
                    endOfStructure = true;
                else{ 
                    levelAccountIds.clear();            
                    for(Account acc: levelAccounts){                    
                        if(!levelAccountIds.contains(acc.Id))
                            levelAccountIds.add(acc.Id);                        
                        //Add child to child set
                        if(!allAccountIds.contains(acc.Id))
                            allAccountIds.add(acc.Id);  
                    }//End for structure
                }//End else structure               
            }//End outer while
            
            Set<Id> adminAccounts = new Set<Id>();
            for(Account_Contact_Role__c role: [Select Id, Customer__c, Contact__c from Account_Contact_Role__c where Role__c =:portalUserAdministratorRoleId and Contact__c = :contact.Id]){
                if(!adminAccounts.contains(role.Customer__c))
                    adminAccounts.add(role.Customer__c);        
            }
            
            List<Account_Contact_Role__c> newAdminRoles = new List<Account_Contact_Role__c>();
            //For each child account we check if all contacts have the mandatory admin role. If not, we add a new one.          
            for(Account account: [Select Id from Account where IsPersonAccount = false and Id IN : allAccountIds]){
                if(!adminAccounts.contains(account.Id)){
                    Account_Contact_Role__c acr_new = new Account_Contact_Role__c(Contact__c = contact.Id, Role__c = portalUserAdministratorRoleId, Customer__c = account.Id);
                    newAdminRoles.add(acr_new); 
                }           
            }
            Database.SaveResult[] insertResult;     
            try {       
                insertResult = Database.insert(newAdminRoles, false);                                       
            } catch (Exception e) {                                                         
                System.debug('Failed creating new admin roles (SC_CheckPortalAdminRolesImpl#execute): ' + e.getMessage());          
            }
            totalAdminRoles += newAdminRoles.size();
            
            if(insertResult != null){
                for(Database.SaveResult ua : insertResult){
                    if(!ua.isSuccess())
                        failedUpdates++;
                }
            }//End if
        }//End outer for 
               
    }//End execute method 
    
    global void finish(Database.BatchableContext ctx){ 
        if(email != null && email !=''){
            AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
                            FROM AsyncApexJob WHERE id = :ctx.getJobId()];
            String emailMessage = 'The batch job (Apex class: SC_CheckPortalAdminRolesImpl) has completed.\n\n' 
                                + 'The batch job checks if all portal admins have access to all nodes in the customer hierarchy. If not, the necessary roles of type Selvbetjeingsadministrator are created.\n'
                                + 'Number of new admin roles created: ' + totalAdminRoles + '.\n'
                                + 'Number of transactions: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
                                + ' processed without any exceptions thrown. \n'                           
                                + 'Numbers of transactions that threw unhandled exceptions: ' + a.numberOfErrors + '.\n'
                                + 'Of the transactions that executed without error, ' + failedUpdates
                                + ' records were not updated successfully.';                            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {email}; 
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Service-Center Batch Job Summary');
            mail.setSubject('Service-Center batch job completed: Check portal admin roles in customer hierarchy');
            mail.setPlainTextBody(emailMessage);
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        } 
     } 
     
     public static testMethod void testExecuteBatch(){
        Account superiorHierarchyAccount = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
        
        contact = [Select Id, HierarchyAccount__c from Contact where Id = :contact.Id];
        contact.HierarchyAccount__c = superiorHierarchyAccount.Id;
        update contact;
                
        Test.startTest();       
        //Run batch job as Cast Iron. Batch job is invoked with only one id to save ressources.
        SC_CheckPortalAdminRolesImpl impl = new SC_CheckPortalAdminRolesImpl('mkha@yousee.dk', true, contact.Id);
        Database.executeBatch(impl);
        Test.stopTest();
    }       
}
*/