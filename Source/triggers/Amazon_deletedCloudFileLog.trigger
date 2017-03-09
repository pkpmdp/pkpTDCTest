/* This rigger will create Document Log record. Whenever a Document is deleted, Document Log will hold data of deleted Document such as 
 * Title, Created Date of deleted Document, Deleted Date, Deleted By(User Name who deleted Document), 
 * Deleted By MID(User MID who deleted Document)
 */
 
trigger Amazon_deletedCloudFileLog on Cloud_File__c (before delete) {
    List<Id> lst_cloudFile=new List<Id>();
    Map<Cloud_File__c, Id> map_CloudFile = new Map<Cloud_File__c,Id>();
    List<Cloud_File_Document_Log__c> lst_cloudFileLog=new List<Cloud_File_Document_Log__c>();
    
    for(Cloud_File__c a: Trigger.old){
        system.debug('deleted File id:'+a.Id);
        map_CloudFile.put(a,a.Id);
    }
    
    for (Cloud_File__c cfcObjTemp:[Select id,createdDate,Cloud_file_Title__c,Cloud_File_MID__c, Cloud_file_cu_no__c, Cloud_File_Con_Proj_No__c, Cloud_file_Hierarchi_Cust_no__c, Cloud_File_SupplierRequestId__c from Cloud_File__c where IsActive__c = true and Id in :map_CloudFile.values()]){
        system.debug('deleted File id2:'+cfcObjTemp.Id);
        Cloud_File_Document_Log__c cfdlObj =new Cloud_File_Document_Log__c();
        DateTime t=cfcObjTemp.createdDate;
        Date d = Date.newInstance(t.year(),t.month(),t.day());  
        cfdlObj.Document_Log_CreatedDate__c=d;
        cfdlObj.Document_Log_Deleted_By__c=UserInfo.getName();
        cfdlObj.Document_Log_Deleted_Date__c=Date.today();
        cfdlObj.Document_Log_Title__c=cfcObjTemp.Cloud_file_Title__c;
        cfdlObj.Document_Log_Cable_Unit_Number__c = cfcObjTemp.Cloud_file_cu_no__c;
        cfdlObj.Document_Log_Construction_Project_Number__c = cfcObjTemp.Cloud_File_Con_Proj_No__c;
        cfdlObj.Doc_Log_Hierarchical_Customer_Number__c = cfcObjTemp.Cloud_file_Hierarchi_Cust_no__c;
        cfdlObj.Document_Log_Supplier_Request_Id__c = cfcObjTemp.Cloud_File_SupplierRequestId__c;
           
        system.debug('log object:'+cfdlObj);
        lst_cloudFileLog.add(cfdlObj);
                
    }
    
    List<User> lst_user=[Select id,Mid__c,Name from User where ID=:UserInfo.getUserId()];
        
    for(Cloud_File_Document_Log__c cfcObjTemp2:lst_cloudFileLog)
    {
        cfcObjTemp2.Document_Log_Deleted_by_MID__c=lst_user[0].Mid__c;
    }
    
    if(!lst_cloudFileLog.isEmpty()){
        insert lst_cloudFileLog;
    }
}