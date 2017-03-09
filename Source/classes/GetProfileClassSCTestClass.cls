/** 
* This class contains unit tests for validating the behavior of Apex classes 
* and triggers. 
* * Unit tests are class methods that verify whether a particular piece 
* of code is working properly. Unit test methods take no arguments, 
* commit no data to the database, and are flagged with the testMethod 
* keyword in the method definition. 
* * All test methods in an organization are executed whenever Apex code is deployed 
* to a production organization to confirm correctness, ensure code 
* coverage, and prevent regressions. All Apex classes are 
* required to have at least 75% code coverage in order to be deployed 
* to a production organization. In addition, all triggers must have some code coverage. 
*  * The @isTest class annotation indicates this class only contains test 
* methods. Classes defined with the @isTest annotation do not count against 
* the organization size limit for all Apex scripts. 
* * See the Apex Language Reference for more information about Testing and Code Coverage.
*/

@isTest 
public class GetProfileClassSCTestClass {    
	static testMethod void myUnitTest() {
          Cable_Unit__c cableNo = new Cable_Unit__c();
          cableNo.Cable_Unit_No__c = '00000055555';
          cableNo.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
          cableNo.Municipaly__c = clsTestDataForYS.getMunicipaly();
          cableNo.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
          cableNo.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
          cableNo.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
          cableNo.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
          insert cableNo;
         
		  apexpages.currentpage().getparameters().put(contactConstClass.CABLEUNITNUMBER,cableNo.Cable_Unit_No__c);      
		  ManageContactsController manageContactsObj = new ManageContactsController();       
		  CableUnitDetailsController cableUnitDetailsObj = new CableUnitDetailsController();             
		  GetProfileClass getProfileObj1 = new GetProfileClass(manageContactsObj);       
		  GetProfileClass getProfileObj2 = new GetProfileClass(cableUnitDetailsObj);       
		  GetProfileClass.getUserProfile();       
		  getProfileObj1.getCNumber();    
	     }
	}