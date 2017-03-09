/**********************************************************************
 Name:  CableUnitService()
 YouSee Service Center Application
=======================================================
Purpose:                                                            
This class contains all Cable Unit Related Functions
Referred in ViewCableUnitsController                                                            
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                Jira Issue
1.0 -    Capgemini      	01/12/2012      INITIAL DEVELOPMENT    JIRA: 
1.1 -    Name               XX/XX/XXXX      
***********************************************************************/
public class CableUnitService{ 
    
    public Id userId;
    public  string cntStatus;
    public String cntHierarchyDetails;
    public ID cntHierarchyDetails1; 
    public String acrRolename{get; set;}
    private String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
    private String contactRolesAdministrator = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Administrator').Value__c;
    public CableUnitService(){
        
    } 
    
    /* gets Logged in User Account Id */
    public ID getLoggedInUserAccountID(){  
        // Old query for fetching contact hierarchy details
        //Contact userContact = [Select Street_P__r.Name, accountId ,status__C From Contact  where id in (select contactid from User where id =:userId) LIMIT 1];                 
        Contact userContact = [Select Street_P__r.Name, accountId ,status__C, HierarchyAccount__c From Contact  where id in (select contactid from User where id =:userId) LIMIT 1];
        system.debug('$UserContact$'+userContact);
        cntStatus = userContact.status__C;
        
        cntHierarchyDetails = userContact.HierarchyAccount__c;
        System.debug('getLoggedInUserAccountID ->'+cntStatus+ '$Hierarchy Account Details$'+cntHierarchyDetails);
        return userContact.accountId;    
    }

    /*  Loop though all children and populate the account list with account Ids */
    /*  When logged in user is Portal Administrator */
    public List<ID> getAssignedAccountsPortalAdmin(){
     
        ID accountId = getLoggedInUserAccountID(); 
        List<ID> accountIdList = new List<ID>{};
        List<ID> currentParent = new List<ID>{};
        Integer level = 0;
        List<Account> acctList = new List<Account>{};
        Boolean endOfStructure = false;
        while (!endOfStructure ){
            if(level==0)
                acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.id = :accountId];
            else
                acctList = [select a.ParentId, a.Id, a.name from Account a WHERE a.ParentId IN :currentParent];
            if(acctList.size() == 0){
                endOfStructure = true;
            }    
            else {
                currentParent.clear();
       
                for(Account acctObj : acctList){
                    accountIdList.add(acctObj.id);
                    currentParent.add(acctObj.id);
                }
                level++;
            }
        }
         
        return accountIdList;
    }
     
    /*  Get the assigned accounts from the account share list */   
    /*  When logged in user is Portal User */
    /*public List<ID> getAssignedAccountsPortalUser(){
            List<ID> accountIdList= new List<ID>();
            List<AccountShare> accountShareList = [Select a.AccountId From AccountShare a where a.userOrGroupId=:userId];
            for(AccountShare accountShare : accountShareList){
                accountIdList.add(accountShare.accountId);
            }
            return accountIdList;
    }*/
    
     /** This method is used get assigned account ids for logged user */
    public List<ID> getAccountIds(List<ID> contactIDs, Id contactHierAccount){
        System.debug('contactIDs testing***: '+contactIDs);
        System.debug('contactHierAccount testing***: '+contactHierAccount);
        ID selectedRoleId;
        String loggedInAccntId,extrLoggedInAccntId;
        List<ID> accountIdsList= new List<ID>();
        Lookup_Contact_Roles__c lcrRole = new Lookup_Contact_Roles__c();
        List<Account_Contact_Role__c> acrAccountsList = new List<Account_Contact_Role__c>();
        if(contactHierAccount != null){ 
          loggedInAccntId = contactHierAccount;
          extrLoggedInAccntId = loggedInAccntId.substring(0, loggedInAccntId.length() - 3);
          system.debug('$ExterLoggedInAccntId$'+extrLoggedInAccntId);
        }
        if(extrLoggedInAccntId != null && contactIDs.size() > 0){
          acrAccountsList = [select Id,Role__C,Customer__c,RoleName__c,Role__r.Name,HierarchyAccount__c from Account_Contact_Role__c where Contact__c in :contactIDs and HierarchyAccount__c =: extrLoggedInAccntId];
        }
        System.debug('acrAccountsList testing***: '+acrAccountsList);
        System.debug('acrAccountsList testing size***: '+acrAccountsList.size());
        List<Lookup_Contact_Roles__c> lcrRoleList = [Select Id, Name from Lookup_Contact_Roles__c where Name =: contactRolesAdministrator or Name =: contactRolesBruger];  
        if(acrAccountsList.size() > 0 && acrAccountsList  != null){
            for(Account_Contact_Role__c accountContacts : acrAccountsList){ 
               //accountIdsList.add(accountContacts.Customer__c);
               if( accountContacts.Role__r.Name == contactRolesAdministrator || accountContacts.Role__r.Name == contactRolesBruger ){
                 accountIdsList.add(accountContacts.Customer__c);
                 selectedRoleId = accountContacts.Role__c;
                 System.debug('selectedRole****'+selectedRoleId);
                 for(Lookup_Contact_Roles__c role : lcrRoleList){
                    if(role.Id == selectedRoleId){
                        acrRolename = role.Name;
                    }
                 }
                 System.debug('@@@@@@@LookupRole Name@@@@@'+acrRolename+'@######accountIdsList'+accountIdsList);
               }
            }
        }
        System.debug(' The Account Id List -----------> ' + accountIdsList+'#Size#'+accountIdsList.size());
        return accountIdsList;
    } 
     
    /*  get Cable Unit related Ids */  
    public Map<ID, Account> getCableUnitRelatedDetails(Id userInfoId){
            userId = userInfoId; 
            Id contactHierarchyAccount;
            List<ID> contactIDs = new List<ID>();
            System.debug('UserInfo: '+userInfoId);
            User[] user=[select u.Id, u.ContactId, u.Contact.HierarchyAccount__c From User u  where Id =: userId];
            System.debug('$User Size$'+user.size());
            if(user.size() > 0 && user != null){
                System.debug('#a#');
              if(user[0].ContactId != null){    
                contactIDs.add(user[0].ContactId);
                System.debug('Contact Id -----------------> ' + user[0].ContactId);
                if(user[0].Contact.HierarchyAccount__c != null){
                 contactHierarchyAccount = user[0].Contact.HierarchyAccount__c;
                 System.debug('contactHierarchyAccount---'+contactHierarchyAccount);
                }
              } 
            }
            
            System.debug('Contact Ids -----------------> ' + contactIDs);  
            Map<ID, Account> accountMap = null;
            if(contactIDs != null && contactIDs.size() > 0){
                System.debug('***contactHierarchyAccount---'+contactHierarchyAccount+'*****contactIDs'+contactIDs);
                List<ID> accountIdList = getAccountIds(contactIDs,contactHierarchyAccount);  
                System.debug('***accountIdList---'+accountIdList);
                System.debug('***accountIdList---*****'+accountIdList.size());
                List<Account> accountList = new List<Account>();
                accountList = [Select a.Name, a.Cable_Unit__r.Cable_Unit_No__c, a.Cable_Unit__c, a.Cable_Unit__r.Contract_Source_ID__c, a.Cable_Unit__r.Name, a.Cable_Unit__r.Status__c, a.Cable_Unit__r.Status_Formula__c, a.Id, a.Cable_Unit__r.Current_Kiss_Case__c, a.Cable_Unit__r.Inaktiv_Dato__c, Type From Account a where a.id IN : accountIdList];
                //List<Account> accountList = [Select a.Name, a.Cable_Unit__r.Cable_Unit_No__c, a.Cable_Unit__c, a.Cable_Unit__r.Name, a.Cable_Unit__r.Status__c, a.Cable_Unit__r.Status_Formula__c, a.Id, a.Cable_Unit__r.cableUnit_Name__c, a.Cable_Unit__r.Current_Kiss_Case__c, Type From  Account a where a.Id IN :accountIdList]; 
                System.debug('getCableUnitRelatedDetails method , accountList->'+accountList+'$Size Details$'+accountList.size());

                accountMap = new Map<ID, Account>();
                if(accountList.size() > 0){
                    for(Account account : accountList){
                        //System.debug('a.Sales_Concept_Parameter__r.broadBandService__c'+account.Sales_Concept_Parameter__r.broadBandService__c);    
                        System.debug('------account.Cable_Unit__r.Current_Kiss_Case__c-------'+account.Cable_Unit__r.Current_Kiss_Case__c);
                        if(account.Cable_Unit__r.Current_Kiss_Case__c != null){
                            accountMap.put(account.Cable_Unit__r.Current_Kiss_Case__c, account);
                        }   
                    }
                }
                System.debug('---accountMap- in getCableUnitRelatedDetails-------'+accountMap);
            }
            //Check For another method
            //Contact userContact3 = [Select Id,HierarchyAccount__c From Contact where Id IN (select contactid from User where Id =: userId) LIMIT 1];
            //cntHierarchyDetails1 = userContact3.HierarchyAccount__c;
            
            //getContactHierarchyDetails();
            
            return accountMap;
    }
    
    /*  get Sales Concept related Ids */ 
    public List<Opportunity> getSalesConceptRelatedDetails(Set<ID> accountKeySet){
            System.debug('getSalesConceptRelatedDetails method , accountKeySet-> '+accountKeySet);
                       
            List<Opportunity>  salesConceptList = [Select id, Sales_Concept_Lookup__r.Solution__c,    
            Sales_Concept_Lookup__r.Telephony__c, Sales_Concept_Lookup__r.TVandRadio__c, Sales_Concept_Lookup__r.Broadband__c,
            Sales_Concept_Lookup__r.image_holder_for_telephony__c, Sales_Concept_Lookup__r.image_holder_for_broadband__c, 
            Sales_Concept_Lookup__r.image_Holder_for_TV__c From Opportunity where id IN: accountKeySet order by Account.Cable_Unit__r.Cable_Unit_No__c];
            system.debug('$salesConceptList$'+salesConceptList);
            return salesConceptList;
    }
    
    /** This method is used to get the user profile*/
    public String getUserProfile(){
        User user = [select Profile.Name from User where id = : userId];
        return user.Profile.Name;
    }
    
    // Added Extra method for getting the Hierarchy Account Details fiels from Contact object
    public ID getContactHierarchyDetails(){
        Contact userContact2 = [Select Id, HierarchyAccount__c From Contact where id in (select contactid from User where id =:userId) LIMIT 1];
        system.debug('$UserContact2$'+userContact2);
        cntHierarchyDetails1 = userContact2.HierarchyAccount__c;
        system.debug('$cntHierarchyDetails$'+cntHierarchyDetails1);
        return cntHierarchyDetails1;
       }
}