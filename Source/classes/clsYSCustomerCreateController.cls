public with sharing class clsYSCustomerCreateController {

    private Account account;
    public Cable_Unit__c cableUnit;
    
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    // following lines are added by Navneet for populating records from custom settings
    String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;//012200000000nf3
   /* public String strHierarName{get;set;}
    public String strHierarId{get;set;}*/
    
    public clsYSCustomerCreateController(ApexPages.StandardController controller) {
        //account.ownerId = System.Userinfo.getUserId();
        //System.debug('user'+account.ownerID);
        cableUnit = new Cable_Unit__c ();
        renderValMsg = false;
        renderOtherMsg = false;
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
        
        return new PageReference('/001/o');
    }
    
/* start of changes for SF-24*/
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

    /* Commented not using
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
        
    system.debug('account.Customer_Segment_Lookup__c: '+account.Customer_Segment_Lookup__c);
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
    //return errFlag;
    //}
    
    
    public boolean renderValMsg{get;set;}
    public boolean renderOtherMsg{get;set;}
   /* end of sf-24 */ 
    
    public PageReference saveAccount() {
       //if(requiredFieldValidation())
       // return null;
       system.debug('save triggered');
         Cable_Unit__c objCable = new Cable_Unit__c();
         Savepoint sp = Database.setSavepoint(); // added on 22nd Nov'13
        try {                
             // cableUnit.name = account.name;    
              insert cableUnit;
              objCable = cableUnit.clone(false);
              System.debug('=======cableUnit===2========'+cableUnit.Id);
              
            } catch(System.DmlException e){
    
                Database.rollback(sp); 
                return null;
            }
        
        
        try {
              account.ownerId = System.Userinfo.getUserId();
              //account.RecordTypeId = '012200000000nf3';
              account.RecordTypeId = customerRecordType1;
              
            /*  if(strHierarName!=''&& strHierarName!=null) 
                {
                    System.debug('=====strHierarId======'+strHierarId+'======strHierarName======'+strHierarName);
                    account.Kontraktkunde__c = strHierarId;
                }
                else if(strHierarName == '')
                    account.Kontraktkunde__c = null;*/
              
              account.Cable_Unit__c = cableUnit.Id;
            /*
            if(account.DKTV_Foreningsmail__c == true && (account.DKTV_mailadresse__c == null || account.DKTV_mailadresse__c == '')){
                
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Provide Email address');
                ApexPages.addMessage(errorMsg);
                return null;
            }*/
            insert account;
            
            
        } catch(System.DMLException e){
            
           string Err= e.getMessage();
           
           if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
           }
           else if(e.getDmlType(0) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
              
              system.debug('======Err============='+Err); 
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Err);
               ApexPages.addMessage(myMsg);   
               ApexPages.addMessages(e);
               //renderValMsg = false;
               //renderOtherMsg = true;
           }
           Database.rollback(sp); 
           cableUnit = new Cable_Unit__c(); // creating a new instance as sobject id exists even after rollback 
           cableUnit  = objCable;
           return null;        
        }
        return (new ApexPages.StandardController(account)).view();
    }

    public Cable_Unit__c getCableUnit() {
        if(cableUnit == null) cableUnit = new Cable_Unit__c();
        return cableUnit;
    }
    
    public void setCableUnit(Cable_Unit__c cableUnit) {
        this.cableUnit = cableUnit;
    }

    public Account getAccount() {
        if(account == null) account = new Account();
        return account;
    }
    
    public void setAccount(Account account) {
        this.account = account;
    }
    
    static testMethod void testCreateYSAccount() {
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        Account acc = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        clsYSCustomerCreateController controller = new clsYSCustomerCreateController(sc);
        
        controller.setAccount(acc);
        controller.saveAccount();
        controller.setCableUnit(cableUnit);
        cableUnit.name='YS Test';
        acc.name = 'YS Test';
        
        controller.saveAccount();
        System.assertEquals(cableUnit.id, controller.getAccount().Cable_Unit__c); 
        System.assertEquals(cableUnit.id, controller.getCableUnit().id);       
        
        System.assertNotEquals(0, controller.getBuildingTypeOptions().size());
        System.assertNotEquals(0, controller.getHousingOwnerShipOptions().size());
        System.assertNotEquals(0, controller.getHousingTypeOptions().size());
        System.assertNotEquals(0, controller.getCustomerSegmentOptions().size());
        System.assertNotEquals(0, controller.getCustomerSatisfactions().size());
        controller.cancel();
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
    cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
    cableUnitTest.Name = 'cu_kundeCust_testing1'; 
    cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
    cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
    cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                    
    cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
    cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
    cableUnitTest.Cable_Unit_No__c=String.valueOf(Crypto.getRandomInteger());
        
         Address__c addr  = new Address__c();
    addr.Town__c = 'AH';
    addr.Postcode__c = '421002';
    addr.Door_No__c = '301';
    //addr.Side__c = 'A';
    addr.Floor__c = 'Third';
    addr.House_No__c = 'testData';
    addr.Street__c = 'AH';
    addr.Entrance__c = 'A';
    addr.External_Id__c ='1636835';
    addr.Cableunit_number__c = cableUnitTest.Cable_Unit_No__c;
    insert addr;
        
        
    Account acc1 = new Account();
    acc1.Name = 'TestHierarchy';
    acc1.Type='Hierarki';
    acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
    acc1.Street_YK__c = addr.Id;
    acc1.Street_YK__r = addr;
        controller.setAccount(acc1);
        controller.setCableUnit(cableUnitTest);
        
        controller.saveAccount();
        System.assertEquals(cableUnitTest.id, controller.getAccount().Cable_Unit__c); 
        System.assertEquals(cableUnitTest.id, controller.getCableUnit().id); 
        
         controller.errAccName = '';
    controller.errCblName = '';
    controller.errCblPtIns = '';
    controller.errCblMun = '';
    controller.errCblPCode = '';
    /*Added by Satarupa*/
    controller.errAccNameFlag = false;
    controller.errCblNameFlag  = false;
    controller.errCblPtInsFlag  = false;
    controller.errCblMunFlag  = false;
    controller.errCblPCodeFlag  = false;
    /**/
    controller.errAccSeg  = '';
    controller.errCblHType = '';
    controller.errCblHOwn = '';
    controller.errCblBType  = '';
    controller.errAccSegFlag  = false;
    controller.errCblHTypeFlag  = false;
    controller.errCblHOwnFlag = false;
    controller.errCblBTypeFlag  = false;
     
    }
}