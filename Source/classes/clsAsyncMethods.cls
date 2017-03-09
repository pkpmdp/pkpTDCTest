/*
    @Author: mkha@yousee.dk
    Description: Used for YS related Service-Center functionality when reparenting a customer and activating and deactivating cable units for portal use.
        
    Test types:
    Primary: Test as much functionality as possible.
    Secondary: Only some code fragments are tested. Those classes have their own primary test classes.
    
    Test class: Due to complexity, all functionality has been manually tested.
         
*/
public class clsAsyncMethods { 
    //Retrieve Salesforce ids for user roles in portal
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    
    //Contains reference to a context report showing related addresses in portal order.
    private static String orderGroupReportId = ServiceCenter_CustomSettings__c.getInstance('Order Group Report').Value__c;
    
    //Retrieve case information for YFF
    private static String caseDepartment = ServiceCenter_CustomSettings__c.getInstance('Case Department').Value__c;
    private static String caseProduct = ServiceCenter_CustomSettings__c.getInstance('Case Product').Value__c;
    
    //Retrieve Salesforce ids for portal user profiles in Service-Center
    private static String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User') != null ?  ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c : null;
    private static String portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator') != null ? ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c : null;
   
    
    /*
        This future method is called each time SC_Activity_Log__c is updated with a classic or Kasia2 order number. If the order id matches a Kasia case created in Salesforce, 
        then we associate the two to make it possible to see case references in SC_Activity_Log__c
    */
    @future
    public static void bindKasiaCaseAndPackageChange(Set <Id> logEntries){
        
        List<SC_Activity_Log__c> activity_log = new List<SC_Activity_Log__c>();        
        Map<String, Id> OrderNumberWithKasiaCase = new Map<String, Id>();
        Map<Id, SC_Activity_Log__c> caseWithActivityLog = new Map<Id, SC_Activity_Log__c>();
        //Ensures are assigned to correct queue after processing
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        
        for(Case portalCase: [Select Id, Subject from Case where Origin like '%Kasia%' and (LastModifiedDate = today OR LastModifiedDate = yesterday)]){
            if(portalCase.Subject != null && portalCase.Subject.indexOf('Manuel behandling') !=-1){
                String subject = portalCase.Subject.substring(portalCase.Subject.indexOf(':')+ 1, portalCase.Subject.lastIndexOf(')'));
                if(subject != null || subject !=''){
                    String kasiaOrderNumber = portalCase.Subject.substring(portalCase.Subject.indexOf(':')+ 1, portalCase.Subject.lastIndexOf(')')).trim();         
                    if(OrderNumberWithKasiaCase.get(kasiaOrderNumber) == null)
                        OrderNumberWithKasiaCase.put(kasiaOrderNumber, portalCase.Id);
                }
            }               
        }        
        
        List<SC_Activity_Log__c> log_entries_update = new List<SC_Activity_Log__c>();
        for(SC_Activity_Log__c activity: [Select Id, Case__c, Kasia_Order_Number__c, OrderGroupId__c, Kasia_Classic_Order_Number__c from SC_Activity_Log__c where Id IN :logEntries]){
            boolean match = false;
            if(OrderNumberWithKasiaCase.get(activity.Kasia_Order_Number__c) != null){
                activity.Case__c = OrderNumberWithKasiaCase.get(activity.Kasia_Order_Number__c);
                match = true;
            }
            else if(OrderNumberWithKasiaCase.get(activity.Kasia_Classic_Order_Number__c) != null){
                activity.Case__c = OrderNumberWithKasiaCase.get(activity.Kasia_Classic_Order_Number__c);
                match = true;
            } 
            if(match){
                activity.Kasia_Order_Status__c = 'Error';
                log_entries_update.add(activity);
                if (caseWithActivityLog.get(activity.Case__c) == null)
                    caseWithActivityLog.put(activity.Case__c, activity);    
                }           
        }
        
        //Update matched cases with link to Service-Center log entry
        List<Case> caseTobeUpdated = new List<Case>();
        for(Case c: [Select Id, Subject, Description from Case where Id IN :caseWithActivityLog.keySet()]){
            SC_Activity_Log__c activity = caseWithActivityLog.get(c.Id); 
            if(activity != null){
                String baseURL = URL.getSalesforceBaseUrl().toExternalForm();       
                //Fixes a problem where Salesforce sometime inserts http instead of https
                if (baseURL.startsWith('http:')){
                    baseURL = baseURL.replaceFirst('http:', 'https:');
                }               
                String link = 'Link til omkoblingsordre: ' + baseURL + '/' + activity.Id + '\n';
                link += 'Link til øvrige adresser i omkoblingsordre: ' + baseURL + '/' + orderGroupReportId + '?pv0=' + activity.OrderGroupId__c;           
                c.Description =  link + '\n\n' + c.Description;
                c.Subject = c.Subject + ' - Visiteret';
                //Assign case directly to YFF Visitering after processing
                c.Department__c = caseDepartment;
                c.Product_2__c = caseProduct;
                c.AccountId = activity.Cable_Unit__c;
                c.setOptions(dmo);              
                caseTobeUpdated.add(c);
            }
        }             
        if(log_entries_update.size() != 0)
            Database.SaveResult[] resultsLogs = Database.update(log_entries_update, false);
        if(caseTobeUpdated.size() != 0)
            Database.SaveResult[] resultsLogs = Database.update(caseTobeUpdated, false);
        
    }//End method
   
   /*
    Updates user object whenever a contact is updated from Salesforce or portal. Future method is used to avoid the mixed dml issue in Salesforce
    when updating a contact and user in the same context.          
   */
   @future
   public static void updateUserObject(Set<Id> contacts){
        Map<Id, Contact> ContactMap = new Map<Id, Contact>();
        for(Contact contact: [Select Id, Email, FirstName, LastName from Contact where Id IN :contacts]){
            if(ContactMap.get(contact.Id)== null)
                ContactMap.put(contact.Id, contact);    
        }       
        List <User> portal_users = new List<User>();
        for(User portal_user: [Select Id, Email, FirstName, LastName, ContactId from User where ContactId IN :contacts and (Profile.Name =: portalUserProfile or Profile.Name =: portalAdminUser)]){
            portal_user.FirstName = ContactMap.get(portal_user.ContactId).FirstName; 
            portal_user.LastName = ContactMap.get(portal_user.ContactId).LastName;
            portal_user.Email = ContactMap.get(portal_user.ContactId).Email;
            portal_user.Username = ContactMap.get(portal_user.ContactId).Email;                                             
            portal_users.add(portal_user);  
        }
        if(!Recursioncontrol.runonce){
            Recursioncontrol.runonce = true;        
            if(portal_users.size() > 0)
                Database.update(portal_users);
        }   
   }
   
   /* Static version used when invoked from batch job contexts - contains the same code as checkCableUnitPortalStatus with future annotation
      Checks whether cable units with assigned portal roles for Service-Center have the field Service_Center_Customer_Agreement__c set to true.
      This update is later reflected in warehouse causing Clear subscriptions to be loaded into Salesforce.         
   */   
   public static void checkCableUnitPortalStatusStatic(Set<Id> cable_unit_customers, boolean insertMode){
        RecursionControl.runonce = true;
        List <Cable_Unit__c> cableUnitsToBeUpdated = new List<Cable_Unit__c>();                        
        if(insertMode){         
            for(Cable_Unit__c cable_unit: [Select Id, Service_Center_Customer_Agreement__c from Cable_Unit__c where Id IN (Select Cable_Unit__c from Account where Id IN : cable_unit_customers)]){
                //Enable cable unit to be Service-Center enabled in the integration
                if(cable_unit.Service_Center_Customer_Agreement__c == false){                   
                    cable_unit.Service_Center_Customer_Agreement__c = true;
                    cableUnitsToBeUpdated.add(cable_unit);                  
                }               
            }           
        } 
        else{
            Set <Id> cable_units = new Set<Id>();
            //We need extra for-structure to do analysis based on Account and Account_Contact_Role__c because nested sub queries are not allowed
            for(Account account: [Select Id, Cable_Unit__c from Account where Id IN : cable_unit_customers and Id NOT IN (Select customer__c from Account_Contact_Role__c where Customer__c IN : cable_unit_customers and (Role__c = :portalUserRoleId OR Role__c = :portalUserAdministratorRoleId))]){
                if(!cable_units.contains(account.Cable_Unit__c))
                    cable_units.add(account.Cable_Unit__c);         
            }           
            //Once we know which cable units to update, we traverse the Set and update if necessary
            for(Cable_Unit__c cable_unit: [Select Id, Service_Center_Customer_Agreement__c from Cable_Unit__c where Id IN : cable_units]){              
                if(cable_unit.Service_Center_Customer_Agreement__c == true){                    
                    cable_unit.Service_Center_Customer_Agreement__c = false;
                    cableUnitsToBeUpdated.add(cable_unit);
                }                       
            }
        }        
        //First we update the cable units - this will not trigger any outbound
        if(cableUnitsToBeUpdated.size() > 0)
            Database.SaveResult[] resultsAccount = Database.update(cableUnitsToBeUpdated);        
        //Now, update account to trigger outbound
        List<Account> accountsTobeUpdated = [Select Id from Account where Id IN : cable_unit_customers];        
        if(accountsTobeUpdated != null && accountsTobeUpdated.size() > 0 )
            Database.SaveResult[] resultsAccount = Database.update(accountsTobeUpdated);
    }//End method
     
   
   /* Future version used when invoked from user contexts - contains the same code as checkCableUnitPortalStatus with static context 
      Checks whether cable units with assigned portal roles for Service-Center have the field Service_Center_Customer_Agreement__c set to true.
      This update is later reflected in warehouse causing Clear subscriptions to be loaded into Salesforce.         
   */
   @future
   public static void checkCableUnitPortalStatus(Set<Id> cable_unit_customers, boolean insertMode){
        RecursionControl.runonce = true;
        List <Cable_Unit__c> cableUnitsToBeUpdated = new List<Cable_Unit__c>();                        
        if(insertMode){         
            for(Cable_Unit__c cable_unit: [Select Id, Service_Center_Customer_Agreement__c from Cable_Unit__c where Id IN (Select Cable_Unit__c from Account where Id IN : cable_unit_customers)]){
                //Enable cable unit to be Service-Center enabled in the integration
                if(cable_unit.Service_Center_Customer_Agreement__c == false){                   
                    cable_unit.Service_Center_Customer_Agreement__c = true;
                    cableUnitsToBeUpdated.add(cable_unit);                  
                }               
            }           
        } 
        else{
            Set <Id> cable_units = new Set<Id>();
            //We need extra for-structure to do analysis based on Account and Account_Contact_Role__c because nested sub queries are not allowed
            for(Account account: [Select Id, Cable_Unit__c from Account where Id IN : cable_unit_customers and Id NOT IN (Select customer__c from Account_Contact_Role__c where Customer__c IN : cable_unit_customers and (Role__c = :portalUserRoleId OR Role__c = :portalUserAdministratorRoleId))]){
                if(!cable_units.contains(account.Cable_Unit__c))
                    cable_units.add(account.Cable_Unit__c);         
            }           
            //Once we know which cable units to update, we traverse the Set and update if necessary
            for(Cable_Unit__c cable_unit: [Select Id, Service_Center_Customer_Agreement__c from Cable_Unit__c where Id IN : cable_units]){              
                if(cable_unit.Service_Center_Customer_Agreement__c == true){                    
                    cable_unit.Service_Center_Customer_Agreement__c = false;
                    cableUnitsToBeUpdated.add(cable_unit);
                }                       
            }
        }        
        //First we update the cable units - this will not trigger any outbound
        if(cableUnitsToBeUpdated.size() > 0)
            Database.SaveResult[] resultsAccount = Database.update(cableUnitsToBeUpdated);        
        //Now, update account to trigger outbound
        List<Account> accountsTobeUpdated = [Select Id from Account where Id IN : cable_unit_customers];        
        if(accountsTobeUpdated != null && accountsTobeUpdated.size() > 0 )
            Database.SaveResult[] resultsAccount = Database.update(accountsTobeUpdated);
    }//End method
     
    /* 
        This method recalculates all the childs with new reference to SuperiorAccount if ParentId is changed. 
        In addition, user roles are automatically added to the childs if the new parent is portal enabled.
    */
    @future
    public static void updateAccountHierarchy_Parent_Update(Set<Id> accountHierarchyUpdate, boolean toNewParent, boolean newCustomer){
        List <Account> accountsToBeUpdated = new List <Account>();
        List<Account> levelAccounts;
        Set<Id> levelAccountIds;
        List<Account_Contact_Role__c> newRoles = new List<Account_Contact_Role__c>();                           
        for(Account node: [Select Id, SuperiorAccount__c, ParentId, Parent.SuperiorAccount__c from Account where Id IN : accountHierarchyUpdate]){
            //Skip this logic if new customer
            if(newCustomer == false){        
                accountsToBeUpdated.add(node);            
                if(toNewParent){
                    //If parent is not superior account, insert the SuperiorAccount__c of the new parent node into this account
                    if(node.parent.SuperiorAccount__c != null)
                        node.SuperiorAccount__c = node.parent.SuperiorAccount__c;
                    else//If parent is superior account, then insert a direct reference to the parent account
                        node.SuperiorAccount__c = node.ParentId;                
                }
                else
                    node.SuperiorAccount__c = null; 
                boolean endOfStructure = false; 
                levelAccounts = new List<Account>();
                levelAccountIds = new Set<Id>();
                Integer level = 0;
                while (!endOfStructure ){                               
                    try{
                        if(level == 0 )
                            levelAccounts = [select Id from Account WHERE ParentId = :node.Id];
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
                        }               
                        //Update all accounts with new superiorAccountID                
                        for(Account account: [select Id, SuperiorAccount__c from Account WHERE Id IN :levelAccountIds ]){                   
                            if(toNewParent)
                                account.SuperiorAccount__c = node.SuperiorAccount__c;
                            else
                                account.SuperiorAccount__c = node.Id;   
                            accountsToBeUpdated.add(account);   
                        }
                    }               
                }//End while
            }//Closes if not newCustomer           
            
            //Adds user-related roles to new customer   
            if(toNewParent || newCustomer){                                     
                for(Account node2: [Select Id, ParentId from Account where Id IN :accountHierarchyUpdate]){
                    for(Account_Contact_Role__c acr: [Select Id, Contact__c, Role__c from Account_Contact_Role__c where Customer__c = : node2.ParentId and (Role__c = : portalUserRoleId OR Role__c = : portalUserAdministratorRoleId)]){
                        Account_Contact_Role__c acr_new = new Account_Contact_Role__c(Contact__c = acr.Contact__c, Role__c = acr.Role__c, Customer__c = node2.Id);
                        newRoles.add(acr_new);                      
                    }
                }               
            }//End Role update            
        }//End for-structure
        
        //Update records        
        if(!RecursionControl.runonce){
            RecursionControl.runonce = true;                            
            if(accountsToBeUpdated.size() > 0)
                Database.SaveResult[] resultsAccount = Database.update(accountsToBeUpdated);
            if(newRoles.size() > 0)                                     
                Database.SaveResult[] resultsAccount = Database.insert(newRoles, true);
        }
    }//End method 
    
    /* 
        This method clones all user related contact roles on parent node in new hierarchy to new node. This automatically grants existing users access to new node in hierarchy.
    */
    @future
    public static void addUserRoles(Set<Id> accountHierarchyUpdate){
        List<Account_Contact_Role__c> newRoles = new List<Account_Contact_Role__c>();            
        for(Account node: [Select Id, ParentId from Account where Id IN :accountHierarchyUpdate]){                          
            for(Account_Contact_Role__c acr: [Select Id, Contact__c, Role__c from Account_Contact_Role__c where Customer__c = :node.ParentId and (Role__c = : portalUserRoleId OR Role__c = : portalUserAdministratorRoleId) For Update]){
                Account_Contact_Role__c acr_new = new Account_Contact_Role__c(Contact__c = acr.Contact__c, Role__c = acr.Role__c, Customer__c = node.Id);
                newRoles.add(acr_new);                      
            }
        }
        //Add roles        
        if(!RecursionControl.runonce){
            RecursionControl.runonce = true;            
            if(newRoles.size() > 0)                                     
                Database.SaveResult[] resultsAccount = Database.insert(newRoles, true);
        }     
    } 
    
    static testMethod void testBindKasiaCaseAndPackageChange(){ 
        //To-Do: implement test methods once Service-Center is in production            
    }
    
    static testMethod void testaddUserRoles(){ 
        Account acc1 = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Account acc2 = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        acc2.ParentId = acc1.Id;
        update acc2;
        Set<Id> accountHierarchyUpdate = new Set<Id>();
        accountHierarchyUpdate.add(acc2.Id);        
        clsAsyncMethods.addUserRoles(accountHierarchyUpdate);               
    }
    
    static testMethod void testUpdateUserObject(){
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
        Set<Id> contacts = new Set<Id>();
        contacts.add(contact.Id);
        clsAsyncMethods.updateUserObject(contacts);         
    }
    
    static testMethod void testCheckCableUnitPortalStatus(){
        Account account = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Set<Id> cable_unit_customers = new Set<Id>();
        cable_unit_customers.add(account.Id);
        clsAsyncMethods.checkCableUnitPortalStatus(cable_unit_customers, true);
        clsAsyncMethods.checkCableUnitPortalStatus(cable_unit_customers, false);
        clsAsyncMethods.checkCableUnitPortalStatusStatic(cable_unit_customers, true);
        clsAsyncMethods.checkCableUnitPortalStatusStatic(cable_unit_customers, false);
        //No asserts due to manual testing.
    }
    
    static testMethod void testupdateAccountHierarchy_Parent_Update(){
        Account acc1 = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Account acc2 = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        acc2.ParentId = acc1.Id;
        update acc2;
        Set<Id> accountHierarchyUpdate = new Set<Id>();
        accountHierarchyUpdate.add(acc2.Id);        
        clsAsyncMethods.updateAccountHierarchy_Parent_Update(accountHierarchyUpdate, false, false);     
        //No asserts due to manual testing.                 
    }  
}