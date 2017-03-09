//public with sharing class updateActivityHelper {
public class updateActivityHelper{
 
 public void updatedCalloutActivityLog(List<Order__c> listOrder)  {
 	
        	String cableUnitName,cableUnitNumber;
	        SC_Activity_Log__c actLog = new SC_Activity_Log__c();
	        List<Id> orderIdList =  new List<Id>();
	        //List<Order__c> newOrder = new List<Order__c>(); 
	        List<Account> cableUnitAccntDetail  = new List<Account>();
	        List<Contact> loggedInUserContact = new List<Contact>();
	        List<SC_Activity_Log__c> activityLog = new List<SC_Activity_Log__c>();
	        
	        Map<Id,String>  productNameMap = new Map<Id,String>();
	        Map<Id,String>  kasiaOrderNoMap = new Map<Id,String>();
	        Map<String,Id>  cableUnitAccntMap = new Map<String,Id>();
	        Map<Id,String>  kasiaOrderStatusMap = new Map<Id,String>();
	        //Added- 222
	        
	        if(listOrder != null && listOrder.size() > 0){
		        for(Order__c orderDetails : listOrder){
		       	  orderIdList.add(orderDetails.id);	
		          kasiaOrderNoMap.put(orderDetails.id,orderDetails.Kasia_Order_Number__c);
		          kasiaOrderStatusMap.put(orderDetails.id,orderDetails.Kasia_Order_Status__c);
		          cableUnitName = orderDetails.cableUnitName__c;
		          cableUnitNumber = orderDetails.cableUnitNumber__c;
		          productNameMap.put(orderDetails.id,orderDetails.Product_Name__c);
		        }
	        }
	     
	       List<SC_Activity_Log__c> activityLogToBeUpdated = new List<SC_Activity_Log__c>();
		   if(orderIdList != null && orderIdList.size() > 0){ 
		          activityLogToBeUpdated = [select s.Order__r.Id,s.Kasia_Order_Number__c,s.Cable_Unit__c,s.Requested_by__c,s.Kasia_Order_Status__c,s.Order_type__c,Current_package__c,New_package__c  from SC_Activity_Log__c s where s.Order__c in: (orderIdList)]; 
		   }
	       List<SC_Activity_Log__c> updatedActivityList = new List<SC_Activity_Log__c>();
	       Set<ID> scActivityIds = new Set<ID>();
	       for (Integer i = 0; i < orderIdList.size();i++){
	       		if(activityLogToBeUpdated != null && activityLogToBeUpdated.size() > 0){
	         		for(SC_Activity_Log__c activity : activityLogToBeUpdated){
	         			if(activity.Order__r.Id == orderIdList.get(i)){
	         				if(kasiaOrderNoMap != null && kasiaOrderNoMap.size() > 0){
	         		  			activity.Kasia_Order_Number__c = kasiaOrderNoMap.get(activity.Order__r.Id);
	         				}
	         				if(kasiaOrderStatusMap.size() > 0){
	         		   			activity.Kasia_Order_Status__c = kasiaOrderStatusMap.get(activity.Order__r.Id);
	         	    		}
	         			}
		         		 if(!scActivityIds.contains(activity.Id)){	
		         	     	updatedActivityList.add(activity);
		         	     	scActivityIds.add(activity.Id);
		         		 }	
	         		}
	       		}
	       }
	       try{
	            if(updatedActivityList.size() > 0){
	              update updatedActivityList;
	            }
	       }catch(Exception e){
	             System.debug('updatedCalloutActivityLog--updatedActivityList--'+e.getMessage());
	       }

	       
 }

}