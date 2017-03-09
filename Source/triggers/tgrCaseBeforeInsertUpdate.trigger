trigger tgrCaseBeforeInsertUpdate on Case (before insert, before update) {
    //System.debug('darren' + Trigger.new);
    // Agents sometimes link to customer using customer number - not account lookup

// NP BEGIN --->
    // Are there any NP specific Cases to process?
    boolean isNpCase = false;
    // Select all NP Orders for inserted/updated NP Cases
    Set<Id> npOrderIds = new Set<Id>(); // <NpOrderId>
    Map<Id, NP_Order__c> npOrderIdToNPOrder = new Map<Id, NP_Order__c>(); // <NpOrderId::NP Order>
    for (Case aCase:Trigger.new) {
        if (aCase.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT ||
            aCase.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT
        ) {
            isNpCase = true;
            if (aCase.NP_Order__c != null) {
                npOrderIds.add(aCase.NP_Order__c);
            }
        }
       
        /*YB Case code - Updates the YB Case Check Box if product or type/task is changed. Orignially, this code was
              placed in a workflow rule with field update to YB Case Check Box, but due to issues with order of execution, the logic is now implemented in this trigger.
              This makes it possinle for recordtype triggers to fire with subsequent assignment rules to work as expected.
              Note that cases having department=YB and Product are also marked as YB Cases
        */
        /*if(Trigger.isUpdate){           
            if( 
                (Trigger.oldMap.get(aCase.Id).YB_Case__c == true) && 
                (
                    (Trigger.oldMap.get(aCase.Id).Department__c != 'YB' && Trigger.oldMap.get(aCase.Id).Product_2__c == 'Klage' && aCase.Product_2__c != 'Klage') ||
                    ( (Trigger.oldMap.get(aCase.Id).Department__c == 'YB' && Trigger.oldMap.get(aCase.Id).Product_2__c == 'Klage') &&
                    ( (aCase.Department__c != 'YB' && aCase.Product_2__c != 'Klage') || (aCase.Product_2__c != 'Visitering' && aCase.Product_2__c != 'Klage'))) ||                  
                    ( (Trigger.oldMap.get(aCase.Id).Department__c == 'YB' && Trigger.oldMap.get(aCase.Id).Product_2__c == 'Visitering') &&
                    ( (aCase.Department__c != 'YB' && aCase.Product_2__c != 'Klage') || (aCase.Product_2__c != 'Visitering' && aCase.Product_2__c != 'Klage'))) 
                )){//End OR and If
                aCase.YB_Case__c = false;   
            }
        }*/
        //Security code allowing certain customers to close their own case from auto-response emails. 
        //YOT is the first project to experiment with this functionality
        if(Trigger.isInsert)
            aCase.SecurCode__c = Crypto.getRandomInteger().format();
    }
    if (!npOrderIds.isEmpty()) {
        for (
            NP_Order__c npOrder: [
                SELECT id, Customer_Email__c, Customer_Name__c, Customer_Number__c, Customer_Number_Kasia__c,
                    External_Customer_Name__c, External_Customer_Number__c, External_Operator__c, NP_Date__c,
                    Telephone_Number__c, Series_Count__c, Is_Frequent_Code__c, External_Operator_Code__c,
                    Authorization_Approved__c, Authorization_Received__c, Authorization_Deadline__c,
                    Current_Customer_Id__c, Status__c, In_Port_Notification_Status__c,
                    First_Reminder_Date__c, Second_Reminder_Date__c, Order_Close_Date__c
                FROM NP_Order__c WHERE id IN :npOrderIds]
        ) {
            npOrderIdToNPOrder.put(npOrder.id, npOrder);
        }
    }

    // Do we need to compute a working day 30 days from today to set instead of an empty NP date?
    Datetime workDay = null;
    boolean isFutureWorkingDateNeeded = false;
    if (isNpCase) {
        for (Case aCase:Trigger.new) {
            if (aCase.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT) {
                NP_Order__c npOrder = npOrderIdToNPOrder.get(aCase.NP_Order__c);
                if (npOrder != null &&
                    npOrder.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED
                ) {
                    // there is an NP out-port order (created/updated by CastIron) to process
                    isFutureWorkingDateNeeded = true;
                    break;
                }
            }
        }
    }
// <--- NP END

  /*  for(Case case2:Trigger.new){
       
        if(case2.Anlaeg_No_New__c != null){
            while (case2.Anlaeg_No_New__c.length() < 10) {
                
                case2.Anlaeg_No_New__c = '0' + case2.Anlaeg_No_New__c;
            }  
        }
    } */
    clsCasesUtil util = new clsCasesUtil();
    util.linkCasesToCustomer(Trigger.new, Trigger.old);
    
    
    //Trigger to define Entitlement lookup for the case 
    clsEntitlementCalculator.calculateEntitlement(Trigger.new);

// NP BEGIN --->
    // NP Orders to be updated
    List<NP_Order__c> toUpdateOrders = new List<NP_Order__c>();
    // Accounts to be updated
    List<Account> toUpdateAccounts = new List<Account>();
    // IDs of NP Orders to be accepted by OCH
    Set<Id> acceptedOrderIds = new Set<Id>();
    Map<Id, Id> acceptedCases = new Map<Id, Id>();

    Set<String> inCustNumbers = new Set<String>();
    if (isNpCase) {
        if (isFutureWorkingDateNeeded) {
            // the working day 30 days from today might be needed if no NP Date comes with the order
            workDay = clsCasesNpHandlerController.computeFutureWorkingDate(Datetime.now(), 30);
        }

        for (Case x: Trigger.new) {
            if (x.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT
                || x.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT
            ) {
                // Collect non-null Customer Numbers either from Case or from NP Order
                if (x.Customer_Number__c != null) {
                    inCustNumbers.add(x.Customer_Number__c);
                } else if (x.NP_Customer_Number__c != null) {
                    // NP_Customer_Number__c is a formula field (Customer Number value in related NP Order)
                    inCustNumbers.add(x.NP_Customer_Number__c);
                } else {
                    NP_Order__c npOrder = npOrderIdToNPOrder.get(x.NP_Order__c);
                    if (npOrder != null && npOrder.Current_Customer_Id__c != null) {
                        inCustNumbers.add(npOrder.Current_Customer_Id__c);
                    }
                }
            }
        }
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Map<String, Account> custNrToAccount = new Map<String, Account>();
        for (Account acc:[SELECT Id, Customer_No__c, PersonEmail FROM Account WHERE Customer_No__c IN :inCustNumbers]
        ) {
            accountMap.put(acc.Id, acc);
            custNrToAccount.put(acc.Customer_No__c, acc);
        }

        if (Trigger.isInsert) {
            // Prepare necessary Account data
            Map<Id, String> accNamesMap = new Map<Id, String>();
            for (Account acc:[SELECT Id, Name FROM Account WHERE Customer_No__c IN :inCustNumbers]) {
                // We need another SOQL - if we selected Name in the previous SOQL, SF would complain on Account update
                accNamesMap.put(acc.Id, acc.Name);
            }
            for (Case case2:Trigger.new) {
                // There must be a look up relation between NP Case and NP Order
                NP_Order__c npOrder = npOrderIdToNPOrder.get(case2.NP_Order__c);
                if (case2.NP_Order__c != null && npOrder != null) {
                    // Type/Task value identifies an NP In-port Case record
                    if (
                        case2.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT &&
                        npOrder.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED
                    ) {
                        Account acc = accountMap.get(case2.AccountId);
                        if (acc != null) {
                            // if NP Order email is different than related Account email
                            if (npOrder.Customer_Email__c != null && npOrder.Customer_Email__c != acc.PersonEmail) {
                                acc.PersonEmail = npOrder.Customer_Email__c;
                                acc.No_Email__c = false;
                                toUpdateAccounts.add(acc);
                            }
                        }
                        // set NP Order Customer Name if empty
                        if (npOrder.Customer_Name__c == null) {
                            String accName = accNamesMap.get(case2.AccountId);
                            if (accName != null) {
                                npOrder.Customer_Name__c = accName;
                            }
                        }
                        // Validate a new in-port order:
                        // Validation #1: All required input fields must be filled in
                        if (
                            npOrder.Telephone_Number__c == null ||
                            npOrder.Customer_Email__c == null || case2.Origin == null ||
                            case2.AccountId == null || npOrder.Customer_Number__c == null
                        ) {
                            // Any of input fields has no value -> Case Incomplete
                            // Set values of record type and status
                            //noRT: case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEINCOMPLETE);
                            if (case2.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                                case2.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
                            }
                            npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE;
                        } else {
                            boolean isOK = true;
                            // Validation #2
                            if (isOK && npOrder.Customer_Number__c != null && case2.AccountId != null) {
                                // The given customer nr. must be associated with the customer identified by AccountId
                                if (acc == null) {
                                    isOK = false;
                                } else {
                                    isOK = npOrder.Customer_Number__c.equals(acc.Customer_No__c);
                                }
                            }
                            // Validation #3
                            if (isOK && npOrder.Telephone_Number__c != null) {
                                // The given phone nr. must be a valid one (8 digits)
                                isOK = Pattern.compile('[0-9]{8}').matcher(npOrder.Telephone_Number__c).matches();
                            }
                            // Validation #4
                            if (isOK && npOrder.Customer_Email__c != null) {
                                // The given e-mail must have a valid format
                                //isOK = Pattern.compile('^[a-zA-Z][a-zA-Z0-9_\\.\\-]+@([a-zA-Z0-9-]{2,}\\.)+([a-zA-Z]{2,4}|[a-zA-Z]{2}\\.[a-zA-Z]{2})$').matcher(npOrder.Customer_Email__c).matches();
                                isOK = Pattern.compile('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$').matcher(npOrder.Customer_Email__c).matches();
                            }
                            if (isOK) {
                                // Fields are valid -> Case Valid
                                // Set Case status value
                                //noRT: case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEOPEN);
                                if (case2.Status == clsCasesNpHandlerController.CASE_STATUS_NEW) {
                                    case2.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
                                }
                                // Set NP Order Status
                                npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION;
                                //clsCasesNpHandlerController.setConfirmationReminders(npOrder, config); -this is done in tgrCaseAfterInsertUpdate
                            } else {
                                // Any of input fields failed the validation -> Case Incomplete
                                // Set values of record type and status
                                //noRT: case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPINPORTCASEINCOMPLETE);
                                if (case2.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED) {
                                    case2.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
                                }
                                npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE;
                            }
                        }
                        toUpdateOrders.add(npOrder);
                        // Set correct record type for new NP in-port
                        case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPQUEUE);
                    }
                    else if (
                        case2.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT &&
                        npOrder.Status__c == clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED
                    ) {
                        // The Case record is to be created with an OCH request
                        clsCasesNpHandlerController.validateNpCaseInTrigger(
                            npOrder, case2, toUpdateOrders, custNrToAccount, workDay
                        );
                        // Set correct record type for new NP out-port
                        case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPQUEUE);
                    }
                    // Update xxx_Srch__c values
                    case2.NP_Telephone_Number_Srch__c = npOrder.Telephone_Number__c;
                    case2.NP_Customer_Number_Srch__c = npOrder.Customer_Number__c;
                }
            }
        } else if (Trigger.isUpdate) {
            for (Case case2:Trigger.new) {
                // Set correct record type for updated NP Cases:
                if (case2.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT ||
                    case2.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT
                ) {
                    if (case2.IsClosed) { //case2.Status == clsCasesNpHandlerController.CASE_STATUS_CLOSED) {
                        case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPCLOSED);
                    } else if (case2.RecordTypeId == clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_OPEN)) {
                        if (case2.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT) {
                            case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOPEN_IN);
                        } else {
                            case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPOPEN_OUT);
                        }
                    } else if (case2.RecordTypeId == clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_QUEUE)) {
                        case2.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPQUEUE);
                    }
                }
            }
        }

        if (!toUpdateOrders.isEmpty()) {
            database.update(toUpdateOrders);
        }
        if (!toUpdateAccounts.isEmpty()) {
            database.update(toUpdateAccounts);
        }
    }
// <--- NP END
/*
    //This code is to populate Case with Milestone data
    if(Trigger.isUpdate){
        
        List<Case> cases = new List<Case>();
        for(Case case2:Trigger.new){

//            if(Trigger.oldMap.get(case2.Id).EntitlementId != case2.EntitlementId){
                
                cases.add(case2);
//            }
        }

        if(cases.size() > 0)
            clsPopulateCaseWithMilestoneData.populateMilestoneData(cases);
    }
*/
    // Outbound , Call Back START
    
    /* Map Case record types to Call Back Case record types
    Workflows change record types after some business actions.
    But if Case is Call Back Case we need our record types similiar as Case record types.
    */
    static final String CALL_BACK_PRODUCT = 'YOT Call Back';
    //static final String OUTBOUND_PRODUCT = 'Green Lamp';
    static final String OUTBOUND_DEPARTMENT = 'YKRL';
 
    boolean needToChangeRecordType = false;
   
    Map<String, ID> mapNameId = new Map<String,ID>();
    Map<ID, String> mapIdName = new Map<ID, String>();
    Map<ID, Account> mapIdAccount = new Map<ID, Account>();
    Set<ID> caseOutbound = new Set<ID>();
    for(Case case2:Trigger.new){
        if (case2.Product_2__c == CALL_BACK_PRODUCT ){
            needToChangeRecordType = true;
        }
        else if (case2.Department__c == OUTBOUND_DEPARTMENT){
            needToChangeRecordType = true;
            if(case2.AccountId != null ){           
                caseOutbound.add(case2.AccountId);
            }           
        }
    }
    
    if (needToChangeRecordType) { 
        if (!caseOutbound.isEmpty()){
            for (
                Account outboundAccount: [
                   select Id ,Home_Phone__c,PersonMobilePhone, Phone from 
                    Account where id IN :caseOutbound ]
            ) {
                mapIdAccount.put(outboundAccount.Id,outboundAccount);
            }
        }  
        List<RecordType> caseRecordTypes = new List<RecordType>();
                    	caseRecordTypes = [Select Id , Name From RecordType Where SobjectType = 'Case' and IsActive = true];
      
       	
        for(RecordType recordType: caseRecordTypes){
            mapNameId.put(recordType.Name,recordType.Id);
            mapIdName.put(recordType.Id,recordType.Name);
        }
        for(Case case2:Trigger.new){
            if (case2.Product_2__c == CALL_BACK_PRODUCT){
                if ( mapIdName.get(case2.RecordTypeId) == 'Queue Owned Case'){
                    case2.RecordTypeId = mapNameId.get('Call Back Queue Owned Case');
                //} else if ( mapIdName.get(case2.RecordTypeId) == 'YB Closed Case'){
                //  case2.RecordTypeId = mapNameId.get('Call Back Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Web to Case - Kollegahdaelp'){
                    case2.RecordTypeId = mapNameId.get('Call Back Web to Case - Kollegahdaelp');
                //} else if ( mapIdName.get(case2.RecordTypeId) == 'YB Complaints Case'){
                //  case2.RecordTypeId = mapNameId.get('Call Back Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'YKS Sag'){
                    case2.RecordTypeId = mapNameId.get('Call Back YKS Sag Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Open Case - No Document'){
                    case2.RecordTypeId = mapNameId.get('Call Back Open Case - No Document');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Closed Case'){
                    case2.RecordTypeId = mapNameId.get('Call Back Closed Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Open Case'){
                    case2.RecordTypeId = mapNameId.get('Call Back Open Case');
                }
            }
            else if (case2.Department__c == OUTBOUND_DEPARTMENT){
            /* done in workflow
                if(case2.AccountId != null ){ 
                    Account caseAccount = mapIdAccount.get(case2.AccountId);
                    if (caseAccount!=null){ //rare situation account is deleted durring run this trigger.
                        case2.Dialable_Home_Phone__c = caseAccount.Home_Phone__c;
                        case2.Dialable_Mobile_Phone__c = caseAccount.PersonMobilePhone;
                        case2.Dialable_Phone_Number__c = caseAccount.Phone;
                        System.debug(case2.Dialable_Home_Phone__c + '--------------------');
                    }
                }               
             */
                if ( mapIdName.get(case2.RecordTypeId) == 'Queue Owned Case'){
                    case2.RecordTypeId = mapNameId.get('Outbound Queue Owned Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Closed Case'){
                    case2.RecordTypeId = mapNameId.get('Outbound Closed Case');
                } else if ( mapIdName.get(case2.RecordTypeId) == 'Open Case'){
                    case2.RecordTypeId = mapNameId.get('Outbound Open Case');
                }
            }           
        }
    }
    // Outbound , Call Back END
    
    // Remove Carriage Returns from Description START
    
    List<Case> newCases = Trigger.new;
    for(Integer j = 0; j < newCases.size(); j++){
        if(UserInfo.getName() == 'API User' && newCases[j].Description != null){
            String trimDescription = newCases[j].Description;
            try {
                /* Existing one
                trimDescription = trimDescription.replaceAll('([\\s\\p{Z}]*\\n){3,}','\n\n');*/
                system.debug('Case description before trim'+ trimDescription );
                trimDescription = trimDescription.replaceAll('\r','\n');
                system.debug('Case description after trim'+ trimDescription);
            } catch(Exception e){
                System.debug('Trim exception on Case ' + newCases[j].Id);
            }
            newCases[j].Description = trimDescription;  
        } 
    }
    // Remove Carriage Returns from Description END
    
    //#######################   START : SPOC-1852   ####################//
    
        List<Customer_Log__c> lst_custLogs=new List<Customer_Log__c>();
        try{    
        if(Trigger.isUpdate && !KundeLogRecursionControl.runonce){
         KundeLogRecursionControl.runonce = true; // trigger recursion control to let it run once
        // String DEFAULT_CUSTOMER_LOG_TYPE= Label.KundeLogType; // default picklist value
       String inquiryTypeValue=null;
       ConsoleCustTypeCustomLog__c cctcObj =ConsoleCustTypeCustomLog__c.getInstance(UserInfo.getProfileId());
        if(cctcObj!=null){
            inquiryTypeValue=cctcObj.Inquirytypevalue__c;
            system.debug('###inquiryTypeValue:'+inquiryTypeValue);
        }
        
         system.debug('###inside isUpdate');
            for(Case caseObj: Trigger.New){
                system.debug('###caseObj.Save_in_Kundelog__c:'+caseObj.Save_in_Kundelog__c+' Internal_Comments_Close_Reason__c:'+ caseObj.Internal_Comments_Close_Reason__c);
                 if(caseObj.Save_in_Kundelog__c==true && caseObj.Internal_Comments_Close_Reason__c!=null&&(trigger.newMap.get(caseObj.Id).status=='Closed'||trigger.newMap.get(caseObj.Id).status=='Cancelled'))
                    {
                        Customer_Log__c clObj=new Customer_Log__c();
                        clObj.Text__c='Sagsnummer '+caseObj.CaseNumber+': '+caseObj.Internal_Comments_Close_Reason__c;
                        clObj.Customer__c=caseObj.AccountId;
                        //clObj.Case_Number__c = caseObj.CaseNumber;
                        //clObj.Inquiry_Type__c=Label.KundeLogType;
                        clObj.Inquiry_Type__c=caseObj.Inquiry_Type__c;
                      
                        lst_custLogs.add(clObj);
                        caseObj.Save_in_Kundelog__c=false;
                        //caseObj.Internal_Comments_Close_Reason__c='';
                        caseObj.Inquiry_Type__c=null;
                    }
            }
        }
        if(lst_custLogs.size()>0){
            system.debug('###lst_custLogs.size: '+lst_custLogs.size());
            insert lst_custLogs;   
        }
        }
        catch(Exception e){
          Trigger.new[0].addError(Label.Err_tocls_non_custcase);
        } 
    
    //####################### END : SPOC-1852   ####################//
    //Changes for spoc 1930
    if(Trigger.isUpdate){
      Map<String, Case> accountsToUpdateBlocklbuster = new Map<String, Case>();
      List<Case> caseToBEUpdated = new List<Case>();
      for(Case c : Trigger.New){
        if((c.AccountId == null) && (c.Email__c != null) && (c.Department__c =='Blockbuster')){
          accountsToUpdateBlocklbuster.put(c.Email__c,c);
          
        }
      }
      if(accountsToUpdateBlocklbuster.size() >0 ){
        List<Account> blockbusterAccount = [Select Id, PersonEmail, (Select Id, Name From Contacts) From Account Where PersonEmail <> null and PersonEmail In :accountsToUpdateBlocklbuster.keySet() and Brands__c ='Blockbuster'];
        if(blockbusterAccount.size()== 1){
          for (Case c: accountsToUpdateBlocklbuster.values()) {
            for(Account a:blockbusterAccount){
              if(a.PersonEmail == c.Email__c){
                c.AccountId = a.Id;
                c.Email__c = a.PersonEmail;
                caseToBEUpdated.add(c);
                if(a.Contacts.size()!=0){
                            //System.debug('Wen'+account.Contacts[0].id);
                            c.ContactId = a.Contacts[0].id;
                        }
              }
            }
          }
        }
      }
      System.debug('CAses to be updated' +caseToBEUpdated );
      //update caseToBEUpdated;
    }
    //END SPOC-1930
}