/**
* This class implements the controller part of the MVC pattern for the Listview Widget.
*/
public with sharing class IWLListviewWidgetController extends IWLBaseWidgetController {
    
    public final static String VOTEUP = IWLCodeSettings.VOTEUP;
    public final static String VOTEDOWN = IWLCodeSettings.VOTEDOWN; 
    public final static String ORIGIN_CSS_CLASS_PREFIX = 'IWLListview';
    public final static String PARAM_IDEA_ID = 'idi';
    public final static String PARAM_COMMENT_BODY = 'txt';

    private List<sObject> queriedResults {get; set;}
    public Map<Id, sObject> sObjResultMap {get; set;}
    public List<IWLListviewWidgetDO> visualDataList {get; set;}
    private Map<String, IWLListviewWidgetDO> visualDataMap {get; set;}
    private List<String> voteExcludeIdList {get; set;}


    //attributes for the "comment" feature
    public Boolean successfulComment {get; set;}
    public String commentSuccess {get; set;}

    //attributes for the "vote" feature
    public String voteIdeaId { get; set; }
    public String voteType { get; set; }
    public Integer voteTotal { get; set; }
    public Boolean successfulVote {get; set;}
    
    
    //attributes for the pagination panel
    public Integer currentPageIndex {get; set;}
    public Integer totalRecords {get; set;}
    public Integer pageCount {get; set;}
    public Boolean pageChanged {get; set;}
    public String ideaID{get;set;} 
    public String commentIdeaId{get;set;}
    public String listViewMessage {get; set;}          
    
    
    //A message string to show information to the user
    public String message {get; set;}
    
    public IWLListviewWidgetController() {
        listViewMessage = 'Tryk venligst på knappen igen';
    }
    
    public Integer getMaxCommentSize() {
    return IWLCodeSettings.MAX_COMMENT_SIZE;
    }
    public String getIdeaID() {
        String valueOne = Apexpages.currentPage().getParameters().get(PARAM_IDEA_ID);
         return valueOne;   
    }
    
    public PageReference redirectToDetailPage() {
            PageReference reference=new PageReference('/apex/youbioIdeaDetail?id='+commentIdeaId);
            reference.setRedirect(true);
            return reference;
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
        if (widgetRecord.Type__c == IWLCodeSettings.ListviewRecordTypeName) {
                            //the widget record has been loaded and has the correct type

            try {
                voteExcludeIdList = new List<String>();
                if( widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistRSSLabel ){
                    this.visualDataList = IWLRSSDAO.getRecords(widgetRecord);
                    currentPageIndex = 0;
                }else{
                    loadPaginationInfo(widgetRecord);
                    loadResultsByPage(currentPageIndex);
                }
                return true;
            } catch (Exception ex) {
                message = ex.getMessage();
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.error, message );
                ApexPages.addMessage(msg);     
                //LoadErrorMessage = ex.getMessage();
                return false;
            }
                    
        } else {
            //Wrong Widget record's type.
            message = 'Wrong widget type';
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.error, message );
            ApexPages.addMessage(msg);
            //LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
            return false;
        }
    }    
    
    /**
    * This method obtains from the database the records that must be shown in this widget according to the parameters set in 
    * "widget". 
    * @param widget the record of the IWLWidget__c object that specifies which object must be listed in this widget.
    * @return a list of records retrieved from the database, according to the specification given by "widget"
    */
    public List<sObject> getRecords(IWLWidget__c widget) {
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
        daoInstance.queryOffset = currentPageIndex * Integer.valueOf(widget.listSize__c);
        
        return daoInstance.getRecords(widget);
        
    }
    
    /**
    * This method implements the action to vote for an Idea/Idea Theme, promoting or demoting it.
    * @param voteIdeaId This attribute will hold the Id of the idea/theme that is being voted
    * @param voteType This attribute will provide the type of vote the user is doing (Up or Down)
    * @return a null page reference so the component can be reloaded.
    */
    public PageReference vote() {
        System.debug('*****Wen vote method start'+voteIdeaId);    
        message = '';
        clearMessages();
        successfulVote = false;
        voteType= 'Up';        
        if (voteIdeaId != null && voteType != null) {
            
            List<Idea> votedIdea = new List<Idea>();
            
            try {
                
                SecurityManager.canAccess(Idea.sObjectType);
                
                votedIdea = [Select Id, CreatedById, ParentIdeaId from Idea where Id = :voteIdeaId limit 1];
                                
                if ( votedIdea.size() == 0 ) {
                    //The idea does not exist.
                    //message = Label.IWL_NO_EXIST;
                    //addMessage(ERROR_MESSAGE, message);
                    listViewMessage = 'Ide eksisterer ikke';
                    return null;
                }
            } catch(SecurityManager.SecurityException ex) {
                //message = ex.getMessage();
                //addMessage(ERROR_MESSAGE, message);
                listViewMessage = ex.getMessage();
                return null;
            }

            
            if (votedIdea[0].ParentIdeaId <> null){
                //the idea has been merged, so we vote on the parent idea.
                voteIdeaId = votedIdea[0].ParentIdeaId;
                return vote();
            }
            try {
                if (!canVote(votedIdea[0])) {
                    //message = 'ListView: you are not allowed to vote for this idea' ;
                    //addMessage(ERROR_MESSAGE, Label.IWL_CANT_VOTE_ON_IDEA);
                    System.debug('*****Wen can not vote');                        
                    listViewMessage = 'Du har ikke tilladelse til at stemme';                  
                    return null;
                }

            } catch (SecurityManager.SecurityException ex) {
               listViewMessage = ex.getMessage();
               //message = ex.getMessage();
               //addMessage(ERROR_MESSAGE, message);
               return null; 
            } catch (Exception ex) {
                listViewMessage = ex.getMessage();
                //message = ex.getMessage();
                //addMessage(ERROR_MESSAGE, message);
                 return null;
            }
        
            Vote newVote = new Vote(ParentId = voteIdeaId, Type = voteType );
            message = Label.IWL_VOTING;
            try {
                insert newVote;
                //message = Label.IWL_VOTED;
                //addMessage(SUCCESS_MESSAGE, message);
                System.debug('***Wen vote success');
                //prepare the widget to be refreshed:
                voteTotal = Integer.valueOf([Select Id, VoteTotal from Idea where Id = :voteIdeaId limit 1].VoteTotal);
                successfulVote = true;
                listViewMessage = 'Tak for din stemme';
                doLoad();
                // if we've reached this point, the vote was completed successfully 
            } catch (System.DmlException e) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Voting disabled'));
                // ignore - most likely they tried to vote twice in 2 browser windows
                //message = Label.IWL_NO_VOTE + ' ' + voteIdeaId + ';' + voteType + ';' + e.getMessage();
                //addMessage(ERROR_MESSAGE, message);
                listViewMessage = e.getMessage();
            }
        
        
        } else {
            //message = Label.IWL_VOTE_NULL + '' + voteIdeaId + ';' + voteType;
            listViewMessage = 'System error, please contact administrator';
        }
        //PageReference pg = Apexpages.currentPage();
        //pg.setRedirect(true);
        return null;
    }
    
    public Boolean canComment {
      get {
        if (canComment == null) {
          canComment = (widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) &&
            (SecurityManager.isAccessible(IdeaComment.sObjectType) && SecurityManager.isAccessible(new Schema.Sobjectfield[]{IdeaComment.CommentBody}));
        }
        
        return canComment;
      } set;
    }
    
    /**
    * This method implements the action to comment for an Idea/Idea Theme.
    * @return a null page reference so the component can be reloaded.
    */ 
    public PageReference IWLListViewComment() {
        clearMessages();
        successfulComment = false;
        
        String valueOne = Apexpages.currentPage().getParameters().get(PARAM_IDEA_ID);
        String valueTwo = Apexpages.currentPage().getParameters().get(PARAM_COMMENT_BODY);
        if (valueOne == null || valueOne == '') {
          addMessage(ERROR_MESSAGE, Label.IWL_IDEA_FOR_COMMENT_EMPTY);
          commentSuccess = JSON.serialize(new IdeaComment( IdeaId = valueOne));
          successfulComment = true;
          return null;
        }
        if (valueTwo == null || valueTwo == '') {
          addMessage(ERROR_MESSAGE, Label.IWL_COMMENT_CANNOT_BE_EMPTY);
          commentSuccess = JSON.serialize(new IdeaComment( IdeaId = valueOne));
          successfulComment = true;
          return null;
        }
       if (canComment) {
         try {
            IdeaComment c = new IdeaComment( IdeaId = valueOne, CommentBody= valueTwo );
            insert c;
            c = [ Select Id, IdeaId, CommentBody, CreatedById, CreatedDate, SystemModstamp, IsDeleted, IsHtml, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.IWLAvatarId__c From IdeaComment where Id = :c.Id limit 1];
            String blankAvatarImage = IWLImageUtilities.getImageUrl(widgetRecord, 'emptyAvatarImageUrl__c', IWLCodeSettings.ResourceBlankAvatarImage);
        c.CreatedBy.IWLAvatarId__c = (c.CreatedBy.IWLAvatarId__c == null ) ? blankAvatarImage : IWLImageUtilities.getImageUrl(c.CreatedBy.IWLAvatarId__c);
        
            commentSuccess = JSON.serialize(c);
    
            successfulComment = true;
        message= Label.IWL_COMMENT_SUCCESS;
        addMessage(SUCCESS_MESSAGE, message);
         } catch (Exception ex) {
           addMessage(ERROR_MESSAGE, ex.getMessage());
            commentSuccess = JSON.serialize(new IdeaComment( IdeaId = valueOne));
            successfulComment = true;
            return null;
         }
       } else {
         message = Label.IWL_CANT_COMMENT_IDEA;
         addMessage(ERROR_MESSAGE, message);
       }
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


    public Boolean ShowDetailedView {
        get {
            if (widgetRecord == null) return false;
            return (widgetRecord.viewType__c == IWLCodeSettings.ViewtypePicklistDetailedLabel);
        }
    }
    
    /**
    * Checks if the user can vote on the idea
    * @return true iif the user is not the creator of the idea and has not voted on it.
    */
    public Boolean canVote(Idea idea) {
        
            SecurityManager.canCreate(Vote.sObjectType);
            Id currentUserId = UserInfo.getUserId();
                    
            if (idea.CreatedById == currentUserId) {
                return false;
            }
            List<Vote> votesForUser = [Select Id from Vote where ParentId = :idea.Id and CreatedById = :currentUserId limit 1];
            return votesForUser.size() == 0;        
    }
    
    /**
    ** Methods for the pagination feature **
    **/
    
    
    /**
    * This method measures the pagination parameters for the widget, counting the amount of pages of feeds that can be shown
    */
    private void loadPaginationInfo(IWLWidget__c widget) {
        currentPageIndex = 0;
        
        if (widgetRecord != null && widgetRecord.showPagination__c) {
            if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
                //we are to list Ideas, get them from the IWLIdeaDAO
                totalRecords = new IWLIdeaDAO().getRecordsCount(widget);
            } else if (widget.Origin__c == IWLCodeSettings.OriginPicklistUserLabel) {
                //we are to list Users, get them from the IWLUserDAO
                totalRecords = new IWLUserDAO().getRecordsCount(widget);
            } else if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
                //we are to list Idea Themes, get them from the IWLIdeaThemeDAO
                totalRecords = new IWLIdeaThemeDAO().getRecordsCount(widget);
            }   
            Integer listSize =  Integer.valueOf(widgetRecord.listSize__c);
            pageCount = Integer.valueOf(math.ceil(totalRecords / widgetRecord.listSize__c));
                
        } else {
            
            totalRecords = 0;
            pageCount = 1;
        }
    }
    
    
    public PageReference showNextPage() {
        if (!hasNextPage) return null; //there isn't a next page for the paginator
        
        loadResultsByPage(currentPageIndex + 1);
        return null;
    } 
    
    public PageReference showPreviousPage() {
        if (!hasPreviousPage) return null; //there isn't a previous page for the paginator
        
        loadResultsByPage(currentPageIndex -1);
        return null;
    }
    
    /**
    * Loads the items in the list, based on the specs of the widget record, starting 
    * from the result at (pageIndex*widgetRecord.ListSize__c)
    * @param pageIndex the index of the page that needs to be shown
    */
    private void loadResultsByPage(Integer pageIndex) {
        this.pageChanged = false;
        Integer previousPageIndex = this.currentPageIndex;
        this.currentPageIndex = pageIndex;
        queriedResults = new List<sObject>();
        visualDataList = new List<IWLListviewWidgetDO>();
        visualDataMap = new Map<String, IWLListviewWidgetDO>();
        voteExcludeIdList = new List<String>();
        //get the records to be shown from the database.
        this.queriedResults = getRecords(widgetRecord);               
        this.sObjResultMap = new Map<Id, sObject>(this.queriedResults);
        // translate the records into instances of IWLListviewWidgetDO, so that they can be rendered in the view
        this.visualDataList = new IWLListviewWidgetModel().ObjectToListviewDO(this.queriedResults, widgetRecord, visualDataMap);
      
                     system.debug('============='+visualDataMap);
        if (widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
            //if we're currently showing ideas, process the ideas that can not be voted on by this user
            voteExcludeIdList = excludeItemsFromVote();
        }
        this.pageChanged = (previousPageIndex != currentPageIndex);
        
    }
    
    /**
    * tells if the paginator has a previous page
    */
    public Boolean hasPreviousPage {
        get {
            return currentPageIndex > 0;            
        }
    }
    
    /**
    * tells if the paginator has a next page.
    */
    public Boolean hasNextPage {
        get {
            return currentPageIndex + 1 < pageCount;
        }   
    }
       
    
    /**
    * This method returns a list of the ids in the current view that the user has already voted to, as well as it marks each Display Object in the view as enabled to be voted on.
    * @return the list of ids of all the ideas that the user has already voted to.
    */
    public List<String> excludeItemsFromVote() {
        List<String> voteExcludeIdList = new List<String>();
    if (!SecurityManager.isCreateable( Vote.sObjectType ) || SecurityManager.isGuestUser()) {
            //the user can't vote on any idea
            voteExcludeIdList.addAll(visualDataMap.keySet());
            for (String ideaId : voteExcludeIdList) {
                visualDataMap.get(ideaId).canVote = false;
            }
            return voteExcludeIdList;
        }
        //Select all the ideas to which the current user has already voted.
        List<AggregateResult> votesForUser = [Select ParentId from Vote where Parent.Type = 'Idea' AND CreatedById = :UserInfo.getUserId() and ParentId IN :visualDataMap.keySet() group by ParentId limit :IWLCodeSettings.MAX_SOQL_RESULTS];
        String votedIdeaId;
        //add the ids to the excludes list
        for (AggregateResult res : votesForUser) {
            votedIdeaId = String.valueOf(res.get('ParentId'));
            voteExcludeIdList.add(votedIdeaId);
            if (visualDataMap.containsKey(votedIdeaId)) {
                visualDataMap.get(votedIdeaId).canVote = false;
            }
        }
    
        return voteExcludeIdList;
        
    }
    
    /******** TEST METHODS *******/
  
  @IsTest(SeeAllData=true)
  private static void testLoad() {
    Test.startTest();
    Community com = IWLTestUtilities.getCommunity();
      Idea i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
      IWLTestUtilities.createIdeaComment( 'Idea Comment' , i.Id );  
      sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
      User u = IWLTestUtilities.getAdminUser();
      if (theme != null) {
        //create an idea for the theme, and assign it.      
      i.put('IdeaThemeId', String.valueOf(theme.get('Id')));
      update i;
      }      
    
    IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
    
    IWLListviewWidgetController controller = new IWLListviewWidgetController();
    controller.WidgetDeveloperName = widget.developerName__c;
    controller.widgetRecord = widget;
    
    system.assert(controller.loadWidget);
    
    controller.loadWidget = null;
    widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
    
    system.assert(controller.loadWidget); 
    
    if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
      controller.loadWidget = null;
      widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
      
      system.assert(controller.loadWidget); 
    }
    
    system.assert(controller.getOriginClassName().startsWith('IWLListview'));
    system.assert(controller.widgetWidth + controller.widgetHeight + controller.itemsCount >= 0);
    system.assert(controller.detailPageBaseUrl != null && controller.authorDetailPageBaseUrl != null);
    system.assert(controller.ShowDetailedView);
    
    Test.stopTest();
  }
  
  @IsTest(SeeAllData=true)
  private static void testCommentRelatedFeatures() {
    Test.startTest();
    Community com = IWLTestUtilities.getCommunity();
    Idea i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
    IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
    
    IWLListviewWidgetController controller = new IWLListviewWidgetController();
    controller.WidgetDeveloperName = widget.developerName__c;
    controller.widgetRecord = widget;
    widget.useAdvancedFiltering__c = true;
    widget.filterAdvanced__c = 'Id = \''+ i.Id + '\'';
    
    system.assert(controller.loadWidget);
    
    Apexpages.currentPage().getParameters().put('idi', i.Id);
        Apexpages.currentPage().getParameters().put('txt', 'A new comment');
    PageReference pr = controller.IWLListViewComment();
    
    
    Test.stopTest();
  }
  
  @IsTest(SeeAllData=true)
  private static void testVoteRelatedFeatures() {
    Test.startTest();
    User adminUser = IWLTestUtilities.getAdminUser();
    Community com = IWLTestUtilities.getCommunity();
    IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
    User ideaCreator = IWLTestUtilities.createTestUser();
    User guestUser = null;
    Idea i = null;
    //look for a user that can create ideas, besides the admin user.
    for (User u : [Select Id from User where Id != :adminUser.Id And IsActive = true limit 10]) {
      System.runAs(u) {
        if (SecurityManager.isGuestUser() && guestUser == null) {
          guestUser = u;
        }
        
      }
    }
    
    system.runAs(ideaCreator) {
      i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
    }
    IWLListviewWidgetController controller = new IWLListviewWidgetController();
    controller.WidgetDeveloperName = widget.developerName__c;
    controller.widgetRecord = widget;
    widget.useAdvancedFiltering__c = true;
    widget.filterAdvanced__c = 'Id = \''+ i.Id + '\'';  
    
    controller.voteIdeaId = i.Id;
    controller.voteType = 'Up';
    //features for the guest user:
    if (guestUser != null) {
      System.runAs(guestUser) {
        system.assert(controller.loadWidget);
        System.debug('### guest canvote');
        system.assert(controller.canVote(i));
        System.debug('### guest vote');
        system.assert(controller.vote() == null && controller.message != Label.IWL_VOTED);
        System.debug('### finished guest vote');
      }
    }
    controller.loadWidget = null;
    if (ideaCreator.Id != adminUser.Id) {
      
        system.assert(controller.loadWidget);
        System.debug('### admin canvote');
        system.assert(controller.canVote(i));
        System.debug('### admin vote');
        system.assert(controller.vote() == null);
        System.debug('### finished admin vote');
    
    } 
    controller.loadWidget = null;
    System.runAs(ideaCreator) {
      System.assert(controller.loadWidget);
      system.assert(!controller.canVote(i));
      system.assert(controller.vote() == null && controller.message != Label.IWL_VOTED);
    }
  
    Test.stopTest();
  }
  
  @IsTest(SeeAllData=true)
  private static void testPagination() {
    Test.startTest();
    Community com = IWLTestUtilities.getCommunity();
    Idea i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
    Idea i2 = IWLTestUtilities.createIdea( 'Idea Title 2', 'Body 2', com.Id );
    IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
    IWLListviewWidgetController controller = new IWLListviewWidgetController();
    controller.WidgetDeveloperName = widget.developerName__c;
    controller.widgetRecord = widget;
    widget.useAdvancedFiltering__c = true;
    widget.filterAdvanced__c = 'Id = \''+ i.Id + '\' OR Id =\''+ i2.Id +'\'';
    
    system.assert(controller.loadWidget);
    
    system.assert(!controller.hasNextPage && !controller.hasPreviousPage);
    
    system.assert(controller.showNextPage() == controller.showPreviousPage());
    
    controller.loadWidget = null;
    
    widget.listSize__c = 1;
    
    system.assert(controller.loadWidget);
    system.assert(controller.hasNextPage && !controller.hasPreviousPage);
    
    system.assert(controller.showNextPage() == null);
    system.assert(!controller.hasNextPage && controller.hasPreviousPage);
    system.assert(controller.showPreviousPage() == null);
    system.assert(controller.hasNextPage && !controller.hasPreviousPage);
    Test.stopTest();
    
  }
    
}