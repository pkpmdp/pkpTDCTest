public with sharing class IWLRSSDAO {

	public static final String TEST_XML_RESPONSE = '<feed xmlns="http://www.w3.org/2005/Atom" xml:base="http://xahlee.org/Periodic_dosage_dir/"><item><title>Earth Invaded</title><link>http://news.example.com/2004/12/17/invasion</link><description>The earth was attacked by an invasion fleet from halfway across the galaxy; luckily, a fatal miscalculation of scale resulted in the entire armada being eaten by a small dog.</description><author>You</author><pubDate>2012-09-13 00:00:00</pubDate></item><entry><title>Earth Invaded</title><link>http://news.example.com/2004/12/17/invasion</link><description>The earth was attacked by an invasion fleet from halfway across the galaxy; luckily, a fatal miscalculation of scale resulted in the entire armada being eaten by a small dog.</description><name>You</name><updated>2012-09-13 00:00:00</updated></entry></feed>';
	public static Boolean isTest = false;

	/**
	* Get Feed Content
	* @param String url		Url source
	* @return List<IWLListviewWidgetDO>	RSS Feed List
	*/
    public static List<IWLListviewWidgetDO> getRecords( IWLWidget__c widgetRecord ){
		List<IWLListviewWidgetDO> listRSSFeed = new List<IWLListviewWidgetDO>();

		Http protocol = new HTTP();
 		HttpRequest req = new HttpRequest();
        req.setTimeout( 60000 );            
        req.setEndpoint( widgetRecord.URL_Feed__c );
        req.setMethod( 'GET' );
        req.setHeader('Content-Length', '0');
        String xml = '';
        if (!isTest) {
        	xml = protocol.send( req ).getBody();
        } else {
        	xml = TEST_XML_RESPONSE;
        }
		if( xml != null && xml != '' ){
			
			XmlStreamReader reader = new XmlStreamReader(xml);
		    Integer i = 0;
			while(reader.hasNext()) {
	
		        if (reader.getEventType() == XmlTag.END_ELEMENT) {
	
		        }else if (reader.getEventType() == XmlTag.START_ELEMENT) {
					// ATOM
		           	if( reader.getLocalName() == 'entry' ){
				        
				        if( i == widgetRecord.listSize__c ) break;
		           		reader.next();
		           		IWLListviewWidgetDO f = new IWLListviewWidgetDO();

		           		while(reader.hasNext()) {
		           			
		           			if (reader.getEventType() == XmlTag.END_ELEMENT) {
								if( reader.getLocalName() == 'entry' ) break;
		           			}else if (reader.getEventType() == XmlTag.START_ELEMENT) {
		           				
		           				if( reader.getLocalName() == 'title' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('title', 'title', reader.getText(), null);
		           					}
				           			i++;
		           				}else if( reader.getLocalName() == 'link' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.link = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('link', 'link', reader.getText(), null);
		           					}
		           				}else if( reader.getLocalName() == 'name' ){
		           					
		           					if (reader.getEventType() == XmlTag.START_ELEMENT) {
		           						reader.next();
		           						f.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('name', 'name', reader.getText(), null);
		           					}
		           				}else if( reader.getLocalName() == 'updated' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('updated', 'updated', reader.getText(), null);
		           					}
		           				}
		           			}
		           			reader.next();
		           		}
		           		listRSSFeed.add(f);
		           	
		           	// FEED
		           }else if( reader.getLocalName() == 'item' ){
		           		if( i == widgetRecord.listSize__c ) break;
		           		reader.next();
		           		IWLListviewWidgetDO f = new IWLListviewWidgetDO();
		           		
		           		while(reader.hasNext()) {
		           			
		           			if (reader.getEventType() == XmlTag.END_ELEMENT) {
								if( reader.getLocalName() == 'item' ) break;
		           			}else if (reader.getEventType() == XmlTag.START_ELEMENT) {
		           				if( reader.getLocalName() == 'title' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.title = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('title', 'title', reader.getText(), null);
		           					}
					       			i++;
		           				}else if( reader.getLocalName() == 'link' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.link = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('link', 'link', reader.getText(), null);
		           					}
		           				}else if( reader.getLocalName() == 'description' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.content = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('description', 'description', reader.getText(), null);
		           					}
		           				}else if( reader.getLocalName() == 'author' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.authorName = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('author', 'author', reader.getText(), null);
		           					}
		           				}else if( reader.getLocalName() == 'pubDate' ){
		           					reader.next();
		           					if (reader.getEventType() == XmlTag.CHARACTERS) {
		           						f.activityDate = new IWLSlideshowWidgetDO.IWLWidgetDOAttribute('pubDate', 'pubDate', reader.getText(), null);
		           					}
		           				}
		           			}
		           			reader.next();
		           		}
		           		listRSSFeed.add(f);
		           }
		        }
		        reader.next();
			}
		}
		return listRSSFeed;
	}
	
	@isTest
	private static void testIWLRSSDAO() {
		
		Test.startTest();
		
		IWLRSSDAO.isTest = true;
		IWLWidget__c widget = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		widget.URL_Feed__c = 'http://www.google.com';
		List<IWLListviewWidgetDO> visualData = IWLRSSDAO.getRecords(widget);
		
		system.assert(visualData.size() > 0);
		
		Test.stopTest();
		
	}
}