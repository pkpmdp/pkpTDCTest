@isTest
public class scYousee_Store_Links_Controller_New_Test
{
    public  static Cable_Unit__c cableUnitTest;
    public static User user;
    public static User user1;
    
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
        
        cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Cable_Unit_No__c='0000000570';
        insert cableUnitTest;
        
        String leadownerId = UserInfo.getUserId();
        
        Cable_Unit__c cu = [Select cu.Cable_Unit_No__c, cu.Id from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
        
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
        
         user1=new User();  
        user1.Username='testvps@test.com';
        user1.LastName='testLName';
        user1.Email='testvps@test.com';
        user1.Alias='trvps';
        user1.CommunityNickname='trsts';
        user1.TimeZoneSidKey='Europe/Paris';
        user1.LocaleSidKey='da_DK';  
        user1.EmailEncodingKey='ISO-8859-1';
        user1.ProfileId='00e20000000v9G1AAI';
        user1.LanguageLocaleKey='da';           
        user1.MID__c='133';
        user1.IsActive=true;        
        insert user1;
    }
    
    public static testmethod void testscYousee_Store_Links_Controller_New_Test()
    {
        Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
        PageReference form = new PageReference('Page.scYousee_Store_Links_New');
        Test.setCurrentPageReference(form);
        ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
        scYousee_Store_Links_Controller_New obj = new scYousee_Store_Links_Controller_New();
        obj.LinkInput = 'www.google.com';
        obj.Category = 'Regler for Bland Selv Tv';
        obj.Comment = 'Test Comment';
        //obj.pgactionfun();
        obj.onSubmit();
        Links__C linka = [select id from links__c where URL__c = 'www.google.com' limit 1];
        obj.linkId = linka.id;
        obj.editLink();
        obj.onSubmit();
        obj.delLink();
        obj.getCategoryAll();
        obj.getCableUnitName();
        obj.displayPopup = true;
        obj.closePopup();
        obj.showPopup();
        
        obj.isUpdateLink = false;
        obj.LinkInput = 'www.google.com';
        obj.Category = null;
        obj.Comment = 'Test Comment';
        obj.onSubmit();
        
        list<Links__c> listLinks = [select id from Links__c];
        delete listLinks;
        
        obj.LinkInput = 'www.google.com';
        obj.Category = 'Regler for Bland Selv Tv';
        obj.Comment = 'Test Comment';
        obj.onSubmit();
        obj.LinkInput = 'www.google.com';
        obj.Category = 'Regler for Bland Selv Tv';
        obj.Comment = 'Test Comment';
        obj.onSubmit();
        
        list<Links__c> listLinks1 = [select id from Links__c];
        delete listLinks1;
        /*obj.LinkInput = 'www.yahoo.com';
        obj.Category = 'Priser';
        obj.Comment = 'Test Comment';
        obj.onSubmit();*/
      /*  Links__C linka1 = [select id from links__c limit 1];
        obj.linkId = linka1.id;
        obj.isUpdateLink = true;
        obj.onSubmit();*/
    }
}