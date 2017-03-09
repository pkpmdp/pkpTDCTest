public with sharing class SCChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}      
    public String siteCoreUrl {get;set;}   
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
     public SCChangePasswordController() {
     	siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
     }
     
     @IsTest(SeeAllData=true) public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        SCChangePasswordController controller = new SCChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}