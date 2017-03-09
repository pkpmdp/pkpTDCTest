public class PostNewsInChatter {
	
	public PostNewsInChatter(){
		
	}
	
	public void updateChatter(){
	    try{
        YouSeeChatterGroups__c businessGroupYO = YouSeeChatterGroups__c.getValues('YO Business');
        YouSeeChatterGroups__c businessGroupYK = YouSeeChatterGroups__c.getValues('YK Business');
            
        List<FeedItem> feedItems = new List<FeedItem>();        
        Map<String, Id> mapNewsPost = new Map<String,Id>();  // Map<Post LinkURL, News Article Id>
    
        // create a chatter feed for each news which will be posted to the business chatter group
        for(NewsArticle__c news: [select Id, Name,Teaser__c,Department__c,Post_in_Chatter__c from NewsArticle__c where Start_Featuring__c = TODAY]){
            if(news.Post_in_Chatter__c){
                FeedItem fItem = new FeedItem();
                //fItem.Title = news.Teaser__c;
                String baseURL = Url.getSalesforceBaseUrl().toExternalForm();
                //fItem.LinkUrl = baseURL + '/' + news.Id;
                
                // if news article belongs to YO, post in YO Business Group
                if(news.Department__c.contains('YO')){                  
               //Changed from fItem.Title from News.Teaser__c to News.Name. Change related to SPOC-1558               
               //     fItem.Title = news.Teaser__c;
                      fItem.Title = news.Name;
                    fItem.ParentId = businessGroupYO.GroupId__c; 
                // Below Line Commented to test one task related to double post in chatter
                //    fItem.body = news.Teaser__c;  
                    //system.debug('YO Dept***'+fItem.ParentId); 
                    
                    fItem.LinkUrl = baseURL + '/' + news.Id;  
                    
                    // create a map of the post LinkURl and the related news article Id
                    //mapNewsPost.put(fItem.linkURL, news.Id);
                    feedItems.add(fItem);                   
                } 
                
                // if news article belongs to YK, post in YK Business Group             
                if(news.Department__c.contains('YK')){                    
                    fItem = new FeedItem();
                 //Changed from fItem.Title from News.Teaser__c to News.Name. Change related to SPOC-1558               
               //     fItem.Title = news.Teaser__c;
                      fItem.Title = news.Name;
                    fItem.ParentId = businessGroupYK.GroupId__c; 
                    
                    //system.debug('YK Dept***'+fItem.ParentId);  
                    
                    // create a map of the post LinkURl and the related news article Id
                    //mapNewsPost.put(fItem.linkURL, news.Id);
                    //system.debug('URL***'+mapNewsPost.get(fItem.linkURL));
                  // Below Line Commented to test one task related to double post in chatter
                   // fItem.body = news.Teaser__c; 
                    
                    fItem.LinkUrl = baseURL + '/' + news.Id;  
                    
                    //mapNewsPost.put(fItem.linkURL, news.Id);
                    feedItems.add(fItem);                  
                }
                
                // create a map of the post LinkURl and the related news article Id
                mapNewsPost.put(fItem.linkURL, news.Id);
                //feedItems.add(fItem);           
            }
        } 
     
        if(feedItems.size() > 0){ 
            //system.debug('feedItems1***'+ feedItems.size());
            //system.debug('feeds items***'+feedItems);
            
            insert feedItems;
            
           // system.debug('feedItems***'+ feedItems.size());
            //system.debug('parent***'+feedItems[0].ParentId);
            //system.debug('parent***'+feedItems[1].ParentId);
            //system.debug('linkUrl***'+feedItems[1].linkURL);
            
            // create a new record in the junction object News_Article_Post__c
            List<News_Article_Post__c> listNewsPosts = new List<News_Article_Post__c>();
            for(Feeditem f: feedItems) {
                News_Article_Post__c np = new News_Article_Post__c();
                np.News_Article__c = mapNewsPost.get(f.linkURL);
                //system.debug('PostLink***'+mapNewsPost.get(f.linkURL));
                //system.debug('Link***'+np.News_Article__c);
                np.Chatter_Post_Id__c = f.Id;
                listNewsPosts.add(np);      
                        
            } //end-for 
            
            //system.debug('listSize***'+ listNewsPosts.size());
            
            if(!listNewsPosts.isEmpty()){
                insert listNewsPosts;
            }           
        } 
    }
    catch(Exception e){
        system.debug('### Exception in tgrNewsArticle:  ' + e.getMessage());
    }
	}
}