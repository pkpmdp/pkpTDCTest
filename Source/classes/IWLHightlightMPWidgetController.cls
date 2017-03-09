public with sharing class IWLHightlightMPWidgetController extends IWLBaseWidgetController{
	public final static String VOTEUP = IWLCodeSettings.VOTEUP;
    public final static String VOTEDOWN = IWLCodeSettings.VOTEDOWN; 
    public final static String ORIGIN_CSS_CLASS_PREFIX = 'IWLDetailView';

    //attributes for the "vote" feature
    public String voteIdeaId { get; set; }
    public String voteType { get; set; }
    public Integer voteTotal { get; set; }
    public Boolean successfulVote {get; set;}
    
    //Attributes for the 'comment' feature
    public String comment {get; set;}
    
    //Attributes for the 'update' feature.
    public sObject recordToUpdate {get; set;}
    public Boolean editSuccess {get; set;}
    
    //General attributes for the widget.
    public String IdRecords {get; set;}
    public String message {get; set;}
    public IWLBaseDAO dao {get; set;}
    public IWLListviewWidgetDO visualData   {get; set;}
    public String shortContent{get;set;}
    public String detailPageUrl{get;set;}
    public String detailPage{get;set;} 
    public String commentIdeaId{get;set;} 
    public String detailViewMessage {get; set;}
    public Boolean showCommentPanel{get;set;}
 
    
    /*public String getDetailPageUrl(){
        //return '/apex/youbioIdeaDetail?id='+IdRecords;
        return 'http://google.dk';        
    }
    
    public String getDetailPage() {
        return 'http://google.dk';
    }*/
    
    public PageReference redirectToDetailPage() {
        PageReference reference=new PageReference('/apex/youbioIdeaDetail?id='+commentIdeaId);
        reference.setRedirect(true);
        return reference;
    }
                 
    public String makeShortContent(IWLListviewWidgetDO visualData) { 
        shortContent = '';         
        String fullContent = visualData.content.value;
        if(fullContent != null) {
            shortContent = fullContent;
            System.debug('****Wen makeShortContent fullContent***'+fullContent);              
            if(fullContent.length()>100)
                shortContent = fullContent.left(100);
        }    
        System.debug('****Wen shortContent***'+shortContent);            
        return shortContent;            
    }    

    public IWLHightlightMPWidgetController() {
         detailViewMessage = 'Tryk på knappen igen';
         showCommentPanel = false;
    }
    public void showCommentEditor() {
        showCommentPanel = true;
    }
    
    public override String getOriginClassName() {
        return ORIGIN_CSS_CLASS_PREFIX + IWLCodeSettings.getCssForOrigin(widgetRecord.Origin__c);
    }
    
    public Integer getMaxCommentSize() {
        return IWLCodeSettings.MAX_COMMENT_SIZE;
    }
    
    /**
    * This method overrides the one in IWLBaseWidgetController in order to implement the 
    * widget-specific load procedure of the widget's specs and information. 
    * @return true iif the load process was successful.
    */
    protected override Boolean doLoad() {
        //Check for the widgetRecord's type
        if (widgetRecord.Type__c == IWLCodeSettings.DetailViewRecordTypeName) {
            //the widget record has been loaded and has the correct type
            try {
                
                Map<String, IWLListviewWidgetDO> visualDataMap =  new Map<String, IWLListviewWidgetDO>();
                
                //get the records to be shown from the database.
                List<sObject> queriedResults = new List<sObject>();
                System.debug('**** Wen debug widgetRecord'+widgetRecord.developerName__c);
                queriedResults.add( getRecord( widgetRecord, IdRecords ) );  
                recordToUpdate = queriedResults.get(0);                          
                // translate the records into instances of IWLListviewWidgetDO, so that they can be rendered in the view
                System.debug('Wen Debug model begin');
                List<IWLListviewWidgetDO> visualDataList = new IWLListviewWidgetModel().ObjectToListviewDO( queriedResults, widgetRecord, visualDataMap);  
                System.debug('Wen Debug model end'+visualDataList.size());
                this.visualData = visualDataList[0];
                shortContent = makeShortContent(this.visualData);
                //if we're showing an idea, check if the user can vote on this idea.
                if (this.widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
                    System.debug('***Wen debug canVote begin');
                    this.visualData.canVote = canVote((Idea)queriedResults[0]); 
                    System.debug('***Wen debug canVote end');                 
                } 
                System.debug('***Wen debug canVote'+this.visualData.canVote);                         
                return true;
            } catch (Exception ex) {                   
                //LoadErrorMessage = Label.IWL_CANNOT_ACCESS_INFORMATION;
                message = 'Can not access widget information. Please contact administrator.';
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, message );
                ApexPages.addMessage(msg);               
                return false;
            }
                    
        } else {
            //Wrong Widget record's type.
            //LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;   
            message = 'Wrong widget type. Please contact administrator.'   ;
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, message );
            ApexPages.addMessage(msg);       
            return false;
        }
    }
    
    /**
    * This method obtains from the database the records that must be shown in this widget according to the parameters set in 
    * "widget". 
    * @param widget the record of the IWLWidget__c object that specifies which object must be listed in this widget.
    * @return a list of records retrieved from the database, according to the specification given by "widget"
    */
    public sObject getRecord( IWLWidget__c widget, String IdRecord ) {
    
        if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel) {
            //we are to list Ideas, get them from the IWLIdeaDAO
            dao = new IWLIdeaDAO();
            return dao.getRecord( widget, IdRecord );
        } else if (widget.Origin__c == IWLCodeSettings.OriginPicklistUserLabel) {
            //we are to list Users, get them from the IWLUserDAO
            dao = new IWLUserDAO();
            return dao.getRecord( widget, IdRecord );
        } else if (widget.Origin__c == IWLCodeSettings.OriginPicklistIdeaThemeLabel) {
            //we are to list Idea Themes, get them from the IWLIdeaThemeDAO
            dao = new IWLIdeaThemeDAO();
            return dao.getRecord( widget, IdRecord );
        }
        //no valid option has been selected as the origin of the information for this object, so we return an empty list.
        return null;
    }
    /**
    * This method implements the action to comment for an Idea/Idea Theme.
    * @return a null page reference so the component can be reloaded.
    */
    public PageReference IWLDetailViewComment() {
        clearMessages();
        if (!canComment) {
            //addMessage(ERROR_MESSAGE, Label.IWL_CANT_COMMENT_IDEA);
            message = 'Du har ikke tilladelse til at skrive kommentar';
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.WARNING, message );
            ApexPages.addMessage(msg); 
        } else if (comment != null && comment != '') {
            try {
                IdeaComment ideaComment = new IdeaComment( IdeaId = IdRecords, CommentBody= comment );
                insert ideaComment;
                //addMessage(SUCCESS_MESSAGE, Label.IWL_COMMENT_SUCCESS);
                doLoad();
            } catch (Exception ex) {//an error occurred, probably because this is a merged Idea.
                //addMessage(ERROR_MESSAGE, ex.getMessage());
                message = ex.getMessage();
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, message );
                ApexPages.addMessage(msg); 
            }
        } else {
            //addMessage(ERROR_MESSAGE, Label.IWL_COMMENT_CANNOT_BE_EMPTY);
            message = 'Skriv venligst beskrivelse';
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.WARNING, message );
            ApexPages.addMessage(msg); 
        }
        return null;
    }   
    
    /**
    * This method implements the action to vote for an Idea/Idea Theme, promoting or demoting it.
    * @param voteIdeaId This attribute will hold the Id of the idea/theme that is being voted
    * @param voteType This attribute will provide the type of vote the user is doing (Up or Down)
    * @return a null page reference so the component can be reloaded.
    */
    public PageReference IWLDetailViewVoteMP() {
        System.debug('*****Wen detaildebug vote start'+voteIdeaId);
        clearMessages();
        detailViewMessage  = 'initiate message';
        voteType= 'Up';
        if (voteIdeaId != null && voteType != null) {
            List<Idea> votedIdea = new List<Idea>();
            try {
                SecurityManager.canAccess(Idea.sObjectType);
                
                votedIdea = [Select Id, CreatedById, ParentIdeaId from Idea where Id = :voteIdeaId limit 1];
                if ( votedIdea.size() == 0 ) {
                    //The idea does not exist.
                    detailViewMessage  = 'the idea is not existed';
                    //addMessage(ERROR_MESSAGE,Label.IWL_NO_EXIST);
                    
                    return null;
                }
            } catch(SecurityManager.SecurityException ex) {
                detailViewMessage  = 'vote: system exception';
                //addMessage(ERROR_MESSAGE, ex.getMessage());
                return null;
            }
            if (votedIdea[0].ParentIdeaId != null){
                //the idea has been merged, so we vote on the parent idea.
                voteIdeaId = votedIdea[0].ParentIdeaId;
                return IWLDetailViewVoteMP();
            }
            try {
                if (!canVote(votedIdea[0])) {
                    
                    detailViewMessage  = 'Du har ikke tilladelse til at stemme';
                    System.debug('******Wen'+detailViewMessage);
                    //addMessage(ERROR_MESSAGE, Label.IWL_CANT_VOTE_ON_IDEA);
                    return null;
                }
            } catch (SecurityManager.SecurityException ex) {
                detailViewMessage  = ex.getMessage();
                //addMessage(ERROR_MESSAGE, ex.getMessage());
                return null; 
            } catch (Exception ex) {
                detailViewMessage  = ex.getMessage();
                //addMessage(ERROR_MESSAGE, ex.getMessage());
                return null;
            }
            System.debug('+++++Wen'+voteIdeaId+voteType) ;           
            Vote newVote = new Vote(ParentId = voteIdeaId, Type = voteType );
            message = Label.IWL_VOTING;
            try {
                insert newVote;
                doLoad();
                //addMessage(SUCCESS_MESSAGE, Label.IWL_VOTED);
                detailViewMessage  = 'Tak for din stemme';
                voteTotal = Integer.valueOf(visualData.likes.value);
                System.debug('+++++++Wen'+voteTotal);                    
                successfulVote = true;
            } catch (System.DmlException e) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Voting disabled'));
                 //addMessage(ERROR_MESSAGE, Label.IWL_NO_VOTE + ' ' + voteIdeaId + ';' + voteType + ';' + e.getMessage());
                 detailViewMessage  = e.getMessage();
                 System.debug('******Wen'+detailViewMessage);
            }
        } else {
            //addMessage(ERROR_MESSAGE, Label.IWL_VOTE_NULL + '' + voteIdeaId + ';' + voteType);
            detailViewMessage  = 'System error, please contact administrator';
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
            if (SecurityManager.isGuestUser()) {
                return false;
            }
            SecurityManager.canCreate(Vote.sObjectType);
            Id currentUserId = UserInfo.getUserId();
            //commented out because of test, pls bring it back        
            if (idea.CreatedById == currentUserId) {
                return false;
            }
            List<Vote> votesForUser = [Select Id from Vote where ParentId = :idea.Id and CreatedById = :currentUserId limit 1];
            
            return votesForUser.size() == 0;
            return true;        
    }
    
    /**
    * Checks wether the user can comment on an idea or not.
    */
    public Boolean canComment {
        get {
            if (canComment == null) {
                canComment =  SecurityManager.isCreateable(IdeaComment.sObjectType) && this.widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistIdeaLabel;
            }
            return canComment; 
        } set;
    }
    
    /********** Record update methods ***********/
    
    /**
    * This method returns the system singular labels for the editable fields in the currently loaded record.
    */
    public Map<String, String> LabelsForEditableFields {
        get {
            if (LabelsForEditableFields == null) {
                LabelsForEditableFields = new Map<String, String>();
                for (String fieldName : dao.getEditableFieldsNames()) {
                    LabelsForEditableFields.put(fieldName, IWLDynamicDescribeUtils.Instance.getFieldLabel(widgetRecord.Origin__c, fieldName));
                }   
            } 
            return LabelsForEditableFields;
        } set;
    }
    
    /**
    * This method tells wether or not the currently logged in user can update the reocord or not. Since edition 
    * is currently enabled only for users, it will return false if the widget has loaded an Idea or Idea Theme.
    */
    public Boolean canEdit {
        
        get {
            if (canEdit == null) {
                if (widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistUserLabel && !SecurityManager.isGuestUser()) {
                    canEdit = String.valueOf(recordToUpdate.get('Id')) == String.valueOf(Userinfo.getUserId()); 
                } else {
                    canEdit = false;//String.valueOf(recordToUpdate.get('CreatedById')) == String.valueOf(Userinfo.getUserId());
                }
            } 
            return canEdit;
        } set;
    }
    
    /**
    * This method performs the update action on the currently loaded record.
    * @return a null page reference, so that the widget gets rerendered.
    */
    public PageReference updateInfo() {
        clearMessages();
        editSuccess = false;
        try {
            if (canEdit) {
                update recordToUpdate;
                doLoad();
                addMessage(SUCCESS_MESSAGE, Label.IWL_RECORD_EDIT_SUCCESS);
                addMessage(INFO_MESSAGE, Label.IWL_RECORD_EDIT_CONFIRMATION_NEEDED);
                editSuccess = true;
            } else {
                //add a meessage saying that  the user can't edit the record
            }
        } catch (Exception ex) {
            addMessage(ERROR_MESSAGE, ex.getMessage());
        }
        return null;
    }
    
    public Boolean rerenderOnEdit {
        get {
            return widgetRecord.Origin__c == IWLCodeSettings.OriginPicklistUserLabel;
        }
    }
    
        
    /******** TEST METHODS *******/
    
    @isTest
    private static void testLoad() {
        Test.startTest();
        Community com = IWLTestUtilities.getCommunity();
        Idea i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
        IWLTestUtilities.createIdeaComment( 'Idea Comment' , i.Id );    
        sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
        User u = IWLTestUtilities.getAdminUser();
        if (theme != null && theme.get('id') != null) {
            //create an idea for the theme, and assign it.          
            //i.put('IdeaThemeId', String.valueOf(theme.get('Id'))); 
             i.put('IdeaThemeId', theme.Id);         
            update i;
        }           
        
        IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEADETAIL);
        
        IWLHightlightMPWidgetController controller = new IWLHightlightMPWidgetController();
        controller.WidgetDeveloperName = widget.developerName__c;
        controller.widgetRecord = widget;
        controller.IdRecords = i.Id;
        system.assert(controller.loadWidget);
        
        controller.loadWidget = null;
        widget.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
        controller.IdRecords = u.Id;
        system.assert(controller.loadWidget); 
        
        if (IWLIdeaThemeDAO.IsIdeaThemeEnabled && theme.id != null) {
            controller.loadWidget = null;
            widget.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
            controller.IdRecords = String.valueOf(theme.get('Id'));
            system.assert(controller.loadWidget); 
        }
        
        system.assert(controller.getOriginClassName().startsWith('IWLDetailView'));
        system.assert(controller.widgetWidth + controller.widgetHeight >= 0);
        system.assert(controller.detailPageBaseUrl != null && controller.authorDetailPageBaseUrl != null);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testCommentRelatedFeatures() {
        Test.startTest();
        Community com = IWLTestUtilities.getCommunity();
        Idea i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
        IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEADETAIL);
        
        IWLHightlightMPWidgetController controller = new IWLHightlightMPWidgetController();
        controller.WidgetDeveloperName = widget.developerName__c;
        controller.widgetRecord = widget;
        controller.IdRecords = i.Id;
        system.assert(controller.loadWidget);
        
        system.assert(controller.canComment);
        
        controller.comment = 'A new comment';
        PageReference pr = controller.IWLDetailViewComment();
        System.assert(controller.visualData.feedItemsCount == 1);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testVoteRelatedFeatures() {
        Test.startTest();
        User adminUser = IWLTestUtilities.getAdminUser();
        Community com = IWLTestUtilities.getCommunity();
        IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEADETAIL);
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
        System.debug('### AdminId: ' + adminUser.Id + ', CreatorId: ' + ideaCreator.Id);
        system.runAs(ideaCreator) {
            i = IWLTestUtilities.createIdea( 'Idea Title', 'Body', com.Id );
        }
        IWLHightlightMPWidgetController controller = new IWLHightlightMPWidgetController();
        controller.WidgetDeveloperName = widget.developerName__c;
        controller.widgetRecord = widget;
        controller.IdRecords = i.Id;
        
        
        controller.voteIdeaId = i.Id;
        controller.voteType = 'Up';
        //features for the guest user:
        if (guestUser != null) {
            System.runAs(guestUser) {
                system.assert(controller.loadWidget);
                System.debug('### guest canvote');
                system.assert(!controller.canVote(i));
                System.debug('### guest vote');
                system.assert(controller.IWLDetailViewVoteMP() == null);
                System.debug('### finished guest vote');
            }
        }
        controller.loadWidget = null;
        if (ideaCreator.Id != adminUser.Id) {
            
                system.assert(controller.loadWidget);
                System.debug('### admin canvote');
                system.assert(controller.canVote(i));
                System.debug('### admin vote');
                system.assert(controller.IWLDetailViewVoteMP() == null);
                System.debug('### finished admin vote');
        
        } 
        
        System.runAs(ideaCreator) {
            System.assert(controller.loadWidget);
            system.assert(!controller.canVote(i));
            system.assert(controller.IWLDetailViewVoteMP() == null);
        }
    
        Test.stopTest();
    }
}