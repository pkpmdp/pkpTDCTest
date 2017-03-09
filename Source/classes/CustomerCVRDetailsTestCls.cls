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
@isTest(seeAllData=true)
public class CustomerCVRDetailsTestCls{

 static testMethod void singleCustomerTeamRoleDetailsTest() {    
     
     	
        CustomerCVRDetails.CustomerCVRWrapper cWrapObj = new CustomerCVRDetails.CustomerCVRWrapper();
        cWrapObj.cvrno = '123456';
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customers';
        RestContext.request.addParameter('action', 'getcustomercvr');   
        CustomerCVRDetails.getAction();
        List<CustomerCVRDetails.CustomerCVRWrapper> customerWrpList = CustomerCVRDetails.getCustomerCVRDetails();
        List<Account> accList  = [SELECT Id,CVR_Number__c,Customer_No__c,Cable_unit_no__c,RecordTypeId FROM Account limit 1]; 
        List<CustomerCVRDetails.CustomerCVRWrapper> cWrapObj2 = CustomerCVRDetails.getMapToCustomerList(accList);
    }
	
	
    //test role id null
    static testMethod void singleCustomerTeamRoleDetailsTest2() { 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customers';
        //RestContext.request.addParameter('action', '');   
        CustomerCVRDetails.getAction();   
        List<CustomerCVRDetails.CustomerCVRWrapper> customerWrpList = CustomerCVRDetails.getCustomerCVRDetails();
        //CustomerCVRDetails.getMapToCustomerList();
    }
    
    // test passing a cable unit number
    
	static testMethod void singleCvrDetails() { 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customers';
        RestContext.request.addParameter('action', 'getcustomercvr');
          
        
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.CVR_Number__c = '124578';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Cable_Unit_No__c = '111';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;  
        
        RestContext.request.addParameter('cableunitno', cableUnitTest.Cable_Unit_No__c);
        
        CustomerCVRDetails.getAction();   
        List<Account> accList1  = [SELECT Id,CVR_Number__c,Customer_No__c,Cable_unit_no__c,RecordTypeId FROM Account where ID =: acc.ID limit 1]; 
        List<CustomerCVRDetails.CustomerCVRWrapper> cWrapObj2 = CustomerCVRDetails.getMapToCustomerList(accList1);
        List<CustomerCVRDetails.CustomerCVRWrapper> customerWrpList = CustomerCVRDetails.getCustomerCVRDetails();
        CustomerCVRDetails.getMapToCustomerList(accList1);
    }
}