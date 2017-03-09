/**
* This class controls the Search widget.
*/
public with sharing class IWLSearchWidgetController extends IWLBaseWidgetController {

    
    public String s								{get; set;}
    public List<SearchWidgetItems> ItemsList	{get; set;}
    
    public class SearchWidgetItems {
        public String Id        {get;set;}
        public String Title     {get;set;}
        public String Body		{get;set;}
    }
    
    /**
	* This method overrides the one in IWLBaseWidgetController in order to implement the 
	* widget-specific load procedure of the widget's specs and information. 
	* @return true iif the load process was successful.
	*/
    protected override Boolean doLoad() {
    	if (widgetRecord.Type__c == IWLCodeSettings.SearchRecordTypeName) {
    		//the widgetRecord exists and is of the correct type for this widget
			return true;
		} else {
			//the widgetRecord has a wrong type.
			LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
			return false;
		}		
    }

	/**
	* This method implements the actual search for Ideas or Idea themes.
	*/
    public pageReference searchIdea(){
    	clearMessages();
		ItemsList = new List<SearchWidgetItems>();
		Id[] similarIds;
		List<sObject> searchResult;
		Map<Id, sObject> resultMap;
    	String query = String.escapeSingleQuotes(s);
    	String communityFilter = (widgetRecord.Community__c != null) ? ' AND CommunityId = \'' + widgetRecord.Community__c + '\'' : '';
		if ( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel ) {
			Idea nIdea = new Idea(
				Title = s,
				Body = s
			);
			resultMap = new Map<Id, sObject>(Database.query('SELECT Id, Title, Body FROM Idea WHERE Title LIKE \'%'+query+'%\' ' + communityFilter + ''));
			/*similarIds = new List<Id>(ideasMap.keySet());//Ideas.findSimilar(nIdea);
			searchResult = ideasMap.values();*/
    	} else if( IWLIdeaThemeDAO.IsIdeaThemeEnabled ){    		
			resultMap = new Map<Id, sObject>(Database.query('SELECT Id, Title, Description FROM IdeaTheme WHERE Title LIKE \'%'+query+'%\' ' + communityFilter + 'LIMIT 1'));
			
		}
		
		if (resultMap.size() > 0) {
			similarIds = new List<Id>(resultMap.keySet());
			searchResult = resultMap.values();
		} else {
			similarIds = new List<Id>();
		}
		
		if ( similarIds == null || similarIds.size() == 0 ) {
			
			addMessage( INFO_MESSAGE, Label.IWL_NO_RESULTS );
		}else{
			if( widgetRecord.Redirect__c ){
				return redirectWithSearchResults(similarIds);
		    }else{
		    		showSearchResultsInWidget(searchResult);
		    	
			}
    		
    	}
    	return null;
    }
    
    private void showSearchResultsInWidget(List<sObject> searchResult) {
    	if ( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
    		for( sObject i : searchResult ){
    			SearchWidgetItems swi = new SearchWidgetItems();
    			swi.Id = String.valueOf( i.get('Id') );
    			swi.Title = String.valueOf( i.get('Title') );
    			swi.Body = String.valueOf( i.get('Description') );
    			ItemsList.add(swi);
    		}
    	} else {
    		for( sObject i : searchResult ){
				SearchWidgetItems s = new SearchWidgetItems();
				Idea sIdea = (Idea) i;
				s.Id = String.valueOf( sIdea.Id );
				s.Title = sIdea.Title;
				s.Body = sIdea.Body;
				ItemsList.add(s);
			}
    	}
    }
    
    private PageReference redirectWithSearchResults(List<String> sarchResultIds) {
    	String records = ''; 
		for( String x : sarchResultIds ){
			records+= x + ',';
		}
		pageReference pr = this.generateReturnReference();
		pr.getParameters().put('records', records );
        pr.setRedirect(true);
        return pr;
    }
    
    public static testMethod void testIWLSearchWidgetController() {
		Test.startTest();
    	Community com = IWLTestUtilities.getCommunity();
    	IWLTestUtilities.createIdea( 'Test Idea', 'Test Idea', com.Id );
		sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
		
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_SEARCHIDEAS);
		
    	IWLSearchWidgetController c = new IWLSearchWidgetController();
    	c.widgetDeveloperName = widget.developerName__c;
    	c.widgetRecord = widget;
    	if( c.loadWidget ){
	    	c.s = 'Idea';
	    	c.searchIdea();
	    	system.assert( c.ItemsList.size() > 0 || c.ItemsList.size() == 0 );
	    	
	    	c.widgetRecord.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
	    	//update c.widgetRecord;
	    	c.s = 'Title';
	    	c.searchIdea();   
	    	c.widgetRecord.redirect__c = true;
	    	c.widgetRecord.redirectURL__c = 'http://www.google.com';
	    	c.searchIdea();   
	    	
	    	c.s = '894908401342nnuweunru2b8n!!'; 
	    	c.searchIdea();   		
    	}
    	
    	try {
    		c = new IWLSearchWidgetController();
    		widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_THEMESLIST);
    		c.widgetDeveloperName = widget.developerName__c;
    		c.widgetRecord = widget;
    		c.doLoad();
    	} catch (Exception ex) {/*Do nothing*/}
    	
    	Test.stopTest();
    }    
    
}