@RestResource(urlMapping='/CloudFileRest/*') 
global class AWS_RestService { 

private static String STATUS_CODE_ERROR = '500';
private static String STATUS_NOT_FOUND_ERROR = '404';
private static String STATUS_CODE_SUCCESS = '200';    
private static String STATUS_MESSAGE_SUCCESS = 'SUCCESS';  
    
private Static String ERROR_MSG_MISSING_CU_NO = 'Missing Cable Unit Number.'; 
private Static String ERROR_MSG_MISSING_SR_NO = 'Missing Service Request Number.';     
private Static String ERROR_MSG_MISSING_ACTION = 'Missing value for the parameter action.';  
private Static String ERROR_MSG_SAVING_CLOUD_FILE = 'Error saving cloud file.' ; 
private static String ERROR_MSG_MISSING_PARAM_VALUE = 'Missing param value.';
private static String ERROR_MSG_INVALID_HIERARCHY_CUSTOMER_NO='Invalid hierarchy customer no.';    

@HttpGet
// Entry point for all GET calls. This method is an index method.
global static ResponseWrapper doAction()
{
    String action = RestContext.request.params.get('action');
    
    if(action == null || action == '')
    {
        ResponseWrapper resp  =new ResponseWrapper();
        resp.StatusCode = STATUS_CODE_ERROR;
        resp.StatusMessage = ERROR_MSG_MISSING_ACTION; 
        return resp;
    }
    if('GET_CU_FILES'.equalsIgnoreCase(action))
    {
        return getCUFiles(RestContext.request);
    }
    else if('GET_CP_FILES'.equalsIgnoreCase(action))
    {
        return getConsProjFiles(RestContext.request); 
    }
    return null;    
}

// returns the list of cloud files for the associated cable unit number    
public static ResponseWrapper getCUFiles(RestRequest req)
{
    ResponseWrapper resp  =new ResponseWrapper();
    String cableUnitNo = AmazonUtil.fixCableUnitNo(req.params.get('cableUnitNo'));
    if(cableUnitNo!=null){       
        List<Cloud_File__c> listCF = [select id, name, Cloud_File_Bucket_Name__c, Cloud_file_cu_no__c, Cloud_file_case_no__c, 
        									 Cloud_File_Description__c, Cloud_File_Full_Name__c, Cloud_file_content_Type__c, Cloud_File_Doc_Remark__c, 
                                        	 Cloud_File_MID__c, Cloud_File_Offer_Id__c, Cloud_file_KISS_doc_type__c, lastModifiedDate, 
                                        	 Cloud_File_SupplierRequestId__c, Cloud_File_Con_Proj_No__c,  
                                        	 Cloud_file_Title__c, isActive__c, Cloud_file_Status__c,Cloud_File_Department__c, 
                                        	 Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Path_Prefix__c, Cloud_File_Uploaded_By__c,
                                        	 Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name     
                                      from Cloud_file__c 
                                      where Cloud_file_cu_no__c = :cableUnitNo 
                                            AND (Cloud_file_KISS_doc_type__c != Null OR Cloud_file_KISS_doc_type__c != '')
                                            AND isActive__c = true 
                                            AND Cloud_file_KISS_doc_type__c != 'Supplier'
                                            AND Cloud_file_KISS_doc_type__c != 'Bermuda'
                                     ];  
        resp.listCloudFiles = mapToWrapperList(listCF);                            
        resp.StatusCode = STATUS_CODE_SUCCESS;
        resp.StatusMessage = STATUS_MESSAGE_SUCCESS;
        
    } else {
        resp.StatusCode = STATUS_CODE_ERROR;
        resp.StatusMessage = ERROR_MSG_MISSING_CU_NO;
    }
    return resp;
}

public static ResponseWrapper getConsProjFiles(RestRequest req)
{
    ResponseWrapper resp  =new ResponseWrapper();    
    String serviceReqNo = req.params.get('supplierRequestId');
    
    // check if the service req number is not null
    if(serviceReqNo == '' || serviceReqNo == null)
    {
        resp.StatusCode = STATUS_CODE_ERROR;
        resp.StatusMessage = ERROR_MSG_MISSING_SR_NO;
        return resp;
    }
    try {
        List<Cloud_file__c> listCF = [select id, name, Cloud_File_Bucket_Name__c, Cloud_file_cu_no__c, Cloud_file_case_no__c, 
        									 Cloud_File_Description__c, Cloud_file_content_Type__c, Cloud_File_Doc_Remark__c, 
        									 Cloud_file_KISS_doc_type__c,  Cloud_File_MID__c, Cloud_File_Offer_Id__c,
                                          	 lastModifiedDate, createdDate,  Cloud_File_SupplierRequestId__c, Cloud_File_Con_Proj_No__c, 
                                          	 Cloud_File_Full_Name__c, Cloud_file_Title__c, isActive__c,Cloud_File_Department__c, Cloud_file_Status__c,
                                          	 Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Path_Prefix__c ,Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name
                                      from Cloud_file__c 
                                      where Cloud_File_SupplierRequestId__c = :serviceReqNo
                                      		AND isActive__c = true
                                     ];       
        resp.listCloudFiles = mapToWrapperList(listCF);
        
        resp.StatusCode = STATUS_CODE_SUCCESS;
        resp.StatusMessage = STATUS_MESSAGE_SUCCESS;
        
    } 
    catch (Exception ex)
    {
        resp.StatusCode = STATUS_CODE_ERROR;
        resp.StatusMessage = 'Error getting Construction Project Files.' + ' ' + ex.getMessage();
    }
    return resp;
}

// map the custom sfdc object to response wrapper class for cloud files.
public static CloudFileWrapper mapToWrapper(Cloud_file__c cf)
{
    if(cf != null)
    {
        CloudFileWrapper cfWrapper = new CloudFileWrapper();
        cfWrapper.bucketName = cf.Cloud_File_Bucket_Name__c;
        cfWrapper.cableUnitNo = cf.Cloud_file_cu_no__c;
        cfWrapper.caseNo = cf.Cloud_file_case_no__c;
        //cfWrapper.fileName = cf.Name;
        cfWrapper.fileName = cf.Cloud_file_Title__c;
       // cfWrapper.fileURL = cf.Cloud_File_URL__c;
        //cfWrapper.contentSize = cf.Cloud_file_content_size__c;
        cfWrapper.contentType = cf.Cloud_file_content_Type__c;
        cfWrapper.fileDescription = cf.Cloud_File_Description__c;  
        cfWrapper.kissDocType = cf.Cloud_file_KISS_doc_type__c;
        cfWrapper.mid = cf.Cloud_File_MID__c;
        cfWrapper.OfferId = cf.Cloud_File_Offer_Id__c;
        cfWrapper.constructProjNo = cf.Cloud_File_Con_Proj_No__c;
        cfWrapper.supplierRequestId = cf.Cloud_File_SupplierRequestId__c;
        cfWrapper.fullName = cf.Cloud_File_Full_Name__c;
        cfWrapper.centaDocType = cf.Cloud_File_Category__r.Name;
        cfWrapper.lastModifiedDate = cf.LastModifiedDate;
        cfWrapper.docRemark = cf.Cloud_File_Doc_Remark__c;
        cfWrapper.isActive = cf.IsActive__c; 
        cfWrapper.status = cf.Cloud_file_Status__c;  ////      
        cfWrapper.docType=cf.Cloud_File_Document_Type__r.Name;
        cfWrapper.hierarchicalCustomerNumber=cf.Cloud_file_Hierarchi_Cust_no__c;
       // cfWrapper.cloudFileDepartment=cf.Cloud_File_Department__c;
        cfWrapper.pathPrefix=cf.Cloud_File_Path_Prefix__c;
        return cfWrapper;
        
    }
    return null;
}

// map the custom sfdc object to response wrapper class for cloud files.
public static List<CloudFileWrapper> mapToWrapperList(List<Cloud_file__c> listcf)
{
    List<CloudFileWrapper> listWrapper = new List<CloudFileWrapper>();
    for(Cloud_File__c cf : listcf)
    {
        CloudFileWrapper cfWrapper = mapToWrapper(cf);
        listWrapper.add(cfWrapper);
    }
    return listWrapper;
}
@HttpPost
global static ResponseWrapper saveCloudFile(CloudFileWrapper cf)
{   
    // Create a new cloud file object with the values passed    
    ResponseWrapper resp  =new ResponseWrapper();   
    system.debug('##Request wrapper:'+cf);
    if(cf.kissDocType!=null || !String.isEmpty(cf.kissDocType))
    {
        if(cf.cableUnitNo == null && (cf.constructProjNo == null || cf.supplierRequestId == null) && cf.hierarchicalCustomerNumber==null)
        {
            resp.StatusCode = STATUS_CODE_ERROR;
            resp.StatusMessage = ERROR_MSG_MISSING_PARAM_VALUE;
            return resp;
        }
    }
    else{
         if(cf.cableUnitNo == null && cf.constructProjNo == null && cf.hierarchicalCustomerNumber==null)
        {
            resp.StatusCode = STATUS_CODE_ERROR;
            resp.StatusMessage = ERROR_MSG_MISSING_PARAM_VALUE;
            return resp;
        }
    }
    if(cf.hierarchicalCustomerNumber!=null){
        
        List<Account> lst_hierarchyCustomer=[SELECT Id,HierarchyCustomerNumber__c FROM Account where HierarchyCustomerNumber__c=:cf.hierarchicalCustomerNumber];
        if(lst_hierarchyCustomer.size()==0)
        {
             resp.StatusCode = STATUS_NOT_FOUND_ERROR;
             resp.StatusMessage = ERROR_MSG_INVALID_HIERARCHY_CUSTOMER_NO;
             return resp;
        }
    }
    try 
    {
       List<AmazonKISSStatus__c> liststs = new List<AmazonKISSStatus__c>();
       liststs = [SELECT Id, Name, Status__c FROM AmazonKISSStatus__c WHERE Name =: 'Låst'];   //////
       
       
       Cloud_File__c cloudFile = new Cloud_File__c();
       system.debug('*** category:'+ cf.centaDocType+' docType:'+cf.docType);  
        if(String.isNotBlank(cf.centaDocType)&& String.isNotBlank(cf.docType))
        {
        	List<DocumentCategoryType__c> lst_categoryDocType=[Select Id,Type__c,Parent__c,Name,isActive__c from DocumentCategoryType__c where value__c IN(:cf.centaDocType,:cf.docType)];
		        system.debug('***lst_categoryDocType size:'+lst_categoryDocType.size()+' lst_categoryDocType:'+lst_categoryDocType);
		        Id parentId;
		  	    for(DocumentCategoryType__c tempObj : lst_categoryDocType){	    	
			    	if((tempObj.Type__c).equalsIgnoreCase('Category')){
			    		cloudFile.Cloud_File_Category__c=tempObj.Id;
			    		parentId=tempObj.Id;
			    	}
			     }   
			      for(DocumentCategoryType__c tempObj : lst_categoryDocType){     
			    	if((tempObj.Type__c).equalsIgnoreCase('Document Type')&&(tempObj.Parent__c==parentId)&&(tempObj.Name).equalsIgnoreCase(cf.docType)){
			    		cloudFile.Cloud_File_Document_Type__c=tempObj.Id;
			    		 system.debug('***inside doc type');
			  		 }  
			      }     
        }
       cloudFile.Cloud_file_Title__c = cf.fileName;
       cloudFile.Cloud_File_Full_Name__c = cf.fullName;
       cloudFile.Cloud_File_Bucket_Name__c = cf.bucketName;   ////
       cloudFile.Cloud_file_cu_no__c = AmazonUtil.fixCableUnitNo(cf.cableUnitNo);
       cloudFile.Cloud_file_case_no__c = cf.caseNo;
      // cloudFile.Cloud_File_URL__c = cf.fileURL;
     //  cloudFile.Cloud_file_content_size__c = cf.contentSize;
       cloudFile.Cloud_file_content_Type__c = cf.contentType;
       cloudFile.Cloud_File_Description__c = cf.fileDescription; 
       cloudFile.Cloud_file_KISS_doc_type__c= cf.kissDocType;
       //cloudFile.Cloud_File_Centa_Doc_Type__c=cf.centaDocType;
       cloudFile.Cloud_File_MID__c = cf.mid;
       cloudFile.Cloud_File_Offer_Id__c  = cf.OfferId;
       cloudFile.Cloud_File_Con_Proj_No__c = cf.constructProjNo;
       cloudFile.Cloud_File_SupplierRequestId__c = cf.supplierRequestId;
       cloudFile.isActive__c = cf.isActive;
       cloudFile.Cloud_File_Doc_Remark__c = cf.docRemark;
       cloudFile.Cloud_file_Hierarchi_Cust_no__c=cf.hierarchicalCustomerNumber;
       //cloudFile.Centa_Document_Name__c=cf.docType;     
       //cloudFile.Cloud_File_Department__c=cf.cloudFileDepartment; 
      if(String.isNotBlank(cf.kissDocType))
      {
        cloudFile.Cloud_file_Status__c = liststs[0].Status__c;
        }
      else{
        cloudFile.Cloud_file_Status__c =cf.status;
      }
       ///////        
       cloudFile.Cloud_File_Path_Prefix__c=cf.pathPrefix;
       
       if(cf.hierarchicalCustomerNumber != null){
        cloudFile.Cloud_File_Customer_Numbers__c=cf.hierarchicalCustomerNumber;
       }else if(cf.cableUnitNo != Null){
        cloudFile.Cloud_File_Customer_Numbers__c = cf.cableUnitNo;
       }
       // TODO - get ownerId from the MID passed 
       List<User> listUsers = [select Id, Name, MID__c, IsActive from User where MID__c = :cf.mid and isActive = true limit 1];
       if (!listUsers.isEmpty()){
         cloudFile.OwnerId = listUsers[0].Id;     
         cloudFile.Cloud_File_Uploaded_By__c = listUsers[0].Name;
       }
       /*List<User> listUsers = [select Id from User where MID__c = :cf.mid and isActive = true limit 1];
       if (!listUsers.isEmpty()){
         cloudFile.OwnerId = listUsers[0].Id;  
       }*/
      
       // TODO - get account Id from the passed cable unit no
          if(cf.cableUnitNo!=null ){       	
       		
		           String cuno=AmazonUtil.fixCableUnitNo(cf.cableUnitNo);
		           List<Account> listAccount = [select Id from Account where Cable_Unit_No__c =:cuno limit 1];
		           if(!listAccount.isEmpty()) {
		             //String accountId =  listAccount[0].Id;
		             //Integer iLen = accountId.length();
		             //cloudFile.Cloud_file_related_to_id__c =  accountId.substring(0, iLen - 3);
		             cloudFile.Cloud_file_related_to_id__c =  listAccount[0].Id;
		            // cloudFile.Cloud_File_Path_Prefix__c=AmazonUtil.getCloudFilePrefix(listAccount[0]);
		          
       		}
       		
       }
       
       String[] bucket=(cf.pathPrefix).split('/');
       String bucketName=bucket[1];
       if(bucket[1].equals('construction-project'))
       {
       	 cloudFile.Cloud_file_related_to_id__c =  null;
       }
       
       if(cf.hierarchicalCustomerNumber!=null){
       //Get Account Id from the passed hierarchical customer number
           List<Account> listAccount1 = [select Id from Account where HierarchyCustomerNumber__c =:cf.hierarchicalCustomerNumber limit 1];
           if(!listAccount1.isEmpty()) {
             //String accountId1 =  listAccount1[0].Id;
             //Integer iLen1 = accountId1.length();
             //cloudFile.Cloud_file_related_to_id__c =  accountId1.substring(0, iLen1 - 3);
             cloudFile.Cloud_file_related_to_id__c =  listAccount1[0].Id;
             // cloudFile.Cloud_File_Path_Prefix__c=AmazonUtil.getCloudFilePrefix(listAccount1[0]);
           }
       }
       // check if the file is already present with the same bucket name and full name
       // TODO - check if upsert can be used along with a external id
       List<Cloud_File__c> listCurrentCF = [select Id from Cloud_File__c                                                
                                               where Cloud_File_Bucket_Name__c = :cloudFile.Cloud_File_Bucket_Name__c 
                                               and Cloud_File_Full_Name__c = :cloudFile.Cloud_File_Full_Name__c limit 1];
       if(!listCurrentCF.isEmpty())
       {
         cloudFile.Id = listCurrentCF[0].Id;
         
         update cloudFile;
         
       } else {                                        
           insert cloudFile; 
       } 
       system.debug('##saved cloudFile'+cloudFile);
          
       resp.StatusCode = STATUS_CODE_SUCCESS;
       resp.StatusMessage = STATUS_MESSAGE_SUCCESS; 
    }
    catch(Exception ex)
    {
        resp.StatusCode = STATUS_CODE_ERROR;
        resp.StatusMessage = ERROR_MSG_SAVING_CLOUD_FILE + ' ' + ex.getMessage();
    }
    return resp;
}
    
// Response Wrapper class
global class ResponseWrapper{           
   public String StatusCode;
   public String StatusMessage;
   public List<CloudFileWrapper> listCloudFiles; 
}    

// wrapper class for cloud file object
global class CloudFileWrapper {
   public String fileName;
   public String bucketName;
   public String cableUnitNo;
   public String caseNo;
   public String fullName;
  //public String fileURL;
  // public Decimal contentSize;
   public String contentType;
   public String fileDescription;
   public String kissDocType;
   public String mid;
   public String OfferId;  
   public String constructProjNo;   
   public String supplierRequestId;
   public String department;
   public String centaDocType;
   public DateTime lastModifiedDate;
   public String docRemark;    
   public Boolean isActive;
   public String status;
   public String docType;
   public String hierarchicalCustomerNumber;
   public String cloudFileDepartment;
   public String pathPrefix;
}

}