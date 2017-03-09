public with sharing class ViewDealerOrdersController  {

    public String assignedItems { get; set; }
    public string listlabel = 'Bestillinger indenfor seneste måned';
    public string dateListlabel { get {return listlabel;}}
    public DateTime currentDateTime = Datetime.now();
    public string formattedDate =  currentDateTime.day() + '-' + currentDateTime.month() + '-'  + currentDateTime.year();
    public Datetime formattedDT = DateTime.valueof(currentDateTime.year() + '-' + currentDateTime.month() + '-' + currentDateTime.day() + ' ' + currentDateTime.hour() + ':' + currentDateTime.minute() + ':' + currentDateTime.second());
    public string oldestOrder;
    Map<string, string> months = new Map<String, String>{'Jan' => 'Jan','Feb' => 'Feb', 'Mar' => 'Mar', 'Apr' => 'Apr', 'May' => 'Maj', 'Jun' => 'Jun', 'Jul' => 'Jul', 'Aug' => 'Aug', 'Sep' => 'Sep', 'Oct' => 'Okt', 'Nov' => 'Nov', 'Dec' => 'Dec'};
    Map<string, string> days = new Map<String, String>{'Sun' => 'Søn', 'Mon' => 'Man', 'Tue' => 'Tir', 'Wed' => 'Ons', 'Thu' => 'Thu', 'Fri' => 'Fre', 'Sat' => 'Lør'};
    public string dealerId1 = UserInfo.getUserId();
    
    
    public string findOldestOrder
    {
        get {
                Dealer_Products_Order__c obj = [select OrderDateTime__c from Dealer_Products_Order__c order by OrderDateTime__c limit 1];
                oldestOrder = obj.OrderDateTime__c.day() + '-' + obj.OrderDateTime__c.month() + '-' +  obj.OrderDateTime__c.year();
                return oldestOrder;
        }
    }
    
    public List<ForhandlerInformations__c> getHistoryHeaderInformation(){
               return getInformation('Historik Page'); 
    }
    
    public List<ForhandlerInformations__c> getInformation(String pageType){
               List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c =: 'Bestil Varer' and Group_Information__c =: pageType and info.SubGroup_Information__c = 'Top'];
               integer days = 0;
               Date todayDate = date.today();
               List<ForhandlerInformations__c> filteredInformationList = new List<ForhandlerInformations__c>(); 
               for(ForhandlerInformations__c info : informationList) {
                     if(info.EndDate__c != null){ 
                         days = todayDate.daysBetween(info.EndDate__c);
                     }    
                     if((info.EndDate__c == null) ||  (info.EndDate__c != null && days > 0)) {
                         filteredInformationList.add(info); 
                     }                             
                }  
                return filteredInformationList; 
        }        
     public DateTime pastMonthDT {get 
            {
                return formattedDT.addmonths(-1);
            } 
        }
     
     
     public string pastMonthDealerOrderHistory {get
     	{
     		return UserInfo.getUserId();
     	}   
     }
           
      public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('0','Vælg'));
            options.add(new SelectOption('1','Ordrenummer'));
            options.add(new SelectOption('2','Dato'));
            options.add(new SelectOption('3','Seneste måned'));
            return options;
        }
        
    public String startDate;
    public String searchEndDate;
    public String strDate{set; get;}
    public String enDate{set; get;}
    public String orderNumber{set; get;}
    public commonclass objCommon = new commonclass();  
    public string dealerName{
        get {
                try
                {
                    return objCommon.userContact.Name;
                }
                catch(Exception ex)
                {
                    return null;
                }
             }
    }
    public string dealerNumber{
        get { 
                try
                {
                    return objCommon.dealerAccount.Dealer_Number__c;
                }
                catch(Exception ex)
                {
                    return null;
                }
            }
    }
    
    public string lastMnthStartDate{ get; set; }
    public string lastMnthEndDate{ get; set; }
    
    // Pagination code
    public PaginationController component {get;set;}
    public boolean showPaging {get;set;}
    public boolean showOrderList {get;set;}
    public boolean resetOnChange {get;set;}
    public string baseQuery = 'select Name, CreatedById, OrderDateTime__c from Dealer_Products_Order__c';
    public string orderingField = 'OrderDateTime__c';
    public string CreatedById = 'CreatedById';
    // Initial DefaultViewCriteria next line is changed for DealerWeb 488
    //public string defaultViewCriteria = ' where ' + orderingField + ' >= :pastMonthDT' + ' order by ' + orderingField + ' desc';
    
    
    //Working For dealer Who has done the order
    //public string defaultViewCriteria = ' where ' + 'CreatedById ' + '= :pastMonthDealerOrderHistory' + ' order by ' + orderingField + ' desc ';
    
    public string defaultViewCriteria = ' where ' + orderingField + ' >= :pastMonthDT' + ' and ' + ' CreatedById ' + ' = :pastMonthDealerOrderHistory' + ' order by ' + orderingField + ' desc ';
    public List<Dealer_Products_Order__c> products = new List<Dealer_Products_Order__c>();
    public List<Dealer_Products_Order__c> orderedProducts
    {
        get {return products;}
        set {products = value;}
    }           
	
	public List<Dealer_Products_Order__c> temp = new List<Dealer_Products_Order__c>();
	public List<Dealer_Products_Order__c> templist
	{
		get {return temp;}
		set {temp = value;}
	}
    
    public ViewDealerOrdersController getThis()
    {
        return this;
    }
    
    public void resultFromPagination(List<sObject> result)
    {
        orderedProducts = (List<Dealer_Products_Order__c>)result;
    }
    
    
    //new code
    public boolean paginationFlag = true;
    public boolean paginationExecution
    {
        get 
        {  
            if(paginationFlag)
            {
                paginationFlag = false;
                return true;
            }
            else
             return false;
        }
        
    }
    
    //End of Pagination code
    
     public void selectionChange()
    {
        resetOnChange = false;
        orderNumber = null;
        strDate = null;
        startDate = null;
        enDate = null;
        searchEndDate = null;
    }

	
    public ViewDealerOrdersController() { 
        ///objCommon.setDealerInfo();
        showPaging = false;
        showOrderList = true;
        assignedItems ='0';
        datetime d= Datetime.now();
        string strFormat='dd.MM.yyyy';
        lastMnthStartDate = d.format(strFormat);
        datetime endD = datetime.newInstance(d.year(), d.month()-1,d.day());   
        lastMnthEndDate = endD.format(strFormat);
        System.debug('***User Id Of Dealer' + UserInfo.getUserId());
    }
    
    public String getStartDate(){
        return startDate;
        }
     
    public String getStartDateTime(){
        
        string dateTimeFormat = formatDate(startDate,' 00:00:00');
        return dateTimeFormat;
        }
    
    public void setStartDate(String startDate){
        this.startDate = startDate;
        }
    
   public String getSearchEndDate(){
        return searchEndDate;
        }
        
    public String getEndDateTime(){
       string dateTimeFormat = formatDate(searchEndDate,' 23:59:59');
        return dateTimeFormat;
    }
    
   public void setSearchEndDate(String searchEndDate){
        this.searchEndDate= searchEndDate;
        }
        
    public string formatDate(string dateString, string dTime)
    {
        if(dateString!=null && dateString!='')
        {
            String[] arrDate = dateString.split('\\.');
            return arrDate[2] + '-' + arrDate[1] + '-' + arrDate[0] + dTime;
        }
        else
            return null;
    }
        
    
     public PageReference findOrders()
     {  
     	System.debug('Hello inside findOrders:' + assignedItems);
     	System.debug('*** Dealer ID***'+dealerId1);
        strDate = startDate;
        enDate = searchEndDate;
        boolean noStartD=false, noEndD=false;
        //public string dealerId12 = UserInfo.getUserId();
        //if searched by order number
       if(assignedItems == '1')
       {
       		
           orderNumber = orderNumber.trim();
           
           
           if(orderNumber != null &&  orderNumber.length() == 1){
           		
           	
           }
           listlabel = 'Ordreliste for  ' + orderNumber;
           
            //System.debug('Controller Debug : ' + orderNumber);
           //List<sObject> result = Database.query(baseQuery +  ' where Name = '+ '\''+ orderNumber +'\'' );
           //List<sObject> result = Database.query(baseQuery + 'where CreatedById = '+ '\'' + dealerId1 + '\'');
           String query = baseQuery + ' where Name = '+ '\''+ orderNumber + '\' and CreatedById = \''+  dealerId1 + '\''; 
           System.debug('query: '+query);
           List<sObject> result = Database.query(query);
           //List<sObject> result = Database.query(baseQuery +  ' where Name = '+ '\''+ orderNumber +'\' + ' and '  + 'CreatedById = ' +  dealerId12 + ');
           //List<sObject> templist = result;
           
           showPaging = false;
           resultFromPagination(result);
           component.resetRowMarker(result); 
          
       }
       
       //if searched by date range
       else if(assignedItems == '2')
       {
            if(startDate=='' || startDate==null)
            {
                startDate = (oldestOrder==null || oldestOrder=='') ? findOldestOrder : oldestOrder;
                strDate = startDate;
                noStartD = true;
            }
    
            if(searchEndDate=='' || searchEndDate==null)
            {
                searchEndDate = formattedDate;
                enDate = searchEndDate;
                noEndD = true;
            }
            System.debug('^^^^^^^');    
            listlabel = 'Ordreliste fra ' + startDate + ' til ' + searchEndDate;
            component.searchResult();
          
            if(noStartD) 
             {startDate=null;strDate=null;}
            if(noEndD)  
             {searchEndDate=null;enDate=null;}
             system.debug('@@noEndD:'+noEndD);
            showPaging = true; 
        }
        
        //if searched by last mnth
        else if(assignedItems == '3')
        {
            listlabel = 'Bestillinger indenfor seneste måned';
            showPaging = false;
            component.setDefaultProductList();
        }
        else if(assignedItems == '4')
        {
            listlabel = 'Bestillinger indenfor seneste måned';
            showPaging = false;
            component.setDefaultProductList();                
        }
        if(products.size()>0)
        { 
          showOrderList = true;
          resetOnChange = false;
        }
        else
        {
         showOrderList = false;
         resetOnChange = true;
        }
        
         return null;
    }
         
    public pagereference dealerProductPage()
    {
        String newPageUrl ='/apex/DealerProductPage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
    
    //Added these for back button
  	public PageReference viewHistory() {
  		System.debug('Hello inside viewHistory' + assignedItems);
        String newPageUrl ='/apex/ViewDealerOrderHistory';
        PageReference newPage = new PageReference(newPageUrl);
       	assignedItems = '4';
       	findOrders();
        return null;
    }
     
    public List<c_DealerProductLineItems> getProductLineItems()
    {
        List<c_DealerProductLineItems> orderLinesList = new List<c_DealerProductLineItems>();
        Map<string,c_DealerProductLineItems> prodGroupMap = new Map<string,c_DealerProductLineItems>();
        
        for(Dealer_ProductLineItems_Order__c line : [select Product_Number__c,Product_Name__c,Product_Group__c,Product_Description__c,Quantity__c from Dealer_ProductLineItems_Order__c where DealerOrderNumber__r.Name=:selectedOrderNumber])
        {
            if(prodGroupMap.containsKey(line.Product_Group__c))
             prodGroupMap.get(line.Product_Group__c).lineItemsList.add(line);
            else
            {
                c_DealerProductLineItems lineItemsObj = new c_DealerProductLineItems();
                if('Generel'.equals(line.Product_Group__c)){
                	lineItemsObj.productGroup = 'Generelt';
                }else{
                	lineItemsObj.productGroup = line.Product_Group__c;	
                }
                lineItemsObj.lineItemsListProp.add(line);
                prodGroupMap.put(line.Product_Group__c,lineItemsObj);
            }
        }
        
        c_DealerProductLineItems generalList;
        for(string key : prodGroupMap.keyset())
        {
          if(key=='Generelt')
           generalList =  prodGroupMap.get(key);
          else
           orderLinesList.add(prodGroupMap.get(key));
        }
        if(generalList!=null)
         orderLinesList.add(generalList);
          
        return orderLinesList;
    }
    
    public string selectedOrderNumber {get;set;}
    public String selectedOrderDate{
    	set;
    	get{
    	   List<String> selectedDate = selectedOrderDate.split(' ');
		   return days.get(selectedDate[0])+'. '+selectedDate[2]+'. '+months.get(selectedDate[1])+'. '+selectedDate[5]+'  '+selectedDate[3];
    	}
    }
    
    public boolean ordLine {get;set;}
    
    public void viewLineItems()
    {
                ordLine = true;
    }
    
    public void backToHistoryPage()
    {
       ordLine = false;
    }
    
    public class c_DealerProductLineItems
    {
        public string productGroup {get;set;}
        public List<Dealer_ProductLineItems_Order__c> lineItemsList = new List<Dealer_ProductLineItems_Order__c>();
        public List<Dealer_ProductLineItems_Order__c> lineItemsListProp {get {return lineItemsList;}}
    }
 

}