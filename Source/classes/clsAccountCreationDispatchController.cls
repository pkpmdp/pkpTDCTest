public with sharing class clsAccountCreationDispatchController {
    private Account a;
    private String recordType;
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    // following lines are added by Navneet for populating records from custom settings
	String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;//012200000000nf3
	String customerRecordType2 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID2__c;//012200000000nf3AAA
    
    /*
    Retriving environment unique field ids for address lookup fields. Used to fix an issue 
    when creating customers from the address layout. This address must be passed on to the 
    customer creation layout.
    */    
	public YSFieldIDs__c ysFieldIds = YSFieldIDs__c.getInstance('YSFieldIDs');
	private String ADDRESS_FIELD_ID = ysFieldIds.AddressFieldIdLookup__c; 
    private final ApexPages.StandardController controller;  
    
    public clsAccountCreationDispatchController(ApexPages.StandardController controller) {
        this.controller = controller;
        getRecordType();
    }    
     
    public PageReference getRedir() {     
        PageReference newPage;
               
        /*if (this.recordType == '012200000000nf3'|| this.recordType == '012200000000nf3AAA') {
            newPage = Page.YSCustomerCreate;           
        }*/
        
         if (this.recordType == customerRecordType1 || this.recordType == customerRecordType2) {
            newPage = Page.YSCustomerCreate;           
        }else {
        	if(recordType != null) {
            	newPage = new PageReference('/001/e?retURL=%2F001%2Fo&RecordType='+recordType+'&ent=Account');
            	newPage.getParameters().put('nooverride', '1');
        	} else {
        		newPage = new PageReference('/001/e?retURL=%2F001%2Fo');
        		newPage.getParameters().put('nooverride', '1');
        	}
        	//Fix to maintain adress key when creating new Person Customers from Address page layout
        	String addressLookupId = ApexPages.currentPage().getParameters().get(ADDRESS_FIELD_ID + '_lkid');
        	String addressString = ApexPages.currentPage().getParameters().get(ADDRESS_FIELD_ID);   		
        	if(addressLookupId != null){        		
    			newPage.getParameters().put(ADDRESS_FIELD_ID + '_lkid', addressLookupId);
    			newPage.getParameters().put(ADDRESS_FIELD_ID, addressString);
        	}
        }
        return newPage.setRedirect(true);        
    }
    
    public String getRecordType() {
    	if(ApexPages.currentPage().getParameters().get('RecordType') != null) {
            this.recordType = ApexPages.currentPage().getParameters().get('RecordType');           
        }
        return recordType;
    }
    
    public static testMethod void testController(){
    	YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    	// following lines are added by Navneet for populating records from custom settings
		String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;//012200000000nf3
		String customerRecordType2 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID2__c;//012200000000nf3AAA
	
    	Account acc = new Account();
    	acc.name = 'test account';
    	//acc.RecordTypeId = '012200000000nf3';
    	acc.RecordTypeId = customerRecordType1;
    	acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
    	insert acc;
    	
    	PageReference pageRef = Page.AccountCreationDispatch;
    	pageRef.getParameters().put('RecordType', acc.RecordTypeId);
    	Test.setCurrentPage(pageRef);
    	ApexPages.standardController stdCtrl = new ApexPages.standardController(acc);
    	clsAccountCreationDispatchController controller = new clsAccountCreationDispatchController(stdCtrl);
    	//System.assertEquals('012200000000nf3AAA', controller.getRecordType());
    	System.assertEquals(customerRecordType2, controller.getRecordType());
    	System.assertEquals(Page.yscustomercreate.getURL(), controller.getRedir().getURL());    
        controller.RecordType = 'Ys Test';
        controller.getRedir();
        controller.RecordType = null;
        controller.getRedir();
    }
  
}