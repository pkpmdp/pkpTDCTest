/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is de-ployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UploadYouSeeContactImagesSCTestClass{

    static testMethod void myUnitTest() {
         Id imageId;
        
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
		Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        cu.Status__c = '0';
        cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                   
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cu.Cable_Type__c = 'Coax';
        cu.Loop__c = 'T';
        insert cu;
		
		Account account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert account;
        List<Lookup_Account_Team_Role__c> roleK = [Select Id,Name from Lookup_Account_Team_Role__c where Name =:'Kundeansvarlig'];
        
        Lookup_Account_Team_Role__c role3 = new Lookup_Account_Team_Role__c(Name = 'Kundeansvarlig', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                          Code__c = 'Rolle3' );
          insert role3;
        Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c( Name = 'Michel Kenneth Hansen', SourceId__c = 'member-id1' ,Email__c ='test@test.com', Telephone__c = '123456',Code__c ='abc1');    
		insert member1;
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = roleK[0].Id);
        insert ct; 
        PageReference pageRef = Page.ViewYouseeContactPersonPage;  
        Test.setCurrentPage(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber', cu.Cable_Unit_No__c);
		
        Test.startTest();
        UploadYouSeeContactImages controller= new UploadYouSeeContactImages();
        System.debug('**Cable Unit Number**'+ Apexpages.currentpage().getparameters().get('cableunitnumber'));
                
        controller.cancel();
        controller.writeToConsultant();
        controller.GetYouSeeContactName();
        controller.GetYouSeeContactTelephone();
        controller.getMainImage();
        controller.setMainImage(imageId);
        controller.GetOrgId();
        
        controller = new UploadYouSeeContactImages();   
        controller.cancel();                                     
    }
	
	static testMethod void negativeTest() {
         Id imageId;
        
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
		Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        cu.Status__c = '0';
        cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                   
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cu.Cable_Type__c = 'Coax';
        cu.Loop__c = 'T';
        insert cu;
		
        PageReference pageRef = Page.ViewYouseeContactPersonPage;  
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('cableunitnumber', '');
		 Apexpages.currentpage().getparameters().put('accountId', ''); 
        Test.startTest();
        UploadYouSeeContactImages controller= new UploadYouSeeContactImages();
        System.debug('**Cable Unit Number**'+ Apexpages.currentpage().getparameters().get('cableunitnumber'));
                
        controller.cancel();
        controller.writeToConsultant();
        controller.GetYouSeeContactName();
        controller.GetYouSeeContactTelephone();
        controller.getMainImage();
        controller.setMainImage(imageId);
        controller.GetOrgId();
        
        controller = new UploadYouSeeContactImages();   
        controller.cancel();                                     
    } 
	
	 static testMethod void myNegativeTest2() {
         Id imageId;
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
		Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        cu.Status__c = '0';
        cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                   
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cu.Cable_Type__c = 'Coax';
        cu.Loop__c = 'T';
        insert cu;
		
		Account account = new Account();
        account.Name = 'Vishal Nayak';
        account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert account;
        List<Lookup_Account_Team_Role__c> roleK = [Select Id,Name from Lookup_Account_Team_Role__c where Name =:'Kundeansvarlig'];
        
        Lookup_Account_Team_Role__c role3 = new Lookup_Account_Team_Role__c(Name = 'Kundeansvarlig', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                          Code__c = 'Rolle3' );
          insert role3;
        Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c(  SourceId__c = 'member-id1' );    
		insert member1;
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = roleK[0].Id);
        insert ct; 
		
        PageReference pageRef = Page.ViewYouseeContactPersonPage;  
        Test.setCurrentPage(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
        Apexpages.currentpage().getparameters().put('cableunitnumber', '43222664');
		
        Test.startTest();
        UploadYouSeeContactImages controller= new UploadYouSeeContactImages();
        System.debug('**Cable Unit Number**'+ Apexpages.currentpage().getparameters().get('cableunitnumber'));
                
		String UserMCode = 'A53124';
        String DocumentID = '';
        ContentVersion tempContent = new ContentVersion();
        List<ContentVersion> testContent = new List<ContentVersion>();
        testContent = [select id, Title, Description from ContentVersion where Account__c = :account.Id];
        DocumentID = tempContent.Id;
		
        controller.cancel();
        controller.writeToConsultant();
        controller.GetYouSeeContactName();
        controller.GetYouSeeContactTelephone();
        controller.getMainImage();
        controller.setMainImage(imageId);
        controller.GetOrgId();
        
        controller = new UploadYouSeeContactImages();   
        controller.cancel();                                     
    }
     static testMethod void myNegativeTest3() {
         Id imageId;
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
		
		Account account = new Account();
        account.Name = 'Vishal Nayak';
      //  account.Cable_Unit__c = cu.Id;
        account.RecordTypeId = recordType.Id;
		account.Anlaeg_No__c ='1234';
        account.Active__c = true;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert account;
        List<Lookup_Account_Team_Role__c> roleK = [Select Id,Name from Lookup_Account_Team_Role__c where Name =:'Kundeansvarlig'];
        
        Lookup_Account_Team_Role__c role3 = new Lookup_Account_Team_Role__c(Name = 'Kundeansvarlig', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                          Code__c = 'Rolle3' );
          insert role3;
        Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c(  SourceId__c = 'member-id1' );    
		insert member1;
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = roleK[0].Id);
        insert ct; 
		
        PageReference pageRef = Page.ViewYouseeContactPersonPage;  
        Test.setCurrentPage(pageRef);
        String accountId = account.Id;
        Apexpages.currentpage().getparameters().put('accountId', accountId); 
       // Apexpages.currentpage().getparameters().put('cableunitnumber', '43222664');
		
        Test.startTest();
        UploadYouSeeContactImages controller= new UploadYouSeeContactImages();
       
        controller.cancel();
        controller.writeToConsultant();
        controller.GetYouSeeContactName();
        controller.GetYouSeeContactTelephone();
        controller.getMainImage();
        controller.setMainImage(imageId);
        controller.GetOrgId();
        
        controller = new UploadYouSeeContactImages();   
        controller.cancel();                                     
    }
    
}