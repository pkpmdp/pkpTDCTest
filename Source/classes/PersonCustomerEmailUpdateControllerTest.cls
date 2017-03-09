@isTest(SeeAllData=true)
public class PersonCustomerEmailUpdateControllerTest {

    static testMethod void PersonCustomerEmail1(){
         // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '0987654';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
  
        Permission__c per = new Permission__c();
        per.Nej_til_markedsforing__c = true;
        per.Driftsinfo_pa_email__c=true;
        per.E_kommunikation__c = false;
        per.Customer__c = acc.Id;
        insert per;
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockHttpResponse());
        ApexPages.StandardController controller = new ApexPages.StandardController(acc);
        PersonCustomerEmailUpdateController con = new PersonCustomerEmailUpdateController(controller);
        con.editEmail();
        con.updateEmail();
    }
    static testMethod void PersonCustomerEmail2(){
         RecordType objRec = [Select id,Name from RecordType where DeveloperName = 'YK_Customer_Account'];
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
        Test.setMock(HttpCalloutMock.class, new NFCallOutMockHttpResponse());
        ApexPages.StandardController controller = new ApexPages.StandardController(objAccount);
        PersonCustomerEmailUpdateController con = new PersonCustomerEmailUpdateController(controller);
        con.editEmail();
        con.emailvalidateFlag = false;
        con.updateEmail();
         con.pc = new Permission__c();
        HttpResponse res = new HttpResponse();
        con.pc.Marketing_Permission__c = true;
        con.email='';
		res.setBody('{"emailAddr":"","invoiceMedia":"PAPIR","isCcCustomer":"0","isEInvoiceCustomer":"0","mobileNo":"","paymentMethod":"Giro","paymentNotificationMethod":"","status":"0","errorMessage":""}');        
    	res.setStatusCode(200);
        con.updatePersonEmail(res);
        con.pc.Marketing_Permission__c = false;
		con.updatePersonEmail(res);
        res.setBody('{"emailAddr":"","invoiceMedia":"PDFMAIL","isCcCustomer":"0","isEInvoiceCustomer":"0","mobileNo":"","paymentMethod":"CC","paymentNotificationMethod":"","status":"0","errorMessage":""}');        
    	con.updatePersonEmail(res);
        res.setBody('{"emailAddr":"","invoiceMedia":"PDFMAIL","isCcCustomer":"0","isEInvoiceCustomer":"0","mobileNo":"","paymentMethod":"CC","paymentNotificationMethod":"","status":"1","errorMessage":""}');        
    	con.updatePersonEmail(res);
    }
}