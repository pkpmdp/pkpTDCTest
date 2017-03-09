public class PaginationController
{
    public PaginationController()
    {
    
    }
    public boolean firstExecution { get{return pageController.paginationExecution;} }//new code
    
    public ViewDealerOrdersController pageController 
    { 
        get; 
        set 
        {
              if (value != null) 
              {
                pageController = value;
                pageController.component = this;
                if(firstExecution)
                 setDefaultProductList();
              }
        }
    }
    
    public integer rows {get;set;}
    public dateTime pageFirstRow {get;set;}
    public dateTime pageLastRow {get;set;}
    public boolean onFirstPage {get;set;}
    public boolean onLastPage {get;set;}
    public boolean showPaging {get {return pageController.showPaging;} }
    public DateTime startDateTime;
    public DateTime endDateTime;
    public DateTime pastMonthDT {get{return pageController.pastMonthDT;}}
    public string pastMonthDealerOrderHistory {get{return pageController.pastMonthDealerOrderHistory;}}
    public string userId = UserInfo.getUserId();
    public string Query
    { 
        get { return pageController.baseQuery; }
    }
    public string orderingField
    {
        get { return pageController.orderingField ; }
    }
    public string defaultViewCriteria
    {
        get { return pageController.defaultViewCriteria; }
    }
    public string CreatedById
    {
    	get { return pagecontroller.CreatedById; }
    }
    
    public string searchCriteria
    {
       		/*get {
                startDateTime = datetime.valueof(pageController.getStartDateTime());
                endDateTime = datetime.valueof(pageController.getEndDateTime());
                return ' where ' + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime order by ' + orderingField + ' desc Limit ' + rows; 
            }*/
             get {
                startDateTime = datetime.valueof(pageController.getStartDateTime());
                endDateTime = datetime.valueof(pageController.getEndDateTime());
                return ' where ' + 'CreatedById' + ' =: userId and ' + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime  and ' + ' CreatedById ' + '= :userId ' + 'order by ' + orderingField + ' desc Limit ' + rows;
                 
            }
    }
    
    public void resetRowMarker(List<sObject> result)
    {
       if(!result.isEmpty())
       {
        pageFirstRow = (dateTime)result[0].get(orderingField);
        pageLastRow =  (dateTime)result[result.size()-1].get(orderingField);
       }
       else
       {
         onFirstPage = true;
         onLastPage = true;
       }
    }
    
    public void setDefaultProductList()
    {
    		
       List<sObject> result = Database.query(Query + defaultViewCriteria);
       pageController.resultFromPagination(result);
       resetRowMarker(result);
       onFirstPage = true;
       onLastPage = false;
    }
    
    public void searchResult()
    {
       System.debug('*** Search Criteria ***'+ searchCriteria);	
       
       List<sObject> result = Database.query(Query + searchCriteria);
       System.debug('*** Result***'+ result);
       pageController.resultFromPagination(result);
       resetRowMarker(result); 
       if(!result.isEmpty())
       {
        onFirstPage = true;
        onLastPage = (Database.query(Query + ' where ' + orderingField + ' < : pageLastRow and ' + orderingField + ' >= :startDateTime').size() > 0) ? false : true;
       }  
    }
    
    public void first()
    {
       List<sObject> result = Database.query(Query + ' where '  + 'CreatedById ' + ' = :userId ' + ' and '  + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime order by ' + orderingField + ' desc Limit ' + rows);
       pageController.resultFromPagination(result);
       resetRowMarker(result);
       onFirstPage = true;
       onLastPage = false;
    }
    public void next()
    {
       List<sObject> result = Database.query(Query + ' where ' + 'CreatedById ' + ' = :userId ' + ' and ' + orderingField + ' < :pageLastRow and ' + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime order by ' + orderingField + ' desc Limit ' + (rows+1));
       onFirstPage = false;
       if(result.size() > rows)
       {
        onLastPage = false; 
        result.remove(result.size()-1);  
       }
       else
        onLastPage = true;
       pageController.resultFromPagination(result);
       resetRowMarker(result);
    }
    public void previous()
    {
       List<sObject> result = Database.query(Query + ' where ' + 'CreatedById ' + ' = :userId ' + ' and ' + orderingField  + ' > :pageFirstRow and ' + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime order by ' + orderingField + ' Limit ' + (rows+1));
       if(result.size() > rows)
       {
        onFirstPage = false; 
        result.remove(result.size()-1);  
       }
       else
        onFirstPage = true;
       onLastPage = false;
       List<sObject> resultDesc = arrangeDescending(result);
       pageController.resultFromPagination(resultDesc);
       resetRowMarker(resultDesc);
    }
    public void last()
    {
       List<sObject> result = Database.query(Query + ' where ' + ' CreatedById ' + ' = :userId ' + ' and ' + orderingField + ' >= :startDateTime and ' + orderingField + ' <= :endDateTime order by ' + orderingField  + ' Limit ' + rows);
       List<sObject> resultDesc = arrangeDescending(result);
       pageController.resultFromPagination(resultDesc);
       resetRowMarker(resultDesc);
       onFirstPage = false;
       onLastPage = true;
    }
    public List<sObject> arrangeDescending(List<sObject> result)
    {
        List<sObject> resultDesc = new List<sObject>();
        if(!result.isEmpty())
        {
            integer resultSize = result.size();
            for(integer i = resultSize-1;i>=0;i--)
             resultDesc.add(result[i]);
        }
        return resultDesc;
    }
}