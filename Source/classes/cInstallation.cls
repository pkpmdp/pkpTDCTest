public class cInstallation {
    public Net_Installations__c installation{get; set;}  
    public Subscription__c subscription{get;set;}  
    public boolean selected{get; set;}
    public String tvpackage {get; set;}
    public String packageChangedDate {get; set;} 
    public Boolean selectedmyBeboer {get; set;}
    public String myBebeorTxt {get; set;}
    public List<SelectOption> optionsPackages {get; set;}
    public String futureSubsPackage{get; set;}
    public String effectiveDate {get; set;}
    public String effectiveEndDate {get; set;}  
    public String productName {get; set;}
    public Boolean checkBlandSelv{get; set;}
    public String blandSelvEmailID{get; set;}
    
    /**Added by sagar **/
    public String amsId{get; set;}
    public String formatAddress{get; set;}
    
    /*public String formattedAddressName{get; set;}
    public String formattedHouseNo{get; set;}*/
    public String currentProduct{get; set;}
    public String installationLbnr;
    public String errorFlag{get; set;}
    public String errorCode;
    public String errorMessage;
    public List<cProducts> productsList{get; set;}
    public List<String> nybeborList{get; set;}
    public String nybeboerHref{get; set;}
    public String nybeboerMediaType{get; set;}
    public Boolean nybeboerFlag{get; set;}
    public String existingSortering{get; set;}
    
    //Added sc-413 error scenario
    public boolean errorSubscFlag{get;set;}
    public Integer countSubscFlag {get; set;}
    public Integer testFlag {get; set;}
    public Integer subsCount {get; set;}
     
    public Boolean checkValidate{get; set;} 

        public boolean isBadPayee{get;set;}    //Added for bland selv phase 2 b


    public class cProducts{
        public String prodName;
        public String productNo;
        public String href;
        public String mediaType;
        public String sortering;
    } 
    /**Added by sagar **/
    
    
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('cInstallation','Change tv-package');
    public cInstallation(){
            
    }
    
   public cInstallation(Net_Installations__c inst, Subscription__c subscription) {
        this.subscription = subscription;
        installation = inst;
        //getformattedAddressName();
        //getformattedHouseNo();
        selected = false;
    }
 
   //added
    public cInstallation(Subscription__c subscription) {
        this.subscription = subscription;
        
        selected = false;
    }
  public cInstallation(Net_Installations__c inst) {
        installation = inst;
        selected = false;
        checkBlandSelv = false;
    }
    public String getFormattedAddress(){
        String addressString = installation.Address__r.Name == null ?  '' : installation.Address__r.Name;
        addressString = addressString+ (installation.Address__r.House_No__c == null ?  '' : (installation.Address__r.Name != null ? ' '+installation.Address__r.House_No__c : installation.Address__r.House_No__c));
        addressString = addressString+(installation.Address__r.Entrance__c == null ?  '' : (addressString != null ? ', opgang ' + installation.Address__r.Entrance__c : 'opgang ' + installation.Address__r.Entrance__c));
        addressString = addressString+(installation.Address__r.Floor__c == null ?  '' : (addressString != null ? ', '+installation.Address__r.Floor__c : installation.Address__r.Floor__c));
        //addressString = addressString+(installation.Address__r.Side__c == null ?  '' : (installation.Address__r.Floor__c != null ? ' '+installation.Address__r.Side__c : (addressString != null ? ', '+installation.Address__r.Side__c : installation.Address__r.Side__c)));
      //addressString = addressString+(installation.Address__r.Door_No__c == null ?  '' : (addressString != null ? ' dør ' + installation.Address__r.Door_No__c : 'dør '+installation.Address__r.Door_No__c));
        addressString = addressString+(installation.Address__r.Door_No__c == null ?  '' : ((addressString != null && installation.Address__r.Floor__c != null) ? ' Side/dørnr. ' + installation.Address__r.Door_No__c : (addressString != null ? ',Side/dørnr. '+installation.Address__r.Door_No__c:'Side/dørnr. '+installation.Address__r.Door_No__c )));
        addressString = addressString+(installation.Location__c == null ?  '' : (addressString != null ? ', '+installation.Location__c :installation.Location__c));
        addressString = addressString+(installation.Address__r.PostCode__c == null ?  '' : (addressString != null ? ', '+installation.Address__r.PostCode__c :installation.Address__r.PostCode__c));
        addressString = addressString+(installation.Address__r.Town__c == null ?  '' : (installation.Address__r.PostCode__c != null ? ' '+installation.Address__r.Town__c : (addressString != null ? ', '+installation.Address__r.Town__c : installation.Address__r.Town__c)));
        addressString = addressString+(installation.Address__r.District__c == null ?  '' :(addressString != null ? ', '+installation.Address__r.District__c:installation.Address__r.District__c));
        addressString = addressString+(installation.Address__r.Street__c== null ?'' :(addressString != null ? ', '+installation.Address__r.Street__c:installation.Address__r.Street__c));
        formatAddress = addressString.substring(0, addressString.length());
        return addressString.substring(0, addressString.length());
    }
    
    public String getCurrentProductName(){
       currentProduct = subscription.Product__r.Name;
       return subscription.Product__r.Name;
    }
    
    public String getFullAddress(){
       return installation.Address__r.Full_Address__c;  
    }
    
    /*public String getFinalAddress(){
      return installation.FullAddress__c;
    }*/
    
    
    /*
    public String getformattedAddressName(){
      String addressString1 = installation.Address__r.Name == null ?  '' : installation.Address__r.Name;
      //addressString1 = addressString1+ (installation.Address__r.House_No__c == null ?  '' : (installation.Address__r.Name != null ? ' '+installation.Address__r.House_No__c : installation.Address__r.House_No__c));
      formattedAddressName = addressString1.substring(0, addressString1.length());
      System.debug('####formattedAddressName'+formattedAddressName);
      return formattedAddressName;
    }
    
    public String getformattedHouseNo(){
      String addressString2 = installation.Address__r.House_No__c == null ?  '' : installation.Address__r.House_No__c;
      formattedHouseNo = addressString2.substring(0, addressString2.length());
      System.debug('####formattedAddressName'+formattedHouseNo);
      return formattedHouseNo;
    }*/
}