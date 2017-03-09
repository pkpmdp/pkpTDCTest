/**
    This trigger creates a business chatter feed every time a new News Article is posted.
**/
trigger tgrNewsArticle on NewsArticle__c (after insert) {
    try{
        YouSeeChatterGroups__c businessGroupYO = YouSeeChatterGroups__c.getValues('YO Business');
        YouSeeChatterGroups__c businessGroupYK = YouSeeChatterGroups__c.getValues('YK Business');
            
        List<FeedItem> feedItems = new List<FeedItem>();        
        Map<String, Id> mapNewsPost = new Map<String,Id>();  // Map<Post LinkURL, News Article Id>
    
        // create a chatter feed for each news which will be posted to the business chatter group
        for(NewsArticle__c news: trigger.new){
            if(news.Post_in_Chatter__c && ((news.Start_Featuring__c <= Datetime.now()) || (news.Start_Featuring__c == null))){
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
                 // Below Line commented to remove the double post
                 //   fItem.body = news.Teaser__c;  
                                        
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
                    
                    system.debug('YK Dept***'+fItem.ParentId);  
                    
                    // create a map of the post LinkURl and the related news article Id
                    //mapNewsPost.put(fItem.linkURL, news.Id);
                    system.debug('URL***'+mapNewsPost.get(fItem.linkURL));
                  // Below Line commented to remove the double post
                 //  fItem.body = news.Teaser__c; 
                    fItem.LinkUrl = baseURL + '/' + news.Id;
                    feedItems.add(fItem);                  
                }
                
                // create a map of the post LinkURl and the related news article Id
                mapNewsPost.put(fItem.linkURL, news.Id);
                //feedItems.add(fItem);           
            }
        } 
     
        if(feedItems.size() > 0){ 
                        
            insert feedItems;
            
                        
            // create a new record in the junction object News_Article_Post__c
            List<News_Article_Post__c> listNewsPosts = new List<News_Article_Post__c>();
            for(Feeditem f: feedItems) {
                News_Article_Post__c np = new News_Article_Post__c();
                np.News_Article__c = mapNewsPost.get(f.linkURL);
                np.Chatter_Post_Id__c = f.Id;
                listNewsPosts.add(np);      
                        
            } //end-for 
            
            if(!listNewsPosts.isEmpty()){
                insert listNewsPosts;
            }           
        } 
    }
    catch(Exception e){
        system.debug('### Exception in tgrNewsArticle:  ' + e.getMessage());
    }
}