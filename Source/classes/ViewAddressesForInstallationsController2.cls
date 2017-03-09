/* Class for view address and installations. List of addresses are displayed on account condition and
user can select installations to change the package and it's effective date
*/

public class ViewAddressesForInstallationsController2 extends PageControllerBase{
    //EDM-637 START
    public static List<String> calloutParameter = new List<String>();
    public static List<String> calloutValue = new List<String>();
    //EDM-637 END
    public static Boolean FORCE_TEST_MODE = false;
    public boolean isbadpayee{get;set;}//Added for Bland selv phase 2b
    public Boolean streetFlag{get;set;}
    public Boolean changedDateFlag = false; 
    public boolean validateNewResident = false;
    public boolean showChangePackageButton{get;set;}
    public boolean errorFlag{get;set;}
    public boolean addressesFlag{get;set;}
    public boolean productOfferingFlag{get;set;}
    public static boolean changePackageFlag{get;set;}
    public boolean cancelPackageFlag{get;set;}
    public boolean selectedFlag{get;set;}
    public boolean changedTvPackageFlag{get;set;}
    public static Boolean checkFlag{get; set;}
    public static Boolean ordertypeFlag{get; set;}
    
    //public static Boolean mixedFlag{get; set;}
    public Boolean addressesSize {get;set;}
    public Boolean regenerateGroupId {get;set;}
    public String databaseQuery; 
    public String searchHsNoText; 
    public String addressSearch;
    public String xmlResponse; 
    public String currentSalesConceptId;
    public String distinctStreetNames;
    public String trimmedCU{get; set;}
    public String showChangeALL{get; set;}
    public string selectedPackage{get; set;}  
    public string selectedPackageDate{get; set;}
    public static String cableUnitNumber1 {get; set;}
    public static String cableUnitName1 {get; set;}
    public String cableUnitNumber {get; set;}
    public String cableUnitName {get; set;}
    public String legalAccountNo {get; set;}
    public String searchValues{get;set;}
    public String userSelectedPage{ get; set;}
    public String portalBrugerRole {get; set;}
    public static String firstName {get; set;} 
    public static String lastName{get; set;}
    public String changedAmsId{get; set;}
    public String changedDate{get; set;} 
    public String JSONString{get; set;}
    //public String installationIds;
    public String siteCoreUrl{get; set;} 
    public String localeSetting{get;set;}  
    // public Integer subsCount {get; set;}
    public Integer loopCount; 
    public boolean cableUnitLoop {get;set;}
    List<List<cInstallation>> exportList;    
    List<list<cInstallation>> exportlistBS;//Added for bland selv phase 2
    List<Cable_Unit__c> cableUnitsForMail;
    List<string> ReleaseDate = new List<string>();
    public List<string> amsIDList = new List<string>();
    public List<cInstallation> finalInstallations{get; set;}
    public List<Net_Installations__c> addressItems {get;set;}
    public List<Order__c> dslOrderList = new List<Order__c>();
    List<SelectOption> filterOptions = new List<SelectOption>();
    public static List<Order__c> dslOrderListForMail = new List<Order__c>();    
    public List<cInstallation> installationList =  new List<cInstallation>();
    public List<cInstallation> installationValues = new List<cInstallation>();
    public List<cInstallation> sortedInstallations =  new List<cInstallation>();
    public List<cInstallation> confirmedInstallations = new List<cInstallation>();
    public List<cInstallation> installationOfferingList = new List<cInstallation>();
    public List<Net_Installations__c> subscriptionInst = new List<Net_Installations__c>();
    public static List<cInstallation> confirmedInstallationsForMail = new List<cInstallation>();
    public List<Net_Installations__c> netInstallAmsId = new List<Net_Installations__c>();
    public List<Order__c> chkGroupIdList;
    
    public Map<String,String> amsIdMap = new Map<String,String>();
    public Map<String, String> clearProductMap = new Map<String, String>();
    public Map<Id,cInstallation> finalSelectedListInstallationMap = new Map<Id,cInstallation>();
    Map<String, Net_Installations__c> installationMap = new Map<String, Net_Installations__c>();
    public Map<String, List<cInstallationHistory>> wrapperMap = new Map<String, List<cInstallationHistory>>(); 
    
    public static String contactRolesBruger = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
    //ServiceCenter_CustomSettings__c sc = ServiceCenter_CustomSettings__c.getValues('Bcc_Email');
    String bccValue = ServiceCenter_CustomSettings__c.getInstance('Bcc_Email').Value__c;
    ServiceCenter_CustomSettings__c sc = ServiceCenter_CustomSettings__c.getValues('Bcc_Email');
    ServiceCenter_CustomSettings__c sc1 = ServiceCenter_CustomSettings__c.getValues('Production_Bcc_Email');
    public String value,value1;
    ServiceCenter_CustomSettings__c productionDomain = ServiceCenter_CustomSettings__c.getValues('Production_Email_Setting');
    ServiceCenter_CustomSettings__c testDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
    ServiceCenter_CustomSettings__c scToAddresses = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');
    ServiceCenter_CustomSettings__c ccTestDomain = ServiceCenter_CustomSettings__c.getValues('Production_CC_EmailSettings');
    String retURL;
    //public List<cInstallation> cInstList{get; set;}
    public date myDateTime = date.today();
    public String SysDate = String.valueOf(myDateTime);
    public List<String> statusCodeList{get; set;}
    public String statusList = '(\'1\',\'2\')';
    public boolean timedoutFlag {get;set;}
    //Added for Bland selv phase 2b
    //####
    public static String existingProductsXmlResponse{get;set;}
    //Added for SF-2561
    public static String BSListXmlResponse{get;set;}
    public static String BadPayeeCalloutXmlResponse{get;set;}
    public static Map<String, String> instMap{get;set;}
    public static String mBillOnphoneUrl = YouSeeCustomSettings__c.getInstance('mBillingOnphoneUrl').Setting_Value__c;
    public static String installationIdStr{get;set;}
    public static String emailSTR{get;set;}
    public static String customerName{get;set;}   
    public Set<Id> set_existingBadPayee{get;set;} 
    public Set<Id> set_newCheckedBadPayee{get;set;} 
    public Set<Id> set_newUnCheckedBadPayee{get;set;} 
    //Bland selv fase 2b
    public String BSsearchValues{get;set;}
    public List<String> installationId;
    public String idString;
    public integer searchlistsize; 
    public Boolean SogAddressFlag{get; set;}
    //support-5377
    public String accountId{get;set;}
    public Boolean renderSection{get;set;}
    
    
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewAddressesForInstallationsController2','Change Tv-Package');
    
    public ViewAddressesForInstallationsController2(){
        try {
            //Added for bland selv phase 2 b
            set_existingBadPayee=new Set<Id>();            
            set_newCheckedBadPayee=new Set<Id>();
            set_newUnCheckedBadPayee=new Set<Id>();
            
            errorFlag =  false;
            FORCE_TEST_MODE = false;
            SogAddressFlag = false;
            productOfferingFlag = true;
            List<Cable_Unit__c> cableUnits;
            portalBrugerRole = contactRolesBruger;
            userSelectedPage = Label.SC_installationerPage;
            statusCodeList = new List<String>{'1','2'};
                //cInstList = new List<cInstallation>();
                
                siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
            localeSetting = UserInfo.getLocale();
            System.debug('LocaleSetting*****'+localeSetting);
            if(apexPages.currentPage().getParameters().get('cableunitnumber') != null){  
                cableUnitNumber = apexPages.currentPage().getParameters().get('cableunitnumber');
            }
            trimmedCU = cableUnitNumber.trim().replaceAll('^0+(?!$)', '');
            //Support-SUPPORT-5377
            accountId ='';
            Boolean cableUnitMatch = true;// Support-5377
            renderSection = true; // Support-5377
            if(apexPages.currentPage().getParameters().get('accountId') != null){
                accountId = ApexPages.CurrentPage().getParameters().get('accountId');
                
            }
            list<Account> accList = new list<Account>();
            if(String.isNotBlank(accountId)){
                
                accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
            }
            
            if(!accList.isEmpty()){
                if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                    renderSection = false;
                    cableUnitMatch = false;
                    /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cable Unit Not matched with Account');
ApexPages.addMessage(errorMsg); */ 
                }
            }
            else
            {
                renderSection = false;
                cableUnitMatch = false;
            }
            
            if(cableUnitMatch){
                
                
                //Changes for SC-578,removed field c.Loop__c for SF-1224 Production deployment (Add a field)
                if(cableUnitNumber != null){
                    cableUnits = [Select c.Name,c.Cable_Unit_No__c, c.Legal_Account_No__c, c.Legal_Account_No__r.Customer_No__c, 
                                  c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.id, c.distinctAddresses__c, c.Number_of_installations__c,c.Loop__c from Cable_Unit__c c where 
                                  c.Cable_Unit_No__c =: cableUnitNumber limit 1];
                }
                cableUnitLoop = false;
                system.debug('aaaaaaa ' +cableUnits);
                if(cableUnits != null && cableUnits.size() > 0){
                    if(cableUnits[0].Name != null){
                        cableUnitName = cableUnits[0].Name;
                    }
                    if(cableUnits[0].Legal_Account_No__c != null){
                        legalAccountNo = cableUnits[0].Legal_Account_No__r.Customer_No__c;
                    }
                    if(cableUnits[0].Current_Kiss_Case__r.Sales_Concept_Lookup__r.id != null){
                        currentSalesConceptId = cableUnits[0].Current_Kiss_Case__r.Sales_Concept_Lookup__r.id;
                    } 
                    if(cableUnits[0].distinctAddresses__c != null){
                        distinctStreetNames = cableUnits[0].distinctAddresses__c;
                    } 
                    if(cableUnits[0].Number_of_installations__c <= 1000){
                        filterOptions.add(new SelectOption('Alle adresser', 'Alle adresser'));
                    }
                    
                    if (cableUnits[0].Loop__c != null && cableUnits[0].Loop__c == 'T'){
                        cableUnitLoop = true;
                    }
                    
                }
                system.debug('Cable unit loop:'+ cableUnitLoop);
                if(distinctStreetNames != null && distinctStreetNames != ''){
                    List<String> streetNames = new List<String>();
                    if(distinctStreetNames.contains(',')){
                        streetNames = distinctStreetNames.split(',');
                    }else{
                        streetNames.add(distinctStreetNames);                
                    }    
                    System.debug('streetNames: '+streetNames);
                    for(String street : streetNames){
                        if(street != null && street != '' && street.split('\\(')[0] != ''){
                            String streetName = street;     
                            streetName = streetName.contains('&#39;')?streetName.replace('&#39;', '\''):streetName;
                            filterOptions.add(new SelectOption(streetName.split('\\(')[0], streetName));
                        }
                        errorFlag = false;  
                    }
                    filterOptions = sortOptionList(filterOptions);
                    
                    //Added for displaying 1000 installations in one go(SC-444)
                    if(cableUnits[0].Number_of_installations__c <= 1000){
                        System.debug('#Inside 1000 installations#');
                        addressSearch = '';
                    }else{
                        addressSearch = filterOptions.get(0).getValue().split('\\(')[0];
                    }
                    //addressSearch = filterOptions.get(0).getValue().split('\\(')[0];
                    //System.debug('street: '+filterOptions);
                }else{
                    errorFlag = true;
                    ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_EmptyInstallations);
                    ApexPages.addMessage(errorMsg1);
                }    
                String exportQuery = 'select inst.Id,inst.Location__c, inst.Cable_Unit__r.Name, inst.Address__r.Name, '+
                    'inst.Installation_Status_Code__c, inst.Address__r.Street__c, inst.Name,inst.Address__r.Entrance__c, '+
                    'inst.Address__r.Floor__c, inst.Address__r.Town__c, inst.Address__r.Door_No__c, '+
                    'inst.Address__r.District__c,inst.Address__r.House_No__c,inst.Address__r.PostCode__c '+
                    'From Net_Installations__c inst where inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cableUnitNumber + '\' '+
                    ' and inst.Start_Date__c <= '+ SysDate+'T23:59:00.000Z'+
                    ' and inst.Installation_Status_Code__c IN ' + statusList + 
                    'order by inst.Address__r.Name, inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c, '+
                    'inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c';
                
                //           List<Net_Installations__c> netInstall = Database.query(exportQuery);
                exportquery += ' limit 500';
                System.debug('#Export Query#'+exportquery); 
                setExcelquery(exportQuery);
                //           if(netInstall.size() <= 0){
                if (cableUnits[0].Number_of_installations__c <= 0){
                    //               System.debug('$$newInstall$$'+netInstall.size());
                    ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_EmptyInstallations);
                    ApexPages.addMessage(errorMsg1);
                } 
                if(cableUnits[0].Number_of_installations__c != null){
                    addressesSize = cableUnits[0].Number_of_installations__c <= 500 ? false:true;   
                }else{
                    addressesSize = false; 
                }
                
                System.debug('$$size: '+addressesSize);
            }          
            fetchAddresses();
        } catch (Exception e) { 
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            //System.debug('*****Error: '+e.getMessage());
            errorFlag = true;
        }       
    }
    
    public string getTodayDate(){
        return datetime.now().format('dd-MM-yyyy');
    }
    
    public String getSearchHsNoText(){
        return searchHsNoText;
    }
    
    public void setSearchHsNoText(String text){
        searchHsNoText = text;
    }
    
    public void setValidateNewResident(boolean validateNewResident){
        this.validateNewResident= validateNewResident;
    }
    
    public Boolean getValidateNewResident(){
        return validateNewResident;
    }
    
    public Map<String, List<cInstallationHistory>> getWrapperMap(){
        return wrapperMap;
    }
    
    public String getShowChangeALL(){
        return showChangeALL ;
    }
    
    public void setShowChangeALL(String showChangeALL){
        this.showChangeALL = showChangeALL;
    }
    
    public void setInstallationList(List<cInstallation> installationList){
        this.installationList = installationList;
    }
    
    
    
    public List<cInstallation> getInstallationOfferingList(){
        if(installationOfferingList.size() > 1){
            setShowChangeALL('display:block'); 
        }else{
            setShowChangeALL('display:none');
        }
        system.debug('Heap size in getInstallationOfferingList' + Limits.getHeapSize() + ' Remaining:' + Limits.getLimitHeapSize() );
        return installationOfferingList;
    }
    
    public List<cInstallation> getconfirmedInstallationsForMail(){
        return confirmedInstallationsForMail;
    }
    
    public List<Order__c> getdslOrderListForMail(){
        return dslOrderListForMail;
    }
    
    public void fetchAddresses(){
        try {
            if(addressSearch != null && addressSearch != ''){
                addressSearch = addressSearch.contains('&#39;')?addressSearch.replace('&#39;', '\''):addressSearch;
                //Commented for remove more thyan one escap
                //addressSearch = String.escapeSingleQuotes(addressSearch);
                System.debug('*****addressSearch***'+addressSearch);
            }    
            databaseQuery = 'select inst.isBadPayee__c,inst.Cable_Unit__r.Cable_Unit_No__c,inst.Cable_Unit__r.Customer__r.Customer_No__c, inst.Cable_Unit__r.Customer__r.Email__c,Move_Flag__c,inst.Id,inst.Location__c, inst.INSTALLATION_ID__c, inst.Cable_Unit__r.Name,inst.Address__r.Name,inst.Installation_Status_Code__c,inst.Address__r.Street__c, inst.HasFuturePackage__c,'+
                'inst.Name,inst.Address__r.Entrance__c,inst.Address__r.Floor__c,inst.Address__r.Town__c,inst.Address__r.External_Id__c,'+
                'inst.Address__r.Door_No__c,inst.Address__r.District__c,inst.Address__r.House_No__c,inst.Address__r.PostCode__c, inst.Installation_Formula_Status__c,inst.Image_Status_Text__c  '+
                'From Net_Installations__c inst where';
            databaseQuery += ' inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cableUnitNumber + '\' and Start_Date__c <= '+ SysDate+'T23:59:00.000Z' + ' and inst.Installation_Status_Code__c IN ' + statusList;
            //databaseQuery = databaseQuery + ' inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cableUnitNumber + '\'';
            if(searchHsNoText != null && searchHsNoText.length() > 0){
                databaseQuery = databaseQuery + ' and inst.Address__r.Name=\'' + addressSearch + '\' and inst.Address__r.House_No__c =\''+searchHsNoText+ '\'';
                errorFlag = false;
            }else{
                if(addressSearch != null && addressSearch != '' && addressSearch != 'Alle adresser'){
                    System.debug('#addressSearch#');
                    databaseQuery = databaseQuery + ' and inst.Address__r.Name=\''+ addressSearch +'\'';
                    errorFlag = false;
                }else{
                    System.debug('#Default Selected Else Query#'+databaseQuery);
                }   
                
            }
            //Bland selv Phase 2b
            system.debug('idString-->'+idString);
            // system.debug('searchlistsize-->'+searchlistsize);
            
            if(BSsearchValues=='BlandSelv')
            {
                databaseQuery = databaseQuery + ' and inst.Id IN ('+idString+')';
                
            }
            //End Bland selv Phase 2
            system.debug('addresses search: +'+addressSearch);
            databaseQuery = databaseQuery + ' order by inst.Address__r.Name, inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c,inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c limit 1000';
            System.debug('#strInstQuery#'+databaseQuery);
            showFlagChange = true;
            if(databaseQuery != null){
                setQuery(databaseQuery);
                setExcelQuery(databaseQuery);//Added for bland selv phase 2 b
                
            }
            if(FORCE_TEST_MODE == true){
                integer i;
                i = 10/0;
            }
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError); 
            ApexPages.addMessage(errorMsg);
        }      
    } 
    
    public List<cInstallation> getInstallationList(){
        try {
            setSelectedPackages();
            
            cInstallation installation = null;
            Map<Id, Subscription__c> subscriptionMap = new Map<Id, Subscription__c>();
            Set<Id> instSet = new Set<Id>();
            set<String> set_installatinNumbers=new Set<String>();// Added for bland selv phase 2 b
            
            installationList = new List<cInstallation>();
            if(FORCE_TEST_MODE){
                subscriptionInst = (List<Net_Installations__c>)Database.query(databaseQuery);
            }else{
                subscriptionInst = (List<Net_Installations__c>)getRecords(); 
                
            }
            //Added for bland selv phase 2 b
            system.debug('$$$$installation size: subscriptionInst'+subscriptionInst.size() +'::::'+subscriptionInst);
            Set<Id> set_existing_allBadPayee=new Set<Id>();
            for (Net_Installations__c sInst: subscriptionInst){
                instSet.add(sInst.Id);
                //added for bland selv phase 2 b
                set_installatinNumbers.add(sInst.Installation_Id__c);
                if(sInst.isBadPayee__c==true){
                    system.debug('!@@ sInst.isBadPayee__c:'+sInst.isBadPayee__c);
                    set_existing_allBadPayee.add(sInst.Id);
                    
                    
                }
            }
            set_existingBadPayee=set_existing_allBadPayee;
            system.debug('$$$$instSet :'+instSet);
            system.debug('***set_existingBadPayee***'+set_existingBadPayee);
            
            //            system.debug('test ' +subscriptionInst + 'Size is:'+ subscriptionInst.size() + 'Set Values' + instSet + 'size of Sets' + instSet.size());
            //Added for bland selv phase 2 b
            List<Subscription__c> sList = [Select s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c,s.Net_Installation__c,s.Net_Installation__r.Cable_Unit__r.Customer__r.Customer_No__c,s.Net_Installation__r.Cable_Unit__r.Customer__r.Email__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, 
                                           s.Product__r.Name, s.Address__c,s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s 
                                           //where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today() order by s.Start_Date__c];
                                           where s.Net_Installation__c =: instSet and s.Start_Date__c <=: date.today() order by s.Start_Date__c];
            System.debug('@Todays Date@'+date.today());
            if(sList != null && sList.Size() > 0){
                for(Subscription__c s: sList){
                    subscriptionMap.put(s.Net_Installation__c, s);
                }
            }
            for(Integer subscriptionCount = 0 ; subscriptionCount < subscriptionInst.Size() ; subscriptionCount++){
                installation = new cInstallation(subscriptionInst[subscriptionCount], new Subscription__c());
                installation.amsId = subscriptionInst[subscriptionCount].Address__r.External_Id__c;
                if(subscriptionMap.containsKey(subscriptionInst[subscriptionCount].id)){
                    installation = new cInstallation(subscriptionInst[subscriptionCount], subscriptionMap.get(subscriptionInst[subscriptionCount].id));
                    installation.amsId = subscriptionInst[subscriptionCount].Address__r.External_Id__c;
                    installation.isBadPayee=subscriptionInst[subscriptionCount].isBadPayee__c;// Added for bland selv phase 2 b
                    
                }
                installation.installationLbnr = subscriptionInst[subscriptionCount].INSTALLATION_ID__c;  // Added for SC-521
                installationList.add(installation);
            }
            setCheckBoxValue();
            System.debug('pkp installationList :'+installationList);
            return installationList;
        } catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            System.debug(e.getMessage());
            return null;
        }
        
    }
    
    public PageReference displayTvPackages(){
        try{
            selectedFlag = false;
            setSelectedInstallations();
            List<string> installationIds = new List<string>();
            system.debug('###sortedInstallations#'+sortedInstallations);
            system.debug('Heap size in display function:' + Limits.getHeapSize() + ' Remaining:' + Limits.getLimitHeapSize() );
            List<String> installationLbnr = new List<String>();
            List<String> kundeIdList = new List<String>();
            List<String> datesList = new List<String>();
            ReleaseDate = getPackageDate();   
            List<cInstallation> installationValues = new List<cInstallation>();
            amsIdMap = new Map<String,String>();
            amsIDList = new List<string>();
            if(finalSelectedListInstallationMap.size() > 0){
                installationValues = finalSelectedListInstallationMap.values();
                //cInstList = finalSelectedListInstallationMap.values();
                system.debug('#finalSelectedListInstallationMap#'+finalSelectedListInstallationMap+'#installationValues#'+installationValues.size()+'###sortedInstallations#'+sortedInstallations);
            }
            if(installationValues.size()>0){
                //for(Integer i = 0; i < netInstall.Size(); i++){
                for(Integer selectedValue = 0; selectedValue < installationValues.size(); selectedValue++){
                    //System.debug('installationValues.External_Id__c: '+ installationValues[selectedValue].installation.Address__r.External_Id__c+'netInstall[i].Address__r.External_Id__c: '+netInstall[i].Address__r.External_Id__c);     
                    //if(installationValues[selectedValue].selected && installationValues[selectedValue].installation.Address__r.External_Id__c == netInstall[i].Address__r.External_Id__c){
                    system.debug('$$installationValues[selectedValue].selected$'+installationValues[selectedValue].selected);
                    selectedFlag = true;
                    amsIDList.add(installationValues[selectedValue].installation.Address__r.External_Id__c);
                    amsIdMap.put(installationValues[selectedValue].installation.Address__r.External_Id__c,installationValues[selectedValue].installation.Address__r.External_Id__c);
                    installationIds.add(installationValues[selectedValue].installation.Id);
                    installationLbnr.add(installationValues[selectedValue].installation.INSTALLATION_ID__c);
                    if(installationValues[selectedValue].subscription.Start_Date__c != null){
                        kundeIdList.add('1');
                    }else{
                        kundeIdList.add(legalAccountNo);
                    }
                    datesList.add(ReleaseDate.get(0));
                    //}
                }   
                //}
            }
            
            // Added For Checking high priority Error Message
            try{
                system.debug('##amsIDList##'+amsIDList+'$installationIds$'+installationIds+'####kundeIdList'+kundeIdList);
                productOfferingFlag = fetchProductsForChangeTVPackage(amsIDList, installationIds, installationLbnr, kundeIdList, datesList);
                //             system.debug('Heap size in display function: After HTTP Call' + Limits.getHeapSize() + ' Remaining:' + Limits.getLimitHeapSize() );
                system.debug('Date&Time****After'+DateTime.now());
                system.debug('##productOfferingFlag##'+productOfferingFlag);
                if(productOfferingFlag == false){
                    throw new Custom_Exception('From : ViewAddressesForInstallationsController2  Method: displayTvPackages() Module Name : Change Tv-Package ErrorMessage: Service downtime error',false);
                }
            }catch(Custom_Exception ec){
                system.debug('@Inside Custom Exception@'+ec.getMessage());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
                ApexPages.addMessage(errorMsg);
                timedoutFlag = true;
                system.debug('@Inserted@'+timedoutFlag);
                exceptionHandler.handleException(ec,'displayTvPackages()',false,false,cableUnitNumber,'High');
                return null;
            }
            system.debug('Heap size in display function: After HTTP Call' + Limits.getHeapSize() + ' Remaining:' + Limits.getLimitHeapSize() );
            //System.debug('productOfferingFlag: '+productOfferingFlag); 
            return null;
        }catch (exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'displayTvPackages()',false,false,cableUnitNumber,'Medium');
            system.debug('*Exception_thrown ' +e);
            return null;
        }
    }
    
    public boolean checkValidateNewResident(){
        try {
            List<Sales_Concept_Parameter__c> salesConceptList = [SELECT s.Sales_Concept__c, s.Parameter_Value__c, s.Parameter_Head__c, 
                                                                 Parameter_Group__c From Sales_Concept_Parameter__c s where s.Sales_Concept__c =: currentSalesConceptId and s.Parameter_PortalActive__c = true  
                                                                 and s.Parameter_Head__c = 'Gratis ændringsgebyr nyindflytning' and s.Parameter_Value__c = 'Ja'];
            if(salesConceptList.size() > 0){
                validateNewResident = true;
            }else {
                validateNewResident = false;
            }
            return validateNewResident;
        }catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'getValidateNewResident()',false,false,cableUnitNumber,'Medium');
            return null;
        }         
    }
    
    public PageReference changeTvPackage(){
        // Change to absolute path
        //String pageURL = '/apex/ChangeTvPackagesPage'; 
        //PageReference pageReference = new PageReference(pageURL);
        //PageReference pageReference = Page.ChangeTvPackagesPage;
        // COMMENTED ABOVE FOR SPOC 2411
        PageReference pageReference = Page.ChangeTvPackagesPage_SPOC2411;
        
        return pageReference;
    }
    
    public List<SelectOption> getItems(){
        try {
            /*options.add(new SelectOption('Alle adresser', 'Alle adresser'));
string addrName = null;//1.get the address Name and house No
string minHouseNo = null;
String maxHouseNo = null;
Set<String> streetSet = new Set<String>();
addressItems = [SELECT n.Address__r.Name, n.Address__r.House_No__c 
From Net_Installations__c n where n.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber
order by n.Address__r.Name limit 500];
for(Net_Installations__c installation : addressItems){
streetSet.add(installation.Address__r.Name);                   
}               
for(String name : streetSet){
List<String> houseNo = new List<String>();
for(Net_Installations__c installation : addressItems){
if(installation.Address__r.Name == name){
houseNo.add(installation.Address__r.House_No__c);              
}
}
Integer maxValue = Integer.valueOf(houseNo.get(0)); 
for(Integer i=1; i < houseNo.size(); i++){ 
if(Integer.valueOf(houseNo.get(i)) > maxValue){ 
maxValue = Integer.valueOf(houseNo.get(i)); 
} 
}
Integer minValue = Integer.valueOf(houseNo.get(0)); 
for(Integer i=1; i < houseNo.size(); i++){ 
if(Integer.valueOf(houseNo.get(i)) < minValue){ 
minValue = Integer.valueOf(houseNo.get(i)); 
}      
}
options.add(new SelectOption(name + ' (' + minValue + ' - ' + maxValue+')' , name + ' (' + minValue + ' - ' + maxValue+')')); 
}*/
            return filterOptions;
        } catch (exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            return null;
        }      
    }
    
    /** This method is used to export the Installation Addresses list to a excel sheet.*/
    
    public PageReference exportAddressesToExcel() {
        //ExportAddressesToExcelBatchClass job = new ExportAddressesToExcelBatchClass();
        //job.createExcelForAddresses(cableUnitNumber);
        //callToFutureForAddressesExport(cableUnitNumber);
        PageReference excelPage;
        excelPage= Page.InstallationAddressesE2E;
        return excelPage;
    }
    //added for Bland selv  phase 2 b
    public PageReference exportAddressesToExcelBS() {
        //ExportAddressesToExcelBatchClass job = new ExportAddressesToExcelBatchClass();
        //job.createExcelForAddresses(cableUnitNumber);
        //callToFutureForAddressesExport(cableUnitNumber);
        PageReference excelPageBS;
        excelPageBS= Page.InstallationAddressesBS;
        return excelPageBS;
    }
    
    public PageReference exportAddressesToExcelAndSendMail() {
        //ExportAddressesToExcelBatchClass job = new ExportAddressesToExcelBatchClass();
        //job.createExcelForAddresses(cableUnitNumber);
        callToFutureForAddressesExport(cableUnitNumber);
        /*PageReference excelPage;
excelPage= Page.InstallationAddressesE2E;
return excelPage;*/
        return null;
    }
    
    @future
    public static void callToFutureForAddressesExport(String cu){
        String finalstr; 
        //String recordString;
        String installationIds;
        date myDateTime = date.today();
        String SysDate = String.valueOf(myDateTime);
        String statusInstList = '(\'1\',\'2\')';
        List<String> sList4 = new List<String>{'1','2'};
            //List<Subscription__c> sList = [Select s.Net_Installation__c,s.Net_Installation__r.Location__c,s.Net_Installation__r.Address__r.Entrance__c,s.Net_Installation__r.Address__r.District__c,s.Net_Installation__r.Address__r.Town__c,s.Net_Installation__r.Address__r.PostCode__c,s.Net_Installation__r.Address__r.Floor__c,s.Net_Installation__r.Address__r.Door_No__c, s.Net_Installation__r.Installation_Status_Code__c, s.Net_Installation__r.Address__r.House_No__c,s.Net_Installation__r.Address__r.Name, s.Id, s.Start_Date__c,s.Formatted_Start_Date__c, s.Product__r.Name From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cu and s.Start_Date__c != null and s.Start_Date__c <=: date.today()];
            List<Subscription__c> sList = [Select s.Net_Installation__c, s.Net_Installation__r.Location__c , s.Net_Installation__r.Start_Date__c,s.Net_Installation__r.Address__r.Entrance__c,s.Net_Installation__r.Address__r.District__c,s.Net_Installation__r.Address__r.Town__c,s.Net_Installation__r.Address__r.PostCode__c,s.Net_Installation__r.Address__r.Floor__c,s.Net_Installation__r.Address__r.Door_No__c, s.Net_Installation__r.Installation_Status_Code__c, s.Net_Installation__r.Address__r.House_No__c,s.Net_Installation__r.Address__r.Name, s.Id, s.Start_Date__c,s.Formatted_Start_Date__c, s.Product__r.Name From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cu and s.Start_Date__c != null and s.Start_Date__c <=: date.today() and s.Net_Installation__r.Start_Date__c <=: date.today() and s.Net_Installation__r.Installation_Status_Code__c IN : sList4];
        
        
        System.debug('*****sList.size: '+sList.size());
        //   finalstr = 'sep=,\n';
        finalstr = EncodingUtil.base64decode('77u/').toString();
        finalstr += '"Addresse","Status","Dato","Tv-pakke"\n';
        for(Subscription__c s: sList){
            String addressString = s.Net_Installation__r.Address__r.Name == null ?  '' : s.Net_Installation__r.Address__r.Name;
            addressString = addressString+ (s.Net_Installation__r.Address__r.House_No__c == null ?  '' : (s.Net_Installation__r.Address__r.Name != null ? ' '+s.Net_Installation__r.Address__r.House_No__c : s.Net_Installation__r.Address__r.House_No__c));
            addressString = addressString+(s.Net_Installation__r.Address__r.Entrance__c == null ?  '' : (addressString != null ? ', opgang ' + s.Net_Installation__r.Address__r.Entrance__c : 'opgang ' + s.Net_Installation__r.Address__r.Entrance__c));
            addressString = addressString+(s.Net_Installation__r.Address__r.Floor__c == null ?  '' : (addressString != null ? ', '+s.Net_Installation__r.Address__r.Floor__c : s.Net_Installation__r.Address__r.Floor__c));
            //addressString = addressString+(s.Net_Installation__r.Address__r.Side__c == null ?  '' : (s.Net_Installation__r.Address__r.Floor__c != null ? ' '+s.Net_Installation__r.Address__r.Side__c : (addressString != null ? ', '+s.Net_Installation__r.Address__r.Side__c : s.Net_Installation__r.Address__r.Side__c)));
            addressString = addressString+(s.Net_Installation__r.Address__r.Door_No__c == null ?  '' : ((addressString != null && s.Net_Installation__r.Address__r.Floor__c != null) ? ' Side/dørnr. ' + s.Net_Installation__r.Address__r.Door_No__c : (addressString != null ? ',Side/dørnr. '+s.Net_Installation__r.Address__r.Door_No__c:'Side/dørnr. '+s.Net_Installation__r.Address__r.Door_No__c )));
            addressString = addressString+(s.Net_Installation__r.Location__c == null ?  '' : (addressString != null ? ', '+s.Net_Installation__r.Location__c :s.Net_Installation__r.Location__c));
            addressString = addressString+(s.Net_Installation__r.Address__r.PostCode__c == null ?  '' : (addressString != null ? ', '+s.Net_Installation__r.Address__r.PostCode__c :s.Net_Installation__r.Address__r.PostCode__c));
            addressString = addressString+(s.Net_Installation__r.Address__r.Town__c == null ?  '' : (s.Net_Installation__r.Address__r.PostCode__c != null ? ' '+s.Net_Installation__r.Address__r.Town__c : (addressString != null ? ', '+s.Net_Installation__r.Address__r.Town__c : s.Net_Installation__r.Address__r.Town__c)));
            addressString = addressString+(s.Net_Installation__r.Address__r.District__c == null ?  '' :(addressString != null ? ', '+s.Net_Installation__r.Address__r.District__c:s.Net_Installation__r.Address__r.District__c));
            addressString = addressString.substring(0, addressString.length());
            String recordString = '"'+addressString+'"';  
            if(s.Net_Installation__r.Installation_Status_Code__c == '1'){
                recordString = recordString + ',"Stik opsat"';
            }else if(s.Net_Installation__r.Installation_Status_Code__c == '2'){
                recordString = recordString + ',"Tilslutning mulig"';
            }/*else if(s.Net_Installation__r.Installation_Status_Code__c == '9'){
recordString = recordString + ',"Tilslutning ej mulig"';
}*/else{
    recordString = recordString + ',""';
}
            DateTime dt = s.Start_Date__c; 
            recordString = recordString + ',"'+dt.format('dd-MM-yyyy')+' ","'+s.Product__r.Name+'"\n';
            finalstr = finalstr +recordString;
            system.debug('#finalstr#'+finalstr);
            if(installationIds == null || installationIds == ''){
                installationIds = '\'' + s.Net_Installation__c + '\'';
            }else{
                installationIds += ',\'' +s.Net_Installation__c+'\'';
            } 
        } 
        
        String strInstQuery = 'select inst.Id,inst.Location__c,inst.Cable_Unit__r.Name,inst.Address__r.Name, inst.Installation_Status_Code__c, inst.Address__r.Street__c, inst.HasFuturePackage__c,'+
            'inst.Name,inst.Address__r.Entrance__c,inst.Address__r.Floor__c,inst.Address__r.Town__c,inst.Start_Date__c, inst.Address__r.External_Id__c,'+
            'inst.Address__r.Door_No__c,inst.Address__r.District__c,inst.Address__r.House_No__c,inst.Address__r.PostCode__c, inst.Installation_Formula_Status__c '+
            'From Net_Installations__c inst where';
        strInstQuery = strInstQuery + ' inst.Cable_Unit__r.Cable_Unit_No__c =\'' + cu + '\' and inst.Id Not In ('+installationIds+')' + ' and inst.Start_Date__c <= '+ SysDate+'T23:59:00.000Z';
        strInstQuery = strInstQuery + ' and inst.Installation_Status_Code__c IN ' + statusInstList;
        
        strInstQuery = strInstQuery + ' order by inst.Address__r.Name, inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c,inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c';
        
        List<Net_Installations__c> expList = (List<Net_Installations__c>)Database.query(strInstQuery);
        System.debug('*****expList.size: '+expList.size()+'Final Query for 500'+strInstQuery);         
        for(Net_Installations__c inst : expList){
            String addressString = inst.Address__r.Name == null ?  '' : inst.Address__r.Name;
            addressString = addressString+ (inst.Address__r.House_No__c == null ?  '' : (inst.Address__r.Name != null ? ' '+inst.Address__r.House_No__c : inst.Address__r.House_No__c));
            addressString = addressString+(inst.Address__r.Entrance__c == null ?  '' : (addressString != null ? ', opgang ' + inst.Address__r.Entrance__c : 'opgang ' + inst.Address__r.Entrance__c));
            addressString = addressString+(inst.Address__r.Floor__c == null ?  '' : (addressString != null ? ', '+inst.Address__r.Floor__c : inst.Address__r.Floor__c));
            //addressString = addressString+(inst.Address__r.Side__c == null ?  '' : (inst.Address__r.Floor__c != null ? ' '+inst.Address__r.Side__c : (addressString != null ? ', '+inst.Address__r.Side__c : inst.Address__r.Side__c)));
            addressString = addressString+(inst.Address__r.Door_No__c == null ?  '' : ((addressString != null && inst.Address__r.Floor__c != null) ? ' Side/dørnr. ' + inst.Address__r.Door_No__c : (addressString != null ? ',Side/dørnr. '+inst.Address__r.Door_No__c:'Side/dørnr. '+inst.Address__r.Door_No__c )));
            
            addressString = addressString+(inst.Location__c == null ?  '' : (addressString != null ? ', '+inst.Location__c :inst.Location__c));
            addressString = addressString+(inst.Address__r.PostCode__c == null ?  '' : (addressString != null ? ', '+inst.Address__r.PostCode__c :inst.Address__r.PostCode__c));
            addressString = addressString+(inst.Address__r.Town__c == null ?  '' : (inst.Address__r.PostCode__c != null ? ' '+inst.Address__r.Town__c : (addressString != null ? ', '+inst.Address__r.Town__c : inst.Address__r.Town__c)));
            addressString = addressString+(inst.Address__r.District__c == null ?  '' :(addressString != null ? ', '+inst.Address__r.District__c:inst.Address__r.District__c));
            
            addressString = addressString.substring(0, addressString.length());
            String recordString = '"'+addressString+'"';
            if(inst.Installation_Status_Code__c == '1'){
                recordString = recordString + ',"Stik opsat"';
            }else if(inst.Installation_Status_Code__c == '2'){
                recordString = recordString + ',"Tilslutning mulig"';
            }/*else if(inst.Installation_Status_Code__c == '9'){
recordString = recordString + ',"Tilslutning ej mulig"';
}*/else{
    recordString = recordString + ',""';
}
            recordString = recordString + ',"",""\n';
            finalstr = finalstr +recordString;
        }          
        
        if(finalstr != '' && finalstr.length() > 0){ 
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            String trimmedCU = cu.trim().replaceAll('^0+(?!$)', '');
            string csvname = 'Eksporterede_Installationsadresser-'+ trimmedCU +'.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            email.setTargetObjectId(UserInfo.getUserId());
            List<EmailTemplate> templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'ExportAddressesInExcelMailTemplate'];
            email.setTemplateId(templateList.get(0).id);
            OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
            email.setOrgWideEmailAddressId(owa.Id);
            email.setSaveAsActivity(false);
            csvAttc.setContentType('text/csv; charset=UTF-8');
            //   csvAttc.setContentType('application/vnd.ms-excel');
            //email.setCharset('UTF-8');
            ServiceCenter_CustomSettings__c scToAddresses1 = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');
            ServiceCenter_CustomSettings__c testDomain1 = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
            ServiceCenter_CustomSettings__c ccTestDomain1 = ServiceCenter_CustomSettings__c.getValues('Production_CC_EmailSettings');
            String value2;
            String retURL3;
            String[] toCCAddresses1; 
            //      if(retURL3 == testDomain1.Value__c){
            if(ccTestDomain1 != null && ccTestDomain1.Value__c != null){
                value2 = ccTestDomain1.Value__c;
                toCCAddresses1 = value2.split(';');
                //  email.setToAddresses(toCCAddresses1);
                email.setCcAddresses(toCCAddresses1);
                //System.debug('#toCCAddresses#'+toCCAddresses1);
            }
            //     }
            //String[] toAddresses = new list<string> {'savra@yousee.dk'};
            //email.setToAddresses(toAddresses);
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            system.debug('#Email Send#');
        } 
    }
    
    /** This method passes the list to exportexceladdresses page */
    
    public List<cInstallation> getListExport(){
        try {
            List<Net_Installations__c> expList = (List<Net_Installations__c>)getRecordsforExport();
            List<cInstallation> installationList = new List<cInstallation>();
            Map<Id, Subscription__c> subscriptionMap = new Map<Id, Subscription__c>();
            //List<Subscription__c> sList = [Select s.Net_Installation__c, s.Id, s.Start_Date__c, s.Product__r.Name From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today()];
            List<Subscription__c> sList = [Select s.Net_Installation__c,s.Net_Installation__r.Location__c,s.Net_Installation__r.Start_Date__c ,s.Id, s.Start_Date__c, s.Product__r.Name,s.Net_Installation__r.Installation_Status_Code__c From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today() and s.Net_Installation__r.Start_Date__c <=: date.today() and s.Net_Installation__r.Installation_Status_Code__c IN : statusCodeList];
            
            for(Subscription__c s: sList){
                subscriptionMap.put(s.Net_Installation__c, s);
            }          
            
            for(Integer subscriptionCount = 0 ; subscriptionCount < expList.Size() ; subscriptionCount++){
                if(subscriptionMap.size() > 0 && subscriptionMap.containsKey(expList[subscriptionCount].id)){
                    installationList.add(new cInstallation(expList[subscriptionCount], subscriptionMap.get(expList[subscriptionCount].id)));
                }else{
                    installationList.add(new cInstallation(expList[subscriptionCount], new Subscription__c()));
                }
            }
            if(FORCE_TEST_MODE == true){
                integer i;
                i = 10/0;
            }
            if(installationList.size() > 0){
                return installationList;
            }else{
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No records found.');
                ApexPages.addMessage(errorMsg);
                return null;
            }  
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }        
    }
    //added for Bland Selv phase 2 b
    public List<cInstallation> getListExportBS(){
        try {
            List<Net_Installations__c> expListBS = (List<Net_Installations__c>)getRecordsforExport();
            List<cInstallation> installationListBS = new List<cInstallation>();
            Map<Id, Subscription__c> subscriptionMapBS = new Map<Id, Subscription__c>();
            List<Subscription__c> sListBS = new List<Subscription__c>();
            //List<Subscription__c> sList = [Select s.Net_Installation__c, s.Id, s.Start_Date__c, s.Product__r.Name From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today()];
            //sList = [Select Net_Installation__c,Net_Installation__r.Location__c,Net_Installation__r.Start_Date__c ,Id,Start_Date__c,Product__r.Name,Net_Installation__r.Installation_Status_Code__c From Subscription__c where Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and Start_Date__c <=: date.today() and Net_Installation__r.Start_Date__c <=: date.today() and Net_Installation__r.Installation_Status_Code__c IN : statusCodeList and Product__r.Name='Fuldpakke med Bland Selv'];
            //system.debug('sList -->'+sList );
            for(Subscription__c BS: [Select Net_Installation__c,Net_Installation__r.Location__c,Net_Installation__r.Start_Date__c ,Id,Start_Date__c,Product__r.Name,Net_Installation__r.Installation_Status_Code__c From Subscription__c where Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and Start_Date__c <=: date.today() and Net_Installation__r.Start_Date__c <=: date.today() and Net_Installation__r.Installation_Status_Code__c IN : statusCodeList and Product__r.Name like '%med Bland Selv%']){
                
                subscriptionMapBS.put(BS.Net_Installation__c,BS);
            }          
            system.debug('subscriptionMap-->'+subscriptionMapBS);
            
            for(Integer subscriptionCountBS = 0 ; subscriptionCountBS < expListBS.Size() ; subscriptionCountBS++){
                
                if(subscriptionMapBS.size() > 0 && subscriptionMapBS.containsKey(expListBS[subscriptionCountBS].id)){
                    
                    installationListBS.add(new cInstallation(expListBS[subscriptionCountBS], subscriptionMapBS.get(expListBS[subscriptionCountBS].id)));
                }
            }
            if(FORCE_TEST_MODE == true){
                integer i;
                i = 10/0;
            }
            if(installationListBS.size() > 0){
                System.debug('installationListBS-->'+installationListBS);
                System.debug('subscriptionMapBS-->'+subscriptionMapBS);
                
                return installationListBS;
            }else{
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No records found.');
                ApexPages.addMessage(errorMsg);
                return null;
            } 
            
            
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }        
    }
    public Pagereference search(){
        List<String> codeList = new List<String>{'1','2'};
            //Added for bland selv phase 2 b
            List<Subscription__c> subscriptionList =new list<Subscription__c>();
        installationId=new List<String>();
        String concatinstallID='';
        SET<String> searchinstallationId=new SET<String>();
        
        List<Net_Installations__c> searchList;//= new List<Net_Installations__c>();
        
        system.debug('$Inside search$'+cableUnitNumber);
        system.debug('addressSearch outside-->'+addressSearch );
        
        try {
            installationList = new List<cInstallation>();
            addressSearch = searchValues;
            //Added for bland selv phase 2 b
            if(addressSearch != null && addressSearch != ''){
                addressSearch = addressSearch.contains('&#39;')?addressSearch.replace('&#39;', '\''):addressSearch;
                addressSearch = String.escapeSingleQuotes(addressSearch);
            }
            
            System.debug('searchValues: ***'+searchValues);
            if(searchHsNoText != null && searchHsNoText.length() > 0 && BSsearchValues!='BlandSelv'){
                errorFlag = true;
                system.debug(addressSearch + ' aaaa ' + searchHsNoText);
                //List<Net_Installations__c> searchList = [Select n.Address__r.Name, n.Address__r.House_No__c from Net_Installations__c n where n.Address__r.Name =: addressSearch and n.Address__r.House_No__c =: searchHsNoText ];
                //Added for Bland selv phase 2 b
                
                searchList = [Select n.Cable_Unit_No__c, n.Id,n.Address__r.Name, n.Address__r.House_No__c,n.Start_Date__c,n.Installation_Status_Code__c,n.Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c n where n.Cable_Unit__r.Cable_Unit_No__c = :cableUnitNumber and n.Address__r.Name =: addressSearch and n.Address__r.House_No__c =: searchHsNoText and n.Start_Date__c <= :Date.today() and n.Installation_Status_Code__c IN : codeList];
                system.debug('$$$$$$searchList'+searchList);
                
            }   
            system.debug('$$$$$$BSsearchValues'+BSsearchValues);
            
            if(BSsearchValues=='BlandSelv')
            {
                subscriptionList = [Select Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c,Net_Installation__c, Id, Name, Start_Date__c, End_Date__c, 
                                    Product__r.Name, Address__c,Future_Subscription__c,Subscription_No__c From Subscription__c  
                                    where Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and Start_Date__c <=: date.today() and Product__r.Name like'%med Bland Selv%' order by Start_Date__c];
                if(subscriptionList.size()>0){
                    idString='';
                    idString = '\'';
                    system.debug( 'idString outside-->'+idString); 
                    for(Subscription__c sub:subscriptionList )
                    {      
                        system.debug( 'net installation-->'+sub.Net_Installation__c); 
                        idString += sub.Net_Installation__c + '\',\'';
                        system.debug('Id string in for loop-->'+idString);
                        //  installationId.add(sub.Net_Installation__c);
                        // installationId.add(idString);
                        searchinstallationId.add(sub.Net_Installation__c);
                        
                    }
                    idString = idString.substring(0,idString.length()-2);
                    
                    //idString += ')';
                    
                    installationId.add(idString);
                    system.debug('Installation id are-->'+installationId);  
                    system.debug('idString outside-->'+idString);
                }
                system.debug('addressSearch outside-->'+addressSearch );
                if(searchHsNoText != null && searchHsNoText.length() > 0)
                { //errorFlag = true;
                    searchList = [Select Cable_Unit_No__c,Id,Address__r.Name, Address__r.Street__c,Address__r.House_No__c,Start_Date__c,Installation_Status_Code__c,Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c where Cable_Unit__r.Cable_Unit_No__c = :cableUnitNumber and Address__r.Name =: addressSearch and Address__r.House_No__c =: searchHsNoText and Start_Date__c <= :Date.today() and Installation_Status_Code__c IN : codeList and ID IN: installationId];
                }
                else{
                    searchList = [Select Cable_Unit_No__c,Id,Address__r.Name,Address__r.Street__c, Address__r.House_No__c,Start_Date__c,Installation_Status_Code__c,Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c where Cable_Unit__r.Cable_Unit_No__c = :cableUnitNumber and Address__r.Name =: addressSearch and Start_Date__c <= :Date.today() and Installation_Status_Code__c IN : codeList and ID IN: installationId];
                }
                system.debug('$$$$$$searchList in BB'+searchList);
                system.debug('$$$$$$searchList size'+searchList.size());
                
                
            }
            
            else{
                searchList = [Select n.Cable_Unit_No__c,n.Id,n.Address__r.Name, n.Address__r.House_No__c,n.Address__r.Street__c,n.Start_Date__c,n.Installation_Status_Code__c,n.Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c n where n.Cable_Unit__r.Cable_Unit_No__c = :cableUnitNumber and n.Address__r.Name =: addressSearch and n.Address__r.House_No__c =: searchHsNoText and n.Start_Date__c <= :Date.today() and n.Installation_Status_Code__c IN : codeList];
                
            } 
            if(searchList != null && searchList.size() > 0){
                errorFlag = false;
            }
            if(searchList != null && searchList.size() > 0){
                errorFlag = false;
            }
            if(errorFlag){
                ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.SC_EmptyInstallations);
                ApexPages.addMessage(debugMsg);
                SogAddressFlag = true;
                return null;
            }
            //searchlistsize=searchList.size();
            
            System.debug('Before fetchAddresses()');
            fetchAddresses();
            System.debug('After fetchAddresses()');
            
            initializePaging(); // This method should be called after fetchAddresses() here in this requirement.
            return null;
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'search()',false,false,cableUnitNumber,'Medium');
            return null;
        }    
    }
    
    public void parseInstallationHistoryXML(String response, List<cInstallation> historyAddresses){
        system.debug('response'+response);
        try {
            Dom.Document doc = new Dom.Document();
            if(FORCE_TEST_MODE){
                response = ' <?xml version="1.0" encoding="UTF-8"?>';
                response += '<rows>';
                response += '<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>58849</AMSADDRESSID>';
                response += '<INST_LBNR>1</INST_LBNR><STARTDATO>2008-01-01T00:00:00.000</STARTDATO><SLUTDATO>2100-01-01T00:00:00.000</SLUTDATO><VARENAVN>Fuldpakke</VARENAVN></row>';
                response += '<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>136548</AMSADDRESSID><INST_LBNR>1</INST_LBNR>';
                response += '<STARTDATO>2008-09-01T00:00:00.000</STARTDATO><SLUTDATO>2100-01-01T00:00:00.000</SLUTDATO><VARENAVN>Mellempakke</VARENAVN></row>';
                response += '<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>445630</AMSADDRESSID>';
                response += '<INST_LBNR>1</INST_LBNR><STARTDATO>2008-01-01T00:00:00.000</STARTDATO><SLUTDATO>2008-08-31T00:00:00.000</SLUTDATO><VARENAVN>Grundpakke</VARENAVN></row>';
                response += '</rows>';
            }
            if(response != null && response != '11'){
                doc.load(response);
                //cInstallationHistory installation = null;
                cInstallationHistory installation =new cInstallationHistory();
                
                List<cInstallationHistory> histList = null;
                List<cInstallationHistory> histListLatest = null;
                List<cInstallationHistory> installationList = new List<cInstallationHistory>();
                system.debug('doc.getRootElement().getChildElements()'+doc.getRootElement().getChildElements());
                for(dom.XmlNode node : doc.getRootElement().getChildElements()) {
                    List<Dom.XmlNode> childNodes =  node.getChildElements();
                    system.debug('childNodes+++++++++++'+childNodes);
                    for (Dom.XmlNode child : childNodes) {
                        system.debug('child'+child);
                        system.debug('child.getName()++++'+child.getName());
                        //system.debug('child.getText()++++'+child.getText());
                        if(child.getName().equals('AMS_ADDRESS_ID') && child.getText().trim().length() > 0){
                            for(cInstallation sub : historyAddresses){
                                if(sub.installation.Address__r.External_Id__c.equals(child.getText().trim())){
                                    installation = new cInstallationHistory();
                                    installation.formattedAddress = sub.getFormattedAddress();
                                    System.debug('$formattedAddresses $'+installation.formattedAddress);
                                }
                            }
                        }else if(child.getName().equals('INSTALLATION_LBNR') && child.getText().trim().length() > 0){
                            installation.Installation_Lbnr = child.getText().trim();
                        }else if(child.getName().equals('START_DATE') && child.getText().trim().length() > 0){                                                          
                            installation.StartDate = parseInstallationDate(child.getText().trim());
                        }else if(child.getName().equals('END_DATE') && child.getText().trim().length() > 0){
                            installation.EndDate = parseInstallationDate(child.getText().trim());
                        }else if(child.getName().equals('VARENAME') && child.getText().trim().length() > 0){
                            installation.ProductName = child.getText().trim();
                        }
                    }
                    if(installation != null)
                        installationList.add(installation);
                }
                for(cInstallationHistory inst : installationList){
                    histList = new List<cInstallationHistory>();
                    histListLatest =  new List<cInstallationHistory>();
                    for(cInstallationHistory i : installationList){
                        if(i.formattedAddress.equals(inst.formattedAddress)){
                            if(i.EndDate !='')
                                histListLatest.add(i);
                            else
                                histList.add(i);
                        }
                    }
                    if(!histListLatest.isEmpty())
                    {
                        histListLatest.sort();
                        system.debug('=====After sort=1=========='+histList);
                        histList.addAll(histListLatest);
                    }
                    wrapperMap.put(inst.formattedAddress, histList);
                }
                System.debug('History of changeTvPackage - '+wrapperMap);
            }
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'parseInstallationHistoryXML()',false,false,cableUnitNumber,'Medium');
        }
    }
    
    @testvisible private String parseInstallationDate(String installationDate){
        String year, month, day;
        if(installationDate.length() >= 10){
            installationDate = installationDate.substring(0, 10);
            year = installationDate.substring(0, 4);
            month = installationDate.substring(5, 7);
            day = installationDate.substring(8, 10);
        }
        String parseDate = day+'-'+month+'-'+year;
        if(parseDate == '01-01-2100'){
            return '';
        }else{
            return parseDate;              
        }
    }
    
    public String createInstallationHistoryReqXML(List<cInstallation> historyAddresses){
        try {
            String xmlString = '';
            xmlString = '<?xml version="1.0" encoding="UTF-8"?>';
            xmlString += '<Installations>';
            for(cInstallation installation : historyAddresses){
                if (installation.installation.Address__r.External_Id__c != null){
                    xmlString += '<Installation>';
                    xmlString += '<Address_Id>'+installation.installation.Address__r.External_Id__c+'</Address_Id>';
                    //   xmlString += '<Installation_Lbnr>1</Installation_Lbnr>';
                    xmlString += '<Installation_Lbnr>'+installation.installationLbnr+'</Installation_Lbnr>';   // Added for SC-521   
                    xmlString += '</Installation>';
                }
            }
            xmlString += '</Installations>';
            if(FORCE_TEST_MODE){
                xmlString = '<?xml version="1.0" encoding="UTF-8"?><Installations><Installation><Address_Id>55849</Address_Id><Installation_Lbnr>1</Installation_Lbnr></Installation><Installation><Address_Id>136548</Address_Id><Installation_Lbnr>1</Installation_Lbnr></Installation></Installations>';
            }
            return xmlString;
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'createInstallationHistoryReqXML()',false,false,cableUnitNumber,'Medium');
            return null;
        }     
    }
    
    public PageReference viewInstallationHistory(){
        try{
            List<cInstallation> selectedAddresses = new List<cInstallation>();
            setselectedInstallations();
            //       selectedAddresses.clear();
            wrapperMap.clear();
            //    List<cInstallation> selectedAddresses = getSelectedSubscriptionForAddresses();
            selectedAddresses = finalSelectedListInstallationMap.values();
            if(selectedAddresses.size() <= 0){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Vælg venligst en adresse');
                ApexPages.addMessage(errorMsg);  
                return null;
            }
            String request = createInstallationHistoryReqXML(selectedAddresses);
            String response = '11';
            if(request != null){
                system.debug('$Request$'+request);
                if(!FORCE_TEST_MODE){
                    //response = HttpRequestUtil.makeHttpCall('YSSCInstHistReq', request);
                    calloutParameter.add('null');
                    //calloutValue.add('<?xml version="1.0" encoding="UTF-8"?><Installations><Installation><Address_Id>6845228</Address_Id><Installation_Lbnr>1267617</Installation_Lbnr></Installation></Installations>');
                    calloutValue.add(request);
                    response= clsConnectionUtils_Admin.callout1('YSSCInstHistReq',calloutParameter,calloutvalue);
                    calloutParameter = new List<String>();
                    calloutvalue = new List<String>();
                    
                    
                }else{
                    response = '<?xml version="1.0" encoding="UTF-8"><row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>55849</AMSADDRESSID><INST_LBNR>1</INST_LBNR><STARTDATO>2004-10-01T00:00:00.000</STARTDATO><SLUTDATO>2009-10-31T00:00:00.000</SLUTDATO><VARENAVN>Fuldpakke</VARENAVN></row>';
                    response += '<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>55849</AMSADDRESSID><INST_LBNR>1</INST_LBNR><STARTDATO>2009-11-01T00:00:00.000</STARTDATO><SLUTDATO>2100-01-01T00:00:00.000</SLUTDATO><VARENAVN>Grundpakke</VARENAVN></row>';
                    response += '<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><AMSADDRESSID>136548</AMSADDRESSID><INST_LBNR>1</INST_LBNR><STARTDATO>1989-09-01T00:00:00.000</STARTDATO><SLUTDATO>2004-09-30T00:00:00.000</SLUTDATO><VARENAVN>Grundpakke</VARENAVN></row></rows>';
                }   
                system.debug('$Response$'+response);
            }
            parseInstallationHistoryXML(response,selectedAddresses);
            // Change to absolute path
            Pagereference viewHistoryPage = Page.ViewInstallationAddressHistory;
            //Pagereference viewHistoryPage = new Pagereference('/apex/ViewInstallationAddressHistory');
            //viewHistoryPage.setRedirect(true);
            return viewHistoryPage;
        }catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            exceptionHandler.handleException(e,'viewInstallationHistory()',false,false,cableUnitNumber,'Medium');
            return null; 
        }       
    }
    
    public List<cInstallation> getSelectedSubscriptionForAddresses(){
        List<cInstallation> selectedAddresses = new List<cInstallation>();
        for(cInstallation installation : installationList){
            System.debug('$Installation list$'+installationList);
            if(installation.selected == true){
                System.debug('Inside selected'+installation.selected);
                selectedAddresses.add(installation);
            }
        }
        return selectedAddresses;
    }
    
    /*public class cInstallationHistory{
public String Installation_Lbnr{get;set;}
public String formattedAddress{get;set;}
public String StartDate{get;set;}
public String EndDate{get;set;}
public String ProductName{get;set;}
}*/
    
    /************ChangeTvPackageController********************/
    
    public Boolean fetchProductsForChangeTVPackage(List<string> amsIDList, List<string> installationIds, List<String> installationLbnr, List<String> kundeIdList, List<String> datesList){
        // Added for Sorting on ChangeTvPackagePage
        List<string> newamsIDList = new List<string>();
        List<String> newinstallationLbnr = new List<String>();
        List<String> newkundeIdList = new List<String>();
        List<String> newdatesList = new List<String>();
        List<String> newinstallationIds = new List<String>();
        
        List<Net_Installations__c> addresses =
            [select s.Name,s.Location__c,s.INSTALLATION_ID__c,s.Address__r.External_Id__c, s.Address__r.Name, s.Address__r.Full_Address__c, s.Id,
             s.Address__r.House_No__c,s.Address__r.Street__c,s.Address__r.Entrance__c,s.Address__r.Door_No__c,s.Address__r.Town__c,
             s.Address__r.Floor__c,s.Address__r.District__c,s.Address__r.PostCode__c,s.Move_Flag__c From Net_Installations__c s where s.id in :installationIds 
             order by s.Address__r.Name, s.Address__r.HouseNumber__c,s.Address__r.Entrance__c,s.Address__r.Floor_No_Dev__c,s.Address__r.Door_Number_Dev__c];
        installationMap = new Map<String, Net_Installations__c>(); 
        system.debug('#addresses#'+addresses);    
        for(Net_Installations__c installation : addresses){
            installationMap.put(installation.Address__r.External_Id__c, installation);
        }
        system.debug('#installationList#'+installationList.size()+'#installationValues#'+installationValues);
        
        /*        if(amsIDList.size() > 0){
netInstallAmsId = [select  inst.Address__r.External_Id__c From Net_Installations__c inst where Address__r.External_Id__c in :amsIDList 
order by inst.Address__r.Name,inst.Address__r.HouseNumber__c,inst.Address__r.Entrance__c,inst.Address__r.Floor_No_Dev__c,inst.Address__r.Door_Number_Dev__c];
}
System.debug('New AmsId'+netInstallAmsId);*/
        //        if(netInstallAmsId.size() > 0){
        if(addresses.size() > 0){
            System.debug('Inside For Loop');
            for(Net_Installations__c tempList : addresses){
                if(amsIdMap.get(tempList.Address__r.External_Id__c) != null){
                    Integer size = amsIDList.size();
                    for(Integer i = 0 ; i<size ; i++){
                        if(tempList.Address__r.External_Id__c == amsIDList[i]){
                            newamsIDList.add(amsIDList[i]);
                            newinstallationIds.add(installationIds[i]);
                            newinstallationLbnr.add(installationLbnr[i]);
                            newkundeIdList.add(kundeIdList[i]);
                            newdatesList.add(datesList[i]);
                        }
                    }
                }
            }
        }       
        
        //amsIDList.sort();
        system.debug('#amsIDList#'+amsIDList+'$$$$$$$newamsIDList'+newamsIDList+'$$$$$$$KundeIds'+newkundeIdList);
        try{
            //xmlResponse = generateRequestAndResponse(amsIDList, installationLbnr, kundeIdList, datesList); 
            xmlResponse = generateRequestAndResponse(newamsIDList, newinstallationIds, newinstallationLbnr, newkundeIdList, newdatesList);
            System.debug('newamsIDList: '+newamsIDList);
            
            System.debug('final xmlResponse: '+xmlResponse);
            
            if(xmlResponse != null && xmlResponse != '' && xmlResponse.trim().length() > 0){
                changedDateFlag = false;
                installationOfferingList = parseXMLResponse(xmlResponse,newinstallationIds);
                System.debug('installationOfferingList'+installationOfferingList);
                xmlResponse = ''; 
                if(installationOfferingList.size() > 0){
                    return true;
                }else{
                    return false;
                } 
            }else{
                System.debug('final xmlResponse: 11111'+xmlResponse);
                return false;
            }
        }catch(Exception e){
            System.debug('Null xml Response'+e.getMessage());
            throw e;
        }
    }
    
    public String generateRequestAndResponse(List<String> amsIDList, List<String> installationIds, List<String> installationLbnr, List<String> kundeIdList, List<String> datesList){
        try{
            String xmlString = '';
            String tempXml = '';
            String header = '<?xml version="1.0" encoding="UTF-8"?>';
            String startingRootElementTag = '<Products>';
            String endingRootElementTag = '</Products>';
            Integer iCount = 0;
            if (amsIDList.size() > 0){
                for(String amsId : amsIDList){
                    if (amsId != null && amsId != ''){
                        xmlString = '<Product>';
                        
                        if(amsId != null){
                            xmlString += '<Address_Id>'+amsId+'</Address_Id>';
                        }else{
                            xmlString += '<Address_Id></Address_Id>';
                        }
                        if(installationLbnr.get(iCount) != null){
                            xmlString += '<Installation_Lbnr>'+installationLbnr.get(iCount)+'</Installation_Lbnr>';
                        }
                        else{
                            xmlString += '<Installation_Lbnr></Installation_Lbnr>';
                        }
                        
                       // code commented for SUPPPORT-6903 to enable cast iron
                        /*
                        if(kundeIdList.get(iCount) != null || kundeIdList.get(iCount) != '1'){
                           xmlString += '<Kunde_id>'+kundeIdList.get(iCount)+'</Kunde_id>';                              
                        }else{
                            xmlString += '<Kunde_id></Kunde_id>';
                        }
                        */
                       
                        xmlString += '<Kunde_id>'+legalAccountNo+'</Kunde_id>';
                        
                        if(datesList.get(0) != null){
                        xmlString += '<Effective_Date>'+datesList.get(0)+'</Effective_Date>';
                        }
                        else{
                            xmlString += '<Effective_Date></Effective_Date>';
                        }
                        xmlString += '</Product>';
                        tempXml = tempXml + xmlString;
                    }
                    iCount = iCount + 1;
                }
            }  
            
            String request = header + startingRootElementTag + tempXml + endingRootElementTag;
            //string testingtempxml ='<Products><Product><Address_Id>2107414</Address_Id><Installation_Lbnr>294649</Installation_Lbnr><Kunde_id></Kunde_id><Effective_Date>01-12-2016</Effective_Date></Product></Products>';
            
            
            //String request = header + testingtempxml;
            system.debug('$request$'+request);
            String response = '';
            if(!FORCE_TEST_MODE){
                try{
                    //response = HttpRequestUtil.makeHttpCall('changeTVPackage?opt=YSSCProductList', request);
                    calloutParameter.add('null');
                    calloutValue.add(request);
                    //calloutValue.add('<?xml version="1.0" encoding="UTF-8"?><Installations><Installation><Address_Id>952945</Address_Id><Installation_Lbnr>241812</Installation_Lbnr></Installation></Installations>');
                   // response= clsConnectionUtils_Admin.callout1('changeTVPackage?opt=YSSCProductList',calloutParameter,calloutvalue);
                    response= clsConnectionUtils_Admin.callout1(INTEGRATION__c.getInstance('YSSCProductList').API__c,calloutParameter,calloutvalue);
                    calloutParameter = new List<String>();
                    calloutvalue = new List<String>();
                }catch(Exception e){
                    System.debug('####Callout Occoured'+e.getMessage());
                    throw e;
                }   
            }else{
                response = '<?xml version="1.0"  encoding="UTF-8"?>'+
                    '<Installation_List>'+
                    '<Installation_Record>'+
                    '<Address_Id>7862229</Address_Id>'+ 
                    '<Installation_Lbnr>1</Installation_Lbnr>'+
                    '<Error>'+
                    '<Error_Code></Error_Code>'+ 
                    '<Error_Message></Error_Message>'+ 
                    '</Error>'+
                    '<Existing_products>'+
                    '<Navn>Fuldpakke</Navn>'+
                    '<Sortering>11-01-0030</Sortering>'+
                    '<Varenr>1101201</Varenr>'+
                    '</Existing_products>'+
                    '<Product_list>'+
                    '<Product_Record>'+
                    '<Product_Name>Grundpakke</Product_Name>'+
                    '<Product_Number>1101001</Product_Number>'+ 
                    '<Href>yahoo.com</Href>'+ 
                    '<Mediatype>tv</Mediatype>'+ 
                    '<sortering>11-01-0011</sortering>'+ 
                    '</Product_Record>'+
                    '<Product_Record>'+
                    '<Product_Name>Fuldpakke</Product_Name>'+ 
                    '<Product_No>1101201</Product_No>'+
                    '<Href>lmn</Href>'+ 
                    '<Mediatype>teliphony</Mediatype>'+ 
                    '<sortering>11-01-0015</sortering>'+ 
                    '</Product_Record>'+
                    '</Product_list>'+
                    '<Nybeboer_product>'+
                    '<Href>http://preprod-kasia.yousee.dk/afsaetning/opdater/-849407049/1119008</Href>'+ 
                    '<Mediatype>vnd.yousee.kasia2.afsaetning+json;version=1;charset=UTF-8</Mediatype>'+ 
                    '</Nybeboer_product>'+
                    '<Nybeboer_product>'+
                    '<Href>http://preprod-kasia.yousee.dk/afsaetning/opdater/-849407049/1112001</Href>'+ 
                    '<Mediatype>vnd.yousee.kasia2.afsaetning+json;version=1;charset=UTF-8</Mediatype>'+ 
                    '</Nybeboer_product>'+
                    '<Kunde_Data>aaaa </Kunde_Data>'+  
                    '<Array_Init />'+ 
                    '<Etag/>'+ 
                    '</Installation_Record>'+
                    '</Installation_List>';
            } 
            if(FORCE_TEST_MODE){
                integer i;
                i = 10/0;
            }
            System.debug('response*****'+response);
            
            //Added for Checking Severity In the Error Log Object 
            //response = null;
            return response;
        }catch(Exception e){
            system.debug('#Inside response catch#');
            //exceptionHandler.handleException(e,'callToCastIron()',false,false,cableUnitNumber,'High');
            return null;
        }
    }
    
    @testvisible private List<cInstallation> parseXMLResponse(String response,List<String> installationIds){
        
        system.debug('Insisde parseXMLResponse+++++++++++++++++++++');
        Integer errorCount = 0;
        if(!changedDateFlag)
            showChangePackageButton = false;
        Dom.Document doc = new Dom.Document();
        system.debug('++++++++++'+response);
        doc.load(response);   
        Dom.XMLNode rootElement = doc.getRootElement(); // Installation_List
        //system.debug('rootElement++++++++'+rootElement);
        System.debug('##List of InstallationsIDs###'+installationIds);
        Map<Id, Subscription__c> subscriptionMap = new Map<Id, Subscription__c>();
        //  List<Subscription__c> sList = [Select s.Net_Installation__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, s.Product__r.Name, s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today()];
        
        
        List<Subscription__c> sList = [Select s.Net_Installation__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, s.Product__r.Name, s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s where s.Net_Installation__c IN : installationIds and s.Start_Date__c <=: date.today() order by s.Start_Date__c];
        
        // Check if needs to add here filter 
        //List<Subscription__c> sList = [Select s.Net_Installation__c, s.Id, s.Name, s.Start_Date__c, s.End_Date__c, s.Product__r.Name, s.Future_Subscription__c, s.Subscription_No__c From Subscription__c s where s.Net_Installation__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNumber and s.Start_Date__c <=: date.today() and s.Net_Installation__r.Start_Date__c <: date.today() and s.Net_Installation__r.Installation_Status_Code__c IN :statusCodeList order by s.Start_Date__c];
        System.debug('@@@@@Size@@@@@@'+sList.size());
        List<cInstallation> productOfferingList = new List<cInstallation>();    
        for(Subscription__c s: sList){
            subscriptionMap.put(s.Net_Installation__c, s);
        }
        //system.debug('****rootElement.getChildElements()***'+rootElement.getChildElements());
        for(dom.XmlNode installationRecord : rootElement.getChildElements()) { //Installation_Record
            cInstallation installationOffering;
            String currentPackage;
            List<String> nybeborList = new List<String>();
            //System.debug('****installationRecord.getName()***'+installationRecord.getName());
            //System.debug('****installationRecord.getChildElements()***'+installationRecord.getChildElements());
            if(installationRecord.getName() == 'Installation_Record'){
                for(dom.XmlNode installationChild : installationRecord.getChildElements()){ //Individual installation
                    System.debug('****installationChild.getName()***'+installationChild.getName());
                    if(installationChild.getName() == 'Address_Id'){ //Address_Id
                        //System.debug('****Inside Address_Id***');
                        Integer sCount = 0;
                        system.debug('installationMap::'+installationMap);
                        system.debug('Trim::'+installationChild.getText().trim());
                        Net_Installations__c installation = installationMap.get(installationChild.getText().trim());
                        system.debug('installation::'+installation);
                        if(installation != null){
                            if(subscriptionMap.containsKey(installation.id)){
                                currentPackage = subscriptionMap.get(installation.id).Product__r.Name;
                                installationOffering = new cInstallation(installation, subscriptionMap.get(installation.id));  
                            }else{
                                installationOffering = new cInstallation(installation, new Subscription__c());
                            }
                        }  
                        if(installationOffering != null){
                            installationOffering.amsId = installationChild.getText().trim();
                        }  
                    }else if(installationChild.getName() == 'Installation_Lbnr'){                   //Installation_Lbnr
                        installationOffering.installationLbnr = installationChild.getText().trim();
                    }else if(installationChild.getName() == 'Error'){                                            //Error
                        System.debug('Error');
                        for(dom.XmlNode errorChild : installationChild.getChildElements()){
                            if(errorChild.getName() == 'Error_Code'){                                            //Error_Code
                                installationOffering.errorCode = errorChild.getText().trim();
                                if(installationOffering.errorCode != null && installationOffering.errorCode != ''){
                                    installationOffering.errorFlag = 'true';
                                    errorCount = errorCount + 1;
                                }else{
                                    installationOffering.errorFlag = 'false';
                                }
                            }else if(errorChild.getName() == 'Error_Message'){                           //Error_Message
                                installationOffering.errorMessage = errorChild.getText().trim();
                            }
                        }
                    }else if(installationChild.getName() == 'Existing_products'){                            //Existing_products
                        for(dom.XmlNode existingChild : installationChild.getChildElements()){
                            if(existingChild.getName() == 'Sortering'){                                        //Sortering
                                installationOffering.existingSortering = existingChild.getText().trim(); 
                            }    
                        }
                    }else if(installationChild.getName() == 'Product_list'){                                //Product_List
                        System.debug('Product_list');
                        List<cInstallation.cProducts> productsList = new List<cInstallation.cProducts>();
                        List<SelectOption> options = new List<SelectOption>();
                        Set<String> optionString = new Set<String>();
                        List<String> sorteringList = new List<String>();
                        options.add(new SelectOption('Uændret pakke','Uændret pakke'));
                        for(dom.XmlNode productListChild : installationChild.getChildElements()){   //Product_Record
                            System.debug('Product_Record');
                            cInstallation.cProducts products;
                            for(dom.XmlNode productRecordChild : productListChild.getChildElements()){                     
                                if(productRecordChild.getName() == 'Product_Name'){                     //Product_Name
                                    if(productRecordChild.getText().trim() != null && productRecordChild.getText().trim() != ''){
                                        products = new cInstallation.cProducts();
                                        products.prodName = productRecordChild.getText().trim();
                                        system.debug('#products.prodName#'+products.prodName);
                                    } 
                                }else if(productRecordChild.getName() == 'Product_Number'){         //Product_Number
                                    if(products != null && productRecordChild.getText().trim() != null && productRecordChild.getText().trim() != ''){
                                        products.productNo = productRecordChild.getText().trim();
                                    }   
                                }else if(productRecordChild.getName() == 'Href'){
                                    if(products != null && productRecordChild.getText().trim() != null && productRecordChild.getText().trim() != ''){
                                        products.href = productRecordChild.getText().trim();
                                    }   
                                }else if(productRecordChild.getName() == 'Mediatype'){
                                    if(products != null && productRecordChild.getText().trim() != null && productRecordChild.getText().trim() != ''){
                                        products.mediaType = productRecordChild.getText().trim();
                                    }   
                                }else if(productRecordChild.getName() == 'sortering'){
                                    if(products != null && productRecordChild.getText().trim() != null && productRecordChild.getText().trim() != ''){
                                        products.sortering = productRecordChild.getText().trim();
                                        sorteringList.add(products.sortering);
                                    }   
                                }
                            }
                            if(products != null && products.prodName != currentPackage){
                                productsList.add(products);
                            }   
                        } 
                        sorteringList.sort();
                        for(String sortering : sorteringList){
                            for(cInstallation.cProducts products : productsList){
                                if((sortering == products.sortering) && (products.prodName != currentPackage ) && (!optionString.contains(products.prodName))){
                                    /* Support-2866 Change
clearProductMap.put(products.sortering, products.prodName); */
                                    if(products.productNo != '1101204' && products.productNo != '1101104' && products.productNo != '1101961' && products.productNo != '1101962'){
                                        options.add(new SelectOption(products.prodName, products.prodName));
                                        optionString.add(products.prodName);
                                        clearProductMap.put(products.sortering, products.prodName);
                                    }
                                    
                                }
                            }
                        }
                        System.debug('options---'+options);
                        if(currentPackage != null && currentPackage.trim().length() > 0){
                            cInstallation.cProducts products = new cInstallation.cProducts();
                            products.prodName = 'Afbestil';
                            products.sortering = '11-01-0100';
                            productsList.add(products);
                            clearProductMap.put(products.sortering, products.prodName);
                            options.add(new SelectOption(products.prodName, products.prodName));
                        }
                        installationOffering.productsList = productsList;
                        installationOffering.optionsPackages = options;
                        system.debug('#installationOffering.optionsPackages#'+installationOffering.optionsPackages);
                    }else if(installationChild.getName() == 'Nybeboer_product'){
                        System.debug('Nybeboer_product');
                        for(dom.XmlNode nybeboerChild : installationChild.getChildElements()){
                            if(nybeboerChild.getName() == 'Href'){
                                System.debug(nybeboerChild.getText().trim());
                                installationOffering.nybeboerHref = nybeboerChild.getText().trim();
                                if(nybeboerChild.getText().trim() != null && nybeboerChild.getText().trim() != ''){
                                    if(installationOffering.nybeboerHref.contains('1119008') || installationOffering.nybeboerHref.contains('1112001')){
                                        nybeborList.add(nybeboerChild.getText().trim());
                                    }
                                }
                            }else if(nybeboerChild.getName() == 'Mediatype'){
                                installationOffering.nybeboerMediaType = nybeboerChild.getText().trim();
                                if(nybeboerChild.getText().trim() != null && nybeboerChild.getText().trim() != ''){
                                    nybeborList.add(nybeboerChild.getText().trim());
                                }   
                            }
                        }
                        if(nybeborList.size() > 2){
                            installationOffering.nybeboerFlag = true;
                            //if(!changedDateFlag)
                            //    validateNewResident = true;                          
                        }else{
                            installationOffering.nybeboerFlag = false;
                        }
                    }
                    installationOffering.tvpackage = currentPackage;
                }
            }
            
            if(nybeborList.size() > 0){
                installationOffering.nybeborList = nybeborList;                 
            }
            productOfferingList.add(installationOffering);
        }
        if(productOfferingList.size() == errorCount && !changedDateFlag){
            showChangePackageButton = true;
        }
        System.debug('final productOfferingList----'+productOfferingList);
        checkValidateNewResident();
        return productOfferingList;
    }
    
    public List<String> getPackageDate(){
        List<String> ReleaseDate = new List<String>();
        date mydate = date.today();
        Date currentMnth;
        date nextmnthDate;
        string strFormat='dd-MM-yyyy';
        Integer numberDays = date.daysInMonth(mydate.year(), mydate.month());
        date startDate = date.newInstance(mydate.year(),mydate.month(),mydate.day());
        date dueDate = date.newInstance(mydate.year(),mydate.month(),numberDays);
        Integer numberDaysDue = startDate.daysBetween(dueDate);
        Integer totalDays = numberDaysDue;
        System.debug('totalDays: '+totalDays);
        List<String> yearList = new List<String>{'January','Feburary','March','April','May','June','July','August','September','October','November','December'};
            List<Holiday> holidayList = [Select h.Id, h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h where h.ActivityDate >: date.today() and h.ActivityDate <=: dueDate and h.IsRecurrence = false order by h.Id];
        List<Holiday> holidayListTrue = [Select h.Id, h.RecurrenceDayOfMonth, h.Name, h.ActivityDate,h.IsRecurrence,h.RecurrenceMonthOfYear From Holiday h where h.RecurrenceMonthOfYear =:yearList.get(myDate.month()-1) and h.RecurrenceDayOfMonth >: myDate.Day() and h.RecurrenceDayOfMonth <=: numberDays and h.IsRecurrence = true order by h.Id];
        List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};
            for(Holiday holiday : holidayList){
                if(mydate.month() == holiday.ActivityDate.month()){
                    totalDays = totalDays - 1;
                }
            }
        System.debug('totalDays 1: '+totalDays);
        for(Integer i = 1; i <= numberDaysDue; i++){
            Date nextDate = date.today().addDays(i);
            Integer remainder = Math.mod(date.newInstance(0001, 1, 1).daysBetween(nextDate) , 7);  
            String dayValue = listDay.get(remainder);
            System.debug('dayValue: '+dayValue);
            boolean flag = false;
            for(Holiday holiday : holidayList){
                if(holiday.ActivityDate == nextDate){
                    flag = true;
                }                
            }
            if(holidayListTrue.size() > 0){
                for(Holiday holiday1 : holidayListTrue){
                    if(nextDate.day() == holiday1.RecurrenceDayOfMonth && (dayValue != 'Saturday' || dayValue != 'Sunday')){
                        totalDays = totalDays - 1;  
                    }
                }
            } 
            if(!flag && (dayValue == 'Saturday' || dayValue == 'Sunday')){
                totalDays = totalDays -1;
            }
        }
        System.debug('totalDays 2: '+totalDays);
        if(totalDays >= 10){
            //Add from current mnth.
            for(Integer countYear=1;countYear<= 12;countYear++){
                currentMnth=mydate.addMonths(countYear).toStartOfMonth();
                Datetime dt = datetime.newInstance(currentMnth.year(), currentMnth.month(),currentMnth.day());
                ReleaseDate.add(dt.format(strFormat));
            }
        }else{
            //Add from next mnth
            for(Integer countYear=1;countYear<= 12;countYear++){
                currentMnth=mydate.addMonths(countYear+1).toStartOfMonth();
                Datetime dt = datetime.newInstance(currentMnth.year(), currentMnth.month(),currentMnth.day());
                ReleaseDate.add(dt.format(strFormat));
            }
        }
        System.debug('ReleaseDate: '+ReleaseDate);
        return ReleaseDate; 
    }
    
    public List<SelectOption> getItemsDropDown(){
        List<SelectOption> optionsItems = new List<SelectOption>();
        for(Integer i=0;i<12;i++){ 
            optionsItems.add(new SelectOption(String.valueof(ReleaseDate[i]),String.valueof(ReleaseDate[i])));
        }
        System.debug('optionsItems size: '+optionsItems.size());
        return optionsItems;
    }
    
    public List<SelectOption> getPackageItems(){
        List<SelectOption> options = new List<SelectOption>();
        try {
            options.add(new SelectOption('Uændret pakke','Uændret pakke'));
            if(clearProductMap != null && clearProductMap.size() > 0){
                Set <String> keySet = new Set<String>();
                List<String> keyList = new List<String>();
                keySet = clearProductMap.keySet();
                for(String key : keySet){
                    keyList.add(key);
                }
                keyList.sort();
                for(String key : keyList) {
                    options.add(new SelectOption(clearProductMap.get(key), clearProductMap.get(key)));
                }
            }
            if(FORCE_TEST_MODE == true){
                integer i;
                i = 10/0;
            }
            return options;
        } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            return null;
        }          
    }
    
    public List<String> getSelectListALL(){
        List<String> liststr = new List<String>();
        liststr.add('1');
        return liststr;
    }
    
    public void displaySelectedValue(){
        System.debug('selected paclage finally-----------aaaaaaaaaa-------------->' + selectedPackage);
        Boolean flag = false;
        for(cInstallation installation : installationOfferingList){
            flag = false;
            for(cInstallation.cProducts products : installation.productsList){
                System.debug('selected paclage finally-----------products.prodName-------------->' + products.prodName);
                if(products.prodName == selectedPackage || selectedPackage == 'Afbestil'){
                    flag = true;
                }
            }
            if(!flag){
                installation.tvpackage = 'Uændret pakke';      
            }else{
                installation.tvpackage = selectedPackage;
            }
        }
    }
    
    public PageReference displaySelectedDate(){
        List<string> amsIDList = new List<string>();
        List<String> installationLbnr = new List<String>();
        List<String> kundeIdList = new List<String>();
        List<String> datesList = new List<String>();
        List<String> installationIds = new List<String>();
        for(cInstallation installation : installationOfferingList){
            amsIDList.add(installation.installation.Address__r.External_Id__c);
            installationIds.add(installation.installation.Id);
            installationLbnr.add(installation.installation.INSTALLATION_ID__c);
            if(installation.subscription.Start_Date__c != null){
                kundeIdList.add('1');
            }else{
                System.debug('displaySelectedDate legalAccountNo-----'+legalAccountNo);
                kundeIdList.add(legalAccountNo);
            }
            datesList.add(selectedPackageDate);
        }
        xmlResponse = generateRequestAndResponse(amsIDList, installationIds, installationLbnr, kundeIdList, datesList); 
        System.debug('xmlResponse: '+xmlResponse);
        
        if(xmlResponse != null && xmlResponse != '' && xmlResponse.trim().length() > 0){ 
            changedDateFlag = true;
            List<cInstallation> newOfferingList = parseXMLResponse(xmlResponse,installationIds);
            List<cInstallation> oldOfferingList = installationOfferingList;
            installationOfferingList = new List<cInstallation>();
            Integer i = 0;
            for(cInstallation newInstallation : newOfferingList){
                newInstallation.packageChangedDate = selectedPackageDate;
                if(oldOfferingList.get(i).selectedmyBeboer != null){
                    newInstallation.selectedmyBeboer = oldOfferingList.get(i).selectedmyBeboer;                 
                }
                installationOfferingList.add(newInstallation);
                i = i + 1;
            }             
        }else{
            //return false;
        }
        return null;
    }
    
    public PageReference backToViewInstallation(){
        System.debug('$backToViewInstallation1$');
        // Change to absolute path
        //String newPageUrl = '/apex/ViewAddressesForInstallationsPage';
        //PageReference newPage = new PageReference(newPageUrl);
        PageReference newPage = Page.ViewAddressesForInstallationsPage2411;
        System.debug('#installationList#'+installationList);
        if(installationList != null && installationList.size() > 0){
            for(Integer chkBoxCount1 = 0; chkBoxCount1 < installationList.size() ; chkBoxCount1++){
                if(finalSelectedListInstallationMap.get(installationList[chkBoxCount1].installation.id) != null ){
                    if(installationList[chkBoxCount1].selected){
                        installationList[chkBoxCount1].selected = false;
                    }
                }
            }
        }
        finalSelectedListInstallationMap.clear(); 
        newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
        return newPage;
    }
    
    public PageReference backToViewAddressInstallationPage(){
        //Change to absolute path
        //String newPageUrl = '/apex/ViewAddressesForInstallationsPage';
        //PageReference newPage = new PageReference(newPageUrl);
        PageReference newPage = Page.ViewAddressesForInstallationsPage2411;
        if(installationList.size() > 0){
            for(Integer chkBoxCount = 0; chkBoxCount < installationList.size() ; chkBoxCount++){
                if(finalSelectedListInstallationMap.get(installationList[chkBoxCount].installation.id) != null ){
                    if(installationList[chkBoxCount].selected){
                        installationList[chkBoxCount].selected = false;
                    }
                }
            }
        }
        finalSelectedListInstallationMap.clear(); 
        newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
        System.debug('backToViewInstallation finalSelectedListInstallationMap--'+finalSelectedListInstallationMap);
        System.debug('backToViewInstallation finalSelectedListInstallationMap size--'+finalSelectedListInstallationMap.size());
        return newPage;
    } 
    
    public PageReference backToViewPage(){
        searchHsNoText ='';
        PageReference newPage = Page.ViewAddressesForInstallationsPage2411;
        newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
        //PageReference newPage = new PageReference('/apex/ViewAddressesForInstallationsPage?cableunitnumber='+cableUnitNumber);
        system.debug('##cableUnitNumber:'+cableUnitNumber);
        system.debug('##PageReference:'+newPage);
        SogAddressFlag = false;
        errorFlag=false;
        fetchAddresses();
        initializePaging();
        getInstallationList(); 
        return newPage;
    }
    
    public PageReference confirmTvPackage(){
        try {
            boolean flag = true;
            Integer icount = 0;
            setConfirmedInstallations();
            if(confirmedInstallations.Size() > 0){
                for(Integer selectedValue=0; selectedValue < confirmedInstallations.Size(); selectedValue ++){
                    if(confirmedInstallations[selectedValue].tvpackage == 'Uændret pakke'){
                        icount = icount + 1;
                    }
                }
                if(icount == (confirmedInstallations.Size())){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Der er ikke valgt nogen ændringer');
                    ApexPages.addMessage(errorMsg);
                    return null;
                }
                finalInstallations = new List<cInstallation>();
                for(cInstallation installation : confirmedInstallations){
                    /*if(installation.getCurrentProductName() == 'Mellempakke (BS)' || installation.getCurrentProductName() == 'Fuldpakke (BS)'){
installation.checkBlandSelv = true;
}*/
                    if(installation.tvpackage != 'Uændret pakke'){
                        finalInstallations.add(installation);                       
                    }
                }
            }
            System.debug('##finalInstallations##'+finalInstallations);
            //Change to absolute path
            //String pageURL = '/apex/ConfirmTvPackagesPage';
            //PageReference pageReference = new PageReference(pageURL);
            
            // PageReference pageReference = Page.ConfirmTvPackagesPage;
            // commented above for spoc 2411
            PageReference pageReference = Page.ConfirmTvPackagesPage_spoc2411;
            
            if(FORCE_TEST_MODE == true){
                integer i;
                i = 10/0;    
            }
            return pageReference;
        } catch (exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }
    
    public void setConfirmedInstallations(){
        if(installationOfferingList != null){
            confirmedInstallations = new List<cInstallation>();
            for(cInstallation installationChecked: installationOfferingList){
                if(FORCE_TEST_MODE){
                    installationChecked.tvPackage = 'Grundpakke';
                    installationChecked.selectedmyBeboer = true;
                } 
                if(installationChecked.selectedmyBeboer != null && installationChecked.selectedmyBeboer){
                    installationChecked.myBebeorTxt = 'Nyindflyttet, gratis ændringsgebyr';
                }else{
                    installationChecked.myBebeorTxt = '';
                } 
                if(installationChecked.errorFlag != 'true'){  
                    confirmedInstallations.add(installationChecked);
                } 
            }
        }
    }
    
    public List<cInstallation> getConfirmedInstallations(){
        System.debug('confirmedInstallations size: '+confirmedInstallations.size());
        if(confirmedInstallations.size() > 1){
            setShowChangeALL('display:block'); 
        }else{
            setShowChangeALL('display:none');
        }
        return confirmedInstallations;
    }
    
    public PageReference backToChangeTvPackagesPage(){
        //Change to absolute path
        //String pageURL = '/apex/ChangeTvPackagesPage';
        //PageReference pageReference = new PageReference(pageURL);
        
        //PageReference pageReference = Page.ChangeTvPackagesPage;
        // COMMENTED ABOVE FOR SPOC 2411
        PageReference pageReference = Page.ChangeTvPackagesPage_spoc2411;
        return pageReference;
    } 
    
    /*
* following function is use to show details after placing DSL order,
* In case of package cancellation following functionality send mail to yss team.
*/
    public PageReference placeOrderForPackageChange() {
        //try {
        cancelPackageFlag = false;
        changePackageFlag = false;
        regenerateGroupId = false;
        dslOrderList = new List<Order__c>();
        chkGroupIdList = new List<Order__c>();
        System.debug('------------------ Inside confirmedTvPackage() ----------------------->');
        String sortering = '', existingSortering = '';
        //String ExistingNull = 'Null Existing Sortering';
        String loggedInUsersName = UserInfo.getUserName();
        Integer c = 1;
        String OrderGrpId = '',systemDate ='';
        String year, month, day,parseDate;
        if(finalInstallations != null){
            systemDate = String.valueOf(date.today());
            if(systemDate.length() >= 10){
                year = systemDate.substring(0, 4);
                month = systemDate.substring(5, 7);
                day = systemDate.substring(8, 10);
                parseDate = day+'-'+month+'-'+year;
                //    parseDate = date.today().Day() + '-' + date.today().Month() + '-' + date.today().Year();
                regenerateGroupId = false;
                loopCount = 1;
                OrderGrpId = parseDate + '-' + ServiceCenterTestUtil.getRandomNumber(11111,100000);
                while(!regenerateGroupId && loopCount != 5){
                    if(OrderGrpId != null){
                        chkGroupIdList = [select name from Order__c where OrderGroupId__c =: OrderGrpId limit 1];
                    }
                    if(chkGroupIdList.size() == 0){
                        regenerateGroupId = true;
                    }else{
                        OrderGrpId = parseDate + '-' + ServiceCenterTestUtil.getRandomNumber(11111,100000);
                        loopCount++;
                    }
                }
                System.debug('Group Id*****'+OrderGrpId);
            }
            
            for(cInstallation subscription : finalInstallations) {
                Order__c dslOrder = new Order__c();
                System.debug('$$$$$$$$$$$$$$$44$Formatted Address$'+subscription.getFormattedAddress());
                for(cInstallation.cProducts products : subscription.productsList){
                    if(products.prodName == subscription.tvpackage){
                        dslOrder.URL__c = products.href;
                        dslOrder.Product_No__c = products.productNo;
                        dslOrder.Product_Name__c = products.prodName;
                        dslOrder.Media_Type__c = products.mediaType;
                        dslOrder.Kundedata__c = '';
                        sortering = products.sortering;
                        System.debug('#Sortering#'+sortering);
                    }
                }
                dslOrder.Address_Id__c = subscription.amsid;
                dslOrder.Installation_No__c = subscription.installation.INSTALLATION_ID__c;
                dslOrder.Net_Installation__c = subscription.installation.Id;
                dslOrder.Location__c = subscription.installation.Location__c;
                System.debug('####dslOrder.Net_Installation__c###'+dslOrder.Net_Installation__c+'#####Order Location'+dslOrder.Location__c);
                
                if(OrderGrpId != null){
                    dslOrder.OrderGroupId__c = OrderGrpId;
                }
                if (subscription.packageChangedDate != null) {
                    dslOrder.ChangePackageDate__c = subscription.packageChangedDate;
                }
                
                if (loggedInUsersName != null && loggedInUsersName != '') {
                    dslOrder.loggedInUserName__c = loggedInUsersName;
                }
                if (subscription.getCurrentProductName() !=null && subscription.getCurrentProductName() !=''){
                    dslOrder.packageBeforeChange__c = subscription.getCurrentProductName();
                }
                
                if(dslOrder.Product_Name__c == 'Afbestil'){
                    dslOrder.Order_Type__c = 'Cancellation';
                    dslOrder.Kasia_Order_Status__c = 'Error';
                    cancelPackageFlag = true;
                }else{
                    if(subscription.getCurrentProductName() != null && subscription.getCurrentProductName() != ''){
                        System.debug('#sortering#'+sortering);
                        if((sortering != null || sortering != '') && sortering.lastIndexOf('-') != -1){
                            //sortering = sortering.substring(sortering.lastIndexOf('-'), sortering.length());
                            //comented above and uncommented below for support-6903
                            sortering = sortering.substring(sortering.lastIndexOf('-') + 1, sortering.length());
                        }else{
                            sortering = sortering.substring(0, sortering.length());
                        }
                        Integer numericSortering = integer.valueof(sortering);
                        System.debug('#numericSortering#'+numericSortering);
                        existingSortering = subscription.existingSortering;
                        
                        System.debug('#existingSortering#'+existingSortering);
                        
                        /* Changes made for order type fields
if(existingSortering == null || existingSortering == ''){   
//throw new Custom_Exception(ExistingNull + 'AMS ID :' +dslOrder.Address_Id__c + 'Installation No : '+ dslOrder.Installation_No__c + ' Net Installation : '+ dslOrder.Net_Installation__c + 'cInstallations: '+ subscription,true);
exceptionHandler.logErrorMessage('From : ViewAddressesForInstallationsController Method: placeOrderForPackageChange() Module Name : Change Tv-Package ErrorMessage:'+ExistingNull + 'AMS ID :' +dslOrder.Address_Id__c + 'Installation No : '+ dslOrder.Installation_No__c + ' Net Installation : '+ dslOrder.Net_Installation__c + 'cInstallations: '+ subscription,false,'High');
}else if (existingSortering != null && existingSortering != ''){
System.debug('ExistSort'+existingSortering);
existingSortering = existingSortering.substring(existingSortering.lastIndexOf('-'), existingSortering.length());
//existingSortering = existingSortering.substring(existingSortering.lastIndexOf('-') + 1, existingSortering.length());
System.debug('$Updated Sortering$'+existingSortering);
Integer numericEXSortering = integer.valueof(existingSortering);
System.debug('#numericEXSortering#'+numericEXSortering+'#numericSortering#'+numericSortering);
if(numericEXSortering > numericSortering){
dslOrder.Order_Type__c = 'Upgrade';
System.debug('$Product Names$'+dslOrder.Product_Name__c+'$dslOrder.Order_Type__c$'+dslOrder.Order_Type__c+'#numericEXSortering$$#'+numericEXSortering+'###numericSortering$$'+numericSortering);
}else if(numericEXSortering < numericSortering && numericEXSortering != null){
dslOrder.Order_Type__c = 'Downgrade';
System.debug('$Product Names###$'+dslOrder.Product_Name__c+'$Inside else dslOrder.Order_Type__c%%$'+dslOrder.Order_Type__c+'$$#numericEXSortering$$#'+numericEXSortering+'###$$numericSortering$$'+numericSortering);
}else{
exceptionHandler.logErrorMessage('From : ViewAddressesForInstallationsController Method: placeOrderForPackageChange() Module Name : Change Tv-Package ErrorMessage:'+ 'Existing Sortering: ' + numericEXSortering + 'and Current Product Sortering: ' + numericSortering + 'both are same' + 'AMS ID :' +dslOrder.Address_Id__c + 'Installation No : '+ dslOrder.Installation_No__c + ' Net Installation : '+ dslOrder.Net_Installation__c + 'cInstallations: '+ subscription,false,'High');
}
}*/
                        
                        
                        if(existingSortering != null && existingSortering != ''){
                            
                            System.debug('pkp inside $Product Names$'+dslOrder.Product_Name__c);
						if(dslOrder.Product_Name__c != 'Digitalt Filter - Registreret'){
                            System.debug('ExistSort'+existingSortering);
                           /* // was getting  index error for cast iron  support-6903 so added if condition
                            if(existingSortering.contains('-')){
                            existingSortering = existingSortering.substring(existingSortering.lastIndexOf('-'), existingSortering.length());
                                }
                          */
                            existingSortering = existingSortering.substring(existingSortering.lastIndexOf('-') + 1, existingSortering.length());
                            System.debug('$Updated Sortering$'+existingSortering);
                            Integer numericEXSortering = integer.valueof(existingSortering);
                            System.debug('#numericEXSortering#'+numericEXSortering+'#numericSortering#'+numericSortering);
                            if(numericEXSortering > numericSortering){
                                //dslOrder.Order_Type__c = 'Upgrade'; // commented for support - 6903
                                dslOrder.Order_Type__c = 'Downgrade';                                
                                System.debug('pkp 1$Product Names$'+dslOrder.Product_Name__c+'$dslOrder.Order_Type__c$'+dslOrder.Order_Type__c+'#numericEXSortering$$#'+numericEXSortering+'###numericSortering$$'+numericSortering);
                            }else if(numericEXSortering < numericSortering && numericEXSortering != null){
                                //dslOrder.Order_Type__c = 'Downgrade'; // commented for support - 6903
                                dslOrder.Order_Type__c = 'Upgrade';
                                System.debug('pkp2 $Product Names###$'+dslOrder.Product_Name__c+'$Inside else dslOrder.Order_Type__c%%$'+dslOrder.Order_Type__c+'$$#numericEXSortering$$#'+numericEXSortering+'###$$numericSortering$$'+numericSortering);
                            }
                            /*else if(numericEXSortering == numericSortering && subscription.checkBlandSelv == true){
System.debug('$Inside blandslev$'+subscription.checkBlandSelv);
/* Not passing Order type
dslOrder.Order_Type__c = 'Bland Selv';*/                                  
                            //}
                            System.debug('pkp3 $Product Names###$'+dslOrder.Product_Name__c+'$Inside else dslOrder.Order_Type__c%%$'+dslOrder.Order_Type__c+'$$#numericEXSortering$$#'+numericEXSortering+'###$$numericSortering$$'+numericSortering);
                            } 
                            
                             else{
							   dslOrder.Order_Type__c = 'Downgrade';							
							}
                        } 
                        
                    }else{
                        dslOrder.Order_Type__c = 'New';
                        System.debug('pkp dslOrder.Order_Type__c'+dslOrder.Order_Type__c);
                    }
                    dslOrder.Kasia_Order_Status__c = 'NEW';
                    changePackageFlag = true;
                }
                
                if(dslOrder.Order_Type__c == 'Downgrade'){
                    boolean flag = false;
                    if(validateNewResident){
                        system.debug('#subscription.nybeborList#'+subscription.nybeborList);
                        for(String nybeborProperty : subscription.nybeborList){
                            if(nybeborProperty.contains('1119008') && subscription.selectedmyBeboer){
                                dslOrder.selectedmyBeboer__c = true;
                                dslOrder.Nybeboer_URL__c = nybeborProperty;
                                dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
                                dslOrder.nybeboreAvailable__c = 'Omk. gratis';
                                flag = true;
                                break;
                            }else if(nybeborProperty.contains('1112001') && !subscription.selectedmyBeboer){
                                dslOrder.selectedmyBeboer__c = false;
                                dslOrder.Nybeboer_URL__c = nybeborProperty;
                                dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
                                dslOrder.nyBeboreNotAvailable__c ='Omk. 295';
                                flag = true;
                                break;
                            }
                        }
                        if (!flag){
                            dslOrder.Kasia_Order_Status__c = 'Error';
                            dslOrder.Order_Type__c = 'Error';
                        }
                    }else{
                        //TODO : after michels comments
                        for(String nybeborProperty : subscription.nybeborList){
                            if(nybeborProperty.contains('1112001')){
                                dslOrder.selectedmyBeboer__c = false;
                                dslOrder.Nybeboer_URL__c = nybeborProperty;
                                dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
                                dslOrder.nyBeboreNotAvailable__c ='Omk. 295';
                                flag = true;
                                break;
                            }
                        }
                    }    
                }
                
                /*if(subscription.nybeborList != null && subscription.nybeborList.size() >= 2 && subscription.selectedmyBeboer != null && validateNewResident){
if (subscription.selectedmyBeboer){
dslOrder.selectedmyBeboer__c = true;
system.debug('#dslOrder.selectedmyBeboer__c#'+dslOrder.selectedmyBeboer__c);
boolean flag = false;
for(String nybeborProperty : subscription.nybeborList){
System.debug('nybeborProperty: '+nybeborProperty);
if(nybeborProperty.contains('1119008')){
dslOrder.Nybeboer_URL__c = nybeborProperty;
dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
flag = true;
break;
}
}
if (flag){
dslOrder.nybeboreAvailable__c = 'Omk. gratis';
}else{
dslOrder.nybeboreAvailable__c = '';
}  
} else {
dslOrder.selectedmyBeboer__c = false;
system.debug('#dslOrder.selectedmyBeboer__c #####'+dslOrder.selectedmyBeboer__c);
boolean flag = false;
for(String nybeborProperty : subscription.nybeborList){
System.debug('@@nybeborProperty: '+nybeborProperty);
if(nybeborProperty.contains('1112001')){
dslOrder.Nybeboer_URL__c = nybeborProperty;
dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
flag = true;
break;
}
}
if (flag){
dslOrder.nyBeboreNotAvailable__c ='Omk. 295';
}else{
dslOrder.nyBeboreNotAvailable__c ='';
} 
// Added for checking selected Beober field
//dslOrder.selectedmyBeboer__c = false;
}
}else if(!validateNewResident && subscription.nybeborList != null && subscription.nybeborList.size() >= 2){
boolean flag = false;
for(String nybeborProperty : subscription.nybeborList){
if(nybeborProperty.contains('1112001')){
dslOrder.Nybeboer_URL__c = nybeborProperty;
dslorder.Nybeboer_MediaType__c = subscription.nybeboerMediaType;
flag = true;
break;
}
}
if (flag){
dslOrder.nyBeboreNotAvailable__c ='Omk. 295';
}else{
dslOrder.nyBeboreNotAvailable__c ='';
}
dslOrder.selectedmyBeboer__c = false;
}*/
                dslOrder.cableUnitName__c = cableUnitName;
                dslOrder.cableUnitNumber__c = cableUnitNumber;
                dslOrder.SalesChannel__c = 'SC';
                System.debug('#dslOrder.Order_Type__c#@@@'+dslOrder.Order_Type__c);
                if(dslOrder.Order_Type__c == 'Downgrade'){
                    ordertypeFlag = true;
                    System.debug('#ordertypeFlag$$$$#'+ordertypeFlag);
                    
                }/*else if(dslOrder.Order_Type__c == 'Upgrade'){
mixedFlag = true;
System.debug('#mixedFlag $$$$#'+mixedFlag);
}*/      
                if(validateNewResident){
                    system.debug('#validateNewResident#'+validateNewResident);
                    dslOrder.validateNewResident__c = 'true';
                }else{
                    system.debug('#validateNewResident###'+validateNewResident);
                    dslOrder.validateNewResident__c = 'false';
                } 
                system.debug('$$dslOrder.selectedmyBeboer__c$$'+dslOrder.selectedmyBeboer__c);
                if(dslOrder != null){
                    dslOrderList.add(dslOrder);
                    
                }
                c=c+1;
            }
        } 
        try{
            if (dslOrderList.size() > 0 && dslOrderList != null){
                System.debug('@dslOrderList@'+dslOrderList);
                insert dslOrderList;
            }
        }catch(Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }
        /*}catch (Exception e){
ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
ApexPages.addMessage(errorMsg);
return null;
} */
        checkFlag = validateNewResident;
        system.debug('#$checkFlag$#'+checkFlag);
        confirmedInstallationsForMail = finalInstallations;
        dslOrderListForMail = dslOrderList; 
        //system.debug('#$dslOrderListForMail Selected Beober$#'+dslOrderListForMail[0].selectedmyBeboer__c+'#Order Type Flag#'+ordertypeFlag);
        cableUnitNumber1 = cableUnitNumber;
        cableUnitName1 = cableUnitName; 
        String[] toBccAddresses;       
        String[] toCCAddresses; 
        User loggedInUser = [Select email, firstname, lastname, street from user where Id =: userInfo.getUserId() LIMIT 1];
        
        String loggedInUserEmailID = loggedInUser.Email;
        firstName = loggedInUser.firstName;
        lastName = loggedInUser.lastName;
        List<String> toAddresses = new List<String>();
        if(loggedInUser != null){
            //toAddresses = new String []{loggedInUser.email,'pba@yousee.dk','poonam.thergaonkar@capgemini.com','amrish.surve@capgemini.com'};
            toAddresses = new String[] {'amsur@yousee.dk','poonam.thergaonkar@capgemini.com','gona@yousee.dk','savra@yousee.dk'};
                } 
        System.debug('$To Addresses List$'+toAddresses);
        
        // Changes for checking whether the not to send email to loggedInUser 
        //Contact tempContact = [Select Id, email, firstname from Contact where email = 'sameh@yousee.dk' limit 1];
        //User tempUser = [Select Id, email, firstname, lastname from user where Email = 'sameh@yousee.dk' LIMIT 1];
        //User tempUser = [Select Id, email, firstname, lastname from user where Email = 'tiols@yousee.dk' AND Name = 'Tina Olsen' LIMIT 1];
        //User tempUser = [Select Id, email, firstname, lastname from user where Email = 'evast@yousee.dk' AND Name = 'Eva Stokholm' LIMIT 1];
        
        /*For bcc Addresses to be implemented in production
List<String> bccAddresses = new List<String>();
bccAddresses.add('supportkiss@yousee.dk');*/
        //ServiceCenter_CustomSettings__c sc = ServiceCenter_CustomSettings__c.getValues('Bcc_Email');
        //ServiceCenter_CustomSettings__c sc1 = ServiceCenter_CustomSettings__c.getValues('Production_Bcc_Email');
        //String value,value1;
        //ServiceCenter_CustomSettings__c productionDomain = ServiceCenter_CustomSettings__c.getValues('Production_Email_Setting');
        //ServiceCenter_CustomSettings__c testDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
        //ServiceCenter_CustomSettings__c scToAddresses = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');
        retURL = ApexPages.currentPage().getHeaders().get('Host');
        
        // Currently working with proper bcc email settings
        if(retURL == testDomain.Value__c){
            if(sc != null && sc.Value__c != null){
                value = sc.Value__c;
                toBccAddresses = value.split(';');
            }
        }else{
            if(sc1 != null && sc1.Value__c != null){
                value = sc1.Value__c;
                toBccAddresses = value.split(';');
            }
        }
        
        
        OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
        List<EmailTemplate> templateList = null;
        system.debug('validateNewResident'+validateNewResident+'#changePackageFlag#'+changePackageFlag+'cancelPackageFlag$$'+cancelPackageFlag);
        
        /*
if(changePackageFlag){  
Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
mail.setToAddresses(toAddresses);

// Done For Cross checking 
/*if(retURL != productionDomain.Value__c){
if(sc1 != null && sc1.Value__c != null){
value = sc1.Value__c;
toBccAddresses = value.split(';');
}
}else{
if(sc != null && sc.Value__c != null){
value = sc.Value__c;
toBccAddresses = value.split(';');
}
}*/
        
        /* Before Change the code for BCC Email
if(sc != null && sc.Value__c != null){
value = sc.Value__c;
toBccAddresses = value.split(';');
}*/
        /*
system.debug('#toBccAddresses#'+toBccAddresses);
mail.setBccAddresses(toBccAddresses);
mail.setOrgWideEmailAddressId(owa.id);
mail.setTargetObjectId(loggedInUser.Id);
mail.setSaveAsActivity(false);
templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'TvPackageChange'];
mail.setTemplateId(templateList.get(0).id);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
}
if(cancelPackageFlag){
Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
mail1.setToAddresses(toAddresses);
system.debug('#BCC Addresses #'+toBccAddresses);
mail1.setBccAddresses(toBccAddresses);
mail1.setOrgWideEmailAddressId(owa.id);
mail1.setTargetObjectId(loggedInUser.Id);
mail1.setSaveAsActivity(false);
templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'TvPackageCancel'];
mail1.setTemplateId(templateList.get(0).id);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail1});
}*/
        
        system.debug('##validateNewResident@@'+validateNewResident+'#$changePackageFlag$#'+changePackageFlag+'##cancelPackageFlag$$'+cancelPackageFlag+'checkFlag'+checkFlag+'#OrdertypeFlag#'+ordertypeFlag); 
        if(changePackageFlag && cancelPackageFlag){
            system.debug('@validateNewResident@'+validateNewResident+'checkFlag'+checkFlag);
            Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
            // Commented for making domain generic
            //mail2.setToAddresses(toAddresses);
            //   if(retURL == testDomain.Value__c){
            if(ccTestDomain != null && ccTestDomain.Value__c != null){
                value1 = ccTestDomain.Value__c;
                toCCAddresses = value1.split(';');
                //  mail2.setToAddresses(toCCAddresses);
                mail2.setCcAddresses(toCCAddresses);
                // System.debug('#toCCAddresses#'+toCCAddresses);
            }
            //  }
            system.debug('#toBccAddresses#'+toBccAddresses);
            mail2.setBccAddresses(toBccAddresses);
            mail2.setOrgWideEmailAddressId(owa.id);
            mail2.setTargetObjectId(loggedInUser.Id);
            mail2.setSaveAsActivity(false);
            templateList =  [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'MixedPackageFunction'];
            mail2.setTemplateId(templateList.get(0).id);
            if(!FORCE_TEST_MODE){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail2});
            }
        }else if(changePackageFlag && !cancelPackageFlag){
            system.debug('@@validateNewResident@@'+validateNewResident+'@checkFlag@'+checkFlag);
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            //mail.setToAddresses(toAddresses);
            //  if(retURL == testDomain.Value__c){
            if(ccTestDomain != null && ccTestDomain.Value__c != null){
                value1 = ccTestDomain.Value__c;
                toCCAddresses = value1.split(';');
                //  mail.setToAddresses(toCCAddresses);
                mail.setCcAddresses(toCCAddresses);
                //System.debug('#toCCAddresses#'+toCCAddresses);
            }
            //   }
            system.debug('#toBccAddresses#'+toBccAddresses);
            mail.setBccAddresses(toBccAddresses);
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setTargetObjectId(loggedInUser.Id);
            mail.setSaveAsActivity(false);
            templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'TvPackageChange'];
            mail.setTemplateId(templateList.get(0).id);
            if(!FORCE_TEST_MODE){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            }
        }else if(!changePackageFlag && cancelPackageFlag){
            system.debug('@@@validateNewResident@@@'+validateNewResident);
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            //  if(retURL == testDomain.Value__c){
            if(ccTestDomain != null && ccTestDomain.Value__c != null){
                value1 = ccTestDomain.Value__c;
                toCCAddresses = value1.split(';');
                //  mail1.setToAddresses(toCCAddresses);
                mail1.setCcAddresses(toCCAddresses);
                // System.debug('#toCCAddresses#'+toCCAddresses);
            }
            //  }
            //            mail1.setToAddresses(toAddresses);
            system.debug('#BCC Addresses #'+toBccAddresses);
            mail1.setBccAddresses(toBccAddresses);
            mail1.setOrgWideEmailAddressId(owa.id);
            mail1.setTargetObjectId(loggedInUser.Id);
            mail1.setSaveAsActivity(false);
            templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'TvPackageCancel'];
            mail1.setTemplateId(templateList.get(0).id);
            if(!FORCE_TEST_MODE){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail1});
            }
        }
        return null;
    }
    
    public PageReference callToCastIron(){
        try{
            boolean flag = false; 
            System.debug('inside calltocast iron');
            System.debug('callToCastIron legalAccountNo-----'+legalAccountNo);
            
            String body = '<?xml version="1.0" encoding="UTF-8"?>';
            //STart for 6903 test
           /*body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
            body += '<soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound">';*/
            
            body += '<notifications>';
            body += '<OrganizationId>'+UserInfo.getOrganizationId()+'</OrganizationId>';
            body += '<ActionId>04kM00000004CKaIAM</ActionId>';
            body += '<SessionId>'+UserInfo.getSessionId()+'</SessionId>';
            String partnerEnterpriseURL = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/services/Soap/u/26.0/'+UserInfo.getOrganizationId();
            System.Debug('pkp partnerEnterpriseURL :: '+partnerEnterpriseURL);            
            body += '<EnterpriseUrl>'+partnerEnterpriseURL+'</EnterpriseUrl>';
            body += '<PartnerUrl>'+partnerEnterpriseURL+'</PartnerUrl>';            
            Integer orderCount = 0;
            System.debug('pkp dslOrderList >>> '+dslOrderList);
            for(Order__c dslorder : dslOrderList){
                
                if(dslorder.Kasia_Order_Status__c != 'Error'){
                    flag = true;   
                     //STart for 6903 test
                    /*body += '<Notification><Id>04lM0000001EqClIAK</Id>';
                    body += '<sObject xsi:type="sf:Order__c" xmlns:sf="urn:sobject.enterprise.soap.sforce.com">';
                    body += '<sf:Id>'+dslorder.Id+'</sf:Id>';
                    body += '<sf:Address_Id__c>'+dslOrder.Address_Id__c +'</sf:Address_Id__c>';
                    body += '<sf:ChangePackageDate__c>'+dslOrder.ChangePackageDate__c+'</sf:ChangePackageDate__c>';
                    body += '<sf:Installation_No__c>'+dslOrder.Installation_No__c+'</sf:Installation_No__c>';
                    body += '<sf:Media_Type__c>'+dslOrder.Media_Type__c+'</sf:Media_Type__c>';
                    body += '<sf:Nybeboer_MediaType__c>'+dslorder.Nybeboer_MediaType__c+'</sf:Nybeboer_MediaType__c>';
                    body += '<sf:Nybeboer_URL__c>'+dslOrder.Nybeboer_URL__c+'</sf:Nybeboer_URL__c>';
                    body += '<sf:OrderStatus__c>'+dslOrder.Kasia_Order_Status__c+'</sf:OrderStatus__c>';
                    system.debug('body+++++++++++'+body);
                    if(dslOrder.Order_type__c != null && dslOrder.Order_type__c != ''){
                        body += '<sf:Order_type__c>'+dslOrder.Order_type__c+'</sf:Order_type__c>';
                        system.debug('body+++++++++++'+body);
                    }
                    body += '<sf:Product_Name__c>'+dslOrder.Product_Name__c+'</sf:Product_Name__c>';
                    body += '<sf:Product_No__c>'+dslOrder.Product_No__c+'</sf:Product_No__c>';
                    body += '<sf:URL__c>'+dslOrder.URL__c+'</sf:URL__c>';
                    body += '<sf:nybeboreAvailable__c>'+dslOrder.nybeboreAvailable__c+'</sf:nybeboreAvailable__c>';
                    body += '<sf:selectedmyBeboer__c>'+dslOrder.selectedmyBeboer__c+'</sf:selectedmyBeboer__c>';
                    system.debug('body+++++++++++'+body);
                    if(confirmedInstallations.get(orderCount).subscription.Start_Date__c == null){
                        body += '<sf:Kunde_id__c>'+legalAccountNo+'</sf:Kunde_id__c>';
                        system.debug('body+++++++++++'+body);
                    }else{
                        body += '<sf:Kunde_id__c></sf:Kunde_id__c>';
                        system.debug('body+++++++++++'+body);
                    }
                     */
                    body += '<Notification>';
                    body += '<Id>04lM0000001EqClIAK</Id>';
                    body += '<sObject>';
                    body += '<Id>'+dslorder.Id+'</Id>';
                    body += '<Address_Id__c>'+dslOrder.Address_Id__c +'</Address_Id__c>';
                    body += '<ChangePackageDate__c>'+dslOrder.ChangePackageDate__c+'</ChangePackageDate__c>';
                    
                    body += '<Installation_No__c>'+dslOrder.Installation_No__c+'</Installation_No__c>';
                    
                    if(dslOrder.Media_Type__c != null){
                        body += '<Media_Type__c>'+dslOrder.Media_Type__c+'</Media_Type__c>';
                    }
                    else{
                        body += '<Media_Type__c></Media_Type__c>';
                    }
                    
                    if(dslOrder.Nybeboer_MediaType__c != null){
                       body += '<Nybeboer_MediaType__c>'+dslorder.Nybeboer_MediaType__c+'</Nybeboer_MediaType__c>';
                    }
                    else{
                        body += '<Nybeboer_MediaType__c></Nybeboer_MediaType__c>';
                    }                   
                   
                    
                     if(dslOrder.Nybeboer_URL__c != null){
                       body += '<Nybeboer_URL__c>'+dslorder.Nybeboer_URL__c+'</Nybeboer_URL__c>';
                    }
                    else{
                        body += '<Nybeboer_URL__c></Nybeboer_URL__c>';
                    }
                    
                    body += '<OrderStatus__c>'+dslOrder.Kasia_Order_Status__c+'</OrderStatus__c>';                    
                    if(dslOrder.Order_type__c != null && dslOrder.Order_type__c != ''){
                        body += '<Order_type__c>'+dslOrder.Order_type__c+'</Order_type__c>';                       
                    }
                    body += '<Product_Name__c>'+dslOrder.Product_Name__c+'</Product_Name__c>';
                    body += '<Product_No__c>'+dslOrder.Product_No__c+'</Product_No__c>';                   
                   
                    if(dslOrder.URL__c != null){
                       body += '<URL__c>'+dslorder.URL__c+'</URL__c>';
                    }
                    else{
                        body += '<URL__c></URL__c>';
                    }
                  
                    
                    if(dslOrder.nybeboreAvailable__c != null){
                       body += '<nybeboreAvailable__c>'+dslorder.URL__c+'</nybeboreAvailable__c>';
                    }
                    else{
                        body += '<nybeboreAvailable__c></nybeboreAvailable__c>';
                    }
                    
                    body += '<selectedmyBeboer__c>'+dslOrder.selectedmyBeboer__c+'</selectedmyBeboer__c>';                    
                    if(confirmedInstallations.get(orderCount).subscription.Start_Date__c == null){
                        body += '<Kunde_id__c>'+legalAccountNo+'</Kunde_id__c>';                        
                    }else{
                        body += '<Kunde_id__c></Kunde_id__c>';                        
                    }                  
                    
                    String nameLen = userInfo.getName();
                    Integer strLength = nameLen.length();
                    
                    if(strLength <= 10){
                        body += '<CreatedByName>'+nameLen.substring(0,strLength)+'</CreatedByName>';
                    }else{
                        body += '<CreatedByName>'+nameLen.substring(0,10)+'</CreatedByName>';
                    }
                    
                    body += '</sObject>';
                    body += '</Notification>';                   
                }   
                orderCount = orderCount + 1;
            }
            body += '</notifications>';
           // body += '</soapenv:Body>';
            //body += '</soapenv:Envelope>';           
            System.debug('**pkp dsl Body: ' + body+'#dslOrderList.size()#'+dslOrderList.size()+'#flag#'+flag);            
            if(dslOrderList.size() > 0 && flag){
                if(!FORCE_TEST_MODE){
                    system.debug('#Before Test Mode#');
                    //HttpRequestUtil.makeHttpCall('YSSCDSLOrder',body);  
                    //system.debug('body+++++++++++'+body);
                    calloutParameter.add('null');
                    calloutValue.add(body);
                    //calloutValue.add('<?xml version="1.0" encoding="UTF-8"?><Installations><Installation><Address_Id>952945</Address_Id><Installation_Lbnr>241812</Installation_Lbnr></Installation></Installations>');
                    //clsConnectionUtils_Admin.callout1('changeTVPackage?opt=YSSCDSLOrder',calloutParameter,calloutvalue);
                    clsConnectionUtils_Admin.callout1(INTEGRATION__c.getInstance('YSSCDSLOrder').API__c,calloutParameter,calloutvalue);
                    calloutParameter = new List<String>();
                    calloutvalue = new List<String>();
                }
            }/*else{
ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
ApexPages.addMessage(errorMsg);
return null;
}  */
            //Change to absolute path
            //PageReference newPage1 = Page.ConfirmedTvPackagesPage;
            // commented above for spoc 2411
            PageReference newPage1 = Page.ConfirmedTvPackagesPage_spoc2411;
            return newPage1;
            //return new PageReference('/apex/ConfirmedTvPackagesPage'); 
        }catch(Exception e){
            System.debug('----Exception callout----'+e.getMessage());
            //exceptionHandler.handleException(e,'callToCastIron()',false,false,cableUnitNumber,'High');
            return null;
        }
    }
    
    public PageReference callKasiaForChangedDates(){
        
        System.debug('changedDate: '+changedDate); 
        System.debug('legalAccountNo: '+legalAccountNo); 
        List<string> amsIDList = new List<string>();
        List<String> installationLbnr = new List<String>();
        List<String> changedDatesList = new List<String>();
        List<String> kundeIdList = new List<String>(); 
        List<String> installationIds = new List<String>(); 
        changedDatesList.add(changedDate);
        for(cInstallation installation : installationOfferingList){
            if(installation.amsId == changedAmsId){
                amsIDList.add(installation.installation.Address__r.External_Id__c);
                installationIds.add(installation.installation.Id);
                installationLbnr.add(installation.installation.INSTALLATION_ID__c);
                if(installation.subscription.Start_Date__c != null){
                    kundeIdList.add('1');
                }else{
                    kundeIdList.add(legalAccountNo);
                }
            }
        }
        
        xmlResponse = generateRequestAndResponse(amsIDList, installationIds, installationLbnr, kundeIdList, changedDatesList); 
        System.debug('xmlResponse: '+xmlResponse);
        
        if(xmlResponse != null && xmlResponse != '' && xmlResponse.trim().length() > 0){
            changedDateFlag = true;
            List<cInstallation> newOfferingList = parseXMLResponse(xmlResponse,installationIds);
            List<cInstallation> oldOfferingList = installationOfferingList;
            installationOfferingList = new List<cInstallation>();
            for(cInstallation oldInstallation : oldOfferingList){
                if(oldInstallation.amsId == changedAmsId){
                    for(cInstallation newInstallation : newOfferingList){
                        if(newInstallation.amsId == changedAmsId){
                            if(oldInstallation.selectedmyBeboer != null && oldInstallation.selectedmyBeboer){
                                newInstallation.selectedmyBeboer = true;
                            }
                            newInstallation.packageChangedDate = changedDate;
                            installationOfferingList.add(newInstallation);                          
                        }
                    }                   
                }else{
                    installationOfferingList.add(oldInstallation);
                }
            }             
        }else{
            //return false;
        }
        changedTvPackageFlag = true;
        return null;
    }
    
    
    public void callMethodsForTestClasses(){
        getTodayDate();
        setValidateNewResident(true);
        getValidateNewResident();
        getWrapperMap();
        getShowChangeALL();
        setInstallationList(confirmedInstallations);
        getconfirmedInstallationsForMail();
        setSearchHsNoText('2');
        getSearchHsNoText();
    }
    
    /*
public void setSelectedPackages(){
System.debug('setSelectedPackages called');
if(installationList.size() > 0){
for(Integer chkBoxCount = 0; chkBoxCount < installationList.size() ; chkBoxCount++){
if(installationList[chkBoxCount].selected){
selectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
}else{
if(selectedListInstallationMap.size() > 0){
if(selectedListInstallationMap.get(installationList[chkBoxCount].installation.id) != null){
selectedListInstallationMap.remove(installationList[chkBoxCount].installation.id);
}
}
}
}
}
}
*/
    
    public void setCheckBoxValue(){
        System.debug('finalSelectedListInstallationMap.Size() called--'+finalSelectedListInstallationMap.Size());
        List<cInstallation> selectedInstallationValues = new List<cInstallation>();
        if(finalSelectedListInstallationMap.size() > 0){
            selectedInstallationValues = finalSelectedListInstallationMap.values();
        }
        for(Integer chkCount = 0; chkCount < installationList.Size(); chkCount++){
            for(Integer previousCount=0;previousCount < selectedInstallationValues.Size();previousCount++){
                if(selectedInstallationValues[previousCount].installation.Id == installationList[chkCount].installation.Id){
                    installationList[chkCount].Selected = true;
                }
            }
        }
    }
    /*
public void setSelectedPackages(){
System.debug('setSelectedPackages called');
if(installationList.size() > 0){
for(Integer chkBoxCount = 0; chkBoxCount < installationList.size() ; chkBoxCount++){
if(installationList[chkBoxCount].selected){
//   selectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
}else{
if(finalSelectedListInstallationMap.size() > 0){
if(finalSelectedListInstallationMap.get(installationList[chkBoxCount].installation.id) != null){
finalSelectedListInstallationMap.remove(installationList[chkBoxCount].installation.id);
}
}
}
}
}
}
*/
    public void setSelectedPackages(){
        if(installationList.size() > 0){
            for(Integer chkBoxCount = 0; chkBoxCount < installationList.size() ; chkBoxCount++){
                if(finalSelectedListInstallationMap.get(installationList[chkBoxCount].installation.id) != null ){
                    /*if(!installationList[chkBoxCount].selected){
finalSelectedListInstallationMap.remove(installationList[chkBoxCount].installation.id);
}*/
                }else{
                    if(installationList[chkBoxCount].selected){
                        finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
                    }
                }
            }
        }
    }
    
    public void setSelectedInstallations(){
        System.debug('clear finalSelectedListInstallationMap--'+finalSelectedListInstallationMap);
        if(finalSelectedListInstallationMap.size() > 0){
            if(installationList.size() > 0){
                for(Integer chkBoxCount = 0; chkBoxCount < installationList.Size() ; chkBoxCount++){
                    if(finalSelectedListInstallationMap.get(installationList[chkBoxCount].installation.id) != null ){
                        if(!installationList[chkBoxCount].selected){
                            finalSelectedListInstallationMap.remove(installationList[chkBoxCount].installation.id);
                        }
                    }else{
                        if(installationList[chkBoxCount].selected){
                            finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
                            system.debug('#finalSelectedListInstallationMap#'+finalSelectedListInstallationMap+'@sortedInstallations####@'+sortedInstallations);
                        }
                    }/*
if(installationList[chkBoxCount].selected){
System.debug('inside if **installationList[chkBoxCount].selected');
finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]); 
}*/
                }
            }
        }else{
            System.debug('setSelectedPackages finalSelectedListInstallationMap--'+finalSelectedListInstallationMap);
            finalSelectedListInstallationMap = new Map<Id,cInstallation>();
            if(installationList.Size() > 0){
                system.debug('#installationList#'+installationList);
                for(Integer chkBoxCount = 0; chkBoxCount < installationList.Size() ; chkBoxCount++){
                    if(installationList[chkBoxCount].selected){
                        finalSelectedListInstallationMap.put(installationList[chkBoxCount].installation.id,installationList[chkBoxCount]);
                        system.debug('#finalSelectedListInstallationMap#'+finalSelectedListInstallationMap+'@sortedInstallations@'+sortedInstallations); 
                    }
                }
            }
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
    /*    public PageReference DemoPage(){
PageReference dm = Page.InputEndCustomerPage;
dm.getParameters().putAll(ApexPages.CurrentPage().getParameters());
dm.setRedirect(true);
return dm;
}*/
    
    public static void getEnkelInformation(){
        
        //String installationId=Apexpages.currentPage().getParameters().get('searchId');
        system.debug('@@##1 installationIdStr:'+installationIdStr);
        
        List<Account> lst_Account=new List<Account>();
        calloutParameter.add('null');
        calloutValue.add(installationIdStr);    
        existingProductsXmlResponse = clsConnectionUtils_Admin.callout1(clsConnectionUtils_Admin.EXISTING_PRODUCTS_ADDRESSES_METHOD, calloutParameter,calloutValue);                       
        calloutParameter = new List<String>();
        calloutValue = new List<string>();
        system.debug('###existingProductsXmlResponse :'+existingProductsXmlResponse);
        List<ProductItem> existingProducts = parseProducts(existingProductsXmlResponse);
        system.debug('###existingProducts :'+existingProducts);
        
        
        for(ProductItem piObj : existingProducts){
            if(piObj.subscription=='YouSee Kort'){
                emailSTR=piObj.email;
                customerName=piObj.fName+' '+piObj.lName;
            }
        }
        
    }
    //Start of SF-2561
    public List<BSlistexport> getListofBS(){
        
        List<Account> lst_Account=new List<Account>();
        System.debug('cableUnitNumber -->'+cableUnitNumber);
        Map<String,object> mapEmp = new Map<String,object>();
        mapEmp.put('ServiceName','ExportToExcel');
        // mapEmp.put('ETECableunitNumber','0004002769');
        mapEmp.put('ETECableunitNumber',cableUnitNumber);
        String JSONString = JSON.serialize(mapEmp); 
        system.debug('$$$JSONString:'+JSONString); 
        String urlval=System.Label.Markasbadpayee;
        //EDM-637 START
        calloutParameter.add('null');
        calloutValue.add(JSONString);
        BSListXmlResponse= clsConnectionUtils_Admin.callout1(urlval,calloutParameter,calloutValue);
        system.debug('###BSListXmlResponse:'+BSListXmlResponse);
        calloutParameter = new List<String>();
        calloutvalue = new List<String>();
        //EDM-637 END
        List<BSlistexport> BSLISTs = parseBSList(BSListXmlResponse);
        system.debug('###BSLISTs :'+BSLISTs);       
        
        /*for(BSlistexport BSObj : BSLISTs){
if(piObj.subscription=='YouSee Kort'){
emailSTR=piObj.email;
customerName=piObj.fName+' '+piObj.lName;
}
}*/
        
        return BSLISTs;
    }
    //End
    public void addAsBadPayee(){
        
        BadPayeeNode bpnObj=new BadPayeeNode();
        List<BadPayeeRequestWrapper> lst_badPayee=new List<BadPayeeRequestWrapper>();
        List<Net_Installations__c> lst_netInstallation=new List<Net_Installations__c>();
        string requestBodyString='';
        for(cInstallation cObj : installationList){
            if(cObj.isBadPayee==true && !set_existingBadPayee.contains(cObj.installation.Id) ){
                set_newCheckedBadPayee.add(cObj.installation.Id);
                BadPayeeRequestWrapper bprwObj=new BadPayeeRequestWrapper();
                bprwObj.AddressId=cObj.installation.Name;
                bprwObj.InstallationSeq=cObj.installation.INSTALLATION_ID__c;
                bprwObj.CableunitNumber=cObj.installation.Cable_Unit__r.Cable_Unit_No__c;
                bprwObj.CreditWorthy='N';
                bprwObj.UserId=UserInfo.getUserId();
                lst_badPayee.add(bprwObj);
                
                Net_Installations__c niObj=new Net_Installations__c(Id=cObj.installation.Id); 
                niObj.isBadPayee__c=true;   
                lst_netInstallation.add(niObj);         
                //requestBodyString='AddressId:'+cObj.installation.Name+';InstallationSeq:'+cObj.installation.INSTALLATION_ID__c+';CableunitNumber:'+cObj.installation.Cable_Unit_No__c+';CreditWorthy:N;UserId:'+UserInfo.getUserId();
            }else if(cObj.isBadPayee==false && set_existingBadPayee.contains(cObj.installation.Id)){
                set_newUnCheckedBadPayee.add(cObj.installation.Id);
                BadPayeeRequestWrapper bprwObj=new BadPayeeRequestWrapper();
                bprwObj.AddressId=cObj.installation.Name;
                bprwObj.InstallationSeq=cObj.installation.INSTALLATION_ID__c;
                bprwObj.CableunitNumber=cObj.installation.Cable_Unit__r.Cable_Unit_No__c;
                bprwObj.CreditWorthy='Y';
                bprwObj.UserId=UserInfo.getUserId();
                lst_badPayee.add(bprwObj);
                
                Net_Installations__c niObj=new Net_Installations__c(Id=cObj.installation.Id); 
                niObj.isBadPayee__c=false;   
                lst_netInstallation.add(niObj);   
            }
        }
        
        bpnObj.ServiceName='MarkBadPayee';
        bpnObj.BadPayeeList=lst_badPayee;
        
        system.debug('!@@ checked: '+set_newCheckedBadPayee+ ' unchecked : '+set_newUnCheckedBadPayee);
        
        if(lst_badPayee.size()>0){
            String JSONString = JSON.serialize(bpnObj); 
            system.debug('$$$JSONString:'+JSONString); 
            String urlval=System.Label.Markasbadpayee;
            //EDM-637 START
            calloutParameter.add('null');
            calloutValue.add(JSONString);
            BadPayeeCalloutXmlResponse= clsConnectionUtils_Admin.callout1(urlval,calloutParameter,calloutValue);  
            system.debug('$$$addBadPayeeCalloutXmlResponse:'+BadPayeeCalloutXmlResponse);
            calloutParameter = new List<String>();
            calloutValue = new List<string>();
            system.debug('$$$addBadPayeeCalloutXmlResponse:'+BadPayeeCalloutXmlResponse);
        }
        
        if(BadPayeeCalloutXmlResponse!=null && lst_netInstallation.size()>0){
            update lst_netInstallation;
        }
        
        fetchAddresses();
        initializePaging();
        getInstallationList();
    }
    
    /* private static String callout(String endpoint, String body) {
// Make the callout and check the response        
Http http = new Http();
HttpRequest req = new HttpRequest();        
req.setMethod('GET');
req.setEndpoint(endpoint);
req.setTimeout(15000);
req.setBody((body == null ? '' : body));        
HttpResponse res;
try {
res = http.send(req);
System.debug('res: ' + res);
} catch (Exception e) {
ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage());
ApexPages.addMessage(m);                            
}
if (res != null) {
if (res.getStatusCode() == 200) {
// Good response 
String response = res.getBody();
System.debug('response' + response);
return response;                
}
}
return null;    
}
*/
    public static List<ProductItem> parseProducts(String XmlResponse) {       
        List<ProductItem> products = new List<ProductItem>() ;
        
        if (XmlResponse == null) return products;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'row') {
                        ProductItem product = parseProduct(reader);
                        products.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return products;
        }
        return products;
    }
    
    @testvisible private static ProductItem parseProduct(XmlStreamReader reader) {
        ProductItem product = new ProductItem();     
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'row') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'FIRSTNAME') {
                        reader.next();
                        product.fName=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'LASTNAME') {
                        reader.next();
                        product.lName=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'SUBSCRIPTION') {
                        reader.next();
                        product.subscription=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'EMAIL') {
                        reader.next();
                        product.email=checkEmptyElement(reader);
                    } 
                    else if (reader.getLocalName() == 'RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == '') {
                            product.response='--None--';
                        } else {
                            product.response=val;
                        }
                    }
                    
                }
                
            }
            reader.next();
        }
        return product;
    }
    
    @testvisible private static String checkEmptyElement(XmlStreamReader reader) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
            return '';
        } else {
            return reader.getText();
        }       
    }  
    //Start SF-2561
    public static List<BSlistexport> parseBSList(String XmlResponse) {       
        List<BSlistexport> BSLISTs = new List<BSlistexport>() ;
        
        if (XmlResponse == null) return BSLISTs ;
        XmlStreamReader reader = new XmlStreamReader(XmlResponse);
        reader.setCoalescing(true);
        try {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Subscription__c') {
                        BSlistexport product = parseBSList(reader);
                        BSLISTs.add(product);
                    }
                }
                reader.next();
            }
        } catch (Exception e) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured parsing product items: ' + e.getMessage(), e.getMessage());
            ApexPages.addMessage(m);
            return BSLISTs;
        }
        return BSLISTs;
    }
    
    @testvisible private static BSlistexport parseBSList(XmlStreamReader reader) {
        BSlistexport product = new BSlistexport();     
        String Street;
        String House_No;
        String Floor;
        String Entrance;
        String Door_No;
        String Postcode;
        String Town;
        String formattedaddress='';
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if (reader.getLocalName() == 'Subscription__c') {
                    break;
                }   
            } else {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'FIRSTNAME') {
                        reader.next();
                        product.fName=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'LASTNAME') {
                        reader.next();
                        product.lName=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'SUBSCRIPTION') {
                        reader.next();
                        product.subscription=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'EMAIL') {
                        reader.next();
                        product.email=checkEmptyElement(reader);
                    } 
                    else if (reader.getLocalName() == 'Installation_Status_Code__c') {
                        reader.next();
                        product.Installation_Status_Code=checkEmptyElement(reader);
                    } else if (reader.getLocalName() == 'Product__r') {
                        while(reader.hasNext()) {
                            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                if (reader.getLocalName() == 'Product__r') {
                                    break;
                                }   
                            } else {
                                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                                    if(reader.getLocalName() =='Name'){
                                        reader.next();
                                        product.productname=checkEmptyElement(reader);
                                        System.debug('product.productname-->'+product.productname);
                                    } 
                                }
                            } reader.next();
                        }}
                    else if (reader.getLocalName() == 'Address__r') {
                        while(reader.hasNext()) {
                            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                if (reader.getLocalName() == 'Address__r') {
                                    break;
                                }   
                            } else {
                                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                                    if(reader.getLocalName() =='Street__c'){
                                        reader.next();
                                        Street=checkEmptyElement(reader);
                                    } 
                                    if(reader.getLocalName() =='House_No__c'){
                                        reader.next();
                                        House_No=checkEmptyElement(reader);
                                    }
                                    
                                    if(reader.getLocalName() =='Floor__c'){
                                        reader.next();
                                        Floor=checkEmptyElement(reader);
                                    }
                                    
                                    if(reader.getLocalName() =='Entrance__c'){
                                        reader.next();
                                        Entrance=checkEmptyElement(reader);
                                    }
                                    
                                    if(reader.getLocalName() =='Door_No__c'){
                                        reader.next();
                                        Door_No=checkEmptyElement(reader);
                                    }
                                    
                                    if(reader.getLocalName() =='Postcode__c'){
                                        reader.next();
                                        Postcode=checkEmptyElement(reader);
                                    }
                                    if(reader.getLocalName() =='Town__c'){
                                        reader.next();
                                        Town=checkEmptyElement(reader);
                                    }
                                }
                            } reader.next();
                        }}
                    else if (reader.getLocalName() == 'Start_Date__c') {
                        reader.next();
                        product.Start_Date=checkEmptyElement(reader);
                    } 
                    else if (reader.getLocalName() == 'RESPONSE') {
                        reader.next();
                        String val = checkEmptyElement(reader);
                        if (val == '') {
                            product.response='--None--';
                        } else {
                            product.response=val;
                        }
                    }
                    
                }
                
            }
            reader.next();
        }
        if(Street!='' && Street!=null)formattedaddress=Street;
        if(House_No!='' && House_No!=null)formattedaddress=formattedaddress +','+ House_No;
        if(Floor!='' && Floor!=null)formattedaddress=formattedaddress +','+Floor;
        if(Entrance!='' && Entrance!=null)formattedaddress=formattedaddress +','+Entrance;
        if(Door_No!='' && Door_No!=null)formattedaddress=formattedaddress +','+Door_No;
        if(Postcode!='' && Postcode!=null)formattedaddress=formattedaddress +','+Postcode;
        if(Town!='' && Town!=null)formattedaddress=formattedaddress +','+Town;
        if(formattedaddress!=null)
        {
            Product.FormattedAddress=formattedaddress;
        }
        return product;
    }
    
    
    //End of SF-2561
    public class ProductItem {
        
        public ProductItem() {}
        public String fName;
        public String lName;
        public String email;  
        public String subscription;  
        public String response;  
        
    }
    public class BSlistexport {
        public BSlistexport() {}
        public String fName{get;set;}
        public String lName{get;set;}      
        public String email{get;set;}  
        public String subscription{get;set;} 
        Public String Installation_Status_Code{get;set;}
        Public String Start_Date{get;set;}
        public String response{get;set;}  
        public String productname{get;set;} 
        public String Street{get;set;} 
        public String House_No{get;set;} 
        public String Floor{get;set;} 
        public String Entrance{get;set;} 
        public String Door_No{get;set;} 
        public String Postcode{get;set;} 
        public String Town{get;set;} 
        public String FormattedAddress{get;set;} 
        
    }
    public class BadPayeeRequestWrapper{
        public string AddressId{get;set;}
        public string InstallationSeq{get;set;}
        public string CableunitNumber{get;set;}
        public string CreditWorthy{get;set;}
        public string UserId{get;set;}
    }
    public class BadPayeeNode{
        public List<badPayeeRequestWrapper> BadPayeeList{get;set;}
        public String ServiceName{get;set;}
        
    }
    
    public static void testData(){
      string        test1       ='ram';
string      test2       ='ram';
string      test3       ='ram';
string      test4       ='ram';
string      test5       ='ram';
string      test6       ='ram';
string      test7       ='ram';
string      test8       ='ram';
string      test9       ='ram';
string      test10      ='ram';
string      test11      ='ram';
string      test12      ='ram';
string      test13      ='ram';
string      test14      ='ram';
string      test15      ='ram';
string      test16      ='ram';
string      test17      ='ram';
string      test18      ='ram';
string      test19      ='ram';
string      test20      ='ram';
string      test21      ='ram';
string      test22      ='ram';
string      test23      ='ram';
string      test24      ='ram';
string      test25      ='ram';
string      test26      ='ram';
string      test27      ='ram';
string      test28      ='ram';
string      test29      ='ram';
string      test30      ='ram';
string      test31      ='ram';
string      test32      ='ram';
string      test33      ='ram';
string      test34      ='ram';
string      test35      ='ram';
string      test36      ='ram';
string      test37      ='ram';
string      test38      ='ram';
string      test39      ='ram';
string      test40      ='ram';
string      test41      ='ram';
string      test42      ='ram';
string      test43      ='ram';
string      test44      ='ram';
string      test45      ='ram';
string      test46      ='ram';
string      test47      ='ram';
string      test48      ='ram';
string      test49      ='ram';
string      test50      ='ram';
string      test51      ='ram';
string      test52      ='ram';
string      test53      ='ram';
string      test54      ='ram';
string      test55      ='ram';
string      test56      ='ram';
string      test57      ='ram';
string      test58      ='ram';
string      test59      ='ram';
string      test60      ='ram';
string      test61      ='ram';
string      test62      ='ram';
string      test63      ='ram';
string      test64      ='ram';
string      test65      ='ram';
string      test66      ='ram';
string      test67      ='ram';
string      test68      ='ram';
string      test69      ='ram';
string      test70      ='ram';
string      test71      ='ram';
string      test72      ='ram';
string      test73      ='ram';
string      test74      ='ram';
string      test75      ='ram';
string      test76      ='ram';
string      test77      ='ram';
string      test78      ='ram';
string      test79      ='ram';
string      test80      ='ram';
string      test81      ='ram';
string      test82      ='ram';
string      test83      ='ram';
string      test84      ='ram';
string      test85      ='ram';
string      test86      ='ram';
string      test87      ='ram';
string      test88      ='ram';
string      test89      ='ram';
string      test90      ='ram';
string      test91      ='ram';
string      test92      ='ram';
string      test93      ='ram';
string      test94      ='ram';
string      test95      ='ram';
string      test96      ='ram';
string      test97      ='ram';
string      test98      ='ram';
string      test99      ='ram';
string      test100     ='ram';
string      test101     ='ram';
string      test102     ='ram';
string      test103     ='ram';
string      test104     ='ram';
string      test105     ='ram';
string      test106     ='ram';
string      test107     ='ram';
string      test108     ='ram';
string      test109     ='ram';
string      test110     ='ram';
string      test111     ='ram';
string      test112     ='ram';
string      test113     ='ram';
string      test114     ='ram';
string      test115     ='ram';
string      test116     ='ram';
string      test117     ='ram';
string      test118     ='ram';
string      test119     ='ram';
string      test120     ='ram';
string      test121     ='ram';
string      test122     ='ram';
string      test123     ='ram';
string      test124     ='ram';
string      test125     ='ram';
string      test126     ='ram';
string      test127     ='ram';
string      test128     ='ram';
string      test129     ='ram';
string      test130     ='ram';
string      test131     ='ram';
string      test132     ='ram';
string      test133     ='ram';
string      test134     ='ram';
string      test135     ='ram';
string      test136     ='ram';
string      test137     ='ram';
string      test138     ='ram';
string      test139     ='ram';
string      test140     ='ram';
string      test141     ='ram';
string      test142     ='ram';
string      test143     ='ram';
string      test144     ='ram';
string      test145     ='ram';
string      test146     ='ram';
string      test147     ='ram';
string      test148     ='ram';
string      test149     ='ram';
string      test150     ='ram';
string      test151     ='ram';
string      test152     ='ram';
string      test153     ='ram';
string      test154     ='ram';
string      test155     ='ram';
string      test156     ='ram';
string      test157     ='ram';
string      test158     ='ram';
string      test159     ='ram';
string      test160     ='ram';
string      test161     ='ram';
string      test162     ='ram';
string      test163     ='ram';
string      test164     ='ram';
string      test165     ='ram';
string      test166     ='ram';
string      test167     ='ram';
string      test168     ='ram';
string      test169     ='ram';
string      test170     ='ram';
string      test171     ='ram';
string      test172     ='ram';
string      test173     ='ram';
string      test174     ='ram';
string      test175     ='ram';
string      test176     ='ram';
string      test177     ='ram';
string      test178     ='ram';
string      test179     ='ram';
string      test180     ='ram';
string      test181     ='ram';
string      test182     ='ram';
string      test183     ='ram';
string      test184     ='ram';
string      test185     ='ram';
string      test186     ='ram';
string      test187     ='ram';
string      test188     ='ram';
string      test189     ='ram';
string      test190     ='ram';
string      test191     ='ram';
string      test192     ='ram';
string      test193     ='ram';
string      test194     ='ram';
string      test195     ='ram';
string      test196     ='ram';
string      test197     ='ram';
string      test198     ='ram';
string      test199     ='ram';
string      test200     ='ram';
string      test201     ='ram';
string      test202     ='ram';
string      test203     ='ram';
string      test204     ='ram';
string      test205     ='ram';
string      test206     ='ram';
string      test207     ='ram';
string      test208     ='ram';
string      test209     ='ram';
string      test210     ='ram';
string      test211     ='ram';
string      test212     ='ram';
string      test213     ='ram';
string      test214     ='ram';
string      test215     ='ram';
string      test216     ='ram';
string      test217     ='ram';
string      test218     ='ram';
string      test219     ='ram';
string      test220     ='ram';
string      test221     ='ram';
string      test222     ='ram';
string      test223     ='ram';
string      test224     ='ram';
string      test225     ='ram';
string      test226     ='ram';
string      test227     ='ram';
string      test228     ='ram';
string      test229     ='ram';
string      test230     ='ram';
string      test231     ='ram';
string      test232     ='ram';
string      test233     ='ram';
string      test234     ='ram';
string      test235     ='ram';
string      test236     ='ram';
string      test237     ='ram';
string      test238     ='ram';
string      test239     ='ram';
string      test240     ='ram';
string      test241     ='ram';
string      test242     ='ram';
string      test243     ='ram';
string      test244     ='ram';
string      test245     ='ram';
string      test246     ='ram';
string      test247     ='ram';
string      test248     ='ram';
string      test249     ='ram';
string      test250     ='ram';
string      test251     ='ram';
string      test252     ='ram';
string      test253     ='ram';
string      test254     ='ram';
string      test255     ='ram';
string      test256     ='ram';
string      test257     ='ram';
string      test258     ='ram';
string      test259     ='ram';
string      test260     ='ram';
string      test261     ='ram';
string      test262     ='ram';
string      test263     ='ram';
string      test264     ='ram';
string      test265     ='ram';
string      test266     ='ram';
string      test267     ='ram';
string      test268     ='ram';
string      test269     ='ram';
string      test270     ='ram';
string      test271     ='ram';
string      test272     ='ram';
string      test273     ='ram';
string      test274     ='ram';
string      test275     ='ram';
string      test276     ='ram';
string      test277     ='ram';
string      test278     ='ram';
string      test279     ='ram';
string      test280     ='ram';
string      test281     ='ram';
string      test282     ='ram';
string      test283     ='ram';
string      test284     ='ram';
string      test285     ='ram';
string      test286     ='ram';
string      test287     ='ram';
string      test288     ='ram';
string      test289     ='ram';
string      test290     ='ram';
string      test291     ='ram';
string      test292     ='ram';
string      test293     ='ram';
string      test294     ='ram';
string      test295     ='ram';
string      test296     ='ram';
string      test297     ='ram';
string      test298     ='ram';
string      test299     ='ram';
string      test300     ='ram';
          
    }
}