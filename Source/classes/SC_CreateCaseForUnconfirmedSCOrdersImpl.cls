global class SC_CreateCaseForUnconfirmedSCOrdersImpl implements Database.Batchable<sObject>, Database.Stateful{
	private static String portalUserAdministratorRoleId = ServiceCenter_CustomSettings__c.getInstance('Selvbetjeningsadministrator').Value__c;
	
	public Double failedUpdates{get; set;}
	public String email {get; set;}
	public boolean isTest {get; set;}
	public Id testOrder {get; set;}
	public Double totalCasesCreated {get; set;}
	
	global SC_CreateCaseForUnconfirmedSCOrdersImpl(String email, boolean isTest, Id testOrder){
         failedUpdates = 0;         
         this.email = email;
         this.isTest = isTest;
         this.testOrder = testOrder;
         totalCasesCreated = 0;
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';
        if(isTest)
        	query = 'Select Id, Kasia_Order_Status__c from SC_Activity_Log__c where Id= : testOrder'; 
        else	
        	query = 'Select Id, Kasia_Order_Status__c from SC_Activity_Log__c where Kasia_Order_Status__c =\'New\' and LastModifiedDate <= yesterday';
        return Database.getQueryLocator(query);        
     }  
	
	//Overvej denne: http://developer.force.com/cookbook/recipe/using-batch-apex-to-reassign-account-owners
	global void execute(Database.BatchableContext ctx, List<Sobject> scope){
		List<SC_Activity_Log__c> ordersToBeUpdated = new List<SC_Activity_Log__c>();
		for(SC_Activity_Log__c logObject: (List<SC_Activity_Log__c>) scope){
			if(logObject.Kasia_Order_Status__c == 'New' ){
				logObject.Kasia_Order_Status__c = 'Error';
				ordersToBeUpdated.add(logObject);		
			}				
		}
		Database.SaveResult[] updateResult;
		try {
			//For each update to failure, an after trigger on Activity Log will create a case with the YFF department
			updateResult = Database.update(ordersToBeUpdated);								
	    } catch (Exception e) { 		    				
        	System.debug('Failed updating Order object to status = Error (SC_CreateCaseForUnconfirmedSCOrdersImpl#execute): ' + e.getMessage());          
		}
		totalCasesCreated +=  ordersToBeUpdated.size();
		
		if(updateResult != null){
	        for(Database.SaveResult ua : updateResult){
	             if(!ua.isSuccess()){
	                 failedUpdates++;                                  
	            } 
	        }
		}
	}
	
	global void finish(Database.BatchableContext ctx){ 
        if(email != null && email !=''){
	        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email   
	                        FROM AsyncApexJob WHERE id = :ctx.getJobId()];
	        String emailMessage = 'The batch job (Apex class: SC_CreateCaseForUnconfirmedSCOrdersImpl) has completed.\n\n' 
	                            + 'The batch job updates unconfirmed package change orders in Service-Center in SC_Activity_Log__c to status = \'Error\' thus creating a manual case for YFF.\n'
	                            + 'Total number of unconfirmed orders set to manual handling: ' + totalCasesCreated + '\n'
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
	        mail.setSubject('Service-Center batch job completed: Update unconfirmed package change orders to Error');
	        mail.setPlainTextBody(emailMessage);
	        mail.setHtmlBody(emailMessage);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        } 
     } 
     
     public static testMethod void testExecuteBatch(){     	
     	SC_Activity_Log__c testOrder = new SC_Activity_Log__c();     	
     	testOrder.Kasia_Order_Status__c = 'New';     	
     	insert testOrder;
     	
     	Test.startTest(); 
     	//Run batch job as Cast Iron. Batch job is invoked with only one id to save ressources.
       	SC_CreateCaseForUnconfirmedSCOrdersImpl impl = new SC_CreateCaseForUnconfirmedSCOrdersImpl('mkha@yousee.dk', true, testOrder.Id);
        Database.executeBatch(impl); 
     	Test.stopTest(); 
     	SC_Activity_Log__c testVerification = [Select Id, Kasia_Order_Status__c, Case__c from SC_Activity_Log__c where Id = :testOrder.Id];
     	system.assertEquals('Error', testVerification.Kasia_Order_Status__c);
    }
}