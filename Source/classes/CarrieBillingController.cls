/***********************************************************************************
************************************************************************************

* @class: CarrieBillingController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 8/02/2012
* @description: Class is used to display billing related information for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarrieBillingController{
    //private static String UserName = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_UserName').Value__c; //CARRIE-986
    //private static String Password = CarrieCustomSettings__c.getInstance('AriaLoginCredentials_Password').Value__c; //CARRIE-986
    private Aria_API_Configuration__c config { get; private set; }
    public Decimal casperNo ;
    public Id customerId;
    public String selectAccount{get; set;}
    public List<Aria_Account__c> listAcct {get;set;}
    public Account oppty { get; set; }
    public ApexPages.StandardController controller { get; set; }
    public List<String> listStr = new List<String>();
    public Map<String,Id> pageLayoutRecordType{get;set;}
    //start of carrie-1116
    public List<BetalerAccounts> listAcctBetaler {get;set;}
    public String PageKundeId{get;set;}
    public String PageAriaId{get;set;}
    public Integer Pagesize{get;set;}
    public List<BetalerAccounts> Betalerlstacc{get;set;} 
    public Integer count1{get;set;}
    public Boolean hasPrevious {get;set;}
    public Boolean hasNext {get;set;}
    public Integer pageno {get;set;}
    public Integer totalPage{get;set;} 
    public Boolean stopRedirectPage{get;set;}
    // end of carrie-1116

    public CarrieBillingController(ApexPages.StandardController controller){
    	stopRedirectPage = false;
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        this.controller = controller;
   /*     List<String> recordTypeName = new List<String>();
        recordTypeName.add('Carrie_Telephony');
        recordTypeName.add('Carrie_YouBio');
        pageLayoutRecordType = new Map<String,Id>();
        List<RecordType> recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName in : recordTypeName ];
        for(RecordType rt :recordtypes){
            pageLayoutRecordType.put(rt.DeveloperName,rt.Id);
            
        }*/
        initializeRecordTypes();
        
       oppty = (Account) controller.getRecord();
    }
    
    //Added for Batch code
    public CarrieBillingController(){
    	initializeRecordTypes();
    }
    
    public void initializeRecordTypes(){
    
     List<String> recordTypeName = new List<String>();
        recordTypeName.add('Carrie_Telephony');
        recordTypeName.add('Carrie_YouBio');
        pageLayoutRecordType = new Map<String,Id>();
        List<RecordType> recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName in : recordTypeName ];
        for(RecordType rt :recordtypes){
            pageLayoutRecordType.put(rt.DeveloperName,rt.Id);
            
        }
    
    }
   
    public CarrieBillingController(Decimal AccountNo,Id customer_Id) {
        //String CustNOStr = ''+AccountNo;
        this.casperNo= AccountNo;
        this.customerId=customer_Id;
        //oppty = [select id,Customer_No__c from Account where Customer_No__c =:CustNOStr];
        loadRecord(AccountNo);
        initializeRecordTypes();
        config = CarrieCommonUtil.validateAPIConfiguration(config); //CARRIE-986
    }
    
      /**    * @description: This method is used to get Account related information. New 14-feb-13   */
    private void loadRecord(Decimal AccountNo) {
        String CustNOStr = ''+AccountNo;
        list <Account> lstAccount = [select id,Customer_No__c from Account where Customer_No__c =:CustNOStr];
        if(lstAccount.size()>0){
        oppty = lstAccount.get(0);
        }
     }
     
    /**
        * @description: This method makes API call to Aria System for getting billing related information.
        * @param: Aria Account number for the customer.
        * @return: Response From Aria. 
        */
    /*public String getAriaAccountResponse(String AriaAccountNo){
        String queryString = '';
        queryString = 'acct_no=' +AriaAccountNo;
        HttpResponse billingResponse; 
    	billingResponse = AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => billingQueryString});
    	system.debug('billing response in batch ' +billingResponse.getBody());
    	response = billingResponse.getBody();
    }*/
    
    public String getAriaResponse(Decimal CasperNo){
        //HttpResponse response =AriaWebServices.makeCallForJson('get_account_details',UserName,Password, new Map<String, String> { 'query_string' => 'supp_field_value='+CasperNo+' AND supp_field_name=Juridisk'}); //CARRIE-986
        HttpResponse response = new HttpResponse();
        if(Test.isRunningTest()){
            String str = '{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":1,"account_details":[{"acct_no":4338656,"senior_acct_no":null,"user_id":"47wq3r6c","password":"4eg5nxdt","status_cd":1,"plan_no":10351163,"first_name":"MICHAEL","mi":null,"last_name":"HANSEN","address_1":"Mosede Bygade 4B   ","address_2":null,"city":"Greve","locality":null,"postal_code":"2670","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2013-02-19 05:33:31","last_updated":"2013-05-15 19:13:32","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"MICHAEL","billing_middle_initial":null,"billing_last_name":"HANSEN","billing_address1":"Mosede Bygade 4B   ","billing_address2":null,"billing_city":"Greve","billing_state":null,"billing_locality":null,"billing_zip":"2670","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouBio","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":396,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"377334477"},{"supp_field_name":"Betaler","supp_field_value":"377334477"}],"bill_day":1,"supp_plan":[{"supp_plan_no":10351165,"supp_plan_name":"YouBio Abonnement"}]},{"acct_no":3667927,"senior_acct_no":null,"user_id":"rjrvcq3m","password":"h33m66f7","status_cd":1,"plan_no":10263079,"first_name":null,"mi":null,"last_name":"TIMI TECH AS","address_1":"Skovbovu00e6nget 5   ","address_2":null,"city":"Vu00e6rlu00f8se","locality":null,"postal_code":"3500","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2012-07-09 02:09:02","last_updated":"2013-04-22 02:57:54","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"601880651"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":9,"supp_plan":[]},{"acct_no":3537993,"senior_acct_no":null,"user_id":"4b8hervm","password":"7pd35rqj","status_cd":1,"plan_no":10263079,"first_name":"STEVEN","mi":null,"last_name":"GEMYNTHE","address_1":"Katrinedalsvej 14A ST  4","address_2":null,"city":"Vanlu00f8se","locality":null,"postal_code":"2720","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 18:19:09","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614000002"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537997,"senior_acct_no":null,"user_id":"8x5h84pj","password":"5b4m88xc","status_cd":1,"plan_no":10263079,"first_name":"THERESE","mi":null,"last_name":"STENBu00c6K","address_1":"Holger Danskes Vej 20 2  2","address_2":null,"city":"Frederiksberg","locality":null,"postal_code":"2000","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 18:24:19","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614140006"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3667783,"senior_acct_no":null,"user_id":"rxhebper","password":"acqs3saj","status_cd":1,"plan_no":10263079,"first_name":"DEMIR","mi":null,"last_name":"MEHMET","address_1":"Parkvej 34 1  TH","address_2":null,"city":"Ku00f8ge","locality":null,"postal_code":"4600","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:23:35","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"605231761"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3667805,"senior_acct_no":null,"user_id":"4bvfemdc","password":"m5y7389c","status_cd":1,"plan_no":10263079,"first_name":"KRISTIAN","mi":null,"last_name":"Ru00d8NNE","address_1":"Uglevang 90 2  MF","address_2":null,"city":"Alleru00f8d","locality":null,"postal_code":"3450","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:42:06","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"612351269"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3667807,"senior_acct_no":null,"user_id":"58h7g399","password":"39m4c4xy","status_cd":1,"plan_no":10263079,"first_name":"BIRGIT SAMUELSEN","mi":null,"last_name":"MAGNUS POULSEN","address_1":"Hovgu00e5rdsparken 89   ","address_2":null,"city":"Greve","locality":null,"postal_code":"2670","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:43:53","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"601820356"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3538121,"senior_acct_no":null,"user_id":"ykryrg38","password":"jqje7fds","status_cd":1,"plan_no":10263079,"first_name":"THERESE","mi":null,"last_name":"STENBu00c6K","address_1":"Holger Danskes Vej 20 2  2","address_2":null,"city":"Frederiksberg","locality":null,"postal_code":"2000","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 20:15:05","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614140006"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3538125,"senior_acct_no":null,"user_id":"mnwa96bu","password":"4y5uhc35","status_cd":1,"plan_no":10263079,"first_name":"MIKAEL","mi":null,"last_name":"MODEST","address_1":"Strandhaven 133   ","address_2":null,"city":"Vallensbu00e6k Strand","locality":null,"postal_code":"2665","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 20:16:53","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"610730009"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537967,"senior_acct_no":null,"user_id":"8j9x5fcq","password":"vhpet8ys","status_cd":1,"plan_no":10263079,"first_name":"LI","mi":null,"last_name":"JINSHENG","address_1":"Ru00f8nnegade 12 1  TH","address_2":null,"city":"Ku00f8benhavn u00d8","locality":null,"postal_code":"2100","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 17:39:46","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"615440009"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537969,"senior_acct_no":null,"user_id":"jcuheq4s","password":"vmxeprkk","status_cd":1,"plan_no":10263079,"first_name":"DALIBOR","mi":null,"last_name":"PERIC","address_1":"Andreas Bju00f8rns Gade 11 ST  TH","address_2":null,"city":"Ku00f8benhavn K","locality":null,"postal_code":"1428","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":"dperic24@hotmail.com","client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 17:40:36","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":"NATASHASP@PRIVAT.DK","billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"611680087"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3543399,"senior_acct_no":null,"user_id":"vvdkg93e","password":"hr5ycuy9","status_cd":1,"plan_no":10263079,"first_name":"ERLING","mi":null,"last_name":"RUBu00c6K Su00d8RENSEN","address_1":"Fuglevu00e6nget 59   ","address_2":null,"city":"Hornslet","locality":null,"postal_code":"8543","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-06-02 18:37:24","last_updated":"2013-05-16 19:11:02","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"610470097"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":2,"supp_plan":[]},{"acct_no":3640615,"senior_acct_no":null,"user_id":"ttrcy5kg","password":"np5aja3d","status_cd":1,"plan_no":10263079,"first_name":"ERIK","mi":null,"last_name":"HINRICHSEN","address_1":"Rosenvu00e6nget 2   ","address_2":null,"city":"Ru00f8dekro","locality":null,"postal_code":"6230","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-06-10 23:45:47","last_updated":"2013-05-24 19:11:50","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"602230639"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":10,"supp_plan":[]}]}';//carrie-1116 
            response.setBody(str);
        }
        else{
            response =AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'supp_field_value='+CasperNo+' AND supp_field_name=Juridisk'});       
        }
        system.debug('Response from Billing Controller'+response.getBody());
        return response.getBody();
    }
  
  //Start of Carrie-1116  
    public String getAriaResponseForBetalar(Decimal CasperNo){
        HttpResponse response  = new HttpResponse();
        if(test.isRunningTest())
        {
            String str=  '{"error_code":0,"error_msg":"OK","starting_record":0,"total_records":1,"account_details":[{"acct_no":4338656,"senior_acct_no":null,"user_id":"47wq3r6c","password":"4eg5nxdt","status_cd":1,"plan_no":10351163,"first_name":"MICHAEL","mi":null,"last_name":"HANSEN","address_1":"Mosede Bygade 4B   ","address_2":null,"city":"Greve","locality":null,"postal_code":"2670","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2013-02-19 05:33:31","last_updated":"2013-05-15 19:13:32","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"MICHAEL","billing_middle_initial":null,"billing_last_name":"HANSEN","billing_address1":"Mosede Bygade 4B   ","billing_address2":null,"billing_city":"Greve","billing_state":null,"billing_locality":null,"billing_zip":"2670","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouBio","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":396,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"377334477"},{"supp_field_name":"Betaler","supp_field_value":"377334477"}],"bill_day":1,"supp_plan":[{"supp_plan_no":10351165,"supp_plan_name":"YouBio Abonnement"}]},{"acct_no":3667927,"senior_acct_no":null,"user_id":"rjrvcq3m","password":"h33m66f7","status_cd":1,"plan_no":10263079,"first_name":null,"mi":null,"last_name":"TIMI TECH AS","address_1":"Skovbovu00e6nget 5   ","address_2":null,"city":"Vu00e6rlu00f8se","locality":null,"postal_code":"3500","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":4,"created":"2012-07-09 02:09:02","last_updated":"2013-04-22 02:57:54","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":4,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"601880651"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":9,"supp_plan":[]},{"acct_no":3537993,"senior_acct_no":null,"user_id":"4b8hervm","password":"7pd35rqj","status_cd":1,"plan_no":10263079,"first_name":"STEVEN","mi":null,"last_name":"GEMYNTHE","address_1":"Katrinedalsvej 14A ST  4","address_2":null,"city":"Vanlu00f8se","locality":null,"postal_code":"2720","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 18:19:09","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614000002"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537997,"senior_acct_no":null,"user_id":"8x5h84pj","password":"5b4m88xc","status_cd":1,"plan_no":10263079,"first_name":"THERESE","mi":null,"last_name":"STENBu00c6K","address_1":"Holger Danskes Vej 20 2  2","address_2":null,"city":"Frederiksberg","locality":null,"postal_code":"2000","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 18:24:19","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614140006"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3667783,"senior_acct_no":null,"user_id":"rxhebper","password":"acqs3saj","status_cd":1,"plan_no":10263079,"first_name":"DEMIR","mi":null,"last_name":"MEHMET","address_1":"Parkvej 34 1  TH","address_2":null,"city":"Ku00f8ge","locality":null,"postal_code":"4600","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:23:35","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"605231761"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3667805,"senior_acct_no":null,"user_id":"4bvfemdc","password":"m5y7389c","status_cd":1,"plan_no":10263079,"first_name":"KRISTIAN","mi":null,"last_name":"Ru00d8NNE","address_1":"Uglevang 90 2  MF","address_2":null,"city":"Alleru00f8d","locality":null,"postal_code":"3450","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:42:06","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"612351269"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3667807,"senior_acct_no":null,"user_id":"58h7g399","password":"39m4c4xy","status_cd":1,"plan_no":10263079,"first_name":"BIRGIT SAMUELSEN","mi":null,"last_name":"MAGNUS POULSEN","address_1":"Hovgu00e5rdsparken 89   ","address_2":null,"city":"Greve","locality":null,"postal_code":"2670","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-07-08 23:43:53","last_updated":"2013-04-21 03:05:29","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"601820356"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":8,"supp_plan":[]},{"acct_no":3538121,"senior_acct_no":null,"user_id":"ykryrg38","password":"jqje7fds","status_cd":1,"plan_no":10263079,"first_name":"THERESE","mi":null,"last_name":"STENBu00c6K","address_1":"Holger Danskes Vej 20 2  2","address_2":null,"city":"Frederiksberg","locality":null,"postal_code":"2000","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 20:15:05","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"614140006"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3538125,"senior_acct_no":null,"user_id":"mnwa96bu","password":"4y5uhc35","status_cd":1,"plan_no":10263079,"first_name":"MIKAEL","mi":null,"last_name":"MODEST","address_1":"Strandhaven 133   ","address_2":null,"city":"Vallensbu00e6k Strand","locality":null,"postal_code":"2665","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 20:16:53","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"610730009"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537967,"senior_acct_no":null,"user_id":"8j9x5fcq","password":"vhpet8ys","status_cd":1,"plan_no":10263079,"first_name":"LI","mi":null,"last_name":"JINSHENG","address_1":"Ru00f8nnegade 12 1  TH","address_2":null,"city":"Ku00f8benhavn u00d8","locality":null,"postal_code":"2100","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 17:39:46","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"615440009"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3537969,"senior_acct_no":null,"user_id":"jcuheq4s","password":"vmxeprkk","status_cd":1,"plan_no":10263079,"first_name":"DALIBOR","mi":null,"last_name":"PERIC","address_1":"Andreas Bju00f8rns Gade 11 ST  TH","address_2":null,"city":"Ku00f8benhavn K","locality":null,"postal_code":"1428","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":"dperic24@hotmail.com","client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-05-27 17:40:36","last_updated":"2013-05-10 19:11:41","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":"NATASHASP@PRIVAT.DK","billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"611680087"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":27,"supp_plan":[]},{"acct_no":3543399,"senior_acct_no":null,"user_id":"vvdkg93e","password":"hr5ycuy9","status_cd":1,"plan_no":10263079,"first_name":"ERLING","mi":null,"last_name":"RUBu00c6K Su00d8RENSEN","address_1":"Fuglevu00e6nget 59   ","address_2":null,"city":"Hornslet","locality":null,"postal_code":"8543","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-06-02 18:37:24","last_updated":"2013-05-16 19:11:02","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"610470097"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":2,"supp_plan":[]},{"acct_no":3640615,"senior_acct_no":null,"user_id":"ttrcy5kg","password":"np5aja3d","status_cd":1,"plan_no":10263079,"first_name":"ERIK","mi":null,"last_name":"HINRICHSEN","address_1":"Rosenvu00e6nget 2   ","address_2":null,"city":"Ru00f8dekro","locality":null,"postal_code":"6230","country":"DK","phone_npa":null,"phone_nxx":null,"phone_suffix":null,"phone_extension":null,"intl_phone":null,"alt_email":null,"client_acct_id":null,"promo_cd":null,"resp_level_cd":1,"pay_method":0,"created":"2012-06-10 23:45:47","last_updated":"2013-05-24 19:11:50","client_1":null,"company_name":null,"current_billing_info":[{"billing_first_name":"NATASHA","billing_middle_initial":null,"billing_last_name":"PRINDAHL","billing_address1":"Sallingvej 26 3  TH","billing_address2":null,"billing_city":"Vanlu00f8se","billing_state":null,"billing_locality":null,"billing_zip":"2720","billing_country":"DK","billing_phone_npa":null,"billing_phone_nxx":null,"billing_phone_suffix":null,"billing_phone_extension":null,"billing_intl_phone":null,"billing_email":null,"billing_pay_method":0,"billing_cc_expire_mm":null,"billing_cc_expire_yyyy":null,"billing_bank_routing_num":null}],"plan_name":"YouSee","state_prov":null,"country_english":"Denmark","promo_name":null,"no_provision_ind":0,"bill_action_cd":1,"status_name":"ACTIVE","acct_balance":0,"supp_field":[{"supp_field_name":"Juridisk","supp_field_value":"602230639"},{"supp_field_name":"Betaler","supp_field_value":"615580041"}],"bill_day":10,"supp_plan":[]}]}';
            response.setBody(str);
        }else{
            response =AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'supp_field_value='+CasperNo+' AND supp_field_name=Betaler'});       
        }
        system.debug('Response from Billing Controller for betaler'+response.getBody());
        return response.getBody();
    }
  //end of carrie-1116
    
    public String getAriaAccountResponse(String AriaAccountno1){
        //HttpResponse response =AriaWebServices.makeCallForJson('get_account_details',UserName,Password, new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountno1});    //CARRIE-986
        HttpResponse response =AriaWebServices.makeCallForJson('get_account_details',config.Client_No__c.longValue(),String.valueOf(config.Auth_Key__c), new Map<String, String> { 'query_string' => 'acct_no='+AriaAccountno1});    
         system.debug('AriaAccountno1...'+AriaAccountno1);
        system.debug('Response from Billing Controller'+response.getBody());
        return response.getBody();
    }
    
    /**
        * @description: This method  is use to parse the json response from Aria.
        * @param: Account.
        * @param: json response from Aria.
        * @return: Account.
        */    
    public Aria_Account__c getBillingDetails(String response , Aria_Account__c aria_account) {
        try{
            String error = ''; 
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) { 
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {  
                    String text = parser.getText(); 
                    parser.nextToken(); 
                    if(text =='error_code'){
                        error =  parser.getText();
                    }else if (text == 'supp_field_name' & parser.getText() == 'Betaler') { 
                        parser.nextToken();
                        text = parser.getText(); 
                        if(text == 'supp_field_value'){
                                parser.nextToken();
                                aria_account.Betaler__c = parser.getText();
                        }
                    }else if (text == 'acct_no') {  
                        aria_account.Aria_Account_No__c = decimal.valueOf(parser.getText()); 
                    }else if (text == 'status_name') {  
                        aria_account.Regningsstatus__c = parser.getText();  
                    }else if (text == 'billing_pay_method') {
                        //aria_account.Aria_Pay_Method__c = carriecommonutil.getPaymentMethod(Long.valueOf(parser.getText()))  ;
                        aria_account.Aria_Pay_Method__c = CarrieCommonUtil.PAY_METHOD_MAP.get(Long.valueOf(parser.getText()));
                    }else if (text == 'acct_balance') {
                        aria_account.CurrentSaldo__c  =0.0;
                        if(parser.getText()!=null && !parser.getText().equals('null')){
                            aria_account.CurrentSaldo__c  = decimal.valueof(parser.getText());
                              aria_account.End_Balance__c =   aria_account.CurrentSaldo__c; // issue 752
                        } 
                        aria_account.Start_Balance__c = 0; // issue 752
                    } 
                }
            }
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
                CarrieLog.LogException(e); 
        }
        return aria_account;
    }
    
    public List<Aria_Account__c> getAriaAccounts(String response) {
        List<Aria_Account__c> Accountlist = new List<Aria_Account__c>();
        try{
            Aria_Account__c AriaAcct;
            String error = '';
            
            CarrieBillingWrapper billingWrapper = new CarrieBillingWrapper();
            billingWrapper = CarrieBillingWrapper.parse(response);
            
            for(CarrieBillingWrapper.Account_details a : billingWrapper.account_details){
                AriaAcct = new Aria_Account__c();
                AriaAcct.Aria_Account_No__c = a.acct_no;
                AriaAcct.Name = ''+a.acct_no;
                listStr.add(AriaAcct.Name);
                AriaAcct.Account__c = oppty.Id;
                AriaAcct.Aria_Plan_Name__c = a.plan_name;
                AriaAcct.Regningsstatus__c = a.status_name;
                AriaAcct.Aria_Pay_Method__c = CarrieCommonUtil.PAY_METHOD_MAP.get(a.pay_method);
                AriaAcct.CurrentSaldo__c = a.acct_balance;
                AriaAcct.End_Balance__c = a.acct_balance; // issue 752
                AriaAcct.Start_Balance__c = 0; // issue 752
                if(a.plan_name.equalsIgnoreCase('YouBio')){
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_YouBio');              
                }else{
                    AriaAcct.RecordTypeId = pageLayoutRecordType.get('Carrie_Telephony');
                }
                for(CarrieBillingWrapper.Supp_field supp : a.Supp_field){
                    if(supp.supp_field_name =='Betaler'){
                        AriaAcct.Betaler__c = supp.supp_field_value;
                    }
                }
                Accountlist.add(AriaAcct); 
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return Accountlist;
    }
    
    //start of Carrie-1116
    /**
        * @description: This method  is used to parse the json response from Aria.
        * @param: json response from Aria.
        * @return: List<BetalerAccounts>.
        */
    public List<BetalerAccounts> getAriaAccountsforBetaler(String response) {
        List<BetalerAccounts> Accountlist = new List<BetalerAccounts>();
        try{
            BetalerAccounts AriaAcct;
            String error = '';
            
            CarrieBillingWrapper billingWrapper = new CarrieBillingWrapper();
            
            billingWrapper = CarrieBillingWrapper.parse(response);
            
            for(CarrieBillingWrapper.Account_details a : billingWrapper.account_details){
                AriaAcct = new BetalerAccounts();
                AriaAcct.AriaNo =''+ a.acct_no;
                AriaAcct.Name = a.first_name+' '+a.last_name;
                AriaAcct.plan = a.plan_name;
                if(a.plan_name=='YouSee'){
                AriaAcct.plan = 'Øvrige produkter';
                }
               for(CarrieBillingWrapper.Supp_field supp : a.Supp_field){
                    if(supp.supp_field_name =='Juridisk'){
                        AriaAcct.CustNo = supp.supp_field_value;
                    }
                }
                Accountlist.add(AriaAcct); 
               
                if(AriaAcct.CustNo!=null && AriaAcct.CustNo.length() > 0 && AriaAcct.CustNo!= oppty.Customer_No__c){
                	stopRedirectPage = true;
                }
            }
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return Accountlist;
    }
    //end of carrie-1116
    
    public PageReference redirectCustomerBillingPage() {
        if(selectAccount !=null){
            system.debug('selectAccount....'+selectAccount);
        //   Account oppty = new Account();
        //   oppty = [Select acc.Customer_No__c, acc.Id ,acc.FirstName  From Account acc where acc.Customer_No__c =:selectAccount ];
        //   system.debug(oppty+'...........Oppty][]');
            PageReference pageRef = new PageReference('/apex/CarrieCustomerBillingPage?id='+selectAccount); 
            return pageRef;
        }else{
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Vælg product');
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }
    
    public PageReference upsertAriaAccount(){
        try{
			Betalerlstacc= new List<BetalerAccounts>();//carrie-1116
        	if(oppty.Customer_No__c==null){
		        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Kunde nummer mangler');
		        ApexPages.addMessage(errorMsg);
	        	return null;
	        }
            casperNo = decimal.valueOf(oppty.Customer_No__c);
            
            //start of carrie-1116
	        String responseDataBetaler = getAriaResponseForBetalar(casperNo);
	        listAcctBetaler = getAriaAccountsforBetaler(responseDataBetaler); 
	        Pagesize = 10;        
	        if(listAcctBetaler!=null && listAcctBetaler.size()>0){
	        	count1=listAcctBetaler.size();
	         	hasPrevious =false;
	         	hasNext=true;
	         	pageno=1;
	         	if(count1>Pagesize){
	            	for(integer i=0; i<Pagesize;i++)
	                	Betalerlstacc.add(listAcctBetaler[i]);
	         	}else{
	            	for(integer i=0; i<count1;i++)
	        			Betalerlstacc.add(listAcctBetaler[i]);
	        			hasNext= false;
	         	}
	        	if( math.mod(listAcctBetaler.size(),10)==0)
	             	totalPage =listAcctBetaler.size()/10;
	            else
	            	totalPage =(listAcctBetaler.size()/10) +1;
	        }
        	system.debug('Betalerlstacc: '+Betalerlstacc+' count1:'+count1);
            //end of carrie-1116
            
            String responseData =  getAriaResponse(casperNo);
            
            if(pageLayoutRecordType.size()<2){
	            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please set the RecordType and Pagelayout.');
	            ApexPages.addMessage(errorMsg);
	            return null;
            }
            listAcct = getAriaAccounts(responseData);
            List<Aria_Account__c> deleteAriaAccount = [Select a.Name From Aria_Account__c a where a.Account__c=:controller.getRecord().Id and a.Name NOT IN :listStr ];
            delete deleteAriaAccount;
            System.debug('List****'+listAcct);
            upsert listAcct Aria_Account_No__c;
        }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception);
            ApexPages.addMessage(errorMsg);
            CarrieLog.LogException(e);
            return null;
        }
        if(listAcct==null ){
        	if(listAcctBetaler!=null && listAcctBetaler.size()==0){ 
	            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Der er ikke tilknyttet nogen Aria konto til denne kunde');
	            ApexPages.addMessage(errorMsg);
            }else if(listAcctBetaler!=null && listAcctBetaler.size()==1){
            	return RedirectToBillingPage(listAcctBetaler[0].AriaNo);		
            }            
            return null;
        }
        else if(listAcct!=null && listAcct.size()>1){
            return null;
        /*}else if(listAcctBetaler!=null && listAcctBetaler.size()!=0){ //carrie-1116
            return null;*/
        }else if(listAcct!=null && listAcct.size()==1){
        	if(stopRedirectPage){
            	return null;
        	}else{
	        	PageReference pageRef = new PageReference('/apex/CarrieCustomerBillingPage?id='+listAcct[0].Id); 
	            return pageRef;	
        	}
        }else if(listAcct!=null && listAcct.size()==0 && listAcctBetaler!=null && listAcctBetaler.size()==1){
        	return RedirectToBillingPage(listAcctBetaler[0].AriaNo);		
        } else{
	        if(listAcctBetaler!=null && listAcctBetaler.size()==0){ 
	        	ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Der er ikke tilknyttet nogen Aria konto til denne kunde');
	            ApexPages.addMessage(errorMsg);            
	        }
	        return null;
        }
    }
    
    public List<SelectOption> getSelectAccounts() {
        List<SelectOption> options = new List<SelectOption>();
        try{
            for(Aria_Account__c a : listAcct){
                if(a.Aria_Plan_Name__c=='YouSee'){
                    options.add(new SelectOption(''+a.Id,'Øvrige produkter ( Betaler Id: '+a.Name+' )')); //carrie-1116
                    selectAccount=''+a.Id;                  
                }else{
                        options.add(new SelectOption(''+a.Id,a.Aria_Plan_Name__c+' ( Betaler Id: '+a.Name+' )')); //carrie-1116
                }
            }
        }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            
        }
        return options;
    }

//start of carrie-1116


    /*
        * @description: Inner class for betaler accounts.
        */
class BetalerAccounts{
    public String name{get;set;}
    public  String AriaNo{get;set;}
    public String CustNo{get;set;}
    public String plan{get;set;}

    public BetalerAccounts(){}
}

/**
        * @description: This method  is used to redirect to CarrieAccountSelectPage.
        * @return: CarrieAccountSelectPage.
        */
/* public PageReference CallCustomerPage(){
    try{
    CarrieAriaSearchController casc = new CarrieAriaSearchController();
    ID AcctId = casc.lookForKundeNumber(PageKundeId);
    PageReference pf = new PageReference('/apex/CarrieAccountSelectPage?id='+AcctId);
    pf.setRedirect(true);
    return pf;
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        return null;
    }   
}*/

/**
        * @description: This method  is used to redirect to CarrieCustomerBillingPage.
        * @return: CarrieCustomerBillingPage.
        */
public PageReference CallAriaPage(){
    try{
        return RedirectToBillingPage(PageAriaId);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }   
}

public PageReference RedirectToBillingPage(String Aria_num){
	
List<Aria_Account__c> ariaSpoc = new List<Aria_Account__c>();
        CarrieAriaSearchController casc = new CarrieAriaSearchController();
        ariaSpoc = [SELECT Name, Id, Account__c, Aria_Account_No__c,Aria_Plan_Name__c, Betaler__c, Customer_No__c FROM Aria_Account__c where name =:Aria_num limit 1];
        system.debug('ariaSpoc: '+ariaSpoc);
        if(ariaSpoc!=null && ariaSpoc.size()>0){
            PageReference pf1 = new PageReference('/apex/CarrieCustomerBillingPage?id='+ariaSpoc[0].Id);
            pf1.setRedirect(true);
            return pf1;
        }else{
            casc.ariaNumber = Aria_num;
            PageReference pp = casc.makeAriaSearchCall();
            ariaSpoc = casc.ariaSpoc;
            if(ariaSpoc!=null && ariaSpoc.size()>0){     
                PageReference pf1 = new PageReference('/apex/CarrieCustomerBillingPage?id='+ariaSpoc[0].Id);
                pf1.setRedirect(true);
                return pf1;
            }
        return null;
        }	
}


/**
        * @description: This method  is used for Pagination.
        */
public void First(){
         hasNext=true;
         Betalerlstacc.clear();
         hasPrevious=false;
         pageno =1;
         for(integer i=0;i<10;i++)
          {
          Betalerlstacc.add(listAcctBetaler[i]);  
         }
}

/**
        * @description: This method  is used for Pagination.
        */     
public void Previous(){    
         hasNext=true;
         Betalerlstacc.clear();
         if(pageno  !=1)
             {
                  pageno  = pageno  - 1;
                  If(pageno  ==1 )
                  hasPrevious=false;
                   for(integer i=(pageno -1) * Pagesize;i<(pageno * Pagesize);i++ )
                     {
                         Betalerlstacc.add(listAcctBetaler[i]); 
                     }
             }                           
             else
              {
                  hasPrevious=false;
                  
                  for(integer i=(pageno -1) * Pagesize;i<(pageno * Pagesize);i++ )
                     {
                         Betalerlstacc.add(listAcctBetaler[i]); 
                      }
              }
}

/**
        * @description: This method  is used for Pagination.
        */     
public void Next(){
         pageno  = pageno +1;
         integer pgno;
         Betalerlstacc.clear();
         if(math.mod(listAcctBetaler.size(), Pagesize)==0)
           { 
                pgno=listAcctBetaler.size()/ Pagesize;
           }
            else
            pgno=(listAcctBetaler.size()/Pagesize) +1; 
            if(pageno ==pgno)
             { 
                  hasNext=false;
                  for(integer i=(pageno -1) * Pagesize;i<listAcctBetaler.size();i++ )
                    {
                     Betalerlstacc.add(listAcctBetaler[i]); 
                    }
             }
           else            
            for(integer i=(pageno -1) * Pagesize;i<(pageno * Pagesize);i++ )
              {
                     Betalerlstacc.add(listAcctBetaler[i]); 
             }
            hasPrevious=true;
}


/**
        * @description: This method  is used for Pagination.
        */     
public void Last(){  
        hasPrevious=true;
        Betalerlstacc.clear();
        hasNext=false;
        if( math.mod(listAcctBetaler.size(),Pagesize)==0)
             pageno =listAcctBetaler.size() / Pagesize;
            else
            pageno =(listAcctBetaler.size() / Pagesize ) +1; 
         for(integer i=(pageno -1) * Pagesize;i<listAcctBetaler.size();i++)
          {
              Betalerlstacc.add(listAcctBetaler[i]);  
         }
}

//end of carrie-1116

}