public class CableUnitInstallations{
    
    private final Cable_Unit__c cableUnit;
    private Net_Installations__c[] installations;
    private Net_Installations__c filter;
    private Integer streetFrom;
    private Integer streetTo;
    private String streetName;
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    private boolean isYFFMode = false;
    private SelectOption[] streetNames;    
   
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    public boolean isLastBtnDisabled{get;set;}       
    
    private Integer totalNoOfRecs; 

    public CableUnitInstallations(ApexPages.StandardController controller){
        this.cableUnit = (Cable_Unit__c)controller.getRecord(); 
        this.filter = new Net_Installations__c();
        this.isYFFMode = false;
        
        //Determine if controller is invoked from O-Customer page layout having the parameter isYFFMode set to true.
        String parameter = ApexPages.currentPage().getParameters().get('isYFFMode');
        if (parameter != null){
            isYFFMode = Boolean.valueOf(parameter);         
        }
        else
            isYFFMode = false;        
                            
        //this.filter.HasFuturePackage__c = true;

        this.pageSize = 100;
        // Try to get the default value from custom settings;
        // if the default value is different from the values defined in the CableUnitInstallationsPage VF page
        // (selectList's selectOption items) - currently 10, 50, 100 - it will be ignored and value of 10 will be set
        YouSeeCustomSettings__c rec = YouSeeCustomSettings__c.getValues('CableUnitInstallations_PageSize');
        if (rec != null && rec.Setting_Value__c != null) {
            try {
                Integer csVal = Integer.valueOf(rec.Setting_Value__c);
                if (csVal > 0) {
                    this.pageSize = csVal;
                }
            } catch (Exception e) {}
        }

        this.pageNumber = 0;
        this.isLastBtnDisabled= false;        
        this.streetName = ''; 
        
        if(isYFFMode)
            loadStreetNames();       
        findInstallations();        
    }
    
    //Retrieve distinct streenames
    public SelectOption[] getStreetNames() {
        return streetNames;
    }
    
    //Load distinct streetnames
    private void loadStreetNames(){     
        Cable_Unit__c cu = [Select distinctAddresses__c, Number_of_installations__c from Cable_Unit__c where Id = :cableUnit.Id];           
        if(cu != null && cu.distinctAddresses__c != null){
            List<String> streetNameTokens = cu.distinctAddresses__c.split(',', 0);
            streetNames = new SelectOption[]{};
            //Add default option if cable unit has less than 500 addresses
            if(cu.Number_of_installations__c < 500)
                streetNames.add(new SelectOption('','--Vælg gadenavn--'));
            for(String street: streetNameTokens){
                String trimmedStreet = street.trim();                           
                streetNames.add(new SelectOption(trimmedStreet, trimmedStreet));    
            }
            streetNames.sort();
            
            if(streetNames.size() >= 2 && cu.Number_of_installations__c < 500)              
                streetName = streetNames[1].getValue();
            else if (streetNames.size() > 0 && cu.Number_of_installations__c > 500)
                streetName = streetNames[0].getValue();
        }                       
    }
    
    public List<Net_Installations__c> getInstallations() {
        return this.installations;
    }
    
    public PageReference next(){  
        pageNumber++;  
        findInstallations();  
        return null;  
    }
       
    public PageReference previous(){  
        pageNumber--;  
        if (pageNumber < 0){
            return null;  
        }  
        findInstallations();  
        return null;  
    }  
    
    public PageReference findInstallationsNumOfRecords(){
         pageNumber = 0;
         findInstallations();
         return null;
    }
    
    public PageReference findInstallationsFilter(){
         pageNumber = 0;
         findInstallations();
         return null;
    }
    
    public PageReference first(){
         pageNumber = 0;
         findInstallations();
         return null;
    }

    public PageReference last(){
         if(noOfPages != null && noOfPages > 0){
             pageNumber = noOfPages - 1;
             findInstallations();
         }
         return null;
    }

    
    public PageReference findInstallations(){        
        isLastBtnDisabled = false;
        Integer offset = pageNumber * pageSize;

        /*
        query = 'Select Name, Status__c, Installation_Formula_Status__c, Id, INSTALLATION_ID__c, ' +
            'INSTALLATION_ADDRESS_EXTERNAL_ID__c, HasFuturePackage__c, Cable_Unit__c, ' +
            'Address__c, Address__r.Full_Address__c, Address_Id__c From Net_Installations__c';
        */
        //String query = 'SELECT Name, Status__c, Address__r.Full_Address__c FROM Net_Installations__c';
        //Added stikType__c in the query for EDM-738
        String query = 'SELECT Name, Status__c, stiktype__c, Address__r.Full_Address__c,Address__r.Name,Address__r.House_No__c,Address__r.Entrance__c,Address__r.Floor__c,Address__r.Door_No__c,Address__r.PostCode__c,Address__r.Town__c,Address__r.District__c,Location__c FROM Net_Installations__c';
        String queryTotalRecordsCount = 'SELECT count() FROM Net_Installations__c';
        String whereClause = ' WHERE Cable_Unit__c=\'' + this.cableUnit.Id + '\'';

        if (this.filter.Name != null) {
            whereClause += ' AND Name=\'' + this.filter.Name + '\'';
        }

        if (this.filter.Address__c != null) {
            Address__c address = [SELECT Street__c FROM Address__c WHERE Id=:this.filter.Address__c];
            whereClause += ' AND Address__r.Street__c=\'' + address.Street__c + '\'';
        }

        if (this.streetFrom != null && this.streetFrom > 0) {
            whereClause += ' AND Address__r.HouseNumber__c >= ' + this.streetFrom;
        }
        if (this.streetTo != null && this.streetTo > 0){
            whereClause += ' AND Address__r.HouseNumber__c <= ' + this.streetTo;
        }   

        if (isYFFMode) {
            //Before search, we need to strip away the house-numbers from the picklist box
            String convertedStreet = streetName != null ? streetName.substringBefore('(').trim() : '';
            if (convertedStreet !='') {
                whereClause += ' AND Address__r.Street__c=\'' + convertedStreet + '\'';
            }
        }

        /*
        //MKHA: Commented out since this field must be displayed on screen.
        if(this.filter.HasFuturePackage__c != null){
            //System.debug('hfp '+ this.filter.HasFuturePackage__c);
            whereClause += ' AND HasFuturePackage__c=' + this.filter.HasFuturePackage__c;
        }
        */

        if (this.filter.Status__c != null) {
            //System.debug('is ' + this.filter.Status__c);
            whereClause += ' AND Status__c=\'' + this.filter.Status__c + '\'';
        }
        
        //Added below If loop for EDM-738
        if (this.filter.Stiktype__c != null) {
            System.debug('is ' + this.filter.Stiktype__c);
            whereClause += ' AND Stiktype__c=\'' + this.filter.Stiktype__c + '\'';
        }

        query += whereClause + ' ORDER BY ' + sortExp + ' ' + sortDirection;
        query += ' LIMIT '+ pageSize + ' OFFSET ' + offset;
        System.debug('query: '+ query);
        queryTotalRecordsCount += whereClause;
        System.debug('queryTotalRecordsCount: '+ queryTotalRecordsCount);

        try {
            this.installations = Database.query(query);
            totalNoOfRecs = Database.countQuery(queryTotalRecordsCount);
            if (totalNoOfRecs > 0) {
                noOfPages = totalNoOfRecs/pageSize;
                if (Math.mod(totalNoOfRecs, pageSize) > 0) {
                    noOfPages++;
                }
            } else {
                pageNumber = 0;
                noOfPages = 0;
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }

        isLastBtnDisabled = noOfPages > 2000/pageSize;

        return null;
    }
    
    public Net_Installations__c getFilter(){
        return filter;
    }

    public void setFilter(Net_Installations__c filter){
        this.filter = filter;
    }
    
    public Integer getStreetFrom() {
        if(streetFrom == 0){
            return null;
        }
        return streetFrom;
    }

    public void setStreetFrom(Integer streetFrom) {
        this.streetFrom = streetFrom;
    }
    
    public Integer getStreetTo() {
        if(streetTo == 0){
            return null;
        }
        return streetTo;
    }
    
    public void setStreetTo(Integer streetTo) {
        this.streetTo = streetTo;
    }
    
    public String getStreetName(){      
        return streetName;
    }

    public void setStreetName(String streetName){       
        if(streetName == null)
            this.streetName = '';
        else
            this.streetName = streetName;
    }
    
    public boolean getIsYFFMode(){      
        return isYFFMode;
    }
    
    //sorting
    public String sortExpression
    {
     get
     {
        return sortExp;
     }
     set
     {
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

   public String getSortDirection()
   {
      if (sortExpression == null || sortExpression == '')
        return 'ASC';
      else
       return sortDirection;
   }
  
   public void setSortDirection(String value)
   {  
     sortDirection = value;
   }
    
    static testMethod void testInstallations() {
        Cable_Unit__c test = new Cable_Unit__c();
        test.Name = 'cu_kundeCust_testing'; 
        test.distinctAddresses__c = 'test address';
        test.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        test.Municipaly__c = clsTestDataForYS.getMunicipaly();
        test.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        test.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        test.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        test.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert test;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(test);
        CableUnitInstallations controller = new CableUnitInstallations(sc);

        Net_Installations__c filter = new Net_Installations__c();
        filter.Name = '1';
        //filter.HasFuturePackage__c = false;
        filter.Status__c = 'Fordelerboks';
        filter.Stiktype__c='testEdm735';//Added for EDM-738
        Address__c address = new Address__c();
        insert address;        
        filter.Address__c = address.Id;
        controller.setFilter(filter);
        controller.findInstallations();
        controller.getInstallations();
        controller.getFilter();
        controller.setStreetFrom(0);
        controller.setStreetTo(0);
        controller.getStreetFrom();
        controller.getStreetTo();
        controller.setStreetFrom(1);
        controller.setStreetTo(1);
        controller.getStreetFrom();
        controller.getStreetTo();
        controller.getSortDirection();
        controller.setSortDirection('ASC');
        String s = controller.sortExpression;
        controller.sortExpression = null;
        controller.getSortDirection();
        controller.sortExpression = 'ASC';
        controller.getSortDirection();
        controller.sortExpression = 'ASC';
        controller.getSortDirection();
        controller.next();
        controller.pageNumber = -1;
        controller.previous();
        controller.pageNumber = 1;
        controller.previous();
        controller.findInstallationsNumOfRecords();
        controller.first();
        controller.noOfPages = 1;
        controller.last();
        controller.loadStreetNames();
        controller.findInstallationsFilter();
    }  
    
}