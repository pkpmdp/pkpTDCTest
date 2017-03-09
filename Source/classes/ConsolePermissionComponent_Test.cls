@isTest(SeeAllData=true)
private class ConsolePermissionComponent_Test {

    static testMethod void testMethodConsolePermissionComponent_Test() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        
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
        customer.PersonEmail = 'Test@test.com';
        insert customer;
        
        Account customer1 = new Account();
        customer1.RecordTypeId =recordType.Id;
        customer1.Status_YK__c = 'Active';
        customer1.FirstName = 'Temp1';  
        customer1.LastName = 'Temp';
        customer1.Invoice_Test__c = true;
        customer1.Customer_response__c = 'Neutral omkring ændring';
        customer1.Customer_No__c='981930';  
        customer1.PersonEmail = 'Test244@test.com';
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
        //ApexPages.StandardController standardController = new ApexPages.StandardController(customer);
        ConsolePermissionComponent_CT pcont = new ConsolePermissionComponent_CT();
        pcont.AccStrId = customer.Id;
        pcont.getPermission();
        
        pcont.objpermission.Driftsinfo_pa_email__c= true;
        pcont.objpermission.Driftsinfo_pa_email_Opdateret_af__c='A123456';
        pcont.objpermission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
        
        pcont.save();
        pcont.objpermission.Driftsinfo_pa_SMS__c = true;
        pcont.objpermission.Driftsinfo_pa_SMS_Opdateret_af__c = '67854976';
        pcont.objpermission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
        pcont.save();
        //pcont.autoRefreshPage();
        pcont.updatedByField('6578769');
        pcont.updatedByField('M124365');
        pcont.updatedByField('T124365');
        pcont.objpermission.Driftsinfo_pa_email__c= true;
        pcont.objpermission.Driftsinfo_pa_SMS__c = true;
        pcont.objpermission.Nej_til_markedsforing__c = true;
        pcont.objpermission.Nej_til_Telefonopkald__c = true;
        pcont.objpermission.Marketing_Permission__c = true;
        pcont.objpermission.E_kommunikation__c = true;
        pcont.updatePermissionsDateFields();
        pcont.objpermission.E_kommunikation__c = true;
        pcont.objpermission.E_kommunikation_Opdateret_af__c = 'M31102';
        pcont.objpermission.E_kommunikation_Opdateret_Dato__c = Date.today();
        pcont.objpermission.Nej_til_markedsforing__c = true;
        pcont.objpermission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        pcont.objpermission.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        pcont.updateFlag = false;
        pcont.save();
        pcont.objpermission.Driftsinfo_pa_email__c= false;
        pcont.objpermission.Driftsinfo_pa_SMS__c = false;
        pcont.objpermission.Nej_til_markedsforing__c = false;
        pcont.objpermission.Nej_til_Telefonopkald__c = false;
        pcont.objpermission.Marketing_Permission__c = false;
        pcont.objpermission.E_kommunikation__c = false;
        pcont.updatePermissionsDateFields();
        pcont.objpermission.E_kommunikation__c = false;
        pcont.objpermission.E_kommunikation_Opdateret_af__c = 'M31102';
        pcont.objpermission.E_kommunikation_Opdateret_Dato__c = Date.today();
        pcont.objpermission.Nej_til_markedsforing__c = false;
        pcont.objpermission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        pcont.objpermission.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        pcont.updatePermissionsDateFieldsOnUpdate();       
        //ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer1);
        ConsolePermissionComponent_CT pcont1 = new ConsolePermissionComponent_CT();
        
        pcont1.save();
    }
    
    static testMethod void testremConsolePermissionComponent() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        
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
        customer.PersonEmail = 'West@test.com';
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
        permissionTest.E_kommunikation__c = false;
        permissionTest.E_kommunikation_Opdateret_af__c = 'M31102';
        permissionTest.E_kommunikation_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = true;
        //permissionTest.Old_E_kommunikation_c__c = true; 
        insert permissionTest;
        
        Test.startTest();
        //ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer);
        ConsolePermissionComponent_CT pcont1 = new ConsolePermissionComponent_CT();
        pcont1.getPermissionRecord(customer.id);
        pcont1.setPermission(permissionTest);
        pcont1.convertDateFormat(System.today());
        pcont1.save();
        Test.stopTest();
    }
    
    static testMethod void testSavePermission() {
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = [Select lastNumber__c from CustomerNumberSeq__c];
        
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
        permissionTest.Nej_til_markedsforing__c = false;
        permissionTest.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
        permissionTest.Nej_til_markedsforing_Opdateret_af__c = '6578765';
        permissionTest.Marketing_Permission__c = true;
        insert permissionTest;
        
        Test.startTest();
        //ApexPages.StandardController standardController1 = new ApexPages.StandardController(customer);
        ConsolePermissionComponent_CT pcont1 = new ConsolePermissionComponent_CT();
        pcont1.getPermissionRecord(customer.id);
        pcont1.setPermission(permissionTest);
        pcont1.save();
        Test.stopTest();
    }
}