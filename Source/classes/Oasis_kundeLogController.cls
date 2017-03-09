public class Oasis_kundeLogController{
    public list<Customer_Log__c> custLog =new list<Customer_Log__c>();
    public list<Customer_Log__c> oldCustLog =new list<Customer_Log__c>();
    public String defaultSelectValue {get;set;}
    public string custId; 
    public string ResponseFromCon {get;set;}
    public string name;
    public Integer PageSize {get;set;}
    public Integer PageNumber {get;set;}
    public string currentCountText {get; set;}
    public ApexPages.StandardSetController stdSetController;
    
    public Oasis_kundeLogController(){
        PageSize = 10;
        PageNumber = 1;
        custId=ApexPages.currentPage().getParameters().get('id');
        string query='select id,Name,Creation_Date__c,Text__c,User_Name__c, User_MID__c,Inquiry_Type__c,Date__c,Customer__c from Customer_Log__c where Customer__c=\''+custId+'\'';
        system.debug('<<<<<<<custId'+custId);
        stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        stdSetController.setPageSize(PageSize);
        system.debug('<<<<<<PageSize'+PageSize);
    }
     
    public list<Customer_Log__c> showAllLogs(){
        ResponseFromCon=CustomerLogHistory.fetchCustomerLog(custId);
        string query='select id,Name,Creation_Date__c,Text__c,User_Name__c, User_MID__c,Inquiry_Type__c,Date__c,Customer__c from Customer_Log__c where Customer__c=\''+custId+'\'';
        stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        system.debug('ResponseFromCon'+ResponseFromCon);
        return null;
    }
    
    public list<Customer_Log__c> getshow(){
        
        system.debug('<<<<<PageNumber'+PageNumber);
        custLog = stdSetController.getRecords();
        PageNumber = getPageNumber();
        system.debug('<<<<<custLog'+custLog);
        setCurrentPageCountText();
        return custLog;
    }
    
    public void setCurrentPageCountText(){
        System.debug('PageNumber****'+getPageNumber());
        if(getPageNumber() != null){
            integer startingRecordNo = (getPageNumber()-1)*integer.valueof(getPageSize())+1; 
            integer lastRecordNo =getPageNumber()*integer.valueof(getPageSize()); 
            integer sizepg=integer.valueof(getPageSize());
            system.debug('sizepg'+sizepg);
            System.debug('startingRecordNo****'+startingRecordNo);
            system.debug('<<<<<<lastRecordNo'+lastRecordNo);
            if(Integer.valueOf(getResultSize()) < lastRecordNo)
                lastRecordNo=Integer.valueOf(getResultSize());
            if(Integer.valueof(getResultSize()) <= 0 ){
                currentCountText = string.valueof(getResultSize()) + '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());
            }else{
                currentCountText = string.valueof(startingRecordNo)+ '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());  
            }  
            System.debug('startingRecordNo****'+startingRecordNo);
            system.debug('<<<<<<lastRecordNo'+lastRecordNo);
            system.debug('<<<<<Integer.valueOf(getResultSize())'+Integer.valueOf(getResultSize()));
            system.debug('<<<<<currentCountText'+currentCountText);
        }
        
    }
    public static String getPICKLIST_OPTION_SELECT(){
        system.debug('<<<<<<<<<<Oasis_Utils.PICKLIST_OPTION_SELECT'+Oasis_Utils.PICKLIST_OPTION_SELECT);
        return Oasis_Utils.PICKLIST_OPTION_SELECT;
    }
    public PageReference first() {
        stdSetController.first();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getshow();
        system.debug('PageNumber'+PageNumber);
        system.debug('defaultSelectValue'+defaultSelectValue);
        return null;
    }
    
    // returns the last page of records
    public PageReference last() {
        stdSetController.last();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getshow();
        system.debug('PageNumber'+PageNumber);
        system.debug('defaultSelectValue'+defaultSelectValue);
        return null;
    }
    
    // returns the previous page of records
    public PageReference previous() {
        stdSetController.previous();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getshow();
        system.debug('PageNumber'+PageNumber);
        system.debug('defaultSelectValue'+defaultSelectValue);
        return null;
    }
    
    // returns the next page of records
    public PageReference next() {
        stdSetController.next();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getshow(); 
        system.debug('PageNumber'+PageNumber);
        system.debug('defaultSelectValue'+defaultSelectValue);
        return null;
    }
    // returns the page number of the current page set
    public Integer getPageNumber() {
        if(custLog != null){
            system.debug('stdSetController.getPageNumber()'+stdSetController.getPageNumber());
            return stdSetController.getPageNumber();
        }
        else
            return null;
    }
    // returns the result size in Query Locator
    public Integer getResultSize(){
        system.debug('<<<stdSetController.getResultSize()'+stdSetController.getResultSize());
        return stdSetController.getResultSize();
    }
    
    // Sets the pageSize
    public void setPageSize(Integer pageSize){
        system.debug('pagesize'+pageSize);
        stdSetController.setPageSize(pageSize);
    }
    
    public Integer getPageSize(){
        system.debug('stdSetController.getPageSize()'+stdSetController.getPageSize());
        return stdSetController.getPageSize();
    }
    
    // Called when user changes the picklist value for pagesize
    public PageReference changPaging(){
        System.debug('$changPaging$');
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        System.debug('<<<<<<defaultSelectValue'+defaultSelectValue);
        if(pageSize != null){
            system.debug('<<<<<<pageSize'+pageSize);
            stdSetController.setPageSize(pageSize);
        }
        getshow();
        return null;
    }
    
    public Boolean getHasNext() {
        system.debug('stdSetController.getHasNext()'+stdSetController.getHasNext());
        return stdSetController.getHasNext();
        
    }
    // indicates whether there are more records before the current page set.
    public Boolean getHasPrevious() {
        system.debug('stdSetController.getHasPrevious()'+stdSetController.getHasPrevious());
        return stdSetController.getHasPrevious();
        
    }
}