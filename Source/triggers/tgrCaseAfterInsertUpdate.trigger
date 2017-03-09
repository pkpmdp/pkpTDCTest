trigger tgrCaseAfterInsertUpdate on Case (after insert, after update) {
    
    if(Trigger.IsUpdate && !RecursionControl.runonce) {
        RecursionControl.runonce = true;
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        
        List<Case> updateList = new List<Case>();
        Set<Case> updateSet = new Set<Case>();
        YouSeeCustomSettings__c profIds = YouSeeCustomSettings__c.getInstance('No_case_assignment_customerinformation'); //SPOC 2181
        List<String>prodIdList = new List<String>();
        prodIdList = profIds.Setting_Value__c.split(',');
        Set<String>setProfIds = new Set<String>();
        setProfIds.addAll(prodIdList);
        String profileId = UserInfo.getProfileId().substring(0, 15);
        String oldOwnerId;
        String newOwnerId;
        //SPOC-1602
        String loggedInUserId;
        // A list of all new CaseComments
        List<CaseComment> caseCmnts = new List<CaseComment>();
        String CR_CLOSED  = System.Label.Close_Reason_Closed + ' ';  // CASE CLOSED; CLOSE REASON:
        String CR_NEW     = System.Label.Close_Reason_New + ' ';     // NEW CLOSE REASON:
        String CR_UPDATED = System.Label.Close_Reason_Updated + ' '; // UPDATED CLOSE REASON:

        for (Case c : Trigger.New) {
            // Take the value from Close Reason field and create a new CaseComment
            String closeReason = c.Internal_Comments_Close_Reason__c == null ? '' : c.Internal_Comments_Close_Reason__c.trim();
            String closeReasonOld = Trigger.oldMap.get(c.Id).Internal_Comments_Close_Reason__c;
            closeReasonOld = closeReasonOld == null ? '' : closeReasonOld.trim();
            if (closeReason != '' && closeReason != closeReasonOld) {
                CaseComment caseCmnt = new CaseComment();
                caseCmnt.ParentId = c.Id;
                String prefixStr = (
                    c.Status == 'Closed' && Trigger.oldMap.get(c.Id).Status != 'Closed' ?
                    CR_CLOSED : (closeReasonOld == '' ? CR_NEW : CR_UPDATED)
                );
                closeReason = prefixStr + closeReason;
                if (closeReason.length() > 4000) {
                    // maximum size of the comment body is 4000 bytes
                    closeReason = closeReason.substring(0, 4000);
                }
                caseCmnt.CommentBody = closeReason;
                caseCmnts.add(caseCmnt);
            }
            
            oldOwnerId = trigger.oldMap.get(c.Id).OwnerId;
            newOwnerId = trigger.newMap.get(c.Id).OwnerId;
            System.debug('***OldId-->'+oldOwnerId +' ***NewId-->'+newOwnerId);
           //SPOC-1602
            loggedInUserId=userinfo.getUserId();
            system.debug('loggedInUserId'+loggedInUserId);
if( (trigger.oldMap.get(c.Id).Status=='Reserved') && (c.Type_Task__c!='NP in-port' && c.Type_Task__c!='NP out-port') &&
         (trigger.newMap.get(c.Id).Department__c == trigger.oldMap.get(c.Id).Department__c) &&
         (trigger.newMap.get(c.Id).Type_Task__c == trigger.oldMap.get(c.Id).Type_Task__c) &&
         (trigger.newMap.get(c.Id).Product_2__c == trigger.oldMap.get(c.Id).Product_2__c) && 
         (oldOwnerId==loggedInUserId) && (oldOwnerId.startsWith('005')) &&
         (c.Status!='Cancelled' && c.Status!='Closed' && c.Status!='Postponed' && c.Status!='Reserved')){
                     
                 System.debug('should not fire');
                 Case n = c.clone(true, true);              
                 dmo.assignmentRuleHeader.useDefaultRule = false;
                 n.setOptions(dmo);
                 updateSet.add(n);  
            
            }
            //End of SPOC 1602
            
            //Start of SPOC 2181
            
            else if((setProfIds.contains(profileId) || setProfIds.contains(profileId))&&
                    (c.Type_Task__c!='NP in-port' && c.Type_Task__c!='NP out-port') &&
                    (trigger.newMap.get(c.Id).Department__c == trigger.oldMap.get(c.Id).Department__c) &&
                    (trigger.newMap.get(c.Id).Product_2__c == trigger.oldMap.get(c.Id).Product_2__c) &&
                    (trigger.newMap.get(c.Id).Type_Task__c == trigger.oldMap.get(c.Id).Type_Task__c) &&
                    (oldOwnerId==loggedInUserId) && (oldOwnerId.startsWith('005')) &&
                    (trigger.newMap.get(c.Id).Status == trigger.oldMap.get(c.Id).Status) &&
                    (
                    (trigger.newMap.get(c.Id).AccountId != trigger.oldMap.get(c.Id).AccountId) ||
                    (trigger.newMap.get(c.Id).Customer_Number__c != trigger.oldMap.get(c.Id).Customer_Number__c) ||
                    (trigger.newMap.get(c.Id).ContactId != trigger.oldMap.get(c.Id).ContactId) ||
                    (trigger.newMap.get(c.Id).Anlaeg_No_New__c != trigger.oldMap.get(c.Id).Anlaeg_No_New__c) ||
                    (trigger.newMap.get(c.Id).Number_of_task_in_this_case__c != trigger.oldMap.get(c.Id).Number_of_task_in_this_case__c)||
                    (trigger.newMap.get(c.Id).Urgent__c != trigger.oldMap.get(c.Id).Urgent__c)||
                    (trigger.newMap.get(c.Id).Salesstatus__c != trigger.oldMap.get(c.Id).Salesstatus__c)
                     //(c.Status!='Cancelled' && c.Status!='Closed')
                    )){
                        System.debug('inside spoc 2181');
                        Case n = c.clone(true, true);              
                        dmo.assignmentRuleHeader.useDefaultRule = false;
                        n.setOptions(dmo);
                        updateSet.add(n);
                
            }
            
            // End of SPOC 2181
            
            // When YFF or YOT users utilize "Change Owner" on a case
            // it is returned to the queue due to assignment rules.
            // This if-statement prevents that from happening and leaves
            // the case with whoever it was assigned to using Change Owner
          else if(
            c.Status != 'Reserved' && 
            !c.manual_assign__c && 
            newOwnerId.startsWith('005') && oldOwnerId.startsWith('005') &&
            newOwnerId != oldOwnerId &&
            (profileId == '00e20000000v9G1' || profileId == '00e20000001UQpw' ||
             profileId == '00e20000001UQ6D' || profileId == '00e20000001UR8G' ||
             profileId == '00e20000001UQ6E' || profileId == '00e20000001UQvB' ||
             profileId == '00e20000000vfam' || profileId == '00e20000001UROU')
          ){
             System.debug('*** First Else IF');
              Case n = c.clone(true, true);
              dmo.assignmentRuleHeader.useDefaultRule = false;
              n.setOptions(dmo);
              updateSet.add(n);
          } else if(
            c.Status != 'Reserved' && 
            !c.manual_assign__c && 
            trigger.newMap.get(c.Id).Address__c != trigger.oldMap.get(c.Id).Address__c && 
            trigger.newMap.get(c.Id).Alternative_Address_Text__c == trigger.oldMap.get(c.Id).Alternative_Address_Text__c &&
            trigger.newMap.get(c.Id).Alternate_Name__c == trigger.oldMap.get(c.Id).Alternate_Name__c &&
            trigger.newMap.get(c.Id).AccountId != trigger.oldMap.get(c.Id).AccountId &&
            trigger.newMap.get(c.Id).Customer_Number__c != trigger.oldMap.get(c.Id).Customer_Number__c &&
            (trigger.newMap.get(c.Id).Department__c != trigger.oldMap.get(c.Id).Department__c ||
             trigger.newMap.get(c.Id).Product_2__c != trigger.oldMap.get(c.Id).Product_2__c ||
             trigger.newMap.get(c.Id).Type_Task__c != trigger.oldMap.get(c.Id).Type_Task__c)
          ){
               System.debug('*** @nd Else IF');
              Case n = c.clone(true, true);
              n.setOptions(dmo);
              updateSet.add(n);
          } else if(
            c.Status != 'Reserved' && 
            !c.manual_assign__c && 
            trigger.newMap.get(c.Id).Address__c == trigger.oldMap.get(c.Id).Address__c && 
            trigger.newMap.get(c.Id).Alternative_Address_Text__c == trigger.oldMap.get(c.Id).Alternative_Address_Text__c &&
            trigger.newMap.get(c.Id).Alternate_Name__c == trigger.oldMap.get(c.Id).Alternate_Name__c &&
            trigger.newMap.get(c.Id).AccountId == trigger.oldMap.get(c.Id).AccountId
          ){
              System.debug('*** @nd Final Else IF');//sf-2674
              Case n = c.clone(true, true);
              if(n.status == 'Closed' || n.status == 'Cancelled')
                  n.Reserve_Until__c = null;
                dmo.assignmentRuleHeader.useDefaultRule = true;
              n.setOptions(dmo);
              updateSet.add(n);
          }
        }

        try{
            updateList.addAll(updateSet);

            database.update(updateList);
            System.debug('*************updatelist'+updatelist);

            // Insert all new CaseComments
            if (caseCmnts.size() > 0) {
                insert(caseCmnts);
            }
        } catch(Exception e){
            
            System.debug('Error updating Case:' + e.getMessage());
        }
        system.debug('dmo.assignmentRuleHeader.useDefaultRule'+dmo.assignmentRuleHeader.useDefaultRule);//sf-2674
    }

// NP in-port BEGIN - send confirmation email to the customer ON INSERT --->
    if (Trigger.isInsert) {
        // If the new Case is valid there should be a confirmation request sent immediately
        Set<Id> toConfirmOrderIds = new Set<Id>();
        Map<Id, String> npOrderToDKTVnr = new Map<Id, String>();
        Map<Id, Boolean> npOrderToDKTVflow = new Map<Id, Boolean>();
        for (Case c : Trigger.New) {
            if (
                c.Type_Task__c == clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT &&
                c.Status == clsCasesNpHandlerController.CASE_STATUS_NPRESERVED
            ) {
                toConfirmOrderIds.add(c.NP_Order__c);
                npOrderToDKTVnr.put(c.NP_Order__c, c.NP_DKTV_Customer_Number__c);
                npOrderToDKTVflow.put(c.NP_Order__c, c.NP_DKTV_Flow__c);
            }
        }

        List<NP_Order__c> toConfirmOrders;
        if (toConfirmOrderIds != null && !toConfirmOrderIds.isEmpty()) {
            toConfirmOrders = [
               SELECT Id, Status__c, External_Customer_Number__c,
                   In_Port_Notification_Status__c, First_Reminder_Date__c, Second_Reminder_Date__c, Order_Close_Date__c
               FROM NP_Order__c
               WHERE Id IN :toConfirmOrderIds AND Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION
            ];
            Number_Porting_Configuration__c config = Number_Porting_Configuration__c.getInstance('INPORT_CONFIRMATION');
            for (NP_order__c o: toConfirmOrders) {
                Boolean isDKTVflow = npOrderToDKTVflow.get(o.id);
                if (isDKTVflow != null && isDKTVflow) {
                    // The related customer is a DKTV customer
                    if (o.External_Customer_Number__c == null) {
                        // Set the external number if blank
                        String DKTVnr = npOrderToDKTVnr.get(o.id);
                        if (DKTVnr != null) {
                            o.External_Customer_Number__c = DKTVnr;
                        }
                    }
                    // Automatic confirm for an in-port of a DKTV customer phone number
                    o.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPINPORTCONFIRMED;
                } else {
                    // Set confirmation reminders and send a confirmation request
                    clsCasesNpHandlerController.setConfirmationReminders(o, config);
                }
            }
        }

        try {
            if (toConfirmOrders != null) {
                database.update(toConfirmOrders);
            }
        } catch(Exception e){
            System.debug('Error updating NP Orders: ' + e.getMessage());
        }
    }
    // SPOC - 1930 // Apurva
    /*list<string> listCaseEmail = new list<string>();
    map<string,case> mapCase = new map<string,case>();
    if(Trigger.isInsert)
    {
    
        system.debug('In if insert ***');
        for(Case cs : Trigger.new)
        {
            system.debug('Triger .new *** '+cs);
            listCaseEmail.add(cs.Email__c);
            mapCase.put(cs.Email__c,cs);
        }
    }
    system.debug('listCaseEmail *** '+listCaseEmail);
    system.debug('mapCase ***'+mapCase);
    List<Account> listAccount = [select id,name,recordtypeid from Account where email__c in : listCaseEmail];
    system.debug('listAccount *** '+listAccount);
    List<case> listCaseToUpdate = new List<case>();
    if(listAccount.size() == 1)
    {
        system.debug('In if size chk *** listAccount.size() *** '+listAccount.size());
        for(Account acc : listAccount)
        {
            if(acc.Recordtype.DeveloperName == 'Blockbuster_Customer_Account'){
            system.debug('if blockbuster *** ');
                Case case1 = mapCase.get(acc.Email__c);
                case1.AccountId = acc.id;
                listCaseToUpdate.add(case1);
            }
        }
    }
    if(listCaseToUpdate.size() > 1)
    {
        update listCaseToUpdate;
    } */
// <--- NP in-port END - send confirmation email to the customer ON INSERT

    //These two parts are for thr creation of Handlers records
    //for Case Owner changes
    if(Trigger.isInsert){
        

        clsHandlerManager.takeOwnership(Trigger.NewMap);
    } 
    
    if(Trigger.isUpdate){
        
        Map<Id, Case> newCasesOnTarget = new Map<Id, Case>();
        List<Case> oldCasesOnTarget = new List<Case>();
        Set<Id> closedCases = new Set<Id>();
        for(Case case2:Trigger.new ){
            
            if(case2.ownerId != Trigger.oldMap.get(case2.Id).OwnerId && !case2.manual_assign__c){
                newCasesOnTarget.put(case2.Id,case2);
                oldCasesOnTarget.add(Trigger.oldMap.get(case2.Id));
            }
            // Collect Ids of cases that are being closed now
            if (case2.IsClosed && !Trigger.oldMap.get(case2.Id).IsClosed) {
                closedCases.add(case2.Id);
            }
        }
        
        if(newCasesOnTarget.size() > 0 && oldCasesOnTarget.size() > 0){
            
            //clsHandlerManager.releaseOwnership(oldCasesOnTarget);
            clsHandlerManager.releaseOwnership(oldCasesOnTarget, closedCases);

            clsHandlerManager.takeOwnership(newCasesOnTarget);
        
        }
    }
      
      // CB Case part
      // check for CB Cases lookups, if there are any Cancelled or Closed cases, update lookup to null and delete CB_Case objects
      if(Trigger.isUpdate){
        List<CB_Case__c> lstToDelete = new List<CB_Case__c>();
        
      for (Case c : Trigger.New) {
        if ((c.Status == 'Closed' || c.Status == 'Cancelled') && c.Call_Back__c != null){
            List<CB_Case__c> lst = [SELECT Id FROM CB_Case__c WHERE Id = : c.Call_Back__c];
            lstToDelete.addAll(lst);
        }
      }
      
      try {
        delete lstToDelete;
        } catch(Exception e){
        system.debug('Error updating Case:' + e.getMessage());
      }       
      }
      // CB Case par

    if(Trigger.isUpdate){
        List<Id> accIdsToUpdate = new List<Id>(); //SPOC-1269
        List<Id> caseIdsInTrigger = new List<Id>(); //SPOC-1269
        for (Case c : Trigger.New) {
            Case oldCase = Trigger.oldMap.get(c.Id);
            //SPOC-499 section
            if(
                c.status == 'Re-Opened' &&
                oldCase.status != 'Re-Opened'
            ){
                List<Handler__c> lastClosedHandler = [
                    SELECT ClosedByUserTimeStamp__c, isReOpened__c FROM Handler__c WHERE ClosedByUser__c = true AND Case__c=:c.Id
                    ORDER BY ClosedByUserTimeStamp__c DESC LIMIT 1
                ];
                if (lastClosedHandler.size() > 0) {
                    if (!lastClosedHandler[0].isReOpened__c) {
                        lastClosedHandler[0].isReOpened__c = true;
                        lastClosedHandler[0].BeginEndActivityDelta__c =
                            (System.now().getTime() - lastClosedHandler[0].ClosedByUserTimeStamp__c.getTime())/60000
                        ;
                        update lastClosedHandler[0];
                    } else {
                        System.debug('Error: No corresponding closed record found');
                    }
                }
            }
            //End of SPOC-499 section

            //SPOC-1269 section
            if (c.AccountId != null &&
                c.Udsendt_survey_test__c && !oldCase.Udsendt_survey_test__c &&
                c.Status == 'Closed'
            ) {
                // Case.SurveySent changes into True (by time-based WF rule) on a closed Case ->
                // set Account.SurveySentDate to today
                accIdsToUpdate.add(c.AccountId);
            }
            // These must not be updated again (to avoid an update loop)
            caseIdsInTrigger.add(c.Id);
        }
        List<Account> accsToUpdate = new List<Account>();
        if (!accIdsToUpdate.isEmpty()) {
            List<Account> accs = [
                SELECT Survey_sent_date__c FROM Account WHERE Id IN :accIdsToUpdate
            ];
            for (Account acc : accs) {
                acc.Survey_sent_date__c = Date.today();
                accsToUpdate.add(acc);
            }
        }
        if (!accsToUpdate.isEmpty()) {
           try{
                update accsToUpdate;
           } catch(Exception e){
               System.debug('Error updating Account:' + e.getMessage());
               List<Scheduled_Update__c> scheduled_Updates = new List<Scheduled_Update__c>();
               for(Account account : accsToUpdate) {
                   Scheduled_Update__c  scheduled_Update = new Scheduled_Update__c(Id__c = account.Id);    
                   scheduled_Updates.add(scheduled_Update);
               }
               insert(scheduled_Updates);
           }         
        }
        // Cancel survey sending for other Cases related to the same Account
        // which are waiting in time-based WF queue (Closed AND SurveySent = False)
        List<Case> casesToUpdate = new List<Case>();
        if (!accIdsToUpdate.isEmpty()) {
            List<Case> cases = [
                SELECT Survey_Cancellation__c FROM Case
                WHERE Id NOT IN :caseIdsInTrigger AND AccountId IN :accIdsToUpdate
                    AND Status = 'Closed' AND Udsendt_survey_test__c = False
                    AND Survey_Cancellation__c = False
            ];
            for (Case aCase : cases) {
                aCase.Survey_Cancellation__c = True;
                casesToUpdate.add(aCase);
            }
        }
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
        //End of SPOC-1269 section
    }

    // Update of Milestones
    if(Trigger.isUpdate){
        List<Case> casesToUpdate = new List<Case>();
    
        for (Case c : Trigger.New) {
            Case oldCase = Trigger.oldMap.get(c.Id);
            if(
                c.EntitlementId != null && 
                oldCase != null && 
                c.status == 'Closed' &&
                oldCase.status != 'Closed'
            ){
                casesToUpdate.add(c);
            }
        }
        
        if(!casesToUpdate.isEmpty()){
            List<CaseMilestone> cmList = [SELECT id,CompletionDate FROM CaseMilestone WHERE CaseId IN :casesToUpdate];
            if (cmList.isEmpty() == false){
                for(CaseMilestone tmpCM: cmList){
                    tmpCM.CompletionDate = System.now();
                }
            
                try{
                    update cmList;                
                }catch(Exception e){
                    System.debug('Error updating milestones:' + e.getMessage());
                }
            }
        }
    }
    
    //Start for SF-2139
    /*
    -- Functional Scope: When a case is Closed or Cancelled (case status) the related not closed tasks 
        to the closed case with task subject ‘Follow-up Reserved Case’ should be automatically closed.
        
    -- Technical Approach: 
        Step 1: Check on which cases the status has been changed to 'Closed or 'Cancelled'. Create a SET of IDs.
        Step 2: Query related tasks which are not completed and are related to Cases in context.
        Step 3: Query the status from the related tasks and update the same to 'Completed'.
    */
    
    if(Trigger.isUpdate){
        
        Set<Id> updatedCases = new Set<Id>();
        //Step 1 - Check on which cases the status has been changed to closed. Create a SET of IDs.
        for(Case c : Trigger.new){
            String oldStatus = Trigger.oldMap.get(c.Id).Status;
            String newStaus = c.Status;
            
            if(oldStatus != newStaus && (newStaus == 'Closed' || newStaus == 'Cancelled')){
                updatedCases.add(c.Id);
            }
        }
        
        // Step 2 - Query related tasks which are not completed and are related to Cases in context.
        List<Task> relatedTasks = new List<Task>();
        relatedTasks = [Select Id FROM Task
                        WHERE Status!= 'Completed'
                        AND Subject = 'Follow-up Reserved Case'
                        AND WhatId IN :updatedCases];
        
        // Step 3 - Query the status from the related tasks and update the same to 'Completed'
        List<Task> relatedTasksToUpdate = new List<Task>();
        if(!relatedTasks.IsEmpty()){
            List<Task> tasks = [Select Status FROM Task
                                WHERE Id IN :relatedTasks];
            
            for(Task t : tasks){
                t.Status = 'Completed';
            relatedTasksToUpdate.add(t);
            }
            
            if(!relatedTasksToUpdate.IsEmpty()){
                try{
                update relatedTasksToUpdate;
                }
                catch(Exception e){
                    System.debug('Tasks not marked as Completed:' + e.getMessage());
                }   
            }                       
        }
            
    }
    // End of SF-2139

        
 }