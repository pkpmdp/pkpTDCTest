public class SaveSurveyExtension {
    private String customerId;
    private String customerName;
    private String recordType;
    private String ent;
    private String redirectURL;
    public SaveSurveyExtension(ApexPages.StandardController controller) {
      customerId = ApexPages.currentPage().getParameters().get('CF00N20000001Wv4U_lkid');
      customerName = ApexPages.currentPage().getParameters().get('CF00N20000001Wv4U'); 
      recordType = ApexPages.currentPage().getParameters().get('RecordType');
      ent = ApexPages.currentPage().getParameters().get('ent');      
    }
     
    public void setCustomerId(String customerId) {
      this.customerId = customerId;
    }
     
    public void setCustomerName(String customerName) {
      this.customerName = customerName;
    }  
     
    public void setRecordType(String recordType) {
      this.recordType = recordType;
    }   
     
    public void setEnt(String ent) {
      this.ent = ent;
    }  
     
    public String getRedirectURL() {
      return this.redirectURL;
    }    
         
    public PageReference redirectToSave(){
        /* Builds URL to open standard SAVE page. Save page takes parameters from URL and acts according to them.
         *
         * Purpose of parameters:
         * ----------------------
         * CF00N20000001Wv4U - customer name field on SAVE page to prefill value
         * CF00N20000001Wv4U_lkid - customer id field on SAVE page
         * retURL - return URL, suppose to specify URL where user should be redirected after save but it does NOT work
         * recordType - record type to generate SAVE page according to
         * ent - unknown sense
         * saveURL - URL where should be user redirected after save, works perfect
         */
          
        PageReference pageReference = null;
        String name = customerName;
        if (name != null && name.contains('&')) {
            // Encode '&' to '%26'
            name = name.replace('&', '%26');
        }
        redirectURL = '/a0F/e?nooverride=1&CF00N20000001Wv4U='+name+
        '&CF00N20000001Wv4U_lkid='+customerId+
        '&retURL='+customerId +
        '&RecordType='+recordType+
        '&ent='+ent+
        '&saveURL='+customerId;
        pageReference = new PageReference(redirectURL);
                 
        return pageReference;     
     
    }
     
    static testMethod void testSaveSurveyExtension() {
      SaveSurveyExtension ext = new SaveSurveyExtension(null);
      ext.setCustomerName('Jim Carrey');
      ext.setCustomerId('1234');
      ext.setRecordType('ABC');
      ext.setEnt('000');
       
      System.assertNotEquals(null,ext.redirectToSave());
      System.assertEquals('/a0F/e?nooverride=1&CF00N20000001Wv4U=Jim Carrey'+
        '&CF00N20000001Wv4U_lkid=1234'+
        '&retURL=1234'+
        '&RecordType=ABC'+
        '&ent=000'+
        '&saveURL=1234', ext.getRedirectURL());
    }   

    static testMethod void testSaveSurveyExtensionAmp() {
        // Test if the code can handle ampersands
        SaveSurveyExtension ext = new SaveSurveyExtension(null);
        ext.setCustomerName('CHRISTIAN BAUN & LOUISE SCHOU');
        ext.setCustomerId('1234');
        ext.setRecordType('ABC');
        ext.setEnt('000');
        System.assertNotEquals(null,ext.redirectToSave());
        System.assertEquals('/a0F/e?nooverride=1&CF00N20000001Wv4U=CHRISTIAN BAUN %26 LOUISE SCHOU'+
            '&CF00N20000001Wv4U_lkid=1234'+
            '&retURL=1234'+
            '&RecordType=ABC'+
            '&ent=000'+
            '&saveURL=1234', ext.getRedirectURL()
        );
    }
}