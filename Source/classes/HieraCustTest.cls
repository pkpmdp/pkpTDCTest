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

@isTest(SeeAllData = true)
private class HieraCustTest {
	// Hierarki_Cust Class cover
    static testMethod void myUnitTest() {

		Pagereference testPageHierarki_Cust_Page  = Page.Hierarki_Cust_Page;
		Test.setCurrentPage(testPageHierarki_Cust_Page);
    	
    	YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        String ysHCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
        String ysKCustomerRecordType = ysRecords.YS_Customer_Account__c;
        
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';         
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        
        RecordType recordType = [Select Id,Name From RecordType Where ID = :ysHCustomerRecordType];
        
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
        
        Account accPar = new Account();
        accPar.Name = 'TestHierarchyPar';
        accPar.Type='Hierarki';
        accPar.Customer_Segment_Lookup__c = customerSegmentObj.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        accPar.Street_YK__c = addr.Id;
        accPar.Street_YK__r = addr;
        accPar.recordTypeId = recordType.Id;
        insert accPar;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.ParentId = accPar.Id;
        acc.Customer_Segment_Lookup__c = customerSegmentObj.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.recordTypeId = recordType.Id;
        insert acc;
        
        RecordType recordType1 = [Select Id,Name From RecordType Where ID = :ysKCustomerRecordType];
        
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccount1', RecordTypeID = recordType.Id);
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
        
        ApexPages.CurrentPage().getParameters().put('likeString', kundeChildAccount.id);
        ApexPages.CurrentPage().getParameters().put('KundePar', acc.id);
        Hierarki_Cust obj = new Hierarki_Cust();
        
        obj.strKundeId = kundeChildAccount.id;
        obj.KundeParent = acc.id;       
        obj.findAcc();
        
        obj.lstAcc.clear();
        obj.findAcc();
	}
    
    // CheckForHierarkiAcc cover
    static testmethod void CheckForHierarkiAccTest()
    {
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        String ysHCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
        String ysKCustomerRecordType = ysRecords.YS_Customer_Account__c;
        RecordType recordType = [Select Id,Name From RecordType Where ID = :ysHCustomerRecordType];
        RecordType recordType1 = [Select Id,Name From RecordType Where ID = :ysKCustomerRecordType];
        system.debug('recordType1 ***** '+recordType1);
        //RunOnceKontraktKundeTrigg.setIsFirstRun(true);
        Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';         
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        
        //Addredss
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
        //Parent Account
        Account accPar = new Account();
        accPar.Name = 'TestHierarchyPar';
        accPar.Type='Hierarki';
        accPar.Customer_Segment_Lookup__c = customerSegmentObj.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        accPar.Street_YK__c = addr.Id;
        accPar.Street_YK__r = addr;
        accPar.recordTypeId = recordType.Id;
        insert accPar;
        
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccount1', RecordTypeID = recordType.Id, Type='Hierarki',Street_YK__c = addr.Id);
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        insert kundeChildAccount;
        // Account
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.ParentId = accPar.Id;
        acc.Customer_Segment_Lookup__c = customerSegmentObj.id;
        //acc.Customer_Segment_Lookup__c=customerSegment.Id;
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.RecordType = recordType1;
        acc.Dummy_Account__c = false;
        //acc.RecordTypeName__c = 'YS Customer Account';
        insert acc;
        system.debug('acc.RecordTypeName__ **** '+acc);
        acc.ParentId = kundeChildAccount.id;
        update acc;
    }
}