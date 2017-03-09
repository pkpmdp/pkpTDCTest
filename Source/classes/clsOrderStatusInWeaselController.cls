public class clsOrderStatusInWeaselController{
     //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    private String orderStatus;
    private String respError;
    private String xmlResponse;
	public clsOrderStatusInWeaselController(ApexPages.StandardController stdController){
        NP_Order__c npo = (NP_Order__c) stdController.getRecord();
        String orderId = null;
        orderStatus = null;
        if (npo.Id != null){
            NP_Order__c[] dbNpos = [SELECT Order_Id__c FROM NP_Order__c WHERE Id = :npo.Id];
            if (dbNpos.size() == 1){
                if (dbNpos[0].Order_Id__c != null){
                    orderId = ''+dbNpos[0].Order_Id__c;
                }
            }
        }
        orderStatus = '';
        if (orderId != null){
            // There is an order in Weasel
            respError = null;
            //EDM-637 START
            calloutParameter.add('null');
            calloutValue.add(orderId);
            xmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.ORDER_INFO_SPOC_WEASEL_METHOD, calloutParameter, calloutValue);
           //EDM-637 END
			orderStatus = respError != null ? respError : parseResponse();
        }
    }
   public String getOrderStatus(){
        return orderStatus;
    }
 /* private String callout(String endpoint, String body) {
        // Make the callout and check the response
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(15000);
        req.setBody((body == null ? '' : body));
        System.debug('req: ' + endpoint + '?' + body);
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res: ' + res);
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(
                ApexPages.severity.Error, e.getMessage(), e.getMessage()
            );
            ApexPages.addMessage(m);
            respError = 'Error: No response';
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response
                String response = res.getBody();
                System.debug('Good response: ' + response);
                return response;
            }
            else {
                respError = 'Error: ' + res.getStatusCode();
            }
        }
        return null;
    }
*/	private String parseResponse(){
        String retVal = '';
        if (xmlResponse != null){
            String respActionName = '';
            String respOrderStatus = '';
            XmlStreamReader reader = new XmlStreamReader(xmlResponse);
            reader.setCoalescing(true);
            try{
                while(reader.hasNext()){
                    if(reader.getEventType() == XmlTag.START_ELEMENT){
                        if(reader.getLocalName() == 'currentActionName'){
                            reader.next();
                            if(reader.getEventType() != XmlTag.END_ELEMENT){
                                respActionName = reader.getText();
                            } 
                        }else if(reader.getLocalName() == 'currentOrderStatus'){
                            reader.next();
                            if(reader.getEventType() != XmlTag.END_ELEMENT){
                                respOrderStatus = reader.getText();
                            }
                        }
                    }
                    reader.next();
                }
                retVal = makeOrderStatus(respActionName, respOrderStatus);
            }catch(Exception e){
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'An error occured parsing the XML response: ' + e.getMessage(),e.getMessage());
                ApexPages.addMessage(m);
            }
        }
        return retVal;
    }
	private String makeOrderStatus(String strA, String strB){
        if(strA == '' && strB == ''){
            return '';
        }else{
            return strA != '' ? strA + ' [' + strB + ']' : '[' + strB + ']';
        }
    }
	static testMethod void testAll(){
        // Instantiate an NP Order
        INTEGRATION__c inte = new INTEGRATION__c();
        inte.Name = 'getOrderInfo';
        inte.HttpMethod__c = 'GET';
        inte.IsBodyAppended__c = false;
        inte.Service__c = 'JITTERBIT_NPORDER';
        inte.Params__c = 'orderid';
        insert inte;
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERINCOMPLETE;
        insert npOrder;
        clsOrderStatusInWeaselController ctrl = new clsOrderStatusInWeaselController(new ApexPages.standardController(npOrder));
        // No orderId on NP Order
        System.assertEquals('', ctrl.getOrderStatus());
		npOrder.Order_Id__c = decimal.valueOf('1');
        update npOrder;
        ctrl = new clsOrderStatusInWeaselController(new ApexPages.standardController(npOrder));
        // Test a cancel response
        String respActionName = 'Cancel Order';
        String respOrderStatus = 'error';
        ctrl.xmlResponse = '<?xml version="1.0" encoding="UTF-8"?>\n<return>\n<actionList>\n<createDate>2012-05-03T11:39:52+02:00</createDate>\n' +
                   '<description>Set View Port</description>\n<orderId>1</orderId>\n<sequence>2</sequence>\n<status>open</status>\n' +
                '</actionList>\n<actionList>\n<createDate>2012-05-03T11:39:52+02:00</createDate>\n<description>Validate Create Number</description>\n' +
                   '<orderId>1</orderId>\n<sequence>3</sequence>\n<status>open</status>\n</actionList>\n<actionList>\n<createDate>2012-05-03T11:39:52+02:00</createDate>\n' +
                   '<description>Set View Port</description>\n<orderId>1</orderId>\n<sequence>4</sequence>\n<status>open</status>\n</actionList>\n' +
                '<actionList>\n<createDate>2012-05-03T11:39:58+02:00</createDate>\n<description>Create Order</description>\n<orderId>1</orderId>\n' +
                   '<sequence>5</sequence>\n<status>open</status>\n</actionList>\n<actionList>\n<createDate>2012-05-03T11:40:38+02:00</createDate>\n' +
                   '<description>Wait For Och Response</description>\n<orderId>1</orderId>\n<sequence>8</sequence>\n<status>open</status>\n' +
                '</actionList>\n<attentionDate>2012-05-03T11:40:38+02:00</attentionDate>\n<creationDate>2012-05-03T11:39:51+02:00</creationDate>\n' +
                '<currentActionName>' + respActionName + '</currentActionName>\n<currentOrderStatus>' + respOrderStatus + '</currentOrderStatus>\n' +
                '<flowDescription>Create a import of a number</flowDescription>\n<modificationDate>2012-05-03T11:40:38+02:00</modificationDate>\n' +'</return>';
        ctrl.orderStatus = ctrl.parseResponse();
        System.assertEquals(ctrl.makeOrderStatus(respActionName, respOrderStatus), ctrl.getOrderStatus());
        // Test a complete response
        respActionName = '';
        respOrderStatus = 'finished';
        ctrl.xmlResponse = '<?xml version="1.0" encoding="UTF-8"?>\n<return>\n<actionList>\n<createDate>2012-05-08T15:31:35+02:00</createDate>\n' +
                   '<description>Set View Port</description>\n<orderId>3</orderId>\n<sequence>2</sequence>\n<status>open</status>\n</actionList>\n' +
                '<actionList>\n<createDate>2012-05-08T15:31:35+02:00</createDate>\n<description>Validate Range</description>\n<orderId>3</orderId>\n' +
                   '<sequence>3</sequence>\n<status>open</status>\n</actionList>\n<creationDate>2012-05-08T15:31:34+02:00</creationDate>\n' +
                '<currentOrderStatus>' + respOrderStatus + '</currentOrderStatus>\n<flowDescription>Create number range</flowDescription>\n' +
                '<modificationDate>2012-05-08T15:32:09+02:00</modificationDate>\n</return>';
        ctrl.orderStatus = ctrl.parseResponse();
        System.assertEquals(ctrl.makeOrderStatus(respActionName, respOrderStatus), ctrl.getOrderStatus());
    }
}