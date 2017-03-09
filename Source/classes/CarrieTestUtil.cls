/***********************************************************************************
************************************************************************************

* @class: CarrieTestUtil
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: This is a utility class for test class. 

************************************************************************************
***********************************************************************************/
public with sharing class CarrieTestUtil {
    
    /**
    * @description: This method is used to insert User.
    * @return: User.
    */
    public static User insertUser(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%API User Profile%']; 
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User testUser = new User(alias = 'standt', email='abc@test.com',title='kunderådgiver',
                                emailencodingkey='UTF-8', lastname='Chokkam', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profiles[0].Id, 
                                timezonesidkey='America/Los_Angeles', username='RamChokam@test.com'); 
        testUser.setOptions(dmo);
        testUser.MID__c = 'M78447VVMP';
        insert testUser;
        return testUser;
    }
    
    /**
    * @description: This method is used to insert Account.
    * @return: Account.
    */
    
    public static Account insertCustomer(){
    	RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
        Account customer = new Account();
        customer.RecordTypeId =recordType.Id;
        customer.Status_YK__c = 'Active';
        customer.FirstName = 'Temp1'; //SPOC-1396
        customer.LastName = 'Temp';
        customer.Invoice_Test__c = true;
        customer.Customer_response__c = 'Neutral omkring ændring';
        customer.Customer_No__c='981929';  
        insert customer;
        return customer;
    }
    
    /**
    * @description: This method is used to insert Aria Account.
    * @return: Aria Account.
    */
    public static Aria_Account__c insertAccount(){
		Account customer = insertCustomer();
        Aria_Account__c ariaCustomer = new Aria_Account__c();
        ariaCustomer.Account__c  = customer.Id;
        ariaCustomer.Aria_Account_No__c=3648207;
        ariaCustomer.Name='3648207'; 
        ariaCustomer.Aria_Plan_Name__c='Temp';
        insert ariaCustomer;
        return ariaCustomer;
    }
    
    
    
}