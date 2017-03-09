/****************************************************************************************
  hardware ws call - search for the serial number
First check for status, allowed status are 'disponibel' ,'Transit' and 'UNDER_OMBYTNING'
    if one of above mentioned status then take rel value.
    rel could be "Ombtying"/Indlevering
    ombtying  - customer has chosen to deliver box at dealer shop
    indlevering means - customer will get new box from yousee through mail.
check for lokation , if it starts with 'T', then it indicates box is aleady with Delaer, cannot exchange it.
                     if it starts  with 'DISTRBU', in indicates box is with Distributor , cannot exc it.
                     
check for ombytning-godkendt field , this field indicate whether exchanged order found or not, in case of indlevering , do not check for this field.

If ombtying and other above criteria are satisfied then dealer will give the new serial box to customer , for that he will first enter new serial box and check for approval .
    call first ws call again ,and this time check take the lokation from response , and compare that with the logged in dealer, if matches then serial number is approved.
    
Incase of Indelevering we do not enter the new serial box number    
  
*****************************************************************************************/

public class DealerExchangeInShop {
        
        public string SerialNo{set;get;}
        public string newSerialNo{set;get;}
        public boolean flag = false;
        boolean validated = false;
        public boolean DisPBoxCondParam{set;get;} 
        public boolean CustInfoRendering{set;get;}
        public boolean DisplayNewSerialNumber{set;get;}
        public string Errorvalue{set;get;}
        //String returnBoxCond = null;
        public string returnBoxCond{set;get;}
        public boolean showComment{set;get;}
        public string damageComment{set;get;}
        string SerialNovar; 
        public String DealeraddressString1 = '';
        public String DealeraddressString2 = '';
        public string SellerNumber{set;get;}
        string AgentNumber;
        public string OptionalTextArea3{set;get;}
        public string OptionalTextArea4{set;get;} 
         List<ForhandlerInformations__c> forhandlerIndormationLst = new List<ForhandlerInformations__c>();
        List<forhandlerInformationWrapper> wrapperClassLst = new List<forhandlerInformationWrapper>();
        public string ToptextArea1{set;}
        public string ToptextArea2{set;}
        public string ToptextArea3{set;}
        public string ToptextArea4{set;}
        public boolean textAreaRendering{set;get;}
        public String DocumentID { get; set; }
        public boolean DocumentUploaded { get; set; }
        public Blob body {get;set;}
        public string res{get;set;}
        public string location{get;set;}
        public string rel{get;set;}
        public string error{get;set;}
        public Boolean ExchangeOrderFound{get;set;}
        public Boolean testMode { get; set; }
        public static Boolean FORCE_TEST_MODE = false;
        public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    	public final String ENDPOINT = castIronEndPoint.END_POINT__c;
        
        //public static string ENDPOINT = 'http://213.174.69.111:7890/Kasia20';  // remove hardcoding use custom setting      
   		
        public string response{get;set;}
        public string Nextresponse{get;set;}        
        public cCustomerInstallationAddress cCustInstAdd;
        string JSON = '';
        string url = '';
        boolean Approved = false;
        public boolean returnBoxCondFlag{get;set;}
        //public boolean ExchangeApproved{set;get;}
        public DealerExchangeInShop()
        {
            Nextresponse = '{}';
            //response='';
            //error='';
         }
        
        public cCustomerInstallationAddress getCCustInstAdd(){
            return cCustInstAdd;       
        }
     
        public PageReference GettextAreaDetails() 
        {
            forhandlerIndormationLst = [Select f.SubGroup_Information__c, f.Sequence_Number__c, f.Page_Type__c, f.Name, f.Id, f.Group_Information__c, f.Description__c, f.Dealer__c From ForhandlerInformations__c f where  Page_Type__c ='Exchange in shop'];
        
            for(ForhandlerInformations__c info : forhandlerIndormationLst)
            {
                forhandlerInformationWrapper forinfoObj = new forhandlerInformationWrapper();
                forinfoObj.description = info.Description__c;
                forinfoObj.pageno = info.Group_Information__c;
                forinfoObj.TopBottom = info.SubGroup_Information__c;
                forinfoObj.SequenceNo = info.Sequence_Number__c;
                wrapperClassLst.add(forinfoObj);                               
            }                 
            return null;            
        }
 
        public String getToptextArea1() {        
            textAreaRendering = false;
            string text1;
            for(forhandlerInformationWrapper WrapperVar :wrapperClassLst)
            {
                if(WrapperVar.pageno == 'DealerExchangeInShopSearchPage')
                    if(WrapperVar.TopBottom == 'Top')
                        if(WrapperVar.SequenceNo == 1.0)
                            text1 = WrapperVar.description;
            }                   
            return text1;
        }
     
        public String getToptextArea2() {           
            string text2;
            for(forhandlerInformationWrapper WrapperVar :wrapperClassLst)
            {
                if(WrapperVar.pageno == 'DealerExchangeInShopSearchPage')
                    if(WrapperVar.TopBottom == 'Top')
                        if(WrapperVar.SequenceNo == 2.0)
                            text2 = WrapperVar.description;
            }         
            return text2;
        }
 
        public String getToptextArea3() {        
            string text3;
            textAreaRendering = true;
            for(forhandlerInformationWrapper WrapperVar :wrapperClassLst)
            {
                if(WrapperVar.pageno == 'DealerExchangeInShopApprovalPage')
                    if(WrapperVar.TopBottom == 'Top')
                        if(WrapperVar.SequenceNo == 3.0)
                            text3 = WrapperVar.description;
                            System.debug('** Text3**'+ text3);
            }                 
            return text3;
        }

        public String getToptextArea4() {        
            string text4;
            textAreaRendering = true;
            for(forhandlerInformationWrapper WrapperVar :wrapperClassLst)
            {
                if(WrapperVar.pageno == 'DealerExchangeInShopApprovalPage')
                    if(WrapperVar.TopBottom == 'Bottom')
                        if(WrapperVar.SequenceNo == 4.0)
                            text4 = WrapperVar.description;
            } 
                    
            return text4;
        }
 
        public String getAddress1() {        
            system.debug('############### ---- DealeraddressString1 ------- '   + DealeraddressString1);
            return DealeraddressString1;  
        }

        public String getAddress2() {        
          
            return DealeraddressString2;  
        } 
        
        public string getExchangeDate() {        
             Datetime dt = system.today();
        string dtFrmt = dt.format('dd.MM.yyyy');
        system.debug('$$$$$$$$$$ '   + dtFrmt);            
            return dtFrmt;
        }

        public String getAgentNumber() {
            return AgentNumber;
        }
        
        public void setAgentNumber(String AgentNumber){
             this.AgentNumber = AgentNumber; 
        }           
        
        public class forhandlerInformationWrapper
        {
            public string pageno;
            public string TopBottom;
            public string description;
            public double SequenceNo; 
        }

// click on search button. 
   public PageReference SearchSerialNO(){                
     try{
     		 System.debug('In SearchSerialNO');
             SerialNo = SerialNo.trim();
             System.debug('Serial Number is'+ SerialNo);
             SerialNovar = SerialNo.trim();
             System.debug('Serial Number is'+ SerialNo);
             error = '';
             response='';                         
                // make a ws call here                                 
                SearchSerialNumber(); 
                // If you are trying to enter the same exchanged box number again , now that box is with dealer , so it will throe an error.                                      
                if(error == '')
                {
                    // to check whether box is with dealer 
                     if(location.startsWith('T') && location.length()==5)
                        {     
                        	System.debug('Location Is' + location);                  
                            error ='Box er allerede udvekslet, og det er med forhandleren';                       
                            return null;           
                        }                        
                     // to check whether box is with Distributor
                     if(location.startsWith('DISTRIBU')) // DISTRIBU
                        {                           
                            error ='boks er med distributør';                           
                            return null;
           
                        }       
                    
                    // incase of rel type onbtying , exchangeOrder found should be true
                    // incase of rel type indlevering , exchangeOrderFouund should be false. So do not check for ExchangeOrder Found incase of indlevering.
                     if(ExchangeOrderFound == true || rel == 'indlevering')
                     {     
                     	System.debug('***EOF***'+ ExchangeOrderFound + 'rel' + rel);                  
                        DisPBoxCondParam =  true;
                        CustInfoRendering  = true;  
                        fetchCustomerInformation();                 
                        if(rel != 'ombytning' && rel == 'indlevering') // if customer has chosen a mail option
                        {      
                        	System.debug('Inside rel');                         
                            DisplayNewSerialNumber = false;
                            Errorvalue = 'Kunden har fået tilsendt en boks pr. post fra YouSee og skal derfor ikke have udleveret en ny fra dig.';                              
                        }
                        else
                        {
                            DisplayNewSerialNumber = true;
                            Errorvalue = '';
                        }
                        textAreaRendering  =true; 
                        return page.DealerExchangeInShopSearchResultPage;
                                                                                            
                     }
                     else
                     {                          
                        textAreaRendering  =true;
                        DisPBoxCondParam =  false; 
                        CustInfoRendering = false;                                                                 
                       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.NoExchangeOrderFound));
                     //  error = System.Label.NoExchangeOrderFound;
                     error = 'Ifølge YouSees system er der ingen ombytningsordre på dette serienr. Det kan skyldes følgende årsager:';
                     error += ' Kunden har ikke fejlmeldt boksen hos YouSee Support. Det skal kunden selv gøre først.';
                    error += ' Serienummeret er indtastet forkert – prøv igen.';        
                    error += ' Kunden har flere bokse og har medbragt den forkerte.';
                    error += ' Har du spørgsmål, så kontakt venligst YouSee  Forhandlersupport på 70 13 37 00';
                        
                        return null;             
                     }
                     
                      
                }   
                else
                {                    
                     return null; 
                }            
        }catch(Exception e)
         {            
             ApexPages.addMessages(e);
            
                return null;
         }
   }

        public void SearchSerialNumber(){            
         try
         {
         	//System.debug('**Inside Search Serial Number**');
            //string body = 'GET /logistik/hardware/'+SerialNovar+'   !#$ !#$'; 
            string url = '/logistik/hardware/'+SerialNovar;             
           	string methodType = 'GET';
            testMode = FORCE_TEST_MODE;                            
            if(!(testMode)){
            	System.debug('* Inside TestMode *');
                   response = HttpRequestResponse.makeHttpCall(ENDPOINT+'/Kasia20','', methodType, url, '');
                //response =      HttpRequestResponse.makeHttpCall(body, methodType,ENDPOINT);
               // response = '{"links":[{"rel":"indlevering","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":true,"varenavn":"Leje af YouSee Boks","varenummer":"1203021","type":3,"lokation":"T9755","status":"DISPONIBEL","serienummer":"838301228900","ETag":"793755800"}';
            }
            System.debug('Response Is'+response);
            // parse response
            if(response != null || response != '')
            {
                    JSONObject j = new JSONObject( response );                  
                    if(j.has('logistik'))                    
                     {
                       JSONObject.value vs =  j.getValue('logistik');
                       if(j.getValue('responsecode').str != '200'){                                                                       
                            if(vs.obj.has('error') )
                            {    
                            	System.debug('Inside if with responsecode'+j.getValue('responsecode').str);                                                                                                                                                                                                                                         
                                error = j.getValue('logistik').obj.getValue('error').str;                            
                            }
                            else
                            {
                            	System.debug('Inside else with responsecode' + j.getValue('responsecode').str);
                                error = j.getValue('logistik').str;
                            }
                    
                        }
                     
                       else
                        {                   
                            //Fetch Location
                             location =  j.getValue('logistik').obj.getValue('lokation').str;
                             System.debug('Location is'+ location);                       
                            //Fetch Status and Rel
                            string status =   j.getValue('logistik').obj.getValue('status').str;
                            System.debug('Status is'+status);                                                
                            if(status.equalsIgnoreCase('disponibel') || status.equalsIgnoreCase('UNDER_OMBYTNING'))    // ||  status.equalsIgnoreCase('Transit') commented for dealerweb 252
                            {        
                            	  System.debug('Disponibel or ombytning');                                             
                                  rel =  j.getValue('logistik').obj.getValue('links').values[0].obj.getValue('rel').str;                                  
                                  error = '';
                            }         
                            else
                            {
                            		System.debug('Inside else');
                                  //error = 'kan ikke bytte hardware med status '+status;
                                  error ='Kan ikke bytte hardware med status '+ status +'. Husk at varemodtage';  // defect dealerweb285
                            }                                       
                            //Fetch Exchange Order Found
                            ExchangeOrderFound = j.getValue('logistik').obj.getBoolean('ombytning-godkendt');  
                            System.debug('ExchangeOrderFound'+ ExchangeOrderFound);                                             
                        }
                 
                     }
            }
         }
         catch(System.CalloutException e)
         {                                          
                throw e;
         }
        } 

        public pagereference CreatePDFDoc()
        {
            testMode = FORCE_TEST_MODE; 
            PageReference pref = new PageReference('/apex/DealerExchangeInShopReceiptPrintingPage');                       
           if(!(testMode)){
            body = pref.getContentAsPDF();
           }
            //To upload the document
            Document d= new Document();
            folder f=[SELECT Id,Name from folder where name='Exchange In Shop' and type='Document']; 
            d.FolderId=f.Id; 
            d.Name='test exc.pdf';//userName + '-' +docType;              
            d.Body = body;
            //d.ContentType = 'application/pdf';//'application/msWord'; ////'text/html';
           // d.Type = '.pdf';
           // d.IsPublic=false; 
            Database.SaveResult sr = Database.insert(d,false);                                
            if(sr.isSuccess())
            {
                DocumentID=sr.getId(); 
                DocumentUploaded =true;
            }  
            return null;
        }

        public void fetchCustomerInformation()
        {
          if(location.startsWith('T') && location.length()==5)
           {
           error ='Box er allerede udvekslet, og det er med forhandleren';
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,error));
           
           }
           System.debug('Customer Number ----------------------------> ' +location);
            /* Commented for DW-720: Removed side__c field from the new query below
            List<Account> accList =[Select  Customer_No__c,a.Email__c,a.Phone, a.Name, a.LastName, a.FirstName , a.Street_YK__r.Town__c, a.Street_YK__r.Postcode__c, a.Street_YK__r.Door_No__c,
                                         a.Street_YK__r.Side__c, a.Street_YK__r.Floor__c, a.Street_YK__r.House_No__c,
                                          a.Street_YK__r.Street__c, a.Street_YK__c ,a.Street_YK__r.Entrance__c
                                          From Account a
                                           where Customer_No__c =:location limit 1];*/
            List<Account> accList =[Select  Customer_No__c,a.Email__c,a.Phone, a.Name, a.LastName, a.FirstName , a.Street_YK__r.Town__c, a.Street_YK__r.Postcode__c, a.Street_YK__r.Door_No__c,
                                         a.Street_YK__r.Floor__c, a.Street_YK__r.House_No__c,
                                          a.Street_YK__r.Street__c, a.Street_YK__c ,a.Street_YK__r.Entrance__c
                                          From Account a
                                           where Customer_No__c =:location limit 1];

          System.debug('accList ----------------------------> ' +accList.size());          
           if(!(accList.isEmpty()))       
           {
                Account acc = accList[0];
                cCustInstAdd = new cCustomerInstallationAddress();
                cCustInstAdd.addr = acc.Street_YK__r;//addr;
                cCustInstAdd.firstName = acc.FirstName;
                cCustInstAdd.lastName = acc.LastName;
                cCustInstAdd.contactNumber = acc.Phone;
                cCustInstAdd.email = acc.Email__c;
                cCustInstAdd.Name = acc.Name;
                cCustInstAdd.customerNumber = acc.Customer_No__c;
           }
        
        }
   
        public class cCustomerInstallationAddress{
            public String Name{get;set;}
            public String firstName{get;set;}
            public String lastName{get;set;}
            public String contactNumber{get;set;}
            public Address__c addr{get;set;}
            public String email{get;set;}
            public String mobilePhone{get;set;}
            public String amsId{get;set;}
            public String customerNumber{get;set;}
        
            public String getAddr1(){
                String addressString = '';
                addressString = addressString+(addr.Street__c == null ?  '' : addr.Street__c+' ');
                addressString = addressString+ (addr.House_No__c == null ?  '' : addr.House_No__c+' ');
                addressString = addressString+(addr.Entrance__c == null ?  '' : addr.Entrance__c+' ');
                addressString = addressString+(addr.Floor__c == null ?  '' : addr.Floor__c+' ');
                //Commented for DW-720: Side__c is going to be deleted from SFDC
                //addressString = addressString+(addr.Side__c == null ?  '' : addr.Side__c+' ');
                addressString = addressString+(addr.Door_No__c == null ?  '' : addr.Door_No__c+' ');
                return addressString;
            }
            public String getAddr2(){
                String addressString = '';
                addressString = addressString+(addr.Postcode__c == null ?  '' : addr.Postcode__c+' ');
                addressString = addressString+(addr.Town__c== null ?  '' : addr.Town__c+' ');
                return addressString;
            }
        }


       // on the search result page
        public PageReference Next(){      
        // To check whether Box condition is selected or not...
            error = '';
            try{
                system.debug('returnBoxCond ***************  '+returnBoxCond);
                               
            if(DisplayNewSerialNumber)
            {                 
                 newSerialNo = newSerialNo.trim();
                 SerialNovar = newSerialNo.trim();
                 
              //   validation();
            }
          //  if(validated || DisplayNewSerialNumber == false)
          //  {                       
                FetchDealerAddress(); 
                CreateJSONRequest(); 
                   //only hardware ws call
                   System.debug('Rel is'+ rel);
               if(rel != 'ombytning' && rel == 'indlevering' && (error == null || error == ''))               
                {
                    return Page.DealerExchangeInShopApprovalPage;
                }
                else 
                {
                    if(Approved)
                    {
                    	System.debug('***Comes inside Approval Page ***');
                        return Page.DealerExchangeInShopApprovalPage;
                    }
                    else
                    {
                        return null;
                    }
                    
                }             
                     // make ws call  
                                                                                  
              /* Defect - 160, 163 Isabelle asked to move the ws calls to Next Approval page.
                CreateJSONRequest();                                                                
               
                 JSONObject j = new JSONObject( Nextresponse );
                 if((j.getValue('responsecode').str == '200') && (error == null || error == ''))
                 {
                    return Page.DealerExchangeInShopApprovalPage;
                 }
                 else
                 {
                     JSONObject.value vs =  j.getValue('logistik');
                     if(vs.obj.has('error') )
                            {                                                                                                                                                                                                                                             
                                error = j.getValue('logistik').obj.getValue('error').str;                            
                            }
                            else
                            {
                                error = j.getValue('logistik').str;
                            }
                    return null; 
                 }*/
               
              /*  if(Nextresponse.contains('409') && (error == null || error == ''))
                 {
                   error= '409 Webservice fejl, prøv igen.';
                   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'409 Webservice fejl, prøv igen.'));
                    return null; 
                 }  
                 else if(Nextresponse.contains('201') && (error == null || error == ''))
                 {
                    return Page.DealerExchangeInShopApprovalPage;
                 }
                 else if(Nextresponse.contains('200') && (error == null || error == ''))
                 {
                    return Page.DealerExchangeInShopApprovalPage;
                 } 
                 else
                 {
                  if(error == null || error == '')
                  error = Nextresponse;                    
                    return null;
                 }*/         
        
            }Catch(Exception e)
            {
                ApexPages.addMessages(e);
                return null;
            }
        }

        
        public PageReference redirectToCustomerReceiptPage(){        
                //system.debug('inside redirectToCustomerReceiptPage method ********  ');
                return Page.DealerExchangeInShopReceipt;            
            
        }
        
         public PageReference Approve(){        
                //CreateJSONRequest();
                System.debug('**Inside Approve**');                                                                
              	error = '';
               try{
               System.debug('*** approved ***');	
               ReserveSRNumber();
                
              // parsing is moved to the client side -- because some time json response format is not as expected eg getting some special characters in exception
              //which jsonobject cannot process
              
              JSONObject j = new JSONObject( Nextresponse );
                if((j.getValue('responsecode').str == '200') || (j.getValue('responsecode').str == '201') && (error == null || error == ''))
                 {
                 	System.debug('**Response Code**'+j.getValue('responsecode').str);
                    return Page.DealerExchangeInShopReceipt;
                    System.debug('After the page');
                 }
                 else
                 {
                     JSONObject.value vs =  j.getValue('logistik');
                     if(vs.obj.has('error'))
                            {                    
                            	System.debug('**Inside logistik if**');                                                                                                                                                                                                                         
                                error = j.getValue('logistik').obj.getValue('error').str;                            
                            }
                            else
                            {
                            	System.debug('**Inside logistik else**');
                                error = j.getValue('logistik').str;
                            }
                    return null; 
                 }
               return null; 
             }Catch(Exception e)
            {               
                      error = e.getMessage();            
                return null;
            }
            //return Page.DealerExchangeInShopReceipt;
        } 
        
        // ombtying /indlevering ws call for approval
        public void CreateJSONRequest(){
        	//System.debug('**Comes Inside CreateJSONRequest**');
           // string JSON = '';
           // string url = '';
           // boolean Approved = false;  
            system.debug('the value of rel is ***'+rel); 
            try{    
            if(rel == 'ombytning' && rel != 'indlevering' && (error == null || error == '') ) // if customer has chosen a shop option
            {      
            	//System.debug('**Call To Search Serial Number1**');          
                SearchSerialNumber(); // to check whether dealer has approved or not- 1st web service call again with new serial no.
               system.debug('Response ******* '+Response);
                if (error == null || error == ''){
                 if(Response.length() > 0 )
                {                   
                //  DummyCommonClass dealerInfo = new DummyCommonClass();
                  commonClass dealerInfo = new commonClass(); 
                            
                    JSONObject j = new JSONObject( Response );
                    // if(j.has('error'))
                     if(j.has('logistik'))                    
                     {                       
                        JSONObject.value vs =  j.getValue('logistik');
                       if(j.getValue('responsecode').str != '200'){                                            
                            Approved= false; 
                            if(vs.obj.has('error') )
                            {                                                                                                                                                                                                                                             
                                error = j.getValue('logistik').obj.getValue('error').str;                            
                            }
                            else
                            {
                                error = j.getValue('logistik').str;
                            }
                    
                        }
                     else{
                                    string DealerNumber =  j.getValue('logistik').obj.getValue('lokation').str;// j.getString('lokation');                                         
                                    dealerInfo.setDealerInfo();       
                                    Account DealerAcc = dealerInfo.dealerAccount;
                                    AgentNumber = DealerAcc.Dealer_Number__c;                                                    
                                    if(AgentNumber == DealerNumber)// if('T2295' == DealerNumber)//                                    
                                    {
                                        Approved = true;
                                    }
                                    else
                                    {
                                        Approved = false;
                                            // error= 'Serienummer stemmer ikke overens med YouSee’s informationer oom lagertilstand. Har du husket at væremodtage dine varer fra YouSee?';
                                            error = 'Serienummer er ikke disponibelt'; //dealerweb defect 286
                                    }
                                }
                     }
                }
                }
                
            }       
        }
         catch(System.CalloutException e)
         {                                          
                throw e;
         }
        
        } 
        
          
      public void ReserveSRNumber(){
      	system.debug('returnBoxCond value is *******************'+returnBoxCond);
      	if(returnBoxCond == 'OK'){
		  returnBoxCondFlag = false;
        }else{
    	  returnBoxCondFlag = true;
        }
        try{
    		System.debug('Approved'+ Approved);
             if(Approved)
            {
                //JSON = '{\"lager-lokation\" :'+'\"'+AgentNumber+'\"'+', \"kundens-hardware\" :'+'\"'+SerialNo+'\"'+',\"ombyttet-hardware\"  :'+'\"'+newSerialNo+'\"' ,\"udbetal-kommission\" : true,\"hardware-skadet\" : true,\"ombytningskommentar\" : \"Boksen var synligt skadet ved modtagelse\",\"klient-funktion\" : \"ombyt i bil\", \"klient-system\" : \"Davids Sys\", \"klient-bruger\" : \"David\"}';
                JSON =  '{\"lager-lokation\":'+'\"'+AgentNumber+'\"'+',\"kundens-hardware\":'+'\"'+SerialNo+'\"'+',\"ombyttet-hardware\":'+'\"'+newSerialNo+'\"';
                //JSON  = JSON + ',\"udbetal-kommission\":true,\"hardware-skadet\":true,\"ombytningskommentar\":\"Boksen var synligt skadet ved modtagelse\"';
                //DW- 623
                system.debug('damageComment is --'+damageComment+' --And Return Box-condition is ----------'+returnBoxCond+'-------------and returnBoxCondFlag is -----'+returnBoxCondFlag);
                JSON  = JSON + ',\"udbetal-kommission\":true,\"hardware-skadet\":'+returnBoxCondFlag+',\"ombytningskommentar\":'+'\"'+damageComment+'\"';
                JSON  = JSON + ',\"klient-funktion\":\"ombyt i bil\",\"klient-system\":\"DealerWeb\",\"klient-bruger\":'+'\"'+AgentNumber+'"}';        
            
            //      body ='POST /logistik/ombytning !#$  !#$  ' +JSON; // commented for the changes in cast iron
                  url = '/logistik/ombytning';
                  system.debug(' ****** JSON ombytning --'+url);
                  system.debug(' ****** JSON for ombytning Is --------------------------->'+JSON);    
            }
            else
            {                   
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,error));           
            }
	        // If customer has chosen Mail option , then there is no new serial number .
            if(rel != 'ombytning' && rel == 'indlevering' && (error == null || error == ''))
            {
            	System.debug('** Inside If **'+ '*** Rel***'+ rel);
                JSON =  '{\"lager-lokation\":'+'\"'+AgentNumber+'\"'+',\"kundens-hardware\":'+'\"'+SerialNo+'\"';
                system.debug('damageComment is --'+damageComment+' --And Return Box-condition is ----------'+returnBoxCond+'-------------and returnBoxCondFlag is -----'+returnBoxCondFlag);
                JSON  = JSON +',\"klient-funktion\":\"indlevering\",\"klient-system\":\"DealerWeb\",\"klient-bruger\":'+'\"'+AgentNumber+'"}';
                //body = 'POST /logistik/indlevering !#$  !#$  '+JSON;  //commented for chages in cast Iron
                
              // url = '/logistik/indlevering/'+JSON;
               url = '/logistik/indlevering';
               system.debug(' ****** JSON Is'+url);
               system.debug(' ****** JSON Is--------------------------->'+JSON);      
            }                        
         	// string context ='kasia2.0';                                
            string methodType = 'POST';               
            if(!(testMode)){ 
                
              //  Nextresponse =   HttpRequestResponse.makeHttpCall(body, methodType,ENDPOINT);// commented for chages in cast Iron
              	System.debug('JSON'+ JSON);
                 Nextresponse = HttpRequestResponse.makeHttpCall(ENDPOINT+'/Kasia20',JSON, methodType, url, '');          
                system.debug('JSON Response in NEXT METHOD $$$$$$$$$  '+Nextresponse);
            }
            
         }
         catch(System.CalloutException e)
         {                                          
                throw e;
         }
        
      
      }
      
        public void FetchDealerAddress()
        {
                    string accid;
                    DealeraddressString1='';
                    DealeraddressString2 ='';
                   // DummycommonClass dealerInfo = new DummycommonClass();
                   commonClass dealerInfo = new commonClass();                                                                                                             
                    dealerInfo.setDealerInfo();       
                    Account DealerAcc = dealerInfo.dealerAccount;
                    accid = DealerAcc.Id;
                    this.AgentNumber = DealerAcc.Dealer_Number__c;
            
            //string name = Userinfo.getName();
            Account acc = [Select a.Name,Dealer_Number__c, a.Town_YK__c,a.Street_YK__r.Street__c, a.Side_YK__c, a.Post_Code__c, a.House_No__c, a.Floor_No__c, a.Entrance_YK__c, a.Door_No_YK__c, a.District_YK__c From Account a where Id=:accid limit 1];      
            //AgentNumber = acc.Dealer_Number__c; 
            System.debug('street name: '+acc.Street_YK__r.Street__c==null?'':acc.Street_YK__r.Street__c + ': '+acc.House_No__c);
            DealeraddressString1 = DealeraddressString1+(acc.Street_YK__r.Street__c==null?'':acc.Street_YK__r.Street__c+' ');
            DealeraddressString1 = DealeraddressString1+ (acc.House_No__c == null ?  '' : acc.House_No__c+' ');
            DealeraddressString1 = DealeraddressString1+(acc.Entrance_YK__c == null ?  '' : acc.Entrance_YK__c+' ');
            DealeraddressString1 = DealeraddressString1+(acc.Floor_No__c == null ?  '' : acc.Floor_No__c+' ');
            DealeraddressString1 = DealeraddressString1+(acc.Side_YK__c == null ?  '' : acc.Side_YK__c+' ');
            DealeraddressString1 = DealeraddressString1+(acc.Door_No_YK__c == null ?  '' : acc.Door_No_YK__c+' ');            
            DealeraddressString2 = DealeraddressString2 +(acc.Post_Code__c == null ?  '' : acc.Post_Code__c+' ');
            DealeraddressString2 = DealeraddressString2 +(acc.Town_YK__c== null ?  '' : acc.Town_YK__c+' ');                   
        }
 
      

        public PageReference renderCommentTextBox(){    
            if(returnBoxCond == 'beskadiget')
            {
                showComment =true;       
            }
            else
                showComment =false;
            return null;
        }  
  
      public PageReference BacktoSearchpage(){        
            returnBoxCond = null;
             showComment =false;
             damageComment = '';
             this.newSerialNo ='';
              error = '';
            
            return Page.DealerExchangeInShopSearchPage;
      } 
          
       
      public PageReference  BacktoSearchResultPage(){        
             Nextresponse = '{}';
             error= '';
             DealeraddressString1 ='';
             DealeraddressString2=''; 
            return Page.DealerExchangeInShopSearchResultPage;
      }  
      
       public PageReference  BacktoApprovalPage(){   
       	// as per isabelle once approved ,on back buttonclick from customer receipt screen redirect back to serial number search screen.
   			resetValues();
            return Page.DealerExchangeInShopSearchPage;
      }
      
      public void resetValues()
      {
      	 returnBoxCond = null;
         showComment =false;
         damageComment = '';
         this.newSerialNo ='';
         SerialNo ='';    
      	error=''; 
      	Approved = false;
        DealeraddressString1 ='';
        DealeraddressString2='';    
      }
 }