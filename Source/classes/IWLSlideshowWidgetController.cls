/**
* This class implements the controller part of the MVC pattern for the User Avatar Upload Widget.
*/
public with sharing class IWLSlideshowWidgetController extends IWLBaseWidgetController {
	public final static String ORIGIN_CSS_CLASS_PREFIX = 'IWLSlideshow';

	private transient List<sObject> queriedResults {get; set;}
	public Map<Id, sObject> sObjResultMap {get; set;}
	public List<IWLSlideshowWidgetDO> visualDataList {get; set;}
		
	public IWLSlideshowWidgetController() {
		
	}
	
	public override String getOriginClassName() {
		
        if (widgetRecord != null) {
            
            return ORIGIN_CSS_CLASS_PREFIX + IWLCodeSettings.getCssForOrigin(widgetRecord.Origin__c);
        } else {
            return '';
        }
    
		
	}
	
	/**
	* This method overrides the one in IWLBaseWidgetController in order to implement the 
	* widget-specific load procedure of the widget's specs and information. 
	* @return true iif the load process was successful.
	*/
	protected override Boolean doLoad() {
		
		//Check for the widgetRecord's type
		if (widgetRecord.Type__c == IWLCodeSettings.SlideshowRecordTypeName) {
			//the widget record has been loaded and has the correct type
							
			//get the records to be shown from the database.
			this.queriedResults = getRecords(widgetRecord);
			this.sObjResultMap = new Map<Id, sObject>(queriedResults);
			//translate the records into instances of IWLSlideshowWidgetDO, so that they can be rendered in the view
			this.visualDataList = new IWLSlideshowWidgetModel().ObjectToSlideshowDO(this.queriedResults, widgetRecord);
			//mark the widget as correctly loaded.
			return true;
		} else {
			//Wrong Widget record's type.
			LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
			return false;
		}
	}
	
	/**
    * This method obtains from the database the records that must be shown in this widget according to the parameters set in 
    * "widget". 
    * @param widget the record of the IWLWidget__c object that specifies which object must be listed in this widget.
    * @return a list of records retrieved from the database, according to the specification given by "widget"
    */
	private List<sObject> getRecords(IWLWidget__c widget) {
		IWLBaseDAO daoInstance; 
		if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
			//we are to list Ideas, get them from the IWLIdeaDAO
			daoInstance = new IWLIdeaDAO();
			
		} else if (widget.Origin__c == IWLCodeSettings.OriginPicklistUserLabel) {
			//we are to list Users, get them from the IWLUserDAO
			daoInstance = new IWLUserDAO();
			
		} else if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
			//we are to list Idea Themes, get them from the IWLIdeaThemeDAO
			daoInstance = new IWLIdeaThemeDAO();
			
		} else {
			//no valid option has been selected as the origin of the information for this object, so we return an empty list.
			return new List<sObject>();
		}
		daoInstance.queryOffset = 0;
		return daoInstance.getRecords(widget);
	}
	
	public String getErrorMessage() {
		return null;
	}
	
	public Integer widgetWidth {
		get {
			return Integer.valueOf(widgetRecord.width__c);
		}
	}
	
	public Integer widgetHeight {
		get {
			return Integer.valueOf(widgetRecord.height__c);
			}
	}
	
	public String detailPageBaseUrl {
		get {
			if (detailPageBaseUrl == null) {
				this.detailPageBaseUrl = (widgetRecord.detailPageUrl__c != null && widgetRecord.detailPageUrl__c != '') ? (widgetRecord.detailPageUrl__c.contains('?') ? widgetRecord.detailPageUrl__c : widgetRecord.detailPageUrl__c + '?' ) + 'id=' : '/';
			}
			return this.detailPageBaseUrl;
		} set;
	}
	
	public String authorDetailPageBaseUrl {
		get {
			if (authorDetailPageBaseUrl == null) {
				this.authorDetailPageBaseUrl = (widgetRecord.authorDetailUrl__c != null && widgetRecord.authorDetailUrl__c != '') ? (widgetRecord.authorDetailUrl__c.contains('?') ? widgetRecord.authorDetailUrl__c : widgetRecord.authorDetailUrl__c + '?' ) + 'id=' : '/';
			}
			return this.authorDetailPageBaseUrl;
		} set;
	}
	
	public Integer itemsCount {
		get {
			return visualDataList.size();
		}
	}
	
	public Integer transitionInterval {
		get {
			return (widgetRecord.transitionInterval__c != null) ? Integer.valueOf(widgetRecord.transitionInterval__c) : 0;
		}
	}
		
	@isTest
	public static void testLoadWidget() {
		Test.startTest();
		
		Community com = IWLTestUtilities.getCommunity();
		Idea i = IWLTestUtilities.createIdea('Title', 'Body', com.Id);
		
		RecordType record = [select id,name from recordtype where sobjecttype='IWLWidget__c' and name = 'Slideshow'];
		
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASSLIDESHOW);
		
		IWLSlideshowWidgetController controller = new IWLSlideshowWidgetController();
		controller.widgetDeveloperName = widget.developerName__c;
		System.assert(controller.loadWidget);
		System.assert(controller.queriedResults.size() > 0);
		System.assert(controller.visualDataList.size() > 0);
		
		Test.stopTest();
	}
 
 	@isTest
	static void testSlideshowWidget() {
		Test.startTest();
		
		//create an idea to make sure we retrieve ideas.
		Community com = IWLTestUtilities.getCommunity();
		Idea newIdea = IWLTestUtilities.createIdea('Title', 'Body', com.Id);
		IdeaComment newComment = IWLTestUtilities.createIdeaComment('Com body', newIdea.Id);
		
		//create a widget to list ideas.
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASSLIDESHOW);
		
		//load the widget for ideas.						
		IWLSlideshowWidgetController controller = new IWLSlideshowWidgetController();
		controller.widgetDeveloperName = widget.developerName__c;
		controller.widgetRecord = widget;
		System.assert(controller.loadWidget);
		System.assert(controller.itemsCount > 0 && controller.authorDetailPageBaseUrl != null && controller.detailPageBaseUrl != null );
								
		//now we do the same for users:
		widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
		
		controller.loadWidget = null;
		System.assert(controller.loadWidget);
		System.assert(controller.widgetWidth + controller.widgetHeight + controller.itemsCount + controller.transitionInterval >= 0);
		//And finally, we load the widget for Idea Theme, if the object is enabled
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'Description', 'Status', com.Id);
			
			widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
			
			
			controller.loadWidget = null;
			System.assert(controller.loadWidget);
		}	
		
		System.assert(controller.getOriginClassName().startsWith('IWLSlideshow') && controller.getErrorMessage() == null);	
		Test.stopTest();
	}
 
 	
}