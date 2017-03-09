@isTest
global class NFCallOutMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        req.getEndpoint();
        req.getMethod();
        req.getBody();
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}');
        res.setStatusCode(200);
        return res;
    }
}