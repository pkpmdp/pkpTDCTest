global class MessagingOEndCustomer {


     @future(callout=true)
  public static void callMessaging(String AccountId)
     {
     System.debug('Messaging called');
         try{
            Account Act = [SELECT Id, Name, Customer_No__c, Type, Email__c, PersonEmail, FirstName,IsPersonAccount, LastName, PersonMobilePhone, Mobile_phone__c FROM Account where id =: AccountId];
               
            System.debug('Act: '+Act);
            String fName ='';
            String lName ='';
            if(Act.LastName!=null)
            lName = Act.LastName;
            if(Act.FirstName!=null)
            fName = Act.FirstName;
            String endPoint = messaging_end_point__c.getInstance('endPointUrl').Value__c;
            Httprequest request = new Httprequest();
            request.setEndpoint(endpoint+'/messaging'); 
            request.setMethod('POST'); 
            String body ='{"kontaktform":"O-slutkunde", "email":"'+Act.PersonEmail+'", "data":{"fornavn":"'+fName+'", "efternavn":"'+lName+'", "permissionGranted":"true"}}';
            request.setBody(body);
            system.debug('request body: '+request.getBody());
            request.setTimeout(60000);              
            String httpResp = '';
            Http http = new Http(); 
            Httpresponse response;
            response = http.send(request);
            System.debug('response'+response+' response body: '+response.getBody());
           
            }catch(Exception e){
            system.debug('MessagingOEndCustomer exception '+e.getMessage());
                     
            }
    
     }
     
      @IsTest(SeeAllData=true)
      public static void testCallMessagingOEndCustomer(){
      Account account = new Account();
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];        
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Temp1';
        account.LastName = 'Temp';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='111111';
        insert account;
      MessagingOEndCustomer.callMessaging(''+account.id);
      }
}