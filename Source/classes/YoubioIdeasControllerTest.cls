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
private class YoubioIdeasControllerTest {

    static testMethod void loadTest() {
        YoubioIdeasController ybController = new YoubioIdeasController();
        ApexPages.CurrentPage().getParameters().put('category', String.valueOf(0));
        ybController.getProfilePicture ();
        system.assert(ybController.doLoad);
        
        YoubioIdeasController ybController1 = new YoubioIdeasController();
        ApexPages.CurrentPage().getParameters().put('category', String.valueOf(1));
        ybController1.getProfilePicture ();
        system.assert(ybController1.doLoad);
        system.assert(ybController1.listview.useAdvancedFiltering__c, true);
        
        YoubioIdeasController ybController2 = new YoubioIdeasController();
        ApexPages.CurrentPage().getParameters().put('category', String.valueOf(2));
        ybController2.getProfilePicture ();
        system.assert(ybController2.doLoad);
        ybController.getUserCreatedDate();
        
        YoubioIdeasController ybController3 = new YoubioIdeasController();
        ApexPages.CurrentPage().getParameters().put('category', String.valueOf(3));
        ybController3.getProfilePicture ();
        system.assert(ybController3.doLoad);
        ybController.getUserCreatedDate();
        
        ApexPages.CurrentPage().getParameters().put('mine', 'true');
        ybController.getUserCreatedDate();
        ybController.getme();
        
    }
}