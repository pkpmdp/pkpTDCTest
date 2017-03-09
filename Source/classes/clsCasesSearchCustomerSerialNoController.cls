public with sharing class clsCasesSearchCustomerSerialNoController {
    
    private Boolean isTesting = false;
    private static String TESTING_CUSTOMER_NO = '999999';
    private static String TESTING_XMLRESP = '<?xml version="1.0"?><row><CUSTOMERID>'  + TESTING_CUSTOMER_NO + '</CUSTOMERID></row>';
    
    private Account resAccount;
    private ApexPages.StandardController controller;
    
    public String searchFor {get;set;}
    public String resultString {get;set;}
      
    public clsCasesSearchCustomerSerialNoController(ApexPages.StandardController c) {
        controller = c;
    }
    
    public PageReference updateCase() {
    	resultString = 'ok';
    	ID cid = controller.getId();
        Database.SaveResult SR = Database.update ( new Case (id = cid, AccountId = resAccount.id));
        if (SR.getErrors() != null && SR.getErrors().size() >0) {
        	resultString = SR.getErrors()[0].getMessage();
        }
        return null;
    } 
    
    public PageReference lookupCustomer() {
        
        //isTesting = true;
        
        resAccount = null;
        resultString = null;
        
        final String START_ERROR = 'Error: ';
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(clsConnectionUtils.END_POINT + 'YKCases');
        
        String body = searchFor ;
        
        req.setBody(body);
        System.debug('Call webservice with body : ' + req.getBody());
        
        // Make the callout and check the response
        
        try {
        	Integer statuscode = 0;
        	String statustxt = '';
			String xmlbody = '';
			
        	if (!isTesting) {
            	HttpResponse res = http.send(req);
            	System.debug('Got Response : ' + res);
            	statuscode = res.getStatusCode();
            	if (statuscode == 200) {
            		xmlbody = res.getBody();
            	} else {
            		statustxt = res.getStatus();
            	}
        	} else {
        		statuscode = 200;
        		xmlbody = TESTING_XMLRESP ;
        	}
            
            if (statuscode == 200) {
                
                XmlStreamReader reader = new XmlStreamReader(xmlbody);
                reader.setCoalescing(true);
                try {
                    List<String> custids = new List<String>();
                    while(reader.hasNext()) {
                        if (reader.getEventType() == XmlTag.START_ELEMENT) {
                            if (reader.getLocalName() == 'row') {
                                
                                while(reader.hasNext()) {
                                    if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                        if (reader.getLocalName() == 'row') {
                                            break;
                                        }   
                                    } else {
                                        if (reader.getEventType() == XmlTag.START_ELEMENT) {
                                            if (reader.getLocalName() == 'CUSTOMERID') {
                                                reader.next();
                                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                                } else {
                                                    custids.add( reader.getText());
                                                }
                                            }
                                        }  
                                    }
                                    reader.next();
                                }
                            }
                        }
                        reader.next();
                    }
                    
                    if (custids.isEmpty() || custids.size() >1) {
                         resultString = START_ERROR + 'Serial Number matched ' + custids.size() + ' record(s)';
                    } else {
                        try {
                            resAccount = [select Name, Customer_No__c from Account where Customer_No__c = :custids[0]];
                            resultString = resAccount.name;
                        } catch (Exception e) {
                            resultString = START_ERROR + ' Customer Number ' + custids[0] + ' not found';
                        }
                    }
                    
                } catch (Exception e) {
                     resultString = START_ERROR + ' XML Exception - ' +  e.getMessage();
                }
            } else {
                resultString = START_ERROR + statuscode + ' - ' + statustxt;
            }
        } catch (Exception e) {
            resultString = START_ERROR + ' Exception - ' +  e.getMessage();
        }
        
        return null;
    }


    static testMethod void test() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        PageReference pageRef = Page.CasesSearchCustomerResults;
        Test.setCurrentPage(pageRef);
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
         System.assert (add.id != null, 'Cannot insert address');
         
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = TESTING_CUSTOMER_NO;
        insert acc;
        
        //System.assertEquals ([select LastName, Customer_No__c from Account where Customer_No__c = :TESTING_CUSTOMER_NO].Customer_No__c, TESTING_CUSTOMER_NO);
         
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Description = 'Department: YFFTEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c.RecordTypeId = recordType.Id;
        insert c;
        
        System.assert (c.id != null, 'Cannot insert account');
        
        // Navigate to the search page and instantiate the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        clsCasesSearchCustomerSerialNoController controller = new clsCasesSearchCustomerSerialNoController(sc);
        controller.isTesting = true;
        controller.searchFor = 'Test';
		controller.lookupCustomer();
		controller.resAccount = acc;
		//System.debug('lookupCustomer() ' + controller.resultString);
		controller.updateCase();
    }  
    
}