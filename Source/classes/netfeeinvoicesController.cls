public class netfeeinvoicesController {

    public String accountId{get; set;}
    public String cableUnitNumber{get; set;}
    public Account accObj{get; set;}
    public List<Account> cuList{get; set;}
    public static List<Invoice__c> invoiceList{get; set;}
    public static String legalAccNo{get; set;}
    public String paymentAccNo{get; set;}
    public List<netsFeeWrapper> listNetsWrapper{get;set;} 
    public List<InvoiceWrapper> list_Invoices{get;set;}
    public List<InvoiceWrapper> list_UnpaidInvoices{get;set;}
    public Map<String,InvoiceWrapper> mapInvNoToInvoice{get;set;}
    public  InvoiceWrapper invWrpObj{get;set;}
    public String dibsTransactionId{get;set;}
    //Pagination variables
    public integer invoiceCounter {get; set;}  //keeps track of the offset
    public integer invoiceTotalSize {get; set;}
    public integer invoiceRows {get; set;}
    public String AccNo{get;set;}
    public String AccName{get;set;}
    public Decimal TotalInvoice{get;set;}
    public String strTotalInvoice{get;set;}
    public String customerNo{get;set;}//SPOC 2094
    
    
    //Payment method variables
    public String strPaymethod{get;set;}
    //Invoice Media variable 
    public String strInvoiceMedia{get;set;}
    public String strIp{get;set;}
    public Boolean selectInvMed{get;set;}
    public List<Permission__c> listPermission;
    public Map<String,String> mapforPaymentMethod {get;set;}
    public Map<String,String> mapForErrorCodes {get;set;}
    
    
    public netfeeinvoicesController(ApexPages.StandardController controller) {
        
        
        listNetsWrapper = new List<netsFeeWrapper>();
        mapInvNoToInvoice = new Map<String,InvoiceWrapper>();
        cuList = new List<Account>();
        this.accObj= (Account)controller.getRecord();
        system.debug('check1'+this.accObj);
        invoiceCounter = 0;
        invoiceRows = 10;
        strPaymethod = '';
        dibsTransactionId = '';
        selectInvMed = false;
        TotalInvoice = 0;
        strIp = NetsFeeCallOut.GetUserIPAddress();
        ispageLodaErr = false;
        if(accObj != null){         
            AccNo = EvalAcc();  
        }
        selectInvMed = getEcommForCustomer(AccNo);
        
        mapforPaymentMethod = new Map<String, String>
        {'C' => 'CREDIT_CARD ', 
         'O' => 'TRANSFER ',
         'CH' => 'CHECK', 
         'R' => 'GIRO', 
         'D' => 'PBS', 
         'SB' => 'SELVBETJENING' ,  
         'TB' => 'TDC_BUTIK' , 
         'BA' => 'BANK' , 
         'IB' => 'INDBETALINGSKORT' , 
         'OT' => 'OTHER' , 
         'NA' => 'Kreditnota'
       };
       
       mapForErrorCodes = new Map<String, String>
       {
            '-1'=>'Der er endnu ikke dannet fakturaer på denne kunde. Bemærk at YouBio og telefoni ikke opkræves her',
            '1' => 'KONTONR FEJL', 
            '2' => 'LID FEJL', 
            '3' => 'FEJL I KALD', 
            '4' => 'ADGANGS FEJL', 
            '5' => 'SYSTEMFEJL', 
            '6' => 'PARAMETER FEJL', 
            '7' => 'SIDSTE SIDE',     
            '10' => 'KONTOSTATUS ER NIS ELLER ANDET - IKKE ALM', 
            '11' => 'REGNINGSTATUS UGYLDIG', 
            '12' => 'FLERE KONTI PAA TLF', 
            '13' => 'FOR MANGE AFTALER' 

       };
    }
    
    /*
        This method determines the customer for which the invoices are to be shown
    */
    public String EvalAcc(){
        
      cuList = [Select Name,Street_YK__c,Street_YK__r.Full_Address__c,Id,Cable_Unit_No__c,Customer_No__c,IspersonAccount,Cable_Unit__c,Cable_Unit__r.Legal_Account_No__r.customer_No__c,Cable_Unit__r.Legal_Account_No__r.Name,Cable_Unit__r.Payment_Account_No__r.customer_No__c, Cable_Unit__r.Payment_Account_No__r.Name From Account where ID =: accObj.ID ];
      customerNo = cuList[0].Customer_No__c; //SPOC 2094
      if(!cuList.isEmpty()){
          if(cuList.size() > 0 && (cuList[0].Cable_Unit_No__c != null && cuList[0].Cable_Unit_No__c != '' && !cuList[0].IsPersonAccount)) {
              cableUnitNumber = cuList[0].Cable_Unit_No__c;
              AccNo = cableUnitNumber;
              system.debug('check2'+AccNo);
              AccName = cuList[0].Name;
          }else if(cuList[0].Customer_No__c !=null){
              cableUnitNumber = cuList[0].Customer_No__c ;
              AccNo = cableUnitNumber;
              AccName = cuList[0].Name;
          }
          
          if(cuList.size() > 0 && cuList[0].Cable_Unit__r.Legal_Account_No__r.customer_No__c != null){
              legalAccNo = cuList[0].Cable_Unit__r.Legal_Account_No__c;
              AccNo = legalAccNo;
              AccName = cuList[0].Cable_Unit__r.Legal_Account_No__r.Name;
          }
          
          if(cuList.size() > 0 && cuList[0].Cable_Unit__r.Payment_Account_No__r.customer_No__c != null){
              paymentAccNo = cuList[0].Cable_Unit__r.Payment_Account_No__c;
              AccNo = paymentAccNo;
              AccName = cuList[0].Cable_Unit__r.Payment_Account_No__r.Name;
          }
      }   
      System.debug('#cableUnitNumber ###'+cableUnitNumber+'####legalAccNo'+legalAccNo+'@@@@paymentAccNo@@@'+paymentAccNo);
      return AccNo;
    }
    
    /*
        This method checks whether the customer has a ecom true and has email id.
    */
    public Boolean getEcommForCustomer(String custNo){
        listPermission = new List<Permission__c>();
      // listPermission = [SELECT Customer__c,E_kommunikation__c,id,Customer_Number__c,Customer__r.PersonEmail,Customer__r.PersonMobilePhone FROM Permission__c where Customer_Number__c =:AccNo and E_kommunikation__c = TRUE and Customer__r.PersonEmail!=null];
        system.debug('******listPermission'+listPermission);
       listPermission = [SELECT Customer__c,E_kommunikation__c,id,Customer_Number__c,Customer__r.PersonEmail,Customer__r.PersonMobilePhone FROM Permission__c where Customer_Number__c =:AccNo and Customer__r.PersonEmail!=null];
        if(!listPermission.isEmpty())
            selectInvMed = true;
        return selectInvMed;
    }
    
   public static Boolean ispageLodaErr{get;set;}
   /*
    This method is called when the page loads. 2 services are called.
        1. Payment service to retrieve the Customer Information,its current payment method,leveringsmetode.
        2. Business Core service to retrieve the invoice details for this customer
   */
    public PageReference invokeCI() {
         
         system.debug('');
         makeHTTPforPaymentProfile();     
         getInovoiceBillsByHTTPCallOut();
         return null;
    } 
    
    public PageReference invokeCallout(){
        makeHTTPforPaymentProfile();
        return null;
    }
    public Boolean isError{get;set;}
    
    /*
        This method does the following.
            A callout goes to the getBills of the Business Core to fetch the invoices of the customer dated from 1st July 14' to 31st Dec 15'.          
    */
    public pagereference getInovoiceBillsByHTTPCallOut(){
      
       invoiceTotalSize = 0;
       Date stdt  = date.newinstance(2014, 7, 1);
       Date enddt = date.newinstance(2016, 12, 31);
       
       list_Invoices=new List<InvoiceWrapper>();
       HttpResponse hresponse=netfeeinvoicesPDFBillsController.getBills(AccNo,stdt,enddt,NetsFeeCallOut.GetUserMid(),NetsFeeCallOut.GetUserIPAddress(),UserInfo.getUserId());
       if(hresponse!=null){
           String responseBody=hresponse.getBody();
           system.debug('%% in getInovoiceBillsByHTTPCallOut responseBody:'+responseBody);
           isError = false;
           Date dtCalc;
            try{
                   JSONParser parser = JSON.createParser(responseBody);
                   Integer i = 0;
                   TotalInvoice = 0;
                   while (parser.nextToken() != null) {
                   // Start at the array of invoices.                                        
                        //  Advance to the start object marker to
                        //  find next invoice statement object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read entire invoice object, including its array of line items.
                            InvoiceWrapper inv = (InvoiceWrapper)parser.readValueAs(InvoiceWrapper.class);
                            if(inv.invoiceNumber!=null){
                                i = i+1;
                                inv.rowcount = i; 
                                //If invoice is not paid and does not have a credit note.
                                //Credit note is payment adjustments                                
                                if(inv.paid == false && inv.creditnote == false){
                                    //To calculate the amount that has to be paid
                                    //The lesser value in either of the column is taken as the amount to be paid
                                    if(Math.abs(decimal.valueOf(inv.amountTotalInclVat)) <= Math.abs(decimal.valueOf(inv.balance))){                                        
                                        inv.strPartialAmt = (Math.abs(decimal.valueOf(inv.amountTotalInclVat)).setScale(2)+.001).format();
                                        inv.strPartialAmt = inv.strPartialAmt.substring(0,inv.strPartialAmt.length()-1);
                                        inv.Sample = Math.abs(decimal.valueOf(inv.amountTotalInclVat));
                                    }
                                    else if(Math.abs(decimal.valueOf(inv.amountTotalInclVat)) > Math.abs(decimal.valueOf(inv.balance))){
                                        inv.strPartialAmt = (Math.abs(decimal.valueOf(inv.balance)).setScale(2)+.001).format();
                                        inv.strPartialAmt = inv.strPartialAmt.substring(0,inv.strPartialAmt.length()-1);
                                        inv.Sample = Math.abs(decimal.valueOf(inv.balance));
                                    }
                                                                       
                                    TotalInvoice = TotalInvoice + inv.Sample;// total amount of all the remaining invoices to be paid
                                }
                                //To show the amount that has been paid or unpaid in the lalt column.
                                inv.amountTotalInclVat = (decimal.valueOf(inv.amountTotalInclVat).setScale(2)+.001).format();
                                inv.amountTotalInclVat = inv.amountTotalInclVat.substring(0,inv.amountTotalInclVat.length()-1);
    
                                String[] lastPaymentDate = new List<String>();
                                //Formatting the last payment date in Danish format
                                if(inv.lastPaymentDate!=''){
                                    lastPaymentDate = inv.lastPaymentDate.split('-');
                                    inv.lastPaymentDate = lastPaymentDate[2] +'-'+lastPaymentDate[1]+'-'+lastPaymentDate[0];
                                    dtCalc= date.newInstance(integer.valueOf(lastPaymentDate[0]),integer.valueOf(lastPaymentDate[1]),integer.valueOf(lastPaymentDate[2]));
                                    inv.lastpaymentFrCal = EvalToPay(dtCalc,mapforPaymentMethod.get(inv.paymentMethod));
                                }
                                String[] InvoiceDate = new List<String>();
                                //Formatting the document date in Danish format
                                if(inv.documentDate!=''){
                                    InvoiceDate = inv.documentDate.split('-');
                                    inv.documentDate = InvoiceDate[2] +'-'+InvoiceDate[1]+'-'+InvoiceDate[0];
                                }
                                system.debug('****Invoice number: ' +inv.lastPaymentDate+'****dtCalc:'+dtCalc+'todaye===='+date.today());                               
                                // For debugging purposes, serialize again to verify what was parsed.
                                String s = JSON.serialize(inv);
                                system.debug('Serialized invoice: ' + s);                                                                                                         
                                list_Invoices.add(inv);
                            }       
                            
                        }                         
                    }
                    strTotalInvoice = (TotalInvoice.setscale(2)+.001).format(); //Formatting the total Amount that is remaining
                    strTotalInvoice = strTotalInvoice.substring(0,strTotalInvoice .length()-1);
                    system.debug('##strTotalInvoice: ' + strTotalInvoice); 
                    if(!list_Invoices.isEmpty()){
                        invoiceTotalSize = list_Invoices.size(); 
                        system.debug('##list_Invoices invoice: ' + list_Invoices);                         
                    }
               
            }catch(Exception e){
                    system.debug('%%Inside response catch#'+e.getMessage());
                    isError = true;
                    if(e.getMessage().contains('Unexpected character')){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Intern fejl: Fejl fra server')); 
                    }
                    
                    else{
                        Map<String,Object> mapError = (Map<String, Object>)JSON.deserializeUntyped(responseBody);                 
                        Map<String,Object> s = (Map<String,Object>)mapError.get('error');                              
                        strTotalInvoice = TotalInvoice.format();
                        String errmsg = (String)s.get('message');                         
                        String msg = '';
                        if(errmsg!='')
                            msg = checkcodes(errmsg);                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msg!=''?msg:'Intern fejl: Fejl fra server'));  
                    }
            } 
       }
       else
        ispageLodaErr = true;
        return null;
    } 
    
    /*
        This method evaluates that amount can be paid if the due date is in future and 2 days after current day for Payment method PBS or CC
        For Giro it could be paid instantly
         
    */
    public String EvalToPay(Date duedate,String paymethod){
        Date duedateFinal = duedate.addDays(2);
        Integer daysDiff = duedateFinal.daysBetween(date.today());
        
        if(daysDiff>=0 || paymethod == 'GIRO')
            return 'payable';
        else
            return 'notpayable';
    }
    
    /*
        Error messages corresponding to error codes received.
    */
    public String checkcodes(String err){
        String val = '';
          
        if(err.indexOf('BEA-')!=-1){
            val = 'Fjernbetjeningen Corba tjeneste returnerede en fejl';
        }
        
        else if(err.indexOf('reply code')!=-1){
            String errmsg = err.substring(err.indexOf('reply code'),(err.length()));
            
            if(errmsg.contains('1')){
              if(errmsg.lastIndexOf('-1')!=-1){   
                    val =  mapForErrorCodes.get('-1');
                    val = val+'(Reply Code: -1)';             
                 }  
                if(errmsg.lastIndexOf('10')!=-1){
                    val =  mapForErrorCodes.get('10');
                    val = val+'(Reply Code: 10)';
                }
                if(errmsg.lastIndexOf('11')!=-1){
                    val =  mapForErrorCodes.get('11');
                    val = val+'(Reply Code: 11)';
                }
                if(errmsg.lastIndexOf('12')!=-1){
                    val =  mapForErrorCodes.get('12');
                    val = val+'(Reply Code: 12)';
                }
                if(errmsg.lastIndexOf('13')!=-1){
                    val =  mapForErrorCodes.get('13');
                    val = val+'(Reply Code: 13)';
                }
                 
                if(errmsg.lastIndexOf('1')!= -1 && errmsg.lastIndexOf('-1')== -1 && errmsg.lastIndexOf('10')== -1 && errmsg.lastIndexOf('11') == -1 && errmsg.lastIndexOf('12') == -1 && errmsg.lastIndexOf('13') ==-1){
                    val =  mapForErrorCodes.get('1');
                    val = val+'(Reply Code: 1)';
                }
            }
            else if(errmsg.lastIndexOf('2')!= -1){
                val =  mapForErrorCodes.get('2');
                val = val+'(Reply Code: 2)';
            }
            else if(errmsg.lastIndexOf('3')!= -1){
                val =  mapForErrorCodes.get('3');
                val = val+'(Reply Code: 3)';
            }
            else if(errmsg.lastIndexOf('4')!= -1){
                val =  mapForErrorCodes.get('4');
                val = val+'(Reply Code: 4)';
            }
            else if(errmsg.lastIndexOf('5')!= -1){
                val =  mapForErrorCodes.get('5');
                val = val+'(Reply Code: 5)';
            }
            else if(errmsg.lastIndexOf('6')!= -1){
                val =  mapForErrorCodes.get('6');
                val = val+'(Reply Code: 6)';
            }
            else if(errmsg.lastIndexOf('7')!= -1){
                val =  mapForErrorCodes.get('7');
                val = val+'(Reply Code: 7)';
            } 
           
                 
   }
      
             
       return val;
       
   
            
    }
    
  
   
    /*
        This method  calls the getCustomerPaymentProfile_v2 of Payment service method to bring in the customer information.
    */
    public Map<String,String> mapPaymentProfToInfo{get;set;}
    public boolean payProfilRender { get;set; }
    
 
     
    public void makeHTTPforPaymentProfile(){
        mapPaymentProfToInfo = new Map<String,String>();
        
        HTTPResponse resPaymentProf = NetsFeeCallOut.CallForPaymentProfile(AccNo,strIp);
        
        if(resPaymentProf!=null ){
        System.debug('***********response'+resPaymentProf.getbody());
            if(resPaymentProf.getStatusCode() == 200){
            Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(resPaymentProf.getBody(),Map<String,String>.class);
            
            if(responseMap.get('status')=='0'){
                mapPaymentProfToInfo.putAll(responseMap);
                strPaymethod = mapPaymentProfToInfo.get('paymentMethod'); // assigning payment method to a variable to be displayed on page
                strInvoiceMedia = mapPaymentProfToInfo.get('invoiceMedia'); // assigning delivery method to a variable to be displayed on page
                payProfilRender = true;              
            }
            else{
                payProfilRender = false;                 
            }
        }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'fejl fra betalingsservice'));
        }
            
        
        system.debug('payProfilRender===='+payProfilRender+'$$$$$$mapPaymentProfToInfo'+strPaymethod+'==strInvoiceMedia==='+strInvoiceMedia);
    }

   /*
    This method changes the payment method of the customer when the Betalingsmetode button is clicked 
   */
    public pagereference updatepaymentMethod(){
        
        String transactionid = Apexpages.currentPage().getParameters().get('trasactionid');
        String expDate = Apexpages.currentPage().getParameters().get('expirationdate'); 
        String PayMethod = Apexpages.currentPage().getParameters().get('PayMeth');
        String casrMask = Apexpages.currentPage().getParameters().get('cardNoMask');
        //SUPPORT-6470 added authkey
        String authkey =  Apexpages.currentPage().getParameters().get('authkey');
        HttpResponse responseupdate ;
        HttpResponse responsePapir;
        HttpResponse responsePDF;
        if(PayMethod == 'Giro'){ // payment method is instantly changed and reflected on screen
            responseupdate = NetsFeeCallOut.CallForUpdateToGIRO(AccNo,strIp);
            system.debug('*********response'+responseupdate.getBody());
        }
        else if(PayMethod == 'CC'){ // payment method can only be changed if the Ecom is true and customer has an email id.
            //SUPPORT-6470 Start
            String md5CodedVal = getMD5CodedValue(transactionid);
            if( md5CodedVal != '' && authkey != '' && md5CodedVal != authkey){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in DIBS transaction: Authkey doesn\'t match'));
                return null;
            }
            //SUPPORT-6470 End
            String strUserId = NetsFeeCallOut.GetUserMid();
            // Added parameter carsmask for SUPPORT-4681
            responseupdate = NetsFeeCallOut.CallForUpdateToCC(AccNo,strIp,strUserId,mapPaymentProfToInfo,transactionid,expDate,listPermission,casrMask); 
                
        }
        
        if(responseupdate != null){
           system.debug('*********response'+responseupdate.getBody()); 
           String errCallOut = Checkvalidity(responseupdate.getBody()); 
           
           if(errCallOut==''){
             makeHTTPforPaymentProfile();//to call a subsequent call out to payment service to fetch the updated record and show it on the page
           }
           else
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut));
        }
        
        return null;
    }
    
    /*
        This method is called to update the delivery method when the leveringsmetode button is clicked.
    */
    public pagereference updateInvoiceMedia(){
        
        String strUpdateInvMed = Apexpages.currentPage().getParameters().get('selectInv');

        updateInv(strUpdateInvMed);
        
        return null;      
    }
    
    /* 
        This method is called from the updateInvoiceMedia method to change the leveringsmetode method
    */
    public void updateInv(String strUpdateInvMed){
        HttpResponse responseupdate,responseNotMethod ;
        if(strUpdateInvMed!=''){
            if(strUpdateInvMed == 'PDFMAIL' || strUpdateInvMed == 'REGNING-I-SELVBETJEN')
            {
                //For PDFMAIL and REGNING-I-SELVBETJEN if there is no email address then CallForUpdateInvoiceMediaEmail service is 
                //called which updates both Invoice media with Email from SPOC
                    responseupdate = NetsFeeCallOut.CallForUpdateInvoiceMediaEmail(AccNo,strIp,strUpdateInvMed,mapPaymentProfToInfo.get('emailAddr'),listPermission);
                    system.debug('*********response'+responseupdate.getBody());
                    if(responseupdate != null){
            
                       String errCallOut = Checkvalidity(responseupdate.getBody());
                       if(errCallOut=='')
                         makeHTTPforPaymentProfile(); // updated info to show on page
                       else
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut));
                    }
                }
                else{
                        //if the invoice media is other than PDFMAIL/Self Service 
                        //the payment notification method has to be set. This sets the Mobile No/Email Address for if Payment notification method is CC.
                        responseNotMethod = NetsFeeCallOut.CallForUpdateNotificationMethod(AccNo,strIp,listPermission,mapPaymentProfToInfo);
                        if(responseNotMethod != null){        
                               String errCallOut = Checkvalidity(responseNotMethod.getBody());
                               if(errCallOut==''){
                                    makeHTTPforPaymentProfile();
                                    responseupdate = NetsFeeCallOut.CallForUpdateInvoiceMediaEmail(AccNo,strIp,strUpdateInvMed,mapPaymentProfToInfo.get('emailAddr'),listPermission);
                                    system.debug('*********response'+responseupdate.getBody());
                                    if(responseupdate != null){
            
                                       String errCallOut1 = Checkvalidity(responseupdate.getBody());
                                       if(errCallOut1=='')
                                         makeHTTPforPaymentProfile();
                                       else
                                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut1));
                                    }
                               }
                               else
                                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut));
                        }

                    }
            }
            else{
                responseupdate = NetsFeeCallOut.CallForUpdateInvoiceMedia(AccNo,strIp,strUpdateInvMed);
                system.debug('********* response'+responseupdate.getBody());
                if(responseupdate != null){
            
                   String errCallOut = Checkvalidity(responseupdate.getBody());
                   if(errCallOut=='')
                     makeHTTPforPaymentProfile();
                   else
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut));
                }
            }
            
        }
   // }
    
    /*
        This method calls the BusinessCore services which n turn call RAS for the payments.
        The parameters needed are transaction id,orderid,amount,invoice no and Expiry date.
    */
    public pagereference payServiceMethod(){
        String transid = Apexpages.currentPage().getParameters().get('transId');
        String orderid = Apexpages.currentPage().getParameters().get('orderid');
        Decimal dcmAmt = Decimal.valueOf(Apexpages.currentPage().getParameters().get('dcmAmt'));
        String strinvoice = Apexpages.currentPage().getParameters().get('strinvoice');
        String strExpDate = Apexpages.currentPage().getParameters().get('strExp');
        String strcardmask = Apexpages.currentPage().getParameters().get('cardNoMask1'); // SUPPORT-4681
        HttpResponse responseupdate;
            //responseupdate = NetsFeeCallOut.CallForpayService(AccNo,strIp,strinvoice,transid,dcmAmt);         
             responseupdate = netfeeinvoicesPDFBillsController.payBills(AccNo,strinvoice,orderid,strIp,transid,dcmAmt,strExpDate,NetsFeeCallOut.GetUserMid(),NetsFeeCallOut.GetUserIPAddress(),UserInfo.getUserId(),strcardmask);
             System.debug('**********'+responseupdate.getBody());
        if(responseupdate != null && responseupdate.getStatusCode() == 200){
            
            String errCallOut = Checkvalidity(responseupdate.getBody());
            
            if(errCallOut=='' || errCallOut == null){
                makeHTTPforPaymentProfile();
                getInovoiceBillsByHTTPCallOut();
            }
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCallOut));
        }
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Fejl fra server: '+responseupdate.getStatus()));
        
        return null;
    }
    
    /*
        This method checks the validity of the response whether it is erroneous or not.
    */
    public String Checkvalidity(String s){
        
        Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(s,Map<String,String>.class);
         system.debug('*********'+responseMap); 
        
        if(responseMap.get('status')=='0')
            return '';
        else
            return responseMap.get('errorMessage');
    }
    /*
        SUPPORT-6470
        This method gets the MD5 code.
    */
    public String getMD5CodedValue(String transactionid){
        string md5CodedVal = '';
        NetsFee_DIBS_Settings__c dibsSet = NetsFee_DIBS_Settings__c.getInstance(); 
        string key1 = dibsSet.Key1__c;
        string key2 = dibsSet.Key2__c;
        string currencyMD5 = dibsSet.Currency_MD5__c;
        string curr = dibsSet.Currency__c;
        String input = key1 + 'transact=' + transactionid + '&preauth=true' + currencyMD5 + curr;
        system.debug('input : ' +input);
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(input)));
        system.debug('md5Coded key1' +md5Coded);
        md5Coded = key2 + md5Coded;
        system.debug('md5Coded key2: ' +md5Coded);
        md5CodedVal = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(md5Coded)));
        system.debug('md5CodedVal: ' +md5CodedVal);
        
       return md5CodedVal;
       
    }

}