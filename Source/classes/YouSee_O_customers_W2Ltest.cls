@isTest
public class YouSee_O_customers_W2Ltest {
    
    public static Cable_Unit__c testCableUnit;
    public static Cable_Unit__c testCableUnit2;
    public static User user;
    
    @testSetup
    static void testData(){
        ServiceCenter_CustomSettings__c customsetting =new ServiceCenter_CustomSettings__c();
        customsetting.Name='Service_Center_SiteCoreURL';
        customsetting.Value__c='https://yousee.dk';
        insert customsetting;
        
        ServiceCenter_CustomSettings__c customsetting2 =new ServiceCenter_CustomSettings__c();
        customsetting2.Name='Contact Roles Bruger';
        customsetting2.Value__c='Selvbetjeningsbruger';
        insert customsetting2;
        
        Yousee13Campaign__c customsetting3 =new Yousee13Campaign__c();
        customsetting3.Name='Registration';
        customsetting3.SiteGuestUserId__c='005M0000004Odn8';
        customsetting3.Lead_RecordType__c='012M0000000CsDc';
        insert customsetting3;
        
        
        Lookup_Post_Code__c postcode= new Lookup_Post_Code__c();
        //postcode.PostCode_External_ID__c='7400';
        postcode.Name='7400';
        insert postcode;
        
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
        testCableUnit2.Name = 'test Ct';
        testCableUnit2.Cable_Unit_No__c = '1234567890';
        testCableUnit2.Potential_Installations__c = 68.0;
        testCableUnit2.Municipaly__c = '223 Hørsholm'; 
        testCableUnit2.Cable_Unit_Post_Code__c = '7400';
        testCableUnit2.Housing_Ownership__c = housingOwnerShip.Id;                      
        testCableUnit2.Housing_Type__c = housingType.Id;                     
        testCableUnit2.Building_Type__c = buildingType.Id;
        insert testCableUnit2;
        
        
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
        
        Lead lead1 = new Lead();
        lead1.FirstName = 'Tom';
        lead1.LastName = 'Jones';          
        lead1.Email = 'test@testaccount123.dk';
        lead1.Status = 'Åben';
        lead1.Unsubscribed__c = false;               
        lead1.Cable_Unit_1__c = testCableUnit2.Id;
        lead1.LeadSource = 'Service Center - Member registration';
        lead1.OwnerId= user.Id;
        lead1.Unsubscribed__c= true;
        insert lead1;
        
        
    }
    
    public static testmethod void testYouSee_O_customers_W2LTest(){
        
        Cable_Unit__c cu = [Select Id, cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'test CU'];
        System.debug('Test data cableUnitTest.Cable_Unit_No__c@@@@ '+cu.Cable_Unit_No__c);
        //System.debug('Test data cableunit.Cable_Unit_Post_Code__c#####'+ cu.Cable_Unit_Post_Code__c);
        PageReference form = new PageReference('Page.YouSee_O_customers_W2L_form');
        Test.setCurrentPageReference(form);
        
        ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
        YouSee_O_customers_W2L obj =new YouSee_O_customers_W2L();
       // obj.title='Title';
        obj.firstName='Theo';
        obj.lastName='Walcott';
        obj.email='tejas.naik@capgemini.com';
        obj.telephone='223344';
        obj.successmsg='tst';
        obj.saveLead();
        
     /*   Lead leadobj = new Lead();
        leadobj = [Select id,Cable_Unit_1__c from Lead where Cable_Unit_1__c=:cu.id ];
        System.debug('Lead obj id@@@' + leadobj.Cable_Unit_1__c);
        System.debug('cu id' + cu);
        System.assertequals(leadobj.Cable_Unit_1__c,cu.id);*/
        
    }
    
    public static testmethod void testYouSee_O_customers_W2LErrortest(){
        Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'test CU'  ];
        PageReference form = new PageReference('Page.YouSee_O_customers_W2L_form');
        Test.setCurrentPageReference(form);
        ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
        
        YouSee_O_customers_W2L obj2 =new YouSee_O_customers_W2L();
        obj2.validate();
        YouSee_O_customers_W2L obj3 =new YouSee_O_customers_W2L();
        obj3.firstName='Theo';
        obj3.validate();
        YouSee_O_customers_W2L obj4 =new YouSee_O_customers_W2L();
        obj4.firstName='Theo';
        obj4.lastName='Walcott';
        obj4.validate();
        YouSee_O_customers_W2L obj5 =new YouSee_O_customers_W2L();
        obj5.firstName='Theo';
        obj5.lastName='Walcott';
        obj5.email='tejas@cg.com';
        obj5.validate();
        
        YouSee_O_customers_W2L obj6 =new YouSee_O_customers_W2L();
        obj6.firstName='Theo';
        obj6.lastName='Walcott';
        obj6.email='tejas@cg';
        obj6.telephone='33445';
        obj6.validate();
        
    }
    
    public static testmethod void testYouSee_O_customers_W2Lleadpresenttest(){
       Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'test Ct'  ];
       PageReference form = new PageReference('Page.YouSee_O_customers_W2L_form');
       Test.setCurrentPageReference(form);
       ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
       User u1 = [SELECT Id FROM User WHERE Alias='trss'];
       System.RunAs(u1){
        YouSee_O_customers_W2L obj =new YouSee_O_customers_W2L();
        obj.firstName='Theo';
        obj.lastName='Walcott';
        obj.email='test@testaccount123.dk';
        obj.telephone='33445';    
        obj.validate();
        obj.Resendemail();
        obj.clearForm();
       }  
    
    
    }
    

}