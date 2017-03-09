/**
* This class defines constants and access mehtods to them. An alternative to most of the content of this class would be to use labels, but since
* they're translatable, we decided not to go that way, since our application won't support translations.
*/
public with sharing class IWLCodeSettings {
	
	public static final String DATE_FORMAT = 'yyyy-MM-dd\'T\'hh:mm:ss\'z\'' ;
	public static final Integer MAX_SOQL_RESULTS = 10000;
	public static final String INTERNAL_USER_FALSE_ID = 'n0tAva1la8!e';
	public static final Integer MAX_COMMENT_SIZE = 4000;
	public final static String VOTEUP = 'Up';
	public final static String VOTEDOWN = 'Down';
	
	/*Supported record types names for IWLWidget*/
	private static final String SLIDESHOW_RECORDTYPE_NAME = 'Slideshow';
	private static final String LISTVIEW_RECORDTYPE_NAME = 'Listview';
	private static final String DETAILVIEW_RECORDTYPE_NAME = 'DetailView';
	private static final String SEARCH_RECORDTYPE_NAME = 'Search';
	private static final String SHAREON_RECORDTYPE_NAME = 'ShareOn';
	private static final String AVATARUPLOAD_RECORDTYPE_NAME = 'AvatarUpload';
	private static final String POSTIDEA_RECORDTYPE_NAME = 'PostIdea';
	
	/*IWL "Origin" Picklist values*/
	private static final String ORIGIN_PICKLIST_USER = 'User';	
	private static final String ORIGIN_PICKLIST_IDEA = 'Idea';
	private static final String ORIGIN_PICKLIST_IDEATHEME = 'Idea Theme';
	private static final String ORIGIN_PICKLIST_RSS = 'RSS (Atom)';

	/*IWL "Filter (Basic)" Picklist values*/
	private static final String FILTER_PICKLIST_RECENT = 'Recent';
	private static final String FILTER_PICKLIST_ACTIVE = 'Active';
	private static final String FILTER_PICKLIST_NEW_USERS = 'This Month';
	private static final String FILTER_PICKLIST_NOVICE_USERS = 'This Week';
	
	/*IWL "Order By (Basic)" Picklist values*/
	private static final String ORDERBY_PICKLIST_CREATED_DATE = 'Created Date';
	private static final String ORDERBY_PICKLIST_ALPHABETICALLY = 'Alphabetically';
	private static final String ORDERBY_PICKLIST_COMMENTS_COUNT = 'Comments Count';
	private static final String ORDERBY_PICKLIST_RATING_DATE = 'Rating';
	private static final String ORDERBY_PICKLIST_IDEA_COUNT = 'Proposed Idea Count'; 	
	
	
	/*IWL "Sort Order" Picklist Values*/
	private static final String SORTORDER_PICKLIST_DESCENDING = 'Descending';
	private static final String SORTORDER_PICKLIST_ASCENDING = 'Ascending';
	
	/*IWL "View Type" Picklist Values*/
	private static final String VIEWTYPE_PICKLIST_DETAILED = 'Detailed';
	private static final String VIEWTYPE_PICKLIST_SUMMARY = 'Summary';
	
	/*IWL Origin-specific CSS classes identifier*/
	private static final String CSS_ORIGIN_IDEAS = 'Idea';
	private static final String CSS_ORIGIN_IDEATHEMES = 'IdeaTheme';
	private static final String CSS_ORIGIN_USER = 'User';
	private static final String CSS_ORIGIN_RSS = 'Rss';
	
	/*Links to the default images in static resources*/
	private static final String RESOURCE_BLANK_AVATAR_IMAGE = '/resource/IWLResources/styles/images/blankAvatarBig.png';
	private static final String RESOURCE_AJAX_LOADER_IMAGE = '/resource/IWLResources/styles/images/ajax-loader.gif';
	private static final String RESOURCE_EMPTY_BUTTON_IMAGE = '/resource/IWLResources/styles/images/empty-button.png';
	private static final String RESOURCE_FACEBOOK_IMAGE = '/resource/IWLResources/styles/images/icons/facebook.png';
	private static final String RESOURCE_LINKEDIN_IMAGE = '/resource/IWLResources/styles/images/icons/linkedin.png';
	private static final String RESOURCE_MOBILEME_IMAGE = '/resource/IWLResources/styles/images/icons/mobileme.png';
	private static final String RESOURCE_TUMBLR_IMAGE = '/resource/IWLResources/styles/images/icons/tumblr.png';
	private static final String RESOURCE_TWITTER_IMAGE = '/resource/IWLResources/styles/images/icons/twitter.png';
	private static final String RESOURCE_IDEA_THEME_DEFAULT_IMAGE = '/resource/IWLResources/styles/images/ideathemeemptyimage.jpg';
	
	private static final String AVATAR_UPLOAD_DEFAULT_FOLDER_DEVNAME = 'Widgets_User_Avatars';
	private static final String IDEA_THEME_IMAGE_FOLDER_DEVNAME = 'IWL_Idea_Theme_Images';
    
    public static String CssOriginRss {
    	get {
    		return CSS_ORIGIN_RSS;
    	}
    }
    
    public static String CssOriginUser {
    	get {
    		return CSS_ORIGIN_USER;
    	}
    }
    
    public static String CssOriginIdeaThemes {
    	get {
    		return CSS_ORIGIN_IDEATHEMES;
    	}
    }
    
    public static String CssOriginIdeas {
    	get {
    		return CSS_ORIGIN_IDEAS;
    	}
    }
    
    public static String getCssForOrigin(String origin) {
    	if (origin == ORIGIN_PICKLIST_IDEA) {
    		return CssOriginIdeas;
    	} else if (origin == ORIGIN_PICKLIST_IDEATHEME) {
    		return CssOriginIdeaThemes;
    	} else if (origin == ORIGIN_PICKLIST_USER) {
    		return CssOriginUser;
    	} else if (origin == ORIGIN_PICKLIST_RSS) {
    		return CssOriginRss;
    	} else {
    		return CssOriginIdeas;
    	}
    }
    
    public static String IdeaThemeImageFolderDevname {
    	get {
    		return IDEA_THEME_IMAGE_FOLDER_DEVNAME;
    	}
    }
    
	public static String AvatarUploadFolderDevname {
		get {
			return AVATAR_UPLOAD_DEFAULT_FOLDER_DEVNAME;
		}
	}
	
	public static String SlideshowRecordTypeName {
		get {
			return SLIDESHOW_RECORDTYPE_NAME;
		}
	}
	
	public static String ListviewRecordTypeName {
		get {
			return LISTVIEW_RECORDTYPE_NAME;
		}
	}
	
	public static String DetailViewRecordTypeName {
		get {
			return DETAILVIEW_RECORDTYPE_NAME;
		}
	}
	
	public static String SearchRecordTypeName {
		get {
			return SEARCH_RECORDTYPE_NAME;
		}
	}

	public static String ShareOnRecordTypeName {
		get {
			return SHAREON_RECORDTYPE_NAME;
		}
	}
	
	public static String AvatarUploadRecordTypeName {
		get {
			return AVATARUPLOAD_RECORDTYPE_NAME;
		}
	}
	
	public static String PostIdeaRecordTypeName {
		get {
			return POSTIDEA_RECORDTYPE_NAME;
		}
	}
	
	public static String OriginPicklistUserLabel {
		 get {
		 	return ORIGIN_PICKLIST_USER;
		 }
	}
	
	public static String OriginPicklistIdeaLabel {
		 get {
		 	return ORIGIN_PICKLIST_IDEA;
		 }
	}
	
	public static String OriginPicklistIdeaThemeLabel {
		get {
			return ORIGIN_PICKLIST_IDEATHEME;
		}
	}

	public static String OriginPicklistRSSLabel {
		get {
			return ORIGIN_PICKLIST_RSS;
		}
	}
		
	public static String FilterPicklistRecentLabel {
		 get {
		 	return FILTER_PICKLIST_RECENT;
		 }
	}
	public static String FilterPicklistActiveLabel {
		 get {
		 	return FILTER_PICKLIST_ACTIVE;
		 }
	}
	public static String FilterPicklistNewUsersLabel {
		 get {
		 	return FILTER_PICKLIST_NEW_USERS;
		 }
	}
	public static String FilterPicklistNoviceUsersLabel {
		 get {
		 	return FILTER_PICKLIST_NOVICE_USERS;
		 }
	}
	
	public static String OrderByPicklistCreatedDateLabel {
		get {
			return ORDERBY_PICKLIST_CREATED_DATE;
		}
	}
	public static String OrderByPicklistAlphabeticallyLabel {
		get {
			return ORDERBY_PICKLIST_ALPHABETICALLY;
		}
	}
	public static String OrderByPicklistCommentsCountLabel {
		get {
			return ORDERBY_PICKLIST_COMMENTS_COUNT;
		}
	}
	public static String OrderByPicklistRatingLabel {
		get {
			return ORDERBY_PICKLIST_RATING_DATE;
		}
	}
	public static String OrderByPicklistIdeaCountLabel {
		get {
			return ORDERBY_PICKLIST_IDEA_COUNT;
		}
	}
	
	public static String SortOrderPicklistDescendingLabel {
		get {
			return SORTORDER_PICKLIST_DESCENDING;
		}
	}
	
	public static String SortOrderPicklistAscendingLabel {
		get {
			return SORTORDER_PICKLIST_ASCENDING;
		}
	}	
	
	public static String ViewtypePicklistDetailedLabel {
		get {
			return VIEWTYPE_PICKLIST_DETAILED;
	
		}
	}
	
	public static String ViewtypePicklistSummaryLabel {
		get {
			return VIEWTYPE_PICKLIST_SUMMARY;
		}
	}
	
	public class IWLInvalidObjectTypeException extends Exception {
		
	}
	
	public static String ResourceTwitterImage {
		get {
			return RESOURCE_TWITTER_IMAGE;
		}
	}
	
	public static String ResourceTumblrImage {
		get {
			return RESOURCE_TUMBLR_IMAGE;
		}
	}
	
	public static String ResourceMobilemeImage {
		get {
			return RESOURCE_MOBILEME_IMAGE;
		}
	}
	
	public static String ResourceLinkedinImage {
		get {
			return RESOURCE_LINKEDIN_IMAGE;
		}
	}
	
	public static String ResourceFacebookImage {
		get {
			return RESOURCE_FACEBOOK_IMAGE;
		}
	}
	
	public static String ResourceEmptyButtonImage {
		get {
			return RESOURCE_EMPTY_BUTTON_IMAGE;
		}
	}
	
	public static String ResourceAjaxLoaderImage {
		get {
			return RESOURCE_AJAX_LOADER_IMAGE;
		}
	}
	
	public static String ResourceBlankAvatarImage {
		get {
			return RESOURCE_BLANK_AVATAR_IMAGE;
		}
	}
	
	public static String ResourceIdeaThemeDefaultImage {
		get {
			return RESOURCE_IDEA_THEME_DEFAULT_IMAGE;
		}
	}
}