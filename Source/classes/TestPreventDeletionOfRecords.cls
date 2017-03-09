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
 
 /*
 * @ Author : Navneet Rajput
 * @ Date : 11/08/2011 
 */
 
@isTest
private class TestPreventDeletionOfRecords {

    private static Lookup_Building_Type__c buildingType;
    private static Lookup_Building_Type__c buildingType2;
    private static Lookup_Housing_Type__c housingType;
    private static Lookup_Housing_Ownership__c housingOwnership;    
    private static Address__c add;
    private static Cable_Unit__c cUnit;
    private static Account acc;
    private static Account account;
    private static Lookup_Customer_Satisfaction__c custSatisfactionObj;
    private static Lookup_Customer_Segment__c customerSegmentObj;
    private static Lookup_Customer_Segment__c customerSegmentObj2;
    private static KISS_Role_Validation_Rules__c rule1;
    private static KISS_Role_Validation_Rules__c rule2;
    private static Lookup_Account_Team_Role__c accTeamRoleObj;
    private static Lookup_Contact_Roles__c accContactRoleObj;
    private static Lookup_Account_Team_Member__c accTeamMemberObj; 
    private static Account_Team__c accTeam;
    private static Contact con; 
    private static Competitor__c competitor;
    private static Account_Contact_Role__c acr;
    
    
    public TestPreventDeletionOfRecords (){
        
    }
    
    // initialize and add data in to specific objects : preparation of dummy data  
      
    public static void init (){ 
        //Creating contact roles to match KISS rules
        accContactRoleObj = 
            new Lookup_Contact_Roles__c(Name = 'Rolle2', Start_Date__c = Date.valueOf('2011-01-01'),
                                       End_Date__c = Date.valueOf('2100-12-31'), SourceId__c = 'rolle1-Id',
                                       Code__c = 'Rolle10');
        insert accContactRoleObj;
        
        buildingType = new Lookup_Building_Type__c();
        //buildingType.Active__c='ja';
        buildingType.name ='Private bunglow';
        buildingType.Code__c='12121';
        buildingType.End_Date__c= date.today();
        buildingType.Start_Date__c=date.today();
        buildingType.SourceId__c='Private bunglow';
       
        insert  buildingType;
        //system.debug();
        //Lookup_Building_Type__c bTypeObj = [select Id,Name from Lookup_Building_Type__c limit 1];
        
        add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
       
        cUnit = new Cable_Unit__c();
        cUnit.Name = 'Torvet 28'; 
        cUnit.Cable_Unit_No__c='1234';
		cUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();        
        insert cUnit; 
        
        acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Customer_No__c = '1234';
        acc.Street_YK__c = add.Id;
        acc.Cable_Unit__c = cUnit.Id;  
        insert acc;
        
        // End 
                
        competitor = new Competitor__c();
        competitor.customer__c = acc.Id;
        competitor.Competitor__c = 'TestCompetitor';
        competitor.Competitor_role__c = 'TestRole';
        
        insert competitor;
        
        custSatisfactionObj = new Lookup_Customer_Satisfaction__c();
        
        custSatisfactionObj.Start_Date__c=date.today();
        custSatisfactionObj.End_Date__c=date.today();
        custSatisfactionObj.Name='pisse guard';
        custSatisfactionObj.code__c='1212';
        //custSatisfactionObj.Active__c='Ja';
        custSatisfactionObj.SourceId__c='DCRM 1211';
        
        insert custSatisfactionObj;
        
        Account acc1 = new Account();
        acc1.FirstName = 'Rajput';
        acc1.LastName = 'Navneet';
        acc1.Street_YK__c = add.Id;
        // Modified due to implementation of KKD-82
        acc1.Customer_No__c = '12342';
        acc1.Customer_Satisfaction_Lookup__c = custSatisfactionObj.Id;
        acc1.Cable_Unit__c = cUnit.Id;
        
        insert acc1;
        
        customerSegmentObj =new Lookup_Customer_Segment__c(); 
        
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today();
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';
        //custSatisfactionObj.Active__c='Ja';
        customerSegmentObj.SourceId__c='DCRM 1211';
        
        insert customerSegmentObj;
        
        Account acc2 = new Account();
        acc2.FirstName = 'Rajput1';
        acc2.LastName = 'Navneet1';
        acc2.Customer_No__c = '12341';
        acc1.Street_YK__c = add.Id;
        acc2.Customer_Segment_Lookup__c = customerSegmentObj.Id;
        acc2.Cable_Unit__c = cUnit.Id;
        
        insert acc2;
        // Before delete account team role 
        accTeamRoleObj = new Lookup_Account_Team_Role__c();
        
        accTeamRoleObj.SourceId__c='AaBB12'; 
        accTeamRoleObj.Code__c='Rolle1';
        accTeamRoleObj.Name='Rolle1';
        accTeamRoleObj.Start_Date__c= date.today();
        accTeamRoleObj.End_Date__c= date.today().addMonths(1);        
        insert accTeamRoleObj;
        
        rule1 = new KISS_Role_Validation_Rules__c( Name = 'Rolle1',Unlimited__c = true, Required__c = 1, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = accTeamRoleObj.Id );
        insert rule1;
        // before deletion of account team member
        accTeamMemberObj = new Lookup_Account_Team_Member__c ();
        
        accTeamMemberObj.code__c = '3223';
        accTeamMemberObj.Name='Janni Nelsan';
        accTeamMemberObj.SourceId__c='1111232';
        
        insert accTeamMemberObj;
       
        
        accTeam = new Account_Team__c();
       
        accTeam.Customer__c=acc2.Id;
        accTeam.Customer_Team_Member__c=accTeamMemberObj.Id;
        accTeam.Customer_Team_Role__c = accTeamRoleObj.Id;
        //accTeam.Customer__c = acc2.Id;
        
        try {
            insert accTeam; 
        } catch (Exception e){
            system.assert(false);
        }
        
        //Before deletion contact 
        Cable_Unit__c cable_unit = new Cable_Unit__c();
        cable_unit.Cable_Unit_No__c = '452342343';
        cable_unit.Name = 'TestCustomerAccountRoleTrigger';
        cable_unit.CA_Sales_Concept__c = 'SERVICE';
        cable_unit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cable_unit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cable_unit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cable_unit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cable_unit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cable_unit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cable_unit;                    
        
        account = new Account( Name = 'TestAccountContactRoleTrigger', RecordTypeID = '012200000000nf3');
        account.Cable_Unit__c = cable_unit.Id;  
        account.Street_YK__c = add.Id;          
        account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
        insert account;
         
        con = new Contact();        
        con.FirstName='Navneet';
        con.KissPartyId__c = 'XCk54';
        con.LastName='Rajput';      
        con.Email='Test@gmail.com';
        con.Phone='8989898898';
        con.Street_P__c = add.Id;       
        insert con;
        
        rule2 = new KISS_Role_Validation_Rules__c( Name = 'Rolle2',Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = accContactRoleObj.Id);
        insert rule2;
        Test.startTest();
        acr = new Account_Contact_Role__c();
        acr.Contact__c = con.Id;
        acr.Role__c = accContactRoleObj.Id;
        acr.Customer__c = account.Id;
        insert acr;
        
        preventBuildingTypeDeletion();
        preventCustomerSatisfactionDeletion();
        preventCustomerSegmentDeletion();
        preventAccountTeamMemberDeletion();
        preventContactRoleDeletion();
        deleteCompetitor();
        preventContactDeletion();
        Test.stopTest();
    }
    
    // before deletion building record type
    private static void preventBuildingTypeDeletion(){
        try {
            delete buildingType;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    
    // before deletion of customer satisfacion records
    private static void preventCustomerSatisfactionDeletion(){
        
        try {
            delete custSatisfactionObj;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }

    // before deletion of customer segment record
    private static void preventCustomerSegmentDeletion(){
          
         try {
            delete customerSegmentObj;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    
    // before deletion of Account Team member record 
    private static void preventAccountTeamMemberDeletion(){
         try {
            delete accTeamMemberObj;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    
    // before deletion of the account team role 
    private static void preventAccountTeamRoleDeletion(){
        try {
            delete accTeamRoleObj;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    // prevent deletion of contact
    private static void preventContactDeletion(){
        try {
            delete con;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    
    // prevent deletion of contact
    private static void preventContactRoleDeletion(){
        try {
            delete accContactRoleObj;
        } catch (Exception e){  
            system.assert(e.getMessage().contains('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter'),e.getMessage());
            return;
        } 
        system.assert(false);
    }
    
    // Test method starts from here : test class execution point
    /*static testMethod void deletionOfRecordsTest() {  
    	init();
        Test.startTest();
        preventBuildingTypeDeletion();
        preventCustomerSatisfactionDeletion();
        preventCustomerSegmentDeletion();
        preventAccountTeamRoleDeletion();
        Test.stopTest();
      }
    
   
    
    static testMethod void deletionOfRecordsTest4() {  
    	init();
        Test.startTest(); 
        preventAccountTeamMemberDeletion();
        preventContactRoleDeletion();
        deleteCompetitor();
        preventContactDeletion();
        Test.stopTest();
    }*/
   
    
    // Test deletion of Competitors with subsequent transfer to DeletedCompetitor object
    // This test is not related to
    private static void deleteCompetitor(){     
        try {
            delete competitor;
        } catch (Exception e){
            system.assert(false);
            return;
        } 
        system.assert(true);
    } 
}