global class SC_AcquireExternalIdForContactRolesImpl implements Database.Batchable<sObject>, Database.Stateful {
	private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
	
	public Double failedUpdates{get; set;}	
	public String email {get; set;}
	public User YS_Sales_User {get; set;}
	public boolean isTest {get; set;}
	public Id testAcr {get; set;}
	public Double totalRolesRecreated {get; set;}
	
	global SC_AcquireExternalIdForContactRolesImpl(String email, boolean isTest, Id testAcr){
         failedUpdates = 0;         
         this.email = email;
         this.isTest = isTest;
         this.testAcr = testAcr;
         totalRolesRecreated = 0; 
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';        
        if(isTest){
        	query = 'Select Id, Customer__c, Role__c, Contact__c, Total_Insight__c from Account_Contact_Role__c where Contact__c=:testAcr';        	
        }
        else{       
        	query = 'Select Id, Customer__c, Role__c, Contact__c, Total_Insight__c from Account_Contact_Role__c where ContactRoleExternalID__c=\'\' and Customer_Type__c=\'Kunde\'';
        }
        return Database.getQueryLocator(query);        
     }  
	
	//Overvej denne: http://developer.force.com/cookbook/recipe/using-batch-apex-to-reassign-account-owners
	global void execute(Database.BatchableContext ctx, List<Sobject> scope){
		//This map stores one contact role for each cable unit. 
		Map<Id, Account_Contact_Role__c> contact_roles = new Map<Id, Account_Contact_Role__c>();
		//When updating all contact roles for a cable unit, we just need to update one role. To allow this, we use a Map approach
		for(Account_Contact_Role__c role : (List<Account_Contact_Role__c>) scope){
			if(contact_roles.get(role.Customer__c) == null){
				contact_roles.put(role.Customer__c, role);	
			}	
		}
		
		Database.SaveResult[] updateResult;
		try {        		
			//No need to update any fields - we just need to touch the records to get the external id from Kiss.
			updateResult = Database.update(contact_roles.values(), false);						
	    } catch (Exception e) {			
        	System.debug('Failed aqquiring ContactRoleExternalId (SC_AcquireExternalIdForContactRolesImpl#execute): ' + e.getMessage());          
        }
        for(Database.SaveResult ua : updateResult){
             if(!ua.isSuccess()){
                 failedUpdates++;
            } 
        }
        totalRolesRecreated += scope.size(); 
        
		
		/*
		List<Account_Contact_Role__c> clonedRecords = new List<Account_Contact_Role__c>().deepClone();			
		Database.DeleteResult[] DeleteResult;
		Database.SaveResult[] InsertResult;		
		Savepoint sp = Database.setSavepoint();				
		try {        		
			//First we delete records because externalId cannot be aqquired by touching/updating record due to limitations in Cast Iron
			//If one record is failing, we roll back all deletes to avoid consistency problems
			DeleteResult = Database.delete(scope);			
			InsertResult = Database.insert(clonedRecords);							
	    } catch (Exception e) {
	    	Database.rollback(sp);	    		    		    				
        	System.debug('Failed aqquiring external id for contact roles (SC_AcquireExternalIdForContactRolesImpl#execute): ' + e.getMessage());          
		}
		if(InsertResult != null){
	        for(Database.SaveResult ua : InsertResult){
	             if(!ua.isSuccess()){
	                 failedUpdates++;                                  
	            } 
	        }
		}
		*/
	}
	
	global void finish(Database.BatchableContext ctx){ 
        if(email != null && email !=''){
	        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
	                        FROM AsyncApexJob WHERE id = :ctx.getJobId()];
	        String emailMessage = 'The batch job (Apex class: SC_AcquireExternalIdForContactRolesImpl) has completed.\n\n' 
	                            + 'The batch job updates Account_Contact_Roles without ContactRoleExternalID, thus creating an outbound that fetches external id from KISS.\n'
	                            + 'Total number of contact roles recreated in Kiss: ' + totalRolesRecreated + '\n'
	                            + 'Number of batches: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
	                            + ' processed without any exceptions thrown. \n'                           
	                            + 'Numbers of batches that threw unhandled exceptions: ' + a.numberOfErrors + '.\n'
	                            + 'Of the batches that executed without error, ' + failedUpdates
	                            + ' records were not updated successfully.';                            
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {email}; 
	        mail.setToAddresses(toAddresses);
	        mail.setReplyTo('noreply@salesforce.com');
	        mail.setSenderDisplayName('Service-Center Batch Job Summary');
	        mail.setSubject('Service-Center batch job completed: Aqquire externalId for account contact roles');
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
     	acr.ContactRoleExternalID__c = '';
     	update acr;     	
     	
        Test.startTest();
       	//Batch job is invoked with only one id to save ressources.
       	SC_AcquireExternalIdForContactRolesImpl impl = new SC_AcquireExternalIdForContactRolesImpl('mkha@yousee.dk', true, acr.Id);
        Database.executeBatch(impl, 1);               
        Test.stopTest();
        try{
        	Account_Contact_Role__c check = [Select Id, ContactRoleExternalID__c from Account_Contact_Role__c where Id = : acr.id];
        }catch(Exception e){
        	system.assert(true);        	
        }                
    } 		
}