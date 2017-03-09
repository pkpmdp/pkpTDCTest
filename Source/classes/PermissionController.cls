public class PermissionController {
    
    public PermissionController() {
        //   String strId = ApexPages.currentPage().getParameters().get('id');
        //  accountId = ID.valueOf(strId);
        
    }
    
    public Account Acc{get;set;}
    public Boolean updateFlag{get;set;}
    public Permission__c permission{get;set;} 
    public String AccStrId{get;set;}
    public String EcommagreementUpdatedDate{get;set;}
    public String DriftEmailUpdatedDate{get;set;}
    public String DriftSMSUpdatedDate{get;set;} 
    public String NoThankyouUpdatedDate{get;set;}
    public String PermissionUpdatedDate{get;set;}
    public String TelefonopkaldUpdatedDate{get;set;} 
    public Boolean RobinsonValue {get;set;}
    public Account accountEmail{get;set;}
    public Id accountId{get;set;} 
    public String baseUrl{get;set;} 
    public boolean errorOccured{get;set;}
    
    public String EcommagreementUpdatedBy{get;set;}
    public String DriftEmailUpdatedBy{get;set;}
    public String DriftSMSUpdatedBy{get;set;} 
    public String NoThankyouUpdatedBy{get;set;}
    public String PermissionUpdatedBy{get;set;}
    public String TelefonopkaldUpdatedBy{get;set;} 
    public Boolean errorinyouBio{get; set;}
    
    public PermissionController(ApexPages.StandardController controller){
        errorOccured = false;
        Acc = (Account) controller.getRecord();
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        accountId = Acc.Id;
        system.debug('base url is =------------------'+baseUrl);
        InitializeConstruction();
    }
    
    public void InitializeConstruction(){
        accountEmail = [SELECT  Customer_No__c,PersonEmail,PersonMobilePhone,Home_Phone__c FROM Account  a where a.id = :accountId limit 1];
        system.debug('value of account Id is ----------'+accountId+'  -------value of  account email is    $$$$$$$$$$$$$$$$ --------'+accountEmail.PersonEmail);
        try{
            system.debug('Acc: '+Acc);
            EcommagreementUpdatedDate='';
            DriftEmailUpdatedDate = '';
            DriftSMSUpdatedDate = '';
            NoThankyouUpdatedDate = '';
            PermissionUpdatedDate = '';
            TelefonopkaldUpdatedDate = '';
            EcommagreementUpdatedBy='';
            DriftEmailUpdatedBy = '';
            DriftSMSUpdatedBy = '';
            NoThankyouUpdatedBy = '';
            PermissionUpdatedBy = '';
            TelefonopkaldUpdatedBy = '';  
            getPermissionRecord(); 
            
            
            if(permission.Customer__r.Street_YK__r.Robinson__c=='Ja'){
                RobinsonValue = true;
            }else{
                RobinsonValue = false;
            }
        }catch(System.QueryException e){
            permission = null;
        } 
        if(permission!=null){
            updateFlag = true;
        }else{
            permission  = new Permission__c();
            permission.Customer__c = accountId;
            permission.customerID__c = accountEmail.Customer_No__c;
            updateFlag = false;
        }
        
    }
    
    
    public void getPermissionRecord(){
        permission = [SELECT Id, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c,
                      Marketing_Permission__c,Robinsonlisten__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,
                      E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_Dato__c,
                      Customer__r.Street_YK__r.Robinson__c,Customer__r.Email__c,Nej_til_Telefonopkald__c,
                      Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,Driftsinfo_pa_SMS_Opdateret_af__c,Nej_til_markedsforing_Opdateret_af__c,E_kommunikation_Opdateret_af__c,Marketing_permission_Opdateret_af__c,customerID__c FROM Permission__c 
                      WHERE Customer__c= :accountId limit 1];
        
        if(permission.E_kommunikation_Opdateret_af__c!=null){
            EcommagreementUpdatedBy = updatedByField(permission.E_kommunikation_Opdateret_af__c);
        }
        if(permission.Driftsinfo_pa_email_Opdateret_af__c!=null){
            DriftEmailUpdatedBy = updatedByField(permission.Driftsinfo_pa_email_Opdateret_af__c);
        }
        if(permission.Driftsinfo_pa_SMS_Opdateret_af__c!=null){
            DriftSMSUpdatedBy = updatedByField(permission.Driftsinfo_pa_SMS_Opdateret_af__c);
        }
        if(permission.Nej_til_markedsforing_Opdateret_af__c!=null){
            NoThankyouUpdatedBy = updatedByField(permission.Nej_til_markedsforing_Opdateret_af__c);
        }
        if(permission.Marketing_permission_Opdateret_af__c!=null){
            PermissionUpdatedBy = updatedByField(permission.Marketing_permission_Opdateret_af__c);
        }
        if(permission.Nej_til_Telefonopkald_Opdateret_af__c!=null){
            TelefonopkaldUpdatedBy = updatedByField(permission.Nej_til_Telefonopkald_Opdateret_af__c);
        }
    }
    
    public PageReference autoRefreshPage() 
    {    try{
        getPermissionRecord();
        updateFlag = true;
    }
     catch(System.QueryException e){           
     }
     
     
     return null;
    }   
    
    public pagereference save(){
        system.debug('value of updateFlag is ------------------------'+updateFlag+'accountEmail'+accountEmail+'####accountEmail.Home_Phone__c###'+accountEmail.Home_Phone__c+'###### accountEmail.PersonMobilePhone'+ accountEmail.PersonMobilePhone+'#@@@@@@@@@@accountEmail.PersonEmail == null'+accountEmail.PersonEmail == null+'!@@@@@permission.Marketing_Permission__c@@@@@@'+permission.Marketing_Permission__c);
        errorOccured = false;
        try{
            if(accountEmail.PersonEmail == null && permission.E_kommunikation__c){
              errorOccured = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.NoEmailForEcom);
                ApexPages.addMessage(errorMsg);
                permission.E_kommunikation__c = false;
                return null;
            }
            if(accountEmail.PersonEmail == null && permission.Driftsinfo_pa_email__c){
                errorOccured = true;
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email is necessary for Driftsinfo på email');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.emailNecessaryForDriftsinfo);
                ApexPages.addMessage(errorMsg);
                permission.Driftsinfo_pa_email__c = false;
                return null;
            }
            if(accountEmail.PersonMobilePhone == null && permission.Driftsinfo_pa_SMS__c){
                errorOccured = true;
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile number is required for Driftsinfo på SMS');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.mobileRequiredForDriftsinfo);
                ApexPages.addMessage(errorMsg);
                permission.Driftsinfo_pa_SMS__c = false;
                return null;
            }
            if(accountEmail.Home_Phone__c == null && accountEmail.PersonMobilePhone == null && accountEmail.PersonEmail == null && permission.Marketing_Permission__c){
                errorOccured = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.Marketing_permission_validation);
                ApexPages.addMessage(errorMsg);
                permission.Marketing_Permission__c = false;
                return null;
            }
            //System.debug('###AAAAApermission.E_kommunikation__cAAAAA'+permission.E_kommunikation__c+'OLDEEEEEEEEEE'+permission.Old_E_kommunikation_c__c);
            /*if(!permission.E_kommunikation__c && permission.Old_E_kommunikation_c__c){
                errorinyouBio = clsProductsYKController_V3.getYouBioAndTelefoniProducts(permission.customerID__c);
                System.debug('###AAAAAAAAAA'+errorinyouBio);
                if(errorinyouBio == true){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.YouBioTelefoniSubscription);
                    ApexPages.addMessage(errorMsg);
                    errorOccured = true;
                    return null;
                }
                
            }*/
            if(updateFlag){
                updatePermissionsDateFieldsOnUpdate();             
                update permission;
            }else{
                updatePermissionsDateFields();
                insert permission;
                updateFlag = true;
            }
        }catch(Exception e){
            errorOccured = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }
        if(errorOccured == false){
            ApexPages.Message infoMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Updated Successfully');
            ApexPages.addMessage(infoMessage);
        }
        return null;
    }
    
    public String updatedByField(String updatedByfieldvalue){
        String updatedValue;
        //    if(updatedByfieldvalue.equalsIgnoreCase('portal') || updatedByfieldvalue.equalsIgnoreCase('YouSee.dk'))
        if(updatedByfieldvalue.startsWith('6') && updatedByfieldvalue.isNumeric())
            updatedValue = 'YouSee.dk af kunden';
        else if(updatedByfieldvalue.startsWith('M') && updatedByfieldvalue.right(updatedByfieldvalue.length()-1).isNumeric())
            updatedValue = 'SPOC af '+updatedByfieldvalue;
        else if(updatedByfieldvalue.startsWith('T') && updatedByfieldvalue.right(updatedByfieldvalue.length()-1).isNumeric())
            updatedValue = 'Forhandler '+updatedByfieldvalue;
        else
            updatedValue = updatedByfieldvalue;
        
        return updatedValue;
    }
    
    public void updatePermissionsDateFields(){
        User uservalue = [select MID__c from User where Id=:UserInfo.getUserId() limit 1];   
        if(permission.Driftsinfo_pa_email__c){
            permission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_email_Opdateret_af__c = uservalue.mid__c;
        }
        if(permission.Driftsinfo_pa_SMS__c){
            permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_SMS_Opdateret_af__c = uservalue.mid__c;
        }
        if(permission.E_kommunikation__c){
            permission.E_kommunikation_Opdateret_Dato__c = Date.today();
            permission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
        }
        if(permission.Marketing_Permission__c){
            permission.Marketing_permission_Opdateret_Dato__c = Date.today();
            permission.Marketing_permission_Opdateret_af__c = uservalue.mid__c;
        }
        if(permission.Nej_til_markedsforing__c){
            permission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
            permission.Nej_til_markedsforing_Opdateret_af__c = uservalue.mid__c;
        }
        if(permission.Nej_til_Telefonopkald__c){
            permission.Nej_til_Telefonopkald_Opdateret_Dato__c = Date.today();
            permission.Nej_til_Telefonopkald_Opdateret_af__c =  uservalue.mid__c;
        }
    }
    
    public void updatePermissionsDateFieldsOnUpdate(){
        Date todaysDate = System.today();
        Date strJulyDate = Date.newinstance(2014, 7, 01);
        User uservalue = [select MID__c from User where Id=:UserInfo.getUserId() limit 1];
        Permission__c pp = [SELECT Id, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c,Marketing_Permission__c,Nej_til_Telefonopkald__c,E_kommunikation_Opdateret_Dato__c from Permission__c where id=:permission.id];   
        if(pp.Driftsinfo_pa_email__c!=permission.Driftsinfo_pa_email__c){
            permission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_email_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Driftsinfo_pa_SMS__c!=permission.Driftsinfo_pa_SMS__c){
            permission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            permission.Driftsinfo_pa_SMS_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.E_kommunikation__c!=permission.E_kommunikation__c){
            if(permission.E_kommunikation__c == true){
                if(permission.E_kommunikation_Opdateret_Dato__c > todaysDate || permission.E_kommunikation_Opdateret_Dato__c  < strJulyDate){
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Datoen må ikke være ældre end 1. july 2014');
                        ApexPages.addMessage(errorMsg);
                        errorOccured = true;
                        permission.E_kommunikation_Opdateret_Dato__c = pp.E_kommunikation_Opdateret_Dato__c;
                        permission.E_kommunikation__c = false;
                        //return null;  
                            
                }else {
                        permission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
                }
            }else {
            permission.E_kommunikation_Opdateret_Dato__c = Date.today();
            permission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
            }
        }
        if(pp.E_kommunikation__c && permission.E_kommunikation__c ){
            if(pp.E_kommunikation_Opdateret_Dato__c != permission.E_kommunikation_Opdateret_Dato__c ){
                if(permission.E_kommunikation_Opdateret_Dato__c > todaysDate || permission.E_kommunikation_Opdateret_Dato__c  < strJulyDate){
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Datoen må ikke være ældre end 1. july 2014');
                        ApexPages.addMessage(errorMsg);
                        errorOccured = true;
                        permission.E_kommunikation_Opdateret_Dato__c = pp.E_kommunikation_Opdateret_Dato__c;
                }else{
                        permission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
                      }  
            
            }
        }
        if(pp.Marketing_Permission__c!=permission.Marketing_Permission__c){
            permission.Marketing_permission_Opdateret_Dato__c = Date.today();
            permission.Marketing_permission_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Nej_til_markedsforing__c!=permission.Nej_til_markedsforing__c){
            permission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
            permission.Nej_til_markedsforing_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Nej_til_Telefonopkald__c!=permission.Nej_til_Telefonopkald__c){
            permission.Nej_til_Telefonopkald_Opdateret_Dato__c = Date.today();
            permission.Nej_til_Telefonopkald_Opdateret_af__c =  uservalue.mid__c;
        }
    }
    
    public pagereference invokePermission(){
        accountId = ID.valueOf(AccStrId);
        system.debug('accountId in constr: '+accountId);
        InitializeConstruction();       
        return null;
    }
    
    
}