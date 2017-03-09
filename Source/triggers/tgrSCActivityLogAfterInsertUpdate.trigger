trigger tgrSCActivityLogAfterInsertUpdate on SC_Activity_Log__c (after insert, after update) {
    Set<Id> ordersToBeUpdatedError = new Set<Id>();
    Set<Id> ordersToBeUpdatedCompleted = new Set<Id>();
    //Contains reference to a context report showing related addresses in portal order.
    private static String orderGroupReportId = ServiceCenter_CustomSettings__c.getInstance('Order Group Report').Value__c;
    private static String caseDepartment = ServiceCenter_CustomSettings__c.getInstance('Case Department').Value__c;
    private static String caseProduct = ServiceCenter_CustomSettings__c.getInstance('Case Product').Value__c;
    
    
    List <Case> cases = new List <Case>();
    
    Database.DMLOptions dmo = new Database.DMLOptions();
    dmo.assignmentRuleHeader.useDefaultRule = true;
    //We set this value to avoid sending an autoresponse e-mail to the portal user. This is because the portal user has already received an order confirmation e-mail from YFF.
    dmo.emailHeader.triggerAutoResponseEmail = false;
    dmo.emailHeader.triggerOtherEmail = false; 
    dmo.emailHeader.triggerUserEmail = false;
    
    /*
    Creates a case assigned to YFF if a package change has failed due to error or if the package needs manual handling like cancellations
    */
    if(Trigger.isAfter){
        //Map for storing relation between logEntry and case
        Map<ID, Case> logWithCase = new Map<ID, Case>();
        Map<ID, SC_Activity_Log__c> logEntries = new Map<ID, SC_Activity_Log__c>();
        Set<Id> OrderCompareWithCases = new Set<Id>(); 
        
                
        for(SC_Activity_Log__c logEntry: Trigger.new){
          /* Two scenarios exist for creating cases directly from portal:
            Scenario 1: Used for cancellations which are not sent to Kasia. Here, the portal inserts the order with status = 'Error' in Order and SC_Activity_Log__c  
            Scenario 2: Nightly batchjob 'SC_CreateCaseForUnconfirmedSCOrders' creates a case for Orders having status = 'New'. This scenario applies if Kasia never returns with order confirmation.
          */         
            if( (Trigger.isInsert && logEntry.Kasia_Order_Status__c == 'Error') || 
                (Trigger.isUpdate && Trigger.oldMap.get(logEntry.Id).Kasia_Order_Status__c == 'New' && logEntry.Kasia_Order_Status__c == 'Error' && logEntry.Case__c == null)){                
                                    
                String orderText = '';
                if (logEntry.Order_type__c == 'Cancellation')
                    orderText = 'Ordren er en afbestilling og skal håndteres manuelt. Se andre afbestillinger i samme ordre i rapportlinket foroven.';
                else
                  orderText = 'Omkoblingen er ikke blevet oprettet i Kasia. Dette kan skyldes en teknisk fejl eller at omkoblingen skal håndteres manuelt.';  
                                                                         
                Case errorCase = new Case();                
                //Be aware not to change this to 'Web' since that triggers and auto-response from web-to-case                                
                errorCase.Origin = 'O-Kunde Selvbetjening';
                errorCase.setOptions(dmo);                
                errorCase.Department__c = caseDepartment;
                errorCase.Product_2__c = caseProduct;                
                errorCase.AccountId = logEntry.Cable_Unit__c;
                errorCase.Subject = 'Handling påkrævet. Manuel håndtering af skift af tv-pakke/Service-Center';
                errorCase.Description = '****************Ordredetaljer****************\n\n\n'
                    + 'Installationsadresse: ' + (logEntry.Installation_address__c != '' ? logEntry.Installation_address__c : '') + '\n'   
                    + 'Lokation: ' + (logEntry.Location__c != null ? logEntry.Location__c : '') + '\n'             
                    + 'Kundenr.: ' +       logEntry.CableUnit_No__c + '\n'
                    + 'Ordretype: ' +       logEntry.Order_type__c + '\n'                    
                    + 'Ordrestatus: ' +     + 'Fejl - '+ orderText + '\n\n'                       
                    + 'Ordrenr.: ' +        (logEntry.Kasia_Order_Number__c != null ? logEntry.Kasia_Order_Number__c : '') + '\n'
                    + 'Nuværende pakke: ' + logEntry.Current_package__c + '\n'
                    + 'Ny pakke: ' +        (logEntry.New_package__c != '' ? logEntry.New_package__c: 'Ikke relevant') + '\n'
                    + 'Ikrafttrædelsesdato: ' + (logEntry.ChangePackageDate__c != '' ? logEntry.ChangePackageDate__c: '') + '\n'
                    + 'Ny beboer afkrydset: ' + (logEntry.selectedmyBeboer__c == true ? 'Ja': 'Nej') + '\n\n'                    
                    + 'Oprettet af:\n'
                    + 'Navn: ' +            (logEntry.CreatedByFullName__c != null ? logEntry.CreatedByFullName__c : '' ) + '\n' 
                    + 'Adresse: ' +         (logEntry.CreatedByAddress__c != null ? logEntry.CreatedByAddress__c : '' ) + '\n' 
                    + 'Email: ' +           (logEntry.CreatedByEmail__c != null ? logEntry.CreatedByEmail__c : '') + '\n' 
                    + 'Privat tlf.: ' +     (logEntry.CreatedByHomePhone__c != null ? logEntry.CreatedByHomePhone__c : '') + '\n'
                    + 'Mobil tlf.: ' +      (logEntry.CreatedByMobile__c != null ? logEntry.CreatedByMobile__c : '') + '\n' 
                    + 'Arb. tlf.: ' +       (logEntry.CreatedByTelephone__c != null ? logEntry.CreatedByTelephone__c : '') + '\n\n'
                    
                                
                    + 'Denne sag er genereret automatisk af Service-Center ved afbestillinger og fejl i ordreprocessen.\n\n'
                    + 'Sagsmedarbejderen bedes i alle tilfælde manuelt tjekke om ovenstående ordre er registreret korrekt i Casper på installationen.\n\n'
                    + 'Mvh\n Service-Center ordrehåndtering';                       
                cases.add(errorCase);
                
                //Insert URL to SC_Activity log making it possible to access the package change order details from the case describtion
               // String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
               //SC-527 URL will be fetched from custom settings
                String baseURL = ServiceCenter_CustomSettings__c.getInstance('SFDC_URL').Value__c;
                
                               
                //Fixes an issue where base url in certain situations contains the substring -api which requires the user to log in again
    /*       no longer required as url is being fetched from Custom Settings
        if(baseURL.indexOf('-api')!=-1)
            {
              baseURL = baseURL.replace('-api', '');  
            }      
            
 */     
          //Fixes a problem where Salesforce sometime inserts http instead of https
          if (baseURL.startsWith('http:')){
            baseURL = baseURL.replaceFirst('http:', 'https:');
          } 
            
            String link = 'Link til omkoblingsordre: ' + baseURL + '/' + logEntry.Id + '\n';
            link += 'Link til øvrige adresser i omkoblingsordre: ' + baseURL + '/' + orderGroupReportId + '?pv0=' + logEntry.OrderGroupId__c;                  
            errorCase.Description =  link + '\n\n' + errorCase.Description;
            
                //Store association between log and case for later update
                if(logWithCase.get(logEntry.Id) == null)
                    logWithCase.put(logEntry.Id, errorCase);
                                        
                //Store log entries for lookup purposes
                SC_Activity_Log__c log = logEntry.clone(true, true);
                if(logEntries.get(logEntry.Id) == null)
                    logEntries.put(logEntry.Id, log); 
            }
            else if(Trigger.isUpdate && Trigger.oldMap.get(logEntry.Id).Kasia_Order_Status__c != 'Completed' && logEntry.Kasia_Order_Status__c == 'Completed' ){
                ordersToBeUpdatedCompleted.add(logEntry.Order__c);                  
            }
            //We don't require that Kasia_Order_Status__c is equal to error due to dependency on OrderStatusService which might be delayed. We only look at changes made to cases.
            else if(Trigger.isUpdate && Trigger.oldMap.get(logEntry.Id).Case__c == null && logEntry.Case__c != null){               
               //Backward update to Order object if trigger isUpdate (i.e not cancellations which are handled by direct insert actions into activity log)
               ordersToBeUpdatedError.add(logEntry.Order__c);
            } 
            //Used to bind orders and cases if Kasia2 or Classic has thrown an error. This update is near realtime and runs in parallel with SC_AssociateCaseAndOrderImpl batch job
            //If the order status service from Classic begins to work, we must conditions to : If Classic or Kasia2 order number is not null and if status changes to error, then run
            else if( Trigger.isUpdate && Trigger.oldMap.get(logEntry.Id).Kasia_Classic_Order_Number__c == null && 
                     logEntry.Kasia_Classic_Order_Number__c != null && !OrderCompareWithCases.contains(logEntry.Id)){
              OrderCompareWithCases.add(logEntry.Id);
            //insert case update logic  
            }                            
        }
        //Perform immidiate check comparing orders against cases
        if(OrderCompareWithCases.size() > 0 && !System.isBatch() && !System.isFuture() && !System.isScheduled()){
          try{
            clsAsyncMethods.bindKasiaCaseAndPackageChange(OrderCompareWithCases);
          }catch(Exception message){
            //If Cast Iron calls this service more than 200 times a day, a LimitException is thrown. This method is not critical since batchjob performs same job.
            system.debug('Error invoking async bindKasiaCaseAndPackageChange');
          }          
        }
        
        //First insert cases to retrieve case ids
        if(cases.size() > 0)
            Database.SaveResult[] resultsCases = Database.insert(cases);
        
        if(logWithCase.size() > 0){
            for(Id logEntryId: logWithCase.KeySet()){
                SC_Activity_Log__c logEntry = logEntries.get(logEntryId); 
                if(logEntry != null){
                    logEntry.Case__c = logWithCase.get(logEntryId).Id;      
                }               
            }
            Database.SaveResult[] resultsLogEntries = Database.update(logEntries.values());
        }       
        
        //Backward update of order object with error status
        if(ordersToBeUpdatedError.size() > 0){
            List <Order__c> updateOrdersError = new List <Order__c>();
            for(Order__c orderObjectError: [Select Id, Kasia_Order_Status__c from Order__c where Id IN : ordersToBeUpdatedError]){
                if(orderObjectError.Kasia_Order_Status__c != 'Error'){
                    orderObjectError.Kasia_Order_Status__c = 'Error';                    
                    updateOrdersError.add(orderObjectError);
                }               
            }
            if(updateOrdersError.size() > 0)
            Database.SaveResult[] resultsOrderError = Database.update(updateOrdersError);                   
        }
        
        //Backward update of order object with completed status
        if(ordersToBeUpdatedCompleted.size() > 0){
            List <Order__c> updateOrdersCompleted = new List <Order__c>();
            for(Order__c orderObjectCompleted: [Select Id, Kasia_Order_Status__c from Order__c where Id IN : ordersToBeUpdatedCompleted]){
                if(orderObjectCompleted.Kasia_Order_Status__c != 'Completed'){
                    orderObjectCompleted.Kasia_Order_Status__c = 'Completed';
                    updateOrdersCompleted.add(orderObjectCompleted);    
                }               
            }
            if(updateOrdersCompleted.size() > 0)
            Database.SaveResult[] resultsOrderError = Database.update(updateOrdersCompleted);           
        }   
    }
}