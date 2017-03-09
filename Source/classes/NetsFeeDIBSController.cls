public with sharing class NetsFeeDIBSController {
    
    public boolean isFreeChoicePageFlag{get;set;}
    public String md5Coded2 { get; set; }   
    public String orderId {get; set;}
    public string price {get;set;}//SPOC 2094
    public string customerNo;//SPOC 2094
    public string invoiceNo;//SPOC 2094
    public string cardNum{get;set;} // SUPPORT-4681
    public boolean preauth{get;set;}//SUPPORT-6470
    public NetsFeeDIBSController(){
        isFreeChoicePageFlag = false;
        
        invoiceNo = ApexPages.currentPage().getParameters().get('invoiceNo');//SPOC 2094
        //SUPPORT-6470
        if(invoiceNo==null) {preauth = true;}
        
        customerNo = ApexPages.currentPage().getParameters().get('customerNo');//SPOC 2094
        price = ApexPages.currentPage().getParameters().get('price');//SPOC 2094
        cardNum = ApexPages.currentPage().getParameters().get('card'); // SUPPORT-4681
    }
    
    public void generateMD5Key(){
    
        md5Coded2 = orderId = '';
        NetsFee_DIBS_Settings__c dibsSet = NetsFee_DIBS_Settings__c.getInstance(); 

        //Started coding for SPOC-2094 to append 0 as invoiceNo. should be 4 digits
        if(invoiceNo != null && invoiceNo != '') {
            Integer invoiceLength = invoiceNo.length();
            if(invoiceLength <= 4) {
                for (Integer i = invoiceLength; i < 4; i++) {
                    invoiceNo = '0' + invoiceNo;
                }
            }
        }
        //Ended coding SPOC-2094
        string currencyMD5 = dibsSet.Currency_MD5__c;
        string orderIdMD5 = dibsSet.Order_ID_MD5__c;
        string key1 = dibsSet.Key1__c;
        string key2 = dibsSet.Key2__c;
        string merchant = dibsSet.Merchant_Id__c;
        orderId = dibsSet.Order_Id__c;
        string curr = dibsSet.Currency__c;
        Datetime myDT = Datetime.now(); 
        String myDate = myDT.format('ddMMyyyyhhmmss');
        //orderId += myDate;
        orderId = orderId+'-'+ customerNo+'-'+invoiceNo+'-'+ myDate;//SPOC 2094
        system.debug('orderId ' +orderId);
        String input = key1 + 'merchant=' + merchant + orderIdMD5  + orderId + currencyMD5 + curr + '&amount='+price;
        system.debug('input pppp: ' +input);
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(input)));
        system.debug('md5Coded ' +md5Coded);
        md5Coded = key2 + md5Coded;
        system.debug('md5Coded pppp: ' +md5Coded);
        md5Coded2 = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(md5Coded)));
        
        
        system.debug('md5Coded2 ' + md5Coded2);
    }
}