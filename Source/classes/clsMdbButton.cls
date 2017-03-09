global class clsMdbButton{
    
    //inner class
    private class MdbButtCallResponse{
        public String casperAddressId = '';
        public String networkNr = '';
    }

    public class ApplicationException extends Exception {
    } 
    
    public static final String ERROR_PREFIX='ERROR: ';
    
    webservice static String getMdbUrl(String amsId){
        String result='';
        try {
            String searchXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.MDB_BUTTON_METHOD, amsId);
            if(searchXmlResponse != null){
                MdbButtCallResponse response = parseResponse(searchXmlResponse);
                result = 'http://masterdatabasen.dk?side=anl_details.asp&anl='+response.networkNr +'&adr='+response.casperAddressId;
            }

        }
        catch(ApplicationException e){
            result = ERROR_PREFIX+clsConnectionUtils.MDB_BUTTON_METHOD +' '+e.getMessage();
        }
        
        return result;
    }
    
    
    public static String callout(String endpoint, String body) {
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));        
        System.debug('req body = ' + body);
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res = ' + res);
        } catch (Exception e) {
            String errorMsg='HTTP call exception: ' + e.getMessage();
            System.debug(errorMsg);
            throw new ApplicationException(errorMsg);
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                return res.getBody();  // Good response
            }
            else {
                throw new ApplicationException(res.getStatusCode()+' '+res.getStatus());
            }
        }
        return null;    
    }

    private static MdbButtCallResponse parseResponse(String XmlResponse) {     
        MdbButtCallResponse result = new MdbButtCallResponse();
        if (XmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(XmlResponse);
                 
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'row') {
                            result = parseResponseTag(reader);
                        }
                    }
                    reader.next();
                }
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
                ApexPages.addMessage(m);
            }
        }
        return result;
    }
    
    private static MdbButtCallResponse parseResponseTag(XmlStreamReader reader) {
        MdbButtCallResponse result = new MdbButtCallResponse();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {                
                    if (reader.getLocalName() == 'CASPER_ADDRESS_ID') {
                        reader.next();
                        result.casperAddressId = checkEmptyElement(reader);
                    } 
                    else if (reader.getLocalName() == 'NETWORK_NR') {
                        reader.next();
                        result.networkNr = checkEmptyElement(reader);
                    } 
                 }  
            }
            reader.next();
        }
        return result;
    }
    
    private static String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }
      
    static testMethod void testGetMdbUrl() {
        clsMdbButton.getMdbUrl('384868');
        
        String testXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows><row><CASPER_ADDRESS_ID>2046181</CASPER_ADDRESS_ID><NETWORK_NR>5030714</NETWORK_NR></row></rows>';
        MdbButtCallResponse response = parseResponse(testXmlResponse);
        System.assertEquals('5030714',response.networkNr);
        System.assertEquals('2046181',response.casperAddressId);
    }


}