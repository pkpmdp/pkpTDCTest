@isTest(SeeAllData=true)
public class ContactDetailsRestServiceTestClass {
      static testMethod void contactDetailsTest1() {    
      /*	YSRecordTypes__c r=new YSRecordTypes__c();
      	r.Name='YSRecordTypes';
      	r.YS_Contact_Record_Type__c='012D0000000BD3N';
      	insert r;*/
      	   
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'all');
       
        
        List<String> ids=new List<String>();
        ids.add('003c000000Lo9ITAAZ');
        ids.add('0032000000RCelpAAD');
        
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);        
        ContactDetailsRestService.getContactDetails();
         ContactDetailsRestService.doPostAction();
        
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
      	String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        List<Id> idList = new List<Id>();
        for(String id1 : jsonwrap){
            idList.add(id1);
        }
        List<Contact> conList=[Select Name,FirstName,LastName,Company_Customer__c,Title,MobilePhone,Phone,HomePhone,Email,Street_P__r.Name,Street_P__r.Door_No__c,Street_P__r.Entrance__c,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c,Street_P__r.Street__c,Id,Street_P__r.Floor__c,Street_P__r.District__c,Street_P__r.PO_Box__c,IsPersonAccount from Contact limit 10];
        ContactDetailsRestService.getMapToContactList(conList);
        Set<String> conIdMap=new Set<String>();
        for(Contact cTemp : conList)
        	conIdMap.add(cTemp.Id);
        ContactDetailsRestService.quoteKeySet(conIdMap);
    }
    //action =null test
    static testMethod void contactDetailsTest2() {         
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
       // RestContext.request.addParameter('action', 'all');             
        ContactDetailsRestService.doPostAction();
    }
     //action =other test
    static testMethod void contactDetailsTest3() {         
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
       RestContext.request.addParameter('action', 'elseTest');             
        ContactDetailsRestService.doPostAction();
    }
    //test for null json data
    static testMethod void contactDetailsTest4() {    
      
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'all');
       
        
        List<String> ids=new List<String>();
       // ids.add('003c000000Lo9ITAAZ');
        //ids.add('0032000000RCelpAAD');
        
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);        
        ContactDetailsRestService.getContactDetails();
         ContactDetailsRestService.doPostAction();
    }
    
    
    static testMethod void contactDetailsByRoleIdTest() {    
      	
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'findcontact');
        
        ContactDetailsRestService.Jsondata2 jsonWrapper=new ContactDetailsRestService.Jsondata2();
        jsonWrapper.addressId=234234;
        List<String> conIds=new List<String>();
        conIds.add('0032000000RCelpAAD'); //test id
        jsonWrapper.contactIds=conIds;
        jsonWrapper.email='testmail';
        jsonWrapper.firstName='testname';
        jsonWrapper.lastName='testname2';
        jsonWrapper.mobilePhone='2341243';
        jsonWrapper.organizationName='testOrg';
        jsonWrapper.privatePhone='234234';
        jsonWrapper.roleId='a0DD0000009XVncMAG';
        jsonWrapper.title='testTitle';
        jsonWrapper.workPhone='23423423';      
        
         String jsonString=JSON.serialize(jsonWrapper);
        RestContext.request.requestBody=Blob.valueOf(jsonString);   
        
        ContactDetailsRestService.getContactDetailsByRoleId();
        
        ContactDetailsRestService.ContactWrapper conWrapper=new ContactDetailsRestService.ContactWrapper();
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
        conWrapper.name='John Cena';
        conWrapper.organization='testOrg';
        conWrapper.POBoxNr='testPO';
        conWrapper.postCode='testPOCode';
        conWrapper.privatePhone='234234';
        conWrapper.streetName='MG';
        conWrapper.title='Mr';
        conWrapper.town='Las Vegas';
        conWrapper.workPhone='234234';
        
        ContactDetailsRestService.doPostAction();
        
    }
    
    
}