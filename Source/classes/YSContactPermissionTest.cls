@isTest
public with sharing class YSContactPermissionTest {
    
    static testMethod void myUnitTest() {
        User YSSalesUser = [Select Id from User where username like 'suser@salesforce.com%'];
        System.runAs(YSSalesUser){
            Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact() ;
            contact.Permission__c=true;
            contact.Email='tejas.naik@capgemini.com';
            update contact;
            //tejas code
            Account account1 = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
            //Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();        
            Account_Contact_Role__c acr1 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, account1.id);
            
           
            /*Apexpages.currentpage().getparameters().put('cuid',contact.Account.Cable_Unit_No__c);
            Apexpages.currentpage().getparameters().put('secur',contact.SecurityCode__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(contact);
            ContactLoginController con = new ContactLoginController(sc);
            PageReference permissionPage = con.Login(); */
            
            Apexpages.currentpage().getparameters().put('aid',account1.id); 
            Apexpages.currentpage().getparameters().put('id',contact.id);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(contact);
            ContactPermissionController con1 = new ContactPermissionController(sc1);
             
            con1.selectclick();
            con1.unselectclick();
            con1.getunSelectedValues();
            con1.getSelectedValues();
            con1.email = 'wm@test.dk';
            system.debug('Tejas contact obj'+ contact);
            con1.permission=true;
            con1.saveContact();
            //con1.hasPermissionBefore(contact);
            
        }      
    } 

	static testMethod void myUnitTest1() {
		Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact() ;
		Apexpages.currentpage().getparameters().put('cuid',contact.Account.Cable_Unit_No__c);
		Apexpages.currentpage().getparameters().put('secur',contact.SecurityCode__c);
		ApexPages.StandardController sc = new ApexPages.StandardController(contact);
    	ContactLoginController con = new ContactLoginController(sc);
    	PageReference permissionPage = con.Login();
	}   
}