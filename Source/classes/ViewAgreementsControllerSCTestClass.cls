/** * This class contains unit tests for validating the behavior of Apex classes * and triggers. * * Unit tests are class methods that verify whether a particular piece * of code is working properly. Unit test methods take no arguments, * commit no data to the database, and are flagged with the testMethod * keyword in the method definition. * * All test methods in an organization are executed whenever Apex code is deployed * to a production organization to confirm correctness, ensure code * coverage, and prevent regressions. All Apex classes are * required to have at least 75% code coverage in order to be deployed * to a production organization. In addition, all triggers must have some code coverage. *  * The @isTest class annotation indicates this class only contains test * methods. Classes defined with the @isTest annotation do not count against * the organization size limit for all Apex scripts. * * See the Apex Language Reference for more information about Testing and Code Coverage. */
@isTest(SeeAllData = true)
private class ViewAgreementsControllerSCTestClass {   
     static testMethod void myUnitTest() {        
     ViewAgreementsController viewAgreementsObj = new ViewAgreementsController();     
     String documentURL;
     Id imageId;
     
     Cable_Unit__c cableUnit = new Cable_Unit__c();  
     cableUnit.Name = 'cu_kundeCust_testing';
     cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
     cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
     cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
     cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
     cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
     cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
     insert cableUnit;  
           
     
     viewAgreementsObj.GetYouSeeContactName();   
     viewAgreementsObj.GetYouSeeContactEmail();    
     viewAgreementsObj.getList_SalesConceptParam();    
     viewAgreementsObj.GetYouSeeContactTelephone();  
     //viewAgreementsObj.getDocumentURL();      
     //viewAgreementsObj.setDocumentURL(documentURL);    
     viewAgreementsObj.setMainImage(imageId);     
     viewAgreementsObj.getCableUnitName();       
     viewAgreementsObj.getMainImage();       
     viewAgreementsObj.writeToConsultant();  
 }
     
     static testMethod void myFirstUNitTest(){
        Test.startTest();
        String UserMCode = 'A53914';
        
        Map<string, List<Sales_Concept_Parameter__c>> salesconceptMapTest = new Map<String,List<Sales_Concept_Parameter__c>>();
        String salesConceptGroup;
        List<Sales_Concept_Parameter__c> salesParam = new List<Sales_Concept_Parameter__c>();
        Sales_Concept_Parameter__c scp = new Sales_Concept_Parameter__c();
         /*scp.Parameter_Value__c =  'asd';
         scp.Parameter_PortalActive__c = true;
         scp.sc_param_webContent_TextContent__c = 'daadasd';
         scp.Parameter_Head__c = 'head';
         scp.Parameter_Group__c = 'abxc';
         scp.Parameter_Code__c = 'qwe';
         scp.Head__c = 'head';
         scp.Code__c = 'Code';
         scp.ParameterValue_PortalActive__c
             
             */
        PageReference newPage = Page.ViewAgreementsPage;
        Test.setCurrentPage(newPage);
        Lookup_Account_Team_Role__c relationManagerRoleId = null;
        String relationManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
        relationManagerRoleId = [select Id from Lookup_Account_Team_Role__c where Name =: relationManagerRoleName];
        Id relManagerRoleId = relationManagerRoleId.Id;
        ApexPages.currentPage().getParameters().put('accountId','0012000000W5UOQAA3');
        List<Lookup_Account_Team_Role__c> roleList = [select Id from Lookup_Account_Team_Role__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c];
        Id roleId;
        if(roleList.size() > 0)  
            roleId = roleList.get(0).Id;  
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
        Account acc = new Account(Name='TestAccount');
        acc.RecordTypeId = recordType.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        insert acc;
        ApexPages.currentPage().getParameters().put('accountId','0012000000W5UOQAA3');
         ViewAgreementsController viewAgreementsObj = new ViewAgreementsController();
         ViewAgreementsController.c_SalesConceptParam sc_c = new  ViewAgreementsController.c_SalesConceptParam();
         sc_c.salesConceptGroup = 'abc';
        salesParam.add(scp);
         sc_c.salesConceptParam = salesParam;
        viewAgreementsObj.getAccountTeam();
        viewAgreementsObj.GetDocumentId(UserMCode);
        viewAgreementsObj.getImageId();
        viewAgreementsObj.GetTestImageId();
         
   
    }
    //public CommonExceptionHandlerCls testExceptionHandler = new CommonExceptionHandlerCls('ViewAgreementsControllerSCTestClass','Test Classes for View Agreements Controller');    
    static testMethod void mySecondUnitTest(){
     
            Test.startTest();
            String UserMCode = 'A53124';
            String DocumentID = '';
            ContentVersion tempContent = new ContentVersion();
            List<ContentVersion> testContent = new List<ContentVersion>();
            testContent = [select id, Title, Description from ContentVersion where Account__c =: '001M000000ACyWQIA1'];
            DocumentID = tempContent.Id;
            Boolean tempExist = true;
            Map<string, List<Sales_Concept_Parameter__c>> salesconceptMapTest = new Map<String,List<Sales_Concept_Parameter__c>>();
            String salesConceptGroup;
            List<Sales_Concept_Parameter__c> salesParam = new List<Sales_Concept_Parameter__c>();
            ViewAgreementsController viewAgreementsObj = new ViewAgreementsController();
            PageReference newPage = Page.ViewAgreementsPage;
            Test.setCurrentPage(newPage);
            Lookup_Account_Team_Role__c relationManagerRoleId;
            String relationManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
            relationManagerRoleId = [select Id from Lookup_Account_Team_Role__c where Name =: relationManagerRoleName];
            Id relManagerRoleId = relationManagerRoleId.Id;
            ApexPages.currentPage().getParameters().put('accountId','0012000000W5UOQAA3');
            List<Lookup_Account_Team_Role__c> roleList = [select Id from Lookup_Account_Team_Role__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c];
            Id roleId;
            if(roleList.size() > 0)  
            roleId = roleList.get(0).Id;  
            RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
            
            Account acc = new Account(Name='TestAccount');
            acc.RecordTypeId = recordType.Id;
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
            insert acc;
            
            viewAgreementsObj.getAccountTeam();
            viewAgreementsObj.GetDocumentId(UserMCode);
            viewAgreementsObj.getImageId();
            viewAgreementsObj.GetTestImageId();
            viewAgreementsObj.tempTestFlag = true;
    }    
    static testMethod void myNegativeUnitTest(){
     
            Test.startTest();
            String UserMCode = 'A53124';
            
            String DocumentID = '';
            ContentVersion tempContent = new ContentVersion();
            List<ContentVersion> testContent = new List<ContentVersion>();
            testContent = [select id, Title, Description from ContentVersion where Account__c =: '001M000000ACyWQIA1'];
            //tempContent = testContent.get(0);
            DocumentID = tempContent.Id;
            Boolean tempExist = true;
            Map<string, List<Sales_Concept_Parameter__c>> salesconceptMapTest = new Map<String,List<Sales_Concept_Parameter__c>>();
            String salesConceptGroup;
            List<Sales_Concept_Parameter__c> salesParam = new List<Sales_Concept_Parameter__c>();
            ViewAgreementsController viewAgreementsObj = new ViewAgreementsController();
            PageReference newPage = Page.ViewAgreementsPage;
            Test.setCurrentPage(newPage);
            Lookup_Account_Team_Role__c relationManagerRoleId = null;
            String relationManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
            relationManagerRoleId = [select Id from Lookup_Account_Team_Role__c where Name =: relationManagerRoleName];
            Id relManagerRoleId = relationManagerRoleId.Id;
            ApexPages.currentPage().getParameters().put('accountId','0012000000W5UOQAA3');
            List<Lookup_Account_Team_Role__c> roleList = [select Id from Lookup_Account_Team_Role__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c];
            Id roleId;
            if(roleList.size() > 0)  
            roleId = roleList.get(0).Id;  
            RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
            
            Account acc = new Account(Name='TestAccount');
            acc.RecordTypeId = recordType.Id;
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
            insert acc;
            
            
            viewAgreementsObj.getAccountTeam();
            viewAgreementsObj.getImageId();
            viewAgreementsObj.tempTestFlag = true;
            viewAgreementsObj.GetTestImageId();
            viewAgreementsObj.GetDocumentId(UserMCode);
            viewAgreementsObj.writeToConsultant();
              
            
    }
}