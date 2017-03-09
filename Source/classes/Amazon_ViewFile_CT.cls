/*
 *JIRA Issue:- SF-1565 - View/Edit/Upload account documents from SFDC
 *Description:- User can view a file which is uploaded in Amazon S3. Document URL will be active for 10 years from view of a Document
*/
public class Amazon_ViewFile_CT {
    public String url {get; set;}
    public transient String fileData {get; set;}
    public String contentType {get; set;}
    
    // constructor
    public Amazon_ViewFile_CT() {  
               
    } 
    
    public pageReference doPageLoad()
    {
        AWSKey__c awsConfig = AmazonUtil.getAWSConfig();
        String apiKey = awsConfig.Key__c;
        String secret = awsConfig.Secret__c;
        
        // get the cloud file id from the request
        String cloudFileId = ApexPages.currentpage().getParameters().get('id');
              
        // get the cloud file record 
        List<Cloud_file__c> listCF = [select Id, Cloud_File_Bucket_Name__c, cloud_file_full_name__c, cloud_file_content_type__c, 
        									 Cloud_File_Path_Prefix__c  
                                      from cloud_file__c where id = :cloudFileId limit 1];
        
        if(!listCF.isEmpty())
        {
           Cloud_file__c cf = listCF[0];
           contentType = cf.cloud_file_content_type__c;
           system.debug('>>>>>fileName: ' + cf.cloud_file_full_name__c);
           String fileName = EncodingUtil.urlEncode(cf.cloud_file_full_name__c, 'UTF-8');            
           system.debug('>>>fileName: ' + fileName);            
           String bucket = EncodingUtil.urlEncode(cf.Cloud_File_Bucket_Name__c,'UTF-8'); 
           system.debug('Bucket:= '+bucket+'###'+'File Name:='+fileName);
           String prefix = EncodingUtil.urlEncode(cf.Cloud_File_Path_Prefix__c, 'UTF-8');
           
           Datetime currentTime = DateTime.now();
           Datetime expireson = currentTime.addYears(10);
           Long Lexpires = expireson.getTime()/1000; 
            
            String stringtosign = 'GET\n\n\n'+Lexpires+'\n/' + bucket + '/' + prefix + '/' + filename;
            system.debug('>>>>stringtosign: ' + stringtosign);
            String signed = AmazonUtil.make_sig(secret,stringtosign);
            String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
            //url = 'http://' + bucket + '.s3.amazonaws.com/' + filename + '?AWSAccessKeyId=' + apiKey + '&Expires='+Lexpires+'&Signature='+ codedsigned;                       
            url = 'https://' + bucket + '.s3.amazonaws.com/' + prefix + '/' + filename + '?AWSAccessKeyId=' + apiKey + '&Expires='+Lexpires+'&Signature='+ codedsigned;
            system.debug('URL>>>' + url);
            /*
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody());
            fileData = EncodingUtil.base64Encode(res.getBodyAsBlob());
            */
            return null;
        }
        
        return null;
    }
}