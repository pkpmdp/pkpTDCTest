/**
* This class implements the controller part of the MVC pattern for the Post Idea Widget.
*/
public with sharing class IWLPostIdeaWidgetController extends IWLBaseWidgetController {

    
    public String saveMessage           {get; set;} //a message to be shown when an idea is posted
    public String message {get;set;}
    public Integer MSG_MAX_LENGTH           { get { return 32000; } }
    public String ThemeId               {get; set;}
    public String defaultTitle          {get {
                                            return Label.IWL_ENTER_TITLE;
                                        } set;}
    public Boolean reRenderIdeaBody {get; set;} //a flag signaling if the Idea's body must be re-rendered in the component
    public Boolean postSuccess {get; set;} //a flag signaling the Idea has been successfully saved.
    private transient Idea[] searchResult; //used to search for similar ideas.
    private transient Idea pIdea;//the new idea to be posted.
    String categoryForIdea;
    
    public IWLPostIdeaWidgetController() {
        searchResult = new List<Idea>();
        reRenderIdeaBody = false;
    }
    
    /**
    * This method overrides the one in IWLBaseWidgetController in order to implement the 
    * widget-specific load procedure of the widget's specs and information. 
    * @return true iif the load process was successful.
    */
    protected override Boolean doLoad() {
        
        if (widgetRecord.Type__c == IWLCodeSettings.PostIdeaRecordTypeName) {
            //the widgetRecord exists and is of the correct type for this widget
            return true;
        } else {
            //the widgetRecord has a wrong type.
            //LoadErrorMessage = Label.IWL_ERROR_INVALID_RECORD_TYPE;
            message = 'Wrong Widget Type, please contact administrator';
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.Error, message );
            ApexPages.addMessage(msg); 
            return false;
        }       
    }
    
    
    /**
    * This is a getter method for the Idea record being created in this controller, wrapping the value of the private pIdea attribute.
    */
    public Idea getNewIdea() {
        
            if (pIdea == null) {
                pIdea = new Idea();
                pIdea.communityId = widgetRecord.Community__c;
                
            }
            return pIdea;
        
    }
    
    /**
    * This method returns the names of the categories available for the Idea object
    * @return an array with the names of all the categories available for the Idea object.
    */
    public String[] getCategories() {
        List<String> cats = new List<String>();
        if (!SecurityManager.IsAccessible(Idea.Categories)) {
            return cats;
        }
        Schema.DescribeFieldResult fieldResult = Idea.Categories.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            cats.add(f.getLabel());
        }
        cats.sort();
        fieldResult = null;
        ple = null;
        return cats;
    }
    
    
    /**
    * This method builds a list of SelectOption to be used in the Widget so that the user can select multiple categories for the new idea.
    * @return the list of SelectOptions according to the categories avaialble for the Idea object.
    */
    /*public List<SelectOption> getCategoryOptions() {
        List<SelectOption> valueOptions = new List<SelectOption>();
        for (String value : getCategories()) {
            valueOptions.add(new SelectOption(value, value));
        }
        return valueOptions;
    }*/
    
    /**
    * Builds a list with the categories that have been already assigned to the idea that is being created.
    * @return an array containing the names of the categories that have been already assigned to the idea being created.
    */
    /*public String[] getCategoriesForIdea() {
        Idea nIdea = getNewIdea();
        String categories = nIdea.categories;
        if (categories == null) {
            return new List<String>();
        } else {
            return categories.split(';');
        }       
    }*/
    public String getCategoryForIdea() {
        return categoryForIdea;   
    }
    
    
    /**
    * Adds the categories whose names are in the "categories" array to the ones assigned to the idea that is being created.
    * @param categories The list of categories to be added to the idea being created by this widget.
    */
    /*public void setCategoriesForIdea(String[] categories) {
        String categoryString = '';

        for (String category : categories) {
             if (categoryString.length() > 0) {
                categoryString += ';';
            }
            categoryString += category;
        }

        Idea nIdea = getNewIdea();
        if (nIdea.categories == null || nIdea.categories.length() == 0) {
            nIdea.categories = categoryString;
        } else if (categoryString.length() > 0) {
            nIdea.categories += ';';
            nIdea.categories += categoryString;
        }
    }*/
    
    public void setCategoryForIdea(String categories) {
        this.categoryForIdea = categories;
        Idea nIdea = getNewIdea();
        nIdea.categories = categoryForIdea;        
    }
    
     public Idea[] getSimilarIdeas() {
        return searchResult;
     }
    
     /**
     * This method loads in searchResult a list of similar ideas to the one that the user is attempting to create, matching by the system provided
     * functionality "Ideas.findSimilar".
     * @return a null page reference so that the widget can be re-rendered.
     */
     public PageReference loadSimilar() {
         Idea nIdea = getNewIdea();
         try {
             Id[] similarIds = Ideas.findSimilar(nIdea);
             if (similarIds == null || similarIds.size() == 0) {
                 return null;
             } else {
                 searchResult = [select Id, title from idea where id in :similarIds];
             }
         } catch (Exception ex) {
             return null;
         }
         return null;
     }

     public Boolean getHasSimilarIdeas() {
         return searchResult != null && searchResult.size() > 0;
     }
    
     /**
     * The method to save the idea that has been created in this widget, clearing the widget's form if everything is ok.
     * @return an emtpy page reference to re-render the widget.
     */
     public PageReference save() {
        clearMessages();
        System.debug('****Wen save action');        
        PageReference saveReturnReference = generateReturnReference();
         try {
            SecurityManager.canCreate(Idea.sObjectType);
            SecurityManager.canCreate(new Schema.sObjectfield[] { Idea.Body, Idea.Title});
             Idea nIdea = getNewIdea();
             if (nIdea.Body != null && nIdea.Body.length() > MSG_MAX_LENGTH) {
                //idea body is too long
                //addMessage(ERROR_MESSAGE, Label.IWL_TOO_LONG_IDEA_BODY.replace('{0}', String.valueOf(MSG_MAX_LENGTH)));
                message = 'Beskrivelse må ikke overskride det maksimale antal 3200 tegn';
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.WARNING, message );
                ApexPages.addMessage(msg); 
                reRenderIdeaBody = false;
                postSuccess = false;
                return null;
             }
             if( IWLIdeaThemeDAO.IsIdeaThemeEnabled && themeId != null){
                nIdea.put( 'IdeaThemeId', themeId );
             }
             
             insert nIdea;
             reRenderIdeaBody = true;
             saveMessage = Label.IWL_IDEA_SAVED;
             addMessage(SUCCESS_MESSAGE, Label.IWL_IDEA_SAVED);
             pIdea = null;
             //append the new idea id at the last of the querystring for the new page.
             if (saveReturnReference != null) {
                                
                Boolean redirect = saveReturnReference.getRedirect();
                saveReturnReference = new PageReference(saveReturnReference.getUrl());
                //saveReturnReference.getParameters().put('IWLNewIdeaId', nIdea.id);
                saveReturnReference.getParameters().put('id', nIdea.id);                
                saveReturnReference.setRedirect(redirect);
             }
             postSuccess = true;
         } catch (System.DmlException e) {
             for (Integer i = 0; i < e.getNumDml(); i++) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
                 //this.addMessage(ERROR_MESSAGE, '' + e.getDmlMessage(i) );
             }
             reRenderIdeaBody = false;
             postSuccess = false;
             return null;
         } catch (Exception e) {
            this.addMessage(ERROR_MESSAGE, '' + e.getMessage());
            postSuccess = false;
            return null;
         }
         return saveReturnReference;
     }
    
    /**
    * The cancel functionality for the widget, clears the form and the new Idea record's field
    * @return a null PageReference.
    */
    public PageReference cancel() {
        clearMessages();
        pIdea = null;
        if (widgetRecord.twoStepIdea__c) {
            return null;//DO NOT REDIRECT IF THE WIDGET IS A TWO STEPS WIDGET
        } else {
            reRenderIdeaBody = true;
            return generateReturnReference();
        }
        
    }
    
    /**
    * Returns the amount of seconds that it takes the widget to render the "details" part after the user has clicked on the "next" button.
    * @return an amount of time, in seconds.
    */
    public Integer transitionInterval {
        get {
            return (widgetRecord.transitionInterval__c != null && Integer.valueOf(widgetRecord.transitionInterval__c) > 0) ? Integer.valueOf(widgetRecord.transitionInterval__c)  : 0;
        }
    }
    
    public String emptyButtonUrl {
        get {
            return IWLCodeSettings.ResourceEmptyButtonImage;
        }
    }
    
    @isTest
    public static void testIWLPostIdeaWidgetController() {
        Community com = IWLTestUtilities.getCommunity();
        
        Idea i = IWLTestUtilities.createIdea('Test Idea 1312324214124124', 'body', com.Id);
        
        IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_POSTIDEA);

        IWLPostIdeaWidgetController c = new IWLPostIdeaWidgetController();
        
        c.widgetDeveloperName = widget.developerName__c;
        c.widgetRecord = widget;
        widget.transitionInterval__c = 5;
        widget.Redirect__c = true;
        widget.RedirectURL__c = 'apex/IWLIdeaDetail';
        if( c.loadWidget ){
            Idea newIdea = c.getNewIdea();
            List<String> categories = c.getCategories();
            
            newIdea.Title = 'Test Idea 1312324214124124';
            newIdea.Body = i.body;
            //c.setCategoriesForIdea(new String[] { 'Test Category 1' ,'Test Category 2'});
            //c.setCategoriesForIdea(new String[] { 'Test Category 3' ,'Test Category 4'});
            c.setCategoryForIdea('Test Category 1');
            c.setCategoryForIdea('Test Category 2');
            
            //List<Selectoption> categoriesSelectOptions = c.getCategoryOptions(); //just for code coverage
            //List<String> categoriesForIdea = c.getCategoriesForIdea();
            String categoriesForIdea = c.getCategoryForIdea();
            
            c.loadSimilar();
            Idea[] similarIdeas = c.getSimilarIdeas();
            
            c.getHasSimilarIdeas();
            
            if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
                sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'description', '', com.Id);
                c.ThemeId = String.valueOf(theme.get('Id'));
            }
            
            PageReference saveresult = c.save();
            
            newIdea = c.getNewIdea();
            newIdea.Title = null;
            c.save();
            c.cancel();
            system.assert( c.transitionInterval > 0 );
        } else {
            System.debug('### failed loading');
        }
    }
}