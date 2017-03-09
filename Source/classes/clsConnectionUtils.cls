public class clsConnectionUtils {
    public static final String END_POINT =
        END_POINT__c.getInstance('END_POINT_YOUPROD2') != null ?
        END_POINT__c.getInstance('END_POINT_YOUPROD2').END_POINT__c + '/' :
        null
    ;
    public static final String EXISTING_PRODUCTS_CUSTOMERS_METHOD = 'YK7Inbound';
    public static final String EXISTING_PRODUCTS_ADDRESSES_METHOD = 'YK8Inbound'; 
    public static final String POTENTIAL_PRODUCTS_ADDRESSES_METHOD = 'YK6Inbound';
    public static final String OVERNIGHT_PRODUCTS_CUSTOMERS_METHOD = 'YK5Inbound';
    public static final String SAS_PRODUCTS_CUSTOMERS_METHOD = 'SAS_Churn';
    public static final String CAMPAIGN_HISTORY_CUSTOMERS_METHOD = 'YK13InboundCustomer';
    public static final String CAMPAIGN_HISTORY_LEADS_METHOD = 'YK13InboundLead';
    public static final String OVERNIGHT_PRODUCTS_RESPONSE_METHOD = 'YK5Update'; 
    public static final String SAS_PRODUCTS_RESPONSE_METHOD = 'SAS_Churn_Update'; 
    public static final String UPDATE_CASPER_METHOD = 'YK9_FindInCasper';
    public static final String UPDATE_CASPER_ADDRESS_METHOD = 'YK9_FindInCasperAddress';
    public static final String EXISTING_ACTIVITY_LOGS_METHOD = 'YK3getCustomerInquiries';
    public static final String ADD_ACTIVITY_LOG_METHOD = 'YK3addCustomerInquiry';
    public static final String MOBILEBB_METHOD = 'GetMobbForbrug';
    public static final String NEW_CAMPAIGN_HISTORY_CUSTOMER = 'ContactHistoryInboundCustomer';
    public static final String NEW_CAMPAIGN_HISTORY_LEAD = 'ContactHistoryInboundLead';
    public static final String CASE_SEARCH_BY_ANLAEGNR = 'GetDebitorInbound';
    public static final String New_SAS_PRODUCTS_RESPONSE_METHOD = 'UpdateSASOffers';
    public static final String New_SAS_PRODUCTS_CUSTOMERS_METHOD = 'GetSASOffers';
    public static final String REPROVISION_METHOD = 'getCustomerProductGroup';
    public static final String MDB_BUTTON_METHOD = 'getCasperId';
    public static final String LATEST_PRODUCT_USAGE_METHOD = 'getProductLatestUsages';
    public static final String QUICK_PRODUCT_INFO_METHOD = 'getSPOC21Activities';
    public static final String SMS_SERVICE_METHOD = 'SPOC440SMSMockup';
    public static final String CABLEUNITNOTE_METHOD = 'getAnlaegBemaerkninger';
    public static final String ORDER_INFO_SPOC_WEASEL_METHOD = 'getOrderInfo';
    public static final String CUSTOMER_ADDRESSES_METHOD = 'getCustomerAddress';
}