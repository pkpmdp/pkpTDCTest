public class CableUnitDetailsController {
    public Id contactId;
    public string cableUnitName;
    public String cableUnitNumber;
    public string status;
    public string solution;
    public String tvRadio{get;set;}
    public String broadband{get;set;}
    public String telephony{get;set;}
    public String portalBrugerRole {get; set;}
    public String accountId{get;set;}//support-5377
    private String paymentAccNumber;
    public String siteCoreUrl{get; set;}
    public static Boolean FORCE_TEST_MODE = false;
    public static List<String> calloutParameter = new List<String>();
    public static List<String> calloutvalue = new List<String>();
    public Boolean renderSection{get;set;}//support-5377
    //public static CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('CableUnitDetailsController ','Cable Units Details');
    //public static integer responseCode{get; set;}
    List<Cable_Unit__c> cableUnitList = new List<Cable_Unit__c>();  
    public string getCableUnitName() {
        return cableUnitName ;
    }
        public string getSolution(){
        return solution;
    }
    public string getStatus(){
        if(status == '4'){
            status = 'I drift';
        }else if(status == '99'){
            status = 'Opsagt';
        }else if(status == '0'){
            status = 'Uden aftale';
        }else if(status == '2'){
            status = 'Under opsætning';
        }else{
            status = 'Under opsætning';
        }
        return status;
    }
     public Id getContactId() {
        List<User> userList = [select contactid from User where id =:UserInfo.getUserId()];    
        if(userList.size() > 0) {                   
            contactId =  userList[0].ContactId;
        } 
        return contactId ;
    }  
    public void setContactId(Id conId){
        contactId = conId;
    } 
     /***
        This method is used to insert a record in the Service_Centre_Data_Sync_Log__c Object.
        It returns the Id of the newly inserted record.
      **/
    /*private Id getDataSyncLogId(String cableUnitNumber){
        Service_Centre_Data_Sync_Log__c syncLog = new  Service_Centre_Data_Sync_Log__c();        
        syncLog.CableUnitNo__c =    cableUnitNumber;   
        syncLog.Request_Source__c = 'cableUnitDetailsPage';
        syncLog.CableUnitNo__c = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        syncLog.Account_No__c = ApexPages.CurrentPage().getParameters().get('accountId');
        try{
            insert syncLog;
        }catch(DMLException ex){
            system.debug('### The dataSyncLog Id created is ### '+ex.getMessage());
        }
        
        return syncLog.Id;
    }*/
    public CableUnitDetailsController(){
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        cableUnitList = new List<Cable_Unit__c>(); 
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');//start support-5377
        Boolean cableUnitNotMatch = false;
        renderSection = true;
        list<Account> accList = new list<Account>();
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
        if(!accList.isEmpty()){
            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
            if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
                /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cable Unit Not matched with Account');
                ApexPages.addMessage(errorMsg); */ 
            }//end support-5377
        else{
            if(cableUnitNumber != null){
            cableUnitList = [Select c.name, status__c, c.Contract_Source_ID__c, 
                c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.solution__c,
                c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.TVandRadio__c,
                c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.Broadband__c,
                c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.Telephony__c
            from Cable_Unit__c c where  c.Cable_Unit_No__c =: cableUnitNumber];
        }
        List<Id> salesConceptId = new List<Id>();
        for(Cable_Unit__c cableUnit : cableUnitList){
           salesConceptId.add(cableUnit.Current_Kiss_Case__r.Sales_Concept_Lookup__c);
        }
        System.debug('salesConceptId: '+salesConceptId);
        List<Sales_Concept_Parameter__c> salesConceptParameterList = [Select s.Sales_Concept__c, s.Parameter_PortalActive__c, s.Parameter_Group__c, s.Parameter_Head__c, s.Parameter_Value__c From Sales_Concept_Parameter__c s where s.Sales_Concept__C in: (salesConceptId)]; 
        System.Debug('Cable Unit in cableunitdetails-----'+cableUnitList);
        if(cableUnitList != null && cableUnitList.size() > 0){
            if(cableUnitList[0].name != null){
              cableUnitName = cableUnitList[0].name;
            }
            if(cableUnitList[0].status__c != null){
             status = cableUnitList[0].status__c;
            }
            if(cableUnitList[0].Current_Kiss_Case__r.Sales_Concept_Lookup__r.solution__c != null){
             solution = cableUnitList[0].Current_Kiss_Case__r.Sales_Concept_Lookup__r.solution__c;
            }
            tvRadio = Label.SC_Nej;
            broadband = Label.SC_Nej;
            telephony = Label.SC_Nej;
            if(cableUnitList[0].Contract_Source_ID__c == null){
                tvRadio = Label.SC_Nej;
                broadband = Label.SC_Nej;
                telephony = Label.SC_Nej;
            }else{
                tvRadio = Label.SC_Ja;
                for(Sales_Concept_Parameter__c salesConceptParameter : salesConceptParameterList){
                  if(salesConceptParameter.Parameter_Group__c.equalsIgnoreCase('Bredbånd') && salesConceptParameter.Parameter_Head__c.equalsIgnoreCase('YouSee Bredbånd') && salesConceptParameter.Parameter_Value__c.equalsIgnoreCase('Ja')){
                    broadband = Label.SC_Ja;
                    telephony = Label.SC_Ja;
                  }
                }
            }  
         } 
            
        }
    }
    else{
        renderSection = false;//support-5377
        }
    }
    public PageReference FetchCableUnitdata() {
        System.debug('In FetchCable****');
         //dataSyncLogId = getDataSyncLogId(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
         //System.debug('In FetchCable****'+dataSyncLogId);
         accountId = ApexPages.CurrentPage().getParameters().get('accountId');
         System.debug('#accountId#'+accountId);
         //makeHTTPCallOut(cableUnitNumber, accountId);   //Agreement call
         makeHTTPCallOut(cableUnitNumber, '');   //Invoice call
        //paymentAccNumber = cuList[0].Payment_Account_No__r.customer_No__c;
        ApexPages.CurrentPage().getParameters().put('paymentAccNumber',paymentAccNumber);
         ApexPages.CurrentPage().getParameters().put('dataSyncLogId','04lM0000001bDSCIA2');
         return null;
    }
   public PageReference cancel(){   
        // Change According from Partial Page Reference to Absolute
        //PageReference newPage = new PageReference('/apex/ViewCableUnitsHomePage');
        PageReference newPage = Page.ViewCableUnitsHomePage;
        newPage.setRedirect(true);
        return newPage;    
   } 
   //@future(callout = true)
   public static void makeHTTPCallOut(String cableUnitNo, String accountNo){
        String body = '<?xml version="1.0"?>';       
        body += '<notifications xmlns="http://soap.sforce.com/2005/09/outbound">';
        body += '<OrganizationId>00DM0000000ARWB</OrganizationId>';
        body += '<ActionId>04kM00000004CKaIAM</ActionId>';
        body += '<SessionId xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>';
        body += '<EnterpriseUrl>https://cs7-api.salesforce.com/services/Soap/c/24.0/00DM0000000ARWB</EnterpriseUrl>';
        body += '<PartnerUrl>https://cs7-api.salesforce.com/services/Soap/u/24.0/00DM0000000ARWB</PartnerUrl>';
        body += '<Notification>';
        body += '<Id>04lM0000001bDSCIA2</Id>';
        body += '<sObject xmlns:sf="urn:sobject.enterprise.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="sf:Service_Centre_Data_Sync_Log__c">';
        body += '<sf:Id>00DM0000000ARWB</sf:Id>';
        body += '<sf:CableUnitNo__c>'+cableUnitNo+'</sf:CableUnitNo__c>';
        /* Commented for Agreements call
        if(accountNo != ''){
           body += '<sf:Account_No__c>'+accountNo+'</sf:Account_No__c>';        
        }*/
        body += '</sObject>';
        body += '</Notification>';
        body += '</notifications>'; 
        System.debug('#Body#'+body);
        String response = '';
        if(!FORCE_TEST_MODE){
            System.debug('In callout block');
          try{
              /***** Changes for EDM-637 *****/
               // HttpRequestUtil.makeHttpCall('InvoiceReq',body);
               calloutParameter.add('null');
               calloutvalue.add(body);
               string res= clsConnectionUtils_Admin.callout1('InvoiceReq',calloutParameter,calloutvalue);
              System.debug('#response#'+response);
              /*** End of Code EDM-637 ****/
              
                /* Commented for Agreements Call
                if(accountNo != ''){
                    response = HttpRequestUtil.makeHttpCall('AgreementReq',body);
                    System.debug('#response#'+response);  
                }else{
                    HttpRequestUtil.makeHttpCall('InvoiceReq',body);
                }*/
          }catch(Exception e){
                system.debug('#Inside response catch#'+e.getMessage());
                //exceptionHandler.handleException(e,'makeHTTPCallOut()',false,false,null,'High');
                //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Read Timed Out');
                //ApexPages.addMessage(errorMsg);
          }
        }
   }
}