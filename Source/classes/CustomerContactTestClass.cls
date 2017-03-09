@isTest(seeAllData=true)
private class CustomerContactTestClass {

    static testMethod void customerContactRoleDetailsTest() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customercontactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        CustomerContact.getCustomerContactRoleDetails();
        CustomerContact.CustomerContactRoleWrapper conWrapper=new CustomerContact.CustomerContactRoleWrapper(); 
        conWrapper.contactId='testId';
        conWrapper.doorNo='testNo';
        conWrapper.email='testMail';
        conWrapper.entrance='testEntrance';
        conWrapper.firstName='testFirstName';
        conWrapper.lastName='testLastName';
        conWrapper.floor='testFloor';
        conWrapper.fullName='testFullName';
        conWrapper.houseNo='testHouseNo';
        conWrapper.locality='testLoc';
        conWrapper.mobilePhone='23234';       
        conWrapper.organization='testOrg';
        conWrapper.POBoxNr='testPO';
        conWrapper.postCode='testPOCode';
        conWrapper.privatePhone='234234';
        conWrapper.streetName='MG';
        conWrapper.title='Mr';
        conWrapper.town='Las Vegas';
        conWrapper.workPhone='234234';
        conWrapper.visKontrakt=true;
        conWrapper.roleCode='teest';
        conWrapper.roleId='32423';
        conWrapper.roleName='test';
        conWrapper.numberOfmagazies=23;
        
        List<Account_Contact_Role__c> customerContactRoleList = [Select a.Title__c,a.Contact__r.RecordTypeId,a.CableUnit__c,a.Role__r.Name,a.Role__r.Vis_i_kontrakt__c,a.Role__r.Code__c,a.Contact__c,a.Contact__r.Phone,a.Contact__r.Email,a.Contact__r.MobilePhone,a.Total_Insight__c,a.Contact__r.Company_Customer__c,a.Contact__r.Title,a.Contact__r.Name,a.Contact__r.FirstName,a.Contact__r.LastName,a.Contact__r.HomePhone,a.Contact__r.Street_P__c,a.Contact__r.Street_P__r.PO_Box__c,a.Contact__r.Street_P__r.Town__c,a.Contact__r.Street_P__r.Postcode__c,a.Contact__r.Street_P__r.Door_No__c,a.Contact__r.Street_P__r.House_No__c,a.Contact__r.Street_P__r.Entrance__c,a.Contact__r.Street_P__r.Street__c,a.Contact__r.Street_P__r.Floor__c,a.Contact__r.Street_P__r.Side__c,a.Contact__r.Street_P__r.District__c,a.Contact__r.Street_P__r.External_Id__c From Account_Contact_Role__c a where a.Total_Insight__c!=null limit 1];
        CustomerContact.mapToContactRoleList(customerContactRoleList);
    }
}