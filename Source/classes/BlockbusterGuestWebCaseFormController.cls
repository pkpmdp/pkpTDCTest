public without sharing class BlockbusterGuestWebCaseFormController {

    public String stylsheet { get; set; }

    public PageReference description() {
        return null;
    }

    public PageReference selectHvilken() {
        return null;
    }

    public String test{get; set;}
    public String name{get; set;}
    public spoc2019cmp_cls objwrap1{get;set;}
    //public String subject {get; set;}
    public String description {get; set;}
    public String filename {get; set;}
    public Blob filebody {get; set;}
    public String email {get; set;}
    public String origin {get; set;}
    public String department {get; set;}
    public String product {get; set;}
    public String Blockbuster_system_information {get; set;}
    public List<SelectOption> HvadList {get;set;}
    public String selectHvad {get;set;}
    public User user {get;set;}
    public String des{get;set;}
    public boolean Incoming{get;set;}
    public String Device_Name {get;set;}
    public String Platform {get;set;}
  
    public String selectHvilken {get;set;}
    public String selectHvilken1 {get;set;}
    public Boolean triggerAutoResponseEmail {get; set;}
   
    public String returnUrl{get;set;}  //to store the url to return to the same page agn
    public String returnUrl2{get;set;}
    
    public String selectBrowser{get;set;}
    public String selectOpSys{get;set;}
    public String selectProduct{get;set;}
    public String strEmail{get;set;}
    public String subject{get;set;}
    public String BBType{get;set;}
    public String Device{get;set;}
    public String selectPlatform{get;set;}
    
    public List<SelectOption>listPlatform{get;set;}
    public List<SelectOption>listBrowser{get;set;}
    public List<SelectOption>listOpSys{get;set;}
    public List<SelectOption>listProd{get;set;}
    public List<SelectOption>listBBType{get;set;}
    
    public Boolean showBrowser{get;set;}
    public Boolean showOS{get;set;}
    public Boolean showProd{get;set;}
    public Boolean showEmail{get;set;}
    public Boolean showSubject{get;set;}
    public Boolean showFile{get;set;}
    public Boolean showDevice{get;set;}
    public Boolean showBBType{get;set;}
    public String fullURL;
    

public Boolean errormessage{get; set;} //Added for BB-1230
    public String errormessageVal{get; set;}
   Final String emailregex ='^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; //Added for email validation BB-1543
    //Final String emailregex ='/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i';
    public BlockbusterGuestWebCaseFormController(){
    fullURL = ApexPages.currentPage().getParameters().get('email');
    strEmail = fullURL;
    String firstname =ApexPages.currentPage().getParameters().get('firstname');
    String lastname=ApexPages.currentPage().getParameters().get('lastname');
    String phone=ApexPages.currentPage().getParameters().get('phone');
    String customerno=ApexPages.currentPage().getParameters().get('customerno');
    String personid=ApexPages.currentPage().getParameters().get('personid');
    String facebookuserid=ApexPages.currentPage().getParameters().get('facebookuserid');
    String orderid=ApexPages.currentPage().getParameters().get('order_id');
    String browserplatform=ApexPages.currentPage().getParameters().get('browser_platform');
    Blockbuster_system_information ='Navn:'+firstname + lastname + '\r\n' + 'E-mail:'+fullURL+ '\r\n' + 'Telefon:' +phone+'\r\n'+'Kundenummer:'+customerno+'\r\n'+'Person ID:'+personid+'\r\n'+'Facebook ID:'+facebookuserid+'\r\n'+'Order ID:'+orderid+'\r\n'+'Browser:'+browserplatform;
        system.debug('device name ***'+'*****'+''+Device_Name);
    system.debug('blockbustersysteminfo-----------------'+Blockbuster_system_information);
    system.debug('email@@@'+fullURL);
    test = fullURL ;
    stylsheet = ApexPages.currentPage().getParameters().get('stylesheet');
    system.debug('$$stylesheet$'+stylsheet);
    department = 'Blockbuster';
    origin = 'Web - Blockbuster';
    
    returnUrl2=ApexPages.currentPage().getUrl(); 
    errormessage=false; //Added for BB1230
    
    listPlatform = new List<SelectOption>();
    listBrowser  = new List<SelectOption>();
    listOpSys = new List<SelectOption>();
    listProd = new List<SelectOption>();
    listBBType = new List<SelectOption>();
    
    showBrowser = false;
    showOS = false;
    showProd = false;
    showEmail = false;
    showSubject = false;
    showFile = false;
    showDevice = false;
    showBBType = false;
    
    
    listPlatform = BBW2CPicklistValues.getPlatform();
        objwrap1 = new spoc2019cmp_cls();
       // SYstem.debug('*****-->'+objwrap1.listAudVidMac);
    }
    
    public PageReference getChildValue()
    {
        if(selectPlatform == 'PC/MAC' || selectPlatform == 'Playstation 4' || selectPlatform == 'Playstation 3')
        {
            objwrap1.listAudVidMac =  BBW2CPicklistValues.getAudVidMac();
            objwrap1.listIntSupplMac = BBW2CPicklistValues.getIntSupplMac();
            objwrap1.listIntConTypeMac = BBW2CPicklistValues.getIntConTypeMac();
        }
        if(selectPlatform == 'iPhone/iPad' || selectPlatform == 'Android mobil/tablet')
        {
            objwrap1.listAudVidMac =  BBW2CPicklistValues.getAudVidMac();
            objwrap1.listIntConTypeMac = BBW2CPicklistValues.getIntConTypeIphone(); 
        }
        if(selectPlatform == 'Smart TV - LG' || selectPlatform == 'Smart TV - Panasonic' || selectPlatform == 'Smart TV - Philips' || selectPlatform == 'Smart TV - Samsung' || selectPlatform == 'Smart TV - Sony')
        {
            objwrap1.listAudVidMac =  BBW2CPicklistValues.getAudVidMac();
            objwrap1.listIntSupplMac = BBW2CPicklistValues.getIntSupplTV();
            objwrap1.listIntConTypeMac = BBW2CPicklistValues.getIntConTypeMac();
            objwrap1.listSmtTVUpd = BBW2CPicklistValues.getSmtTVUpdTV();
        } 
        return null;
    }
    
    public pagereference getPicklistValues(){
        if(selectPlatform == 'PC/MAC'){
            listBrowser = BBW2CPicklistValues.getBrowserForPCMac();
            listOpSys = BBW2CPicklistValues.getOSForPCMac();
            listProd = BBW2CPicklistValues.getProductForPCMac();
            showBrowser = true;
            showOS = true;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true; 
            showBBType = false;
            showDevice = false;
            System.debug('***-->'+objwrap1.listAudVidMac);
        }
        if(selectPlatform == 'iPhone/iPad'){
            
            listProd = BBW2CPicklistValues.getProductForIPhone();
            listBBType = BBW2CPicklistValues.getBBTypeForIpad();
            showBrowser = false;
            showOS = false;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true;
            showBBType = true;
            showDevice = true;
        }
        if(selectPlatform == 'Android mobil/tablet'){
            listProd = BBW2CPicklistValues.getProductForAndroid();
            listBBType = BBW2CPicklistValues.getBBTypeForIpad();
            showBrowser = false;
            showOS = false;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true;
            showBBType = true;
            showDevice = true;
        }
        if(selectPlatform == 'Playstation 3'){
            
            listProd = BBW2CPicklistValues.getProductForPS3();          
            showBrowser = false;
            showOS = false;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true;
            showBBType = false;
            showDevice = false;
        }
        if(selectPlatform == 'Playstation 4'){
            listProd = BBW2CPicklistValues.getProductForPS3();          
            showBrowser = false;
            showOS = false;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true;
            showBBType = false;
            showDevice = false;
        }
        if(selectPlatform == 'Smart TV - LG' || selectPlatform == 'Smart TV - Panasonic' || selectPlatform == 'Smart TV - Philips' || selectPlatform == 'Smart TV - Samsung' || selectPlatform == 'Smart TV - Sony'){
            listProd = BBW2CPicklistValues.getProductForPS3();          
            showBrowser = false;
            showOS = false;
            showProd = true;
            showEmail = true;
            showSubject = true;
            showFile = true;
            showBBType = false;
            showDevice = false;
        }
        clearvalues();
        return null;
    }
   
    public List<SelectOption> getHvadOptions() {
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption ('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Film eller serier','Film eller serier'));
        Options.add(new SelectOption('Betaling','Betaling'));
        Options.add(new SelectOption('Min profil','Min profil'));
        Options.add(new SelectOption('Andet','Andet'));

    return Options;
     
            
    }
    
    public List<SelectOption> getHvilkenOptions() {
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('PC','PC'));
        Options.add(new SelectOption('Mac ','Mac '));
        Options.add(new SelectOption('iPhone','iPhone'));
        Options.add(new SelectOption('iPad','iPad'));
        Options.add(new SelectOption('Android Mobil','Android Mobil'));
        Options.add(new SelectOption('Android Tablet','Android Tablet'));
        Options.add(new SelectOption('Samsung Smart TV','Samsung Smart TV'));
        Options.add(new SelectOption('Philips Smart TV','Philips Smart TV')); 
        Options.add(new SelectOption('LG Smart TV','LG Smart TV'));
        Options.add(new SelectOption('Panasonic Smart TV','Panasonic Smart TV'));
        Options.add(new SelectOption('Sony Smart TV','Sony Smart TV'));
        Options.add(new SelectOption('Playstation 3','Playstation 3'));
        Options.add(new SelectOption('Playstation 4','Playstation 4'));
        return Options;
    }
    
     public List<SelectOption> getHvilken1Options() {
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Internet Explorer 8.0','Internet Explorer 8.0'));
        //Options.add(new SelectOption('Mac ','Mac '));
        Options.add(new SelectOption('Internet Explorer 9.0','Internet Explorer 9.0'));
        Options.add(new SelectOption('Internet Explorer 10','Internet Explorer 10'));
        Options.add(new SelectOption('Internet Explorer 11','Internet Explorer 11'));
        Options.add(new SelectOption('Chrome ','Chrome '));
        Options.add(new SelectOption('Mozilla','Mozilla'));
        Options.add(new SelectOption('Firefox','Firefox'));
        Options.add(new SelectOption('Safari','Safari'));
        Options.add(new SelectOption('Andet','Andet')); 
        return Options;
    }
    
public void emailid()
{
        user = [select email  from User where Id = :UserInfo.getUserId()];
           system.debug('*****'+user.email);      
                  }
    
    public PageReference doSubmit() {
        String selectHvilkentemp,selectHvilken1temp,selectHvadtemp,descriptiontemp,product2c;
        department = 'Blockbuster';
        origin = 'Web - Blockbuster';
    
        String res = validate();
        system.debug('res=='+res);
        if(res != null && res != '')
        {
            system.debug('inside res==');
            errormessage=true;
             errormessageVal = res;
             return null;
        }
        else{
            errormessage=false;
        }
        
       /* if(selectHvilken == null){
            selectHvilkentemp ='None';
        } else{
            selectHvilkentemp = selectHvilken; 
        }
        if(selectHvilken1== null){
            selectHvilken1temp ='None';
        } else{
            selectHvilken1temp = selectHvilken1; 
        }*/
        if(selectProduct== null){
            selectHvadtemp ='Blockbuster henvendelse - None';
        } else{
            selectHvadtemp = 'Blockbuster henvendelse - '+selectProduct; 
        }
       /* if(selectHvad =='Film eller serier'){
            product2c='Content';
        } else if(selectHvad =='Betaling'){
            product2c='Betaling';
        } else if(selectHvad =='Min profil'){
            product2c='Profil';
        }else if(selectHvad =='Andet'){
            product2c='Andet';
        }*/
    
      /*  System.debug('Hvilken platform oplever du fejlen på:  platform:' + selectHvilken  );
        System.debug('Hvilken browser bruger du:   browser:' + selectHvilken  );
        System.debug('Subject ' + selectHvad);
        //description = description + 'Platform:' + selectHvilken + 'Browser:' +selectHvilken1;*/
        system.debug('***-->'+selectBrowser);
        descriptiontemp = subject + '\r\n' +'Navn: '+name + '\r\n' + 'Platform: ' + selectPlatform + '\r\n' + 'Browser: ' + selectBrowser;
        //create a new case
        
        Case basket = new Case(Subject = selectHvadtemp, 
                               Description = descriptiontemp, 
                               Email__c = strEmail,
                               Origin = origin, 
                               Department__c = department, 
                               Product_2__c = selectProduct,
                               Blockbuster_system_information__c = Blockbuster_system_information,
                               Device_Name__c=selectBrowser,
                               Platform__c= selectPlatform);
        
        //Case basket = new Case(Subject = email, Description = description);
        //system.debug('Subject44'+subject+'description$$$'+description+'Email444'+test+'Origin$444'+origin+'department$$'+department+'selecthvvas$$$'+selectHvad+'Blockbustersysteminfo$$'+Blockbuster_system_information);
        basket.BBW2C_Operating_System__c = selectOpSys;
        basket.BBW2C_Movie__c = objWrap1.selectMovie;
        basket.BBW2C_Video_Audio__c = objwrap1.selectVidAud;
        basket.BBW2C_Postal_Code__c = objwrap1.strPostnr;
        basket.BBW2C_Internet_supplier__c = objwrap1.strInterSupp;
        basket.BBW2C_Broadband_speed__c = objwrap1.strBBSpeed;
        basket.BBW2C_Time_of_incident_in_the_movie__c = objwrap1.TimeOfInciMv;
        basket.BBW2C_Time_of_incident_on_the_day__c = objwrap1.TimeOfInciday;
        basket.BBW2C_IP_Address__c = objwrap1.strIp;
        basket.BBW2C_Internet_connection_type__c = objwrap1.selectIntCnType;
        basket.BBW2C_Blockbuster_type__c = BBType;
        basket.BBW2C_SmartTV_updated__c = objwrap1.selectSmtTVUpd;
        basket.BBW2C_Device__c = device;
       
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        basket.Origin = origin;
        //dmlOpts.EmailHeader.triggerAutoResponseEmail = true; 
        system.debug('trigger value*************'+dmlOpts.EmailHeader.triggerAutoResponseEmail);
        basket.setOptions(dmlOpts);
      
        
       /* Database.DMLOptions opts = new Database.DMLOptions(); 
        opts.EmailHeader.triggerAutoResponseEmail = true; 
        Case checkInCase = new Case(); 
        //checkInCase.OwnerId = u.Id; 
       // checkInCase.ContactId = primaryContact.Id; 
        checkInCase.setOptions(opts); 
        insert checkInCase;*/
 

        insert basket;
        insert new EmailMessage  (Status = '2',Incoming=true,FromAddress = strEmail, ParentId = basket.ID, ToAddress = 'kundeservice@blockbuster.dk', Subject = selectHvadtemp, TextBody = descriptiontemp ,MessageDate = DateTime.now()); 
      
        //basket.ContactEmail = 'sneha.salunkhe@capgemini.com';
        //update basket;
        system.debug('Basket *** '+basket);
        //associate the attachment

        if(fileBody != null && fileName != null) 
        {       
            insert new Attachment(Name = filename, Body = filebody, ParentId = basket.Id);
            filebody = null;
        }
        //PageReference pr = new PageReference('/apex/BlockBusterCaseSubmittedPage?returl='+returnUrl);
        System.debug('URL for the page is ' +returnUrl2 );
        
        PageReference pr = new PageReference('/apex/BlockBusterCaseSubmittedPage?'+returnUrl2);
        //PageReference pr = new PageReference(returnUrl2);
        pr.setRedirect(true);
        return pr;
        
    }
    
    public String validate()
    {
        String str;
        if(name == '' || name == null)
        {
            str = 'Navn kan ikke være tom';
             return str;
        }
        else if(selectPlatform == '' || selectPlatform == null)
        {
             
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'vælge en værdi'));
             str = 'platform kan ikke være tom';
             return str;
        }
        else if(selectPlatform == 'PC/MAC' && (selectBrowser == '' || selectBrowser == null))
        {
            
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'vælge en værdi'));
             str = 'browser kan ikke være tom';
             return str;
        }
        else if(selectPlatform == 'PC/MAC' && (selectOpSys == '' || selectOpSys == null))
        {
                
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'vælge en værdi'));
             str = 'styresystem kan ikke være tom';
             return str;
        }
        else if((selectPlatform == 'iPhone/iPad' || selectPlatform == 'Android mobil/tablet') && (Device == '' || Device == null))
        {
            str = 'enhed kan ikke være tom';
             return str;
        }
        else if((selectPlatform == 'iPhone/iPad' || selectPlatform == 'Android mobil/tablet') && (BBType == '' || BBType == null))
        {
            str = 'blockbuster type kan ikke være tom';
             return str;
        }
        else if(selectProduct == '' || selectProduct == null)
        {
            
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'vælge en værdi'));
             str = 'din henvendelse kan ikke være tom';
             return str;
        }
       else if(subject == null || subject =='') 
        {
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Value kræves mailadresse felt'));
        str = 'Din besked kan ikke være tom';
        return str;
        }  
        else 
        {
        if(strEmail !=null && strEmail !=''){
            if(Pattern.matches(emailregex, strEmail)){
                system.debug('inside matches');
                
            
            } else{
                
                System.debug('***-->Error'+strEmail);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''));
                str = 'Emailadressen er ikke gyldig';
                return str;
            }
        }
        else{
            str = 'Value kræves mailadresse felt';
            return str;
        }
            
        if(selectProduct == 'Afspilning' || selectProduct == 'Afspilning via app' || selectProduct == 'Afspilning via Airplay' || selectProduct == 'Afspilning via ChromeCast')
        {
            if(objWrap1.selectMovie == null || objWrap1.selectMovie == '')
            {
                 str = 'film/trailer/preview henvendelsen kan ikke være tom';
                 return str;
            }
            else if(objwrap1.selectVidAud =='' || objwrap1.selectVidAud == null)
            {
                str = 'video lyd kan ikke være tom';
                 return str;
            }
            /*else if((selectPlatform != 'iPhone/iPad' && selectPlatform != 'Android mobil/tablet') && (objwrap1.strPostnr == '' || objwrap1.strPostnr == null))
            {
               str = 'Indtast dit postnummer med fire cifre';
                    return str;
               
                
                
            }*/
            else if((selectPlatform != 'iPhone/iPad' && selectPlatform != 'Android mobil/tablet') && (objwrap1.strInterSupp == '' || objwrap1.strInterSupp == null))
            {
                str = 'internetudbyder kan ikke være tom';
                return str;
            }
          /*  else if((selectPlatform != 'iPhone/iPad' && selectPlatform != 'Android mobil/tablet') && (objwrap1.strBBSpeed == '' || objwrap1.strBBSpeed == null))
            {
                str = 'bredbånds hastighed kan ikke være tom';
                return str;
            }*/
            else if(objwrap1.TimeOfInciMv == '' || objwrap1.TimeOfInciMv == null)
            {
                 str = 'Tidspunkt for hændelse i filmen kan ikke være tom';
                return str;
            }
            else if(objwrap1.TimeOfInciday == '' || objwrap1.TimeOfInciday == null)
            {
                str = 'Tidspunkt for hændelse på dagen kan ikke være tom';
                return str;
            }
         /*   else if((selectPlatform != 'iPhone/iPad' && selectPlatform != 'Android mobil/tablet') && (objwrap1.strIp == '' || objwrap1.strIp == null))
            {
                str = 'din IP kan ikke være tom';
                return str;
            }*/
            else if(objwrap1.selectIntCnType == '' || objwrap1.selectIntCnType == null)
            {
                str = 'Internetforbindelse typen kan ikke være tom';
                return str;
            }
            else if(selectPlatform == 'Smart TV' && (objwrap1.selectSmtTVUpd == '' || objwrap1.selectSmtTVUpd == null))
            {
                str = 'Smart TV’s firmware kan ikke være tom';
                return str;
            }
            else
            {
                if(selectPlatform != 'iPhone/iPad' && selectPlatform != 'Android mobil/tablet')
                {
                    if((objwrap1.strPostnr == '' || objwrap1.strPostnr == null))
                    {
                        str = 'Indtast dit postnummer med fire cifre';
                        return str;
                    }
                    else if(objwrap1.strPostnr.length() > 4)
                    {
                        str = 'Indtastet postnummer er ikke gyldig';
                        return str;
                    }
                    return str;
                    
                }
            }
        }
     }
    return null;
    }
    
    
    public void clearvalues()
    {
        description = '';
        filename  = '';
        email  = '';
        origin  = '';
        department = '';
        product = '';
        Blockbuster_system_information = '';
        Platform  = '';
        selectProduct = '';
        selectOpSys = '';
        //strEmail = '';
        subject = '';
        Device = '';
        BBType = '';
        selectBrowser = '';
        objwrap1 = new spoc2019cmp_cls();
    }
    
}