public class ViewCableUnitsController{ 
    public String contactStatus { get; set; }
    public String contactRolename { get; set;}
    public String portalAdminUser{get; set;}
    public String portalBrugerRole {get; set;}
    public Integer cuSize {get; set;}
    
    public ID hierarchyStatus{ get; set;}
    public Boolean checkFlag {get; set;}
    public List<Id> salesConceptId;
    CableUnitService cuService = new CableUnitService();
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewCableUnitsController','Home Page');
    public String siteCoreUrl{get; set;}
    
        
    public ViewCableUnitsController(){
       getCableUnitStatus();
       portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
       portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
       siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
       checkFlag = false;
    }
    
    public Map<String, String> cableUnitStatusMap = new Map<String, String>();
    
    public Integer getCuSize(){
        return cuSize;
    }
    
    /*  Identify keys to their associated values */     
    public void getCableUnitStatus(){
        cableUnitStatusMap.put('4', 'I drift');
        cableUnitStatusMap.put('99', 'Opsagt');
        cableUnitStatusMap.put('0', 'Uden aftale');
        cableUnitStatusMap.put('2', 'Under opsætning');
    }

    /** This method is used get cableUnits List .*/
    public List<CableUnits> getCUList() {
        //try {
               Id portalId = ApexPages.currentPage().getParameters().get('suportaluserid'); 
               Map<ID, Account> accountMap = cuService.getCableUnitRelatedDetails(UserInfo.getUserId());
               System.debug('accountMap0: '+accountMap);
               //Contact checkUserContact = [Select Id, HierarchyAccount__c From Contact where id in (select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
               List<Contact> contactList = [Select Id, HierarchyAccount__c From Contact where id in (select contactid from User where id =:UserInfo.getUserId())];
               if(contactList.size() > 0){
                   hierarchyStatus = contactList.get(0).HierarchyAccount__c;    
               }/*else{
                    hierarchyStatus = null;
               }*/       
                         
               List<CableUnits> cableUnitsList = new List<CableUnits>();
               if(accountMap != null && accountMap.size() > 0){
                   contactStatus = cuService.cntStatus;
                   contactRolename = cuService.acrRolename; 
                   List<Opportunity> salesConceptList = cuService.getSalesConceptRelatedDetails(accountMap.keySet());
                   salesConceptId = new List<Id>();
                   for(Opportunity opportunity : salesConceptList){
                       salesConceptId.add(opportunity.Sales_Concept_Lookup__c);
                   }
                   List<Sales_Concept_Parameter__c> salesConceptParameterList = [Select s.Sales_Concept__c, 
                                                                                       s.Parameter_Group__c, s.Parameter_Head__c,
                                s.Parameter_Value__c From Sales_Concept_Parameter__c s where s.Sales_Concept__C in: (salesConceptId) and 
                                s.Parameter_Group__c='Bredbånd' and s.Parameter_Head__c='YouSee Bredbånd' and s.Parameter_Value__c='Ja'];
                   System.debug('salesList: '+salesConceptList.size());
                   for(Opportunity opportunity : salesConceptList){
                            CableUnits cu = new CableUnits();
                            System.debug('accountMap1: '+accountMap); 
                            Account a = accountMap.get(opportunity.id);
                            
                            cu.accountId  = a.Id;
                            //cu.broadBandService = a.Sales_Concept_Parameter__r.broadBandService__c;
                            cu.cableUnitNumber = a.Cable_Unit__r.Cable_Unit_No__c; //a.Cable_Unit__r.Name;
                            cu.cableUnitName = a.Cable_Unit__r.Name;
                            //System.debug('$cu.broadBandService$'+cu.broadBandService);
                            System.debug('$cu.cableUnitName$'+cu.cableUnitName+'cu.cableUnitNumber'+cu.cableUnitNumber);
                            cu.cableUnitStatusImgHolder = a.Cable_Unit__r.Status_Formula__c;
                            cu.solution = opportunity.Sales_Concept_Lookup__r.Solution__c;
                            if(a.Cable_Unit__r.Inaktiv_Dato__c != null){                                
                                Date cableUnitDate = a.Cable_Unit__r.Inaktiv_Dato__c;
                                if(cableUnitDate >= date.today()){
                                    cu.cableUnitEnabled = true;
                                }else{
                                    cu.cableUnitEnabled = false;
                                }
                            }else{
                                cu.cableUnitEnabled = true;
                            }    
                            if(a.Cable_Unit__r.Status__c == '4'){
                                cu.cableUnitStatus = 'I drift';
                            }else if(a.Cable_Unit__r.Status__c == '99'){
                                cu.cableUnitStatus = 'Opsagt';
                            }else if(a.Cable_Unit__r.Status__c == '0'){
                                cu.cableUnitStatus = 'Uden aftale';
                                cu.cableUnitEnabled = false;
                            }else{
                                cu.cableUnitStatus = 'Under opsætning';
                            }
                            cu.tVService = Label.SC_Nej;
                            cu.broadBandService = Label.SC_Nej;
                            cu.telephonyService = Label.SC_Nej;
                            if(a.Cable_Unit__r.Contract_Source_ID__c == null){
                                cu.tVService = Label.SC_Nej;
                                cu.broadBandService = Label.SC_Nej;
                                cu.telephonyService = Label.SC_Nej;
                            }else{
                                cu.tVService = Label.SC_Ja;
                                
                                for(Sales_Concept_Parameter__c salesConceptParameter : salesConceptParameterList){
                                    if (salesConceptParameter.Sales_Concept__c ==opportunity.Sales_Concept_Lookup__c  ){
                                        cu.broadBandService = Label.SC_Ja;
                                        cu.telephonyService = Label.SC_Ja;
                                    }
                                //    if(salesConceptParameter.Sales_Concept__c == opportunity.Sales_Concept_Lookup__c){
                                  //      if(salesConceptParameter.Parameter_Group__c.equalsIgnoreCase('Bredbånd') && salesConceptParameter.Parameter_Head__c.equalsIgnoreCase('YouSee Bredbånd') && salesConceptParameter.Parameter_Value__c.equalsIgnoreCase('Ja')){
                                   //         cu.broadBandService = Label.SC_Ja;
                                    //        cu.telephonyService = Label.SC_Ja;
                                    //    }
                                    //}
                                }
                            }
                            //System.debug('$cu.broadBandService$'+cu.broadBandService);
                            cableUnitsList.add(cu);
                    }
               }else{
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_CableUnitsNotPresent);
                    ApexPages.addMessage(errorMsg);                 
               }
               return  cableUnitsList;
             
    }
    
      
    /* Wrapper Class */
    public class CableUnits{
            public String cableUnitName {get; set;} 
            public String cableUnitNumber  {get; set;}
            public String cableUnitStatus {get; set;} 
            public String cableUnitStatusImgHolder {get; set;}    
            public String telephonyService {get; set;}    
            public String broadBandService {get; set;}   
            public String tVService {get; set;}
            public String telephonyServiceImgHolder {get; set;}    
            public String broadBandServiceImgHolder {get; set;}   
            public String tVServiceImgHolder {get; set;}
            public String solution {get; set;}
            public boolean cableUnitEnabled {get; set;}
            public ID accountId {get; set;}
    } 

  
    /** This method is used to export the cable unit list to a excel sheet.*/
    public PageReference exportExcel(){
        PageReference excelPage;
        excelPage= Page.cableUnitE2E;
        return excelPage;
    }
    
   
    
    
}