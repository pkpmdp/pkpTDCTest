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
private class clsLookupTableListControllerTest {

    static testMethod void myUnitTest() {
       clsLookupTableListController controller = new clsLookupTableListController();
       Lookup_Building_Type__c lbtc = new Lookup_Building_Type__c();
       lbtc.Name = 'testLBT';
       DateTime dT = System.now();
       Date startDate = date.today();
       Date endDate = date.today().addMonths(1);
       lbtc.Start_Date__c = startDate;
       lbtc.End_Date__c = endDate;
       lbtc.SourceId__c = 'testSourceID';
       insert lbtc;
       List<Lookup_Building_Type__c> lbt = controller.getBuildingTypes();
       System.assertNotEquals(lbt.size(), 0); 
       
       Lookup_Customer_Segment__c lcsc = new Lookup_Customer_Segment__c();
       lcsc.Name = 'testLCS';
       lcsc.Start_Date__c = startDate;
       lcsc.End_Date__c = endDate;
       lcsc.SourceId__c = 'testSourceID';
       insert lcsc;
       List<Lookup_Customer_Segment__c> lcs = controller.getCustomerSegments();
       System.assertNotEquals(lcs.size(), 0);
       
       Lookup_Housing_Type__c lhtc = new Lookup_Housing_Type__c();
       lhtc.Name = 'testLHT';
       lhtc.Start_Date__c = startDate;
       lhtc.End_Date__c = endDate;
       lhtc.SourceId__c = 'testSourceID';
       insert lhtc;
       List<Lookup_Housing_Type__c> lht= controller.getHousingTypes();
       System.assertNotEquals(lht.size(), 0);
       
       Lookup_Housing_Ownership__c lhoc = new Lookup_Housing_Ownership__c();
       lhoc.Name = 'testLHO';
       lhoc.Start_Date__c = startDate;
       lhoc.End_Date__c = endDate;
       lhoc.SourceId__c = 'testSourceID';
       insert lhoc;
       List<Lookup_Housing_Ownership__c> lho = controller.getHousingOwnership();
       System.assertNotEquals(lho.size(), 0);
       
       Lookup_Customer_Satisfaction__c lcsac = new Lookup_Customer_Satisfaction__c();
       lcsac.Name = 'testLCS';
       lcsac.Start_Date__c = startDate;
       lcsac.End_Date__c = endDate;
       lcsac.SourceId__c = 'testSourceID';
       insert lcsac;
	   List<Lookup_Customer_Satisfaction__c> lcsa = controller.getCustomerSatisfaction();
       System.assertNotEquals(lcsa.size(), 0);
       
       Lookup_Account_Team_Role__c latrc = new Lookup_Account_Team_Role__c();
       latrc.Name = 'testLATR';
       latrc.Start_Date__c = startDate;
       latrc.End_Date__c = endDate;
       latrc.SourceId__c = 'testSourceID';
       insert latrc;
       List<Lookup_Account_Team_Role__c> latr = controller.getCustomerTeamRoles();
       System.assertNotEquals(latr.size(), 0); 
       
    }
}