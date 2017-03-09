/*
 * JIRA Issue:- SF-1565 - Upload account documents from SFDC & SF-1571 - Upload documents for Hierarchical Customers
 * VF - 1. Amazon_DocUpload
 *      2. Amazon_DocUploadToS3     
 */
public class Amazon_DocUpload_CT {
    //public static AWSKeys credentials {get;set;}
    //private String AWSCredentialName = ''; //Modify this string variable to be the name of the AWS Credential record that contains the proper AWS keys and secret
    //public string secret { get {return credentials.secret;} }
    //public string key { get {return credentials.key;} }
    public string secret { get {return awskey.Secret__c;} }
    public string key { get {return awskey.Key__c;} }
    public AWSKey__c awskey; 
    public AWSKey__c awsConfig;
    
    public Cloud_File__c record; //  { get { return (Cloud_File__c)con.getRecord(); }}
    public S3.AmazonS3 as3 { get; private set; }
    public static String serverURL {get;set;}
    
    public String fileName {get;set;}
    //public Integer fileSize {get;set;}
    public Integer fileSize = Null;
    public Blob fileBlob {get;set;}
    public S3.ListAllMyBucketsEntry[] allBucketList {get;set;}      
    
    public string clfName{get; set;}
    public String val{get;set;}
    Account acc;
    public String categoryVar{get;set;}
    public String docTypeVar{get;set;}
    public boolean isCategorySelected{get;set;}  
    //public String prepath{get; set;}
    
    
    ApexPages.StandardController con;
    public Amazon_DocUpload_CT(ApexPages.StandardController stdController) {
        this.con = stdController;
        system.debug('record***'+ con.getRecord() );
        clfName = 'Cloud File Name';
        try { 
        this.record = [select id,Cloud_File_Bucket_Name__c,Cloud_file_content_Type__c, name,Cloud_File_Full_Name__c, Cloud_File_Access__c, 
                              Cloud_File_Description__c, Cloud_file_cu_no__c, Cloud_File_Category__c,Cloud_File_Document_Type__c,
                              Cloud_file_Status__c,Cloud_File_Department__c, Cloud_file_Title__c, Cloud_file_Hierarchi_Cust_no__c,
                              Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c                                
                              from Cloud_File__c 
                              where id = :con.getRecord().id limit 1];
        } catch( Exception ee) { 
            this.record = new Cloud_File__c(); 
        }
        //as3 = new S3.AmazonS3(credentials.key,credentials.secret);
    }  
    
    public Amazon_DocUpload_CT(){
        
    } 
    
     /*
       This method is called when the news3object Visualforce page is loaded. It verifies that the AWS Keys can be found
       in the AWSKeys__c custom object by the specified name, as set in the string variable AWSCredentialsName. 
       
       Any errors are added to the ApexPage and displayed in the Visualforce page. 
    */
    public PageReference constructor(){
        try{
            /*awskey = [SELECT Id, Name FROM AWSKey__c LIMIT 1];
            AWSCredentialName = awskey.Name;
            credentials = new AWSKeys(AWSCredentialName);   */
                   
            awskey = AmazonUtil.getAWSConfig();
            //as3 = new S3.AmazonS3(credentials.key,credentials.secret);
                       
        }catch(Exception e){
             
             //ApexPages.addMessage(e);
             //throw new AWSKeys.AWSKeysException(AWSEx);
             //ApexPages.addMessage(AWSEx);    
        }   
    
       return null; 
    }    
    
    public List<SelectOption> getCategories() {
    	
    	Set<ID> set_ids=new Set<ID>();
        List<DocumentCategoryType__c> lst_Obj=[SELECT Parent__r.Id FROM DocumentCategoryType__c where Type__c='Document Type' and isActive__c=true];
        for(DocumentCategoryType__c tempObj : lst_Obj)
        {
        	set_ids.add(tempObj.Parent__r.Id);
        }        
        List<DocumentCategoryType__c> lst_categories=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Exclude_In_Upload__c=false and Id IN : set_ids];
        lst_categories.sort();
        List<SelectOption> options = new List<SelectOption>();
        String result = UserInfo.getLocale();
        String language=UserInfo.getLanguage();
        system.debug('##locale :'+result);
          system.debug('##language :'+language);
		if(language.equalsIgnoreCase('en_us')){
			 options.add(new SelectOption(' ','--None--'));
		}else{
       		 options.add(new SelectOption(' ','--Ingen--'));
		}
		
        for(DocumentCategoryType__c lbl : lst_categories)
        {         	
          options.add(new SelectOption(lbl.Value__c,lbl.Name));
        }
        return options;
        
     }
     
     public List<SelectOption> getDocTypes() {
        List<DocumentCategoryType__c> lst_docTypes=new List<DocumentCategoryType__c>();
     	List<DocumentCategoryType__c> lst_category2=[SELECT ID,Value__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Value__c=:categoryVar];
     	if(lst_category2.size()>0){
         lst_docTypes=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Document Type' and Parent__c=:lst_category2[0].Id];
     	}
        lst_docTypes.sort();
        List<SelectOption> options = new List<SelectOption>();
        if(String.isBlank(categoryVar)){
        	isCategorySelected=false;
	        String result = UserInfo.getLocale();
	        String language=UserInfo.getLanguage();
        	system.debug('##locale :'+result);
            system.debug('##language :'+language);
			if(language.equalsIgnoreCase('en_us')){
				 options.add(new SelectOption(' ','--None--'));
			}else{
	        	options.add(new SelectOption(' ','--Ingen--'));
			}
        }else
        {
        	isCategorySelected=true;
        }
        for(DocumentCategoryType__c lbl : lst_docTypes)
        {
          options.add(new SelectOption(lbl.Value__c,lbl.Name));
        }
    	return options;
     }
    
    public static String createPolicy(Cloud_File__c cf) 
    {
      datetime expire = system.now().addDays(1);
      String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                               expire.formatGmt('HH:mm:ss')+'.'+
                               expire.formatGMT('SSS')+'Z'; 
                               
      String pkey = cf.Cloud_File_Path_Prefix__c + '/' + cf.Cloud_File_Customer_Numbers__c;
        
      /*String policy =  '{ "expiration": "'+formattedexpire +'",' + 
                         '"conditions": [ {"bucket": "' + cf.Cloud_File_Bucket_Name__c +'" } ' + 
                         ',{ "acl": "' + cf.Cloud_File_Access__c +'" },'+                              
                         '{"content-type":"'+cf.Cloud_file_content_Type__c+'"},'+
                         '{"success_action_redirect": "https://'+serverurl+'/apex/Amazon_UpdateIsActive?ID='+cf.id+'&callback=True"},' +
                         '["starts-with", "$key", "'+ cf.Cloud_File_Customer_Numbers__c +'"]]}'; */
                         
      String policy =  '{ "expiration": "'+formattedexpire +'",' + 
                         '"conditions": [ {"bucket": "' + cf.Cloud_File_Bucket_Name__c +'" } ' + 
                         ',{ "acl": "' + cf.Cloud_File_Access__c +'" },'+                              
                         '{"content-type":"'+cf.Cloud_file_content_Type__c+'"},'+
                         '{"success_action_redirect": "https://'+serverurl+'/apex/Amazon_UpdateIsActive?ID='+cf.id+'&callback=True"},' +
                         '["starts-with", "$key", "'+ pkey +'"]]}';
                         
      system.debug('>>>policy:' + policy);  
      //return EncodingUtil.urlEncode(policy, 'UTF-8');
      return policy;  
    }
    
    public static String getPolicy(String policyStr)
    {       
       return EncodingUtil.base64Encode(Blob.valueOf(policyStr));   
    }
    
    public static String getSignature(String policyStr, String apiSecret)
    {       
       return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policyStr)), apiSecret);  
    }
   
    /*
    datetime expire = system.now().addDays(1);
    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
        expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
          
    string policy { get {return 
        '{ "expiration": "'+formattedexpire+'","conditions": [ {"bucket": "'+
        record.Cloud_File_Bucket_Name__c +'" } ,{ "acl": "'+
        record.Cloud_File_Access__c +'" },'+
    //  '{"success_action_status": "201" },'+
        '{"content-type":"'+record.Cloud_file_content_Type__c+'"},'+
        '{"success_action_redirect": "https://'+serverurl+'/apex/Amazon_UpdateIsActive?ID='+record.id+'&callback=True"},' +
        '["starts-with", "$key", "'+record.Cloud_file_cu_no__c+'"] ]}';   } } 
   
    public String getPolicy() {
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
    
    public String getSignedPolicy() {    
        return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));        
    }
    
    // tester
    public String getHexPolicy() {
        String p = getPolicy();
        return EncodingUtil.convertToHex(Blob.valueOf(p));
    }
    
    
   */ 
    
    //method that will sign
    private static String make_sig(string canonicalBuffer, String apiSecret) {        
        String macUrl ;        
        //String signingKey = EncodingUtil.base64Encode(Blob.valueOf(apiSecret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(apiSecret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    public String bucketToList {get;set;}
        
    // this method is called from JS in Amazon_DocUploadToS3 page to upload the content type and 
    // and also generate the file title
    @RemoteAction
    public static RemoteActionResponse processFile(String cloudFileId, String fileExt, String contentType, String server_URL)
    {
        system.debug('### server_URL ' + server_URL);
        // get the aws config
        AWSKey__c awsConfig = AmazonUtil.getAWSConfig();
        system.debug('>>>in updateContentType');
        List<Cloud_File__c> listCF = [select Id, Cloud_file_content_Type__c, 
                                                 Cloud_File_Document_Type__r.Name,Cloud_File_Bucket_Name__c,
                                                 Cloud_File_Access__c, Cloud_file_cu_no__c,
                                            Cloud_file_KISS_doc_type__c, Cloud_file_Title__c,
                                            Cloud_File_Full_Name__c, Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, 
                                            Cloud_File_Path_Prefix__c,Cloud_File_Department__c                                             
                                        from Cloud_File__c
                                        where Id = :cloudFileId];        
        if(!listCF.isEmpty())
        {
            Cloud_File__c cf =  listCF[0];
            cf.Cloud_file_content_Type__c = contentType;
            cf.Cloud_file_Title__c = AmazonUtil.getCloudFileTitle(cf, fileExt);
            cf.Cloud_File_Full_Name__c = cf.Cloud_File_Customer_Numbers__c + '/' + cf.Cloud_file_Title__c;
            system.debug('>>>>cf' + cf);
            update cf;
            
            system.debug('server_URL= '+server_URL);
            serverURL = server_URL;
            // return the file title back along with the 
            // recalculated policy and signature
            RemoteActionResponse res = new RemoteActionResponse();
            res.fileTitle = cf.Cloud_file_Title__c; 
            
            String policyStr = createPolicy(cf);
            res.policy = getPolicy(policyStr); 
            System.debug('Blob Policy>>>' + res.policy);
            System.debug('Hex Policy>>>' + EncodingUtil.convertToHex(Blob.valueOf(res.policy))); 
            
            res.signature = getSignature(policyStr, awsConfig.Secret__c);            
            system.debug('Signature>>>> '+res.signature + '@@@@@@' + 'Policy= '+res.policy);
            return res;
        }
        return null;
    }     
    
    public pageReference save1() {
        
        // this saved the cloud file field values from the VF binding
       
        User mid = [SELECT Id, MID__c, Name,Department, IsActive FROM User WHERE Id =: UserInfo.getUserId()];
        
        Cloud_File__c cldF = (Cloud_File__c)con.getRecord();            
	    if(String.isNotBlank(mid.Department)){	        	 	
	        cldF.Cloud_File_Department__c =mid.Department;
	     } 
	   
	    system.debug('*** category:'+ categoryVar+' docType:'+docTypeVar);    
	   
	    if(String.isBlank(categoryVar)||String.isBlank(docTypeVar))
        {
        	Apexpages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Vælg kategori og dokument type'));
       		return null;
        }else{
		        List<DocumentCategoryType__c> lst_categoryDocType=[Select Id,Type__c,Parent__c,Name,isActive__c from DocumentCategoryType__c where value__c IN(:categoryVar,:docTypeVar)];
		        system.debug('***lst_categoryDocType size:'+lst_categoryDocType.size()+' lst_categoryDocType:'+lst_categoryDocType);
		        Id parentId;
		  	    for(DocumentCategoryType__c tempObj : lst_categoryDocType){	    	
			    	if((tempObj.Type__c).equalsIgnoreCase('Category')){
			    		cldF.Cloud_File_Category__c=tempObj.Id;
			    		parentId=tempObj.Id;
			    	}
			     }   
			      for(DocumentCategoryType__c tempObj : lst_categoryDocType){     
			    	if((tempObj.Type__c).equalsIgnoreCase('Document Type')&&(tempObj.Parent__c==parentId)&&(tempObj.Name).equalsIgnoreCase(docTypeVar)){
			    		cldF.Cloud_File_Document_Type__c=tempObj.Id;
			    		 system.debug('***inside doc type');
			  		 }  
			      }     
        }
       
        con.save();
        
        system.debug('***record ID:'+con.getRecord().id);
        PageReference p = new PageReference('/apex/Amazon_DocUploadToS3?id='+ con.getRecord().id );
        String relatedToId = APexpages.currentPage().getParameters().get('relatedTo');
        system.debug('Related To Id='+relatedToId);
        acc = [SELECT Id, Name, Cable_Unit_No__c, HierarchyCustomerNumber__c, Type FROM Account WHERE ID =:relatedToId LIMIT 1];
        system.debug('Account details='+acc.Cable_Unit_No__c);
        
        List<Cloud_File__c> listClF = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, Cloud_File_Bucket_Name__c, isActive__c, 
                                              Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c,  
                                              Cloud_File_Category__r.Name, Cloud_File_Document_Type__r.Name, 
                                              Cloud_File_Path_Prefix__c,Cloud_File_Department__c                                               
                                       FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
        
        if(!listClF.isEmpty())
        {
            Cloud_File__c cf =  listClF[0];
            system.debug('Cloud File record=' + cf.Id);
            
            //cf.Cloud_file_related_to_id__c = relatedToId;
            cf.Cloud_file_related_to_id__c = acc.Id;
           // cf.Cloud_File_All_Categories__c = listClF[0].Cloud_File_Centa_Doc_Type__c;
            //cf.Cloud_File_All_Document_Types__c = listClF[0].Centa_Document_Name__c;
            //system.debug('cf.Cloud_File_All_Categories__c= '+cf.Cloud_File_All_Categories__c);
           // system.debug('cf.Cloud_File_All_Document_Types__c= '+cf.Cloud_File_All_Document_Types__c);
            system.debug('cf.Cloud_File_Category__c= '+listClF[0].Cloud_File_Category__r.Name);
            system.debug('cf.Cloud_File_Document_Type__c= '+listClF[0].Cloud_File_Document_Type__r.Name);
            //cf.Cloud_file_cu_no__c = acc.Cable_Unit_No__c;
            //cf.Cloud_file_Hierarchi_Cust_no__c = acc.HierarchyCustomerNumber__c;
            
            if(acc.Type == 'Hierarki'){
                cf.Cloud_file_Hierarchi_Cust_no__c = acc.HierarchyCustomerNumber__c;
                cf.Cloud_File_Customer_Numbers__c = acc.HierarchyCustomerNumber__c;
            }else{
                cf.Cloud_file_cu_no__c = acc.Cable_Unit_No__c;
                cf.Cloud_File_Customer_Numbers__c = acc.Cable_Unit_No__c;
            }
            
            // TODO - bucket name has to be chosen dynamically      
            //cf.Cloud_File_Bucket_Name__c = getCorrectBucket();
            cf.Cloud_File_Bucket_Name__c = AmazonUtil.getCorrectBucket();
            cf.Cloud_File_Path_Prefix__c = AmazonUtil.getCloudFilePrefix(acc);
            //prepath = cf.Cloud_File_Path_Prefix__c + cf.Cloud_File_Full_Name__c; 
            cf.IsActive__c = false;
            
            if(mid.IsActive == true){
                cf.Cloud_File_MID__c = mid.MID__c;
                //cf.Cloud_File_Uploaded_By__c = mid.Name;
            }
            if(String.isNotBlank(mid.Department)){
	            	cf.Cloud_File_Department__c =mid.Department;
	        }	
            
            /*User mid = [SELECT Id, MID__c FROM User WHERE Id =: UserInfo.getUserId()];            
            cf.Cloud_File_MID__c = mid.MID__c;*/
        
            update listClF;            
        }
   
        p.getParameters().put('urlParam', serverURL);
        p.setRedirect(true);
        return p;   
    }
    
    // this method returns the correct bucket name based on the customer type - heirarchy or otherwise.    
    /*public String getCorrectBucket()
    {       
        String bName = '';
        
        if(acc.Type == 'Hierarki'){
            Map<string,AWS_Hierarchical_BucketName__c> mapBucket =AWS_Hierarchical_BucketName__c.getAll();
            Set<String> setBucket = mapBucket.keySet();
            System.debug('Bucket >>>' + setBucket);
            List<String> listStrings = new List<String>(setBucket);
            bName = listStrings[0];
        }else{
            Map<string,AWS_BucketName__c> mapBucket =AWS_BucketName__c.getAll();
            Set<String> setBucket = mapBucket.keySet();
            System.debug('Bucket >>>' + setBucket);
            List<String> listStrings = new List<String>(setBucket);
            bName = listStrings[0];
        }
        
        system.debug('bName='+bName);
        return bName;
    }*/
    
    
    
    public pageReference cancel() {
        String relatedToId = APexpages.currentPage().getParameters().get('relatedTo');
        system.debug('Related To Id = '+relatedToId);
        PageReference p = new PageReference('/' + relatedToId);
        //p.setRedirect(true);
        return p;
        //return null;
    }
    
    public pageReference cancel1() {
        
        List<Cloud_File__c> listClF1 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, Cloud_file_Hierarchi_Cust_no__c, 
                                        Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c                                           
                                       FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
        String relatedToId = listClF1[0].Cloud_file_related_to_id__c;
        if(!listClF1.isEmpty()){
            delete listClF1;
            system.debug('Deleted');
        }
        PageReference p = new PageReference('/' + relatedToId);        
        return p;        
    }
    
    public pageReference page2onLoad(){
        String contentType;
       List<Cloud_File__c> listClF1 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, 
                                        Cloud_File_Bucket_Name__c,
                                       Cloud_File_Full_Name__c, Cloud_file_content_Type__c,
                                       Cloud_File_Document_Type__c, Cloud_file_Title__c, Cloud_file_Hierarchi_Cust_no__c,
                                       Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c                                            
                                       FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
       
       /*    
        listClF1[0].Cloud_File_Full_Name__c = listClF1[0].Cloud_file_cu_no__c +'/'+listClF1[0].Cloud_file_Title__c;
       
       if(!listClF1.isEmpty()){
           update listClF1;
       }*/
       //system.debug('Content Type='+listClF1[0].Cloud_file_content_Type__c);
       PageReference tempPageRef = constructor();
       
       serverURL = createServerURL();
       system.debug('Server URL: '+serverURL);
       return null; 
    }
    
    public static String createServerURL()
    {
        // Need to get the salesforce.com server from the URL
       System.debug('serverURL: ' +  ApexPages.currentPage().getParameters().get('urlParam'));
       serverURL = ApexPages.currentPage().getParameters().get('urlParam');
       //System.debug('serverURL: ' + serverURL);
       String urlDomain = serverURL.substring(serverURL.indexOf('://')+3,serverURL.indexOf('/services'));
       System.debug('URL Domain: ' + urlDomain);
       return urlDomain; 
    }   
    
    //This function is used on VF-Amazon_UpdateIsActive
    //When file is successfully uploaed to Amazon S3 the sucess URL will be redirect to Amazon_UpdateIsActive page which will make Document Record
    //active. 
    public pageReference UpdateIsActive(){
        String cloudFlId = APexpages.currentPage().getParameters().get('Id');
        //system.debug('Cloud File Id&&&'+cloudFlId);
        String isactive = APexpages.currentPage().getParameters().get('callback');
        List<Cloud_File__c> listClF2 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, 
                                        Cloud_File_Bucket_Name__c,
                                       Cloud_File_Full_Name__c, Cloud_file_content_Type__c,
                                       Cloud_File_Category__c,Cloud_File_Document_Type__c, Cloud_file_Title__c, IsActive__c, 
                                       Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c                                         
                                       FROM Cloud_File__c WHERE Id =:cloudFlId LIMIT 1];
                                       
        if(!listClF2.isEmpty()){
            if(isactive == 'True'){
                listClF2[0].IsActive__c = True;
            }
            else{
                listClF2[0].IsActive__c = False;
            }     
        
            update listClF2;
        }
        if(listClF2[0].Cloud_file_related_to_id__c!=null){
        //PageReference p = new PageReference('/' + cloudFlId);        
        PageReference p = new PageReference('/' + listClF2[0].Cloud_file_related_to_id__c);
        return p;
        }else
         return null;
    }
    
    public class RemoteActionResponse
    {
        public String policy {get; set;}   
        public String signature {get; set;}
        public String fileTitle {get; set;}        
    }
}