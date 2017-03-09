@isTest
private class ChangePasswordControllerTestClass{

   static ChangePasswordController changePasswordController=new ChangePasswordController();
    static User user;
    static testmethod void changePasswordTest(){        
        changePasswordController.newpwd='new_pass#123';
        changePasswordController.confirmpwd='new_pass#123';
        changePasswordController.changePassword();
    }
    
    static testmethod void changePasswordWithNullUserTest(){ 
        changePasswordController.loggedInUser = user;       
        changePasswordController.newpwd='';
        changePasswordController.confirmpwd='';
        changePasswordController.changePassword();
    }
    
    static testmethod void changePasswordMismatchTest(){
        changePasswordController.newpwd='new_pass#123';
        changePasswordController.confirmpwd='new_pass123';
        changePasswordController.changePassword();    
    }
    
    static testmethod void changePasswordMiminum8Test(){ 
        changePasswordController.loggedInUser = user;       
        changePasswordController.newpwd='n';
        changePasswordController.confirmpwd='n';
        changePasswordController.changePassword();
    }
    
    static testmethod void passwordChangeCalledTest(){
        changePasswordController.pwdChangeAction();
    }
    
    static testmethod void backToHomePageTest(){
        changePasswordController.backToHomePage();
    }

}