@isTest
global class clsFbUrlShortenerMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Only send a mock response for the SHORTENER_END_POINT endpoint and GET method.
        System.assertEquals(clsFbUrlShortener.SHORTENER_END_POINT, req.getEndpoint().substringBefore('?'));
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":{"global_hash":"900913","hash":"ze6poY","long_url":"http://google.com/","new_hash":0,"url":"http://bit.ly/ze6poY"},"status_code": 200,"status_txt":"OK"}');
        res.setStatusCode(200);
        return res;
    }
}