@isTest(SeeAllData=true)
public class custrestclass
{
  static testMethod void testUpdateblockbuster() {
    /* CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
     cseq.lastNumber__c = 63647595;
     insert cseq;*/
     
    Address__c address1 = new Address__c();
       address1.Street__c = 'Stradellasvej';
       address1.External_Id__c ='66666666';
       address1.Entrance__c = '';
       address1.House_No__c = '80';
       address1.Floor__c = '2';
       address1.Postcode__c = '';
       address1.Town__c = 'paris'; 
       address1.Door_No__c = '';
       address1.OclearAddress__c = 'Yes';
       address1.Isubscription__c = 'No';
       insert address1;
      Address__c address2 = new Address__c();
       address2.Street__c = 'Stradellasvej';
       address2.External_Id__c ='66666667';
       address2.Entrance__c = '';
       address2.House_No__c = '80';
       address2.Floor__c = '2';
       address2.Postcode__c = '';
       address2.Town__c = 'paris'; 
       address2.Door_No__c = '';
       address2.OclearAddress__c = 'Yes';
       address2.Isubscription__c = 'No';
       insert address2;
      
      // account created for blockbuster
     User  u1 = [SELECT Id, Name FROM User where name='Kasia2 User' limit 1]; 
      System.runAs(u1) {
    Account account1 = new Account();
    RecordType recordType1 = [Select r.Name, r.Id From RecordType r where r.Name = 'Blockbuster Customer Account'];        
    account1.RecordTypeId =recordType1.Id;
    account1.Status_YK__c = 'Active';
    account1.FirstName = 'Sneha'; 
    account1.LastName = 'Salunkhe';
    account1.Invoice_Test__c = true;
    account1.Customer_response__c = 'Neutral omkring ændring';
    account1.Customer_No__c='370004410'; 
    account1.Billing_Address__c=address2.id;
    insert account1;
    
         Account custno = [select id,Customer_No__c from account where id=:account1.Id];
    String cnumberBB = custno.Customer_No__c;
    system.debug('cnumberBB : '+cnumberBB );
     // response for blockbuster
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = 'https://cs14.salesforce.com/services/apexrest/createNewCustomer'+'/'+cnumberBB ;
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doGet();
    RestResponse respon = RestContext.response; 
    system.debug('response: '+respon.responseBody.toString());
    req = new RestRequest();
    res = new RestResponse();
    String jsonRewuest1 =    '{"FirstName": "John1234","LastName": "TestCust2311","PersonHomePhone":"5463876","Brands":["Yousee","Blockbuster"],"Type": "Kunde","RecordType": "Blockbuster_Customer_Account","Phone":"5467876","PersonMobilePhone":"2265887","PersonEmail": "mamani@yousee.dk.test","CustomerType": "Enkel","CustomerSubType": "Normal", "AmsId": "'+address1.External_Id__c+'", "CustomerInformation":"account","StatusYK": "Active","BillingAddress":"'+address1.id+'","DKTVCustomerNumber":"123456","Permissions":{"Marketing_Permission":{"updated_date":null,"enabled":true,"changed_by":null},"E_kommunikation":{"updated_date":"2013-06-21","enabled":true,"changed_by":"magesh"},"Driftsinfo_pa_SMS":{"updated_date":"2013-07-21","enabled":true,"changed_by":"update kasia2 kunde"},"Driftsinfo_pa_email":{"updated_date":"2013-06-21","enabled":true,"changed_by":"mmm"},"Nej_til_markedsforing":{"updated_date":null,"enabled":true,"changed_by":null},"Nej_til_Telefonopkald":{"updated_date":null,"enabled":true,"changed_by":null}}}';

    req.requestBody = Blob.valueof(jsonRewuest1);
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doPost();
    respon = RestContext.response;
     system.debug('response Post: '+respon.responseBody.toString());
     req = new RestRequest();
    res = new RestResponse();
    String jsonRewuest2 = '{"CustomerNo": "'+cnumberBB +'","FirstName": "John1234","LastName": "TestCust2311","PersonHomePhone":"5463876","Brands":["Yousee","Blockbuster"],"Type": "Kunde","RecordType": "Blockbuster_Customer_Account","Phone":"5467876","PersonMobilePhone":"2265887","PersonEmail": "mamani@yousee.dk.test","CustomerType": "Enkel","CustomerSubType": "Normal", "AmsId": "'+address1.External_Id__c+'","CustomerInformation":"account data","StatusYK": "Active","BillingAddress":"'+address1.id+'","DKTVCustomerNumber":"123456","Permissions":{"Marketing_Permission":{"updated_date":null,"enabled":true,"changed_by":null},"E_kommunikation":{"updated_date":"2013-06-21","enabled":true,"changed_by":"magesh"},"Driftsinfo_pa_SMS":{"updated_date":"2013-07-21","enabled":true,"changed_by":"update kasia2 kunde"},"Driftsinfo_pa_email":{"updated_date":"2013-06-21","enabled":true,"changed_by":"mmm"},"Nej_til_markedsforing":{"updated_date":null,"enabled":true,"changed_by":null},"Nej_til_Telefonopkald":{"updated_date":null,"enabled":true,"changed_by":null}}}';
    req.requestBody = Blob.valueof(jsonRewuest2);
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doPatch();
    respon = RestContext.response;
     system.debug('response Patch: '+respon.responseBody.toString());
     }
     }}