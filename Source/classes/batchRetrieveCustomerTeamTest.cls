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
@isTest(seeAlldata = true)
private class batchRetrieveCustomerTeamTest {	 
	 static Lookup_Account_Team_Role__c createAccountTeamRole(String role, String Sourceid, String code) {
    	Lookup_Account_Team_Role__c role1 = 
                new Lookup_Account_Team_Role__c(Name = role, Start_Date__c = Date.valueOf('2011-01-01'),
                                            End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = Sourceid,
                                            Code__c = code);
        insert role1;
        return role1;               
    }
    
    static Lookup_Account_Team_Member__c createAccountTeamMember(String name) {
    	Lookup_Account_Team_Member__c member1 = new Lookup_Account_Team_Member__c( Name = name, SourceId__c = 'Testmember-id1');
    	insert member1;
        return member1;   
    }
    
    static testMethod void myUnitTest() {
       Account account1 = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
       Lookup_Account_Team_Role__c role1 = createAccountTeamRole('TestRole1', 'Testrolle1-Id', 'TestRolle1');
       Lookup_Account_Team_Role__c role2 = createAccountTeamRole('TestRole2', 'Testrolle2-Id', 'TestRolle2');
       KISS_Role_Validation_Rules__c rule1 = 
	            new KISS_Role_Validation_Rules__c( Name = 'TestRolle1',
	                                               Unlimited__c = true, Required__c = 1, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role1.Id);
	        insert rule1;
	        
	   KISS_Role_Validation_Rules__c     rule2 = 
	            new KISS_Role_Validation_Rules__c( Name = 'TestRolle2',
	                                               Unlimited__c = false, Required__c = 1, Possible__c = 1, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role2.Id);
	        insert rule2;
       Lookup_Account_Team_Member__c member1 = createAccountTeamMember('TESTCLASSCUSTOMER_WenTest');
       Account_Team__c acct1 = new Account_Team__c();
       acct1.Customer__c = account1.id;
       acct1.Customer_Team_Member__c = member1.id;
       acct1.Customer_Team_Role__c = role1.id;
       insert acct1;
       Account_Team__c acct2 = new Account_Team__c(Customer__c=account1.id, Customer_Team_Member__c = member1.id, Customer_Team_Role__c = role2.id);
       insert acct2;
       
       Test.startTest();
                
        batchRetrieveCustomerTeam accTeam = new batchRetrieveCustomerTeam();
        accTeam.isTestRun = '1';
        accTeam.testID = acct1.id;
        integer batchSize = 2;
        ID batchprocessid = Database.executeBatch(accTeam, batchSize);     
        
       Test.stopTest();
        List<Account> cs = [SELECT kundeAnsvarligc__c, salgsAnsvarlig__c FROM Account where id =: account1.id Limit 1];       
        System.assertEquals(member1.id, cs[0].kundeAnsvarligc__c);
        //System.assertEquals(acct2.id, cs[0].salgsAnsvarlig__c);
    }
}