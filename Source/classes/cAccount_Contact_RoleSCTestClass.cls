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
private class cAccount_Contact_RoleSCTestClass {

    static testMethod void myUnitTest() {
      Account_Contact_Role__c a;
      cAccount_Contact_Role accConRole = new cAccount_Contact_Role();
      cAccount_Contact_Role acr = new cAccount_Contact_Role(a);
        accConRole.selected=true;
        accConRole.editContact='abc';
        accConRole.viewContact='xyz';
        accConRole.deleteContact='abc';
        accConRole.firstName='xyz';
        accConRole.space='esd';
        accConRole.FName='sh';
        accConRole.LName='ga';
        accConRole.roleName='abc';
        accConRole.contactName='sheetal';
        accConRole.contactFName='asd';
        accConRole.contactLName='xyz';
        accConRole.alternateEmail='s@gmail.com';
        accConRole.email='s@yahoo.com';
        accConRole.accountId='123';
        accConRole.homePhone='23456';
        accConRole.mobilePhone='12345';
        accConRole.phone='12345';
        accConRole.totalInsightRoles='1234';      
    }
}