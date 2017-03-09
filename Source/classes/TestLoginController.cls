public class TestLoginController{
    public String username {get; set;}
    public String password {get; set;}
    public boolean displayFlag {get;set;}
    public boolean displaySentMailMsg {get;set;}
    public String dispMessage {get;set;}
	public String SiteLoginCS{get; set;}
	public Boolean siteLoginEnabled{get; set;}
	public String siteCoreUrl {get;set;}
    public String sfUrl{get; set;}
    public Boolean issueFlag{get; set;} //Added for SPOC-2345
    public List<String> issueList{get; set;} //Added for SPOC-2345
    public PageReference login() { 
        //String startUrl = System.currentPageReference().getParameters().get('startURL');
        dispMessage = '';
        displayFlag = true;  
        displaySentMailMsg = false;
        return Site.login(username, password, '/apex/ViewCableUnitsHomePage');
    }
    
       public TestLoginController () {
           issueList = new List<String>();
       		string maintenanceFlag;
       		displayFlag = true;      
            displaySentMailMsg = false;
           sfUrl = URL.getSalesforceBaseUrl().toExternalForm();
            siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
//            SiteLoginCS = Site_Login__c.getInstance(UserInfo.getProfileId()).Text_Message__c;
//            siteLoginEnabled = Site_Login__c.getInstance(UserInfo.getProfileId()).DisplayMessage__c;
			  SiteLoginCS = ServiceCenter_CustomSettings__c.getInstance('Maintenance_Message').Value__c;
			  maintenanceFlag = ServiceCenter_CustomSettings__c.getInstance('SC_Login_Access').Value__c;
			 if(maintenanceFlag != null && maintenanceFlag != ''){
				  if (maintenanceFlag.equalsIgnoreCase('true')){
	              		siteLoginEnabled = true;
				  }else{
				  		siteLoginEnabled = false;
				  }
       		}else
       			siteLoginEnabled = false;
           //Added for SPOC-2345
           String scIssueFlag = ServiceCenter_CustomSettings__c.getInstance('SC_Issue_Flag').Value__c;
           issueList = System.Label.SC_Issue_List.split(';');
           if(scIssueFlag != null && scIssueFlag != ''){
               if(scIssueFlag.equalsIgnoreCase('true'))
                   issueFlag = true;
              else
                   issueFlag = false;
           }else
               issueFlag = false;
           // SPOC-2345 END
       }
    public static testMethod void testTestLoginController () {
       TestLoginController controller = new TestLoginController();
        controller.DisplayForgotPwd();
        controller.forgotPassword();
        String str = 'snesalun';
        controller.login();
      
    }   
    public PageReference DisplayForgotPwd() {
        displayFlag = false;
        return null;
    }  
    public PageReference forgotPassword() {
      boolean success = Site.forgotPassword(username);
      
      
      if (success) {  
        displaySentMailMsg = true; 
        displayFlag = true;      
        dispMessage=System.Label.site.temp_password_sent;
      }
      else
      {
          displayFlag = false;
//          displaySentMailMsg = true;
          dispMessage = 'Could not sent the mail';
       }
      return null;
    } 
}