/**
* This class implements the controller part of the MVC pattern for the Share On Widget.
*/
public with sharing class IWLShareOnWidgetController extends IWLBaseWidgetController {  

	public static String SHAREON_URL = 'javascript: window.open( \'{0}\' ,null, \'toolbar=0, location=0, directories=0, status=0, menubar=0, scrollbars=0, resizable=0, width=650, height=450\');void(0);';
	public static String SHAREON_TYPE_FACEBOOK {get{ return 'Facebook';} set;}
	public static String SHAREON_TYPE_TWITTER {get{ return 'Twitter';} set;}
	public static String SHAREON_TYPE_LINKEDIN {get{ return 'Linkedin';} set;}
	public static String SHAREON_TYPE_MAIL {get{ return 'Email';} set;}
    public static String FACEBOOK_SHARE_URL = 'https://www.facebook.com/sharer/sharer.php?u=';
    public static String TWITTER_SHARE_URL = 'https://twitter.com/intent/tweet?source=tweetbutton&url=';
    public static String LINKEDIN_SHARE_URL = 'http://www.linkedin.com/shareArticle?mini=true&ro=false&trk=bookmarklet&title=';
     
    
	public String IdeaId							{get; set;}
	public String url								{get; set;}

	/**
	* This method overrides the one in IWLBaseWidgetController in order to implement the 
	* widget-specific load procedure of the widget's specs and information. 
	* @return true iif the load process was successful.
	*/
    protected override Boolean doLoad() {
    	if (widgetRecord.Type__c == IWLCodeSettings.ShareOnRecordTypeName) {
    		//the widgetRecord exists and is of the correct type for this widget
    		String i1 = String.escapeSingleQuotes( IdeaId );
    		String title = '';
    		//retrieve the idea to be shared.
			List<sObject> i = new List<sObject>();
			
			if( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel ) {
				i = Database.query( 'SELECT Id, Title FROM Idea WHERE Id = \'' + i1 + '\' LIMIT 1' );
				title = String.valueOf( i.get(0).get('Title') );
			}else if( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistUserLabel ) {
				i = Database.query( 'SELECT Id, Name FROM User WHERE Id = \'' + i1 + '\' LIMIT 1' );
				title = String.valueOf( i.get(0).get('Name') );
			}else if( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel ) {
				i = Database.query( 'SELECT Id, Title FROM IdeaTheme WHERE Id = \'' + i1 + '\' LIMIT 1' );
				title = String.valueOf( i.get(0).get('Title') );
			}
			if( i.size() > 0 ){
				//the idea was found
				
				//Depending on the shareon_type field, we will build different urls to share the idea.
				//We will also set default images for the different media where the idea will be posted 
				//if the user has not specified one in the widget's configuration.
				if( widgetRecord.ShareOn_Type__c == SHAREON_TYPE_FACEBOOK ){
					url = SHAREON_URL.replace( '{0}', FACEBOOK_SHARE_URL + detailPageBaseUrl + IdeaId + '&t=' + title );
				}else if(  widgetRecord.ShareOn_Type__c == SHAREON_TYPE_TWITTER ){
					url = SHAREON_URL.replace( '{0}', TWITTER_SHARE_URL + detailPageBaseUrl + IdeaId + '&text=' + title );
				}else if(  widgetRecord.ShareOn_Type__c == SHAREON_TYPE_LINKEDIN ){
					url = SHAREON_URL.replace( '{0}', LINKEDIN_SHARE_URL + title + '&url=' + detailPageBaseUrl + IdeaId + '' );
				}else if(  widgetRecord.ShareOn_Type__c == SHAREON_TYPE_MAIL ){
					url = 'mailto:?subject=' + title + '&body=' +  Label.IWL_EMAIL_MESSAGE.replace('{0}', widgetRecord.Origin__c) + ' ' + title + ' ' + detailPageBaseUrl + IdeaId+'';
				}
				return true;//mark the widget as correctly initialized
			} else {
				LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TO_SHARE;
				return false;
			}
			
		} else {
			//the widgetRecord has a wrong type.
			LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
			return false;
		}		
    }

	/**
	* This method build the base Url for the widget's shared url, based on widgetRecord's detailPageUrl__c field.
	* @return a String representing the url for the idea/idea theme's detail page 
	*/
	public String detailPageBaseUrl {
		get {
			if( this.detailPageBaseUrl == null ) {
				if( widgetRecord.detailPageUrl__c != null && widgetRecord.detailPageUrl__c != '' ){
					this.detailPageBaseUrl = (widgetRecord.detailPageUrl__c.contains('?') ? widgetRecord.detailPageUrl__c : widgetRecord.detailPageUrl__c + '?' ) + 'id=';
				}else{
					this.detailPageBaseUrl = 'https://' + ApexPages.currentPage().getHeaders().get('Host')+ widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel ? '/ideas/viewIdea.apexp?id=' : '/';
				}
			}
			return this.detailPageBaseUrl;
		} set;
	}
	
	@isTest
	static void testShareOnWidget() {
		
		Test.startTest();
		
		
		IWLShareOnWidgetController controller = new IWLShareOnWidgetController();
		
		//create an idea to 'share'
		Community com = IWLTestUtilities.getCommunity();
		Idea newIdea = IWLTestUtilities.createIdea('Title', 'Body', com.Id);
		sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'Description', 'Status', com.Id);
		
		//create widget, do not insert yet.
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_SHAREON);
		widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
		widget.ShareOn_Type__c = SHAREON_TYPE_FACEBOOK;
		
		controller.widgetDeveloperName = widget.developerName__c;
		controller.widgetRecord = widget;
		controller.IdeaId = newIdea.Id;
		
		System.assert(controller.loadWidget);
		System.assert(controller.detailPageBaseUrl != null);
		widget.ShareOn_Type__c = SHAREON_TYPE_TWITTER;
		controller.loadWidget = null;
		System.assert(controller.loadWidget);
		
		widget.ShareOn_Type__c = SHAREON_TYPE_LINKEDIN;
		
		controller.loadWidget = null;
		System.assert(controller.loadWidget);
		
		widget.ShareOn_Type__c = SHAREON_TYPE_MAIL;
		controller.loadWidget = null;
		System.assert(controller.loadWidget);
		
		
		widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
		controller.IdeaId = IWLTestUtilities.getAdminUser().Id;
		controller.loadWidget = null;
		System.assert(controller.loadWidget);
		
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
			controller.IdeaId = String.valueOf(theme.get('Id'));
			controller.loadWidget = null;
			System.assert(controller.loadWidget);
		}
		
		controller.loadWidget = null;	
		controller.IdeaId = 'InvalidId';
		System.assert(!controller.loadWidget);
		
		controller.loadWidget = null;	
		widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		controller.widgetDeveloperName = widget.developerName__c;
		controller.widgetRecord = widget;
		System.assert(!controller.loadWidget);
		
		//create a failure scenario
		controller.loadWidget = null;	
		controller.widgetDeveloperName = null;
		controller.widgetRecord = null;
		System.assert(!controller.loadWidget);
		
		Test.stopTest();
	}

}