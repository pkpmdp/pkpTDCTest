@isTest
public class BbGuestWebCaseFormControllertest {

 public static testMethod void doSubmittest()
 { 
     PageReference form = new PageReference('Page.WebCaseForm');
     Test.setCurrentPageReference(form);  
     
     BlockbusterGuestWebCaseFormController obj = new BlockbusterGuestWebCaseFormController();
     obj.fullURL = '';
     obj.department='Blockbuster';
     obj.origin ='Web - Blockbuster';
     obj.Blockbuster_system_information='system information';
     obj.test ='polycarp@aronallen.com';
     obj.selectHvad ='Andet';
     obj.description = '';
     obj.filename = '';
     obj.filebody = Blob.valueOf('abcdefg');
     obj.email ='sagar.madkaikar@capgemini.com';
     obj.name = 'test';
     obj.selectPlatform = 'PC/MAC';
     obj.selectBrowser = 'Google Chrome';
     obj.selectOpSys = 'Windows 7';
     obj.selectProduct = 'Afspilning';
     obj.strEmail = 'sagar.madkaikar@capgemini.com';
     obj.subject = 'test subject';
     obj.BBType = 'App';
     obj.Device = 'App';
     obj.HvadList = new List<SelectOption>(); 
     obj.product = '';
     obj.user = new User();
     obj.des = '';
 	 obj.Incoming = false;
     obj.Platform = 'PC/MAC';
 	 obj.triggerAutoResponseEmail = false;
     obj.returnUrl = ''; 

     obj.doSubmit();
     obj.getHvadOptions();
     obj.getHvilken1Options();
     obj.getHvilkenOptions(); 
     obj.description();
     obj.selectHvilken();
     
     obj.selectPlatform = 'PC/MAC';
     obj.getChildValue();
     obj.getPicklistValues();
     
     obj.selectPlatform = 'iPhone/iPad';
     obj.getChildValue();
     obj.getPicklistValues();
     
     obj.selectPlatform = 'Smart TV - LG';
     obj.getChildValue(); 
     obj.getPicklistValues();
     
     obj.selectPlatform = 'Android mobil/tablet'; 
     obj.getPicklistValues();
     
     obj.selectPlatform = 'Playstation 3'; 
     obj.getPicklistValues();
     
     obj.selectPlatform = 'Playstation 4'; 
     obj.getPicklistValues();
     
     obj.emailid();
     
     obj.selectHvilken='test';
     obj.selectHvilken1='test2';
     obj.selectHvad='Film eller serier';
     obj.doSubmit();
     
     
     obj.selectHvad='Min profil';
     obj.selectBrowser = 'Google CHrome';
     
     obj.doSubmit(); 
    
 }
    public static testMethod void validatetest()
    {
        Test.startTest();
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        PageReference form = new PageReference('Page.WebCaseForm');
     	Test.setCurrentPageReference(form);  
     
     	BlockbusterGuestWebCaseFormController obj = new BlockbusterGuestWebCaseFormController();
        obj.validate();
        obj.name = 'test';
         obj.validate();

        obj.selectPlatform = 'PC/MAC';
        obj.validate();
        obj.selectBrowser = 'Google Chrome';
        obj.selectOpSys  ='';
        obj.validate();
        obj.selectPlatform = 'iPhone/iPad';
        obj.selectOpSys = '';
        obj.validate();
        obj.Device = 'test';
        obj.validate();
        obj.BBType = 'App';
        obj.validate();
        obj.selectProduct = 'Afspilning via app';
        obj.validate();
        obj.subject = 'test';
        obj.validate();
        obj.strEmail = 'test.123';
        obj.validate();
        obj.strEmail = 'test@testing.com';
        obj.validate();
        obj.objwrap1 = new spoc2019cmp_cls();
        obj.validate();
        obj.objwrap1.selectMovie = 'test';
        obj.validate();
        obj.objwrap1.selectVidAud = 'Billede';
        obj.validate();
        obj.objwrap1.strPostnr = '1234';
        obj.validate();
        obj.objwrap1.strInterSupp = 'TBD';
        obj.validate();
        obj.objwrap1.strBBSpeed = 'test';
        obj.validate();
        obj.objwrap1.TimeOfInciMv = 'test';
        obj.validate();
        obj.objwrap1.TimeOfInciday = 'test';
        obj.validate();
        
        obj.objwrap1.selectIntCnType = 'Kabel';
        obj.validate();
        obj.doSubmit();
        Test.stopTest();
    }
    
    public static testmethod void testPickList()
    {
        
        
        Test.startTest();
        BBW2CPicklistValues.getPlatform();
        BBW2CPicklistValues.getBrowserForPCMac();
        BBW2CPicklistValues.getOSForPCMac();
        BBW2CPicklistValues.getProductForPCMac();
        BBW2CPicklistValues.getProductForIPhone();
        BBW2CPicklistValues.getBBTypeForIpad();
        BBW2CPicklistValues.getProductForAndroid();
        BBW2CPicklistValues.getProductForPS3();
        BBW2CPicklistValues.getIntSupplTV();     
        BBW2CPicklistValues.getIntConTypeIphone();
        BBW2CPicklistValues.getAudVidMac();
        BBW2CPicklistValues.getIntSupplMac();
        BBW2CPicklistValues.getIntConTypeMac();       
        BBW2CPicklistValues.getSmtTVUpdTV();
        
        
        
       
        Test.stopTest(); 
    }
    
    public static testmethod void testSPOC2019cmp()
    {
        spoc2019cmp_cls obj = new spoc2019cmp_cls();
        Test.startTest();
        obj.department = '';
        obj.description = '';
        obj.selectBrowser = '';
        obj.selectOpSys = '';
        obj.selectProduct = '';
        obj.strEmail = '';
        obj.subject = '';
        obj.filebody = '';
        obj.filename = '';
        obj.Device = '';
        obj.BBType = '';
        obj.selectMovie = '';
        obj.selectVidAud = '';
        obj.strPostnr = '';
        obj.strInterSupp = '';
        obj.strBBSpeed = '';
        obj.TimeOfInciMv = '';
        obj.TimeOfInciday = '';
        obj.strIp = '';
        obj.selectIntCnType = '';
        obj.selectSmtTVUpd = '';
        
        obj.listAudVidMac = BBW2CPicklistValues.getAudVidMac();
        obj.listIntSupplMac = BBW2CPicklistValues.getIntSupplMac();
        obj.listIntConTypeMac = BBW2CPicklistValues.getIntConTypeMac();       
        obj.listSmtTVUpd = BBW2CPicklistValues.getSmtTVUpdTV();
        obj.caseSave();
        
        Test.stopTest();
        
        
    }
    
    public static testmethod void testspoc2019compController()
    {
        Test.startTest();
        
        spoc2019compController obj = new spoc2019compController();
        obj.objwrap = new spoc2019cmp_cls();
        Test.stopTest();
    }
    
    
    


 }