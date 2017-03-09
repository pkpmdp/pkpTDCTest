public with sharing class CPR_Status {
    
    public String strCPRNumber{get;set;}
    public List<CPRResponse>listCPRResp{get;set;}
    public String strMatch{get;set;}
    public Integer statusCode = 200; 
    public static final Map<String,String>errormessage = new Map<String,String>
    {'172' =>'Personen xxxxxx-xxxx findes ikke i CPR.',
     '52' => 'Personnummeret er udfyldt forkert.Det skal v+ªre gyldigt'};
    
    List<Account>listAcc = new List<Account>();
    public String AccId;
    public CPR_Status(ApexPages.StandardController Ctlr){
        listCPRResp = new List<CPRResponse>();
        AccId = Ctlr.getId();
        strCPRNumber = '';
        listAcc = [SELECT Name,Customer_No__c,Street_YK__c,Street_YK__r.Street__c ,
                            Street_YK__r.House_No__c ,Street_YK__r.Entrance__c,
                                Street_YK__r.Floor__c, Street_YK__r.Door_No__c,
                                    Street_YK__r.Postcode__c,
                                        Street_YK__r.Town__c  from Account where id=:ctlr.getId()];
    }
    public CPR_Status(){}
    public String CPREncypted = '';
    public List<Customer_Log__c>listCustLog;
    public pagereference btnCallOutToBC(){
        listCPRResp = new List<CPRResponse>();
        listCustLog = new List<Customer_Log__c>();
        if(strCPRNumber!=''){
            if(!strCPRNumber.contains('-')){
                if(strCPRNumber.isNumeric()){
                    strCPRNumber = strCPRNumber.trim();  
                    if(strCPRNumber.length() == 10){     
                        CPREncypted = CPRUtil.encryptCPR(strCPRNumber);
                        HttpResponse resp = netfeeinvoicesPDFBillsController.getCPRResponse(CPREncypted,NetsFeeCallOut.GetUserMid(),NetsFeeCallOut.GetUserIPAddress(),UserInfo.getuserId(),AccId);
                        if(Test.isRunningTest()){
                            resp = getCPRresponse(statusCode);
                        }
                        if(resp!=null){
                            if(resp.getStatusCode() == 200){ //resp.getStatus() == 'OK' && 
                                String respBody = resp.getBody();
                                createtable(respBody);  
                                if(strMatch == 'UnMatched'){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.CPRMismatchNotif)); 
                                    String logText = System.Label.CPRMismatch+' '+listCPRResp[0].NameFull+','+
                                    listCPRResp[0].street+(listCPRResp[0].street!=''?',':'')+
                                    listCPRResp[0].streetnumber+(listCPRResp[0].streetnumber!=''?',':'')+
                                    listCPRResp[0].houseLetter+(listCPRResp[0].houseLetter!=''?',':'')+
                                    listCPRResp[0].floor+(listCPRResp[0].floor!=''?',':'')+
                                    listCPRResp[0].floorside+(listCPRResp[0].floorside!=''?',':'')+ 
                                    listCPRResp[0].zipCode+(listCPRResp[0].zipCode!=''?',':'')+ 
                                    listCPRResp[0].city; 
                                    Customer_Log__c objNotes = new Customer_Log__c();
                                    objNotes.Customer__c=AccId;  
                                    objNotes.Text__c = logText;
                                    objNotes.Inquiry_Form__c = 'CPR mismatch'; 
                                    listCustLog.add(objNotes); 
                                    /*if(!listCustLog.isEmpty())
                                        insert listCustLog; */
                                }
                            }
                            else{
                                if(resp.getStatusCode() == 500){
                                    system.debug('resp.getBody()'+resp.getBody());
                                    String s1 = resp.getBody();        
                                    if(s1.contains('StatusCode')){
                                        Integer p = s1.indexOf('StatusCode');
                                        String s = s1.substring(p);
                                        system.debug('s '+s);
                                        Integer f = s.indexOf(',');
                                        String g = s.substring(0,f);
                                        string h = 'StatusCode ';
                                        String l = g.substring((h.length()-1),f);
                                        String intmsg = l.replaceAll( '\\s+', '');
                                        system.debug('intmsg '+intmsg);
                                        if(errormessage.get(intmsg)!=null){  
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errormessage.get(intmsg)));
                                             Customer_Log__c objNotes = new Customer_Log__c();
                                             objNotes.Customer__c=string.valueOf(AccId);
                                             objNotes.Text__c = errormessage.get(intmsg);
                                             objNotes.Inquiry_Form__c = 'CPR error';
                                             listCustLog.add(objNotes);
                                        }
                                        else{
                                             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Intern serverfejl'));  
                                             Customer_Log__c objNotes = new Customer_Log__c();
                                             objNotes.Customer__c=string.valueOf(AccId);
                                             objNotes.Text__c = s1;
                                             objNotes.Inquiry_Form__c = 'CPR error';
                                             listCustLog.add(objNotes); 
                                        }
                                    }
                                }
                                  
                            }
                        }
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.CPRIntegerlessthan10));
                        Customer_Log__c objNotes = new Customer_Log__c();
                        objNotes.Customer__c=string.valueOf(AccId);
                        objNotes.Text__c = System.Label.CPRIntegerlessthan10;
                        objNotes.Inquiry_Form__c = 'CPR error';
                        listCustLog.add(objNotes);  
                    }
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.CPRInvalidInteger));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=string.valueOf(AccId);
                    objNotes.Text__c = System.Label.CPRInvalidInteger;
                    objNotes.Inquiry_Form__c = 'CPR error';
                    listCustLog.add(objNotes);                           
                    
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.CPRValid));
                Customer_Log__c objNotes = new Customer_Log__c();
                objNotes.Customer__c=string.valueOf(AccId);
                objNotes.Text__c = System.Label.CPRValid;
                objNotes.Inquiry_Form__c = 'CPR error';
                listCustLog.add(objNotes);
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.CPRBlank));
            Customer_Log__c objNotes = new Customer_Log__c();
            objNotes.Customer__c=string.valueOf(AccId);
            objNotes.Text__c = System.Label.CPRBlank;
            objNotes.Inquiry_Form__c = 'CPR error';
            listCustLog.add(objNotes);
        }
        if(!listCustLog.isEmpty() && !Test.isRunningTest()){
            insert listCustLog;
         }
        return null;
    }
    
    public void createtable(String resp){
        String respBody ;
        JSONParser parser;
        CPRResponse CPRWrapper;
        try{            
            respBody = resp;
            parser = JSON.createParser(respBody);               
             system.debug('respBody '+respBody);
             while (parser.nextToken() != null) {
                 system.debug('parser.nextToken()' +parser.getCurrentToken());
                 if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    CPRWrapper = (CPRResponse)parser.readValueAs(CPRResponse.class);
                    CPRWrapper.NameFull =  CPRWrapper.firstName+' '+CPRWrapper.lastName;
                    CPRWrapper.source = 'CPR DB';
                    listCPRResp.add(CPRWrapper);
                 }
             }
             if(!listAcc.isEmpty()){
                CPRResponse CPRWrapper1 = new CPRResponse();
                CPRWrapper1.NameFull = listAcc[0].Name;
                CPRWrapper1.street = listAcc[0].Street_YK__r.Street__c;
                CPRWrapper1.streetnumber = listAcc[0].Street_YK__r.House_No__c;
                CPRWrapper1.houseLetter  = listAcc[0].Street_YK__r.Entrance__c;
                CPRWrapper1.floor = listAcc[0].Street_YK__r.Floor__c ;
                CPRWrapper1.floorside = listAcc[0].Street_YK__r.Door_No__c  ;
                CPRWrapper1.zipCode = listAcc[0].Street_YK__r.Postcode__c;
                CPRWrapper1.city = listAcc[0].Street_YK__r.Town__c;
                CPRWrapper1.source = 'Installationsadresse i SPOC';
                listCPRResp.add(CPRWrapper1);
             } 
             if(!listCPRResp.isEmpty()){
                    matchaddress();
                 /*if(listCPRResp[0].NameFull.equalsIgnoreCase(listCPRResp[1].NameFull) &&
                    listCPRResp[0].street.equalsIgnoreCase(listCPRResp[1].street) && 
                    listCPRResp[0].streetnumber.equalsIgnoreCase(listCPRResp[1].streetnumber) && 
                    listCPRResp[0].houseLetter.equalsIgnoreCase(listCPRResp[1].houseLetter)  &&
                    listCPRResp[0].floor.equalsIgnoreCase(listCPRResp[1].floor) && 
                    listCPRResp[0].floorside.equalsIgnoreCase(listCPRResp[1].floorside) &&
                    listCPRResp[0].zipCode.equalsIgnoreCase(listCPRResp[1].zipCode) &&
                    listCPRResp[0].city.equalsIgnoreCase(listCPRResp[1].city)){
                        strMatch = 'Matched';
                    }
                    else{
                        strMatch = 'UnMatched';          
                    }*/
                    system.debug('strMatch=='+strMatch);
                    
             }
                          
        }
        catch(Exception e){         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
            Customer_Log__c objNotes = new Customer_Log__c();
            objNotes.Customer__c=AccId;
            objNotes.Text__c = System.Label.CPRBlank;
            objNotes.Inquiry_Form__c = 'CPR error';
            listCustLog.add(objNotes);             
        } 
        if(!listCustLog.isEmpty() && !Test.isRunningTest())
            insert listCustLog;
    }
    
    public void matchaddress(){
        
        Integer i = 0;
        if(((listCPRResp[0].NameFull!=''&& listCPRResp[0].NameFull!=null)?listCPRResp[0].NameFull.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].NameFull!='' && listCPRResp[1].NameFull!=null)?listCPRResp[1].NameFull.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 1');
            i++;
        }
        
        if(((listCPRResp[0].street!='' && listCPRResp[0].street!=null)?listCPRResp[0].street.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].street!=''&& listCPRResp[1].street!=null)?listCPRResp[1].street.replaceFirst('^0+(?!$)', ''):''))){
            i++;
            system.debug('in 2');
        }
        
        if(((listCPRResp[0].streetnumber!='' && listCPRResp[0].streetnumber!=null)?listCPRResp[0].streetnumber.replaceFirst('^0+(?!$)', ''):listCPRResp[0].streetnumber).equalsIgnoreCase(((listCPRResp[1].streetnumber!='' && listCPRResp[1].streetnumber!=null)?listCPRResp[1].streetnumber.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 3');
            i++;
        }
        
        system.debug('listCPRResp[0].houseLetter'+listCPRResp[0].houseLetter);  
        system.debug('listCPRResp[1].houseLetter'+listCPRResp[1].houseLetter);
        if(((listCPRResp[0].houseLetter!='' && listCPRResp[1].streetnumber!=null)?listCPRResp[0].houseLetter.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].houseLetter!='' && listCPRResp[1].houseLetter!=null)?listCPRResp[1].houseLetter.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 4');
            i++;
        }
        
        if(((listCPRResp[0].floor!='' && listCPRResp[0].floor!=null)?listCPRResp[0].floor.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].floor!='' && listCPRResp[1].floor!=null)?listCPRResp[1].floor.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 5');
            i++;
        }
        
        if(((listCPRResp[0].floorside!='' && listCPRResp[0].floorside!=null)?listCPRResp[0].floorside.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].floorside!=''&& listCPRResp[1].floorside!=null)?listCPRResp[1].floorside.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 6');
            i++;
        }
        
        if(((listCPRResp[0].zipCode!='' && listCPRResp[0].zipCode!=null)?listCPRResp[0].zipCode.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].zipCode!='' && listCPRResp[1].zipCode!=null)?listCPRResp[1].zipCode.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 7');
            i++;
        }
        
        if(((listCPRResp[0].city!='' && listCPRResp[0].city!=null)?listCPRResp[0].city.replaceFirst('^0+(?!$)', ''):'').equalsIgnoreCase(((listCPRResp[1].city!='' && listCPRResp[1].city!=null)?listCPRResp[1].city.replaceFirst('^0+(?!$)', ''):''))){
            system.debug('in 8');
            i++;
        }
        system.debug('i===='+i);
        if(i==8)
            strMatch = 'Matched';
        else
            strMatch = 'UnMatched';         
        
    }
    public String respBodyForKasia;
    public pagereference btnSaveToKasia(){
        system.debug('in save');
            listCustLog = new List<Customer_Log__c>();
            HttpResponse resfromBC = netfeeinvoicesPDFBillsController.saveTokasia(listAcc[0].Customer_No__c, strCPRNumber, NetsFeeCallOut.GetUserMid(),NetsFeeCallOut.GetUserIPAddress(),UserInfo.getuserId(),AccId);
            if(Test.isRunningTest()){
                resfromBC = getSaveError();
            }
            if(resfromBC!=null){
                if(resfromBC.getStatusCode() == 200){//resfromBC.getStatus() == 'OK' && 
                    system.debug('resfromBC '+resfromBC);
                    respBodyForKasia = resfromBC.getBody();
                }  
                else{
                    TrackLogForError(resfromBC);
                } 
            }        
                /*else if(resfromBC.getStatusCode() == 400){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 403){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 404){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 406){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 409){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 412){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 500){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
                 else if(resfromBC.getStatusCode() == 503){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
                    Customer_Log__c objNotes = new Customer_Log__c();
                    objNotes.Customer__c=AccId;
                    objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
                    objNotes.Inquiry_Form__c = 'CPR';
                    listCustLog.add(objNotes);
                }
            
            }
            /*else
                Customer_Log__c objNotes = new Customer_Log__c();
                objNotes.Customer__c=AccId;
                objNotes.Text__c = resfromBC.getStatus()+' : '+resfromBC.getStatus();
                objNotes.Inquiry_Form__c = 'CPR';
                listCustLog.add(objNotes);*/
        
        
        /*if(!listCustLog.isEmpty())
            insert listCustLog;*/
        return null;
    }
    
    public HttpResponse getSaveError(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"reversed_invoice_lines":[{"invoice_no":60066243,"invoice_line_no":1,"invoice_line_service_no":11165924,"invoice_line_reversed_amount":15,"invoice_line_reversing_date":null,"invoice_line_comments":"Blockbuster Ku00f8b (order # 5953263)","client_invoice_line_service_id":"Blockbuster_Ku00f8b"},{"invoice_no":60066243,"invoice_line_no":2,"invoice_line_service_no":10004,"invoice_line_reversed_amount":3.75,"invoice_line_reversing_date":null,"invoice_line_comments":"Value Added Tax (VAT)","client_invoice_line_service_id":"10004"}],"applied_total_refund_amount":18.75,"applied_total_reversal_amount":18.75,"transaction_id":"83436174","error_code":0,"error_msg":"OK"}');
        res.setStatusCode(200);
        return res;
        
    }
    
    public void TrackLogForError(HttpResponse resfromBC){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,resfromBC.getStatus()));
        Customer_Log__c objNotes = new Customer_Log__c();
        objNotes.Customer__c=AccId;
        objNotes.Text__c = resfromBC.getStatusCode()+' : '+resfromBC.getStatus();
        objNotes.Inquiry_Form__c = 'CPR error';
        listCustLog.add(objNotes);
        
        if(!listCustLog.isEmpty())
            insert listCustLog;
    }
    
    public pagereference btnSaveToSpoc(){
        system.debug('in spoc save');   
        if(respBodyForKasia == '"OK"'){
            system.debug('In here');
            try{
                Account objAcc = new Account(id=AccId);
                system.debug('System.now===='+System.now());
                //objAcc.CPR_Status__c = System.now();
                String CPRValDate = System.now().format('dd-MM-yyyy'); 
                String CPRValTime = System.now().format('HH:mm');
                objAcc.CPR_Status__c = CPRValDate+' '+CPRValTime;
                objAcc.CPR_No__c = strCPRNumber.substring(0,6)+'****';
                update objAcc; 
                
                savematchdatatolog();
                
            }
            catch(Exception e){
                system.debug('exception '+e.getMessage());
            }           
            Pagereference pr = new Pagereference('/'+AccId);
            pr.setRedirect(true);
            return pr;
        }
        else
            return null;    
        
    }
    
    public void savematchdatatolog(){
        String logText = System.Label.CPRMatchData+' '+listCPRResp[0].NameFull+','+
        listCPRResp[0].street+(listCPRResp[0].street!=''?',':'')+
        listCPRResp[0].streetnumber+(listCPRResp[0].streetnumber!=''?',':'')+
        listCPRResp[0].houseLetter+(listCPRResp[0].houseLetter!=''?',':'')+
        listCPRResp[0].floor+(listCPRResp[0].floor!=''?',':'')+
        listCPRResp[0].floorside+(listCPRResp[0].floorside!=''?',':'')+ 
        listCPRResp[0].zipCode+(listCPRResp[0].zipCode!=''?',':'')+ 
        listCPRResp[0].city; 
        Customer_Log__c objNotes = new Customer_Log__c();
        objNotes.Customer__c=AccId;  
        objNotes.Text__c = logText;
        objNotes.Inquiry_Form__c = 'CPR success'; 
        listCustLog.add(objNotes); 
        if(!listCustLog.isEmpty())
            insert listCustLog;
    }
    
    public pagereference btnCancel(){
        Pagereference pr = new Pagereference('/'+AccId);
        pr.setRedirect(true);
        return pr;
    }
    
    public pagereference btnsaveMismatchtoLog(){
    
        String logText = System.Label.CPRMismatch+' '+listCPRResp[0].NameFull+','+
        listCPRResp[0].street+(listCPRResp[0].street!=''?',':'')+
        listCPRResp[0].streetnumber+(listCPRResp[0].streetnumber!=''?',':'')+
        listCPRResp[0].houseLetter+(listCPRResp[0].houseLetter!=''?',':'')+
        listCPRResp[0].floor+(listCPRResp[0].floor!=''?',':'')+
        listCPRResp[0].floorside+(listCPRResp[0].floorside!=''?',':'')+ 
        listCPRResp[0].zipCode+(listCPRResp[0].zipCode!=''?',':'')+ 
        listCPRResp[0].city; 
        Customer_Log__c objNotes = new Customer_Log__c();
        objNotes.Customer__c=AccId;  
        objNotes.Text__c = logText;
        objNotes.Inquiry_Form__c = 'CPR mismatch'; 
        listCustLog.add(objNotes); 
        if(!listCustLog.isEmpty())
            insert listCustLog; 
        return null;
    }
    public class CPRResponse{
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String cprStatus{get;set;}
        public String locality{get;set;}
        public String street{get;set;}
        public String streetnumber{get;set;}
        public String houseLetter{get;set;}
        public String floor{get;set;}
        public String floorside{get;set;}
        public String zipCode{get;set;}
        public String city{get;set;}
        public String co{get;set;}
        public String placeName{get;set;}
        public String streetCode{get;set;}
        public String muncipality{get;set;}
        public String muncipalityCode{get;set;}
        public String StreetFull{get;set;}
        public String HouseFull{get;set;}
        public String NameFull{get;set;}
        public String source{get;set;}
        //public Error objerr{get;set;}
        
        public CPRResponse(){}
        
    }
    
    public class errresponse{
        public String code{get;set;}
        public String message{get;set;}
        public String stacktrace{get;set;}
        public String requestID {get;set;}
        public String timestamp {get;set;}
    }

    
    /*public HttpResponse getCPRresponse(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"firstName":"Jens","lastName":"Mortensen","cprStatus":"01","locality":"","street":"Boulevarden","streetnumber":"101","houseLetter":"","floor":"01","floorside":"mf","zipCode":"6800","city":"Varde","co":"","placeName":"","streetCode":"5731","muncipality":"Varde","muncipalityCode":"573"}');
        res.setStatusCode(200);
        //res.setStatus = 'OK';
        return res;
    } */
    public HttpResponse getCPRresponse(Integer statusCode){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(statusCode == 200)
        {
            res.setBody('{"firstName":"Jens","lastName":"Mortensen","cprStatus":"01","locality":"","street":"Boulevarden","streetnumber":"101","houseLetter":"","floor":"01","floorside":"mf","zipCode":"6800","city":"Varde","co":"","placeName":"","streetCode":"5731","muncipality":"Varde","muncipalityCode":"573"}');
            res.setStatusCode(200);            
        }
        else if(statusCode == 500)
        {
            res.setBody('{"firstName":"Jens","lastName":"Mortensen","cprStatus":"01","locality":"","StatusCode":"500","street":"Boulevarden","streetnumber":"101","houseLetter":"","floor":"01","floorside":"mf","zipCode":"6800","city":"Varde","co":"","placeName":"","streetCode":"5731","muncipality":"Varde","muncipalityCode":"573"}');
        res.setStatusCode(500);
        }
        
        //res.setStatus = 'OK';
        return res;
    }
    
   
}