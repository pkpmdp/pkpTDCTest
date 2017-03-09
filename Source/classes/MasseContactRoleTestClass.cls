/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MasseContactRoleTestClass {

    static testMethod void myUnitTest() {
    	
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        // following lines are added by Navneet for populating records from custom settings
        String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;//012200000000nf3
        String customerRecordType2 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID2__c;//012200000000nf3AAA
        
        User YSSalesUser = [Select Id from User where username like 'suser@salesforce.com%'];
        System.runAs(YSSalesUser) {
        /*Lookup_Contact_Roles__c role1 = 
            new Lookup_Contact_Roles__c(Name = 'Rolle10', Start_Date__c = Date.valueOf('2012-01-01'),
                                        End_Date__c = Date.valueOf('2019-12-31'), SourceId__c = 'rolle10-Id',
                                        Code__c = 'Rolle10');*/
        Lookup_Contact_Roles__c role1 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Role10');                                
        
        /*KISS_Role_Validation_Rules__c rule1 = 
            new KISS_Role_Validation_Rules__c( Name = 'Rolle10',
                                               Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde');
        
        Address__c address = new Address__c(Name= 'Klostervangen', Active__c = true, External_Id__c = 'test454',
	        				      				House_No__c = '34', Postcode__c = '3360');
	    insert address;
	        				      				
        Contact contact = new Contact();
        contact.FirstName = 'test';
        contact.LastName = 'test';
        contact.MobilePhone = 'test';
        contact.Street_P__c = address.Id;
        contact.KissPartyId__c = 'test';
        
        
        insert contact;
        insert role1;*/
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact() ;
        //rule1.Contact_Roles__c = role1.id; 
        //insert rule1;
        
        /*Cable_Unit__c cableUnit = new Cable_Unit__c();
        Lookup_Building_Type__c bt1 = new Lookup_Building_Type__c(Code__c='bt1', Start_Date__c = Date.valueOf('2012-01-01'),
                                        End_Date__c = Date.valueOf('2019-12-31'), SourceId__c='bt1-Id');
        insert bt1;
        Lookup_Housing_Type__c ht1 = new Lookup_Housing_Type__c(Code__c='ht1', Start_Date__c = Date.valueOf('2012-01-01'),
                                        End_Date__c = Date.valueOf('2019-12-31'), SourceId__c='ht1-Id');
        insert ht1;
        
        Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
		customerSegment.Name = 'ParceInt_Test'; 
        customerSegment.Code__c = 'pnetTest'; 
        customerSegment.SourceId__c = 'PCRM-seg---98777511';
        insert customerSegment;
        
        Lookup_Housing_Ownership__c ho1 = new Lookup_Housing_Ownership__c(Code__c='ho1', Start_Date__c = Date.valueOf('2012-01-01'),
                                        End_Date__c = Date.valueOf('2019-12-31'), SourceId__c='ho1-Id');
        insert ho1;
        
        cableUnit.Building_Type__c = bt1.id; 
        cableUnit.Housing_Ownership__c = ho1.id;
        cableUnit.Housing_Type__c = ht1.id;  
        cableUnit.Municipaly__c = 'byen'; 
        cableUnit.Cable_Unit_Post_Code__c = '2000';                            
        insert cableUnit;
        
        Account acc = new Account();
        acc.Name = 'Test Customer';
        acc.Customer_No__c = '5436789';
        acc.recordtypeId = customerRecordType2;         
        acc.Cable_Unit__c = cableUnit.Id;
        acc.Customer_Segment_Lookup__c = customerSegment.id;
        acc.Housing_Ownership_Lookup__c = ho1.id;
        insert acc;*/
        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        
        
        Account_Contact_Role__c acr = new Account_Contact_Role__c(Contact__c = contact.Id,Customer__c = acc.Id, Role__c = role1.Id);
        insert acr;
        
        
        
    	Account_Contact_Role__c acr1 = new Account_Contact_Role__c();
    	acr1.Customer__c = acr.Customer__c;
    	Apexpages.currentpage().getparameters().put('cid',contact.Id);
    	ApexPages.StandardController sc = new ApexPages.StandardController(acr1);
        MasseContactRoleController con = new MasseContactRoleController(sc);             
        con.acr = acr1;
        con.acr.Customer__c = acr1.Customer__c;            
        con.getContactRoles();
        con.selectclick2();
        con.unselectclick2();
        con.getunSelectedValues2();
        con.getSelectedValues2();
        con.cancel();
        con.save();
        }
    }
}