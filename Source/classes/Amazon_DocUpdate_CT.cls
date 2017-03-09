/*
 * JIRA Issue:- SF-1568 - Update account documents from SFDC
 * VF - Amazon_UpdateFile
*/
public class Amazon_DocUpdate_CT {
    
    public static String serverURL {get;set;}
    public AWSKey__c credentials;
    AWSKey__c awsConfig;
    public string key {get; set;}       
    public Cloud_File__c clfrecord;
    public Boolean rendrd {get;set;}
    
    public Amazon_DocUpdate_CT(ApexPages.StandardController stdController) {
        credentials = AmazonUtil.getAWSConfig();
        key = credentials.Key__c;        
        system.debug('key= '+key); 
        
        rendrd = true;       
    } 
    
    public Amazon_DocUpdate_CT(){
        
    } 
    
    public static String getSignature(String policyStr, String apiSecret) {       
       return AmazonUtil.make_sig(apiSecret,EncodingUtil.base64Encode(Blob.valueOf(policyStr)));  
    }    
    
    // this method is called from JS in Amazon_DocUploadToS3 page to upload the content type and 
    // and also generate the file title
    /* Change History
        March 16th 2014 - Changed for SF-2322. This JIRA was created due to frequent support issues related to opening of documents in Salesforce like SUPPORT-2483
    */
    @RemoteAction
    public static RemoteActionResponse processFile(String cloudFileId, String fileExt, String contentType, String server_URL) {
        // get the aws config
        AWSKey__c awsConfig = AmazonUtil.getAWSConfig();
        system.debug('>>>in updateContentType');
        List<Cloud_File__c> listCF = [SELECT Id, Cloud_file_content_Type__c, Cloud_File_Document_Type__r.Name,Cloud_File_Bucket_Name__c,
                                             Cloud_File_Access__c, Cloud_file_cu_no__c, Cloud_file_KISS_doc_type__c, Cloud_file_Title__c,
                                             Cloud_File_Full_Name__c, Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, 
                                             Cloud_File_Path_Prefix__c  
                                      FROM Cloud_File__c
                                      WHERE Id = :cloudFileId];        
        if(!listCF.isEmpty()) {            
            Cloud_File__c cf =  listCF[0];
            serverURL = server_URL;
            
            // return the file title back along with the recalculated policy and signature
            
            system.debug('contentType>>>> '+contentType);
            cf.Cloud_file_content_Type__c = contentType;
            cf.Cloud_file_Title__c =AmazonUtil.getCloudFileTitle(cf, fileExt);
            update cf;
           
            RemoteActionResponse res = new RemoteActionResponse();
            res.fileTitle = cf.Cloud_file_Title__c; 
            
            String policyStr = AmazonUtil.createPolicy(cf, serverurl);
            res.policy = AmazonUtil.getPolicy(policyStr); 
            System.debug('Blob Policy>>>' + res.policy);
            System.debug('Hex Policy>>>' + EncodingUtil.convertToHex(Blob.valueOf(res.policy))); 
            
            //res.signature = AmazonUtil.getSignature(policyStr, awsConfig.Secret__c);            
            res.signature = getSignature(policyStr, awsConfig.Secret__c);
            system.debug('Signature>>>> '+res.signature + '@@@@@@' + 'Policy= '+res.policy);
            system.debug('>>>>cf' + cf);
            return res;
        }
        return null;
    }    
    
    public PageReference onPageLoad() {             
        serverURL = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('serverURL= '+serverURL);
        
        Id cId = ApexPages.currentPage().getParameters().get('id');
        
        Cloud_File__c c = [SELECT Id, Name, Cloud_file_KISS_doc_type__c, Cloud_file_Status__c, OwnerId, Cloud_File_Document_Type__r.Name FROM Cloud_File__c WHERE Id =: cId];
        system.debug('KISS Doc Type= '+c.Cloud_file_KISS_doc_type__c);
        
        /*if(c.Cloud_file_KISS_doc_type__c != Null ){
            system.debug('**KISS Doc Type is not Null***');
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot update this file.'));
        }
        
        if(c.Cloud_file_Status__c == 'Låst'){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot update this file.'));
        }
        
        Map<string,AmazonAdminProfiles__c> mapAdminProfs =AmazonAdminProfiles__c.getAll();
        Set<String> setadmProfiles = mapAdminProfs.keySet();
        User loginUsr = [SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        Boolean admin = false;
        
        if(setadmProfiles.contains(loginUsr.Profile.Name)){
            admin = true;
        }
                
        if(c.OwnerId != UserInfo.getUserId() || admin == false){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot update this file.'));
        }*/
        
        Map<string,AmazonAdminProfiles__c> mapAdminProfs =AmazonAdminProfiles__c.getAll();
        Set<String> setadmProfiles = mapAdminProfs.keySet();
        User loginUsr = [SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        Boolean admin = false;
        
        if(setadmProfiles.contains(loginUsr.Profile.Name)){
            admin = true;
        }
        
        /*if(c.Cloud_file_KISS_doc_type__c != Null || (c.Cloud_file_Status__c == 'Låst' || (admin == false || c.OwnerId != UserInfo.getUserId()))){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot update this file.'));
        }*/
        
       if(c.Cloud_file_KISS_doc_type__c != Null){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere denne fil da den er genereret af KISS'));
        }
        if(c.Cloud_file_KISS_doc_type__c == Null && c.Cloud_File_Document_Type__r.Name == Null){
        	rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere denne fil fordi dokumentnavn og/eller type mangler.'));
        }else if (c.Cloud_file_Status__c == 'Låst' && c.Cloud_file_KISS_doc_type__c == Null){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere dette dokument, fordi det er låst.'));
        }
        
        /*else if (c.OwnerId != UserInfo.getUserId() || admin == false){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot update this file.'));
        }*/
        
        return null;
    }
    
    public PageReference updateDocRecord() {
        Id clfId1 = ApexPages.currentPage().getParameters().get('ID');
        S3.AmazonS3 as3;        
        DateTime now = DateTime.now();
        String Bucket;
        String deleteFileName;
        String fulName;
        
        Cloud_File__c clf = [SELECT Id, Name, Cloud_File_Bucket_Name__c, Cloud_File_Full_Name__c, Cloud_File_Customer_Numbers__c,
                                    Cloud_file_Title__c, Cloud_file_KISS_doc_type__c, Cloud_File_Path_Prefix__c, Cloud_File_MID__c  
                             FROM Cloud_File__c WHERE Id =:clfId1];
                             
        fulName = clf.Cloud_File_Customer_Numbers__c + '/' + clf.Cloud_file_Title__c;
        
        if(clf.Cloud_file_KISS_doc_type__c == Null || clf.Cloud_file_KISS_doc_type__c == ''){       
            if(clf.Cloud_File_Full_Name__c != fulName){
                Bucket = clf.Cloud_File_Bucket_Name__c;
                //deleteFileName = clf.Cloud_File_Full_Name__c;                 
                deleteFileName = clf.Cloud_File_Path_Prefix__c + '/' + clf.Cloud_File_Full_Name__c;
               if(!Test.isRunningTest()){
                    as3 = new S3.AmazonS3(credentials.Key__c,credentials.Secret__c);
                    system.debug('deleteFileName= '+deleteFileName);
                    S3.Status deleteObjectReslt= as3.DeleteObject(Bucket,deleteFileName,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
                }
                clf.Cloud_File_Full_Name__c = fulName;
                                
                User usr = [SELECT Id, Name, MID__c, IsActive FROM User WHERE MID__c = :clf.Cloud_File_MID__c LIMIT 1];   
                            
                if(usr.IsActive == true){
                    clf.Cloud_File_MID__c =  usr.MID__c;                    
                }
                                
                if(clf != Null){
                    update clf;
                }
            }   
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere denne fil.'));
            Bucket = clf.Cloud_File_Bucket_Name__c;
            deleteFileName = fulName;
            if(!Test.isRunningTest()){                  
                as3 = new S3.AmazonS3(credentials.Key__c,credentials.Secret__c);
                system.debug('deleteFileName= '+deleteFileName);
                S3.Status deleteObjectReslt= as3.DeleteObject(Bucket,deleteFileName,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
            }
        }
        //
        /*fulName = clf.Cloud_File_Customer_Numbers__c + '/' + clf.Cloud_file_Title__c;
        
        if(clf.Cloud_File_Full_Name__c != fulName){
            Bucket = clf.Cloud_File_Bucket_Name__c;
            deleteFileName = clf.Cloud_File_Full_Name__c;                   
            as3 = new S3.AmazonS3(credentials.Key__c,credentials.Secret__c);
            
            system.debug('deleteFileName= '+deleteFileName);
            S3.Status deleteObjectReslt= as3.DeleteObject(Bucket,deleteFileName,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
            
            clf.Cloud_File_Full_Name__c = fulName;
                
            if(clf != Null){
                update clf;
            }
        }       */
        //
        
        PageReference p = new PageReference('/'+clfId1);
        return p;
    }
    
    public pageReference cancel1() {
        Id clfId = ApexPages.currentPage().getParameters().get('id');
        PageReference p = new PageReference('/' + clfId);        
        return p; 
    }
    
    public class RemoteActionResponse {
        public String policy {get; set;}   
        public String signature {get; set;}
        public String fileTitle {get; set;}        
    }
    
}