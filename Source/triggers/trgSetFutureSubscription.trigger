trigger trgSetFutureSubscription on Subscription__c (after insert,after delete,after update) {

    System.debug('---InsidetrgSetFutureSubscription ---');
    Savepoint sp= Database.setSavepoint();
    CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('Trigger_future error','Trigger_future error');
    List<Id> installationIdList = new List<Id>();
    List<Net_Installations__c> existInstallationList = new List<Net_Installations__c>();  
    List<Net_Installations__c> installationListToBeUpdated = new List<Net_Installations__c>();
    
    List<Subscription__c> deletedSubscrRecords = new List<Subscription__c>();
    List<Subscription__c> subscrList = new List<Subscription__c>();
    Set<Id> deletedNetInstId = new Set<Id>();
    //List<Id> futureinstIds = new List<Id>();
    List<Net_Installations__c> netInstList = new List<Net_Installations__c>();
    List<Net_Installations__c> netInstListToUpdate = new List<Net_Installations__c>();
    
    date mydate = date.today();
    String formattedSysDate = String.valueOf(mydate);
    String formattedCurrentSysDate;
    if(mydate != null){
        //converting the current date in dd-MM-yyyy  format
       formattedCurrentSysDate = convertDateFormat(mydate);
    }
    try{
      if(Trigger.isAfter && Trigger.isInsert){
          System.debug('----Inside insert trigger-----');
          Map<ID, String> instSubscrIdMap = new Map<ID, String>();
          List<Subscription__c> subscriptionListToBeUpdated = new List<Subscription__c>();
          List<Subscription__c> futureSubscriptionList = new List<Subscription__c>();
          List<Subscription__c> existActiveSubscriptionList = new List<Subscription__c>();
          //Only in case of upgrade/downgrade and new order
          futureSubscriptionList = trigger.new;
          System.debug('---futureSubscriptionList size---'+futureSubscriptionList.size());
          String formattedStartDate,formattedReqStartDate,formattedReqEndDate;
          
          
          if(futureSubscriptionList.size() > 0){
            for(Subscription__c futureSubscription : futureSubscriptionList){
              if(futureSubscription.Requested_Start_Date__c != null){
                 formattedReqStartDate = convertDateFormat(futureSubscription.Requested_Start_Date__c);
              }
              if(futureSubscription.Start_Date__c != null){
                formattedStartDate = convertDateFormat(futureSubscription.Start_Date__c);
              }
              if(futureSubscription.Requested_End_Date__c != null){
                    formattedReqEndDate = convertDateFormat(futureSubscription.Requested_End_Date__c);
              }
              if(formattedStartDate != null && formattedStartDate != '01-01-2100' && formattedStartDate != '01-01-1900' && futureSubscription.Start_Date__c != null && futureSubscription.Start_Date__c <= mydate){
                  System.debug('Inside Manual Update');
                  if(formattedReqEndDate != '01-01-2100' && formattedReqEndDate != '01-01-1900'){
                      installationIdList.add(futureSubscription.Net_Installation__c);
                     // instSubscrIdMap.put(futureSubscription.Net_Installation__c, futureSubscription.Id);
                  }
              }else{
                  System.debug('Inside Normal Case');
                    if(formattedReqStartDate != null && formattedReqStartDate != '01-01-2100' && formattedReqStartDate != '01-01-1900'){
                        if(mydate != null && futureSubscription.Requested_Start_Date__c >= mydate){
                            if(futureSubscription.Net_Installation__c != null){     
                                installationIdList.add(futureSubscription.Net_Installation__c);
                                instSubscrIdMap.put(futureSubscription.Net_Installation__c, futureSubscription.Id);
                            }
                        }
                    }
              }
              
            }//end of for loop
          }//end of if condition    
          String formattedEndDate;
          String uniqueInstIds='';
          if(installationIdList.size() > 0){
            for(Id instId : installationIdList){
              if(!uniqueInstIds.contains(instId)){
                 if(uniqueInstIds == null || uniqueInstIds == ''){
                     uniqueInstIds = '\'' + instId + '\'';
                 }else{
                     uniqueInstIds += ',\'' +instId+'\'';
                 } 
              }
           }
          }
          String strQuery;
          if(uniqueInstIds != null && uniqueInstIds != ''){
             strQuery = 'select s.Id, s.Net_Installation__c,s.Future_Subscription__c,s.End_Date__c,'+
                                's.Net_Installation__r.HasFuturePackage__c From Subscription__c s where';
             strQuery = strQuery + ' s.Net_Installation__c in ('+ uniqueInstIds +') and s.Start_Date__c <= '+ formattedSysDate + ' and s.Future_Subscription__c = null';
          }
          if(strQuery != null){
            System.debug('strQuery--'+strQuery);
            existActiveSubscriptionList = DataBase.query(strQuery);
          }
         System.debug('existActiveSubscriptionList---'+existActiveSubscriptionList);
         //Below block should get executed only in case of upgrade/downgrade - for picking the old existing subscription
         if(existActiveSubscriptionList.size() > 0){
           for(Subscription__c selectedSubscription : existActiveSubscriptionList){
              if(instSubscrIdMap.size() > 0 && instSubscrIdMap.get(selectedSubscription.Net_Installation__c) != null){
                 
                if(selectedSubscription.End_Date__c != null){
                 formattedEndDate = convertDateFormat(selectedSubscription.End_Date__c);
                }
                System.debug('formattedEndDate----'+formattedEndDate);
                if(formattedEndDate != null && (formattedEndDate == '01-01-2100' || formattedEndDate == '01-01-1900')){
                 System.debug('inside if formattedEndDate----'+formattedEndDate);
                  selectedSubscription.Future_Subscription__c = instSubscrIdMap.get(selectedSubscription.Net_Installation__c);
                  //selectedSubscription.Future_Subscription__c = '123a';
                  subscriptionListToBeUpdated.add(selectedSubscription);
                  System.debug('--before update subscriptionListToBeUpdated----'+subscriptionListToBeUpdated);
                }
              }
           }
        }
        System.debug('subscriptionListToBeUpdated.size()---'+subscriptionListToBeUpdated.size());
        if(subscriptionListToBeUpdated.size() > 0){
          update subscriptionListToBeUpdated;
        }
        
        //Below block should get executed only in case of new order - to update HasFuturePackage field of NetInstallation object
        if(installationIdList.size() > 0){
          existInstallationList = [select id,HasFuturePackage__c from Net_Installations__c where id in: (installationIdList) and HasFuturePackage__c =: false];
       //   existInstallationList = [select id,HasFuturePackage__c from Net_Installations__c where id in: (installationIdList)];
        }
       //existInstallationList.size() > 0 - Only in case of installation without subscription
        if(existInstallationList.size() > 0){
          for(Net_Installations__c installation : existInstallationList){
            System.debug('installation.HasFuturePackage__c--'+installation.HasFuturePackage__c);
            installation.HasFuturePackage__c = true; 
            installationListToBeUpdated.add(installation);
          }
        }
        if(installationListToBeUpdated.size() > 0){
          update installationListToBeUpdated;
        }
      }//End of IsInsert trigger
    
      if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('----Inside isUpdate trigger-----');
        String formattedStartDate, formattedRequestedEndDate;
        installationIdList = new List<Id>();
        List<Id> instIdList = new List<Id>();
        List<Subscription__c> subscriptionList = new List<Subscription__c>();
        List<Subscription__c> updatedSubscription = new List<Subscription__c>();
        List<Net_Installations__c> installationList = new List<Net_Installations__c>();
        List<Net_Installations__c> installationToBeUpdated = new List<Net_Installations__c>();
        Map<Id, Integer> instSubscCountMap = new Map<Id, Integer>();
        Map<Id, Integer> instActvSubscCountMap = new Map<Id, Integer>();
        
        for(Subscription__c subscription: [Select s.Net_Installation__r.HasFuturePackage__c,s.Start_Date__c, s.Future_Subscription__c, s.Requested_End_Date__c from Subscription__c s where Id IN : trigger.new]){
            if(subscription.Net_Installation__r.HasFuturePackage__c && subscription.Future_Subscription__c == null){
              System.debug('Scenario - new order subscription activated');
              //Installation without subscription
              if(subscription.Start_Date__c != null){
                formattedStartDate = convertDateFormat(subscription.Start_Date__c);
              }
              if(formattedStartDate != null && formattedStartDate != '01-01-2100' && formattedStartDate != '01-01-1900'){
                //dummy update without bier activities / for bier activities- update in StartDate Field 
                  //SUPPORT-4693 START
                  if(subscription.Requested_End_Date__c != null){
                      formattedRequestedEndDate = convertDateFormat(subscription.Requested_End_Date__c);
                  }
                  if(formattedRequestedEndDate != null && formattedRequestedEndDate != '01-01-2100' && formattedRequestedEndDate != '01-01-1900' && subscription.Start_Date__c <= mydate){
                      instIdList.add(subscription.Net_Installation__c);
                    System.debug('Inside else - if condition instIdList------'+instIdList);
                  }
                  //SUPPORT-4693 END
                  else if(subscription.Start_Date__c <= mydate){
                 //Special cable units without Bier activities  
                  installationIdList.add(subscription.Net_Installation__c);
                  System.debug('Inside else - else condition installationIdList------'+installationIdList);
               }
              }//end of formattedStartDate chk 
            }else{
                //subscription.Net_Installation__r.HasFuturePackage__c == false
              if(subscription.Future_Subscription__c != null && Trigger.oldMap.get(subscription.Id).Future_Subscription__c == null){
                //scenario- Future susbscription field updated for existing subscription - upgrade/downgrade
                system.debug('#Test #'+subscription.Net_Installation__c);
                installationIdList.add(subscription.Net_Installation__c);
              }else{
                String formattedReqEndDate,formattedOldReqEndDate;
                //afbestil
                if(subscription.Requested_End_Date__c != null){
                   formattedReqEndDate = convertDateFormat(subscription.Requested_End_Date__c);
                    System.debug('****formattedReqEndDate***'+formattedReqEndDate);
                }
                if(formattedReqEndDate != null && formattedReqEndDate != '01-01-2100' && formattedReqEndDate != '01-01-1900'){
                  // cancellation scenario
                  if(Trigger.oldMap.get(subscription.Id).Requested_End_Date__c != null){
                      formattedOldReqEndDate = convertDateFormat(Trigger.oldMap.get(subscription.Id).Requested_End_Date__c);
                        System.debug('****formattedOldReqEndDate***'+formattedOldReqEndDate);
                  }
                  //if(formattedOldReqEndDate != null && formattedReqEndDate != formattedOldReqEndDate && formattedReqEndDate >= formattedCurrentSysDate)
                  if(Trigger.oldMap.get(subscription.Id).Requested_End_Date__c != null && mydate != null && 
                       formattedReqEndDate != formattedOldReqEndDate && subscription.Requested_End_Date__c >= mydate){
                      
                    installationIdList.add(subscription.Net_Installation__c);
                    System.debug('Inside else - if condition installationIdList------'+installationIdList);
                  }else{ //Added for SUPPORT-4693
                    instIdList.add(subscription.Net_Installation__c);
                    System.debug('Inside else - if condition instIdList------'+instIdList);
                  }//SUPPORT-4693 END
                  
                }//end of if - formattedReqEndDate chk
              }//end of else block
            }//end of main else block
         }//end of for loop
       
        if(installationIdList != null && installationIdList.size() > 0){
          subscriptionList =  [select s.Id,s.Start_Date__c,s.Net_Installation__c From Subscription__c s where s.Net_Installation__c in: (installationIdList)];
          installationList = [select id,HasFuturePackage__c from Net_Installations__c where id in: (installationIdList)];
        }
        if(subscriptionList != null && subscriptionList.size() > 0){
         for(Subscription__c subscrip : subscriptionList){
          Integer subsCount = 1, activeSubsCount = 1;
          if(instSubscCountMap.get(subscrip.Net_Installation__c) != null){ 
            subsCount = subsCount + 1;
          }
          //Storing the actual count of subscription(active + future)
          instSubscCountMap.put(subscrip.Net_Installation__c, subsCount);
          //Added for handling error scenario part
          if(subscrip.Start_Date__c <= mydate){
            if(instActvSubscCountMap.get(subscrip.Net_Installation__c) != null){
              activeSubsCount = activeSubsCount + 1;
            }
            instActvSubscCountMap.put(subscrip.Net_Installation__c, activeSubsCount);
          } 
         }//end of for loop
        }//end of if condition
        system.debug('#installationList#'+installationList);
        system.debug('#instActvSubscCountMap#'+instActvSubscCountMap);
        if(installationList != null && installationList.size() > 0){
         for(Net_Installations__c installation : installationList){
            System.debug('UPDATE installation.HasFuturePackage__c--'+installation.HasFuturePackage__c);
            if(installation.HasFuturePackage__c){
                system.debug('%instSubscCountMap.get(installation.id)%'+instSubscCountMap.get(installation.id)+'#instActvSubscCountMap.get(installation.id)#'+instActvSubscCountMap.get(installation.id));
              //below block should get executed when new ordered/future - subscription activated - HasFuturePackage should be set as false
            if(instSubscCountMap.size() > 0){
              if((instSubscCountMap.get(installation.id) == 1) 
                 || (instActvSubscCountMap.size() > 0 && instActvSubscCountMap.get(installation.id) == 2 && instSubscCountMap.get(installation.id) == 2)){
                    
               installation.HasFuturePackage__c = false;
               installationToBeUpdated.add(installation); 
               system.debug('Inside else'+installationToBeUpdated);
              }
             }
            }else{
                System.debug('***iNSIDE ELSE-'+installation.HasFuturePackage__c);
              //Below block should get executed only in case of upgrade/downgrade and afbestil - R.E.D updated
              installation.HasFuturePackage__c = true;
              installationToBeUpdated.add(installation); 
              System.debug('$installationToBeUpdated$'+installationToBeUpdated);
            }
         }
        }
          //SUPPORT-4693 START
        List<Net_Installations__c> installationList1 = new List<Net_Installations__c>();
            installationList1 = [select id,HasFuturePackage__c from Net_Installations__c where id in: (instIdList)];
          if(!installationList1.isEmpty()){
              for(Net_Installations__c installation :installationList1)
              {
                  installation.HasFuturePackage__c = true;
                  installationToBeUpdated.add(installation);
              }
          }
          //SUPPORT-4693 END
        if(installationToBeUpdated != null && installationToBeUpdated.size() > 0){
          System.debug('***installationToBeUpdated UPDATE***-'+installationToBeUpdated);
          update installationToBeUpdated;   
        }
        
      }
 
 
     if(Trigger.isAfter && Trigger.isDelete){
        System.debug('####Inside delete trigger');
        String formattedReqStartDate,formattedStartDate;
        deletedSubscrRecords = Trigger.old;
        for(Subscription__c subList : deletedSubscrRecords){
            deletedNetInstId.add(subList.Net_Installation__c);
            System.debug('####Inside if installations ids'+deletedNetInstId);
        }
        subscrList = [Select s.Start_Date__c, s.Requested_Start_Date__c, s.Requested_End_Date__c, s.Net_Installation__c, s.Id, s.Future_Subscription__c, s.End_Date__c From Subscription__c s where s.Net_Installation__c IN : deletedNetInstId and s.Net_Installation__r.HasFuturePackage__c = true];
        if(subscrList != null && subscrList.size() > 0){
            for(Subscription__c updatedSubList : subscrList){
                if(updatedSubList.Requested_Start_Date__c != null){
                    formattedReqStartDate = convertDateFormat(updatedSubList.Requested_Start_Date__c);
                }
                if(updatedSubList.Start_Date__c != null){
                    formattedStartDate = convertDateFormat(updatedSubList.Start_Date__c);
                }
                System.debug('####Inside for installations ids'+formattedReqStartDate+'#########RED $$$'+formattedStartDate); 
                if(formattedReqStartDate != '01-01-2100' && formattedReqStartDate != '01-01-1900' && formattedStartDate != '01-01-2100' && formattedStartDate != '01-01-1900'){
                    if(updatedSubList.Requested_Start_Date__c > mydate && updatedSubList.Start_Date__c > mydate){
                        deletedNetInstId.remove(updatedSubList.Net_Installation__c);
                        System.debug('### Future Ids to remove####'+deletedNetInstId);
                    }
                }
            }
        }
        System.debug('####final installations ids to update '+deletedNetInstId);
        netInstList = [Select Id,HasFuturePackage__c from Net_Installations__c where Id IN :deletedNetInstId and HasFuturePackage__c = true];
        System.debug('$$$$$$$$$List of All Ids to update'+netInstList);
        if(netInstList != null && netInstList.size() > 0){
            for(Net_Installations__c instList : netInstList){
                instList.HasFuturePackage__c = false;
                netInstListToUpdate.add(instList);
                System.debug('$$$$$$$$$List of All Ids to Before update'+netInstListToUpdate);
            }
        }
        
        if(netInstListToUpdate != null && netInstListToUpdate.size() > 0){
            update netInstListToUpdate;
        }
     }
 
 
 
 /*    if(Trigger.isAfter && Trigger.isDelete){
     List<Id> deletedSubsInstId = new List<Id>();
     List<Subscription__c> deletedSubscrRecords = new List<Subscription__c>();
     
     deletedSubscrRecords = Trigger.old;
     System.debug('deletedSubscrRecords---'+deletedSubscrRecords);
     System.debug('deletedSubscrRecords- size--'+deletedSubscrRecords.size());
     String formattedEndDate;
     installationListToBeUpdated = new List<Net_Installations__c>();
     
     for(Subscription__c deletedSubscription: [Select s.Net_Installation__c,s.Net_Installation__r.HasFuturePackage__c,s.End_Date__c from Subscription__c s where Id IN : trigger.old]){
           //Afbestil and (Future bcums actv and existing one deleted)
           if(deletedSubscription.End_Date__c != null){
             System.debug('deletedSubscription.Net_Installation__r.HasFuturePackage__c--'+deletedSubscription.Net_Installation__r.HasFuturePackage__c);
             formattedEndDate = convertDateFormat(deletedSubscription.End_Date__c);
           }
           System.debug('formattedEndDate--'+formattedEndDate);
           //Should get executed in case of Old existing subscription - deleted and Afbestil - subscription deleted
           if(formattedEndDate != null){
             if(formattedEndDate != '01-01-2100' && formattedEndDate != '01-01-1900'){
              deletedSubsInstId.add(deletedSubscription.Net_Installation__c);
             }
           }
       }
      List<Net_Installations__c> installationList = [select id,HasFuturePackage__c from Net_Installations__c where id in: (deletedSubsInstId) and HasFuturePackage__c =: true];
      if(installationList != null && installationList.size() > 0){
        for(Net_Installations__c installation : installationList){
           System.debug('inside HasFuturePackage__c--'+formattedEndDate);
           installation.HasFuturePackage__c = false;
           installationListToBeUpdated.add(installation);
        }
      }
      if(installationListToBeUpdated != null && installationListToBeUpdated.size() > 0){
         System.debug('---installationListToBeUpdated.size() ---'+installationListToBeUpdated.size()); 
         update installationListToBeUpdated;
         System.debug('-after  update installationListToBeUpdated----'+installationListToBeUpdated);
      }
   } */
   }catch (Exception e) {
     System.debug('exceptions---'+e.getMessage());
      exceptionHandler.handleException(e,'Trigger fut error()',false,false,null,'Medium');
     Database.rollback(sp);
    
     throw e;
   }
   private String convertDateFormat(Date inputDate){
      String strDtFormat='dd-MM-yyyy';
      String formattedDate;
      DateTime dt = inputDate;
      if(dt != null){
         formattedDate = dt.format(strDtFormat);
      }
      return formattedDate;
   }
}