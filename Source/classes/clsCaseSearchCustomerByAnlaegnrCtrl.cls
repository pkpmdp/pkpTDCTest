public with sharing class clsCaseSearchCustomerByAnlaegnrCtrl {

    private ApexPages.StandardController controller;
    public Case cse;
    private String debitorNr = '';
    private String searchXmlResponse;
    public String retUrl = 'unassigned';

    public clsCaseSearchCustomerByAnlaegnrCtrl(ApexPages.StandardController controller) {
        this.cse = (Case) controller.getRecord();
        cse = [Select id, Anlaegnr_Search_Term__c, manual_assign__c, allow_edit__c from Case where id = : cse.id];
        /*if (ApexPages.currentPage().getUrl().startsWith('/apex/CasesSearchCustomerByAnlaegnr?')) {
            cse.Address_Search_Term__c = null;
        }*/
        if(ApexPages.currentPage().getParameters().get('retUrl') != null){
            retUrl = ApexPages.currentPage().getParameters().get('retUrl');
        }
    }
    
    private static String TrimLeading(String str, String leading){
        if (str != null && str.length() > 0 && leading != null && leading.length() > 0){
            Integer i = 0;
            while (i == 0){
              if ((i = str.indexOf(leading)) == 0){
                str = str.substring(leading.length());
              }
            }
        }
        return str;     
    }
    /*
    public PageReference navigateToSearch() {
        cse.Anlaegnr_Search_Term__c = TrimLeading(cse.Anlaegnr_Search_Term__c, '0');
        cse.manual_assign__c = true;
        cse.allow_edit__c = true;
        try {
            update cse;
        } catch (System.DMLException e) {
            System.debug('DML error'+e);
        }
        return null;
    }
    */

    public PageReference searchCableUnit() {
        cse.manual_assign__c = true;
        cse.allow_edit__c = true;
        try {
            update cse;
        } catch (System.DMLException e) {
            System.debug('DML error'+e);
        }
        
        if (cse.Anlaegnr_Search_Term__c != null && cse.Anlaegnr_Search_Term__c != ''){
            //A temporary search string is used to search for accounts, because cable unit number must be exactly 10 characters long.
            String cu_searchString = cse.Anlaegnr_Search_Term__c;
            while (cu_searchString.length() < 10) {
                cu_searchString = '0' + cu_searchString;   
            }             
            List<Account> accounts = [Select id, Cable_Unit_No__c from Account where Cable_Unit_No__c = :cu_searchString  limit 1];
            if(accounts.size()!= 0) {
                cse.AccountId = accounts[0].id;
                //YFF requires that cable unit number are shown without zeros, thus the string is trimmed
                cse.Anlaegnr_Search_Term__c = TrimLeading(cse.Anlaegnr_Search_Term__c, '0');
                update cse;
            }          
        }
      return null;
    }

    public PageReference navigateToSearch() {
        cse.manual_assign__c = true;
        cse.allow_edit__c = true;
        try {
            update cse;
        } catch (System.DMLException e) {
            System.debug('DML error'+e);
        }
        return null;
    }
    
    /* Old version replaced on October 4th 2011
    public PageReference searchAddresses() {
        if (cse.Anlaegnr_Search_Term__c == '' || cse.Anlaegnr_Search_Term__c == null) {
            debitorNr = '';
            return null;
        } else {            
            String searchAnlaegsnr = cse.Anlaegnr_Search_Term__c;
            while (searchAnlaegsnr.length() < 10) {
                searchAnlaegsnr = '0' + searchAnlaegsnr;
            }
            searchXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.CASE_SEARCH_BY_ANLAEGNR, searchAnlaegsnr);
            if(searchXmlResponse != null)
                debitorNr = parseSearchResults(searchXmlResponse);  
            return findOCustomer(debitorNr);
        } 
    }
    */
    
    //YFF Cases can only be associated to cable units from KISS and not from Casper. 
    public PageReference searchKissCableUnit() {
        if (cse.Anlaegnr_Search_Term__c != null && cse.Anlaegnr_Search_Term__c != '') {
            //A temporary search string is used to search for accounts, because cable unit number must be exactly 10 characters long.
            String cu_searchString = cse.Anlaegnr_Search_Term__c;           
            while (cu_searchString.length() < 10) {
                cu_searchString = '0' + cu_searchString;        
            }             
            List<Account> accounts = [Select id, Cable_Unit_No__c from Account where Cable_Unit_No__c = :cu_searchString  limit 1];
            if(accounts.size()!= 0) {
                cse.AccountId = accounts[0].id;
                //YFF requires that cable unit number are shown without zeros, thus the string is trimmed
                cse.Anlaegnr_Search_Term__c = TrimLeading(cse.Anlaegnr_Search_Term__c, '0');
                update cse;
            }          
        }
        if(retUrl!=null && retUrl.equals('fastEdit')){
            return new PageReference('/apex/FastEditCase?id=' + cse.Id);
        }

        return new PageReference('/' + cse.Id); 
    }
    
    /* Old version replaced by October 4th 2011
    private PageReference findOCustomer(String debitorNr) {
        if(debitorNr != '' && debitorNr != null) { 
            debitorNr = debitorNr.trim();
            List<Account> accounts = [Select id, Customer_No__c from Account where Customer_No__c =: debitorNr Limit 1];
            if(accounts.size()!= 0) {
                cse.AccountId = accounts[0].id;
                update cse;
            }                
        }
            return new PageReference('/' + cse.Id);
         //else {
            //System.debug('#######################search term'+cse.Anlaegnr_Search_Term__c);
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Der findes ingen kunde'));
             //return null;
         //}
    }*/
    
    
    private String callout(String endpoint, String body) {
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
    
    private String parseSearchResults(String XmlResponse) {     
        String customerNo;
        if (XmlResponse == null) return '';
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
             
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        customerNo = parseCustomerNO(reader);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return '';
        }
        return customerNo;
    }
    
    private String parseCustomerNO(XmlStreamReader reader) {
        String customerNo;
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {                
                    if (reader.getLocalName() == 'KONTONUMMER') {
                        reader.next();
                        customerNo = checkEmptyElement(reader);
                    } 
                }  
            }
            reader.next();
        }
        return customerNo;
    }
    
    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
    
    public Case getCse() {
        return this.cse;
    }

    public String getRetUrl(){
        return this.retUrl;
    }

    public static testMethod void testTrimLeading(){
      system.assert(TrimLeading('0000000055', '0') == '55');
      system.assert(TrimLeading('0000000055', '00') == '55');
      system.assert(TrimLeading('0000000055', '000') != '55');
      system.assert(TrimLeading('0000000055', '0000') == '55');
      system.assert(TrimLeading('0000000055', '') == '0000000055');
      system.assert(TrimLeading('', '') == '');
      system.assert(TrimLeading('', '1') == '');
      system.assert(TrimLeading(null, '1') == null);
      system.assert(TrimLeading(null, null) == null);
      system.assert(TrimLeading('', null) == '');
      system.assert(TrimLeading('a', 'a') == '');
      system.assert(TrimLeading('aa', 'a') == '');
      system.assert(TrimLeading('aa', 'aa') == '');
      system.assert(TrimLeading('aaa', 'aa') == 'a');
      system.assert(TrimLeading('aaab', 'aa') == 'ab');
      system.assert(TrimLeading('aaabc', 'abc') == 'aaabc');
      system.assert(TrimLeading('aaabc', 'a') == 'bc');
      system.assert(TrimLeading('abababcababc', 'ab') == 'cababc');
      system.assert(TrimLeading('abababcababc', 'aba') == 'babcababc');
      system.assert(TrimLeading('abababcababc', 'abc') == 'abababcababc');
      system.assert(TrimLeading('abababcababcab', 'cab') == 'abababcababcab');
      system.assert(TrimLeading('cabababcababcab', 'cab') == 'ababcababcab');
      system.assert(TrimLeading('cabcababcab', 'cab') == 'abcab');
      system.assert(TrimLeading('cabcabcab', 'cab') == '');
    }

    public static testMethod void testSearchCustomer() {
        Case cse = new Case();
        insert cse;
		
        Account acc = new Account();
        acc.name = 'test account';
        acc.Customer_No__c = '123456';
		acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
		
        PageReference prf = Page.CaseSearchCustomerByAnlaegnr;
        Test.setCurrentPage(prf);
        System.assertEquals(prf.getURL(), '/apex/casesearchcustomerbyanlaegnr');
        ApexPages.Standardcontroller standardCtrl = new ApexPages.Standardcontroller(cse);
        clsCaseSearchCustomerByAnlaegnrCtrl controller = new clsCaseSearchCustomerByAnlaegnrCtrl(standardCtrl);
        System.assertEquals(null, controller.getCse().Anlaegnr_Search_Term__c);
        //System.assertEquals(null, controller.searchAddresses());
        controller.getCse().Anlaegnr_Search_Term__c = '555555555';
        controller.navigateToSearch();
        System.assertEquals('555555555', controller.getCse().Anlaegnr_Search_Term__c);
        System.assertEquals(true, controller.getCse().manual_assign__c);
        //System.assertEquals(null, controller.searchAddresses());
        String XmlResponse = '<?xml version="1.0" encoding="UTF-8"?><rows><row><KONTONUMMER>123456</KONTONUMMER></row></rows>';
        System.assertEquals('123456', controller.parseSearchResults(XmlResponse));
        //controller.findOCustomer('123456');
        //System.assertEquals(controller.getCse().AccountId, acc.id);
    }

    public static testMethod void testGetRetUrl() {
        Case cse = new Case();
        insert cse;
               
        PageReference prf = Page.CaseSearchCustomerByAnlaegnr;
        Test.setCurrentPage(prf);

        ApexPages.Standardcontroller standardCtrl = new ApexPages.Standardcontroller(cse);
        clsCaseSearchCustomerByAnlaegnrCtrl controller = new clsCaseSearchCustomerByAnlaegnrCtrl(standardCtrl);
        System.assertEquals('unassigned', controller.getRetUrl());      
    }

    public static testMethod void testSearchKissCableUnit() {
        Case cse = new Case();
        cse.Anlaegnr_Search_Term__c = 'test1';
        insert cse;
        
        Account acc = new Account();
        acc.name = 'test account';
        acc.Customer_No__c = '123456';
		acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
               
        PageReference prf = Page.CaseSearchCustomerByAnlaegnr;
        Test.setCurrentPage(prf);

        ApexPages.Standardcontroller standardCtrl = new ApexPages.Standardcontroller(cse);
        clsCaseSearchCustomerByAnlaegnrCtrl controller = new clsCaseSearchCustomerByAnlaegnrCtrl(standardCtrl);
        System.assertEquals('/' + cse.Id, controller.searchKissCableUnit().getUrl() );
        controller.searchCableUnit();
    }

    public static testMethod void testCallout() {
        Case cse = new Case();
        insert cse;
                      
        PageReference prf = Page.CaseSearchCustomerByAnlaegnr;
        Test.setCurrentPage(prf);

        ApexPages.Standardcontroller standardCtrl = new ApexPages.Standardcontroller(cse);
        clsCaseSearchCustomerByAnlaegnrCtrl controller = new clsCaseSearchCustomerByAnlaegnrCtrl(standardCtrl);
        System.assertEquals(null,controller.callout('','') );              
    }

}