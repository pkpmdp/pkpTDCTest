@RestResource(urlMapping='/searchcloudfiles/*')
global class AmazonWS_CloudFileDetails {
    
  @HttpPost
    global static List<CloudFileWrapper> doPostAction(){
        String action = RestContext.request.params.get('action');        
        if(action == null || action == ''){
            return new List<CloudFileWrapper>();
        }
        if('all'.equals(action)){
            return getCloudFilesDetails();
        }   
        return null;
    }
    
    global static List<CloudFileWrapper> getCloudFilesDetails() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            Blob body = req.requestBody;
          
            String bodyString = body.toString();    
            System.debug('blob body###'+bodyString);
            JsonWrapper jsonWrpObj =(JsonWrapper)JSON.deserialize(bodyString,JsonWrapper.class);        
           System.debug('jsonWrpObj###'+jsonWrpObj);
            if(jsonWrpObj == null){
                return new List<CloudFileWrapper>();
            }
            String sqlQuery='SELECT Id,Cloud_file_Title__c,Cloud_file_cu_no__c,Cloud_file_Hierarchi_Cust_no__c,Cloud_File_Document_Tag__c, ' +
                            'Cloud_File_Description__c,Cloud_File_Con_Proj_No__c,' + 
                            'Cloud_File_Bucket_Name__c,Cloud_File_Full_Name__c,CreatedDate,Cloud_File_MID__c, Cloud_File_Path_Prefix__c, '+
                            'Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name  FROM Cloud_File__c ' + 
                            'where (Id != null ';      
            
            String filterString=' and isActive__c=true';
            if(String.isNotBlank(jsonWrpObj.title))
                filterString+=' and Cloud_file_Title__c LIKE \''+jsonWrpObj.title+'%\'';
            
            if(String.isNotBlank(jsonWrpObj.cableunitnumber))
            {
                String cableUnitNo = AmazonUtil.fixCableUnitNo(jsonWrpObj.cableunitnumber); 
                filterString+=' and Cloud_file_cu_no__c =\''+cableUnitNo+'\''; 
            }           
        
            if(String.isNotBlank(jsonWrpObj.hierarchicalcustomernumber))
                filterString+=' and Cloud_file_Hierarchi_Cust_no__c =\''+jsonWrpObj.hierarchicalcustomernumber+'\'';
        
            if(String.isNotBlank(jsonWrpObj.constructionprojectnumber))
                filterString+=' and Cloud_File_Con_Proj_No__c =\''+jsonWrpObj.constructionprojectnumber+'\'';
                    
            if(String.isNotBlank(jsonWrpObj.documenttype))
                filterString+=' and Cloud_File_Document_Type__r.Name =\''+jsonWrpObj.documenttype+'\'';
        
            if(String.isNotBlank(jsonWrpObj.categories))
                filterString+=' and Cloud_File_Category__r.Name =\''+jsonWrpObj.categories+'\'';
                    
            if(String.isNotBlank(jsonWrpObj.bucketname))
                filterString+=' and Cloud_File_Bucket_Name__c =\''+jsonWrpObj.bucketname+'\'';
                    
	        
           if(String.isNotBlank(jsonWrpObj.startDate)) {
              String dateString1=jsonWrpObj.startDate; //(dd-mm-yyyy) this is the format in JSON request object
              String[] dateFormat1=dateString1.split('-',5);
              if(dateFormat1.size()==3){
	              DateTime startDate1 =DateTime.newInstance(Integer.valueOf(dateFormat1[2]),Integer.valueOf(dateFormat1[1]) ,Integer.valueOf(dateFormat1[0]),0,0,0);
	              //converting to yyyy-mm-dd format for salesforce
	              filterString += ' and CreatedDate >=:startDate1'; 
              }
                    
          }   
           if(String.isNotBlank(jsonWrpObj.endDate)) {
             String dateString2=jsonWrpObj.endDate; //(dd-mm-yyyy) this is the format in JSON request object
             String[] dateFormat2=dateString2.split('-',5);
             if(dateFormat2.size()==3){
	             DateTime endDate2 =DateTime.newInstance(Integer.valueOf(dateFormat2[2]),Integer.valueOf(dateFormat2[1]) ,Integer.valueOf(dateFormat2[0]),23,59,59);
	             //converting to yyyy-mm-dd format for salesforce 
	             filterString += ' and CreatedDate <=:endDate2'; 
             }
          }  
          if(String.isNotBlank(jsonWrpObj.docsfid))
            {
                
                filterString+=' and Id =\''+jsonWrpObj.docsfid+'\''; 
            }   
           
           String tagQuery= ' or (Id!=null '+filterString;
           
           
            filterString+=' and Cloud_File_Document_Tag__c=null)';// this is when no document Tag selected (1st query)
            
            if(String.isNotBlank(jsonWrpObj.doctag) ){
                filterString+=tagQuery+' and Cloud_File_Document_Tag__c =\''+jsonWrpObj.doctag+'\')';      //when docuement Tag selected (2nd query)      
            }  
            System.debug('filterString###'+filterString);
            
            String finalString= sqlQuery+filterString+'  ORDER BY CreatedDate DESC limit 10000'; //Query String with (1st Query)OR(2nd Query)
            
            system.debug('####finalString'+finalString);
            
            
            List<Cloud_File__c> cfList = Database.query(finalString);
            if(cfList != null && cfList.size() > 0){
                return mapToCloudFileList(cfList);
                
            }else{
                return new List<CloudFileWrapper>();
            }
    }
    
    public static List<CloudFileWrapper> mapToCloudFileList(List<Cloud_File__c> cloudFileList){
        List<CloudFileWrapper> listWrapper = new List<CloudFileWrapper>();
        for(Cloud_File__c cf : cloudFileList){
           CloudFileWrapper cfWrapper = new CloudFileWrapper();
           cfWrapper.title=cf.Cloud_file_Title__c;
           cfWrapper.cableunitnumber=cf.Cloud_file_cu_no__c;
           cfWrapper.hierarchicalcustomernumber=cf.Cloud_file_Hierarchi_Cust_no__c;
           cfWrapper.constructionprojectnumber=cf.Cloud_File_Con_Proj_No__c;
           cfWrapper.categories=cf.Cloud_File_Category__r.Name;
           cfWrapper.documenttype=cf.Cloud_File_Document_Type__r.Name;
          // cfWrapper.categories=cf.Cloud_File_Centa_Doc_Type__c;
          // cfWrapper.documenttype=cf.Centa_Document_Name__c;
           cfWrapper.description=cf.Cloud_File_Description__c;                      
           cfWrapper.bucketname=cf.Cloud_File_Bucket_Name__c;
           cfWrapper.fullname=cf.Cloud_File_Full_Name__c;
           cfWrapper.createddate=String.valueOf(cf.CreatedDate);
           cfWrapper.createdby=cf.Cloud_File_MID__c;
           cfWrapper.pathprefix=cf.Cloud_File_Path_Prefix__c;
           cfWrapper.docTag=cf.Cloud_File_Document_Tag__c;
           cfWrapper.docsfid=cf.Id;
           listWrapper.add(cfWrapper);
        }
        return listWrapper;
}
  global class CloudFileWrapper {    
     public String title;
     public String cableunitnumber;
     public String constructionprojectnumber;
     public String hierarchicalcustomernumber;
     public String categories;
     public String documenttype;
     public String bucketname;
     public String fullname;
     public String createddate;
     public String createdby;
     public String pathprefix;
     public String description;
     public String doctag;
     public String docsfid;
  }
  global class JsonWrapper{
     public String title;
     public String cableunitnumber;
     public String constructionprojectnumber;
     public String hierarchicalcustomernumber;
     public String categories;
     public String documenttype;
     public String startdate;
     public String enddate;
     public String bucketname;
     public String doctag;
     public String docsfid;
  }
}