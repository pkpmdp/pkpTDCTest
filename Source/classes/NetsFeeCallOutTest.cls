@IsTest(SeeAllData=true)
private class NetsFeeCallOutTest {

    
    static testMethod void myUnitNetsFeeCallOutTest() {
         string invoiceNo='tes';
        NetsFeeCallOut.GetUserIPAddress();
        NetsFeeCallOut.GetUserMid();
        
    }

     @isTest static void testCallout() {
        // Set mock callout class    
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockHttpResponse());
        HttpResponse res = NetsFeeCallOut.CallForPaymentProfile('600006645',NetsFeeCallOut.GetUserIPAddress());
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
        HttpResponse res1 = NetsFeeCallOut.CallForUpdateToGIRO('600006645',NetsFeeCallOut.GetUserIPAddress());
        
        String contentType1 = res1.getHeader('Content-Type');
        System.assert(contentType1 == 'application/json');
        String actualValue1 = res1.getBody();
        String expectedValue1 = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue1, expectedValue1);
        System.assertEquals(200, res1.getStatusCode());
        
        List<Permission__c>listPermission = [SELECT Customer__c,E_kommunikation__c,id,Customer_Number__c,Customer__r.PersonEmail,Customer__r.PersonMobilePhone FROM Permission__c where Customer__r.PersonEmail!=null and Customer_Number__c!=null limit 1];
        Map<String,String> mapPaymentProfToInfo = new Map<String,String>{'emailAddr' => 'dpa@tdc.dk', 'errorMessage' => '', 'isCcCustomer' => 'false', 'isEInvoiceCustomer' => '', 'mobileNo' => '', 'paymentMethod'=> 'PBS', 'paymentNotificationMethod'=> '', 'status' => '0'};
       
        HttpResponse res2 = NetsFeeCallOut.CallForUpdateToCC('600006645',NetsFeeCallOut.GetUserIPAddress(),NetsFeeCallOut.GetUserMid(),mapPaymentProfToInfo,'90052775','06/24',listPermission,'XXXXXXXXXXXX000');
        
        String contentType2 = res2.getHeader('Content-Type');
        System.assert(contentType2 == 'application/json');
        String actualValue2 = res2.getBody();
        String expectedValue2 = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue2, expectedValue2);
        System.assertEquals(200, res2.getStatusCode());

       
        HttpResponse res3 = NetsFeeCallOut.CallForUpdateInvoiceMedia('600006645',NetsFeeCallOut.GetUserIPAddress(),'PAPIR');
        
        String contentType3 = res3.getHeader('Content-Type');
        System.assert(contentType3 == 'application/json');
        String actualValue3 = res3.getBody();
        String expectedValue3 = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue3, expectedValue3);
        System.assertEquals(200, res3.getStatusCode());
        
        HttpResponse res4 = NetsFeeCallOut.CallForUpdateInvoiceMediaEmail('600006645',NetsFeeCallOut.GetUserIPAddress(),'PAPIR','Test@tdc.dk',listPermission);
        
        String contentType4 = res4.getHeader('Content-Type');
        System.assert(contentType4 == 'application/json');
        String actualValue4 = res4.getBody();
        String expectedValue4 = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue4, expectedValue4);
        System.assertEquals(200, res4.getStatusCode());
        
        
        HttpResponse res5 = NetsFeeCallOut.CallForUpdateNotificationMethod('600006645',NetsFeeCallOut.GetUserIPAddress(),listPermission,mapPaymentProfToInfo );
        
        String contentType5 = res5.getHeader('Content-Type');
        System.assert(contentType5 == 'application/json');
        String actualValue5 = res5.getBody();
        String expectedValue5 = '{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}';
        System.assertEquals(actualValue5, expectedValue5);
        System.assertEquals(200, res5.getStatusCode());
        
        Test.stopTest();
    }
    
    static testMethod void myUnitNetsFeeDIBSControllerTest() {
        NetsFeeDIBSController objNetsFeeDIBSController = new NetsFeeDIBSController();
        objNetsFeeDIBSController.generateMD5Key();
          string invoiceNo='te';
               
    }
    
     static testMethod void myUnitInvoiceWrapperTest() {
        InvoiceWrapper objNetsFeeDIBSController = new InvoiceWrapper();
        GetBillsErr getBillsErr = new GetBillsErr();
    }
    
    @isTest static void myunitnetfeeinvoicesController() {

        RecordType objRec = [Select id,Name from RecordType where Name = 'YK Customer Account'];
        
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        system.debug('CustomerNumberSeq__c----->'+custSeq);
        
        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c(Name = 'Andelsboligforening1',Code__c = 'ANMC',
                                                    SourceId__c = 'ABCDE');
        insert objLookUp;
        
        Account objAccount = new Account(RecordTypeId = objRec.Id,Lastname = 'Test Console Account',FirstName = 'Test First Name',PersonEmail = 'test@tdc.dk',
                                        Status_YK__c = 'Active',Customer_Segment_Lookup__c = objLookUp.id,Customer_No__c = '123456789');
        
        insert objAccount;
        
        Permission__c permissionTest = new Permission__c();
        permissionTest.Customer__c = objAccount.id;
        permissionTest.Driftsinfo_pa_SMS__c = false;
        permissionTest.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        permissionTest.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        permissionTest.Driftsinfo_pa_email__c = false;
        permissionTest.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        permissionTest.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        permissionTest.E_kommunikation__c = true;
        permissionTest.E_kommunikation_Opdateret_af__c = 'M31102';
        permissionTest.E_kommunikation_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = false;
        insert permissionTest;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockHttpResponse());
        ApexPages.StandardController standardController = new ApexPages.StandardController(objAccount);
        netfeeinvoicesController objnetfeeinvoicesController =new netfeeinvoicesController(standardController);
        
        //objnetfeeinvoicesController.invokeCI();
        objnetfeeinvoicesController.makeHTTPforPaymentProfile();
        
        Apexpages.currentPage().getParameters().put('trasactionid','902622569');
        Apexpages.currentPage().getParameters().put('expirationdate','06/24');
        Apexpages.currentPage().getParameters().put('PayMeth','Giro');
        
        objnetfeeinvoicesController.updatepaymentMethod();
        
        Apexpages.currentPage().getParameters().put('PayMeth','CC');
        
        objnetfeeinvoicesController.updatepaymentMethod();
        
        Apexpages.currentPage().getParameters().put('selectInv','PDFMAIL');
        objnetfeeinvoicesController.updateInvoiceMedia();
        
        Apexpages.currentPage().getParameters().put('selectInv','PAPIR');
        objnetfeeinvoicesController.updateInvoiceMedia();

        objnetfeeinvoicesController.Checkvalidity('{"emailAddr":"dpa@tdc.dk", "errorMessage":"null", "invoiceMedia":"PDFMAIL", "isCcCustomer":"false", "isEInvoiceCustomer":"null", "mobileNo":"123456", "paymentMethod":"PBS", "paymentNotificationMethod":"null", "status":"0"}');
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockITSG());
        
        objnetfeeinvoicesController.getInovoiceBillsByHTTPCallOut();

        String str = 'BEA-';
        
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 1';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 2';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 3';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 4';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 5';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 6';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 7';
        objnetfeeinvoicesController.checkcodes(str);    
        str = 'reply code 10';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 11';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 12';
        objnetfeeinvoicesController.checkcodes(str);
        str = 'reply code 13';
        objnetfeeinvoicesController.checkcodes(str);
        //objnetfeeinvoicesController.
        
        Test.stopTest();
    }
    
   /* static testmethod void testNetsFeePdfAttach() {
        Test.startTest();
        
        RecordType objRec = [Select id,Name from RecordType where Name = 'YK Customer Account'];
        
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        system.debug('CustomerNumberSeq__c----->'+custSeq);
        
        //Create Customer Segment
        Lookup_Customer_Segment__c objLookUp = new Lookup_Customer_Segment__c(Name = 'Andelsboligforening1',Code__c = 'ANMC',
                                                    SourceId__c = 'ABCDE');
        insert objLookUp;
        
        Account objAccount = new Account(RecordTypeId = objRec.Id,Lastname = 'Test Console Account',FirstName = 'Test First Name',PersonEmail = 'test@tdc.dk',
                                        Status_YK__c = 'Active',Customer_Segment_Lookup__c = objLookUp.id,Customer_No__c = '123456789');
        
        insert objAccount;
        
        Attachment att=new Attachment();
        att.Body = Blob.valueOf('hey');
        att.parentId = objAccount.Id;
        att.Name = 'test.pdf';
        att.Description = 'NetsFee';     
        insert att;
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        
        String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, new NetsFeedeletePdfAttach());
        
        Test.stopTest();
         
    }*/
 
}