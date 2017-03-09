/******************************************************
*	class Oasis_ChangePassword_CT
*	
*	Controller for the change password page.
******************************************************/
public class Oasis_ChangePassword_CT {
	public String oldPassword {get; set;}
	public String newPassword {get; set;} 
	public Oasis_User__c oUser {get; set;}
		
	public Oasis_ChangePassword_CT()
	{
		
		
	}
	
	public pageReference changePassword()
	{
		Site.changePassword(newPassword, newPassword, oldPassword);
		return null;
	}
	
	
}