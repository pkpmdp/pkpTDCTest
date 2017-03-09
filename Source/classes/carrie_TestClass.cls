@isTest (SeeAllData=true) 
public with sharing class carrie_TestClass {
	
	static testMethod void testCarrieBatchforariaSchedular()
	{
		CarrieBatchforariaSchedular car = new CarrieBatchforariaSchedular();
		SchedulableContext sc;
		car.execute(sc);
	}
	static testMethod void testCarrieBatchforcustSchedular()
	{
		CarrieBatchforcustSchedular car = new CarrieBatchforcustSchedular();
		SchedulableContext sc;
		car.execute(sc);
	}
	
	static testMethod void testCarrieCustomersBatch()
	{
		Account account;
		RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        Account account1;
        RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account1 = new Account();                     
        account1.RecordTypeId =recordType1.Id;
        account1.Status_YK__c = 'Active';
        account1.FirstName = 'Test'; 
        account1.LastName = 'Test';
        account1.Invoice_Test__c = true;
        account1.Customer_response__c = 'Neutral omkring ændring';
        account1.Customer_No__c='981920'; 
        insert account1;
        
        list<Account> listAcc = new list<Account>();
        listAcc.add(account);
        listAcc.add(account1);
        
		CarrieCustomersBatch car = new CarrieCustomersBatch();
		car.query = 'select id,Customer_No__c from Account where IsDirty__c =true limit 10';
		Database.BatchableContext BC;
		car.start(BC);
		car.execute(BC, listAcc);
		car.finish(BC);
	}
	
	static testMethod void testCarrieFinalUpdateBatch()
	{
		Account account;
		RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        Account account1;
        
        RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account1 = new Account();                     
        account1.RecordTypeId =recordType1.Id;
        account1.Status_YK__c = 'Active';
        account1.FirstName = 'Test'; 
        account1.LastName = 'Test';
        account1.Invoice_Test__c = true;
        account1.Customer_response__c = 'Neutral omkring ændring';
        account1.Customer_No__c='981920'; 
        insert account1;
        
		Aria_Account__c customer;
		customer = new Aria_Account__c();
        customer.Account__c  = account.Id;
        customer.Aria_Account_No__c=3648207;
        customer.Name='3648207'; 
        customer.Aria_Plan_Name__c='Temp';
        customer.API_calls__c = 'Transaction Created';
        customer.Regningsstatus__c = 'ACTIVE';
        insert customer;
        
        Aria_Account__c customer1;
		customer1 = new Aria_Account__c();
        customer1.Account__c  = account1.Id;
        customer1.Aria_Account_No__c=3648206;
        customer1.Name='3648206'; 
        customer1.Aria_Plan_Name__c='Temp';
        customer1.API_calls__c = 'Transaction Created';
        customer1.Regningsstatus__c = 'ACTIVE';
        insert customer1;	
        
        list<Aria_Account__c> listAria = new list<Aria_Account__c>();
        listAria.add(customer);
        listAria.add(customer1);
        
        CarrieFinalUpdateBatch car = new CarrieFinalUpdateBatch();
        car.query = 'Select LastModifiedDateAria__c, API_calls__c, Updated__c, Id from Aria_Account__c where (API_calls__c = \'Transaction Created\' or  API_calls__c = \'\') limit 10';
        //Database.BatchableContext BC;
        Database.executeBatch(car);
        //car.start(BC);
        //car.execute(BC, listAria);
        //car.finish(BC);
	}
	static testmethod void testCarrieAriaBatch()
	{
		Account account;
		RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Test'; 
        account.LastName = 'Test';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='981929'; 
        insert account;
        Account account1;
        
        RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        account1 = new Account();                     
        account1.RecordTypeId =recordType1.Id;
        account1.Status_YK__c = 'Active';
        account1.FirstName = 'Test'; 
        account1.LastName = 'Test';
        account1.Invoice_Test__c = true;
        account1.Customer_response__c = 'Neutral omkring ændring';
        account1.Customer_No__c='981920'; 
        insert account1;
        
        list<Account> listAcc = new list<Account>();
        listAcc.add(account);
        listAcc.add(account1);
        
        CarrieAriaBatch car = new CarrieAriaBatch();
        car.query = 'Select Name, Updated__c,Account__r.Customer_No__c, a.LastModifiedDate, a.LastModifiedDateAria__c, a.Aria_Plan_Name__c, a.CurrentSaldo__c,a.Indbetalt__c, a.Rykkerstatus__c, a.Rykkerdato__c, a.Regningsstatus__c, a.Momspligtigt_bel_b__c, a.Id, a.Faktureret1__c, a.Aria_Pay_Method__c, a.Aria_Last_Bill_Date__c,a.Days_in_Dunning__c, a.Aria_Account_No__c,a.Account__c, a.Account__r.AddressId__c, a.Betaler__c From Aria_Account__c a  where Account__r.IsDirty__c =true limit 10';
        Database.executeBatch(car);
	}
	
}