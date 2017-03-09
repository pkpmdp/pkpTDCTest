public class PagingController
{	
	public ApexPages.StandardSetController stdSetController;
	public Integer resultSize{get; set;}
	
	public PageControllerBase pageController{get;
		set{
			if(pageController == null){
				pageController = value;
				pageController.pagingComponent = this;
				initializePaging();
			}
		}
	}

    public PagingController() {}
    
    public void initializePaging(){
    	if(pageController != null && pageController.getQuery() != null && pageController.getQuery().length() > 0){
    		if(getPageSize().equals('0')){
    			getAllRecords();
    		}
    		else{
    			stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(pageController.getQuery()));
	        	stdSetController.setPageSize(Integer.valueOf(getPageSize()));
    		}
    		//currentCountText = string.valueOf(stdSetController.getRecords().size());
    		resultSize = Integer.valueOf(getResultSize());
    		if(Integer.valueOf(getResultSize()) > 0 ){
    			setCurrentPageCountText();
    		}
    	}else {
    			System.debug('Page Controller and Component controller are yet not binded or u have not set the query yet');
    	}
    }
    
    public void setPageSize(String pageSize){
    	pageController.setPageSize(Integer.valueOf(pageSize));
    }
    
    public String getPageSize(){
    	return pageController.getPageSize()+'' ;
    }
    
     public Boolean getHasNext() {
     	if(stdSetController != null){
        	return stdSetController.getHasNext();
     	}
     		return null;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean getHasPrevious() {
    	if(stdSetController != null){
    	return stdSetController.getHasPrevious();
    	}
    	return null;
    	
    }
 
    // returns the page number of the current page set
    public Integer getPageNumber() {
    	if(pageController != null && pageController.getQuery() != null && pageController.getQuery().length() > 0)
        	return stdSetController.getPageNumber();
        else
        	return null;
    }
    
    public Integer getResultSize(){
    	resultSize = stdSetController.getResultSize();
    	return stdSetController.getResultSize();
    }
    
    public PageReference changPaging(){
    	System.debug('$changPaging$');
    	if(Integer.valueOf(getPageSize()) == 0){
    		getAllRecords();
    		setPageSize('0');
    	}else { 
    		initializePaging();
    	}
    	return null;
    }
 
 	/*public PageReference changPaging1(){
 		return null;
 	}*/
 
    // returns the first page of records
    public PageReference first() {
        stdSetController.first();
        setCurrentPageCountText();    
        return null;
    }
 
    // returns the last page of records
    public PageReference last() {
        stdSetController.last();
        setCurrentPageCountText();    
        return null;
    }
 
    // returns the previous page of records
    public PageReference previous() {
        stdSetController.previous();
        setCurrentPageCountText();
        return null;
    }
 
    // returns the next page of records
    public PageReference next() {
    	System.debug('@@');
    	System.debug('inside next()****'+stdSetController.getSelected());
        stdSetController.next();
        setCurrentPageCountText();      
      	//currentCountText = string.valueOf(stdSetController.getRecords().size());
        return null;
    }
    
    public void getAllRecords(){
    	
    	List<sObject> sobjectList = Database.query(pageController.getQuery());
    	stdSetController = new ApexPages.StandardSetController(sobjectList);
    	//stdSetController.setPageSize(200);
    }
    
	public Boolean getRequirePageChange(){
		return pageController.showFlagChange;
	}
	public string currentCountText {get; set;}
	public void setCurrentPageCountText(){
	//private void setCurrentPageCountText(){
		//userSelectedPage = ApexPages.CurrentPage().getParameters().get('userSelectedPage');
		//system.debug('userSelectedPage-->'+userSelectedPage);
		
		if(getPageNumber() != null){
			integer startingRecordNo = (getPageNumber()-1)*integer.valueof(getPageSize())+1; 
	    	/*if(startingRecordNo==0)
	    		startingRecordNo=1;*/
	    	integer lastRecordNo =getPageNumber()*integer.valueof(getPageSize()); 
	    	if(Integer.valueOf(getResultSize()) < lastRecordNo)
	    		lastRecordNo=Integer.valueOf(getResultSize());
	    	if(Integer.valueof(getResultSize()) <= 0 ){
	   				currentCountText = string.valueof(getResultSize()) + '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());
	   			}else{
	   				currentCountText = string.valueof(startingRecordNo)+ '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());	
	   			}	
	    	//currentCountText = string.valueof(startingRecordNo)  +'-'+ string.valueof(lastRecordNo)+ ' ud af ' + string.valueof(getResultSize());
	    	//currentCountText = String.valueOf(stdSetController.getRecords().size());
			//system.debug('$Final currentCountText$'+currentCountText);
		}
	}
}