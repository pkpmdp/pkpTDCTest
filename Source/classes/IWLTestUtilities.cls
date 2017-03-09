/**
* This class provides methods that facilitate the execution of test methods, and is only used in test context.
*/
@IsTest(SeeAllData=true)
public class IWLTestUtilities {

    public static final String IWL_WIDGET_IDEASLIST = 'iwlIdeasList';
    public static final String IWL_WIDGET_THEMESLIST = 'iwlThemesList';
    public static final String IWL_WIDGET_USERLIST = 'iwlUsersList';
    public static final String IWL_WIDGET_POSTIDEA = 'iwlPostIdea';
    public static final String IWL_WIDGET_USERLIST_SIMPLE = 'iwlUsersListSimple';
    public static final String IWL_WIDGET_AVATARUPLOAD = 'iwlAvatarUpload';
    public static final String IWL_WIDGET_IDEADETAIL = 'iwlIdeaDetail';
    public static final String IWL_WIDGET_IDEATHEMEDETAIL = 'iwlIdeaThemeDetail';
    public static final String IWL_WIDGET_USERDETAIL = 'iwlUserDetail';
    public static final String IWL_WIDGET_IDEASSLIDESHOW = 'iwlIdeasSlideshow';
    public static final String IWL_WIDGET_IDEATHEMESSLIDESHOW = 'iwlIdeaThemesSlideshow';
    public static final String IWL_WIDGET_USERSSLIDESHOW = 'iwlUsersSlideshow';
    public static final String IWL_WIDGET_SEARCHIDEAS = 'iwlSearchIdeas';
    public static final String IWL_WIDGET_SEARCHIDEATHEMES = 'iwlSearchIdeaThemes';
    public static final String IWL_WIDGET_SHAREON = 'iwlShareOn';

    public static Idea createIdea(String ideaTitle, String ideaBody, Id ideaCommunityId) {
        Idea i = new Idea(Title = ideaTitle, body=ideaBody, CommunityId = ideaCommunityId, Categories= 'Indhold');
        insert i;
        return i;
    }
    
    public static Community getCommunity(Id communityId) {
        return [Select Id, Name, IsActive from Community where Id=:communityId and IsActive = true limit 1];
    }
    
    public static Community getCommunity(String communityName) {
        return [Select Id, Name, IsActive from Community where Name=:communityName and IsActive = true limit 1];
    }
    
    public static Community getCommunity() {
        List<Community> communities =  [Select Id, Name, IsActive from Community where IsActive = true and Name = 'Youbio Community' limit 1];
        return communities[0];
    }
    
    public static IdeaComment createIdeaComment(String comBody, Id ideaId) {
        IdeaComment ic = new IdeaComment(CommentBody = comBody, IdeaId = ideaId);
        insert ic;
        return ic;
    }
    
    public static sObject createIdeaTheme(String Title, String description, String status, Id CommunityId) {
        sObject theme = null;
        if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
            theme = Schema.getGlobalDescribe().get('IdeaTheme').newSObject();
            theme.put('Title', Title);
            theme.put('Description', description);
            theme.put('Status', status);
            theme.put('Categories', null);
            theme.put('CommunityId', CommunityId);
            insert theme;
            return theme;
        }
        return theme;
    }
    
    public static sObject getIdeatheme(Id themeId) {
        sObject theme = null;
        if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
            theme = Database.query('Select Id, Title, Description, Status, Categories, CommunityId, EndDate, StartDate, LastModifiedDate, ' + 
                        'CreatedDate, CreatedBy.CommunityNickname, CreatedBy.Username, CreatedBy.Id, CreatedById, CreatedBy.IWLAvatarId__c ' + 
                        'From IdeaTheme where Id = \'' + themeId + '\' limit 1').get(0);
        }
        return theme;
    }
    
    public static IWLWidget__c createIWLWidget(String developerName, String recordTypeDevName, String Origin, Boolean overrideCSS,
                                                String communityId, Integer ListSize, Integer RelatedFeedSize, Boolean DoInsert ) {
        RecordType rt = [Select Id from RecordType where sObjectType = 'IWLWidget__c' and developerName = :recordTypeDevName];
        
        IWLWidget__c newWidget = new IWLWidget__c(Name = developerName, Title__c = developerName, Origin__c = Origin,
         description__c = developerName, RecordTypeId = rt.Id, overrideCSS__c = overrideCSS, 
         Community__c = communityId, listSize__c = ListSize, 
         relatedFeedSize__c = RelatedFeedSize, developerName__c = developerName);
         if (DoInsert) {
            insert newWidget;   
         }
         
         return newWidget;
    }
    
    public static IWLWidget__c getIWLWidget(String developerName) {
        IWLWidget__c record = generateWidget(developerName);
        /*if (record != null) {
            return record;
        }*/
        return IWLWidgetDAO.getRecord(developerName);
    }
    
    public static IWLWidget__c getIWLWidget(Id widgetRecordId) {
        return IWLWidgetDAO.getRecord(widgetRecordId);
            
    }
    
    public static RecordType getIWLRecordType(String devName) {
        return [Select Id from RecordType where sObjectType = 'IWLWidget__c' and DeveloperName = :devName limit 1];
        
    }
    
    public static User getAdminUser() {
        Profile p = [select id from profile where Name = 'Yousee System Administrator' limit 1];    
        return [Select Id, IWLAvatarId__c from User where profileId = :p.Id AND isActive = true].get(0);
    }
    
    public static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Yousee System Administrator'];
        //Contact con = clsTestFactory.getTestFactoryInstance().createYSContact();
        User u = new User(Alias = 'testa', Email='testadmin213123@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='testadmin213123@testorg.com', MID__c='T888888');
      insert u;
      return u;
    }
    
    public static IWLWidget__c generateWidget(String developerName) {
        IWLWidget__c record = null;
        String communityId = getCommunity().Id;
        record = new IWLWidget__c(DeveloperName__c = developerName, 
                                        Title__c= developerName, 
                                        Community__c = communityId, 
                                        Name = developerName, 
                                        description__c = developerName, 
                                        OrderByBasic__c = IWLCodeSettings.OrderByPicklistCreatedDateLabel, 
                                        overrideCSS__c = false, 
                                        sortOrder__c = IWLCodeSettings.SortOrderPicklistDescendingLabel, 
                                        listSize__c = 10, 
                                        seeMoreUrl__c = '/huioh?', 
                                        detailPageUrl__c = 'http://www.google.com',  
                                        transitionInterval__c = 0, 
                                        authorDetailUrl__c = 'author/?', 
                                        useAdvancedFiltering__c = false,
                                        filterAdvanced__c  = null, 
                                        orderByAdvanced__c = null, 
                                        emptyAvatarImageUrl__c = '',
                                        contentLength__c = 300,
                                        relatedFeedSize__c = 3, 
                                        showRichText__c = true, 
                                        showPagination__c = true, 
                                        showRelatedFeed__c = true, 
                                        votePanel__c = true, 
                                        viewType__c = IWLCodeSettings.ViewtypePicklistDetailedLabel, 
                                        additionalFields__c = '', 
                                        RedirectURL__c = '', 
                                        twoStepIdea__c = false,
                                        showLabels__c = true, 
                                        avatarsFolderDevName__c = null
                                        );
        if (developerName == IWL_WIDGET_IDEASLIST) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.ListviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
        } else if (developerName == IWL_WIDGET_THEMESLIST) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.ListviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
        } else if (developerName == IWL_WIDGET_USERLIST) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.ListviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
        } else if (developerName == IWL_WIDGET_POSTIDEA) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.PostIdeaRecordTypeName).Id;
        } else if (developerName == IWL_WIDGET_USERLIST_SIMPLE) {
            
        } else if (developerName == IWL_WIDGET_AVATARUPLOAD) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.AvatarUploadRecordTypeName).Id;
            
        } else if (developerName == IWL_WIDGET_IDEADETAIL) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.DetailviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
        } else if (developerName == IWL_WIDGET_IDEATHEMEDETAIL) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.DetailviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
        } else if (developerName == IWL_WIDGET_USERDETAIL) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.DetailviewRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
        } else if (developerName == IWL_WIDGET_IDEASSLIDESHOW) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.SlideshowRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
        } else if (developerName == IWL_WIDGET_IDEATHEMESSLIDESHOW) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.SlideshowRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
        } else if (developerName == IWL_WIDGET_USERSSLIDESHOW) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.SlideshowRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistUserLabel;
        } else if (developerName == IWL_WIDGET_SEARCHIDEAS) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.SearchRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaLabel;
        } else if (developerName == IWL_WIDGET_SEARCHIDEATHEMES) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.SearchRecordTypeName).Id;
            record.Origin__c = IWLCodeSettings.OriginPicklistIdeaThemeLabel;
        } else if (developerName == IWL_WIDGET_SHAREON) {
            record.RecordTypeId = getIWLRecordType(IWLCodeSettings.ShareOnRecordTypeName).Id;
            record.ShareOn_Type__c = 'Facebook';
        } else {
            record = null;
        }
        if (record != null) {
            Database.upsert(record, IWLWidget__c.developerName__c);         
        }
        return record; 
            
    
    }

}