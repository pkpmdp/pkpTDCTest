public class Yousee13DeltageController {
    public String name{get;set;}
    public boolean deltage{get;set;}
    public boolean show{get;set;}
    public CampaignMember cm{get;set;}
    public List<CampaignMember> contactList{get;set;}
    public String campaignID;
    public String accountID{get;set;}
    public String cmid;
    public boolean showPermission{get;set;}
    public boolean showBus{get;set;}
    public String region{get;set;} 
    public String accid{get;set;} 
    public List<CampaignMember> leadList{get;set;}
    public List<CampaignMember> guestList{get;set;}
    public Lead lead1{get;set;}
    public CampaignMember cm1{get;set;}
    public String cuid{get;set;}
    public String cuName{get;set;}
    public String customerName{get;set;}
    public String customerNumber{get;set;}
    public CampaignMember guest{get;set;}
    public CampaignMember campaignMember{get;set;}
    public Lead guestLead{get;set;} 
    public List<CampaignMember> emailList{get;set;}
    public List<CampaignMember> contactUserEmailList{get;set;}
    public List<CampaignMember> existingContactList{get;set;}
    public String emailBody{get;set;} 
    public Map<String, String> guestEmailMaps = new Map<String, String>();
    public String waitingList{get;set;}
    public String lgUserEmail{get;set;}
    public String lgUserMobile{get;set;}
    public boolean lgUserPermission{get;set;}
    public List<ExistingMember> existingMemberList{get;set;}
    public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');
    public String yousee13LeadRecordType = yousee13.Lead_RecordType__c;
    public String customerType{get;set;}
    public Integer busPlace{get;set;}
    public Integer totalTransportRequest{get;set;} // Total number of transport requested
    public Integer transportRequestCounter{get;set;}
    /**TODO LIST
    0. Outstanding issue, boardMember's mobile, email is not editable when accessing from site!!
    
    1. all the hardcoded id will be put into customer setting. OBS. prod and test's id is not identical in this project
    //DONE2. When Contact/Lead click 'deltage', the status of Campaignmember should be changed from 'sendt' to 'tilmeld'
    //DONE3. In the guest page, the relationship list is not completed. It should include all the contact&leads which choose to participate the yousee event
    //DONE4. Control transportation place. There is only 5 places for each organization. If there is more than 5, send email to ??? 
    5. optimize and clean duplicated code!!  
    //DONE6. email cc to lead/contact 
    7.Wen has disabled the cc function for business testing
    **/

    public Yousee13DeltageController(ApexPages.StandardController controller) {
        accid = ApexPages.currentPage().getParameters().get('acc');
        
        cmid = ApexPages.currentPage().getParameters().get('cmid');
        region = ApexPages.currentPage().getParameters().get('loc');
        existingMemberList = new List<ExistingMember>();
        contactList = new List<CampaignMember>(); //find all the already existed boardMembers in page 1
        if(cmid != null && cmid != '') {
            sortCampaignMember(cmid);
            findContactpersons(accid);  
        }
        //campId = ApexPages.currentPage().getParameters().get('camp');
        Account acc = [select a.type, a.Name, a.Customer_No__c, a.Cable_Unit_No__c, a.Cable_Unit_Name__c from account a where a.id = :accid limit 1];
        cuid = acc.Cable_Unit_No__c;
        cuName = acc.Cable_Unit_Name__c;
        customerName = acc.Name;
        customerNumber = acc.Customer_No__c;
        if('Kunde'.equals(acc.Type))
            customerType = 'K';
        else if('Hierarki'.equals(acc.Type))
            customerType = 'H';
        leadList = new List<CampaignMember>();
        leadList = findLeadOnCU(customerType); //find all the already created boardMembers page 2;
        guestList = new List<CampaignMember>();
        guestList = findGuestOnCU(customerType);//find all the already created guests page 3;
        totalTransportRequest = 0;
        transportRequestCounter = 0;
        emailList = new List<CampaignMember>();
        contactUserEmailList = new List<CampaignMember>();
        
        if(cm != null && cm.Bus__c != null) {
            totalTransportRequest++;
            transportRequestCounter++;
        }
       
        if(cm != null && cm.Deltage__c == true){    
            contactUserEmailList.add(cm);
        }
        
        for(CampaignMember c : leadList){
            if(c != null && c.Bus__c != null) {
                totalTransportRequest++;
            }
            if(c.deltage__c == true) {
                emailList.add(c);
            }
        }
        for(CampaignMember c : guestList){
            if(c != null && c.Bus__c != null) {
                totalTransportRequest++;
            }
            if(c.deltage__c == true) {
                emailList.add(c);
            }
        }
       
        cm1 = new CampaignMember(); 
        lead1 = new Lead(); 
        cm1.lead = lead1;
        guest = new CampaignMember();
        guestLead = new Lead();
        guest.lead = guestLead; 
        busPlace = 0;    
    }
    
    /*********************************existing contactPerson begin**********************/
    /** CM stands for login user's campaignmember
        if login user has already permission, then the permission field will be hide
        if login user comes from Jylland /Fyn, then provide the transportation
    **/
    private void sortCampaignMember(String cmid) {
        cm = [Select c.Campaign.id,c.contact.Permission__c, c.contact.name, c.contact.mobilephone, c.HasResponded, c.Deltage__c, c.Show__c, c.Bus__c, c.contact.email, c.contact.firstname, c.contact.lastname, c.ContactId From CampaignMember c where c.id=:cmid];
                System.debug('***Wen LoginUser'+cm.contact.name);
        campaignMember = [Select c.Campaign.id,c.contact.Permission__c, c.contact.name, c.contact.mobilephone, c.HasResponded, c.Deltage__c, c.Show__c, c.Bus__c, c.contact.email, c.contact.firstname, c.contact.lastname, c.ContactId From CampaignMember c where c.id=:cmid];
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
    
    /**find all the contactPersons on the same cable unit of login user
    **/
    public void findContactpersons(String accID) {
        contactList = [Select c.Show__c,c.role__c, c.Id, c.Deltage__c, c.contact.name,c.contact.firstname,c.contact.lastname, c.contact.email, c.Bus__c, c.contact.mobilephone, c.ContactId From CampaignMember c where c.contactId in (select a.Contact__c from Account_Contact_Role__c a where a.Customer__c = :accid) AND c.CampaignId =:campaignID AND c.id != :cm.id];
        existingContactList = [Select c.Show__c,c.role__c, c.Id, c.Deltage__c,  c.contact.name,c.contact.firstname,c.contact.lastname, c.contact.email, c.Bus__c, c.contact.mobilephone, c.ContactId From CampaignMember c where c.contactId in (select a.Contact__c from Account_Contact_Role__c a where a.Customer__c = :accid) AND c.CampaignId =:campaignID AND c.id != :cm.id];
        if(contactList.size() != 0) {
            for(CampaignMember c : contactList){
                ExistingMember exm = new ExistingMember(c.contact.name, c.contact.email, c.contact.mobilephone, c);
                existingMemberList.add(exm);
            }
        }   
    }
    
    /**Login user's validation rule
    **/
    public boolean HasValidationErrorsForContact(){
        boolean errors = false;
        if(cm.Deltage__c == true) {
            errors = validateContactCM(cm);
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
    
    /**
     Existing contact persons validation rule
    **/
    public boolean HasValidationErrorsContactList() {
        boolean errors = false;
        /*for(CampaignMember camp : contactList) {
            if(camp.Deltage__c == true) {
                errors =  validateContactCM(camp);
            } else {
                if(camp.show__c == true || camp.Bus__c != null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'You have chosen show or transportation for '+camp.contact.firstname+', remember to check deltage'));
                    errors = true;
                }
            }               
        }*/
        if(existingMemberList.size() != 0) {
            for(ExistingMember exm : existingMemberList) {
              if(exm.cm.Deltage__c == true) {
                  errors =  validateExistingMember(exm);
                  if(errors){
                    break;
                  }
              } else {
                if(!showBus){
                  if(exm.cm.show__c == true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du har valgt at deltage i tv-show '+exm.name+'. For at tilmelde dig skal du også sætte flueben i feltet Deltager i YouSee LIVE´13.'));
                        return true;
                  }
                }else{
                  if(exm.cm.show__c == true && exm.cm.Bus__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du har valgt at deltage i tv-show '+exm.name+'. For at tilmelde dig skal du også sætte flueben i feltet Deltager i YouSee LIVE´13.'));
                        return true;
                    }
                    if(exm.cm.show__c == false && exm.cm.Bus__c != null) {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du kan kun udfylde ‘Ønsker bustransport ’ '+exm.name+', hvis du skal deltage I YouSee LIVE’13.'));
                      return true;
                  }
                  if(exm.cm.show__c == true && exm.cm.Bus__c != null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Du kan kun udfylde ‘Deltager i tv-show ' + ' og ‘Ønsker bustransport ’ '+exm.name+', hvis du skal deltage I YouSee LIVE’13.'));
                      return true;
                  }  
                }
                  
              }               
          }
        }
        return errors;
    }
    
    public boolean validateExistingMember(ExistingMember exm) {
        boolean errors = false;
          if(exm.mobile == null || exm.mobile  == '') {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste ' +exm.name +' \'s mobilnr.'));
                errors = true;
            }  
            if(exm.mobile != null && exm.mobile != '' && exm.mobile.length() < 8 ) {
              ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning, exm.name + ' \'s Mobilnummer skal have mindst 8 cifre.'));
                errors = true;
            }
                 
            if(exm.email == null || exm.email == ''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste '+exm.name+ ' \'s e-mail adresse.'));
                errors = true;
            } else {
                String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+'; 
                Boolean formatOK = Pattern.matches(pat, exm.email);
                if(formatOK == false){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste en gyldig e-mail adresse for'+exm.name));
                    errors = true;   
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
        
        if(HasValidationErrorsForContact() || HasValidationErrorsContactList()){
          return null;
        }    
        else {
          
          try {
                contactUserEmailList.clear();
                totalTransportRequest = totalTransportRequest - transportRequestCounter;
                if(valdiateTotalTransportRequested(cm)){
                    return null;
                }
                if(cm != null && cm.Bus__c != null) {
                    totalTransportRequest++;
                }
                if(cm.deltage__c == true) {
                    
                    emailList.add(cm);
                    cm.Status = 'Tilmeldt';
                } 
                Contact con = new Contact();
                con = findContactById(cm.contactId);
                con.email = lgUserEmail;
                con.mobilephone = lgUserMobile;
                con.Permission__c = lgUserPermission;
                System.debug('******Wen findContactById '+con.name+cm.contactId);
                update con;
                update cm;            
                
                 List<Contact> contactList = new List<Contact>();
                      
                System.debug('****wen existingMemberList'+existingMemberList.size());
                if(existingMemberList.size() != 0) {
                    for(ExistingMember exm : existingMemberList) {
                        System.debug('*****Wen wrap member'+exm.name+exm.cm.contactId);
                        if(exm.cm.Deltage__c == true) {
                            emailList.add(exm.cm);
                            exm.cm.Status = 'Tilmeldt';
                        } 
                        Contact cont = new Contact();
                        cont = findContactById(exm.cm.contactId);
                        System.debug('*******wen email check database'+cont.email);
                        cont.email = exm.email;
                        cont.mobilephone = exm.mobile;
                        System.debug('*******wen email check interface'+exm.email);
                        contactList.add(cont);
                       //  update cont;
                        if(valdiateTotalTransportRequested(exm.cm)){
                            return null;
                        }
                        if(exm.cm.Bus__c != null) {
                            totalTransportRequest++;
                        }   
                        update exm.cm;
                    }
                    update contactList;
                }
                //update contactList;
                PageReference newPage = new PageReference('/apex/Yousee13AddMember');
                newPage.getParameters().put('camp', campaignID);
                newPage.getParameters().put('acc', accid);
                newPage.setRedirect(false);
                return newPage;
        } catch (DmlException e) {
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
    
    /**
        existing contact persons's next button
    **/    
    public PageReference saveContactRegistration() {
        return saveRegistration();
    }
    
    /******************Existing contactPersons End; Add member Begin************/
   
   
    /**
    get the list of all the boardmembers which are newly created by other collegues for 'KUNDE' type Customer
    **/
    public List<CampaignMember> findLeadOnCU(String customerType) {
        System.debug('wen try to find LeadList on the same CU');
        if(customerType == 'K')
            leadList = [Select c.ContactId, c.Show__c,c.role__c, c.Id, c.Deltage__c, c.lead.name,c.lead.firstname, c.lead.lastname, c.lead.email, c.Bus__c, c.lead.mobilephone From CampaignMember c where c.lead.Anlaeg_No__c =: cuid AND c.CampaignId =:campaignID AND c.lead.title != 'Guest' limit 100];
        else if(customerType == 'H')
            leadList = [Select c.ContactId, c.Show__c,c.role__c, c.Id, c.Deltage__c, c.lead.name,c.lead.firstname, c.lead.lastname, c.lead.email, c.Bus__c, c.lead.mobilephone From CampaignMember c where c.lead.Customer_Number__c =: customerNumber AND c.CampaignId =:campaignID AND c.lead.title != 'Guest'];
        return leadList;
    }
    
    public boolean valdiateTotalTransportRequested(CampaignMember cm){
         
          if(cm.Bus__c != null && totalTransportRequest >= 5) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Du har forsøgt at melde mere end 5 personer til bustransport. Der kan max. tilmeldes 5 personer.'));
                return true;
          }
          return false;
    }
     /**
    get the list of all the boardmembers which are newly created by other collegues for 'Hierarchy' type Customer
    **/
    /*private List<CampaignMember> findLeadOnACC() {
        System.debug('wen try to find LeadList on the same customer');
        leadList = [Select c.Show__c,c.role__c, c.Id, c.Deltage__c, c.lead.name,c.lead.firstname, c.lead.lastname, c.lead.email, c.Bus__c, c.lead.mobilephone From CampaignMember c where c.lead.Customer_Number__c =: customerNumber AND c.CampaignId =:campaignID AND c.lead.title != 'Guest'];
        return leadList;
    }*/
    
    
    /**board member(Lead) validation
    **/
    public boolean HasValidationErrors(CampaignMember cm){
        System.debug('wen hasvalidationerrors method');
        boolean errors = false;
        errors = validateCM(cm);
        return errors;
    } 
    private boolean validateCM(CampaignMember cmp) {
        System.debug('wen validateCM method');
        boolean errors = false;
        if(cmp.lead.firstname == null || cmp.lead.firstname == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste fornavn'));
                errors = true; 
        }
        if(cmp.lead.lastname == null || cmp.lead.lastname == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste efternavn'));
                errors = true; 
        }

            if(cmp.lead.mobilephone == null || cmp.lead.mobilephone == '') {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste mobilnr.'));
                errors = true;
            }        
            if(cmp.lead.email == null || cmp.lead.email == ''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'E-mail-adresser skal udfyldes. Vi sender billetter og anden relevant information om YouSee LIVE´13 via e-mail.'));
                errors = true;
            } else {
                String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+'; 
                Boolean formatOK = Pattern.matches(pat, cmp.lead.email);
                if(formatOK == false){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste en gyldig e-mail adresse for'+cmp.lead.firstname));
                    errors = true;   
                }
            }
        return errors;
    } 
    
     /**
    save BoardMember and redirect to create guest
    **/
    public pageReference saveLead(CampaignMember cm, Lead ld) {
          //success = false;
          System.debug('wen savelead  method');
          if(HasValidationErrors(cm) || valdiateTotalTransportRequested(cm)){
                return null;
          }  
          else {  
              try {
                     System.debug('wen ready to insert lead');
                     ld.RecordTypeId = yousee13LeadRecordType;//'012M0000000CsDc' ;
                     ld.Anlaeg_No__c = cuid;
                     ld.Anlaeg_Name__c =  cuName;
                     ld.Company = customerName;
                     ld.Customer_Number__c = customerNumber;
                     ld.Account_YS_Live_13__c = accid; 
                     insert ld;
                     System.debug('wen ready to insert cm');
                     cm.campaignId = campaignID;
                     cm.leadId = ld.id;
                     cm.Deltage__c = true;
                     cm.Status = 'Tilmeldt';
                     insert cm;
                     if(cm.Bus__c != null) {
                          totalTransportRequest++;
                     }
                     emailList.add(cm);
                     PageReference newPage = new PageReference('/apex/Yousee13AddGuest');
                   newPage.getParameters().put('acc', accid);
                   newPage.setRedirect(false);
                   return newPage;
              } catch (DmlException e) {
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
    
    /**
    save boardMember and create more member 
    **/
    public pageReference saveAndMore(CampaignMember cm, Lead ld) {
          //success = false;
          System.debug('wen savelead  method');
          if(HasValidationErrors(cm) || valdiateTotalTransportRequested(cm))
            return null;
          else {  
          try {
                   System.debug('wen ready to insert lead');
                   ld.RecordTypeId = yousee13LeadRecordType;//'012M0000000CsDc' ;
                   //todo
                   ld.Anlaeg_No__c = cuid;
                   ld.Anlaeg_Name__c =  cuName;
                   //ld.Title = 'Guest';
                   ld.Company = customerName;
                   ld.Customer_Number__c = customerNumber; 
                   ld.Account_YS_Live_13__c = accid; 
                   insert ld;
                   System.debug('wen ready to insert cm');
                   cm.campaignId = campaignID;
                   cm.leadId = ld.id;
                   cm.Deltage__c = true;  
                   //if(cm.Deltage__c == true) {
                   
                    cm.Status = 'Tilmeldt';
                    //busPlaces ++;
                   //}              
                   insert cm;  
                   if(cm.Bus__c != null) {
                        totalTransportRequest++;
                   }         
                   emailList.add(cm);
                            
               PageReference newPage = new PageReference('/apex/Yousee13AddMember');
               //newPage.getParameters().put('camp', campId);
                newPage.getParameters().put('acc', accid);
               newPage.setRedirect(false);
               return newPage;
                   
          } catch (DmlException e) {
               String errorMessage = e.getDMLMessage(0);
               if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
                    return null;
               } else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt YouSee på telefon 70 70 40 00.')); 
                    System.debug('update error');
                    return null;
               }
         }
         }
    }
    
    public void initializeMember() {
         cm1 = new CampaignMember();
         lead1 = new Lead();
         cm1.lead = lead1;
         leadList = findLeadOnCU(customerType);
         System.debug('Wen LeadList'+leadList.size());  
    }
    
     /**boardMember save&next button
    **/
     public PageReference saveAndRedirect() { 
             System.debug('wen saveAndRedirect method');
             Boolean success = false;
             System.debug('Vishal lead1.Role__c ' + lead1.Role__c);
             
            return saveLead(cm1, lead1);
     } 
     /**
     boardMember addmore button
     **/
     public PageReference addMore() {
           return saveAndMore(cm1, lead1);
     }
    
    /**boardMember skip button**/ 
    public PageReference redirectToCreateGuest() { 
        PageReference newPage = new PageReference('/apex/Yousee13AddGuest');
        //newPage.getParameters().put('camp', campId);
        newPage.getParameters().put('acc', accid);
        newPage.setRedirect(false);
        return newPage;
    }
     
      /**boardMember skip button**/ 
    public PageReference redirectToCreateMember() {
      
      if(campaignMember.Deltage__c == true){ 
          emailList.add(campaignMember);
      }  
        for(CampaignMember c : existingContactList){
            if(c.Deltage__c == true){   
                emailList.add(c);
            }   
        }
        PageReference newPage = new PageReference('/apex/Yousee13AddMember');
        //newPage.getParameters().put('camp', campId);
        newPage.getParameters().put('acc', accid);
        newPage.setRedirect(false);
        return newPage;
    }
     
     /***********************************add board member end; add guest begin*************************************/
    
        /**
        get the list of all the guests which are registed by other collegues
        **/   
    public  List<CampaignMember> findGuestOnCU(String customerType) {
        if(customerType == 'K')
        guestList = [Select c.contactId, c.Show__c,c.role__c, c.Id, c.Deltage__c,c.lead.description, c.lead.name,c.lead.firstname, c.lead.lastname, c.lead.email, c.Bus__c, c.lead.mobilephone From CampaignMember c where c.lead.Anlaeg_No__c =: cuid AND c.CampaignId =:campaignID AND c.lead.title = 'Guest' limit 100];
        else if(customerType == 'H')
        guestList = [Select c.contactId, c.Show__c,c.role__c, c.Id, c.Deltage__c,c.lead.description, c.lead.name,c.lead.firstname, c.lead.lastname, c.lead.email, c.Bus__c, c.lead.mobilephone From CampaignMember c where c.lead.Customer_Number__c =: customerNumber AND c.CampaignId =:campaignID AND c.lead.title = 'Guest'];
        return guestList;    
    }
    
     /**
    get the list of all the boardMembers who have rights to bring guest
    **/
    public List<selectOption> getRelations() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query belo
                               
                if(cm.Deltage__c == true){
                        if(cm.contact != null && cm.contact.name != null && lgUserEmail != null){
                            options.add(new selectOption(lgUserEmail, cm.contact.name));
                            guestEmailMaps.put(lgUserEmail, cm.contact.name);
                        }   
                }        
                //if(cm.contact != null && cm.contact.name != null && lgUserEmail != null){
                    //guestEmailMaps.put(lgUserEmail, cm.contact.name);
                //}   
                for(CampaignMember econ : contactList) {
                    if(econ.contact != null && econ.contact.name != null && econ.contact.email != null){
                        if(econ.deltage__c == true)
                                options.add(new selectOption(econ.contact.email, econ.contact.name));
                        guestEmailMaps.put(econ.contact.email, econ.contact.name);
                    }   
                }          
        for(CampaignMember bm : leadList) //boardMember 
        {   
            if(bm.lead != null && bm.lead.name != null && bm.lead.email != null){
                options.add(new selectOption(bm.lead.email, bm.lead.name));
                guestEmailMaps.put(bm.lead.email, bm.lead.name);
            }   
        }   
        return options; //return the picklist options
    }
    
   
    /** save guest and redirect to confirmation page
    **/
    public pageReference saveGuest(CampaignMember cm, Lead ld) {
          //success = false;
          System.debug('wen savelead  method');
          System.debug(' Total transport Req save ' + totalTransportRequest);
          if(validateGuest(cm) || valdiateTotalTransportRequested(cm))
            return null;
          else {  
          try {
                   System.debug('wen ready to insert lead');
                   ld.RecordTypeId = yousee13LeadRecordType;//'012M0000000CsDc' ;
                   ld.Anlaeg_No__c = cuid;
                   ld.Anlaeg_Name__c =  cuName; 
                   ld.Title = 'Guest';
                   ld.description = guestEmailMaps.get(ld.email);
                   ld.Company = customerName;
                   ld.Customer_Number__c = customerNumber;
                   ld.Account_YS_Live_13__c = accid;  
                   insert ld;
                   System.debug('wen ready to insert cm');
                   cm.campaignId = campaignID;
                   cm.leadId = ld.id; 
                   cm.Deltage__c = true;
                   //if(cm.Deltage__c == true){
                   
                    cm.Status = 'Tilmeldt';
                    //busPlaces ++;
                   //}               
                   insert cm;   
                   if(cm.Bus__c != null) {
                        totalTransportRequest++;
                   }
                    emailList.add(cm);
                                  
                  sendConfirmationEmail(emailList);   
               PageReference newPage = new PageReference('/apex/yousee13confirmation');
               //newPage.getParameters().put('camp', campId);
               newPage.getParameters().put('acc', accid);
               newPage.getParameters().put('camp', campaignID);
               newPage.setRedirect(false);
               return newPage;
                   
          } catch (DmlException e) {
               String errorMessage = e.getDMLMessage(0);
               if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
                    return null;
               } else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt YouSee på telefon 70 70 40 00.')); 
                    System.debug('update error');
                    return null;
               }
         }
         }
    }
    
    /**
    save guest and create more guest
    **/
    public PageReference saveGuestAndMore(CampaignMember cm, Lead ld){
          System.debug('wen savelead  method');
       if(validateGuest(cm) || valdiateTotalTransportRequested(cm) ){
              return null;
          }  
          else {  
              try {
                   System.debug('wen ready to insert lead');
                   ld.RecordTypeId = yousee13LeadRecordType;//'012M0000000CsDc' ;
                   //todo
                   ld.Anlaeg_No__c = cuid;
                   ld.Anlaeg_Name__c =  cuName;
                   ld.Title = 'Guest';
                   ld.description = guestEmailMaps.get(ld.email);
                   ld.Company = customerName;
                   ld.Customer_Number__c = customerNumber;  
                   ld.Account_YS_Live_13__c = accid; 
                   insert ld;
                   System.debug('wen ready to insert cm');
                   cm.campaignId = campaignID;
                   cm.leadId = ld.id;  
                   cm.Deltage__c = true;
                   cm.Status = 'Tilmeldt';
                   insert cm;  
                   if( cm.Bus__c != null) {
                        totalTransportRequest++;
                   }
                   emailList.add(cm);
                    PageReference newPage = new PageReference('/apex/Yousee13AddGuest');
                    newPage.getParameters().put('acc', accid);
                    newPage.setRedirect(false);
                    return newPage;
               }catch (DmlException e) {
                      String errorMessage = e.getDMLMessage(0);
                   if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, errorMessage));
                        return null;
                   }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt YouSee på telefon 70 70 40 00.')); 
                        System.debug('update error');
                        return null;
                   }
              }
         }
    }
     
    
    /**guest validation
    **/
    public boolean validateGuest(CampaignMember cmp) {
        boolean errors = false;
        if(cmp.lead.firstname == null || cmp.lead.firstname == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste fornavn'));
                errors = true; 
        }
        if(cmp.lead.lastname == null || cmp.lead.lastname == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste efternavn'));
                errors = true; 
        }
        if(cmp.lead.email == null || cmp.lead.email == '') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Husk at taste Ledsager til.'));
            errors = true;
        }        
        return errors;
    }   
    
    public void initializeGuest() {
         guest = new CampaignMember();
         guestLead = new Lead();
         guest.lead = guestLead; 
         guestList = findGuestOnCU(customerType); 
    }
   
     /**guest addmore button
     ***/
     public PageReference addMoreGuest() {
           return saveGuestAndMore(guest, guestLead);
     }
     /**guest save&next button
     **/
     public PageReference saveGuestAndNext() {
        return saveGuest(guest, guestLead);
     }
     /***guest skip button
     **/    
    public PageReference redirectToConfirmation() {
        try{
          sendConfirmationEmail(emailList);
        }catch(Exception e){
          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Warning, e.getMessage()));
        }  
        PageReference newPage = new PageReference('/apex/yousee13confirmation');
        //newPage.getParameters().put('camp', campId);
        newPage.getParameters().put('acc', accid);
        newPage.getParameters().put('camp', campaignID);
        newPage.setRedirect(false);
        return newPage;
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
            if(cm.ContactId == null) {
                emailBody +=  '<b> ' +cm.Lead.FirstName + '  </b> ' ;
                emailBody +=  '<b> ' +cm.Lead.LastName + ' &nbsp; </b> ' ;
                if(cm.Show__c == true)
                        emailBody += ' <b> &nbsp; &nbsp; Deltager i tv-show &nbsp; </b> ';
                        System.debug('*****Wen Bus'+cm.Bus__c);
                if(cm.Bus__c != null || 'null'.equals(cm.Bus__c))
                        emailBody += ' <b> &nbsp; &nbsp; Bustransport fra: &nbsp;' +  cm.Bus__c + ' &nbsp; &nbsp; </b> ';
                emailBody += '<br/><br/>';  
                if(cm.Lead != null && cm.Lead.Email != null){
                        ccAddresses.add(cm.Lead.Email);
                }       
            }else{
                emailBody += ' <b> ' +  cm.Contact.FirstName + '  </b> ' ;
                emailBody += ' <b> ' +  cm.Contact.LastName  + ' &nbsp; </b> ' ;
                if(cm.Show__c == true)
                        emailBody += ' <b> &nbsp; &nbsp; Deltager i tv-show &nbsp; &nbsp; </b> ';
                if(cm.Bus__c != null || 'null'.equals(cm.Bus__c))
                        emailBody += ' <b> &nbsp; &nbsp; Bustransport fra: &nbsp;' + cm.Bus__c + ' &nbsp; &nbsp; </b> ';
                emailBody += ' <br/><br/> ';  
                if(cm.Contact != null && cm.Contact.Email != null){
                        ccAddresses.add(cm.Contact.Email);
                }       
            }    
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
        mail.setCcAddresses(ccAddresses); 
        Messaging.SendEmailResult[] result =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  
     /*  
    // to be used in test environment 
    public void sendEmail(String emailBody, List<String> ccAddresses){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(cm.Deltage__c == true && cm.Contact.email != null){
          mail.setToAddresses(new String[] { MAIl_TO });
        }
        mail.setCcAddresses(new String[] { MAIl_TO }); 
        mail.setSubject(SUBJECT_CONTENT);
        mail.setHtmlBody(emailBody);
        Messaging.SendEmailResult[] result =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    */
    public class ExistingMember {
        public String name{get;set;}
        public String mobile{get;set;}
        public String email{get;set;}
        public CampaignMember cm{get;set;}
        public ExistingMember(String name, String email, String mobile, CampaignMember cm) {
            this.name = name;
            this.mobile = mobile;
            this.email = email;
            this.cm = cm;    
        }
    }
       
}