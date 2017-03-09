public class PersonCustomerEmailUpdateController{

    Public Account acc{get;set;}
    public String errorMessage{get; set;}
    public boolean errorFlag{get; set;}
    public boolean emailFlag{get; set;}
    public boolean emailvalidateFlag{get; set;}
    public String email{get; set;}
    public Account account;
    public Permission__c pc;
    public PersonCustomerEmailUpdateController(ApexPages.StandardController controller){
        acc = (Account)controller.getRecord();
        System.debug('***acc**'+acc);
        email = acc.PersonEmail;
        //errorMessage = 'test';
    }
    
    Public PageReference updateEmail(){
        System.debug('****acc***'+acc+'***'+UserInfo.getProfileId());
        if(String.isBlank(email) && UserInfo.getProfileId() != '00e200000010no5AAA'){
            String strIp = NetsFeeCallOut.GetUserIPAddress();
        account=  new Account();
            account = [SELECT Id, Name, Customer_No__c,Permission__c FROM Account WHERE Id =: acc.Id];
        pc=new Permission__c();
        pc = [SELECT Id,Marketing_Permission__c FROM Permission__c WHERE Customer__c = :acc.Id LIMIT 1];
        System.debug('****strIp***'+strIp+'****accountNumber***'+account.Customer_No__c);
        HttpResponse res = new HttpResponse();
        res = NetsFeeCallOut.CallForPaymentProfile(account.Customer_No__c, strIp);
        updatePersonEmail(res);
        }else{
            if(String.isBlank(email)){
                errorMessage = '';
                        errorFlag = false;
                        acc.PersonEmail = email;
                        update acc;
            }else{
            try{
                    errorMessage = '';
                    errorFlag = false;
                    acc.PersonEmail = email;
                    update acc;
                }catch(Exception ex){
                    errorFlag = true;
                    String str = ex.getMessage();
                    if(str.contains('INVALID_EMAIL_ADDRESS')){
                        errorMessage = str.substring(str.indexOf(',')+1,str.length()-25);
                    }else{
                        errorMessage = str.substring(str.indexOf(',')+1,str.length()-4);
                    }
                	
                	//errorMessage = 'Invalid Email address.';  
                }
            }
        }
        return null;
    }
    public PageReference editEmail(){
        System.debug('*****editEmail called');
        emailFlag = true;
        return null;
    }
    public void updatePersonEmail(HttpResponse res){
        if(res!=null ){
        System.debug('***response'+res.getbody());
            if(res.getStatusCode() == 200){
                System.debug('Test');
                try{
                    
                
            Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
            
            if(responseMap.get('status')=='0'){
                errorFlag = false;
                String strInvoiceMedia = responseMap.get('invoiceMedia');// assigning delivery method to a variable to be displayed on page             
                System.debug('invoiceMedia'+strInvoiceMedia);
                if(strInvoiceMedia == 'PDFMAIL'){
                    errorFlag = true;
                    errorMessage = System.Label.EmailValidationMessage;
                }else{
                    if(pc.Marketing_Permission__c == true){
                        errorFlag = true;
                        errorMessage = 'Hvis Marketing tilladelse er sandt, kan e-mail ikke være tom.';
                    }else{
                        errorMessage = '';
                        errorFlag = false;
                        acc.PersonEmail = email;
                        update acc;
                    }
                }
            }
            else{
                System.debug('Test2');
                errorFlag = true;
                errorMessage = responseMap.get('errorMessage');
            }
        }catch(Exception ex){
                    errorFlag = true;
            String str = ex.getMessage();
                	errorMessage = str.substring(str.indexOf(',')+1,str.length()-4);
                }
        }
        }
        else{
            errorFlag = true;
            errorMessage = 'fejl fra betalingsservice';
        }
    }

}