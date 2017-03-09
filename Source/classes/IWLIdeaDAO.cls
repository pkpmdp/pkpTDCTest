/**
* This class is the Data Access Object for the Idea object, extending the IWLBaseDAO to implement its methods.
*  
*/ 
public with sharing virtual class IWLIdeaDAO extends IWLBaseDAO{

	private static final Integer COMMENTS_PER_IDEA = 2;
	
	protected override Boolean isAccessible() {
		Boolean accessible = SecurityManager.isAccessible(Idea.sObjectType) && 
			SecurityManager.isAccessible(new Schema.sObjectfield[] {
				Idea.VoteTotal, Idea.VoteScore, Idea.Title, Idea.Status, Idea.NumComments, 
				Idea.LastModifiedDate, Idea.IsLocked, Idea.Id, 
				Idea.CreatedDate, Idea.CreatedById, Idea.Categories, Idea.IsHtml, Idea.Body 
			});
		
		return accessible;
	}

	/**
	* Return idea, according to the parameters set by widgetSpecs' attributes.
	*/ 
	public override sObject getRecord( IWLWidget__c widgetSpecs, String IdRecord ) { 
		return this.getIdea( widgetSpecs, IdRecord );
	}
	
	/**
	* Lists ideas, according to the parameters set by widgetSpecs' attributes.
	*/
	public override List<sObject> getRecords(IWLWidget__c widgetSpecs) {
		return this.getIdeas(widgetSpecs);
	}

	/**
	* Returns a list of ideas, according to the parameters set by widgetSpecs' attributes.
	*/
	public Idea getIdea( IWLWidget__c widgetSpecs, String IdRecord ) {
		if (canAccess) {
			//we check the origin field in the widget has been correctly set to 'Idea', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistIdeaLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException(
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistIdeaLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}
			//Here we build the query that we will perform against database retrieving Idea records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
			String query = 'Select '+ getQueryString(getFieldsForQuery(widgetSpecs)) +
							', ( Select Id, IdeaId, CommentBody, CreatedById, CreatedDate, SystemModstamp, IsDeleted, IsHtml, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c ' +
								' From Comments Order By CreatedDate DESC )' +
							' From Idea WHERE Id = \'' + String.escapeSingleQuotes(IdRecord) + '\'' +
							' limit 1';
			List<Idea> i = Database.query(query);
			return i[0];
		}
		return null;
	}	
	/**
	* This methods returns the amount of records that can be retrieved from the database according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return the amount of records that can be retrieved with a query based on widgetSpecs
	*/ 
	public override Integer getRecordsCount(IWLWidget__c widgetSpecs) {
		if (canAccess) {
			String query = 'Select Count(Id) recordAmount from Idea where CommunityId = \'' + String.escapeSingleQuotes(widgetSpecs.Community__c) +'\'' + getFilterCriteria(widgetSpecs);
			return Integer.valueOf(Database.query(query).get(0).get('recordAmount'));
		} else {
			return 0;//Idea is not accessible
		}
	}
	
	
	/**
	* Returns a list of ideas, according to the parameters set by widgetSpecs' attributes.
	*/
	public List<Idea> getIdeas(IWLWidget__c widgetSpecs) {
		
		if (canAccess) {
			//we check the origin field in the widget has been correctly set to 'Idea', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistIdeaLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException(
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistIdeaLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}
			
			//Here we build the query that we will perform against database retrieving Idea records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
			String query = 'Select ' + getQueryString(getFieldsForQuery(widgetSpecs)) + getFeedSelectionQuery(widgetSpecs) + 
							' From Idea where CommunityId = \'' + String.escapeSingleQuotes(widgetSpecs.Community__c) +'\'' + getFilterCriteria(widgetSpecs) + 
							' Order By ' + getOrderByClause(widgetSpecs) + ' ' + getSortOrder(widgetSpecs) +
							' limit ' + Integer.valueOf(widgetSpecs.listSize__c) + ' Offset ' + this.queryOffset;
			
			
			return (List<Idea>)Database.query(query);
		}
		return new List<Idea>();
	}
	
	/**
	* Returns a map containing the amount of ideas posted to each Idea Theme in  themesIds list.
	* @param themesIds the Ids of the idea themes the user wants information from.
	* @return a map of <IdeaTheme.Id, AggregateResult> containing an entry for each Theme in themesIds, and the 
	* amount of ideas posted to the theme.
	*/
	public static Map<Id, AggregateResult> getIdeasCountPerTheme(List<Id> themesIds) { 
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled && themesIds != null && themesIds.size() > 0) {
			String records = '';
			for (Id themeId : themesIds) {
				records += '\'' + themeId + '\',';
			}
			
			if (records.endsWith(',')) {
				records = records.substring(0, records.length() -1);
			}
			
			return new Map<Id, AggregateResult>((List<AggregateResult>)Database.query('Select IdeaThemeId Id, count(i.Id) IdeasPerTheme from Idea i where i.IdeaThemeId IN (' + records  + ') group by i.IdeaThemeId limit ' + themesIds.size()));
		}
		
		return new Map<Id, AggregateResult>(); 
	}
	
	protected override Set<String> getFieldsForQuery(IWLWidget__c widgetSpecs) {
		Set<String> fieldSet = new Set<String>();
		fieldSet.addAll(
			new String[]{
				'VoteTotal', 'VoteScore', 'Title', 'Status', 'NumComments', 'LastModifiedDate', 'IsLocked', 'Id', 
				'CreatedDate', 'CreatedById', 'Categories', 'IsHtml', 'Body', 
				'CreatedBy.CommunityNickname', 'CreatedBy.Username', 'CreatedBy.Id', 'CreatedBy.IWLAvatarId__c'
			}
		);
		fieldSet.addAll(getAdditionalFields(widgetSpecs));
		return fieldSet;
	}

	/**
	* This method builds the where clause for the query to list ideas. 
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
				//This is the filter for recent ideas : Ideas created less than 30 days ago. 
				filterCriteria = ' AND CreatedDate > ' + Datetime.now().addDays(-30).format( IWLCodeSettings.DATE_FORMAT );
			} else if (widgetSpecs.FilterBasic__c == IWLCodeSettings.FilterPicklistActiveLabel) {
				
				//This is the filter for Active ideas: Ideas with comments.
				filterCriteria = ' AND NumComments > 0';
			}
		}	
		return filterCriteria;
	}
	
	/**
	* This method builds the order by clause for the query to list ideas
	*/
	protected override String getOrderByClause(IWLWidget__c widgetSpecs) {
		String orderByClause = '';
		
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.orderByAdvanced__c != null && widgetSpecs.orderByAdvanced__c != '') {
			//The advanced filtering has been enabled, and an order by clause has been written.
			
			orderByClause = widgetSpecs.orderByAdvanced__c;
		} else if (widgetSpecs.OrderByBasic__c != null && widgetSpecs.OrderByBasic__c != '') {
			//a default order by clause has been selected.
			
			if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistCreatedDateLabel) {
				//Order by the idea's createdDate field
				orderByClause =  'CreatedDate';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistAlphabeticallyLabel) {
				//Order by the idea's Title field
				orderByClause =  'Title';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistCommentsCountLabel) {
				//Order by the idea's NumComments field
				orderByClause =  'NumComments';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistRatingLabel) {
				//Order by the idea's VoteTotal field
				orderByClause =  'VoteTotal';
			} else {
				orderByClause = 'Id';
			} 
		} else {
			orderByClause =  'Id';
		}
		
		return orderByClause;
	}
	
	/**
	* This method builds the part of the query in charge of selecting the Comments for each idea.
	* @param widgetSpecs the IWLWidget__c record specifying if the comments must be listed or not. 
	* @return If widgetSpecs.showRelatedFeed__c then it will build a select sub-query for Comments; else, it will return an empty string
	*/
	private String getFeedSelectionQuery(IWLWidget__c widgetSpecs) {
		String feedSelection = '';
		
		feedSelection = ', (Select Id, IdeaId, CommentBody, CreatedById, CreatedDate, SystemModstamp, IsDeleted, IsHtml, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c From Comments Order By CreatedDate DESC limit ' + 
				((widgetSpecs.relatedFeedSize__c == null || widgetSpecs.relatedFeedSize__c <= 0 ) ? COMMENTS_PER_IDEA : widgetSpecs.relatedFeedSize__c) + ') ';
		return feedSelection;
	}
	
	
	/**
	* This method retrieves the information of all ideas merged with those which ids are in parentIdeasIds.
	* @param parentIdeasIds a list of the Ids of all the parent ideas.
	* @return a list of the Ideas that have been merged with the ideas represented nby parentIdeasIds.
	* 
	*/
	public static List<Idea> getMergedIdeas(List<String> parentIdeasIds) {
		return [SELECT Id, Title, CreatedById, CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c, ParentIdeaId FROM Idea WHERE ParentIdeaId IN :parentIdeasIds limit 10000];
	}
	
	/**
	* This method retrieves a list of the developer names of all fields that are editable for the type of object
	* this DAO manages. 
	* @return a list with the names of the fields that are edditable in this object.
	*/
	public override List<String> getEditableFieldsNames() {
		return new String[]{'Title', 'Body'};
	}
		
	@isTest
	public static void testGetIdeas() {
		Test.startTest();
		Community com = IWLTestUtilities.getCommunity();
		
		Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'Body', com.Id);
		
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		IWLIdeaDAO controller = new IWLIdeaDAO();
		List<sObject> ideas = controller.getRecords(widget);
		System.assert(ideas.size() > 0);
		widget.useAdvancedFiltering__c = false;
		//test different combinations of filters and order clauses.
		widget.FilterBasic__c = IWLCodeSettings.FilterPicklistRecentLabel;
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistCreatedDateLabel;
		ideas = controller.getRecords(widget);
		
		widget.FilterBasic__c = IWLCodeSettings.FilterPicklistActiveLabel;
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistAlphabeticallyLabel;
		ideas = controller.getRecords(widget);
		
		
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistCommentsCountLabel;
		ideas = controller.getRecords(widget);
		
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistRatingLabel;
		ideas = controller.getRecords(widget);
		
		widget.OrderByBasic__c = 'Nothing';
		ideas = controller.getRecords(widget);
		
		
		//the following code is to test the additional fields feature.
		widget.additionalFields__c = 'Id';
		//try {
			//this is an expected exception
			ideas = controller.getRecords(widget);
			
		//} catch (Exception ex) {
		//	System.debug(ex.getMessage());
		//}
		Test.stopTest();
	} 
	
	@isTest
	public static void testGetIdeasAdvancedFiltering() {
		Test.startTest();
		Community com = IWLTestUtilities.getCommunity();
		
		Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'body', com.Id);
				
		IWLWidget__c widget =  IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		widget.useAdvancedFiltering__c = true;
		widget.filterAdvanced__c = 'Id = \'' + i.Id + '\'';
		widget.additionalFields__c = null;
		IWLIdeaDAO controller = new IWLIdeaDAO();
		
		List<sObject> ideas = controller.getRecords(widget);
		System.assert(ideas.size() > 0);
		Integer recordsCount = controller.getRecordsCount(widget);
		widget.OrderByAdvanced__c = 'Id';
		ideas = controller.getRecords(widget);
		System.assert(ideas.size() > 0);
		Test.stopTest();
	}
	
	@isTest
	public static void testGetIdeasWithComments() {
		Test.startTest();
		Community com = IWLTestUtilities.getCommunity();
		
		Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'body', com.Id);
		
		IdeaComment comment = IWLTestUtilities.createIdeaComment('Body Comment', i.Id);
		
		
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		widget.useAdvancedFiltering__c = true;
		widget.filterAdvanced__c = 'Id = \'' + i.Id + '\'';
		List<Idea> ideas = (List<Idea>)new IWLIdeaDAO().getRecords(widget);
		System.assert(ideas.size() > 0);
		Idea savedIdea = ideas.get(0);
		System.assert(savedIdea.Comments.size() > 0);
		Test.stopTest();
	}

	@isTest
    public static void testIWLBaseDAO() {
    	
    	Community com = IWLTestUtilities.getCommunity();
		
		Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'body', com.Id);
		
		IdeaComment comment = IWLTestUtilities.createIdeaComment('Body Comment', i.Id);
		
    	IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
    	widget.OrderByBasic__c = null;
    	widget.useAdvancedFiltering__c = false;
    	IWLIdeaDAO c = new IWLIdeaDAO();
    	c.getIdeas( widget );
    }

	@isTest
	public static void testIWLGetSingleIdea() {
		Community com = IWLTestUtilities.getCommunity();
		
		Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'Body', com.Id);
		
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		IWLIdeaDAO controller = new IWLIdeaDAO();
		Idea testIdea = (Idea)controller.getRecord(widget, i.Id);
		System.assert(testIdea.Id == i.Id);
	}
}