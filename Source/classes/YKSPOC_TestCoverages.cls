/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
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
private class YKSPOC_TestCoverages {
    
    static User ykAdmin;
    static User yoAdmin;
    static User ykUser;
    static User yoUser;
    static User suUser;
    
    static YKAdminProfiles__c ykAdminProfiles;
    static YOProfilesNew__c yoProfiles;
    static YKProfilesNew__c ykProfiles;
    static SPOC1876_Profiles_New__c spocProfiles;
    //Start of SPOC 2113
    static YK_Views__c views;
    static ViewPortSettings__c vp;
     //End of SPOC 2113
    static CollaborationGroup yoBusiness;
    static CollaborationGroup ykBusiness;
    static CollaborationGroup Social;
    
    static YouSeeChatterGroups__c yoGroup;
    static YouSeeChatterGroups__c ykGroup;
    static YouSeeChatterGroups__c socialGroup;
    
    static YO_OperationConsultant__c ykInfoRecord;
    static YO_OperationConsultant__c bookingInfoRecord; 
    static YO_OperationConsultant__c vagtInfoRecord;
    static YO_OperationConsultant__c yotdsInfoRecord; 
    static YO_OperationConsultant__c vagtInfoTextRecord;
    static YO_OperationConsultant__c yotdsInfoTextRecord; 
    
    static RecordType ykInfo;
    static RecordType bookingInfo;
    static RecordType vagtInfoRt;
    static RecordType vagtInfoTextRt;
    static RecordType yotdsInfoRt;
    static RecordType yotdsInfoTextRt;
    
    static YOHomePage__c vagtInfo;
    static YOHomePage__c vagtInfoText;
    static YOHomePage__c yotdsInfo;
    static YOHomePage__c yotdsInfoText;
    
    static NewsArticle__c newsArticle;
    static News_Article_Post__c pc;
    static void createUser(){
          
        Profile[] profiles = new List<Profile>();
        
        profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee YK Pilot Administrator%'];
        if(!profiles.isEmpty()) {
            User ykpiotAdmin = new User(alias = 'ykAdmin', email='testClassYKAdmin@test.com',title='Mr',
                emailencodingkey='UTF-8', lastname='YkAdm', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profiles[0].Id,
                timezonesidkey='America/Los_Angeles', username='ykadminuser@test.com',MID__c = 'M87654');        
             insert ykpiotAdmin;
        }

         profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee YK Pilot User%'];  
         if(!profiles.isEmpty()) {
             User ykpiotUser = new User(alias = 'ykUser', email='testClassYKUser@test.com',title='Mr',
                emailencodingkey='UTF-8', lastname='YkUsr', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profiles[0].Id,
                timezonesidkey='America/Los_Angeles', username='ykuser@test.com',MID__c = 'M87655');        
             insert ykpiotUser;
         }


         profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee YO Pilot Administrator%'];
         if(!profiles.isEmpty()) {
             User yopiotAdmin = new User(alias = 'yoAdmin', email='testClassYKAdmin@test.com',title='Mr',
                emailencodingkey='UTF-8', lastname='YoAdm', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profiles[0].Id,
                timezonesidkey='America/Los_Angeles', username='yoadminuser@test.com',MID__c = 'M87656');        
             insert yopiotAdmin;
         }

         profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee YO Pilot User%'];     
         if(!profiles.isEmpty()) {
             User yopiotUser = new User(alias = 'yoUser', email='testClassYKUser@test.com',title='Mr',
                emailencodingkey='UTF-8', lastname='YoUsr', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profiles[0].Id,
                timezonesidkey='America/Los_Angeles', username='youser@test.com',MID__c = 'M87657');        
             insert yopiotUser;
         }
        //Start of SPOC 2113
         profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee SU User%'];     
         if(!profiles.isEmpty()) {
             User yoSuUser = new User(alias = 'yoUse', email='testClassYKUser@test.com',title='Mr',
                emailencodingkey='UTF-8', lastname='YoUsr', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profiles[0].Id,
                timezonesidkey='America/Los_Angeles', username='suuser@test.com',MID__c = 'M87658');        
             insert yoSuUser;
         //End of SPOC 2113
         }
        }
        
    static void fetchSettings(){
        //Start of SPOC 2113
        suUser =  [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee YO Super User' AND IsActive = True Limit 1]; // FOR PROD Environment
       //  suUser =  [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee SU User' AND IsActive = True Limit 1]; // FOR TEST Environment
        //End of SPOC 2113
        ykAdmin = [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee YK Pilot Administrator' AND IsActive = True Limit 1];
        //yoAdmin = [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee YO Super User' AND IsActive = True Limit 1];
        String SuperUser = System.Label.SPOC1876SuperUser;
        yoAdmin = [Select Name,Profile.Name,Id From User Where Profile.Name = :SuperUser AND IsActive = True Limit 1];
        
        ykUser = [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee YK Pilot User' AND IsActive = True Limit 1];
       String strUser = System.Label.SPOC1876User;
       // yoUser = [Select Name,Profile.Name,Id From User Where Profile.Name = 'YouSee YO User' AND IsActive = True Limit 1];
       yoUser = [Select Name,Profile.Name,Id From User Where Profile.Name = :strUser AND IsActive = True Limit 1];
        
        ykInfo = [SELECT Id FROM RecordType WHERE Name = 'YK Info' Limit 1];
        bookingInfo = [SELECT Id FROM RecordType WHERE Name = 'Booking Details' Limit 1];
        vagtInfoRt = [Select Id From RecordType WHERE Name = 'Vagt Info' Limit 1];
        vagtInfoTextRt = [Select Id From RecordType WHERE Name = 'Vagt Info Text' Limit 1];
        yotdsInfoRt = [Select Id From RecordType WHERE Name = 'YOTDS Info' Limit 1];
        yotdsInfoTextRt = [Select Id From RecordType WHERE Name = 'YOTDS Info Text' Limit 1];
    }
    
    static void createCustomSettings(){
        //start of SPOC 2113
        views = new YK_Views__c();
        String str = yoUser.Profile.Id;
        views.ViewId__c = str.substring(0,15);
        views.Name = 'yoUser';
        insert views;
        
        vp= new ViewPortSettings__c();
        vp.Name = '15 inch';
        vp.MaxViewPort__c = 900.0;
        vp.MinViewPort__c = 700.0;
        vp.NewsLimit__c = 17;
        insert vp;
        
        spocProfiles = new SPOC1876_Profiles_New__c();
        spocProfiles.Profiles__c = suUser.Profile.Name;
        spocProfiles.Name = suUser.Profile.Name;
        insert spocProfiles;
        //End of SPOC 2113
        ykAdminProfiles = new YKAdminProfiles__c();
        ykAdminProfiles.Profiles__c = ykAdmin.Profile.Name;
        ykAdminProfiles.Name = ykAdmin.Profile.Name;
        insert ykAdminProfiles;
        
        yoProfiles = new YOProfilesNew__c();
        yoProfiles.Profiles__c = yoAdmin.Profile.Name;
        yoProfiles.Name = yoAdmin.Profile.Name;
        insert yoProfiles;
        
        yoProfiles = new YOProfilesNew__c();
        yoProfiles.Profiles__c = yoUser.Profile.Name;
        yoProfiles.Name = yoUser.Profile.Name;
        insert yoProfiles;
        
        ykProfiles = new YKProfilesNew__c();
        ykProfiles.Profiles__c = ykUser.Profile.Name;
        ykProfiles.Name = ykUser.Profile.Name;
        insert ykProfiles;
        
        ykProfiles = new YKProfilesNew__c();
        ykProfiles.Profiles__c = ykAdmin.Profile.Name;
        ykProfiles.Name = ykAdmin.Profile.Name;
        insert ykProfiles;
        
        vagtInfo = new YOHomePage__c();
        vagtInfo.Name = 'Vagt Info';
        vagtInfo.RecordTypeId__c = vagtInfoRt.Id;
        insert vagtInfo;
        
        vagtInfoText = new YOHomePage__c();
        vagtInfoText.Name = 'Vagt Info Text';
        vagtInfoText.RecordTypeId__c = vagtInfotextRt.Id;
        insert vagtInfoText;
        
        yotdsInfo = new YOHomePage__c();
        yotdsInfo.Name = 'YOTDS Info';
        yotdsInfo.RecordTypeId__c = yotdsInfoRt.Id;
        insert yotdsInfo;
        
        yotdsInfoText = new YOHomePage__c();
        yotdsInfoText.Name = 'YOTDS Info Text';
        yotdsInfoText.RecordTypeId__c = yotdsInfoTextRt.Id;
        insert yotdsInfoText;
    }
    
    static void createChatterGroups(){
        yoBusiness = new CollaborationGroup();
        yoBusiness.Name = 'YO Business';
        yoBusiness.CollaborationType = 'Private';
        insert yoBusiness;
        
        ykBusiness = new CollaborationGroup();
        ykBusiness.Name = 'YK Business';
        ykBusiness.CollaborationType = 'Private';
        insert ykBusiness;
        
        Social = new CollaborationGroup();
        Social.Name = 'Social';
        Social.CollaborationType = 'Private';
        insert Social;
        
        yoGroup = new YouSeeChatterGroups__c();
        yoGroup.GroupId__c = yoBusiness.Id;
        yoGroup.Name = 'YO Business';
        insert yoGroup;
        
        ykGroup = new YouSeeChatterGroups__c();
        ykGroup.GroupId__c = ykBusiness.Id;
        ykGroup.Name = 'YK Business';
        insert ykGroup;
        
        socialGroup = new YouSeeChatterGroups__c();
        socialGroup.GroupId__c = Social.Id;
        socialGroup.Name = 'Social';
        insert socialGroup;
    }
    
    static void createData(){
        ykInfoRecord = new YO_OperationConsultant__c();
        ykInfoRecord.Information__c = 'testing';
        ykInfoRecord.RecordTypeId = ykInfo.Id;
        ykInfoRecord.User__c=userinfo.getUserId();
        insert ykInfoRecord;
        
        bookingInfoRecord = new YO_OperationConsultant__c();
        bookingInfoRecord.Information__c = 'testing';
        bookingInfoRecord.RecordTypeId = bookingInfo.Id;
        bookingInfoRecord.User__c=userinfo.getUserId();
        insert bookingInfoRecord;
        
        vagtInfoRecord = new YO_OperationConsultant__c();
        vagtInfoRecord.Information__c = 'testing';
        vagtInfoRecord.RecordTypeId = vagtInfoRt.Id;
        vagtInfoRecord.User__c = yoUser.Id;
        vagtInfoRecord.onDuty__c = true;
        insert vagtInfoRecord;
        
        yotdsInfoRecord = new YO_OperationConsultant__c();
        yotdsInfoRecord.Information__c = 'testing';
        yotdsInfoRecord.RecordTypeId = yotdsInfoRt.Id;
        yotdsInfoRecord.User__c = yoUser.Id;
        yotdsInfoRecord.onDuty__c = true;
        insert yotdsInfoRecord;
        
        vagtInfoTextRecord = new YO_OperationConsultant__c();
        vagtInfoTextRecord.Information__c = 'testing';
        vagtInfoTextRecord.RecordTypeId = vagtInfoTextRt.Id;
        vagtInfoTextRecord.User__c=userinfo.getUserId();
        insert vagtInfoTextRecord;
        
        yotdsInfoTextRecord = new YO_OperationConsultant__c();
        yotdsInfoTextRecord.Information__c = 'testing';
        yotdsInfoTextRecord.RecordTypeId = yotdsInfoTextRt.Id;
        yotdsInfoTextRecord.User__c=userinfo.getUserId();
        insert yotdsInfoTextRecord;
        
        newsArticle = new NewsArticle__c();
        newsArticle.Department__c = 'YO';
        newsArticle.Teaser__c = 'teaser...';
        newsArticle.Priority__c = True;
        newsArticle.Article__c = 'helloo!!!';
        newsArticle.Stop_Featuring__c = Date.today() + 5;
        newsArticle.Post_in_Chatter__c = true;
       
        insert newsArticle;
        
        CollaborationGroup cg = new CollaborationGroup();
        cg.CollaborationType = 'private';
        cg.Description = 'Velkommen SPOC Superbrugere til Chatter! Dette forum giver os nye muligheder for at sparre med hinanden, dele viden og holde os opdaterede med, hvad der rører sig i grupperne og organisationen. God fornøjelse!';
        cg.Name = 'SPOC superbrugere YKRs';
        insert cg;
        
        FeedItem fi  = new FeedItem();
        fi.Body = 'test';
        fi.Type = 'TextPost';
        fi.ParentId = cg.Id;
        insert fi;
        
        pc =new   News_Article_Post__c ();
        pc.Chatter_Post_Id__c= fi.Id;
        pc.News_Article__c = newsArticle.Id;   
        insert pc;
        
       
    }
    
    // Test Method for KnowledgeHome_Controller class
    static testMethod void KnowledgeHome_Controller_Test(){

        createUser();  
        fetchSettings();
        createCustomSettings();
        createChatterGroups();
        createData();

        system.runAs(ykUser){
            KnowledgeHome_Controller home = new KnowledgeHome_Controller();
        }
        
        system.runAs(yoUser){       
            KnowledgeHome_Controller home = new KnowledgeHome_Controller();
        }
        
        system.runAs(ykAdmin){
            KnowledgeHome_Controller home = new KnowledgeHome_Controller();
        }
        
        system.runAs(yoAdmin){      
            KnowledgeHome_Controller home = new KnowledgeHome_Controller();
        }
        //start of SPOC 2113
         system.runAs(suUser){
             ApexPages.currentPage().getParameters().put('tab', 'YK');
            KnowledgeHome_Controller home = new KnowledgeHome_Controller();
             home.test = '';
        }
        //End of SPOC 2113
        
    }
    
    // Test method for tgrNewsArticle trigger
    static testMethod void tgrNewsArticle_Test(){
        NewsArticle__c news1 = new NewsArticle__c();
        news1.Post_in_Chatter__c = true;
        news1.Teaser__c = 'testing...';
        news1.Department__c = 'YO;YK';
        insert news1;
    }
    
    // Test Method for LatestNews class
    static testMethod void testLatestNews() {
        //start of SPOC 2113
        NewsArticle__c news1 = new NewsArticle__c();
        news1.Post_in_Chatter__c = true;
        news1.Teaser__c = 'testing...';
        news1.Article__c = '<table><tr><td><img src="login.jpg"></img></td></tr></table>';
        news1.Department__c = 'YO;YK';
        news1.Category__c = 'Clear';
        insert news1;
        
        NewsArticle__c news2 = new NewsArticle__c();
        news2.Post_in_Chatter__c = true;
        news2.Teaser__c = 'testing...';
        news2.Article__c = '<img src="login.jpg"></img>';
        news2.Department__c = 'YO;YK';
        news2.Category__c = 'Clear';
        insert news2;
        NewsArticle__c news3 = new NewsArticle__c();
        news3.Post_in_Chatter__c = true;
        news3.Teaser__c = 'testing...';
        news3.Article__c = 'test';
        news3.Department__c = 'YO;YK';
        news3.Category__c = 'Clear';
        insert news3;
        
        NewsArticle__c news4 = new NewsArticle__c();
        news4.Post_in_Chatter__c = true;
        news4.Teaser__c = 'testing...';
        news4.Article__c = '<table><tr><td><img src="login.jpg"></img></td></tr></table>';
        news4.Department__c = 'YO;YK';
        insert news4;
        
        NewsArticle__c news5 = new NewsArticle__c();
        news5.Post_in_Chatter__c = true;
        news5.Teaser__c = 'testing...';
        news5.Article__c = '<img src="login.jpg"></img>';
        news5.Department__c = 'YO;YK';
        insert news5;
        
        NewsArticle__c news6 = new NewsArticle__c();
        news6.Post_in_Chatter__c = true;
        news6.Teaser__c = 'testing...';
        news6.Article__c = 'test';
        news6.Department__c = 'YO;YK';
        insert news6;
        
         createUser();  
         fetchSettings();
        createCustomSettings();
        createChatterGroups();
        createData();
        
        test.startTest();
        KnowledgeHome_Controller home = new KnowledgeHome_Controller();
        KnowledgeHome_Controller home1 = new KnowledgeHome_Controller();
        LatestNews l;
        LatestNews l2 = new LatestNews(home1); 
        system.runas(yoUser) {
             LatestNews l1 = new LatestNews(home1); 
        }
        system.runas(ykUser) {
             l = new LatestNews(home);  
        }
        system.runas(suUser) {
             l = new LatestNews(home);  
        }
        system.runas(yoUser) {
             ApexPages.currentPage().getParameters().put('tab', 'YO');
             l = new LatestNews(home); 
             l.viewPortHeight = 800;
             l.newsDepartment = 'YO';
             l.getNewsArticles();
             l.getListDepartmentType();
            l.newsDepartmentSelected = '';
            String html=  '<html><head>Test</head><body>test class <br/> of SPOC 2113 <body></html>';
            l.convertHTMLtoText(html);
            boolean a = l.ShouldDisplay;
        }
        //End of SPOC 2113
        system.runas(ykUser) {
             ApexPages.currentPage().getParameters().put('tab', 'YK');
             l = new LatestNews(home);  
        }
        
        system.runas(yoAdmin) {
            l = new LatestNews(home);   
        }
        
        system.runAs(ykAdmin) {
            l = new LatestNews(home);
        } 
        test.stopTest();
    }
    
    // Test Method for YKSpocUtils class
    static testMethod void testUtils()
    {

       createUser();  
       fetchSettings();
        createCustomSettings();
        createChatterGroups();
        createData();
        
        test.startTest();
     
        // get a user with a YK Admin profile
        system.assertEquals(YKSpocUtils.isYKAdmin(ykAdmin.Id), true);
        
        // the method should return false for a non admin yk user
        system.assertEquals(YKSpocUtils.isYKAdmin(ykUser.Id), false);
        
        YKSpocUtils.getDepartmentType();
        
        // get a user with a YK Admin profile
        system.assertEquals(YOSpocUtils.isYOAdmin(ykAdmin.Id), false);
        test.stopTest();
 }
 
    //Test Method for chatterFeedsController class
    static testMethod void testchatterFeedsController(){    
        createUser();
        fetchSettings();
        createCustomSettings();
        createChatterGroups();
        createData();
        chatterFeedsController chatterFeedContrl; 
        
        system.runas(yoUser){
            chatterFeedContrl = new chatterFeedsController();
        }
        
        system.runas(ykUser){
            chatterFeedContrl = new chatterFeedsController();
        }
        
        system.runas(yoAdmin){
            chatterFeedContrl = new chatterFeedsController();
        }
        
        system.runas(ykAdmin){
            chatterFeedContrl = new chatterFeedsController();
        }
    }
    
    @isTest (SeeAllData = TRUE)
    // Test Method for KnowledgeHomeSidebar_CT
    static void testKnowledgeHomeSidebar_CT(){
        
        //createCustomSettings();
        //createChatterGroups();

        createUser();  
        fetchSettings();
        createData();
        
        ApexPages.currentPage().getParameters().put('viewId', 'YKINFO');
        KnowledgeHomeSidebar_CT KHS = new KnowledgeHomeSidebar_CT();
        KHS.viewId = 'YKINFO';
        KHS.getPageLoad();
        
        ApexPages.currentPage().getParameters().put('viewId', 'BKINFO');
        KHS = new KnowledgeHomeSidebar_CT();
        KHS.viewId = 'BKINFO';
        KHS.getPageLoad();
        
        ApexPages.currentPage().getParameters().put('viewId', 'YOTDS');
        KHS = new KnowledgeHomeSidebar_CT();
        KHS.viewId = 'YOTDS';
        KHS.getPageLoad();
        
        ApexPages.currentPage().getParameters().put('viewId', 'VAGT');
        KHS = new KnowledgeHomeSidebar_CT();
        KHS.viewId = 'VAGT';
        KHS.getPageLoad();
    }
    
    // Test Method for DisplayNewsFeedController
    static testMethod void testDisplayNewsFeedController(){
        
       
   
         
        createUser();
        fetchSettings();
        createCustomSettings();
        createChatterGroups();
        createData();
        
        ApexPages.Standardcontroller std = new ApexPages.Standardcontroller(newsArticle);
        DisplayNewsFeedController feedController = new DisplayNewsFeedController(std);
    }
    
    // Test Method for PostNewsInChatter
    static testMethod void testPostNewsInChatter(){
        createChatterGroups();
        
        NewsArticle__c YOnews = new NewsArticle__c();
        YOnews.Post_in_Chatter__c = true;
        YOnews.Teaser__c = 'testing...YO';
        YOnews.Department__c = 'YO';
        insert YOnews;
        
        NewsArticle__c YKnews = new NewsArticle__c();
        YKnews.Post_in_Chatter__c = true;
        YKnews.Teaser__c = 'testing...YK';
        YKnews.Department__c = 'YK';
        insert YKnews;
        System.debug('YOGroup =>'+YouSeeChatterGroups__c.getValues('YO Business'));
        test.startTest();
        PostNewsInChatter post = new PostNewsInChatter();
        post.updateChatter();
        test.stopTest();
    }
    
}