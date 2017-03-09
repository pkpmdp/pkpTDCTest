global class SC_CheckCableUnitPortalStatusImpl implements Database.Batchable<sObject>, Database.Stateful {
    private static String portalUserRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsbruger').Value__c;
    private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
    
    public Double failedUpdates{get; set;}  
    public String email {get; set;}
    public User YS_Sales_User {get; set;}
    public boolean isTest {get; set;}
    public Id testAcr {get; set;}
    public Double totalCableUnitsUpdated {get; set;}
    //public String CableStr = 'a1TM00000004KQSMA2';     
     
    //This batch job only activates cable units.
    global SC_CheckCableUnitPortalStatusImpl(String email, boolean isTest, Id testAcr){
         failedUpdates = 0;         
         this.email = email;
         this.isTest = isTest;
         this.testAcr = testAcr; 
         this.totalCableUnitsUpdated = 0;        
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';        
        if(isTest){
            query = 'Select Id, Cable_Unit__c, Cable_Unit__r.Service_Center_Customer_Agreement__c from Account where Id = : testAcr';           
        }
        else{       
              query = 'Select Id, Cable_Unit__c, Cable_Unit__r.Service_Center_Customer_Agreement__c from Account where Cable_Unit__r.Service_Center_Customer_Agreement__c = false and Id IN (Select Customer__c from Account_Contact_Role__c where (Role__c = :portalUserRoleId OR Role__c = :portalUserAdministratorRoleId))';
              //query = 'Select Id, Cable_Unit__c, Cable_Unit__r.Service_Center_Customer_Agreement__c from Account where Cable_Unit__c = :CableStr and Cable_Unit__r.Service_Center_Customer_Agreement__c = false and Id IN (Select Customer__c from Account_Contact_Role__c where (Role__c = :portalUserRoleId OR Role__c = :portalUserAdministratorRoleId))';
              System.debug('###########Query'+query);   
                
        }
        return Database.getQueryLocator(query);        
     }  
    
    //Overvej denne: http://developer.force.com/cookbook/recipe/using-batch-apex-to-reassign-account-owners
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){        
        Set <ID> cableUnitsToBeActivated = new Set <ID>();
        List<Account> accountsToBeUpdated  = new List<Account>();
        for(Account account  : (List<Account>) scope){
            System.debug('###########Inside Scope'+account);
            if(account.Cable_Unit__r.Service_Center_Customer_Agreement__c == false && !cableUnitsToBeActivated.contains(account.Cable_Unit__c)){
                //Note we must update cable units as well as account. Only updates on accounts trigger outbounds so we need to update the parent account reference as well.
                cableUnitsToBeActivated.add(account.Cable_Unit__c);
                accountsToBeUpdated.add(account);   
                System.debug('###########Inside cableUnitsToBeActivated'+cableUnitsToBeActivated);  
            }       
        }
        
        List<Cable_Unit__c> cableUnitsToBeActivatedList = new List<Cable_Unit__c>();                
        for(Cable_Unit__c cu : [Select Id from Cable_Unit__c where Id IN : cableUnitsToBeActivated]){
            cu.Service_Center_Customer_Agreement__c = true;
            cableUnitsToBeActivatedList.add(cu);
        }
                
        Database.SaveResult[] updateCUResult;
        Database.SaveResult[] updateAccountResult;
        try {   
            System.debug('###########Inside cableUnitsToBeActivatedList'+cableUnitsToBeActivatedList);      
            updateCUResult = Database.update(cableUnitsToBeActivatedList);
            updateAccountResult = Database.update(accountsToBeUpdated);
                                        
        } catch (Exception e) {                                                         
            System.debug('Failed updating Service_Center_Customer_Agreement__c on Cable Unit and Account (SC_CheckCableUnitPortalStatusImpl#execute): ' + e.getMessage());          
        }
        if(updateAccountResult != null){
            for(Database.SaveResult ua : updateAccountResult){
                 if(!ua.isSuccess()){
                     failedUpdates++;                                  
                } 
            }
        }  
        totalCableUnitsUpdated += cableUnitsToBeActivatedList.size();
    }
    
    global void finish(Database.BatchableContext ctx){ 
        if(email != null && email !=''){
            AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
                            FROM AsyncApexJob WHERE id = :ctx.getJobId()];
            String emailMessage = 'The batch job (Apex class: SC_CheckCableUnitPortalStatusImpl) has completed.\n\n' 
                                + 'The batch job sets the value of Service_Center_Customer_Agreement__c to true if the cable unit has any associated contact roles of type: Selvbetjeningsbruger or Selvbetjeingsadministrator.\n'
                                + 'Total number of activated cable units: ' + totalCableUnitsUpdated + '\n'
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
            mail.setSubject('Service-Center batch job completed: Activate Cable Units for portal use based contact roles');
            mail.setPlainTextBody(emailMessage);
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        } 
     } 
     
     public static testMethod void testExecuteBatch(){
        Account cableUnit = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();  
        
        Account_Contact_Role__c acr = new Account_Contact_Role__c(
                                      Role__c = portalUserAdministratorRoleId, 
                                      Customer__c = cableUnit.Id,
                                      Contact__c = contact.Id);
        insert acr;         
        Test.startTest();       
        
        //Run batch job as Cast Iron. Batch job is invoked with only one id to save ressources.
        SC_CheckCableUnitPortalStatusImpl impl = new SC_CheckCableUnitPortalStatusImpl('mkha@yousee.dk', true, cableUnit.Id);
        Database.executeBatch(impl);
        Test.stopTest(); 
        Account account = [Select Id, Service_Center_Customer_Agreement_CU__c from Account where Id = :cableUnit.Id ];
        system.assertEquals('Ja', account.Service_Center_Customer_Agreement_CU__c);         
    }       
}