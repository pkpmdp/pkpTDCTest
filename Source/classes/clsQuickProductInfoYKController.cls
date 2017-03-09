public class clsQuickProductInfoYKController {
/*
    private Address__c addr;
    private String responseError;
    private String responseString;
    private String xmlResponse;
    private Date aDate;

    public clsQuickProductInfoYKController(ApexPages.StandardController stdController) {
        addr = (Address__c) stdController.getRecord();
        responseError = null;
        xmlResponse = null;
        aDate = null;
        responseString = getResponseString();
    }

    public String getResponseString() {
        if (xmlResponse == null) {
            responseString = null;
            // No callout has been made yet
            if (addr.Id != null) {
                Address__c[] dbAddrs = [SELECT External_Id__c FROM Address__c WHERE Id = :addr.Id];
                if (dbAddrs.size() == 1) {
                    xmlResponse = callout(
                        clsConnectionUtils.END_POINT + clsConnectionUtils.QUICK_PRODUCT_INFO_METHOD,
                        dbAddrs[0].External_Id__c
                    );
                }
            }
        }
        Boolean isResponse = (responseError == null) && (xmlResponse != null);
        if (isResponse) {
            // a good esponse should contain at least one row
            isResponse = hasRows();
        }
        responseString = (isResponse) ?
            System.Label.Quick_Product_Info_Activity // some info from Casper
            : System.Label.Quick_Product_Info_Empty  // no info from Casper
        ;
        return responseString;
    }

    public Date getDatePrinted() {
        if (aDate == null && xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'DATOUDSKREVETARBORDRE') {
                            reader.next();
                            if (reader.getEventType() != XmlTag.END_ELEMENT) {
                                // there is a value - try to convert into a date
                                aDate = Date.valueOf(reader.getText().trim());
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
        return aDate;
    }

    public String getResponseError() {
        return responseError;
    }

    private Boolean hasRows() {
        Boolean hasRows = false;
        if (xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'row') {
                            hasRows = true;
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
        return hasRows;
    }

    private String callout(String endpoint, String body) {
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
            responseError = 'Error: No response';
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response
                String response = res.getBody();
                System.debug('Good response: ' + response);
                return response;
            }
            else {
                responseError = 'Error: ' + res.getStatusCode();
            }
        }
        return null;
    }

    static testMethod void testQuickProductInfo() {
        // Instantiate an Address record
        Address__c addr = new Address__c();
        insert addr;

        // Instantiate and construct the controller class
        clsQuickProductInfoYKController ctrl =
            new clsQuickProductInfoYKController(new ApexPages.standardController(addr))
        ;
        if (ctrl.getResponseString() == null) {
            // A response error or no response
            System.assertEquals(null, ctrl.getDatePrinted());
        }

        ctrl = new clsQuickProductInfoYKController(new ApexPages.standardController(addr));
        // An OrderPrintedDate date present in the response
        ctrl.responseError = null;
        ctrl.xmlResponse = '<rows>\n' +
            '   <row>\n' +
            '      <ADRESSE_ID>0003745134</ADRESSE_ID>\n' +
            '      <AKTIVITET>   2113665</AKTIVITET>\n' +
            '      <DATOUDSKREVETARBORDRE>2008-07-01T00:00:00.000</DATOUDSKREVETARBORDRE>\n' +
            '      <BIERREVSPOR>0</BIERREVSPOR>\n' +
            '      <BIERREVDATO>2008-07-01T00:00:00.000</BIERREVDATO>\n' +
            '      <AKTIV>4</AKTIV>\n' +
            '      <OPHXRS_XRSAG>2</OPHXRS_XRSAG>\n' +
            '   </row>\n' +
            '</rows>'
        ;
        System.assert(ctrl.hasRows());
        System.assertNotEquals(null, ctrl.getDatePrinted());

        ctrl = new clsQuickProductInfoYKController(new ApexPages.standardController(addr));
        // No OrderPrintedDate date present in the response
        ctrl.responseError = null;
        ctrl.xmlResponse = '<rows>\n' +
            '   <row>\n' +
            '      <ADRESSE_ID>0003745134</ADRESSE_ID>\n' +
            '      <AKTIVITET>   2113665</AKTIVITET>\n' +
            '      <DATOUDSKREVETARBORDRE/>\n' +
            '      <BIERREVSPOR>0</BIERREVSPOR>\n' +
            '      <BIERREVDATO/>\n' +
            '      <AKTIV>4</AKTIV>\n' +
            '      <OPHXRS_XRSAG>2</OPHXRS_XRSAG>\n' +
            '   </row>\n' +
            '</rows>'
        ;
        System.assert(ctrl.hasRows());
        System.assertEquals(null, ctrl.getDatePrinted());
        System.assertEquals(System.label.Quick_Product_Info_Activity, ctrl.getResponseString());

        ctrl = new clsQuickProductInfoYKController(new ApexPages.standardController(addr));
        // An empty response
        ctrl.responseError = null;
        ctrl.xmlResponse = '<rows/>';
        System.assert(!ctrl.hasRows());
        System.assertEquals(null, ctrl.getDatePrinted());
        System.assertEquals(System.label.Quick_Product_Info_Empty, ctrl.getResponseString());
    }
    */
}