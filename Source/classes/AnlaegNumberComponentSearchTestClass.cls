@isTest(SeeAllData = true)
public class AnlaegNumberComponentSearchTestClass {
static testMethod void myUnitTest()
{
    test.startTest();
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Cable_Unit_No__c = '0001234567';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        insert cableUnit;
        
        Account acc = new Account();
        acc.name = 'test';
       // acc.Id ='1dcM000000003klIAA';
      acc.Cable_Unit__c = cableUnit.id;
 //   cableUnit.id = acc.Cable_Unit__c;
     RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
        acc = new Account();                     
        acc.RecordTypeId =recordType.Id;
        acc.Status_YK__c = 'Active';
    
        acc.FirstName = 'Test'; 
        acc.LastName = 'Test';
        acc.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        PageReference prf = Page.SearchonAnlaegNumber;
        prf.getParameters().put('AnlaegNumber', '1234567'); 
        Test.setCurrentPage(prf);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        AnlaegNumberComponentSearchController controller = new AnlaegNumberComponentSearchController(stdController);
    AnlaegNumberComponentSearchController con = new AnlaegNumberComponentSearchController();
        controller.cunumber='1234567';
    List<Cable_Unit__c> cab = [Select c.Cable_Unit_No__c, (Select Id From Accounts__r) From Cable_Unit__c c where c.Cable_Unit_No__c=: '0001245677'];
  system.debug('cab***********'+cab);
 //   controller.cables = [Select c.Cable_Unit_No__c, (Select Id From Accounts__r) From Cable_Unit__c c where c.Cable_Unit_No__c=: '1234567'];
    system.debug('*****controller.cables'+controller.cables);
    controller.showAccount();
//system.assert(cab.size()>0);
   
     Test.stopTest();
}
    
}