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
* See the Apex Language Reference for more information about Testing and Code Coverage. @isTest
*/

@isTest
public class CableUnitDetailsControllerSCTestClass {
    
    static testMethod void testCableUnitDetails() {
        Id conId;
        
        Account accountsTemp = null;
        String telephony = Label.SC_Ja;
        
        Cable_Unit__c c = new Cable_Unit__c();
        c.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        c.Name = 'cu_kundeCust_testing'; 
        c.Municipaly__c = clsTestDataForYS.getMunicipaly();
        c.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        c.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                     
        c.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        c.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        c.Cable_Unit_No__c = '0000000435';        
        insert c;
        
        ApexPages.CurrentPage().getParameters().put('cableunitnumber',c.Cable_Unit_No__c);
        
        SalesConcept__c salesConObj = new SalesConcept__c();
        salesConObj.Solution__c = 'Indholdsbeskrivelse mangler';
        salesConObj.TVandRadio__c = 1.0 ;
        salesConObj.Broadband__c = 2.0 ;
        salesConObj.Telephony__c = 3.0 ;
        salesConObj.SC_Source_Id__c = 'OAS';
        insert salesConObj;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj.Name = 'A:6000545:201134';
        oppObj.StageName = 'Potentiel';
        oppObj.CloseDate = Date.valueOf('2012-03-03');
        insert oppObj;
        
        List<Cable_Unit__c> cableUnitList = new List<Cable_Unit__c>();
        Cable_Unit__c cableUnitObj1 = new Cable_Unit__c(); 
        cableUnitObj1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnitObj1.Name = 'cu_kundeCust_testing4'; 
        cableUnitObj1.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitObj1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitObj1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership1();                   
        cableUnitObj1.Housing_Type__c = clsTestDataForYS.createLookupHousingType1();                  
        cableUnitObj1.Building_Type__c = clsTestDataForYS.createLookupBuildingType1();      
        cableUnitObj1.Current_Kiss_Case__c = oppObj.Id;
        cableUnitObj1.Status__c = 'Running';
        cableUnitObj1.Name = 'B';
        
        Cable_Unit__c cableUnitObj2 = new Cable_Unit__c(); 
        cableUnitObj2.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnitObj2.Name = 'cu_kundeCust_testing'; 
        cableUnitObj2.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitObj2.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitObj2.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership2();                      
        cableUnitObj2.Housing_Type__c = clsTestDataForYS.createLookupHousingType2();                  
        cableUnitObj2.Building_Type__c = clsTestDataForYS.createLookupBuildingType2();           
        cableUnitObj2.Current_Kiss_Case__c = oppObj.Id;
        cableUnitObj2.Status__c = '99';
        
        cableUnitList.add(cableUnitObj1);
        cableUnitList.add(cableUnitObj2);
        insert cableUnitList;
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Hierarchy Account'];
        Account acc = new Account(Name='TestAccount');
        acc.RecordTypeId = recordType.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        acc.Cable_Unit__c = c.id;
        insert acc;
        ApexPages.currentPage().getParameters().put('accountId',acc.Id);
        CableUnitDetailsController cuDetailsObj = new CableUnitDetailsController();
        cuDetailsObj.tvRadio = 'gp';
        cuDetailsObj.broadband = 'Yes';
        cuDetailsObj.telephony = 'present';
        cuDetailsObj.status = '4';
        cuDetailsObj.getStatus();
        cuDetailsObj.status = '99';
        cuDetailsObj.getStatus();
        cuDetailsObj.status = '0';
        cuDetailsObj.getStatus();
        cuDetailsObj.status = '2';
        cuDetailsObj.getStatus();
        cuDetailsObj.cancel(); 
        cuDetailsObj.getCableUnitName();
        cuDetailsObj.getContactId();
        cuDetailsObj.setContactId(conId);
        cuDetailsObj.getStatus();
        cuDetailsObj.getSolution();
        
         CableUnitDetailsController_SPOC2411 cuDetailsObj2 = new CableUnitDetailsController_SPOC2411();
        cuDetailsObj2.tvRadio = 'gp';
        cuDetailsObj2.broadband = 'Yes';
        cuDetailsObj2.telephony = 'present';
        cuDetailsObj2.status = '4';
        cuDetailsObj2.getStatus();
        cuDetailsObj2.status = '99';
        cuDetailsObj2.getStatus();
        cuDetailsObj2.status = '0';
        cuDetailsObj2.getStatus();
        cuDetailsObj2.status = '2';
        cuDetailsObj2.getStatus();
        cuDetailsObj2.cancel(); 
        cuDetailsObj2.getCableUnitName();
        cuDetailsObj2.getContactId();
        cuDetailsObj2.setContactId(conId);
        cuDetailsObj2.getStatus();
        cuDetailsObj2.getSolution();
        ApexPages.currentPage().getParameters().put('accountId','abc');
        ApexPages.CurrentPage().getParameters().put('cableunitnumber',null);
        CableUnitDetailsController cuDetailsObj1 = new CableUnitDetailsController();
        cuDetailsObj1.tvRadio = 'gp';
        cuDetailsObj1.broadband = 'Yes';
        cuDetailsObj1.telephony = 'present';
        cuDetailsObj1.status = '4';
        cuDetailsObj1.getStatus();
        cuDetailsObj1.status = '99';
        cuDetailsObj1.getStatus();
        cuDetailsObj1.status = '0';
        cuDetailsObj1.getStatus();
        cuDetailsObj1.status = '2';
        cuDetailsObj1.getStatus();
        cuDetailsObj1.cancel(); 
        cuDetailsObj1.getCableUnitName();
        cuDetailsObj1.getContactId();
        cuDetailsObj1.setContactId(conId);
        cuDetailsObj1.getStatus();
        cuDetailsObj1.getSolution();
        
        
        CableUnitDetailsController_SPOC2411 cuDetailsObj3 = new CableUnitDetailsController_SPOC2411();
        cuDetailsObj3.tvRadio = 'gp';
        cuDetailsObj3.broadband = 'Yes';
        cuDetailsObj3.telephony = 'present';
        cuDetailsObj3.status = '4';
        cuDetailsObj3.getStatus();
        cuDetailsObj3.status = '99';
        cuDetailsObj3.getStatus();
        cuDetailsObj3.status = '0';
        cuDetailsObj3.getStatus();
        cuDetailsObj3.status = '2';
        cuDetailsObj3.getStatus();
        cuDetailsObj3.cancel(); 
        cuDetailsObj3.getCableUnitName();
        cuDetailsObj3.getContactId();
        cuDetailsObj3.setContactId(conId);
        cuDetailsObj3.getStatus();
        cuDetailsObj3.getSolution();
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CableUnitCalloutMock());
        PageReference page= cuDetailsObj.FetchCableUnitdata();
        
        Test.setMock(HttpCalloutMock.class, new CableUnitCalloutMock());
        PageReference page1= cuDetailsObj1.FetchCableUnitdata();
        
        Test.setMock(HttpCalloutMock.class, new CableUnitCalloutMock());
        PageReference page3= cuDetailsObj2.FetchCableUnitdata();
        
        Test.setMock(HttpCalloutMock.class, new CableUnitCalloutMock());
        PageReference page4= cuDetailsObj3.FetchCableUnitdata();
        Test.stopTest();
       
        cuDetailsObj.getCableUnitName();        
        cuDetailsObj1.getCableUnitName();        
        cuDetailsObj2.getCableUnitName();
        cuDetailsObj3.getCableUnitName();
        // cuDetailsObj.getTvRadio();
        //cuDetailsObj.getBroadband();
        // cuDetailsObj.getTelephony();
    }
    
    public class CableUnitCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Test Response');
            return res;
        }
    }
}