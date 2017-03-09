public class CarrieAriaSearchController{
    public string arnum{get;set;}
    public CarrieAriaSearchController(ApexPages.StandardController controller) {
        
    }



    private Aria_API_Configuration__c config { get; private set; } //CARRIE-986
    public String ariaNumber{get;set;}
    
    public List<Aria_Account__c> ariaSpoc{get;set;}
    boolean flagUpsert {get;set;} 
    
    public String juridisk{get;set;}
    public Map<String,Id> pageLayoutRecordType{get;set;}  
    
    public Id spocId{get;set;}
    
    
    public CarrieAriaSearchController(){
        flagUpsert=false;
        ariaNumber = ApexPages.currentPage().getParameters().get('AriaNumber');
        ariaSpoc = new List<Aria_Account__c>(); // added as on 3-5-13 for null error
        system.debug('ariaNumber: '+ariaNumber);
        List<String> recordTypeName = new List<String>();
        recordTypeName.add('Carrie_Telephony');
        recordTypeName.add('Carrie_YouBio');
        pageLayoutRecordType = new Map<String,Id>();
        List<RecordType> recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName in : recordTypeName ];
        for(RecordType rt :recordtypes){
            pageLayoutRecordType.put(rt.DeveloperName,rt.Id);
        }
    }
    public void redirectToPage()
    {
        arnum = ariaNumber;     
    }
    public PageReference SearchAria(){
        try{
            if(ariaNumber!=null && ariaNumber.length()>0 ){
                if(ariaNumber.isNumeric()){
                    ariaSpoc = [SELECT Name, Id, Account__c, Account__r.Name,Aria_Account_No__c,Aria_Plan_Name__c, Betaler__c, Customer_No__c FROM Aria_Account__c where name =:ariaNumber limit 1];
                    system.debug('ariaSpoc: '+ariaSpoc);
                    if(ariaSpoc!=null && ariaSpoc.size()>0){
                        return null;
                    }else{
                        return makeAriaSearchCall();
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Indtast valid Betaler ID'));
                    return null;
                }
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return null;
    }
    
    public PageReference makeAriaSearchCall(){
        config = CarrieCommonUtil.validateAPIConfiguration(config); //CARRIE-986
        HttpResponse response = AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+ariaNumber});
        system.debug('response: '+response);
        system.debug('ariaNumber: '+ariaNumber);
        system.debug('Get Detials: '+response.getBody());        
        return  getAriaAccounts(response.getBody());
    }
    
    //Start
    public PageReference getAriaAccounts(String response){
        List<Aria_Account__c> Accountlist = new List<Aria_Account__c>();
        try{
            Aria_Account__c AriaAcct;
            CarrieBillingWrapper billingWrapper = new CarrieBillingWrapper();
            billingWrapper = CarrieBillingWrapper.parse(response);
            system.debug('billingWrapper: '+billingWrapper);
            if(billingWrapper==null || billingWrapper.account_details.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Betaler ID ('+ariaNumber+') findes ikke i Aria'));
                return null;
            }            
            for(CarrieBillingWrapper.Account_details a : billingWrapper.account_details){
                AriaAcct = new Aria_Account__c();
                AriaAcct.Aria_Account_No__c = a.acct_no;
                AriaAcct.Name = ''+a.acct_no;
                AriaAcct.Aria_Plan_Name__c = a.plan_name;
                if(a.plan_name.equalsIgnoreCase('YouBio')){
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_YouBio');              
                }else{
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_Telephony');
                }
                AriaAcct.Regningsstatus__c = a.status_name;
                AriaAcct.Aria_Pay_Method__c = CarrieCommonUtil.PAY_METHOD_MAP.get(a.pay_method);
                AriaAcct.CurrentSaldo__c = a.acct_balance; 
                System.debug('a.Supp_field: '+a.Supp_field);
                if(a.Supp_field.size()>0){
                    for(CarrieBillingWrapper.Supp_field supp : a.Supp_field){
                        if(supp.supp_field_name =='Juridisk'){
                            if(supp.supp_field_value!=null && supp.supp_field_value.length() > 1){
                                juridisk = supp.supp_field_value;
                                AriaAcct.Customer_No__c = juridisk;
                                spocId= lookForKundeNumber(juridisk);
                                AriaAcct.Account__c = spocId;
                            }else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Der er ikke tilknyttet nogen Aria konto til denne kunde'));
                                return null;
                            }
                        }
                        else if(supp.supp_field_name =='Betaler'){
                            AriaAcct.Betaler__c = supp.supp_field_value;
                        }
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Der er ikke tilknyttet nogen Aria konto til denne kunde'));
                    return null;
                }                  
                Accountlist.add(AriaAcct); 
            }
            if(flagUpsert){            
                upsert Accountlist Aria_Account_No__c;
            }else{
                Accountlist=null;
                return null;
            }
            if(Accountlist!=null && Accountlist.size()>0){
                ariaSpoc = Accountlist;
                return null;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Betaler ID ('+ariaNumber+') findes ikke i Aria'));
                return null;
            }       
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return null;        
    }
    //End
        
    public Id lookForKundeNumber(String kundeNo){
        if(kundeNo!=null && kundeNo.length()>0){
            List<Account> aaa = [select Id from Account where Customer_No__c like : kundeNo];
            if(aaa.size()>0){
                flagUpsert=true;
                return aaa[0].Id;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Kunde ('+kundeNo+') findes ikke i Salesforce'));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Der er ikke tilknyttet nogen Aria konto til denne kunde'));
            return null;
        }
    }
}