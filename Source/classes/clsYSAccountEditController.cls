public with sharing class clsYSAccountEditController {

    public String accountID {get; set;}
    public String cuID {get;set;}
    public Account account;
    public Cable_Unit__c cableUnit {get; set;}
    public Boolean dktvFalg{get; set;}
    public Boolean dktvmailFlag{get; set;}
    public String strHierarName{get;set;}
    public String strHierarId{get;set;}
    //public Boolean checkErrorFlag{get; set;}
    public ApexPages.StandardController controller;
    
    public clsYSAccountEditController(ApexPages.StandardController controller) {
        this.controller = controller;
        SObject obj = controller.getRecord();
        account = (Account) obj;  
        accountID = account.Id;
        //checkErrorFlag = false;
        //dktvFalg = false;
        //dktvmailFlag = false;
        account = Database.query('Select a.Kontraktkunde__c,a.Kontraktkunde__r.Name, a.Kontraktkunde__r.Id,a.CA_Debit_Code__c, a.CA_Arrears_Code__c, a.Description, a.memberships__c, a.Customer_Segment_Lookup__c,a.Street_YK__c, PO_Box_alt__c, a.Declaration_of_Intent__c, a.Customer_Satisfaction_Lookup__c, a.CVR_number__c, a.ParentId, a.Phone, Home_Phone__c, Mobile_phone__c, a.Website, a.type, a.company_email__c,  a.Id, a.Name, a.OwnerId, a.isPersonAccount, a.Cable_Unit__c, a.RecordTypeID,a.Cable_Unit_DKTV__c,a.DKTV_Foreningsmail__c,a.DKTV_mailadresse__c,a.EAN_nr__c,a.Foreningsweb__c,a.Date_of_Next_General_Meeting__c,a.Annual_general_meeting__c,a.Partnership__c from Account a where a.Id =: accountID limit 1');
        //account = accounts[0];
        
        if(account.Kontraktkunde__c!=null){
            strHierarName = account.Kontraktkunde__r.Name;
            strHierarId = account.Kontraktkunde__c;
        }
        
        if(account.Cable_Unit_DKTV__c == True){
            dktvFalg = true;
        }else{
            dktvFalg = false;
        }
        if(account.DKTV_Foreningsmail__c == True){
            dktvmailFlag = true;
        }else{
            dktvmailFlag = false;
        }
        System.debug('%%%%account.Cable_Unit__c'+account.Cable_Unit__c);
        if(account.Cable_Unit__c != null) {
            cuID = account.Cable_Unit__c;
            cableUnit = [Select c.Service_Center_Customer_Agreement__c, c.OwnerId, c.Name, c.Municipaly__c, c.Potential_Installations__c ,c.IsDeleted, c.Id, c.Housing_Type__c, c.Housing_Ownership__c, c.CreatedDate, c.CreatedById, c.Cable_Unit_in_Casper__c, c.Cable_Unit_Post_Code__c, c.Cable_Unit_No__c, c.CA_Sales_Concept__c, c.CA_Ownership__c, c.CA_Ownership_Code__c, c.CA_Installations__c, c.Building_Type__c from Cable_Unit__c c where c.Id =: cuID limit 1];
            
            System.debug('%%%%account.Cable_Unit__c%%%%%%%%%%%'+cableUnit);
        }
          
    }
    
    public Account getAccount() {
        return account; 
    }   
    
    public SelectOption[] getBuildingTypeOptions() {
        SelectOption[] buildingType = new SelectOption[]{};
        buildingType.add(new SelectOption('','- Ingen -'));
        for (Lookup_Building_Type__c b : [select id, name, code__c, active__c from Lookup_Building_Type__c where active__c='Ja' order by name]) {
            buildingType.add(new SelectOption(b.id, b.name));
        }
        return buildingType;
    }
    
    public SelectOption[] getHousingOwnerShipOptions() {
        SelectOption[] housingOwnership = new SelectOption[]{};
        housingOwnership.add(new SelectOption('','- Ingen -'));
        for (Lookup_Housing_Ownership__c ho : [select id, name, code__c, active__c from Lookup_Housing_Ownership__c where active__c='Ja' order by name]) {
            housingOwnership.add(new SelectOption(ho.id, ho.name));
        }
        return housingOwnership;
    }
    
    public SelectOption[] getHousingTypeOptions() {
        SelectOption[] housingType = new SelectOption[]{};
        housingType.add(new SelectOption('','- Ingen -'));
        for (Lookup_Housing_Type__c ht : [select id, name, code__c, active__c from Lookup_Housing_Type__c where active__c='Ja' order by name]) {
            housingType.add(new SelectOption(ht.id, ht.name));
        }
        return housingType;
    }
    
    public SelectOption[] getCustomerSegmentOptions() {
        SelectOption[] customerSegment = new SelectOption[]{};
        customerSegment.add(new SelectOption('','- Ingen -'));
        for (Lookup_Customer_Segment__c cs : [select id, name, code__c, active__c from Lookup_Customer_Segment__c where active__c='Ja' order by name]) {
            customerSegment.add(new SelectOption(cs.id, cs.name));
        }
        return customerSegment;
    }
    
    public SelectOption[] getCustomerSatisfactions() {
        SelectOption[] customerSatisfaction = new SelectOption[]{};
        customerSatisfaction.add(new SelectOption('','- Ingen -'));
        for (Lookup_Customer_Satisfaction__c csa : [select id, name, code__c, active__c from Lookup_Customer_Satisfaction__c where active__c='Ja' order by name]) {
            customerSatisfaction.add(new SelectOption(csa.id, csa.name));
        }
        return customerSatisfaction;
    }
    
    public PageReference cancel() {
        return (new ApexPages.StandardController(account)).view();
    }
    
    /*start of changes for SF-24*/
    public String errAccName{get;set;}
    public String errCblName{get;set;}
    public String errCblPtIns {get;set;}
    public String errCblMun {get;set;}
    public String errCblPCode{get;set;}
    /*Added by Satarupa*/
    public Boolean errAccNameFlag{get;set;}
    public Boolean errCblNameFlag {get;set;}
    public Boolean errCblPtInsFlag {get;set;}
    public Boolean errCblMunFlag {get;set;}
    public Boolean errCblPCodeFlag {get;set;}
    /**/
    public String errAccSeg{get;set;}
    public String errCblHType{get;set;}
    public String errCblHOwn{get;set;}
    public String errCblBType{get;set;}
    public Boolean errAccSegFlag{get;set;}
    public Boolean errCblHTypeFlag {get;set;}
    public Boolean errCblHOwnFlag {get;set;}
    public Boolean errCblBTypeFlag {get;set;}
    
    /*
    public Boolean requiredFieldValidation(){
        errAccName='';
        errCblName='';
        errCblPtIns='';
        errCblMun='';
        errCblPCode='';
        errAccSeg='';
        errCblHType='';
        errCblHOwn='';
        errCblBType='';
        errAccSegFlag=false;
        errCblHTypeFlag =false;
        errCblHOwnFlag =false;
        errCblBTypeFlag =false;
        
        errAccNameFlag=false;
        errCblNameFlag = false;
        errCblPtInsFlag = false;
        errCblMunFlag = false;
        errCblPCodeFlag = false;
        
        
        String errText='Error: You must enter a value';
        Boolean errFlag = false;
        if(UserInfo.getLanguage()=='da')
        errText = 'Fejl: Du skal angive en værdi';
        
    //system.debug('account.Customer_Segment_Lookup__c: '+account.Customer_Segment_Lookup__c);
   /* if(account.name==null || (account.name!=null && account.name.length()==0)){
    errAccNameFlag = true;
    errFlag = true;
    errAccName = errText;
    }
    if(cableUnit.name==null || (cableUnit.name!=null && cableUnit.name.length()==0)){
    errCblNameFlag = true;
    errFlag = true;
    errCblName = errText;
    }
    if(cableUnit.Potential_Installations__c==null){
    errCblPtInsFlag = true;
    errFlag = true;
    errCblPtIns = errText;
                  
    }
    if(cableUnit.Municipaly__c==null || (cableUnit.Municipaly__c!=null && cableUnit.Municipaly__c.length()==0)){
    errCblMunFlag = true;
    errFlag = true;
    errCblMun = errText;
    }
    if(cableUnit.Cable_Unit_Post_Code__c==null || (cableUnit.Cable_Unit_Post_Code__c!=null && cableUnit.Cable_Unit_Post_Code__c.length()==0)){
    errCblPCodeFlag = true;
    errFlag = true;
    errCblPCode = errText;
    }
    if(account.Customer_Segment_Lookup__c==null){
    errAccSegFlag = true;
    errFlag = true;
    errAccSeg = errText;
    }
    if(cableUnit.Housing_Type__c==null){
    errCblHTypeFlag = true;
    errFlag = true;
    errCblHType = errText;
    }
    if(cableUnit.Housing_Ownership__c==null){
    errCblHOwnFlag = true;
    errFlag = true;
    errCblHOwn = errText;
    }
    if(cableUnit.Building_Type__c==null){
    errCblBTypeFlag = true;
    errFlag = true;
    errCblBType = errText;
    }    
    system.debug('errFlag: '+errFlag);*/
  //  return errFlag;
  //  }
  /* end of sf-24 */ 

    public PageReference saveAccount() {
        try {
            /*if(account.DKTV_Foreningsmail__c == false){
                //account.DKTV_mailadresse__c = '';
                //System.debug('@@@@'+account.DKTV_Foreningsmail__c+'@@account.DKTV_mailadresse__c@@'+account.DKTV_mailadresse__c);
            }*/
            /*if(account.Cable_Unit_DKTV__c == false && account.DKTV_Foreningsmail__c == True){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please Select Cable Unit DKTV');
                ApexPages.addMessage(errorMsg);
            }*/
            //if(requiredFieldValidation())
            //    return null;
            
            if(strHierarName!=''&& strHierarName!=null) 
            {
                System.debug('=====strHierarId======'+strHierarId+'======strHierarName======'+strHierarName);
                account.Kontraktkunde__c = strHierarId;
            }
            else if(strHierarName == '')
                account.Kontraktkunde__c = null;
            update account;
            if(cableUnit != null)
                update cableUnit;
        } catch(System.DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
        return (new ApexPages.StandardController(account)).view();
    }
    
    static testMethod void testEditYSAccount() {
        
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnit;
        
        Account parentAcc = new Account();
        parentAcc.Type = 'Hierarki';
        parentAcc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde2();
        parentAcc.name = 'Parent1';
        insert parentAcc;  
        
        Account acc = new Account();
        acc.Name = 'YS test';
        acc.Cable_Unit__c = cableUnit.Id;
        acc.Customer_No__c = '5436789';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Kontraktkunde__c = parentAcc.id;
        acc.Cable_Unit_DKTV__c = true;
        acc.DKTV_Foreningsmail__c = true;
        insert acc;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        clsYSAccountEditController controller = new clsYSAccountEditController(sc);
        
        System.assertNotEquals(0, controller.getBuildingTypeOptions().size());
        System.assertNotEquals(0, controller.getHousingOwnerShipOptions().size());
        System.assertNotEquals(0, controller.getHousingTypeOptions().size());
        System.assertNotEquals(0, controller.getCustomerSegmentOptions().size());
        System.assertNotEquals(0, controller.getCustomerSatisfactions().size());
        controller.errAccName = '';
    controller.errCblName = '';
    controller.errCblPtIns = '';
    controller.errCblMun ='';
    controller.errCblPCode = '';
   
    controller.errAccNameFlag = false;
    controller.errCblNameFlag = false;
    controller.errCblPtInsFlag = false;
    controller.errCblMunFlag  = false;
    controller.errCblPCodeFlag  = false;
    /**/
    controller.errAccSeg = '';
    controller.errCblHType = '';
    controller.errCblHOwn = '';
    controller.errCblBType = '';
    controller.errAccSegFlag = false;
    controller.errCblHTypeFlag = false;
    controller.errCblHOwnFlag = false;
    controller.errCblBTypeFlag = false;
        cableUnit.Cable_Unit_in_Casper__c = true;
        controller.saveAccount();
        controller.getAccount();
        controller.cancel();
        System.assertEquals(true, cableUnit.Cable_Unit_in_Casper__c);   
    }
    
}