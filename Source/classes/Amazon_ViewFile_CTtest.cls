@isTest(SeeAllData=true)
public class Amazon_ViewFile_CTtest {
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
     
     static testMethod void TestViewFile(){
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
        testAWSBucket1.Name='preprod5';
        testAWSBucket1.Bucket_Name__c = 'sofus-preprod';
        testAWSBucket1.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket1.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket1.Environment__c = 'prepssd';//tejas
        testAWSBucket1.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket1;
        
        testAWSBucket2 = new AWS_Env_Settings__c();
        testAWSBucket2.Name='prodrj';
        testAWSBucket2.Bucket_Name__c = 'sofus-prod';
        testAWSBucket2.Cable_Unit_Folder__c = 'cableunit';
        testAWSBucket2.Construction_Project_Folder__c = 'construction-project';
        testAWSBucket2.Environment__c = 'prttd';
        testAWSBucket2.Hierarchy_Customer_Folder__c = 'customer-hierarchy';
        insert testAWSBucket2;
        
        //AmazonNoDeleteCategories__c
        testAmzNoDelCat = new AmazonNoDeleteCategories__c();
        testAmzNoDelCat.Name = 'TestCustSet';
        testAmzNoDelCat.Category__c = 'Aftale';
        testAmzNoDelCat.Document_Type__c = 'Allonge';
        insert testAmzNoDelCat;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',testCloudFile.Id);
        Amazon_ViewFile_CT controller = new Amazon_ViewFile_CT();
        controller.doPageLoad();
        Test.stopTest();
    }
	

}