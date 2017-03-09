@isTest
public class LeadWS_UpdateStatustest {
    
    @testSetup
    static void testData(){
        Yousee13Campaign__c customsetting3 =new Yousee13Campaign__c();
        customsetting3.Name='Registration';
        customsetting3.SiteGuestUserId__c='005M0000004Odn8';
        customsetting3.Lead_RecordType__c='012M0000000CsDc';
        insert customsetting3;
        
        Lead lead1 =new Lead(FirstName='Theo',LastName='Walcott',Email='Theo@gmail.com',MobilePhone='223344',LeadSource='Service Center - Member registration');
        insert lead1;
        
    }
    
    static testMethod void LeadWS_Updatestatustest() {
        
        Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +leadid+ '","status":"Success","message":"", "amsId":"111", "customerNr":"239"}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
        
        Lead leadobjaft = [Select id,Status from Lead where FirstName ='Theo' ];
        System.debug('Afterupdate statuus ' + leadobjaft.status);
        System.assertequals(leadobjaft.status,System.label.Yousee_O_customerLeadStatusRegistreringGennemf_rt);
    }
    
    static testMethod void LeadWS_Updatestatustest2() {
        
        Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +leadid+ '","status":"Failure","message":"no installtion", "amsId":"111", "customerNr":"239"}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
        
        Lead leadobjaft = [Select id,Status,Description from Lead where FirstName ='Theo' ];
        System.debug('Afterupdate statuus ' + leadobjaft.status);
        System.assertequals(leadobjaft.status,System.label.Yousee_O_customerLeadStatusRegistreringMislykkedes);
        System.assertequals(leadobjaft.Description,'no installtion');
    }

    static testMethod void LeadWS_Updatestatustest3() {
        
        Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +leadid+ '","status":"Donotcontact","message":"", "amsId":"111", "customerNr":"239"}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
        
        Lead leadobjaft = [Select id,Status,Unsubscribed__c from Lead where FirstName ='Theo' ];
        System.debug('Afterupdate statuus ' + leadobjaft.status);
        System.assertequals(leadobjaft.status,'Afmeldt');
        System.assertequals(leadobjaft.Unsubscribed__c,true);
    }
     
     static testMethod void LeadWS_Updatestatustestnegative() {
     	try{
     	Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +'Asddreefg'+ '","status":"Success","message":"Donotcontact", "amsId":"111", "customerNr":"239"}';
        String JSONMsg1 = '{"leadId":"' +leadid+ '","message":"", "amsId":"", "customerNr":""}';
        String JSONMsg2 = '{"leadId":"","message":"", "amsId":"", "customerNr":""}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
     	}
     	catch(Exception e){
     		System.debug('#######'+ e.getMessage());
     	}
        
     }
    
    
     static testMethod void LeadWS_Updatestatustestnegative1() {
     	try{
     	Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +leadid+ '","message":"", "amsId":"", "customerNr":""}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
     	}
     	catch(Exception e){
      		System.debug('#######'+ e.getMessage());
     	}
        
     }
    
     static testMethod void LeadWS_Updatestatustestnegative2() {
     	try{
     	Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"","message":"", "amsId":"", "customerNr":""}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
     	}
     	catch(Exception e){
      		System.debug('#######'+ e.getMessage());
     	}
        
     }
    
    
    
    
    
   
    static testMethod void LeadWS_Updatestatustest5() {
        
        Lead leadobj = [Select id from Lead where FirstName ='Theo' ];
        String leadid = leadobj.id;
        System.debug('Lead id @@@@'+ leadid);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/LeadRest';
        req.httpMethod = 'POST';
        String JSONMsg = '{"leadId":"' +leadid+ '","status":"Failure","message":"no installtion"}';
        system.debug('JSONMsg '+ JSONMsg);
        //String body= JSON.serialize(JSONMsg);
        //system.debug('Body' + body);
        //System.debug('Blobvalue of' + Blob.valueof(body) );
        req.requestBody = Blob.valueof(JSONMsg);
        //req.requestBody = body;
        RestContext.request = req;
        RestContext.response = res;
        String response=LeadWS_UpdateStatus.updateLead();
        System.debug('Response' + response );
        
        Lead leadobjaft = [Select id,Status,Description from Lead where FirstName ='Theo' ];
        System.debug('Afterupdate statuus ' + leadobjaft.status);
        System.assertequals(leadobjaft.status,'Registrering mislykkedes');
        System.assertequals(leadobjaft.Description,'no installtion');
    }
}