trigger trgAfterOrderInsert on Order__c (after insert,after update) {
   system.debug('$trgAfterOrderInsert$');
   
   List<Order__c> orderDetailsList = Trigger.new;
   System.debug('orderDetailsList---'+orderDetailsList.size());
   //public InstallationPackageMailUtility installationPackageMailUtility = new InstallationPackageMailUtility();
   //ServiceCenter_CustomSettings__c scProductionDomain = ServiceCenter_CustomSettings__c.getValues('Production_Email_Setting');
   //ServiceCenter_CustomSettings__c scTestDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
    /*public class OrderException extends Exception {
    } */
   
   String cableUnitName,cableUnitNumber;
   
   List<Contact> loggedInUserContact = new List<Contact>();
   List<Account> cableUnitAcctDetail  = new List<Account>();
   List<Address__c> detailsAddress = new List<Address__c>();
   List<Order__c> pckgOrderList = new List<Order__c>();
   List<Order__c> cancellationOrderList = new List<Order__c>();
   List<SC_Activity_Log__c> activityLogList = new List<SC_Activity_Log__c>();
   
   Map<Id,String>  productNameMap = new Map<Id,String>();
   Map<String, String> addressMap = new Map<String, String>();
   
   List<Id> addressIdList = new List<Id>();
   List<String> addressIdLst = new List<String>();    
        
   Boolean cancellationFlag = false;
   Boolean pckgChangeFlag =  false;
   
   if(orderDetailsList  != null && orderDetailsList .size() > 0){  
      if(orderDetailsList[0].cableUnitNumber__c != null){  
       cableUnitAcctDetail = [select acc.id from Account acc where acc.Cable_Unit__r.Cable_Unit_No__c =: orderDetailsList[0].cableUnitNumber__c];
      }
     if(orderDetailsList[0].loggedInUserName__c != null){
       loggedInUserContact = [Select Id From Contact  where id in (select contactid from User where Username =: orderDetailsList[0].loggedInUserName__c) limit 1];
     }
   }
   SC_Activity_Log__c activityLog =  new SC_Activity_Log__c();  
  
   if(Trigger.isAfter && Trigger.isInsert){
     if(orderDetailsList != null && orderDetailsList.size() > 0){
       for(Order__c insertedOrder : orderDetailsList){
          activityLog =  new SC_Activity_Log__c();
         if(insertedOrder.Product_Name__c != null){ 
           activityLog.New_package__c = insertedOrder.Product_Name__c;
          }
           System.debug('insertedOrder.Order_Type__c---'+insertedOrder.Order_Type__c);
          if(insertedOrder.Order_type__c != 'Cancellation'){
            pckgChangeFlag = true;
            pckgOrderList.add(insertedOrder);
            system.debug('$Cancellation Flag$'+cancellationFlag);
           }else{ 
             System.debug('inside else');
              cancellationFlag =true;
              cancellationOrderList.add(insertedOrder);
              system.debug('$Cancellation Flag$'+cancellationFlag);
           }  
          activityLog.Order_type__c = insertedOrder.Order_type__c;
          if(insertedOrder.Net_Installation__c != null){
            activityLog.Net_Installation__c = insertedOrder.Net_Installation__c;
          }
          if(loggedInUserContact != null && loggedInUserContact.size() > 0){
            activityLog.Requested_by__c = loggedInUserContact[0].id;
          }
          if(insertedOrder.packageBeforeChange__c != null){
          	activityLog.Current_package__c = insertedOrder.packageBeforeChange__c;
          }
          if(insertedOrder.Location__c != null){
           	activityLog.Location__c = insertedOrder.Location__c;
          }
          if(cableUnitAcctDetail != null && cableUnitAcctDetail.size() > 0){
            activityLog.Cable_Unit__c = cableUnitAcctDetail[0].id;
          }
          if(insertedOrder.id != null){
           	activityLog.Order__c = insertedOrder.id;
          }
          if(insertedOrder.Kasia_Order_Status__c != null){
            activityLog.Kasia_Order_Status__c = insertedOrder.Kasia_Order_Status__c;
          }
          if(insertedOrder.ChangePackageDate__c != null){
            activityLog.ChangePackageDate__c = insertedOrder.ChangePackageDate__c;
          }
          if(insertedOrder.OrderGroupId__c != null){
              activityLog.OrderGroupId__c = insertedOrder.OrderGroupId__c;
              System.debug('#activityLog.OrderGroupId__c#'+activityLog.OrderGroupId__c);
          }
          /*System.debug('insertedOrder.Net_Installation__c---'+insertedOrder.Net_Installation__c);
          if(insertedOrder.Net_Installation__c != null){
             activityLog.Net_Installation__c = insertedOrder.Net_Installation__c;
            system.debug('Address Field'+activityLog.Net_Installation__c);
          }*/
          
          System.debug('$insertedOrder.selectedmyBeboer__c$'+insertedOrder.selectedmyBeboer__c);
          /*if(insertedOrder.selectedmyBeboer__c != null){
            activityLog.selectedmyBeboer__c = insertedOrder.selectedmyBeboer__c;
          }*/
          if(insertedOrder.nybeboreAvailable__c != null){
            if(insertedOrder.nybeboreAvailable__c == 'Omk. gratis' || insertedOrder.nybeboreAvailable__c == 'Omk. 295'){
              activityLog.selectedmyBeboer__c = true;
            }else{
              activityLog.selectedmyBeboer__c = false;  
            }
          }
          if(activityLog != null){
            activityLogList.add(activityLog);
            system.debug('$activityLog With All Details $'+activityLogList);
         }
         
         cableUnitName = insertedOrder.cableUnitName__c;
         cableUnitNumber = insertedOrder.cableUnitNumber__c;
         
         if(insertedOrder.Product_Name__c != null){
           productNameMap.put(insertedOrder.id,insertedOrder.Product_Name__c);
         }
         if(insertedOrder.Address_Id__c != null){
           System.debug('---insertedOrder.Address_Id__c---'+insertedOrder.Address_Id__c);
           addressIdLst.add(insertedOrder.Address_Id__c);
         }
        }
       }
     
       if(addressIdLst != null && addressIdLst.size() > 0){
          detailsAddress = [Select a.Full_Address__c,a.External_Id__c From Address__c a where External_Id__c in:(addressIdLst)];
      }
      System.debug('detailsAddress--size----'+detailsAddress.size());
      if(detailsAddress != null && detailsAddress.size() > 0){
          for(Address__c addressDetail : detailsAddress){
             system.debug('$updatedCalloutActivityLog address map1111$'+detailsAddress);
             addressMap.put(addressDetail.External_Id__c,addressDetail.Full_Address__c);
             system.debug('$updatedCalloutActivityLog address map1111$'+addressDetail);
         }
      }
       try{
        if(activityLogList.size() > 0){
           System.debug('Size of Activity log'+ activityLogList.size());
           System.debug('Activity log'+ activityLogList);
         insert activityLogList;
        }
     }catch(Exception ex){
       System.debug('---OrderException--');
     //  throw new CustomeGenericException('exception generic');
     }
    
    }
    if(Trigger.isAfter && Trigger.isUpdate){
     updateActivityHelper activityLogHelper = new updateActivityHelper();
     System.debug('---UserInfo.getUserId() trgAfterOrderInsert---'+UserInfo.getUserId());
     System.debug('---UserInfo.getUsername() trgAfterOrderInsert---'+UserInfo.getUserName());
     System.debug('***Inside Trigger after update***'+orderDetailsList.size());
     if(orderDetailsList  != null && orderDetailsList .size() > 0){
        activityLogHelper.updatedCalloutActivityLog(orderDetailsList);
     } 
    }
}