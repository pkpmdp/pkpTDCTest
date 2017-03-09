/**
* This class implements some methods that serve as utilities for images management.
*/
public with sharing class IWLImageUtilities {
    
    public static final String SERVLET_FILE_DOWNLOAD_URL = '/servlet/servlet.FileDownload?file='; 
    public static final String VISUALFORCE_PAGE_APEX_URL = 'apex';
    
    /**
    * This method builds a link to an image Document from its id. 
    * @param imageDocumentId The id of the document where the image has been stored.
    * @return a link that allows the application to either show or download the document in the browser. The returned string is empty if imageDocumentId is empty or null. 
    */
    public static String getImageUrl(String imageDocumentId) {

        if (imageDocumentId == null || imageDocumentId == '') {
            return '';
        } else {
            if (Site.getCurrentSiteUrl() == null) {
                return URL.getSalesforceBaseUrl().toExternalForm() + 
                    +SERVLET_FILE_DOWNLOAD_URL+imageDocumentId;
            } else {
                if( URL.getCurrentRequestUrl().toExternalForm().contains(VISUALFORCE_PAGE_APEX_URL) ){
                    return URL.getCurrentRequestUrl().toExternalForm().substring( 0, URL.getCurrentRequestUrl().toExternalForm().indexOf(VISUALFORCE_PAGE_APEX_URL) )
                        +SERVLET_FILE_DOWNLOAD_URL+imageDocumentId
                        +'&oid='+UserInfo.getOrganizationId();
                }else{
                    return URL.getSalesforceBaseURL().toExternalForm()
                        +SERVLET_FILE_DOWNLOAD_URL+imageDocumentId
                        +'&oid='+UserInfo.getOrganizationId();
                }
            }
        }       
    }
    
    public static String getImageUrl(sObject record, String fieldName, String defaultImagePath) {
        return getImageUrl((String)record.get(fieldName), defaultImagePath);
    }
    
    public static String getImageUrl(String imagePath, String defaultImagePath) {
        return (imagePath == null || imagePath == '') ? defaultImagePath : imagePath;
    }
    

    public static String getFacebookImage(String imagePath) {
        return imagePath;
    }
        
    @isTest
    private static void testImageUtilities() {
        Test.startTest();
        
        String imageUrl = IWLImageUtilities.getImageUrl('path', 'default');
        System.assert(imageUrl == 'path');
        imageUrl = IWLImageUtilities.getImageUrl(null, 'default');
        System.assert(imageUrl == 'default');       
        Document doc = new Document();
        doc.Description = null;
        imageUrl = IWLImageUtilities.getImageUrl(doc, 'Description', 'path');
        
        doc.Description = 'Desc';
        imageUrl = IWLImageUtilities.getImageUrl(doc, 'Description', 'path');
        System.assert(imageUrl != '');
        
        imageUrl = IWLImageUtilities.getImageUrl(null);
        system.assert(imageURL == '');
        
        imageUrl = IWLImageUtilities.getImageUrl('something');
        system.assert(imageURL != '');
        
        
        Test.stopTest();
    }
    
    
}