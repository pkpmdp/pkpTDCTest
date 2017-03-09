public with sharing class clsCustomerLogController {
    public String idParam{get;set;}
    public String idAccount{get;set;}
    public boolean statusAssignment{ get; set; }
    public Customer_Log__c customerLog{get;set;}
    public ID salesforceId{get;set;}
    public ID accountId{get;set;}
    
    public clsCustomerLogController() {
    
        customerLog= new Customer_Log__c();
        statusAssignment = true;
        idParam=System.currentPagereference().getParameters().get('id');
        
            if (idParam!=null){
                if (idParam.startsWith('001')){
                    idAccount=idParam;
                }
                else if (idParam.startsWith('003')){
                    List<Contact> contactList = [Select AccountId From Contact where id=:idParam];
                    if (contactList.size()==1){
                        idAccount = contactList[0].AccountId;
                    }
                }
                else if (idParam.startsWith('500')){
                    List<Case> caseList = [Select AccountId From Case where id=:idParam];
                    if (caseList.size()==1){
                        idAccount = caseList[0].AccountId;
                    }
                }
            }
            
            if (idAccount==null){
                customerLog.Text__c=System.Label.Customer_ID_not_found;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO ,System.Label.Customer_ID_not_found)); 
            }
            else {
                customerLog.Customer__c=idAccount;
            }
           
    }
    
    // Changes done to fulfill 
    // https://yousee.jira.com/wiki/display/SPOC/BUC%20SPOC-435%20Solution%20Design 
    public PageReference save(){ 
        if (idAccount!=null && customerLog.text__c!=''){
            
             //create log in Salesforce
            saveLogToSF();
            //clear textarea
            customerLog= new Customer_Log__c();
            customerLog.Customer__c=idAccount;
        }
        if (idParam.startsWith('001')){
            statusAssignment = false;
        }else{
            statusAssignment = true;
        }   
        //PageReference pr = new PageReference('/apex/ConsoleCustomerLeftPanelPoC_YKRB?Id='+idAccount+'&isdtp=vw');
        //PageReference pr = new PageReference('/apex/DealerCustomerSearch?isdtp=vw');
        //return pr;
        return null;
    }
    
    
    /*
    public PageReference save(){ 
        if (idAccount!=null && customerLog.text__c!=''){
            //create log in Casper
            saveLogToCasper(customerLog.text__c);

            //create log in Salesforce
            saveLogToSF();
            
            //clear textarea
            customerLog= new Customer_Log__c();
            customerLog.Customer__c=idAccount;
        }
        return null;
    }
    */

    private void saveLogToSF(){
            insert customerLog;
    }

    /*
        This method will be removed in second phase of SPOC-435
    
    private void saveLogToCasper(String text) {
        //Customer_Log__c newActivityLog = [Select User__c, Text__c, Inquiry_Type__c, Inquiry_Form__c, Date__c, Customer__c From Customer_Log__c where id=:newActivityLogId];
        Account account = [Select Customer_No__c from Account where id=:idAccount];
        User user = [Select MID__c From User Where Id = : UserInfo.getUserId()];
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'customerInquiry', null);
        writeStartAndEndElements(w, 'customerId', (String) account.Customer_No__c);
        writeStartAndEndElements(w, 'contactType', '1');//default value 'Telefonisk'
        writeStartAndEndElements(w, 'subjectType', '0');//default value 'Supplerende tekst'
        writeStartAndEndElements(w, 'subjectTypeDesc', '');
        //writeStartAndEndElements(w, 'text', EncodingUtil.urlEncode(newActivityLog.textField, 'ISO-8859-1'));
        writeStartAndEndElements(w, 'text', text);
        writeStartAndEndElements(w, 'dataset', 'KTV');
        writeStartAndEndElements(w, 'sequenceNumber', '1');
        writeStartAndEndElements(w, 'userId', user.MID__c);            
        w.writeEndElement(); 
        w.writeEndDocument();
        String newActivityLogXmlResponse = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.ADD_ACTIVITY_LOG_METHOD, w.getXmlString());
    }
    
    private void writeStartAndEndElements(XMLStreamWriter w, String name, String value) {
        w.writeStartElement(null, name, null);
        w.writeCharacters((value == null ? '': value));
        w.writeEndElement();
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
    */
     static testMethod  void prepareData() {
        Decimal TESTNUM = 68999998;
        List<CustomerNumberSeq__c> custSeqList = [ Select lastNumber__c from  CustomerNumberSeq__c ];
        CustomerNumberSeq__c custSeq; 
        if (custSeqList.size() > 0 ){
            custSeq = (CustomerNumberSeq__c)custSeqList.get(0);
            custSeq.lastNumber__c = TESTNUM;
            update custSeq;  
        }else {
            custSeq = new  CustomerNumberSeq__c();
            custSeq.lastNumber__c = TESTNUM;              
            insert custSeq;
        }        
    }
    
    
    static testMethod void testCustomerLogController() {
        Test.startTest();
        prepareData();
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        // prepare Customer
        Account customer = new Account(FirstName = 'John', LastName = 'Doe');
        insert customer; 

        PageReference pageRef = Page.CustomerLog;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().clear();
        
        //test without parameter
        clsCustomerLogController controller = new clsCustomerLogController ();
        
        //test with account id as parameter
        ApexPages.currentPage().getParameters().put('id', customer.id);
        controller = new clsCustomerLogController ();

        controller.save();
        List<Customer_Log__c> custLogList=[select id from Customer_Log__c where Customer__c =:customer.id ];
        System.assert(custLogList != null);
        System.assertEquals(custLogList.size(), 1); 

        //test with contact id as parameter
        List<Contact> contactList = [select id from Contact where AccountId=:customer.id];
        if (contactList.size()>0){
        
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', contactList[0].id);
            controller = new clsCustomerLogController ();
    
            controller.save();
            custLogList=[select id from Customer_Log__c where Customer__c =:customer.id ];
            System.assert(custLogList != null);
            System.assertEquals(custLogList.size(), 2); 
        }

        //test with case id as parameter
        Case testCase = new Case(AccountId=customer.id);
        insert testCase;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id', testCase.id);
        controller = new clsCustomerLogController ();

        controller.save();
        custLogList=[select id from Customer_Log__c where Customer__c =:customer.id ];
        System.assert(custLogList != null);
        System.assertEquals(custLogList.size(), 3); 


        Test.stopTest();
    }
}