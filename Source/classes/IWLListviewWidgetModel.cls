/**
* This class implements the Model part of the MVC pattern for the Listview Widget, 
* providing methods that translates information brought from the database (Ideas, Idea Themes, Users)
* into instances of IWLListviewWidgetDO so that the view (IWLListviewWidgetView) is able
* to render all the information contained in the original records from database. 
*/
public with sharing class IWLListviewWidgetModel {

    
    private String blankAvatarImage;
    private String defaultIdeaThemeImage;
    
    public String authorDetailPageBaseUrl;  
    public String detailPageBaseUrl;
    
    
    /**
    * This method translates the list of objects provided into a list of IWLListviewWidgetDO instances, 
    * according to the specification given by widget. Depending on widget's Origin__c's value, the list
    * of objects will  be interpreted as Ideas, Idea Themes or Users, and each record will be translated
    * accordingly to an instance of IWLListviewWidgetDO.
    *
    * @param objects the list of records of some object in the database.
    * @param widget a record of IWLWidget__c that specifies which Object type the objects belong to.
    * @param outVisualDataMap A map of the generated instances of IWLListviewWidgetDO, by RecordId.
    * @return a list of IWLListviewWidgetDO, each instance corresponding to one of the objects in the list
    * of objects provided
    * 
    */
    public List<IWLListviewWidgetDO> ObjectToListviewDO(List<sObject> objects, IWLWidget__c widget, Map<String, IWLListviewWidgetDO> outVisualDataMap ) {
        detailPageBaseUrl = (widget.detailPageUrl__c != null && widget.detailPageUrl__c != '') ? (widget.detailPageUrl__c.contains('?') ? widget.detailPageUrl__c : widget.detailPageUrl__c + '?' ) + 'id=' : '/';
        //authorDetailPageBaseUrl = ( widget.authorDetailUrl__c != null && widget.authorDetailUrl__c != '') ? (widget.authorDetailUrl__c.contains('?') ? widget.authorDetailUrl__c : widget.authorDetailUrl__c + '?' ) + 'id=' : '/';
        blankAvatarImage = IWLImageUtilities.getImageUrl(widget, 'emptyAvatarImageUrl__c', IWLCodeSettings.ResourceBlankAvatarImage);

        if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
            return IdeaToListviewDO((List<Idea>)objects, outVisualDataMap, widget);
        } else if (widget.Origin__c == IWLCodeSettings.OriginPicklistUserLabel) {
            return UserToListviewDO((List<User>)objects, outVisualDataMap, widget);
        } if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
            defaultIdeaThemeImage = IWLCodeSettings.ResourceIdeaThemeDefaultImage;
            return IdeaThemeToListviewDO(objects, outVisualDataMap, widget);    
        }
        return new List<IWLListviewWidgetDO>();
    }
    
    /**
    * This method translates the contents of an idea record to an IWLListviewWidgetDO record.
    * @param idea the record of the Idea object to be translated.
    * @param index the index of the IWLListviewWidgetDO that will be created.
    * @return an IWLListviewWidgetDO instance with its information filled from the Idea record, 
    * with the respective index
    */
    public IWLListviewWidgetDO IdeaToListviewDO(Idea idea, Integer index) {
        String objectAPIName = 'Idea';
        IWLListviewWidgetDO dataObjectInstance;
        dataObjectInstance = new IWLListviewWidgetDO();
        dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), idea.Id, null);
        dataObjectInstance.link = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Link', 'Link', detailPageBaseUrl + dataObjectInstance.recordId.value, null);
        dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Title',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Title'), idea.Title, null);
        dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Body',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Body'), idea.Body, null);
        dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('numComments',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'numComments'), String.valueOf(idea.numComments), null );
        dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('VoteTotal', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'VoteTotal'), String.valueOf(idea.VoteTotal/10), null);
        dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('VoteScore', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'VoteScore'), String.valueOf(idea.VoteScore), null);
        dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Dislikes', 'Dislikes', String.valueOf(idea.VoteTotal - idea.VoteScore), null );
        dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('LastModifiedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'LastModifiedDate'), String.valueOf(idea.LastModifiedDate), null);
        dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Status', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Status'), String.valueOf(idea.Status), null);
        dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', '', '', null);//no mapping, yet
        
        //Related topics, i.e. categories for an Idea or Idea Theme.
        if (idea.Categories != null && idea.Categories != '') {
            String [] cats = idea.Categories.split(';');
            dataObjectInstance.relatedTopics.fieldDevName = 'Categories';
            dataObjectInstance.relatedTopics.fieldLabel = IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Categories');
            dataObjectInstance.relatedTopics.valuesList.addAll(cats);
        }
                    
        //author's details
        processAuthorInformation(objectAPIName, idea, dataObjectInstance);
        
        //miscelanneous information
        dataObjectInstance.index = index;
        dataObjectInstance.objectType = Schema.SObjectType.Idea;        
        dataObjectInstance.canVote = true;
        
        
        dataObjectInstance.mergedIdeas = new List<IWLListviewWidgetDO.IWLListviewWidgetMergedIdeasDO>();    
                
        //Parse the IdeaComments associated with this Idea
        dataObjectInstance.feedItems = new List<IWLListviewWidgetDO.IWLListviewWidgetFeedDO>();
        objectAPIName = 'IdeaComment';
        
        List<IdeaComment> relatedComments =  (List<IdeaComment>)idea.getSObjects('Comments');
        if (relatedComments != null) {
            IWLListviewWidgetDO.IWLListviewWidgetFeedDO itemFeed;
            IdeaComment comment;
            //for (Integer comIndex = relatedComments.size() -1; comIndex >=0; comIndex--) {
            for(Integer comIndex = 0; comIndex < relatedComments.size(); comIndex++) {
                comment = relatedComments.get(comIndex);
                itemFeed = new IWLListviewWidgetDO.IWLListviewWidgetFeedDO();
                itemFeed.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommentBody', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'CommentBody'), comment.CommentBody, null);
                itemFeed.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), comment.Id, null);
                
                processRelatedItemAuthorInformation(objectAPIName, comment, itemFeed);
                
                itemFeed.creationDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CreatedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'CreatedDate'), String.valueOf(comment.CreatedDate), null);
                itemFeed.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Likes', 'N/A', null);   
                dataObjectInstance.feedItems.add(itemFeed);
            }
        }   
        return dataObjectInstance;
    }
    
    /**
    * This method converts a list of ideas in a list of IWLListviewWidgetDO instances, mapping the fields accordingly.
    * @param ideas A list of Idea records.
    * @param outVisualDataMap A map of the generated instances of IWLListviewWidgetDO, by RecordId.
    * @param widget the IWLWidget__c record specifying this widget.
    * @return a list of IWLListviewWidgetDO containing an instance for each Idea record in "ideas".
    */
    public List<IWLListviewWidgetDO> IdeaToListviewDO(List<Idea> ideas, Map<String, IWLListviewWidgetDO> outVisualDataMap,
                                                            IWLWidget__c widget) {
        List<IWLListviewWidgetDO> convertedInstances = new List<IWLListviewWidgetDO>();
        IWLListviewWidgetDO dataObjectInstance;
        List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
        
        Integer index = 1;
        for (Idea i : ideas) {
            dataObjectInstance = IdeaToListviewDO(i, index);
            processAdditionalAttributes(dataObjectInstance, i, 'Idea', additionalAttributes);
            convertedInstances.add(dataObjectInstance);
            
            outVisualDataMap.put(dataObjectInstance.recordId.value, dataObjectInstance);
            index++;
        }
        if (widget.loadMerged__c) {
            processAdditionalIdeaInfo(outVisualDataMap);
        }
        return convertedInstances;
        
    }
    
    /**
    * This method translates the contents of an Idea Theme record to an IWLListviewWidgetDO record.
    * @param theme the record of the Idea Theme object to be translated.
    * @param index the index of the IWLListviewWidgetDO that will be created.
    * @return an IWLListviewWidgetDO instance with its information filled from the Idea Theme record, 
    * with the respective index
    */
    public IWLListviewWidgetDO IdeaThemeToListviewDO(sObject theme, Integer index) {
        IWLListviewWidgetDO dataObjectInstance;
        String objectAPIName = 'IdeaTheme';
        
        dataObjectInstance = new IWLListviewWidgetDO();
        dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), (String)theme.get('Id'), null);
        dataObjectInstance.link = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Link', 'Link', detailPageBaseUrl + dataObjectInstance.recordId.value, null);
        dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Title',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Title'), (String)theme.get('Title'), null);
        dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Description',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Description'), (String)theme.get('Description'), null);
        dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Proposed Ideas', '0', null );
        dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Likes', 'N/A', null);
        dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Rating', 'N/A', null);
        dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Dislikes', 'N/A', null );
        dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('LastModifiedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'LastModifiedDate'), String.valueOf(theme.get('LastModifiedDate')), null);
        dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Status', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Status'), (String)theme.get('Status'), null);
        dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLThemeIcon__c', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLThemeIcon__c'), 
                                            ((String)theme.get('IWLThemeIcon__c') == null) ? defaultIdeaThemeImage : IWLImageUtilities.getImageUrl((String)theme.get('IWLThemeIcon__c')), null);
        dataObjectInstance.index = index;
        
        //author's details
        processAuthorInformation(objectAPIName, theme, dataObjectInstance);
        //miscellaneous information
        dataObjectInstance.canVote = false;
        
        //Parse the ideas associated with this Idea Theme
        dataObjectInstance.feedItems = new List<IWLListviewWidgetDO.IWLListviewWidgetFeedDO>(); 
        List<Idea> relatedIdeas = (List<Idea>) theme.getSObjects('Ideas');
        objectAPIName = 'Idea';
        if (relatedIdeas != null) {
            IWLListviewWidgetDO.IWLListviewWidgetFeedDO itemFeed;
            Idea relatedIdea;
            for (Integer ideaIndex = relatedIdeas.size() -1; ideaIndex >= 0; ideaIndex--) {
                relatedIdea = relatedIdeas.get(ideaIndex);
                itemFeed = new IWLListviewWidgetDO.IWLListviewWidgetFeedDO();
                itemFeed.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Title', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Title'), relatedIdea.Title, null);
                itemFeed.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), relatedIdea.Id, null);
                
                processRelatedItemAuthorInformation(objectAPIName, relatedIdea, itemFeed);
                
                itemFeed.creationDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CreatedDate', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'CreatedDate'), String.valueOf(relatedIdea.CreatedDate), null);
                itemFeed.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('VoteTotal', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'VoteTotal'), String.valueOf(relatedIdea.VoteTotal), null);   
                dataObjectInstance.feedItems.add(itemFeed);
            }
        }
        return dataObjectInstance;
    }
    
    /**
    * This method converts a list of idea themes in a list of IWLListviewWidgetDO instances, mapping the fields accordingly.
    * @param ideaThemes A list of Idea Theme records.
    * @param outVisualDataMap A map of the generated instances of IWLListviewWidgetDO, by RecordId.
    * @param widget the IWLWidget__c record specifying this widget.
    * @return a list of IWLListviewWidgetDO containing an instance for each Idea Theme record in "ideaThemes".
    */
    public List<IWLListviewWidgetDO> IdeaThemeToListviewDO(List<SObject> ideaThemes, Map<String, IWLListviewWidgetDO> outVisualDataMap,
                                                            IWLWidget__c widget ) {
        List<IWLListviewWidgetDO> convertedInstances = new List<IWLListviewWidgetDO>();
        IWLListviewWidgetDO dataObjectInstance;
        List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
        
        Integer index = 1;
        for (SObject theme : ideaThemes ) {
            dataObjectInstance = IdeaThemeToListviewDO(theme, index);
            convertedInstances.add(dataObjectInstance);
            processAdditionalAttributes(dataObjectInstance, theme, 'IdeaTheme', additionalAttributes);
            outVisualDataMap.put(dataObjectInstance.recordId.value, dataObjectInstance);
            index++;
        }
        processAdditionalIdeaThemeInfo(outVisualDataMap);
        return convertedInstances;
    }
    
    public IWLListviewWidgetDO UserToListviewDO(User user, Integer index) {
        String objectAPIName = 'User';
        IWLListviewWidgetDO dataObjectInstance;     
        dataObjectInstance = new IWLListviewWidgetDO();
            
        dataObjectInstance.recordId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), user.Id, null);
        dataObjectInstance.link = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Link', 'Link', detailPageBaseUrl + dataObjectInstance.recordId.value, null);
        /*dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
                                        ( ( user.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getImageUrl(user.IWLAvatarId__c) ), null);  */      
        dataObjectInstance.imageURL = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
                                        ( ( user.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getFacebookImage(user.IWLAvatarId__c) ), null); 
        dataObjectInstance.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname',  '', user.CommunityNickname, null);
        dataObjectInstance.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('AboutMe',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'AboutMe'), user.AboutMe, null);
        dataObjectInstance.feedSize = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IdeaComment', IWLDynamicDescribeUtils.Instance.getObjectPluralLabel('IdeaComment'), 'N/A', null );
        dataObjectInstance.likes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Vote', IWLDynamicDescribeUtils.Instance.getObjectPluralLabel('Vote'), 'N/A', null);
        dataObjectInstance.rating = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Idea', IWLDynamicDescribeUtils.Instance.getObjectPluralLabel('Idea'), 'N/A', null);
        dataObjectInstance.dislikes = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Dislikes', 'N/A', null );
        dataObjectInstance.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Last Activity Date', 'N/A', null);
        dataObjectInstance.status = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('', 'Status', 'N/A', null);
        dataObjectInstance.authorId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Id', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Id'), user.Id, null);      
        /*dataObjectInstance.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute(
            'IWLAvatarId__c', 
            IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
            ( ( user.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getImageUrl(user.IWLAvatarId__c) ), 
            null
        );*/
        dataObjectInstance.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute(
            'IWLAvatarId__c', 
            IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'IWLAvatarId__c'), 
            ( ( user.IWLAvatarId__c == null )? blankAvatarImage : IWLImageUtilities.getFacebookImage(user.IWLAvatarId__c) ), 
            null
        );              
        dataObjectInstance.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('Email',  IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'Email'), user.Email, null);
        
        //miscelanneous information
        dataObjectInstance.index = index;
        dataObjectInstance.objectType = Schema.SObjectType.User;        
        dataObjectInstance.feedItems = new List<IWLListviewWidgetDO.IWLListviewWidgetFeedDO>();
        dataObjectInstance.canVote = false;
        
        return dataObjectInstance;
    }
    
    /**
    * This method converts a list of Users in a list of IWLListviewWidgetDO instances, mapping the fields accordingly.
    * @param users A list of User records.
    * @param outVisualDataMap A map of the generated instances of IWLListviewWidgetDO, by RecordId.
    * @param widget the IWLWidget__c record specifying this widget.
    * @return a list of IWLListviewWidgetDO containing an instance for each User record in "users".
    */
    public List<IWLListviewWidgetDO> UserToListviewDO(List<User> users, Map<String, IWLListviewWidgetDO> outVisualDataMap,
                                                            IWLWidget__c widget) {
        List<IWLListviewWidgetDO> convertedInstances = new List<IWLListviewWidgetDO>();
        IWLListviewWidgetDO dataObjectInstance;
        List<String> additionalAttributes = IWLWidgetDAO.getAdditionalFieldsList(widget);
        
        Integer index = 1;
        for (User u : users) {
            dataObjectInstance = UserToListviewDO(u, index);
            processAdditionalAttributes(dataObjectInstance, u, 'User', additionalAttributes);
            convertedInstances.add(dataObjectInstance);
            outVisualDataMap.put(dataObjectInstance.recordId.value, dataObjectInstance);
            index++;
        }
        if (widget.loadUserStats__c) {
            processAdditionalUserInfo(outVisualDataMap);
        }
        return convertedInstances;
    }
    
    /**
    * This method works only when processing users, and fills in outVisualDataMap the information about the
    * Number of comments, ideas and votes that a user has made.
    *
    */
    private void processAdditionalUserInfo(Map<String, IWLListviewWidgetDO> outVisualDataMap) {
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
    * This method works only when processing ideas, and fills in outVisualDataMap the information about 
    * the ideas that have been merged with the ideas being processed.
    *
    */
    private void processAdditionalIdeaInfo(Map<String, IWLListviewWidgetDO> outVisualDataMap) {
        List<String> IdeasIds = new List<String>(outVisualDataMap.keySet());
        
        List<Idea> ideasWithParent = IWLIdeaDAO.getMergedIdeas(IdeasIds);
        
        for (Idea mergedIdea : ideasWithParent) {
            IWLListviewWidgetDO parentIdeaData = outVisualDataMap.get(mergedIdea.ParentIdeaId);
            IWLListviewWidgetDO.IWLListviewWidgetMergedIdeasDO mergedIdeaData;
            
            mergedIdeaData = new IWLListviewWidgetDO.IWLListviewWidgetMergedIdeasDO();
            mergedIdeaData.Id = mergedIdea.Id;
            mergedIdeaData.Title = mergedIdea.Title;
            processMergedIdeaAuthorInformation(mergedIdea, mergedIdeaData);
            parentIdeaData.mergedIdeas.add(mergedIdeaData);
        
        }
    }
    
    /**
    * This method works only when processing idea themes, and fills in outVisualDataMap the information about 
    * the ideas that have been posted to the Idea Themes being processed.
    *
    */
    private void processAdditionalIdeaThemeInfo(Map<String, IWLListviewWidgetDO> outVisualDataMap) {
        if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
            List<String> ideaThemesIds = new List<String>(outVisualDataMap.keySet());
            
            Map<Id, AggregateResult> ideasPerTheme = IWLIdeaDAO.getIdeasCountPerTheme(ideaThemesIds);
            
            for (String themeId : ideaThemesIds) {
                
                outVisualDataMap.get(themeId).feedSize.value = ideasPerTheme.get(themeId) != null ? String.valueOf(ideasPerTheme.get(themeId).get('IdeasPerTheme')) : '0';
                
            }
        }
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
        if (record.getSObject('CreatedBy') == null || record.getSObject('CreatedBy').get('id') == null) {
            //the author's information is not available
            displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), Label.IWL_INTERNAL_USER_COMMUNITY_NICKNAME, null);
            displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), blankAvatarImage, null);
        } else {
            //the author's information is available
            displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), (String)record.getSObject('CreatedBy').get('CommunityNickname'), null);
            /*displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), 
                                            ( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getImageUrl((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')), null); */
            displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), 
                                            ((String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getFacebookImage((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')), null);    
        }
        
        
    }
    
    /**
    * Same as "processAuthorInformation" but for Merged Ideas
    */ 
    private void processMergedIdeaAuthorInformation(sObject record, IWLListviewWidgetDO.IWLListviewWidgetMergedIdeasDO displayObject) {
        displayObject.authorId = String.valueOf(record.get('CreatedById'));
        if (record.getSObject('CreatedBy') == null || record.getSObject('CreatedBy').get('Id') == null) {
            //the author's information is not available
            displayObject.authorName = Label.IWL_INTERNAL_USER_COMMUNITY_NICKNAME;
            displayObject.authorImage = blankAvatarImage;
        } else {
            //the author's information is available
            displayObject.authorName = (String)record.getSObject('CreatedBy').get('CommunityNickname');
            //displayObject.authorImage = ( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getImageUrl((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')); 
            displayObject.authorImage = ( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getFacebookImage((String)record.getSObject('CreatedBy').get('IWLAvatarId__c'));  
        }
    }
    
    
    /**
    * Same as "processAuthorInformation" but for related ideas/comments
    */
    private void processRelatedItemAuthorInformation(String objectAPIName, sObject record, IWLListviewWidgetDO.IWLListviewWidgetFeedDO displayObject) {
        displayObject.authorId = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CreatedById', IWLDynamicDescribeUtils.Instance.getFieldLabel(objectAPIName, 'CreatedById'), String.valueOf(record.get('CreatedById')), null);
        if (record.getSObject('CreatedBy') == null || record.getSObject('CreatedBy').get('Id') == null) {
            //the author's information is not available
            displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), Label.IWL_INTERNAL_USER_COMMUNITY_NICKNAME, null);
            displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), blankAvatarImage, null);
        } else {
            //the author's information is available
            displayObject.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('CommunityNickname', IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'CommunityNickname'), (String)record.getSObject('CreatedBy').get('CommunityNickname'), null);
            /*displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), 
                                            ( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getImageUrl((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')), null);    */
            displayObject.authorImage = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('IWLAvatarId__c', 
                                            IWLDynamicDescribeUtils.Instance.getFieldLabel('User', 'IWLAvatarId__c'), 
                                            ( (String)record.getSObject('CreatedBy').get('IWLAvatarId__c') == null )? blankAvatarImage : IWLImageUtilities.getFacebookImage((String)record.getSObject('CreatedBy').get('IWLAvatarId__c')), null);
        }
        
        
    }
    
    /**
    * Translates the information for all additional attributes that have been added in the widget's configuration
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
    
    public static testMethod void testIWLListviewWidgetModel() {
        Test.startTest();
        IWLListviewWidgetModel c = new IWLListviewWidgetModel();
        
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
        Map<String, IWLListviewWidgetDO> visualDataMap = new Map<String, IWLListviewWidgetDO>();
        IWLBaseDAO helperController = new IWLIdeaDAO();
        
        IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
        
        widget.additionalFields__c = 'Id';
        
        records = helperController.getRecords(widget);
        
        List<IWLListviewWidgetDO> visualData = c.ObjectToListviewDO( records, 
            widget,
            visualDataMap
        );
        
        if (records.size() > 0) {
            system.assert(visualDataMap.containsKey(String.valueOf(records.get(0).get('Id'))));
        }
        
        visualDataMap = new Map<String, IWLListviewWidgetDO>();
        widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
        helperController = new IWLUserDAO();
        records = helperController.getRecords(widget);
        visualData = c.ObjectToListviewDO(records, 
            widget,
            visualDataMap
        );
        if (records.size() > 0) {
            system.assert(visualDataMap.containsKey(String.valueOf(records.get(0).get('Id'))));
        }
        widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
        helperController = new IWLIdeaThemeDAO();
        records = helperController.getRecords(widget);
        visualDataMap = new Map<String, IWLListviewWidgetDO>();
        visualData = c.ObjectToListviewDO( records, 
            widget,
            visualDataMap
        );
        if (records.size() > 0) {
            system.assert(visualDataMap.containsKey(String.valueOf(records.get(0).get('Id'))));
        }
        
        Test.stopTest();
    }
    
    
    
}