/***********************************************************************************
************************************************************************************

* @class: Yousee13LoginControllerTestClass
* @version History : 1.0
* @date: 18/12/2012
* @description: Test Class for Yousee13LoginController.

************************************************************************************ 
***********************************************************************************/

@isTest(SeeAllData=true)
private class Yousee13LoginControllerTestClass {
    
    
    static ApexPages.StandardController sc;

    /**
    * @description: This method is used to test positive flow sceanrio for region Jutland 
    */
    static testMethod void testLoginPositiveFlow1() {
        List<Account_Contact_Role__c> acrs = [Select a.Customer__r.Customer_No__c, a.Contact__r.SecurityCode__c, a.Contact__r.Post_Code_P__c From Account_Contact_Role__c a where a.Contact__r.SecurityCode__c != null and a.Contact__r.Post_Code_P__c > '4999' limit 1];
        String customerNo = acrs[0].Customer__r.Customer_No__c;
        String securityCode = acrs[0].Contact__r.SecurityCode__c;
      
        Yousee13LoginController contr = new Yousee13LoginController(sc);
        contr.cuid = customerNo; 
        contr.secur = securityCode; 
        contr.Login(); 
    }        
   
    
   /**
    * @description: This method is used to test positive flow sceanrio for region Shetland 
    */
    static testMethod void testLoginPositiveFlow2() {
        List<Account_Contact_Role__c> acrs = [Select a.Customer__r.Customer_No__c, a.Contact__r.SecurityCode__c, a.Contact__r.Post_Code_P__c From Account_Contact_Role__c a where a.Contact__r.SecurityCode__c != null and a.Contact__r.Post_Code_P__c > '2999' and a.Contact__r.Post_Code_P__c < '4999' limit 1];
        String customerNo = acrs[0].Customer__r.Customer_No__c;
        String securityCode = acrs[0].Contact__r.SecurityCode__c;
      
        Yousee13LoginController contr = new Yousee13LoginController(sc);
        contr.cuid = customerNo; 
        contr.secur = securityCode; 
        contr.Login(); 
    }    
   
    /**
    * @description: This method is used to test positive flow sceanrio for Copenhagen region
    */
    static testMethod void testLoginPositiveFlow3() {
        List<Account_Contact_Role__c> acrs = [Select a.Customer__r.Customer_No__c, a.Contact__r.SecurityCode__c, a.Contact__r.Post_Code_P__c From Account_Contact_Role__c a where a.Contact__r.SecurityCode__c != null and a.Contact__r.Post_Code_P__c < '2999' limit 1];
        String customerNo = acrs[0].Customer__r.Customer_No__c;
        String securityCode = acrs[0].Contact__r.SecurityCode__c;
      
        Yousee13LoginController contr = new Yousee13LoginController(sc);
        contr.cuid = customerNo; 
        contr.secur = securityCode; 
        contr.Login(); 
    }
    
    /**
    * @description: This method is used to test general methods of Yousee13LoginController
    */
    static testMethod void testLoginNegativeFlow1() {
        List<Account_Contact_Role__c> acrs = [Select a.Customer__r.Customer_No__c, a.Contact__r.SecurityCode__c From Account_Contact_Role__c a where a.Contact__r.SecurityCode__c != null limit 1];
        String customerNo = acrs[0].Customer__r.Customer_No__c;
        String securityCode = acrs[0].Contact__r.SecurityCode__c;
      
        Yousee13LoginController contr = new Yousee13LoginController(sc);
        contr.cuid = ''; 
        contr.secur = securityCode; 
        contr.Login(); 
    }
    
     /**
    * @description: This method is used to test general methods of Yousee13LoginController
    */
    static testMethod void testLoginNegativeFlow2() {
        List<Account_Contact_Role__c> acrs = [Select a.Customer__r.Customer_No__c, a.Contact__r.SecurityCode__c From Account_Contact_Role__c a where a.Contact__r.SecurityCode__c != null limit 1];
        String customerNo = acrs[0].Customer__r.Customer_No__c;
        String securityCode = acrs[0].Contact__r.SecurityCode__c;
      
        Yousee13LoginController contr = new Yousee13LoginController(sc);
        contr.cuid = '23232323'; 
        contr.secur = '2323233'; 
        contr.Login(); 
    }
    
}