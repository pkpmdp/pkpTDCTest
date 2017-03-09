public with sharing abstract class IWLBaseWidgetController {

	public static final String ERROR_MESSAGE = 'Error';
	public static final String WARNING_MESSAGE = 'Warning';
	public static final String SUCCESS_MESSAGE = 'Success';
	public static final String INFO_MESSAGE = 'Info';
	
	public static final String CSS_CLASS_PREFIX = 'IWLStatus';

    public String LoadErrorMessage {
    	get ;
    	set {
    		LoadErrorMessage = value;
    		this.addMessage(ERROR_MESSAGE, LoadErrorMessage);
    		
    	}
    } //this string is used to show the user an error message upon widget load.
    
    public Map<String, List<StatusMessage>> statusMessages = new Map<String, List<StatusMessage>>();
    
    public StatusMessagesWrapper statusMessagesWrap {
    	get {
    		return new StatusMessagesWrapper(statusMessages);
    	} set;
    }
    
    
    public String WidgetDeveloperName {get; 
        set {
            if (WidgetDeveloperName != value) {
                loadWidget = null;
                if (widgetRecord != null && widgetRecord.DeveloperName__c != value) {
                    widgetRecord = null;
                    
                }
            }
            WidgetDeveloperName = value;
            
        }
    }
    public IWLWidget__c widgetRecord {get; 
        set {
            if (widgetRecord != null && value != null && WidgetDeveloperName != value.DeveloperName__c) {
                WidgetDeveloperName = value.DeveloperName__c;
            }   
            if (value != null && widgetRecord == null) {
            	
                widgetRecord = value;
            }
            
        }
    }
    
    protected String originalPageUrl {get; set;} //the url, at the moment this widget is loaded.
    
    /**
    * This method will be implemented by each Type of widget controller in order to implement the 
    * widget-specific load procedure of the widget's specs and information. 
    * @return true iif the load process was successful.
    */
    protected abstract Boolean doLoad();
    
    public virtual String getOriginClassName() {
        
        return 'IWLWidget' + IWLCodeSettings.getCssForOrigin(widgetRecord.Origin__c);
    }
    
    /**
    * This method is follows the "Template Method" design pattern and attempts to load the IWL widget 
    * record from the database, searching for a record with developerName__c = widgetDeveloperName, 
    * initializing the widget with the information retrieved from the database.
    * @returns true iif there's an IWLWidget__c record in the database such that its developerName__c = widgetDeveloperName, 
    * and the widget-specific load procedure is successful
    */
    public Boolean loadWidget {
        get {
            if (loadWidget == null) {//the controller has not been initialized before
                if (widgetDeveloperName != '') {//a widgetDeveloperName has been provided, so we query attempt to get that record.
                    
                    try {
                        
                        if (widgetRecord == null || widgetRecord.DeveloperName__c == null || widgetRecord.DeveloperName__c != widgetDeveloperName) {
                            String n = String.escapeSingleQuotes( widgetDeveloperName );
                            widgetRecord = IWLWidgetDAO.getRecord( n );// ask the IWLWidgetDAO for the widget record.
                        }
                        if (widgetRecord != null) {
                            //widget record successfully loaded.
                            loadWidget = doLoad();
                            
                            originalPageUrl = Apexpages.currentPage().getUrl();
                            
                        } else {
                            //could not load the widget... probably because a wrong WidgetDeveloperName
                            LoadErrorMessage = Label.IWL_ERROR_INVALID_DEVELOPER_NAME;
                            loadWidget = false;
                        }
                        
                    } catch (Exception ex) {
                        //TODO: process IWLWidget__c record retrieval exception
                        LoadErrorMessage = Label.IWL_ERROR_IN_DATABASE + ' ' + ex.getMessage();
                        loadWidget = false;
                    }
                    
                } else {                    
                    LoadErrorMessage = Label.IWL_ERROR_EMPTY_DEVELOPER_NAME;
                    loadWidget = false;
                }// END: if (widgetDeveloperName != '')
            } // END: if (loadWidget == null)
            return loadWidget;  
        } 
        set;
    } 
    
    /**
    * This method generates a page reference, depending on the parameters set in widgetRecord. It either generates 
    * a redirect page reference, or a null page reference (for rerenders) 
    * @return null iif !widgetRecord.redirect__c && widgetREcord.redirectUrl__c == null. 
    * @return A page reference to the current page if widgetRecord.redirectUrl__c == null. Redirection will be applied if widgetRecord.redirect__c
    * @return A page reference to widgetRecord.redirectUrl__c if it is not null. Redirection will be applied if widgetRecord.redirect__c
    */
    protected PageReference generateReturnReference() {
        if (!widgetRecord.Redirect__c) {
            return null;
        }
        PageReference pr;
        if (widgetRecord.RedirectURL__c == null || widgetRecord.RedirectURL__c == '') {
            pr = new PageReference(originalPageUrl);
        } else {
            String redirectUrl = widgetRecord.RedirectURL__c;
            if (!redirectUrl.toLowercase().startsWith('http') ) {
                redirectUrl = URL.getSalesforceBaseUrl().toExternalForm() + (redirectUrl.startsWith('/') ? '' : '/') + redirectUrl;
            }
            pr = new PageReference(redirectUrl);
        }   
        pr.setRedirect(true);
        
        return pr;
    }
    
    /**** Messaging methods - They provide functionality to manage status messages shown to the user ****/
    
    
    public void addMessage(String status, String message) {
    	if (!statusMessages.containsKey(status) || statusMessages.get(status) == null) {
    		statusMessages.put(status, new List<StatusMessage>());
    	}
    	statusMessages.get(status).add(new StatusMessage(status, message));
    }
    
    public void clearMessages() {
    	if (statusMessages != null) {
    		statusMessages.clear();
    	}
    }
    
    public with sharing class StatusMessage {
    	
    	public String status {get; set;}
    	public String message {get; set;}
    	
    	public StatusMessage(String status, String message) {
    		this.status = status;
    		this.message = message;
    	}
    	
    	public String getCSSClass() {
    		return CSS_CLASS_PREFIX + status;
    	}
    }
    
    
}