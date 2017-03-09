public class clsDriftInfoCustomer{
    //EDM-637 START
    List<String> calloutParameter = new List<String>();
    List<String> calloutValue = new List<String>();
    //EDM-637 END
    public String currentId{get; set;}
    private ProductItem[] existingProducts;
    private ProductItem[] customerArea;
    private String existingProductsXmlResponse;
     private Account account;
     private String currentTab;
     // BIER system hyperlink
    public static string BIER_URL_BASE = 'https://biersys.dk';
     // BIER system hyperlink for active activities
    public static string BIER_URL_AA = BIER_URL_BASE + '/casp_readonly/c_light.cgi?id=';
    // BIER system hyperlink for active errors
    //public static string BIER_URL_AE = BIER_URL_BASE + '/fejl_melder/show.cgi?id=';
    public  string BIER_URL_AE{get;set;} // BIER_URL_BASE + '/fejl_melder/show.cgi?id=';
     // # of Active Activities
    public Integer ActiveActivitiesCount{get; private set;}
    // url for BIER for Active Activity detail
    public String ActiveActivitiesUrl{get; private set;}
    // # of Active Errors
    public list<ActiveErrors__c> ActiveErrorsCount{get; private set;}
    // url for BIER for Active Error detail
    public String ActiveErrorsUrl {get; private set;}
    public string ActiveErrorId{get;private set;}
    public String END_POINT {get;set;}
    public Integer errListCount{get;set;}
    public Integer count{get;set;}
    public boolean isRenderzero{get; set;}//spoc-2360
    public boolean isRenderrepeat{get; set;}//spoc-2360
    public clsDriftInfoCustomer(ApexPages.StandardController controller){       
        	BIER_URL_AE = BIER_URL_BASE + '/fejl_melder/show.cgi?id=';//spoc-2360
            //END_POINT = END_POINT__c.getInstance('END_POINT_YOUPROD2').END_POINT__c;
            END_POINT = 'http://tdcgrouptrial79207.jitterbit.eu/prod';
           this.account = (Account) controller.getRecord();
            List<ActiveActivities__c> lstAA = [SELECT Id, Name, ActiveActivityID__c, Transferred_to_Bier__c FROM ActiveActivities__c WHERE Customer__c = :account.Id];
                this.ActiveActivitiesCount = lstAA == null ? 0 : lstAA.size();
                this.ActiveActivitiesUrl = (lstAA != null && lstAA.size() == 1) ? (lstAA[0].Transferred_to_Bier__c == False ? '#' : BIER_URL_AA + lstAA[0].ActiveActivityID__c): '/apex/ActiveActivitiesPage?CustomerId=' + account.Id;
                List<ActiveErrors__c> lstAE = [SELECT Id, Name, ActiveErrorId__c FROM ActiveErrors__c WHERE Customer__c =: account.Id];
                System.debug('*****latAE****'+lstAE);
               if (lstAE.size()==0)//spoc-2360 start
               {
                   isRenderzero=true;
                   isRenderrepeat=false;
               }
              else
              {
                  this.ActiveErrorsCount =lstAE;
                   isRenderzero=false;	
                   isRenderrepeat=true;
              }
               //spoc-2360 end
               // this.ActiveErrorsCount = lstAE.isEmpty() ? 0 :lstAE[0].ActiveErrorId__c.intValue();  
              this.errListCount =lstAE.isEmpty() ? 0: ActiveErrorsCount.size();
               // this.ActiveErrorsUrl = (lstAE != null && lstAE.size()>1) ? BIER_URL_AE + lstAE[0].ActiveErrorId__c : '/apex/ActiveErrorsPage?CustomerId=' + account.Id;
    }
    public clsDriftInfoCustomer(){
        System.debug('*****currentId****'+currentId);
    }
    public List<ProductItem> getExistingProducts(){
         System.debug('*****currentId****'+currentId);
        if(currentId != null){
            this.account = [SELECT Id, Name, AddressId__c FROM Account WHERE Id=: currentId];
            //END_POINT = END_POINT__c.getInstance('END_POINT_YOUPROD2').END_POINT__c;
            // END_POINT = 'http://tdcgrouptrial79207.jitterbit.eu/prod';
            List<ActiveActivities__c> lstAA = [SELECT Id, Name, ActiveActivityID__c, Transferred_to_Bier__c FROM ActiveActivities__c WHERE Customer__c = :account.Id];
                this.ActiveActivitiesCount = lstAA == null ? 0 : lstAA.size();
                this.ActiveActivitiesUrl = (lstAA != null && lstAA.size() == 1) ? (lstAA[0].Transferred_to_Bier__c == False ? '#' : BIER_URL_AA + lstAA[0].ActiveActivityID__c): '/apex/ActiveActivitiesPage?CustomerId=' + account.Id;
                List<ActiveErrors__c> lstAE = [SELECT Id, Name, ActiveErrorId__c FROM ActiveErrors__c WHERE Customer__c =: account.Id];
             if (lstAE.size()==0)
               {
                   isRenderzero=true;
                   isRenderrepeat=false;
               }
              else
              {
                  this.ActiveErrorsCount =lstAE;
                   isRenderzero=false;
                   isRenderrepeat=true;
              }
             this.errListCount = lstAE.isEmpty() ? 0: ActiveErrorsCount.size();
               // this.ActiveErrorsCount = lstAE == null ? 0 : lstAE;
               // this.ActiveErrorsUrl = (lstAE != null && lstAE.size() > 1) ? BIER_URL_AE + lstAE[0].ActiveErrorId__c : '/apex/ActiveErrorsPage?CustomerId=' + account.Id;
        }
        try{
      //commented for Prod  String url = 'http://213.174.75.100:7890/getDriftInfo?optType=driftInfoCust&amsId='+account.AddressId__c;
      //String url = END_POINT+'/getDriftInfo?optType=driftInfoCust&amsId='+account.AddressId__c;
        currentTab = 'DriftInfoCustomerTab';
         calloutParameter.add('null'); // for optType
         calloutParameter.add('null'); // for amsId
         calloutValue.add('driftInfoCust');
         calloutValue.add(account.AddressId__c);
        existingProductsXmlResponse = clsConnectionUtils_Admin.callout1('getDriftInfo',calloutParameter,calloutValue);
        this.existingProducts = parseProducts(existingProductsXmlResponse);   
        calloutParameter = new List<String>(); //EDM-637
        calloutValue = new List<String>();//EDM-637
            return this.existingProducts;         
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occured calling : driftInfoCust' + e.getMessage()));
            return null; 
        }               
    }
    public List<ProductItem> getCustomerArea(){
        try{
       //commented for prod String url = 'http://213.174.75.100:7890/getDriftInfo?optType=driftInfoCustArea&amsId='+account.AddressId__c;
        //String url = END_POINT+'/getDriftInfo?optType=driftInfoCustArea&amsId='+account.AddressId__c;
        currentTab = 'DriftInfoCustomerAreaTab';
         calloutParameter.add('null'); // EDM-637 for optType
         calloutParameter.add('null'); // EDM-637 for amsId
         calloutValue.add('driftInfoCustArea');
         calloutValue.add(account.AddressId__c);
         existingProductsXmlResponse = clsConnectionUtils_Admin.callout1('getDriftInfo',calloutParameter,calloutValue);
         this.existingProducts = parseProducts(existingProductsXmlResponse);   
        calloutParameter = new List<String>(); //EDM-637
        calloutValue = new List<String>();//EDM-637
        return this.existingProducts;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occured calling : driftInfoCustArea' + e.getMessage()));
            return null;
        }
    }   
    /*private String callout(String url){
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
       // req.setHeader('charset','utf-8'); 
		req.setHeader('Content-Type', 'text/xml,charset=utf-8');
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml,charset=utf-8');
        //res.setHeader('charset','utf-8'); 
        try {
            res = http.send(req);
            System.debug('res: ' + res);
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage());
            ApexPages.addMessage(m);                            
        }
        if (res != null) {
            if (res.getStatusCode() == 200) {
                // Good response 
                String response = res.getBody();
                System.debug('response' + response);
                return response;                
            }
        }
        return null;    
    }*/
    public void setCurrentTab(String tab){
      this.currentTab = tab;
    }
    public String getCurrentTab(){
      return this.currentTab;
    }
    private List<ProductItem> parseProducts(String XmlResponse){       
        List<ProductItem> products = new List<ProductItem>() ;
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()){
                if (reader.getEventType() == XmlTag.START_ELEMENT){
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseProduct(reader);
                        products.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e){
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing xml items: ' + e.getMessage());
            ApexPages.addMessage(m);
            return products;
        }
        return products;
    }
    private ProductItem parseProduct(XmlStreamReader reader){
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT){
                if (reader.getLocalName() == 'row'){
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT){
                    if (reader.getLocalName() == 'AMSID'){
                        reader.next();
                        product.setAmsid(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'DRIFTINFO_ID'){
                        reader.next();
                        product.setDriftInfo_id(checkEmptyElement(reader));
                    }/* else if (reader.getLocalName() == 'KATEGORI_NAVN'){
                        reader.next();
                        product.setKategori_navn(checkEmptyElement(reader));
                    }*/ else if (reader.getLocalName() == 'PRODUKT_NAVN'){
                        reader.next();
                        product.setProdukt_navn(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'NODE'){
                        reader.next();
                        product.setNode(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'SUM_KUNDER'){
                        reader.next();
                        product.setSum_kunder(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'OVERSKRIFT'){
                        reader.next();
                        product.setOverskrift(checkEmptyElement(reader));
                    } else if (reader.getLocalName() == 'VIST_INTERN_REFERENCE'){
                        reader.next();
                        product.setVist_intern_reference(checkEmptyElement(reader));
                    }/* else if (reader.getLocalName() == 'STARTTID') {
                        reader.next();
                        product.setStarttid(checkEmptyElement(reader));
                    }  else if (reader.getLocalName() == 'FORVENTET_SLUTTID') {
                        reader.next();
                        product.setForventet_sluttid(checkEmptyElement(reader));
                    } */
                }
            }
            reader.next();
        }
        return product;
    }
    private String checkEmptyElement(XmlStreamReader reader){
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }               
    public class ProductItem{
        
        public ProductItem() {}
        private String amsid; 
        private String kategori_navn;
        private String produkt_navn;
        private String sum_kunder;
        private String overskrift;
        private String vist_intern_reference;
        private String starttid;
        private String forventet_sluttid;
        private String driftInfo_id; 
        private String node;
        public String getAmsid(){
            return amsid;
        }
        public void setAmsid(String amsid){
            this.amsid = amsid;
        }
        /* public String getKategori_navn(){
            return kategori_navn;
        }
        public void setKategori_navn(String kategori_navn){
            this.kategori_navn = kategori_navn;
        }*/
        public void setNode(String node){
            this.node = node;
        }
        public String getNode(){
            return node;
        }
        public void setDriftInfo_id(String driftInfo_id){
         this.driftInfo_id = driftInfo_id; 
        }
        public String getDriftInfo_id(){
            return driftInfo_id;
        }
        public String getProdukt_navn(){
            return produkt_navn;
        }
        public void setProdukt_navn(String produkt_navn){
            this.produkt_navn = produkt_navn;
        }
        public String getSum_kunder(){
            return sum_kunder;
        }
        public void setSum_kunder(String sum_kunder){
            this.sum_kunder = sum_kunder;
        }
        public String getOverskrift(){
            return overskrift;
        }
        public void setOverskrift(String overskrift){
            this.overskrift = overskrift;
        }
		public String getVist_intern_reference(){
            return this.vist_intern_reference;
        }
        public void setVist_intern_reference(String vist_intern_reference){
            this.vist_intern_reference = vist_intern_reference;
        }
        /*  public String getStarttid() {
            return this.starttid;
        }
         public void setStarttid(String starttid){
            this.starttid = starttid;            
        }
        public String getForventet_sluttid(){
            return this.forventet_sluttid;
        }
        public void setForventet_sluttid(String forventet_sluttid){
            this.forventet_sluttid = forventet_sluttid;            
        } */
   }/**
    * @description: This method is used to Test clsDriftInfoCustomer class.
    */
    @isTest(SeeAllData=true)
      public static void testDriftInfoCustomer(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee System Administrator%']; 
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User testUser = new User(alias = 'standt', email='abc@test.com',title='kunderådgiver',
                                emailencodingkey='UTF-8', lastname='Chokkam', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profiles[0].Id, 
                                timezonesidkey='America/Los_Angeles', username='RamChokam@test.com'); 
        testUser.setOptions(dmo);
        testUser.MID__c = 'M78447VVMP';
        insert testUser;
        Account account = new Account();
                    RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];        
                    account.RecordTypeId =recordType.Id;
                    account.Status_YK__c = 'Active';
                    account.FirstName = 'Temp1';
                    account.LastName = 'Temp';
                    account.Invoice_Test__c = true;
                    account.Customer_response__c = 'Neutral omkring ændring';
                    account.Customer_No__c='344689776';
                    insert account;
        system.runAs(testUser){        
            ApexPages.StandardController standardController = new ApexPages.StandardController(account);
            clsDriftInfoCustomer driftInfoCust =new clsDriftInfoCustomer(standardController);
            driftInfoCust.currentId = account.Id;
            String xmlresponse = '<?xml version="1.0" encoding="UTF-8"?><rowdata><row><AMSID>5925665</AMSID><DRIFTINFO_ID>12518</DRIFTINFO_ID><SUB_ID>1</SUB_ID><KATEGORI_NAVN>Spontan</KATEGORI_NAVN><PRODUKT_NAVN>Alle kunder</PRODUKT_NAVN><NODE>110400000 Region Midtjylland (REG)</NODE><SUM_KUNDER>194761</SUM_KUNDER><OVERSKRIFT>Prob. m. YouBio oprettelse</OVERSKRIFT><VIST_INTERN_REFERENCE/><INTERN_REFERENCE_URL/><SPEAK>0</SPEAK><STARTTID>07-05-2013 15:30</STARTTID><FORVENTET_SLUTTID/><SLUTTID/><LEVETID/><TIMESTAMP>2013-05-07 15:34</TIMESTAMP></row><row><AMSID>5925665</AMSID><DRIFTINFO_ID>12337</DRIFTINFO_ID><SUB_ID>1</SUB_ID><KATEGORI_NAVN>Spontan</KATEGORI_NAVN><PRODUKT_NAVN>Canal8</PRODUKT_NAVN><NODE>751000000 Slet (POP)</NODE><SUM_KUNDER>73844</SUM_KUNDER><OVERSKRIFT>% Canal 8</OVERSKRIFT><VIST_INTERN_REFERENCE/><INTERN_REFERENCE_URL/><SPEAK>0</SPEAK><STARTTID>02-05-2013 08:45</STARTTID><FORVENTET_SLUTTID/><SLUTTID/><LEVETID/><TIMESTAMP>2013-05-02 08:56</TIMESTAMP></row><row><AMSID>5925665</AMSID><DRIFTINFO_ID>12330</DRIFTINFO_ID><SUB_ID>1</SUB_ID><KATEGORI_NAVN>Spontan</KATEGORI_NAVN><PRODUKT_NAVN>TV2</PRODUKT_NAVN><NODE>110000000 Regionsudbud (YouSee) (SA)</NODE><SUM_KUNDER>1154447</SUM_KUNDER><OVERSKRIFT>TV2 melder ingen rettigheder</OVERSKRIFT><VIST_INTERN_REFERENCE/><INTERN_REFERENCE_URL/><SPEAK>0</SPEAK><STARTTID>01-05-2013 19:30</STARTTID><FORVENTET_SLUTTID/><SLUTTID/><LEVETID/><TIMESTAMP>2013-05-02 08:11</TIMESTAMP></row></rowdata>';
            //driftInfoCust.getExistingProducts();
            driftInfoCust.getCustomerArea();
            driftInfoCust.parseProducts(xmlresponse);
            clsDriftInfoCustomer test = new clsDriftInfoCustomer();
            ProductItem pt = new ProductItem();
            pt.getAmsid();
            pt.getVist_intern_reference();
            pt.getOverskrift();
            pt.getSum_kunder();
            pt.getProdukt_navn();
            pt.getDriftInfo_id();
            pt.getNode();
            pt.getAmsid();
            driftInfoCust.getExistingProducts();
            test.setCurrentTab('test');
            test.getCurrentTab();
      }
 }
}