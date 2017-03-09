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
private class PortalUserUtilSCTestClass {

  
    static testMethod void myUnitTest() {
      
       PortalUserUtil portalObj = new PortalUserUtil();
       PortalUserUtil.FORCE_TEST_MODE = true;
       Contact contact = new Contact();
       User user =  new User();
       ID accID = serviceCenterTestUtil.getRandomAccountId();
       User loggedInUser = [Select email, firstname, lastname from user where Id =: userInfo.getUserId() LIMIT 1];
       List<String> accList = new List<String>();
       
       accList.add('Ashwini');
       accList.add('Abhijit');
       String subject = 'My mail';
       String message = 'I am Ashwini Shinde';
       portalObj.fireMail(user, accList, subject, message);
       portalObj.sendMail(loggedInUser, accList, subject, message);  
       portalObj.getStreetForAccount(accID, contact);
       portalObj.getAssignedCableUnits(contact.Id);
       portalObj.sendMail(null, null, null, null);
       
       
    }
}