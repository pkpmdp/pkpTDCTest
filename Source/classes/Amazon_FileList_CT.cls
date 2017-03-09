/*
 *Description:- Document records will be listed on Account detail page.
 *              User can,
 *              1. Upload a file - Uploads a file in Amzon S3 as well as creates a new record for Document in Salesforce
 *              2. View file
 *              3. Move Single as well as multiple files(User can move maximum 5 files at a time) to another Cable Unit
 *              4. Delete file - Deletes file from Amaozn S3 as well as deletes a records from Salesforce
 *              5. Edit file - Edits record values od Document record.
*/
public class Amazon_FileList_CT {

    //public String checkFile { get; set; }
    Public String id {get;set;}   
    public List<clfWrapper> cldfilesList {get; set;}
    public Boolean isAdmin {get; set;}
    Public List<Cloud_File__c> selectedFiles2 = new List<Cloud_File__c>();
    Public List<Cloud_File__c> selectedFiles3 {get; set;}
    public String cuNo{get; set;}
    AWSKey__c awsConfig;
    public Boolean movable {get; set;}
    public Boolean rendrd {get;set;}
    public Boolean rendrd1 {get;set;}
    public Boolean error = false;
    public Boolean deletable {get;set;}
    public Account acc;
    public List<Cloud_File__c> lst_cloudFile=new List<Cloud_File__c>();
                    
    /* Constructor*/    
    public Amazon_FileList_CT(){       
        rendrd = true;
        rendrd1 = false;
        deletable = true;
        //cuNo = null; 
        
        id=ApexPages.CurrentPage().getParameters().get('Id');
        system.debug('Id= '+id);      
        
        //Account acc = [SELECT Id FROm Account WHERE Id =: id LIMIT 1];
        acc = [SELECT Id, Name, Type FROM Account WHERE ID =: Id LIMIT 1];
        system.debug('@@@Account Id= '+acc.Id);
        
        cldfilesList = new List<clfWrapper>();       
        
        
        
        for(Cloud_File__c c : [SELECT Id, Cloud_file_Title__c, Cloud_File_Description__c, CreatedDate, Cloud_File_Uploaded_By__c,Cloud_File_Last_Modified_Date__c, 
                                      Cloud_File_Last_Modified_By__r.Name,LastModifiedDate, LastModifiedBy.Name, 
                                      Cloud_File_Department__c, Cloud_file_case_no__c, Cloud_file_related_to_id__c, cloud_file_full_name__c, 
                                      isActive__c, Cloud_File_Path_Prefix__c, Cloud_File_Doc_Remark__c, Cloud_file_KISS_doc_type__c, 
                                      Cloud_File_Bucket_Name__c,Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name
                               FROM Cloud_File__c 
                               WHERE Cloud_file_related_to_id__c =: acc.Id AND cloud_file_full_name__c != null AND isActive__c = true
                               ORDER BY  CreatedDate DESC                                        
                               LIMIT 1000 ]){
                                lst_cloudFile.add(c);
                                
            system.debug('###lst_cloudFile1= '+lst_cloudFile.size());
        }        
        
        
     
       cldfilesList=mapFields(lst_cloudFile);
        
        if (Schema.sObjectType.Cloud_File__c.isDeletable()) {
            isAdmin = True;
        }
        
                
        Map<string,AmazonAdminProfiles__c> mapAdminProfs =AmazonAdminProfiles__c.getAll();
        Set<String> setadmProfiles = mapAdminProfs.keySet();
        User loginUsr = [SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        
        //acc = [SELECT Id, Name, Type FROM Account WHERE ID =: Id];
        
        if(setadmProfiles.contains(loginUsr.Profile.Name) && acc.Type != 'Hierarki'){
            movable = True;
        } 
        
        
        /*if(acc.Type == 'Hierarki'){
            movable = false;
        }*/
    }  
       
    
        
    /* Method for returning the files */
    public List<clfWrapper> getDocList(){    
        system.debug('cldfilesList= '+cldfilesList.size());
        return cldfilesList;    
    }
    /* End of Method */
    
    /* Method to fetch the selected records*/
    public PageReference moveSelected(){
        selectedFiles3 = new List<Cloud_File__c>();
        List<Cloud_File__c> selectedFiles = new List<Cloud_File__c>();
        system.debug('cldfilesList= '+cldfilesList);
                
        if(cldfilesList!= null){
            system.debug('getDocList()= '+getDocList());
            for(clfWrapper c : getDocList()){
                if(c.selected == true){
                    selectedFiles.add(c.clf);
                    system.debug('selectedFiles= '+selectedFiles);
                }
            }
            selectedFiles2 = selectedFiles;
            selectedFiles3 = selectedFiles2;
        }
        
        system.debug('***selectedFiles2= '+selectedFiles2);
        /* show error message if no file is selected */
        if (selectedFiles.size()==0){            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Vælg mindst én fil.'));
            return null;
        }else if(selectedFiles.size() > 5){         
            /* show error message if more than 5 files are selected */
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan flytte maksimalt 5 filer ad gangen.'));
            return null;
        }
        else{          
            /*PageReference p = Page.Amazon_MoveFile1;
            p.setRedirect(false);
            p.getParameters().put('id',null); 
            system.debug('PageReference Id= '+p.getParameters().get('id'));            
            return p;*/
            rendrd = false;
            rendrd1 = true;
            
            return null;
        }
    }
    
   
    //MoveFile function - will move a file from one CU to another CU   
    public PageReference MoveFile(){
        //Account acc = new Account();
        Boolean moved;
        AWSKey__c credentials1 = AmazonUtil.getAWSConfig();
        S3.AmazonS3 as3;   
        if(!Test.isRunningTest()){ 
        //system.debug('Key= '+awsConfig.Key__c+'&&&secret= '+awsConfig.Secret__c);                                           
        as3 = new S3.AmazonS3(credentials1.Key__c,credentials1.Secret__c);
        }
        DateTime now = DateTime.now();
        List<Cloud_File__c> listclf = new List<Cloud_File__c>();
        
        /*
        Account acc = new Account();
        Boolean moved;
        AWSKey__c credentials1 = getAWSConfig();
        S3.AmazonS3 as3; 
        as3 = new S3.AmazonS3(credentials1.Key__c,credentials1.Secret__c);
        DateTime now = DateTime.now();
        List<Cloud_File__c> listclf = new List<Cloud_File__c>();*/
                    
        if((String.isNotBlank(cuNo) && String.isNotEmpty(cuNo))){
               
            //system.debug('Key= '+awsConfig.Key__c+'&&&secret= '+awsConfig.Secret__c);                                           
            
                        
            system.debug('cuNo='+cuNo);
            if(cuNo.length() <> 10){
                if(cuNo.length() < 10){
                    Integer diff = 10 - cuNo.length();
                    String zeros = '';
                    for(Integer i = 0; i<= diff - 1; i++){
                        zeros = zeros + '0';
                    }
                    cuNo = zeros + cuNo;
                }
            }else if(cuNo.length() > 10){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Kundenr kan ikke være mere end 10 cifre.'));
            }
            system.debug('cuNo2='+cuNo);
            //acc = [SELECT Id, Name, Cable_Unit_No__c FROM Account WHERE Cable_Unit_No__c =:cuNo LIMIT 1];
            List<Account> accLst = [SELECT Id, Name, Cable_Unit_No__c FROM Account WHERE Cable_Unit_No__c =:cuNo LIMIT 1];
            //accLst.add(acc);
            
            if(!accLst.isEmpty()){
                system.debug('^^^Account exists^^^');
                //String accId = accLst[0].Id;
                //String relatedToId = accLst[0].Id;
                
                system.debug('%%%selectedFiles2= '+selectedFiles2);
                for(Cloud_File__c cf : selectedFiles2){
                    String origBucket = cf.Cloud_File_Bucket_Name__c;
                    String origFileName = cf.Cloud_File_Path_Prefix__c + '/' + cf.Cloud_File_Full_Name__c;
                    String newBucket = cf.Cloud_File_Bucket_Name__c;
                    String newFileName = cf.Cloud_File_Path_Prefix__c + '/' + cuNo + '/' + cf.Cloud_file_Title__c;
                    
                    moved = AmazonUtil.copyFile(origBucket, origFileName, newBucket, newFileName);
                    system.debug('moved= '+moved);
                    
                    if(moved == True){
                        if(!Test.isRunningTest()){
                        S3.Status deleteObjectReslt= as3.DeleteObject(origBucket,origFileName,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
                        system.debug('deleteObjectReslt= '+deleteObjectReslt);
                        }
                        //cf.Cloud_File_Full_Name__c = newFileName;
                        cf.Cloud_File_Full_Name__c = cuNo + '/' + cf.Cloud_file_Title__c;
                        cf.Cloud_file_related_to_id__c = accLst[0].Id;
                        cf.Cloud_File_Customer_Numbers__c = cuNo;
                        cf.Cloud_file_cu_no__c = cuNo;
                        
                        listclf.add(cf);
                    }
                } 
                
                if(moved == True){
                    if(!listclf.isEmpty()){
                        system.debug('$$$In Update clfList$$$');
                        update listclf;
                    }
                    
                    system.debug('$$$$$$$$');
                    //rendrd1 = false;
                    //rendrd = true;
                    PageReference p = new PageReference('/apex/Amazon_ConfirmFileMove?id='+Id);
                    system.debug('PageReference= '+p);
                    return p;
                    system.debug('#########');
                    
                    //PageReference p = new PageReference('/'+relatedToId);
                    //return p;
                }
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Indtastede Kundenr findes ikke.'));
            }
        }else{
            //cuNo = null;
            //error = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Indtast Kundenr.'));
        } 
        return null;  
    }
    
   //Function to delete a single file from Amazon S3 as well as deletes Document record from Salesforce
    public PageReference DeletFile(){
      system.debug('!!!In DeletFile function!!!');
        Id id1 = System.currentPageReference().getParameters().get('fileId');
        system.debug('Delete Id= '+id1);
                        
        AmazonUtil.deleteFile(Id1);
                
        PageReference p = new PageReference('/apex/Amazon_ConfirmDelete?id='+Id);
        system.debug('PageReference= '+p);
        return p;
    }
    
    public PageReference Cancel(){        
        PageReference p = new PageReference('/apex/Amazon_AccountFileList?id='+id);
        return p;
        /*rendrd = true;
        rendrd1 = false;
        return null;    */    
    }
    
    public List<clfWrapper> mapFields(List<Cloud_File__c> lst_cloudFile){
          List<clfWrapper> lst_clfWrpObj=new List<clfWrapper>();
          Set<String> fileTypes=new Set<String>{'csv','doc','docx','xls','xlsx','img','msg','pdf','png','ppt','pptx','txt','text','tif','zip','rar','htm','html','snp','default','js','jpg','css'};
          system.debug('###lst_cloudFile= '+lst_cloudFile.size());
          for(Cloud_File__c c: lst_cloudFile)
          {
             String[] bucketNames=(c.Cloud_File_Path_Prefix__c).split('/');
                if(!bucketNames[1].equals('construction-project'))
                {
                    clfWrapper clfWrpObj=new clfWrapper();
                    clfWrpObj.clf = c;
                    clfWrpObj.Category=c.Cloud_File_Category__r.Name;
                    clfWrpObj.DocType=c.Cloud_File_Document_Type__r.Name; 
                    clfWrpObj.selected = false;
                    clfWrpObj.Id1 = c.Id;
                    clfWrpObj.Title = c.Cloud_file_Title__c;
                    clfWrpObj.Description = c.Cloud_File_Description__c;
                    //Description = c.Decription__c;
                    //clfWrpObj.LastModifiedDate = c.LastModifiedDate;
                    if(!Test.isRunningTest()){
                    if(c.Cloud_File_Last_Modified_Date__c!=null)
                    clfWrpObj.LastModifiedDate = c.Cloud_File_Last_Modified_Date__c.format('dd/MM/yyyy');
                    }
                    //clfWrpObj.ContentType = c.Cloud_file_content_Type__c;
                    //clfWrpObj.Docremark = c.Cloud_File_Doc_Remark__c;
                    clfWrpObj.CaseNum = c.Cloud_file_case_no__c;
                    clfWrpObj.KISSType = c.Cloud_file_KISS_doc_type__c;
                    //clfWrpObj.AllDocType = c.Cloud_File_All_Document_Types__c;
                    //clfWrpObj.DocType = c.Centa_Document_Name__c;
                   // clfWrpObj.Category = c.Cloud_File_Centa_Doc_Type__c;
                    //clfWrpObj.AllCategory = c.Cloud_File_All_Categories__c;  
                    clfWrpObj.departmentName=c.Cloud_File_Department__c;
                    //clfWrpObj.CreatedDate=c.CreatedDate;  
                    if(!Test.isRunningTest()){
                    clfWrpObj.CreatedDate = c.CreatedDate.format('dd/MM/yyyy');
                    }
                    clfWrpObj.createdBy=c.Cloud_File_Uploaded_By__c ; 
                    //clfWrpObj.lastModifiedBy=c.lastModifiedBy.Name;  
                    clfWrpObj.lastModifiedBy=c.Cloud_File_Last_Modified_By__r.Name  ;   
                    ///Descri = c.Decription__c;
                    clfWrpObj.isDeleted = True;
                    clfWrpObj.isDocTypeNull = False;
                    
                    integer lastIndx=(c.Cloud_File_Full_Name__c).lastIndexOf('.');
                    String fullName=c.Cloud_File_Full_Name__c;
                    String fileType=(fullName.subString(lastIndx+1)).toLowerCase();
                    String defaultFileType='default';
                    if(fileTypes.contains(fileType))
                    {
                        clfWrpObj.fileType=fileType;
                    }
                    else
                    {
                        clfWrpObj.fileType=defaultFileType;
                    }
            
                    if(clfWrpObj.DocType == Null && clfWrpObj.KISSType == Null){
                        clfWrpObj.isDocTypeNull = True;
                    }
                    
                    Map<string,AmazonNoDeleteCategories__c> mapCat = AmazonNoDeleteCategories__c.getAll();
                    system.debug('mapCat= '+mapCat);
                    
                    Map<string,AmazonNoDeleteCategories__c> mapCat1 = new Map<string,AmazonNoDeleteCategories__c>();
                    Map<string,AmazonNoDeleteCategories__c> mapDocType = new Map<string,AmazonNoDeleteCategories__c>();
                    
                    for(AmazonNoDeleteCategories__c a : mapCat.values()){
                        mapCat1.put(a.Category__c, a);
                        mapDocType.put(a.Document_Type__c,a);
                        system.debug('mapCat1= '+mapCat1);
                        system.debug('mapDocType= '+mapDocType);
                    }
                     
                    Set<String> cat = new Set<String>();
                    cat.addAll(mapCat1.keyset());
                    system.debug('###cat= '+cat); 
                    
                    Set<String> docTypes = new Set<String>();
                    docTypes.addAll(mapDocType.keyset());
                    system.debug('docTypes= '+docTypes);
                    
                    system.debug('@@@isDeleted= '+clfWrpObj.isDeleted+'&&&Id1= '+clfWrpObj.Id1);
                    system.debug('###DocCategory:'+c.Cloud_File_Category__r.Name+' and ###DocName:'+c.Cloud_File_Document_Type__r.Name); 
                    if(cat.contains(c.Cloud_File_Category__r.Name) && docTypes.contains(c.Cloud_File_Document_Type__r.Name)){
                        clfWrpObj.isDeleted = false;
                        system.debug('###isDeleted= '+clfWrpObj.isDeleted+'&&&Id1= '+clfWrpObj.Id1);
                    }                    
                lst_clfWrpObj.add(clfWrpObj);
                }
          }
          return lst_clfWrpObj;
        
    } 
    
    /* Wrapper class to contain Cloud File record and a boolean flag */
    public class clfWrapper{
        public Cloud_File__c clf {get; set;}
        public Boolean selected {get; set;}
        public Id id1 {get;set;}
        public String Title {get;set;}
        public String Description {get;set;}
        //public DateTime LastModifiedDate {get;set;}
        public String LastModifiedDate {get;set;}
        //public String ContentType {get;set;}
        //public String Docremark {get;set;}
        public String CaseNum {get;set;}
        public String KISSType {get;set;}
        //public String AllDocType {get; set;}
        public String DocType {get; set;}
        public String Category {get; set;}
        //public String AllCategory {get; set;}
        public Boolean isDeleted {get; set;}
        public String createdBy {get;set;}
        public String lastModifiedBy {get;set;}
        public String departmentName {get;set;}
        //public DateTime CreatedDate {get;set;}
        public string CreatedDate {get;set;}
        public Boolean isDocTypeNull {get;set;}
        //public String Descri {get;set;}
        public String fileType{get;set;}
        public clfWrapper(){
            
        } 
    /* end of Wrapper class */
    }
}