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
private class checkHierakiCustTestCls {

	public static Address__c addr{get;set;}
	public static Account accParDiffHier{get;set;}
	public static Account accPar{get;set;}
	public static Account acc{get;set;}
	public static Account kundeChildAccount2{get;set;}
	public static Map<Id,Id> mapIdtoPar{get;set;}
	public static Map<Id,Id> MapIdToKKId{get;set;}
	public static Map<Id,Id> mapIdToIdHier{get;set;}
	public static Map<Id,Set<Id>> MapIdToOldHiearTop{get;set;}
	public static Map<Id,Set<Id>> MapKundeToParHierAccs{get;set;}
	public static Set<Id> setAllTopIds{get;set;}
	public static List<Account> lstAccHierTriggNew{get;set;}
	public static Map<Id,Account> MapIdToAccFrStr{get;set;}
	public static List<Account> accList {get;set;}
	public static YSRecordTypes__c ysRecords {get;set;}
	public static RecordType recordType {get;set;}
	public static RecordType recordType1 {get;set;}
	
	
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        setupData();
       
        Test.startTest();
        
        RunOnceKontraktKundeTrigg.getIsFirstRun();
        
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccount1', RecordTypeID = recordType.Id);
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kundeChildAccount.ParentId = acc.Id;   
        kundeChildAccount.Dummy_Account__c = false;
        insert kundeChildAccount;

		RunOnceKontraktKundeTrigg.getIsFirstRun();
        kundeChildAccount.Kontraktkunde__c = accPar.id;
         update kundeChildAccount;

        mapIdtoPar.put(kundeChildAccount.Id,acc.Id);
        MapIdToKKId.put(kundeChildAccount.Id,accPar.id);
        MapIdToAccFrStr.put(kundeChildAccount.Id, kundeChildAccount);
        accList.add(kundeChildAccount);
        checkHierakiCust clsController = new checkHierakiCust();
        clsController.getHieraki(mapIdtoPar,MapIdToKKId,MapIdToAccFrStr,accList);  
        
        RunOnceKontraktKundeTrigg.getIsFirstRun();
        kundeChildAccount.Kontraktkunde__c = accParDiffHier.id;
         update kundeChildAccount;
         
        mapIdtoPar.put(kundeChildAccount.Id,acc.Id);
        MapIdToKKId.put(kundeChildAccount.Id,accParDiffHier.id);
        MapIdToAccFrStr.put(kundeChildAccount.Id, kundeChildAccount);
        accList.add(kundeChildAccount);
        checkHierakiCust clsController1 = new checkHierakiCust();
        clsController1.getHieraki(mapIdtoPar,MapIdToKKId,MapIdToAccFrStr,accList);  
        
        RunOnceKontraktKundeTrigg.getIsFirstRun();
        acc.ParentId = accParDiffHier.id;
        update acc;
        
        mapIdToIdHier.put(acc.id,accPar.id);
        clsController1.MatchHierarki(mapIdToIdHier);
		
		set<id>setBuffParId = new set<id>();
		setBuffParId.add(accPar.id);
		MapIdToOldHiearTop.put(acc.id,setBuffParId);
		setAllTopIds.add(accPar.id);
		List<Account> lstKundeAcc = new List<Account>();
		Set<Id> setNewIds = new Set<Id>();
		lstKundeAcc.add(kundeChildAccount);
		setNewIds.addAll(MapIdToOldHiearTop.keyset());
	    Set<Id> setHierId = new Set<Id>();
	    setHierId.add(accPar.id);
		clsController1.KundeErrHierarki(setAllTopIds, MapIdToOldHiearTop.keyset());
		
		RunOnceKontraktKundeTrigg.getIsFirstRun();
		delete accPar;
		
		set<id>setHierToDel = new Set<id>();
		setHierToDel.add(kundeChildAccount2.id);
		set<id> setIdToDel = new Set<id>();
		setIdToDel.addAll(setHierToDel);
		checkHierakiCust.delKundeKKonHierDel(setHierToDel);	
        
        Test.stopTest();
        
    }
    
    static testMethod void setupData(){
    	
    	mapIdtoPar = new Map<Id,Id>(); 
        MapIdToKKId = new Map<Id,Id>();
        mapIdToIdHier = new Map<Id,Id>();
        MapIdToOldHiearTop = new Map<Id,Set<Id>>();
        MapKundeToParHierAccs = new Map<Id,Set<Id>>();
        setAllTopIds = new Set<Id>();
        lstAccHierTriggNew = new List<Account>();
        MapIdToAccFrStr = new Map<Id,Account>();
        accList = new List<Account>();
        
        ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        String ysHCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
        String ysKCustomerRecordType = ysRecords.YS_Customer_Account__c;
        
        recordType = [Select Id,Name From RecordType Where ID = :ysHCustomerRecordType];
        recordType1 = [Select Id,Name From RecordType Where ID = :ysKCustomerRecordType];
    	
    	addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        accParDiffHier = new Account();
        accParDiffHier.Name = 'TestDiffHierarchy';
        accParDiffHier.Type='Hierarki';
        accParDiffHier.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment3();
        accParDiffHier.Street_YK__c = addr.Id;
        accParDiffHier.Street_YK__r = addr;
        accParDiffHier.recordTypeId = recordType.Id;
        insert accParDiffHier;
        
        accPar = new Account();
        accPar.Name = 'TestHierarchy1';
        accPar.Type='Hierarki';
        accPar.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment2();
        accPar.Street_YK__c = addr.Id;
        accPar.Street_YK__r = addr;
        accPar.recordTypeId = recordType.Id;
        insert accPar;
        
        acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.ParentId = accPar.id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.recordTypeId = recordType.Id;
        insert acc;
        
        kundeChildAccount2 = new Account();
        kundeChildAccount2 = new Account( Name = 'TestAccount2', RecordTypeID = recordType1.Id,Kontraktkunde__c=acc.Id);       
        kundeChildAccount2.ParentId = accPar.Id;   
        kundeChildAccount2.Dummy_Account__c = false;
        kundeChildAccount2.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment4();
        kundeChildAccount2.SampleText__c=accParDiffHier.Id;
        insert kundeChildAccount2;
        
        
        
        
    }
    
    static testMethod void myUnitTest1() {
    	
    	setupData();   
    	Set<ID> setHierId=new Set<ID>();
    	Set<ID> setNewId=new Set<ID>();	 
    	setHierId.add(acc.Id);
    	setNewId.add(accParDiffHier.Id);
    	
    	Test.startTest();
    	checkHierakiCust clsController = new checkHierakiCust();    	
    	clsController.KundeErrHierarki(setHierId,setNewId);
    	Test.stopTest();
    }
    
    static testMethod void UpdateHierarKUndeTest(){
    	
    	setupData();
    	Map<Id,List<Account>> MapUpdat=new Map<Id,List<Account>>();
    	MapUpdat.put(acc.Id,new List<Account>{acc});
    	List<Account> lstAcc=new List<Account>();
    	lstAcc.add(acc);
    	Test.startTest();
    	checkHierakiCust clsController = new checkHierakiCust();    	
    	clsController.UpdateHierarKUnde(MapUpdat,lstAcc);
    	clsController.UpdateHierKunde(lstAcc);
    	Test.stopTest();
    	
    	
    }
    
   /* static testMethod void myUnitTestfordelKundeKKonHierDel() {
        // TO DO: implement unit test
        Set<Id> setIdToDel = new Set<Id>(); 
        Set<ID> newHIds = new Set<Id>();
        Set<ID> succHID = new Set<ID>();
        List<Account> accList = new List<Account>();
        List<Account> lstKunde = new List<Account>();
        Map<Id,Id> MapHierToHierObj = new Map<Id,Id>();
        
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
        String ysHCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
        String ysKCustomerRecordType = ysRecords.YS_Customer_Account__c;
        
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
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.recordTypeId = recordType.Id;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestHierarchy1';
        acc1.Type='Hierarki';
        acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        acc1.Street_YK__c = addr.Id;
        acc1.Street_YK__r = addr;
        acc1.recordTypeId = recordType.Id;
        insert acc1;
        
        newHIds.add(acc.Id);
        succHID.add(acc1.ID);
        MapHierToHierObj.put(acc1.ID,acc1.ID);
        
        RecordType recordType1 = [Select Id,Name From RecordType Where ID = :ysKCustomerRecordType];
        
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccount1', RecordTypeID = recordType.Id);
        kundeChildAccount.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        kundeChildAccount.Kontraktkunde__c = acc.Id;
        insert kundeChildAccount;
        lstKunde.add(kundeChildAccount);
        
        Account kundeChild = new Account();
        kundeChild = new Account( Name = 'TestAccount2', RecordTypeID = recordType.Id);
        kundeChild.Customer_Segment_Lookup__c =  clsTestDataForYS.createLookupCustomerSegmentKunde2();
        //kundeChild.ParentId = acc.Id;
        //kundeChild.Kontraktkunde__c = acc.Id;
        insert kundeChild;
        
        setIdToDel.add(acc.Id);
        System.debug('####setIdToDel###'+setIdToDel);
        checkHierakiCust clsController = new checkHierakiCust();
        clsController.GetNewHier(newHIds); 
        clsController.UpdateHierKunde(lstKunde);
        clsController.UpdateKundeField(succHID,MapHierToHierObj);
        checkHierakiCust.delKundeKKonHierDel(setIdToDel);  
        
    }*/
    
    
    
}