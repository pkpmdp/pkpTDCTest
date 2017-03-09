public class clsAccountEditAddresses {

    private ApexPages.standardController controller;
    public Account acc{get;set;}
    public boolean isBucAddress{get;set;}   
    public String selectid{get;set;}
    public boolean displayPopup {get; set;}     
    public String selectinstall{get;set;}
    public List<Net_Installations__c> netinstall;
    public List<Net_Installations__c> beforeupdate;
    public string previousval;
    public string newvalue;
    public String fullURL = ApexPages.currentPage().getParameters().get('addid');
    public String billurl = ApexPages.currentPage().getParameters().get('billing');
    public Integer Length {get;set;}
    
    private class AddrData {
        String fullName;
        String type;
        String typeFull;
        Date validFromDate;
        String validFrom;
        Date validToDate;
        String validTo;
        String deleted;
        String hash;
       
        AddrData(String fullName, String type, Date validFromDate, Date validToDate, String deleted) {
            this.fullName = fullName;
            this.type = type;
            this.typeFull = makeTypeFull(type);
            this.validFromDate = validFromDate;
            this.validFrom = validFromDate == null ? null : validFromDate.format();
            this.validToDate = validToDate;
            this.validTo = validToDate == null ? null : validToDate.format();
            this.deleted = deleted;
            this.hash = makeHash(validFromDate, validToDate, type);
        }
        AddrData(String fullName, String type, Date validFromDate) {
            this(fullName, type, validFromDate, null, null);
        }
        public String getFullName() { return fullName; }
        public String getType() { return type; }
        public String getTypeFull() { return typeFull; }
        public String getValidFrom() { return validFrom; }
        public String getValidTo() { return validTo; }
        public String getDeleted() { return deleted; }
        public String getHash() { return Hash; }
        private String makeTypeFull(String str) {
            String retVal = str;
            if (str == 'J') {
                retVal = System.Label.Customer_Address_Type_Legal;
            } else if (str == 'B') {
                retVal = System.Label.Customer_Address_Type_Billing;
            }
            return retVal;
        }
        private String makeHash(Date fr, Date to, String str) {
            String fDate = fr == null ? '0000-00-00' : String.valueOf(fr);
            return fDate + str;
        }
    }
    private List<AddrData> addresses;

    public clsAccountEditAddresses(ApexPages.StandardController stdController) {
        
        controller = stdController;
        netinstall = new List<Net_Installations__c>();
        acc = [
            SELECT Id,BUC_address1__c, BUC_address2__c, BUC_address3__c, BUC_address4__c, BUC_address5__c, BUC_address_type__c, BUC_Country__c,
                Billing_Address__c, Street_YK__c, IsPersonAccount,Customer_No__c,Billing_Address__r.Name,Street_YK__r.Name,BUC_country__r.Name,Net_Installation__r.name,Net_Installation__c
            FROM Account
            WHERE Id = :((Account) controller.getRecord()).Id
        ];
        //selectinstall ='93563';
        String xmlResponse = callout(
            clsConnectionUtils.END_POINT + clsConnectionUtils.CUSTOMER_ADDRESSES_METHOD,
            acc.Customer_No__c
        );
/*
xmlResponse = '<response>\n' +
'   <kundeAddresses>\n' +
'      <address>Baker Street 1, 1234 Frederiksberg</address>\n' +
'      <type>J</type>\n' +
'      <debitorNr>609560372</debitorNr>\n' +
'      <validFrom>2010-12-08T08:42:24.000</validFrom>\n' +
'      <validTo/>\n' +
'      <udgaet/>\n' +
'   </kundeAddresses>\n' +
'   <kundeAddresses>\n' +
'      <address>Baker Street 1, 1234 Frederiksberg</address>\n' +
'      <type>B</type>\n' +
'      <debitorNr>609560372</debitorNr>\n' +
'      <validFrom>2010-12-08T08:42:24.000</validFrom>\n' +
'      <validTo/>\n' +
'      <udgaet/>\n' +
'   </kundeAddresses>\n' +
'   <kundeAddresses>\n' +
'      <address>Sesame Street 1, 1234 Aalborg</address>\n' +
'      <type>J</type>\n' +
'      <debitorNr>609560372</debitorNr>\n' +
'      <validFrom>2006-11-03T21:14:47.000</validFrom>\n' +
'      <validTo>2010-12-07T07:42:24.000</validTo>\n' +
'      <udgaet/>\n' +
'   </kundeAddresses>\n' +
'   <kundeAddresses>\n' +
'      <address>Sesame Street 1, 1234 Aalborg</address>\n' +
'      <type>B</type>\n' +
'      <debitorNr>609560372</debitorNr>\n' +
'      <validFrom>2006-11-03T21:14:47.000</validFrom>\n' +
'      <validTo>2010-12-07T07:42:24.000</validTo>\n' +
'      <udgaet/>\n' +
'   </kundeAddresses>\n' +
'</response>'
;
*/
        addresses = makeAddressList(xmlResponse);
        sortAddressList(addresses);
    }

    public List <AddrData> getAddresses() {
        return addresses;
    }
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {         
        displayPopup = true;    
    }
    
    /*public void populatecode(){ 
        System.debug('method called');
    } */
    public PageReference save() {
  if(acc.Street_YK__r.Name=='Dummyudlandsvej' && acc.Billing_Address__r.Name!='Dummyudlandsvej')
    {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Billing_Error));
    return null;
    }
    else
    {  
        system.debug('##Account.Billing_Address__c:'+acc.Billing_Address__r.Name);
        system.debug('##acc.Street_YK__c:'+acc.Street_YK__r.Name+' Address Type1:'+acc.BUC_address_type__c+' Country:'+acc.BUC_country__r.Name);
        system.debug('##acc.BUC_address1__c:'+acc.BUC_address1__c+' acc.BUC_address2__c:'+acc.BUC_address2__c+' acc.BUC_address3__c:'+acc.BUC_address3__c);
        system.debug('##acc.BUC_address4__c:'+acc.BUC_address4__c+' acc.BUC_address5__c:'+acc.BUC_address5__c);
        //added for SPOC-1203
        Country__c countryid=[select id,name from Country__c where name='Danmark' limit 1];
       
        system.debug('%%%%%%%Buc country:'+acc.BUC_country__c);
        if(((String.isBlank(acc.BUC_address1__c))||(String.isBlank(acc.BUC_address2__c))||(String.isBlank(acc.BUC_address4__c))||(String.isBlank(acc.BUC_address5__c))||(String.isBlank(acc.BUC_country__c)))&&((acc.BUC_address_type__c=='Foreign address')&&(acc.Billing_Address__r.Name=='Dummyudlandsvej'))){
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.BUC_add1_add2_add4_add5_country);
            ApexPages.addMessage(errorMsg);
            system.debug('*****if 1');
            return null; 
            
         }
         else if(((String.isBlank(acc.BUC_address3__c))||(String.isBlank(acc.BUC_address4__c))||(String.isBlank(acc.BUC_address5__c)))&&((acc.BUC_address_type__c=='Postbox')&&(acc.Billing_Address__r.Name=='Dummyudlandsvej'))){
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.BUC_add3_add4_add5);
            ApexPages.addMessage(errorMsg);
            system.debug('*****if 2');
            return null; 
         }
         else if((acc.Billing_Address__r.Name=='Dummyudlandsvej')&&!((String.isNotBlank(acc.BUC_country__c)||String.isNotBlank(acc.BUC_address1__c)||String.isNotBlank(acc.BUC_address2__c)||String.isNotBlank(acc.BUC_address3__c)||String.isNotBlank(acc.BUC_address4__c)||String.isNotBlank(acc.BUC_address5__c)))){
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.BUC_Postbox_Address);
            ApexPages.addMessage(errorMsg);
            system.debug('*****if 3');
            return null; 
         }else if((acc.Billing_Address__r.Name=='Dummyudlandsvej') && (String.isBlank(acc.BUC_address_type__c)))
         {
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.BUC_Address_Type);
            ApexPages.addMessage(errorMsg);
            system.debug('*****if 4');
            return null; 
         }else{           
          if(acc.Billing_Address__r.Name!='Dummyudlandsvej'){
            acc.BUC_address_type__c=null;
            system.debug('*****if 5');
          }
           if((acc.BUC_country__c==countryid.id)&&((acc.BUC_address_type__c=='Foreign address')&&(acc.Billing_Address__r.Name=='Dummyudlandsvej'))){
            ApexPages.Message errorMsg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.Foreign_address_no_country_as_denmark);
            ApexPages.addMessage(errorMsg);
            system.debug('*****if 6');
            return null; 
         }
         else {
         system.debug('*****if 7');
         //Final Implementation for SF-1688 starts
         
             List <Net_Installations__c> netinstlst=[SELECT Id,Address__c FROM Net_Installations__c where Address__c = :acc.Street_YK__c and (Installation_Status_Code__c = '1' OR Installation_Status_Code__c = '11') order by lastmodifieddate desc limit 1] ;
             if(netinstlst.size() == 1){
                 acc.Net_Installation__c = netinstlst[0].id;
             } else {
                List <Net_Installations__c> netinstlst2=[SELECT Id,Address__c FROM Net_Installations__c where Address__c = :acc.Street_YK__c and Installation_Status_Code__c = '0' order by lastmodifieddate desc limit 1] ; 
                if(netinstlst2.size() ==1){
                    acc.Net_Installation__c = netinstlst2[0].id;
                }
              else{
                 acc.Net_Installation__c=null;
             }
             }
         //Final Implementation for SF-1688 ends
         update acc;
         system.debug('*****update'+acc);
         Account ac=(Account)controller.getRecord();
         return controller.view();
    
            }
         } 
         
  }
  
    }
    
    
   

    public PageReference cancel() {
        PageReference pageRef = controller.cancel();
        return new PageReference('/' + acc.Id);
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
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response
                String response = res.getBody();
                System.debug('Good response: ' + response);
                return response;
            }
        }
        return null;
    }

    private List<AddrData> makeAddressList(String response) {
        List<AddrData> aList = new List<AddrData>();
        if (response != null) {
            XmlStreamReader reader = new XmlStreamReader(response);
            reader.setCoalescing(true);
            try {
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        AddrData anAddr = null;
                        if (reader.getLocalName() == 'kundeAddresses') {
                            anAddr = parseAddress(reader);
                        }
                        if (anAddr != null) {
                            aList.add(anAddr);
                        }
                    }
                    reader.next();
                }
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error,
                    'An error occured parsing the XML response: ' + e.getMessage(),
                    e.getMessage()
                );
                ApexPages.addMessage(m);
            }
        }
        return aList;
    }

    private AddrData parseAddress(XmlStreamReader reader) {
        AddrData anAddr = null;
        String fullName = null;
        String type = null;
        Date validFromDate = null;
        Date validToDate = null;
        String deleted = null;
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'kundeAddresses') {
                    anAddr = new AddrData(fullName, type, validFromDate, validToDate, deleted);
                    break;
                }
            } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'address') {
                    reader.next();
                    if (reader.getEventType() != XmlTag.END_ELEMENT) {
                        fullName = reader.getText().trim();
                    }
                } else if (reader.getLocalName() == 'type') {
                    reader.next();
                    if (reader.getEventType() != XmlTag.END_ELEMENT) {
                        type = reader.getText().trim();
                    }
                } else if (reader.getLocalName() == 'validFrom') {
                    reader.next();
                    if (reader.getEventType() != XmlTag.END_ELEMENT) {
                        validFromDate = Date.valueOf(reader.getText().trim());
                    }
                } else if (reader.getLocalName() == 'validTo') {
                    reader.next();
                    if (reader.getEventType() != XmlTag.END_ELEMENT) {
                        validToDate = Date.valueOf(reader.getText().trim());
                    }
                } else if (reader.getLocalName() == 'udgaet') {
                    reader.next();
                    if (reader.getEventType() != XmlTag.END_ELEMENT) {
                        deleted = reader.getText().trim();
                    }
                }
            }
            reader.next();
        }
        return anAddr;
    }

    private void sortAddressList(List<AddrData> aList) {
        List<AddrData> sortedList = new List<AddrData>();
        // Prepare a map <hash : items with the same hash>
        Map<String, List<AddrData>> aMap = new Map<String, List<AddrData>>();
        for (AddrData item : aList) {
            String hash = item.getHash();
            if (aMap.get(hash) == null) {
                aMap.put(hash, new List<AddrData>());
            }
            aMap.get(hash).add(item);
        }
        // Sort the hash keys
        List<String> keys = new List<String>(aMap.keySet());
        keys.sort();
        // Set up the sorted list
        for (String key : keys) {
            sortedList.addAll(aMap.get(key));
        }

        // Update the list (descending)
        aList.clear();
        for (Integer i=sortedList.size()-1; i >= 0; i--) {
            aList.add(sortedList[i]);
        }
        /* Update the list (ascending)
        for (AddrData item : sortedList) {
            aList.add(item);
        }
        */
    }
    
    public SelectOption[] getCountryOptions() {
      SelectOption[] countries = new SelectOption[]{};
      for (Country__c c:[SELECT id,name,Country_Code__c FROM Country__c]) {
        countries.add(new SelectOption(c.id, c.name+' '+c.Country_Code__c));
      }
      return countries;
    }
    
    static testmethod void testgetCountryOptions(){
    
        PageReference pageRef = Page.AccountEditAddresses;
        Test.setCurrentPage(pageRef);
        Country__c country1 = new Country__c();
        country1.name='USA';
        country1.Country_Code__c='SU';
        insert country1;
        Country__c country2 = new Country__c();
        country2.name='INDIA';
        country2.Country_Code__c='IN';
        insert country2;
        Country__c country3 = new Country__c();
        country3.name='AUSTRALIA';
        country3.Country_Code__c='UU';
        insert country3;
        
        String aBUC_1 = 'BUC Address 01';
        String aBUC_2 = 'BUC Address 02';
        String aBUC_3 = 'BUC Address 03';
        String aBUC_4 = 'BUC Address 04';
        String aBUC_5 = 'BUC Address 05';
        String aBUC_addr_type = 'Postbox';
        Account acc = new Account();
        acc.Name = 'John Doe';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.BUC_address1__c = aBUC_1;
        acc.BUC_address2__c = aBUC_2;
        acc.BUC_address3__c = aBUC_3;
        acc.BUC_address4__c = aBUC_4;
        acc.BUC_address5__c = aBUC_5;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YS Customer Account'].Id;
        insert acc;
        
        // Instantiate and construct the controller class.
        clsAccountEditAddresses ctrl = new clsAccountEditAddresses(new ApexPages.standardController(acc));
        ctrl.getCountryOptions();
    }
    
   
    static testMethod void testSave() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.AccountEditAddresses;
        Test.setCurrentPage(pageRef);
    
    System.debug('%%%%%Page REF1'+pageRef);
        String aBUC_1 = 'BUC Address 01';
        String aBUC_2 = 'BUC Address 02';
        String aBUC_3 = 'BUC Address 03';
        String aBUC_4 = 'BUC Address 04';
        String aBUC_5 = 'BUC Address 05';
        String aBUC_addr_type = 'Postbox';
        
        /*Country__c country = new Country__c();
        country.name='USA';
        country.Country_Code__c='US';
        insert country;*/


        // Instantiate Address records
        Address__c addr1 = new Address__c();
        insert addr1;
        Address__c addr2 = new Address__c();
        insert addr2;

        // Instantiate a Customer record
        //Account acc = new Account(Name='John Doe');
        Account acc = new Account();
        acc.Name = 'John Doe';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.BUC_address1__c = aBUC_1;
        acc.BUC_address2__c = aBUC_2;
        acc.BUC_address3__c = aBUC_3;
        acc.BUC_address4__c = aBUC_4;
        acc.BUC_address5__c = aBUC_5;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YS Customer Account'].Id;
        insert acc;

        // Instantiate and construct the controller class.
        clsAccountEditAddresses ctrl = new clsAccountEditAddresses(new ApexPages.standardController(acc));
      
        // Fill address values to Account record of the controller
        /*acc.BUC_address1__c = aBUC_1;
        acc.BUC_address2__c = aBUC_2;
        acc.BUC_address3__c = aBUC_3;
        acc.BUC_address4__c = aBUC_4;
        acc.BUC_address5__c = aBUC_5;*/
        acc.BUC_Address_Type__c = aBUC_addr_type;
        //acc.BUC_Country__c = country.id;
        acc.Billing_Address__c = addr1.Id;
        acc.Street_YK__c = addr2.Id;

        // Save:
        //pageRef = ctrl.save();
        ctrl.save();
        System.debug('%%%%%Page REF2'+pageRef);
        // Check that the save() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Account dbAcc = [
            SELECT BUC_address1__c, BUC_address2__c, IsPersonAccount,BUC_address3__c, BUC_address4__c, BUC_address5__c, BUC_address_type__c, BUC_Country__c,
            Billing_Address__c, Street_YK__c
            FROM Account WHERE Id = :acc.Id
        ];
        System.debug('###dbAcc##'+dbAcc);
        System.assertEquals(dbAcc.BUC_address1__c, aBUC_1);
        System.assertEquals(dbAcc.BUC_address2__c, aBUC_2);
        System.assertEquals(dbAcc.BUC_address3__c, aBUC_3);
        System.assertEquals(dbAcc.BUC_address4__c, aBUC_4);
        System.assertEquals(dbAcc.BUC_address5__c, aBUC_5);
        System.assertEquals(dbAcc.BUC_address_type__c, null);
        //System.assertEquals(dbAcc.BUC_Country__c, country.id);
        //System.assertEquals(dbAcc.Billing_Address__c, addr1.Id);
        //System.assertEquals(dbAcc.Street_YK__c, addr2.Id);
    }

    static testMethod void testCancel() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.AccountEditAddresses;
        Test.setCurrentPage(pageRef);

        String aBUC_1 = 'BUC Address 01';
        String aBUC_2 = 'BUC Address 02';
        String aBUC_3 = 'BUC Address 03';
        String aBUC_4 = 'BUC Address 04';
        String aBUC_5 = 'BUC Address 05';
        String aBUC_addr_type = 'Postbox';
        
        /*Country__c country = new Country__c();
        country.name='USA';
        country.Country_Code__c='US';
        insert country;*/       

        // Instantiate Address records
        Address__c addr1 = new Address__c();
        insert addr1;
        Address__c addr2 = new Address__c();
        insert addr2;

        // Instantiate a Customer record
        Account acc = new Account();
        acc.Name = 'John Doe';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YS Customer Account'].Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
      

        // Instantiate and construct the controller class.
        clsAccountEditAddresses ctrl =
            new clsAccountEditAddresses(new ApexPages.standardController(acc))
        ;

        // Fill address values to Account record of the controller
        acc.BUC_address1__c = aBUC_1;
        acc.BUC_address2__c = aBUC_2;
        acc.BUC_address3__c = aBUC_3;
        acc.BUC_address4__c = aBUC_4;
        acc.BUC_address5__c = aBUC_5;
        acc.BUC_Address_Type__c = aBUC_addr_type;
        //acc.BUC_Country__c = country.id;        
        acc.Billing_Address__c = addr1.Id;
        acc.Street_YK__c = addr2.Id;

        // Cancel:
        pageRef = ctrl.cancel();
        // Check that the cancel() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        Account dbAcc = [
            SELECT BUC_address1__c, BUC_address2__c, BUC_address3__c, IsPersonAccount,BUC_address4__c, BUC_address5__c, BUC_address_type__c, BUC_Country__c,
            Billing_Address__c, Street_YK__c
            FROM Account WHERE Id = :acc.Id
        ];
        System.assertEquals(dbAcc.BUC_address1__c, null);
        System.assertEquals(dbAcc.BUC_address2__c, null);
        System.assertEquals(dbAcc.BUC_address3__c, null);
        System.assertEquals(dbAcc.BUC_address4__c, null);
        System.assertEquals(dbAcc.BUC_address5__c, null);
        System.assertEquals(dbAcc.BUC_address_type__c, null);
        //System.assertEquals(dbAcc.BUC_Country__c, null);        
        System.assertEquals(dbAcc.Billing_Address__c, null);
        System.assertEquals(dbAcc.Street_YK__c, null);
    }

    static testMethod void testMakeAndSortAddressList() {
        // Instantiate an Account record
        Account acc = new Account(Name='John Doe');
        acc.Customer_No__c = '987654321';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;

        // Instantiate and construct the controller class
        clsAccountEditAddresses ctrl =
            new clsAccountEditAddresses(new ApexPages.standardController(acc))
        ;

        String a1_fullName = 'Baker Street 1, 1234 Frederiksberg';
        String a1_type = 'J';
        String a1_validFrom = Date.newInstance(2010, 12, 8).format();
        String a1_validTo = null;
        String a1_deleted = null;
        String a2_fullName = 'Baker Street 2, 1234 Frederiksberg';
        String a2_type = 'B';
        String a2_validFrom = Date.newInstance(2010, 12, 8).format();
        String a2_validTo = null;
        String a2_deleted = null;
        String a3_fullName = 'Sesame Street 1, 1234 Aalborg';
        String a3_type = 'J';
        String a3_validFrom = Date.newInstance(2006, 11, 3).format();
        String a3_validTo = Date.newInstance(2010, 12, 7).format();
        String a3_deleted = null;
        String a4_fullName = 'Sesame Street 2, 1234 Aalborg';
        String a4_type = 'B';
        String a4_validFrom = Date.newInstance(2006, 11, 3).format();
        String a4_validTo = Date.newInstance(2010, 12, 7).format();
        String a4_deleted = 'Ja';
        String xmlResponse = '<response>\n' +
            '   <kundeAddresses>\n' +
            '      <address>' + a1_fullName + '</address>\n' +
            '      <type>' + a1_type + '</type>\n' +
            '      <debitorNr>609560372</debitorNr>\n' +
            '      <validFrom>2010-12-08T08:42:24.000</validFrom>\n' +
            '      <validTo/>\n' +
            '      <udgaet/>\n' +
            '   </kundeAddresses>\n' +
            '   <kundeAddresses>\n' +
            '      <address>' + a2_fullName + '</address>\n' +
            '      <type>' + a2_type + '</type>\n' +
            '      <debitorNr>609560372</debitorNr>\n' +
            '      <validFrom>2010-12-08T08:42:24.000</validFrom>\n' +
            '      <validTo/>\n' +
            '      <udgaet/>\n' +
            '   </kundeAddresses>\n' +
            '   <kundeAddresses>\n' +
            '      <address>' + a3_fullName + '</address>\n' +
            '      <type>' + a3_type + '</type>\n' +
            '      <debitorNr>609560372</debitorNr>\n' +
            '      <validFrom>2006-11-03T21:14:47.000</validFrom>\n' +
            '      <validTo>2010-12-07T07:42:24.000</validTo>\n' +
            '      <udgaet>' + (a3_deleted == null ? '' : a3_deleted) + '</udgaet>\n' +
            '   </kundeAddresses>\n' +
            '   <kundeAddresses>\n' +
            '      <address>' + a4_fullName + '</address>\n' +
            '      <type>' + a4_type + '</type>\n' +
            '      <debitorNr>609560372</debitorNr>\n' +
            '      <validFrom>2006-11-03T21:14:47.000</validFrom>\n' +
            '      <validTo>2010-12-07T07:42:24.000</validTo>\n' +
            '      <udgaet>' + (a4_deleted == null ? '' : a4_deleted) + '</udgaet>\n' +
            '   </kundeAddresses>\n' +
            '</response>'
        ;
        // Test the makeAddressList method
        List <AddrData> addresses = ctrl.makeAddressList(xmlResponse);
        System.assertEquals(4, addresses.size());
        for (AddrData addr : addresses) {
            String fullName = addr.getFullName();
            if (fullName == a1_fullName) {
                System.assertEquals(a1_type, addr.getType());
                System.assertEquals(a1_validFrom, addr.getValidFrom());
                System.assertEquals(a1_validTo, addr.getValidTo());
                System.assertEquals(a1_deleted, addr.getDeleted());
            } else if (fullName == a2_fullName) {
                System.assertEquals(a2_type, addr.getType());
                System.assertEquals(a2_validFrom, addr.getValidFrom());
                System.assertEquals(a2_validTo, addr.getValidTo());
                System.assertEquals(a2_deleted, addr.getDeleted());
            } else if (fullName == a3_fullName) {
                System.assertEquals(a3_type, addr.getType());
                System.assertEquals(a3_validFrom, addr.getValidFrom());
                System.assertEquals(a3_validTo, addr.getValidTo());
                System.assertEquals(a3_deleted, addr.getDeleted());
            } else if (fullName == a4_fullName) {
                System.assertEquals(a4_type, addr.getType());
                System.assertEquals(a4_validFrom, addr.getValidFrom());
                System.assertEquals(a4_validTo, addr.getValidTo());
                System.assertEquals(a4_deleted, addr.getDeleted());
            } else {
                // No match = error
                System.assert(false);
            }
        }
        // Test the sortAddressList method
        ctrl.sortAddressList(addresses);
        System.assertEquals(a1_fullName, addresses[0].getFullName());
        System.assertEquals(a2_fullName, addresses[1].getFullName());
        System.assertEquals(a3_fullName, addresses[2].getFullName());
        System.assertEquals(a4_fullName, addresses[3].getFullName());
    }
}