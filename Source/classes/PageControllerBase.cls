/** 
This class needs to be extended to have paging functionality.
To achieve paging following needs to be done.
1. The controller must extend to this class.
2. Add PagingComponent to the page like (<c:PagingComponent pageController="{!this}"/>).
3. create the dynamic query and set it using setQuery method in the constructor else if
   you do not set it in constructor then use initializePaging() method to invoke paging.
*/ 
public virtual class PageControllerBase {
    // This is the instance of paging component controller.
    public PagingController pagingComponent{get;set;}
    
    public boolean showFlagChange = false; 
    
    private Integer pageSize=10;
    
    // Dynamic query
    private String query;
    
    private String excelQuery;
    
    public void setQuery(String strQuery){
    	if(strQuery != null){
    	System.debug('inside setquery in pagecontroller...'+strQuery);
        query = strQuery;
    	}
    }
    
    public String getQuery(){
        return query;
    }
    
    public void setExcelQuery(String strQuery){
    	if(strQuery != null){
          excelQuery = strQuery;
    	}
    }
    
    public String getExcelQuery(){
        return excelQuery;
    }
    
    public void setPageSize(Integer pageSize){
        this.pageSize = pageSize;
    }
    
    public Integer getPageSize(){
    	System.debug('Inside getPageSize');
        return pageSize;
    }
    
    /**
     * This method should be used in scenarios where we need to create StandardSetController using 
     * modified query and have pagination on the new result set.
     * This method should not be called in the constructor of the controller as page component and 
     * page controller are yet not binded.Please refer to visual force page life cylcle.
     */
    //public void initializePaging(){ 
    protected void initializePaging(){
    	System.debug('Inside initializepaging page controller base');
        pagingComponent.initializePaging();
    }
    
    public PageControllerBase getThis(){
        return this;
    }
    
    //public List<sObject> getRecords(){
    protected List<sObject> getRecords(){
        System.debug('----Result Size ---    '+ pagingComponent.stdSetController.getResultSize());
        System.debug('Standard set Controller get Records'+ pagingComponent.stdSetController.getRecords());
        return pagingComponent.stdSetController.getRecords();
    }
    
    /**
     Before calling this method make sure the query to retrieve all the record is already set.
    */
    //public void setQueryForAllRecords(){
    protected void setQueryForAllRecords(){
        pagingComponent.getAllRecords();
    }
    
     public List<sObject> getRecordsforExport(){
    	List<sObject> temList = Database.query(getExcelQuery());
    	return temList;
    }
}