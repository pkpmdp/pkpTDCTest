public with sharing class clsConsoleUsageTabController {
	//EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private Account account;
    private UsageResponse usageResponse;

    public clsConsoleUsageTabController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
    }

    public PageReference pageAction(){
        if (this.account != null) {
            updateLatestProductUsage();
        }
        return null;
    }


    // LatestProductUsage BEGIN --->
    public PageReference updateLatestProductUsage() {
        this.usageResponse = getUsageResponse();
        return null;
    }

    private UsageResponse getUsageResponse() {
        if (this.usageResponse == null) {
        	//EDM-637 START
        	calloutParameter.add('null');
        	calloutValue.add(account.Customer_No__c);
            String usageXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.LATEST_PRODUCT_USAGE_METHOD, calloutParameter, calloutValue);
            calloutParameter = new List<String>();
            calloutValue = new List<string>();
            //EDM-637 END
            this.usageResponse = parseLatestProductUsage(usageXmlResponse);
        }
        return usageResponse;
    }
    
    public List<LatestProductUsage> getLatestProductUsage() {
        return this.usageResponse == null? null: getUsageResponse().latestProductUsages;                
    }

    public List<ProductUsage> getProductUsage() {
        return this.usageResponse == null? null: getUsageResponse().productUsages;
        
    }
    
    public List<ReturnPathActivatedItem> getReturnPathActivated() {
        return this.usageResponse == null? null: getUsageResponse().returnPathActivated;        
    }
    
    private UsageResponse parseLatestProductUsage(String xmlResponse) { 
xmlResponse = '<?xml version="1.0" encoding="UTF-8"?><Response xmlns="http://yousee.dk/box/usages"><customerID>605590333</customerID><youseePlus><serialNr/><greenLamp/></youseePlus><lastUseDates><webTV>Web-TV</webTV><webTV_date/><play>Play</play><play_date>2011-03-14T00:00:00Z</play_date><cinema>Cinema</cinema><cinema_date>2011-09-03T12:38:48Z</cinema_date><startForFra>Start forfra</startForFra><startForFra_date>2011-09-06T22:30:46Z</startForFra_date><archive>Arkiv</archive><archive_date>2011-09-03T16:37:37Z</archive_date><plus>YouSee Plus</plus><plus_date/></lastUseDates><bb><productName>Bredbånd 50 Mbit/5 Mbit</productName><percentUse/><usage>15040586</usage><maxLimit>50000</maxLimit></bb><mobb><productName>Bredbånd 50 Mbit/5 Mbit</productName><percentUse/><usage>15040586</usage><maxLimit>0</maxLimit></mobb><telefoni><productName/><percentUse/><usage/><maxLimit/></telefoni><returnPath>2010-12-01T00:00:00Z</returnPath><boxUseDates><Boxusefirstdate>2010-08-25T21:12:16Z</Boxusefirstdate><Boxuselastdate>2011-09-07T22:07:56Z</Boxuselastdate></boxUseDates></Response>';
    
        UsageResponse result = new UsageResponse();
        ProductUsage bb,mobb,telefoni;
        List<ProductUsage> productUsages = new List<ProductUsage>();
        if (xmlResponse != null) {
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            while (reader.hasNext()) {
                System.debug('Element ' + reader.getLocalName());
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'lastUseDates') {
                        result.latestProductUsages = parseLatestProductUsageItem(reader);
                    }
                    else if(reader.getLocalName() == 'bb' && (bb = parseProductUsage(reader))!= null 
                        && ( bb.productName!= '' )){//  || bb.percentUse!='' ||  bb.usage!='' || bb.maxLimit!='')){                         
                            productUsages.add(bb);                      
                    }
                    else if(reader.getLocalName() == 'mobb'&& (mobb = parseProductUsage(reader))!= null 
                        && (mobb.productName!= '')){ //|| mobb.percentUse!='' ||  mobb.usage!='' || mobb.maxLimit!='')){
                            productUsages.add(mobb);                        
                    }
                    else if(reader.getLocalName() == 'telefoni' && (telefoni = parseProductUsage(reader))!= null 
                        && (telefoni.productName!= '')) {// || telefoni.percentUse!='' ||  telefoni.usage!='' || telefoni.maxLimit!='')){
                            productUsages.add(telefoni);                        
                    }
                    else if(reader.getLocalName() == 'boxUseDates'){
                        result.returnPathActivated = parseReturnPathActivated(reader);
                    }
                }
                reader.next();
            }
        }
        result.productUsages=productUsages;
        return result;
    }
    
    private ProductUsage parseProductUsage(XmlStreamReader reader) {
        ProductUsage result = new ProductUsage();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'bb' || reader.getLocalName() == 'mobb' || reader.getLocalName() == 'telefoni') {
                    result.forbrugType=reader.getLocalName();
                    break;
                }   
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'productName') {
                    reader.next();
                    result.productName=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'percentUse') {
                    reader.next();
                    result.percentUse=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'usage') {
                    reader.next();
                    result.usage=String.valueOf(clsBBForbrug.convertkByteToGB(reader));
                } else if (reader.getLocalName() == 'maxLimit') {
                    reader.next();
                    String maxLimitGB = String.valueOf(clsBBForbrug.convertMBtoGB(reader));
                    if (maxLimitGB.equals('0.0')) {
                      result.maxLimit= System.Label.No.toUpperCase(); 
                    } else {
                      result.maxLimit=maxLimitGB + ' GB';
                    }
//                    result.maxLimit=String.valueOf(clsBBForbrug.convertMBtoGB(reader));
                } 
            }
            reader.next();
        }
                
        return result;
    }
    
    private List<LatestProductUsage> parseLatestProductUsageItem(XmlStreamReader reader) {
        LatestProductUsage prodWebTV = new LatestProductUsage();
        LatestProductUsage prodPlay = new LatestProductUsage();
        LatestProductUsage prodCinema = new LatestProductUsage();
        LatestProductUsage prodStartForFra = new LatestProductUsage();
        LatestProductUsage prodArchive = new LatestProductUsage();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'lastUseDates') {
                    break;
                }  
            } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('-Element ' + reader.getLocalName());
                if (reader.getLocalName() == 'webTV') {
                    reader.next();
                    prodWebTV.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'webTV_date') {
                    reader.next();
                    prodWebTV.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'play') {
                    reader.next();
                    prodPlay.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'play_date') {
                    reader.next();
                    prodPlay.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'cinema') {
                    reader.next();
                    prodCinema.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'cinema_date') {
                    reader.next();
                    prodCinema.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'startForFra') {
                    reader.next();
                    prodStartForFra.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'startForFra_date') {
                    reader.next();
                    prodStartForFra.latestUsage=formatDate(reader);
                } else if (reader.getLocalName() == 'archive') {
                    reader.next();
                    prodArchive.service=checkEmptyElement(reader);
                } else if (reader.getLocalName() == 'archive_date') {
                    reader.next();
                    prodArchive.latestUsage=formatDate(reader);
                } 
            }
            reader.next();
        }

        List<LatestProductUsage> latestProductUsages = new List<LatestProductUsage>();
        latestProductUsages.add(prodWebTV);
        latestProductUsages.add(prodPlay);
        latestProductUsages.add(prodCinema);
        latestProductUsages.add(prodStartForFra);
        latestProductUsages.add(prodArchive);

        return latestProductUsages;
    }
    
    
    private List<ReturnPathActivatedItem> parseReturnPathActivated(XmlStreamReader reader) {
        List<ReturnPathActivatedItem> result = new List<ReturnPathActivatedItem>();
        ReturnPathActivatedItem item = new ReturnPathActivatedItem();
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'boxUseDates') {
                    result.add(item);
                    break;
                }   
            }           
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'Boxusefirstdate') {
                    reader.next();
                    item.boxUseFirstDate=formatDate(reader);
                } else if (reader.getLocalName() == 'Boxuselastdate') {
                    reader.next();
                    item.returnPathDate=formatDate(reader);
                } 
            }
            reader.next();
        }
        return result;
    }
    
    public String formatDate(XmlStreamReader reader) {
        String strDate = checkEmptyElement(reader);
        return formatDate(strDate);
    }
    
    public String formatDate(String strDate) {  
        try {
            Date dt = Date.valueOf(strDate);
            return dt.format();
        } catch(Exception e) {
            return '';
        }
    }
            
    public class LatestProductUsage {
        public String service{get;set;}
        public String latestUsage{get;set;}
        
        public LatestProductUsage() {
        }   
        
        public LatestProductUsage(String service, String latestUsage) {
            this.service = service;
            this.latestUsage = latestUsage;
        }   
    }

    public class ProductUsage {
        public String forbrugType{get; set;}
        public String productName{get;set;}
        public String percentUse{get;set;}
        public String usage{get;set;}
        public String maxLimit{get;set;}
        public String getForbrugUrl(){
            String forbrugUrl ='';
            if (productName!=''){
                if (forbrugType == 'bb'){
                    forbrugUrl =  '/apex/BBForbrug?id='+ ApexPages.currentPage().getParameters().get('id')
                    +'&productName='+  EncodingUtil.urlEncode(productName, 'UTF-8')+'&maxLimit='+ maxLimit + '&usage='+ usage + '&percentUse='+ percentUse;
                }else if (forbrugType == 'mobb'){
                    forbrugUrl = '/apex/mobilBBForbrug?id='+ ApexPages.currentPage().getParameters().get('id');
                }
            } 
            return forbrugUrl;
        }        
    }
    
    public class UsageResponse {
        public List<LatestProductUsage> latestProductUsages;
        public List<ProductUsage> productUsages;
        public List<ReturnPathActivatedItem> returnPathActivated;

    }

    public class ReturnPathActivatedItem {
        public String returnPathDate{get;set;}
        public String boxUseFirstDate{get;set;}
    }
// LatestProductUsage END --->

    private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {            
            return reader.getText();
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
    static testMethod void testLatestProductUsage() {
        /*
           <Response xmlns="http://yousee.dk/box/usages"> 
           <customerID>605590333</customerID> 
           <youseePlus> 
              <serialNr/> 
              <greenLamp/> 
           </youseePlus> 
           <lastUseDates> 
              <webTV>Web-TV</webTV> 
              <webTV_date/> 
              <play>Play</play> 
              <play_date>2011-03-14T00:00:00Z</play_date> 
              <cinema>Cinema</cinema> 
              <cinema_date>2011-09-03T12:38:48Z</cinema_date> 
              <startForFra>Start forfra</startForFra> 
              <startForFra_date>2011-09-06T22:30:46Z</startForFra_date> 
              <archive>Arkiv</archive> 
              <archive_date>2011-09-03T16:37:37Z</archive_date> 
              <plus>YouSee Plus</plus> 
              <plus_date/> 
           </lastUseDates> 
           <bb> 
              <productName>Bredbånd 50 Mbit/5 Mbit</productName> 
              <percentUse/> 
              <usage>15040586</usage> 
              <maxLimit>50000</maxLimit> 
           </bb> 
           <mobb> 
              <productName>Bredbånd 50 Mbit/5 Mbit</productName> 
              <percentUse/> 
              <usage>15040586</usage> 
              <maxLimit>0</maxLimit> 
           </mobb> 
           <telefoni> 
              <productName/> 
              <percentUse/> 
              <usage/> 
              <maxLimit/> 
           </telefoni> 
           <returnPath>2010-12-01T00:00:00Z</returnPath> 
           <boxUseDates> 
              <Boxusefirstdate>2010-08-25T21:12:16Z</Boxusefirstdate> 
              <Boxuselastdate>2011-09-07T22:07:56Z</Boxuselastdate> 
           </boxUseDates> 
        </Response> 
        */
        
        Address__c add = new Address__c(Street__c = 'Main Street', Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(Name = 'Test Account 1', Street_YK__c = add.Id, Customer_No__c = '123456789');
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        clsConsoleUsageTabController controller = new clsConsoleUsageTabController(new ApexPages.StandardController(acc));
        
        controller.usageResponse = controller.parseLatestProductUsage('<?xml version="1.0" encoding="UTF-8"?><Response xmlns="http://yousee.dk/box/usages"><customerID>605590333</customerID><youseePlus><serialNr/><greenLamp/></youseePlus><lastUseDates><webTV>Web-TV</webTV><webTV_date/><play>Play</play><play_date>2011-03-14T00:00:00Z</play_date><cinema>Cinema</cinema><cinema_date>2011-09-03T12:38:48Z</cinema_date><startForFra>Start forfra</startForFra><startForFra_date>2011-09-06T22:30:46Z</startForFra_date><archive>Arkiv</archive><archive_date>2011-09-03T16:37:37Z</archive_date><plus>YouSee Plus</plus><plus_date/></lastUseDates><bb><productName>Bredbånd 50 Mbit/5 Mbit</productName><percentUse/><usage>15040586</usage><maxLimit>50000</maxLimit></bb><mobb><productName>Bredbånd 50 Mbit/5 Mbit</productName><percentUse/><usage>15040586</usage><maxLimit>0</maxLimit></mobb><telefoni><productName/><percentUse/><usage/><maxLimit/></telefoni><returnPath>2010-12-01T00:00:00Z</returnPath><boxUseDates><Boxusefirstdate>2010-08-25T21:12:16Z</Boxusefirstdate><Boxuselastdate>2011-09-07T22:07:56Z</Boxuselastdate></boxUseDates></Response>');
        
        system.assert(controller.usageResponse.latestProductUsages[0].service=='Web-TV');
        system.assert(controller.usageResponse.latestProductUsages[0].latestUsage=='');
        
        system.assert(controller.usageResponse.latestProductUsages[1].service=='Play');
        system.assert(controller.usageResponse.latestProductUsages[1].latestUsage==controller.formatDate('2011-03-14T00:00:00Z'));
        
        system.assert(controller.usageResponse.latestProductUsages[2].service=='Cinema');
        system.assert(controller.usageResponse.latestProductUsages[2].latestUsage==controller.formatDate('2011-09-03T12:38:48Z'));
        
        system.assert(controller.usageResponse.latestProductUsages[3].service=='Start forfra');
        system.assert(controller.usageResponse.latestProductUsages[3].latestUsage==controller.formatDate('2011-09-06T22:30:46Z'));
        
        system.assert(controller.usageResponse.latestProductUsages[4].service=='Arkiv');
        system.assert(controller.usageResponse.latestProductUsages[4].latestUsage==controller.formatDate('2011-09-03T16:37:37Z'));
        
        system.assert(controller.usageResponse.productUsages[0].productName=='Bredbånd 50 Mbit/5 Mbit');
        system.assert(controller.usageResponse.productUsages[0].percentUse=='');
        //convert to units system.assert(controller.usageResponse.productUsages[0].usage=='15040586');
        //convert to units system.assert(controller.usageResponse.productUsages[0].maxLimit=='50000');
        
        system.assert(controller.usageResponse.productUsages[0].maxLimit=='48.82 GB');
        system.assert(controller.usageResponse.productUsages[1].maxLimit==System.Label.No.toUpperCase());       
               
        system.assert(controller.usageResponse.returnPathActivated[0].returnPathDate==controller.formatDate('2011-09-07T22:07:56Z'));
        system.assert(controller.usageResponse.returnPathActivated[0].boxUseFirstDate==controller.formatDate('2010-08-25T21:12:16Z'));
        controller.updateLatestProductUsage();
        controller.pageAction();
        controller.getProductUsage();
        controller.getLatestProductUsage();
        controller.getReturnPathActivated();
        clsConsoleUsageTabController.LatestProductUsage testusage = new clsConsoleUsageTabController.LatestProductUsage('test','test');
        clsConsoleUsageTabController.ProductUsage usage = new clsConsoleUsageTabController.ProductUsage();
        usage.getForbrugUrl();
        usage.forbrugType+='bb';
    }

}