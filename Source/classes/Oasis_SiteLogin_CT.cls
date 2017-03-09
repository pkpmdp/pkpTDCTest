/******************************************************************************
*class Oasis_SiteLogin_CT
*
*Controller for the login page. Logs the user in.
*******************************************************************************/ 
public class Oasis_SiteLogin_CT{
    public String retURL {get; set;}
    public String email {get; set;}
    public String password {get; set;}
    public Boolean loggedIn;
    public Boolean loginError {get; set;}
    public String username ='';
    public String passwd = '';
    public String custNumb='';
    public String address='';

    //constructor
    public Oasis_SiteLogin_CT() {
        // store where the user is coming from in the retURl param
        loginError = false;
        // SPOC-2399 ---START

        if(Apexpages.currentPage().getParameters().containsKey('username') && String.isNotBlank(Apexpages.currentPage().getParameters().get('username'))){
            username = Apexpages.currentPage().getParameters().get('username');
        }
        if(Apexpages.currentPage().getParameters().containsKey('password') && String.isNotBlank(Apexpages.currentPage().getParameters().get('password'))){
            passwd = Apexpages.currentPage().getParameters().get('password');
        }
        if(Apexpages.currentPage().getParameters().containsKey('customer') && String.isNotBlank(Apexpages.currentPage().getParameters().get('customer'))){
            custNumb = Apexpages.currentPage().getParameters().get('customer');
        }
        //SPOC-2422 Start
        if(Apexpages.currentPage().getParameters().containsKey('address') && String.isNotBlank(Apexpages.currentPage().getParameters().get('address'))){
            address = Apexpages.currentPage().getParameters().get('address');
        }
        //SPOC-2422 End        
        // SPOC-2399 --- END

    }

    // login handler
    public pageReference login(){       
        Oasis_User__c oUser;
        loggedIn = false;

        // check if the user has been sent here from some other page
        String referrer = Apexpages.currentPage().getParameters().get('retURL');

        // PageReference pageRef = Site.login(email, password, '');
        List<Oasis_User__c> listOUser = [select Oasis_User_Email__c,Oasis_User_Name__c,Id, Oasis_Mid__c 
                                         from Oasis_User__c
                                         where (Oasis_User_Email__c = :email or Oasis_Mid__c = :email)
                                         and Oasis_User_Password__c = :password];

        if(!listOUser.isEmpty()) {
            oUser = listOUser[0];
            loggedIn = true;       
        }


        if(loggedIn == true){
            // on successfull login create cookie
            createLoginCookie(oUser);

            return Page.Oasis_InstallationSearch2;

            /*if(String.isEmpty(referrer))
     return Page.Oasis_InstallationSearch2;
     else
     return new PageReference(Site.getCurrentSiteUrl() + Encodingutil.urlDecode(referrer, 'UTF-8'));*/ 
        }else{
            loginError = true;     
            return null; 
        }

    }

    private void createLoginCookie(Oasis_User__c ou)
    {

        // new Cookie(name, value, path, age, isSecure)
        Cookie loginCookie = new Cookie(Oasis_Utils.OASIS_COOKIE_NAME,Json.serialize(ou),null,Oasis_Utils.USER_SESSION_PERIOD,false);
        system.debug('New login time cookie **** '+loginCookie);
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{loginCookie});
    }

    //doRedirection method to set the page redirection based on url parameters 
    // SPOC-2399 ---START
    public PageReference doRedirection(){
        PageReference pgeRedirect;
        if(String.isNotBlank(username) && String.isNotBlank(passwd)){
            email = username;           
            System.debug('');
            password = passwd;
            System.debug('');
            system.debug('***email and ***password*****' + email + '   '+ password);
            pgeRedirect = login();
            System.debug('');
        }
        list<Customer_Subscription__c> subscriptionList = new list<Customer_Subscription__c>();
        list<Net_Installations__c > netInstallationsList = new list<Net_Installations__c >();
        if(String.isNotBlank(custNumb)){
            system.debug('*******custNumb*****'+ custNumb);
            subscriptionList = [SELECT Customer_Number__c ,Installation_Id__c, Id, Customer__c, Address__c FROM Customer_Subscription__c WHERE Customer_Number__c = :custNumb];
            system.debug('***subscriptionList****' + subscriptionList);
            list<Net_Installations__c> installation = new list<Net_Installations__c>();
            
                if(!subscriptionList.isEmpty() && subscriptionList.size() ==1){
                //list<Net_Installations__c> installation = new list<Net_Installations__c>();
                installation = [SELECT id, Name from Net_Installations__c WHERE INSTALLATION_ID__c =:subscriptionList[0].Installation_Id__c];
                System.debug('installation 87>>> : '+installation);
                
                if(!installation.isEmpty() && installation.size()==1){
                    pgeRedirect = Page.Oasis_InstallationInfo2;
                    pgeRedirect.getParameters().put('id',installation[0].id);
                    system.debug('***installation 45****' + installation);
                    system.debug('***pgeRedirect1****' + pgeRedirect);
                }
                
                
            }
            else if(!subscriptionList.isEmpty() && subscriptionList.size()>1){
                
                installation = [SELECT id, Name, Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c WHERE INSTALLATION_ID__c =:subscriptionList[0].Installation_Id__c];
                system.debug('***installation236****' + installation);
                
                if(!installation.isEmpty()){
                    pgeRedirect = Page.Oasis_InstallationSearch2;
                    pgeRedirect.getParameters().put('custNumb',custNumb);
                    pgeRedirect.getParameters().put('cunum',installation[0].Cable_Unit__r.Cable_Unit_No__c);
                    system.debug('***pgeRedirect2****' + pgeRedirect);
                    
                }
            }
            else{
                if(!subscriptionList.isEmpty() && String.isNotBlank(custNumb)){
                    installation = [SELECT id, Name, Cable_Unit__r.Cable_Unit_No__c from Net_Installations__c WHERE INSTALLATION_ID__c =:subscriptionList[0].Installation_Id__c];
                    system.debug('***installation#****' + installation);
                    if(!installation.isEmpty()){
                        pgeRedirect = Page.Oasis_InstallationSearch2;
                        pgeRedirect.getParameters().put('cunum',installation[0].Cable_Unit__r.Cable_Unit_No__c);
                        system.debug('***pgeRedirect3****' + pgeRedirect);
                    }
                    
                    
                }
            }
        
            
        }
        //-----------------------------------START SPOC-2422 --------------------------------------------------
        if(String.isNotBlank(address)){
            system.debug('*******address*****'+ address);
     
            netInstallationsList= [SELECT Id ,Name,Address__r.External_Id__c FROM Net_Installations__c WHERE Address__r.External_Id__c= :address];
        
                
                if(!netInstallationsList.isEmpty() && netInstallationsList.size()==1){
                    pgeRedirect = Page.Oasis_InstallationInfo2;
                    pgeRedirect.getParameters().put('id',netInstallationsList[0].id);
                   
                }
                else  if(!netInstallationsList.isEmpty() && netInstallationsList.size()>1) {
                    pgeRedirect = Page.Oasis_InstallationSearch2;
                    pgeRedirect.getParameters().put('address',netInstallationsList[0].Address__r.External_Id__c);
                    
            
            }
        }
            
        //------------------------------END SPOC-2422----------------------------------------------------
        
        
         
        return pgeRedirect;
    }
     // SPOC-2399 ---END

}