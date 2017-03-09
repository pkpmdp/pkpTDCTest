public class Yousee13DeltageIndblikController {
  
    public boolean show{get;set;}
    public CampaignMember cm{get;set;}
    public String campaignID;
    public String cmid;
    public boolean showPermission{get;set;}
    public boolean showBus{get;set;}
    public String region{get;set;} 
    public String accid{get;set;} 
    public String cuid{get;set;}
    public String cuName{get;set;}
    public String customerName{get;set;}
    public String customerNumber{get;set;}
    public List<CampaignMember> emailList{get;set;}
    public String emailBody{get;set;} 
    public String lgUserEmail{get;set;}
    public String lgUserMobile{get;set;}
    public boolean lgUserPermission{get;set;}
    public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');
    public String yousee13LeadRecordType = yousee13.Lead_RecordType__c;
   
    public Yousee13DeltageIndblikController (ApexPages.StandardController controller) {
        accid = ApexPages.currentPage().getParameters().get('acc');
        cmid = ApexPages.currentPage().getParameters().get('cmid');
        region = ApexPages.currentPage().getParameters().get('loc');
        if(cmid != null && cmid != '') {
            sortCampaignMember(cmid);
        }
        Account acc = [select a.type, a.Name, a.Customer_No__c, a.Cable_Unit_No__c, a.Cable_Unit_Name__c from account a where a.id = :accid limit 1];
        cuid = acc.Cable_Unit_No__c;
        cuName = acc.Cable_Unit_Name__c;
        customerName = acc.Name;
        customerNumber = acc.Customer_No__c;
    }
    
    /*********************************existing contactPerson begin**********************/
    /** CM stands for login user's campaignmember
        if login user has already permission, then the permission field will be hide
        if login user comes from Jylland /Fyn, then provide the transportation
    **/
    private void sortCampaignMember(String cmid) {
        cm = [Select c.Campaign.id,c.contact.Permission__c, c.contact.name, c.contact.mobilephone, c.HasResponded, c.Deltage__c, c.Show__c, c.Bus__c, c.contact.email, c.contact.firstname, c.contact.lastname, c.ContactId From CampaignMember c where c.id=:cmid];
                System.debug('***Wen LoginUser'+cm.contact.name);
        campaignID = cm.Campaign.id;
        lgUserEmail = cm.Contact.email;
        lgUserMobile = cm.Contact.mobilephone;
        lgUserPermission = cm.contact.Permission__c;
        if(cm.contact.permission__c == true)
            showPermission = false;
        else
            showPermission = true;
        if(region == 'jf')
            showBus = true;
        else
            showBus = false;
    }    
    
    /**Login user's validation rule
    **/
    public boolean HasValidationErrorsForContact(){
        boolean errors = false;
        if(cm.Deltage__c == true) {
            errors = validateContactCM(cm);
            if(errors){
            	return true;
            }
        } 
        else {
            if(!showBus){
                if(cm.show__c == true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du har valgt at deltage i tv-show. For at tilmelde dig skal du også sætte flueben i feltet Deltager i YouSee LIVE´13.'));
                    return true;
                }
            }
            else{
                if(cm.show__c == true && cm.Bus__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du har valgt at deltage i tv-show. For at tilmelde dig skal du også sætte flueben i feltet Deltager i YouSee LIVE´13.'));
                    return true;
                }
                if(cm.show__c == false && cm.Bus__c != null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du kan kun udfylde ‘Ønsker bustransport’, hvis du skal deltage I YouSee LIVE’13.'));
                    return true;
                }
                if(cm.show__c == true && cm.Bus__c != null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du kan kun udfylde ‘Deltager i tv-show' + ' og ‘Ønsker bustransport’, hvis du skal deltage I YouSee LIVE’13'));
                    return true;
                }   
            }
        } 
        return errors;
    } 
    
    public boolean validateContactCM(CampaignMember cmp) {
        boolean errors = false;
        if(lgUserMobile == null || lgUserMobile == '') {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste ' +cmp.contact.firstname + ' \'s mobilnr.'));
                errors = true;
            }        
            if(lgUserMobile != null && lgUserMobile != '' && lgUserMobile.length() < 8 ) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning, cmp.contact.firstname + ' \'s Mobilnummer skal have mindst 8 cifre.'));
                errors = true;
            }
            if(lgUserEmail == null || lgUserEmail == ''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste '+cmp.contact.firstname+ ' \'s e-mail adresse.'));
                errors = true;
            } else {
                String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+'; 
                Boolean formatOK = Pattern.matches(pat, lgUserEmail);
                if(formatOK == false){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste en gyldig e-mail adresse for'+cmp.contact.firstname));
                    errors = true;   
                }
            }
        return errors;
    } 

        /**
        savePage: Existing Contact Permisions
        **/
    public PageReference saveRegistration() {
        
        if(HasValidationErrorsForContact()){
            return null;
        }    
        else {
            try {
            		emailList = new List<CampaignMember>();
            		if(cm.deltage__c == true) {
	                    emailList.add(cm);
	                    cm.Status = 'Tilmeldt';
	                } 
	                Contact con = new Contact();
	                con = findContactById(cm.contactId);
	                con.email = lgUserEmail;
	                con.mobilephone = lgUserMobile;
	                con.Permission__c = lgUserPermission;
	                update con;
	                update cm;            
	                try{
	            		sendConfirmationEmail(emailList);
	        		}catch(Exception e){
	            		ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning, e.getMessage()));
	        		}
	        		PageReference newPage = new PageReference('/apex/yousee13indblikConfirmation');
	                newPage.getParameters().put('camp', campaignID);
	                newPage.getParameters().put('acc', accid);
	                newPage.setRedirect(false);
	                return newPage;
        	}catch (DmlException e) {
                    String errorMessage = e.getDMLMessage(0);
	                if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {                   
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
	                        return null;
	                } else{
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt YouSee på telefon 70 70 40 00'));
	                        System.debug('update error');
	                        return null; 
                	} 
	        }
        }
    }
    
    public Contact findContactById(String id) {
        Contact con = [Select c.name, c.firstname, c.lastname, c.email, c.mobilephone from Contact c where c.id =: id limit 1];
        return con;
    }
    
    /***************************add guest end;confirmation begin*******************/
    // Class is used for sending confirmation mail.
    
    public static final String SUBJECT_CONTENT = 'Bekræftelse på tilmelding til YouSee Live ’13';
  //  public static final String MAIl_TO = 'tisc@yousee.dk';
    public static final String MAIl_TO = 'vna@yousee.dk';
    public static final String REGARDS_CONTENT = 'Venlig hilsen <br/><br/>YouSee'; 
  //  public List<String> ccAddresses = new List<String>();
    
    // Method used for sending YouSee13 Confirmation Mail to Organized customer
    // takes parameter as list 
    public void sendConfirmationEmail(List<CampaignMember> campaignMembersList){
        List<String> ccAddresses  =  new List<String>(); 
        emailBody = '<h1><b>Tak for din tilmelding til YouSee LIVE ’13, 9. marts 2013 i Bella Center.</b></h1>' +'<br/><br/>';
        emailBody += '<font face="Verdana" size="2"> ';
        emailBody += 'Vi har registreret din tilmelding.'+ '<br/><br/>';
        emailBody += 'Nedenfor vises de deltagere der er tilmeldt fra din forening/virksomhed. Bemærk, at der kan være vist andre navne, end dem du selv har tilmeldt.'+ '<br/><br/>';
        emailBody += 'Det skyldes at flere af jer kan have modtaget en invitation og derfor kan have tilmeldt jer ad flere omgange.'+ '<br/><br/>'; 
        
        for(CampaignMember cm : campaignMembersList){
                emailBody += ' <b> ' +  cm.Contact.FirstName + '  </b> ' ;
                emailBody += ' <b> ' +  cm.Contact.LastName  + ' &nbsp; </b> ' ;
                if(cm.Show__c == true)
                        emailBody += ' <b> &nbsp; &nbsp; Deltager i tv-show &nbsp; &nbsp; </b> ';
                if(cm.Bus__c != null || 'null'.equals(cm.Bus__c))
                        emailBody += ' <b> &nbsp; &nbsp; Bustransport fra: &nbsp;' + cm.Bus__c + ' &nbsp; &nbsp; </b> ';
                emailBody += ' <br/><br/> ';  
               
        }
        emailBody += 'I slutningen af februar modtager du en billet på e-mail, som du printer og medbringer i Bella Center lørdag 9. marts 2013.' + '<br/><br/>';
        emailBody += 'Hvis flere er tilmeldt fra din forening/virksomhed, så modtager de deres egen billet på e-mail. E-mailen indeholder dit eget program, praktiske oplysninger og mere information om de oplevelser, der venter dig på YouSee LIVE ’13. Bemærk, at du ikke får yderligere materiale tilsendt pr. brev.' + '<br/><br/>';
        emailBody += 'Du vil løbende modtage nyhedsbreve på e-mail, som fortæller om nye oplevelser på YouSee LIVE ’13.' + '<br/><br/>';
        emailBody += 'På yousee.dk/13 kan du altid holde dig opdateret og se programmet for dagen, oversigt over udstillere, få mere information om fagkonferencerne og få en forsmag på, hvad du kan glæde dig til i vores fantastiske tv-show.' + '<br/><br/>';
        emailBody += 'Vi glæder os til at se dig til en forrygende dag lørdag 9. marts 2013 i Bella Center.' + '<br/><br/>';
        emailBody += 'Hvis du bliver forhindret i at deltage 9. marts på YouSee LIVE’13, kan du sende os en e-mail på salgoest@yousee.dk eller ringe på telefon 70 70 40 00 mellem kl. 9.00 og 15.00 på alle hverdage.' + '<br/><br/>';
        emailBody += REGARDS_CONTENT;
        emailBody += ' </font> ';
        sendEmail(emailBody, ccAddresses);
    }
  
    // to be used in production
    public void sendEmail(String emailBody, List<String> ccAddresses){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(cm.Deltage__c == true && cm.Contact.email != null){
            mail.setToAddresses(new String[] { cm.Contact.email });
        }
        mail.setSubject(SUBJECT_CONTENT);
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] result =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
     
    
     /*   
    // to be used in test environment 
    public void sendEmail(String emailBody, List<String> ccAddresses){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(cm.Deltage__c == true && cm.Contact.email != null){
            mail.setToAddresses(new String[] { MAIl_TO });
        }
        mail.setSubject(SUBJECT_CONTENT);
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] result =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
     */
}