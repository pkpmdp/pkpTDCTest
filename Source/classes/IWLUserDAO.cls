/**
* This class is the Data Access Object for the User object, extending the IWLBaseDAO to implement its methods.
* 
*/
public with sharing virtual class IWLUserDAO extends IWLBaseDAO {
	
	public static Boolean canAccessVotes {
		get {
			if (canAccessVotes == null) {
				canAccessVotes = SecurityManager.isAccessible( new Schema.sObjectfield[] {
					Vote.Id, Vote.CreatedById	
				});	
			}
			return canAccessVotes;
		} set;
	}
	
	public static Boolean canAccessIdeas {
		get {
			if (canAccessIdeas == null) {
				canAccessIdeas = SecurityManager.isAccessible( new Schema.sObjectfield[] {
					Idea.Id, Idea.CreatedById	
				});	
			}
			return canAccessIdeas;
		} set;
	}
	
	public static Boolean canAccessComments {
		get {
			if (canAccessComments == null) {
				canAccessComments = SecurityManager.isAccessible( new Schema.sObjectfield[] {
					IdeaComment.Id, IdeaComment.CreatedById	
				});	
			}
			return canAccessComments;
		} set;
	}
	
	protected override Boolean isAccessible() {
		Boolean accessible = SecurityManager.isAccessible(User.sObjectType);
		
		return accessible;
	}
	
	/**
	* Lists users, according to the parameters set by widgetSpecs' attributes.
	*/
	public override sObject getRecord( IWLWidget__c widgetSpecs, String IdRecord ) {
		return this.getUser( widgetSpecs, IdRecord );
	}
	/**
	* Lists users, according to the parameters set by widgetSpecs' attributes.
	*/
	public override List<sObject> getRecords(IWLWidget__c widgetSpecs) {
		return this.getUsers(widgetSpecs);
	}
	
	/**
	* This methods returns the amount of records that can be retrieved from the database according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return the amount of records that can be retrieved with a query based on widgetSpecs
	*/ 
	public override Integer getRecordsCount(IWLWidget__c widgetSpecs) {
		if (canAccess) {
			String query = 'Select Count(Id) recordAmount ' +
							'From User ' + getFilterCriteria(widgetSpecs);
			return Integer.valueOf(Database.query(query).get(0).get('recordAmount'));
		} else {
			return 0;//User is not accessible
		}
	}
	
	/**
	* Lists users, according to the parameters set by widgetSpecs' attributes.
	*/
	public User getUser(IWLWidget__c widgetSpecs, String IdRecord) {
		
		if (canAccess) {
			
			//we check the origin field in the widget has been correctly set to 'User', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistUserLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException(
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistUserLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}
			
			//Here we build the query that we will perform against database retrieving User records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
			String query = 'Select ' + getQueryString(getFieldsForQuery(widgetSpecs)) + 
							' From User WHERE Id = \'' + String.escapeSingleQuotes(IdRecord) + '\'' +
							' limit 1';
			List<User> u = Database.query(query);
			if( u.size() > 0 ) return u[0];
			return null;
			
		}
		return null;
	}
	
	public static Map<Id, AggregateResult> getIdeasPerUser(List<Id> userIds) {
		if (canAccessIdeas) {
			return new Map<Id, AggregateResult>([Select CreatedById Id, count(i.Id) IdeasPerUser from Idea i where i.CreatedById IN :userIds group by i.CreatedById limit :userIds.size()]);
		}
		return new Map<Id, AggregateResult>(); 
	}
	
	public static Map<Id, AggregateResult> getThemesPerUser(List<Id> userIds) {
		return new Map<Id, AggregateResult>();
	}
	
	public static Map<Id, AggregateResult> getCommentsPerUser(List<Id> userIds) {
		if (canAccessComments) {
			return new Map<Id, AggregateResult>([Select CreatedById Id, count(ic.Id) CommentsPerUser from IdeaComment ic where ic.CreatedById IN :userIds group by ic.CreatedById limit :userIds.size()]);
		}
		return new Map<Id, AggregateResult>();
	}
	
	public static Map<Id, AggregateResult> getVotesPerUser(List<Id> userIds) {
		if (canAccessVotes) {
			return new  Map<Id, AggregateResult>([Select CreatedById Id, count(v.Id) VotesPerUser from Vote v where Parent.Type = 'Idea' AND v.CreatedById IN :userIds group by v.CreatedById limit :userIds.size()]);
		}
		return new Map<Id, AggregateResult>();
	}
	
	/**
	* This method retrieves a list of the developer names of all fields that are editable for the type of object
	* this DAO manages. 
	* @return a list with the names of the fields that are edditable in this object.
	*/
	public override List<String> getEditableFieldsNames() {
		return new String[]{'CommunityNickname', 'Email', 'AboutMe'};
	}
	
		
	/**
	* Lists users, according to the parameters set by widgetSpecs' attributes.
	*/
	public List<User> getUsers(IWLWidget__c widgetSpecs) {
		
		if (canAccess) {
			
			//we check the origin field in the widget has been correctly set to 'User', if not, we throw an exception
			if (widgetSpecs.Origin__c != IWLCodeSettings.OriginPicklistUserLabel) {
				throw new IWLCodeSettings.IWLInvalidObjectTypeException(
					Label.INVALID_OBJECT_TYPE_EXCEPTION.replace( '{0}', IWLCodeSettings.OriginPicklistUserLabel ).replace( '{1}', widgetSpecs.Origin__c )
				);
			}
			
			//Here we build the query that we will perform against database retrieving User records.
			//In the future, we might parameterize the "select" part, so that in widgetSpecs the users specify the fields they want to have.
			//the query is built with text in order to allow dynamic definition of some parts of it, as the where and order by clauses.
			String query = 'Select ' + getQueryString(getFieldsForQuery(widgetSpecs)) +  
							' From User ' + getFilterCriteria(widgetSpecs) + 
							' Order By ' + getOrderByClause(widgetSpecs) + ' ' + getSortOrder(widgetSpecs) +
							' limit ' + Integer.valueOf(widgetSpecs.listSize__c) + ' Offset ' + this.queryOffset;
			
			return (List<User>)Database.query(query);
			
		}
		return null;
	}
	
	protected override Set<String> getFieldsForQuery(IWLWidget__c widgetSpecs) {
		Set<String> fieldSet = new Set<String>();
		fieldSet.addAll(
			new String[]{
				'Name', 'LastName', 'IsActive', 'Id', 'FirstName', 'Email', 'AboutMe', 'CommunityNickname', 
				'IWLAvatarId__c', 'ProfileId', 'Profile.Name'
			}
		);
		fieldSet.addAll(getAdditionalFields(widgetSpecs));
		return fieldSet;
	}

	/**
	* This method builds the where clause for the query to list users. 
	* If it must use advanced filters, it just returns the content of the filterAdvanced__c field.
	* If a default filter has been used, it builds the where clause depending on which the option is.
	*/
	protected override String getFilterCriteria(IWLWidget__c widgetSpecs) {
		String filterCriteria = '';
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.filterAdvanced__c != null && widgetSpecs.filterAdvanced__c != '') {
			//The advanced filtering has been enabled, and a filter criteria has been written.
			filterCriteria = 'where ' + widgetSpecs.filterAdvanced__c;
		} else if (widgetSpecs.FilterBasic__c != null && widgetSpecs.FilterBasic__c != '') {
			//a default filter has been chosen
			if (widgetSpecs.FilterBasic__c == IWLCodeSettings.FilterPicklistNewUsersLabel) {
				//This is the filter for recently created users : users created less than 30 days ago.
				filterCriteria = 'where CreatedDate > ' + Datetime.now().addDays(-30).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'') + '';
			} else if (widgetSpecs.FilterBasic__c == IWLCodeSettings.FilterPicklistNoviceUsersLabel) {
				//This is the filter for recently created users : users created less than 7 days ago.
				filterCriteria = 'where CreatedDate > ' + Datetime.now().addDays(-7).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'') + '';
			}
		}	
		return filterCriteria;
	}
	
	/**
	* This method builds the order by clause for the query to list users
	*/
	protected override String getOrderByClause(IWLWidget__c widgetSpecs) {
		String orderByClause = '';
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.orderByAdvanced__c != null && widgetSpecs.orderByAdvanced__c != '') {
			//The advanced filtering has been enabled, and an order by clause has been written.
			orderByClause = widgetSpecs.orderByAdvanced__c;
		} else if (widgetSpecs.OrderByBasic__c != null && widgetSpecs.OrderByBasic__c != '') {
			if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistCreatedDateLabel) {
				//Order by the user's createdDate field
				orderByClause =  'CreatedDate';
			} else if (widgetSpecs.OrderByBasic__c == IWLCodeSettings.OrderByPicklistAlphabeticallyLabel) {
				//Order by the user's communitynickname field
				orderByClause =  'CommunityNickname';
			} else {
				//Order by Id
				orderByClause = 'Id';
			} 
		} else {
			//Order by Id if no ordering criteria has been specified.
			orderByClause =  'Id';
		}
		return orderByClause;
	}
	
	
	@isTest
	public static void testGetUsers() {
		Test.startTest();
			
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_USERLIST);
		//test a basic filter, for coverage.
		IWLUserDAO testInstance = new IWLUserDAO();
		List<sObject> users = testInstance.getRecords(widget);
		
		widget.FilterBasic__c = '';
		widget.sortOrder__c = IWLCodeSettings.SortOrderPicklistAscendingLabel;
		
		//Get the first 10 users
		users = testInstance.getRecords(widget);
		System.assert(users.size() > 0);
		System.assert(testInstance.getRecordsCount(widget) > 0);
		
		//Use an advanced filter and ordering:
		Id firstUserId = (Id)users.get(0).get('Id');
		widget.useAdvancedFiltering__c = true;
		widget.filterAdvanced__c = 'Id = \'' + firstUserId + '\'';
		widget.orderByAdvanced__c = 'Name, Id ASC';
		users = testInstance.getRecords(widget);
		//we should've retrieved the same user from who we retrieved the ID first and used as the filter criteria.
		System.assert(users.size() == 1 && users.get(0).get('Id') == firstUserId);
		
		//for code coverage, test differet orders and filters
		widget.useAdvancedFiltering__c = false;
		widget.FilterBasic__c = null;
		widget.OrderByBasic__c = null;
		users = testInstance.getRecords(widget);
		
		widget.FilterBasic__c = IWLCodeSettings.FilterPicklistNewUsersLabel;
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistCreatedDateLabel;
		users = testInstance.getRecords(widget);
		
		widget.FilterBasic__c = IWLCodeSettings.FilterPicklistNoviceUsersLabel;
		widget.OrderByBasic__c = IWLCodeSettings.OrderByPicklistAlphabeticallyLabel;
		users = testInstance.getRecords(widget);
		
		try {
			widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
			users  = testInstance.getRecords(widget);
		} catch (Exception ex) { /*Do nothing with this exception. it is expected behavior*/}
		Test.stopTest();
	} 
	
	
	@isTest
	public static void testGetAdditionalUserInformation() {
		Test.startTest();
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_USERLIST);
		
		IWLUserDAO testInstance = new IWLUserDAO();
		List<sObject> users = testInstance.getRecords(widget);
		List<Id> userIds = new List<Id>(new Id[] {String.valueOf(users.get(0).get('Id'))});
		Map<Id, AggregateResult> ideasPerUser = getIdeasPerUser(userIds);
		Map<Id, AggregateResult> themesPerUser = getThemesPerUser(userIds);
		Map<Id, AggregateResult> commentsPerUser = getCommentsPerUser(userIds);
		Map<Id, AggregateResult> votesPerUser = getVotesPerUser(userIds);
		system.assert(votesPerUser.containsKey(userIds.get(0)) || !votesPerUser.containsKey(userIds.get(0)) );
		Test.stopTest();
		
	}
	
	@isTest
	public static void testGetSingleRecord() {
		Test.startTest();
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_USERLIST);
		IWLUserDAO testInstance = new IWLUserDAO();
		List<sObject> users = testInstance.getRecords(widget);
		User u = (User) testInstance.getRecord(widget, String.valueOf(users.get(0).get('Id')));
		system.assert(String.valueOf(u.Id) == String.valueOf(users.get(0).get('Id')));
		Test.stopTest();
	}
}