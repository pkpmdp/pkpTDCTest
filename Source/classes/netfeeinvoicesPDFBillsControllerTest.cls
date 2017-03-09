@isTest(SeeAllData=true)
public class netfeeinvoicesPDFBillsControllerTest {

    static testMethod void myUnitnetfeeinvoicesPDFBillsControllerTest() {
      
      System.currentPageReference().getParameters().put('accNo','600006645');
      System.currentPageReference().getParameters().put('billSeqNo','7');      
      System.currentPageReference().getParameters().put('invoiceNumber','7');
      netfeeinvoicesPDFBillsController objNF = new netfeeinvoicesPDFBillsController();
      
    }
    
    @isTest static void testCallout() {
        // Set mock callout class 
        Test.startTest();
        netfeeinvoicesPDFBillsController objNF1 = new netfeeinvoicesPDFBillsController();
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockITSG());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        //objNFITSG.GetBillAsDocument();
        
        Date stdt  = date.newinstance(2013, 1, 1);
        Date enddt = date.newinstance(2016, 12, 31);
        HttpResponse res = netfeeinvoicesPDFBillsController.getBills('600006645',stdt,enddt,NetsFeeCallOut.GetUserMid(),'203.191.35.23',UserInfo.getUserId());
        
        // Verify response received contains fake values
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '[{"suspended":false,"billSequenceNo":33,"invoiceNumber":33,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":1255.4799999999996,"lastPaymentDate":"2014-08-05","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":6277.4,"balance":-36476.94,"documentDate":"2014-07-22","documentNumber":"33"},{"suspended":false,"billSequenceNo":32,"invoiceNumber":32,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":6039.907999999999,"lastPaymentDate":"2014-08-01","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":32199.54,"balance":-30199.54,"documentDate":"2014-07-09","documentNumber":"32"}]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
        HttpResponse res1 = netfeeinvoicesPDFBillsController.payBills('600006645','7','youbio','203.191.35.23','902622569',20.0,'06/24',NetsFeeCallOut.GetUserMid(),'203.191.35.23',UserInfo.getUserId(),'XXXXXXXXXXXX0000');  
		
	    String actualValue1 = res1.getBody();
        String expectedValue1 = '[{"suspended":false,"billSequenceNo":33,"invoiceNumber":33,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":1255.4799999999996,"lastPaymentDate":"2014-08-05","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":6277.4,"balance":-36476.94,"documentDate":"2014-07-22","documentNumber":"33"},{"suspended":false,"billSequenceNo":32,"invoiceNumber":32,"creditnote":false,"period":"August måned  2014","vatCalculated":false,"amountTotalTax":6039.907999999999,"lastPaymentDate":"2014-08-01","paid":false,"pdfDownloadable":false,"description":"August måned  2014","accountNumber":600006645,"paymentMethod":"D","excerptItemType":"BILL","amountTotalInclVat":32199.54,"balance":-30199.54,"documentDate":"2014-07-09","documentNumber":"32"}]';
        System.assertEquals(actualValue1, expectedValue1);
        System.assertEquals(200, res1.getStatusCode());
        objNF1.AccId = '0012000000PU0Su';
        HttpResponse res2 = netfeeinvoicesPDFBillsController.getCPRResponse('12345',NetsFeeCallOut.GetUserMid(),'203.191.35.23',UserInfo.getUserId(),objNF1.AccId);
       
        objNF1.GetBillAsDocument(); 
        
        objNF1.insertAttachment('abc','PDF');
        Test.stopTest();

    }
    
}