/**********************************************************************************
************************************************************************************

* @class: DealerWebConferenceFollowUp
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 28/01/2013
* @description: Class is controller for the DealerWebConferenceFollowUp form.

************************************************************************************ 
***********************************************************************************/
public class DealerWebConferenceFollowUp {
    public String valgRute {get ; set; }    
    public String mobileNumber    {get;set;}
    public String ticketNumber    {get;set;}
    public List<Contact> totalRegisteredContacts {get; set;}
    public List<CountWrapper> countTransportList {get; set;} 
    public Integer arrivedContacts {get;set;}
    public Integer notArrivedContacts {get;set;}
    public String pickup {get; set;}
    public List<Contact> notArrivedList {get; set;}
    public List<Contact> resultContact{get;set;}
    public String countType {get; set;}
    Map<String,CountWrapper> routesMap = new Map<String,CountWrapper>();    
    Map<String, List<String>> route1 = new Map<String,List<String>>();
    
    // Start - Pagination variables
    public Integer pageSize    {get;set;}
    public Integer currentPage    {get;set;}
    public String currentPageInfo    {get;set;}
    
    // for disabling pagination links
    public Boolean showPrevious    {get;set;}
    public Boolean showNext    {get;set;}
    
    private Integer totalRecords;
    private Integer pageNumber;
    // End - Pagination variables
    
    //validate inputs for search.
    private Boolean isValidInputs{get;set;}{isValidInputs = true;}
    
    //Constructor
    public DealerWebConferenceFollowUp () {
        valgRute = '';
        pickup = '';
        mobileNumber = '';
        totalRegisteredContacts = new List<Contact>();
        notArrivedList = new List<Contact>();
        countTransportList = new List<CountWrapper>();
        ticketNumber = '';
        arrivedContacts = 0;
        notArrivedContacts = 0;
        currentPage = 0;
        pageSize = Test.isRunningTest() ? 1 : 25;
        pageNumber = 1;
        showPrevious = false; 
        countType = '';
        getCountofParticipants();       
        createRouteMap();      
    }
        
    public PageReference clearInputs(){
        mobileNumber = ticketNumber = '';
        resultContact = new List<Contact>();
        return null;
    }
    /**
    * @description: Used to search a conference contact using mobile number and/or dynamic generated ticket number entered by user.    
    */
     public PageReference searchContact(){ 
        ApexPages.Message myMsg;
        resultContact = new List<Contact>();
        validateInputs();
        if(isValidInputs){                  
            String query =  buildQueryString('searchContact');
            if(mobileNumber != '' && mobileNumber != null)
                query += 'and Conference_Mobile_Phone__c = \''+mobileNumber+'\'';                    
            if (ticketNumber != '' && ticketNumber != null)
                query += 'and Ticket_Number__c = \''+ticketNumber+'\'';    
            system.debug('query in searchContact ' + query);
            try{
                resultContact = Database.query(query);  
                if(resultContact.size() < 1){ 
                    showErrors(System.Label.noRecordsFound, 'Error');
                }else{
                    if(resultContact[0].Transportation_Required__c == 'Ja')
                        valgRute = resultContact[0].Valg_rute__c;               
                    if(resultContact[0].Transportation_Required__c != 'Ja')
                        valgRute = 'Egen Transport'; 
                    //getCountofParticipants();   
                    getCountForRoute(); 
                }
            }catch(DMLException ex){
                showErrors(System.Label.noRecordsFound, 'Error');
            } 
        }
        else{
            resultContact = new List<Contact>();
            system.debug('the value of resultContact ------'+resultContact);
            ticketNumber = mobileNumber = '';
        }
       return null; 
     }
     
    /**
    * @description: Used to mark a contact as 'arrived'.  
    */  
    public PageReference registerParticipant(){
        try{
            if(resultContact.size() > 0){
                Contact con = new Contact();
                con = resultContact[0];  
                system.debug('contact to update in searchContact ' + con);  
                if(!con.Participated_in_Conference__c){    
                    con.Participated_in_Conference__c = true;
                    update con;
                    showErrors(System.Label.registeredParticipant, 'Info');
                    if(con.Transportation_Required__c == 'Ja')
                        valgRute = con.Valg_rute__c;               
                    if(con.Transportation_Required__c != 'Ja')
                        valgRute = 'Egen Transport'; 
                    system.debug('Updated contact in searchContact ' + con);
                    system.debug('Updated valgRute in searchContact ' +valgRute);        
                    resultContact = new List<Contact>();            
                }
                else {
                    showErrors(System.Label.alreadyArrivedUser, 'Error');  
                    resultContact = new List<Contact>();
                    ticketNumber = mobileNumber = '';
                }                                                  
            } 
            else{
                showErrors(System.Label.noRecordsFound, 'Error');
            }       
            getCountofParticipants();   
            getCountForRoute(); 
            mobileNumber = ticketNumber = '';  
            system.debug('mobileNumber ' +mobileNumber + ' ticketNumber ' +ticketNumber);                             
        }
        catch(DMLException ex){
            showErrors(System.Label.notMarkedAsParticipated, 'Error');
            return null;                    
        }         
        catch(Exception ex){
            showErrors(System.Label.errorOccurredTryAgain, 'Error');
            return null;
        }
        return null; 
    }
    
    /**
    * @description: Used to calculate the total number of participants, number of participants arrived
    *  and the number of participants not arrived for each pickup point in a route    
    */   
    public PageReference getCountForRoute(){
        system.debug('Route in getCountForRoute ' + valgRute);
        List<Contact> contactList = new List<Contact>();
        routesMap = new Map<String,CountWrapper>();
        if(route1.containsKey(valgRute)){     
                 
            for(String pick : route1.get(valgRute)){   
                CountWrapper wrap = new CountWrapper();
                wrap.status = 'Lukket';              
                wrap.pickupPoint = pick;
                routesMap.put(pick,wrap);
            }
        } 
        countTransportList = new List<CountWrapper>();
        String query = buildQueryString('getCountForRoute');            
        contactList = Database.query(query);            
        system.debug('contactList.size()'+contactList);
        for(Contact con : contactList){
            String key = '';
            CountWrapper countWrap = new CountWrapper();
            if((valgRute == 'Alle' && con.Transportation_Required__c == 'Ja') || valgRute != 'Egen Transport')  {
                key =  con.Valg_opsamlingsby__c;                
            }                                               
            if ((valgRute == 'Alle' && con.Transportation_Required__c != 'Ja') || valgRute == 'Egen Transport'){
                key = 'Egen Transport';              
            }               
            if(routesMap.keySet().contains(key))                
                countWrap = routesMap.get(key);                 
            countWrap.totalCount++;
            if(con.Participated_in_Conference__c)
                countWrap.arrivedCount++;
            countWrap.notArrivedCount = countWrap.totalCount - countWrap.arrivedCount;
            countWrap.pickupPoint = key;
            if(countWrap.notArrivedCount == 0)
                countWrap.status = 'Lukket';
            else
                countWrap.status = 'Åbent';  
            routesMap.put(key, countWrap);      
        }   
        countTransportList = routesMap.values();
        // Sorting
        if(route1.containsKey(valgRute)){
            List<CountWrapper> lstTemp = new List<CountWrapper>();
            for(String s : route1.get(valgRute)){
                for(CountWrapper cw : countTransportList){
                    if(cw.pickupPoint == s){
                        lstTemp.add(cw);
                    }
                }
            }
            countTransportList = new List<CountWrapper>();
            countTransportList.addAll(lstTemp); 
        }        
        // End - Sorting
        notArrivedList = new List<Contact>();
        system.debug('resultContact in getCountFor Route ' +resultContact);             
        system.debug('countTransportList ' +countTransportList);
        return null;                            
    } 
    
    /**
    * @description: Used to display contact details of participants not arrived for pickup point selected by user    
    */     
    public PageReference displayNotArrivedList(){
        system.debug('countType ' +countType);
        try{
            if(pickup != '' && pickup != '--Vælg--'){
                pageNumber = 1;
                currentPage = 0;
                String query = '';
                if(countType == 'arrived')
                    query = buildQueryString('displayArrivedList');                                
                else if(countType == 'notArrived')
                    query = buildQueryString('displayNotArrivedList');               
                notArrivedList = Database.query(query);
                totalRecords = notArrivedList.size();
                system.debug('notArrivedList in displayNotArrivedList ' +notArrivedList);
                enableDisablePaginationLinks();                
            }   
        }
        catch(Exception ex){
            system.debug('Exception in displayNotArrivedList ' +ex);    
        }               
        return null;
    } 
    
    /**
    * @description: Construct SelectOption contaning all routes
    * @return: List of routes    
    */ 
    public List<SelectOption> getRoutes(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Vælg--','--Vælg--')); 
        options.add(new SelectOption('Alle','Alle'));
        options.add(new SelectOption('Frederikshavn-Aalborg-Randers','Frederikshavn-Aalborg-Randers')); 
        options.add(new SelectOption('Struer-Holstebro-Herning-Vejle','Struer-Holstebro-Herning-Vejle'));
        options.add(new SelectOption('Skive-Viborg-Silkeborg','Skive-Viborg-Silkeborg'));
        options.add(new SelectOption('Skjern-Varde-Esbjerg-Fredericia','Skjern-Varde-Esbjerg-Fredericia'));
        options.add(new SelectOption('Aabenraa-Haderslev-Kolding-Nyborg','Aabenraa-Haderslev-Kolding-Nyborg'));
        options.add(new SelectOption('Århus-Horsens-Odense','Århus-Horsens-Odense'));
        options.add(new SelectOption('Egen Transport','Egen Transport')); 
        return options;
    }
    
    /**
    * @description: Used to calculate the total number of participants, number of participants arrived
    * and the number of participants not arrived for the conference   
    */ 
    private void getCountofParticipants(){
        String query =  buildQueryString('getCountofParticipants');
        totalRegisteredContacts = Database.query(query);
        arrivedContacts = notArrivedContacts = 0;
        for(Contact contact : totalRegisteredContacts){
            if(contact.Participated_in_Conference__c == true)              
                arrivedContacts++;                         
        }
        notArrivedContacts = totalRegisteredContacts.size() - arrivedContacts;                        
    }     
    
    /**
    * @description: Used to construct query string for different scenarios
    * @return: query string  
    */ 
    private String buildQueryString(String action){
        String query = 'Select FirstName, LastName, Participated_in_Conference__c, Deregistered_from_Conference__c, Transportation_Required__c, Valg_opsamlingsby__c , Valg_rute__c , Conference_Mobile_Phone__c ,Ticket_Number__c From Contact ';
        query += 'WHERE IsConferenceContact__c = true AND Deregistered_from_Conference__c = false ';
        system.debug(action + ' action ' +valgRute + ' valg Rute ' + pickup + 'pickup' );
        if(action == 'displayNotArrivedList' || action == 'displayArrivedList'){            
            if(pickup != 'Egen Transport' && pickup != 'Alle')
                query += 'and Transportation_Required__c = \'Ja\' and Valg_opsamlingsby__c = \'' +pickup + '\' ';
            else if(pickup == 'Egen Transport')
                query += 'and Transportation_Required__c != \'Ja\' ';            
            else if(pickup == 'Alle')
                query += 'and Transportation_Required__c = \'Ja\' ';  
            if(action == 'displayNotArrivedList')
                query += 'and Participated_in_Conference__c = false ';   
            if(action == 'displayArrivedList')
                query += 'and Participated_in_Conference__c = true ';                           
        }                                                   
        else if(action == 'getCountForRoute'){ 
            if(valgRute != 'Alle'){        
                if(valgRute != 'Egen Transport')
                    query += 'and Transportation_Required__c = \'Ja\' and Valg_rute__c = \'' +valgRute + '\'';      
                else
                    query += 'and Transportation_Required__c != \'Ja\'';                             
            }             
        }  
        system.debug('query in buildQueryString ' +query);
        return query;
    }
    
    /**
    * @description: Used to construct a map, with routes as key and list of pickup points as values.  
    * Used for displaying pick up points with no registered contacts and for sorting pickup values on the basis of pickup time
    */ 
    private void createRouteMap(){
        List<String> allPickupPoints = new List<String>();
        route1.put('Frederikshavn-Aalborg-Randers',new List<String>{'Frederikshavn Banegård','Ålborg Hallens P-Plads','Randers Hallens P-Plads – Skyline Arena'});
        allPickupPoints.addAll(route1.get('Frederikshavn-Aalborg-Randers'));
        route1.put('Struer-Holstebro-Herning-Vejle', new List<String>{'Struer Banegård','Holstebro Banegård','Herning Banegård','Vejle Banegård'});
        allPickupPoints.addAll(route1.get('Struer-Holstebro-Herning-Vejle'));
        route1.put('Skive-Viborg-Silkeborg', new List<String>{'Skive Banegård','Viborg Banegård','Silkeborg Banegård'});
        allPickupPoints.addAll(route1.get('Skive-Viborg-Silkeborg'));
        route1.put('Skjern-Varde-Esbjerg-Fredericia', new List<String>{'Skjern Banegård','Varde Banegård','Esbjerg Banegård','Fredericia Banegård'});
        allPickupPoints.addAll(route1.get('Skjern-Varde-Esbjerg-Fredericia'));
        route1.put('Aabenraa-Haderslev-Kolding-Nyborg', new List<String>{'Aabenraa Afkørsel ved Mc Donalds','Haderslev busstation','Kolding Banegård','Nyborg Banegård'});
        allPickupPoints.addAll(route1.get('Aabenraa-Haderslev-Kolding-Nyborg'));
        route1.put('Århus-Horsens-Odense', new List<String>{'Aarhus ved Musikhuset','Horsens ved afkørsel 56 - den ved Burger King','Odense Banegård ved posthuset'});
        allPickupPoints.addAll(route1.get('Århus-Horsens-Odense'));   
        allPickupPoints.add('Egen Transport');      
        route1.put('Alle', allPickupPoints);        
    }
    
    // Start - Pagination Methods
    public void showPrevious()
    {
        currentPage = currentPage - pageSize;
        pageNumber--;
        enableDisablePaginationLinks();        
    }
    
    public void showNext()
    {
        currentPage = currentPage + pageSize;
        pageNumber++;
        enableDisablePaginationLinks();
    }
    
    public void showFirst()
    {
        currentPage = 0;
        pageNumber = 1;
        enableDisablePaginationLinks();
    }
    
    public void showLast()
    {
        currentPage = (Math.mod(totalRecords, pageSize) == 0) ? totalRecords - pageSize : (totalRecords / pageSize) * pageSize;
        pageNumber = (Math.mod(totalRecords, pageSize) == 0 ? totalRecords/pageSize : (totalRecords/pageSize) + 1);
        enableDisablePaginationLinks();
    }
    
    private void enableDisablePaginationLinks()
    {
        if(currentPage == 0)
            showPrevious = false;
        else
            showPrevious = true;
        
        if((totalRecords - pageSize) <= currentPage)
            showNext = false;
        else
            showNext = true;
        
        currentPageInfo = 'Side' + pageNumber +   ' af ' + (Math.mod(totalRecords, pageSize) == 0 ? totalRecords/pageSize : (totalRecords/pageSize) + 1);
    }
    
    // End - Pagination Methods
    
    /**
    * @description: Used to validate Mobile number and Ticket number which are input strings for search criteria.
    * @return: Boolean isValidInputs
    */
    private boolean validateInputs(){
        isValidInputs= true;
        ApexPages.Message myMsg;        
        if(mobileNumber.length() > 0 && !Pattern.matches('[0-9]{8,8}',mobileNumber)){
            showErrors(System.Label.invalidMobileNumber, 'Error');
            isValidInputs= false;
        }
        if(ticketNumber.length() > 0 && !Pattern.matches('[a-zA-Z]{6}[0-9]{2}[\\-][0-9]{5}',ticketNumber)){
            showErrors(System.Label.invalidTicketNumber, 'Error');
            isValidInputs= false;
        }
        if(mobileNumber.length() == 0 && ticketNumber.length() == 0){
            showErrors(System.Label.enterMobileOrTicketNumber, 'Error');
            isValidInputs= false;
        }
        return isValidInputs;
    }
    
    /**
    * @description: Common method to display error messages on page
    * @param: String error message
    */
    private void showErrors(String errorMsgs, String msgType){
        ApexPages.Message myMsg;
        if(msgType == 'Error')
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMsgs);
        else if(msgType == 'Info')
            myMsg = new ApexPages.Message(ApexPages.Severity.INFO,errorMsgs);
        ApexPages.addMessage(myMsg);        
    }
    
    public Class CountWrapper{
        public String pickupPoint {get ; set;}
        public Integer totalCount {get ; set;}
        public Integer arrivedCount {get ; set;}
        public Integer notArrivedCount {get ; set;}
        public String status {get ; set;}
        public CountWrapper(){  
            totalCount = 0;
            arrivedCount = 0;
            notArrivedCount = 0;
            pickupPoint = '';
            status = '';
        }
    }
}