/***********************************************
*   class CustomerLogHistory
*   SF-1497
*   Calls CI service to fetch customer log records 
*   for the customer
*
***********************************************/
global class CustomerLogHistory{
    webservice static String fetchCustomerLog(String customerId) {
        String END_POINT = ServiceCenter_CustomSettings__c.getInstance('Service_Center_End_Point').Value__c;
        String strDate = '';
        DateTime dt;
        DateTime todayDate;
        Map<Integer,String> dateMap = new Map<Integer,String>{1=>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
        // convert 15 char id to 18 char
        Id accountId;
        try{
            accountId = customerId;          
        } catch (Exception e) {}            
        // check if customer logs older than last 2 years present
        List<Customer_Log__c> listCustLog = [Select Id, Creation_Date__c,CreatedDate,Customer__c From Customer_Log__c WHERE Creation_Date__c < LAST_N_YEARS:1 and Customer__c = :accountId order by Creation_Date__c desc];
        system.debug('=======listCustLog======='+listCustLog);
        if(!listCustLog.isEmpty()) {
            return 'recordspresent'; 
        } else {
            // make CI call to fetch records older than 2 years
            // first get the max creation date
            /*List<Customer_Log__c> listCL = [select Creation_Date__c, Customer__c  from Customer_Log__c 
                                                    where Customer__c = :accountId 
                                                    order by Creation_Date__c desc limit 1];
            String requestBody;
            if (!listCL.isEmpty()) 
            {
                dt = DateTime.valueOf(listCL[0].get('Creation_Date__c'));                
                strDate = dt.day() + '-' + dateMap.get(dt.month()) + '-' + dt.year(); 
            }           
            else {
                strDate = '';               
            }*/
            List<AggregateResult> minDateLst = [SELECT MIN(Creation_Date__c) minCount, Customer__c custid FROM Customer_Log__c where Customer__c = :accountId group by Customer__c];
            //String accId;
            if(!minDateLst.isEmpty()){
                for(AggregateResult listResult : minDateLst){
                    if(DateTime.valueOf(listResult.get('minCount')) != null ){
                        dt = DateTime.valueOf(listResult.get('minCount'));
                        //accId = String.valueOf(listResult.get('custid'));
                        strDate = dt.day() + '-' + dateMap.get(dt.month()) + '-' + dt.year();
                        System.debug('$$$$Customer No'+accountId+'######StrDate'+strDate);
                    }
                }
            }else{
                    todayDate = system.now();
                    strDate = todayDate.day() + '-' + dateMap.get(todayDate.month()) + '-' + todayDate.year();
                    System.debug('###todaysdate'+strDate);
            }
            System.debug('##accountId###'+accountId+'####strDate###'+strDate);
            // make the CI call   
            try{
                 if(accountId != null)
                 {                                  
                    HttpResponse res;
                    Http http = new Http();                         
                    HttpRequest req = new HttpRequest();
                    String method = INTEGRATION__c.getInstance('CustomerLogRetrieve') != null ? INTEGRATION__c.getInstance('CustomerLogRetrieve').HttpMethod__c : 'GET';       
                    String endpoint =  clsConnectionUtils_Admin.getEndPoint('CustomerLogRetrieve');
                     req.setMethod(method); 
                    req.setEndpoint(endpoint); 
                    //req.setheader('serviceMethod', 'GET');
                    req.setBody(accountId + ';' + strDate);
                    system.debug('request body>>>' + req.getBody()); 
                    req.setTimeout(60000);                                                                  
                    res = http.send(req);
                    System.debug('Res>>>>>>' + res.getStatusCode());
                    String responseBody = res.getbody().trim(); 
                    System.debug('########res.getStatus()'+res.getStatusCode()+'#####Body'+responseBody);     
                     /*if(res.getStatusCode() == 200){
                         System.debug('**** Inside code');
                         if(responseBody == 'TRUE'){
                        	System.debug('***true***');
                             return 'success';
                        }else if(responseBody == 'NO'){
                            System.debug('***not found***');
                            return 'notfound';
                        }
                     }else{
                         System.debug('***Error***');
                         return 'error';
                     }*/
                     if(responseBody == 'TRUE' && res.getStatusCode() == 200){
                        return 'success';
                    }else if(responseBody == 'NO' && res.getStatusCode() == 200){
                        return 'notfound';
                    }else{
                        return 'error';
                    }                 
                 } 
             } catch(Exception e){
                        return 'error';
             }          
         }
        return ''; 
    }
}