public class youbioIdeasController {
    public FacebookUser me{get;set;}
    public boolean authed{get;set;}
    public IWLWidget__c listview {get; set;}
    public boolean loggedin{get;set;}
    public String facebookLoginUrl{get;set;}
    public String latestIdeaID{get;set;}
    public String mostPopIdeaID{get;set;} 
    public YoubioIDs__c youbio{get;set;} 
    public static String youbioAuthProvider; 
    public String sortedBy{get;set;}   
    
    public youbioIdeasController() {
        //if(loggedin == true){
        youbio = YoubioIDs__c.getInstance('Youbio');
        //youbioAuthProvider = '0SOM0000000000L';
       youbioAuthProvider = '0SOD0000000TN1U';//PROD 
        String accessToken = getToken();
        if(accessToken != null) {
            me = new FacebookUser(accessToken, 'me');
            authed = true; 
            loggedin = true;           
        } else {
            authed = false;
            loggedin = false;
        }
        List<Idea> latestIdeaIDs = [Select i.VoteTotal From Idea i where i.CommunityId= :youbio.CommunityID__c ORDER BY i.CreatedDate DESC ];
        latestIdeaID = latestIdeaIDs[0].id;
        List<Idea> mostPopIdeaIDs = [Select i.VoteTotal From Idea i where i.CommunityId= :youbio.CommunityID__c ORDER BY i.VoteTotal DESC ];         
        mostPopIdeaID = mostPopIdeaIds[0].id;                 
        //facebookLoginUrl = 'https://test.salesforce.com/services/auth/sso/00DM0000000ARWBMA4/FacebookSign?site=https%3A%2F%2Fyousee.test.cs7.force.com&startURL=%2Fapex%2FyoubioIdeas';  
        facebookLoginUrl = youbio.FacebookRedirectURL__c;
     }
   
    
    public Boolean doLoad {
                get {
                        if (doLoad == null) {
                                //listview = IWLWidgetDAO.getRecord('IdeasList');
                                                                
                                
                                Map<String, String> pageParams = Apexpages.currentPage().getParameters();
                                String selectedCategory = pageParams.get('category');
                                sortedBy = pageParams.get('sortedBy');                                
                                String selectedCat;
                                String idsList = pageParams.get('records');
                                Boolean showMyIdeas = pageParams.get('mine') != null;                                
                                if(selectedCategory!= null) {
                                    listview = IWLWidgetDAO.getRecord('ListByCategory');
                                } else if(sortedBy == 'rating') {
                                    listview = IWLWidgetDAO.getRecord('IdeasByRating');                                    
                                } else {
                                    listview = IWLWidgetDAO.getRecord('IdeasByTime');                                
                                }                                                               
                               
                                if (selectedCategory != null && selectedCategory != '') {
                                        if(selectedCategory == '0'){
                                            selectedCat = 'Klienter/platforme';
                                            selectedCat = selectedCat.escapeHTML4();                                                
                                             listview.useAdvancedFiltering__c = true;
                                             listview.filterAdvanced__c = 'categories includes (\'' + selectedCat + '\')';
                                             System.debug('***Wen selectedCategory'+listview.filterAdvanced__c);                                    
                                        }
                                        else if(selectedCategory == '1'){
                                            selectedCat = 'Indhold';
                                             listview.useAdvancedFiltering__c = true;
                                        listview.filterAdvanced__c = 'categories includes (\'' + selectedCat + '\')';
}
                                        else if(selectedCategory == '2'){
                                            selectedCat = 'Design';
                                             listview.useAdvancedFiltering__c = true;
                                        listview.filterAdvanced__c = 'categories includes (\'' + selectedCat + '\')';

                                            }
                                        else if(selectedCategory == '3'){
                                            listview.useAdvancedFiltering__c = true;
                                            listview.filterAdvanced__c = 'CreatedById = \''+ youbio.AdministratorID__c + '\'';

                                        }
                                                                                        
                                                                               System.debug('***Wen debug first if');
                                } else if (idsList != null && idsList != '') {
                                        //show only ideas the user has searched for
                                        listview.useAdvancedFiltering__c = true;
                                        idsList = '\'' + idsList + '\'';
                                        idsList = idsList.replaceAll(',', '\',\'');
                                        listview.filterAdvanced__c = 'Id in (' + idsList + ')';
                                        System.debug('***Wen debug second if '); 
                                } else if (showMyIdeas) {
                                        listview.useAdvancedFiltering__c = true;
                                        listview.filterAdvanced__c = 'CreatedById = \''+ Userinfo.getUserId() + '\'';
                                        System.debug('wen debug third if');
                                }
                                doLoad = true;
                        }
                        System.debug('wen debug'+doLoad);
                        return doLoad;
                } set;
        }

    
    /*public PageReference redirectPage() {
         String newPageUrl = 'https://test.salesforce.com/services/auth/sso/00DM0000000ARWBMA4/FacebookSign?site=https%3A%2F%2Fyousee.test.cs7.force.com%2FyoubioHome';        
         //String newPageUrl = 'https://test.salesforce.com/services/auth/sso/00DM0000000ARWBMA4/Youbio?site=https%3A%2F%2Fyousee.test.cs7.force.com%2FyoubioIdeas';
         PageReference newPage = new PageReference(newPageUrl);
         newPage.setRedirect(true);
         return newPage;
    }*/
    
    public static String getToken() {
        return Auth.AuthToken.getAccessToken(youbioAuthProvider,'facebook'); 
    }
    
    public FacebookUser getMe() {
        String accessToken = getToken();
        if(accessToken != null)
           me = new FacebookUser(accessToken, 'me');
        return me;           

    }
    
    private User currentUser {    
        get {
                      if (currentUser == null) {
                        currentUser = [Select Id, IWLAvatarId__c, createdDate from User where Id = :UserInfo.getUserId()]; 
                      } 
                      return currentUser;
        } set;  
    }
    
    public String getProfilePicture () {
        return currentUser.IWLAvatarId__c;
    }
    
    public String getUserCreatedDate() {
        Datetime dT = currentUser.CreatedDate;
        return String.valueOf(Date.newinstance(dT.year(), dT.month(), dT.day()));
    }
    
}