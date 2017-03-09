public class ChangePasswordController{
    
 
    public User loggedInUser {get;set;}
    public string newpwd {get;set;}
    public string confirmpwd {get;set;}
    public boolean changePwdSection {get;set;}
    public boolean pwdChangeMsg {get;set;}
    public string confirmMsg {get;set;}
    public boolean status=false;
    
    public Pagereference changePassword()
    {
        status = false;
        
        if(!newpwd.equals(confirmpwd)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Password er ikke ens');
            ApexPages.addMessage(msg);
        }
        else{
            ApexPages.Message msg = null;
            try
            {
                pwdChangeMsg = true;
                System.setPassword(loggedInUser.Id, newpwd);
                changePwdSection = false;
                confirmMsg = 'Password er ændret succesfuldt';
                msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Password er ændret succesfuldt');
                status = true;
                ApexPages.addMessage(msg);
                return null;
            }
            catch(System.InvalidParameterValueException  ex)
            {
            	if(ex.getMessage().contains('invalid repeated password')){
            		msg = new ApexPages.Message(ApexPages.Severity.Error, 'Du kan ikke bruge tidligere passwords');
            	}else{
            		msg = new ApexPages.Message(ApexPages.Severity.Error, 'Ugyldigt password. Password skal indeholde minimum 8 karakterer og indeholde både tal og bogstaver');
            	}	
                newpwd = null;
                ApexPages.addMessage(msg);
            }
            catch(Exception ex)
            {
                msg = new ApexPages.Message(ApexPages.Severity.Error, 'Change Password failed.Please try after sometime. ');
                newpwd = null;
                ApexPages.addMessage(msg);
            }
        }    
        return null;
    }
    
    public void pwdChangeAction()
    {
        changePwdSection = true;
        pwdChangeMsg = false;
        newpwd=null;
    }
    
    
    public ChangePasswordController(ApexPages.StandardController controller){
    }
    public ChangePasswordController(){
            loggedInUser = [select Username from User where id= :Userinfo.getUserId()];
    }

    public PageReference backToHomePage(){
        String newPageUrl ='/apex/forhandlerHomePage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.getParameters().put('status',string.valueof(status));
        newPage.setRedirect(true);
        return newPage;
    }

    
}