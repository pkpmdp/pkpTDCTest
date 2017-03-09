public with sharing class IWLIdeaThemeImageUploadController {
    
    public static final String PARAM_ID = 'id';
    public static final String PARAM_UPLOAD = 'upload';
    public static final String PARAM_DELETE = 'delete';
    public static final String PARAM_RETURL = 'retUrl';
    public static final String SALESFORCE_BASE = 'salesforce.com';
    public static final String IDEA_THEME_API_NAME = 'IdeaTheme';
    public static final String IDEA_THEME_IMAGE_API_FIELD_NAME = 'IWLThemeIcon__c';
    
    
    private String ideaThemeId {get;set;}
    
    private sObject ideaTheme {get; set;}
    
    public Document themeImage {get; set;}
    
    public Document existingImage {get; set;}
    
    public String existingImageUrl {get; set;}  
    
    public Boolean upload {get; set;} //flag to signal the upload action.
    
    public Boolean doDelete {get; set; } //flag to signal the delete action.
    
    public String retUrl {get;set;} // the return url of the page.
    
    //Attributes to make server side checks on the files uploaded.
    public String imageContentType {get; set;}
    
    public String imageFileSize {get; set;}

    public IWLIdeaThemeImageUploadController() {
        ideaThemeId = Apexpages.currentPage().getParameters().get(PARAM_ID);
        upload = (Apexpages.currentPage().getParameters().get(PARAM_UPLOAD) != null && Apexpages.currentPage().getParameters().get(PARAM_UPLOAD) != '' );
        doDelete = Apexpages.currentPage().getParameters().get(PARAM_DELETE) != null;
        retUrl = Apexpages.currentPage().getParameters().get(PARAM_RETURL);
        //here we validate the url as belonging to the org. If not valid, then we will set the return url to the current page's url.
        String salesforceBaseUrl = Url.getSalesforceBaseUrl().getHost().split('\\.')[1] + '.' + SALESFORCE_BASE;
        
        Url retUrlObj = new Url(retUrl);
        if (!retUrlObj.getHost().endsWith(salesforceBaseUrl)) {
        	retUrl = Apexpages.currentPage().getUrl() != null ? Apexpages.currentPage().getUrl() : '';
        }
        
        
        
    }
    
    public Boolean doLoad {
        get {
            if (doLoad == null) {
                doLoad = false;
                if (!upload && !doDelete) { //no proper parameters have been set
                    return doLoad;
                }
                if (ideaThemeId != null && ideaThemeId != '' && IWLIdeaThemeDAO.IsIdeaThemeEnabled && (upload || doDelete)) {
                    try {
                    	SecurityManager.canAccess(Document.sObjectType);
                    	SecurityManager.canUpdate(Schema.getGlobalDescribe().get( IDEA_THEME_API_NAME ).getDescribe().fields.getMap().get(IDEA_THEME_IMAGE_API_FIELD_NAME));
                    	
                    	SecurityManager.canCreate(Document.sObjectType);
                    	SecurityManager.canAccess(Folder.sObjectType);
                    	SecurityManager.canDelete(Document.sObjectType);	
                    
                        List<sObject> themesList = (List<sObject>)Database.query('Select Id, IWLThemeIcon__c From IdeaTheme Where Id = \'' + String.escapeSingleQuotes(ideaThemeId) + '\' limit 1');
                        if (themesList != null && themesList.size() > 0) {
                        
                            ideaTheme = themesList.get(0);
                            themeImage = new Document();
                            String imageDocumentId = String.valueOf(ideaTheme.get(IDEA_THEME_IMAGE_API_FIELD_NAME));
                         	
                            
                            if (imageDocumentId != null) {
	                            List<Document> atts  = [Select Id from Document where Id = :imageDocumentId limit 1];
	                            
	                            if (atts.size() >= 0) {
	                    
	                                existingImage = atts.get(0);
	                                existingImageUrl = IWLImageUtilities.getImageUrl(existingImage.Id);
	                                
	                            }
	                            doLoad = true;
                            } else if (doDelete) {
                            	doLoad = false;
                            	
                            	ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, Label.IWL_IDEA_THEME_IMAGE_NOT_FOUND ) );
                            } else {
                            	doLoad = true;
                            }
                              
                        } else {
                            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, Label.IWL_IDEA_THEME_NOT_FOUND ) );
                            doLoad = false;
                        }
                        
                    } catch (Exception ex) {
                    	doLoad = false;
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, ex.getMessage() ) );
                    }
                    
                } else {
                    if (!IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, Label.IWL_IDEA_THEME_NOT_ENABLED ) );
                        doLoad = false;
                    } else {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, Label.IWL_IDEA_THEME_ID_MISSING ) );
                        doLoad = false;
                    }
                    
                    
                }
                
            }
            return doLoad;  
        } set;
        
    }
    
    
    public PageReference updateImage() {
        if ( doLoad && themeImage.Name != null ) {
            
            if (existingImage != null) {
                delete existingImage;
            }
            Folder f = [Select Id from Folder where DeveloperName = :IWLCodeSettings.IdeaThemeImageFolderDevname limit 1];
            themeImage.FolderId = f.Id;
            themeImage.isPublic = true;
            insert themeImage;
            
            ideaTheme.put(IDEA_THEME_IMAGE_API_FIELD_NAME, themeImage.Id);
            update ideaTheme;
        }
        themeImage = null;
        Pagereference imageUploadPage = new PageReference(retUrl);
        imageUploadPage.setRedirect(true);
        return imageUploadPage;
    }
    
    public PageReference deleteImage() {
        
        if (doLoad) {
            if (existingImage != null) {
                
                delete existingImage;                
            }
            ideaTheme.put(IDEA_THEME_IMAGE_API_FIELD_NAME, null);
            update ideaTheme;
        }
        themeImage = null;
        Pagereference imageUploadPage = new PageReference(retUrl);
        imageUploadPage.setRedirect(true);
        return imageUploadPage;
    }
    
    
    @isTest
    private static void testIdeaThemeImageUploader() {
    	Test.startTest();
    	
    	Map<String, String> pageParams = Apexpages.currentPage().getParameters();
    	Community com = IWLTestUtilities.getCommunity();
    	sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
        
    	if (theme != null) {
    		String themeId= String.valueOf(theme.get('Id'));
    		pageParams.put('upload', '1');
    		pageParams.put('id', themeId);
    		pageParams.put('retUrl', Url.getSalesforceBaseUrl().toExternalForm());
    		IWLIdeaThemeImageUploadController controller = new IWLIdeaThemeImageUploadController();
    		System.assert(controller.doLoad);
    		
    		controller.themeImage.Body = Encodingutil.base64Decode('9812038140248740174902');
    		controller.themeImage.Name = 'TestName114435696744';
    		controller.updateImage();
    		
    		controller = new IWLIdeaThemeImageUploadController();
    		System.assert(controller.doLoad);
    		controller.themeImage.Name = 'TestName114435696s2744';
    		controller.themeImage.Body = Encodingutil.base64Decode('98128140248740174902');
    		controller.updateImage();
    		
    		pageParams.remove('upload');
    		pageParams.put('delete', '1');
    		controller = new IWLIdeaThemeImageUploadController();
    		System.assert(controller.doLoad);
    		controller.deleteImage();
    	}
    	
    	Test.stopTest();
    	
    }
}