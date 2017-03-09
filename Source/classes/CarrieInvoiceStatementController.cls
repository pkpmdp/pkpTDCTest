/***********************************************************************************
************************************************************************************

* @class: CarrieInvoiceStatementController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to get invoice statement for  an invoice.

************************************************************************************ 
***********************************************************************************/
public class CarrieInvoiceStatementController {
    private Aria_API_Configuration__c config { get; private set; }
    public String invoiceNo = System.currentPagereference().getParameters().get('invoiceno');
    public String AriaAccountNo = System.currentPagereference().getParameters().get('acctno');
    public String data;
    public Integer errorCode;
    public String statementContent;
    public String statement;
    public String errorMessage;
    public Boolean makeCall ;
    
    
    public CarrieInvoiceStatementController() {
      config = CarrieCommonUtil.validateAPIConfiguration(config);
      makeCall = true;
    } 
     
    
    /**
    * @description: This method makes API call to Aria System for getting invoice statement.
    * @return: Response From Aria.
    */
    public String getAriaResponse(){
        config = CarrieCommonUtil.validateAPIConfiguration(config);
       //HttpResponse response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_statement_content', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'acct_no' => AriaAccountNo, 'statement_no' => statementNo, 'do_encoding' => 'false' });
       //jira Carrie-703 get_statement_for_invoice
        HttpResponse response = AriaWebServices.makeCallForJson(config.Aria_Remote_Site_URL__c, 'get_statement_for_invoice', config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'acct_no' => AriaAccountNo, 'invoice_no' => invoiceNo, 'do_encoding' => 'false' });
        return response.getBody();
    }
  
    /**
    * @description: This method  is use to parse the json response from Aria.
    */   
    public String Req {
        get {
            try{
                if(makeCall==true){
                    data =getAriaResponse();
                }
                system.debug('response from invoice statement:'+data);
                JSONParser parser = JSON.createParser(data);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'error_code')) {
                        parser.nextToken();
                        errorCode  = parser.getIntegerValue();   
                    }
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'out_statement')) {
                        parser.nextToken();
                        String url = CarrieInvoiceStatementController.GetResourceURL('CarrieKopiWatermark');
                        statementContent  = parser.getText();
                        if(statementContent.length()>0){
                            statement = statementContent.replace('http:','https:'); //jira Carrie-703 get_statement_for_invoice                       
                       // statement = statementContent.substring(0,statementContent.indexOf('<div id=\"content\">')+20)+'\n<div class=\"watermark\"><div><img src=\"'+url+'\" height=\"200\" width=\"230\" /></div></div>\n'+statementContent.substring(statementContent.indexOf('<div id=\"content\">')+20,statementContent.length());
                        }
                        
                    }
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'error_msg')) {
                        parser.nextToken();
                        errorMessage  = parser.getText();   
                    }
                }
                if(errorCode!=0){
                    return errorMessage;
                }else{                   
                    return statement;
                }    
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                CarrieLog.LogException(e);
                return null;    
            }   
        }    
        set;
    }
    
    /**
    * @description: This method makes is use to get the static resource CarrieKopiWatermark.
    * @param: resourceName CarrieKopiWatermark.
    * @return: if condition matches returns the resource else returns blank
    */
    public static String GetResourceURL(String resourceName) {
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName ];
        if (resourceList.size() == 1) {
            String namespace = resourceList[0].NamespacePrefix;
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        } else return '';
    }
}