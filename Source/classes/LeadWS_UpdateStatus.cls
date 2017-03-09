@RestResource(urlMapping='/LeadRest/*')
global class LeadWS_UpdateStatus {
    
    
    @HttpPost
    global static String updateLead(){
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String bodyString = body.toString();

        //Deserializing the data sent into concrete SFDC objects
        Jsondata jsonwrap =(Jsondata)JSON.deserialize(bodyString,Jsondata.class);
        System.debug('The request recieved' +jsonwrap );
        System.debug('The request status' +jsonwrap.status );
        System.debug('The request message' +jsonwrap.message );
        System.debug('The request leadid' +jsonwrap.leadId );
        System.debug('The request amsId' +jsonwrap.amsId );
        System.debug('The request customerNr' +jsonwrap.customerNr );
        try{
        Lead obj= new Lead();
        if(String.isNotBlank(jsonwrap.leadId) ){
        obj= [Select Name,Status,Permission__c,Description from Lead where id=:jsonwrap.LeadId limit 1];
            if(String.isNotBlank(jsonwrap.status) && 'Donotcontact'.equalsIgnoreCase(jsonwrap.status)){
                System.debug('Inside Donot contact');
                //obj.Permission__c='Nej';
                obj.Unsubscribed__c=true;
                obj.Status=System.label.Yousee_O_customerLeadStatusAfmeldt;
                
                update obj; 
            }
            else if(String.isNotBlank(jsonwrap.status) && 'Success'.equalsIgnoreCase(jsonwrap.status) /*&& String.isNotBlank(jsonwrap.amsId) && String.isNotBlank(jsonwrap.customerNr)*/){
                System.debug('Inside success');
                obj.Status=System.label.Yousee_O_customerLeadStatusRegistreringGennemf_rt;
                obj.Address_External_Id__c = jsonwrap.amsId;
                obj.Customer_Number__c = jsonwrap.customerNr;
                
                update obj; 
            }
            else if(String.isNotBlank(jsonwrap.status) && 'Failure'.equalsIgnoreCase(jsonwrap.status) && String.isNotBlank(jsonwrap.message)){
                System.debug('Inside failure');
                obj.Status= System.label.Yousee_O_customerLeadStatusRegistreringMislykkedes;
                obj.Description=jsonwrap.message;
                obj.Address_External_Id__c = jsonwrap.amsId;
                obj.Customer_Number__c = jsonwrap.customerNr;
                
                update obj; 
            }
            else {
                return System.label.Yousee_O_customerLeadWSErrorMsg;
            }
            /*obj.Form_AMS_Id__c = jsonwrap.amsId;
            obj.Form_Customer_Number__c  = jsonwrap.customerNr;*/
            
        }
        else
        {
                return System.label.Yousee_O_customerLeadWSErrorMsg;
        }
        System.debug('Updated object'+ obj);
        //update obj;   
        System.debug('After updatedml' + obj);
        System.debug('After updatedml permission' + obj.Permission__c);
        System.debug('After updatedml status' + obj.Status);
        return System.label.Yousee_O_customerLeadWSSuccessMsg;
        }
        catch(Exception Exp){
            System.debug('Update of lead has failed' + Exp.getMessage());
            return System.label.Yousee_O_customerLeadWSExceptionMsg;
        }
        
    }
    
    public class Jsondata { 
        public String leadId;
        public String status;       
        public String message;
        public String amsId;
        public String customerNr;

 }

}