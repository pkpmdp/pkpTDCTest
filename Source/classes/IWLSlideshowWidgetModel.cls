/**
* This class implements the Model part of the MVC pattern for the Slideshow Widget, 
* providing methods that translates information brought from the database (Ideas, Idea Themes, Users)
* into instances of IWLSlideshowWidgetDO so that the view (IWLSlideshowWidgetView) is able
* to render all the information contained in the original records from database. 
*/
public with sharing class IWLSlideshowWidgetModel {
	
	private String blankAvatarImage; 
	private String defaultIdeaThemeImage;

	/**
	* This method translates the list of objects provided into a list of IWLSlideshowWidgetDO instances, 
	* according to the specification given by widget. Depending on widget's Origin__c's value, the list
	* of objects will  be interpreted as Ideas, Idea Themes or Users, and each record will be translated
	* accordingly to an instance of IWLSlideshowWidgetDO.
	*
	* @param objects the list of records of some object in the database.
	* @param widget a record of IWLWidget__c that specifies which Object type the objects belong to.
	* @return a list of IWLSlideshowWidgetDO, each instance corresponding to one of the objects in the list
	* of objects provided
 	*/
	public List<IWLSlideshowWidgetDO> ObjectToSlideshowDO(List<sObject> objects, IWLWidget__c widget) {
		blankAvatarImage = IWLImageUtilities.getImageUrl(widget, 'emptyAvatarImageUrl__c', IWLCodeSettings.ResourceBlankAvatarImage);
		
		
		if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
			//The records are from the Idea object
			return IdeaToSlideshowDO((List<Idea>)objects, widget);
		} else if (widget.Origin__c == IWLCodeSettings.OriginPicklistUserLabel) {
			//the records are from the User object
			return UserToSlideshowDO((List<User>)objects, widget);
		} else if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
			defaultIdeaThemeImage = IWLCodeSettings.ResourceIdeaThemeDefaultImage;
			//the records are from the Idea Theme object
			return IdeaThemeToSlideshowDO(objects, widget);
		}
		return new List<IWLSlideshowWidgetDO>();
	}
	
	/**
	* This method converts a list of ideas in a list of IWLSlideshowWidgetDO instances, mapping the fields accordingly.
	* @param ideas A list of Idea records.
	* @param widget the IWLWidget__c record specifying this widget.
	* @return a list of IWLSlideshowWidgetDO containing an instance for each Idea record in "ideas".
	*/
	public List<IWLSlideshowWidgetDO> IdeaToSlideshowDO(List<Idea> ideas, IWLWidget__c widget) {
		List<IWLSlideshowWidgetDO> convertedInstances = new List<IWLSlideshowWidgetDO>();
		IWLSlideshowWidgetDO dataObjectInstance;		
		List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
		
		String objectAPIName = 'Idea';
		
		Integer index = 0;
		for (Idea i : ideas) {
			dataObjectInstance = new IWLSlideshowWidgetDO();
			dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), i.Id, null);
			dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Title',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Title'), i.Title, null);
			dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Body',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Body'), i.Body, null);
			dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('numComments',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'numComments'), String.valueOf(i.numComments), null );
			dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('VoteTotal', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'VoteTotal'), String.valueOf(i.VoteTotal), null);
			dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('VoteScore', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'VoteScore'), String.valueOf(i.VoteScore), null);
			dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Dislikes', 'Dislikes', String.valueOf(i.VoteTotal - i.VoteScore), null );
			dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('LastModifiedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'LastModifiedDate'), String.valueOf(i.LastModifiedDate), null);
			dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Status', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Status'), String.valueOf(i.Status), null);
			dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', '', '', null);//no mapping, yet
			
			//Related topics, i.e. categories for an Idea or Idea Theme.
			if (i.Categories != null && i.Categories != '') {
				String [] cats = i.Categories.split(';');
				dataObjectInstance.relatedTopics.fieldDevName = 'Categories';
				dataObjectInstance.relatedTopics.fieldLabel = IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Categories');
				dataObjectInstance.relatedTopics.valuesList.addAll(cats);
			}
						
			//author's details
			processAuthorInformation(objectAPIName, i, dataObjectInstance);
			//miscelanneous information
			dataObjectInstance.index = index;
			dataObjectInstance.objectType = Schema.SObjectType.Idea;			
			
			//additional attributes specified by the user in widget's configuration.
			processAdditionalAttributes(dataObjectInstance, i, objectAPIName, additionalAttributes);
			
			convertedInstances.add(dataObjectInstance);
			index++;
		}
		
		return convertedInstances;
	}
	
	/**
	* This method converts a list of Users in a list of IWLSlideshowWidgetDO instances, mapping the fields accordingly.
	* @param users A list of User records.
	* @param widget the IWLWidget__c record specifying this widget.
	* @return a list of IWLSlideshowWidgetDO containing an instance for each User record in "users".
	*/
	public List<IWLSlideshowWidgetDO> UserToSlideshowDO(List<User> users, IWLWidget__c widget) {
		List<IWLSlideshowWidgetDO> convertedInstances = new List<IWLSlideshowWidgetDO>();
		IWLSlideshowWidgetDO dataObjectInstance;
		List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
		
		String objectAPIName = 'User';
		
		Integer index = 0;
		Map<String, IWLSlideshowWidgetDO> outVisualDataMap = new Map<String, IWLSlideshowWidgetDO>();
		for (User u : users) {
			dataObjectInstance = new IWLSlideshowWidgetDO();
			
			dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), u.Id, null);
			dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), IWLImageUtilities.getImageUrl(u.IWLAvatarId__c), null);			
			dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname',  '', u.CommunityNickname, null);
			dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('AboutMe',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'AboutMe'), u.AboutMe, null);
			dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Feed Size', 'N/A', null );
			dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Likes', 'N/A', null);
			dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Rating', 'N/A', null);
			dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Dislikes', 'N/A', null );
			dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Last Activity Date', 'N/A', null);
			dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Status', 'N/A', null);
			dataObjectInstance.authorId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), u.Id, null);
			dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
										IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
											( u.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getImageUrl(u.IWLAvatarId__c), null);
			dataObjectInstance.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Email',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Email'), u.Email, null);
			dataObjectInstance.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
										IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
											( u.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getImageUrl(u.IWLAvatarId__c), null);
			//miscelanneous information
			dataObjectInstance.index = index;
			dataObjectInstance.objectType = Schema.SObjectType.User;
									
			processAdditionalAttributes(dataObjectInstance, u, 'User', additionalAttributes);
			outVisualDataMap.put(dataObjectInstance.recordId.value, dataObjectInstance);
			convertedInstances.add(dataObjectInstance);
			index++;
		}
		processAdditionalUserInfo(outVisualDataMap);
		return convertedInstances;
	}
	
	/**
	* This method converts a list of idea themes in a list of IWLSlideshowWidgetDO instances, mapping the fields accordingly.
	* @param ideaThemes A list of Idea Theme records.
	* @param widget the IWLWidget__c record specifying this widget.
	* @return a list of IWLSlideshowWidgetDO containing an instance for each Idea Theme record in "ideaThemes".
	*/
	public List<IWLSlideshowWidgetDO> IdeaThemeToSlideshowDO(List<sObject> ideaThemes, IWLWidget__c widget) {
		List<IWLSlideshowWidgetDO> convertedInstances = new List<IWLSlideshowWidgetDO>();
		IWLSlideshowWidgetDO dataObjectInstance;
		List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
		
		String objectAPIName = 'IdeaTheme';
		
		Integer index = 0;
		Map<String, IWLSlideshowWidgetDO> outVisualDataMap = new Map<String, IWLSlideshowWidgetDO>();
		for (SObject theme : ideaThemes ) {
			dataObjectInstance = new IWLSlideshowWidgetDO();
			
			dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), (String)theme.get('Id'), null);
			dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Title',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Title'), (String)theme.get('Title'), null);
			dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Description',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Description'), (String)theme.get('Description'), null);
			dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Proposed Ideas', '0', null );
			dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Likes', 'N/A', null);
			dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Proposed Ideas', '0', null);
			dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Dislikes', 'N/A', null );
			dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('LastModifiedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'LastModifiedDate'), String.valueOf(theme.get('LastModifiedDate')), null);
			dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Status', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Status'), (String)theme.get('Status'), null);
			dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLThemeIcon__c', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLThemeIcon__c'), 
											((String)theme.get('IWLThemeIcon__c') == null) ? defaultIdeaThemeImage : IWLImageUtilities.getImageUrl((String)theme.get('IWLThemeIcon__c')), null);
			dataObjectInstance.index = index;
			processAuthorInformation(objectAPIName, theme, dataObjectInstance);
			
			processAdditionalAttributes(dataObjectInstance, theme, objectAPIName, additionalAttributes);	
			convertedInstances.add(dataObjectInstance);
			outVisualDataMap.put(dataObjectInstance.recordId.value, dataObjectInstance);
			index++;
		}
		processAdditionalIdeaThemeInfo(outVisualDataMap);
		return convertedInstances;
	}
	
	
	/**
	* This method is responsible for getting and translating the record's creator information to the displayObject,
	* if available, or setting default values if not.
	* @param objectAPIName the api name of the object from which a record is being processed
	* @param record the record from which the creator's information must be retrieved and translated.
	* @param displayObject the object where all the translated information goes into.
	*/
	private void processAuthorInformation(String objectAPIName, sObject record, IWLSlideshowWidgetDO displayObject) {
		displayObject.authorId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CreatedById', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'CreatedById'), String.valueOf(record.get('CreatedById')), null);
		if (record.getSObject('CreatedBy') == null || record.getSObject('CreatedBy').get('Id') == null) {
			//the author's information is not available
			displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), Label.IWL_INTERNAL_USER_COMMUNITY_NICKNAME, null);
			displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
											IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), blankAvatarImage, null);
		} else {
			//the author's information is available
			displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), (String)record.getSObject('CreatedBy').get('CommunityNickname'), null);
			displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
											IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), 
											( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getImageUrl((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')), null);	
		}
		
		
	}
	
	/**
	* This method works only when processing users, and fills in outVisualDataMap the information about the
	* Number of comments, ideas and votes that a user has made.
	*
	*/
	private void processAdditionalUserInfo(Map<String, IWLSlideshowWidgetDO> outVisualDataMap) {
		List<String> userIds = new List<String>(outVisualDataMap.keySet());
		Map<Id, AggregateResult> commentsPerUser = IWLUserDAO.getCommentsPerUser(userIds);
		Map<Id, AggregateResult> ideasPerUser = IWLUserDAO.getIdeasPerUser(userIds);
		Map<Id, AggregateResult> votesPerUser = IWLUserDAO.getVotesPerUser(userIds);
		
		for (String uId : userIds) {			
			outVisualDataMap.get(uId).feedSize.value = commentsPerUser.get(uId) != null ? String.valueOf(commentsPerUser.get(uId).get('CommentsPerUser')) : '0';
			outVisualDataMap.get(uId).rating.value = ideasPerUser.get(uId) != null ? String.valueOf(ideasPerUser.get(uId).get('IdeasPerUser')) : '0';
			outVisualDataMap.get(uId).likes.value = votesPerUser.get(uId) != null ? String.valueOf(votesPerUser.get(uId).get('VotesPerUser')) : '0';
		}
	}
	
	/**
	* This method works only when processing idea themes, and fills in outVisualDataMap the information about 
	* the ideas that have been posted to the Idea Themes being processed.
	*
	*/
	private void processAdditionalIdeaThemeInfo(Map<String, IWLSlideshowWidgetDO> outVisualDataMap) {
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			List<String> ideaThemesIds = new List<String>(outVisualDataMap.keySet());
			
			Map<Id, AggregateResult> ideasPerTheme = IWLIdeaDAO.getIdeasCountPerTheme(ideaThemesIds);
			
			for (String themeId : ideaThemesIds) {
				
				outVisualDataMap.get(themeId).feedSize.value = ideasPerTheme.get(themeId) != null ? String.valueOf(ideasPerTheme.get(themeId).get('IdeasPerTheme')) : '0';
				outVisualDataMap.get(themeId).rating.value = ideasPerTheme.get(themeId) != null ? String.valueOf(ideasPerTheme.get(themeId).get('IdeasPerTheme')) : '0';
			}
		}
	}
	
	
	/**
	* This method processes and transforms all the information that comes from the fields marked as "additional" in the widget
	*/
	private void processAdditionalAttributes(IWLSlideshowWidgetDO displayObject, sObject obj, String objectDevName, 
															List<String> additionalAttributes) {
		IWLSlideshowWidgetDO.IWLWidgetDOAttribute displayAttribute;
		for (String devName : additionalAttributes) {
			displayAttribute = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute();
			displayAttribute.fieldDevName = devName;
			displayAttribute.fieldLabel = IWLDynamicDescribeUtils.Instance.getFieldLabel(objectDevName, devName);
			displayAttribute.value = String.valueOf(obj.get(devName));
			displayObject.additionalAttributesMap.put(devName, displayAttribute);
		}
	}
	
	
	@isTest
	static void testSlideshowWidgetModel() {
		Test.startTest();
		
		IWLSlideshowWidgetModel c = new IWLSlideshowWidgetModel();
    	
    	Community com = IWLTestUtilities.getCommunity();
    	Idea i = IWLTestUtilities.createIdea( 'Egg is an egg more than egg', 'Egg is an egg more than egg', com.Id );
		IWLTestUtilities.createIdeaComment( 'Egg is an egg more than egg' , i.Id );
		sobject theme = null;
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			theme = IWLTestUtilities.createIdeaTheme('Title', 'Description', 'Active', com.Id);
			i.put('IdeaThemeId', String.valueOf(theme.get('Id')));
			update i;
		}
		List<sObject> records = new List<sObject>();
		
		IWLBaseDAO helperController = new IWLIdeaDAO();
		
    	IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASSLIDESHOW);
    	
    	widget.additionalFields__c = 'Id';
    	
    	records = helperController.getRecords(widget);
    	
    	List<IWLSlideshowWidgetDO> visualData = c.ObjectToSlideshowDO( records, 
    		widget
    	);
    	
    	if (records.size() > 0) {
    		system.assert(records.size() == visualData.size());
    	}
    	
    	
    	widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
		helperController = new IWLUserDAO();
		records = helperController.getRecords(widget);
    	visualData = c.ObjectToSlideshowDO(records, 
    		widget
    	);
    	if (records.size() > 0) {
    		system.assert(records.size() == visualData.size());
    	}
    	widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
    	helperController = new IWLIdeaThemeDAO();
    	records = helperController.getRecords(widget);
    	
    	visualData = c.ObjectToSlideshowDO( records, 
    		widget
    	);
    	if (records.size() > 0) {
    		system.assert(records.size() == visualData.size());
    	}
    			 	
		Test.stopTest();
	}

}