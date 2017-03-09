@isTest
global class NFCallOutMockITSG implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        req.getEndpoint();
        req.getMethod();
        req.getBody();
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"suspended":false,"billSequenceNo":33,"invoiceNumber":33,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":1255.4799999999996,"lastPaymentDate":"2014-08-05","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":6277.4,"balance":-36476.94,"documentDate":"2014-07-22","documentNumber":"33"},{"suspended":false,"billSequenceNo":32,"invoiceNumber":32,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":6039.907999999999,"lastPaymentDate":"2014-08-01","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":32199.54,"balance":-30199.54,"documentDate":"2014-07-09","documentNumber":"32"}]');
        res.setStatusCode(200);
        return res;
    }
}