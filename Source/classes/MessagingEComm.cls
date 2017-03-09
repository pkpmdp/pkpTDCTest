global class MessagingEComm {
//public static boolean inFutureContext = false;

     @future(callout=true)
  public static void callMessaging(String AccountId)
     {
     System.debug('Messaging called');
         try{
            Account Act = [SELECT AddressId__c, Address_merge_customer__c, Address_merge_field__pc, AlternateEmail__pc, Post_Code_YS__c, Id, Name, Customer_No__c, Type, E_comm_agreement__c, Email__c, PersonEmail, FirstName, House_No__c, Door_No_YK__c, District_YK__c, IsPersonAccount, LastName, PersonMobilePhone, Mobile_phone__c, Post_Code__c, POS__c, Post_Code_P__pc, Town_P__pc, Private_Email__pc, Street_YK__c, Town_YK__c FROM Account where id =: AccountId];
            String email = Act.PersonEmail;
            String mobile = ''+Act.PersonMobilePhone;
            String kundeid = ''+Act.Customer_No__c;
            datetime myDate = datetime.now();            
            String confirmDate = myDate.format('dd-MM-yyyy');
            String address = Act.Address_merge_customer__c;
            String lName = Act.LastName;
            String post = ''+Act.Post_Code__c;
            String city = Act.Town_YK__c;
            String fName = Act.FirstName;
            String amsid = ''+Act.AddressId__c;
   			String endPoint = messaging_end_point__c.getInstance('endPointUrl').Value__c;
            System.debug('Act: '+Act+' endpoint: '+endPoint);
            Httprequest request = new Httprequest();
            request.setEndpoint(endpoint+'/messaging'); 
            request.setMethod('POST'); 
            String body ='{"kontaktform": "EComBekraeftelse","receiver": {"email": "'+email+'","mobil": "'+mobile+'","kundenummer": "'+kundeid+'"},"data": {"ordre_dato": "'+confirmDate+'","adresse": "'+address+'","efternavn": "'+lName+'","postnr": "'+post+'","bynavn": "'+city+'","email": "'+email+'","kundeid": "'+kundeid+'","mobil": "'+mobile+'", "fornavn": "'+fName+'","amsid": "'+amsid+'"}}';
            request.setBody(body);
            system.debug('request body: '+request.getBody());
            request.setTimeout(60000);              
            String httpResp = '';
            Http http = new Http(); 
            Httpresponse response;
            response = http.send(request);
            System.debug('response'+response+' response body: '+response.getBody());
           
            }catch(Exception e){
            system.debug('MessagingEComm exception '+e.getMessage());
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
           
            }
    
     }
     
      @IsTest(SeeAllData=true)
      public static void testCallMessaging(){
      Account account = new Account();
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];        
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.FirstName = 'Temp1'; //SPOC-1396
        account.LastName = 'Temp';
        account.Invoice_Test__c = true;
        account.Customer_response__c = 'Neutral omkring ændring';
        account.Customer_No__c='111111';
        insert account;
      MessagingEComm.callMessaging(''+account.id);
      }
}