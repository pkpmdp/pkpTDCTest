/**
* This class implements the controller part of the MVC pattern for the User Avatar Upload Widget.
*/
public with sharing class IWLUploadAvatarWidgetController extends IWLBaseWidgetController {
    private static final String EMPTY_AVATAR_DEFAULT_IMAGE = '/resources/IWLResources/styles/images/blankAvatarBig.png';
    private static final Integer MAX_FILE_SIZE = 5242880; //maximum file size, in bytes.
    
    public static final String PARAM_STATUS = 'IWLStatus';
    public static final String PARAM_MESSAGE = 'IWLStatusMessage';
    
    public Boolean editModeOn {get; set;} //a flag telling if the widget is in its edition mode or not (enables or disables new avatar uploads)
    private String pAvatarImageId = null; //The id if the file that holds the image for the user
    public Boolean avatarExists {get; set;}
    
    public Boolean isTest {get; set;}
    
    public Integer fileSize {get; set;}

    /**
    * This tells wether the user can or can not modify the avatar image.
    */
    public Boolean allowUpload {get{
        if (allowUpload == null) {
            allowUpload = false;
            if(!SecurityManager.isGuestUser() ) allowUpload = true;
            allowUpload = allowUpload && editModeOn;    
        }
        return allowUpload;
    } set;}
    
    
    public IWLUploadAvatarWidgetController() {
        Map<String, String> pageParameters = Apexpages.currentPage().getParameters();
        String saveStatus = pageParameters.get(PARAM_STATUS);
        String saveMessage = pageParameters.get(PARAM_MESSAGE);
        
        if (saveStatus != null) {
            addMessage(saveStatus, saveMessage);
        }
        
    }
    
    /**
    * This method overrides the one in IWLBaseWidgetController in order to implement the 
    * widget-specific load procedure of the widget's specs and information. 
    * @return true iif the load process was successful.
    */
    protected override Boolean doLoad() {
        this.isTest = false;
        if (widgetRecord.Type__c == IWLCodeSettings.AvatarUploadRecordTypeName) {
            //the widgetRecord exists and is of the correct type for this widget
            try {
                SecurityManager.canAccess(new Schema.sObjectType[] {User.sObjectType, Attachment.sObjectType});
                SecurityManager.canUpdate(new Schema.sObjectField[] {User.IWLAvatarId__c, Attachment.Name, Attachment.Body});
            } catch (SecurityManager.SecurityException secEx) {
                LoadErrorMessage = secEx.getMessage();
                return false;
            }
            
            return true;
        } else {
            //the widgetRecord has a wrong type.
            LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
            return false;
        }
    }
    
    /**
    * A getter for the current user's avatar image id.
    */
    public String AvatarImageId {
        get {
            if (pAvatarImageId == null && currentUser.IWLAvatarId__c != null && currentUser.IWLAvatarId__c != '' ) {
                pAvatarImageId = currentUser.IWLAvatarId__c;
                avatarExists = true;
            }else if (pAvatarImageId != null){
                pAvatarImageId = String.escapeSingleQuotes( pAvatarImageId );
            }
            return pAvatarImageId;
        } set;
    }   
    
    private Attachment pTempAttachment = null;
    
    /**
    * A getter for a reference to the current user
    */
    private User currentUser {
        get {
            if (currentUser == null) {
                currentUser = [Select Id, IWLAvatarId__c from User where Id = :UserInfo.getUserId()];
            }
            return currentUser;
        } set;
    }
    
    public Attachment avatarImageTempAttachment {
        get {
            if (pTempAttachment == null) {
                pTempAttachment = new Attachment();
            }
            return pTempAttachment;
        }
    }
    
    /**
    * returns the url to the users's avatar, or the widget's default one.
    */
    public String smallAvatarUrl {
        get {
            if (smallAvatarUrl == null) {
                if (AvatarImageId != null) {
                    smallAvatarUrl = IWLImageUtilities.getImageUrl( AvatarImageId );
                } else if (widgetRecord.emptyAvatarImageUrl__c != null && widgetRecord.emptyAvatarImageUrl__c != '') {
                    smallAvatarUrl = widgetRecord.emptyAvatarImageUrl__c;
                } else {
                    smallAvatarUrl = IWLCodeSettings.ResourceBlankAvatarImage;
                }   
            }
            return smallAvatarUrl;
        } set;
    } 
    
    /**
    * This method updates the current user's avatar image with the one that the user has just uploaded. 
    * It saves the image as a public Document in the user's personal folder, deleting the existing one, if any. 
    * After that, it reloads the page.
    * @return a reference to the current page, so that the page is reloaded.
    */
    public PageReference UploadAvatarImage() {
        clearMessages();
        Pagereference returnPage = originalPageUrl == null ? Apexpages.currentPage() : new PageReference(originalPageUrl);
        
        returnPage.setRedirect(true);
        
        if(  fileSize == null || fileSize > MAX_FILE_SIZE || avatarImageTempAttachment.Name == null){
            
            pAvatarImageId = null;          
            smallAvatarUrl = null;
            pTempAttachment = null;     
            currentUser = null; 
            returnPage.getParameters().put(PARAM_STATUS, ERROR_MESSAGE);
            returnPage.getParameters().put(PARAM_MESSAGE, Label.IWL_UPLOAD_BIG_ERROR);
            return returnPage;
        }           
        if( widgetRecord == null ){
            
            widgetRecord = IWLWidgetDAO.getRecord( String.escapeSingleQuotes( widgetDeveloperName ) );
        }
        try {
            if( avatarImageTempAttachment.Body != null ){
                String userId = UserInfo.getUserId();
                String newAvatarId;
                String fileName = 'IWLAvatarImage' + EncodingUtil.convertToHex(Crypto.generateDigest('MD5',Blob.valueOf(avatarImageTempAttachment.Name + Crypto.getRandomInteger()))); 
                pTempAttachment = new Attachment(ParentId = widgetRecord.Id, Body = avatarImageTempAttachment.Body, Name = fileName);
            
                //find the developername of the folder to be used to store the widgets into. it can be either the default or custom folder
                String avatarsFolderDevName = (widgetRecord.avatarsFolderDevName__c != null)  ? widgetRecord.avatarsFolderDevName__c : IWLCodeSettings.AvatarUploadFolderDevname;
                
                //if this is not a test, call the web service to update the avatar image
                newAvatarId = IWLAvatarUploadService.updateUserAvatar(currentUser, pTempAttachment, avatarsFolderDevName);
                
                if (newAvatarId == null) {
                    
                    pTempAttachment = null; 
                    returnPage.getParameters().put(PARAM_STATUS, ERROR_MESSAGE);
                    returnPage.getParameters().put(PARAM_MESSAGE, Label.IWL_AVATAR_UPLOAD_ERROR_SAVING_IMAGE );
                    return returnPage;
                }
                currentUser.IWLAvatarId__c = newAvatarId;
                
                pAvatarImageId = null;                  
                smallAvatarUrl = null;
                pTempAttachment = null;     
                currentUser = null; 
                
                returnPage.getParameters().put(PARAM_STATUS, SUCCESS_MESSAGE);
                returnPage.getParameters().put(PARAM_MESSAGE, Label.IWL_AVATAR_SUCCESSFULLY_SAVED);
                
                return returnPage;
            }
        } catch (Exception ex) {
            
            returnPage.getParameters().put(PARAM_STATUS, ERROR_MESSAGE);
            returnPage.getParameters().put(PARAM_MESSAGE,  ex.getMessage() );
            pAvatarImageId = null;          
            smallAvatarUrl = null;
            pTempAttachment = null;     
            currentUser = null;         
            
        }
        return returnPage;
    }
    
    public PageReference deleteAvatarImage() {
        clearMessages();
        try {
            String oldAvatarId = IWLAvatarUploadService.deleteUserAvatar(currentUser);
            Pagereference retPage = (this.originalPageUrl != null ) ? new Pagereference(this.originalPageUrl) : new Pagereference('http://www.google.com');
            retPage.getParameters().put(PARAM_STATUS, SUCCESS_MESSAGE);
            retPage.getParameters().put(PARAM_MESSAGE, Label.IWL_AVATAR_SUCCESSFULLY_DELETED);
            retPage.setRedirect(true);
            return retPage;
        } catch (Exception ex) {
            Apexpages.currentPage().getParameters().put(PARAM_STATUS, ERROR_MESSAGE);
            Apexpages.currentPage().getParameters().put(PARAM_MESSAGE,  ex.getMessage() );
        }
        return Apexpages.currentPage();
    }
    
    @IsTest(SeeAllData=true)
    static void testLoad() {
        Test.startTest();
        
        System.runAs(IWLTestUtilities.getAdminUser()) {
            IWLUploadAvatarWidgetController controller = new IWLUploadAvatarWidgetController();
            Community com = IWLTestUtilities.getCommunity();
            IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_AVATARUPLOAD);
            widget.emptyAvatarImageUrl__c = 'something';
            
            controller.isTest = true;
            controller.widgetDeveloperName = widget.developerName__c;
            controller.widgetRecord= widget;
            controller.editModeOn = true;
            System.assert(controller.loadWidget);
            System.assert(controller.smallAvatarUrl != null && controller.smallAvatarUrl != '');    
        }
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void testUploadImage() {
        Test.startTest();
        System.runAs(IWLTestUtilities.getAdminUser()) {
            IWLUploadAvatarWidgetController controller = new IWLUploadAvatarWidgetController();
            Community com = IWLTestUtilities.getCommunity();
            IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_AVATARUPLOAD);
            
            controller.widgetDeveloperName = widget.developerName__c;
            controller.editModeOn = true;
            controller.widgetRecord = widget;
            controller.pAvatarImageId = 'InvalidId';
            PageReference pg = controller.UploadAvatarImage();
            controller.avatarImageTempAttachment.Body = Encodingutil.base64Decode('9812038140248740174902');
            controller.avatarImageTempAttachment.Name = 'IWLTestName1231231234141153';
            controller.fileSize = 0;
            controller.isTest = true;
            
            pg = controller.UploadAvatarImage();
            System.assert(controller.currentUser.IWLAvatarId__c != null);
            String newAvatarImageId = controller.avatarImageId;
            pg = controller.deleteAvatarImage();
            
        }
        Test.stopTest();
    }
}