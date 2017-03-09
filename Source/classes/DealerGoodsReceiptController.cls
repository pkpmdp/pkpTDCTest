public class DealerGoodsReceiptController  
{  
    private String startDate;
    private String searchEndDate;
    private String endDate;
    public String strDate{set; get;}
    public String enDate{set; get;}
    public String orderNumber{set; get;}
    public String serialNumber{set; get;}
    public String assignedItems { get; set; }
    public string listlabel = 'Varemodtagelse';
    public string dateListlabel { get {return listlabel;}}
    public string dealerGoods {get;set;}
    public string approvalResponse {get;set;}
    public Boolean testMode { get; set; } 
    public Boolean hidePageBlock {get;set;}
    public static Boolean FORCE_TEST_MODE = false; 
    public string serialNumberList {get;set;}
    public string ETAG {get;set;}
    public commonClass objCommon {get;set;}    
    public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    private String END_POINT = castIronEndPoint.END_POINT__c;
    public Blob body {get;set;}
    public String defectAndMissingHardware{get;set;}
    public String receivedOrderedProducts{get;set;}
    public String notReceivedOrderedProducts{get;set;}
    public String defectiveOrderedProducts{get;set;}
   	public String defectiveOrMissingProducts{get;set;}
   	public Boolean receivedProducts {get;set;}
   	public Boolean notReceivedProducts{get;set;}
   	public Boolean defectiveProducts{get;set;}
   	public List<String> receivedProductsList{get;set;}
   	public List<String> notReceivedProductsList{get;set;}
   	public List<String> defectiveProductsList{get;set;}
    public List<ForhandlerInformations__c> getVaremodtagelseHeader(){
               return getInformation('Varemodtagelse','Order Approval'); 
    }
    
    public List<ForhandlerInformations__c> getInformation(String pageType, String groupInfo){
               List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c =: 'Varemodtagelse' and Group_Information__c =:groupInfo order by Sequence_Number__c];
               
               integer days = 0;
               Date todayDate;
               List<ForhandlerInformations__c> filteredInformationList = new List<ForhandlerInformations__c>(); 
               for(ForhandlerInformations__c info : informationList) {
                     if(info.EndDate__c != null){ 
                         days = todayDate.daysBetween(info.EndDate__c);
                     }    
                     if((info.EndDate__c == null) ||  (info.EndDate__c != null && days > 0)) {
                         filteredInformationList.add(info); 
                     }                             
                }  
                return filteredInformationList; 
        }        
    
    public List<ForhandlerInformations__c> getFinalPageInformation()
    {
        return getInformation('Varemodtagelse','Finalizing Order');
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
    
    public String getStartDateTime(){
        string dateTimeFormat = formatDate(startDate,' 00:00:00');
        return dateTimeFormat;
        }
        
    public String getEndDateTime(){
       string dateTimeFormat = formatDate(endDate,' 23:59:59');
        return dateTimeFormat;
        } 
           
    public String getSearchEndDate(){
        return searchEndDate;
    }
    
    public void setSearchEndDate(String searchEndDate){
        this.searchEndDate = searchEndDate;
    }
    
    public string formatDate(string dateString, string dTime)
    {
        if(dateString!=null && dateString!='')
        {
            string [] arrDate = dateString.split('-');
            return arrDate[2] + '.' + arrDate[1] + '.' + arrDate[0] + dTime;
        }
        else
            return null;
    }
    
    public List<SelectOption> getItems() 
    {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','Vælg'));
            options.add(new SelectOption('1','Ordrenummer'));
            options.add(new SelectOption('2','Serialnummer'));
            options.add(new SelectOption('3','Dato'));
            return options;
    }
    
    public void callOutDealerGoods()
    {
            testMode = FORCE_TEST_MODE;   
            //initCustomSettings();
            //string body = 'GET /logistik/lokation/' + objCommon.dealerAccount.Dealer_Number__c + ' !#$ !#$ ';
            //string body = '/logistik/lokation/' + objCommon.dealerAccount.Dealer_Number__c;  
            //string methodType = 'GET';
            //string endpoint = 'http://192.66.36.144:7890/Kasia20Logistik';
            objCommon = new commonClass();
            system.debug('objCommon.dealerAccount.id ->'+objCommon.dealerAccount.id);
            List<Case> casesList = [Select c.DefectiveAndMissingHardware__c,c.id From Case c where c.AccountId =: objCommon.dealerAccount.id and 
            						 Case_Source__c = 'DealerWeb:Varemodtagelse' and c.Subject = 'Varemodtagelse' and (Status != 'Closed' and Status != 'Cancelled')];
           if(casesList.size() > 0){
            defectAndMissingHardware = '[';
                Integer i;
            	for(i=0;i<casesList.size();i++){
            		system.debug('case id ->'+casesList[i].id);
            		system.debug('case DefectiveAndMissingHardware__c ->'+casesList[i].DefectiveAndMissingHardware__c);
            		defectAndMissingHardware = defectAndMissingHardware + casesList[i].DefectiveAndMissingHardware__c+',';
            	}
            	defectAndMissingHardware = defectAndMissingHardware.substring(0, defectAndMissingHardware.length() - 1);
            	defectAndMissingHardware = defectAndMissingHardware + ']';
            }else{
            	defectAndMissingHardware='"nope"';
            }
             system.debug('defectAndMissingHardware---------->'+defectAndMissingHardware);
            string serviceUrl='/logistik/lokation/' +objCommon.dealerAccount.Dealer_Number__c;
            System.debug('ServiceUrl ------------>' + serviceUrl);
            Http http = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setMethod('GET'); 
            req.setEndpoint(END_POINT+'/Kasia20'); 
            req.setHeader('charset', 'utf-8'); 
            req.setHeader('accept-encoding', 'gzip'); 
            req.setHeader('accept', 'application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8'); //this is done by castiron before and now we need to specify it in client
            req.setHeader('content-type','application/vnd.yousee.kasia2.kunde+json;version=1');
            req.setHeader('If-Match', ''); 
            req.setHeader('serviceUrl', serviceUrl); 
            req.setheader('serviceMethod', 'GET'); //put, get, post etc.
            req.setHeader('salesChannel', 'F'); 
            req.setBody(''); //equal to the requestBody before, the real body that is sent to kasia2 service
            req.setCompressed(true); 
            req.setTimeout(30000);        
            HttpResponse res; 
            
            try
            {
                if(!testMode)
                {
                    res = http.send(req);
                    dealerGoods = res.getbody();
                    //json with out itransit node.
                    //dealerGoods = '{"logistik":{"links":[{"rel":"varemodtagelse","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/varemodtagelse"},{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"paaLager":[{"status":"DISPONIBEL","serienummer":"818103400218","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102506374","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102473543","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102269600","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818100545355","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"838303955769","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303953850","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303941223","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303869902","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838302488586","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302439306","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302414657","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302345660","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302315564","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302304654","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302296278","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302286075","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302268396","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"83830038692","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"02-12-2011","ordrenummer":548582},{"status":"DISPONIBEL","serienummer":"838301358996","varenavn":"Leje af YouSee Boks","varenummer":"1203021"},{"status":"DISPONIBEL","serienummer":"32907952306","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952298","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952280","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952272","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951894","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951886","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951548","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951530","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907578713","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"11-10-2010","ordrenummer":359163},{"status":"DISPONIBEL","serienummer":"32907578275","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907578267","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907578036","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907577079","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907576881","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907575768","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"11-10-2010","ordrenummer":359163},{"status":"DISPONIBEL","serienummer":"32907566056","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566049","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566023","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566015","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566007","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565991","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565983","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565975","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761}],"navn":"TDC Butik Køge - Nørregade 1B","type":"FORHANDLER","lokation":"T8030"}}';
                    //json without paalager
                    //dealerGoods = '{"logistik":{"links":[{"rel":"varemodtagelse","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/varemodtagelse"},{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"iTransit":[{"status":"TRANSIT","serienummer":"838303365559","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"30-01-2012","ordrenummer":550476},{"status":"TRANSIT","serienummer":"838303341113","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"30-01-2012","ordrenummer":550476}],"navn":"TDC Butik Køge - Nørregade 1B","type":"FORHANDLER","lokation":"T8030"}}';
                    // json without itransit and paaLager
                    //dealerGoods = '{"logistik":{"links":[{"rel":"varemodtagelse","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/varemodtagelse"},{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"navn":"TDC Butik Køge - Nørregade 1B","type":"FORHANDLER","lokation":"T8030"}}';
                    // json without logistic node
                    //dealerGoods = '{}';
                    //dealerGoods = '{"logistik":{"links":[{"rel":"varemodtagelse","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/varemodtagelse"},{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"iTransit":[{"status":"TRANSIT","serienummer":"838303365559","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"30-01-2012","ordrenummer":550476},{"status":"TRANSIT","serienummer":"838303341113","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"30-01-2012","ordrenummer":550476}],"paaLager":[{"status":"DISPONIBEL","serienummer":"818103400218","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102506374","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102473543","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818102269600","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"818100545355","varenavn":"DEMO HD-Standardboks","varenummer":"1218385","ordredato":"14-12-2011","ordrenummer":548938},{"status":"DISPONIBEL","serienummer":"838303955769","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303953850","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303941223","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838303869902","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"838302488586","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302439306","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302414657","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302345660","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302315564","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302304654","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302296278","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302286075","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"838302268396","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"16-01-2012","ordrenummer":549800},{"status":"DISPONIBEL","serienummer":"83830038692","varenavn":"Leje af YouSee Boks","varenummer":"1203021","ordredato":"02-12-2011","ordrenummer":548582},{"status":"DISPONIBEL","serienummer":"838301358996","varenavn":"Leje af YouSee Boks","varenummer":"1203021"},{"status":"DISPONIBEL","serienummer":"32907952306","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952298","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952280","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907952272","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951894","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951886","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951548","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907951530","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"03-02-2011","ordrenummer":406103},{"status":"DISPONIBEL","serienummer":"32907578713","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"11-10-2010","ordrenummer":359163},{"status":"DISPONIBEL","serienummer":"32907578275","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907578267","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907578036","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907577079","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907576881","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"14-03-2012","ordrenummer":551146},{"status":"DISPONIBEL","serienummer":"32907575768","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"11-10-2010","ordrenummer":359163},{"status":"DISPONIBEL","serienummer":"32907566056","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566049","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566023","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566015","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907566007","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565991","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565983","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761},{"status":"DISPONIBEL","serienummer":"32907565975","varenavn":"Tvillingkort","varenummer":"1201601","ordredato":"20-05-2010","ordrenummer":324761}],"navn":"TDC Butik Køge - Nørregade 1B","type":"FORHANDLER","lokation":"T8030"}}';
                   
                   //New Json Response for DW-471
                    //dealerGoods = '{"logistik":{"links":[{"rel":"varemodtagelse","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"{GET}/logistik/varemodtagelse"},{"rel":"returnering","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"{GET}/logistik/returnering"},{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"{GET}/logistik/ombytning"}],"iTransit":[{"varenavn":"Leje af YouSee Boks","ordrenummer":550477,"varenummer":"1203021","ordredato":"30-01-2012","serienummer":"838303365552","sidstehandling":"30-01-2012","status":"TRANSIT"},{"varenavn":"Leje af YouSee Boks","ordrenummer":550477,"varenummer":"1203021","ordredato":"30-01-2012","serienummer":"838303341114","sidstehandling":"30-01-2012","status":"TRANSIT"},{"varenavn":"Leje af YouSee Boks","ordrenummer":550476,"varenummer":"1203021","ordredato":"30-01-2012","serienummer":"838303365559","sidstehandling":"30-01-2012","status":"TRANSIT"},{"varenavn":"Leje af YouSee Boks","ordrenummer":550476,"varenummer":"1203021","ordredato":"30-01-2012","serienummer":"838303341113","sidstehandling":"30-01-2012","status":"TRANSIT"}],"paaLager":[{"varenavn":"DEMO HD-Standardboks","ordrenummer":552086,"varenummer":"1218385","ordredato":"18-04-2012","serienummer":"838304523536","sidstehandling":"18-04-2012","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","ordrenummer":551146,"varenummer":"1203021","ordredato":"14-03-2012","serienummer":"838303941223","sidstehandling":"14-03-2012","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","ordrenummer":549800,"varenummer":"1203021","ordredato":"16-01-2012","serienummer":"838302488586","sidstehandling":"16-01-2012","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","ordrenummer":549800,"varenummer":"1203021","ordredato":"16-01-2012","serienummer":"838302439306","sidstehandling":"16-01-2012","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","ordrenummer":549800,"varenummer":"1203021","ordredato":"16-01-2012","serienummer":"838302414657","sidstehandling":"16-01-2012","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","ordrenummer":548582,"varenummer":"1203021","ordredato":"02-12-2011","serienummer":"83830038692","sidstehandling":"15-12-2011","status":"DISPONIBEL"},{"varenavn":"Leje af YouSee Boks","varenummer":"1203021","serienummer":"838301358996","sidstehandling":"21-04-2010","status":"DISPONIBEL"},{"varenavn":"YouSee Kort","ordrenummer":551860,"varenummer":"1201505","ordredato":"10-04-2012","serienummer":"32561616007","sidstehandling":"16-05-2012","status":"DISPONIBEL"},{"varenavn":"YouSee Kort","ordrenummer":551860,"varenummer":"1201505","ordredato":"10-04-2012","serienummer":"32561615355","sidstehandling":"16-05-2012","status":"DISPONIBEL"},{"varenavn":"YouSee Kort","ordrenummer":551860,"varenummer":"1201505","ordredato":"10-04-2012","serienummer":"32561615108","sidstehandling":"16-05-2012","status":"DISPONIBEL"},{"varenavn":"YouSee Kort","ordrenummer":551860,"varenummer":"1201505","ordredato":"10-04-2012","serienummer":"32561615058","sidstehandling":"16-05-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907952306","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907952298","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907952280","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907952272","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907951894","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907951886","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907951548","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":406103,"varenummer":"1201601","ordredato":"03-02-2011","serienummer":"32907951530","sidstehandling":"08-02-2011","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":359163,"varenummer":"1201601","ordredato":"11-10-2010","serienummer":"32907578713","sidstehandling":"12-10-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":551146,"varenummer":"1201601","ordredato":"14-03-2012","serienummer":"32907578275","sidstehandling":"15-03-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":551146,"varenummer":"1201601","ordredato":"14-03-2012","serienummer":"32907578267","sidstehandling":"15-03-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":551146,"varenummer":"1201601","ordredato":"14-03-2012","serienummer":"32907578036","sidstehandling":"15-03-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":551146,"varenummer":"1201601","ordredato":"14-03-2012","serienummer":"32907577079","sidstehandling":"15-03-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":551146,"varenummer":"1201601","ordredato":"14-03-2012","serienummer":"32907576881","sidstehandling":"15-03-2012","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":359163,"varenummer":"1201601","ordredato":"11-10-2010","serienummer":"32907575768","sidstehandling":"12-10-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907566056","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907566049","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907566023","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907566015","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907566007","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907565991","sidstehandling":"22-05-2010","status":"DISPONIBEL"},{"varenavn":"Tvillingkort","ordrenummer":324761,"varenummer":"1201601","ordredato":"20-05-2010","serienummer":"32907565983","sidstehandling":"22-05-2010","status":"DISPONIBEL"}],"navn":"TDC Butik Køge - Nørregade 1B","type":"FORHANDLER","lokation":"T8030"}}';
                    System.debug('dealerGoods --------------> ' + dealerGoods);
                    //JSONObject j = new JSONObject(dealerGoods);
                    //if(j.has('logistik')){
                   // 	JSONObject.value vs = j.getValue('logistik');
                    //	System.debug(j.getValue('responsecode').str);
                  //  }
                    /*JSONObject j = new JSONObject(dealerGoods);
                    if(j.has('logistik')){
                    	JSONObject.value vs = j.getValue('logistik');
                    	System.debug('Response Code ' + responsecode);
                    	if(j.getValue('responsecode').str != '200'){
                    		System.debug('*New Response code*'+ )
                    		return null;
                    	}
                    	else{
                    		return Page.VaremodtagelsePage;
                    	}
                    }*/
                }
                    //dealerGoods = HttpRequestResponse.makeHttpCall(body, methodType,endpoint);
                      //dealerGoods = HttpRequestResponse.makeHttpCall(endpoint,'',methodType,body,''); 
                     //JSONObject j = new JSONObject( dealerGoods );
                     
                     
            }    	
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Der er i øjeblikket ikke forbindelse til bagved liggende system. Prøv igen senere.'));
                hidePageBlock = true;
            }
    }
    
    public PageReference updateApprovalStatus()
    {   
    	String defectiveOrMissing = defectiveOrMissingProducts;
    	defectiveOrderedProducts = ApexPages.currentPage().getParameters().get('defectiveOrderedProducts');
    	notReceivedOrderedProducts = ApexPages.currentPage().getParameters().get('notReceivedOrderedProducts');
    	receivedOrderedProducts = ApexPages.currentPage().getParameters().get('receivedOrderedProducts');
    	System.debug('defectiveOrMissing - '+defectiveOrMissing);
    	System.debug('defectiveOrderedProducts - '+defectiveOrderedProducts);
    	System.debug('notReceivedOrderedProducts - '+notReceivedOrderedProducts);
    	System.debug('receivedOrderedProducts - '+receivedOrderedProducts);
    	if(receivedOrderedProducts != ''){
    		receivedProducts = true;
    	}
    	if(notReceivedOrderedProducts != ''){
    		notReceivedProducts = true;
    	}
    	if(defectiveOrderedProducts != ''){
    		defectiveProducts = true;
    	}
    	//string strBody = strBody + '<p><Table width=80% border=1>';
        //strBody =strBody + '<tr><td width=15% bgcolor="#B2B2B2" ><b>defectiveOrderedProducts</b></td>';
		String strBody='';
		if(defectiveOrderedProducts != ''){
	    	strBody= strBody +'\n'+ 'Defekt hardware: '+defectiveOrderedProducts+'\n';
		}
		if(notReceivedOrderedProducts != ''){
			strBody=strBody + 'Manglende hardware:  '+notReceivedOrderedProducts;
		}
			
        //strBody =strBody + '<tr><td width=35% bgcolor="#B2B2B2" ><b>notReceivedOrderedProducts </b></td>';
		
		//strBody=strBody + '</Table>';
	
        
         objCommon = new commonClass();
        //if(serialNumberList != null && serialNumberList.length()>0 )
        //DW-468
        if(receivedOrderedProducts != null && receivedOrderedProducts.length()>0 )
        {
        	
        	//System.debug(serialNumberList);
            //string [] numbers = serialNumberList.split(':');
            //DW-468
            System.debug(receivedOrderedProducts);
            string [] numbers = receivedOrderedProducts.split(',');
            System.debug(numbers);
            string numStr = '';
            for(string n : numbers)
            {
                if(n!='undefined')
                 numStr = numStr + '"' + n + '",';
            }
            try{
                numStr = numStr.substring(0,numStr.length()-1);
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No selected product.'));
                return null;
            }
            //numStr = '{"lokation":"T2539","serienumre":[' + numStr + '],"klient-funktion":"varemodtag i dyt!","klient-system":"davids sys","klient-bruger":"David"}';
            numStr = '{"lokation":"' + objCommon.dealerAccount.Dealer_Number__c + '","serienumre":[' + numStr + '],"klient-funktion":"varemodtag i dyt!","klient-system":"DealerWeb","klient-bruger": "' + objCommon.dealerAccount.Dealer_Number__c + '"}';
            System.debug('numStr: '+numStr);
           
            testMode = FORCE_TEST_MODE;   
            string serviceUrl = '/logistik/varemodtagelse';   
            Http http = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setMethod('PUT'); 
            req.setEndpoint(END_POINT+'/Kasia20'); 
            req.setHeader('charset', 'utf-8'); 
            req.setHeader('accept-encoding', 'gzip'); 
            req.setHeader('accept', 'application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8'); //this is done by castiron before and now we need to specify it in client
            req.setHeader('content-type','application/vnd.yousee.kasia2.kunde+json;version=1');
            req.setHeader('If-Match', ETAG); 
            req.setHeader('serviceUrl', serviceUrl); 
            req.setheader('serviceMethod', 'POST'); //put, get, post etc.
            req.setHeader('salesChannel', 'F'); 
            req.setBody(numStr); //equal to the requestBody before, the real body that is sent to kasia2 service
            req.setCompressed(true); 
            req.setTimeout(30000);        
            HttpResponse res; 
            
            testMode = FORCE_TEST_MODE;   
            try
            {
                if(!testMode)
                {
                	
                    res = http.send(req);
                    approvalResponse = res.getbody();
                    System.debug('------------------ approvalResponse -----------------------' + approvalResponse);
                   
                }
                //approvalResponse = HttpRequestResponse.makeHttpCall(body, methodType,endpoint);
                //approvalResponse = HttpRequestResponse.makeHttpCall(endpoint,'',methodType,body,ETAG);
                    
                //Pagereference confirmPage = new Pagereference('/apex/DealerGoodsConfirmation');
               /**
                Pagereference confirmPage = new Pagereference('/apex/VaremodtagelseReceiptPage'); 
                system.debug('confirmPage page will return -------------->'+confirmPage);              
                return confirmPage;
                */
                
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'The service you are trying to access is currently down. Please try again later.'));
                return null;
            }
        } 
        	
        if(strBody != ''){ 
	    	Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.useDefaultRule= true;
			RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
			Case newCase = new Case(Status = 'New',Department__c = 'YKFS',RecordTypeId = recordType.Id,
								Product_2__c = 'Visitering',Subject = 'Varemodtagelse',Case_Source__c = 'DealerWeb:Varemodtagelse',
								DefectiveAndMissingHardware__c=defectiveOrMissing,Description=strBody);
			newCase.setOptions(dmlOpts); 
			//newCase.Description(strBody);
			insert newCase; 
			System.debug('newCase.id - '+newCase.id);
		}           
            
       /**
        else
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Ingen varer er valgt'));
             return null;
        }
        */
        
        PageReference pageRef = Page.VaremodtagelseReceiptPage; 
        //pageRef.setRedirect(true);             
        System.debug('varemodtalegse last');
        return pageRef;
    }
        
    /*     
    public pagereference updateApprovalStatus()
    {   
       // if(serialNumberList.length()>0)
       //DW-468
       if(receivedOrderedProducts.length()>0)
        {
            //string [] numbers = serialNumberList.split(':');
            //DW-468 
            string [] numbers = receivedOrderedProducts.split(',');
            string numStr = '';
            for(string n : numbers)
            {
                if(n!='undefined')
                 numStr = numStr + '"' + n + '",';
            }
            numStr = numStr.substring(0,numStr.length()-1);
            //numStr = '{"lokation":"T2539","serienumre":[' + numStr + '],"klient-funktion":"varemodtag i dyt!","klient-system":"davids sys","klient-bruger":"David"}';
            ///numStr = '{"lokation":"' + objCommon.dealerAccount.Dealer_Number__c + '","serienumre":[' + numStr + '],"klient-funktion":"varemodtag i dyt!","klient-system":"davids sys","klient-bruger":"David"}';
            testMode = FORCE_TEST_MODE;   
       
            //string body = 'PUT /logistik/varemodtagelse !#$ ' + ETAG + ' !#$ ' + numStr;
            ///string body = '/logistik/varemodtagelse/' + numStr;
            ///string methodType = 'PUT';
            //string endpoint = 'http://192.66.36.144:7890/Kasia20Logistik';
            string serviceUrl='/logistik/lokation/' + objCommon.dealerAccount.Dealer_Number__c;
            Http http = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setMethod('PUT'); 
            req.setEndpoint(endpoint); 
            req.setHeader('charset', 'utf-8'); 
            req.setHeader('accept-encoding', 'gzip'); 
            req.setHeader('accept', 'application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8'); //this is done by castiron before and now we need to specify it in client
            req.setHeader('If-Match', ETAG); 
            req.setHeader('serviceUrl', serviceUrl); 
            req.setheader('serviceMethod', 'PUT'); //put, get, post etc.
            req.setHeader('salesChannel', 'F'); 
            req.setBody(''); //equal to the requestBody before, the real body that is sent to kasia2 service
            req.setCompressed(true); 
            req.setTimeout(30000);        
            HttpResponse res; 
            
            testMode = FORCE_TEST_MODE;   
            try
            {
                if(!testMode)
                {
                    res = http.send(req);
                    approvalResponse = res.getbody();
                }
                    //approvalResponse = HttpRequestResponse.makeHttpCall(body, methodType,endpoint);
                    ///approvalResponse = HttpRequestResponse.makeHttpCall(endpoint,'',methodType,body,ETAG);
                Pagereference confirmPage = new Pagereference('/apex/DealerGoodsConfirmation');
                return confirmPage;
                
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'The service you are trying to access is currently down. Please try again later.'));
                return null;
            }
        }            
            
        else
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No selected product.'));
             return null;
        }
    }
    */
    
    public void initCustomSettings() 
    {
        // Setup email recipients
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues('DealerWeb.CI.Endpoint');
    	
        if(cs != null && cs.Setting_Value__c != null) {
            END_POINT = cs.Setting_Value__c; // + 'Kasia20Logistik';
        }
        /*
    	if(cs != null && cs.Setting_Value__c != null){
    		END_POINT = cs.Setting_Value__c;
    	}*/    
    }
     
    public pagereference backToGoodsPage()
    {
        Pagereference goodsPage = new Pagereference('/apex/VaremodtagelsePage');
        goodsPage.setRedirect(true);
        return goodsPage;
    } 
	
    public pagereference confirmationPage()
    {
    	String defectiveOrMissing = ApexPages.currentPage().getParameters().get('defectiveOrMissing');
    	defectiveOrderedProducts = ApexPages.currentPage().getParameters().get('defectiveOrderedProducts');
    	notReceivedOrderedProducts = ApexPages.currentPage().getParameters().get('notReceivedOrderedProducts');
    	receivedOrderedProducts = ApexPages.currentPage().getParameters().get('receivedOrderedProducts');
    	System.debug('defectiveOrMissing - '+defectiveOrMissing);
    	System.debug('defectiveOrderedProducts - '+defectiveOrderedProducts);
    	System.debug('notReceivedOrderedProducts - '+notReceivedOrderedProducts);
    	System.debug('receivedOrderedProducts - '+receivedOrderedProducts);
    	receivedProducts = false;
    	notReceivedProducts = false;
    	defectiveProducts = false;
		receivedProductsList = new List<String>();
    	notReceivedProductsList = new List<String>();
    	defectiveProductsList = new List<String>();
    	if(receivedOrderedProducts != ''){ 
    		receivedProducts = true;
    		receivedProductsList = receivedOrderedProducts.split(',');
    		system.debug('receivedProductsList size is ------------'+receivedProductsList.size());
    	}
    	if(notReceivedOrderedProducts != ''){
    		notReceivedProducts = true;
    		notReceivedProductsList = notReceivedOrderedProducts.split(',');
    		system.debug('notReceivedProductsList size is ------------'+notReceivedProductsList.size());
    	}
    	if(defectiveOrderedProducts != ''){
    		defectiveProducts = true;
    		defectiveProductsList = defectiveOrderedProducts.split(',');
    		system.debug('defectiveProductsList size is ------------'+defectiveProductsList.size());
    	}
    	defectiveOrMissingProducts = defectiveOrMissing;
    	//PageReference pageRef = Page.VaremodtagelseReceiptPage;
      	PageReference pageRef = Page.VaremodtagelseConfirmationPage; 
        //pageRef.setRedirect(true);             
        System.debug('varemodtalegse last');
        return pageRef;  
    } 
	 public pagereference backToVaremodtagelsePage()
    {
        Pagereference pageRef = new Pagereference('/apex/VaremodtagelsePage');
        pageRef.setRedirect(false);
        return pageRef;
    }    
}