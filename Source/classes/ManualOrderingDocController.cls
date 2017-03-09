public class ManualOrderingDocController{
    String kundensForNavn;        
        private String error;
    public boolean isApexTest;

          public PageReference   print(){
         /*   String newPageUrl = '/apex/ManualOrderPrintPage';
            
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put('docType' , docType);
            newPage.setRedirect(false);
            Pagereference pr = Page.ManualOrderPrintPage;
            Blob b = pr.getcontent();
                    
            Document receipt = new Document();
            receipt.folderId = [select id from folder where Name='Customer Form Documents'].id;
            receipt.Name = kundensForNavn!=''?kundensForNavn:receipt.folderId;
            receipt.Name = receipt.Name + '.pdf';
            receipt.body = b;
            System.debug('receipt->'+receipt);
            insert receipt;     */      
            String newPageUrl = '/apex/ManualOrderPrintPage';
            
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put('docType' , docType);
            return newPage;
          }

   String longDate = ' ';

   // Init cLongDate with the current Datetime in long date format    
   public String getLongDate() {
    Datetime cDT = System.now();
    longDate = cDT.format('d-MM-yyyy');
    return longDate;
   }

   public commonclass objCommon = new commonclass();  
    public string dealerName{
        get {
                        try
                        {
                                return objCommon.userContact.LastName;
                        }
                        catch(Exception ex)
                        {
                                return null;
                        }
                 }
    }
    public string dealerNumber{
        get { 
                        try
                        {
                                return objCommon.dealerAccount.Dealer_Number__c;
                        }
                        catch(Exception ex)
                        {
                                return null;
                        }
                }
    }
        
    public void sendMail() {
     getOrderingList();
            ApexPages.Message errorMsg = null;
            orderList  = customOrderingList;
            for(cManualOrderingDocument m : orderList){
                    if(m.document.Required__c == true && (m.document.FieldValue__c == '' ||m.document.FieldValue__c == null)){
                       // errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter '+m.document.Description__c);
                          //  ApexPages.addMessage(errorMsg);
                         //   return new PageReference('/apex/ManualOrdersPage');
                    }
            }
            sendUserMailAttachPdf();
            customOrderingList.clear();
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Mail er sendt til forhandlersupport. Print blanket');
            ApexPages.addMessage(myMsg);
           System.Debug('Testing redirect');
          }


    public PageReference back() {
        String newPageUrl ='/apex/ManualFormsPage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }


    private String documentURL;
    public string menuURL {get;set;}
    public String formHeader { get; set; }
    public List<ManualOrderingDocument__c> orderingList = null;
    public List<cManualOrderingDocument> customOrderingList = null;
    public List<cManualOrderingDocument> orderList = null;
    public string newDocType;   
    public string userName; 
   // String[] toAddresses = new String[] {'vishalnayak79@gmail.com'}; 
   // String[] ccAddresses = new String[] {'martin_hay_019198@gmail.com'};
   
    public String DocumentID { get; set; }
    public String DocumentUploaded { get; set; }
    public string docType;
    public string docText;
    public string docFlag{get;set;}
    
    public String getDocumentURL(){
         return documentURL;  
     }   
     public void setDocumentURL(String documentURL){        
        this.documentURL =documentURL;    
     }
     
      public String printURL {get;set;}
      public Blob body {get;set;}
     
      public string ControllerCall {get;set;}
      public string printFlag{get;set;}
      public List<Document> manualDoc { get; set; }
    
     public ManualOrderingDocController(){
        isApexTest = false;
        system.debug('body--->'+body);
        if(controllerCall == 'true'){
            System.debug('Called from brodband');   
        }
        
        printFlag='false';
        userName=Userinfo.getName();
        docType = apexpages.currentpage().getparameters().get('docType');
       docText = apexpages.currentpage().getparameters().get('docTypeText'); 
        System.debug('docType--->' + docType);
        System.debug('docText--->' + docText);

        formHeader  ='Bestilling af ' + docText;
        getManualDocument();
        objCommon.setDealerInfo();
        DocumentUploaded= 'false'; 
     }
    
    public List<cManualOrderingDocument> getCustomOrderingList(){
        List<SelectOption> optionsRadioButton = new List<SelectOption>(); 
        
        if(orderingList == null){
            docFlag = 'true';
            customOrderingList = new  List<cManualOrderingDocument>();
            
            // will fetch records based on document type & order by sequence number  
            orderingList =  [Select m.Description__c, m.FieldType__c, m.Required__c, m.Font__c, m.Font_Color__c, m.FontStyle__c, m.Font_Size__c, 
            m.FontStyling__c, m.FieldValue__c, m.Name,  m.SequenceNumber__c 
            from ManualOrderingDocument__c m where m.ManualOrderDocument__c =:docType order by SequenceNumber__c]; 
            
            system.debug('orderingList-->' + orderingList.size()+'Ordering List'+orderingList);
            Integer listSize = orderingList.Size();
            
            if(listSize == 0){
                docFlag = 'false';  // Needed to display message to the end user
            }
            else{
                boolean prevRecordRadioButton = false; // to track if the radiobutton was present in the prev record
                ManualOrderingDocument__c manualOrderingTemp; // used to persist information        
                Integer currentRecord = 1;
                for(ManualOrderingDocument__c m : orderingList){ // used for customizing the page 
                    System.debug('ManualOrderingDocument__c - '+m);
                    if(m.FieldType__c == 'RadioButton'){ // validate if the field type is radio button 
                        // We add to the customOrderingList when we reach to the last item of the Radio Buttons     
                        // In this Loop we just add it to the optionsRadioButton list
                        // We have to do this because we have to group all the radio buttons
                        if(m.Description__c != null){
                        optionsRadioButton.add(new SelectOption(m.Description__c,m.Description__c)); 
                        }else{
                            optionsRadioButton.add(new SelectOption('',''));
                        }
                        manualOrderingTemp = m;  // used to persist this information so that it is used when we reach last node
                        prevRecordRadioButton = true; // indicates that radiobutton loop begins here
                        if(currentRecord == listSize){ 
                            customOrderingList.add(new cManualOrderingDocument(manualOrderingTemp, optionsRadioButton));
                            System.debug('$customOrderingList$'+customOrderingList);             
                            
                        }
                    }else if(m.FieldType__c != 'RadioButton' && prevRecordRadioButton == true){
                        // this is where we reach the last node of the item in the Radio Button List.
                        // Now it is ready to be added to the final list
                         customOrderingList.add(new cManualOrderingDocument(manualOrderingTemp, optionsRadioButton));
                         // This indicates that the Radio Button Loop has ended & now you are entering a new field type
                         prevRecordRadioButton = false; 
                         optionsRadioButton = new List<SelectOption>(); // This will refresh the option list
                        // We have now two list to be added. One for the Radio Button & now one for the new fieldType 
                         customOrderingList.add(new cManualOrderingDocument(m, null));
                         System.debug('$customOrderingList###$'+customOrderingList);
                    }   //  
                    else if(m.FieldType__c != 'RadioButton' && prevRecordRadioButton == false ){
                        // this is where the field type is not Radio Button 
                        // & the list have never come accross field of type Radio Button.
                        // used for applying style class
                         m.FontStyling__c = 'color:' + m.Font_Color__c + '; ' + 'font-size:' 
                         + m.Font_Size__c + 'px; ' + 'font-family: ' + m.Font__c+';'        
                        + 'font-style: ' + m.FontStyle__c + ';' + 'font-weight: ' + m.FontStyle__c + ';';
                        customOrderingList.add(new cManualOrderingDocument(m, null));
                        System.debug('$customOrderingList###$'+customOrderingList);
                    }
                  
                    currentRecord = currentRecord + 1; 
                } 
            }
        }             
         system.debug('customOrderingList-->' + customOrderingList);
         
         
        return customOrderingList;
    }
    
    public List<cManualOrderingDocument> getOrderingList(){
            List<cManualOrderingDocument> orderslist = new List<cManualOrderingDocument>();
            if(customOrderingList!=null){
            for(cManualOrderingDocument m : customOrderingList){
                    if(m.document.FieldType__c == 'RadioButton'){
                            List<SelectOption> items = m.optionItems; 
                            for(SelectOption option : items){
                                 cManualOrderingDocument doc = new cManualOrderingDocument();
                                 doc.document = m.document;
                                 doc.document.FieldType__c = 'RadioButton';
                                 doc.fieldValue = m.document.FieldValue__c;
                                 doc.description = option.getValue();
                                 orderslist.add(doc); 
                            }
                    }else {        
                            orderslist.add(m);  
                    }                
            } 
    }
            System.debug('orderslist from broadband--->' + orderslist);
            return orderslist;
    }

	//These fields belongs to "Dealerweb_OrderedProduct_Report" Object.
	String kundensAdresse = ''; 
    String kundensPostnr = ''; 
    String kundensBy = ''; 
    String KundensFornavnValue = '';	
    String KundensEfternavn = ''; 
    String KundensEmail = ''; 
    String KundensMobilnr = ''; 
    
    public PageReference savePdf() {
        ApexPages.Message myMsg;
         try{
            getOrderingList();
            ApexPages.Message errorMsg = null;
            orderList  = customOrderingList;
            for(cManualOrderingDocument m : orderList){
            	if(m.document.Description__c.contains('Kundens adresse (vej/husnr./etage)')){
                    kundensAdresse = m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Kundens postnr')){
                    kundensPostnr = m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Kundens by')){
                    kundensBy= m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Kundens fornavn')){
                    KundensFornavnValue = m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Kundens efternavn')){
                    KundensEfternavn = m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Evt. kundens e-mail')){
                    KundensEmail = m.document.FieldValue__c;
                }
                if(m.document.Description__c.contains('Kundens tlf.nr')){
                    KundensMobilnr = m.document.FieldValue__c;
                }
                if(m.document.FieldType__c == 'TextBox' && m.document.Description__c == 'Kundens fornavn'){
                    kundensForNavn = m.document.FieldValue__c;
                }
                if(m.document.Required__c == true && 
                   (m.document.FieldValue__c == '' ||m.document.FieldValue__c == null)
                   && (m.document.FieldType__c != 'Text')){
                    this.error = 'Please enter '+m.document.Description__c;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                    ApexPages.addMessage(msg);
                    return new PageReference('/apex/ManualOrdersPage');
                }
            }
                        
            System.debug('kundensAdresse ------------------------------>' + kundensAdresse);
            System.debug('kundensPostnr ------------------------------>' + kundensPostnr);
            System.debug('kundensBy ------------------------------>' + kundensBy);
            System.debug('KundensFornavnValue ------------------------------>' + KundensFornavnValue);
            System.debug('KundensEfternavn ------------------------------>' + KundensEfternavn);
            System.debug('KundensEmail ------------------------------>' + KundensEmail);
            System.debug('KundensMobilnr ------------------------------>' + KundensMobilnr);
            
            sendUserMailAttachPdf();
            String newPageUrl = '/apex/ManualOrderPrintPage';
            
            PageReference newPage = new PageReference(newPageUrl);
            newPage.getParameters().put('docType' , docType);
            newPage.setRedirect(false);
            Pagereference pr = Page.ManualOrderPrintPage;
            Blob b;
            if(!isApexTest){
                b = pr.getcontent();
            }
            else    
                b =  Blob.valueof('Dummy Content in email body for Apex Test Run');    
            Document receipt = new Document();
            receipt.folderId = [select id from folder where Name='Customer Form Documents'].id;
            receipt.Name = kundensForNavn!=''?kundensForNavn:receipt.folderId;
            receipt.Name = receipt.Name + '.pdf';
            receipt.body = b;
            System.debug('receipt->'+receipt);
            insert receipt;
            
        }catch(Exception e){
            System.Debug('Error--->'+ e.getMessage());
        }
        myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Mail er sendt til forhandlersupport. Print blanket');
        ApexPages.addMessage(myMsg); 
        String newPageUrl = '/apex/PrintManualOrder';
        PageReference newPage = new PageReference(newPageUrl);
        return newPage;
     }

    public void sendUserMailAttachPdf(){
            system.debug('SendMail');
            PageReference pdf = new PageReference('/apex/BroadBandTemplate'); //fGeneratorTemplate;
            if(!isApexTest){
            	system.debug('before getContent Call');
                body = pdf.getContent();
                system.debug('After getContent Call');
            }
            else
                body =  Blob.valueof('Dummy Content in email body for Apex Test Run');
            
            
            //uploadDocument(body);
            
            Messaging.EmailFileAttachment emailattach = new Messaging.EmailFileAttachment();
            emailattach.setContentType('application/pdf');
            string strSubject = 'Bestilling af YouSee ' + newDocType;
            emailattach.setFileName(newDocType + '.pdf');
            emailattach.setInline(false);
            emailattach.Body = body;
            String[] toAddresses;
            String value;
            YouSeeCustomSettings__c toAddressSetting = YouSeeCustomSettings__c.getValues('DealerWeb.Bestil_Varer.TO_ADDRESSES');
            
            if(toAddressSetting != null && toAddressSetting.Setting_Value__c != null) {
                value = toAddressSetting.Setting_Value__c;
                toAddresses = value.split(';');
            }
            
            //String[] toAddresses = toAddressSetting.Setting_Value__c.split(';');
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            // Assign the addresses for the To and CC lists to the mail object.  
            mail.setToAddresses(toAddresses);
            // mail.setCcAddresses(ccAddresses);
            mail.setSubject(strSubject);
            string strBody;
            strBody= ' Hi , '; 
            strBody= strBody+' Kindly find the ' + newDocType + ' form attached with the mail. <br>';
            strBody= strBody+ '<br></br>';
            strBody= strBody+' Regards, <br>';
            strBody= strBody+ userName +'<br>';
            mail.setHtmlBody(strBody);
            //Id emailTemplateId = [select Id from EmailTemplate where Name = 'YouSee Dealer Web: Manual Orders'].Id;
            //mail.setTemplateId(emailTemplateId);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { emailattach});
         
            //Commented for testing other funcationality.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            addProductForReport();
    }
    
    private string setNewDocType(){
       //Setting type name according to doc folder
       if(docText == 'YouSee Bredbånd'){
            newDocType='YouSee Bredband';
       }else if(docText == 'YouSee Telefoni'){
            newDocType='YouSee_Telefoni';
       }else if(docText == 'YouSee Plus'){
            newDocType='Digitalt kabel-tv';
       }else if(docText == 'YouSee Clear'){
            newDocType='YouSee Clear';
       }else if(docText == 'YouSee Ekstrakanaler'){
            newDocType='YouSee Ekstrakanaler';
       }else if(docText == 'Ombyt lejeboks'){
            newDocType='YouSee lejeboks';
           
       }else{
            newDocType = docText;
       }
      
       return newDocType;
    }
    
    public void  getManualDocument(){ 
        ApexPages.Message debugMsg = null;
        documentURL='';
        
        string dType=  setNewDocType();
        System.debug('Document Type --------------------------> '+ dType);
         manualDoc = [Select  d.Id,d.BodyLength From Document d where d.Name =: dType limit 1 ];      
        if(manualDoc.size() > 0){  
            String documentId = manualDoc[0].Id;    
            system.debug('### Doc Id :'+ documentId); 
            documentURL = '/servlet/servlet.FileDownload?file='+documentId;   
            setDocumentURL(documentURL);    
        }
        /*else{ 
            debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is an Error retriving the Document currently,please try again later');  
            ApexPages.addMessage(debugMsg);    
        } */       
    }    
  
    public class cManualOrderingDocument{
            public List<SelectOption> optionItems {get; set;} 
            public String fieldType {get; set;} 
            public String description {get; set;} 
            public String fieldValue{get; set;} 
            public ManualOrderingDocument__c document {get; set;}
            public cManualOrderingDocument(){
            }
            public cManualOrderingDocument(ManualOrderingDocument__c doc, List<SelectOption> options){
                    document  = doc;
                    optionItems = options;
            }
    }
    //ADD FOR ISSUE NO JIRA-837
    
   Private void addProductForReport(){
        system.debug('This is my addProductForReport  objCommon.dealerAccount'+objCommon.dealerAccount+'---------newDocType is '+newDocType);
        String pdktCtogry ='';
        List<String> proStrngLst = new List<String>();
        proStrngLst = newDocType.split(' ');
        Integer lastStr = proStrngLst.size();
        pdktCtogry =proStrngLst[lastStr-1];
        Dealerweb_OrderedProduct_Report__c productReport = new Dealerweb_OrderedProduct_Report__c();
        productReport.Dealer__c = objCommon.dealerAccount.Id;
        productReport.Date__c = Date.today();
        productReport.ProductCategory__c = pdktCtogry;
        productReport.Sales_Channel__c = 'Blanketter';
        productReport.KundensAdresse__c = kundensAdresse;
    	productReport.KundensPostnr__c = kundensPostnr;
    	productReport.KundensBy__c = kundensBy;
    	productReport.Kundens_fornavn__c = KundensFornavnValue;
    	productReport.Kundens_efternavn__c = KundensEfternavn;
    	productReport.Kundens_email__c = KundensEmail;
    	productReport.Kundens_mobilnr__c = KundensMobilnr;
    	
        system.debug('This is my addProductForReport  objCommon.dealerAccount'+objCommon.dealerAccount+'---------pdktCtogry is '+productReport);
        try{
            insert productReport;
        }catch(Exception ex){
            system.debug('there is an exception in addProductForReport----'+ex.getMessage());
        }
    }
}