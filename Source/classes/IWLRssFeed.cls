global with sharing class IWLRssFeed {
		
	public String IdCommunity 			{get; set;}
	public DateTime FeedDate	 		{get; set;}
	
	private Integer NumItems 			{get; set;}
	private Integer NumComments			{get; set;}
	private String Name					{get; set;}
	
    public class feetItem {
        public String Id			{get;set;}
        public String Title			{get;set;}
        public String Summary		{get;set;}
        public DateTime Updated		{get;set;}
        public String Link			{get;set;}
        public String LinkComments	{get;set;}
        public Integer NumComments	{get;set;}
        public String AuthorName	{get;set;}
    }
    	
	public IWLRssFeed(){
		
		Map<String, String> params = ApexPages.currentPage().getParameters();

		IdCommunity = ( ( params.get('c') == null )? '' : params.get('c') );
		NumItems = ( ( params.get('ni') == null )? 10 : Integer.valueOf( ApexPages.currentPage().getParameters().get('ni') ) );
		NumComments = ( ( params.get('nc') == null )? 10 : Integer.valueOf( ApexPages.currentPage().getParameters().get('nc') ) );
		Name = ( ( params.get('name') == null )? 'Idea' : params.get('name') );
		
		FeedDate = Datetime.now();
	}

    public List<feetItem> getFeedItems(){
    	List<feetItem> items = new List<feetItem>();
		String idc = String.escapeSingleQuotes( IdCommunity );
		String query = '';
		String communityFilter = (idc != null && idc != '') ? 'where CommunityId = \'' + String.escapeSingleQuotes(idc) +'\'' : '';
		if( Name == 'Idea' && SecurityManager.isAccessible(Idea.sObjectType)){ 
			 
			query = 'SELECT Title, Body, LastModifiedDate, LastCommentDate, CreatedBy.Name, NumComments ' + 
								'From Idea ' + communityFilter +  						
								' limit ' + String.escapeSingleQuotes(String.valueOf(NumItems));
			 
		} else if (Name == 'IdeaTheme' && IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			 
			query = 'SELECT Title, Description, LastModifiedDate, CreatedBy.Name ' + 
								'From IdeaTheme ' + communityFilter +  						
								' limit ' + String.escapeSingleQuotes(String.valueOf(NumItems));
		} else {
			return items;//either idea themes are not enabled, or the object type specified is not correct.
		}
		
		for( SObject i : Database.query(query) ){
			feetItem x = new feetItem();
					
			x.Id = String.valueOf( i.get('Id') );
			x.Title = String.valueOf( i.get('Title') );
			x.Summary = (Name == 'Idea') ? String.valueOf( i.get('Body') ) : String.valueOf(i.get('Description'));
			x.Updated = Datetime.valueOf( i.get('LastModifiedDate') );
			x.Link	 = ApexPages.currentPage().getHeaders().get('Host')+ '?id=' + x.Id;
			x.LinkComments = ApexPages.currentPage().getHeaders().get('Host')+ '?id=' + x.Id;
			x.NumComments = (Name == 'Idea') ? Integer.valueOf(  i.get('NumComments') ) : 0;
			x.AuthorName = String.valueOf( i.getSObject('CreatedBy').get('Name') );
			
			items.add( x );
		}
    	
		return items; 
    }
    
    @isTest
    static void testIWLRssFeed() {
    	Test.startTest();
    	//create an idea for the feed.
    	Community com = IWLTestUtilities.getCommunity();
		Idea newIdea = IWLTestUtilities.createIdea('Title', 'Body', com.Id);
    	Pagereference curPage = ApexPages.currentPage();
    	curPage.getParameters().put('c', com.Id);
    	IWLRssFeed controller = new IWLRssFeed();
    	
    	List<feetItem> items = controller.getFeedItems();
		System.assert(items.size() > 0);
	
		//create an idea theme for the feed, if enabled.
		sObject theme = IWLTestUtilities.createIdeaTheme('Title', 'Description', 'Status', com.Id);
		curPage.getParameters().put('name', 'IdeaTheme');
		controller = new IWLRssFeed();
		items = controller.getFeedItems();
		if (IWLIdeaThemeDAO.IsIdeaThemeEnabled) {
			System.assert(items.size() > 0);
		} else {
			System.assert(items.size() == 0);
		}
    	
    	Test.stopTest();
    	
    }
}