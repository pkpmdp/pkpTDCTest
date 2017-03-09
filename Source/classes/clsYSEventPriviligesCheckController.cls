public with sharing class clsYSEventPriviligesCheckController {


    private Profile YS_Sales_User;
    private Profile YS_Sales_Super_User;
    private Profile YS_Sales_User_Klage;
    private Profile YS_Sales_KundeInfo_User; 
   
     
    private final ApexPages.StandardController controller;  
    
    public clsYSEventPriviligesCheckController(ApexPages.StandardController controller) {
        this.controller = controller;
        getRecordTypes();      
    }    
    
    public PageReference getRedir(){
      PageReference newPage;
        System.debug('UserInfo=>'+UserInfo.getProfileId());
        if ((YS_Sales_User!=null && UserInfo.getProfileId() == YS_Sales_User.Id) ||
            (YS_Sales_Super_User!=null && UserInfo.getProfileId() == YS_Sales_Super_User.Id) ||
            (YS_Sales_User_Klage!=null && UserInfo.getProfileId() == YS_Sales_User_Klage.Id) ||
            (YS_Sales_KundeInfo_User!=null && UserInfo.getProfileId() == YS_Sales_KundeInfo_User.Id)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Begivenheder skal oprettes i Outlook og efterfølgende tilknyttes kundedata i CRM via klientprogrammet'));
             
             newPage = this.controller.view(); 
             return newPage.setRedirect(true);                                              
            } 
            else{
              String retURL = ApexPages.currentPage().getParameters().get('retURL');
          newPage = new PageReference('/00U/e?retURL=' + retURL);
            newPage.getParameters().put('nooverride', '1');
            return newPage.setRedirect(true);
            }
        }
   
    
    public void getRecordTypes() {
       List<Profile> YS_Sales_Super_User_List=new List<Profile>();
       YS_Sales_Super_User_List=[Select Id from Profile where Name = 'YouSee Sales Super User'];
       if(YS_Sales_Super_User_List.size()>0)
        YS_Sales_Super_User=YS_Sales_Super_User_List[0];
       
       List<Profile> YS_Sales_KundeInfo_User_List=new List<Profile>();
       YS_Sales_KundeInfo_User_List=[Select Id from Profile where Name = 'YouSee Sales User/Klage'];
       if(YS_Sales_KundeInfo_User_List.size()>0)
        YS_Sales_KundeInfo_User=YS_Sales_KundeInfo_User_List[0];
       
       
      YS_Sales_User = [Select Id from Profile where Name = 'YouSee Sales User'];
      //YS_Sales_Super_User = [Select Id from Profile where Name = 'YouSee Sales Super User'];
      YS_Sales_User_Klage = [Select Id from Profile where Name = 'YouSee Sales KundeInfo User'];
     // YS_Sales_KundeInfo_User = [Select Id from Profile where Name = 'YouSee Sales User/Klage'];        
    }
    public static PageReference pageRef;
    public static ApexPages.standardController stdCtrl;
    public static PageReference newPageRef;
    public static testMethod void testController(){
      clsYSEventPriviligesCheckController controller = null;
      User YSSalesUser = [Select Id from User where username like :System.Label.DUMMY_Sales_User+'%'];
      Event event = new Event();
      event.DurationInMinutes = 10;
      event.ActivityDateTime = DateTime.now();
      
      insert event;      
      System.runAs(YSSalesUser) {
        pageRef = Page.YSEventPriviligesCheck;        
        Test.setCurrentPage(pageRef);        
        ApexPages.currentPage().getParameters().put('retURL', Page.YSEventPriviligesCheck.getUrl());
        stdCtrl = new ApexPages.standardController(event);
        controller = new clsYSEventPriviligesCheckController(stdCtrl);
        newPageRef = controller.getRedir();
        System.debug('newPageRef =>'+newPageRef);
        System.assertEquals(Page.YSEventPriviligesCheck.getUrl()+'?retURL='+EncodingUtil.urlEncode(Page.YSEventPriviligesCheck.getUrl(),'UTF-8'), ApexPages.currentPage().getUrl());
      }
      
      User yoUser = [Select Id From User Where username like :System.Label.DUMMY_SU_User+'%'];
      System.runAs(yoUser){
            pageRef = Page.YSEventPriviligesCheck;        
            Test.setCurrentPage(pageRef);        
            ApexPages.currentPage().getParameters().put('retURL', Page.YSEventPriviligesCheck.getUrl());
            stdCtrl = new ApexPages.standardController(event);
            controller = new clsYSEventPriviligesCheckController(stdCtrl);
            newPageRef = controller.getRedir();
        	System.debug('newPageRef =>'+newPageRef);
            System.assertEquals('/00U/e?nooverride=1&retURL='+EncodingUtil.urlEncode(Page.YSEventPriviligesCheck.getUrl(),'UTF-8'), newPageRef.getUrl());
        }  
    }
}