public with sharing class clsConsoleSendTabController{
   //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private Account account;
    private CampaignHistoryItem[] campaignHistory;
    private String campaignHistoryXmlResponse;
    
    public clsConsoleSendTabController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
    }

    public PageReference pageAction(){
        if (this.account != null) {
           getCampaignHistory(); 
        }
        return null;
    }
    
    public PageReference infoRequestAction(){
        if (this.account != null) {
          PageReference pageRef = new PageReference('/apex/CustomerInformationRequestNew'); 
          pageRef.getParameters().put('CF00N20000001WwUW', this.account.Name);
          pageRef.getParameters().put('CF00N20000001WwUW_lkid', this.account.Id);
          pageRef.getParameters().put('00N20000001WwYp', this.account.PersonEmail);
          pageRef.getParameters().put('save_new', '1');
          pageRef.getParameters().put('sfdc.override', '1');
          //pageRef.getParameters().put('retURL', '/apex/ConsoleSendTab');
          return pageRef; 
        }
        return null;
    }
    
    public PageReference giftCodesAction(){
        if (this.account != null) {
          PageReference pageRef = new PageReference('/apex/GiftCodeSend'); 
          pageRef.getParameters().put('accid', this.account.Id);
          //pageRef.getParameters().put('retURL', '/apex/ConsoleSendTab');
          return pageRef;
        }
        return null;
    }
    
    // Method populates the campaign history bind variable in the account Visualforce page
    public List<CampaignHistoryItem> getCampaignHistory() {
        if (this.campaignHistory == null) {
            if (this.account != null) {
            	//EDM-637 START
            	calloutParameter.add('null');
            	calloutValue.add(this.account.Customer_No__c);
                calloutParameter.add('null');
                calloutValue.add(this.account.Street_YK__r.External_Id__c);
                campaignHistoryXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.NEW_CAMPAIGN_HISTORY_CUSTOMER, calloutParameter, calloutValue);
            	calloutParameter = new List<String>();
            	calloutValue = new List<String>();
                
            //EDM-637 END
            }                                    
            this.campaignHistory = parseCampaignHistory(campaignHistoryXmlResponse);
        }
        return this.campaignHistory;
    }
    
    private List<CampaignHistoryItem> parseCampaignHistory(String XmlResponse) {
        List<CampaignHistoryItem> campaignHistory = new List<CampaignHistoryItem>() ;
        if (XmlResponse == null || XmlResponse == '') return campaignHistory;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        //parser may return text in multiple blocks
        reader.setCoalescing(true); 
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Contacthistory') {
                        CampaignHistoryItem product = parseCampaignHistoryItem(reader);
                        campaignHistory.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing new campaign history: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return campaignHistory;
        }
        return campaignHistory;
    }

    private CampaignHistoryItem parseCampaignHistoryItem(XmlStreamReader reader) {
        String subject, category, type, sender, receiver, timeString, responseStatus, contentURL, infoText = null;
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'Contacthistory') {
                    break;
                }
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Emne') {
                        reader.next();
                        subject = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Kategory') {
                        reader.next();
                        category = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Type') {
                        reader.next();
                        type = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Afsender') {
                        reader.next();
                        sender = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Modtager') {
                        reader.next();
                        receiver = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Tidspunkt') {
                        reader.next();
                        timeString = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Status') {
                        reader.next();
                        responseStatus = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'ContentURL') {
                        reader.next();
                        contentURL = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'InfoTekst') {
                        reader.next();
                        infoText = checkEmptyElement(reader);
                    }
                }
            }
            reader.next();
        }
        return new CampaignHistoryItem(
            subject, category, type, sender, receiver, timeString, responseStatus, contentURL, infoText
        );
    }
    
    public class CampaignHistoryItem {
        public String subject {get; set;} //Emne
        public String category {get; set;} //Kategory
        public String type {get; set;} //Type
        public String sender {get; set;} //Afsender
        public String receiver {get; set;} //Modtager
        public String timeDate {get; set;} //Tidspunkt
        public String responseStatus {get; set;} //Status
        public String contentURL {get; set;} //ContentURL
        public String infoText {get; set;} //InfoTekst
        public String mouseOverText {get; set;} //InfoTekst || Emne

        CampaignHistoryItem (
            String subject, String category, String type, String sender,
            String receiver, String timeString, String responseStatus,
            String contentURL, String infoText
        ) {
            this.subject = subject;
            this.category = category;
            this.type = type;
            this.sender = sender;
            this.receiver = receiver;
            try {
                Date dt = Date.valueOf(timeString);
                this.timeDate = dt.format();
            } catch(Exception e) {
                this.timeDate = '';
            }
            this.responseStatus = responseStatus;
            this.contentURL = contentURL;
            this.infoText = infoText;
            this.mouseOverText = infoText == '' ? subject : infoText;
        }
    }
    
    /*private String callout(String endpoint, String body) {
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));
        req.setTimeout(15000);        
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('endpoint: ' + endpoint);
            System.debug('res: ' + res);            
            //ApexPages.Message resValue = new ApexPages.Message(ApexPages.Severity.INFO,'http response=' + res);
            //ApexPages.addMessage(resValue);
                    
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response 
                String response = res.getBody();
                System.debug('response' + response);
                return response;                
            }
        }
        return null;    
    }
    */
    
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {            
            return reader.getText();
        }       
    }   
    
    static testMethod void testDisplayCustomer() {
        INTEGRATION__c inte = new INTEGRATION__c();
        inte.Name = 'ContactHistoryInboundCustomer';
        inte.HttpMethod__c = 'GET';
        inte.IsBodyAppended__c = true;
        inte.Service__c = 'END_POINT_YOUPROD2';
        inte.Params__c = null;
        insert inte;
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc;
        
        String campaignHistoryXmlResponseStr = '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<Contacthistories xmlns="http://yousee.dk/sas/contacthistory">\n' +
                '<Contacthistory>\n' +
                    '<Emne>NKU 2012</Emne>\n' +
                    '<Kategory>NKU</Kategory>\n' +
                    '<Type>DM</Type>\n' +
                    '<Afsender>YouSee</Afsender>\n' +
                    '<Modtager>M1</Modtager>\n' +
                    '<Tidspunkt>2011-10-09T17:12:33.000</Tidspunkt>\n' +
                    '<Status>S1</Status>\n' +
                    '<ContentURL/>\n' +
                    '<InfoTekst>I1</InfoTekst>\n' +
                '</Contacthistory>\n' +
                '<Contacthistory>\n' +
                    '<Emne>Tv2 bliver i YouSees pakker</Emne>\n' +
                    '<Kategory>Generel Retention</Kategory>\n' +
                    '<Type>Email</Type>\n' +
                    '<Afsender>YouSee</Afsender>\n' +
                    '<Modtager/>\n' +
                    '<Tidspunkt>2011-09-08T13:32:42.000</Tidspunkt>\n' +
                    '<Status/>\n' +
                    '<ContentURL>http://ecm.yousee.dk</ContentURL>\n' +
                    '<InfoTekst/>\n' +
                '</Contacthistory>\n' +
            '</Contacthistories>';
            
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsConsoleSendTabController controller = new clsConsoleSendTabController(sc);
        controller.pageAction();   
        controller.getCampaignHistory();    
        controller.campaignHistoryXmlResponse = campaignHistoryXmlResponseStr;
        controller.campaignHistory = controller.parseCampaignHistory(controller.campaignHistoryXmlResponse);
        System.assertEquals(controller.campaignHistory.size(), 2);

        CampaignHistoryItem campaignHistory1 = controller.getCampaignHistory()[0];
        controller.infoRequestAction();
        controller.giftCodesAction();
        System.assertEquals('NKU 2012', campaignHistory1.subject);
        System.assertEquals('NKU', campaignHistory1.category);
        System.assertEquals('DM', campaignHistory1.type);
        System.assertEquals('YouSee', campaignHistory1.sender);
        System.assertEquals('M1', campaignHistory1.receiver);
        //System.assertEquals('09-10-2011', campaignHistory1.timeDate);
        System.assertEquals('S1', campaignHistory1.responseStatus);
        System.assertEquals('', campaignHistory1.contentURL);
        System.assertEquals('I1', campaignHistory1.infoText);
        System.assertEquals('I1', campaignHistory1.mouseOverText);

        CampaignHistoryItem campaignHistory2 = controller.getCampaignHistory()[1];
        System.assertEquals('Tv2 bliver i YouSees pakker', campaignHistory2.subject);
        System.assertEquals('Generel Retention', campaignHistory2.category);
        System.assertEquals('Email', campaignHistory2.type);
        System.assertEquals('YouSee', campaignHistory2.sender);
        System.assertEquals('', campaignHistory2.receiver);
        //System.assertEquals('08-09-2011', campaignHistory2.timeDate);
        System.assertEquals('', campaignHistory2.responseStatus);
        System.assertEquals('http://ecm.yousee.dk', campaignHistory2.contentURL);
        System.assertEquals('', campaignHistory2.infoText);
        System.assertEquals('Tv2 bliver i YouSees pakker', campaignHistory2.mouseOverText);
    }      
}