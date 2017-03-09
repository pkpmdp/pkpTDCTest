public with sharing class CustomAddressLookupController {
    //public Account account {get;set;} // new account to create
    public List<Address__c> results{get;set;} // search results
    //public string searchString{get;set;} // search keyword
    public string addressName {get;set;} 
    public string street {get;set;}
    public string houseNumber {get;set;}
    public string doorNumber {get;set;}
    public string postCode {get;set;}
    public string town {get;set;}
    //public string district {get;set;}
    public boolean displayFlag {get; set;}
    public string entrance {get;set;}
    public string floor {get;set;}
    
    //public string side {get; set;}
    
    public ApexPages.StandardSetController controller {get; set;}
    /*public Address__c searchParameter =new Address__c();
    public Address__c getSearchParameter(){
        return searchParameter;
    }
    public void setSearchParameter(Address__c a){
        searchParameter = a; 
    }*/
    public CustomAddressLookupController() {
       // account = new Account();
        // get the current search string
        //searchParameter = new Address__c();
        addressName = System.currentPageReference().getParameters().get('lksrch');
        if(addressName!='' && addressName!=' ' && addressName!=null)
            runSearch();  
      }
     
      // performs the keyword search
      public PageReference search() {
        displayFlag = true; 
        results=new List<Address__c>();
        runSearch();
        return null;
      }
     
      // prepare the query and issue the search command
      private void runSearch() {
         
        // TODO prepare query string for complex serarches & prevent injections
        //results = performSearch(addressName,street,houseNumber,doorNumber,postCode,town,district);     
        controller = new ApexPages.StandardSetController(Database.getQueryLocator(makeSOQLStatement(addressName,street,houseNumber,doorNumber,postCode,town,entrance,floor)));     
        controller.setPageSize(10);
        if( controller.getResultSize() > 0){
            displayFlag=true;
        }else{ 
            displayFlag=false;
        }
        results = controller.getRecords();         
      } 
     
      // run the search and return the records found. 
      private String makeSOQLStatement(string addressName,string street,string houseNumber,string doorNumber,string postCode,string town,string entrance,string floor) {
        if(addressName!=null)
            addressName = addressName.trim();
        if(street!=null)
            street=street.trim();
        if(houseNumber!=null)
            houseNumber=houseNumber.trim();
        if(doorNumber!=null)
            doorNumber=doorNumber.trim();
        if(postCode!=null)
            postCode=postCode.trim();
        if(town!=null)
            town=town.trim();
        if(entrance!=null)
            entrance=entrance.trim();
        if(floor!=null)
            floor=floor.trim();
        //if(side!=null)
        //    side=side.trim();
                    
        String soql = 'select id, name,Street__c,House_No__c,Door_No__c,Postcode__c,Town__c,District__c,Entrance__c,Floor__c,PO_Box__c from Address__c';
        string filterCriteria='';
        /*if(searchString != '' && searchString != null)
          soql = soql +  ' where name LIKE \'%' + searchString +'%\'';*/
          System.debug('###addressName$'+addressName+'#street#'+street);
        if(addressName != '' && addressName != null)
            //filterCriteria = ' name LIKE \'%' + addressName +'%\'';
            // Changes for making search faster without using like operator
            filterCriteria = ' Street__c = \'' + addressName +'\'';
            
        if(street != '' && street != null){
            if(filterCriteria=='')
                filterCriteria = ' Street__c = \'' + street +'\'';
            else 
                filterCriteria = filterCriteria + ' and Street__c= \'' + street +'\'';
        }
        
        if(houseNumber != '' && houseNumber != null){
            if(filterCriteria=='')
                filterCriteria = ' House_No__c = \'' + houseNumber +'\'';
            else 
                filterCriteria = filterCriteria + ' and House_No__c= \'' + houseNumber +'\'';
        }
        
        if(doorNumber != '' && doorNumber != null){
            if(filterCriteria=='')
                filterCriteria = ' Door_No__c = \'' + doorNumber +'\'';
            else 
                filterCriteria = filterCriteria + ' and Door_No__c= \'' + doorNumber +'\'';
        }
        
        if(postCode != '' && postCode != null){
            if(filterCriteria=='')
                filterCriteria = ' Postcode__c = \'' + postCode +'\'';
            else 
                filterCriteria = filterCriteria + ' and Postcode__c= \'' + postCode +'\'';
        }
        
        if(town != '' && town != null){
            if(filterCriteria=='')
                filterCriteria = ' Town__c = \'' + town +'\'';
            else 
                filterCriteria = filterCriteria + ' and Town__c= \'' + town +'\'';
        }
        
        if(entrance != '' && entrance != null){
            if(filterCriteria=='')
                filterCriteria = ' Entrance__c = \'' + entrance +'\'';
            else 
                filterCriteria = filterCriteria + ' and Entrance__c= \'' + entrance +'\'';
        }
        
        if(floor != '' && floor != null){
            if(filterCriteria=='')
                filterCriteria = ' Floor__c = \'' + floor +'\'';
            else 
                filterCriteria = filterCriteria + ' and Floor__c= \'' + floor +'\'';
        }
        
        /*if(side != '' && side != null){
            if(filterCriteria=='')
                filterCriteria = ' Side__c = \'' + side +'\'';
            else 
                filterCriteria = filterCriteria + ' and Side__c= \'' + side +'\'';
        }*/
        
        
        /*if(district != '' && district != null){
            if(filterCriteria=='')
                filterCriteria = ' District__c = \'' + district +'\'';
            else 
                filterCriteria = filterCriteria + ' and District__c= \'' + district +'\'';
        }*/
        
        if(filterCriteria != '')
            //soql = soql + ' where ' + filterCriteria + ' and Action_Flag__c !=\'' + 'D'+ '\'';
        	soql = soql + ' where ' + filterCriteria + ' and Action_Flag__c !=\'' + 'D'+ '\' and Action_Flag__c !=\'' + 'E' + '\'';
        	soql = soql  + ' order by name limit 10000';  
        	System.debug('soql: '+ soql);
        	return soql;
      }
     
      // save the new account record
     // public PageReference saveAccount() {
        //insert account;
        // reset the account
       // account = new Account();
       // return null;
     // }
     
      // used by the visualforce page to send the link to the right dom element
      public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
      }
     
      // used by the visualforce page to send the link to the right dom element for the text box
      public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
      }
      
      // returns the first page of records
      public void first() {
        controller.first();
        results = controller.getRecords();
        //runSearch();
      }
 
      // returns the last page of records
      public void last() {
        controller.last();
        results = controller.getRecords();
        //runSearch();
      }
 
      // returns the previous page of records
      public void previous() {
        controller.previous();
        results = controller.getRecords();
      }
      public Boolean hasPrevious {
        get {
            return controller.getHasPrevious();
        }
        set;
      }
 
      // returns the next page of records
      public void next() {
        controller.next();
        results = controller.getRecords();
        //runSearch();
      }
    
      public Boolean hasNext {
        get {
            return controller.getHasNext();
        }
        set;
      }
   
      public Integer fromRecordNumber {
        get {
                return (controller.getPageNumber()*10-10)+1;
        }
        set;
      }
      
      public Integer toRecordNumber {
        get {
            if(controller.getPageNumber()*10<controller.getResultSize()){
                return controller.getPageNumber()*10;
              }else{
                   return controller.getResultSize();
                   }
            }
        set;
      }
      public Integer resultSize {
        get {
            return controller.getResultSize();
            }
        set;
      }
    
}