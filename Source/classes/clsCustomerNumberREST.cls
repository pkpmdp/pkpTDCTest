/*
 * Customer REST API
 * Version 1.1
 * createNewCustomer [HTTP POST]
 * createNewCustomer [HTTP PATCH]
*/

@RestResource(urlMapping='/createNewCustomer/*')
global with sharing class clsCustomerNumberREST {
    
public static Decimal TESTNUM = 68999998;
    public static String EXPNUM = '689999999';
    public static String TESTAMSID = '654321'; 
    public class InitializationException extends Exception {}
     
    public class Data {
        public Date updated_date;
        public String changed_by;
        public Boolean enabled;
        public Data(Date Udate,String changeBy,Boolean enabled){
            this.updated_date = Udate;
            this.changed_by = changeBy;
            this.enabled = enabled;  
        }
    }
    
    public class Permission {
        public Data Driftsinfo_pa_SMS;
        public Data Driftsinfo_pa_email;
        public Data E_kommunikation;
        public Data Nej_til_markedsforing;
        public Data Marketing_Permission;
        public Data Nej_til_Telefonopkald;
     
        public Permission(){}
      
        
    }
    
  
    
    public class AccountPermission{
    public Account AccountInfo{get;set;}
    public Permission Permissions{get;set;} 
    
    public void ConstructPermission(Permission__c perm){
        if(perm!=null){
        Data Driftsinfo_pa_SMS = new Data(perm.Driftsinfo_pa_SMS_Opdateret_Dato__c,perm.Driftsinfo_pa_SMS_Opdateret_af__c,perm.Driftsinfo_pa_SMS__c);
        Data Driftsinfo_pa_email = new Data(perm.Driftsinfo_pa_email_Opdateret_Dato__c,perm.Driftsinfo_pa_email_Opdateret_af__c,perm.Driftsinfo_pa_email__c);
        Data ecomm = new Data(perm.E_kommunikation_Opdateret_Dato__c,perm.E_kommunikation_Opdateret_af__c,perm.E_kommunikation__c);
        Data noThank = new Data(perm.Nej_til_markedsforing_Opdateret_Dato__c,perm.Nej_til_markedsforing_Opdateret_af__c,perm.Nej_til_markedsforing__c) ;
        Data Perm1 = new Data(perm.Marketing_permission_Opdateret_Dato__c,perm.Marketing_permission_Opdateret_af__c,perm.Marketing_Permission__c);
        Data telefon = new Data(perm.Nej_til_Telefonopkald_Opdateret_Dato__c,perm.Nej_til_Telefonopkald_Opdateret_af__c,perm.Nej_til_Telefonopkald__c);
       // Data robin = new Data(null,null,null);
        permissions = new Permission();
        permissions.Driftsinfo_pa_SMS = Driftsinfo_pa_SMS;
        permissions.Driftsinfo_pa_email = Driftsinfo_pa_email;
        permissions.E_kommunikation = ecomm;
        permissions.Nej_til_markedsforing = noThank;
        permissions.Marketing_Permission = Perm1;
        permissions.Nej_til_Telefonopkald = telefon;
       // permissions.Robinson =  robin;   
        }   
    }
        
    }
    
    public static String findAddressByAmsId(String amsId){
        if (amsId==null || amsId==''){
            return null;
        }
        List<Address__c> addressList = [select id from Address__c where External_Id__c=:amsId];
        if(addressList.size()==0) {
            throw new InitializationException('Address with AmsID ' + amsId + ' not found in the SPOC');
        }
        return addressList[0].Id;
    }
    
    public static String findRecTypeIdByDevName(String devName){
        List<RecordType> recTypeList = [select id from RecordType where SobjectType = 'Account' AND DeveloperName=:devName];
        if(recTypeList.size()==0) {
            throw new InitializationException('Record Type ' + devName + ' not found in the SPOC');
        }
            System.debug('recTypeList[0].Id-->'+recTypeList[0].Id);

        return recTypeList[0].Id;
    }



@HttpPost
    global static void doPost() {   
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob jsonBlob = req.requestBody;
        String jsonString = jsonBlob.toString();
        system.debug('response form post: '+jsonString);
        res.addHeader('Content-Type','application/json');
        String JsonResponse = '';
        Boolean throwAccountError=true;
        Boolean permissionerror = false;                               
        Account account = new Account();
        Map<String, Object> mainRes;
        Permission__c permission = new Permission__c();
        List<Permission__c> permissionResult;
        Boolean dsms = false;
        Boolean demail = false;
        Boolean ekom = false;
        Boolean mar_per = false;
        Boolean n_mar = false;
        Boolean n_tel = false;
       
        
        AccountPermission AccountData;
        JSONParser parser = JSON.createParser(jsonString);
        String  StringValue='';
        String fname;
        String lname;
        String phphone;
        String brands;//Added for SPOC-1822
        String type;
        String rtype;
        String phone;
        String pmphone;
        String pmail;
        String ctype;
        String csubtype;
        String amsid;
        String cinfo;
        String statusyk;
        String badd;
        String street_YK_ID;
        String Dktv_cust_no;
        try{
        while (parser.nextToken() != null) {
        
             //  try{
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                if(fieldName == 'FirstName') {
                fname = parser.getText();
                account.FirstName = fname;
                }else if(fieldName == 'LastName') {
                lname = parser.getText();
                account.LastName = lname;
                }else if(fieldName == 'PersonHomePhone') {
                phphone = parser.getText();
                if(phphone.length()>0) { account.PersonHomePhone = phphone; account.Home_Phone__c = phphone; }
               }
                //Start-Added for SPOC-1822
                else if(fieldName == 'Brands')
                {
               while(parser.nextToken() != JSONToken.END_ARRAY){
                        if(brands== null || brands== ''){
                                brands= parser.getText();
                        }else{
                                brands+= ';' +parser.getText();
                        }
                    }
                System.debug('Brands-->'+brands);
                account.Brands__c = brands;
                }
               //End-Added for SPOC-1822
        else if(fieldName == 'Type') {
                type = parser.getText();
                account.Type = type;
                }else if(fieldName == 'RecordType') {
                rtype = parser.getText();
                account.RecordTypeId = findRecTypeIdByDevName(rtype);
                }else if(fieldName == 'Phone') {
                phone = parser.getText();
                if(phone.length()>0)account.Phone = phone;
                }else if(fieldName == 'PersonMobilePhone') {
                pmphone = parser.getText();
                //if(pmphone.length()>0)account.PersonMobilePhone = pmphone;
                if(!String.isBlank(pmphone))account.PersonMobilePhone = pmphone;
                }else if(fieldName == 'PersonEmail') {
                pmail = parser.getText();
                if(pmail.length()>0)account.PersonEmail =pmail;
                }else if(fieldName == 'CustomerType') {
                ctype = parser.getText();
                account.Customer_type__c = ctype;
                }else if(fieldName == 'CustomerSubType') {
                csubtype = parser.getText();
                account.CustomerSubType__c = csubtype;
                }else if(fieldName == 'AmsId') {
                amsid = parser.getText();
                street_YK_ID = findAddressByAmsId(amsid);
                account.Street_YK__c = street_YK_ID;
                }else if(fieldName == 'CustomerInformation') {
                cinfo = parser.getText();
                 account.CustomerInformation__c = cinfo;
                }else if(fieldName == 'StatusYK') {
                statusyk = parser.getText();
                account.Status_YK__c = statusyk;
                }else if(fieldName == 'BillingAmsId') { 
                badd = parser.getText();
                 if (badd!=null && badd!= ''){
                    account.Billing_Address__c = findAddressByAmsId(badd);
                } else {
                    account.Billing_Address__c = street_YK_ID;
                }
                }else if(fieldName == 'DKTVCustomerNumber') {
                Dktv_cust_no = parser.getText();
                account.DKTV_Customer_Number__c = Dktv_cust_no;
                }
                else if(fieldName == 'Permissions'){
                    throwAccountError = false;
                    String ChangedBY;
                    Boolean enabledFlag;
                    Date updatedOn;
                    Data permData;
                    try{
                    system.debug('current Token'+parser.getCurrentToken());
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        JSONToken PreviouseToken;
                        
                        try{
                            While(parser.nextToken()!=null){
                                if(PreviouseToken!=null && (PreviouseToken == parser.getCurrentToken()) && (parser.getCurrentToken()==JSONToken.END_OBJECT))
                                break;
                                 PreviouseToken = parser.getCurrentToken();
                                system.debug('current Token inner'+parser.getCurrentToken());
                                if((parser.getCurrentToken()==JSONToken.FIELD_NAME ) && (parser.getText()=='Driftsinfo_pa_email' || parser.getText()=='Driftsinfo_pa_SMS' || parser.getText()=='Nej_til_markedsforing' || parser.getText()=='E_kommunikation' || parser.getText()=='Marketing_Permission' || parser.getText()=='Nej_til_Telefonopkald')){
                                    system.debug('parser.getText():'+parser.getText()); 
                                    String TokenText = parser.getText();
                                    parser.nextToken();
                                    system.debug('inner parser.getCurrentToken()'+parser.getCurrentToken());
                                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                try{
                                    permData = (Data)parser.readValueAs(Data.class);
                                    if(permData!=null){
                                        if(permData.enabled!=null){
                                            if(permData.changed_by==null)
                                                ChangedBY = 'automatisk';
                                                else
                                                ChangedBY = permData.changed_by;
                                            if(permData.updated_date==null)
                                                updatedOn = Date.today();
                                                else
                                                updatedOn = permData.updated_date;
                                    if(TokenText=='Driftsinfo_pa_email'){
                                        demail = true;                                           
                                        permission.Driftsinfo_pa_email__c = permData.enabled;
                                        permission.Driftsinfo_pa_email_Opdateret_Dato__c = updatedOn;
                                        permission.Driftsinfo_pa_email_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Driftsinfo_pa_SMS'){
                                        dsms = true;
                                        permission.Driftsinfo_pa_SMS__c= permData.enabled; // added for SPOC-1458        
                                        permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = updatedOn;
                                        permission.Driftsinfo_pa_SMS_Opdateret_af__c =ChangedBY;
                                    }else if(TokenText=='Nej_til_markedsforing'){
                                        n_mar = true;
                                        permission.Nej_til_markedsforing__c = permData.enabled;
                                        permission.Nej_til_markedsforing_Opdateret_Dato__c = updatedOn;
                                        permission.Nej_til_markedsforing_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='E_kommunikation'){
                                        ekom = true;
                                        permission.E_kommunikation__c = permData.enabled;
                                        permission.E_kommunikation_Opdateret_Dato__c = updatedOn;
                                        permission.E_kommunikation_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Marketing_Permission'){
                                        mar_per = true;
                                        permission.Marketing_Permission__c = permData.enabled;
                                        permission.Marketing_permission_Opdateret_Dato__c = updatedOn;
                                        permission.Marketing_permission_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Nej_til_Telefonopkald'){
                                        n_tel = true;
                                        permission.Nej_til_Telefonopkald__c = permData.enabled;
                                        permission.Nej_til_Telefonopkald_Opdateret_Dato__c = updatedOn;
                                        permission.Nej_til_Telefonopkald_Opdateret_af__c = ChangedBY;
                                    }
                                        }
                                    }
                                    system.debug('permData: '+permData);
                                    PreviouseToken = JSONToken.END_OBJECT;
                                    }catch(Exception e){
                                        system.debug('error: '+e.getMessage());
                                        permissionerror = true;
                                        throwAccountError = false;
                                    //break;
                                    continue;
                                    }
                    
                        System.debug('permData: '+permData);
                        
                                }
                            }
                                
                            }
                    }catch(Exception e){
                    system.debug('Error in inner while'+e.getMessage());                    
                    permissionerror = true;
                    throwAccountError = false;
                    
                    }   
                        
                    }
                    }catch(Exception e){
                            System.debug('permData: '+permData);
                            System.debug('Error in innerClass'+e.getMessage() );
                            
                        }
                    
                }else if(parser.getCurrentToken() == JSONToken.START_OBJECT){               
                        
                        
                        try{
                            While(parser.nextToken()!=null){
                                
                                if(parser.getCurrentToken()==JSONToken.FIELD_NAME){
                                parser.nextToken();
                                parser.skipChildren();
                                
                            }
                                
                            }
                    }catch(Exception e){
                    system.debug('Error in other object while'+e.getMessage());
                    permissionerror = true;
                    throwAccountError = false;
                    }                       
                    
                    
                    System.debug('other object');
                }
                
                
              if(!permissionerror){
                        throwAccountError= true;
                    }
               
            }
          // }catch(Exception e){system.debug('Account after parsing: '+e.getMessage()+' acc:'+account);}
                
        } 
        
        }catch(Exception e){
            
            System.debug('exception condition: '+throwAccountError+' permissionerror'+permissionerror);
            String Errormsg = e.getMessage();
            system.debug('Exception  '+Errormsg+' '+e);
            if((throwAccountError && !permissionerror) || Errormsg.contains('not found in the SPOC')){
            res.StatusCode = 400;
            JsonResponse = '{"response":{"status":"Failure","message":"'+Errormsg+'"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
        }
        
        }
        if((brands ==null) || (brands =='') || (brands =='null')){
                System.debug('brands val-->'+brands);
                account.brands__c='Yousee;';
                }
        insert account;
       system.debug('this is my inserted account ----'+account);
        Account result= new Account();
        if(rtype=='Blockbuster_Customer_Account')
        
        {
         result = [SELECT Id, Customer_No__c, FirstName, LastName,RecordTypeId,PersonMobilePhone,PersonHomePhone,PersonEmail,CustomerInformation__c FROM Account WHERE Id = :account.id limit 1];
        System.debug('In blockbuster');
        }
        else
        {
         result = [SELECT Id, Customer_No__c, FirstName, LastName,Type,RecordTypeId, Phone, PersonMobilePhone, PersonHomePhone, PersonEmail, Customer_type__c, CustomerSubType__c, Street_YK__c , CustomerInformation__c, Status_YK__c, Billing_Address__c,Billing_address_External_ID__c,AddressId__c FROM Account WHERE Id = :account.id limit 1];
                if(result.Phone==null)result.Phone = null;
 
        }
       system.debug('this is my inserted account ----'+result);      
       permission.Customer__c = account.id;
       permission.customerID__c = result.Customer_No__c;
         system.debug('customer_no: '+result.Customer_No__c);    
        system.debug('mobile number: '+account.PersonMobilePhone+' email: '+account.PersonEmail);
          
       try{
        if(account.PersonMobilePhone!=null && account.PersonMobilePhone!='' && account.PersonEmail!=null && account.PersonEmail!=''){ // added for SPOC-1458 
            if(!permission.Driftsinfo_pa_SMS__c && !dsms){
            permission.Driftsinfo_pa_SMS__c= true;        
            permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
            }
            }else if(account.PersonMobilePhone==null && account.PersonEmail!=null && account.PersonEmail!=''){
             if(!permission.Driftsinfo_pa_email__c && !demail){    
            permission.Driftsinfo_pa_email__c = true;
            permission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
             }
            }else if(account.PersonMobilePhone!=null && account.PersonMobilePhone!='' && account.PersonEmail==null){
            if(!permission.Driftsinfo_pa_SMS__c && !dsms){   
            permission.Driftsinfo_pa_SMS__c= true;        
            permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
            }
            }       
         
         
      insert permission;
      system.debug('permission: '+permission);
       }catch(Exception e){
        System.debug('Permission insert ERROR:'+e);
       }
       // Account result = [SELECT Id, Customer_No__c, FirstName, LastName, Type, RecordTypeId, Phone, PersonMobilePhone, PersonHomePhone, PersonEmail, Customer_type__c, CustomerSubType__c, Street_YK__c , CustomerInformation__c, Status_YK__c, Billing_Address__c,AddressId__c FROM Account WHERE Id = :account.id limit 1];
        if(result.PersonMobilePhone==null)result.PersonMobilePhone = null;
        if(result.PersonHomePhone==null)result.PersonHomePhone = null;
        if(result.PersonEmail==null)result.PersonEmail = null;
        if(result.FirstName==null)result.FirstName = null;
        if(result.LastName==null)result.LastName = null; 
        
        permissionResult = [SELECT Id, name, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c, Marketing_Permission__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_af__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,E_kommunikation_Opdateret_af__c,E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_af__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_af__c,Marketing_permission_Opdateret_Dato__c,Nej_til_Telefonopkald__c,Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c  FROM Permission__c WHERE Id = :permission.Id limit 1];
        AccountData = new AccountPermission();
        //AccountData.AccountInfo = account;
        AccountData.AccountInfo = result;
       if (permissionResult.size() > 0)
        {
        AccountData.ConstructPermission(permissionResult[0]);
        }
       // AccountData.ConstructPermission(permission);
        res.StatusCode = 200;       
account resultbrand = [SELECT brands__c,Customer_No__c FROM Account WHERE Id = :account.id limit 1];
        List<String> arrStr = new List<String>();
        arrStr=(resultbrand.brands__c).split(';');
        String brandjson='';
       if(arrStr.size() > 1)
       {
         for(integer i=0;i<arrStr.size();i++)
         {
          if(i==arrStr.size()-1)
           {
            brandjson=brandjson+'"'+arrStr[i] +'"';
           }
          else
          {
            brandjson=brandjson+'"'+arrStr[i] +'",';
          }
         }   
       } 
       else{
            brandjson='"'+resultbrand.brands__c+'"';
           }  
        System.debug('In blockbuster brandjson'+brandjson);
        if(rtype=='Blockbuster_Customer_Account'){//(brands.contains('Blockbuster')|| 
                System.debug('In blockbuster');
        //  accountJson Accjs= new accountJson(AccountData.AccountInfo);
        //  jsonResponse = Json.serialize(Accjs);
        child_Brands childbrand=new child_Brands(resultbrand);
        string jasonbrands=Json.serialize(childbrand).removeStart('{');
        jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+','+jasonbrands;
      //  jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+',"Brands":['+brandjson +']'+'}';
                System.debug('In blockbuster');
                system.debug('jaaaaaaaaaaaaason'+jsonResponse);
        }
        else
        {
         child_Brands childbrand=new child_Brands(resultbrand);
         string jasonbrands=Json.serialize(childbrand).removeStart('{');
         jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+','+jasonbrands.removeEnd('}')+',"Permissions":'+Json.serialize(AccountData.permissions)+'}';
 
        }
    res.responseBody = blob.valueOf(jsonResponse);
        return;
      //  return result;
    }
   @HttpPatch
    global static void doPatch() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob jsonBlob = req.requestBody;
        String jsonString = jsonBlob.toString();
        system.debug('response form patch: '+jsonString);
        res.addHeader('Content-Type','application/json');
        String JsonResponse = '';
        Boolean throwAccountError=true;
        Boolean permissionerror = false;                               
        Account account = new Account();
        Map<String, Object> mainRes;
        Permission__c permission = new Permission__c();
        permission.Driftsinfo_pa_SMS__c = null;
        permission.E_kommunikation__c = null;
        permission.Driftsinfo_pa_email__c = null;
        permission.Marketing_Permission__c = null;
        permission.Nej_til_markedsforing__c = null;
        permission.Nej_til_Telefonopkald__c = null;
        Boolean dsms = false;
        Boolean demail = false;
        Boolean ekom = false;
        Boolean mar_per = false;
        Boolean n_mar = false;
        Boolean n_tel = false;
        system.debug('perm: '+permission);
        
        AccountPermission AccountData;
        JSONParser parser = JSON.createParser(jsonString);
        String  StringValue='';
        String fname;
        String lname;
        String phphone;
        String brands;//added for SPOC-1822
        String type;
        String rtype;
        String phone;
        String pmphone;
        String pmail;
        String ctype;
        String csubtype;
        String amsid;
        String cinfo;
        String statusyk;
        String badd;
        String street_YK_ID;
        String CustomerNo;
        String Dktv_cust_no;
    //added for SPOC-1822
    String updatefname='no';
        String updatelname='no';
        String updatephphone='no';
        String updatebrands='no';//added for SPOC-1822
        String updatetype='no';
        String updatertype='no';
        String updatephone='no';
        String updatepmphone='no';
        String updatepmail='no';
        String updatectype='no';
        String updatecsubtype='no';
        String updateamsid='no';
        String updatecinfo='no';
        String updatestatusyk='no';
        String updatebadd='no';
        String updatestreet_YK_ID='no';
        String updateCustomerNo='no';
        String updateDktv_cust_no='no';
        try{
        while (parser.nextToken() != null) {
        
             //  try{
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    
                  if(fieldName == 'CustomerNo') {
                CustomerNo = parser.getText();                  
                }else if(fieldName == 'FirstName') {
                fname = parser.getText();
                updatefname='yes';
                //account.FirstName = fname;
                }
                else if(fieldName == 'LastName') {
                lname = parser.getText();
                updatelname ='yes';
                //account.LastName = lname;
                }else if(fieldName == 'PersonHomePhone') {
                phphone = parser.getText();
                updatephphone ='yes';
                //account.PersonHomePhone = phphone;
                }
               //Start-Added for SPOC-1822
 
                else if(fieldName == 'Brands')
                {
                 
           
                    while(parser.nextToken() != JSONToken.END_ARRAY){
                        if(brands== null || brands== ''){
                                brands= parser.getText();
                                System.debug('inside 1');
                        }else{
                                brands+= ';' +parser.getText();
                                System.debug('inside 2');
                        }
                    }
                System.debug('Brands-->'+brands);
                
                   updatebrands='yes';   
   System.debug('updatebrands-->'+updatebrands);
                }
              //End-Added for SPOC-1822
                else if(fieldName == 'Type') {
                type = parser.getText();
                //account.Type = type;
                updatetype ='yes';
                }else if(fieldName == 'RecordType') {
                 rtype = parser.getText();
                updatertype ='yes';
                 //account.RecordTypeId = findRecTypeIdByDevName(rtype);
                }else if(fieldName == 'Phone') {
                phone = parser.getText();
                updatephone ='yes';
                //account.Phone = phone;
                }else if(fieldName == 'PersonMobilePhone') {
                pmphone = parser.getText();
                system.debug('check pmphone :'+pmphone );
                updatepmphone ='yes';
                }else if(fieldName == 'PersonEmail') {
                pmail = parser.getText();
                updatepmail ='yes'; 
               }else if(fieldName == 'CustomerType') {
                ctype = parser.getText();
                updatectype ='yes';
                //account.Customer_type__c = ctype;
                }else if(fieldName == 'CustomerSubType') {
                csubtype = parser.getText();
                updatecsubtype ='yes';
                //account.CustomerSubType__c = csubtype;
                }else if(fieldName == 'AmsId') {
                amsid = parser.getText();
                street_YK_ID = findAddressByAmsId(amsid);
                //account.Street_YK__c = street_YK_ID;
                updatestreet_YK_ID='yes';
                }else if(fieldName == 'CustomerInformation') {
                cinfo = parser.getText();
                updatecinfo ='yes';
                //account.CustomerInformation__c = cinfo;
                }else if(fieldName == 'StatusYK') {
                statusyk = parser.getText();
                updatestatusyk ='yes';
                //account.Status_YK__c = statusyk;
                }else if(fieldName == 'BillingAmsId') {
                badd = parser.getText();
                updatebadd ='yes';
 
                }else if(fieldName == 'DKTVCustomerNumber') {
                Dktv_cust_no = parser.getText();
                updateDktv_cust_no ='yes';
                //account.DKTV_Customer_Number__c = Dktv_cust_no;
                }
                else if(fieldName == 'Permissions'){
                    throwAccountError = false;
                    String ChangedBY;
                    Boolean enabledFlag;
                    Date updatedOn;
                    Data permData;
                    try{
                    system.debug('current Token'+parser.getCurrentToken());
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        JSONToken PreviouseToken;
                        try{
                            While(parser.nextToken()!=null){
                                if(PreviouseToken!=null && (PreviouseToken == parser.getCurrentToken()) && (parser.getCurrentToken()==JSONToken.END_OBJECT))
                                break;
                                 PreviouseToken = parser.getCurrentToken();
                                system.debug('current Token inner'+parser.getCurrentToken());
                                if((parser.getCurrentToken()==JSONToken.FIELD_NAME ) && (parser.getText()=='Driftsinfo_pa_email' || parser.getText()=='Driftsinfo_pa_SMS' || parser.getText()=='Nej_til_markedsforing' || parser.getText()=='E_kommunikation' || parser.getText()=='Marketing_Permission' || parser.getText()=='Nej_til_Telefonopkald')){
                                    system.debug('parser.getText():'+parser.getText()); 
                                    String TokenText = parser.getText();
                                    parser.nextToken();
                                    system.debug('inner parser.getCurrentToken()'+parser.getCurrentToken());
                                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                try{
                                    permData = (Data)parser.readValueAs(Data.class);
                                    if(permData!=null){
                                        if(permData.enabled!=null){
                                            if(permData.changed_by==null)
                                                ChangedBY = 'automatisk';
                                                else
                                                ChangedBY = permData.changed_by;
                                            if(permData.updated_date==null)
                                                updatedOn = Date.today();
                                                else
                                                updatedOn = permData.updated_date;
                                    if(TokenText=='Driftsinfo_pa_email'){
                                        demail = true;                                           
                                        permission.Driftsinfo_pa_email__c = permData.enabled;
                                        permission.Driftsinfo_pa_email_Opdateret_Dato__c = updatedOn;
                                        permission.Driftsinfo_pa_email_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Driftsinfo_pa_SMS'){
                                        dsms = true;
                                        permission.Driftsinfo_pa_SMS__c= permData.enabled; // added for SPOC-1458        
                                        permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = updatedOn;
                                        permission.Driftsinfo_pa_SMS_Opdateret_af__c =ChangedBY;
                                    }else if(TokenText=='Nej_til_markedsforing'){
                                        n_mar = true;
                                        permission.Nej_til_markedsforing__c = permData.enabled;
                                        permission.Nej_til_markedsforing_Opdateret_Dato__c = updatedOn;
                                        permission.Nej_til_markedsforing_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='E_kommunikation'){
                                        ekom = true;
                                        permission.E_kommunikation__c = permData.enabled;
                                        permission.E_kommunikation_Opdateret_Dato__c = updatedOn;
                                        permission.E_kommunikation_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Marketing_Permission'){
                                         mar_per = true;
                                        permission.Marketing_Permission__c = permData.enabled;
                                        permission.Marketing_permission_Opdateret_Dato__c = updatedOn;
                                        permission.Marketing_permission_Opdateret_af__c = ChangedBY;
                                    }else if(TokenText=='Nej_til_Telefonopkald'){
                                        n_tel = true;
                                        permission.Nej_til_Telefonopkald__c = permData.enabled;
                                        permission.Nej_til_Telefonopkald_Opdateret_Dato__c = updatedOn;
                                        permission.Nej_til_Telefonopkald_Opdateret_af__c = ChangedBY;
                                    }
                                        }
                                    }
                                    system.debug('permData: '+permData);
                                    PreviouseToken = JSONToken.END_OBJECT;
                                    }catch(Exception e){
                                        system.debug('error: '+e.getMessage());
                                        permissionerror = true;
                                        throwAccountError = false;
                                    //break;
                                    continue;
                                    }
                        System.debug('permData: '+permData);
                                }
                            }
                            }
                    }catch(Exception e){
                    system.debug('Error in inner while'+e.getMessage());                    
                    permissionerror = true;
                    throwAccountError = false;
                    }    
                    }
                    }catch(Exception e){
                            System.debug('permData: '+permData);
                            System.debug('Error in innerClass'+e.getMessage() );  
                        }
                }else if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        try{
                            While(parser.nextToken()!=null){
                                
                                if(parser.getCurrentToken()==JSONToken.FIELD_NAME){
                                parser.nextToken();
                                parser.skipChildren();    
                            }}
                    }catch(Exception e){
                    system.debug('Error in other object while'+e.getMessage());
                    permissionerror = true;
                    throwAccountError = false;
                    }  
                    System.debug('other object');
                }
              if(!permissionerror){
                        throwAccountError= true;
                    }
            }
          // }catch(Exception e){system.debug('Account after parsing: '+e.getMessage()+' acc:'+account);}       
        } 
        }catch(Exception e){
            
            System.debug('exception condition: '+throwAccountError+' permissionerror'+permissionerror);
            String Errormsg = e.getMessage();
            system.debug('Exception  '+Errormsg+' '+e);
            if((throwAccountError && !permissionerror) || Errormsg.contains('not found in the SPOC')){
            res.StatusCode = 400;
            JsonResponse = '{"response":{"status":"Failure","message":"'+Errormsg+'"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
        }
        
        }
        
        if(CustomerNo==null){
            res.statusCode = 400;
            jsonResponse = '{"response":{"status":"Failure","message":"Missing Required Query Parameter - CustomerNo"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        try {
            account = [SELECT Id, Customer_No__c, FirstName, LastName,brands__c,Type, RecordTypeId,recordtype.name, Phone,
                PersonMobilePhone, PersonHomePhone, PersonEmail, Customer_type__c, CustomerSubType__c, Street_YK__c , 
                CustomerInformation__c, Status_YK__c, Billing_Address__c,Billing_address_External_ID__c, Net_Installation__c, DKTV_Customer_Number__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
      
        }catch(System.QueryException e){
            if (e.getMessage() == 'List has no rows for assignment to SObject'){
                res.StatusCode = 404;
                JsonResponse = '{"response":{"status":"Failure","message":"Customer number '+CustomerNo+' is not in SPOC"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
        }
        String PrevEmail = account.PersonEmail;
        String PrevMobNumber = account.PersonMobilePhone;
 if (fname==null){
         if(updatefname=='yes')
         { account.FirstName = fname;}
         }
         else
         { account.FirstName = fname;
         }
          if (lname==null){
         if(updatelname=='yes')
         { account.LastName = lname;}
         }
         else
         { account.LastName = lname;
         }
       if(brands ==null){
        if(updatebrands=='yes')
       {account.brands__c=brands;}
       
       }
       else {account.brands__c=brands;}
         if (type==null){
         if(updatetype=='yes')
         { account.Type = type;
}
         }
         else
         { account.Type = type;
         }
          if (rtype==null){
         if(updatertype=='yes')
         { account.RecordTypeId = findRecTypeIdByDevName(rtype);
}
         }
         else
         { account.RecordTypeId = findRecTypeIdByDevName(rtype);
         }
         if (phone==null){
         if(updatephone=='yes')
         {  account.Phone = phone;
}
         }
         else
         {  account.Phone = phone;
         }
        if (pmphone==null){
         if(updatepmphone=='yes')
         {   account.PersonMobilePhone = pmphone;
}
         }
         else
         {   account.PersonMobilePhone = pmphone;
         }
        if (phphone==null){
         if(updatephphone=='yes')
         {   account.PersonHomePhone = phphone; 
        account.Home_Phone__c = phphone;
}
         }
         else
         {   account.PersonHomePhone = phphone; 
        account.Home_Phone__c = phphone;
         }
        if (pmail==null){
         if(updatepmail=='yes')
         {   account.PersonEmail = pmail;
}
         }
         else
         {   account.PersonEmail = pmail;
         }
       if (ctype==null){
         if(updatectype=='yes')
         {   account.Customer_type__c = ctype;
         }
         }
         else
         {   account.Customer_type__c = ctype;
         }
         if (csubtype==null){
         if(updatecsubtype=='yes')
         {    account.CustomerSubType__c = csubtype;
         }
         }
         else
         {    account.CustomerSubType__c = csubtype;
         }
         if (street_YK_ID==null){
         if(updatestreet_YK_ID=='yes')
         {    account.Street_YK__c = street_YK_ID;
         }
         }
         else
         {   account.Street_YK__c = street_YK_ID;
         }
        if (cinfo==null){
         if(updatecinfo=='yes')
         {     account.CustomerInformation__c = cinfo;
         }
         }
         else
         {    account.CustomerInformation__c = cinfo;
         }
         if (statusyk==null){
         if(updatestatusyk=='yes')
         {    account.Status_YK__c = statusyk;
         }
         }
         else
         {    account.Status_YK__c = statusyk;
         }
         if (badd==null){
         if(updatebadd=='yes')
         {    account.Billing_Address__c = badd;
         }
         }
         else
         {    account.Billing_Address__c = badd;
         }
         if (Dktv_cust_no==null){
         if(updateDktv_cust_no=='yes')
         {    account.DKTV_Customer_Number__c = Dktv_cust_no;
         }
         }
         else
         {    account.DKTV_Customer_Number__c = Dktv_cust_no;
         }
 
 
        system.debug('acc mobile:'+account.PersonMobilePhone);
        update account;
        account resultbrand = [SELECT brands__c,Customer_No__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
        account result= new Account();
        if(account.recordtype.name=='Blockbuster Customer Account')
        
        {
         result= [SELECT Id, Customer_No__c, FirstName, LastName,RecordTypeId,PersonMobilePhone,PersonHomePhone,PersonEmail,CustomerInformation__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
        System.debug('In blockbuster');
        }
        else
        {
         result= [SELECT Id, Customer_No__c, FirstName, LastName,Type,RecordTypeId,Phone, PersonMobilePhone, PersonHomePhone, PersonEmail, Customer_type__c, CustomerSubType__c, Street_YK__c , CustomerInformation__c, Status_YK__c, Billing_Address__c,Billing_address_External_ID__c,AddressId__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
          if(result.Phone==null)result.Phone = null;
        }
    if(result.PersonMobilePhone==null)result.PersonMobilePhone = null;
        if(result.PersonHomePhone==null)result.PersonHomePhone = null;
        
        if(result.PersonEmail==null)result.PersonEmail = null;
        if(result.FirstName==null)result.FirstName = null;
        if(result.LastName==null)result.LastName = null;
        
        Permission__c permissionUpdate =  new Permission__c();
         Boolean insertPermission = false;
         Permission__c original_permission = null;
       try{
            permissionUpdate = [SELECT Id, name,customerID__c, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c, Marketing_Permission__c, Driftsinfo_pa_SMS_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_af__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,E_kommunikation_Opdateret_af__c,E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_af__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_af__c,Marketing_permission_Opdateret_Dato__c,Nej_til_Telefonopkald__c,Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c  FROM Permission__c WHERE Customer__c = :account.Id limit 1];
            original_permission = permissionUpdate.clone(true,true,false,false);
        }catch(System.QueryException e){
            if (e.getMessage() == 'List has no rows for assignment to SObject'){
                permissionUpdate = new Permission__c();
                permissionUpdate.Customer__c = account.id;
                permissionUpdate.customerID__c = result.Customer_No__c;
                insertPermission = true;
                
            }
        } 
         system.debug('permission: '+permission.Driftsinfo_pa_SMS__c);
        system.debug('PrevEmail '+PrevEmail+' PrevMobNumber '+PrevMobNumber+' result.PersonMobilePhone'+result.PersonMobilePhone+' permission.Driftsinfo_pa_SMS__c'+permission.Driftsinfo_pa_SMS__c);
        if(PrevEmail==null && PrevMobNumber==null && (result.PersonMobilePhone!=null || result.PersonEmail!=null)){
            system.debug('paases');
            if(result.PersonMobilePhone!=null && result.PersonEmail!=null){ // added for SPOC-1458 
            if(permission.Driftsinfo_pa_SMS__c==false){
            permissionUpdate.Driftsinfo_pa_SMS__c= true;        
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
            }
            }else if(result.PersonMobilePhone==null && result.PersonEmail!=null){
            if(permission.Driftsinfo_pa_email__c==false){
            permissionUpdate.Driftsinfo_pa_email__c = true;
            permissionUpdate.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            permissionUpdate.Driftsinfo_pa_email_Opdateret_af__c = 'automatisk';
            }
            }else if(result.PersonMobilePhone!=null && result.PersonEmail==null){
            if(permission.Driftsinfo_pa_SMS__c==false){
            permissionUpdate.Driftsinfo_pa_SMS__c= true;        
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
            }
            }
             
        }/* commented for SPOC-1612 on 11/oct/13
        else if(PrevMobNumber==null && result.PersonMobilePhone!=null){
            system.debug('pass');
            if(permission.Driftsinfo_pa_SMS__c==false){
                system.debug('pass1');  
            permissionUpdate.Driftsinfo_pa_SMS__c= true;        
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_af__c ='automatisk';
            }
        }*/
        
        system.debug('permission: '+permission);
        System.debug('before update permission:'+permissionUpdate);
        if(permission!=null){
        if (permission.Driftsinfo_pa_SMS__c!=null && dsms){
            if(result.PersonMobilePhone==null)
            permissionUpdate.Driftsinfo_pa_SMS__c = false;  
            else        
            permissionUpdate.Driftsinfo_pa_SMS__c = permission.Driftsinfo_pa_SMS__c;
            if(original_permission!=null && (permissionUpdate.Driftsinfo_pa_SMS__c != original_permission.Driftsinfo_pa_SMS__c)){
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_Dato__c = permission.Driftsinfo_pa_SMS_Opdateret_Dato__c;
            permissionUpdate.Driftsinfo_pa_SMS_Opdateret_af__c = permission.Driftsinfo_pa_SMS_Opdateret_af__c;
            }
            
       }
       system.debug('perm email: '+permission.Driftsinfo_pa_email__c+' demail:'+demail);
        if (permission.Driftsinfo_pa_email__c!=null && demail){
            if(result.PersonEmail==null)
            permissionUpdate.Driftsinfo_pa_email__c = false;
            else
            permissionUpdate.Driftsinfo_pa_email__c = permission.Driftsinfo_pa_email__c;
            if(original_permission!=null && (permissionUpdate.Driftsinfo_pa_email__c != original_permission.Driftsinfo_pa_email__c)){
            permissionUpdate.Driftsinfo_pa_email_Opdateret_Dato__c = permission.Driftsinfo_pa_email_Opdateret_Dato__c;
            permissionUpdate.Driftsinfo_pa_email_Opdateret_af__c = permission.Driftsinfo_pa_email_Opdateret_af__c;
            }
        }
        if (permission.E_kommunikation__c!=null && ekom){
             permissionUpdate.E_kommunikation__c = permission.E_kommunikation__c;
             if(original_permission!=null && (permissionUpdate.E_kommunikation__c != original_permission.E_kommunikation__c)){
            permissionUpdate.E_kommunikation_Opdateret_Dato__c = permission.E_kommunikation_Opdateret_Dato__c;
            permissionUpdate.E_kommunikation_Opdateret_af__c = permission.E_kommunikation_Opdateret_af__c;
             }
        }
        if (permission.Nej_til_markedsforing__c!=null && n_mar){
             permissionUpdate.Nej_til_markedsforing__c = permission.Nej_til_markedsforing__c;
             if(original_permission!=null && (permissionUpdate.Nej_til_markedsforing__c != original_permission.Nej_til_markedsforing__c)){
            permissionUpdate.Nej_til_markedsforing_Opdateret_Dato__c = permission.Nej_til_markedsforing_Opdateret_Dato__c;
            permissionUpdate.Nej_til_markedsforing_Opdateret_af__c = permission.Nej_til_markedsforing_Opdateret_af__c;
             }
        }
        if (permission.Marketing_Permission__c!=null && mar_per){
             permissionUpdate.Marketing_Permission__c = permission.Marketing_Permission__c;
             if(original_permission!=null && (permissionUpdate.Marketing_Permission__c != original_permission.Marketing_Permission__c)){
            permissionUpdate.Marketing_permission_Opdateret_Dato__c = permission.Marketing_permission_Opdateret_Dato__c;
            permissionUpdate.Marketing_permission_Opdateret_af__c = permission.Marketing_permission_Opdateret_af__c;
             }
        }
        if (permission.Nej_til_Telefonopkald__c!=null && n_tel){
             permissionUpdate.Nej_til_Telefonopkald__c = permission.Nej_til_Telefonopkald__c;
             if(original_permission!=null && (permissionUpdate.Nej_til_Telefonopkald__c != original_permission.Nej_til_Telefonopkald__c)){
            permissionUpdate.Nej_til_Telefonopkald_Opdateret_Dato__c = permission.Nej_til_Telefonopkald_Opdateret_Dato__c;
            permissionUpdate.Nej_til_Telefonopkald_Opdateret_af__c = permission.Nej_til_Telefonopkald_Opdateret_af__c;
             }
        }
        }
        
        
        system.debug('permissionUpdate: '+permissionUpdate);
        
          if(insertPermission){
        insert permissionUpdate;
    }else{
        System.debug('permissionUpdate');
        update permissionUpdate;
    } 
        
      system.debug('permissionUpdate after update: '+permissionUpdate);
        List<Permission__c> permissionResult; 
        permissionResult = [SELECT Id, name, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c, Marketing_Permission__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_af__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,E_kommunikation_Opdateret_af__c,E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_af__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_af__c,Marketing_permission_Opdateret_Dato__c,Nej_til_Telefonopkald__c,Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c  FROM Permission__c WHERE Id = :permissionUpdate.Id limit 1];
        system.debug('permissionResult: '+permissionResult);
        AccountData = new AccountPermission();
        AccountData.AccountInfo = result;
       if (permissionResult.size() > 0)
        {
        AccountData.ConstructPermission(permissionResult[0]);
        }       
        res.StatusCode = 200;       
      if(account.recordtype.name=='Blockbuster Customer Account'){//(brands.contains('Blockbuster')|| 
                System.debug('In blockbuster');
        
        //  accountJson Accjs= new accountJson(AccountData.AccountInfo);
        //  jsonResponse = Json.serialize(Accjs);
        child_Brands childbrand=new child_Brands(resultbrand);
        string jasonbrands=Json.serialize(childbrand).removeStart('{');
        jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+','+jasonbrands;
      //  jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+',"Brands":['+brandjson +']'+'}';
                System.debug('In blockbuster');
                system.debug('jaaaaaaaaaaaaason'+jsonResponse);
 
        }
        else
        {
         child_Brands childbrand=new child_Brands(resultbrand);
         string jasonbrands=Json.serialize(childbrand).removeStart('{');
         jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+','+jasonbrands.removeEnd('}')+',"Permissions":'+Json.serialize(AccountData.permissions)+'}';
       //  jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+',"Brands":['+brandjson +']'+',"Permissions":'+Json.serialize(AccountData.permissions)+'}';
 
        }       
    res.responseBody = blob.valueOf(jsonResponse);
        return;
                
    } 
    
     @HttpGet
    global static void doGet() {
        //If is not sended parameter by HTTP PATCH then value is = null 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        String JsonResponse = '';
        String CustomerNo = null;
        try{
            CustomerNo = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        }catch(Exception e){
            res.StatusCode = 500;
                JsonResponse = '{"response":{"status":"Failure","message":"'+e.getMessage()+'"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
        }
        //No CustomerNo in the parameter
        if(CustomerNo==null){
            res.statusCode = 400;
            jsonResponse = '{"response":{"status":"Failure","message":"Missing Required Query Parameter - CustomerNo"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        
        
        Account account;  
    Account Brand_child;

        
        
        try {
            account = [SELECT Id, Customer_No__c, FirstName, LastName,Type, RecordTypeId,RecordType.Name, Phone, PersonMobilePhone, PersonHomePhone, PersonEmail, Customer_type__c, CustomerSubType__c, Street_YK__c , CustomerInformation__c, Status_YK__c, Billing_Address__c,Billing_address_External_ID__c,AddressId__c,DKTV_Customer_Number__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
             Brand_child=[SELECT Customer_No__c,brands__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];

        }catch(System.QueryException e){
            if (e.getMessage() == 'List has no rows for assignment to SObject'){
                res.StatusCode = 404;
                JsonResponse = '{"response":{"status":"Failure","message":"Customer number '+CustomerNo+' is not in SPOC"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
              //  throw new InitializationException('This customer number ' + CustomerNo + ' is not in the SPOC');
            }
        }        
                             
       
        Permission__c permission;
        
        Boolean insertPermission = false;
       try{
            permission = [SELECT Id, name, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c, Marketing_Permission__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_af__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,E_kommunikation_Opdateret_af__c,E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_af__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_af__c,Marketing_permission_Opdateret_Dato__c,Nej_til_Telefonopkald__c,Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c  FROM Permission__c WHERE Customer__c = :account.Id limit 1];
        }catch(System.QueryException e){
            if (e.getMessage() == 'List has no rows for assignment to SObject'){
                permission = new Permission__c();
                permission.Customer__c = account.id;
               
            }
        }
        try{
     if(account.PersonMobilePhone==null)account.PersonMobilePhone = null;
     if(account.PersonHomePhone==null)account.PersonHomePhone = null;
     if(account.Phone==null)account.Phone = null;
     if(account.PersonEmail==null)account.PersonEmail = null;
     if(account.FirstName==null)account.FirstName = null;
     if(account.LastName==null)account.LastName = null; 

    AccountPermission AccountData = new AccountPermission();
    AccountData.AccountInfo = account;
    AccountData.ConstructPermission(permission);
      res.StatusCode = 200;
    //  jsonResponse ='{"AccountInfo":'+Json.serialize(AccountData.AccountInfo)+',"Permissions":'+Json.serialize(AccountData.permissions)+'}';
if(account.RecordType.Name=='Blockbuster Customer Account')
     {
        Account BBaccount = [SELECT Id, Customer_No__c,recordtypeId,FirstName, LastName,Type,PersonMobilePhone, PersonHomePhone, PersonEmail,CustomerInformation__c FROM Account WHERE Customer_No__c = :CustomerNo limit 1];
       child_Brands childbrand=new child_Brands(Brand_child);
      string jasonbrands=Json.serialize(childbrand).removeStart('{');
      jsonResponse = Json.serialize(BBaccount).removeEnd('}')+','+jasonbrands;
     }
     else{
      child_Brands childbrand=new child_Brands(Brand_child);
      string jasonbrands=Json.serialize(childbrand).removeStart('{');
      jsonResponse = Json.serialize(AccountData.AccountInfo).removeEnd('}')+','+jasonbrands.removeEnd('}')+',"Permissions":'+Json.serialize(AccountData.permissions)+'}';
      }
      res.responseBody = blob.valueOf(jsonResponse);
      return; 
  // return AccountData;
        }catch(Exception e){
            res.StatusCode = 500;
                JsonResponse = '{"response":{"status":"Failure","message":"'+e.getMessage()+'"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
        }                
    }
 
 //test method   
    static testMethod void testUpdatePermission() {
     CustomerNumberSeq__c cseq = new CustomerNumberSeq__c();
     cseq.lastNumber__c = 63647599;
     insert cseq;
    
    Address__c address = new Address__c();
       address.Street__c = 'Amagerbrogade123';
       address.External_Id__c ='55555555';
       address.Entrance__c = '';
       address.House_No__c = '40';
       address.Floor__c = '1';
       address.Postcode__c = '';
       address.Town__c = 'Orderse C'; 
       address.Door_No__c = '';
       address.OclearAddress__c = 'Yes';
       address.Isubscription__c = 'No';
       insert address;
     User  u = [SELECT Id, Name FROM User where name='Kasia2 User' limit 1]; 
      System.runAs(u) {
    Account account = new Account();
    RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];        
    account.RecordTypeId =recordType.Id;
    account.Status_YK__c = 'Active';
    account.FirstName = 'Temp1'; 
    account.LastName = 'Temp';
    account.PersonHomePhone='12345678';
    account.Brands__c='Yousee;Blockbuster';
    account.Invoice_Test__c = true;
    account.Customer_response__c = 'Neutral omkring ændring';
    account.Customer_No__c='370004477'; 
    
    
    
    insert account;
   
   //Added to increase code coverage on 1 NOV 2014
   findAddressByAmsId('');
  // findRecTypeIdByDevName('Po');
    
    
        


    Permission__c permission = new Permission__c();
    permission.Driftsinfo_pa_SMS__c = false;
    permission.Driftsinfo_pa_email__c = false;
    permission.E_kommunikation__c = false;
    permission.Nej_til_markedsforing__c = false;
    permission.Marketing_Permission__c = false;
    
    permission.Customer__c = account.Id; 
    system.debug('permission: '+permission); 
    insert permission;
    Permission__c pp = [select Customer__r.Customer_No__c from permission__c where id=:permission.Id];
    String cnumber = pp.Customer__r.Customer_No__c;
    system.debug('cnumber: '+cnumber);
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = 'https://cs14.salesforce.com/services/apexrest/   '+'/'+cnumber;
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doGet();      
    RestResponse respon = RestContext.response; 
    system.debug('response: '+respon.responseBody.toString()); 
    req = new RestRequest();
    res = new RestResponse();
    String jsonRewuest = '{"FirstName": "John1234","LastName": "TestCust2311","PersonHomePhone":"5463876","Brands":["Yousee","Blockbuster"],"Type": "Kunde","RecordType": "YK_Customer_Account","Phone":"5467876","PersonMobilePhone":"2265887","PersonEmail": "mamani@yousee.dk.test","CustomerType": "Enkel","CustomerSubType": "Normal", "AmsId": "'+address.External_Id__c+'", "CustomerInformation":"account","StatusYK": "Active","BillingAmsId":"'+address.id+'","DKTVCustomerNumber":"123456","Permissions":{"Marketing_Permission":{"updated_date":null,"enabled":true,"changed_by":null},"E_kommunikation":{"updated_date":"2013-06-21","enabled":true,"changed_by":"magesh"},"Driftsinfo_pa_SMS":{"updated_date":"2013-07-21","enabled":true,"changed_by":"update kasia2 kunde"},"Driftsinfo_pa_email":{"updated_date":"2013-06-21","enabled":true,"changed_by":"mmm"},"Nej_til_markedsforing":{"updated_date":null,"enabled":true,"changed_by":null},"Nej_til_Telefonopkald":{"updated_date":null,"enabled":true,"changed_by":null}}}';
    req.requestBody = Blob.valueof(jsonRewuest);
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doPost();
    respon = RestContext.response;
     system.debug('response Post: '+respon.responseBody.toString());
     req = new RestRequest();
    res = new RestResponse();
jsonRewuest = '{"CustomerNo": "'+cnumber+'","FirstName": "John1234","LastName": "TestCust2311","PersonHomePhone":"5463876","Brands":["Yousee","Blockbuster"],"Type": "Kunde","RecordType": "YK_Customer_Account","Phone":"5467876","PersonMobilePhone":"2265887","PersonEmail": "mamani@yousee.dk.test","CustomerType": "Enkel","CustomerSubType": "Normal", "AmsId": "'+address.External_Id__c+'","CustomerInformation":"account data","StatusYK": "Active","BillingAmsId":"'+address.id+'","DKTVCustomerNumber":"123456","Permissions":{"Marketing_Permission":{"updated_date":null,"enabled":true,"changed_by":null},"E_kommunikation":{"updated_date":"2013-06-21","enabled":true,"changed_by":"magesh"},"Driftsinfo_pa_SMS":{"updated_date":"2013-07-21","enabled":true,"changed_by":"update kasia2 kunde"},"Driftsinfo_pa_email":{"updated_date":"2013-06-21","enabled":true,"changed_by":"mmm"},"Nej_til_markedsforing":{"updated_date":null,"enabled":true,"changed_by":null},"Nej_til_Telefonopkald":{"updated_date":null,"enabled":true,"changed_by":null}}}';
    req.requestBody = Blob.valueof(jsonRewuest);
    RestContext.request = req;
    RestContext.response = res;
    clsCustomerNumberREST.doPatch();
    respon = RestContext.response;
     system.debug('response Patch: '+respon.responseBody.toString());
        
     
    //Permission__c p = doPatch(cnumber,null,null,null,false,true,true,'mani','2013-6-3','manij','2013-07-5','manik','2013-6-06');   
    //system.assertEquals(p.E_kommunikation_Opdateret_Dato__c,Date.valueOf('2013-6-3'));
    }}
    global class accountJson{
    public string Customer_No;
    public string FirstName;
    public string LastName;
    public string RecordTypeId;
    public string PersonMobilePhone;
    public string PersonHomePhone;
    public string PersonEmail;
    public string CustomerInformation;
    public list<string> Brand=new list<string>();
    
     public accountJson(Account acc)
     {
     this.Customer_No=acc.Customer_No__c;
     this.FirstName=acc.FirstName;
     this.LastName=acc.LastName;
     this.RecordTypeId=acc.RecordTypeId;
     this.PersonMobilePhone=acc.PersonMobilePhone;
     this.PersonHomePhone=acc.PersonHomePhone;
     this.PersonEmail=acc.PersonEmail;
     this.CustomerInformation=acc.CustomerInformation__c;
     this.Brand.addAll(acc.Brands__c.split(';'));
     
     }
    
    }
    
    global class child_Brands{
    public list<string> Brands=new list<string>();
    public string CustomerNo;
    
     public child_Brands(Account acc)
     {
      this.CustomerNo=acc.Customer_No__c;
      if((acc.Brands__c!=null)&&(acc.Brands__c!=''))
      {
      this.Brands.addAll(acc.Brands__c.split(';'));
      }
    }
}
}