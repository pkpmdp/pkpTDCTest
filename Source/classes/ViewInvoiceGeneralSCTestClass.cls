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
private class ViewInvoiceGeneralSCTestClass {

    /*private static void createTestData() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acc1 = new Account(Name='TestExec Acct1');
        acc1.RecordTypeId = recordType.Id;
        Account acc2 = new Account(Name='TestExec LegalAcct2');
        acc2.RecordTypeId = recordType.Id;
        acc2.Customer_No__c = '2576354';
        Account acc3 = new Account(Name='TestExec PaymentAcct2');
        acc3.RecordTypeId = recordType.Id;
        acc3.Customer_No__c = '2572458';
        insert new Account[]{acc1,acc2,acc3};
        
        Cable_Unit__c cu = new Cable_Unit__c(Name='9892498781',Legal_Account_No__c = acc2.Id,Payment_Account_No__c = acc3.id);
        insert cu;
        
        acc1.Cable_Unit__c = cu.Id;
        upsert acc1;
    
    }*/
    
    static testMethod void testInvoiceGeneral(){
        
        try{
            Test.startTest();
            String portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
            Profile p = [select id from profile where name=:portalAdminUser];
            
            Cable_Unit__C cableunit = new Cable_Unit__C();
            cableunit.name = '12345';
            cableunit.Cable_Unit_No__c = '123456';
            cableunit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
            cableunit.Municipaly__c = clsTestDataForYS.getMunicipaly();
            cableunit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
            cableunit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
            cableunit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
            cableunit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
            insert cableunit;
            
             RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        
      		  Account acc = new Account(Name='TestAccount');
      		  acc.RecordTypeId = recordType.Id;
      		  acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
       		 insert acc;
             
            //createTestData();
            PageReference pageRef = Page.ViewInvoiceGeneral;
            Test.setCurrentPage(pageRef);
         //  Apexpages.currentpage().getparameters().put('cableunitnumber', cableunit.Cable_Unit_No__c);
         //   Apexpages.currentpage().getparameters().put('accountTypeId',account.Id);
            //Test.startTest();
			ApexPages.currentPage().getParameters().put('accountId','0012000000W5UOQAA3');
            ViewInvoiceGeneralController invGenController = new ViewInvoiceGeneralController();
            //Apexpages.currentpage().getparameters().put('accountTypeId',acc.Id);
            ApexPages.CurrentPage().getParameters().put('cableunitnumber', cableunit.Cable_Unit_No__c);
            invGenController.getCableunitName();
            invGenController.getLegalAccId();
            invGenController.getLegalAccNumber();
            invGenController.getPaymentAccId();
            invGenController.getPaymentAccNumber();
            invGenController = new ViewInvoiceGeneralController();
            
        }catch(System.Exception e){
            system.debug('Error'+e.getMessage());
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            Test.stopTest();
        }
                       
    }
}