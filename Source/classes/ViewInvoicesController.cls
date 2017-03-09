public class ViewInvoicesController{    
    public String cableUnitName;
    public String cableUnitNumber;
    public String debitorNumber;
    public String kontonNumber;
    public Boolean pollChecker = true;
    private List<Invoice__c> invoicelist;
    private String startDate;
    private String endDate;
    public String strDate{set; get;}
    public String enDate{set; get;}
    private Boolean dataListFlag;
    private Boolean initialDataListFlag;
    private Boolean invoiceNotPresent;
    public Boolean paymentType{set; get;}
    public Integer pollValue=0;
    public String portalBrugerRole {get; set;}
    public String query;
    public String siteCoreUrl{get; set;}
    public String accountId{get;set;}//support-5377
    public Boolean renderSection{get;set;}//support-5377
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewInvoicesController','View invoices');
    public Boolean getDataListFlag(){
        return dataListFlag;
    }
    public Boolean getinitialDataListFlag(){
        return initialDataListFlag;
    }
    public Boolean getInvoiceNotPresent(){
        return invoiceNotPresent;
    }
    public String getStartDate(){
        return startDate;
    }
    public void setStartDate(String startDate){
        this.startDate = startDate;
    }
    public String getEndDate(){
        return endDate;
    }
    public void setEndDate(String endDate){
        this.endDate = endDate;
    }
    public Boolean getPollChecker() {
        system.debug('inside getPollChecker : '+pollChecker);
        return pollChecker;
    }
    public void setPollChecker(Boolean pollChecker){
        this.pollChecker = pollChecker;
    }
    public String getCableUnitName(){
        system.debug('### get cableUnitName ###' + cableUnitName);
        return cableUnitName;
    }
    public String getCableUnitNumber(){
        system.debug('### get cableUnitNumber ###' + cableUnitNumber);
        return cableUnitNumber;
    }
    public String getDebitorNumber(){
        system.debug('### get Debitornummer ###' + debitorNumber);
        return debitorNumber;
    }
    public String getKontonNumber(){
        system.debug('### get Kontonummer ###' + kontonNumber);
        return kontonNumber;
    }
    public ViewInvoicesController() { 
        try {
             portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
             siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
             cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
             accountId = ApexPages.CurrentPage().getParameters().get('accountId');
             Boolean cableUnitNotMatch = false;
             renderSection = true;
             List <Cable_Unit__c> cuList=[Select c.Legal_Account_No__r.customer_No__c, 
                                          c.Name, c.Payment_Account_No__r.customer_No__c from Cable_Unit__c c 
                                          where c.Cable_Unit_No__c =: cableUnitNumber limit 1];
              list<Account> accList = new list<Account>();
             accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
             if(!accList.isEmpty()){
            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
            if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
              }
             else{
             if(cuList.size() > 0){
                 cableUnitName = cuList[0].name;
                 debitorNumber = cuList[0].Payment_Account_No__r.customer_No__c;
                 //debitorNumber = '611472946';
                 kontonNumber = cuList[0].Legal_Account_No__r.customer_No__c;
                 // Before the Change
                 /*debitorNumber = cuList[0].Legal_Account_No__r.customer_No__c;
                 kontonNumber = cuList[0].Payment_Account_No__r.customer_No__c;*/
              }
              checkOnDataSyncInvoice();  
              }
             }
            else{
                renderSection=false;
            }
        }
            catch (Exception e) {
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
        } 
    }
     /**
     * This is the action which is called when the server evaluates the apex:page - action attribute. 
     * HttpCallout is done in the action instead of constructor so as to make it possible to write testmethod.
     */  
    public Pagereference fetchInvoiceListHttpCallout(){
        String body = '<?xml version="1.0" encoding="UTF-8"?>';
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        body += '<soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound">';
        body += '<OrganizationId>00DM0000000ARWB</OrganizationId><ActionId>04kM00000004CKaIAM</ActionId><SessionId xsi:nil="true"/>';
        body += '<EnterpriseUrl>https://cs7-api.salesforce.com/services/Soap/c/24.0/00DM0000000ARWB</EnterpriseUrl>';
        body += '<PartnerUrl>https://cs7-api.salesforce.com/services/Soap/u/24.0/00DM0000000ARWB</PartnerUrl>';
        body += '<sf:Id>a22M000000005OFIAY</sf:Id>';
        body += '<sf:CableUnitNo__c>0000001148</sf:CableUnitNo__c>';
        body += '</soapenv:Body>';
        body += '</soapenv:Envelope>';
        System.debug('** Body: #: ' + body);
        //HttpRequestUtil.makeHttpCall('InvoiceRequest',body);
        return null;
    }
    public List<Invoice__c> getinvoiceList() {
        return invoicelist; 
    }
    public PageReference checkOnDataSyncInvoice(){
        try {
                /*pollChecker = DataSyncUtil.pollDataSync(
                Apexpages.currentpage().getparameters().get('dataSyncLogId'), 'DataSync_Invoice__c');*/
                String query='Select i.Type__c, i.Payment_Date__c, i.Out__c, i.DisplayInvoice_No__c, i.Name,'+
                  'i.Invoice_Date__c, i.Invoice_Amount__c, i.In__c, i.Id, i.Due_Date__c,'+ 
                  'i.Building_No__c, i.Balance__c, i.Address__c, i.Daekker_No__c '+
                  'From Invoice__c i where Account_No__c =\''+ApexPages.CurrentPage().getParameters().get('accountTypeId')+'\'';
               query = query + ' order by i.Invoice_Date__c desc';
               // query = query + ' order by i.DateSorter__c desc';
                system.debug('Invoice no query'+query);
                List<Invoice__c> invList = DATABASE.query(query);
                if(invList != null && invList.size() > 0){
                	pollChecker = false;
                }else{
                	pollChecker = true;
                }
                if(pollChecker == false){
                    String invoiceNo;
                    for(Invoice__c invoice : invList){
                    	//Chnage for SC-433
                    	invoiceNo = invoice.DisplayInvoice_No__c;
                        System.debug('invoiceNo: '+invoiceNo);
                        /*
                        Date today = date.today();
                        Date todays = today - 547;
                        String previousDate = String.valueOf(todays);
                        system.debug('#previousDate#'+previousDate);
                        //Change for SC-373 comment if block
                        if(String.valueOf(invoice.Invoice_Date__c) >= previousDate){ 
                            invoiceNo = invoice.DisplayInvoice_No__c;
                            System.debug('invoiceNo: '+invoiceNo);
                        }*/
                    }
                    query='Select i.Type__c, i.Payment_Date__c, i.Out__c, i.DisplayInvoice_No__c, i.Sorted_Invoice_Number__c, i.Name,'+
                      'i.Invoice_Date__c, i.Invoice_Amount__c, i.In__c, i.Id, i.Due_Date__c,i.DateSorter__c,'+ 
                      'i.Building_No__c, i.Balance__c, i.Address__c, i.Daekker_No__c, i.Invoice_Payment_Type__c '+
                      'From Invoice__c i where Account_No__c =\''+ApexPages.CurrentPage().getParameters().get('accountTypeId')+'\''+ 'order by i.DateSorter__c desc'; 
                    invList = DATABASE.query(query);
                    invoicelist = new List<Invoice__c>();
                    paymentType = false;  
                    for(Invoice__c invoice : invList){
                    	if(invoice.Invoice_Payment_Type__c == 'PBS'){
                    		paymentType = true;
                    	}
                    	invoicelist.add(invoice);
                        /* Change implemented according to SC-433
                        if(Integer.valueOf(invoice.Sorted_Invoice_Number__c) >= Integer.valueOf(invoiceNo)){
                        	system.debug('#invoice.Daekker_No__c@@@#'+invoice.Daekker_No__c+'#invoiceNo#'+invoiceNo+'#invoice.DisplayInvoice_No__c#'+invoice.DisplayInvoice_No__c);
                            invoicelist.add(invoice);
                        }*/
                    }
                    System.debug('invoiceList.size(): '+invoiceList.size());
                    if(invoicelist != null && invoicelist.size() > 0){
                        dataListFlag = true;
                        initialDataListFlag = false;	
                    }else {
                        initialDataListFlag = true;
                        invoiceNotPresent = true;
                    }
                 }
                 System.debug('pollValue->'+pollValue);
                 if(pollValue == 5){
                    pollChecker = false;
                    ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Ingen fakturaer fundet...');
                    ApexPages.addMessage(debugMsg);
                }
                pollValue++;
        } catch (Exception e) {
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
        }        
        return null;
    }
    public PageReference findInvoices(){
    	try {
		        strDate = startDate;
		        enDate = endDate;
		        System.debug('#startDate#'+startDate+'#endDATe'+endDate);
	            invoicelist = DATABASE.query(createTestInvoiceQuery(startDate,endDate));
	            if(invoicelist.size()< 1){
	                system.debug('There is no invoice for the selected period. Refine your search Criteria.');
	                ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Der findes ingen fakturaer for den valgte periode. Prøv at ændre dine søgekriterier.');
	                ApexPages.addMessage(debugMsg);
	                dataListFlag=false;
	            }else {
	                //ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Denne konto er tilmeldt BetalingsService/PBS.');
	                //ApexPages.addMessage(debugMsg);	
	                System.debug('#Inside else condition#');
	            }
    	} catch (Exception e)   {
    		ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
            exceptionHandler.handleException(e,'findInvoices()',false,false,cableUnitNumber,'Medium');
            return null;
    	}        
            return null;
    }
    public String createTestInvoiceQuery(String inv_startDate,String inv_endDate){
    //private String createInvoiceQuery(String inv_startDate,String inv_endDate){
        try {
                query='Select i.Type__c, i.Payment_Date__c, i.Out__c, i.DisplayInvoice_No__c, i.Name,'+
                      'i.Invoice_Date__c, i.Invoice_Amount__c, i.In__c, i.Id, i.Due_Date__c,'+ 
                      'i.Building_No__c, i.Balance__c, i.Address__c, i.Daekker_No__c, i.DateSorter__c '+
                      'From Invoice__c i where Account_No__c =\''+ApexPages.CurrentPage().getParameters().get('accountTypeId')+'\'';
                      
                System.debug('Query'+query+'$Start Date$'+inv_startDate+'#End Date#'+inv_endDate);
                
                if(inv_startDate != null && inv_startDate.length() > 0 && inv_endDate !=null && inv_endDate.length() > 0){
                    System.debug('c');
                    query = query + ' and i.DateSorter__c >= ' + formatDate(inv_startDate) + ' and i.DateSorter__c <=' + formatDate(inv_endDate);
                    System.debug('Query1'+query);       
                }else if(inv_startDate != '' && inv_startDate.length() > 0){
                    System.debug('c');
                    query = query + ' and i.DateSorter__c >= ' + formatDate(inv_startDate); 
                    System.debug('Query2'+query);  
                }else if(inv_endDate != '' && inv_endDate.length() > 0){
                      system.debug('End date is less than start date.');
                      query = query + ' and i.DateSorter__c <= ' + formatDate(inv_endDate);
                      system.debug('End date is less than start date. Final Query'+query);
                      //ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Der findes ingen faktura i den valgte periode. Vælg en anden periode og tryk på "Søg".');
                      //ApexPages.addMessage(debugMsg);
                }
               //query = query + ' order by i.Sorted_Invoice_Number__c desc';
               query = query + ' order by i.DateSorter__c desc';
                System.debug('Query for Invoices123 --- '+query);
        } catch (Exception e) {
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
        }   
        return query;              
    }
    
    /* Commented not using
    public PageReference findInvoicesOld(){
        try {
                boolean errorFlag = true;
                strDate = startDate;
                enDate = endDate;
                System.debug('start Date'+ strDate + 'End Date'+enDate);
                Date toDate = date.today() - 547;
                String prevDate = String.valueOf(toDate);
                String[] prevarray = prevDate.split('-');
                Integer pd =  Integer.valueOf(prevarray[2]);
                Integer pm = Integer.valueOf(prevarray[1]);
                Integer py = Integer.valueOf(prevarray[0]);
                date pDate = date.newInstance(py,pm,pd);
                
                if(endDate != '' && startDate != ''){
                  String[] stringDate = startDate.split('\\.'); 
                  Integer d =  Integer.valueOf(stringDate[0]);
                  Integer m = Integer.valueOf(stringDate[1]);
                  Integer y = Integer.valueOf(stringDate[2]);
                  date sDate = date.newInstance(y,m,d); 
                  stringDate = endDate.split('\\.');
                  d =  Integer.valueOf(stringDate[0]);
                  m = Integer.valueOf(stringDate[1]);
                  y = Integer.valueOf(stringDate[2]);
                  date eDate = date.newInstance(y,m,d);      
                  if(eDate < sDate){
                    system.debug('End date is less than start date.');
                    ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Der findes ingen faktura i den valgte periode. Vælg en anden periode og tryk på "Søg".');
                    ApexPages.addMessage(debugMsg);
                    dataListFlag=false;
                    errorFlag = false;
                  }
                  if(pDate > sDate){
                    String previousMonth = pm + '';
                    String previousDate = pd + ''; 
                    if(previousMonth.trim().length() > 1 && previousDate.trim().length() > 1)
                        startDate = pd + '.' + pm + '.' + py;
                    else if(previousMonth.trim().length() == 1 && previousDate.trim().length() == 1)
                        startDate = '0'+pd + '.' + '0'+pm + '.' + py;
                    else if(previousMonth.trim().length() > 1 && previousDate.trim().length() == 1)
                        startDate = '0'+pd + '.' + pm + '.' + py;   
                    else if(previousMonth.trim().length() == 1 && previousDate.trim().length() > 1)
                        startDate = pd + '.' + '0'+pm + '.' + py;
                  }
                }else if(endDate != '' && startDate == ''){
                    String[] stringDate = endDate.split('\\.'); 
                    Integer d =  Integer.valueOf(stringDate[0]);
                    Integer m = Integer.valueOf(stringDate[1]);
                    Integer y = Integer.valueOf(stringDate[2]);
                    date eDate = date.newInstance(y,m,d);
                    if(eDate > pDate){
                        String previousMonth = pm + '';
                        String previousDate = pd + ''; 
                        if(previousMonth.trim().length() > 1 && previousDate.trim().length() > 1)
                            startDate = pd + '.' + pm + '.' + py;
                        else if(previousMonth.trim().length() == 1 && previousDate.trim().length() == 1)
                            startDate = '0'+pd + '.' + '0'+pm + '.' + py;
                        else if(previousMonth.trim().length() > 1 && previousDate.trim().length() == 1)
                            startDate = '0'+pd + '.' + pm + '.' + py;   
                        else if(previousMonth.trim().length() == 1 && previousDate.trim().length() > 1)
                            startDate = pd + '.' + '0'+pm + '.' + py;   
                    }else{
                       ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Der findes ingen faktura i den valgte periode. Vælg en anden periode og tryk på "Søg".');
                       ApexPages.addMessage(debugMsg);
                       dataListFlag=false;
                       errorFlag = false;
                    }
                }else if(startDate != ''){
                    String[] stringDate = startDate.split('\\.');   
                    Integer d =  Integer.valueOf(stringDate[0]);
                    Integer m = Integer.valueOf(stringDate[1]);
                    Integer y = Integer.valueOf(stringDate[2]);
                    date sDate = date.newInstance(y,m,d);   
                    
                    if(pDate > sDate){
                        String previousMonth = pm + '';
                        String previousDate = pd + ''; 
                        if(previousMonth.trim().length() > 1 && previousDate.trim().length() > 1)
                            startDate = pd + '.' + pm + '.' + py;
                        else if(previousMonth.trim().length() == 1 && previousDate.trim().length() == 1)
                            startDate = '0'+pd + '.' + '0'+pm + '.' + py;
                        else if(previousMonth.trim().length() > 1 && previousDate.trim().length() == 1)
                            startDate = '0'+pd + '.' + pm + '.' + py;   
                        else if(previousMonth.trim().length() == 1 && previousDate.trim().length() > 1)
                            startDate = pd + '.' + '0'+pm + '.' + py;   
                    } 
                }
                if(errorFlag){   
                    System.debug('start Date'+ strDate + 'End Date'+enDate);
                    String query = createInvoiceQuery(startDate,endDate);
                    //query = query + ' order by i.Invoice_Date__c desc';
                    //query = query + ' order by i.DisplayInvoice_No__c desc';
                    List<Invoice__c> invList = DATABASE.query(query);
                    String invoiceNo;
                    
                    for(Invoice__c invoice : invList){
                        Date today = date.today();
                        Date todays = today - 547;
                        String previousDate = String.valueOf(todays);
                        System.debug('previousDate: '+previousDate);
                        if(String.valueOf(invoice.Invoice_Date__c) >= previousDate){ 
                            invoiceNo = invoice.DisplayInvoice_No__c;
                            System.debug('invoiceNo: '+invoiceNo);
                        }
                    }
                    
                    System.debug('******');
                    query = createInvoiceQuery(startDate,endDate);
                    
                    invList = DATABASE.query(query);
                    System.debug('invList.size(): '+invList.size());
                    invoicelist = new List<Invoice__c>();  
                    for(Invoice__c invoice : invList){
                        if(Integer.valueOf(invoice.Sorted_Invoice_Number__c) >= Integer.valueOf(invoiceNo)){
                            System.debug('invoice id: '+invoice.id);
                            invoicelist.add(invoice);
                        }
                    }
                    
                    System.debug('***Value of invoice list***'+invoicelist+'Size of invoice list'+invoicelist.size());
                    if(invoicelist.size()< 1){
                        system.debug('There is no invoice for the selected period. Refine your search Criteria.');
                        ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Der findes ingen faktura i den valgte periode. Vælg en anden periode og tryk på "Søg".');
                        ApexPages.addMessage(debugMsg);
                        dataListFlag=false;
                    }else {
                        System.debug('Inside else condition');
                    }
                }    
                return null;
        } catch (Exception e)   {
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
            return null;
        }        
            return null;
    } */
    public String createInvoiceQuery(String inv_startDate,String inv_endDate){
    //private String createInvoiceQuery(String inv_startDate,String inv_endDate){
        try {
                query='Select i.Type__c, i.Payment_Date__c, i.Out__c, i.Sorted_Invoice_Number__c, i.DisplayInvoice_No__c, i.Name,'+
                      'i.Invoice_Date__c, i.Invoice_Amount__c, i.In__c, i.Id, i.Due_Date__c,'+ 
                      'i.Building_No__c, i.Balance__c, i.Address__c, i.Daekker_No__c '+
                      'From Invoice__c i where Account_No__c =\''+ApexPages.CurrentPage().getParameters().get('accountTypeId')+'\'';
                System.debug('Query'+query);
                if(inv_startDate == '' && inv_endDate == ''){
                    System.debug('a');
                    String formattedSysDate = String.valueOf(date.today());
                    Date today = date.today();
                    Date todays = today - 547;
                    String previousDate = String.valueOf(todays);
                    //query = query + ' and i.Invoice_Date__c >= ' + previousDate + ' and i.Invoice_Date__c <=' + formattedSysDate;
                }else if(inv_startDate != '' && inv_endDate != ''){
                    System.debug('b');
                    query = query + ' and i.Invoice_Date__c >= ' + formatDate(inv_startDate) + ' and i.Invoice_Date__c <=' + formatDate(inv_endDate);
                    System.debug('Query1'+query);       
                }else if(inv_startDate != '' && inv_startDate.length() > 0){
                    System.debug('c');
                    query = query + ' and i.Invoice_Date__c >= ' + formatDate(inv_startDate); 
                    System.debug('Query2'+query);  
                }else if(inv_endDate != '' && inv_endDate.length() > 0){
                      system.debug('End date is less than start date.');
                      ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Der findes ingen faktura i den valgte periode. Vælg en anden periode og tryk på "Søg".');
                      ApexPages.addMessage(debugMsg);
                }
                query = query + ' order by i.Sorted_Invoice_Number__c desc';
                System.debug('Query for Invoices123 --- '+query);
        } catch (Exception e) {
            ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_commonError);
            ApexPages.addMessage(debugMsg);
        }   
        return query;              
    }
    // This method takes dateString in dd-mm-yyyy and converts to yyyy-dd-mm
    private String formatDate(String invoiceDate){
        System.debug('List of invoice data'+invoiceDate);
        String[] dateLiterals = invoiceDate.split('\\.');
        return dateLiterals[2]+'-'+dateLiterals[1]+'-'+dateLiterals[0];
    }
    public PageReference cancel(){
    	//Changed for SC-22
        /*String newPageUrl = '/apex/ViewInvoiceGeneral';
        PageReference newPage = new PageReference(newPageUrl); */
        PageReference newPage = Page.ViewInvoiceGeneral;
        newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
        newPage.getParameters().put(contactConstClass.ACCOUNTID, ApexPages.CurrentPage().getParameters().get('accountId'));
        newPage.getParameters().put('dataSyncLogId',apexpages.currentpage().getparameters().get('dataSyncLogId'));
        newPage.setRedirect(true);
        return newPage;
    }
    /*public PageReference backToInvoicesPage(){
            String newPageUrl = 'apex/ViewInvoices';
            PageReference newPage = new PageReference(newPageUrl);
            //newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
            /*newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
            newPage.getParameters().put(contactConstClass.ACCOUNTID, ApexPages.currentPage().getParameters().get('accountId'));
            newPage.getParameters().put('dataSyncLogId',ApexPages.currentpage().getParameters().get('dataSyncLogId'));
            //newPage.setRedirect(true);
            //return newPage;
        
     }*/ 
    public PageReference backToInvoicesPage(){
    	//Changed for SC-22
        /*String newPageUrl = '/apex/ViewInvoices';
        PageReference newPage = new PageReference(newPageUrl);*/
        PageReference newPage = Page.ViewInvoices;
        newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
        /*newPage.getParameters().put('cableunitnumber',ApexPages.CurrentPage().getParameters().get(contactConstClass.CABLEUNITNUMBER));
        newPage.getParameters().put(contactConstClass.ACCOUNTID, ApexPages.currentPage().getParameters().get('accountId'));
        newPage.getParameters().put('dataSyncLogId',ApexPages.currentpage().getParameters().get('dataSyncLogId'));*/
        newPage.setRedirect(true);
        return newPage;
    }
        //return Page.ViewInvoices;
}