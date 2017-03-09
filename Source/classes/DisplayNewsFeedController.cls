/**
	Controller class for the page "DisplayNewsFeedPage".
	Fetches chatter feeds related to the current news article record and displays them on detail page	
**/
public class DisplayNewsFeedController {
	public List<FeedItem> lstFeeds	{get;set;} // holds the feed to be displayed on page
	
	public Map<String, User> userDetails {get;set;} // holds user details in the form <user id, user record>
	Set<Id> userIds; // holds Id's of users who have posted feeds and comments
	String newsId; // holds current NewsArticle record's Id
	List<News_Article_Post__c> newsPost; // holds the news article post record related to current news article
	
	public DisplayNewsFeedController(ApexPages.StandardController controller) {
		/* Start -	initialize variables	*/
		lstFeeds = new List<FeedItem>();
		userDetails = new Map<String, User>();
		userIds = new Set<Id>();
		newsId = '';
		newsPost = new List<News_Article_Post__c>();
		/* End -	initialize variables	*/
		
		newsId = controller.getId();  // fetch the current record id 
		 
		try{
			// Fetch feeds related to the current NewsArticle based on NewsArticlePost record, if any, associated
			// with the current NewsArticle Record	
			if(newsId != NULL){
	            newsPost = [SELECT Chatter_Post_Id__c FROM News_Article_Post__c 
	                        WHERE News_Article__c = :newsId LIMIT 1];
	        }
	        if(newsPost.size() > 0){ 
	        	lstFeeds = [SELECT Title, LinkUrl, CreatedById, Body, 
	        			   (SELECT CreatedById, CommentBody FROM FeedComments ORDER BY CreatedDate ASC) 
	        			    FROM FeedItem
							WHERE Id = :newsPost[0].Chatter_Post_Id__c];
	        }
	        
	        // Fetch comments related to the associated chatter Feed
	        // NOTE: We have used a "for within a for" because there will only be one feedItem in lstFeeds
	        for(FeedItem f: lstFeeds){
				for(FeedComment c : f.FeedComments){
					if(!userIds.contains(c.CreatedById))
						userIds.add(c.CreatedById);
				}
				if(!userIds.contains(f.CreatedById))
					userIds.add(f.CreatedById);
			}
			
			// store user details in a map, to be used on the page for fetching user details
			for(User u : [Select Name, SmallPhotoUrl From User Where Id IN :userIds]){
				userDetails.put(u.Id, u);
			}
		}
		catch(Exception e){
			system.debug('### Exception in DisplayNewsFeedController constructor: ' + e.getMessage());
		}
	}
}