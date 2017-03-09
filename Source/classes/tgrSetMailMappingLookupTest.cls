/**
 Test for trigger tgrSetMailMappingLookup
 */
@isTest
private class tgrSetMailMappingLookupTest {


    static testMethod void setMailMappingLookupYK() {
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Klik_KS_PlusXXX';
        m.Technical_Mapping_Name__c = 'Technical_Klik_KS_PlusXXX';
        m.Web_Link__c = '{663C6842-AB1A-4A93-B615-6450ECC69744}';
        m.Template_Group__c = 'YK';
        insert m;
        
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
                
        RecordType recordType = [ Select Id From RecordType Where SobjectType = 
        'Customer_Information_Request__c' and IsActive = true and Name = 'Editable Information Request'];
        
        Customer_Information_Request__c cir = new Customer_Information_Request__c();
        cir.Account__c=acc.Id;
        cir.Email__c='example@example.dk';
        cir.New_Template__c='Klik_KS_PlusXXX';
        cir.RecordTypeId = recordType.Id;
        insert cir;
        Customer_Information_Request__c newCir = [Select Mail_Mapping__c
        from Customer_Information_Request__c where Id =: cir.Id ];      
        
        //Mail_Mapping__c newMapping = [Select id
        //from Mail_Mapping__c where Technical_Mapping_Name__c = 'Technical_Klik_KS_Plus']; 
        
        System.assertEquals( m.id , newCir.Mail_Mapping__c);
        
        
    }
    
    static testMethod void setMailMappingLookupYO() {
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Klik_KS_PlusYOXXX';
        m.Technical_Mapping_Name__c = 'Technical_Klik_KS_PlusYOXXX';
        m.Web_Link__c = '{663C6842-AB1A-4A93-B615-6450ECC69744}';
        m.Template_Group__c = 'YO';
        insert m;
        
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
                
        RecordType recordType = [ Select Id From RecordType Where SobjectType = 
        'Customer_Information_Request__c' and IsActive = true and Name = 'Editable Information Request YO'];
        
        Customer_Information_Request__c cir = new Customer_Information_Request__c();
        cir.Account__c=acc.Id;
        cir.Email__c='example@example.dk';
        cir.New_Template__c='Klik_KS_PlusYOXXX';
        cir.RecordTypeId = recordType.Id;
        insert cir;
        Customer_Information_Request__c newCir = [Select Mail_Mapping__c
        from Customer_Information_Request__c where Id =: cir.Id ];      
        
        //Mail_Mapping__c newMapping = [Select id
        //from Mail_Mapping__c where Technical_Mapping_Name__c = 'Technical_Klik_KS_PlusYO']; 
        
        System.assertEquals( m.id , newCir.Mail_Mapping__c);
       
    }
    
}