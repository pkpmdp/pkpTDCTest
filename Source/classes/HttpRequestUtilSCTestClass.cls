@isTest(SeeAllData = true)
private class HttpRequestUtilSCTestClass{
    
    static TestMethod void testUnit(){
    	HttpRequestUtil.TEST_MODE = true;
        String tempContext = 'YSSCInstHistReq';
        String tempBody = 'ASADHAJJ12321,31';
        HttpRequest tempReq; 
        HttpResponse tempRes;
        HttpRequestUtil httpUtil = new HttpRequestUtil();
        HttpRequestUtil.makeHttpCall(tempContext,tempBody);
    }
}