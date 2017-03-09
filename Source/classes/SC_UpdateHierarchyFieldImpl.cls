global class SC_UpdateHierarchyFieldImpl implements Database.Batchable<sObject>, Database.Stateful
{
    //YS record types
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
    public String ysCustomer = ysRecords.YS_Customer_Account__c;
    public String ysHierarchy = ysRecords.YS_Hierarchy_Account__c;
    
    //Brug Custom Setting til at bestemme om batch skal køre for alle hierarkier eller blot dem hvor det er ændret.
    public Double failedUpdates{get; set;}
    public Double updatedAccounts{get; set;}
    public Double updatedContacts{get; set;}
    public String updateId {get; set;}    
    
    public String email{get;set;} 
    public enum BatchMode {ALL, INCREMENTAL}
    public BatchMode mode;
    Document updatedAccountsFile = new Document();
    public boolean isTest {get; set;}
    public Id testAcr {get; set;}   
     
    //Custom setting regarding Salesforce ids for user roles in self-service portal
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger') != null ?  ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c : null;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator') != null ? ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c : null;   
    
    //Old Custom settings regarding Salesforce ids for internal YouSee roles
    //private static String customer_responsible = YouSeeCustomSettings__c.getInstance('Sales_Responsible_Role') != null ?  YouSeeCustomSettings__c.getInstance('Sales_Responsible_Role').Setting_Value__c: null;
    //private static String sales_responsible = YouSeeCustomSettings__c.getInstance('Customer_Responsible_Role') != null ? YouSeeCustomSettings__c.getInstance('Customer_Responsible_Role').Setting_Value__c: null;
   
    // Changes for SF-1122  
    private static String customer_responsible = YouSeeCustomSettings__c.getInstance('Customer_Responsible_Role') != null ? YouSeeCustomSettings__c.getInstance('Customer_Responsible_Role').Setting_Value__c: null;
    private static String sales_responsible = YouSeeCustomSettings__c.getInstance('Sales_Responsible_Role') != null ? YouSeeCustomSettings__c.getInstance('Sales_Responsible_Role').Setting_Value__c: null;
    
    
    private String fileContent = '';
    
    global SC_UpdateHierarchyFieldImpl(String email, boolean isTest, Id testAcr){
         failedUpdates = 0;
         updatedAccounts = 0;
         updatedContacts = 0;
         this.email = email;
         //Generates a unique update Id
         this.updateID = String.valueOf(Crypto.getRandomInteger());
         this.isTest = isTest;
         this.testAcr = testAcr;   
         
         //Create a file containing updated Accounts. This file is updated after each transaction limit
         updatedAccountsFile.Name = 'Updated Account Ids';  
         updatedAccountsFile.ContentType = 'text/plain';
         updatedAccountsFile.Type = 'txt';                             
    }    
    global Database.queryLocator start(Database.BatchableContext ctx){ 
        String query = '';        
        if(isTest){
            query = 'Select Id, ParentId from Account where ParentId = null and IsPersonAccount = false and (RecordTypeId =:ysCustomer OR RecordTypeId=:ysHierarchy) and Id=:testAcr';          
        }
        else{       
           /* Integer dayHour = datetime.now().hour();
            
            //If run during the day, only update the accounts that have actually changed.
            if(dayHour > 6 && dayHour < 16)
                mode = BatchMode.ALL;
                //mode = BatchMode.INCREMENTAL; 
            else//If run during night, run through all accounts
                mode = BatchMode.ALL;
        
            String query1 = 'Select Id, ParentId from Account where ParentId = null and IsPersonAccount = false and (RecordTypeId =:ysCustomer OR RecordTypeId=:ysHierarchy)';          
            //Assumption: Batch job must be schedueled after midnight
            String query2 = 'Select Id, ParentId from Account where ParentId = null and IsPersonAccount = false and (RecordTypeId =:ysCustomer OR RecordTypeId=:ysHierarchy) and Id IN (SELECT AccountID from AccountHistory where Field=\'Parent\' and CreatedDate = yesterday)';
                    
            query = (mode == BatchMode.ALL ? query1:query2); */
            
            List<Account> accList = [select Id,name,parentId, IsSuperiorAccountChanged__c,SuperiorAccount__c from account where IsSuperiorAccountChanged__c='TRUE'];
            List<String> superiorAccountList = new List<String>();
            
            for(Account acc : accList){
                if(acc.parentId == null){
                    superiorAccountList.add(acc.Id);
                }else{
                    superiorAccountList.add(acc.SuperiorAccount__c);
                }
                acc.IsSuperiorAccountChanged__c = '';
            }
            
            update accList;
            
            query = 'Select Id, ParentId from Account where ParentId = null and IsPersonAccount = false and (RecordTypeId =:ysCustomer OR RecordTypeId=:ysHierarchy) and Id IN : superiorAccountList ';
        }
        return Database.getQueryLocator(query);
     }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){        
        Set<Id> allAccountIds = new Set<ID>();
        Set<Id> updatedAccountIds = new Set<ID>();
        Set<ID> accounts_topnodes = new Set<ID>();
        List<Account> accountsToBeUpdated = new List<Account>(); 
        
        for(Account account : (List<Account>) scope){               
            if (!accounts_topnodes.contains(account.Id)){
                accounts_topnodes.add(account.Id);   
            }     
        }
        System.debug('$$accounts_topnodes$$'+accounts_topnodes.size()+'#########TempACD'+accounts_topnodes);
        Map<Integer, Set<Id>> accountHierarchy = new Map<Integer, Set<Id>>();
        accountHierarchy.put(0, accounts_topnodes);
        System.debug('$$Mapped accountHierarchy$$'+accountHierarchy);
        //All childs per Superior_Account
        Map<Id, Map<Id, Account>> parentToChild = new Map<Id, Map<Id, Account>>();                
        for(Account superiorAccount :[Select Id, SuperiorAccount__c from Account where ID in : accounts_topnodes])
        {
             //The field SuperiorAccount__c on all topnodes must always be null
            if(superiorAccount.SuperiorAccount__c != null){
                superiorAccount.SuperiorAccount__c = null;
                accountsToBeUpdated.add(superiorAccount);
            }   
            if(parentToChild.get(superiorAccount.Id) == null){
                parentToChild.put(superiorAccount.Id, new Map<Id, Account>());   
            }
            //Add id from superior accounts to be used when updating contacts
            allAccountIds.add(superiorAccount.Id);         
            System.debug('$$Updated Accounts $$'+accountsToBeUpdated+'parentToChild'+parentToChild+'##$allAccountIds$$$'+allAccountIds+'###Size AccountsIds#####'+allAccountIds);             
        }
             
        Integer level = 0;        
        while(accountHierarchy.get(level)!= null){                          
            List<Account> levelAccounts = new List<Account>([Select Id, ParentId, SuperiorAccount__c from Account where ParentId in : accountHierarchy.get(level)]);
                       
            for(Id parent: parentToChild.KeySet()){                                                         
                Map<Id, Account> parentToChildMap = parentToChild.get(parent);              
                for(Account account: levelAccounts){                                        
                    if( (parentToChildMap.get(account.Id) == null) && ((level == 0 && account.ParentId == parent) ||                    
                        (parentToChildMap.get(account.ParentId) != null))){                                             
                            parentToChildMap.put(account.Id, account);                          
                            if(account.SuperiorAccount__c != parent){                               
                                account.SuperiorAccount__c = parent;
                                accountsToBeUpdated.add(account);
                                
                                //Update Set to store updated Account Ids in file
                                if(!updatedAccountIds.contains(account.Id))
                                    updatedAccountIds.add(account.Id);  
                                
                            }
                            //Add all processed unique accounts to tmpSet for updating contacts in next step
                            if(!allAccountIds.contains(account.Id)){
                                allAccountIds.add(account.Id);
                            }                                                           
                    }
                } 
            }    
            System.debug('$$accounts_accountsToBeUpdated$$'+accountsToBeUpdated+'#########updatedAccountIds'+updatedAccountIds+'###Before Update'+allAccountIds+'###GlevelAccounts####'+levelAccounts);          
            //Prepare ids for next level
            Set<Id> levelIds = new Set<Id>();
            for (Account account: levelAccounts){                   
                if (!levelIds.contains(account.Id))
                    levelIds.add(account.Id);               
            }                          
            if(levelIds.size() > 0)                          
                accountHierarchy.put(level + 1, levelIds);       
            level++; 
        }
        //Update global counter
        updatedAccounts += accountsToBeUpdated.size();
        System.debug('$$updatedAccounts$$'+updatedAccounts+'#########accountHierarchy'+accountHierarchy);          
        List<Database.SaveResult> updateResultAccount;
        if(accountsToBeUpdated.size() > 0){                     
            try{
                 updateResultAccount = Database.update(accountsToBeUpdated);
            }catch (Exception e){
                system.debug('Error updating accounts in batchjob SC_UpdateHierarchyFieldImpl: ' + e.getMessage());
            }
        }
        
        if(updateResultAccount != null){    
            for(Database.SaveResult ura : updateResultAccount){
                if(!ura.isSuccess())
                     failedUpdates++;            
            } 
        }
        
        //Update file with Account Ids        
        for(Id account: updatedAccountIds){          
            fileContent += account + '\n';      
        }
        System.debug('$$Before Fetch Account Team$$'+allAccountIds);
        //Special task for campaing purposes: Store information about sales and customer responsible for each contact in two separate fields.
        
        List <Account_Team__c> internalRoles = [Select Customer__c, Customer_Team_Member_Name__c, Customer_Team_Role__c 
                                                from Account_Team__c 
                                                where Customer__c IN :allAccountIds 
                                                and (Customer_Team_Role__c = :customer_responsible OR Customer_Team_Role__c = :sales_responsible)];

        Map<Id, SC_UpdateHierarchyFieldImpl.YouSeeRoles> customerWithInternalRoles = new Map<Id, SC_UpdateHierarchyFieldImpl.YouSeeRoles>();
        for(Account_Team__c internalRole: internalRoles) {
            SC_UpdateHierarchyFieldImpl.YouSeeRoles roleInfo = customerWithInternalRoles.get(internalRole.Customer__c);         
            if (roleInfo == null){
                roleInfo  = new SC_UpdateHierarchyFieldImpl.YouSeeRoles();
                customerWithInternalRoles.put(internalRole.Customer__c, roleInfo);
            }
                            
            if(internalRole.Customer_Team_Role__c == sales_responsible)
                roleInfo.sales_responsible_role = internalRole.Customer_Team_Member_Name__c;
            else if(internalRole.Customer_Team_Role__c == customer_responsible)
                roleInfo.customer_responsible_role = internalRole.Customer_Team_Member_Name__c;               
        }//End for-structure 
        
        //Update hierarchyfield on contact
        
        //Step 1: Find all distinct contacts 
        Set <Id> distinctContacts = new Set<Id>();
        Map<Id, Set<Id>> contactWithAccount = new Map<Id, Set<Id>>();
        System.debug('$$Before Fetch Account Contact Role$$'+allAccountIds);

        List<Account_Contact_Role__c> acrList = [Select Id, Contact__c, Contact__r.HierarchyAccount__c, Customer__c,Role__c, 
                                                Customer__r.ParentId, Customer__r.SuperiorAccount__c 
                                                from Account_Contact_Role__c 
                                                where Customer__r.Id In :allAccountIds];

        for(Account_Contact_Role__c acr: acrList){
            //Add distinct contact to Set
            if (!distinctContacts.contains(acr.Contact__c))
                distinctContacts.add(acr.Contact__c);
                
            //Special campain logic: Add accounts associated with each contact
            if (contactWithAccount.get(acr.Contact__c) == null)
                contactWithAccount.put(acr.Contact__c, new Set<Id>());
                
            if(!contactWithAccount.get(acr.Contact__c).contains(acr.Customer__c))
                contactWithAccount.get(acr.Contact__c).add(acr.Customer__c);
       } 
             
        System.debug('$$Before Fetch distinctContacts$$'+distinctContacts+'##contactWithAccount##'+contactWithAccount);
        //Step 2: Identify contacts who are also portal users
        Set<Id> contactWithPortalUser = new Set<Id>();
        for(User portalUser: [Select ContactId from User where IsActive = true and ContactId IN : distinctContacts]){
            if(!contactWithPortalUser.contains(portalUser.ContactId))
                contactWithPortalUser.add(portalUser.ContactId);
        }
        
        //Step 3:Find all distinct customer hierarchies that each contact can be associated with. 
        //Most times, this should only be one customer hierarchy.
        Map<Id, Set<Id>> contactWithDifferentAccounts  = new Map<Id, Set<Id>>();
        
        for(Account_Contact_Role__c acr : acrList){           
            //First we make sure to create a Set to avoid nullpointer exceptions
            if (contactWithDifferentAccounts.get(acr.Contact__c) == null)
                contactWithDifferentAccounts.put(acr.Contact__c, new Set<Id>());            
            //Second, we add all distinct superiorAccounts one by one
            //If related customer is topmost parent then use the actual id, because SuperiorAccount__c cannot have a self reference. Thus, it is empty if the record is topmost parent.
            Id newSuperiorAccount = acr.Customer__r.ParentId != null ? acr.Customer__r.SuperiorAccount__c : acr.Customer__c; 
            if (!contactWithDifferentAccounts.get(acr.Contact__c).contains(newSuperiorAccount)){
                //Determine if role is user related
                boolean isUserRole = acr.Role__c == portalUserRoleId || acr.Role__c == portalUserAdministratorRoleId ? true : false;                
                System.debug('##isUserRole######'+isUserRole);
                /* Update scenarios with business rules
                    Scenario 1: (isUserRole == false && !contactWithPortalUser.contains(acr.Contact__c)):
                    In this scenario non portalactive roles for contacts who are not portal users are used to update the hierarchyAccount field on contacts. 
                    This scenario is safe and has no impact if a contacts have cross-spanning roles because the business can find such contacs in error reports
                    
                    Scenario 2: (isUserRole == true && contactWithPortalUser.contains(acr.Contact__c) && acr.Contact__r.HierarchyAccount__c == null) 
                    This scenario has been disabled because we risked reassigning hierarchy account on portal users who exists in several hierarchies. Now, 
                    we allow this again but only if the hierarchy account is null on the contact. Normally, every portal user is assigned a superior hierarchy node upon creation,
                    but if someone nullifies this, then the batch job will resolve it. The only risk that could materialize is if the portal user has user roles in different hierarchies. In that
                    situation, this batch job could assign the wrong hierarchy node.                    
                    
                    However, error reports will be created to address portal users being assigned several customer hierarchy. In addition, since portal user with hierarchy assignments will not be
                    affected, the risk of errors is minimal.                    
                    
                                    
                    Conclusion: We continue to use the portal safe version to prevent hierarchy nodes from suddenly changing on portal users where a hierarchy node is already assigned.
                    Also we have a new validation rule on Account in tgrAccountBeforeInsert that prevents internal users from adding new parent if current hierarchy has user roles.                
                */ 
                //Old:if(isUserRole == false && !contactWithPortalUser.contains(acr.Contact__c))            
                //Old: contactWithDifferentAccounts.get(acr.Contact__c).add(newSuperiorAccount);             
                if( (isUserRole == false && !contactWithPortalUser.contains(acr.Contact__c) ) || 
                    (isUserRole == true && contactWithPortalUser.contains(acr.Contact__c) && acr.Contact__r.HierarchyAccount__c == null ) ) 
                    contactWithDifferentAccounts.get(acr.Contact__c).add(newSuperiorAccount); 
            } 
        } 
        System.debug('##contactWithDifferentAccounts######'+contactWithDifferentAccounts.keySet());
        //Step 4: Update contacts with relevant HierarchyAccount__c  
        Map<ID, Contact> contactsToBeUpdated = new Map<Id, Contact>();        
        for(Contact contact: [Select Id, HierarchyAccount__r.Id, SC_System_Update_Field__c, Has_More_Hierarchies__c, 
                                    Associated_Sales_Responsible__c, 
                                    Associated_Customer_Responsible__c  
                                from Contact 
                                where Id IN : contactWithDifferentAccounts.KeySet()]){
            //Special campaign logic
                        
            //Campaign fields are reset for each contact at first update
            if(contact.SC_System_Update_Field__c != updateId){
                contact.Associated_Customer_Responsible__c = null;
                contact.Associated_Sales_Responsible__c = null;
            }           
            //We run through each account associated with the contact to find distinct sales and customer responsible reference in wrapper object
            for(Id acc: contactWithAccount.get(contact.Id)){
                SC_UpdateHierarchyFieldImpl.YouSeeRoles tmpRoles = customerWithInternalRoles.get(acc);
                System.debug('##tmpRoles######'+tmpRoles);              
                if(tmpRoles != null){
                    if(tmpRoles.sales_responsible_role != null){
                        if(contact.Associated_Sales_Responsible__c == null) 
                            contact.Associated_Sales_Responsible__c = tmpRoles.sales_responsible_role;
                        else if(!contact.Associated_Sales_Responsible__c.containsIgnoreCase(tmpRoles.sales_responsible_role))                           
                            contact.Associated_Sales_Responsible__c += ', ' + tmpRoles.sales_responsible_role;
                    }
                    if(tmpRoles.customer_responsible_role != null){
                        if(contact.Associated_Customer_Responsible__c == null)  
                            contact.Associated_Customer_Responsible__c = tmpRoles.customer_responsible_role;
                        else if (!contact.Associated_Customer_Responsible__c.containsIgnoreCase(tmpRoles.customer_responsible_role))                            
                            contact.Associated_Customer_Responsible__c += ', ' + tmpRoles.customer_responsible_role;
                    }
                    if(contactsToBeUpdated.get(contact.id) == null)
                        contactsToBeUpdated.put(contact.Id, contact);
                }                           
            }//End special campaign processing 
                        
            //Normally, only one record should be in each Set for one contact. But some contacts can belong to more customer hierarchies 
            for(Id relatedAccountId: contactWithDifferentAccounts.get(contact.Id)){
                //This logic uses an update code to identify contacts belonging to more than one customer hierarchy.
                //If hierarchy field is updated more than once in same batch job with two different hierarchy node, then set hasMoreHierarchies to true.
                if(relatedAccountId == contact.HierarchyAccount__r.Id){
                    if(contact.SC_System_Update_Field__c != updateId){
                        //Reset field at every run
                        contact.Has_More_Hierarchies__c = false;
                        contact.SC_System_Update_Field__c = updateId;
                    }                   
                    if(contactsToBeUpdated.get(contact.id) == null)
                        contactsToBeUpdated.put(contact.Id, contact);
                                
                }
                else{
                    //Update the hasMoreHierarchies if hierarchy field is updated twice by two different hierarchy account
                    //This means that the contact has roles in more than one overall customer hierarchy
                    if(contact.SC_System_Update_Field__c == updateId){                      
                        contact.Has_More_Hierarchies__c = true;
                        //New req: As part of SC-233 and SC-69, we don't nullify this field in any situation - decided on March 23 2012
                        //Old req: If a contact has roles with more than one hierarchy, then set the hierarchy field to null
                        //contact.HierarchyAccount__c = null;
                    }
                    else{
                        contact.SC_System_Update_Field__c = updateId;
                        //Reset field at every run
                        contact.Has_More_Hierarchies__c = false;                                            
                        contact.HierarchyAccount__c = relatedAccountId;                                          
                    }
                    if(contactsToBeUpdated.get(contact.id) == null)
                            contactsToBeUpdated.put(contact.Id, contact); 
                }                   
            }//Close inner for-structure          
        }//Close outer for-structure
        
        //Update global counter
        updatedContacts += contactsToBeUpdated.values().size();
        System.debug('ERRRRRcontactsToBeUpdated'+contactsToBeUpdated.values());
        List<Database.SaveResult> updateResultContact;        
        if(contactsToBeUpdated.size() > 0){
            try{
                updateResultContact = Database.update(contactsToBeUpdated.values());
            }catch (Exception e){
                system.debug('Error updating contacts in batchjob SC_UpdateHierarchyFieldImpl: ' + e.getMessage());
            }
        }
        if(updateResultContact != null){        
            for(Database.SaveResult urc : updateResultContact){
                if(!urc.isSuccess()){
                    failedUpdates++;
                } 
            }
        }        
    }//End execute
        
     global void finish(Database.BatchableContext ctx){
        //Finish up updating file with updated Account ids
        String fileHead = 'Updated accounts (total: ' + updatedAccounts + '):\n';                       
        updatedAccountsFile.Body = Blob.valueOf(fileHead + fileContent);    
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('UpdatedAccounts.txt');
        efa.setBody(updatedAccountsFile.Body);      
        String[] toAddresses;
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
                        FROM AsyncApexJob WHERE id = :ctx.getJobId()];
        String emailMessage = 'The batch job (Apex class: SC_UpdateHierarchyFieldImpl) has completed.\n\n' 
                            + 'The batch job updates the field SuperiorAccount__c on all hierarchy and cable unit customers.\n'
                            + 'Number of transactions: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
                            + ' processed without any exceptions thrown. \n'                           
                            + 'Numbers of transations that threw unhandled exceptions: ' + a.numberOfErrors + '.\n'
                            + 'Of the transactions that executed without error, ' + failedUpdates
                            + ' records were not updated successfully.\n\n'
                            + 'Total updated accounts: ' + updatedAccounts + '\n'
                            + 'Total updated contacts: ' + updatedContacts;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {email}; 
        try{
            toAddresses = email.split(';');
        }catch(Exception e){
            
            System.debug('##########Email Test'+email+'##########Mesasage'+e.getMessage());
        }   
        
        mail.setToAddresses(toAddresses);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); 
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('Service-Center Batch Job Summary');
        mail.setSubject('Service-Center batch job completed: Update hierarchy field on accounts and contacts');
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail }); 
        System.debug('%%%%% After /email send 5toAddresses0'+toAddresses);
     }
     
     /*public static testMethod void testSC_UpdateHierarchyFieldImpl(){
        Account superiorHierarchyAccount = clsTestFactory.getTestFactoryInstance().createYSHierarchyCustomer();
        Account cableUnit1 = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();    
        //clsTestDataForYS cys = new clsTestDataForYS();
        //Account cableUnit1 = cys.createYSCableUnitCustomer();   
        //SuperiorAccount__c is nullified to ensure that we test assignment logic correctly 
        //cableUnit1.SuperiorAccount__c = null;
            
        cableUnit1.ParentId = superiorHierarchyAccount.Id;
        update cableUnit1;
        
         Test.startTest();
        Contact contact1 = clsTestFactory.getTestFactoryInstance().createYSContact();       
        Account_Contact_Role__c acr1 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact1.Id, cableUnit1.Id);
        
        //Commented for SF-1364
        //User CastIron = [Select ID from User where Name= 'CI CastIron' limit 1];           
        
        User NOAPIUser = new User();
        NOAPIUser = [Select ID,Name from User where Name = 'API No Outbound User' limit 1];
        
         
       
        //Commnted for SF-1364
        //System.runAs(CastIron){
        System.runAs(NOAPIUser){    
            //Run batch job as Cast Iron. Batch job is invoked with only one id to save ressources.
            SC_UpdateHierarchyFieldImpl impl = new SC_UpdateHierarchyFieldImpl('mkha@yousee.dk', true, superiorHierarchyAccount.Id);
            Database.executeBatch(impl);    
          } 
        Test.stopTest();            
        //Refresh and test values after batch job has executed
        contact1 = [Select Id, HierarchyAccount__c from Contact where id= :contact1.Id];            
        //system.assertEquals(superiorHierarchyAccount.Id, contact1.HierarchyAccount__c);
        cableUnit1 = [Select Id, SuperiorAccount__c from Account where id= :cableUnit1.Id]; 
        //system.assertEquals(superiorHierarchyAccount.Id, cableUnit1.SuperiorAccount__c);
     }*///End testclass
     
     //Internal wrapper class for campaing updates
    class YouSeeRoles  //http://forceschool.blogspot.dk/2011/06/inner-class-in-apex-class.html
    {  
        public String sales_responsible_role {get;set;}  
        public String customer_responsible_role {get;set;}               
        public YouSeeRoles(){} 
    }
    /*public static testMethod void testYouSeeRoles(){  
        YouSeeRoles ys=new YouSeeRoles();
       
    }*/
        
}//Close batch class