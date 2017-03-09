/***********************************************************************************
*   Oasis_Utils
*   This class all the commonly used methods in the oasis project
*
************************************************************************************/
public class Oasis_Utils{ 
    public static String CASE_SOURCE_OASIS = 'Oasis'; 
    public static String OASIS_COOKIE_NAME = 'oasis';  
    public static String PICKLIST_OPTION_SELECT = 'Vælg';
    public static String CASE_INFO_FOR_INSTALLATION = 'Installation';
    public static String CASE_INFO_FOR_CABLEUNIT = 'CableUnit';
    public static Integer USER_SESSION_PERIOD = 82800;
    public static String TGP = Oasis_String_Values__c.getInstance('Tilsluttet Grundpakke').Value__c;
    public static String TMP = Oasis_String_Values__c.getInstance('Tilsluttet Mellempakke').Value__c;
    public static String TFP = Oasis_String_Values__c.getInstance('Tilsluttet Fuldpakke').Value__c;
    public static String LilleTillPakke = Oasis_String_Values__c.getInstance('Lille Tillægspakke').Value__c;
    public static String TillPakke = Oasis_String_Values__c.getInstance('Tillægspakke').Value__c;  
    public static boolean duplicateCaseFlag;
    public static Map<String, Case> mapOldCase;
   public static Oasis_User__c getOasisUser(PageReference pageRef)
    {
        Oasis_User__c oUser = null;
        String cookieValue = Oasis_Utils.getCookieValue(Oasis_Utils.OASIS_COOKIE_NAME, pageRef);
        system.debug('Cookie value ****** '+cookieValue);
        if (cookieValue != null) {
            oUser = (Oasis_User__c)JSON.deserialize(cookieValue, Oasis_User__c.class);
            
            //extend the time out of the cookie
            Oasis_Utils.extendCookieTimeOut(Oasis_Utils.OASIS_COOKIE_NAME);
        }
        system.debug('Logged IN User>>>' + oUser);
            
        return oUser;       
    }
 
    // return case dept, product and type task based on the registration code 
    public static Oasis_Case_Assignment__c getCaseDetailsforRegCode(String regCode, String forType)
    {
        System.debug('****regCode***'+regCode+'****forType***'+forType);
        List<Oasis_Case_Assignment__c> listCaseInfo = [select case_dept__c, case_product__c, case_type_task__c
                                                        from Oasis_Case_Assignment__c
                                                        where name = :regCode 
                                                        and for__c = :forType];
        if(!listCaseInfo.isEmpty())
            return listCaseInfo[0];
        
        // if no case info present for this reg code, return the default value
        List<Oasis_Case_Assignment__c> listDefaultCaseInfo = [select case_dept__c, case_product__c, case_type_task__c
                                                                from Oasis_Case_Assignment__c
                                                                where name = 'Default'];
        return  listDefaultCaseInfo[0];                                                                                                         
    }
    
    // get all case details assignment details
    public static Map<String, Oasis_Case_Assignment__c> getAllCaseAssignmentDetails(String forType)
    {
        System.debug('****forType***'+forType);
        Map<String, Oasis_Case_Assignment__c> mapCaseAssignment = new Map<String, Oasis_Case_Assignment__c>();
        List<Oasis_Case_Assignment__c> listCaseInfo = [select case_dept__c, case_product__c, case_type_task__c, name 
                                                        from Oasis_Case_Assignment__c
                                                        where for__c = :forType];
        if(!listCaseInfo.isEmpty()) {
            for(Oasis_Case_Assignment__c oc: listCaseInfo)
            {
                mapCaseAssignment.put(oc.Name, oc);
            } 
            
        }
            
        return mapCaseAssignment;                                               
    }
    
    // returns list of registration codes for Installation Search
    // results
    public static List<SelectOption> getInstallationRegistrationCodes()
    {      
       return getPicklistValues(Oasis_Case__c.Oasis_Inst_Case_Registration_Code__c.getDescribe());
    }
    
    // returns a list of registration codes for CU related cases 
    public Static List<SelectOption> getCURegistrationCodes()
    {     
       return getPicklistValues(Oasis_Case__c.Oasis_CU_Case_Reg_Code__c.getDescribe());
    }
    
    // return strike picklist values
    public static List<SelectOption> getStrikeValues()
    {       
        return getPicklistValues(Oasis_Case__c.Oasis_Strike__c.getDescribe());      
    }
    
    // return error type labels
    public static List<SelectOption> getErrorTypeLabels()
    {
        return getPicklistValues(Oasis_Case__c.Oasis_Error_type_Label__c.getDescribe());
    }
    
    private static List<SelectOption> getPicklistValues(Schema.DescribeFieldResult fieldResult) 
    {
            List<SelectOption> picklistValues = new List<SelectOption>();           
            for(Schema.PicklistEntry e : fieldResult.getPickListValues())
            {                  
                picklistValues.add(new SelectOption(e.getLabel(), e.getValue())); 
            } 
            return  picklistValues;  
    }
    
    // get customer subscriptions for installation ids
    public static List<Customer_Subscription__c> getCustomerSubscriptionsForInstallationId(Set<String> installationId)
    {
        List<Customer_Subscription__c> listCS = new List<Customer_Subscription__c>();
        Map<String, List<Customer_Subscription__c>> mapCS = getCustomerSubscriptionsForInstallationMap(installationId);
        for(List<Customer_Subscription__c> l : mapCS.values())
        {
            listCS.addAll(l);
        }
        
        return listCS;          
    }
    
    public static Map<String, List<Customer_Subscription__c>> getCustomerSubscriptionsForInstallationMap(Set<String> installationId) 
    {
        Map<String, List<Customer_Subscription__c>> mapCS = new Map<String, List<Customer_Subscription__c>>();
        List<Customer_Subscription__c> listCustomerSubscription =  [select Address_AMS_Id__c, Address__c, 
                                                                          customer__r.Customer_No__c,
                                                                          Installation_Id__c,
                                                                          Customer_Number__c,Customer__c,
                                                                          customer__r.FirstName, customer__r.LastName,
                                                                          customer__r.Customer_type__c, customer__r.type,
                                                                          customer__r.PersonContactId,  
                                                                          Product__r.Name, Varenummer__c
                                                                    from Customer_Subscription__c
                                                                    where Installation_Id__c in :installationId 
                                                                    order by installation_Id__c];
        System.debug('***listCustomerSubscription***'+listCustomerSubscription);
        
       for(Customer_Subscription__c cs: listCustomerSubscription) {
  			if(mapCS.containsKey(cs.Installation_id__c)) {
  				List<Customer_Subscription__c> listCS = (List<Customer_Subscription__c>) mapCS.get(cs.Installation_id__c);
  				if(listCS != null) {
  					listCS.add(cs);
  				}
  			}	
  			else {
  				mapCS.put(cs.Installation_id__c, new List<Customer_Subscription__c>{cs});
  			}	
  		}

        System.debug('***mapCS****'+mapCS);
        // loop over the map and fix the records
        mapCS = filterAndFixCustomerSubscriptions(mapCS);
        
        system.debug('mapCS>>>>>' + mapCS);
        return mapCS;
    }
    // added for 2455
     public static Map<String, List<Customer_Subscription__c>> getCustomerSubscriptionsForInstallationMapSearch(Set<String> installationId) 
    {
        Map<String, List<Customer_Subscription__c>> mapCS = new Map<String, List<Customer_Subscription__c>>();
        List<Customer_Subscription__c> listCustomerSubscription =  [select Address_AMS_Id__c, Address__c, 
                                                                          customer__r.Customer_No__c,
                                                                          Installation_Id__c,
                                                                          Customer_Number__c,Customer__c,
                                                                          customer__r.FirstName, customer__r.LastName,
                                                                          customer__r.Customer_type__c, customer__r.type,
                                                                          customer__r.PersonContactId,  
                                                                          Product__r.Name, Varenummer__c
                                                                    from Customer_Subscription__c
                                                                    where Installation_Id__c in :installationId 
                                                                    order by installation_Id__c];
        System.debug('***listCustomerSubscription***'+listCustomerSubscription);
        
       for(Customer_Subscription__c cs: listCustomerSubscription) {
  			if(mapCS.containsKey(cs.Installation_id__c)) {
  				List<Customer_Subscription__c> listCS = (List<Customer_Subscription__c>) mapCS.get(cs.Installation_id__c);
  				if(listCS != null) {
  					listCS.add(cs);
  				}
                
                //customer__r.Customer_type__c
                if(mapCS.containsKey(cs.Installation_id__c) && cs.customer__r.Customer_type__c =='Enkel') {
                    mapCS.put(cs.Installation_id__c, new List<Customer_Subscription__c>{cs});
                }
  			}	
  			else {
  				mapCS.put(cs.Installation_id__c, new List<Customer_Subscription__c>{cs});
  			}	
  		}

        System.debug('***mapCS****'+mapCS);
        // loop over the map and fix the records
        mapCS = filterAndFixCustomerSubscriptions(mapCS);
        
        system.debug('mapCS>>>>>' + mapCS);
        return mapCS;
    }
    
    // this method will - 
    // a. Filter all the Organized customer records, if both O and E customer records are present
    // b. Change Lille Tillægspakke to Mellempakke
    // c. Change Tillægspakke to Fuldpakke
    private static Map<String, List<Customer_Subscription__c>> filterAndFixCustomerSubscriptions(Map<String, List<Customer_Subscription__c>> mapCS)
    {
        Map<String, List<Customer_Subscription__c>> mapCustomerSubscription = new Map<String, List<Customer_Subscription__c>>();
        //get the mellempakke and fuldpakke product records
        Product__c mellemPakkeProduct;
        Product__C fuldPakkeProduct;
        List<Product__c> listProducts = [select Id, Name, Product_ID__c from Product__c where Product_ID__c in ('1101101','1101201')];
        for(Product__c p : listProducts)
        {
            if(p.Product_ID__c == '1101101')
                mellemPakkeProduct = p;
            if(p.Product_ID__c == '1101201')
                fuldPakkeProduct = p;
        }
        
        // COMMENTED FOR NOW - MIGHT USE IT LATER
        // get all LT product list
        //List<Product__c> lilleTillaegspakkeProducts = [SELECT Name,Product_ID__c,Product_Name__c, id FROM Product__c where name like 'Lille Tillægspakke%'];          
        // get all TP product list
        //List<Product__c> tillaegspakkeProducts = [SELECT Name,Product_ID__c,Product_Name__c, id FROM Product__c where name like 'Tillægspakke%'];
        
        for(String installationId : mapCS.keySet())
        {
            List<Customer_Subscription__c> listCS = mapCS.get(installationId);
            
            if(listCS!= null && !listCS.isEmpty())
            {
                // check if enkel record is present
                Customer_Subscription__c enkelCS  = new Customer_Subscription__c();
                enkelCS = getEnkelCustomerSubscriptionRecord(listCS);
                //System.debug('***enkelCS**'+enkelCS);
                if(enkelCS != null) 
                {
                    // if enkel customer found, replace LT and TP with mellempakke and fuldpakke                
                    System.debug('**inside enkelCS**');
                    if(String.isNotEmpty(enkelCS.product__c)){
                        System.debug('**product not empty**');
                        if(enkelCS.product__r.Name.contains(LilleTillPakke))                
                            enkelCS.product__r = mellemPakkeProduct;
                        
                        if(enkelCS.product__r.Name.contains(TillPakke))
                            enkelCS.product__r = fuldPakkeProduct;           
                    }
                    // remove the organized customer record
                    Customer_Subscription__c organizedCustomer = getOrganizedCustomerSubscriptionRecord(listCS);
                    System.debug('****organizedCustomer***'+organizedCustomer);
                    /*if(organizedCustomer != null)
                        listCS = new List<Customer_Subscription__c>{enkelCS};  */ 
                }
            }
            mapCustomerSubscription.put(installationId, listCS); 
                    
        }
        return mapCustomerSubscription;
    } 
  
    /*
    // get customer subscriptions for ams id
    public static List<Customer_Subscription__c> getCustomerSubscriptionsForAddressId(Set<String> addressId)
    {
        List<Customer_Subscription__c> listCustomerSubscription = [select Address_AMS_Id__c, Address__c, 
                                                                          customer__r.Customer_No__c,
                                                                          Installation_Id__c,
                                                                          Customer_Number__c,Customer__c,
                                                                          customer__r.FirstName, customer__r.LastName,
                                                                          customer__r.Customer_type__c, customer__r.type,
                                                                          customer__r.PersonContactId,  
                                                                          Product__r.Name, Varenummer__c
                                                                    from Customer_Subscription__c
                                                                    where Address__c in :addressId 
                                                                    order by Address_AMS_Id__c];
        return listCustomerSubscription;                                                            
    }
    
    // return a map of address id and list of customer subscription records.
    public static Map<String, List<Customer_Subscription__c>> getCustomerSubscriptionsForAddressMap(Set<String> addressId) {
        List<Customer_Subscription__c> listCustomerSubscription = getCustomerSubscriptionsForAddressId(addressId);          
        Map<String, List<Customer_Subscription__c>> mapCS = new Map<String, List<Customer_Subscription__c>>();
        
        for(Customer_Subscription__c cs: listCustomerSubscription) {
            if(mapCS.containsKey(cs.Address__c)) {
                List<Customer_Subscription__c> listCS = (List<Customer_Subscription__c>) mapCS.get(cs.Address__c);
                if(listCS != null) {
                    listCS.add(cs);
                }
            }   
            else {
                mapCS.put(cs.Address__c, new List<Customer_Subscription__c>{cs});
            }   
        }
        
        system.debug('mapCS>>>>>' + mapCS);
        return mapCS;
    }*/
    
    // get installation details
    public static List<Net_Installations__c> getInstallationDetails(Set<String> installationIds)
    {
        List<Net_Installations__c> listNetInst = [select Address__c, Address_id__c, Address__r.external_id__c,                                                                                                              
                                                        Address_Merge_Field__c,
                                                        Address__r.Street__c, address__r.House_No__c, address__r.Floor__c,
                                                        address__r.Door_No__c, address__r.PostCode__c, address__r.Town__c, 
                                                        address__r.Entrance__c,                                                         
                                                        Id, location__c, 
                                                        stiktype__c,  // Added for EDM-738
                                                        control_date__c,
                                                        Cable_Unit_No__c,
                                                        Cable_Unit__c, Cable_Unit__r.id, 
                                                        cable_Unit__r.customer__c,
                                                        cable_Unit__r.customer__r.FirstName,
                                                        cable_Unit__r.customer__r.lastname,
                                                        cable_Unit__r.customer__r.Customer_type__c,
                                                        cable_Unit__r.customer__r.KISS_Customer_No__c,
                                                        cable_Unit__r.segment__c,
                                                        status__c, 
                                                        cable_Unit__r.status__c,
                                                        Installation_Status__c,                                                         
                                                        installation_id__c,
                                                        Cable_Unit__r.Oasis_Lock__c,
                                                        Move_Flag__c
                                                   from Net_Installations__c
                                                   where id in :installationIds];
        return listNetInst;
    }
    
     // return a map of installation id/case 
    public static Map<String, Case> getInstallationCases(Set<String> installationIds)
    {
        Map<String, Case> mapCase = new Map<String, Case>();            //installationid, Case       
        date d = system.today().addDays(-60); 
        // get the cases with source as Oasis and installation id 
        // there is a possibility of multiple open cases for an installation, the order by in 
        // end will make sure the latest open case is chosen in the loop
        // where clause changed for Oasis-64. Will fetch all cases whether open or closed and display the latest
        for (Case c:  [select Id, Status, Oasis_Case__r.Oasis_Inst_Case_Registration_Code__c,
                                        Oasis_Case__r.Oasis_Installation__c,
                                        Oasis_Case__r.Oasis_Installation__r.id, 
                                        CaseNumber, Oasis_Case__r.Oasis_Strike__c, 
                                        oasis_case__r.Oasis_Error_type_Label__c                       
                                    from Case where Oasis_Case__r.Oasis_Installation__c in :installationIds
                                    and Oasis_Case__r.Oasis_Installation__c != null
                                    and createdDate >= :d
                                    order by createdDate asc])                                          
        {            
            mapCase.put(c.Oasis_Case__r.Oasis_Installation__r.id, c);    
        }
        
        return mapCase;
    }    
  
    
    // create case for intallation(s)
    public static List<Case> createCaseForInstallation(List<Oasis_Utils.CaseCreateParam> listCaseParams,Map<String, Case> mapSubCase)
    {
        Map<String, Case> mapInstallationCase = new Map<String, Case>();                                // netInstallationId, Case
        Map<String, Oasis_Case__c> mapInstallationOasisCase = new Map<String, Oasis_Case__c>();         // netInstallationId, Oasis Case 
        Map<String, Net_Installations__c> mapInstallation = new Map<String, Net_Installations__c>();    // net installation id, net installation object
        //Map<String, Account> mapCUAccount = new Map<String, Account>();                                   // net installation external id, account
        List<Net_Installations__c> listInstToUpdate = new List<Net_Installations__c>();
        
        /////////////////////////////
        // STEP 1 - Prepare installation, customer data
        /////////////////////////////
        // create a list of installation ids
        Set<String> installationIds = new Set<String>();        
        for(Oasis_Utils.CaseCreateParam cp: listCaseParams)
        {
            installationIds.add(cp.installationId);
        }
        
        // get installation data
        List<Net_Installations__c> listNetInst = Oasis_Utils.getInstallationDetails(installationIds);
        Set<String> installationExternalIds = new Set<String>();
        for(Net_Installations__c n : listNetInst)
        {
            mapInstallation.put(n.Id, n);
            System.debug('NetInstallations ---- ' + n);
            installationExternalIds.add(n.installation_id__c);
        }       
       
        
        // get customer subscriptions for installation addresses
        Map<String, List<Customer_Subscription__c>> mapCS = getCustomerSubscriptionsForInstallationMap(installationExternalIds);        
        
        // get all case assignment details for various reg codes
        Map<String, Oasis_Case_Assignment__c> mapCaseAssignment = getAllCaseAssignmentDetails(CASE_INFO_FOR_INSTALLATION);
        
        // get all error type codes
        Map<String, String> mapErrorTypes = getAllErrorTypes();
        
        /////////////////////////////
        // STEP 2 - Prepare case and oasis case records
        /////////////////////////////
        // for each case param record, create a case
        mapOldCase = new Map<String, case>(); //SUPPORT-5484  If old and new values of regCode,strikeValue,errorTypeLabel are same then store the case in to this
        for(Oasis_Utils.CaseCreateParam cp: listCaseParams)
        {
            // get the installation record
            Net_Installations__c netInstallation = mapInstallation.get(cp.installationId);
             
            // get customer subscription
            List<Customer_Subscription__c> listCS = mapCS.get(netInstallation.installation_id__c);
                                    
            // get customer associated with this subscription
            //Account subscriptionCustomer = mapCUAccount.get(netInstallation.installation_id__c);  
            
            Case c = new Case();
            Oasis_Case__c oc = new Oasis_Case__c();//create new oasis case 
            //SUPPORT-5484 START
            Case oldCase = new Case();
            
            oldCase = mapSubCase.get(cp.installationId);
            if(oldCase != null && oldCase.Status != 'Closed'){
                if(oldCase.Oasis_Case__r.Oasis_Strike__c != cp.strikeValue || oldCase.Oasis_Case__r.Oasis_Inst_Case_Registration_Code__c != cp.regCode || oldCase.Oasis_Case__r.Oasis_Error_type_Label__c !=cp.errorTypeLabel){
            if((cp.regCode == TGP || cp.regCode == TMP || cp.regCode == TFP)
                && (listCS != null && !listCS.isEmpty())
                && netInstallation != null) 
            {
                populateCaseAccountAndAddress(oc, c, netInstallation, listCS, cp);
            } else {
                // if reg code is other can thatn TG, TM or TF
                // set the case origin to Oasis
                c.Origin = CASE_SOURCE_OASIS;
                // If Enkel customer present, set this as the case account
                Customer_Subscription__c cs;
                    cs =  getEnkelCustomerSubscriptionRecord(listCS);
                // if Enkel not present get the organized customer
                if(cs == null)
                    cs = getOrganizedCustomerSubscriptionRecord(listCS);
                
                if(cs!=null) {
                        c.AccountId = cs.Customer__r.id;
                        c.ContactId = cs.Customer__r.PersonContactId;
                        c.Customer_Number__c = cs.Customer_Number__c;
                        oc.Oasis_Subscribed_Package__c = cs.Product__r.Name;                        
                }               
            }              
            if(netInstallation!=null) {
                c.Anlaeg_No_New__c = netInstallation.Cable_Unit_No__c;              
                c.Address_old__c = netInstallation.Address__c;
                
                oc.Oasis_CU_No__c = netInstallation.Cable_Unit_No__c;
                oc.Oasis_Installation__c = netInstallation.Id;
            }
            // copy the account, address and CU reference from the Case to the oasis case record
            oc.Oasis_Customer__c = c.AccountId;                 
            
            // get case dept, product and type/task info based on the reg code
            System.debug('****mapCaseAssignment****'+mapCaseAssignment);
            System.debug('****mapCaseAssignment.get****'+mapCaseAssignment.get(cp.regCode));
            System.debug('****cp****'+cp);
            Oasis_Case_Assignment__c caseInfo = mapCaseAssignment.get(cp.regCode);
            c.Department__c = caseInfo.Case_Dept__c;
            c.Product_2__c = caseInfo.Case_Product__c;
            c.Type_Task__c = caseInfo.Case_Type_Task__c; 
            
            c.Subject = cp.regCode + ': ' + Oasis_utils.formatAddress(netInstallation.Address__r);
            c.Description = cp.comments; 
            system.debug('Case>>>' + c);
            //listNewCases.add(c);
            mapInstallationCase.put(cp.installationId, c);  
            // set Oasis Case Record values          
            oc.Oasis_Inst_Case_Registration_Code__c = cp.regCode;
            if(String.isNotBlank(cp.strikeValue))
                oc.Oasis_Strike__c = cp.strikeValue;
            if(String.isNotBlank(cp.errorTypeLabel)) {
                oc.Oasis_Error_type_Label__c = cp.errorTypeLabel;   
                oc.Oasis_Error_Type_Code__c = mapErrorTypes.get(cp.errorTypeLabel);
            }
            oc.Oasis_AmsId__c = netInstallation.Address__r.external_id__c;            
            oc.Oasis_Comments__c = cp.comments;            
            
            Oasis_User__c oasisUser = getOasisUser(ApexPages.currentPage());
            if(oasisUser != null) {
                oc.Oasis_User__c = oasisUser.Id;
            }
            mapInstallationOasisCase.put(cp.InstallationId, oc);             
            oldCase.Status = 'Closed'; // set old case status to Closed if regcode,errortype and strike are different
             mapOldCase.put(cp.installationId, oldCase);// update old case status to closed
                }else{
                    mapOldCase.put(cp.installationId, oldCase);
                }
            }else{
                System.debug('****cp***'+cp);
            if((cp.regCode == TGP || cp.regCode == TMP || cp.regCode == TFP)
                && (listCS != null && !listCS.isEmpty())
                && netInstallation != null) 
            {
                populateCaseAccountAndAddress(oc, c, netInstallation, listCS, cp);
            } else {
                // if reg code is other can thatn TG, TM or TF
                // set the case origin to Oasis
                c.Origin = CASE_SOURCE_OASIS;
                
                // If Enkel customer present, set this as the case account
                Customer_Subscription__c cs;
                    cs =  getEnkelCustomerSubscriptionRecord(listCS);
                // if Enkel not present get the organized customer
                if(cs == null)
                    cs = getOrganizedCustomerSubscriptionRecord(listCS);
                
                if(cs!=null) {
                        c.AccountId = cs.Customer__r.id;
                        c.ContactId = cs.Customer__r.PersonContactId;
                        c.Customer_Number__c = cs.Customer_Number__c;
                        oc.Oasis_Subscribed_Package__c = cs.Product__r.Name;                        
                }               
            }              
            if(netInstallation!=null) {
                c.Anlaeg_No_New__c = netInstallation.Cable_Unit_No__c;              
                c.Address_old__c = netInstallation.Address__c;
                
                oc.Oasis_CU_No__c = netInstallation.Cable_Unit_No__c;
                oc.Oasis_Installation__c = netInstallation.Id;
            }
            // copy the account, address and CU reference from the Case to the oasis case record
            oc.Oasis_Customer__c = c.AccountId;                 
            // get case dept, product and type/task info based on the reg code
            System.debug('****mapCaseAssignment****'+mapCaseAssignment);
            System.debug('****mapCaseAssignment.get****'+mapCaseAssignment.get(cp.regCode));
            System.debug('****cp****'+cp);
            Oasis_Case_Assignment__c caseInfo = mapCaseAssignment.get(cp.regCode);
            c.Department__c = caseInfo.Case_Dept__c;
            c.Product_2__c = caseInfo.Case_Product__c;
            c.Type_Task__c = caseInfo.Case_Type_Task__c; 
            c.Subject = cp.regCode + ': ' + Oasis_utils.formatAddress(netInstallation.Address__r);
            c.Description = cp.comments; 
            system.debug('Case>>>' + c);
            //listNewCases.add(c);
            mapInstallationCase.put(cp.installationId, c);  
            
            // set Oasis Case Record values
            System.debug('****cp.regCode*******'+cp.regCode); 
            oc.Oasis_Inst_Case_Registration_Code__c = cp.regCode;
            if(String.isNotBlank(cp.strikeValue))
                oc.Oasis_Strike__c = cp.strikeValue;
            if(String.isNotBlank(cp.errorTypeLabel)) {
                oc.Oasis_Error_type_Label__c = cp.errorTypeLabel;   
                oc.Oasis_Error_Type_Code__c = mapErrorTypes.get(cp.errorTypeLabel);
            }
            oc.Oasis_AmsId__c = netInstallation.Address__r.external_id__c;            
            oc.Oasis_Comments__c = cp.comments;            
            
            Oasis_User__c oasisUser = getOasisUser(ApexPages.currentPage());
            if(oasisUser != null) {
                oc.Oasis_User__c = oasisUser.Id;
            }
            mapInstallationOasisCase.put(cp.InstallationId, oc);
          }
          //also update the control date on the installation
            if(netInstallation!=null) {
                net_installations__c n = new net_installations__c();
                n.Id = netInstallation.Id;
                n.control_date__c = Date.today();
                listInstToUpdate.add(n);  
            }  
        }   
        
        /////////////////////////////
        // STEP 3 - Insert oasis case and case records.
        /////////////////////////////
        // insert new oasis case records        
        if(!mapInstallationOasisCase.values().isEmpty())
        {     
            insert mapInstallationOasisCase.values(); 
        } 
        
        // insert the new cases
        if(!mapInstallationCase.values().isEmpty())            
            for(String installationId: mapInstallationOasisCase.keyset())
            {
                Oasis_Case__c oc = mapInstallationOasisCase.get(installationId);
                Case c = mapInstallationCase.get(installationId);
                c.Oasis_Case__c = oc.Id;
            } 
            
            Database.Dmloptions dmo = new Database.Dmloptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;
        if(!mapInstallationCase.values().isEmpty()){
            Database.insert(mapInstallationCase.values(),dmo);
        System.debug('****mapInstallationCase***'+mapInstallationCase);
        //SUPPORT-5484 START
        //To update new case value on old case
        List<case> newcaseList = new List<case>();
        newcaseList = [SELECT Id,CaseNumber,Oasis_Case__c,Oasis_Case__r.Oasis_Installation__c FROM Case WHERE Id=:mapInstallationCase.values()];
            System.debug('****newcaseList****'+newcaseList);
            for(Case c: newcaseList)
            {
                System.debug('****c.Oasis_Case__r.Oasis_Installation__c***'+c.Oasis_Case__r.Oasis_Installation__c);
                Case cOld = mapOldCase.get(c.Oasis_Case__r.Oasis_Installation__c); // get old case
                Case cNew = mapInstallationCase.get(c.Oasis_Case__r.Oasis_Installation__c);
                if(cOld != null && cNew != null){
                    String str = System.label.UpdateCaseInfoMessage;
                    str = str.replace('<T>', c.CaseNumber); // replace <T> with casenumber
                    cOld.Internal_Comments_Close_Reason__c = str;
                    mapOldCase.put(c.Oasis_Case__r.Oasis_Installation__c, cOld);
                }
                
            } 
        }               
            Database.update(mapOldCase.values(),dmo); // update old case status to closed 
        //SUPPORT-5484 END
        // update the control date on the net installation records.
        if(!listInstToUpdate.isEmpty())
            update listInstToUpdate; 
            
               
           
        // requery to get the case Number of the new cases
        if(mapInstallationCase.values().isEmpty()){
            duplicateCaseFlag = true;
        }else if(!mapInstallationCase.values().isEmpty() || !mapOldCase.values().isEmpty()){
            if(Test.isRunningTest()){
                return [select Id, CaseNumber from Case where Id = :mapInstallationCase.values() OR Id = :mapOldCase.values() ORDER BY CreatedDate DESC LIMIT 10];
            }else{
                return [select Id, CaseNumber from Case where Id = :mapInstallationCase.values() OR Id = :mapOldCase.values() ORDER BY CreatedDate DESC];
            }  
        }  
        return null;     
        
        
    } 
    
    // populate the case account and/or address depending on the CU segment, reg code and if O/I 
    // or address is present
    private static void populateCaseAccountAndAddress(Oasis_Case__c oasisCase, Case spocCase, 
                                                                    Net_Installations__c netInstallation, 
                                                                    List<Customer_Subscription__c> listCS,
                                                                    CaseCreateParam cp)  {     
       Cable_Unit__c cu = netInstallation.Cable_Unit__r;                
       // if CU is not null, check segment, reg code and decide if case should be created on 
       // O/I customer or address 
       if(cu != null) 
       {
            Customer_Subscription__c enkelCS;
            Customer_Subscription__c organizedCS;
            if(!listCS.isEmpty()) 
            {
                enkelCS =  getEnkelCustomerSubscriptionRecord(listCS);
                organizedCS = getOrganizedCustomerSubscriptionRecord(listCS);
                
                // if cu segment is 3 or 6, AND reg code = TGP, or TMP or TFP
                // OR
                // if cu segment = 2 or 5 AND reg code = TGP  
                // this is a organized CU           
                if(((cu.Segment__c == '3' || cu.Segment__c == '6') && (cp.regCode == TGP || cp.regCode == TMP || cp.regCode == TFP)) || ((cu.Segment__c == '5' || cu.Segment__c == '2') && cp.regCode == TGP))         
                {
                        // if O customer present, create case on O customer else
                        // create case on Address
                        spocCase.Origin = 'Email - foreningsservice@yousee.dk';
                        if(organizedCS != null) 
                        {
                            oasisCase.Oasis_Subscribed_Package__c = organizedCS.Product__r.Name;
                            spocCase.AccountId = organizedCS.Customer__r.Id;
                            spocCase.Customer_Number__c = organizedCS.Customer_Number__c;
                        } else {
                            spocCase.Address_old__c = netInstallation.Address__c;
                            if(enkelCS != null){
                                oasisCase.Oasis_Subscribed_Package__c = enkelCS.Product__r.Name;
                            }
                        } 
                        return;                     
                }    
                
                // if cu segment is 1 or 4, AND reg code = TGP, or TMP or TFP
                // OR
                // if cu segment = 2 or 5 AND reg code = TMP or TFP
                // this is an individual CU   
                if(((cu.Segment__c == '2' || cu.Segment__c == '5') && (cp.regCode == TMP || cp.regCode == TFP)) || ((cu.Segment__c == '1' || cu.Segment__c == '4') && (cp.regCode == TGP || cp.regCode == TMP || cp.regCode == TFP))) 
                {
                    // if I customer present, create spoc case on I customer else
                    // create case on address
                    spocCase.Origin = 'Email - kundeservice@yousee.dk';
                    if(enkelCS != null)
                    {
                        spocCase.AccountId = enkelCS.customer__r.Id;
                        spocCase.ContactId = enkelCS.customer__r.PersonContactId;
                        spocCase.Customer_Number__c = enkelCS.Customer_Number__c;
                        oasisCase.Oasis_Subscribed_Package__c = enkelCS.Product__r.Name;                    
                    } else {
                        spocCase.Address_old__c = netInstallation.Address__c;
                        if(organizedCS != null){
                            oasisCase.Oasis_Subscribed_Package__c = organizedCS.Product__r.Name;
                        }
                    }
                    return; 
                }          
                
                if(cu.Segment__c == '7' || cu.Segment__c == '8' || cu.Segment__c == '9' || cu.Segment__c == '10' || cu.Segment__c == '99'){
                    spocCase.Origin = CASE_SOURCE_OASIS;
                    if(enkelCS != null){
                        spocCase.AccountId = enkelCS.customer__r.Id;
                        spocCase.ContactId = enkelCS.customer__r.PersonContactId;
                        spocCase.Customer_Number__c = enkelCS.Customer_Number__c;
                        oasisCase.Oasis_Subscribed_Package__c = enkelCS.Product__r.Name;
                        //oasisCase.Customer__c = enkelCS.Customer__r.Id;
                    }else if(organizedCS != null){
                        spocCase.AccountId = organizedCS.Customer__r.Id;
                        spocCase.Customer_Number__c = organizedCS.Customer_Number__c;
                        oasisCase.Oasis_Subscribed_Package__c = organizedCS.Product__r.Name;
                        //oasisCase.Customer__c = organizedCS.Customer__r.Id;
                    }else {
                        spocCase.Address_old__c = netInstallation.Address__c;
                    }
                    return;
                }                               
            }           
         }  
    }
   
   // returns the enkal customer subscription record from the list 
   private static Customer_Subscription__c getEnkelCustomerSubscriptionRecord(List<Customer_Subscription__c> listCS) 
   {        
        if(listCS != null) {
            for(Customer_Subscription__c cs : listCS)
            {
                if(cs.Customer__r.customer_type__c == 'Enkel') {
                    return cs;
                }               
            }
        }
        
        return null;
   }
   
   // returns the organized customer subscription record from the list
   private Static Customer_Subscription__c getOrganizedCustomerSubscriptionRecord(List<Customer_Subscription__c> listCS) 
   {        
        if(listCS != null) {
            for(Customer_Subscription__c cs : listCS)
            {
                if(cs.Customer__r.customer_type__c == 'Organiseret') {
                    return cs;
                }               
            }
        }           
        return null;
   }
    
    // returns the numeric code of the corresponding error type label from the 
    // custom setting.
    public static String getErrorTypeCode(String errorTypeLabel) {
        List<Oasis_Error_Type_Codes__c> listErrorCodes = [select Error_Type_Code__c, Error_Type_Label__c
                                                            from Oasis_Error_Type_Codes__c
                                                            where Error_Type_Label__c= :errorTypeLabel];
        if(!listErrorCodes.isEmpty())
            return listErrorCodes[0].Error_Type_Code__c;
            
        return null;                                                                
    }
    
    // get all numeric error codes and error type labels
    public static Map<String, String> getAllErrorTypes()
    {
        Map<String, String> mapErrorTypes = new Map<String, String>();  // error type label, error type code
        List<Oasis_Error_Type_Codes__c> listErrorCodes = [select Error_Type_Code__c, Error_Type_Label__c
                                                            from Oasis_Error_Type_Codes__c];

        if(!listErrorCodes.isEmpty())
        {
            for(Oasis_Error_Type_Codes__c err : listErrorCodes)
            {
                mapErrorTypes.put(err.Error_Type_Label__c, err.Error_Type_Code__c);
            }
        }  
        
        return mapErrorTypes;                                                       
    }
    
    // returns customer data for the passed installation ids
    public static List<Customer_Installation_Address__c> getInstallationCustomers(Set<String> installationExternalIds)
    {
        return  [select customer__r.FirstName, customer__r.LastName, Installation_id__c,
                                                                     customer__r.Customer_type__c, customer__r.type, 
                                                                     customer__r.Customer_No__c,
                                                                     customer__r.PersonContactId,
                                                                     customer__r.Cable_unit_no__c    
                                                                from customer_installation_address__c 
                                                                where installation_id__c in :installationExternalIds
                                                                and active_sub__c = true];      
    }
     
      
    // this method returns a map of cu no/accountid
    public Static Map<String, String> getAccountInfo(List<Subscription__c> listSubs)
    {       
        // create a set of CU nos
        Set<String> setCUNos = new Set<String>();
        for(Subscription__c s: listSubs) {
             setCUNos.add(s.net_installation__r.Cable_Unit_No__c);          
        }
        system.debug('getAccountInfo>>>setCU>>' + setCUNos);
        
        // get accounts for these cu nos
        List<Account> listCUAccounts = [select Id,cable_unit_no__c  from Account where Cable_Unit_No__c in :setCUNos];
        //create a map of CU and account
        Map<String, String> mapCUAccount = new Map<String, String>();
        for(Account a: listCUAccounts) 
        {
           mapCUAccount.put(a.cable_unit_no__c, a.id); 
        }
        system.debug('getAccountInfo>>>>mapCUAccount>>' + mapCUAccount);
        return mapCUAccount;
    }
    
    public static String formatAddress(Address__c address)
    {
        String formattedAddr = '';
        if(!String.isEmpty(address.Street__c))
           formattedAddr += address.Street__c + ' ';
        if(!String.isEmpty(address.House_No__c))
            formattedAddr += address.House_No__c + ' ';
        if(!String.isEmpty(address.Entrance__c))
           formattedAddr += address.Entrance__c + ' '; 
        if(!String.isEmpty(address.Floor__c))
            formattedAddr += address.Floor__c + ' ';
        if(!String.isEmpty(address.Door_No__c))
           formattedAddr += address.Door_No__c + ' '; 
        if(!String.isEmpty(address.PostCode__c))
           formattedAddr += address.PostCode__c + ' ';    
        if(!String.isEmpty(address.Town__c))
           formattedAddr += address.Town__c + ' ';
           
        return formattedAddr; 
    }
    
    
    // model object used to pass case parameters to 
    // the creator methods
    public Class CaseCreateParam {
        //public String subscriptionId {get; set;}
        public String regCode {get; set;}
        public String comments {get; set;} 
        public String strikeValue {get; set;}
        public String errorTypeLabel {get; set;}   
        public String installationId {get; set;}
    }
    
    
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //   COOKIE UTIL METHODS START HERE
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
   public static String encodeCookieValue(String cookieValue)
    {
        //return EncodingUtil.base64Encode(cookieValue);
        return cookieValue;
    }
    
   public static String decodeCookieValue(String encodedCookieValue)
    {
        //return Encodingutil.base64Decode(encodedCookieValue);\
        return encodedCookieValue;
    } 
    
   public static String getCookieValue(String cookieName)
   {
     Cookie oasisCookie = ApexPages.currentPage().getCookies().get(cookieName);
     if (oasisCookie !=null)
        return oasisCookie.getValue();
    
     return null;
   } 
   
    public static String getCookieValue(String cookieName, PageReference pageRef)
   {
     Cookie oasisCookie = pageRef.getCookies().get(cookieName);
     if (oasisCookie !=null)
        return oasisCookie.getValue();
    
     return null;
   } 
   
   public static void extendCookieTimeOut(String cookieName)
   {
      // we have to change the expire property of the cookie for this
      // the only way to change a property is to create a new cookie 
      Cookie oasisCookie = ApexPages.currentPage().getCookies().get(cookieName);      
      Cookie newCookie = new Cookie(cookieName, oasisCookie.getValue(),null,USER_SESSION_PERIOD,false);
      ApexPages.currentPage().setCookies(new Cookie[]{newCookie});
   }
   
   
   public static void setCookieExpiration(String cookieName){
      // Changed the expire property of the cookie to null to expire the cookie
      // the only way to change a property is to create a new cookie 
      Cookie oasisCookie = ApexPages.currentPage().getCookies().get(cookieName);      
      Cookie newCookie = new Cookie(cookieName, '',null,-1,false);
      ApexPages.currentPage().setCookies(new Cookie[]{newCookie});
   }
   
    
}