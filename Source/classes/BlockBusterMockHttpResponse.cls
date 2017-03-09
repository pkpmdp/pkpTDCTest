@isTest
global class BlockBusterMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        req.getEndpoint();
        req.getMethod();
        req.getBody();
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}');
        res.setStatusCode(200);
        return res;
    }
}