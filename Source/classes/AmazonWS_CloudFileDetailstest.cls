@isTest(SeeAllData=true)
public class AmazonWS_CloudFileDetailstest {
	 //testing searchcloudfiles webservice
    static testMethod void CloudFileDetailsTestMethod1() {  
        AmazonWS_CloudFileDetails.CloudFileWrapper cWrapObj=new AmazonWS_CloudFileDetails.CloudFileWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/searchcloudfiles';
        RestContext.request.addParameter('action', 'all');
        
        AmazonWS_CloudFileDetails.JsonWrapper jsonWrapObj=new AmazonWS_CloudFileDetails.JsonWrapper();
        jsonWrapObj.cableunitnumber='570';
        jsonWrapObj.bucketname='cableunit-test';
        jsonWrapObj.categories='Aftale';
        jsonWrapObj.constructionprojectnumber='';
        jsonWrapObj.documenttype='Underskrevet Interessemåling';
        jsonWrapObj.enddate='7-9-2013';
        jsonWrapObj.startdate='1-9-2013';
        jsonWrapObj.hierarchicalcustomernumber='H-037127';
        jsonWrapObj.title='Underskrevet Interessemåling 2013-09-04.pdf';
        List<String> ids=new List<String>();
        ids.add('003c000000Lo9ITAAZ');
        ids.add('0032000000RCelpAAD');
        
        String jsonString=JSON.serialize(jsonWrapObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString); 
        AmazonWS_CloudFileDetails.doPostAction();       
        AmazonWS_CloudFileDetails.getCloudFilesDetails();
        
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
        AmazonWS_CloudFileDetails.JsonWrapper jsonwrap =(AmazonWS_CloudFileDetails.JsonWrapper)JSON.deserialize(bodyString,AmazonWS_CloudFileDetails.JsonWrapper.class);
        
        List<Cloud_File__c> conList=[SELECT Id,Cloud_file_Title__c,Cloud_File_Path_Prefix__c,Cloud_file_cu_no__c,Cloud_file_Hierarchi_Cust_no__c,Cloud_File_Con_Proj_No__c,Cloud_File_Category__c,Cloud_File_Document_Type__c,Cloud_File_Bucket_Name__c,Cloud_File_Full_Name__c,CreatedDate,Cloud_File_MID__c,Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name,Cloud_File_Description__c,Cloud_File_Document_Tag__c  FROM Cloud_File__c limit 10];
        AmazonWS_CloudFileDetails.mapToCloudFileList(conList);
        
    }
    //action =null test
    static testMethod void CloudFileDetailsTestMethod2() {         
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/searchcloudfiles';                
        ContactDetailsRestService.doPostAction();
    }
     //action =other test
    static testMethod void CloudFileDetailsTestMethod3() {         
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/searchcloudfiles';
       RestContext.request.addParameter('action', 'elseTest');             
        ContactDetailsRestService.doPostAction();
    }
    //test for null json data
    static testMethod void CloudFileDetailsTestMethod4() {    
      
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/searchcloudfiles';
        RestContext.request.addParameter('action', 'all');
        AmazonWS_CloudFileDetails.JsonWrapper jsonWrapObj=new AmazonWS_CloudFileDetails.JsonWrapper();              
        String jsonString=JSON.serialize(jsonWrapObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString);        
        AmazonWS_CloudFileDetails.doPostAction();      
        Test.startTest(); 
        AmazonWS_CloudFileDetails.getCloudFilesDetails();
        Test.stopTest();
    }
}