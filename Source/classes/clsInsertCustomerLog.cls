@RestResource(urlMapping='/custlog/*')
global class clsInsertCustomerLog {

    @HttpGet
    global static ResponseWrapper doAction(){
        String action = RestContext.request.params.get('action');
        if(action == null || action == ''){
            ResponseWrapper resp  = new ResponseWrapper();
            return resp;
        }
        if('getAll'.equalsIgnoreCase(action)){
            return getSingleContactRoleDetails();
        }
        return null;
    }
    
    
    global static ResponseWrapper getSingleContactRoleDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Integer dataId =  Integer.valueOf(req.params.get('datalimit')); 
        String sfId1 = req.params.get('sfId');
        ResponseWrapper resp  = new ResponseWrapper();
        List<Customer_Log__c> custLogList = [SELECT CreatedById,CreatedDate,Creation_Date__c,Customer_Number__c,Customer__c,Date__c,Id,Inquiry_Form__c,Inquiry_Type__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,SystemModstamp,Text__c,User_MID__c,User_Name__c FROM Customer_Log__c where Id > :sfId1 order by Id limit :dataId];
        //List<Customer_Log__c> custLogList = [SELECT Creation_Date__c,Customer_Number__c,Customer__c,Date__c,Flags__c,ID,Inquiry_Form__c,Inquiry_Type__c,Name,Process_Flag__c,Text__c,User_MID__c,User_Name__c FROM Customer_Log__c where Process_Flag__c >= :number1 limit :dataId];
        if(custLogList != null && custLogList.size() > 0){
            resp.listCustLogfile = getMapToContactRoleList(custLogList);
        }
        return resp;
    }
    
    public static List<CustomerLogWrapper> getMapToContactRoleList(List<Customer_Log__c> logList1){
        List<CustomerLogWrapper> listWrapper = new List<CustomerLogWrapper>();
        for(Customer_Log__c lcr : logList1){
            CustomerLogWrapper lcrWrapper = new CustomerLogWrapper();
            //lcrWrapper.Contact1 = lcr.Contact__c;
            lcrWrapper.CreatedById1 = lcr.CreatedById;
            lcrWrapper.CreatedDate1 = lcr.CreatedDate;
            lcrWrapper.Creation_Date1 = lcr.Creation_Date__c;
            lcrWrapper.Customer_Number1 = lcr.Customer_Number__c;
            lcrWrapper.Customer1 = lcr.Customer__c;
            lcrWrapper.Date1 = lcr.Date__c;
            lcrWrapper.Id1 = lcr.Id;
            lcrWrapper.Inquiry_Form1 = lcr.Inquiry_Form__c;
            lcrWrapper.Inquiry_Type1 = lcr.Inquiry_Type__c;
            lcrWrapper.IsDeleted1 = lcr.isDeleted;
            lcrWrapper.LastModifiedById1 = lcr.LastModifiedById;
            lcrWrapper.LastModifiedDate1 = lcr.LastModifiedDate;
            lcrWrapper.Name1 = lcr.Name;
            lcrWrapper.OwnerId1 = lcr.OwnerId;
            lcrWrapper.SystemModstamp1 = lcr.SystemModstamp;
            lcrWrapper.Text1 = lcr.Text__c;
            lcrWrapper.User_MID1 = lcr.User_MID__c;
            lcrWrapper.User_Name1 = lcr.User_Name__c;
            listWrapper.add(lcrWrapper);
        }
        return listWrapper;
    }

    

    global class CustomerLogWrapper {
        //public ID Contact1;
        public ID CreatedById1;
        public DateTime CreatedDate1;
        public DateTime Creation_Date1;
        public String Customer_Number1;
        public ID Customer1;
        public Date Date1;
        public ID Id1;
        public String Inquiry_Form1;
        public String Inquiry_Type1;
        public Boolean IsDeleted1;
        public Id LastModifiedById1;
        public DateTime LastModifiedDate1;
        public String Name1;
        public ID OwnerId1;
        public DateTime SystemModstamp1;
        public String Text1;
        public String User_MID1;
        public String User_Name1;
        
        
        
   }
   
    global class ResponseWrapper{           
        //public String StatusCode;
        //public String StatusMessage;
        public List<CustomerLogWrapper> listCustLogfile; 
   
    } 
}