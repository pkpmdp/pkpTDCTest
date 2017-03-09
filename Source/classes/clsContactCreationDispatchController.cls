public class clsContactCreationDispatchController {
    private Contact c;
    @TestVisible
    private String recordType;
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
    private final ApexPages.StandardController controller;
    private String customerID;
     public YSFieldIDs__c ysFieldIds = YSFieldIDs__c.getInstance('YSFieldIDs');
    private String CUSTOMER_FIELD_ID = ysFieldIds.ExternalRoleCustomerLookup__c;  

    public clsContactCreationDispatchController(ApexPages.StandardController controller) {
        this.controller = controller;
        getRecordType();
        c = (Contact)controller.getRecord();
        String testSandboxcustomerID = ApexPages.currentPage().getParameters().get('CF00N20000002KVQ9_lkid');
        String prodcustomerID = ApexPages.currentPage().getParameters().get('saveurl');
        if(prodcustomerID != null) {            
            customerID = prodcustomerID.substring(1);
        } else
            customerID = testSandboxcustomerID;
    }
    
    public String getRecordType() {
      if(ApexPages.currentPage().getParameters().get('RecordType') != null) {
            this.recordType = ApexPages.currentPage().getParameters().get('RecordType');           
        }
        return recordType;
    }
    
     public PageReference getRedir() {     
        PageReference newPage;
                       
        if (this.recordType == ysContactRecordType) {
            system.debug('*******Wen recordType is specified as YS contact');
           String saveURL = EncodingUtil.URLENCODE('/apex/MasseACRFromContact?rlaccid='+customerID, 'UTF-8');
           newPage = new PageReference('/003/e?saveURL='+saveURL+'&RecordType='+recordType+'&ent=Contact');
           newPage.getParameters().put('nooverride', '0');
           newPage.getParameters().put('rlaccid', customerID);
        }else {
          if(recordType != null) {
              system.debug('*******Wen recordType is specified as other contact');
              newPage = new PageReference('/003/e?retURL=%2F003%2Fo&RecordType='+recordType+'&ent=Contact');
              newPage.getParameters().put('nooverride', '1');
          } else if(recordType ==null && isYSContactDefault()){
              system.debug('*******Wen recordType is not specified but user has default YS contact ');
              String saveURL = EncodingUtil.URLENCODE('/apex/MasseACRFromContact?rlaccid='+customerID, 'UTF-8');
              newPage = new PageReference('/003/e?saveURL='+saveURL+'&RecordType='+ysContactRecordType+'&ent=Contact');
              newPage.getParameters().put('nooverride', '0');
              newPage.getParameters().put('rlaccid', customerID);
              System.debug('*****Wen send parameters'+customerID);
          } else {
              system.debug('*******Wen all the other cases');
              newPage = new PageReference('/003/e?retURL==%2F003%2Fo&ent=Contact');
              newPage.getParameters().put('nooverride', '1'); 
          }
        }
        return newPage.setRedirect(true);        
    }
    @TestVisible
    private boolean isYSContactDefault() {
        String defaultRecordType='';
        Schema.DescribeSObjectResult describeOpp = Schema.SObjectType.Contact;    
        List<Schema.RecordTypeInfo> rtInfos = describeOpp.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtInfo : rtInfos) {
            if(rtInfo.isDefaultRecordTypeMapping()) {               
                defaultRecordType = rtInfo.getRecordTypeId();
                break;
            }
        }
        System.debug('******Wen default'+defaultRecordType);
        String id15Digit = defaultRecordType.substring(0, 14); 
        String id15DigitStandard = ysContactRecordType.substring(0, 14); 
        if(id15Digit == id15DigitStandard)
            return true;
        else 
            return false;    
    }

}