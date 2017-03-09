/***********************************************************************************
************************************************************************************

* @class: CarrieLogBatch
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 05/07/2012
* @description: Class is used to perform the batch operation (delete) on carrieLog.

************************************************************************************
***********************************************************************************/
global class CarrieLogBatch implements Database.Batchable<sObject> {
   
   public String query='select Id from CarrieLog__c ' ;
   
   /**
    * @description: This method is used to initialize and execute the Query.
    * @param: Database.BatchableContext.
    * @return: Database.QueryLocator.
    */
   global Database.QueryLocator start(Database.BatchableContext BC){
    try{
        datetime myDate = Datetime.now();
        datetime newDate = mydate.addDays(-2);
        query = query +'where CreatedDate <'+newDate.format('yyyy-MM-dd')+'T00:00:00.000Z LIMIT 200'; 
        return Database.getQueryLocator(query);
    }
    catch(Exception e){
        CarrieLog.LogException(e);
        return null; 
    }
   }

   /**
    * @description: This method is used to perform the batch delete operation.
    * @param: Database.BatchableContext, scope.
    */
   global void execute(Database.BatchableContext BC, List<sObject> scope){
    if(scope.size()>0){
      delete scope;
      DataBase.emptyRecycleBin(scope);
    }
   }

   /**
    * @description: This method is used to perform the final notification like sending email, logging etc.
    * @param: Database.BatchableContext.
    */
   global void finish(Database.BatchableContext BC){
    system.debug('Job ID is ----------'+BC.getJobId());
   }
      
   /**
    * @description: This method is used to Test CarrieLogBatch class.
    */
   public static testMethod void testExecuteBatch(){
    Test.startTest();
    CarrieLogBatch logbatch= new CarrieLogBatch(); 
    Database.executeBatch(logbatch);
    Test.stopTest();    
   }
}