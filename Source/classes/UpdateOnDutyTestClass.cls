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
@isTest(SeeAllData=true)
private class UpdateOnDutyTestClass {

    static testMethod void testScenario1() {
      //  user u = new user();
        User uid = [SELECT id from User where IsActive = true limit 1];         
        YO_OperationConsultant__c yo = new YO_OperationConsultant__c();
        yo.Information__c = 'text';
        yo.onDuty__c=true;
        yo.User__c = userinfo.getUserId();
        
        insert yo;
    }
    
    static testMethod void testScenario2() {
        YO_OperationConsultant__c yo = new YO_OperationConsultant__c();
        yo.Information__c = 'text';
        yo.onDuty__c=false;
         yo.User__c = userinfo.getUserId();
        insert yo;
    }
}