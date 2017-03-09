/************************************************************
*  class Dezide_Controller
*
*  Added for MY-626.
*  This controller with get the customer products from Kasia,
*   prepare a parameter values for the Dezide call.
*************************************************************/
public class Dezide_Controller {
  //EDM-637 START
    public List<String> calloutParameter = new List<String>();
    public List<String> calloutValue = new List<String>();
    //EDM-637 END
  Account account;
  String existingProductsXmlResponse;
  String productGroup;
  String productId;
  String productActive;
  String requestProductParam;
  String urlParams;
  
  static final String redirectUrl = 'http://guide.tdk.dk/tdc/start.jsp';

  public Dezide_Controller(ApexPages.StandardController std){
    // fetch the customer number to be passed to dezide
    account = [Select Customer_No__c From Account Where Id = :std.getId()];
    
    // initialize the variables
    existingProductsXmlResponse = '';
      requestProductParam = '';
      urlParams = '';
    
    // call CI to fetch existing products for this customer
    if (this.account != null && this.account.Customer_no__c != null){
    	 //EDM-637 START
          calloutParameter.add('null');
          calloutValue.add(this.account.Customer_No__c);
          existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_CUSTOMERS_METHOD, calloutparameter, calloutvalue);
    	//EDM-637 END
    }
    system.debug('@@@@@@@@@@@  ' +existingProductsXmlResponse);
    // parse the response if received and form the URL
    if(existingProductsXmlResponse != null && existingProductsXmlResponse != ''){  
      parseResponse(existingProductsXmlResponse);    
    }
    
    urlParams = '';
    urlParams = '?Type=yousee&EnquiryNo=' + account.Customer_No__c + '&HasBroadband=';
    if(requestProductParam != null && requestProductParam != '')
      urlParams += requestProductParam;
  }
  
  // page-action method that redirects the user to Dezide application
  public pageReference redirectToDezide(){
    if(urlParams != NULL && urlParams != ''){
      PageReference pr = new PageReference(redirectUrl + urlParams);
      return pr;
    }
    else
      return null;
  }
  
  // method to parse the xml response from CI for existing products
  private void parseResponse(String response){
    XmlStreamReader reader = new XmlStreamReader(response);
             
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                  if(reader.getLocalName() == 'row'){
                    productGroup = '';
                    productId = '';
                    productActive = '';
                    parseProduct(reader);
                    if(productActive == '1'){
                      if(requestProductParam == '')
                        requestProductParam = productId;
                      else
                        requestProductParam += ',' + productId;
                    }
                  } 
                }
                reader.next();
            }
        } 
        catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
        }
  }
  
  private void parseProduct(XmlStreamReader reader) {
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } 
            else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if ((reader.getLocalName() == 'BUSINESS_GROUP') || (reader.getLocalName() == 'businessArea')) {
                        reader.next();
                        productGroup = checkEmptyElement(reader);
                    }
                  else if(reader.getLocalName() == 'VARENUMMER'){
                    reader.next();
                    productId = checkEmptyElement(reader);
                  }  
                  else if(reader.getLocalName() == 'ACTIVE'){
                    reader.next();
                    productActive = checkEmptyElement(reader);
                  }
            }
        }
        reader.next();
    }
    }
  
  private String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }
  
  // method to call CI for retrieving existing products for a customer
 /* private String callout(String serviceName, String body) {
        // Make the callout and check the response
        // EDM-637 start
         // EDM-637 start
       String bodyText = '';
        if(String.isNotBlank(INTEGRATION__c.getInstance(serviceName).Params__c)){
            bodyText = INTEGRATION__c.getInstance(serviceName).Params__c;
        }
        String endpoint = clsConnectionUtils.getEndPoint(serviceName);
        if(String.isNotBlank(bodyText))
            endpoint = endpoint + '?' + bodyText + '=' + body;
        
        System.debug('******endPoint*****'+endpoint);      
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        //req.setMethod('GET');
        req.setMethod(String.isBlank(INTEGRATION__c.getInstance(serviceName).HttpMethod__c)?'GET':INTEGRATION__c.getInstance(serviceName).HttpMethod__c);
        req.setEndpoint(endpoint);
        req.setTimeout(15000);
        if(String.isBlank(bodyText)) // bodyText blank indicates that params are not requried for request and hence we are setting the body
            req.setBody((body == null ? '' : body));
        else{
            req.setBody('');
            req.setHeader('charset', 'utf-8');
            req.setHeader('accept-encoding', 'gzip');
            req.setCompressed(true);
            req.setTimeout(30000);
        }
         //EDM-637 End      
        HttpResponse res;
        try {
            res = http.send(req);
        } 
        catch (Exception e) {
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
    */
}