/***********************************************************************************
************************************************************************************

* @class: CarrieLog
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 05/07/2012
* @description: Class is used to maintain history of Exception logs.

************************************************************************************
***********************************************************************************/
public with sharing class CarrieLog { 
    
    
    /**
    * @description: This method is used to insert CarrieLog exceptions.
    */
    public static void LogException(Exception e){
		CarrieLog__c newLog = new CarrieLog__c();
		String message='';	
	    message ='**ERROR**'+e.getMessage()+'\n';
		if(e.getTypeName().equalsIgnoreCase('DMLException') || e.getTypeName().equalsIgnoreCase('EmailException')){
		  message = message +'**FIELDS THAT CAUSED**'+e.getDmlFieldNames(0)+'\n';
		}
		message = message+'**TRACED**'+e.getStackTraceString();
		newLog.debug__c = message;
		insert newLog;		
	}
	
	
	/**
    * @description: This method is used to Test CarrieLog class.
    */
	static testMethod void testCarriLog(){
	 try{
	       String s = null;
	       s.lastIndexOf('test');
		}
		catch(Exception e){
	       CarrieLog.LogException(e);
		}	
		
	}

}