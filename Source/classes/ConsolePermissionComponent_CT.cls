public class ConsolePermissionComponent_CT {
    
    public ConsolePermissionComponent_CT() {
        //   String strId = ApexPages.currentPage().getParameters().get('id');
        //  accountId = ID.valueOf(strId);
        //errorOccured = false;
        ErrEcom = false;
        ErrEmail = false;
        ErrSms = false;
        ErrMarket = false;
        ErrException = false;
        ErrSave = false;
    }
    
    public Account Acc{get;set;}
    public Boolean updateFlag{get;set;}
    public Permission__c objpermission{get;set;} 
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
    
    public Boolean ErrEcom{get;set;}
    public Boolean ErrEmail{get;set;}
    public Boolean ErrSms{get;set;}
    public Boolean ErrMarket{get;set;}
    public Boolean ErrException{get;set;}
    public Boolean ErrSave{get;set;}
    
    /*public PermissionController(ApexPages.StandardController controller){
        errorOccured = false;
        Acc = (Account) controller.getRecord();
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        accountId = Acc.Id;
        system.debug('base url is =------------------'+baseUrl);
        InitializeConstruction();
    }*/
    public Permission__c getPermission(){
        system.debug('=======AccStrId======'+AccStrId);
        
        accountEmail = [SELECT  Customer_No__c,PersonEmail,PersonMobilePhone,Home_Phone__c FROM Account  a where a.id = :AccStrId limit 1];
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
            getPermissionRecord(AccStrId); 
            
            
            if(objpermission.Customer__r.Street_YK__r.Robinson__c=='Ja'){
                RobinsonValue = true;
            }else{
                RobinsonValue = false;
            }
        }catch(System.QueryException e){
            objpermission = null;
        } 
        system.debug('======objpermission=========='+objpermission);
        if(objpermission!=null){
            updateFlag = true;
        }else{
            objpermission  = new Permission__c();
            objpermission.Customer__c = accountId;
            objpermission.customerID__c = accountEmail.Customer_No__c;
            updateFlag = false;
        }
        
        return objpermission;
    
    }
    
    public void setPermission(Permission__c perm){
         this.objpermission = perm;
        
    }
   /* public void InitializeConstruction(){
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
            
            
            if(objpermission.Customer__r.Street_YK__r.Robinson__c=='Ja'){
                RobinsonValue = true;
            }else{
                RobinsonValue = false;
            }
        }catch(System.QueryException e){
            objpermission = null;
        } 
        system.debug('======objpermission=========='+objpermission);
        if(objpermission!=null){
            updateFlag = true;
        }else{
            objpermission  = new Permission__c();
            objpermission.Customer__c = accountId;
            objpermission.customerID__c = accountEmail.Customer_No__c;
            updateFlag = false;
        }
        
    }*/
    
    public string strToolTipEcomm {get;set;}
    public string strToolTipDriftsSms {get;set;}
    public string strToolTipDriftsEmail {get;set;}
    public string strToolTipmarkedsforing {get;set;}
    public string strToolTippermission {get;set;}
    public string strToolTipTelefonopkald {get;set;}

    
    public void getPermissionRecord(Id AccStrId){
        
            objpermission = [SELECT Id, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c,
                          Marketing_Permission__c,Robinsonlisten__c,Driftsinfo_pa_email_Opdateret_Dato__c,Driftsinfo_pa_SMS_Opdateret_Dato__c,
                          E_kommunikation_Opdateret_Dato__c,Nej_til_markedsforing_Opdateret_Dato__c,Marketing_permission_Opdateret_Dato__c,
                          Customer__r.Street_YK__r.Robinson__c,Customer__r.Email__c,Nej_til_Telefonopkald__c,
                          Nej_til_Telefonopkald_Opdateret_af__c,Nej_til_Telefonopkald_Opdateret_Dato__c,Driftsinfo_pa_email_Opdateret_af__c,Driftsinfo_pa_SMS_Opdateret_af__c,Nej_til_markedsforing_Opdateret_af__c,E_kommunikation_Opdateret_af__c,Marketing_permission_Opdateret_af__c,customerID__c,Customer__r.Exempted_from_E_Kom_fee__c,Customer__c FROM Permission__c 
                          WHERE Customer__c= :AccStrId limit 1];
            system.debug('-------objpermission.E_kommunikation__c-1-------'+objpermission.E_kommunikation__c); 
            //String strdtEcom = '';
            String strdtEcom,strdtEmail,strdtSms,strdtMarkd,strdtperm,strdttelefon;
                  
            if(objpermission.E_kommunikation_Opdateret_af__c!=null){ 
                
                EcommagreementUpdatedBy = updatedByField(objpermission.E_kommunikation_Opdateret_af__c);
                if(objpermission.E_kommunikation_Opdateret_Dato__c!=null)
                strdtEcom = convertDateFormat(objpermission.E_kommunikation_Opdateret_Dato__c);             
                strToolTipEcomm = strdtEcom + ' via '+EcommagreementUpdatedBy;
            }
            if(objpermission.Driftsinfo_pa_email_Opdateret_af__c!=null){
                DriftEmailUpdatedBy = updatedByField(objpermission.Driftsinfo_pa_email_Opdateret_af__c);
                
                if(objpermission.Driftsinfo_pa_email_Opdateret_Dato__c != null)
                strdtEmail = convertDateFormat(objpermission.Driftsinfo_pa_email_Opdateret_Dato__c);
                strToolTipDriftsEmail = strdtEmail + ' via '+ DriftEmailUpdatedBy;
            }
            if(objpermission.Driftsinfo_pa_SMS_Opdateret_af__c!=null){
                DriftSMSUpdatedBy = updatedByField(objpermission.Driftsinfo_pa_SMS_Opdateret_af__c);
                
                if(objpermission.Driftsinfo_pa_SMS_Opdateret_Dato__c != null)
                strdtSms = convertDateFormat(objpermission.Driftsinfo_pa_SMS_Opdateret_Dato__c);
                strToolTipDriftsSms = strdtSms + ' via ' + DriftSMSUpdatedBy;
            }
            if(objpermission.Nej_til_markedsforing_Opdateret_af__c!=null){
                NoThankyouUpdatedBy = updatedByField(objpermission.Nej_til_markedsforing_Opdateret_af__c);
                
                if(objpermission.Nej_til_markedsforing_Opdateret_Dato__c!=null)
                strdtMarkd = convertDateFormat(objpermission.Nej_til_markedsforing_Opdateret_Dato__c);              
                strToolTipmarkedsforing = strdtMarkd + ' via '+NoThankyouUpdatedBy;
            }
            if(objpermission.Marketing_permission_Opdateret_af__c!=null){
                PermissionUpdatedBy = updatedByField(objpermission.Marketing_permission_Opdateret_af__c);
                strdtperm = convertDateFormat(objpermission.Marketing_permission_Opdateret_Dato__c);  
                strToolTippermission = strdtperm +  (PermissionUpdatedBy == 'default' ? ' via automatisk' :  ' via ' + PermissionUpdatedBy);
                
            }
            if(objpermission.Nej_til_Telefonopkald_Opdateret_af__c!=null){
                TelefonopkaldUpdatedBy = updatedByField(objpermission.Nej_til_Telefonopkald_Opdateret_af__c);
                
                if(objpermission.Nej_til_Telefonopkald_Opdateret_Dato__c!=null)
                strdttelefon = convertDateFormat(objpermission.Nej_til_Telefonopkald_Opdateret_Dato__c);                
                strToolTipTelefonopkald = strdttelefon + ' via '+TelefonopkaldUpdatedBy;
            }
           
        
    }
    
    public String convertDateFormat(Date inputDate){
      String strDtFormat='dd-MM-yyyy';
      String formattedDate;
      DateTime dt = inputDate;
      if(dt != null){
         formattedDate = dt.format(strDtFormat);
      }
      return formattedDate;
   }
   /* public PageReference autoRefreshPage() 
    {    try{
        getPermissionRecord();
        updateFlag = true;
    }
     catch(System.QueryException e){           
     }
     
     
     return null;
    }  */ 
    public string strException {get;set;}
    public pagereference save(){
        errorOccured = false;
        
        system.debug('objpermission----------------'+objpermission);
        try{
            if(accountEmail.PersonEmail == null && objpermission.E_kommunikation__c){
                errorOccured = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.NoEmailForEcom);
                ApexPages.addMessage(errorMsg);
                objpermission.E_kommunikation__c = false;
                ErrEcom = true;
                return null;
            }
            if(accountEmail.PersonEmail == null && objpermission.Driftsinfo_pa_email__c){
                errorOccured = true;
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email is necessary for Driftsinfo på email');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.emailNecessaryForDriftsinfo);
                ApexPages.addMessage(errorMsg);
                objpermission.Driftsinfo_pa_email__c = false;
                ErrEmail = true;
                return null;
            }
            if(accountEmail.PersonMobilePhone == null && objpermission.Driftsinfo_pa_SMS__c){
                errorOccured = true;
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile number is required for Driftsinfo på SMS');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.mobileRequiredForDriftsinfo);
                ApexPages.addMessage(errorMsg);
                objpermission.Driftsinfo_pa_SMS__c = false;
                ErrSms = true;
                return null;
            }
            system.debug('objpermission.Marketing_Permission__c----------------'+objpermission.Marketing_Permission__c);
            if(accountEmail.Home_Phone__c == null && accountEmail.PersonMobilePhone == null && accountEmail.PersonEmail == null && objpermission.Marketing_Permission__c){
                errorOccured = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.Marketing_permission_validation);
                ApexPages.addMessage(errorMsg);
                objpermission.Marketing_Permission__c = false;
                ErrMarket = true;
                return null;
            }
            System.debug('###AAAAApermission.E_kommunikation__cAAAAA'+objpermission.E_kommunikation__c);
            /*if(!objpermission.E_kommunikation__c && objpermission.Old_E_kommunikation_c__c){
                errorinyouBio = clsProductsYKController_V3.getYouBioAndTelefoniProducts(objpermission.customerID__c);
                System.debug('###AAAAAAAAAA'+errorinyouBio);
                if(errorinyouBio == true){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.YouBioTelefoniSubscription);
                    ApexPages.addMessage(errorMsg);
                    errorOccured = true;
                    return null;
                }
                
            }*/
            Account obj = new Account(id=AccStrId);
            obj.Exempted_from_E_Kom_fee__c = objpermission.Customer__r.Exempted_from_E_Kom_fee__c;
            
            if(updateFlag){
                updatePermissionsDateFieldsOnUpdate();             
                update objpermission;
                update obj;
            }else{
                updatePermissionsDateFields();
                insert objpermission;
                update obj;
                updateFlag = true;
            }
        }catch(Exception e){
            errorOccured = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            strException = e.getMessage();
            ErrException = true;
            return null;
        }
        if(errorOccured == false){
            ApexPages.Message infoMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Updated Successfully');
            ApexPages.addMessage(infoMessage);
            ErrSave  = true;
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
        if(objpermission.Driftsinfo_pa_email__c){
            objpermission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            objpermission.Driftsinfo_pa_email_Opdateret_af__c = uservalue.mid__c;
        }
        if(objpermission.Driftsinfo_pa_SMS__c){
            objpermission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            objpermission.Driftsinfo_pa_SMS_Opdateret_af__c = uservalue.mid__c;
        }
        if(objpermission.E_kommunikation__c){
            objpermission.E_kommunikation_Opdateret_Dato__c = Date.today();
            objpermission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
        }
        if(objpermission.Marketing_Permission__c){
            objpermission.Marketing_permission_Opdateret_Dato__c = Date.today();
            objpermission.Marketing_permission_Opdateret_af__c = uservalue.mid__c;
        }
        if(objpermission.Nej_til_markedsforing__c){
            objpermission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
            objpermission.Nej_til_markedsforing_Opdateret_af__c = uservalue.mid__c;
        }
        if(objpermission.Nej_til_Telefonopkald__c){
            objpermission.Nej_til_Telefonopkald_Opdateret_Dato__c = Date.today();
            objpermission.Nej_til_Telefonopkald_Opdateret_af__c =  uservalue.mid__c;
        }
    }
    
    public void updatePermissionsDateFieldsOnUpdate(){
        User uservalue = [select MID__c from User where Id=:UserInfo.getUserId() limit 1];
        Permission__c pp = [SELECT Id, Driftsinfo_pa_SMS__c, Driftsinfo_pa_email__c, E_kommunikation__c, Nej_til_markedsforing__c,Marketing_Permission__c,Nej_til_Telefonopkald__c from Permission__c where id=:objpermission.id];   
        if(pp.Driftsinfo_pa_email__c!=objpermission.Driftsinfo_pa_email__c){
            objpermission.Driftsinfo_pa_email_Opdateret_Dato__c = Date.today();
            objpermission.Driftsinfo_pa_email_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Driftsinfo_pa_SMS__c!=objpermission.Driftsinfo_pa_SMS__c){
            objpermission.Driftsinfo_pa_SMS_Opdateret_Dato__c = Date.today();
            objpermission.Driftsinfo_pa_SMS_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.E_kommunikation__c!=objpermission.E_kommunikation__c){
            objpermission.E_kommunikation_Opdateret_Dato__c = Date.today();
            objpermission.E_kommunikation_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Marketing_Permission__c!=objpermission.Marketing_Permission__c){
            objpermission.Marketing_permission_Opdateret_Dato__c = Date.today();
            objpermission.Marketing_permission_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Nej_til_markedsforing__c!=objpermission.Nej_til_markedsforing__c){
            objpermission.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
            objpermission.Nej_til_markedsforing_Opdateret_af__c = uservalue.mid__c;
        }
        if(pp.Nej_til_Telefonopkald__c!=objpermission.Nej_til_Telefonopkald__c){
            objpermission.Nej_til_Telefonopkald_Opdateret_Dato__c = Date.today();
            objpermission.Nej_til_Telefonopkald_Opdateret_af__c =  uservalue.mid__c;
        }
    }
    
   /* public pagereference invokePermission(){
        accountId = ID.valueOf(AccStrId);
        system.debug('accountId in constr: '+accountId);
        InitializeConstruction();       
        return null;
    }*/
}