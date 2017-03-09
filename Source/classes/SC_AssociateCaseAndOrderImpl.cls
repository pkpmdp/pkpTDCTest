global class SC_AssociateCaseAndOrderImpl implements Database.Batchable<sObject>, Database.Stateful {
	public Double failedUpdates{get; set;}
	public boolean isTest {get; set;}
	public Id testAcr {get; set;}
	public Double totalAssociations {get; set;}	
	
	//Contains reference to a context report showing related addresses in portal order.
    private static String orderGroupRerportId = ServiceCenter_CustomSettings__c.getInstance('Order Group Report').Value__c;
    
    //Retrieve case information for YFF
    private static String caseDepartment = ServiceCenter_CustomSettings__c.getInstance('Case Department').Value__c;
    private static String caseProduct = ServiceCenter_CustomSettings__c.getInstance('Case Product').Value__c;
	public String email = ServiceCenter_CustomSettings__c.getInstance('Service-Center batch job email').Value__c;
	//This batch job only activates cable units.
	global SC_AssociateCaseAndOrderImpl(boolean isTest, Id testAcr){
         failedUpdates = 0;
         this.totalAssociations = 0;         
        // this.email = email; 
         this.isTest = isTest;
         this.testAcr = testAcr;               
    }  
    
     global Database.queryLocator start(Database.BatchableContext ctx){
        String query = '';        
        if(isTest){
        	query = 'Select Id, Subject from Case where Id = : testAcr';        	
        }
        else{        	       
        	query = 'Select Id, Subject from Case where Origin like \'%Kasia%\' and LastModifiedDate = Last_N_Days: 5'; 
        }
        return Database.getQueryLocator(query);        
     }  
	
	global void execute(Database.BatchableContext ctx, List<Sobject> scope){		
		Map<String, Id> kasiaCaseWithOrderNumber = new Map<String, Id>();
		List<SC_Activity_Log__c> log_entries = new List<SC_Activity_Log__c>();
		Map<Id, SC_Activity_Log__c> caseWithActivityLog = new Map<Id, SC_Activity_Log__c>();
		//Ensures are assigned to correct queue after processing
        Database.DMLOptions dmo = new Database.DMLOptions();
    	dmo.assignmentRuleHeader.useDefaultRule = true;
		
		for(Case portalCase: (List<Case>) scope){
			if(portalCase.Subject != null && portalCase.Subject.indexOf('Manuel behandling') !=-1){
				String subject = portalCase.Subject.substring(portalCase.Subject.indexOf(':')+ 1, portalCase.Subject.lastIndexOf(')'));
				if(subject != null || subject !=''){
					String kasiaOrderNumber = portalCase.Subject.substring(portalCase.Subject.indexOf(':')+ 1, portalCase.Subject.lastIndexOf(')')).trim();			
					if(kasiaCaseWithOrderNumber.get(kasiaOrderNumber) == null)
	        			kasiaCaseWithOrderNumber.put(kasiaOrderNumber, portalCase.Id);
				}
			}				
		}
		
		for(SC_Activity_Log__c activity: [Select Id, Case__c, OrderGroupId__c, Kasia_Order_Number__c, Kasia_Classic_Order_Number__c from SC_Activity_Log__c where LastModifiedDate = Last_N_Days: 5 and Case__c = null]){        	
        	boolean match = false;
        	if(kasiaCaseWithOrderNumber.get(activity.Kasia_Order_Number__c) != null){
        		activity.Case__c = kasiaCaseWithOrderNumber.get(activity.Kasia_Order_Number__c);
        		match = true;
        	}
        	else if(kasiaCaseWithOrderNumber.get(activity.Kasia_Classic_Order_Number__c) != null){
        		activity.Case__c = kasiaCaseWithOrderNumber.get(activity.Kasia_Classic_Order_Number__c);
        		match = true;
        	} 
        	if(match){
        		activity.Kasia_Order_Status__c = 'Error';
        		log_entries.add(activity);
        		if (caseWithActivityLog.get(activity.Case__c) == null)
        			caseWithActivityLog.put(activity.Case__c, activity); 	
        		}		   	
        }
        
        //Update matched cases with link to Service-Center log entry
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        //Fixes an issue where base url in certain situations contains the substring -api which requires the user to log in again
        if(baseURL.indexOf('-api')!=-1)
        {
        	baseURL = baseURL.replace('-api', '');	
        }   	
    	//Create base URL - Fixes a problem where Salesforce sometime inserts http instead of https
		if(baseURL.startsWith('http:')){
			baseURL = baseURL.replaceFirst('http:', 'https:');
		}
		       
        List<Case> caseTobeUpdated = new List<Case>();        
        for(Case c: [Select Id, Subject, Description from Case where Id IN :caseWithActivityLog.keySet()]){
        	SC_Activity_Log__c activity = caseWithActivityLog.get(c.Id); 
        	if(activity != null){ 
        		String link = 'Link til omkoblingsordre: ' + baseURL + '/' + activity.Id + '\n';
        		link += 'Link til øvrige adresser i omkoblingsordre: ' + baseURL + '/' + orderGroupRerportId + '?pv0=' + activity.OrderGroupId__c;        	
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
        
        totalAssociations += log_entries.size();
        
		Database.SaveResult[] updateResult;		
		try {			
            updateResult = Database.update(log_entries, false);
            updateResult = Database.update(caseTobeUpdated, false);										
	    } catch (Exception e) {	    		    		    		    				
        	System.debug('Failed associating cases and package change orders (SC_AssociateCaseAndOrderImpl#execute): ' + e.getMessage());          
		}
		
		if(updateResult != null){
	        for(Database.SaveResult ua : updateResult){
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
	        String emailMessage = 'The batch job (Apex class: SC_AssociateCaseAndOrderImpl) has completed.\n\n' 
	                            + 'The batch associates cases created by Kasia if they match a package change order in activity log.\n'
	                            + 'Number of updated case associations: ' + totalAssociations + '.\n'
	                            + 'Number of transactions: ' + a.totalJobItems + ' of which ' + a.jobitemsprocessed
	                            + ' processed without any exceptions thrown. \n'                           
	                            + 'Numbers of transactions that threw unhandled exceptions: ' + a.numberOfErrors + '.\n'
	                            + 'Of the transactions that executed without error, ' + failedUpdates
	                            + ' records were not updated successfully.';                            
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        
	        //String[] toAddresses = new String[] {email};
	        List<String> toAddresses = new List<String>();
	        toAddresses = email.split(';'); 
	        mail.setToAddresses(toAddresses);
	        mail.setReplyTo('noreply@salesforce.com');
	        mail.setSenderDisplayName('Service-Center Batch Job Summary');
	        mail.setSubject('Service-Center batch job completed: Associate orders with Kasia cases');
	        mail.setPlainTextBody(emailMessage);
	        mail.setHtmlBody(emailMessage);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        } 
     } 
     
     public static testMethod void testExecuteBatch(){
     	SC_Activity_Log__c testOrder1 = new SC_Activity_Log__c();     	
     	testOrder1.Kasia_Order_Status__c = 'Pending';
        testOrder1.Kasia_Order_Number__c = '222';  	
     	insert testOrder1;
     	
     	Case caseObj1 = new Case();
     	caseObj1.Subject = 'Manuel behandling (ordreid: 222)';
     	insert caseObj1;
     	
     	SC_Activity_Log__c testOrder2 = new SC_Activity_Log__c();     	
     	testOrder2.Kasia_Order_Status__c = 'Pending';
        testOrder2.Kasia_Classic_Order_Number__c = '111';  	
     	insert testOrder2;
     	
     	Case caseObj2 = new Case();
     	caseObj2.Subject = 'Manuel behandling (ordreid: 111)';
     	insert caseObj2;
     	
     	Test.startTest(); 
     	//Run batch jobs. Batch job is invoked with only one id to save ressources.
       	SC_AssociateCaseAndOrderImpl impl1 = new SC_AssociateCaseAndOrderImpl( true, caseObj1.Id);
        Database.executeBatch(impl1);
        SC_AssociateCaseAndOrderImpl impl2 = new SC_AssociateCaseAndOrderImpl(true, caseObj2.Id);
        Database.executeBatch(impl2); 
     	Test.stopTest(); 
     	
     	SC_Activity_Log__c testVerification1 = [Select Id, Kasia_Order_Status__c, Case__c from SC_Activity_Log__c where Id = :testOrder1.Id];     	
     	system.assertEquals(testVerification1.Case__c, caseObj1.Id);
     	
     	SC_Activity_Log__c testVerification2 = [Select Id, Kasia_Order_Status__c, Case__c from SC_Activity_Log__c where Id = :testOrder2.Id];     	
     	system.assertEquals(testVerification2.Case__c, caseObj2.Id);
    } 		
}