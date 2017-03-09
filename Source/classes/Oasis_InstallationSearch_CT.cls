/*
* This class is the controller for the Oasis Installation search page
*/
public without sharing class Oasis_InstallationSearch_CT{
    public Address__c address {get; set;}
    public String cuNo {get; set;} 
    public static final String END_POINT =
        END_POINT__c.getInstance('END_POINT_YOUPROD2') != null ?
        END_POINT__c.getInstance('END_POINT_YOUPROD2').END_POINT__c + '/' :null ;
    public String houseNumberFrom {get; set;}
    public String houseNumberTo {get; set;} 
    public  List<ViewModel> searchResults {get; set;}
    public boolean successfulCaseCreation {get; set;}
    public String defaultSelectValue {get;set;}
    public Boolean showStreetPicklist {get; set;} 
    public List<SelectOption> streetsForCU {get; set;}
    // added to disabled the register button for locked CU
    public Boolean searchOnCableUnit {get; set;}
    public Boolean searchedCULocked {get; set;}
    // select options
    public List<SelectOption> listInstRegCodes;
    public List<SelectOption> listStrikeValues;
    public List<SelectOption> listErrorTypeLabels;
    // used for pagination
    public Integer PageSize {get;set;}
    public ApexPages.StandardSetController stdSetController;
    public string currentCountText {get; set;}
    public Integer PageNumber {get;set;}
    public string addrId{get;set;} 
    public boolean flag{get; set;}
    public Map<String, string> digitalFilterInstallation = new Map<String, String>();
    public List<String> calloutParameter = new List<String>();
    public List<String> calloutvalue = new List<String>();
    string mergeCUs;// SUPPORT-5456
    public List<OasisCallouts.CasperActivityWrapper> parsedXML;// OASIS-75 wrapper 
    public Map<String, Case> mapSubCase; //SUPPORT-5484
    public Boolean duplicateCases{get; set;} //SUPPORT-5484
    
    // SPOC-2399 ---START
    public String custNumber{get;set;}
    public String addressUrl{get;set;}
    public String cableUnitNo{get;set;}
    public Boolean showCUPicklist{get;set;}
    public List<SelectOption> cuForKunde{get; set;}
    public Boolean noInstFlag{get; set;}
    // SPOC-2399 ---END
    //public setpageSize {get; set;}
    //constructor
    public Oasis_InstallationSearch_CT()
    {
        showCUPicklist = false;
        noInstFlag = false;
        cuForKunde = new List<SelectOption>();
        //SUPPORT-5458 START
        //odc contains duplicate case value.
        if(ApexPages.currentPage().getParameters().get('odc')!= null){
            // to get the existing data after Gem Registreringer button clicked.
            // Used small variables in cookie to prevent cookie size.
            Cookie aId = ApexPages.currentPage().getCookies().get('aId');
            Cookie addStr = ApexPages.currentPage().getCookies().get('addStr');
            if(addStr != null && addStr.getValue() != null){
                String aStr = addStr.getValue();
                address = (Address__c) JSON.deserialize(aStr, Address__c.class);
            }
            Cookie cuNo1 = ApexPages.currentPage().getCookies().get('cuNo');
            if(cuNo1 != null && cuNo1.getValue() != null){
                cuNo = cuNo1.getValue();
            }
            Cookie sStreetPic = ApexPages.currentPage().getCookies().get('sStreetPic');
            if(sStreetPic != null && sStreetPic.getValue() != null && sStreetPic.getValue() == 'true'){
                showStreetPicklist = true;
                getListStreetValues();
            }else{
               showStreetPicklist = false;
                Cookie hNo = ApexPages.currentPage().getCookies().get('hNo');
                if(hNo != null && hNo.getValue() != null){
                    List<String> s = hNo.getValue().split(';');
                    houseNumberFrom = s[0];
                    houseNumberTo = s[1];
                }
            }
            searchWrapper();
            // to show message case created successfully or already been created
            if(EncodingUtil.base64Decode(ApexPages.currentPage().getParameters().get('odc')).toString()=='true')
                duplicateCases = true;
            else
                duplicateCases = false;
            Cookie successfulCaseCreation1 = ApexPages.currentPage().getCookies().get('sCaseCre');
            if(successfulCaseCreation1 != null && successfulCaseCreation1.getValue() != null && successfulCaseCreation1.getValue() == 'true')
                successfulCaseCreation = true;
            else
               successfulCaseCreation = false;
            system.debug('*****successfulCaseCreation***'+successfulCaseCreation);
            
            // SUPPORT-5484 END
        }
        //SPOC-2422 Start
        else if(ApexPages.currentPage().getParameters().containsKey('address')){
            
            cuNo = '';
            custNumber ='';
            cableUnitNo='';
            successfulCaseCreation = false;
            searchOnCableUnit = false;
            searchedCULocked = false;
            showStreetPicklist = false;
            showCUPicklist =false;
            PageSize = 10;
            PageNumber = 1;
            
            addressUrl='';
            list<Address__c> addList = new List<Address__c>();
            address = new Address__c();
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get('address'))){
               addressUrl = ApexPages.currentPage().getParameters().get('address');
               //SELECT HouseNumber__c,House_No__c,Postcode__c,Street__c FROM Address__c WHERE address
                   addList=[SELECT HouseNumber__c,Entrance__c,Side__c,Floor__c,Door_No__c,House_No__c,Id,Postcode__c,Street__c FROM Address__c WHERE External_Id__c = :addressUrl];
            if(!addList.isEmpty()){
              address = addList[0];
              houseNumberFrom = String.valueOf(addList[0].HouseNumber__c);
              houseNumberTo = String.valueOf(addList[0].HouseNumber__c);
              system.debug('***address***'+address);
                
            }
                
        }
            //SPOC-2422 End
            system.debug('*****searchedCULockedsearchedCULocked******');
         }
        else{
            // SPOC-2399 ---START
            custNumber ='';
            cableUnitNo='';
            cuNo = '';
            if(ApexPages.currentPage().getParameters().containsKey('custNumb') && String.isNotBlank(ApexPages.currentPage().getParameters().get('custNumb')) ){
                custNumber = ApexPages.currentPage().getParameters().get('custNumb');
            }
 
            getListCUtValues(); // populate the CU pick list if Kunde number is populated 
            if(String.isNotBlank(cuNo))
                getListStreetValues();
            // SPOC-2399 ---END
 

            // execute odc parameter not found in url
            
            address = new Address__c();
            successfulCaseCreation = false;
            searchOnCableUnit = false;
            searchedCULocked = false;
            PageSize = 10;
            PageNumber = 1;
        }
       
        
            
    }
    public static String getPICKLIST_OPTION_SELECT(){
        return Oasis_Utils.PICKLIST_OPTION_SELECT;
    }  
    // action handler for the search button
    public pageReference Search()
    {
        //  successfulCaseCreation = false;
        searchedCULocked=false;
        //EDM-738 added stiktype__c, Status__c in the query string
        // get netinstallations based on search criteria
        String netInstallSql = 'select Id,INSTALLATION_ID__c, location__c, stiktype__c, Status__c, Cable_Unit_No__c,Control_Date__c,Cable_Unit__r.Oasis_Lock__c,Move_Flag__c,'+
            ' Address__r.Street__c,Address__r.House_No__c,Address__r.Floor__c,Address__r.Door_No__c,Address__r.Entrance__c,Address__r.PostCode__c,'+
            ' Address__r.Town__c from Net_Installations__c where Address__r.name !=null and Address__r.Action_Flag__c != \'D\' and Address__r.Action_Flag__c != \'E\'';
        
        // create a map of conditions
        Map<String, Object> mapConditions = new Map<String, Object>();
        //mapConditions.put('cableunit_number__c ', cuNo);                 // cable unit no 
       // mapConditions.put('Street__c', address.Street__c);                 // street
        mapConditions.put('Address__r.Entrance__c',Address.Entrance__c);                // entrance
        mapConditions.put('Address__r.Floor__c',Address.Floor__c);                  //floor
        mapConditions.put('Address__r.Side__c',Address.Side__c);                   //side
        mapConditions.put('Address__r.Door_No__c',Address.Door_No__c);                // Door 
        mapConditions.put('Address__r.Postcode__c',Address.Postcode__c);               // zipcode           
        //create an instance of the dynamic helper and pass the base query
        DynamicQueryHelper queryHelper = new DynamicQueryHelper(netInstallSql);        
        netInstallSql = queryHelper.addConditionMap(mapConditions); // add the condition map        
        // add the housenumber range condition  
        netInstallSql = queryHelper.addConditionRange('Address__r.HouseNumber__c', houseNumberFrom, houseNumberTo);
        // street partial search
        System.debug('Inside'+netInstallSql);
        if(String.isNotBlank(address.Street__c)) {
            System.debug('Inside');
            netInstallSql += ' and Address__r.Street__c like \'%' + String.escapeSingleQuotes(Address.Street__c) + '%\'';
        }
        // add the cable unit condition
        if(String.isNotBlank(cuNo)) {
            searchOnCableUnit = true;
            netInstallSql += ' and Cable_Unit_No__c = \'' + cuNo + '\' ';
        } else {
            searchOnCableUnit = false;
        }   
        // String escQuotes = String.escapeSingleQuotes(netInstallSql);
        netInstallSql = netInstallSql + ' order by Address__r.Street__c, Address__r.HouseNumber__c, Address__r.Entrance__c, Address__r.Floor_No_Dev__c, Address__r.Door_Number_Dev__c  limit 1000';
        system.debug('NetInstallSQL>>>>>' + netInstallSql); 
        stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(netInstallSql));
        system.debug('stdSetController>>>>>' + stdSetController.getRecords());
        //SUPPORT-5484 START
        //to set previous page size and number after Gem Registreringer button clicked.
        if(ApexPages.currentPage().getParameters().get('odc')!= null){
            Cookie staSePa = ApexPages.currentPage().getCookies().get('staSePa');
            if(staSePa != null && staSePa.getValue() != null){
                List<String> stanSetPara = staSePa.getValue().split(';');
                PageSize = Integer.valueOf(stanSetPara[0]);
                PageNumber = Integer.valueOf(stanSetPara[1]);
            }
        }//SUPPORT-5484 END
            stdSetController.setPageSize(PageSize); // set standard page size and nbumber
            stdSetController.setPageNumber(PageNumber);
        //OASIS-84 END.
        // END ******************* SUPPORT - 5456
        getinstallationDisplayList();
        return null;   
    }
    
    // TODO - This needs to be fixed, extra for loop not needed.
    // get all customer subscriptions for the passed installation id 
    private Map<String, String> getCustomerSubscriptionsForInstallationId(List<String> installation_id)
    {
        Map<String, String> mapSubscriptions = new Map<String, String>();       
        //  List<Customer_Subscription__c> listCustomerSubscription = Oasis_utils.getCustomerSubscriptionsForInstallationId(new Set<String>(installation_id));
       // Map<String, List<Customer_Subscription__c>> mapCS = Oasis_utils.getCustomerSubscriptionsForInstallationMap(new Set<String>(installation_id));
       // added for 2455
         Map<String, List<Customer_Subscription__c>> mapCS = Oasis_utils.getCustomerSubscriptionsForInstallationMapsearch(new Set<String>(installation_id));
        if(!mapCS.isEmpty()) {
            //  String initInstallationId = '';
            //  String products = ''; 
            
            for(String cs : mapCS.keySet()){
                List<Customer_Subscription__c> lst = mapCS.get(cs);
                if(lst.size() > 0){
                    mapSubscriptions.put(cs,lst[0].Product__r.Name);
                }
            }      
        }  
        return mapSubscriptions;
    }  
    
    public Map<String, Boolean> getCustomersForInstallation(List<String> installationExternalIds)
    {
        Map<String, Boolean> mapCustomersForInstallation = new Map<String, Boolean>();
        Set<String> setInstallationId = new Set<String>();
        setInstallationId.addAll(installationExternalIds);
        List<customer_installation_address__c> listCustomer = Oasis_Utils.getInstallationCustomers(setInstallationId);
        // loop over the installation ids and check which do not have any customers        
        for(customer_installation_address__c c: listCustomer)
        {
            mapCustomersForInstallation.put(c.installation_id__c, true);
        }
        
        return mapCustomersForInstallation;    
    }
    public pageReference getListStreetValues()
    {  
        //if cu present, show dropdown
        cuNo = AmazonUtil.fixCableUnitNo(cuNo);
        system.debug('cuNo>>>>' + cuNo);
        if(String.isNotBlank(cuNo)) {
            String street = '';
            showStreetPicklist = true;
            streetsForCU = new List<Selectoption>();
            /* List<AggregateResult> listCUStreets = [SELECT Address__r.Street__c 
FROM Net_Installations__c 
where cable_unit_no__c = :cuNo 
and Address__r.Action_Flag__c != 'D' and Address__r.Action_Flag__c != 'E'
group by Address__r.Street__c]; 

for(AggregateResult ar : listCUStreets){
street = (String) ar.get('Street__c');
if(street!=null)
streetsForCU.add(new SelectOption(street, street));
}
*/
            String distinctStreetNames = null;
            List<Cable_Unit__c> lst_cableUnits=[Select distinctAddresses__c from Cable_Unit__c where cable_unit_no__c=:cuNo];
            if(lst_cableUnits.size()>0){
                distinctStreetNames=lst_cableUnits[0].distinctAddresses__c;
                if(distinctStreetNames != null && distinctStreetNames != ''){
                    List<String> streetNames = new List<String>();
                    if(distinctStreetNames.contains(',')){
                        streetNames = distinctStreetNames.split(',');
                    }else{
                        streetNames.add(distinctStreetNames);                
                    }    
                    System.debug('streetNames: '+streetNames);
                    for(String streetVar : streetNames){
                        if(streetVar != null && streetVar != '' && streetVar.split('\\(')[0] != ''){
                            String streetName = streetVar;     
                            streetName = streetName.contains('&#39;')?streetName.replace('&#39;', '\''):streetName;
                            streetsForCU.add(new SelectOption(streetName.split('\\(')[0], streetName));
                        }
                        //errorFlag = false;  
                    }
                    streetsForCU = sortOptionList(streetsForCU);
                }
            }
        }
        else {
            showStreetPicklist = false;
            address.Street__c = '';
        }
        return null;  
    }
    
    //getListCUtValues method to get the list of CU numbers based on Kunde Nummer
    public void getListCUtValues(){
        list<Customer_Subscription__c> subscriptionList = new list<Customer_Subscription__c>();
        set<String> installationIdSet = new set<String>();
        set<String> cuNumberSet = new set<String>();
        if(String.isNotBlank(custNumber)){
            for(Customer_Subscription__c cs : [SELECT Customer_Number__c ,Installation_Id__c, Id, Customer__c, Address__c FROM Customer_Subscription__c                                     WHERE Customer_Number__c = :custNumber]){
                installationIdSet.add(cs.Installation_Id__c);
 
            }
            if(!installationIdSet.isEmpty()){
                noInstFlag = false;
                for( Net_Installations__c netIns :[SELECT id, Name, Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c WHERE INSTALLATION_ID__c IN :installationIdSet] ){
 
                    cuNumberSet.add(netIns.Cable_Unit__r.Cable_Unit_No__c);
                }
            }
            else{
                showCUPicklist = false;
                cuForKunde = new list<SelectOption>();
                noInstFlag = true;
                System.debug('****noInstFlag***'+noInstFlag);
            }
            if(!cuNumberSet.isEmpty()){
                list<String> cuNumberList  = new list<String>();
                showCUPicklist = cuNumberSet.size()>1?true:false;
 
                cuNumberList.addAll(cuNumberSet);
                cuNo = cuNumberList.size()==1?cuNumberList[0]:'';
 
                if(cuNumberList.size()==1)
                    getListStreetValues();
 
                if(cuNumberList.size() > 1){
                    if(String.isBlank(cuNo)){
                        cuNo = cuNumberList[0];
                        getListStreetValues();
                    }
 
                    for(Integer i=0;i<cuNumberList.size();i++){
                        cuForKunde.add(new SelectOption(cuNumberList[i],cuNumberList[i]));
                    }
 
                }
            }
        }
        else{
            showCUPicklist = false;
        }
    }
    
    public List<SelectOption> sortOptionList(List<SelectOption> ListToSort) {
        
        if(ListToSort == null || ListToSort.size() <= 1) {
            return ListToSort;                  
        }
        List<SelectOption> Less = new List<SelectOption>();     
        List<SelectOption> Greater = new List<SelectOption>();  
        integer pivot = 0;              
        // save the pivot and remove it from the list       
        SelectOption pivotValue = ListToSort[pivot];        
        ListToSort.remove(pivot);               
        for(SelectOption x : ListToSort) {          
            if(x.getLabel().compareTo(pivotValue.getLabel()) <= 0) {
                Less.add(x);
            } else if(x.getLabel().compareTo(pivotValue.getLabel()) > 0) {
                Greater.add(x);
            }   
        }       
        List<SelectOption> returnList = new List<SelectOption> ();      
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue); 
        returnList.addAll(SortOptionList(Greater)); 
        return returnList; 
    }
    
    // handler for register case button
    public PageReference registerCase()
    {
        System.debug('Inside***RegisterCase');
        List<Oasis_Utils.CaseCreateParam> listSelectedRows = new List<Oasis_Utils.CaseCreateParam>();
        String regCorrect = 'Reg, Korrekt';
        PageNumber = stdSetController.getPageNumber();
        //fetch Values from Custom setting
        String TGP = Oasis_String_Values__c.getInstance('Tilsluttet Grundpakke').Value__c;
        String TMP = Oasis_String_Values__c.getInstance('Tilsluttet Mellempakke').Value__c;
        String TFP = Oasis_String_Values__c.getInstance('Tilsluttet Fuldpakke').Value__c;
        String GP = Oasis_String_Values__c.getInstance('Grundpakke').Value__c;
        String MP = Oasis_String_Values__c.getInstance('Mellempakke').Value__c;
        String FP = Oasis_String_Values__c.getInstance('Fuldpakke').Value__c;
        // check all the view model rows where the reg code has changed..        
        for(ViewModel v : searchResults)
        {
            System.debug('REgCOd***'+v.regCode+'***'+Oasis_Utils.PICKLIST_OPTION_SELECT+'Addr'+v.formattedAddress);  
            if(v.regCode != Oasis_Utils.PICKLIST_OPTION_SELECT && v.regCode != null)
            {
                Oasis_Utils.CaseCreateParam c = new Oasis_Utils.CaseCreateParam();            
                c.installationId = v.installation.id;
                // update regCode to Correct if it meets below mentioned criteria Oasis-47
                if((v.regCode == TGP && v.productName == GP) || (v.regCode == TMP && v.productName == MP) || (v.regCode == TFP && v.productName == FP)){
                    c.regCode = regCorrect;
                }else{
                    c.regCode = v.regCode;
                }  
                if(v.strikeValue != Oasis_Utils.PICKLIST_OPTION_SELECT)
                    c.strikeValue = v.strikeValue;
                if(v.errorTypeLabel != Oasis_Utils.PICKLIST_OPTION_SELECT)
                    c.errorTypeLabel = v.errorTypeLabel;
                listSelectedRows.add(c);
            }
        }
        System.debug('SelectedRowsSize*********'+listSelectedRows.size()+'***'+listSelectedRows);
        // TODO create cases from this list of viewmodel rows
        //SUPPORT-5484 START
        List<Case> listCases = Oasis_Utils.createCaseForInstallation(listSelectedRows,mapSubCase);
        system.debug('registerCase>>>>>new cases>>>' + listCases);
        if(Oasis_Utils.duplicateCaseFlag == true && !Oasis_Utils.mapOldCase.values().isEmpty()){
            duplicateCases = Oasis_Utils.duplicateCaseFlag; // setting flag if all cases are duplicate.
            successfulCaseCreation = false;
        }else if(listCases != null){
            successfulCaseCreation = true;
            duplicateCases = false;
        }else{
            // setting the flag to false in case user clicks on search without select any recrods
            successfulCaseCreation = false;
            duplicateCases = false;
            Oasis_Utils.duplicateCaseFlag = false;
        }
        // do the search again
        //search(); commented because it will call searchwraper after case creation.
        defaultSelectValue = '';
        PageReference pg = ApexPages.currentPage();
        pg.getParameters().clear();
        pg.setRedirect(true);
        //set cookie parameter to get data after Gem Registreringer button clicked.
        pg.getParameters().put('odc',EncodingUtil.base64Encode(Blob.valueOf(duplicateCases+'')));
        String addStr = JSON.serialize(address);
        Cookie co1 = new Cookie('hNo',houseNumberFrom+';'+houseNumberTo,null,120,false);
        Cookie co = new Cookie('sStreetPic',showStreetPicklist+'',null,120,false);
         
        Cookie coo = new Cookie('staSePa',getPageSize()+';'+getPageNumber()+'',null,120,false);
        Cookie coo1 = new Cookie('cuNo',cuNo,null,120,false);
        Cookie coo2 = new Cookie('addStr',addStr,null,120,false);
        Cookie coo3 = new Cookie('sCaseCre',successfulCaseCreation+'',null,120,false);
        List<Cookie> cList = new List<Cookie>{co1,co,coo,coo1,coo2,coo3};
        pg.setCookies(cList);
        return pg;
    }
    
    // returns list of registration codes for Installation Search
    // results
    public List<SelectOption> getListInstRegCodes()
    {
        if (listInstRegCodes == null)
        {
            listInstRegCodes = Oasis_Utils.getInstallationRegistrationCodes();               
        }
        return listInstRegCodes;
    }
    
    public List<SelectOption> getListStrikeValues()
    {
        if(listStrikeValues == null) 
        {
            listStrikeValues = Oasis_Utils.getStrikeValues();
        }
        return listStrikeValues;        
    }
    
    public List<SelectOption> getListErrorTypeLabels()
    {
        if(listErrorTypeLabels == null)
        {
            listErrorTypeLabels = Oasis_Utils.getErrorTypeLabels();
        } 
        return listErrorTypeLabels;     
    }
    
    // rows of this class are rendered in search results. 
    public class ViewModel {        
        public Net_Installations__c installation {get; set;}
        public String regCode {get; set;}
        public String formattedAddress {get; set;} 
        public Case oasisCase {get; set;}
        public String cuNo {get; set;}
        public String strikeValue {get; set;}
        public String stiktype {get; set;}
        public String errorTypeLabel {get; set;}
        public Boolean customerPresent {get; set;}
        public Boolean lockedCableUnit {get;set;}
        public String productName {get; set;}
        public boolean isBlandSelv {get; set;}
        public String lockedTag {get;set;}
        public boolean casperAct{get; set;}
        public boolean productMismatch{get; set;}//EDM-810
        public string trID{get; set;}
        public string hoverMsg{get; set;}
    }
     
    // used to display paginated records on page
    public void getinstallationDisplayList()
    {
        searchResults = new List<ViewModel>();
        List<Net_Installations__c> listNetInstallations = new List<Net_Installations__c>();
        Map<String, String> mapInstallationIds = new Map<String, String>();
        Map<String, String> mapCustomerSubscriptions = new Map<String, String>();
        mapSubCase = new Map<String, Case>();
        Map<String, Boolean> mapCustomersForInstallation = new Map<String, Boolean>();  
        if(stdSetController !=null){
            listNetInstallations = stdSetController.getRecords();
            setCurrentPageCountText(); 
        }
        system.debug('listNetInstallations>>>>' + listNetInstallations);
        for(Net_Installations__c n : listNetInstallations) 
        {
            //setInstallationId.add(n.Id);
            mapInstallationIds.put(n.Id, n.INSTALLATION_ID__c);
        }  
        // get the products for the installations from customer subscription
        mapCustomerSubscriptions = getCustomerSubscriptionsForInstallationId(mapInstallationIds.values()); 
        system.debug('mapCustomerSubscriptions>>' + mapCustomerSubscriptions);     
        // check if a case exists for these subscriptions/installations.
        mapSubCase = Oasis_Utils.getInstallationCases(mapInstallationIds.keySet());
        system.debug('****mapSubCase***'+mapSubCase);
        // check if customers are present at this installation
        mapCustomersForInstallation = getCustomersForInstallation(mapInstallationIds.values());
        // OASIS - 75| SUPPORT-5456
        map<string,OasisCallouts.CasperActivityWrapper> mapCasperact = new map<string,OasisCallouts.CasperActivityWrapper>();  // key -> AMSID i.e. addr extrnal id || value ->CasperActivityWrapper
        if(parsedXML!=null){
        for(OasisCallouts.CasperActivityWrapper capser : parsedXML)
            {
                mapCasperact.put(capser.AMSID,capser);
            }
        }
        system.debug('mapCasperact ?>>>>>> '+mapCasperact);
        map<id,Address__c> mapAddress = new map<id,Address__c>([select id,External_Id__c from Address__c where External_Id__c in : mapCasperact.keyset()]);
        system.debug('mapAddress **** '+mapAddress);
        // loop over net installations to display viewmodel on page
        for(Net_Installations__c netInst : listNetInstallations) 
        {
            ViewModel v = new ViewModel();
            v.trID = 'unlocked';
            v.hoverMsg = '';
            //system.debug('netInst Address__c '+netInst.Address__c);
            if(mapAddress.containsKey(netInst.Address__c))
            {
                system.debug('mapAddress.containsKey '+netInst.Address__c);
                v.casperAct = true;
                v.trID = 'CasperAct';
                //v.hoverMsg = 'Open Casper Activity';
                v.hoverMsg = System.label.Oasis_Open_Casper_Activity;
            }
            //v.addreddId = netInst.Address__c;
            v.installation =  netInst;
            if(netInst.Move_Flag__c==true)
            {
                v.lockedTag='locked';
                v.trID = 'locked';
                //v.hoverMsg = 'Installation under flytning.';
                v.hoverMsg = System.label.Oasis_Installation_under_flytning;
            }else{
                v.lockedTag='unlocked';
                // v.trID = 'unlocked';
            }
            if(mapAddress.containsKey(netInst.Address__c) && netInst.Move_Flag__c==true)
            {
                v.trID = 'locked_CasperAct';
                //v.hoverMsg = 'Open Casper Activity;Installation under flytning.';
                v.hoverMsg = System.label.Oasis_Open_Casper_Activity +' and\n '+ System.label.Oasis_Installation_under_flytning;
            }
            if(netInst.Cable_Unit__r.Oasis_Lock__c == '1'){
                v.lockedCableUnit = true;
                searchedCULocked = true;
            }
            v.oasisCase = (Case)mapSubCase.get(netInst.id);
            v.customerPresent = mapCustomersForInstallation.get(netInst.installation_id__c);
            //OASIS-84 START used to find the mapCustomerSubscriptions product is null or not if null and if record found in digitalFilterInstallation then assign value of digitalFilterInstallation.
            if(mapCustomerSubscriptions.get(netInst.installation_id__c) == null || mapCustomerSubscriptions.get(netInst.installation_id__c) == ''){
                if(digitalFilterInstallation.get(netInst.installation_id__c) != null)
                    if(digitalFilterInstallation.get(netInst.installation_id__c).contains('DI')) //EDM-810
                        v.productName = System.Label.Digital_Filter;
            }else{
                v.productName = mapCustomerSubscriptions.get(netInst.installation_id__c);
            if(String.isNotBlank(v.productName)){
                if((v.productName).contains('Bland Selv')){
                    v.isBlandSelv=true;
                }else{
                    v.isBlandSelv=false;
                }
            }else{
                v.isBlandSelv=false;
            }
            }
            //EDM-810 START
            if(digitalFilterInstallation.get(netInst.installation_id__c) != null){
                System.debug('***digitalFilterInstallation.get(netInst.installation_id__c)**'+digitalFilterInstallation.get(netInst.installation_id__c));
                if(digitalFilterInstallation.get(netInst.installation_id__c).contains('OS')){
                            v.lockedTag='locked';
                            v.trID = 'locked';
                            v.productMismatch = true;
                            if(netInst.Move_Flag__c==true)
                                v.hoverMsg = System.label.Oasis_Installation_under_flytning+'and\n '+System.Label.Product_Mismatch;
                            else
                                v.hoverMsg = System.Label.Product_Mismatch;
                        }
            }
            //EDM-810 END
           //OASIS-84 END 
            v.formattedAddress = Oasis_Utils.formatAddress(netInst.Address__r);          
            //SUPPORT-5484 START
            v.regCode = 'Vælg';
            v.errorTypeLabel = 'Vælg';
            v.strikeValue = 'Vælg';
            //SUPPORT-5484 END
            searchResults.add(v);  
        }
        system.debug('##search Result:'+searchResults);
    }
    
    // returns the first page of records
    public PageReference first() {
        stdSetController.first();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getinstallationDisplayList();
        return null;
    }
    
    // returns the last page of records
    public PageReference last() {
        stdSetController.last();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getinstallationDisplayList();
        return null;
    }
    
    // returns the previous page of records
    public PageReference previous() {
        stdSetController.previous();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getinstallationDisplayList();
        return null;
    }
    
    // returns the next page of records
    public PageReference next() {
        stdSetController.next();
        PageNumber = stdSetController.getPageNumber();
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        getinstallationDisplayList();
        return null;
    }
    public PageReference searchWrapper(){
        
        //SPOC-2399 start
        list<Customer_Subscription__c> subscriptionList = new list<Customer_Subscription__c>();
        PageReference pgeRedirect;
        system.debug('*******custNumber**2222***'+ custNumber);
        if(String.isNotBlank(custNumber)){
            system.debug('*******custNumber*****'+ custNumber);
            subscriptionList = [SELECT Customer_Number__c ,Installation_Id__c, Id, Customer__c, Address__c FROM Customer_Subscription__c WHERE Customer_Number__c = :custNumber];
            system.debug('***subscriptionList****' + subscriptionList);
            
        }
        
        list<Net_Installations__c> installation = new list<Net_Installations__c>();
            
             if(!subscriptionList.isEmpty() && subscriptionList.size() ==1){
                 installation = [SELECT id, Name from Net_Installations__c WHERE INSTALLATION_ID__c =:subscriptionList[0].Installation_Id__c];
                
                if(!installation.isEmpty() && installation.size()==1){
                    pgeRedirect = Page.Oasis_InstallationInfo2;
                    pgeRedirect.getParameters().put('id',installation[0].id);
                    system.debug('***installation****' + installation);
                    system.debug('***pgeRedirect****' + pgeRedirect);
                     return pgeRedirect;
                }
                
             }
             
        //SPOC-2399 END
        else{
                    // OASIS-75
              system.debug('Input CU No **** '+cuNo);
                searchedCULocked=false;
                duplicateCases = false;
                //EDM-738 added stiktype__c in the query string
                // get netinstallations based on search criteria
                String netInstallSql = 'select Id,INSTALLATION_ID__c, location__c, stiktype__c, Cable_Unit_No__c,Control_Date__c,Cable_Unit__r.Oasis_Lock__c,Move_Flag__c,'+
                    ' Address__r.Street__c,Address__r.House_No__c,Address__r.Floor__c,Address__r.Door_No__c,Address__r.Entrance__c,Address__r.PostCode__c,'+
                    ' Address__r.Town__c from Net_Installations__c where Address__r.name !=null and Address__r.Action_Flag__c != \'D\' and Address__r.Action_Flag__c != \'E\'';
                
                // create a map of conditions
                Map<String, Object> mapConditions = new Map<String, Object>();
                //mapConditions.put('cableunit_number__c ', cuNo);                 // cable unit no 
               // mapConditions.put('Street__c', address.Street__c);                 // street
                mapConditions.put('Address__r.Entrance__c',Address.Entrance__c);                // entrance
                mapConditions.put('Address__r.Floor__c',Address.Floor__c);                  //floor
                mapConditions.put('Address__r.Side__c',Address.Side__c);                   //side
                mapConditions.put('Address__r.Door_No__c',Address.Door_No__c);                // Door 
                mapConditions.put('Address__r.Postcode__c',Address.Postcode__c);               // zipcode           
                //create an instance of the dynamic helper and pass the base query
                DynamicQueryHelper queryHelper = new DynamicQueryHelper(netInstallSql);        
                netInstallSql = queryHelper.addConditionMap(mapConditions); // add the condition map        
                // add the housenumber range condition
                if(String.isNotBlank(houseNumberFrom) && String.isNotBlank(houseNumberTo))
                  netInstallSql = queryHelper.addConditionRange('Address__r.HouseNumber__c', houseNumberFrom, houseNumberTo);
                // street partial search
                System.debug('Inside'+netInstallSql);
                if(String.isNotBlank(address.Street__c)) {
                    System.debug('Inside');
                    netInstallSql += ' and Address__r.Street__c like \'%' + String.escapeSingleQuotes(Address.Street__c) + '%\'';
                }
                // add the cable unit condition
                if(String.isNotBlank(cuNo)) {
                    
                    netInstallSql += ' and Cable_Unit_No__c = \'' + cuNo + '\' ';
                } 
                // String escQuotes = String.escapeSingleQuotes(netInstallSql);
                netInstallSql = netInstallSql + ' order by Address__r.Street__c, Address__r.HouseNumber__c, Address__r.Entrance__c, Address__r.Floor_No_Dev__c, Address__r.Door_Number_Dev__c  limit 1000';
                system.debug('NetInstallSQL>>>>>' + netInstallSql); 
                stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(netInstallSql));
                system.debug('stdSetController>>>>>' + stdSetController.getRecords()); 
                //SUPPORT - 5456
                stdSetController.setPageSize(1000);
                mergeCUs='';
                 For(Net_Installations__c netinst : (list<Net_Installations__c>)stdSetController.getRecords())
                {
                    if(mergeCUs == '')
                    {
                        mergeCUs = netinst.Cable_Unit_No__c;
                    }
                    else if(!mergeCUs.contains(netinst.Cable_Unit_No__c))
                    {
                        mergeCUs= mergeCUs +','+ netinst.Cable_Unit_No__c;
                    }
                }
                system.debug('mergeCUs ****** '+mergeCUs);
                String res;
                calloutparameter.add('null');
                calloutValue.add(mergeCUs);
                 if(test.isRunningTest())
                {
                    res = '<?xml version="1.0" encoding="UTF-8"?><rows><row><AMSID>971448</AMSID><AKTIVITET>3157370</AKTIVITET><BIERREVSPOR>1614679</BIERREVSPOR><BIERREVDATO>2013-11-25T00:00:00.000</BIERREVDATO><AKTIV/><OPHXRS_XRSAG/><SPOC24ACTIVITY>3157370</SPOC24ACTIVITY><CABLEUNIT>0000133627</CABLEUNIT></row></rows>';
                }
                else
                {
                    // SUPPORT-6278 START
                    if(System.Label.OasisCasperActivity == 'True')
                        res = clsConnectionUtils_Admin.callout1('Activities2showinOASIS',calloutparameter,calloutValue);
                }
                calloutParameter = new List<String>();
                calloutValue = new List<string>();
                system.debug('res-----'+res);
                if(System.Label.OasisCasperActivity == 'True'){
                    parsedXML = new List<OasisCallouts.CasperActivityWrapper>();
                    parsedXML = OasisCallouts.XMLPaeser(res);
                    system.debug('XMP parser '+parsedXML);
                }
                //SUPPORT-6278 END
                calloutParameter.add('null');
                calloutValue.add(mergeCUs);
                String digitalRes;
                if(!Test.isRunningTest()){
                    digitalRes = clsConnectionUtils_Admin.callout1('DigitalFilter',calloutParameter,calloutValue);
                }
                else{
                    digitalRes = '<Digitalfilter xmlns="http://yousee.dk/stag/fokus"><Digitalfilter><ANLAEGS_NR>4005322</ANLAEGS_NR><INSTAL_SEQ_NR>1350604</INSTAL_SEQ_NR><AMS_ADR_NR>7364833</AMS_ADR_NR><TV_PAKKE>DI</TV_PAKKE></Digitalfilter></Digitalfilter>';
                }
                calloutParameter = new List<String>();
                calloutValue = new List<String>();
                digitalFilterInstallation = OasisCallouts.digitalXMLPaeser(digitalRes);
                system.debug('Digital '+digitalFilterInstallation);
              // setting flag to false for new search on installations
            successfulCaseCreation = false; 
            // reset pageSize & pagenumber on new Search
               PageSize = 10;
                PageNumber = 1;  
                defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
            Search(); 
            
        }
        return null;
        
        
    }
    // used to display page details
    public void setCurrentPageCountText(){
        System.debug('PageNumber****'+getPageNumber());
        if(getPageNumber() != null){
            integer startingRecordNo = (getPageNumber()-1)*integer.valueof(getPageSize())+1; 
            integer lastRecordNo =getPageNumber()*integer.valueof(getPageSize()); 
            if(Integer.valueOf(getResultSize()) < lastRecordNo)
                lastRecordNo=Integer.valueOf(getResultSize());
            if(Integer.valueof(getResultSize()) <= 0 ){
                currentCountText = string.valueof(getResultSize()) + '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());
            }else{
                currentCountText = string.valueof(startingRecordNo)+ '-' + string.valueof(lastRecordNo) + ' ud af ' + string.valueof(getResultSize());  
            }  
        }
        System.debug('currentCountText****'+currentCountText);
    }
    // returns the page number of the current page set
    public Integer getPageNumber() {
        if(stdSetController != null)
            return stdSetController.getPageNumber();
        else
            return null;
    }
    // returns the result size in Query Locator
    public Integer getResultSize(){
        return stdSetController.getResultSize();
    }
    
    // Sets the pageSize
    public void setPageSize(Integer pageSize){
        stdSetController.setPageSize(pageSize);
    }
    
    public Integer getPageSize(){
        return stdSetController.getPageSize();
    }
    
    // Called when user changes the picklist value for pagesize
    public PageReference changPaging(){
        System.debug('$changPaging$');
        defaultSelectValue = getPICKLIST_OPTION_SELECT(); 
        if(pageSize != null){
            stdSetController.setPageSize(pageSize);
        }
        getinstallationDisplayList();
        return null;
    }
    
    public Boolean getHasNext() {
        return stdSetController.getHasNext();
    }
    // indicates whether there are more records before the current page set.
    public Boolean getHasPrevious() {
        return stdSetController.getHasPrevious();
    }
}