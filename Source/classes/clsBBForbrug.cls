public with sharing class clsBBForbrug {
    private BBUsageAbstract customerUsage;
    private String threeMonthsUsageDataXmlResponse;
    private Account account{get;set;}
    
    private List <BBUsageInterface> bbUsagesList = new List<BBUsageInterface>();
    private List <BBUsageInterface> previousThreeMonthsUsage = new BBUsageInterface[3];
    private List<UsageInterface> customerDailyUsages; 
    
    public virtual interface BBInterface{
        Double getTotal();
    }        
    public virtual interface BBUsageInterface extends BBInterface{ 
       String getMonth();
    }       
    public abstract class BBUsageAbstract  implements BBUsageInterface {
        public Integer month {get;set;}
        public List<Usage> dailyUsages = new List<Usage>();  
        public String fromDate {
            get { return fromDate; }
            set {  fromDate = value;
                   month = Date.valueOf(fromDate).month(); }
        }
        public virtual Integer getMaxDays(){
            Date dt = Date.valueOf(fromDate);
            return Date.daysInMonth(dt.year(),dt.month()); 
        }
    }
    public class BBUsageEmpty extends BBUsageAbstract{
        
        public virtual String getMonth (){
            return getMonthAsString(month);
        }
        
        public virtual Double getTotal(){
            return 0.0;         
        }
    }    
    public class BBUsage extends BBUsageAbstract {
        public String toDate {get;set;}
        public Long DownInKB {get;set;}
        public Long UpInKB {get;set;}
        public Long youseeForbrugInKb {get;set;}    

        public virtual String getMonth (){
            return getMonthAsString(month);
        }
        
        public virtual Double getTotal(){
            /** DownInKB + UpInKB - youseeForbrugInKb */
            return convertkByteToGB(DownInKB + UpInKB - youseeForbrugInKb);         
        }
                
        public override Integer getMaxDays(){
            return  Date.valueOf(toDate).day();
        }
        
    }    
    public virtual interface UsageInterface extends BBInterface{ 
       String getDay();
    }    
    public class UsageEmpty implements UsageInterface{
        
        public Integer day {get;set;}
        
        public virtual String getDay(){
            return String.valueOf(day);
        }
        
        public virtual Double getTotal(){
            return 0.0;         
        }
    }    
    public class Usage implements UsageInterface {
        public Integer day {get;set;}    
        public String macAdr {get;set;}
        public String modemId {get;set;}
        public String dateOfRegistration {
            get { return dateOfRegistration; }
            set {  dateOfRegistration = value;
                   day = Date.valueOf(dateOfRegistration).day(); }
        }
        public Long useOfDownloadInKB {get;set;}
        public Long useOfUploadInKB {get;set;}
        public String useOfTrafficTypemailKB {get;set;}
        public String useOfTypeBrowserInKB {get;set;}
        public String useOfTrafficTypeSkypeKB {get;set;}
        public String useOfTrafficTypeMsnKB {get;set;}
        public String useOfTraffixOtherVoipKB {get;set;}
        public String useOfTrafficTypePtpKB {get;set;}
        public Long useOfYouSeePlayKB {get;set;}
        public Long useOfYouSeeWebTvKB {get;set;}
        public Long useOfYouSeeMailKB {get;set;}
        public String useOfOtherStreamingKB {get;set;}
        public String useOfGamingKB {get;set;}
        public String useOfOtherKB {get;set;}
        public String useOfYouseeVoipKB{get;set;}    
            
        public virtual Double getTotal(){
            /** Dayly usage is (forbruglistType): 
            (useOfDownloadInKB+useOfUploadInKB)-
                (useOfYouSeePlayKB+useOfYouSeeWebTvKB+useOfYouSeeMailKB) 
            */          
            return  convertkByteToGB(useOfDownloadInKB+useOfUploadInKB-
                useOfYouSeePlayKB+useOfYouSeeWebTvKB+useOfYouSeeMailKB);            
        }
        
        public virtual String getDay(){
            return String.valueOf(day);
        }       
    }
    
    public clsBBForbrug(ApexPages.StandardController controller) {
          
        this.account = (Account) controller.getRecord();           
        getCustomerUsage();
              
    }
    
    /*      
    public String getMaxLimit(){
        return ApexPages.currentPage().getParameters().get('maxLimit');
    }
    */
    public String getUsage(){
        return ApexPages.currentPage().getParameters().get('usage');
    }
    /*
    public String getPercentUse(){
        return ApexPages.currentPage().getParameters().get('percentUse');
    }
    */
    public String getProductName(){
        return ApexPages.currentPage().getParameters().get('productName');
    }
        
    private String getThisPeriod(){
        DateTime dt = DateTime.now();
        return dt.format('yyyy-MM');
    }
        
    public BBUsageAbstract getCustomerUsage() {
            
        if(this.customerUsage == null) {
            this.customerUsage = new BBUsage();
                      
            if(this.account.Customer_No__c != null) {
                String period = getThisPeriod();
                        
                String callThreeMonthlyUsage=clsConnectionUtils.END_POINT+
                'getBBForbrugRest/RestBBForbrugService/BBforbrug/customerId/' + 
                this.account.Customer_NO__c + '/'+period+'/lastThree';                
                this.threeMonthsUsageDataXmlResponse =  callout(callThreeMonthlyUsage,null);
                parseForbrug(threeMonthsUsageDataXmlResponse);
                setUsages();                            
            }
        }
        return this.customerUsage;
    }
    
    private void setUsages(){
        //If xml response is emtpy
        if (bbUsagesList.size() == 0){
            //Create one empty usage
            DateTime dt = DateTime.now();
            BBUsageEmpty emptyUsage = new BBUsageEmpty();
            emptyUsage.fromDate = dt.format('yyyy-MM-dd');
            bbUsagesList.add(emptyUsage);
        }
        this.customerUsage = (BBUsageAbstract)bbUsagesList.remove(0);
        setDays();
        Integer k = bbUsagesList.size()-1;
        Integer z = 0;
        Integer actualMonth = this.customerUsage.month;
        for(Integer i=0; i<3 ; i++) {
                actualMonth = actualMonth - 1;
                if ( actualMonth <=0 ){
                    actualMonth = 12 - actualMonth;
                }
                if (z > k) {//no other value
                    setEmptyMonth(i,actualMonth);
                }else{
                    BBUsage bbUsage = (BBUsage)bbUsagesList.get(z);
                    if (bbUsage.month == actualMonth){
                        previousThreeMonthsUsage.set(i,bbUsage);
                        z=z+1;
                    }else{
                        setEmptyMonth(i,actualMonth);
                    }
                }
        }   

    }
    
    private void setEmptyMonth(Integer position, Integer actualMonth){
        BBUsageEmpty bbUsageEmpty = new BBUsageEmpty();
        bbUsageEmpty.month = actualMonth;
        previousThreeMonthsUsage.set(position,bbUsageEmpty);
    }
    
    private void setDays(){
        customerDailyUsages = new UsageInterface[this.customerUsage.getMaxDays()];
        Integer k = this.customerUsage.dailyUsages.size()-1; //index of last value
        Integer z = 0; //index of actual value
        Integer actualDay = 1;
        for(Integer i=0; i<customerDailyUsages.size() ; i++) {
                if (z > k) {//no other value
                    setEmptyDay(i,actualDay);
                }else{
                    Usage usage = (Usage)customerUsage.dailyUsages.get(z);
                    if (usage.day == actualDay){
                        customerDailyUsages.set(i,usage);
                        z=z+1;
                    }else{
                        setEmptyDay(i,actualDay);
                    }
                }
                actualDay = actualDay + 1;
                //system.debug('k='+ k );
                //system.debug('z='+z );
                //system.debug('actualDay' +actualDay );    
        }       
    }
        
    private void setEmptyDay(Integer position, Integer actualDay){
        UsageEmpty usageEmpty = new UsageEmpty();
        usageEmpty.day = actualDay;
        customerDailyUsages.set(position,usageEmpty);
    }
    
    
    private String callout(String endpoint, String body) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setTimeout(15000);        
        req.setHeader('Content-type', 'text/html; charset=utf-8');    
        req.setBody((body == null ? '' : body));        
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
                return response;                
            }           
        }
        return null;    
    }
    
    private void parseForbrug(String XmlResponse){
        if(XmlResponse == null || XmlResponse == '' ) return ;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'forbrug') {
                            BBUsage usages = parseUsage(reader);
                            bbUsagesList.add(usages);
                           }
                    }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing XML File: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
        }
    }
       
    public String getDailyUsageGraph() {
        GoogleViz gv = new GoogleViz();
        Integer i=0;
        gv.cols = new list<GoogleViz.col> {
            new GoogleViz.Col('Dato','Dato','string'),
            new GoogleViz.Col('Forbrug','Forbrug i GB','number')
        };
        
        //List<GoogleViz.row> row = new List<GoogleViz.row>();
        if(customerDailyUsages != null ){
            if(customerDailyUsages.size() != 0) {
                for(i=0; i<customerDailyUsages.size();i++) {
                    GoogleViz.row grow = new GoogleViz.row();
                    grow.cells.add(new GoogleViz.cell(customerDailyUsages[i].getDay()));
                    grow.cells.add(new GoogleViz.cell(customerDailyUsages[i].getTotal()));
                    gv.addRow(grow);
                }
            }
        }
        //if(gv.rowCollection.size() != 0){
        //System.debug('DailyUsageGraph google column bar' + gv.toJsonString());
        return gv.toJsonString();
        //}   
        //else return ''; 
    } 

    public String getPreviousThreeMonthsUsage() {
        GoogleViz gv = new GoogleViz();
        Integer i=0;
        gv.cols = new list<GoogleViz.col> {
            new GoogleViz.Col('Dato','Dato','string'),
            new GoogleViz.Col('Forbrug','Forbrug i GB','number')
        };
        //List<GoogleViz.row> row = new List<GoogleViz.row>();
        if(customerUsage != null && previousThreeMonthsUsage != null){
            if(previousThreeMonthsUsage.size() != 0) {
                //Integer k = bbUsagesList.size()-1;
                for(i=previousThreeMonthsUsage.size()-1; i>=0;i--) {
                    //System.debug(i+ 'uuuuuuuuuuuuuuuu');
                    GoogleViz.row grow = new GoogleViz.row();
                    grow.cells.add(new GoogleViz.cell(previousThreeMonthsUsage[i].getMonth()));
                    grow.cells.add(new GoogleViz.cell(previousThreeMonthsUsage[i].getTotal()));
                    gv.addRow(grow);
                }
            }
        }
        //if(gv.rowCollection.size() != 0){
        //System.debug('PreviousThreeMonthsUsage google column bar' + gv.toJsonString());
        return gv.toJsonString();                //}   
        //else return '';       
    }       
        
    private BBUsage parseUsage(XmlStreamReader reader) {
        BBUsage usage= new BBUsage();     
        while(reader.hasNext()) {
            //System.debug('wen xml debug 1'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'forbrug') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'fromDate') {
                        reader.next();
                        usage.fromDate=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'toDate') {
                        reader.next();
                        usage.toDate=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'DownInKB') {
                        reader.next();
                        usage.downInKB=getLongValue(reader);
                    }else if (reader.getLocalName() == 'UpInKB') {
                        //System.debug('hello i am here to get previous');
                        reader.next();
                        usage.upInKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'youseeForbrugInKb') {
                        reader.next();
                        usage.youseeForbrugInKb=getLongValue(reader);
                    } else if (reader.getLocalName() == 'forbrugListe') {
                        usage.dailyUsages=getDailyUsages(reader);
                    }            
                }  
            }
            reader.next();
        }
        return usage;
    }
       
    private Usage parseDailyUsages(XmlStreamReader reader) {
        Usage usage = new Usage();
        while(reader.hasNext()) {
            //System.debug('wen xml debug 21'+reader.getEventType()+reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'forbrug') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'macAdr') {
                        reader.next();
                        usage.macAdr=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'modemId') {
                        reader.next();
                        usage.modemId=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'dateOfRegistration') {
                        reader.next();
                        usage.dateOfRegistration=checkEmptyElement(reader);                        
                    } else if (reader.getLocalName() == 'useOfDownloadInKB') {
                        reader.next();
                        usage.useOfDownloadInKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'useOfUploadInKB') {
                        reader.next();
                        usage.useOfUploadInKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'useOfTrafficTypemailKB') {
                        reader.next();
                        usage.useOfTrafficTypemailKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfTypeBrowserInKB') {
                        reader.next();
                        usage.useOfTypeBrowserInKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfTrafficTypeSkypeKB') {
                        reader.next();
                        usage.useOfTrafficTypeSkypeKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfTrafficTypeMsnKB') {
                        reader.next();
                        usage.useOfTrafficTypeMsnKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfTraffixOtherVoipKB') {
                        reader.next();
                        usage.useOfTraffixOtherVoipKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfTrafficTypePtpKB') {
                        reader.next();
                        usage.useOfTrafficTypePtpKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfYouSeePlayKB') {
                        reader.next();
                        usage.useOfYouSeePlayKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'useOfYouSeeWebTvKB') {
                        reader.next();
                        usage.useOfYouSeeWebTvKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'useOfYouSeeMailKB') {
                        reader.next();
                        usage.useOfYouSeeMailKB=getLongValue(reader);
                    } else if (reader.getLocalName() == 'useOfOtherStreamingKB') {
                        reader.next();
                        usage.useOfOtherStreamingKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfGamingKB') {
                        reader.next();
                        usage.useOfGamingKB=checkEmptyElement(reader);
                    }else if (reader.getLocalName() == 'useOfOtherKB') {
                        reader.next();
                        usage.useOfOtherKB=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'useOfYouseeVoipKB') {
                        reader.next();
                        usage.useOfYouseeVoipKB=checkEmptyElement(reader);
                    }
                }
            }
            reader.next();
        }
        return usage;   
    }
    
    private List<Usage> getDailyUsages(XmlStreamReader reader) {
        List<Usage> dailyUsages = new List<Usage>();
        try {
            while(reader.hasNext()) {
                //System.debug('wen xml debug 22'+reader.getEventType()+reader.getLocalName());
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'forbrugListe') {
                        break;
                    }   
                } else { 
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if (reader.getLocalName() == 'forbrug') {
                            Usage usage = parseDailyUsages(reader);
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
        System.debug('the size of daily usages are'+dailyUsages.size());
        return dailyUsages;
    }
       
    public static Long getLongValue(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            return Long.valueof(reader.getText());
        } else
        return 0;
    }
        
    public static String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    } 

    public static Double convertkByteToGB(Long value) {
        Double myDouble = (Double)(value/1048576.0*100.00);             
        return (myDouble.intValue()/100.00);
    }
    
    
    public static Double convertkByteToGB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1048576.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
    }

    
   public static Double convertkByteToMB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Double.valueof(reader.getText())/1024.0*100.00);              
            return (myDouble.intValue()/100.00);
        } else
        return 0;
    }
    
    public static Double convertMBToGB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Double.valueof(reader.getText())/1024.0*100.00);              
            return (myDouble.intValue()/100.00);
        } else
        return 0;
    }
   /*
    public static Double convertByteToGB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1073741824.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }
   */
   /*
   public static Double convertByteToMB(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Double.valueof(reader.getText())/1048576.0*100.00);              
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }
   */
/*
    public static Double convertByteToGBDecimal(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            Double myDouble = (Double)(Long.valueof(reader.getText())/1000000000.0*100.00);             
            return (myDouble.intValue()/100.00);
        } else
        return 0;
   }
   */
   /*
   private String splitDateTime(XmlStreamReader reader) {
        if(checkEmptyElement(reader) != '') {
            String[] dateS = reader.getText().split('T');
            return dateS[0];
        } else 
            return '';  
   }
   */
   public static String getMonthAsString(Integer month){
        if (month ==1) return 'Jan';
        if (month ==2) return 'Feb';
        if (month ==3) return 'Mar';
        if (month ==4) return 'Apr';
        if (month ==5) return 'May';
        if (month ==6) return 'Jun';
        if (month ==7) return 'Jul';
        if (month ==8) return 'Aug';
        if (month ==9) return 'Sep';
        if (month ==10) return 'Oct';
        if (month ==11) return 'Nov';
        if (month ==12) return 'Dec';       
        return null;        
   }
   
     
   static testMethod void testDisplayBB() {
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
        clsBBForbrug controller = new clsBBForbrug(sc);
        
        //10 month : JUL,AUG,SEP =0
        controller.threeMonthsUsageDataXmlResponse='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-10-01</fromDate><toDate>2011-10-31</toDate><DownInKB>0</DownInKB><UpInKB>0</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe/></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        //System.assertEquals(true, controller.getDailyUsageGraph()!= '');
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "Jul"},{v: 0.0}]},{c:[{v: "Aug"},{v: 0.0}]},{c:[{v: "Sep"},{v: 0.0}]}]}',
            controller.getPreviousThreeMonthsUsage());  
        //02 month : NOV,DEC,JAN =0
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-02-28</fromDate><toDate>2011-02-28</toDate><DownInKB>0</DownInKB><UpInKB>0</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe/></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        //System.assertEquals(true, controller.getDailyUsageGraph()!= '');
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "Nov"},{v: 0.0}]},{c:[{v: "Dec"},{v: 0.0}]},{c:[{v: "Jan"},{v: 0.0}]}]}',
            controller.getPreviousThreeMonthsUsage());  
        //01,10 month : OCT=x,NOV=0,DEC=0
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-01-01</fromDate><toDate>2011-01-31</toDate><DownInKB>0</DownInKB><UpInKB>0</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe/></forbrug><forbrug><fromDate>2010-10-31</fromDate><toDate>2010-10-31</toDate><DownInKB>127605</DownInKB><UpInKB>13379</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug><forbrug><fromDate>2010-10-01</fromDate><toDate>2010-10-31</toDate><DownInKB>2375307</DownInKB><UpInKB>72880</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        //System.assertEquals(true, controller.getDailyUsageGraph()!= '');
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "Oct"},{v: 0.13}]},{c:[{v: "Nov"},{v: 0.0}]},{c:[{v: "Dec"},{v: 0.0}]}]}', 
            controller.getPreviousThreeMonthsUsage());
        //10,08,07 : JUL=x,AUG=y,SEP =0
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-10-01</fromDate><toDate>2011-10-31</toDate><DownInKB>0</DownInKB><UpInKB>0</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe/></forbrug><forbrug><fromDate>2011-08-01</fromDate><toDate>2011-08-31</toDate><DownInKB>127605</DownInKB><UpInKB>13379</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug><forbrug><fromDate>2011-07-01</fromDate><toDate>2011-07-31</toDate><DownInKB>2375307</DownInKB><UpInKB>72880</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        //System.assertEquals(true, controller.getDailyUsageGraph()!= '');
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "Jul"},{v: 2.33}]},{c:[{v: "Aug"},{v: 0.13}]},{c:[{v: "Sep"},{v: 0.0}]}]}',
            controller.getPreviousThreeMonthsUsage());
        //10,09,08,07 : JUL=x,AUG=y,SEP =y
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-10-01</fromDate><toDate>2011-10-31</toDate><DownInKB>0</DownInKB><UpInKB>0</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe/></forbrug><forbrug><fromDate>2011-09-01</fromDate><toDate>2011-09-31</toDate><DownInKB>127605</DownInKB><UpInKB>13379</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug><forbrug><fromDate>2011-08-01</fromDate><toDate>2011-08-31</toDate><DownInKB>127605</DownInKB><UpInKB>13379</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug><forbrug><fromDate>2011-07-01</fromDate><toDate>2011-07-31</toDate><DownInKB>2375307</DownInKB><UpInKB>72880</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        //System.assertEquals(true, controller.getDailyUsageGraph()!= '');
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "Jul"},{v: 2.33}]},{c:[{v: "Aug"},{v: 0.13}]},{c:[{v: "Sep"},{v: 0.13}]}]}', 
            controller.getPreviousThreeMonthsUsage());        
        //Days 1,2,3,4,5=0,6,7,8,9,10,11,12 = x max=31        
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><BBforbrug><BBforbrugList><forbrug><fromDate>2011-10-01</fromDate><toDate>2011-10-31</toDate><DownInKB>3557978</DownInKB><UpInKB>193744</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb><forbrugListe><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-01</dateOfRegistration><useOfDownloadInKB>79085</useOfDownloadInKB><useOfUploadInKB>8592</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>23100</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>11</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>37</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>578</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>236</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>36835</useOfOtherStreamingKB><useOfGamingKB>21640</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-02</dateOfRegistration><useOfDownloadInKB>610969</useOfDownloadInKB><useOfUploadInKB>31294</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>91723</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>5019</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>47</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>1182</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>135</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>490914</useOfOtherStreamingKB><useOfGamingKB>46509</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-03</dateOfRegistration><useOfDownloadInKB>271391</useOfDownloadInKB><useOfUploadInKB>17117</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>67242</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>8262</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>54</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>1082</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>422</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>177256</useOfOtherStreamingKB><useOfGamingKB>30102</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-04</dateOfRegistration><useOfDownloadInKB>205401</useOfDownloadInKB><useOfUploadInKB>18206</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>36691</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>30</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>251</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>1543</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>635</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>104681</useOfOtherStreamingKB><useOfGamingKB>71667</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-06</dateOfRegistration><useOfDownloadInKB>267266</useOfDownloadInKB><useOfUploadInKB>15779</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>99335</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>30</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>153</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>0</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>360</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>1557</useOfOtherStreamingKB><useOfGamingKB>25091</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-07</dateOfRegistration><useOfDownloadInKB>332655</useOfDownloadInKB><useOfUploadInKB>14002</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>35218</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>11</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>35</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>1</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>5</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>13499</useOfOtherStreamingKB><useOfGamingKB>2789</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-08</dateOfRegistration><useOfDownloadInKB>639300</useOfDownloadInKB><useOfUploadInKB>9072</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>32473</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>6</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>19</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>0</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>390</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>97837</useOfOtherStreamingKB><useOfGamingKB>33186</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-09</dateOfRegistration><useOfDownloadInKB>168564</useOfDownloadInKB><useOfUploadInKB>30212</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>42871</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>114</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>99</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>1751</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>299</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>88552</useOfOtherStreamingKB><useOfGamingKB>35559</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-10</dateOfRegistration><useOfDownloadInKB>112351</useOfDownloadInKB><useOfUploadInKB>8880</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>39678</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>3934</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>35</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>411</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>111</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>61530</useOfOtherStreamingKB><useOfGamingKB>8454</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-11</dateOfRegistration><useOfDownloadInKB>782408</useOfDownloadInKB><useOfUploadInKB>35927</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>104201</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>158</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>123</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>2425</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>707</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>643366</useOfOtherStreamingKB><useOfGamingKB>29993</useOfGamingKB></forbrug><forbrug><macAdr>e0469a1fb0b8</macAdr><modemId>104833087</modemId><dateOfRegistration>2011-10-12</dateOfRegistration><useOfDownloadInKB>88588</useOfDownloadInKB><useOfUploadInKB>4663</useOfUploadInKB><useOfTrafficTypemailKB>0</useOfTrafficTypemailKB><useOfTypeBrowserInKB>30684</useOfTypeBrowserInKB><useOfTrafficTypeSkypeKB>29</useOfTrafficTypeSkypeKB><useOfTrafficTypeMsnKB>88</useOfTrafficTypeMsnKB><useOfTraffixOtherVoipKB>0</useOfTraffixOtherVoipKB><useOfTrafficTypePtpKB>108</useOfTrafficTypePtpKB><useOfYouSeePlayKB>0</useOfYouSeePlayKB><useOfYouSeeWebTvKB>0</useOfYouSeeWebTvKB><useOfYouSeeMailKB>0</useOfYouSeeMailKB><useOfOtherStreamingKB>15962</useOfOtherStreamingKB><useOfGamingKB>44834</useOfGamingKB></forbrug></forbrugListe></forbrug><forbrug><fromDate>2011-09-01</fromDate><toDate>2011-09-30</toDate><DownInKB>5124963</DownInKB><UpInKB>312288</UpInKB><youseeForbrugInKb>0</youseeForbrugInKb></forbrug></BBforbrugList></BBforbrug>';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        System.assertEquals('{cols: [{id: "Dato", label: "Dato", type: "string"},{id: "Forbrug", label: "Forbrug i GB", type: "number"}], rows: [{c:[{v: "1"},{v: 0.08}]},{c:[{v: "2"},{v: 0.61}]},{c:[{v: "3"},{v: 0.27}]},{c:[{v: "4"},{v: 0.21}]},{c:[{v: "5"},{v: 0.0}]},{c:[{v: "6"},{v: 0.26}]},{c:[{v: "7"},{v: 0.33}]},{c:[{v: "8"},{v: 0.61}]},{c:[{v: "9"},{v: 0.18}]},{c:[{v: "10"},{v: 0.11}]},{c:[{v: "11"},{v: 0.78}]},{c:[{v: "12"},{v: 0.08}]},{c:[{v: "13"},{v: 0.0}]},{c:[{v: "14"},{v: 0.0}]},{c:[{v: "15"},{v: 0.0}]},{c:[{v: "16"},{v: 0.0}]},{c:[{v: "17"},{v: 0.0}]},{c:[{v: "18"},{v: 0.0}]},{c:[{v: "19"},{v: 0.0}]},{c:[{v: "20"},{v: 0.0}]},{c:[{v: "21"},{v: 0.0}]},{c:[{v: "22"},{v: 0.0}]},{c:[{v: "23"},{v: 0.0}]},{c:[{v: "24"},{v: 0.0}]},{c:[{v: "25"},{v: 0.0}]},{c:[{v: "26"},{v: 0.0}]},{c:[{v: "27"},{v: 0.0}]},{c:[{v: "28"},{v: 0.0}]},{c:[{v: "29"},{v: 0.0}]},{c:[{v: "30"},{v: 0.0}]},{c:[{v: "31"},{v: 0.0}]}]}', 
         controller.getDailyUsageGraph()); 
            
        //xml = '' or xml = null        
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse = '';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);
        controller.setUsages();
        System.assertEquals(true,controller.getDailyUsageGraph()!='');
        System.assertEquals(true,controller.getPreviousThreeMonthsUsage()!=''); 
        
        controller = new clsBBForbrug(sc);
        controller.threeMonthsUsageDataXmlResponse = 'xxxx';
        controller.parseForbrug(controller.threeMonthsUsageDataXmlResponse);       
        
        controller = new clsBBForbrug(sc);
        System.assertEquals(null,clsBBForbrug.getMonthAsString(17));
   }
   
}