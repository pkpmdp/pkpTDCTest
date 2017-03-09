public with sharing class clsMobilBBForbrug {
    public MobbUsage customerUsage;
    public Customer customer;
    public List<Usage> customerDailyUsage;
    private String usageDataXmlResponse;
    private Account account{get;set;}
    List<Usage> dailyUsages = new List<Usage>();
    List<Usage> previousUsages = new List<Usage>();

    public String getMaxLimitFormatted(){
        if(customerUsage!=null && customerUsage.maxLimit!=null){
            return Decimal.valueOf(customerUsage.maxLimit).format();
        }
        return '';
    }
    
    public String getCurrentMonthTotalFormatted(){
        if(customerUsage!=null && customerUsage.currentMonthTotalUsage!=null && customerUsage.currentMonthTotalUsage.total!=null){
            return Decimal.valueOf(customerUsage.currentMonthTotalUsage.total).format();
        }
        return '';
    }

    public clsMobilBBForbrug(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
    }
    
    public MobbUsage getCustomerUsage() {
        if(this.customerUsage == null) {
            MobbUsage customerUsage = new MobbUsage();
            if(this.account.Customer_No__c != null) {
                this.usageDataXmlResponse  = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.MOBILEBB_METHOD, this.account.Customer_NO__c);
                //this.usageDataXmlResponse = '<Response xmlns="http://yousee.dk/mobb"><MobbUsage><Max_Limit>5000000000</Max_Limit><MSISDN>29833140</MSISDN><CurrentMonthTotalUsage><DOWNLOAD>620774</DOWNLOAD><UPLOAD>57127</UPLOAD><TOTAL>677911</TOTAL><UseTime>2010-08-23T00:00:00</UseTime></CurrentMonthTotalUsage><CurrentMonthDailyUsage><DOWNLOAD>4593</DOWNLOAD><UPLOAD>1835</UPLOAD><TOTAL>6428</TOTAL><UseTime>2010-08-01T00:00:00</UseTime></CurrentMonthDailyUsage>'+
//'<CurrentMonthDailyUsage><DOWNLOAD>21579</DOWNLOAD><UPLOAD>3174</UPLOAD><TOTAL>24754</TOTAL><UseTime>2010-08-03T00:00:00</UseTime></CurrentMonthDailyUsage><CurrentMonthDailyUsage><DOWNLOAD>47186</DOWNLOAD><UPLOAD>3741</UPLOAD><TOTAL>50927</TOTAL><UseTime>2010-08-07T00:00:00</UseTime></CurrentMonthDailyUsage><PreviousThreeMonthsUsage><DOWNLOAD>1962303</DOWNLOAD><UPLOAD>211531</UPLOAD><TOTAL>2173848</TOTAL><UseTime>2010-08-31T00:00:00</UseTime></PreviousThreeMonthsUsage></MobbUsage></Response>';
                this.customerUsage = parseUsageDatas2(usageDataXmlResponse);
                this.customer = parseCustomer(usageDataXmlResponse);                
            }
        }
        return this.customerUsage;
    }
    
    private String callout(String endpoint, String body) {
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
    
    private MobbUsage parseUsageDatas2(String XmlResponse) { 
        MobbUsage usages = new MobbUsage();      
        if(XmlResponse == null) return usages;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'MobbUsage') {
                        break;
                    }   
                } else {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'MobbUsage') {
                            MobbUsage monthUsage = parseUsage(reader);
                            usages = monthUsage;
                        }
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing XML File: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return usages;
        }
        return usages;
    }
    
    private Customer parseCustomer(String XmlResponse) { 
        Customer customer = new Customer(); 
        if(XmlResponse == null) return customer;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);     
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'CustomerInfo') {
                        break;
                    }   
                } else {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'CustomerNr') {
                        reader.next();
                        customer.setCustomerNo(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'Product') {
                        reader.next();
                       customer.setProduct(checkEmptyElement(reader));
                    } 
                }  
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing XML File: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return customer;
        }
        return customer;
    }
    
    public String getDailyUsage() {
        GoogleViz gv = new GoogleViz();
        Integer i=0;
        gv.cols = new list<GoogleViz.col> {
            new GoogleViz.Col('Dato','Dato','String'),
            new GoogleViz.Col('Forbrug','Forbrug i GB','number')
        };
        
        List<GoogleViz.row> row = new List<GoogleViz.row>();
        if(customerUsage != null && customerUsage.currentMonthDailyUsage != null){
            if(customerUsage.currentMonthDailyUsage.size() != 0) {
                for(i=0; i<customerUsage.currentMonthDailyUsage.size();i++) {
                    GoogleViz.row grow = new GoogleViz.row();
                    grow.cells.add(new GoogleViz.cell(customerUsage.currentMonthDailyUsage[i].useTime));
                    grow.cells.add(new GoogleViz.cell(customerUsage.currentMonthDailyUsage[i].total));
                    gv.addRow(grow);
                }
            }
        }
        if(gv.rowCollection.size() != 0){
            System.debug('google column bar' + gv.toJsonString());
            return gv.toJsonString();
        }   
        else return ''; 
    } 
    
    public String getPreviousThreeMonthsUsage() {
        GoogleViz gv = new GoogleViz();
        Integer i=0;
        gv.cols = new list<GoogleViz.col> {
            new GoogleViz.Col('Dato','Dato','String'),
            new GoogleViz.Col('Forbrug','Forbrug i GB','number')
        };
        
        List<GoogleViz.row> row = new List<GoogleViz.row>();
        if(customerUsage != null && customerUsage.previousThreeMonthsUsage != null){
            if(customerUsage.previousThreeMonthsUsage.size() != 0) {
                for(i=0; i<customerUsage.previousThreeMonthsUsage.size();i++) {
                    GoogleViz.row grow = new GoogleViz.row();
                    grow.cells.add(new GoogleViz.cell(customerUsage.previousThreeMonthsUsage[i].useMonth));
                    grow.cells.add(new GoogleViz.cell(customerUsage.previousThreeMonthsUsage[i].total));
                    gv.addRow(grow);
                }
            }
        }
        if(gv.rowCollection.size() != 0){
            System.debug('google column bar' + gv.toJsonString());
            return gv.toJsonString();
        }   
        else return ''; 
    }       
    
    private MobbUsage parseUsage(XmlStreamReader reader) {
        MobbUsage usage= new MobbUsage();     
        while(reader.hasNext()) {
            System.debug('wen xml debug 1'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'MobbUsage') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Max_Limit') {
                        reader.next();
                        usage.setMaxLimit(convertByteToGBDecimal(reader));
                        usage.setUsageLimit(convertByteToMB(reader));
                    } else if (reader.getLocalName() == 'MSISDN') {
                        reader.next();
                        usage.setMSISDN(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'UsageStatus') {
                        reader.next();
                        usage.setStatus(checkEmptyElement(reader));
                    }else if (reader.getLocalName() == 'PreviousThreeMonthsUsage') {
                        System.debug('hello i am here to get previous');
                        usage.setPreviousThreeMonthsUsage(getPreviousThreeMonthsUsages(reader));
                    } else if (reader.getLocalName() == 'CurrentMonthTotalUsage') {
                        usage.setCurrentMonthTotalUsage(getCurrentMonthTotalUsage2(reader));
                    } else if (reader.getLocalName() == 'CurrentMonthDailyUsage') {
                        System.debug('hello i am here to get daily Usage');
                        usage.setCurrentMonthDailyUsage(getCurrentMonthDailyUsages(reader));
                    }             
                }  
            }
            reader.next();
        }
        usage.setPercentageUsage();
        return usage;
    }
    
    private Usage getCurrentMonthTotalUsage2(XmlStreamReader reader) {
        Usage usage = new Usage();
        while(reader.hasNext()) {
            System.debug('wen xml debug 21'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'CurrentMonthTotalUsage') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'DOWNLOAD') {
                        reader.next();
                        usage.setDownload(convertkByteToMB(reader));
                    } else if (reader.getLocalName() == 'UPLOAD') {
                        reader.next();
                        usage.setUpload(convertkByteToMB(reader));
                    } else if (reader.getLocalName() == 'TOTAL') {
                        reader.next();
                        usage.setTotal(convertkByteToMB(reader));
                        usage.setPercentageUsageTotal(convertkByteToMB(reader));
                    } else if (reader.getLocalName() == 'UseTime') {
                        reader.next();
                        usage.setUseTime(checkEmptyElement(reader));
                    }
                }
            }
            reader.next();
        }
        return usage;   
    }
    
    List<Usage> usages = new List<Usage>();
    private List<Usage> getCurrentMonthDailyUsages(XmlStreamReader reader) {        
        try {
            while(reader.hasNext()) {
                System.debug('wen xml debug 22'+reader.getEventType()+reader.getLocalName());
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'CurrentMonthDailyUsage') {
                        break;
                    }   
                } else { 
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'CurrentMonthDailyUsage') {
                            Usage usage = parseCurrentMonthDailyUsage(reader);
                            dailyUsages.add(usage);
                        }
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing daily usage: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return dailyUsages;
        }
        System.debug('the size of daily usages are'+usages.size());
        return dailyUsages;
    }
    
    private List<Usage> getPreviousThreeMonthsUsages(XmlStreamReader reader) {
        System.debug('hello i am here to parse  three months');
        try {
            while(reader.hasNext()) {
                System.debug('wen xml debug 23'+reader.getEventType()+reader.getLocalName());
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'PreviousThreeMonthsUsage') {
                        break;
                    }   
                } else {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'PreviousThreeMonthsUsage') {
                            Usage usage = parsePreviousThreeMonthsUsage(reader);
                            previousUsages.add(usage);
                        }
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing three months usage: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return previousUsages;
        }
        System.debug('the size of previous three months usages are'+usages.size());
        return previousUsages;
    }
        
    private Usage parseCurrentMonthDailyUsage(XmlStreamReader reader) {
        Usage usage= new Usage();     
        while(reader.hasNext()) {
            System.debug('wen xml debug 221'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'MUsage') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'DOWNLOAD') {
                        reader.next();
                        usage.setDownload(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'UPLOAD') {
                        reader.next();
                        usage.setUpload(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'TOTAL') {
                        reader.next();
                        usage.setTotal(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'UseTime') {
                        reader.next();
                        usage.setUseTime(splitDateTime(reader));
                    }
                }
            }
            reader.next();
        }
        return usage;  
    }
    
    private Usage parsePreviousThreeMonthsUsage(XmlStreamReader reader) {
        Usage usage= new Usage();     
        while(reader.hasNext()) {
            System.debug('wen xml debug 231'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'MUsage') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'DOWNLOAD') {
                        reader.next();
                        usage.setDownload(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'UPLOAD') {
                        reader.next();
                        usage.setUpload(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'TOTAL') {
                        reader.next();
                        usage.setTotal(convertkByteToGB(reader));
                    } else if (reader.getLocalName() == 'UseTime') {
                        reader.next();
                        usage.setUseTime(splitDateTime(reader));
                    } else if (reader.getLocalName() == 'UseMonth') {
                        reader.next();
                        usage.setUseMonth(checkEmptyElement(reader));
                    }
                }
            }
            reader.next();
        }
        return usage;  
    }
    
    public class Customer {
        public  String customerNo;
        public String product;
        public void setCustomerNo(String customernr) {
            customerNo = customernr;
        }
        public String getCustomerNo() {
            return customerNo;
        }
        public void setProduct(String productName) {
            product = productName;
        }
        public String getProduct() {
            return product;
        }
    }
    
    public class MobbUsage {
        private Double maxLimit {get;set;}
        private Double usageLimit;
        private Usage currentMonthTotalUsage {get;set;} 
        private List<Usage> currentMonthDailyUsage {get;set;}
        private List<Usage> previousThreeMonthsUsage{get;set;}
        private String MSISDN {get;set;}
        private String percentageUsage;
        private String status;
        
        public void setStatus(String usageStatus) {
            status = usageStatus;
        }
        
        public String getStatus() {
            return status;
        }
        
        public void setMaxLimit(Double a) {
            maxLimit = a;
        }
        public Double getMaxLimit(){
            return maxLimit;
        }
        public void setUsageLimit(Double a) {
            usageLimit = a;
        }
        public Double getUsageLimit(){
            return usageLimit;
        }
        public void setPercentageUsage() {
            if(usageLimit != Double.valueOf('0')) {
                //percentageUsage = ((((currentMonthTotalUsage.getPercentageUsageTotal()/usageLimit))*100)*100.00).intValue()/100.00 + '%';
                percentageUsage = (Decimal.valueOf((currentMonthTotalUsage.getPercentageUsageTotal()/usageLimit)*100)).setScale(2).format() + ' %';
                System.debug('percentageusage'+percentageUsage);
            }
        }
        public String getPercentageUsage(){
            return percentageUsage;
        }
        public void setCurrentMonthTotalUsage(Usage usage) {
            currentMonthTotalUsage = usage;
        }
        public Usage getCurrentMonthTotalUsage() {
            return currentMonthTotalUsage;
        }
        public void setCurrentMonthDailyUsage(List<Usage> usage) {
            currentMonthDailyUsage = usage;
        }
        public List<Usage> getCurrentMonthDailyUsage() {
            return currentMonthDailyUsage;
        }
        public void setPreviousThreeMonthsUsage(List<Usage> usage) {
            previousThreeMonthsUsage = usage;
        }
        public void setMSISDN(String a) {
            MSISDN = a;
        }
    }
    
    public class Usage {
        private Double download{get;set;}
        private Double upload{get;set;}
        private Double total{get;set;}
        private Double percentageUsageTotal;
        private String useTime;
        private String useMonth;
        
        public void setDownload(Double a) {
            download = a;
        }
        public void setPercentageUsageTotal(Double put) {
            percentageUsageTotal = put;
        }
        public Double getPercentageUsageTotal() {
            return percentageUsageTotal;
        }
        public Double getDownload() {
            return download;
        }
        public void setUpload(Double a) {
            upload = a;
        }
        public Double getUpload() {
            return upload;
        }
        public void setTotal(Double a) {
            total = a;
        }
        public Double getTotal() {
            return total;
        }
        public String getUseTime() {
            return useTime;
        }
        public void setUseTime(String dt) {
            useTime = dt;
        }
        public String getUseMonth() {
            return useMonth;
        }
        public void setUseMonth(String um) {
            useMonth = um;
        }
    }
    
     private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    } 

    private Double convertkByteToGB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1048576.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
    }

    private Double convertkByteToMB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Double.valueof(reader.getText())/1024.0*100.00);              
            return (myDouble.intValue()/100.00);
        } else
        return 0;
    }
   
    private Double convertByteToGB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1073741824.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }
   
    private Double convertByteToMB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Double.valueof(reader.getText())/1048576.0*100.00);              
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }

    private Double convertByteToGBDecimal(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1000000000.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }
   
   private String splitDateTime(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            String[] dateS = reader.getText().split('T');
            return dateS[0];
        } else 
            return '';  
   }
   
   public Customer getCustomer() {
     return this.customer;
   } 
   
   public void setCustomer(customer myCustomer) {
    this.customer = myCustomer;
   }
   static testMethod void testDisplayMobb() {
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
       	Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '5436789';
       	acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsMobilBBForbrug controller = new clsMobilBBForbrug(sc);
        controller.usageDataXmlResponse = '<Response xmlns="http://yousee.dk/mobb"><MobbUsage><Max_Limit>5000000000</Max_Limit><MSISDN>29833140</MSISDN><CurrentMonthTotalUsage><DOWNLOAD>620774</DOWNLOAD><UPLOAD>57127</UPLOAD><TOTAL>677911</TOTAL><UseTime>2010-08-23T00:00:00</UseTime></CurrentMonthTotalUsage><CurrentMonthDailyUsage><MUsage><DOWNLOAD>4593</DOWNLOAD><UPLOAD>1835</UPLOAD><TOTAL>6428</TOTAL><UseTime>2010-08-01T00:00:00</UseTime></MUsage></CurrentMonthDailyUsage>'+
		'<CurrentMonthDailyUsage><MUsage><DOWNLOAD>21579</DOWNLOAD><UPLOAD>3174</UPLOAD><TOTAL>24754</TOTAL><UseTime>2010-08-03T00:00:00</UseTime></MUsage></CurrentMonthDailyUsage><CurrentMonthDailyUsage><MUsage><DOWNLOAD>47186</DOWNLOAD><UPLOAD>3741</UPLOAD><TOTAL>50927</TOTAL><UseTime>2010-08-07T00:00:00</UseTime></MUsage></CurrentMonthDailyUsage><PreviousThreeMonthsUsage><MUsage><DOWNLOAD>1962303</DOWNLOAD><UPLOAD>211531</UPLOAD><TOTAL>2173848</TOTAL><UseTime>2010-08-31T00:00:00</UseTime><UseMonth>08-2010</UseMonth></MUsage></PreviousThreeMonthsUsage></MobbUsage></Response>';
        controller.customerUsage = controller.parseUsageDatas2(controller.usageDataXmlResponse);
        System.assertEquals(controller.customerUsage, controller.getCustomerUsage());
        System.assertEquals(true, controller.getDailyUsage()!= '');
        System.assertEquals(true, controller.getPreviousThreeMonthsUsage() != '');
   }
   
}