@isTest(SeeAllData = true)
public class KundeNumberSearchTestClass {

public static YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
public static String cableUnitCustomerRecordType = ysRecords.YS_Customer_Account__c;
public static String personAccountRecordType = ysRecords.YK_Customer_Account__c;

 public static testMethod void testKundeNumberSearchControllerForYS() {
        
        Test.startTest();
        //YS customer
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Cable_Unit_No__c = '0001230076';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType(); 
        insert cableUnit;
        
        Account acc = new Account();
        acc.name = 'TTest';
        acc.RecordTypeId = cableUnitCustomerRecordType;
        acc.Cable_Unit__c = cableUnit.id;
        acc.Customer_No__c = cableUnit.Cable_Unit_No__c;
        acc.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        //with zero-prefixed
        PageReference prf = Page.KundeNumberSearch;
        prf.getParameters().put('KundeNumber', '0001230076'); 
        Test.setCurrentPage(prf);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        KundeNumberSearchController controller = new KundeNumberSearchController(stdController); 
        System.assertEquals('0001230076', controller.KundeNumber);     
      //System.assertNotEquals(null, controller.showAccountbykundenumber());
        controller.showAccountbykundenumber();
        
        //without zero-prefixed
        prf.getParameters().put('KundeNumber', '1230076'); 
        Test.setCurrentPage(prf);
        stdController = new ApexPages.StandardController(acc);
        controller = new KundeNumberSearchController(stdController);
        System.assertEquals('1230076', controller.KundeNumber);
       // System.assertNotEquals(null, controller.showAccountbykundenumber());
        controller.showAccountbykundenumber();
     
        //10 digit account not exists
        prf.getParameters().put('KundeNumber', '1230076123'); 
        Test.setCurrentPage(prf);
        stdController = new ApexPages.StandardController(acc);
        controller = new KundeNumberSearchController(stdController);
        System.assertEquals('1230076123', controller.KundeNumber);
     //   System.assertEquals(null, controller.showAccountbykundenumber());
        controller.showAccountbykundenumber();
     
        //inner else when account no length less than 10
        prf.getParameters().put('KundeNumber', '76123'); 
        Test.setCurrentPage(prf);
        stdController = new ApexPages.StandardController(acc);
        controller = new KundeNumberSearchController(stdController);
        System.assertEquals('76123', controller.KundeNumber);
     //   System.assertEquals(null, controller.showAccountbykundenumber());
       controller.showAccountbykundenumber();
     
        //Hierarki customers
        prf.getParameters().put('KundeNumber', 'H-76123'); 
        Test.setCurrentPage(prf);
        stdController = new ApexPages.StandardController(acc);
        controller = new KundeNumberSearchController(stdController);
        System.assertEquals('H-76123', controller.KundeNumber);
     //   System.assertEquals(null, controller.showAccountbykundenumber());
       
       controller.showAccountbykundenumber();
        Test.stopTest();
    }
    
    public static testMethod void testKundeNumberSearchControllerForYK() {
        
        Test.startTest();
        //YK customer
        Account  acc = new Account();
        acc.RecordTypeId = personAccountRecordType;
        acc.Status_YK__c = 'Active';
        acc.FirstName = 'Test'; 
        acc.LastName = 'Test';
        acc.Customer_No__c = '1230076';
        acc.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        PageReference prf = Page.KundeNumberSearch;
        prf.getParameters().put('KundeNumber', '1230076'); 
        Test.setCurrentPage(prf);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        KundeNumberSearchController controller = new KundeNumberSearchController(stdController); 
        System.assertEquals('1230076', controller.KundeNumber);     
       // System.assertNotEquals(null, controller.showAccountbykundenumber());
        controller.showAccountbykundenumber();
        Test.stopTest();
     }
}