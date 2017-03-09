/*
*   Oasis_InstallationInfo_CTE 
*
*   This class is the controller for the Oasis Installation info page. 
*   This page display the installation details for the net installation id
*   passed to the page. 
*   User can register a SPOC Case from this page. 
*/

global without sharing class Oasis_InstallationInfo_CTE {
    public Account customer {get; set;}                                             // customer information    
    public Net_Installations__c installation {get; set;}                        // installation
    public String regCode {get; set;}                                               // registration code value
    public String comments {get; set;}                                              // comments
    public Case oasisCase {get; set;}                                               // Case present for this installation
    public String strikeValue {get; set;}                                           // strike value
    public String errorTypeLabel {get; set;}                                        // error type label
    public Boolean lockedCableUnit {get;set;}                                       // True value specified that cable unit is locked
    public Boolean isNetInstallationInMovement {get;set;}                           // True value specified that Net Installation in Movement   
    public String createdCaseNumber {get; set;}
    // case number of the case created
    public List<Customer_Subscription__c> listSubscriptionCustomers {get; set;}     // customers present at this address
    public String installationAddress {get; set;}
    public List<ViewModel> lst_customerSubscription{get;set;}
    public Boolean isBlandSelvProduct {get; set;}
    public Map<String, Case> mapCase;
    public Boolean duplicateCase{get; set;}
    public List<account> accId{get;set;}
    public static String getPICKLIST_OPTION_SELECT(){
        return Oasis_Utils.PICKLIST_OPTION_SELECT;
    }
    public Oasis_InstallationInfo_CTE() 
    {               
        // get the subscription id from the querystring
        String id = ApexPages.currentPage().getParameters().get('id');
        //odc is duplicate case flag and ocn is createdcasenumber
        //SUPPORT-5484 START
        if(ApexPages.currentPage().getParameters().get('odc')!= null && EncodingUtil.base64Decode(ApexPages.currentPage().getParameters().get('odc')).toString()=='true')
            duplicateCase = true;
        else
            duplicateCase = false;
        string str = ApexPages.currentPage().getParameters().get('ocn');
        if(str != null)
            createdCaseNumber = EncodingUtil.base64Decode(str).toString();
        //SUPPORT-5484 END
        // get the installation details
        List<Net_Installations__c> listInstallations = Oasis_Utils.getInstallationDetails(new Set<String>{id});
        System.debug('------listInstallations--------------'+listInstallations);
        if(!listInstallations.isEmpty()) {
            installation = listInstallations[0];
            if(listInstallations[0].Cable_Unit__r.Oasis_Lock__c == '1'){
                lockedCableUnit = true;
            } 
            if(listInstallations[0].Move_Flag__c==true)
            {
                isNetInstallationInMovement=true;
            }           
        }   
        // get customer subscription information for this installation 
        listSubscriptionCustomers = Oasis_Utils.getCustomerSubscriptionsForInstallationId(new Set<String>{installation.INSTALLATION_ID__c});
        lst_customerSubscription=new List<ViewModel>();
        System.debug('listSubscriptionCustomers<<<<<<<'+listSubscriptionCustomers);
        for(Customer_Subscription__c c : listSubscriptionCustomers){
            ViewModel v=new ViewModel();
            v.csObj=c;
            v.isBlandSelv=false;
            isBlandSelvProduct=false;
            if(String.isNotBlank(c.Product__r.Name)){
                if((c.Product__r.Name).contains('Bland Selv')){
                    v.isBlandSelv=true;
                    isBlandSelvProduct=true;
                }
            }
            lst_customerSubscription.add(v);
            system.debug('##isBlandSelvProduct: '+isBlandSelvProduct);
            system.debug('##cust subscripiton: '+lst_customerSubscription);
        } 
        
        // check if there is a case open for this installation
        //Map<String, Case> mapCase =  Oasis_Utils.getInstallationCases(new Set<String>{installation.id});
        mapCase =  Oasis_Utils.getInstallationCases(new Set<String>{installation.id});
        System.debug('-----mapCase----'+mapCase);
        oasisCase = mapCase.get(installation.id);
        //createdCaseNumber = oasisCase.CaseNumber;
        // get the installation address
        if(installation.Address__r != null) {
            installationAddress =  Oasis_Utils.formatAddress(installation.Address__r);
        }   
    }   
    
    // returns a list of registration codes for CU
    public List<SelectOption> getListInstRegCodes()
    {
        return Oasis_Utils.getInstallationRegistrationCodes();   
    }
    
    // return a list of strike values
    public List<SelectOption> getListStrikeValues()
    {
        return Oasis_Utils.getStrikeValues();       
    }  
    
    public List<SelectOption> getListErrorTypeLabels()
    {
        return Oasis_Utils.getErrorTypeLabels();
    }
    
    public PageReference registerCase()
    {
        Oasis_Utils.CaseCreateParam c = new  Oasis_Utils.CaseCreateParam();
        c.installationId = installation.Id;
        c.regCode = regCode;
        c.comments = comments;
        
        if(strikeValue != Oasis_Utils.PICKLIST_OPTION_SELECT)
            c.strikeValue = strikeValue;
        if(errorTypeLabel != Oasis_Utils.PICKLIST_OPTION_SELECT)
            c.errorTypeLabel = errorTypeLabel;  
        system.debug('Case Param>>>' + c);
        mapCase = Oasis_Utils.getInstallationCases(new Set<String>{c.installationId});
        system.debug('mapCase *******'+mapCase);
        List<Case> listCase = Oasis_Utils.createCaseForInstallation(new List<Oasis_Utils.CaseCreateParam>{c},mapCase);
        // there will be only one case here
        System.debug('****listCase***'+listCase);
        //SUPPORt-5484 START
        if (listCase != null){
            if(!listCase.isEmpty()){
                duplicateCase = false; //set duplicate case to false
                createdCaseNumber = listCase[0].caseNumber;
            }
        }else{
            System.debug('***Oasis_Utils.duplicateCaseFlag;***'+Oasis_Utils.duplicateCaseFlag);
            duplicateCase = Oasis_Utils.duplicateCaseFlag; // set duplicate case to true.
        }
        System.debug('createdCaseNumber----'+createdCaseNumber);
        System.debug('duplicateCase----'+duplicateCase);
        //SUPPORt-5484 END
        // refetch case details 
        mapCase =  Oasis_Utils.getInstallationCases(new Set<String>{installation.id});
        system.debug('mapCase >>>>>'+mapCase.size());
        oasisCase = mapCase.get(installation.id); 
        system.debug('oasisCase >>>>>'+oasisCase);
        System.debug('oasisCase.CaseNumber>>>+++'+oasisCase.CaseNumber);
        createdCaseNumber = oasisCase.CaseNumber;
        regCode='';
        comments='';
        strikeValue='';
        errorTypeLabel='';
        // SUPPORT-5484 START
        PageReference pge = ApexPages.currentPage();
        String id = pge.getParameters().get('id');
        pge.getParameters().clear(); // to clear the viewstate version from URL
        pge.setRedirect(true);
        // set parameter on pages to show the case  succesful creation or duplicate message
        pge.getParameters().put('id',id);
        pge.getParameters().put('ocn',EncodingUtil.base64Encode(Blob.valueOf(createdCaseNumber)));
        pge.getParameters().put('odc',EncodingUtil.base64Encode(Blob.valueOf(duplicateCase+'')));
        return pge;
        // SUPPORT-5484 END
    }
    
    public class ViewModel{ 
        public Customer_Subscription__c csObj{get;set;}
        public boolean isBlandSelv{get;set;}
    } 
}