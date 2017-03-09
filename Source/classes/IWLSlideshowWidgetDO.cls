/**
* This class is a Data Object that provides attributes with the necessary information to serve as the items 
* that will be renedered in the Slideshow widget,
* and are instantiated by the IWLSlideshowWidgetModel class in order to be used by the IWLSlideshowWidgetView
*/
public virtual with sharing class IWLSlideshowWidgetDO {
	public IWLWidgetDOAttribute recordId {get; set;}
	
	public IWLWidgetDOAttribute title {get; set;}
	
	public IWLWidgetDOAttribute content {get; set;}
	
	public IWLWidgetDOAttribute link {get; set;}
	
	public IWLWidgetDOAttribute feedSize {get; set;}
	
	public IWLWidgetDOAttribute likes {get; set;}
	
	public IWLWidgetDOAttribute dislikes {get; set;}
	
	public IWLWidgetDOAttribute activityDate {get; set;}
	
	public IWLWidgetDOAttribute status {get; set;}
	
	public IWLWidgetDOAttribute rating {get; set;}
	
	public IWLWidgetDOAttribute imageURL {get; set;}
	
	public Integer index {get; set;}
	
	public IWLWidgetDOAttribute authorName {get; set;}
	
	public IWLWidgetDOAttribute authorId {get; set;}
	
	public IWLWidgetDOAttribute authorImage {get; set;}	
	
	public IWLWidgetDOAttribute relatedTopics {get; set;}	
	
	
	public transient Schema.Describesobjectresult objectType {get; set;}
	
	public String moreLink {get; set;}
	
	public String detailPageUrl {get; set;}
	
	public String authorDetailPageUrl {get; set;}
	
	public String parentDetailPageUrl {get; set;}
	
	public IWLSlideshowWidgetDO() {
		
		additionalAttributesMap = new Map<String, IWLWidgetDOAttribute>();
		
		relatedTopics = new IWLWidgetDOAttribute();
		relatedTopics.valuesList = new List<String>();
	} 
	
	public Boolean hasRelatedTopics {
		get {
			return (relatedTopics != null && relatedTopics.valuesList != null && relatedTopics.valuesList.size() > 0);
		}
	}
	
	public Map<String, IWLWidgetDOAttribute> additionalAttributesMap {get; set;}
	
	public List<IWLWidgetDOAttribute> additionalAttributes {
		get {
			return additionalAttributesMap.values();
		}
	}
	
	/**
	* This class contains all the necessary information for a leaf attribute in 
	* any DisplayObject extending from IWLSlideshowWidgetDO
	*/
	public class IWLWidgetDOAttribute {
		public String fieldDevName {get; set;}
		public String fieldLabel {get; set;}
		public String value {get; set;}
		public List<String> valuesList {get; set;}
		
		public IWLWidgetDOAttribute() {
			
		}
		
		public IWLWidgetDOAttribute(String developerName, String label, String value, List<String> valuesList) {
			this.fieldDevName = developerName;
			this.fieldLabel = label;
			this.value = value;
			this.valuesList = valuesList;
		}
		
		public Boolean isList {
			get {
				return valuesList != null;
			}
		}
	}
	
}