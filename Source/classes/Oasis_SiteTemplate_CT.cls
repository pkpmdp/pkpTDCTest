/*********************************************
*	class Oasis_SiteTemplate_CT
*	
*	Controller for the Oasis Site Template. 
*	Checks if the current user is authenticated. 
*	If not sends him to login page. Also controls
*	the welcome widget on the nav bar.
*********************************************/
public class Oasis_SiteTemplate_CT {	
	public String OASIS_GUEST_USER = 'Oasis Site Guest User';
	public Oasis_User__c oUser {get; set;}

	public Oasis_SiteTemplate_CT()
	{		
						
	}	
		
	public Pagereference onPageLoad()
	{
		// check if oasis cookie present		
		// if yes get user info from the cookie		
		// else redirect user to the login page
		
		oUser = Oasis_Utils.getOasisUser(ApexPages.currentPage());
		system.debug('oUser>>>>:' + oUser);
		
				
		// if the oasis user is null, redirect to login page
		if(oUser == null) {
			String referrer = Apexpages.currentPage().getUrl().toLowerCase();
			
			// if current page is login, do not redirect again, as it creates a loop.
			if(!referrer.contains('login')) {
				PageReference pageRef = new PageReference(Site.getCurrentSiteUrl() 
															+ 'oasis_SiteLogin' + '?retURL=' + Encodingutil.urlEncode(referrer,'UTF-8')); 
				system.debug('Pageference>>>>' + pageRef);
				return pageRef;
			}				
		}	
		
		return null;	
	}
	
	
	
	public PageReference logout(){
		// call method to expire the cookie
		Oasis_Utils.setCookieExpiration(Oasis_Utils.OASIS_COOKIE_NAME);
		return new PageReference(Site.getPrefix()+'/secur/logout.jsp');
	}
	
}