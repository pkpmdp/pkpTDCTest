@isTest(seeAllData = true)
public class ViewCableUnitsSCTestClassSpoc2411 {     
    static User u; 
    static User user1;
    
    static testMethod void testCableUnitListPositive(){    
        Id hierarchyStatus;
        String ContactStatus;
        
        SalesConcept__c salesConObj = new SalesConcept__c();
        salesConObj.Solution__c = 'Indholdsbeskrivelse mangler';
        salesConObj.TVandRadio__c = 1 ;
        salesConObj.Broadband__c = 0 ;
        salesConObj.Telephony__c = 1 ;
        salesConObj.SC_Source_Id__c = 'OAS';
        insert salesConObj;
        
        Sales_Concept_Parameter__c salesConPar = new Sales_Concept_Parameter__c();
        salesConPar.Sales_Concept__c = salesConObj.Id;
        salesConPar.Parameter_Group__c = 'Bredbånd';
        salesConPar.Parameter_Head__c = 'YouSee Bredbånd'; 
        salesConPar.Parameter_Value__c = 'Ja'; 
        salesConPar.Parameter_PortalActive__c = true;
        salesConPar.SC_Param_SourceId__c = 'KAS.P2---4015110456';
        insert salesConPar;
        
        /*        Opportunity oppObj = new Opportunity();
oppObj.Sales_Concept_Lookup__c = salesConObj.Id;
oppObj.Name = 'A:6000545:201134';
oppObj.StageName = 'Potentiel';
oppObj.CloseDate = Date.valueOf('2014-03-03');
insert oppObj;

*/
        
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                    
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        //cableUnitTest.Current_Kiss_Case__c = oppObj.Id;
        cableUnitTest.Status__c = 'Running';
        Date myDate = date.newinstance(2013, 2, 17);
        cableUnitTest.Inaktiv_Dato__c = mydate;
        cableUnitTest.Contract_Source_ID__c = 'KAS.P2---4015110456';
        insert cableUnitTest;
        
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
        //  acc.Cable_Unit__c = cableUnitTest.Id;
        
        insert acc; 
        
        RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account(); 
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = recordType.Id);
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        kundeChildAccount.ParentId = acc.Id;
        kundeChildAccount.SuperiorAccount__c = acc.Id; 
        insert kundeChildAccount; 
        
        Opportunity oppObj = new Opportunity();
        oppObj.Sales_Concept_Lookup__c = salesConObj.Id;
        oppObj.Name = 'A:6000545:201134';
        oppObj.StageName = 'Potentiel';
        oppObj.CloseDate = Date.valueOf('2014-03-03');
        oppObj.AccountId = kundeChildAccount.id;
        insert oppObj;
        
        System.debug('****oppObj: '+oppObj);
        
        cableUnitTest.Current_Kiss_Case__c = oppObj.Id;
        update cableUnitTest;
        
        System.debug('cable unit updated:' + cableUnitTest);
        
        List<Opportunity> tempOppList =[Select id, Sales_Concept_Lookup__r.Solution__c,    
                                        Sales_Concept_Lookup__r.Telephony__c, Sales_Concept_Lookup__r.TVandRadio__c, Sales_Concept_Lookup__r.Broadband__c,
                                        Sales_Concept_Lookup__r.image_holder_for_telephony__c, Sales_Concept_Lookup__r.image_holder_for_broadband__c, 
                                        Sales_Concept_Lookup__r.image_Holder_for_TV__c  From Opportunity where id =: cableUnitTest.Current_Kiss_Case__c ];
        
        System.debug('count of opp: '+ tempOppList.size());
        
        Contact C2 = new Contact();
        C2.AccountID = kundeChildAccount.Id;
        C2.FirstName = 'Test';
        C2.LastName = 'User';
        C2.Street_P__c = addr.Id; 
        C2.description = 'For Testing Purpose';
        C2.Email = 'test_user@test.com';
        C2.Phone = '22222';
        C2.MobilePhone = '9870214578';
        C2.HomePhone = '124578';
        C2.AlternateEmail__c = 'test_user1@test.com';
        C2.HierarchyAccount__c = acc.Id;
        C2.status__C = 'Aktiv';
        C2.KissPartyId__c = 'KAS.P2---4015110456';
        insert C2;
        
        ID ProID = [ Select id from Profile where name = 'ServiceCenter Portal Administrator'].id;
        system.debug('Before');
        user1 = new User( email='test-user@test1.com',
                         UserName='test-user@test1.com', alias='tuser2', profileid = ProID,
                         CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                         EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test1', 
                         LastName = 'User1',MID__c = 'M25417',ContactId =C2.Id);
        
        ViewCableUnitsController_SPOC2411 controller =  new ViewCableUnitsController_SPOC2411();
            // CableUnits
            controller.strUser =user1.id;
        
        System.runAs(user1){   
            Test.startTest();          
            system.debug('$In side run as user ...$');
            List<Opportunity>  salesConceptList = [Select id, Sales_Concept_Lookup__r.Solution__c,    
                                                   Sales_Concept_Lookup__r.Telephony__c, Sales_Concept_Lookup__r.TVandRadio__c, Sales_Concept_Lookup__r.Broadband__c,
                                                   Sales_Concept_Lookup__r.image_holder_for_telephony__c, Sales_Concept_Lookup__r.image_holder_for_broadband__c, 
                                                   Sales_Concept_Lookup__r.image_Holder_for_TV__c  From Opportunity limit 50];
            system.debug('$salesConceptList$'+salesConceptList);
            
            Lookup_Contact_Roles__c role3 = [Select Id,Name from Lookup_Contact_Roles__c where Name =: ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c];
            system.debug('role 3 PPPP ' + role3);
            
            Account_Contact_Role__c acr = new Account_Contact_Role__c();
            acr.Customer__c = kundeChildAccount.Id;
            acr.Contact__c = C2.Id;
            acr.Role__c = role3.Id;                        
            insert acr;
            
            System.debug('Acr data:' + acr + 'Acr heirarchy:' + acr.HierarchyAccount__c + 'Customer Name:' + acr.Customer__r.Name + 'Custerom superior:' + acr.Customer__r.SuperiorAccount__r.Name  );
            Account_contact_Role__c  accNameTemp = [select Id,Role__C,Customer__c,RoleName__c,Role__r.Name,HierarchyAccount__c from account_contact_role__c where id =: acr.id limit 1];
            System.debug('ACR Entry:' + accNameTemp);
            update accNameTemp;   
            
            /*ServiceCenter_CustomSettings__c ServiceCenterCS = new ServiceCenter_CustomSettings__c();
            ServiceCenterCS.name = 'UserIDSpoc2411'; 
            ServiceCenterCS.Value__c = '005M0000005xJrw';
            insert ServiceCenterCS;*/ 
                 
           // ViewCableUnitsController_SPOC2411 controller =  new ViewCableUnitsController_SPOC2411();
            // CableUnits
            //controller.strUser =user1.id;
            controller.getCUList();
            controller.getCuSize();                
            controller.exportExcel();  
            
            cableUnitTest.Inaktiv_Dato__c = system.today()-1;
            cableUnitTest.Status__c = '4';
            cableUnitTest.Contract_Source_ID__c = null;
            update cableUnitTest;
            controller.getCUList();
            
            cableUnitTest.Inaktiv_Dato__c = null;
            cableUnitTest.Status__c = '99';
            update cableUnitTest;
            controller.getCUList();
            
            cableUnitTest.Status__c = '0';
            update cableUnitTest;
            controller.getCUList();
            
            ViewCableUnitsController_SPOC2411.CableUnits cableUnitsObj = new ViewCableUnitsController_SPOC2411.CableUnits();
            cableUnitsObj.cableUnitName ='';
            cableUnitsObj.cableUnitNumber ='';
            cableUnitsObj.cableUnitStatus='';
            cableUnitsObj.cableUnitStatusImgHolder=''; 
            cableUnitsObj.telephonyService ='';
            cableUnitsObj.broadBandService='';
            cableUnitsObj.tVService='';
            cableUnitsObj.telephonyServiceImgHolder='';
            cableUnitsObj.broadBandServiceImgHolder='';
            cableUnitsObj.tVServiceImgHolder='';
            cableUnitsObj.solution='';
            cableUnitsObj.cableUnitEnabled = true;
            // public ID accountId {get; set;}
           // cableUnitsObj.contactStatus='';
           // cableUnitsObj.contactRolename='';
           // cableUnitsObj.hierarchyStatus='';
            
            
            Test.stopTest(); 
        }  
        
    }
    
    static testMethod void testNegativeScenarios(){
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
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde(); 
        acc.Street_YK__c = addr.Id; 
        acc.Street_YK__r = addr;
        insert acc;               
        
        Contact C2 = new Contact();
        C2.FirstName = 'Test';
        C2.LastName = 'User';
        C2.Street_P__c = addr.Id; 
        C2.description = 'For Testing Purpose';
        C2.Email = 'test_user@test.com';
        C2.Phone = '22222';
        C2.MobilePhone = '9870214578';
        C2.HomePhone = '124578';
        C2.AlternateEmail__c = 'test_user1@test.com';
        C2.HierarchyAccount__c = acc.Id;
        C2.status__C = 'Aktiv';
        C2.KissPartyId__c = 'KAS.P2---4015110456';
        insert C2;
        
        /*ServiceCenter_CustomSettings__c ServiceCenterCS = new ServiceCenter_CustomSettings__c();
        ServiceCenterCS.name = 'UserIDSpoc2411'; 
        ServiceCenterCS.Value__c = '005M0000005xJrw';
        insert ServiceCenterCS;*/
        
        ID ProID = [ Select id from Profile where name = 'ServiceCenter Portal Administrator'].id;
        system.debug('Before');
        user1 = new User( email='test-user@test1.com',
                         UserName='test-user@test1.com', alias='tuser2', profileid = ProID,
                         CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', 
                         EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', FirstName = 'Test1', 
                         LastName = 'User1',MID__c = 'M25417',ContactId =C2.Id);
        
        System.runAs(user1){   
            ViewCableUnitsController_SPOC2411 controller =  new ViewCableUnitsController_SPOC2411();
            controller.getCUList();
            
        }     
    }
}