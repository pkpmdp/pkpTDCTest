public with sharing class CableUnitNoteTableController {
    //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    CableUnitNoteItem[] cableUnitNotes;
    String cableUnitNotesXmlResponse;
    Cable_Unit__c cableUnit;
    
    public CableUnitNoteTableController(ApexPages.StandardController controller) {
        cableUnit = (Cable_Unit__c) controller.getRecord();
    } 
    
    public class CableUnitNoteItem implements Comparable{
        public String type {get; set;}
        public String user {get; set;}
        public String dateN {get; set;}
        public String note {get; set;}
        public Date dt{get{return Date.valueOf(dateN);}set;}       
        
        public Integer compareTo(Object compareTo) {
        CableUnitNoteItem  compareToNote = (CableUnitNoteItem)compareTo;
        if (dt == compareToNote.dt) return 0;
        if (dt > compareToNote.dt) return -1;
        return 1;        
    }
        
        public String Date1{get{
            try {
                 dt = Date.valueOf(dateN);
                return dt.format();
            } catch(Exception e) {
                return '';
            }
        }
        set;
        }
    }
     
    public List<CableUnitNoteItem> getCableUnitNotes() {       
        if (this.cableUnitNotes == null) {
        	//EDM-637 START
            String params = cableUnit.Cable_Unit_No__c;
            //params = '0005003320';
            calloutParameter.add('null');
            calloutValue.add(cableUnit.Cable_Unit_No__c);
           cableUnitNotesXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils.CABLEUNITNOTE_METHOD,calloutParameter,calloutValue);
             //EDM-637 END            
            this.cableUnitNotes=parseCableUnitNote(cableUnitNotesXmlResponse);
            this.cableUnitNotes.sort();
        }           
        return this.cableUnitNotes;                        
    }
     
    private List<CableUnitNoteItem> parseCableUnitNote(String XmlResponse) {       
        List<CableUnitNoteItem> items = new List<CableUnitNoteItem>() ;
        if (XmlResponse == null) return items;
        System.debug('RES:'+ XmlResponse);
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);             
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {                    
                    if (reader.getLocalName() == 'row') {
                        CableUnitNoteItem item = parseCableUnitNote(reader);                      
                        items.add(item);
                    }                    
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return items;
        }
        return items;
    } 
    
    
    private CableUnitNoteItem parseCableUnitNote(XmlStreamReader reader) {
        CableUnitNoteItem item = new CableUnitNoteItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'OPRETTET_AF') {
                        reader.next();
                        item.user = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'TEKST') {
                        reader.next();
                        item.note = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'OPRETTET_DATO') {
                        reader.next();
                        item.dateN = checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'TYPETEKST') {
                        reader.next();
                        item.type = checkEmptyElement(reader);
                    } 
                }  
            }
            reader.next();
        }
        return item;
    }
    
    
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }
    
 
    /*private String callout(String endpoint) {
        // Make the callout and check the response        
        String body = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));
        req.setTimeout(15000);
        System.debug('req:' +req);        
        HttpResponse res;
        ApexPages.Message m;
        try {
            res = http.send(req);
            System.debug('endpoint: ' + endpoint);
            System.debug('res: ' + res);                    
        } catch (Exception e) {
            m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response 
                String response = res.getBody();
                System.debug('response' + response);
                return response;                
            } else{
                m = new ApexPages.Message(ApexPages.severity.Error,String.valueOf(res.getStatusCode()),
                    res.getStatus());
                ApexPages.addMessage(m);
            }
        }
        return null;    
    }
*/
    static testMethod void testDisplayCustomer() {
         
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'cu_kundeCust_testing'; 
        cableUnit.Cable_Unit_No__c = '0005003320jozef';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnit; 
         
        CableUnitNoteItem cbUnitNoteItemExpected = new CableUnitNoteItem();
        cbUnitNoteItemExpected.dateN = '2011-09-29T10:50:52.000';
        cbUnitNoteItemExpected.type='Gratis seer';
        cbUnitNoteItemExpected.note = 'text';
        cbUnitNoteItemExpected.user = 'A71325';
        ApexPages.StandardController sc = new ApexPages.StandardController(cableUnit);        
        CableUnitNoteTableController controller = new CableUnitNoteTableController(sc);
        controller.cableUnitNotesXmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><row><TYPE>17</TYPE><TYPETEKST>Gratis seer</TYPETEKST><LOEBENR>444</LOEBENR><TEKST>text</TEKST><OPRETTET_AF>A71325</OPRETTET_AF><OPRETTET_DATO>2011-09-29T10:50:52.000</OPRETTET_DATO><OPDATERET_DATO>2011-09-29T10:52:29.000</OPDATERET_DATO></row></rows>';
        //controller.parseCableUnitNote(controller.cableUnitNotesXmlResponse);
        CableUnitNoteItem cbUnitNoteItem = (CableUnitNoteItem)controller.parseCableUnitNote(controller.cableUnitNotesXmlResponse).get(0);
       // system.assertEquals(cbUnitNoteItemExpected.getDate(),cbUnitNoteItem.getDate());
        system.assertEquals(cbUnitNoteItemExpected.Date1,cbUnitNoteItem.Date1);
        system.assertEquals(cbUnitNoteItemExpected.type,cbUnitNoteItem.type);
        system.assertEquals(cbUnitNoteItemExpected.user,cbUnitNoteItem.user);
        system.assertEquals(cbUnitNoteItemExpected.note,cbUnitNoteItem.note);
        controller.getCableUnitNotes();
		cbUnitNoteItem.compareTo(cbUnitNoteItemExpected);       
        
    }
}