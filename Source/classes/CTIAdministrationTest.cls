@isTest
/**
	A test class for CTIAdministrationController.
*/
private class CTIAdministrationTest {


	public static testMethod void testInsertCallRegJob() {
		ApexPages.StandardController stdController = new ApexPages.StandardController(new Call_Registration_Job__c());
		CTIAdministrationController controller = new CTIAdministrationController(stdController);
		controller.callRegJob = getDummyData();
		controller.save();
		System.assert(controller.callRegJob.Id != null);
		System.assert(controller.jobTypeTime == false);
		System.assert(controller.jobTypeCoverage == false);
		System.assert(controller.jobTypeCDN == false);
	}

	public static testMethod void testUpdateCallRegJob() {
		Call_Registration_Job__c callRegJob = getDummyData();
		insert callRegJob;
		Group testGroup = new Group(Name = 'Test', Type = CTIAdministrationController.GROUP_TYPE);
		insert testGroup;
		ApexPages.StandardController stdController = new ApexPages.StandardController(callRegJob);
		CTIAdministrationController controller = new CTIAdministrationController(stdController);
		controller.userLookup.User__c = UserInfo.getUserId();
		controller.addUser();
		controller.selectedGroupsIDs.add(testGroup.Id);
		controller.addGroup();
		controller.save();
		System.assert(callRegJob.Id != null);
		System.assert(controller.jobUsersDisplay.size() == 1);
		System.assert(controller.groupsDisplay.size() == 1);
	}
	
	public static testMethod void testAddRemoveUser() {
		ApexPages.StandardController stdController = new ApexPages.StandardController(new Call_Registration_Job__c());
		CTIAdministrationController controller = new CTIAdministrationController(stdController);
		controller.userLookup.User__c = UserInfo.getUserId();
		controller.addUser();
		System.assert(controller.jobUsersDisplay.size() == 1);
		ApexPages.currentPage().getParameters().put('userId', UserInfo.getUserId());
		controller.removeUser();
		System.assert(controller.jobUsersDisplay.size() == 0);
	}
	
	public static testMethod void testAddRemoveGroup() {
		Group testGroup = new Group(Name = 'Test', Type = CTIAdministrationController.GROUP_TYPE);
		insert testGroup;
		ApexPages.StandardController stdController = new ApexPages.StandardController(new Call_Registration_Job__c());
		CTIAdministrationController controller = new CTIAdministrationController(stdController);
		controller.selectedGroupsIDs.add(testGroup.Id);
		controller.addGroup();
		System.assert(controller.groupsDisplay.size() == 1);
		ApexPages.currentPage().getParameters().put('groupId', testGroup.Id);
		controller.removeGroup();
		System.assert(controller.groupsDisplay.size() == 0);
	}
	
	private static Call_Registration_Job__c getDummyData() {
		Date now = Date.today();
		Call_Registration_Job__c callRegJob = new Call_Registration_Job__c(Valid_To__c = now, Valid_From__c = now, Taksonomy_Set__c = 'Test', Job_Type__c = 'Required');
		return callRegJob;
	}
}