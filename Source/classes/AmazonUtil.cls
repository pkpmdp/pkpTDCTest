/***************************************************************************************
*   Class AmazonUtil
*   
*   This class contains all the utility methods and methods used across
*   controller classes
*
***************************************************************************************/

global class AmazonUtil {
    private static AWSKey__c awsConfig;
    public static boolean skipTrigger=false;
    
    public AmazonUtil(){
        awsConfig=getAWSConfig();
    }
   
    public  static AWSKey__c getAWSConfig()
    {
        if(awsConfig == null)
        {
            awsConfig = new  AWSKey__c();            
            List<AWSKey__c> listAWS = new List<AWSKey__c>();
            
            String instanceName = '';
            if(isSandbox())
                instanceName = 'Sandbox';
            else
                instanceName = 'Production';
            
            
            //get the aws config details based on the current instance
            listAWS = [SELECT Name, Key__c, Secret__c FROM AWSKey__c 
                           WHERE Instance__c = :instanceName];
            
            if(!listAWS.isEmpty())
              {
                  awsConfig = listAWS[0];
                  return awsConfig;
              }
        }
        return awsConfig;
    }
     
    // this method will pad the pased Cable unit no
    // with the necessary zeros    
    public static String fixCableUnitNo(String cuNo)
    {
        if(!String.isBlank(cuNo))
        {
           if(cuNo.length() < 10){
             Integer diff = 10 - cuNo.length();
             String zeros = '';
                    
             for(Integer i = 0; i<= diff - 1; i++){
                zeros = zeros + '0';
             }
            cuNo = zeros + cuNo; 
         }        
        }
        return cuNo;
    }
    
    // this method returns if the current org is a sandbox or prod
    public static boolean isSandbox()
    {
        // get the current org id
        String currentOrgId = UserInfo.getOrganizationId().substring(0,15);
        
        // get the prod org id from the custom setting
        String prodOrgId = '';
        List<AmazonOrgId__c> listOrgId = [select Org_id__c from AmazonOrgId__c where name = 'PROD'];
        System.debug('orgId =>'+listOrgId);
        if(!listOrgId.isEmpty())
            prodOrgId = listOrgId[0].Org_id__c;
               
        // if the current org id matches the prod id, we are in prod
        if(currentOrgId == prodOrgId)
            return false;
        else
            return true;
    }
        
    public static String createPolicy(Cloud_File__c cf, String serverurl) {
      datetime expire = system.now().addDays(1);
      String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                               expire.formatGmt('HH:mm:ss')+'.'+
                               expire.formatGMT('SSS')+'Z'; 
                               
      String pkey = cf.Cloud_File_Path_Prefix__c + '/' + cf.Cloud_File_Customer_Numbers__c;
        
      /*String policy =  '{ "expiration": "'+formattedexpire +'",' + 
                         '"conditions": [ {"bucket": "' + cf.Cloud_File_Bucket_Name__c +'" } ' + 
                         ',{ "acl": "' + cf.Cloud_File_Access__c +'" },'+                              
                         '{"content-type":"'+cf.Cloud_file_content_Type__c+'"},'+
                         '{"success_action_redirect": "'+serverurl+'/apex/Amazon_UpdateDocrecord?ID='+cf.id+'&callback=True"},' +
                         '["starts-with", "$key", "'+ cf.Cloud_File_Customer_Numbers__c +'"]]}'; */
      
      system.debug('serverurl'+serverurl);                   
      String policy =  '{ "expiration": "'+formattedexpire +'",' + 
                         '"conditions": [ {"bucket": "' + cf.Cloud_File_Bucket_Name__c +'" } ' + 
                         ',{ "acl": "' + cf.Cloud_File_Access__c +'" },'+                              
                         '{"content-type":"'+cf.Cloud_file_content_Type__c+'"},'+
                         '{"success_action_redirect": "'+serverurl+'/apex/Amazon_UpdateDocrecord?ID='+cf.id+'&callback=True"},' +
                         '["starts-with", "$key", "'+ pkey +'"]]}';
                         
      system.debug('>>>policy:' + policy);  
      //return EncodingUtil.urlEncode(policy, 'UTF-8');
      return policy;  
    }
    
    public static String getPolicy(String policyStr) {       
       return EncodingUtil.base64Encode(Blob.valueOf(policyStr));   
    }
    
    // this method is used to get the signature for the Amazon s3 request
    public static String make_sig(string secret, string canonicalBuffer) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(Secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    public static String getSignature(String policyStr, String apiSecret) {       
       return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policyStr)), apiSecret);  
    }
    
    // this method returns the correct bucket name based on the customer type - heirarchy or otherwise.    
    public static String getCorrectBucket()
    {
        String bName = '';
        AWS_Env_Settings__c awsenv;
        
        if(isSandbox()){           
            awsenv = AWS_Env_Settings__c.getValues('preprod');
            bName = awsenv.Bucket_Name__c;
        }else{
            awsenv = AWS_Env_Settings__c.getValues('prod');
            bName = awsenv.Bucket_Name__c;
        }
        
        system.debug('bName='+bName);
        return bName;
    }
    
    // creates the file title based on the document name, current date and file Extension
    public static String getCloudFileTitle(Cloud_File__c clf, String fileExtension)
    {
       Datetime dateTimetemp = System.now();
       /*Date dateTemp = Date.newInstance(dateTimetemp.year(),dateTimetemp.month(),dateTimetemp.day());
       String x =dateTemp.format(); */
       //String x = dateTimetemp.format('yyyy-MM-dd');      
       String x = dateTimetemp.format('yyyy-MM-dd-HH-mm-ss');       
       system.debug('x= '+x); 
         
        
       if(!String.isEmpty(clf.Cloud_File_Document_Type__r.Name)){            
                clf.Cloud_file_Title__c = clf.Cloud_File_Document_Type__r.Name 
                                                + ' ' + x + '.' 
                                                + fileExtension;
                return clf.Cloud_file_Title__c;    
        } 
        system.debug('>>>>In Amazon Util getCloudFileTitle:'+clf.Cloud_file_Title__c);
       return null; 
    }
    
    //creates the file prefix.
    public static String getCloudFilePrefix(Account acc){
        String prefix = '';
        AWS_Env_Settings__c awsenvfldr;
        
        if(isSandbox()){
            if(acc.Type == 'Hierarki'){
                awsenvfldr = AWS_Env_Settings__c.getValues('preprod');
                prefix = awsenvfldr.Environment__c + '/' + awsenvfldr.Hierarchy_Customer_Folder__c;
            }else if(acc.Type == 'Kunde'){
                awsenvfldr = AWS_Env_Settings__c.getValues('preprod');
                prefix = awsenvfldr.Environment__c + '/' + awsenvfldr.Cable_Unit_Folder__c;
            }
        }else{
            if(acc.Type == 'Hierarki'){
                awsenvfldr = AWS_Env_Settings__c.getValues('prod');
                prefix = awsenvfldr.Environment__c + '/' + awsenvfldr.Hierarchy_Customer_Folder__c;
            }else if(acc.Type == 'Kunde'){
                awsenvfldr = AWS_Env_Settings__c.getValues('prod');
                prefix = awsenvfldr.Environment__c + '/' + awsenvfldr.Cable_Unit_Folder__c;
            }
        }  
        
        system.debug('prefix= '+prefix);
        return prefix;
    }
    
    // This method is used to delete the cloud file from amazon s3.
    
    public static void deleteFile(Id cldfId){  
        
        S3.AmazonS3 as3;
            
        List<Cloud_File__c> clf = [SELECT Id, Name, Cloud_File_Bucket_Name__c, Cloud_file_related_to_id__c, Cloud_file_Title__c, 
                                    Cloud_File_Full_Name__c, Cloud_File_Path_Prefix__c   
                             FROM Cloud_File__c WHERE Id=:cldfId LIMIT 1];                           
        
        if(!clf.isEmpty()){         
        
            String bucketToList = clf[0].Cloud_File_Bucket_Name__c;
            //objectToDelete = ApexPages.currentPage().getParameters().get('keyToDelete');
            String objectToDelete = clf[0].Cloud_File_Path_Prefix__c + '/' + clf[0].Cloud_File_Full_Name__c;
            system.debug('objectToDelete= '+objectToDelete);
            awsConfig=AmazonUtil.getAWSConfig();  
            //AWSKey__c credentials = getAWSConfig();  
                
            as3 = new S3.AmazonS3(awsConfig.Key__c,awsConfig.Secret__c);
            system.debug('Credentials'+awsConfig);
            system.debug('*as3.key= '+as3.key+'*as3.secret= '+as3.secret);
   
            DateTime now = DateTime.now();
            if(!Test.isRunningTest()){  
            S3.Status deleteObjectReslt= as3.DeleteObject(bucketToList,objectToDelete,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
            system.debug('deleteObjectReslt='+deleteObjectReslt);
            }
            delete clf;
          
        }
    }
    
    
  /*  public static Boolean moveFile()
    {
        return null;
    }  */  
    
       
    // this method will copy the specified object to the specified location.
    
    public static Boolean copyFile(String origBucket, String origFileName, String newBucket, String newFileName)
    {
        system.debug('>>>In copyFile***');
        //system.debug('getAWSConfig()= '+getAWSConfig());
        AWSKey__c credentials = AmazonUtil.getAWSConfig();
        
        system.debug('credentials= '+credentials);
        String key = credentials.Key__c;
        String secret = credentials.Secret__c;
        system.debug('Key= '+key+'***Secrete= '+secret);

        Datetime now = DateTime.now();
        
        //format should be like 2006-01-01T12:00:00.000Z
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';
        
        // get the signature
        //  "AmazonS3" + OPERATION + Timestamp
        String canonical = 'AmazonS3' + 'CopyObject' + formattednow;
        String signature = AmazonUtil.make_sig(secret, canonical);
        //String signature = EncodingUtil.Base64Encode(Crypto.generateMac('HmacSHA1', Blob.valueOf(canonical), Blob.valueOf(Secret)));
        
        
        string soapBody= '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header/><env:Body>';
        soapBody += '<CopyObject xmlns="http://s3.amazonaws.com/doc/2006-03-01">';
        soapBody += '<SourceBucket>' + origBucket + '</SourceBucket>';
        soapBody += '<SourceObject>' + origFileName + '</SourceObject>'; 
        soapBody += '<DestinationBucket>' + newBucket + '</DestinationBucket>';
        soapBody += '<DestinationObject>' + newFileName + '</DestinationObject>';
        soapBody += '<MetadataDirective>COPY</MetadataDirective>';
        soapBody += '<AWSAccessKeyId>' + key + '</AWSAccessKeyId>';
        soapBody += '<Timestamp>' + formattednow + '</Timestamp>';
        soapBody += '<Signature>' + signature + '</Signature>';
        soapBody +='</CopyObject></env:Body></env:Envelope>';
        system.debug('SOAPBODY>>>' + soapBody);
        
        HttpRequest req = new HttpRequest();   
        req.setEndpoint('https://s3-eu-west-1.amazonaws.com/soap');
        req.setMethod('POST'); 
        req.setBody(soapBody);
        req.setHeader('Content-Type', 'application/soap+xml' );
        req.setHeader('SOAPAction','');
        req.setHeader('Content-Length',string.valueof(soapBody.trim().length()));
        Http http = new Http();
        if(!Test.isRunningTest()){  
            HttpResponse res = http.send(req);
            system.debug('REs body>>' + res.getBody());
           
            // if status code not equal to 200, 
            // there is a problem and the copy failed.
            if(res.getStatusCode() != 200)
                return false;
         }  
        return true;        
    }
    
    
    



    
    // Response wrapper class for manually made SOAP and REST requests.
    public class AmazonResponse
    {
        public boolean outcome {get; set;}      // indicates the outcome of the operation
        public string statusCode {get; set;}    // indicates the status code of the response
        public String errMessage {get; set;}    // Error message description if any
    }
    
    Public String parseSoapResponse(String xmlBody) {    
        String responseDetail;
        Xmlstreamreader reader = new Xmlstreamreader(xmlBody);
        
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                system.debug('LocalName>>' + reader.getLocalName());
                if ('Reason' == reader.getLocalName())
                {
                   reader.next();
                    system.debug('IN >>>' +  reader.getLocalName());
                    if('Text' == reader.getLocalName())
                    {
                         reader.next();
                             if (reader.getEventType() == XmlTag.CHARACTERS) {
                            responseDetail = reader.getText();
                            break;
                        }
                    }
                }
            }
            reader.next();
        }
        
        return responseDetail;
    }

}