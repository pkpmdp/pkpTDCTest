@isTest
private class PermissionControllerTestClass {

    static testMethod void testPermissionController2() {
        CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
        cseq.lastNumber__c = 66647566;
        insert cseq;
        
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account customer = new Account();
        customer.RecordTypeId =recordType.Id;
        customer.Status_YK__c = 'Active';
        customer.FirstName = 'Temp1';  
        customer.LastName = 'Temp';
        customer.PersonEmail = 'test.test@cap.com';
        customer.Invoice_Test__c = true;
        customer.Customer_response__c = 'Neutral omkring ændring';
        customer.Customer_No__c='981929';  
        insert customer;
         
        Permission__c permissionTest = new Permission__c();
        permissionTest.Customer__c = customer.id;
        permissionTest.Driftsinfo_pa_SMS__c = false;
        permissionTest.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        permissionTest.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        permissionTest.Driftsinfo_pa_email__c = false;
        //permissionTest.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        permissionTest.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        permissionTest.E_kommunikation__c = false;
        //permissionTest.Old_E_kommunikation__c = false;
        permissionTest.E_kommunikation_Opdateret_af__c = 'M31102';
        permissionTest.E_kommunikation_Opdateret_Dato__c = Date.newinstance(2014, 8, 01);
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = false;
        insert permissionTest;
        Test.startTest();
            ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer);
            PermissionController pcont1 = new PermissionController(standardController1);
            pcont1.getPermissionRecord();
            pcont1.permission.E_kommunikation__c = true;
            pcont1.permission.E_kommunikation_Opdateret_Dato__c = Date.today();
            pcont1.save();
            pcont1.permission.E_kommunikation__c = true;
            pcont1.permission.E_kommunikation_Opdateret_Dato__c = Date.newinstance(2014, 5, 01);
            pcont1.save();
            pcont1.permission.E_kommunikation__c = true;
            pcont1.save();
        Test.stopTest();
    } 
    
    static testMethod void testPermissionController3() {
        CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
        cseq.lastNumber__c = 66647566;
        insert cseq;
        
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account customer = new Account();
        customer.RecordTypeId =recordType.Id;
        customer.Status_YK__c = 'Active';
        customer.FirstName = 'Temp1';  
        customer.LastName = 'Temp';
        customer.PersonEmail = null ;
        customer.Invoice_Test__c = true;
        customer.Customer_response__c = 'Neutral omkring ændring';
        customer.Customer_No__c='981929';  
        insert customer;
         
        Permission__c permissionTest = new Permission__c();
        permissionTest.Customer__c = customer.id;
        permissionTest.Driftsinfo_pa_SMS__c = false;
        permissionTest.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        permissionTest.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        permissionTest.Driftsinfo_pa_email__c = false;
        //permissionTest.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        permissionTest.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        permissionTest.E_kommunikation__c = true;
        //permissionTest.Old_E_kommunikation__c = false;
        permissionTest.E_kommunikation_Opdateret_af__c = 'M31102';
        permissionTest.E_kommunikation_Opdateret_Dato__c = Date.newinstance(2014, 8, 01);
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = false;
        insert permissionTest;
        Test.startTest();
            ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer);
            PermissionController pcont1 = new PermissionController(standardController1);
            pcont1.getPermissionRecord();
            pcont1.permission.E_kommunikation__c = true;
            //pcont1.permission.Old_E_kommunikation__c = true;
            pcont1.permission.E_kommunikation_Opdateret_Dato__c = Date.today();
            pcont1.save();
            pcont1.permission.E_kommunikation_Opdateret_Dato__c = Date.newinstance(2014, 5, 01);
            pcont1.save();
            pcont1.permission.E_kommunikation__c = true;
            //pcont1.permission.Old_E_kommunikation__c = true;
            pcont1.permission.E_kommunikation_Opdateret_Dato__c = null;
            pcont1.save();
            //pcont1.permission.E_kommunikation__c = true;
            //pcont1.save();
            pcont1.accountEmail.Home_Phone__c = null;
            pcont1.accountEmail.PersonMobilePhone = null;
            pcont1.accountEmail.PersonEmail = null;
            pcont1.permission.Marketing_Permission__c = true;
            pcont1.save();
        Test.stopTest();
    }       

         
  static testMethod void testPermissionController() {
        CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
        cseq.lastNumber__c = 63647588;
        insert cseq;
        
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account customer = new Account();
        customer.RecordTypeId =recordType.Id;
        customer.Status_YK__c = 'Active';
        customer.FirstName = 'Temp1';  
        customer.LastName = 'Temp';
        customer.PersonEmail = null;
        customer.Invoice_Test__c = true;
        customer.Customer_response__c = 'Neutral omkring ændring';
        customer.Customer_No__c='981929';  
        insert customer;
        
        Account customer1 = new Account();
        customer1.RecordTypeId =recordType.Id;
        customer1.Status_YK__c = 'Active';
        customer1.FirstName = 'Temp1';  
        customer1.LastName = 'Temp';
        customer1.Invoice_Test__c = true;
        customer1.Customer_response__c = 'Neutral omkring ændring';
        customer1.Customer_No__c='981930';  
        insert customer1;
        
        Permission__c permissionTest = new Permission__c();
        permissionTest.Customer__c = customer.id;
        permissionTest.Driftsinfo_pa_SMS__c = false;
        permissionTest.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        permissionTest.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        permissionTest.Driftsinfo_pa_email__c = false;
        permissionTest.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        permissionTest.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        permissionTest.E_kommunikation__c = false;
        permissionTest.E_kommunikation_Opdateret_af__c = 'M31102';
        permissionTest.E_kommunikation_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = false;
        insert permissionTest;
        ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
        PermissionController pcont = new PermissionController(standardController);
        pcont.permission.Driftsinfo_pa_email__c= true;
        pcont.permission.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        pcont.permission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        pcont.save();
        pcont.permission.Driftsinfo_pa_SMS__c = true;
        pcont.permission.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        pcont.permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        pcont.save();
        pcont.autoRefreshPage();
        pcont.updatedByField('6578769');
        pcont.updatedByField('M124365');
        pcont.updatedByField('T124365');
        pcont.permission.Driftsinfo_pa_email__c= true;
        pcont.permission.Driftsinfo_pa_SMS__c = true;
        pcont.permission.Nej_til_markedsforing__c = true;
        pcont.permission.Nej_til_Telefonopkald__c = true;
        pcont.permission.Marketing_Permission__c = true;
        pcont.permission.E_kommunikation__c = true;
        pcont.updatePermissionsDateFields();
        pcont.permission.E_kommunikation__c = true;
        pcont.permission.E_kommunikation_Opdateret_af__c = 'M31102';
        pcont.permission.E_kommunikation_Opdateret_Dato__c = Date.today();
        pcont.permission.Nej_til_markedsforing__c = true;
        pcont.permission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        pcont.permission.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        pcont.updateFlag = false;
        pcont.save();
        pcont.permission.Driftsinfo_pa_email__c= false;
        pcont.permission.Driftsinfo_pa_SMS__c = false;
        pcont.permission.Nej_til_markedsforing__c = false;
        pcont.permission.Nej_til_Telefonopkald__c = false;
        pcont.permission.Marketing_Permission__c = false;
        pcont.permission.E_kommunikation__c = false;
        pcont.updatePermissionsDateFields();
        pcont.permission.E_kommunikation__c = false;
        pcont.permission.E_kommunikation_Opdateret_af__c = 'M31102';
        pcont.permission.E_kommunikation_Opdateret_Dato__c = Date.today();
        pcont.permission.Nej_til_markedsforing__c = false;
        pcont.permission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        pcont.permission.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        pcont.updatePermissionsDateFieldsOnUpdate();       
        ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer1);
        PermissionController pcont1 = new PermissionController(standardController1);
        pcont1.save();
        
    }   
    
    
    static testMethod void testremPermissionController() {
        CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
        cseq.lastNumber__c = 63647588;
        insert cseq;
        
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        addr.Robinson__c = 'Ja';
        insert addr;    
        
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account customer = new Account();
        customer.RecordTypeId =recordType.Id;
        customer.Status_YK__c = 'Active';
        customer.FirstName = 'Temp1';  
        customer.LastName = 'Temp';
        customer.PersonEmail = null;
        customer.Invoice_Test__c = true;
        customer.Customer_response__c = 'Neutral omkring ændring';
        customer.Customer_No__c='981929';  
        customer.Street_YK__c = addr.id;
        customer.Home_Phone__c = null;
        customer.PersonMobilePhone = null;
        customer.PersonEmail = null;
        insert customer;
        
        Permission__c permissionTest = new Permission__c();
        permissionTest.Customer__c = customer.id;
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
        permissionTest.Marketing_Permission__c = true;
        //permissionTest.Old_E_kommunikation_c__c = true;
        //permissionTest.Old_E_kommunikation__c= false;
        insert permissionTest;
        
        Test.startTest();
        ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer);
        PermissionController pcont1 = new PermissionController(standardController1);
        pcont1.getPermissionRecord();
        pcont1.save();
        Test.stopTest();
    }  
}