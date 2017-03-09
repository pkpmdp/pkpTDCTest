/**
* This class is the Data Access Object for the Idea Theme object, extending the IWLBaseDAO to implement its methods.
* 
*/
public with sharing class IWLIdeaThemeDAO extends IWLBaseDAO {
	
	private static final Integer COMMENTS_PER_IDEA = 2;
	
	protected override Boolean isAccessible() {
		Boolean accessible = IsIdeaThemeEnabled && SecurityManager.isAccessible(IWLDynamicDescribeUtils.Instance.globalDescribe.get( 'IdeaTheme' ));
		
		if (accessible) {
			Schema.DescribeSObjectResult ideaThemeDescribe = IWLDynamicDescribeUtils.Instance.getObjectDescribe('IdeaTheme');
			Map<String, Schema.SObjectField> ideaThemeFields = ideaThemeDescribe.fields.getMap();
			accessible = SecurityManager.isAccessible(new Schema.sObjectfield[] {
				ideaThemeFields.get('Id'), ideaThemeFields.get('Title'), ideaThemeFields.get('Description'), 
				ideaThemeFields.get('Status'), ideaThemeFields.get('Categories'), 
				ideaThemeFields.get('CommunityId'), ideaThemeFields.get('EndDate'), 
				ideaThemeFields.get('StartDate'), ideaThemeFields.get('LastModifiedDate'), 
				ideaThemeFields.get('CreatedDate'), ideaThemeFields.get('CreatedById'), 
				ideaThemeFields.get('IWLThemeIcon__c')
			});
		}
		
		return accessible;
	}
	
	/**
	* this method checks if the Idea Theme object is enabled in the org. 
	* @return true iif the Idea Theme object is enabled in the org.
	*/
	public static Boolean IsIdeaThemeEnabled {
		
		get {
			
			if (IsIdeaThemeEnabled == null) {
				try {
					//Perform a test query
					List<sObject> ideaThemeRecords = Database.query('Select Id from IdeaTheme limit 1');
					//If no exception has been thrown, then the org has IdeaTheme enabled 
					IsIdeaThemeEnabled = true;
				} catch (Exception ex) {
					
					//An exception has been thrown by the query, so IdeaTheme is not enabled.
					IsIdeaThemeEnabled = false;
				}
				
			}
			return IsIdeaThemeEnabled;
		}
	}
	
	/**
	* returns IdeaTheme, according to the parameters set by widgetSpecs' attributes.
	*/
	public override sObject getRecord( IWLWidget__c widgetSpecs, String IdRecord ) {
		return this.getIdeaTheme( widgetSpecs, IdRecord );
	}
	
	/** 
	* returns the list of IdeaThemes, according to the parameters set by widgetSpecs' attributes.
	*/
	public override List<sObject> getRecords(IWLWidget__c widgetSpecs) {
		return this.getIdeaThemes(widgetSpecs);
	}
	
	/**
	* This methods returns the amount of records that can be retrieved from the database according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return the amount of records that can be retrieved with a query based on widgetSpecs
	*/ 
	public override Integer getRecordsCount(IWLWidget__c widgetSpecs) {
		if (canAccess) {
			String query = 'Select Count(Id) recordAmount from IdeaTheme where CommunityId = \'' + String.escapeSingleQuotes(widgetSpecs.Community__c) +'\'' + getFilterCriteria(widgetSpecs);
			return Integer.valueOf(Database.query(query).get(0).get('recordAmount'));
		} else {
			return 0;//IdeaTheme is not Enabled
		}
	}
	
	/**
	* returns the list of IdeaThemes, according to the parameters set by widgetSpecs' attributes.
	*/
	public sObject getIdeaTheme( IWLWidget__c widgetSpecs, String IdRecord ) {
		
		if (canAccess) {
			
			//we check the origin field in the widget has been correctly set to 'Idea Theme', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException( 
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistIdeaThemeLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}
			
			//Here we build the query that we will perform against database retrieving Idea Theme records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
           String query = 'Select ' + getQueryString(getFieldsForQuery(widgetSpecs)) +  
                            ' , (Select Id, Title, Body, CreatedById, VoteTotal, CreatedDate, SystemModstamp, IsDeleted, IsHtml, CreatedBy.Name, ' +
                                'CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c From Ideas Order By CreatedDate DESC ) ' +
                            'From IdeaTheme WHERE Id = \'' + String.escapeSingleQuotes(IdRecord) + '\'' +
                            ' limit 1';
			List<sObject> i = Database.query(query);
			return i[0];
		}
		return null;
	}	
	/**
	* returns the list of IdeaThemes, according to the parameters set by widgetSpecs' attributes.
	*/
	public List<sObject> getIdeaThemes(IWLWidget__c widgetSpecs) {
		
		if (canAccess) {
			
			//we check the origin field in the widget has been correctly set to 'Idea Theme', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException( 
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistIdeaThemeLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}		
			
			//Here we build the query that we will perform against database retrieving Idea Theme records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
			String query = 'Select ' + getQueryString(getFieldsForQuery(widgetSpecs)) +
							getFeedSelectionQuery(widgetSpecs) + 
							' From IdeaTheme where CommunityId = \'' + String.escapeSingleQuotes(widgetSpecs.Community__c) +'\'' + getFilterCriteria(widgetSpecs) + 						
							' Order By ' + getOrderByClause(widgetSpecs) + ' ' + getSortOrder(widgetSpecs) +
							' limit ' + Integer.valueOf(widgetSpecs.listSize__c) + ' Offset ' + this.queryOffset;
			
			 
			return (List<sObject>)Database.query(query);
		}
		return new List<sObject>();
	}
	
	protected override Set<String> getFieldsForQuery(IWLWidget__c widgetSpecs) {
		Set<String> fieldSet = new Set<String>();
		fieldSet.addAll(
			new String[]{
				'Id', 'Title', 'Description', 'Status', 'Categories', 'CommunityId', 'EndDate', 'StartDate',  
				'LastModifiedDate', 'CreatedDate', 'CreatedById', 'IWLThemeIcon__c', 'CreatedBy.CommunityNickname', 
				'CreatedBy.Username', 'CreatedBy.Id', 'CreatedBy.IWLAvatarId__c'
			}
		);
		fieldSet.addAll(getAdditionalFields(widgetSpecs));
		return fieldSet;
	}

	/**
	* This method builds the where clause for the query to list idea themes. 
	* If it must use advanced filters, it just returns the content of the filterAdvanced__c field.
	* If a default filter has been used, it builds the where clause depending on which the option is.
	*/
	protected override String getFilterCriteria(IWLWidget__c widgetSpecs) {
		String filterCriteria = '';
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.filterAdvanced__c != null && widgetSpecs.filterAdvanced__c != '') {
			//The advanced filtering has been enabled, and a filter criteria has been written.
			filterCriteria = ' AND (' + widgetSpecs.filterAdvanced__c + ')';
		} else if (widgetSpecs.FilterBasic__c != null && widgetSpecs.FilterBasic__c != '') {
			//a default filter has been chosen
			
			if (widgetSpecs.FilterBasic__c == IWLCodeSettings.FilterPicklistRecentLabel) {
				//This is the filter for recent idea themes : Themes created less than a month ago.
				filterCriteria = ' AND CreatedDate > ' + Datetime.now().addDays(-30).format( IWLCodeSettings.DATE_FORMAT );
			} else if (widgetSpecs.FilterBasic__c == IWLCodeSettings.FilterPicklistActiveLabel) {
				//This is the filter for Active idea themes: Themes with "Active" status.
				filterCriteria = ' AND Status = \'Active\'';
			}
		}	
		return filterCriteria;
	}
	
	/**
	* This method builds the order by clause for the query to list idea themes
	*/
	protected override String getOrderByClause(IWLWidget__c widgetSpecs) {
		String orderByClause = '';
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.orderByAdvanced__c != null && widgetSpecs.orderByAdvanced__c != '') {
			//The advanced filtering has been enabled, and an order by clause has been written.
			orderByClause = widgetSpecs.orderByAdvanced__c;
		} else if (widgetSpecs.OrderByBasic__c != null && widgetSpecs.OrderByBasic__c != '') {
			//a default order by clause has been selected.
			
			if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistCreatedDateLabel) {
				//Order by the theme's createdDate field
				orderByClause =  'CreatedDate';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistAlphabeticallyLabel) {
				//Order by the theme's Title field
				orderByClause =  'Title';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistIdeaCountLabel) {
				//Order by the amount of ideas posted to this theme
				orderByClause =  'Id';//'IdeaCount'; - The field is not available anymore... 
			} else {
				//order by Id
				orderByClause = 'Id';
			} 
		} else {
			//Order by id, if no criteria has been specified.
			orderByClause =  'Id';
		}
		return orderByClause;
	}
	

	
	/**
	* This method builds the part of the query in charge of selecting the Ideas for each theme.
	* @param widgetSpecs the IWLWidget__c record specifying if the ideas must be listed or not. 
	* @return If widgetSpecs.showRelatedFeed__c then it will build a select sub-query for Ideas; else, it will return an empty string
	*/
	private String getFeedSelectionQuery(IWLWidget__c widgetSpecs) {
		String feedSelection = '';
		//if (widgetSpecs.showRelatedFeed__c) {
			//the widget has been configured to show the related feed, so we form the part of the query that gets the comments. 
			//Comments per idea are limited by the specified relatedFeedSize__c value, or by COMMENTS_PER_IDEA in case the 
			//first one is null or less or equals to 0 
			feedSelection = ', (Select Id, Title, Body, CreatedById, VoteTotal, CreatedDate, SystemModstamp, IsDeleted, IsHtml, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c From Ideas Order By CreatedDate ASC limit ' + 
				((widgetSpecs.relatedFeedSize__c == null || widgetSpecs.relatedFeedSize__c <= 0 ) ? COMMENTS_PER_IDEA : widgetSpecs.relatedFeedSize__c) + ') ';
		//}
		return feedSelection;
	}
	
	//TODO: build test methods.
	
	@isTest
    public static void testIWLIdeaThemeDAO() {
    	Test.startTest();
    	Community com = IWLTestUtilities.getCommunity();
    	
    	sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
    	
    	if (theme != null) {
    		//create an idea for the theme, and assign it.
    		Idea i = IWLTestUtilities.createIdea( 'Egg is an egg more than egg', 'Egg is an egg more than egg', com.Id );
			IWLTestUtilities.createIdeaComment( 'Egg is an egg more than egg' , i.Id );	
			i.put('IdeaThemeId', String.valueOf(theme.get('Id')));
			update i;
    	}	
    	IWLWidget__c widgetSpecs = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_THEMESLIST);
    	
    	IWLIdeaThemeDAO controller = new IWLIdeaThemeDAO();
    	List<sObject> themes = controller.getRecords( widgetSpecs );
    	
    	Integer ideaThemesCount = controller.getRecordsCount(widgetSpecs);
    	
    	if (!IsIdeaThemeEnabled) {
    		system.assert(themes.size() == 0 && ideaThemesCount == 0);
    	} else {
    		system.assert(themes.size() > 0 && ideaThemesCount > 0);
    		
    	}
    	
    	widgetSpecs.useAdvancedFiltering__c = false;
    	
    	widgetSpecs.FilterBasic__c = IWLCodeSettings.FilterPicklistRecentLabel;
    	widgetSpecs.OrderByBasic__c = IWLCodeSettings.OrderByPicklistAlphabeticallyLabel;    	
    	themes = controller.getRecords(widgetSpecs);
    	
    	widgetSpecs.FilterBasic__c = IWLCodeSettings.FilterPicklistActiveLabel;
    	widgetSpecs.OrderByBasic__c = IWLCodeSettings.OrderByPicklistCreatedDateLabel;    	
    	themes = controller.getRecords(widgetSpecs);
    	
    	widgetSpecs.OrderByBasic__c = IWLCodeSettings.OrderByPicklistIdeaCountLabel;    	
    	themes = controller.getRecords(widgetSpecs);
    
    	widgetSpecs.useAdvancedFiltering__c = true;
    	widgetSpecs.filterAdvanced__c = 'Status = \'Active\'';    	
    	themes = controller.getRecords(widgetSpecs);
    	
    	try {
    		widgetSpecs.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
    		themes = controller.getRecords(widgetSpecs);
    	} catch (Exception ex) {/*Do nothing, expected behavior*/}
    	
    	Test.stopTest();
    }
	
	@isTest
	public static void testGetSingleRecord() {
		Test.startTest();
    	Community com = IWLTestUtilities.getCommunity();
    	
    	sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
    	IWLWidget__c widgetSpecs = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_THEMESLIST);
    		IWLIdeaThemeDAO controller = new IWLIdeaThemeDAO();
    	if (theme != null) {
    		//create an idea for the theme, and assign it.
    		Idea i = IWLTestUtilities.createIdea( 'Egg is an egg more than egg', 'Egg is an egg more than egg', com.Id );
			IWLTestUtilities.createIdeaComment( 'Egg is an egg more than egg' , i.Id );	
			i.put('IdeaThemeId', String.valueOf(theme.get('Id')));
			update i;    	
		   
		   	sObject testTheme = controller.getRecord(widgetSpecs, String.valueOf(theme.get('Id')));
		   	system.assert(String.valueOf(testTheme.get('Id')) == String.valueOf(theme.get('Id')));
    	} else {
    		try { sObject testTheme = controller.getRecord(widgetSpecs, 'daknddsadoih'); system.assert(testTheme == null); } catch (Exception ex) {/*Do  nothing, expected behavior*/}
    	}	
    	
		
		Test.stopTest();
	}
	
}