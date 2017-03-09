global class clsFbUrlShortener {

    public static final String SHORTENER_END_POINT = 'http://api.bit.ly/v3/shorten';
    private static final String SHORTENER_USER_NAME = ((sf4twitter__Twitter_Public_Configuration__c.getOrgDefaults()!=null)?
                                                        sf4twitter__Twitter_Public_Configuration__c.getOrgDefaults().sf4twitter__Bitly_Username__c:'');
    private static final String SHORTENER_API_KEY = ((sf4twitter__Twitter_Public_Configuration__c.getOrgDefaults()!=null)?
                                                      sf4twitter__Twitter_Public_Configuration__c.getOrgDefaults().sf4twitter__Bitly_Key__c:'');
    private static final String FORM_URL_PREFIX = ((URL_Prefix__c.getOrgDefaults()!=null)?URL_Prefix__c.getOrgDefaults().External__c:'')
                                                  + '/fbsupport/FbContact?state=';

    webService static void getShortUrl(Id conId) {
        System.debug('### Remote invocation of con: ' + conId);
        sf4twitter__Twitter_Conversation__c con = [ SELECT Id, FbFormShortUrl__c, sf4twitter__Parent__c FROM sf4twitter__Twitter_Conversation__c
                                                    WHERE Id = : conId ];

        // Check if this is a parent conversation. If not, get the parrent. 
        if (con.sf4twitter__Parent__c != null) {
            con = [ SELECT Id, FbFormShortUrl__c FROM sf4twitter__Twitter_Conversation__c
                    WHERE Id = : con.sf4twitter__Parent__c ];
        }
        
        // Ask for short url only if FbFormShortUrl is empty
        if (con.FbFormShortUrl__c == null || con.FbFormShortUrl__c == '')
            con.FbFormShortUrl__c = getshortUrl(FORM_URL_PREFIX + con.Id);

        update con;
    }

    public static String getShortUrl(String longUrl) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        // set the request method
        req.setMethod('GET');
        
        String url = SHORTENER_END_POINT +
                     '?login=' + SHORTENER_USER_NAME +
                     '&apiKey=' + SHORTENER_API_KEY +
                     '&longUrl=' + EncodingUtil.urlEncode(longUrl,'UTF-8');
        
        System.debug('### Url: ' + url);
        
        // add the endpoint to the request
        req.setEndpoint(url);
 
        // create the response object
        HTTPResponse res = http.send(req);
        
        if (res != null && res.getStatusCode() == 200) {        
            System.debug('### Response: ' + res.getBody());
            
            String response = res.getBody();
            String shortUrl = parseUrl(response);
            System.debug('### ShortUrl: ' + shortUrl);
            
            return shortUrl;
            
        } else {
            System.debug('### Response Error: ' + res.getBody());
            return null;
        }
    }

    private static String parseUrl(String response) {
        JSONParser parser = JSON.createParser(response);
        //system.debug('### reader: ' + response);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'url')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                return parser.gettext();
            }
        }
        
        return null;
    }
    
    @isTest
    public static void testGetShortUrl() {
        sf4twitter__Twitter_Conversation__c parentCon = new sf4twitter__Twitter_Conversation__c(sf4twitter__TwitterID__c='FB_123456');
        insert parentCon;
        sf4twitter__Twitter_Conversation__c con = new sf4twitter__Twitter_Conversation__c(sf4twitter__TwitterID__c='FB_654321');
        con.sf4twitter__Parent__c = parentCon.Id;
        insert con;
        
        Test.setMock(HttpCalloutMock.class, new clsFbUrlShortenerMockHttpResponse());
        Test.startTest();
        
        getShortUrl(con.Id);
        
        Test.stopTest();
    }
}