public class clsCustomerHeaderDetail{

    private Account account;
    private Boolean showWarning;
    private String contactInfoWarning;

    Apexpages.StandardController controller;
    
    public clsCustomerHeaderDetail(ApexPages.StandardController controller) {
        this.controller = controller;
        account = (Account) controller.getRecord();
        
        List<Case> cases = [SELECT Id FROM Case
            WHERE AccountId = :account.Id
            AND IsClosed = false
            AND isQueueCase__c = 'True'
            //AND Department__c IN ('YK', 'YKFS', 'YKRB', 'YKRL', 'YKRS')
            LIMIT 1
        ];
        showWarning = cases.size() > 0;
        
        getContactInfoWarning();
        
    }
    
    public Boolean getContactShowWarning() {
        return contactInfoWarning != null;
    }

    public String getContactInfoWarning() {
        Account dbAccount = [SELECT PersonEmail, PersonMobilePhone, No_Email__c FROM Account WHERE Id = :account.Id]; 
        contactInfoWarning = null;
        if (dbAccount.PersonMobilePhone == null) {
            if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
                contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address;
            } else {
                contactInfoWarning = System.Label.No_Mobile_Phone;
            }
        } else if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
            contactInfoWarning = System.Label.No_Email_Address;
        }
        return contactInfoWarning;
    }

    public PageReference save() {
        this.controller.save();
        getContactInfoWarning();
        return Apexpages.currentPage();
    }
    
    public PageReference cancel() {
        this.controller.cancel();
        return Apexpages.currentPage();
    }
    
    //Aben sag
    public Boolean getShowWarning() {
        return showWarning;
    }

    public String getInfo() {
        return getShowWarning() ? System.Label.Yes : System.Label.No;
    }
    //Aben sag
    /*
    public PageReference giftCodes(){
      PageReference pageRef = new PageReference('/apex/GiftCodeSend?accid='+account.Id+'&retURL=%2F'+account.Id);
      //System.debug('/apex/GiftCodeSend?accid='+account.Id+'&retURL=%2F'+account.Id);
      return pageRef;
        
    }
    */
    
    public String getGiftCodesUrl(){
      return '/apex/GiftCodeSend?accid='+account.Id+'&retURL=%2F'+account.Id;
    }
    
    static testMethod void testAll() {
        
        Account acc = new Account(Name = 'Test Account 1', Customer_No__c = '123456789');
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        clsCustomerHeaderDetail controller = new clsCustomerHeaderDetail(new ApexPages.StandardController(acc));
        controller.getGiftCodesUrl();
        controller.getShowWarning();
        controller.getContactShowWarning();
        controller.getContactInfoWarning();
        controller.getInfo();
        controller.cancel();
        controller.save();
        
    }
}