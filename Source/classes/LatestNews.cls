/*******************************************************************
* This class gets the news posts to be displayed on YO and YK homepage
*/
public class LatestNews {
    
    //public List<ViewObject> listViewObject {get; private set;}
    private List<String> newsCategories;   
    public List<NewsArticle__c>  listAllNews {get;private set;}
    //boolean value to indicate whether logged in user can access all orgs data.
    public Boolean isFullAccess;
    
    //boolean value to indicate whether logged in user can access all YO News.
    public Boolean isYOUser;
    
    //boolean value to indicate whether logged in user can access all YK News.
    public Boolean isYKUser;
    
    
    // profileId for logged in user
    private String profileId;
    // ViewId for logged in user based on profile
    public String viewId {get;private set;}
    
    // ViewId for logged in user based on profile
    public String YKviewId {get;private set;}
    
    private String newsArticleKeyPrefix;
    public String topLinksKeyPrefix {get;set;}
        
    public String newsDepartment;
    // News Department Selected from page
    public String newsDepartmentSelected {get;set;} 
    public List<SelectOption> ListDepartmentType;
    // Variable to set news list size based on viewport of browser
    public Integer newsSize {get;set;}
    public Integer viewPortHeight {get;set;}
    public Boolean checkDisplay{get;set;}
    
    // constructor
    public LatestNews(KnowledgeHome_Controller controller)
    {
         // figure out the news department
         newsDepartment = getNewsDeptForUser();
         newsSize = 11;
         getNewsArticles();
         checkDisplay = false;     
         
         Schema.DescribeSObjectResult newsArticle = NewsArticle__c.SObjectType.getDescribe();
         newsArticleKeyPrefix = newsArticle.getKeyPrefix();     
         
         Schema.DescribeSObjectResult links = Links__c.SObjectType.getDescribe();
         topLinksKeyPrefix = links.getKeyPrefix();                             
         
         // LoggedIn user's profile Id & custom Setting.                                           
         profileId = UserInfo.getProfileId();
         YK_Views__c views = YK_Views__c.getInstance(profileId);
         viewId = '/' + newsArticlekeyPrefix + '?fcf='+views.ViewId__c;
         if(views.ViewId__c != null) {
             checkDisplay = true;
         }
         
         //YK News
         YKNews_View__c YKviews = YKNews_View__c.getInstance(profileId);
         YKviewId = '/' + newsArticlekeyPrefix + '?fcf='+YKviews.ViewId__c;
         
          /* Code Commented for later use   
             // get all the news categories
             newsCategories = getAllNewsCategories();
             
             // get the news records in the above categories and department
             List<NewsArticle__c> listNews = [select Id, Name, Category__c, Department__c,
                                                     header__c, teaser__c 
                                                from NewsArticle__c
                                                where Department__c = :newsDepartment
                                                and Category__c in :newsCategories ];
                                                                                
             // loop over the news list and 
             // create the view object list         
             createViewObjectList(listNews);
             
           */                           
    }
   
   /* Code Commented for later use  
    // this function creates the list of wrapper objects
    private void createViewObjectList(List<NewsArticle__c> news)
    {
        listViewObject = new List<ViewObject>(); 
        
        // loop over the categories 
        for(String cat : newsCategories)
        {
            ViewObject v = new ViewObject();
            v.category = cat;
            
            // loop over the news list and check if any records for this category. 
            // if found then add them to a list of news articles
            List<NewsArticle__c> listCatNews = new List<NewsArticle__c>();
            v.listNews = listCatNews;
            
            for(NewsArticle__c n : news)
            {
                if(cat == n.Category__c)
                {
                    listCatNews.add(n);
                }
            }
            
            // if atleast one news record in listcatnews,
            // add it to the list of view objects
            if(!listCatNews.isEmpty())
            {
                listViewObject.add(v);
            }               
        }
    }
    
     // this method will get all the values 
    // from the category picklist of the 
    // NewsArticle__c object.
    private List<String> getAllNewsCategories()
    {
       List<String> newsCategories = new List<String>();    
        
       // describe the category picklist in NewsArticle__c object
       Schema.Describefieldresult fieldResult = NewsArticle__c.Category__c.getDescribe();
       // loop over the picklist values obtained in the describe result
       for(Schema.Picklistentry p : fieldResult.getPicklistValues())
       {
          newsCategories.add(p.getValue());     
       }
       
       return newsCategories;
    }
    */
    // this method will evaluate the department
    // based on the profile of the logged in user.
    public String getNewsDeptForUser()
    {        
        //YO Users
        //map used to get the access level 
        Map<string,YOProfilesNew__c> mapYOProfs =YOProfilesNew__c.getAll();
        Set<String> setYOProfiles = mapYOProfs.keySet();
        System.debug('setYOProfiles >>>' + setYOProfiles);
        
        Map<String, SPOC1876_Profiles_New__c> mapSPOC1876UserProfs = SPOC1876_Profiles_New__c.getAll();
        Set<String> setSPOC1876Profiles = new Set<String>();
        setSPOC1876Profiles.addAll(mapSPOC1876UserProfs.keySet());
         System.debug('setSPOC1876Profiles>>>>>>>>>>>>' + setSPOC1876Profiles);
                          
        //YK Users        
        Map<string,YkProfilesNew__c> mapYKProfs =YkProfilesNew__c.getAll();
        Set<String> setYKProfiles = mapYKProfs.keySet();
        system.debug('setYKProfiles >>>' + setYKProfiles );
                
        User loginUsr = [SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        system.debug('User: '+loginUsr);
        String tabSelected;
         if(ApexPages.currentPage().getParameters().containsKey('tab') && ApexPages.currentPage().getParameters().get('tab') != NULL){
                    tabSelected = ApexPages.currentPage().getParameters().get('tab'); 
                    system.debug('tabSelected*******************'+tabSelected); 
                    if(tabSelected == 'YO'){
                        system.debug('isYOUser YO ***************'+isYOUser);
                        return 'YO';
                        system.debug('tab selected +++++++++++++++++++'+tabselected);
                       
                    }else if(tabSelected == 'YK'){
                        system.debug('isYOUser YK ***************'+isYOUser);
                        return 'YK';
                       system.debug('tab selected =================='+tabselected);
                    }        
         }
         else{
        system.debug('in else loop*****************');
            if(setYOProfiles.contains(loginUsr.Profile.Name)){
               system.debug('YO Profile.Name***************'+loginUsr.Profile.Name);
                isYOUser = false;
               system.debug('isYOUser 1 ***************'+isYOUser);
                return 'YO';
             
            }
            else if(setYKProfiles.contains(loginUsr.Profile.Name)){
              system.debug('YK Profile.Name***************'+loginUsr.Profile.Name);
                isYOUser = false;
                system.debug('isYOUser  2 ***************'+isYOUser);
                return 'YK';
              
            }
            else if(setSPOC1876Profiles.contains(loginUsr.Profile.Name)){
             system.debug('SPOC 1876 Profile.Name***************'+loginUsr.Profile.Name);
                isYOUser = false;
                 system.debug('isYOUser  3 ***************'+isYOUser);
                return 'YO';
               
            }
             system.debug('isYOUser 4***************'+isYOUser);
         }
        system.debug('isYOUser***************'+isYOUser);
        return null;
        
    }
   
    
    /*
    // view object that will be bound to the View.
    class ViewObject {
        public String category {get; private set;}
        public List<NewsArticle__c> listNews {get; private set;}
        
    }
    */
    
    public Boolean ShouldDisplay {
        get {
            System.debug('****isYOUser in ShouldDisplay***' + isYOUser);
            return isYOUser;
        }
    }
    
    //Convert Html code to Text
    public String convertHTMLtoText(String html){
        string result = html.replaceAll('<br/>', '\n');
        result = result.replaceAll('<br />', '\n');

        //regular expression to match all HTML/XML tags
        string HTML_TAG_PATTERN = '<.*?>';

        // compile the pattern     
        pattern myPattern = pattern.compile(HTML_TAG_PATTERN);

        // get your matcher instance
        matcher myMatcher = myPattern.matcher(result);
        
        //remove the tags     
        result = myMatcher.replaceAll('');
        
        return result;
    } 
    
    
    
    public PageReference getNewsArticles(){
        System.debug('NewsSize**'+newsSize);
        if(viewPortHeight != null){
            List<ViewPortSettings__c> vpList = ViewPortSettings__c.getAll().values();
            if(vpList.size() > 0){
                System.debug('Inside If');
                for(ViewPortSettings__c vp : vpList){
                    if(viewPortHeight > vp.MinViewPort__c && viewPortHeight < vp.MaxViewPort__c){
                        newsSize =(Integer)vp.NewsLimit__c;
                        break;
                    }
                }
               System.debug('NewsSide Inside***'+newsSize);
            }
        }
        listAllNews = [SELECT Id, Name, Category__c, Department__c,Article__c,
                                            CreatedDate, header__c, teaser__c,Start_Featuring__c  
                                         FROM NewsArticle__c 
                                         WHERE Department__c INCLUDES (:newsDepartment) 
                                         AND (Stop_Featuring__c = null OR Stop_Featuring__c > TODAY) AND  Start_Featuring__c <= TODAY  ORDER BY Priority__c DESC, Start_Featuring__c DESC
                                         LIMIT :newsSize];
         
         // Added By Vishal for showing HTML code in text form in mouse hover                                     
         String articles = '';                                  
         for(NewsArticle__c  article : listAllNews){
            if(article.Article__c != NULL){
               //articles = convertHTMLtoText(article.Article__c); //commented on SPOC 2113
               System.debug('****-->'+article.Article__c);
                articles = article.Article__c;
            }
            // SPOC 2113 Start
            if(article.Category__c  != NULL){
                //article.Article__c = article.Category__c + ' ' + '-' +'\n\n' + convertHTMLtoText(article.Article__c);
               articles = article.Category__c +'<br/><br/>' + articles;
                
                if(articles.contains('<img') && articles.contains('<table')) // if both image and table present in article.
                {
                   articles = articles.replaceAll('<img[^>]*>','<br/><font color="red">&lt; Den vedhæftede fil er for stor til hover text. Åbn nyheden for at se hele indholdet &gt;</font><br/>');
                   articles = articles.replaceAll('<td', '<td style=\"word-wrap: break-word;word-break: break-word;word-break: break-all;\"');
                   articles = articles.replaceAll('width: ', 'width: 200px');
                    
                   system.debug('-----'+articles);
                   articles = articles.replaceAll('</img>', '');
                }
                else if(articles.contains('<img') || articles.contains('<table'))  // to handle the table or image display on hovering
                {
                    System.debug('****article-->'+ articles.replaceAll('<img[^>]*>','<br/><font color="red">&lt;Den vedhæftede fil er for stor til hover text. Åbn nyheden for at se hele indholdet&gt;</font><br/>'));
                    articles = articles.replaceAll('<img[^>]*>','<br/><font color="red">&lt; Den vedhæftede fil er for stor til hover text. Åbn nyheden for at se hele indholdet &gt;</font><br/>');
                    articles = articles.replaceAll('<td', '<td style=\"word-wrap: break-word;word-break: break-word;word-break: break-all;\"');
                    articles = articles.replaceAll('width: ', 'width: 200px');
                    articles = articles.replaceAll('<td', '<td width=\"200px\"');
                    system.debug('-----'+articles);
                    articles = articles.replaceAll('</img>', '');
                }
                else
                {
                    article.Article__c = article.Category__c + ' ' + '<br/>' + articles.replaceAll('font-size:', 'font-size: 14px');
                }
            }else{
               if(articles.contains('<img') && articles.contains('<table')) // if both image and table present in article.
                {
                    articles = articles.replaceAll('<img[^>]*>','<br/><font color="red">&lt; Den vedhæftede fil er for stor til hover text. Åbn nyheden for at se hele indholdet &gt;</font><br/>');
                   
                    articles = articles.replaceAll('<td', '<td style=\"word-wrap: break-word;word-break: break-word;word-break: break-all;\"');
                    articles = articles.replaceAll('width: ', 'width: 200px');
                   system.debug('-----'+articles);
                   articles = articles.replaceAll('</img>', '');
                }
                else if(articles.contains('<img') || articles.contains('<table')) // to handle the table or image display on hovering
                {
                    articles = articles.replaceAll('<img[^>]*>','<br/><font color="red">&lt; Den vedhæftede fil er for stor til hover text. Åbn nyheden for at se hele indholdet &gt;</font><br/>');
                   
                    articles = articles.replaceAll('<td', '<td style=\"word-wrap: break-word;word-break: break-word;word-break: break-all;\"');
                    articles = articles.replaceAll('width: ', 'width: 200px');
                    articles = articles.replaceAll('<td', '<td width=\"200px\"');
                    system.debug('-----'+articles);
                    articles = articles.replaceAll('</img>', '');
                }
            }
             articles = articles.replaceAll( '</?a[^>]*>', '');
             articles = articles.replaceAll('font-size:', 'font-size: 14px');
             article.Article__c = articles;
         } 
        // SPOC 2113 END
         return null;  
    }
    
    public List<SelectOption> getListDepartmentType(){
        if(listdepartmentType == null){
            return YKSpocUtils.getDepartmentType();
        }
        return listdepartmentType;
    } 
     
}