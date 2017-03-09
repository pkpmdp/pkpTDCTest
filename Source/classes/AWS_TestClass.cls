@isTest
private class AWS_TestClass {
    private static User user;
     private static Cable_Unit__c testCableUnit;
     private static Cable_Unit__c testCableUnit2; 
     private static Account testAccount;
      private static Account testAccount2;
     private static Account testAccountHier;
     private static Cloud_File__c testCloudFile;
     private static Cloud_File__c testCloudFile2;
     private static Cloud_File__c testCloudFile3;
     static AWS_Env_Settings__c testAWSBucket1;
     static AWS_Env_Settings__c testAWSBucket2;
     private static AWSKey__c aws;
     private static AWSKey__c aws2;
     private static AWSKey__c awsKey;
     static AmazonNoDeleteCategories__c testAmzNoDelCat;
     private static DocumentCategoryType__c testDocCatType;
      private static DocumentCategoryType__c testDocCatType2;
     private static String cuNumr = '';
     private static String xmlResponse;
          
     // test Amazon Util Class
    static testMethod void testAmazonUtil()
    {
        setupData();
        AmazonUtil controller = new AmazonUtil();
        AmazonUtil.AmazonResponse arObj=new AmazonUtil.AmazonResponse();
        arObj.errMessage='testError';
        arObj.outcome=true;
        arObj.statusCode='200';
        string soapBody= '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header/><env:Body>';
        soapBody += '<CopyObject xmlns="http://s3.amazonaws.com/doc/2006-03-01">';
        soapBody += '<MetadataDirective>COPY</MetadataDirective>';
        soapBody +='</CopyObject></env:Body></env:Envelope>';
        controller.parseSoapResponse(soapBody);
        String cuNo = AmazonUtil.fixCableUnitNo('9876');
        String policyStr=AmazonUtil.createPolicy(testCloudFile,'http://test/testUrl');
        AmazonUtil.getPolicy(policyStr);
        AmazonUtil.getSignature(policyStr, 'testSecrete');
        AmazonUtil.getCloudFileTitle(testCloudFile, 'pdf');
        AmazonUtil.getCorrectBucket();
        AmazonUtil.getCloudFilePrefix(testAccount2);
        AmazonUtil.getCloudFilePrefix(testAccountHier);
        AmazonUtil.deleteFile(testCloudFile2.Id);
        AmazonUtil.copyFile('abc','abc','abc','abc');
    
        
    }
     /* Commented since covered in new testclass Amazon_DocUpload_CTTest
     //test Amazon_DocUpload_CT
     static testMethod void testAmazonFileUploadDoc(){
        setupData();
        
        System.CurrentPageReference().getParameters().put('Id', testCloudFile.Id);
        Apexpages.currentPage().getParameters().put('callback', 'True');
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.CurrentPageReference().getParameters().put('urlParam', 'http://tstcs14.salesforce.com/services/apexrest/cloudFileRest?action=all'); 
        Amazon_DocUpload_CT.serverURL = '';
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUpload_CT controller = new Amazon_DocUpload_CT(cont);
        PageReference p = controller.constructor();
        System.CurrentPageReference().getParameters().put('relatedTo', testAccount.Id);
        PageReference p1 = controller.save1();
        PageReference p2 = controller.cancel();
        PageReference p3 = controller.cancel1();
        PageReference p5 = controller.page2onLoad();
        String policyStr=Amazon_DocUpload_CT.createPolicy(testCloudFile);
        Amazon_DocUpload_CT.getPolicy(policyStr);
        Amazon_DocUpload_CT.getSignature(policyStr, 'testSecrete');
     } */
     
     /*Commented since covered in new testclass Amazon_DocUpload_CTTest
     static testMethod void testAmazonFileUploadDoc1(){
        Amazon_DocUpload_CT controller = new Amazon_DocUpload_CT();
     } */
     
     /*Commented since covered in new testclass Amazon_DocUpload_CTTest
     static testMethod void testAmazonFileUploadDoc2(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUpload_CT controller1 = new Amazon_DocUpload_CT(cont);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());             
            Amazon_DocUpload_CT.processFile(testCloudFile.Id,'jpg','image/jpeg','http://test/test.com');
        Test.stopTest();
     } */
     
     /*Commented since covered in new testclass Amazon_DocUpload_CTTest
     static testMethod void testAmazonFileUploadDoc3(){
        setupData();
        System.CurrentPageReference().getParameters().put('Id', testCloudFile.Id);
        Apexpages.currentPage().getParameters().put('callback', 'True');
        System.CurrentPageReference().getParameters().put('urlParam', 'http://tstcs14.salesforce.com/services/apexrest/cloudFileRest?action=all');    
        Amazon_DocUpload_CT.serverURL = '';        
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUpload_CT controller = new Amazon_DocUpload_CT(cont);
        System.CurrentPageReference().getParameters().put('relatedTo', testAccount.Id);
        PageReference p4 = controller.UpdateIsActive();
    } */
    
    //Amazon_UpdateIsActive_CT
    static testMethod void testAmazonupdateisactive(){      
        setupData();
        System.currentPageReference().getParameters().put('Id', testCloudFile.id);
        Amazon_UpdateIsActive_CT controller = new Amazon_UpdateIsActive_CT();
        PageReference p = controller.UpdateIsActive();
    }
    /* Commented new test class written Amazon_FileList_CtTest
    //Amazon_FileList_CT
    static testMethod void testAmazonFileList() {
        PageReference p = Page.Amazon_AccountFileList;        
        Test.setCurrentPage(p);
        setupData();        
        ApexPages.currentPage().getParameters().put('Id',testAccount.Id);
        Amazon_FileList_CT controller = new Amazon_FileList_CT ();
        List<Cloud_File__c> lst_cloudFiles=new List<Cloud_File__c>();
        lst_cloudFiles.add(testCloudFile);
        Amazon_FileList_CT.clfWrapper clfWrpObj=new Amazon_FileList_CT.clfWrapper();
        controller.mapFields(lst_cloudFiles);        
        //controller.cuNo = '123456987';     
        controller.cuNo = cuNumr; 
        controller.getDocList();        
        controller.moveSelected();
        controller.MoveFile();      
        p = controller.DeletFile();
        controller.Cancel();
    } */
    
    /*Commented new test class written Amazon_ViewFile_CTtest
    //Amazon_ViewFile_CT
    // method to test the view file functionality
    static testMethod void TestViewFile(){
        setupData();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',testCloudFile.Id);
        Amazon_ViewFile_CT controller = new Amazon_ViewFile_CT();
        controller.doPageLoad();
        Test.stopTest();
    } */
    
    /*Commented new test class written AWS_RestServiceTest
    //AWS_RestService
    // test method for the reset webservice
    static testMethod void AWS_RestServiceTestMethod() {
        RestRequest req;
            RestResponse res;   
            AWS_RestService.ResponseWrapper result; 
            // create cloud file records for a cable unit
            setupData();
            Test.startTest();
                // set up the request object            
                req = new RestRequest(); 
                res = new RestResponse(); 
                req.requestURI = '/CloudFileRest';
                // test for no action
                req.httpMethod = 'GET';                 
                RestContext.request = req;
                RestContext.response = res;
                result  = AWS_RestService.doAction(); 
                system.assertNotEquals(result, null); 
                // test get Cable Unit method       
                req = new RestRequest();
                req.httpMethod = 'GET';         
                req.addParameter('action', 'GET_CU_FILES');
                req.addParameter('cableUnitNo', testCableUnit.Id);                  
                RestContext.request = req;
                RestContext.response = res;
                result  = AWS_RestService.doAction(); 
                system.assertNotEquals(result, null); 
                // test for no CU number specified
                req = new RestRequest();
                req.httpMethod = 'GET';         
                req.addParameter('action', 'GET_CU_FILES');                                 
                RestContext.request = req;
                RestContext.response = res;
                result  = AWS_RestService.doAction(); 
                system.assertNotEquals(result, null); 
                // test get construction project files                  
                req = new RestRequest();
                req.httpMethod = 'GET';
                req.addParameter('action', 'GET_CP_FILES'); 
                req.addParameter('consProjNo', '12345');
                req.addParameter('serviceReqNo', '12345');                      
                RestContext.request = req;
                RestContext.response = res;
                result  = AWS_RestService.doAction(); 
                system.assertNotEquals(result, null);
                // test for posting cloud file
                req = new RestRequest();
                req.httpMethod = 'POST';                                
                RestContext.request = req;
                RestContext.response = res;
                AWS_RestService.CloudFileWrapper cf = new AWS_RestService.CloudFileWrapper();
                cf.bucketName = 'Contract';
                cf.cableUnitNo = testCableUnit.Id;
                cf.fileName = 'test file.pdf';  
                cf.fullName = 'test file.pdf';    
                result  = AWS_RestService.saveCloudFile(cf); 
                system.assertNotEquals(result, null); 
            Test.stopTest();
    } */
    
    /*Commented new test class written AWS_RestServiceTest
    static testMethod void AWS_RestServiceTestMethod1() {
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/CloudFileRest';
        RestContext.request.addParameter('action', 'GET_CP_FILES');
        RestContext.request.addParameter('supplierRequestId', '570');
        AWS_RestService.getConsProjFiles(RestContext.request);   
        AWS_RestService.doAction();
    } */
    
    /*Commented new test class written AWS_RestServiceTest
    static testMethod void AWS_RestServiceTestMethod2() {
        setupdata();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/CloudFileRest'; 
        AWS_RestService.CloudFileWrapper cfWrpObj=new AWS_RestService.CloudFileWrapper();
        cfWrpObj.cableUnitNo='0000000570';
        cfWrpObj.constructProjNo='123';  
        cfWrpObj.hierarchicalCustomerNumber='123';
        List<Cloud_File__c> lst_cfObj = new List<Cloud_File__c>();
        lst_cfObj.add(testCloudFile);
        cfWrpObj.mid=lst_cfObj[0].Cloud_File_MID__c;        
        AWS_RestService.saveCloudFile(cfWrpObj);
        AWS_RestService.mapToWrapper(lst_cfObj[0]);
        AWS_RestService.mapToWrapperList(lst_cfObj);
    } */
    
    /*Commented new test class written AWS_RestServiceTest
    //save method with cableUnitNo=null;
    static testMethod void AWS_RestServiceTestMethod3() { 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/CloudFileRest'; 
        AWS_RestService.CloudFileWrapper cfWrpObj=new AWS_RestService.CloudFileWrapper();
        AWS_RestService.saveCloudFile(cfWrpObj);
    } */
    /*Commented new test class written AWS_RestServiceTest
    //save method with cableUnitNo!=null
     static testMethod void AWS_RestServiceTestMethod4() { 
        setupData();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/CloudFileRest'; 
        //RestContext.request.addParameter('cableUnitNo', testCloudFile.Cloud_file_cu_no__c);
        AWS_RestService.CloudFileWrapper cfWrpObj=new AWS_RestService.CloudFileWrapper();
        cfWrpObj.cableUnitNo=testCableUnit2.Cable_Unit_No__c;
        AWS_RestService.saveCloudFile(cfWrpObj);
    }*/
    
    /*Commented new test class written AWS_RestServiceTest
    //save method with kissDocType!=null
     static testMethod void AWS_RestServiceTestMethod5() { 
        setupData();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/CloudFileRest'; 
        AWS_RestService.CloudFileWrapper cfWrpObj=new AWS_RestService.CloudFileWrapper();
        cfWrpObj.kissDocType='test';       
        AWS_RestService.saveCloudFile(cfWrpObj);
    }  */   
    
    /*
    //S3
    //test method for class S3
    static testMethod void test_S3() {
        S3.LoggingSettings logstng = new S3.LoggingSettings();
        S3.Grant grnt = new S3.Grant();
        S3.ListBucketResponse_element lstBktRespEle = new S3.ListBucketResponse_element();
        S3.ListBucketResult lstBktRslt = new S3.ListBucketResult();
        S3.CopyObjectResult copyObjRslt = new S3.CopyObjectResult();
        S3.ListAllMyBucketsList lstAllMyBkt = new S3.ListAllMyBucketsList();
        S3.MetadataEntry metaDataEntry = new S3.MetadataEntry();
        S3.GetBucketAccessControlPolicyResponse_element getBktAcsCntrlPoliRespEle = new S3.GetBucketAccessControlPolicyResponse_element();
        S3.GetObjectResponse_element getObjRespEle = new S3.GetObjectResponse_element();
        S3.AmazonS3 s = new S3.AmazonS3();
        S3 controller = new S3();
        S3.GetBucketLoggingStatus_element getBktLogStsEle = new S3.GetBucketLoggingStatus_element();
        S3.GetObjectExtended_element getObjExtndEle = new S3.GetObjectExtended_element();
        S3.PostResponse_element postRespEle = new S3.PostResponse_element();
        S3.GetBucketAccessControlPolicy_element getBktAcsContrlPoliEle = new S3.GetBucketAccessControlPolicy_element();
        S3.ListAllMyBucketsEntry lstAllMyBktE = new S3.ListAllMyBucketsEntry();
        S3.CreateBucketResult createBktRslt = new S3.CreateBucketResult();
        S3.ListEntry lstEntry = new S3.ListEntry();
        S3.PutObjectInlineResponse_element putObjInResEle = new S3.PutObjectInlineResponse_element();
        S3.DeleteObject_element delObjEle = new S3.DeleteObject_element();
        S3.ListAllMyBucketsResult lstAllMyBktRslts = new S3.ListAllMyBucketsResult();
        S3.ListAllMyBucketsResponse_element lstAllMyBktRespEle = new S3.ListAllMyBucketsResponse_element();
        S3.GetObjectExtendedResponse_element getObjExtndRespEle = new S3.GetObjectExtendedResponse_element();
        S3.CreateBucketResponse_element createBkRespEle = new S3.CreateBucketResponse_element();
        S3.Status status = new S3.Status();
        S3.DeleteBucket_element delBktEle = new S3.DeleteBucket_element();
        S3.SetObjectAccessControlPolicy_element setObjAcsCntrlPoli = new S3.SetObjectAccessControlPolicy_element();
        S3.GetObjectAccessControlPolicyResponse_element getObjAcsCntrlPoliRespEle = new S3.GetObjectAccessControlPolicyResponse_element();
        S3.SetBucketLoggingStatus_element setBktLogStsEle = new S3.SetBucketLoggingStatus_element();
        S3.PrefixEntry preEntry = new S3.PrefixEntry();
        S3.DeleteObjectResponse_element delObjRespEle = new S3.DeleteObjectResponse_element();
        S3.SetBucketAccessControlPolicy_element setBktAcsCntrlPoliEle = new S3.SetBucketAccessControlPolicy_element();
        S3.GetBucketLoggingStatusResponse_element getBktLogStsRespEle = new S3.GetBucketLoggingStatusResponse_element();
        S3.ListAllMyBuckets_element lstAllMyBktEle = new S3.ListAllMyBuckets_element();
        S3.SetBucketLoggingStatusResponse_element setBktLogStsRespEle = new S3.SetBucketLoggingStatusResponse_element();
        S3.PutObjectResult putObjRes = new S3.PutObjectResult();
        S3.GetObjectAccessControlPolicy_element getObjAcsCntrlPoliEle = new S3.GetObjectAccessControlPolicy_element();
        S3.BucketLoggingStatus bktLogSts = new S3.BucketLoggingStatus();
        S3.GetObject_element getObjEle = new S3.GetObject_element();
        S3.Group_x grpX = new S3.Group_x();
        S3.AccessControlList acsCntrlLst = new S3.AccessControlList();
        S3.CopyObjectResponse_element copyObjRespEle = new S3.CopyObjectResponse_element();
        S3.CanonicalUser canoUsr = new S3.CanonicalUser();
        S3.Result reslt = new S3.Result();
        S3.AmazonCustomerByEmail amazonCustByEml = new S3.AmazonCustomerByEmail();
        S3.PutObjectResponse_element putObjRespEle = new S3.PutObjectResponse_element();
        S3.SetObjectAccessControlPolicyResponse_element setObjAcsCntrlPoliRespEle = new S3.SetObjectAccessControlPolicyResponse_element();
        S3.User_x userX = new S3.User_x();
        S3.ListBucket_element lstBktEle = new S3.ListBucket_element();
        S3.GetObjectResult getObjRslt = new S3.GetObjectResult();
        S3.PutObjectInline_element putObjInlEle = new S3.PutObjectInline_element();
        S3.LocationConstraint locConstrain = new S3.LocationConstraint();
        S3.CopyObject_element copyObjEle = new S3.CopyObject_element();
        S3.CreateBucket_element createBktEle = new S3.CreateBucket_element();
        S3.PutObject_element putObjEle = new S3.PutObject_element();
        S3.AccessControlPolicy acsCntrlPoli = new S3.AccessControlPolicy();
        S3.CreateBucketConfiguration createBktConfig = new S3.CreateBucketConfiguration();
        S3.DeleteBucketResponse_element delBktRespEle = new S3.DeleteBucketResponse_element();
        S3.SetBucketAccessControlPolicyResponse_element setBktAcsCntrlPoliRespEle = new S3.SetBucketAccessControlPolicyResponse_element();
        S3.S3Request s3Req = new S3.S3Request();        
    } */
    
    //Amazon_MoveFile_CT
    //test Amazon_MoveFile_CT
    static testMethod void testAmazonMoveFile1(){
        setupdata();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        Amazon_MoveFile_CT controller = new Amazon_MoveFile_CT();
        controller.Id=System.currentPageReference().getParameters().get('Id');
        controller.cuNo = '123456987';
        PageReference p = controller.MoveFile();    
        p = controller.Cancel();        
    }
    
    static testMethod void testAmazonMoveFile2(){
        setupData();
        testCloudFile.Cloud_file_KISS_doc_type__c='test';
        update testCloudFile;
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        Amazon_MoveFile_CT controller = new Amazon_MoveFile_CT();
        controller.Id=System.currentPageReference().getParameters().get('Id');
        controller.cuNo = '123456987';
        PageReference p = controller.MoveFile();   
    }
    
    static testMethod void testAmazonMoveFile4(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        Amazon_MoveFile_CT controller = new Amazon_MoveFile_CT();
        controller.movable=true;   
        testCloudFile.Cloud_file_KISS_doc_type__c=null;
        update testCloudFile; 
        controller.cuNo = '1234567890';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());            
            PageReference p = controller.MoveFile();   
        Test.stopTest();
    }
    
    static testMethod void testAmazonMoveFile3(){
        setupData();
        
        //Move File
        Profile prf = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        User adminUser = new User();
        
        if(prf.Id != Null || prf.Id != ''){         // Create a YO Admin
            
            adminUser.FirstName = 'YO Admin';
            adminUser.lastName = 'User';
            adminUser.ProfileId = prf.Id;
            adminUser.alias = 'yoAdmin';
            adminUser.email = 'yoAdmin@email.com';
            adminUser.userName = 'yoAdmin@email.com';
            adminUser.CommunityNickname = 'yoAdmin';
            adminUser.EmailEncodingKey = 'ISO-8859-1';
            adminUser.TimeZoneSidKey = 'Europe/Paris';
            adminUser.LocaleSidKey = 'da_DK';
            adminUser.LanguageLocaleKey   = 'da';
            adminUser.MID__c = 'YOADMIN';
            insert adminUser;
        }
        
        system.runAs(adminUser){
            System.currentPageReference().getParameters().put('id', testCloudFile.id);
            Amazon_MoveFile_CT controller = new Amazon_MoveFile_CT();
            controller.movable=true;   
            testCloudFile.Cloud_file_KISS_doc_type__c=null;
            update testCloudFile; 
            controller.cuNo = '12345678';
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());            
                PageReference p = controller.MoveFile();   
            Test.stopTest();
        }
    }
    
    static testMethod void testAmazonMoveFile5(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        Amazon_MoveFile_CT controller = new Amazon_MoveFile_CT();
        controller.movable=true;   
        testCloudFile.Cloud_file_KISS_doc_type__c=null;
        update testCloudFile; 
        controller.cuNo = '';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());            
            PageReference p = controller.MoveFile();   
        Test.stopTest();
    }
	
	/*Commented  new testclass Amazon_DocSearch_CTEtest  
    //Amazon_DocSearch_CTE 
    //test Amazon_DocSearch_CTE with isGetMore = True
    static testMethod void testAmazonDocSearch1(){
        setupdata();  
        testCloudFile.IsActive__c = true;
        update testCloudFile;   
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocSearch_CTE controller = new Amazon_DocSearch_CTE(cont);
        Amazon_DocSearch_CTE controller1 = new Amazon_DocSearch_CTE();
        Amazon_DocSearch_CTE.remotePagination(1,True,'isNext','CreatedDate','ASC','Test.pdf','12345','12345','H-1234','Allonge','1.1.2013','1.1.2013','Aftale','worksmart');
        
    }
    
    //test Amazon_DocSearch_CTE with isGetMore = True
    static testMethod void testAmazonDocSearch2(){
        setupdata();  
        testCloudFile.IsActive__c = true;
        update testCloudFile;   
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocSearch_CTE controller = new Amazon_DocSearch_CTE(cont);
        Amazon_DocSearch_CTE controller1 = new Amazon_DocSearch_CTE();
        Amazon_DocSearch_CTE.remotePagination(1,False,'isNext','CreatedDate','ASC','Test.pdf','12345','12345','H-1234','Allonge','1.1.2013','1.1.2013','Aftale','archived');
        
    }
    
    //test Amazon_DocSearch_CTE with nav = ''
    static testMethod void testAmazonDocSearch3(){
        setupdata();  
        testCloudFile.IsActive__c = true;
        update testCloudFile;   
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocSearch_CTE controller = new Amazon_DocSearch_CTE(cont);
        Amazon_DocSearch_CTE controller1 = new Amazon_DocSearch_CTE();
        Amazon_DocSearch_CTE.remotePagination(1,False,'isPrev','CreatedDate','ASC','Test.pdf','12345','12345','H-1234','Allonge','1.1.2013','','Aftale','duplicate');
        
    }
    
    //test Amazon_DocSearch_CTE with nav = ''
    static testMethod void testAmazonDocSearch4(){
        setupdata();  
        testCloudFile.IsActive__c = true;
        update testCloudFile;   
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocSearch_CTE controller = new Amazon_DocSearch_CTE(cont);
        Amazon_DocSearch_CTE controller1 = new Amazon_DocSearch_CTE();
        Amazon_DocSearch_CTE.remotePagination(1,False,'isFirst','CreatedDate','ASC','Test.pdf','12345','12345','H-1234','Allonge','','1.1.2013','Aftale','worksmart');
        
    }
    Commented  new testclass Amazon_DocSearch_CTEtest written*/ 
    
    /* Commented new test class Amazon_FileDelete_CTEXtest written
    //Amazon_FileDelete_CTEX
    //test Amazon_FileDelete_CTEX
    static testMethod void testAmazonFileDelete(){
        setupData();
        ApexPages.currentPage().getParameters().put('Id',testCloudFile.Id);
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_FileDelete_CTEX controller = new Amazon_FileDelete_CTEX(cont);
        controller.deleteFile();
        controller.Cancel();
    }
    */
    //Amazon_batchDeleteInActiveAmazonFiles
    //test Amazon_batchDeleteInActiveAmazonFiles
    static testMethod void testAmazonbatchdelAmzfls(){
        setupData();
        List<Cloud_File__c> listClf = new List<Cloud_File__c>();
        listClf.add(testCloudFile2);
        Test.startTest();
            Amazon_batchDeleteInActiveAmazonFiles batch = new Amazon_batchDeleteInActiveAmazonFiles();
            integer batchSize = 200;
            ID batchprocessid = Database.executeBatch(batch, batchSize);
            batch.start(null);
            batch.execute(null, listClf);
            batch.finish(null);
            //System.abortJob(batchprocessid);
        Test.stopTest();
    }
    
    //Amazon_NewOverride_CTE
    //test Amazon_NewOverride_CTE
    static testMethod void testAmazonNewOverride1(){
        setupdata();
        System.currentPageReference().getParameters().put('retURL', testCloudFile.id);
        ApexPages.Standardcontroller cont = new ApexPages.Standardcontroller(testCloudFile);
        Amazon_NewOverride_CTE controller = new Amazon_NewOverride_CTE(cont);
        PageReference p = controller.redirect();
        p = Page.Amazon_DocUpload;
    }
    
    /*commented Amazon_DocUpdate_CTtestclass written  
    //Amazon_DocUpdate_CT
    static testMethod void testAmazonDocUpdate1(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUpdate_CT controller = new Amazon_DocUpdate_CT(cont);
        Amazon_DocUpdate_CT controller1 = new Amazon_DocUpdate_CT();
        Amazon_DocUpdate_CT.RemoteActionResponse rarObj=new Amazon_DocUpdate_CT.RemoteActionResponse();
        rarObj.fileTitle='test';
        rarObj.policy='test';
        rarObj.signature='testSign';
        String policyStr=AmazonUtil.createPolicy(testCloudFile,'http://test/testUrl');       
        Amazon_DocUpdate_CT.getSignature(policyStr, 'testSecret');
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());
            PageReference p1 = controller1.cancel1();
            PageReference p2 = controller1.onPageLoad();
        Test.stopTest();
    }
    
    static testMethod void testAmazonDocUpdate2(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUpdate_CT controller1 = new Amazon_DocUpdate_CT(cont);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());
            controller1.updateDocRecord();  
            Amazon_DocUpdate_CT.processFile(testCloudFile.Id,'jpg','image/jpeg','http://test/test.com');
        Test.stopTest();
    }
    
    static testMethod void testAmazonDocUpdate3(){
        setupData();
        System.currentPageReference().getParameters().put('id', testCloudFile3.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile3);
        Amazon_DocUpdate_CT controller1 = new Amazon_DocUpdate_CT(cont);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new copyHttpCalloutMethod());
            controller1.updateDocRecord();  
            Amazon_DocUpdate_CT.processFile(testCloudFile.Id,'jpg','image/jpeg','http://test/test.com');
        Test.stopTest();
    }
    Amazon_DocUpdate_CTtestclass written*/
    
    //Amazon_DocUploadMultiCU_CT  44
    static testMethod void testAmazonUploadMultiFile1()
    {
        setupData();
        Apexpages.currentPage().getParameters().put('Id', testCloudFile.Id);
         Apexpages.currentPage().getParameters().put('callback', 'True');   
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile);
        Amazon_DocUploadMultiCU_CT controller = new Amazon_DocUploadMultiCU_CT(cont);
        controller.renderPB(); 
        controller.getSelected();
        controller.GetSelectedCUs();
        Amazon_DocUploadMultiCU_CT.CuWrapper cuWrpObj2=new Amazon_DocUploadMultiCU_CT.CuWrapper();
        cuWrpObj2.accw=testAccount;
        cuWrpObj2.selected=false;            
        controller.selectedCUs.add(cuWrpObj2);
        controller.getUnSelected();
        controller.cuNo=testCableUnit2.Id;
        
        
        testAWSBucket2 = new AWS_Env_Settings__c();
        testAWSBucket2.Name='prod';
        testAWSBucket2.Bucket_Name__c = 'sofus-prod';
        testAWSBucket2.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket2.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket2.Environment__c = 'prod';
        testAWSBucket2.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket2;
        
        testAWSBucket1 = new AWS_Env_Settings__c();
        testAWSBucket1.Name='preprod';
        testAWSBucket1.Bucket_Name__c = 'sofus-preprod';
        testAWSBucket1.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket1.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket1.Environment__c = 'preprod';
        testAWSBucket1.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket1;
        
        //testAWSBucket1 = new AWS_Hierarchical_BucketName__c();
        //testAWSBucket1.AWS_Hierarchical_Bucket_Name__c = 'customer-hierarchy-test1';
        //testAWSBucket1.Name = 'customer-hierarchy-test1';
        //insert testAWSBucket1;
        
        controller.cuNo='123456987897';  
        controller.searchCU();    
        PageReference p3 = controller.cancel1();
        system.debug('Clf Id= '+testCloudFile.Id); 
    }
   
    static testMethod void testAmazonUploadMultiFile3()
    {
        setupData();
        System.CurrentPageReference().getParameters().put('Id',testCloudFile2.Id);  
        System.CurrentPageReference().getParameters().put('callback', 'True');  
        System.CurrentPageReference().getParameters().put('urlParam', 'http://tstcs14.salesforce.com/services/apexrest/cloudFileRest?action=all');
        Amazon_DocUpload_CT.serverURL = '';        
        ApexPages.StandardController cont = new ApexPages.StandardController(testCloudFile2);
        Amazon_DocUploadMultiCU_CT controller = new Amazon_DocUploadMultiCU_CT(cont);      
        controller.cuNo=testCableUnit.Id; 
        Amazon_DocUploadMultiCU_CT.CuWrapper cuWrpObj=new Amazon_DocUploadMultiCU_CT.CuWrapper();
        cuWrpObj.accw=testAccount;
        cuWrpObj.selected=true;
        Amazon_DocUploadMultiCU_CT.CuWrapper cuWrpObj2=new Amazon_DocUploadMultiCU_CT.CuWrapper();
        cuWrpObj2.accw=testAccount;
        cuWrpObj2.selected=true;
        Amazon_DocUploadMultiCU_CT.RemoteActionResponse rarObj=new Amazon_DocUploadMultiCU_CT.RemoteActionResponse();        
        Amazon_DocUploadMultiCU_CT ct=new Amazon_DocUploadMultiCU_CT();
        PageReference p3 = controller.cancel1(); 
        controller.selectedCUs.add(cuWrpObj);
        system.debug('Acccont##:'+testAccount+'%1%'+testAccount.Cable_Unit_No__c);
        controller.cuNo='1234';
        controller.searchCU();
        controller.CWLst.add(cuWrpObj);
        controller.getSelected();
        controller.selectedCUs.add(cuWrpObj2);
        controller.getUnSelected();
        controller.GetSelectedCUs();
        controller.credentials();
        controller.credentials=awsKey;
        String policyStr=Amazon_DocUploadMultiCU_CT.createPolicy(testCloudFile);
        Amazon_DocUploadMultiCU_CT.createServerURL();
        Amazon_DocUploadMultiCU_CT.getSignature(policyStr,awsKey.Secret__c);
        controller.page2onLoad();
        controller.save1();
        controller.selectedCUs.add(cuWrpObj);
        controller.selectedCUs.add(cuWrpObj2);
        controller.selectedCUs.add(cuWrpObj2);
        controller.selectedCUs.add(cuWrpObj2);
        controller.selectedCUs.add(cuWrpObj2);
        controller.selectedCUs.add(cuWrpObj2);
        controller.renderPB();
        controller.getUnSelected();
    }
    
    /*commented new test class  AmazonWS_CloudFileDetailstest written
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
        
        List<Cloud_File__c> conList=[SELECT Cloud_file_Title__c,Cloud_File_Path_Prefix__c,Cloud_file_cu_no__c,Cloud_file_Hierarchi_Cust_no__c,Cloud_File_Con_Proj_No__c,Cloud_File_Category__c,Cloud_File_Document_Type__c,Cloud_File_Bucket_Name__c,Cloud_File_Full_Name__c,CreatedDate,Cloud_File_MID__c  FROM Cloud_File__c limit 10];
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
    }   commented new test class  AmazonWS_CloudFileDetailstest written */
   
     //this covers Amazon_updateDocRemark trigger and Amazon_deletedCloudFileLog trigger
    static testMethod void  Amazon_deletedCloudFileLogTestMethod() {    
        setupData(); 
        Test.startTest(); 
        delete testCloudFile;
        Test.stopTest();
    }
    /*
    //test for AmazonWS_PicklistDetails
     static testMethod void AmazonWS_PicklistDetailsTestMehod1() {  
        setupData(); 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/getpicklistvalues';
        RestContext.request.addParameter('action', 'category_documenttypes_upload');
        AmazonWS_PicklistDetails.Category catObj=new AmazonWS_PicklistDetails.Category('a','b');
        catObj.categorylabel='abc';
        catObj.categoryvalue='abc';
        AmazonWS_PicklistDetails.DocumentType docTypeObj=new AmazonWS_PicklistDetails.DocumentType();
        docTypeObj.documenttypelabel='xyz';
        docTypeObj.documenttypevalue='xyz';
        AmazonWS_PicklistDetails.getCategoryDocTypes('category_documenttypes_upload');       
        AmazonWS_PicklistDetails.getStatusPickListValues();
       //AmazonWS_PicklistDetails.getDocTagPickListValues(); // getting error while using picklist value filter for query
    }
    static testMethod void AmazonWS_PicklistDetailsTestMehod2() {  
        setupData(); 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/getpicklistvalues';
        RestContext.request.addParameter('action', 'category_documenttypes');
        AmazonWS_PicklistDetails.Category catObj=new AmazonWS_PicklistDetails.Category();
        catObj.categorylabel='abc';
        catObj.categoryvalue='abc';
        AmazonWS_PicklistDetails.DocumentType docTypeObj=new AmazonWS_PicklistDetails.DocumentType();
        docTypeObj.documenttypelabel='xyz';
        docTypeObj.documenttypevalue='xyz';
        AmazonWS_PicklistDetails.getCategoryDocTypes('category_documenttypes');       
        AmazonWS_PicklistDetails.getStatusPickListValues();
       //AmazonWS_PicklistDetails.getDocTagPickListValues(); // getting error while using picklist value filter for query
    }
    
    static testMethod void AmazonWS_PicklistDetailsTestMehod3() {  
        setupData(); 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/getpicklistvalues';
        RestContext.request.addParameter('action', 'status');
        AmazonWS_PicklistDetails.Status statusObj=new AmazonWS_PicklistDetails.Status();
        statusObj.statuslabel='abc';
        statusObj.statusname='abc';
    }
    
    static testMethod void AmazonWS_PicklistDetailsTestMehod4() {  
        setupData(); 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/getpicklistvalues';
        RestContext.request.addParameter('action', 'documenttag');
        AmazonWS_PicklistDetails.DocumentTag docTagObj=new AmazonWS_PicklistDetails.DocumentTag();
        docTagObj.documenttaglabel='abc';
        docTagObj.documenttagname='abc';
    }
    //--------------------------------------------------------------------------------------------------------------   
    */
    // method used to setup test records for a cable unit, Customer account and cloud file.
    private static void setupData()
    {
        //Get Amazon S3 credentials
        aws = new AWSKey__c();
        aws.key__c = 'KEY';
        aws.secret__c = 'SECRET';
        aws.Instance__c='Sandbox';
        insert aws;
        
        aws2 = new AWSKey__c();
        aws2.key__c = 'KEY';
        aws2.secret__c = 'SECRET';
        aws2.Instance__c='Production';
        insert aws2;
        
        awsKey=new AWSKey__c();
        awsKey.Key__c='AKIAJASHF5JOAXWT33IA';
        awsKey.Secret__c='OhAesOApBGvu9G';
        insert awsKey;
        
        Lookup_Building_Type__c buildingType;
        Lookup_Housing_Type__c housingType;
        Lookup_Housing_Ownership__c housingOwnerShip;
        
        Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
        customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;
        
        buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow';
        buildingType.Code__c='12121';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow34';
        insert buildingType;
        
        housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype';
        housingType.Code__c = '12121';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow545';
        insert housingType;
        
        housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel';
        housingOwnerShip.Code__c = '12121';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow876';
        insert housingOwnerShip;
                
        // Cable Unit
        testCableUnit = new Cable_Unit__c();
        testCableUnit.Name = 'test CU';
        testCableUnit.Cable_Unit_No__c = '123456987';
        testCableUnit.Potential_Installations__c = 68.0;
        testCableUnit.Municipaly__c = '223 Hørsholm'; 
        testCableUnit.Cable_Unit_Post_Code__c = '7400';
        testCableUnit.Housing_Ownership__c = housingOwnerShip.Id;                      
        testCableUnit.Housing_Type__c = housingType.Id;                     
        testCableUnit.Building_Type__c = buildingType.Id;
        insert testCableUnit;
        
        // Cable Unit
        testCableUnit2 = new Cable_Unit__c();
        testCableUnit2.Name = 'test CU';
        testCableUnit2.Cable_Unit_No__c = '1234567890';
        testCableUnit2.Potential_Installations__c = 68.0;
        testCableUnit2.Municipaly__c = '223 Hørsholm'; 
        testCableUnit2.Cable_Unit_Post_Code__c = '7400';
        testCableUnit2.Housing_Ownership__c = housingOwnerShip.Id;                      
        testCableUnit2.Housing_Type__c = housingType.Id;                     
        testCableUnit2.Building_Type__c = buildingType.Id;
        insert testCableUnit2;
        // setup a customer account   
          
        testAccount = new Account(name='Test Account' + '0', 
                                  Cable_Unit__c = testCableUnit.Id, 
                                  ShippingStreet='1 Main St.', 
                                  ShippingState='VA', 
                                  ShippingPostalCode='12345', 
                                  ShippingCountry='USA', 
                                  ShippingCity='Anytown', 
                                  Description='This is a test account', 
                                  BillingStreet='1 Main St.', 
                                  BillingState='VA', 
                                  BillingPostalCode='12345', 
                                  BillingCountry='USA', 
                                  BillingCity='Anytown', 
                                  AnnualRevenue=10000,
                                  Customer_Segment_Lookup__c=customerSegment.Id,
                                  Type = 'Kunde');
        insert testAccount;         
         Account acc1 = [SELECT Id, Name, Cable_Unit_No__c FROM Account WHERE Id =:testAccount.Id LIMIT 1];
         cuNumr = acc1.Cable_Unit_No__c;
         
        testAccount2 = new Account(name='Test Account2' + '0', 
                                  Cable_Unit__c = testCableUnit2.Id, 
                                  ShippingStreet='1 Main St2.', 
                                  ShippingState='VA', 
                                  ShippingPostalCode='12345', 
                                  ShippingCountry='USA', 
                                  ShippingCity='Anytown', 
                                  Description='This is a test account', 
                                  BillingStreet='1 Main St.', 
                                  BillingState='VA', 
                                  BillingPostalCode='12345', 
                                  BillingCountry='USA', 
                                  BillingCity='Anytown', 
                                  AnnualRevenue=10000,
                                  Customer_Segment_Lookup__c=customerSegment.Id,
                                  Type = 'Kunde');
        insert testAccount2;  
          Account acc2 = [SELECT Id, Name, Cable_Unit_No__c FROM Account WHERE Id =:testAccount2.Id LIMIT 1];   
        testAccountHier = new Account(name='TestHierarchy' + '0',
                                  ShippingStreet='1 Main St.', 
                                  ShippingState='VA', 
                                  ShippingPostalCode='12345', 
                                  ShippingCountry='USA', 
                                  ShippingCity='Anytown', 
                                  Description='This is a test account', 
                                  BillingStreet='1 Main St.', 
                                  BillingState='VA', 
                                  BillingPostalCode='12345', 
                                  BillingCountry='USA', 
                                  BillingCity='Anytown', 
                                  AnnualRevenue=10000,
                                  Customer_Segment_Lookup__c=customerSegment.Id,
                                  Type = 'Hierarki');
        insert testAccountHier; 
       
        Account acc3 = [SELECT Id, Name, Cable_Unit_No__c FROM Account WHERE Id =:testAccountHier.Id LIMIT 1];        
       
        user=new User();  
        user.Username='testvrs@test.com';
        user.LastName='testLastName';
        user.Email='test@test.com';
        user.Alias='trss';
        user.CommunityNickname='trstr';
        user.TimeZoneSidKey='Europe/Paris';
        user.LocaleSidKey='da_DK';  
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId='00e20000000v9G1AAI';
        user.LanguageLocaleKey='da';           
        user.MID__c='123';
        user.IsActive=true;        
        insert user;
        
        testDocCatType=new DocumentCategoryType__c();
        testDocCatType.isActive__c=true;
        testDocCatType.Name='Aftale';
        testDocCatType.Value__c='Aftale';
        testDocCatType.Type__c='Category';
        insert testDocCatType;
        
        testDocCatType2=new DocumentCategoryType__c();
        testDocCatType2.isActive__c=true;
        testDocCatType2.Name='Allonge';
        testDocCatType2.Value__c='Allonge';
        testDocCatType2.Type__c='Document Type';
        testDocCatType2.Parent__c=testDocCatType.Id;
        insert testDocCatType2;
        
        // setup a cloud file for this account
        testCloudFile = new Cloud_File__c();
        testCloudFile.Cloud_File_Bucket_Name__c = 'Common1';
        testCloudFile.Cloud_file_cu_no__c = testAccount.Cable_Unit_No__c;
        testCloudFile.Cloud_file_related_to_id__c = testAccount.Id;
        testCloudFile.Cloud_file_full_name__c = 'Test File Upload1.pdf';
        testCloudFile.Cloud_file_Title__c = 'Test File Upload.pdf';
        testCloudFile.Cloud_File_Category__c = testDocCatType.Id;
        testCloudFile.Cloud_File_Document_Type__c = testDocCatType2.Id;
        testCloudFile.Cloud_file_content_Type__c='pdf';
        testCloudFile.IsActive__c=true;
        testCloudFile.Cloud_File_Doc_Remark__c='test1;test2;test3;test4;test5;test6;test7;test8;test9';
        testCloudFile.Cloud_File_Path_Prefix__c='test';
        testCloudFile.Cloud_File_MID__c = user.MID__c;
        testCloudFile.Cloud_File_Path_Prefix__c='dev/cableunit';  
        testCloudFile.Cloud_File_Document_Tag__c='worksmart';     
        insert testCloudFile;
        
        testCloudFile2 = new Cloud_File__c();
        testCloudFile2.Cloud_File_Bucket_Name__c = 'Common2';
        testCloudFile2.Cloud_file_cu_no__c = testAccount2.Cable_Unit_No__c;
        testCloudFile2.Cloud_file_related_to_id__c = testAccount2.Id;
        testCloudFile2.Cloud_file_full_name__c = 'Test File Upload2.pdf';
        testCloudFile2.Cloud_file_Title__c = 'Test File Upload2.pdf';
        testCloudFile2.Cloud_File_Category__c = testDocCatType.Id;
        testCloudFile2.Cloud_File_Document_Type__c = testDocCatType2.Id;
        testCloudFile2.Cloud_file_content_Type__c='pdf';
        testCloudFile2.IsActive__c=true;
        testCloudFile2.Cloud_File_Doc_Remark__c='test2';
        testCloudFile2.Cloud_File_Path_Prefix__c='test2';
        testCloudFile2.Cloud_File_MID__c = 'testMID2';
        testCloudFile2.Cloud_File_Path_Prefix__c='dev/cableunit';
        testCloudFile2.Cloud_File_Document_Tag__c='archived';    
        insert testCloudFile2;
        
        testCloudFile3 = new Cloud_File__c();
        testCloudFile3.Cloud_File_Bucket_Name__c = 'Common2';
        testCloudFile3.Cloud_file_cu_no__c = testAccount2.Cable_Unit_No__c;
        testCloudFile3.Cloud_file_related_to_id__c = testAccount2.Id;
        testCloudFile3.Cloud_file_full_name__c = 'Test File Upload2.pdf';
        testCloudFile3.Cloud_file_Title__c = 'Test File Upload2.pdf';        
        testCloudFile3.Cloud_file_content_Type__c='pdf';
        testCloudFile3.IsActive__c=true;
        testCloudFile3.Cloud_File_Doc_Remark__c='test2';
        testCloudFile3.Cloud_File_Path_Prefix__c='test2';
        testCloudFile3.Cloud_File_MID__c = 'testMID2';
        testCloudFile3.Cloud_file_KISS_doc_type__c = 'Contract';
        testCloudFile3.Cloud_File_Path_Prefix__c='dev/cableunit';
        testCloudFile.Cloud_File_Document_Tag__c='duplicate';    
        insert testCloudFile3;
        
        testAWSBucket1 = new AWS_Env_Settings__c();
        testAWSBucket1.Name='preprod';
        testAWSBucket1.Bucket_Name__c = 'sofus-preprod';
        testAWSBucket1.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket1.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket1.Environment__c = 'preprod';
        testAWSBucket1.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket1;
        
        testAWSBucket2 = new AWS_Env_Settings__c();
        testAWSBucket2.Name='prod';
        testAWSBucket2.Bucket_Name__c = 'sofus-prod';
        testAWSBucket2.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket2.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket2.Environment__c = 'prod';
        testAWSBucket2.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket2;
        
        //AmazonNoDeleteCategories__c
        testAmzNoDelCat = new AmazonNoDeleteCategories__c();
        testAmzNoDelCat.Name = 'TestCustSet';
        testAmzNoDelCat.Category__c = 'Aftale';
        testAmzNoDelCat.Document_Type__c = 'Allonge';
        insert testAmzNoDelCat;
        
    }
    
    public class copyHttpCalloutMethod implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {      
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');  
            res.setStatusCode(200);
            return res;
        }
     }
}