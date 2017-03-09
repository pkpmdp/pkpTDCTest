/**
* This class is a Data Object, extending the IWLSlideshowDO class and adding a public list of 
* instances of IWLListviewWidgetFeedDO containing information about the 
* feed associated with the item represented by the instance. 
*/
public with sharing class IWLListviewWidgetDO extends IWLSlideshowWidgetDO {

	public list<IWLListviewWidgetFeedDO> feedItems {get; set;} 
	
	public Integer feedItemsCount { 
		get {
			return (feedItems != null) ? feedItems.size() : 0;
		}
	}
	
	public Boolean canVote { get; set; }
	
	public class IWLListviewWidgetFeedDO {
		
		public IWLWidgetDOAttribute recordId {get; set;}
		
		public IWLWidgetDOAttribute content {get; set;}
		
		public IWLWidgetDOAttribute likes {get; set;}
		
		public IWLWidgetDOAttribute creationDate {get; set;}
		
		public IWLWidgetDOAttribute authorId {get; set;}
		
		public IWLWidgetDOAttribute authorName {get; set;}
		
		public IWLWidgetDOAttribute authorImage {get; set;}		

	}

	public list<IWLListviewWidgetMergedIdeasDO> mergedIdeas {get; set;} 
	
	public class IWLListviewWidgetMergedIdeasDO {
		
		public String Id {get; set;}
		
		public String Title {get; set;}
		
		public String authorId {get; set;}
		
		public String authorName {get; set;}
		
		public String authorImage {get; set;}		
		
	}
}