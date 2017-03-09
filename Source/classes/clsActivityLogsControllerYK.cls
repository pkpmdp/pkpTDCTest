public with sharing class clsActivityLogsControllerYK {

    public Boolean viewLogs {get; set;}
    public Boolean createLog {get; set;}
    public ActivityLog newActivityLog {get; set;}
    
    private User user;
    private Account account;
    private List<ActivityLog> existingActivityLogs;
    private List<AccountHistory> personAccountHistory;
    private String existingActivityLogsXmlResponse;
    
    public clsActivityLogsControllerYK(ApexPages.StandardController controller) {
        this.user = [Select MID__c From User Where Id = : UserInfo.getUserId()];
        this.account = (Account) controller.getRecord();
        viewLogs = true;
        createLog = false;
    }

    public void sendToCasper() {
        // Casper button calls this method
        if (account != null) {
            clsCasperButton.sendToCasper(account.Id);
        }
    }

    public List<AccountHistory> getPersonAccountHistory() {
        if (this.personAccountHistory == null && account != null) {
            personAccountHistory = [SELECT AccountId,CreatedDate,CreatedById,Field,NewValue,OldValue FROM AccountHistory WHERE AccountId = :account.Id ORDER BY CreatedDate DESC];
        }           
        return this.personAccountHistory;
    }
    
    public List<ActivityLog> getExistingActivityLogs() {
        if (this.existingActivityLogs == null) {
            existingActivityLogs = new List<ActivityLog>();
            if (this.account.Customer_No__c != null) {
                existingActivityLogsXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.EXISTING_ACTIVITY_LOGS_METHOD, this.account.Customer_No__c);
                //String existingActivityLogsXmlResponse = '<getCustomerInquiriesResponse xmlns="http://interfaces.customer.api.kasia.ktv.tdc.com"><out><customerInquiries xmlns="http://messages.customer.api.kasia.ktv.tdc.com"><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>PERSONLIGT</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>KNV</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></insertedDate><insertedFunc>mkKELog</insertedFunc><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></logDate><modifiedBy>KNV</modifiedBy><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></modifiedDate><modifiedFunc>mkKELog</modifiedFunc><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>1</sequenceNumber><subjectType>0</subjectType><subjectTypeDesc>Supplerende tekst</subjectTypeDesc><text>000001090</text><user>KNV</user><xalSO>false</xalSO></CustomerInquirySO><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>TELEFONISK</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>M20996</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">3</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">7</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2008</year></insertedDate><insertedFunc>updateKundeemne</insertedFunc><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">3</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">7</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2008</year></logDate><modifiedBy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate/><modifiedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>1</sequenceNumber><subjectType>0</subjectType><subjectTypeDesc>Supplerende tekst</subjectTypeDesc><text>betaler er 612027831pj cce</text><user>M20996</user><xalSO>false</xalSO></CustomerInquirySO><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>3</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>mcast</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">30</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">9</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2009</year></insertedDate><insertedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">30</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">9</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2009</year></logDate><modifiedBy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate/><modifiedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>3</sequenceNumber><subjectType>1</subjectType><subjectTypeDesc>Programønske</subjectTypeDesc><text>600000783</text><user>mcast</user><xalSO>false</xalSO></CustomerInquirySO></customerInquiries></out></getCustomerInquiriesResponse>';
                this.existingActivityLogs = parseActivityLogs(existingActivityLogsXmlResponse);
            }            
        }           
        return this.existingActivityLogs;   
    }
    
    private String callout(String endpoint, String body) {
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-type', 'text/html; charset=utf-8');    
        req.setBody((body == null ? '' : body));   
        System.debug ('Callout Body : ' + body);     
        HttpResponse res;
         try {
            res = http.send(req);
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
    
    private List<ActivityLog> parseActivityLogs(String XmlResponse) {       
        List<ActivityLog> logs = new List<ActivityLog>() ;
        if (XmlResponse == null) return logs;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'CustomerInquirySO') {
                        ActivityLog log = parseLog(reader);
                        logs.add(log);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing activity logs: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return logs;
        }
        return logs;
    }
    
    private ActivityLog parseLog(XmlStreamReader reader) {
        ActivityLog log= new ActivityLog();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'CustomerInquirySO') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'user') {
                        reader.next();
                        log.setUser(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'text') {
                        reader.next();
                        //log.setTextAccount(EncodingUtil.urlDecode(checkEmptyElement(reader), 'ISO-8859-1'));
                        log.setTextAccount(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'logDate') {
                        log.setLogDateAccount(getLogDate(reader));
                    } else if (reader.getLocalName() == 'contactType') {
                        reader.next();
                        log.setContactType(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'subjectTypeDesc') {
                        reader.next();
                        log.setSubjectTypeDescription(checkEmptyElement(reader));
                    }             
                }  
            }
            reader.next();
        }
        return log;
    }
    
    private Date getLogDate(XmlStreamReader reader) {
        Integer day, month, year;
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'logDate') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'dayOfMonth') {
                        reader.next();
                        day = Integer.valueOf(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'monthOfYear') {
                        reader.next();
                        month = Integer.valueOf(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'year') {
                        reader.next();
                        year = Integer.valueOf(checkEmptyElement(reader));
                    }
                }
            }
            reader.next();
        }
        return Date.newInstance(year, month, day);  
    }
    
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
    
    public PageReference createLog() {
        viewLogs = false;
        createLog = true;
        newActivityLog = new ActivityLog();
        return null;    
    }
    
    public PageReference viewLogs() {
        viewLogs = true;
        createLog = false;
        return null;    
    }
    
    public PageReference saveLog() {
        
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'customerInquiry', null);
        writeStartAndEndElements(w, 'customerId', (String) this.account.Customer_No__c);
        writeStartAndEndElements(w, 'contactType', newActivityLog.contactType);
        writeStartAndEndElements(w, 'subjectType', newActivityLog.subjectType);
        writeStartAndEndElements(w, 'subjectTypeDesc', newActivityLog.subjectTypeDescription);
        //writeStartAndEndElements(w, 'text', EncodingUtil.urlEncode(newActivityLog.textField, 'ISO-8859-1'));
        writeStartAndEndElements(w, 'text', newActivityLog.textField);
        writeStartAndEndElements(w, 'dataset', 'KTV');
        writeStartAndEndElements(w, 'sequenceNumber', '1');
        writeStartAndEndElements(w, 'userId', this.user.MID__c);            
        w.writeEndElement(); 
        w.writeEndDocument();
        String newActivityLogXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.ADD_ACTIVITY_LOG_METHOD, w.getXmlString());
        this.existingActivityLogs = null;
        viewLogs = true;
        createLog = false;
        return null;
    }
    
    private void writeStartAndEndElements(XMLStreamWriter w, String name, String value) {
        w.writeStartElement(null, name, null);
        w.writeCharacters((value == null ? '': value));
        w.writeEndElement();
    }
    
    public class ActivityLog {
        
        private Account logDateaccount;
        private Account textAccount;
        private String textField;
        private String user;
        private String contactType;
        private String subjectType;
        private String subjectTypeDescription;
        
        public ActivityLog() {}
        
        public Account getLogDateaccount() {
            return logDateaccount;
        }
        
        public void setLogDateaccount(Date dt) {
            logDateaccount = new Account(Permission_Updated__c=dt);
            
        }
        
        public Account getTextAccount() {
            return textAccount;
        }
        
        public void setTextAccount(String text) {
            textAccount = new Account(Serial_Numbers__c=text);
        }
        
        public String getTextField() {
            return textField;
        }
        
        public void setTextField(String s) {
            textField = s;
        }
        
        public String getUser() {
            return user;
        }
        
        public void setUser(String s) {
            user = s;
        }
                
        public String getContactType() {
            return contactType ;
        }
        
        public void setContactType(String s) {
            contactType = s;
        }
        
        public String getSubjectType() {
            return subjectType ;
        }
        
        public void setSubjectType(String s) {
            subjectType = s;
        }
        
        public String getSubjectTypeDescription() {
            return subjectTypeDescription;
        }
        
        public void setSubjectTypeDescription(String s) {
            subjectTypeDescription = s;
        }
        
    }    

    static testMethod void testDisplayCustomer() {
		
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
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Customer_No__c = '';
        insert acc;
        
        // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsActivityLogsControllerYK controller = new clsActivityLogsControllerYK(sc);
        controller.existingActivityLogsXmlResponse = '<getCustomerInquiriesResponse xmlns="http://interfaces.customer.api.kasia.ktv.tdc.com"><out><customerInquiries xmlns="http://messages.customer.api.kasia.ktv.tdc.com"><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>PERSONLIGT</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>KNV</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></insertedDate><insertedFunc>mkKELog</insertedFunc><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></logDate><modifiedBy>KNV</modifiedBy><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">23</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">3</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">1999</year></modifiedDate><modifiedFunc>mkKELog</modifiedFunc><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>1</sequenceNumber><subjectType>0</subjectType><subjectTypeDesc>Supplerende tekst</subjectTypeDesc><text>000001090</text><user>KNV</user><xalSO>false</xalSO></CustomerInquirySO><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>TELEFONISK</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>M20996</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">3</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">7</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2008</year></insertedDate><insertedFunc>updateKundeemne</insertedFunc><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">3</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">7</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2008</year></logDate><modifiedBy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate/><modifiedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>1</sequenceNumber><subjectType>0</subjectType><subjectTypeDesc>Supplerende tekst</subjectTypeDesc><text>betaler er 612027831pj cce</text><user>M20996</user><xalSO>false</xalSO></CustomerInquirySO><CustomerInquirySO xmlns="http://sos.customer.api.kasia.ktv.tdc.com"><contactType>3</contactType><customerId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><dataset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedBy>mcast</insertedBy><insertedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">30</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">9</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2009</year></insertedDate><insertedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><insertedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><lastModifiedDate/><loebenr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><logDate><dayOfMonth xmlns="http://types.util.kasia.ktv.tdc.com">30</dayOfMonth><monthOfYear xmlns="http://types.util.kasia.ktv.tdc.com">9</monthOfYear><year xmlns="http://types.util.kasia.ktv.tdc.com">2009</year></logDate><modifiedBy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedBySystem xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedDate/><modifiedFunc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><modifiedTime xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/><partyId>0002929447</partyId><sequenceNumber>3</sequenceNumber><subjectType>1</subjectType><subjectTypeDesc>Programønske</subjectTypeDesc><text>600000783</text><user>mcast</user><xalSO>false</xalSO></CustomerInquirySO></customerInquiries></out></getCustomerInquiriesResponse>';
        controller.existingActivityLogs = controller.parseActivityLogs(controller.existingActivityLogsXmlResponse);
        System.assertEquals(3, controller.getExistingActivityLogs().size());
        controller.getPersonAccountHistory();
        
        // Create a new log
        PageReference p = controller.createLog();
        System.assertEquals(null, p);
        controller.newActivityLog.setTextField('Test');
        controller.newActivityLog.setContactType('E-mail');
        controller.newActivityLog.setSubjectType('Selector');
        controller.newActivityLog.setUser('M001');
        p = controller.saveLog();
        System.assertEquals(null, p);
        
        // View existing logs
        p = controller.viewLogs();
        System.assertEquals(true, controller.viewLogs);
        System.assertEquals(false, controller.createLog);
    }
}