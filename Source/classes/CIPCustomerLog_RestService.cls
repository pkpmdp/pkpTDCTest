@RestResource(urlMapping='/customerlog/*') 
global class CIPCustomerLog_RestService {
    
    private static String STATUS_CODE_ERROR = '500';
    private static String STATUS_NOT_FOUND_ERROR = '404';
    private static String STATUS_CODE_SUCCESS = '200';    
    private static String STATUS_MESSAGE_SUCCESS = 'SUCCESS';  
        
    private Static String ERROR_MSG_MISSING_CUSTOMER_NO = 'Missing customer Number.'; 
    //private Static String ERROR_MSG_MISSING_SR_NO = 'Missing Service Request Number.';     
    private Static String ERROR_MSG_MISSING_ACTION = 'Missing value for the parameter action.';  
    private Static String ERROR_MSG_SAVING_NOTE = 'Error saving note.' ; 
    private static String ERROR_MSG_MISSING_PARAM_VALUE = 'Missing param value.';
    private static String ERROR_MSG_INVALID_CUSTOMER_NO='Invalid customer no.';   
    public static boolean globalFlagsForTest{get;set;}
    
@HttpGet
// Entry point for all GET calls. This method is an index method.
global static GetResponseWrapper doAction()
{
    String action = RestContext.request.params.get('action');
    GetResponseWrapper grw=new GetResponseWrapper();
    List<ResponseWrapper> lst_ResponseWrapper=new List<ResponseWrapper>();
    if(action == null || action == '')
    {      
       
        StatusWrapper  sw=new StatusWrapper();  
        sw.StatusCode = STATUS_CODE_ERROR;
        sw.StatusMessage = ERROR_MSG_MISSING_ACTION;           
        
        grw.requestStatus=sw; 
        grw.contractList=lst_ResponseWrapper;
        grw.size=0;       
        
        return grw;
       
        //String JSONString = JSON.serialize(lst_StatusWrapper);
       // return JSONString;
     
    }
    if('getNotesForCustomer'.equalsIgnoreCase(action))
    {
        return getCustomerLog(RestContext.request);
    }
   
    return null;    
}

public static GetResponseWrapper getCustomerLog(RestRequest req){
    
     String customerNo =req.params.get('customerno');
     GetResponseWrapper grw=new GetResponseWrapper();
     List<ResponseWrapper> lst_ResponseWrapper=new List<ResponseWrapper>();
     System.debug('##customer no:'+customerNo);
     
     if(String.isBlank(customerNo))
     {      
       
        StatusWrapper  sw=new StatusWrapper();  
        sw.StatusCode = STATUS_CODE_ERROR;
        sw.StatusMessage = ERROR_MSG_MISSING_CUSTOMER_NO;           
        
        grw.requestStatus=sw; 
        grw.contractList=lst_ResponseWrapper;
        grw.size=0;       
        
        return grw;
       
        //String JSONString = JSON.serialize(lst_StatusWrapper);
        // return JSONString;
     }
     
     List<Customer_Log__c> lst_customerLogs=[Select Id,User_MID__c,Customer_Number__c,Area__c,Guide__c,Inquiry_Type__c,LastModifiedDate,Text__c,Started__c FROM Customer_Log__c where Customer__r.Customer_No__c =:customerNo];
     System.debug('##size:'+lst_customerLogs.size());
     
     
     for(Customer_Log__c clTemp : lst_customerLogs)
     {
        ResponseWrapper resp  =new ResponseWrapper();
        resp.area=clTemp.Area__c;
        resp.description=clTemp.Text__c;
        resp.guide=clTemp.Guide__c;
        resp.contactType=clTemp.Inquiry_Type__c;
        resp.started=clTemp.Started__c;
        resp.userMID=clTemp.User_MID__c;
        resp.creationDate=clTemp.LastModifiedDate;
        resp.logId=clTemp.Id;  
        resp.customerNumber=clTemp.Customer_Number__c;       
        lst_ResponseWrapper.add(resp);
     }
      System.debug('##respnse Wrapper:'+lst_ResponseWrapper);
     // String JSONString = JSON.serialize(lst_ResponseWrapper);
     // return JSONString;
     
     StatusWrapper sw=new StatusWrapper();
     sw.StatusCode = STATUS_CODE_SUCCESS;
     sw.StatusMessage = STATUS_MESSAGE_SUCCESS;               
        
     grw.contractList=lst_ResponseWrapper;
     grw.requestStatus=sw;
     grw.size=lst_customerLogs.size();
     return grw;
     
}

@HttpPost
global static String saveCustomerLog(ResponseWrapper rw)
{   
    // Create a new customer log object with the values passed    
        ResponseWrapper resp  =new ResponseWrapper();   
        StatusWrapper  sw=new StatusWrapper();
        System.debug('ResponseWrapper logid:'+rw.logId);  
        if(String.isNotBlank(rw.logId)){
            System.debug('Update.....');
            List<Customer_Log__c> lst_customerLog=[Select Id,User_MID__c,Customer_Number__c,Area__c,Guide__c,Inquiry_Type__c,LastModifiedDate,Text__c,Started__c FROM Customer_Log__c where ID =:rw.logId];
            if(lst_customerLog.size()>0){
                
                Customer_Log__c clObj=lst_customerLog[0];
                
                if(String.isNotBlank(rw.area))
                clObj.Area__c=  rw.area; 
                
                if(String.isNotBlank(rw.guide))
                clObj.Guide__c=rw.guide;
                
                if(rw.started!=null)
                clObj.Started__c=rw.started; 
                
                if(String.isNotBlank(rw.description))
                clObj.Text__c=rw.description; 
                
                if(String.isNotBlank(rw.contactType))
                clObj.Inquiry_Type__c=rw.contactType;
                
                if(String.isNotBlank(rw.userMID))
                clObj.User_MID__c=rw.userMID; 
                //clObj.LastModifiedDate=rw.creationDate;       
                
                if(!Test.isRunningTest()){
                    if(String.isNotBlank(rw.customerNumber))    
                    clObj.Customer__r.Customer_No__c=rw.customerNumber;
                }
                
                try{
                    if(Test.isRunningTest() && globalFlagsForTest) {  // Purposely crash test.
                          integer i=100/0;
                    }
                    update clObj ;              
                    sw.StatusCode = STATUS_CODE_SUCCESS;
                    sw.StatusMessage = STATUS_MESSAGE_SUCCESS;
                    String JSONString = JSON.serialize(sw);
                    System.debug('JSONString:'+JSONString);
                    return JSONString;
                }catch(Exception e){
                    sw.StatusCode =STATUS_CODE_ERROR;
                    sw.StatusMessage = ERROR_MSG_SAVING_NOTE;
                    String JSONString = JSON.serialize(sw);
                    System.debug('JSONString:'+JSONString);
                    return JSONString;
                }
            }else{
                sw.StatusCode = STATUS_CODE_ERROR;
                sw.StatusMessage = ERROR_MSG_INVALID_CUSTOMER_NO;               
                String JSONString = JSON.serialize(sw);
                System.debug('JSONString:'+JSONString);
                return JSONString; 
            }   
        }else if(String.isBlank(rw.customerNumber))
        {
            sw.StatusCode = STATUS_CODE_ERROR;
            sw.StatusMessage = ERROR_MSG_MISSING_PARAM_VALUE;
            String JSONString = JSON.serialize(sw);
            System.debug('JSONString:'+JSONString);
            return JSONString;          
        }else{
            System.debug('Create ....');
           Customer_Log__c clObj=new Customer_Log__c();
            clObj.Area__c=  rw.area; 
            clObj.Guide__c=rw.guide;
            clObj.Started__c=rw.started; 
            clObj.Text__c=rw.description; 
            clObj.Inquiry_Type__c=rw.contactType;
            clObj.User_MID__c=rw.userMID; 
            //clObj.LastModifiedDate=rw.creationDate; 
            List<Account> lst_account=[Select Id from Account where Customer_No__c=:rw.customerNumber];    
            if(lst_account.size()>0)      
            clObj.Customer__c=lst_account[0].Id;
            try{
                if(Test.isRunningTest() && globalFlagsForTest) {  // Purposely crash test.
                          integer i=100/0;
                }
                insert clObj;
                
                PostResponseWrapper prw=new PostResponseWrapper();
               
                sw.StatusCode = STATUS_CODE_SUCCESS;
                sw.StatusMessage = STATUS_MESSAGE_SUCCESS;
                
                prw.requestStatus=sw;
                prw.logId=clObj.Id;
                clObj=[Select Id,Customer_Number__c from Customer_Log__c where Id=:clObj.Id];
                prw.customerNumber=clObj.Customer_Number__c;
                
                String JSONString = JSON.serialize(prw);
                System.debug('JSONString:'+JSONString);
                return JSONString;        
            }catch(Exception e){
                sw.StatusCode = STATUS_CODE_ERROR;
                sw.StatusMessage = ERROR_MSG_MISSING_PARAM_VALUE;               
                String JSONString = JSON.serialize(sw);
                System.debug('JSONString:'+JSONString);
                return JSONString;      
            }   
        }
}




global class ResponseWrapper{
    global String area; // Area__c
    global String guide; //Guide__c
    global DateTime started; //Started__c
    global String description; //Text__c
    global String contactType; //Inquiry_Type__c
    global String userMID; //User_MID__c
    global DateTime creationDate; //LastModifiedDate
    global String customerNumber;
    global String logId;        
}

global class GetResponseWrapper{
    global List<ResponseWrapper> contractList;
    global StatusWrapper requestStatus;
    global Integer size;
}

global class PostResponseWrapper{
    global String logId;
    global String customerNumber;
    global StatusWrapper requestStatus;
}
global class StatusWrapper{
    global String StatusCode;
    global String StatusMessage;
}


}