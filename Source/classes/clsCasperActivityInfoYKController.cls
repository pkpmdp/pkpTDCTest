public class clsCasperActivityInfoYKController{
//EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private Address__c addr;
    private String xmlResponse;
    private String respError;
    private String respOpenS;
    private String respFreeV;
    private Date dateOpenS;
    private Datetime dateOasis;
    private String externalId;
    public Address__c[] dbAddrs = new Address__c[]{}; //OASIS-75
    public clsCasperActivityInfoYKController(ApexPages.StandardController stdController){
        addr = (Address__c) stdController.getRecord();
        dateOasis = null;
        externalId = null;
        if (addr.Id != null) {
            //OASIS-75
            dbAddrs = [SELECT Oasis_Date__c, External_Id__c FROM Address__c WHERE Id = :addr.Id];
            if (dbAddrs.size() == 1) {
                dateOasis  = dbAddrs[0].Oasis_Date__c;
                externalId = dbAddrs[0].External_Id__c;
            }
        }
        respError = null;
        //EDM-637 START
        calloutParameter.add('null');
        calloutValue.add(externalId);
        xmlResponse = clsConnectionUtils_admin.callout1(clsConnectionUtils_admin.QUICK_PRODUCT_INFO_METHOD, calloutParameter, calloutValue);
        //EDM-637 END
        dateOpenS = null;
        respOpenS = respFreeV = null;
        respOpenS = getRespOpenS();
        respFreeV = getRespFreeV(); 
        system.debug('****'+respFreeV);
    }
    public String getRespOpenS() {
        Boolean isResponse = (respError == null) && (xmlResponse != null);
        if (isResponse) {
            isResponse = false;
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'row') {
                            // a good response should contain at least one row
                            isResponse = true;
                            break;
                        }
                    }
                    reader.next();
                }
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error, 'An error occured parsing the XML response: ' + e.getMessage(), e.getMessage()
                );
                ApexPages.addMessage(m);
            }
        }
        return (isResponse) ?
            System.Label.CaspActivInfo_OpenS_Activity // some Open Signal info from Casper
            : System.Label.CaspActivInfo_OpenS_Empty;  // no Open Signal info from Casper
    }
	public Date getDateOpenS() {
        if (dateOpenS == null && xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'DATOUDSKREVETARBORDRE') {
                            reader.next();
                            if (reader.getEventType() != XmlTag.END_ELEMENT) {
                                // there is a value - try to convert into a date
                                dateOpenS = Date.valueOf(reader.getText().trim());
                            } 
                            break;
                        }
                    }
                    reader.next();
                }
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error, 'An error occured parsing the XML response: ' + e.getMessage(), e.getMessage()
                );
                ApexPages.addMessage(m);
            }
        }
        return dateOpenS;
    }
	public String getRespFreeV() {
        system.debug('xmlResponse '+xmlResponse);
        if (respFreeV == null && xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'SPOC24ACTIVITY') {
                            reader.next();
                            if (reader.getEventType() != XmlTag.END_ELEMENT) {
                                respFreeV = reader.getText();
                                System.debug('***-->'+respFreeV);
                            } 
                            break;
                        }
                    }
                    reader.next();
                }
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error, 'An error occured parsing the XML response: ' + e.getMessage(), e.getMessage()
                );
                ApexPages.addMessage(m);
            }
        }
        return respFreeV;
    }
	public Date getDateFreeV() {
        return dateOasis != null ? dateOasis.date() : null;
    }
	public Boolean getIsNewFreeV() {
        Date dateFreeV = getDateFreeV();
        if (dateFreeV != null) {
            return dateFreeV.daysBetween(Date.today()) <= 30;
        } else {
            // No date means older than 30 days
            return false;
        }
    }
	public String getRespError() {
        return respError;
    }
    /* public String callout(String endpoint, String body) {
        // Make the callout and check the response
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(15000);
        req.setBody((body == null ? '' : body));
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res: ' + res);
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(
                ApexPages.severity.Error, e.getMessage(), e.getMessage()
            );
            ApexPages.addMessage(m);
            respError = 'Error: No response';
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response
                String response = res.getBody();
                System.debug('Good response: ' + response);
                return response;
            }
            else {
                respError = 'Error: ' + res.getStatusCode();
            }
        }
        return null;
    }
    */
    static testMethod void testCasperActivityInfo() {
        INTEGRATION__c inte = new INTEGRATION__c();
        inte.Name = 'getSPOC21Activities';
        inte.HttpMethod__c = 'GET';
        inte.IsBodyAppended__c = true;
        inte.Service__c = 'END_POINT_YOUPROD2';
        inte.Params__c = null;
        insert inte;
        String freeViewerInfo = '1624637';
        // Instantiate Address records
        Address__c addr = new Address__c();
        insert addr;
        Address__c addr01 = new Address__c();
        addr01.Oasis_Date__c = Date.today().addDays(-1);
        insert addr01;
        Address__c addr31 = new Address__c();
        addr31.Oasis_Date__c = Date.today().addDays(-31);
        insert addr31;
	// Instantiate and construct the controller class
        clsCasperActivityInfoYKController ctrl =
            new clsCasperActivityInfoYKController(new ApexPages.standardController(addr));
        if (ctrl.getRespError() != null) {
            // A response error or no response & blank Oasis Date field
            System.assertEquals(System.Label.CaspActivInfo_OpenS_Empty, ctrl.getRespOpenS());
            System.assertEquals(null, ctrl.getDateOpenS());
            System.assertEquals(null, ctrl.getRespFreeV());
            System.assertEquals(null, ctrl.getDateFreeV());
        }
		ctrl = new clsCasperActivityInfoYKController(new ApexPages.standardController(addr01));
        // An empty response & yesterday's date in Oasis Date field
        ctrl.respError = null;
        ctrl.xmlResponse = '<rows/>';
        System.assertEquals(null, ctrl.getDateOpenS());
        System.assertEquals(System.label.CaspActivInfo_OpenS_Empty, ctrl.getRespOpenS());
        System.assertEquals(true, ctrl.getIsNewFreeV());
        System.assertEquals(null, ctrl.getRespFreeV());
		ctrl = new clsCasperActivityInfoYKController(new ApexPages.standardController(addr01));
        // An OrderPrintedDate date present in the response
        // A FreeViewerInfo present in the response & yesterday's date in Oasis Date field
        ctrl.respError = null;
        ctrl.xmlResponse = '<rows>\n' +
            '   <row>\n' +
            '      <ADRESSE_ID>0003745134</ADRESSE_ID>\n' +
            '      <AKTIVITET>   2113665</AKTIVITET>\n' +
            '      <DATOUDSKREVETARBORDRE>2008-07-01T00:00:00.000</DATOUDSKREVETARBORDRE>\n' +
            '      <BIERREVSPOR>0</BIERREVSPOR>\n' +
            '      <BIERREVDATO>2008-07-01T00:00:00.000</BIERREVDATO>\n' +
            '      <AKTIV>4</AKTIV>\n' +
            '      <OPHXRS_XRSAG>2</OPHXRS_XRSAG>\n' +
            '      <SPOC24ACTIVITY>' + freeViewerInfo + '</SPOC24ACTIVITY>\n' +
            '   </row>\n' +
            '</rows>'
        ;
        System.assertEquals(ctrl.getRespOpenS(), System.Label.CaspActivInfo_OpenS_Activity);
        System.assertNotEquals(null, ctrl.getDateOpenS());
        System.assertEquals(true, ctrl.getIsNewFreeV());
        System.assertEquals(freeViewerInfo, ctrl.getRespFreeV());

        ctrl = new clsCasperActivityInfoYKController(new ApexPages.standardController(addr));
        // No OrderPrintedDate date present in the response
        // No FreeViewerInfo present in the response & no date in Oasis Date field
        ctrl.respError = null;
        ctrl.xmlResponse = '<rows>\n' +
            '   <row>\n' +
            '      <ADRESSE_ID>0003745134</ADRESSE_ID>\n' +
            '      <AKTIVITET>   2113665</AKTIVITET>\n' +
            '      <DATOUDSKREVETARBORDRE/>\n' +
            '      <BIERREVSPOR>0</BIERREVSPOR>\n' +
            '      <BIERREVDATO/>\n' +
            '      <AKTIV>4</AKTIV>\n' +
            '      <OPHXRS_XRSAG>2</OPHXRS_XRSAG>\n' +
            '      <SPOC24ACTIVITY/>\n' +
            '   </row>\n' +
            '</rows>';
        System.assertEquals(ctrl.getRespOpenS(), System.Label.CaspActivInfo_OpenS_Activity);
        System.assertEquals(null, ctrl.getDateOpenS());
        System.assertEquals(System.label.CaspActivInfo_OpenS_Activity, ctrl.getRespOpenS());
        System.assertEquals(false, ctrl.getIsNewFreeV());
        System.assertEquals(null, ctrl.getRespFreeV());
		ctrl = new clsCasperActivityInfoYKController(new ApexPages.standardController(addr31));
        // No OrderPrintedDate date present in the response
        // A FreeViewerInfo present in the response & an old date in Oasis Date field
        ctrl.respError = null;
        ctrl.xmlResponse = '<rows>\n' +
            '   <row>\n' +
            '      <ADRESSE_ID>0003745134</ADRESSE_ID>\n' +
            '      <AKTIVITET>   2113665</AKTIVITET>\n' +
            '      <DATOUDSKREVETARBORDRE/>\n' +
            '      <BIERREVSPOR>0</BIERREVSPOR>\n' +
            '      <BIERREVDATO/>\n' +
            '      <AKTIV>4</AKTIV>\n' +
            '      <OPHXRS_XRSAG>2</OPHXRS_XRSAG>\n' +
            '      <SPOC24ACTIVITY>' + freeViewerInfo + '</SPOC24ACTIVITY>\n' +
            '   </row>\n' +
            '</rows>';
        System.assertEquals(ctrl.getRespOpenS(), System.Label.CaspActivInfo_OpenS_Activity);
        System.assertEquals(null, ctrl.getDateOpenS());
        System.assertEquals(System.label.CaspActivInfo_OpenS_Activity, ctrl.getRespOpenS());
        System.assertEquals(false, ctrl.getIsNewFreeV());
        System.assertEquals(freeViewerInfo, ctrl.getRespFreeV());
    }
}