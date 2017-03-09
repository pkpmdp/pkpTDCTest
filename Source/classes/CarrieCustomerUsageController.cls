/**********************************************************************************
************************************************************************************

* @class: CarrieCustomerUsageController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 07/03/2012
* @description: Class is used to display telifoni usage for a customer

************************************************************************************ 
***********************************************************************************/
public class CarrieCustomerUsageController{
    public String JSONString {get; set;}
    public String fromDate{get; set;}
    public String toDate{get; set;}
    public String selectedPeriod {get; set;}
    public boolean noRecords{get;set;}
    public String errorMessage{get;set;}
    public String startDate{get;set;}
    public String searchEndDate{get;set;}
    public String noRecError{get;set;}
    public String visAlt{get; private set;}
    public String dateType {get;set;}
    public List<UsageTree> usageSummary{get;set;}
    public boolean isApexTest;
    public List<UsageTree> usageList = new List<UsageTree>();
    boolean valid {get;set;}
    Aria_Account__c controllerCustomer = new Aria_Account__c();
    Map<Integer,String> monthMap = new Map<Integer,String>();
    Map<String,DateTime> stringDateMap = new Map<String,DateTime>();
    String response = '';
    List<UsageTree> usageListSorted;
    public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    private final String END_POINT = castIronEndPoint.END_POINT__c;
    private limitWrapper[] thousandBlocks = new limitWrapper[]{};
    private final integer listLimit;
    public CarrieCustomerUsageController(ApexPages.StandardController controller) {
        JSONString = '[]';
        selectedPeriod = '';
        noRecords = false;
        valid = true;
        visAlt = '0.0';
        dateType = '';
        isApexTest = false;
        listLimit = 1000;
        controllerCustomer = (Aria_Account__c)controller.getRecord();
    }/**
    * @description: Construct a list of valid time periods
    * @return: Options : Time period
    */
    public List<Selectoption> getTimePeriod(){
        List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('Vælg periode','Vælg periode'));
        option.add(new SelectOption('I dag','I dag'));
        option.add(new SelectOption('Seneste uge','Seneste uge'));
        option.add(new SelectOption('Seneste måned','Seneste måned'));
        List<String> previousMonths = new List<String>();
        previousMonths = getPreviousMonths();
        for(String month : previousMonths){
            option.add(new SelectOption(month,monthMap.get(Integer.valueOf(month))));
        } 
        return option;      
    }      
    /**
    * @description: Rerender dates depending upon period selected
    * @return: PageReference
    */   
    public PageReference reRenderDates(){       
        valid = true;   
        if(selectedPeriod!='Vælg periode'){
            startDate = '';
            searchEndDate = '';
            Date toDay;
            if(!isApexTest)
                toDay = date.today();
            else
                toDay = date.newinstance(2012, 1, 1);   
            Integer currMonth = toDay.month();
            Integer currYear = toDay.year();
            Integer prevMonth = currMonth;
            Integer prevYear = currYear;
            Integer daysInMonth = 0;
            Integer currDay = toDay.day();
            toDate = toDay.format();
            if((currDay == 1 && selectedPeriod == 'I dag')||(currDay <= 7 && selectedPeriod == 'Seneste uge')||(selectedPeriod=='Seneste måned')){
                if(currMonth==1){
                    prevMonth = 12;
                    prevYear = currYear - 1;
                } else
                    prevMonth = currMonth - 1;
            }
            //If today is selected
            if(selectedPeriod == 'I dag'){
                if(currDay==1)
                    daysInMonth = date.daysInMonth(prevYear, prevMonth);
                else daysInMonth = currDay -1;
                Date fraDato = date.newInstance(prevYear,prevMonth,daysInMonth);
                fromDate = fraDato.format();
            }else if(selectedPeriod == 'Seneste uge'){
                //If last week is selected
                if(currDay>7)                      
                    fromDate = (toDay-7).format();
                else{
                    integer balance = 7-currDay;
                    daysInMonth = date.daysInMonth(prevYear, prevMonth);
                    integer firstDayOfWeek = daysInMonth-balance;
                    Date fraDato = date.newInstance(prevYear,prevMonth,firstDayOfWeek);
                    fromDate =  fraDato.format();
                }
            }else{ 
                //If any of the previous months is selected
                if(selectedPeriod!='Seneste måned'){
                    Integer month = Integer.valueOf(selectedPeriod);
                    if(month>currMonth)
                        prevYear = currYear - 1;                                   
                    prevMonth = month;
                }
                daysInMonth = date.daysInMonth(prevYear, prevMonth);
                Date fraDato = date.newInstance(prevYear,prevMonth,01);
                Date tilDato = date.newInstance(prevYear,prevMonth,daysInMonth);
                fromDate = fraDato.format();
                toDate = tilDato.format();
            }                                                  
            startDate = '';
            searchEndDate = '';
            errorMessage = '';
            noRecError = '';
            noRecords = false;
            JSONString = '[]';
        }
        return null;
    }
    /**
    * @description: Determine which date fields are left empty by user
    */   
    public void setDateType(){
        system.debug('dateType in setCalType - CarrieCustomerUsageController' +dateType);
        errorMessage = '';
        if(dateType == 'bothDate')
            errorMessage += '<li>Fra-dato</li><li>Til-dato</li>';
        else {       
            if(dateType == 'fromDate')
                errorMessage += '<li>Fra-dato</li>';
            if(dateType == 'toDate')
                errorMessage += '<li>Til-dato</li>';
        }       
        if(errorMessage != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Indtast følgende information: <ul>' + errorMessage + '</ul>Eller vælg en periode fra drop down listen'));
            valid = false;                          
        }     
    }
   
    /**
    * @description: Checks if the date to be sent for processing is valid
    * @return: true if date is valid else false
    */   
    private boolean isDateValid(){
        //If a time period is not selected from drop down
        if(selectedPeriod=='Vælg periode'){
            Date fraDato;
            Date tilDato;
            List<String> fromList = new List<String>();
            List<String> toList = new List<String>();
            boolean bothDates = false;
            try{                                                          
                if(startDate!='' && startDate != null)
                    fromDate = startDate;
                if(searchEndDate!='' && searchEndDate != null)                              
                    toDate = searchEndDate;   
                fromList = fromDate.split('-');
                fraDato = Date.valueOf(fromList[2] + '-' + fromList[1] + '-' + fromList[0]);
                toList = toDate.split('-');                
                tilDato = Date.valueOf(toList[2] + '-' + toList[1] + '-' + toList[0]);                                                                                      
                //check if the dates provided are valid and in correct format   
                if(fraDato!=null && tilDato!=null){
                    if(fraDato > tilDato){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.toDateGtFromDate));
                        valid = false;
                    }  
                    if(fraDato > system.today() && tilDato > system.today()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.datesGtToday));
                        valid = false;
                        bothDates = true;
                    }  
                    if(fraDato > system.today() && bothDates == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.fromDateGtToday));
                        valid = false;
                    } 
                    if(tilDato > system.today() && bothDates == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.toDateGtToday));
                        valid = false;
                    }  
                }                                                                                                                                                                                                                                       
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.invalidDateFormat));
                system.debug('Exception in isDateValid - CarrieCustomerUsageController ' +ex.getMessage());
                valid = false;
            }         
        } 
        return valid;
    }
               
    /**
    * @description: Request response from ARIA from the data provided by the user
    * @return: PageReference
    */   
    public PageReference getUsageDetails(){        
        JSONString = '';
        noRecError = '';
        string error = '';
        valid = true;
        errorMessage = '';
                                        
        setDateType();
        system.debug('valid in getUsageDetails - CarrieCustomerUsageController ' +valid);
        if(valid && (errorMessage == '' || errorMessage == null)){
            reRenderDates();
            boolean isDateValid = isDateValid();
            if(isDateValid){
                Httprequest request = new Httprequest();
                String body = ''; 
                if(controllerCustomer.account__r.Customer_No__c != null){
                    string accNo = controllerCustomer.account__r.Customer_No__c;
                    if(controllerCustomer.account__r.Customer_No__c.contains(','))
                        accNo = controllerCustomer.account__r.Customer_No__c.replace(',','');                                       
                    //body = '<?xml version="1.0" encoding="UTF-8"?><telephony><account_no>'+accNo+'</account_no><start_dt>'+fromDate+'</start_dt><end_dt>'+toDate+'</end_dt></telephony>';
                    //FOR PRODUCTION
                    body = '<?xml version="1.0" encoding="UTF-8"?><telephony><accountno>'+accNo+'</accountno><startdt>'+fromDate+'</startdt><enddt>'+toDate+'</enddt></telephony>';
                    system.debug('request body:'+body);
                    //request.setEndpoint(System.label.CarrieCustomerUsageTelefoni +'/telefoni'); 
                    String endpoint =  clsConnectionUtils_Admin.getEndPoint('telefoni');
                    request.setEndpoint(endpoint);
                    String method = INTEGRATION__c.getInstance('telefoni') != null ? INTEGRATION__c.getInstance('telefoni').HttpMethod__c : 'GET';
                    System.debug('*****endpoint****'+endpoint+'\n********method****'+method);
                    request.setMethod(method); 
                    request.setBody(body); 
                    request.setTimeout(60000); 
                    String httpResp = '';
                    try{
                        Http http = new Http(); 
                        Httpresponse response;
                        if(!isApexTest){                            
                            response = http.send(request);
                            httpResp = response.getBody();
                            system.debug('response -> '+httpResp);
                        }    
                        if(httpResp != null && httpResp.contains('usage'))        
                            generateTree(httpResp);           
                        else{
                            noRecords = true;
                            noRecError = 'Intet forbrug i denne periode ';
                        }   
                    }catch(CalloutException ex){
                        noRecords = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.timeoutError));
                        system.debug('Exception in getUsageDetails - CarrieCustomerUsageController ' +ex.getMessage());
                    }  
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.noCustNum));
                    noRecords = true; 
                    noRecError = '';  
                }                                                                  
            }         
        }        
        dateType = '';                                    
        return null;                
    }

    /**
    * @description: Generate response string compatible with Dynatree
    * @param: aria response returned from getUsageDetails() method
    */   
    public void generateTree(String ariaResponse){
        integer totalCalls = 0;  
        JSONString = '';  
        String startTime = '';                    
        String duration = '';                 
        String amount = '';
        String usagetype = ''; //CARRIE-893
        noRecords = false;            
        usageList = new List<UsageTree>();
        //String visAlt = '';
                
        try{
            //Added for Support-1802
            //Converts JSON response into list
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(ariaResponse);
            //Assign each usage node to a map and process each map.
            Map<String,Object> firstMap = new Map<String,Object>();
            for(Object resp : jsonResponse){
                firstMap = (Map<String, Object>)resp;
                Map<String, Object> rootDataMap;//CARRIE-717
                System.debug('717 First Map '+ firstMap); 
                
                if(firstMap != null && firstMap.get('usage') != null){
                    firstMap = (Map<String, Object>)firstMap.get('usage');
                    visAlt = String.valueOf(firstMap.get('amount'));
                    visAlt = currency(visAlt); //CARRIE-963
                    String calls = String.valueOf(firstMap.get('calls'));
                    rootDataMap = (Map<String, Object>)firstMap.get('data');//CARRIE-717
                    //System.debug('717 First Map 1 '+ rootDataMap);//717
    
                    for(String rootDataNode : rootDataMap.keySet()){
                        String userNumber = rootDataNode;              
                       
                      //  for(String keys: firstMap.keySet()){ //CARRIE-717
                      //      userNumber = keys; //CARRIE-717
                      //  }  //CARRIE-717
                        Pattern valid_characters = Pattern.compile('([0-9]+)'); 
                        firstMap = (Map<String, Object>)rootDataMap.get(userNumber); 
                        firstMap = (Map<String, Object>)firstMap.get('data');
                        //firstMap now contains main nodes (eg: Opkald til Danmark, Opkald til servicenumre, Opkaldsafgift, Opkaldsforsøg)
                        for(String mainNodes : firstMap.keySet()){
                            Map<String, Object> secondMap = (Map<String, Object>)firstMap.get(mainNodes);  
                            //secondMap contains child nodes (eg: Opkald til Mobil)
                            String mainCalls = String.valueOf(secondMap.get('calls'));
                            String mainAmount = String.valueOf(secondMap.get('amount'));
                            mainAmount = currency(mainAmount); //CARRIE-963     
                            String parentType =  mainCalls + ' stk ' + mainNodes;     
                            JSONString += '{title : "<span class=\'td2_1\'>' +parentType+ '</span><span class=\'td2_2\'>' +mainAmount+ '</span>#"';                                             
                            String thirdMapString = String.valueOf(secondMap.get('data'));
                            //For scenarios with no child nodes eg: debiting, crediting
                            if(thirdMapString.indexOf('(') == 0){
                            List<Object> thirdMapList = (List<Object>)secondMap.get('data');
                            Integer thirdListCount = 0;
                            for(Object o : thirdMapList){
                                Map<String, Object> mappp = (Map<String, Object>)o;
                                startTime = String.valueOf(mappp.get('start-time'));
                                duration = String.valueOf(mappp.get('duration'));
                                amount = String.valueOf(mappp.get('amount')); 
                                amount = currency(amount); //CARRIE-963 
                                usagetype = String.valueOf(mappp.get('usagetype')); //CARRIE-893
                                thirdListCount++;
                                if(thirdListCount == thirdMapList.size())
                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+usagetype+'</span><span class=\'td4_3\'>'+duration+'</span><span class=\'td4_4\'>'+amount+'</span>^"}';
                                else
                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+usagetype+'</span><span class=\'td4_3\'>'+duration+'</span><span class=\'td4_4\'>'+amount+'</span>^"},';   
                                
                                /* CARRIE-963 if(thirdListCount == thirdMapList.size())
                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+duration+'</span><span class=\'td4_3\'>'+amount+'</span>^"}';
                                else
                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+duration+'</span><span class=\'td4_3\'>'+amount+'</span>^"},';   */
                                
                                //Add to Usage List
                                UsageTree uTObj = new UsageTree();
                                uTObj.callToNumber = mainNodes;  
                                uTObj.numberForEmail = mainNodes;                                                                 
                                uTObj.startDate = startTime;
                                uTObj.duration = duration;                           
                                uTObj.amount = amount;
                                usageList.add(uTObj);                                                   
                                
                                //create a map for string and dateTime
                                integer index = startTime.indexOf(' ');
                                string dateString = startTime.subString(0,index);
                                string timeString = startTime.subString(index+1);
                                List<String> dList = dateString.split('-');
                                List<String> timeList = timeString.split(':');
                                string stringDate = dList[2] + '-' + dList[1] + '-' + dList[0] + 
                                    ' ' + timeList[0] + ':' + timeList[1] +  ':' + timeList[2];
                                Datetime Dt = datetime.valueOf(stringDate); 
                                stringDateMap.put(startTime,Dt);   
                            }  
                        } 
                        else{ 
                            Map<String, Object> thirdMap = (Map<String, Object>)secondMap.get('data');     
                            //System.debug('thirdMap 717: '+thirdMap);         
                            Integer thirdNodesCount = 0;
                            JSONString += ', children : [';                 
                            for(String thirdNodes : thirdMap.keySet()){                 
                                Map<String, Object> fourthMap = (Map<String, Object>)thirdMap.get(thirdNodes);  
                                mainCalls = String.valueOf(fourthMap.get('calls'));
                                parentType =  mainCalls + ' stk ' + thirdNodes; 
                                if(!parentType.contains('Opkaldsafgift') && !parentType.contains('Opkaldsforsøg')){
                                    JSONString += '{title : "'+parentType+'#"'+ 
                                         ', children : [' ;                                  
                                }                        
                                if(fourthMap.get('data') != null){
                                    fourthMap = (Map<String, Object>)fourthMap.get('data');                     
                                    Integer fourthNodesCount = 0;
                                    for(String fourthNodes : fourthMap.keySet()){
                                        Matcher check_chars = valid_characters.matcher(fourthNodes);
                                        if(check_chars.matches()){
                                            Map<String, Object> fifthMap = (Map<String, Object>)fourthMap.get(fourthNodes); 
                                            mainCalls = String.valueOf(fifthMap.get('calls'));
                                            
                                            String callToNumberSummary = '';
                                            String numberForEmail = '';
                                            String callToNumber = '';
                                            
                                            //Add * at end for email
                                            Integer numLength = fourthNodes.length();
                                            numberForEmail = fourthNodes;
                                            if(fourthNodes.length()>4)
                                                numberForEmail = fourthNodes.subString(0,4);
                                            for(integer no=0;no<numLength-4;no++){
                                                numberForEmail+='*';
                                            }                                        
                                            System.debug('ThirdNode'+ thirdNodes);
                                            //Create different strings for different display
                                            if(thirdNodes.contains(' ')){
                                                integer lastindex = thirdNodes.lastIndexOf(' ');
                                                callToNumber = mainCalls + ' stk ' + thirdNodes.subString(0,lastindex) + ' ' + fourthNodes;
                                                callToNumberSummary = thirdNodes.subString(0,lastindex) + ' ' +fourthNodes;                             
                                                //numberForEmail = thirdNodes.subString(0,lastindex) + ' ' +numberForEmail;   //CARRIE-893                   
                                            }else{
                                            
                                                callToNumber = mainCalls + ' stk ' + thirdNodes + ' ' + fourthNodes;
                                                callToNumberSummary = thirdNodes + ' ' +fourthNodes;                             
                                                //numberForEmail = thirdNodes + ' ' +numberForEmail; //CARRIE-893
                                            
                                            }                                                                                   
                                          
                                            JSONString += '{title : "'+callToNumber+'#"';
                                            JSONString += ', children : ['; 
                                            /* CARRIE-963 JSONString += '{title : "<span class=\'td4_1\'>Dato</span><span class=\'td4_2\'>Varighed</span><span class=\'td4_3\'>Pris i dkk.</span>#",addClass:"colored"},'; */
                                            JSONString += '{title : "<span class=\'td4_1\'>Dato</span><span class=\'td4_2\'>Beskrivelse</span><span class=\'td4_3\'>Varighed</span><span class=\'td4_4\'>Pris i dkk.</span>#",addClass:"colored"},';
                                            List<Object> fifthList = (List<Object>)fifthMap.get('data');    
                                            Integer fifthListCount = 0;
                                            for(Object o : fifthList){
                                                Map<String, Object> mappp = (Map<String, Object>)o;
                                                startTime = String.valueOf(mappp.get('start-time'));
                                                duration = String.valueOf(mappp.get('duration'));
                                                amount = String.valueOf(mappp.get('amount')); 
                                                usagetype = String.valueOf(mappp.get('usagetype'));
                                                amount = currency(amount); //CARRIE-963 
                                                fifthListCount++;
                                                if(fifthListCount==fifthList.size())
                                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+usagetype+'</span><span class=\'td4_3\'>'+duration+'</span><span class=\'td4_4\'>'+amount+'</span>^"}';
                                                else
                                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+usagetype+'</span><span class=\'td4_3\'>'+duration+'</span><span class=\'td4_4\'>'+amount+'</span>^"},';  
                                                
                                                /* CARRIE-963 if(fifthListCount==fifthList.size())
                                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+duration+'</span><span class=\'td4_3\'>'+amount+'</span>^"}';
                                                else
                                                    JSONString += '{title : "<span class=\'td4_1\'>'+startTime+'</span><span class=\'td4_2\'>'+duration+'</span><span class=\'td4_3\'>'+amount+'</span>^"},'; */
                                                       
                                                //system.debug(mainNodes + ' : ' + thirdNodes + ' : ' + fourthNodes + ' : ' + startTime + ' : ' + duration  + ' : ' + amount);
                                                system.debug('numberForEmail: '+numberForEmail);
                                                //Add to Usage List
                                                UsageTree uTObj = new UsageTree();
                                                //uTObj.callToNumber = callToNumberSummary;    //CARRIE-893
                                                uTObj.callToNumber = usagetype + ' ' +fourthNodes;  //CARRIE-893
                                                //uTObj.numberForEmail = numberForEmail;   //CARRIE-893
                                                uTObj.numberForEmail = usagetype + ' ' +numberForEmail; //CARRIE-893                                                           
                                                uTObj.startDate = startTime;
                                                uTObj.duration = duration;                           
                                                uTObj.amount = amount;
                                                usageList.add(uTObj);                                                   
                                                
                                                //create a map for string and dateTime
                                                integer index = startTime.indexOf(' ');
                                                string dateString = startTime.subString(0,index);
                                                string timeString = startTime.subString(index+1);
                                                List<String> dList = dateString.split('-');
                                                List<String> timeList = timeString.split(':');
                                                string stringDate = dList[2] + '-' + dList[1] + '-' + dList[0] + 
                                                    ' ' + timeList[0] + ':' + timeList[1] +  ':' + timeList[2];
                                                Datetime Dt = datetime.valueOf(stringDate); 
                                                stringDateMap.put(startTime,Dt);   
                                            }  
                                            fourthNodesCount++;                                                                     
                                            if(fourthNodesCount == fourthMap.size() && thirdNodesCount+1 == thirdMap.size())
                                                JSONString += ']}';                                                                            
                                            else
                                                JSONString += ']},';                                                                                                    
                                        }
                                    }
                                }
                                thirdNodesCount++; 
                                if(!parentType.contains('Opkaldsafgift') && !parentType.contains('Opkaldsforsøg')) {
                                    if(thirdNodesCount == thirdMap.size())
                                        JSONString += ']}';
                                    else
                                        JSONString += ']},';                                   
                                }                    
                            }                        
                        }   
                        JSONString += ']},';            
                    }   
                }
                }         
            }//Each usage for loop ends
        }//try ends
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,CarrieGlobalConstants.jsonParsingError));
            system.debug('Exception in generateTree - CarrieCustomerUsageController ' +ex.getMessage());
            noRecords = true;
            noRecError = '';   
        }                
        if(JSONString.length()<=0) {
            noRecords = true;
            noRecError = 'Intet forbrug i denne periode ';
        } 
        else{
            String sumResponse = summarizedResponse();
            String vis = '{title : "<span class=\'td2_1\'>Vis Alt</span><span class=\'td2_2\'>' +visAlt+ '</span>' + '#"}';
            JSONString = '[' + sumResponse + JSONString + vis +']';
        }   
        system.debug('aabbccdd '+JSONString);
    }

    /**
    * @description: Navigate to Billing page
    * @return: PageReference: CarrieCustomerBillingPage
    */   
    public PageReference backToCustomer(){
        PageReference pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+controllerCustomer.Id); 
        pageRef.setRedirect(true);
        return pageRef;
    }   

    /**
    * @description: To create list of usages, thousand usages per list to avoid visualforce page error
    * @return: List<limitWrapper> list of usages
    */ 
    public List<limitWrapper> getthousandBlocks(){
        usageSummary = new List<UsageTree>();
        usageSummary = usageListSorted;
        thousandBlocks = new limitWrapper[]{};
        integer counter = 0;
        integer loopCount = 0;
        List<UsageTree> tmpUsageList = new List<UsageTree>();
        if(usageSummary != NULL && usageSummary.size() > listLimit){
            system.debug('exceeds vf limit');
            for(UsageTree usage : usageSummary){
                if(counter < listLimit){
                    tmpUsageList.add(usage);
                    counter++;
                }else{
                    loopCount++;
                    thousandBlocks.add(new limitWrapper(tmpUsageList,loopCount));
                    tmpUsageList = new List<UsageTree>();
                    tmpUsageList.add(usage);
                    counter = 0;
                }       
            }           
        }
        else
            thousandBlocks.add(new limitWrapper(usageSummary,1));        
        return thousandBlocks;
    }
    
    /**
    * @description: Render Usage Summary as a PDF
    * @return: PageReference: CarrieUsagePDFPage
    */  
    public PageReference renderAsPDF() {        
        PageReference pageRef = new PageReference('/apex/CarrieUsagePDFPage?Id='+controllerCustomer.Id); 
        return pageRef;
    } 
    
    /**
    * @description: Send Usage Summary as a PDF attachment in an email
    * @return: PageReference: CarrieUsagePDFPage
    */  
    public PageReference emailAsPDF(){        
        PageReference pageRef;        
        try{   
            String personEmail = [Select PersonEmail from Account where Id =: controllerCustomer.account__c].PersonEmail;
            if(personEmail != null){       
                pageRef = new PageReference('/apex/CarrieUsagePDFPage?Id='+controllerCustomer.Id);        
                pageRef.setRedirect(true);
                Blob pdfContent;
                if(!isApexTest)
                    pdfContent = pageRef.getContent();
                    
                String foreningsOrgEmailAddDisplayName =  CarrieCustomSettings__c.getInstance('CarrieDisplayNameforUsage').Value__c;
                //Construct the attachment
                Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                fileAttachment.setFileName('Samtaleoversigt.pdf');
                if(!isApexTest)
                    fileAttachment.setBody(pdfContent);
                else{
                    Blob dummyBody = Blob.valueof('Dummy Content in email body for Apex Test Run');            
                    fileAttachment.setBody(dummyBody);
                }       
                
                //Construct the email 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                    
                String ccAddresses = CarrieCustomSettings__c.getInstance('CCEmailForUsage').Value__c;
                String emailBody = 'Hej ' + controllerCustomer.account__r.Name + ',<br/><br/>'+
                 'Som aftalt får du her en oversigt over dine telefonisamtaler for den ønskede periode.<br/>'+
                 'Du kan også se dine samtaler og dit forbrug ved at logge på Mit YouSee med dit YouSee brugernavn og adgangskode og vælge "Regninger og betaling".<br/>'+
                 'Du finder Mit YouSee her http://www.yousee.dk/mityousee<br/><br/>'+
                 'Venlig hilsen<br/>'+
                 'YouSee Kundeservice';
                                  
                email.setSubject('Telefoni samtaleoversigt'); 
                email.sethtmlBody(emailBody);                      
                email.toAddresses = new String[] {personEmail};
                //email.toAddresses = new String[] {'prachi.dhaundiyal@capgemini.com','roshan.sahatiya@capgemini.com'};
                OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName =: foreningsOrgEmailAddDisplayName limit 1];
                email.setOrgWideEmailAddressId(owa.id);             
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {fileAttachment}); // Sends the email 
                
                Messaging.SendEmailResult [] results = 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});    
                if (results[0].isSuccess())             
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email er send til ' +personEmail));
            }     
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er ikke registereret en email adresse på kunden'));
            }                                                       
        } 
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Send email fejlede.'));
            system.debug('Exception in emailAsPDF - CarrieCustomerUsageController ' +ex.getMessage());
        }
        //pageRef = new PageReference('/apex/CarrieCustomerUsagePage'); 
        //pageRef.getParameters().put('Id', controllerCustomer.Id);
        //pageRef.setRedirect(false);
        return null;
    } 
        
    /**
    * @description: Create summary response. Includes all calls made by a particular user in a particular time period
    * @return: Usage Summary String
    */  
    private String summarizedResponse(){
        String sumResponse = '';
        usageListSorted = new List<UsageTree>();
        usageListSorted = sortTree();
        usageSummary = new List<UsageTree>();
        usageSummary = usageListSorted;
        system.debug('usageSummary in summarizedResponse - CarrieCustomerUsageController' +usageSummary);
        if(usageListSorted.size()>0){           
            sumResponse += '{title : "Se alle periodens bevægelser fra ' +fromDate+ ' til ' +toDate+ '#"'; 
            sumResponse += ',children: [' +
            '{title : "<span class=\'td4_1\'>Dato</span><span class=\'td4_2\'>Beskrivelse</span><span class=\'td4_3\'>Varighed</span><span class=\'td4_4\'>Pris i dkk.</span>#",addClass:"colored"},';
        }          
        integer count=0;             
        for(UsageTree usage : usageListSorted){  
            count++;            
            if(count != usageListSorted.size())
                sumResponse += '{title : "<span class=\'td4_1\'>' +usage.startDate+ '</span><span class=\'td4_2\'>' +usage.callToNumber+ '</span><span class=\'td4_3\'>' +usage.duration+ '</span><span class=\'td4_4\'>' +usage.amount+ '</span>^"},';
            else  
                sumResponse += '{title : "<span class=\'td4_1\'>' +usage.startDate+ '</span><span class=\'td4_2\'>' +usage.callToNumber+ '</span><span class=\'td4_3\'>' +usage.duration+ '</span><span class=\'td4_4\'>' +usage.amount+ '</span>^"}';                 
        }
        if(usageListSorted.size()>0){
            sumResponse += ']';
            sumResponse += '},';
        }
        return sumResponse;
    }

    /**
    * @description: Sorts the tree to display data in ascending order of start time 
    * @return: List<UsageTree> sorted by time 
    */  
    private List<UsageTree> sortTree(){
        Map<DateTime,UsageTree> dateUsageMap = new Map<DateTime,UsageTree>();
        Set<DateTime> dupTimeUsages = new Set<DateTime>();
        List<UsageTree> dupUsages = new List<UsageTree>();
        List<UsageTree> usageSorted = new List<UsageTree>();
        for(UsageTree usage: usageList){           
            Datetime dates = stringDateMap.get(usage.startDate);
            if(dateUsageMap.keySet().contains(dates)) {
                dupTimeUsages.add(dates);
                dupUsages.add(usage);
            }else    
                dateUsageMap.put(dates,usage); 
        }
        
        List<DateTime> dateTimeList = new List<DateTime>();
        dateTimeList.addAll(dateUsageMap.keySet());
        dateTimeList.sort();
        
        for(DateTime dates : dateTimeList){
            usageSorted.add(dateUsageMap.get(dates));
            if(dupTimeUsages.contains(dates)){
                for(UsageTree usage : dupUsages){                   
                    Datetime usageDate = stringDateMap.get(usage.startDate);
                    if(usageDate == dates) {                       
                        usageSorted.add(usage);
                    }
                }
            }
        }
        return usageSorted;
    }
       
    /**
    * @description: Creates a Map of months for adding in *Vælg periode* drop down
    * @return: List of months
    */  
    private List<String> getPreviousMonths(){       
        monthMap.put(01,'Januar');  
        monthMap.put(02,'Februar');        
        monthMap.put(03,'Marts');   
        monthMap.put(04,'April');        
        monthMap.put(05,'Maj');     
        monthMap.put(06,'Juni');        
        monthMap.put(07,'Juli');    
        monthMap.put(08,'August');        
        monthMap.put(09,'September');   
        monthMap.put(10,'Oktober');        
        monthMap.put(11,'November');    
        monthMap.put(12,'December');        
        List<String> months = new List<String>();
        for(Integer i=0;i<=4;i++){
            Integer prevMonths = system.today().addMonths(10-i).month();
            Integer monthVal = prevMonths - 12;         
            if(monthVal<=0)
                months.add(String.valueOf(prevMonths));
            else
                months.add(String.valueOf(monthVal));                
        }  
        return months;
    } 
    
    /** CARRIE-963
    * @description: To Convert amount into two digits after the comma
    * Included “comma” separation instead of “dot” separation in the amount
    */ 
    public static String currency(String input) {
        if ( input == null ) {
            return '0,00';
        }
        //Decimal d1 = Decimal.valueOf(input).setScale(2);
        Decimal d1 = Decimal.valueOf(input);
        String str = d1.format();
        String decimalStr = str.substringAfter(',');
        
        if( decimalStr.length() == 1){
            str = str + '0';
        }
            if( !str.contains(',' ) ) {
            str = str + ',00';
        }
        return str;
    }        
    
    /**
    * @description: Inner Class to store usage data summary
    */  
    public class usageTree{
        public String startDate {get;set;}
        public String description {get;set;}
        public String amount {get;set;}
        public String duration {get;set;}
        public String callToNumber {get;set;}
        public String parentType {get;set;}
        public String numberForEmail {get;set;}
        //public String usageType {get;set;} //CARRIE-893
    }  
    
    /**
    * @description: Inner Class to store usages in lists, each list containing 1000 usages.
    */ 
    public class limitWrapper
    {
        public List<UsageTree> usages {get;set;}
        public integer blockNumber {get;set;}
        public limitWrapper(List<UsageTree> usgs, integer i)
        {
            usages = usgs;
            blockNumber = i;
        }        
    }  
    
}