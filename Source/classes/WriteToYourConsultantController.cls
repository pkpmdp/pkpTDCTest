public class WriteToYourConsultantController {    
    
    public Boolean sendCopy;
    public boolean displayAddressInfo{get; set;}
    private Boolean editProfile;
    public boolean pageFlag;
    public static boolean TEST_MODE;
    public ID accId{get;set;}
    
    public String[] toAddresses;
    public String[] toBccAddresses;
    public static String mailDescription = null;
    public string cableUnitName {get;set;}
    public String portalBrugerRole {get; set;}
    public Boolean tempFlag = false;
    public static Account acc{get;set;}
    public Address__c address{get; set;}
    public Contact contact{get;set;}
    public Contact contactTest{get; set;}
    public static boolean TEST_MODE1 = false; 
    public String retURL = ApexPages.currentPage().getHeaders().get('Host');
    public String siteCoreUrl{get; set;}
     public Boolean renderSection{get;set;} // Support-5377
         
    ServiceCenter_CustomSettings__c scProductionDomain = ServiceCenter_CustomSettings__c.getValues('Production_Email_Setting');
    ServiceCenter_CustomSettings__c scTestDomain = ServiceCenter_CustomSettings__c.getValues('Test_Email_Setting');
    ServiceCenter_CustomSettings__c scToAddresses1 = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');
    ServiceCenter_CustomSettings__c scBccEmail = ServiceCenter_CustomSettings__c.getValues('Production_Bcc_Email');
    
    ServiceCenter_CustomSettings__c ccTestDomain = ServiceCenter_CustomSettings__c.getValues('Production_CC_EmailSettings');
    
    public Boolean getEditProfile(){
        return editProfile;
    }
    
    public void setEditProfile(Boolean edit){
        editProfile = edit;     
    }
    
    public Boolean getSendCopy(){
        return sendCopy;
    }
    
    public void setSendCopy(Boolean copy){
        sendCopy = copy;
    }
    
    public Boolean getPageFlag(){
        return pageFlag;
    }
    
    public void setPageFlag(Boolean flag){
        pageFlag= flag;
    }
    
    public String getMailDescription(){
        return mailDescription;
    }
    
    public void setMailDescription(String mailDesc){
       mailDescription=mailDesc;
    }
    
    public Contact getContactDetail(){
        return contact;
    }
    
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('WriteToYourConsultantController','Write To Consultant');
    public WriteToYourConsultantController(){
         contactTest = new Contact();
         String value5;
         String cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
          String accountID = ApexPages.currentPage().getParameters().get('accountId');
          // Support-5377 --------START
        Boolean cableUnitMatch = true;  // Support-5377 
        renderSection = true; // Support-5377
        
        list<Account> accList = new list<Account>();
            if(String.isNotBlank(accountID)){
                
                accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountID ];
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
                
                 system.debug('***cableUnitMatch****renderSection****'+cableUnitMatch + '    ' + renderSection);
            }
        
         
     //    toBccAddresses = new String[]{'supportkiss@yousee.dk'};
       if(scBccEmail != null && scBccEmail.Value__c != null){
                  value5 = scBccEmail.Value__c;
                  toBccAddresses = value5.split(';');
                  
        }
       
         contactTest = [Select c.Post_Code_P__c, c.Phone, c.Name, c.MobilePhone, c.LastName, c.House_No__c, c.HomePhone, c.FirstName, c.Email From Contact c where Id IN (Select u.ContactId From User u where Id =:UserInfo.getUserId())];
         system.debug('$contactTest$'+contactTest);
         portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
         siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
         contact = [select Contact.Id,
                          Contact.FirstName,
                          Contact.LastName,
                          Contact.Street_P__c,
                          Contact.Description,
                          Contact.Email,
                          Contact.Phone,
                          Contact.MobilePhone,
                          Contact.HomePhone,
                          Contact.Address_merge_field__c,
                          Contact.AlternateEmail__c
                          from Contact 
                          where Contact.Id in (select contactid from User where id =:UserInfo.getUserId())];
                    
         accId = ApexPages.currentPage().getParameters().get(contactConstClass.ACCOUNTID);
         system.debug('$Account Id$'+accId);
         cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
         fetchAddressDetails();
         pageFlag = true;
         String fullUrl1 = URL.getCurrentRequestUrl().toExternalForm();
         if(fullUrl1.contains('ViewAgreementsPage')){
            pageFlag = false;
         } 
         tempFlag = false;
         backToContactPersonPage();
    }
    
    /* public PageReference sendTempMail(){
        User loggedInUser = new User();
        //Id loggedInId = UserInfo.getUserId();
        //loggedInUser = [Select u.LastName, u.Id, u.FirstName, u.Email, u.ContactId From User u where Id =: loggedInId limit 1];
        List<EmailTemplate> templateList = null;
        if(editProfile){
            try{ 
                update contact;
                contact = [select Contact.Id,Contact.FirstName,Contact.LastName,Contact.Street_P__c,Contact.Email,Contact.Phone,Contact.MobilePhone,Contact.HomePhone from Contact 
                where Contact.Id in (select contactid from User where id =:UserInfo.getUserId())];
                loggedInUser = [Select u.Id,u.FirstName,u.LastName,u.email,u.ContactId from user u where u.ContactId =: contact.Id];
                loggedInUser.FirstName = contact.FirstName;
                loggedInUser.LastName = contact.LastName;
                update loggedInUser;
                if(tempFlag == true){
                    integer i;
                    i = 10/0;
                }
            }catch (DmlException e){ 
                ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
                ApexPages.addMessage(debugMsg);
            }
            catch(Exception e){
                ApexPages.Message debugMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(debugMsg1);
            }
        }
        
        string ysEmail = ApexPages.currentPage().getParameters().get('YouSeeContactEmail');
        Id ysCustomerId = ApexPages.currentPage().getParameters().get('ysId');
        system.debug('**ysEmail**'+ysEmail);
        system.debug('**ysId**'+ysCustomerId);
        
        if(ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != null && ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != ''){
                //system.debug('YouSeeContactEmail is not null');
             if(retURL == scTestDomain.Value__c){
                    
                    //acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =: accId];
                    if(sendCopy){
                        //send mail to both customer and YS Manager
                        //Following mail send to customer
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        toAddresses = new String[]{'evast@yousee.dk','savita.ramankutty@capgemini.com','assh@yousee.dk'};
                        mail.setToAddresses(toAddresses);
                        mail.setTargetObjectId(loggedInUser.Id);
                        mail.setSaveAsActivity(false);
                        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:Mail To Customer'];
                        mail.setTemplateId(templateList.get(0).id);
                        system.debug('mail sending to customer');
                        if(!TEST_MODE){
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                        //Following mail send to YS Manager
                        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                        toAddresses = new String[]{'evast@yousee.dk','savita.ramankutty@capgemini.com','assh@tdc.dk'};
                        mail1.setToAddresses(toAddresses);
                        mail1.setTargetObjectId(loggedInUser.Id);
                        mail1.setSaveAsActivity(false);
                        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:YS Customer Manager Email'];
                        mail1.setTemplateId(templateList.get(0).id);
                        if(!TEST_MODE){
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                        }
                    }else{
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        toAddresses = new String[]{'evast@yousee.dk', 'vishal.tambe@capgemini.com', 'savita.ramankutty@capgemini.com','assh@tdc.dk'};
                        system.debug('$33ToAddresses33$'+toAddresses);
                        mail.setToAddresses(toAddresses);
                        mail.setTargetObjectId(loggedInUser.Id);
                        mail.setSaveAsActivity(false);
                        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:YS Customer Manager Email'];
                        mail.setTemplateId(templateList.get(0).id);
                        if(!TEST_MODE){
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                    }
                 }
                
                //check in production URL
                /*if(retURL == scProductionDomain.Value__c){
                    if(sendCopy){
                        system.debug('**sendCopy is true***');
                        //send mail to both customer and YS Manager
                        //Following mail send to customer
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //toAddresses = new String[]{loggedInUser.email};
                        //mail.setToAddresses(toAddresses);
                        mail.setTargetObjectId(loggedInUser.Id);
                        mail.setSaveAsActivity(false);
                        mail.setTemplateId('00XM0000000HvgE');
                        system.debug('mail sending to customer');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
                        //Following mail send to YS Manager
                        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                        String relManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
                        List<Lookup_Account_Team_Role__c> roleList = [select Id from Lookup_Account_Team_Role__c where Name =: relManagerRoleName];
                        Id relManagerRoleId;
                        String contactEmail;
                        if(roleLIst1.Size() > 0){
                            relManagerRoleId = roleList.get(0).Id;
                        }
                        for ( Account_Team__c at : [Select a.Customer_Team_Member__r.Email__c From Account_Team__c a where a.Customer_Team_Role__r.Id  =: relManagerRoleId and a.customer__C =: accId]){
                            if(at.Customer_Team_Member__r.Email__c != null && at.Customer_Team_Member__r.Email__c != '' && at.Customer_Team_Member__r.Email__c.length() > 0 ){
                                contactEmail = at.Customer_Team_Member__r.Email__c;
                            }   
                        } 
                        //toAddresses = new String[]{contactEmail};
                        system.debug('$ToAddresses$'+toAddresses);
                        //mail1.setToAddresses(toAddresses);
                        mail1.setTargetObjectId(contact.id);
                        mail1.setSaveAsActivity(false);
                        mail1.setTemplateId('00XM0000000Hvfp');
                        system.debug('mail sending to YS Manager');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                    }else{
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        toAddresses = new String[]{'assh@tdc.dk'};
                        system.debug('$ToAddresses$'+toAddresses);
                        mail.setToAddresses(toAddresses);
                        mail.setTargetObjectId(loggedInUser.Id);
                        mail.setSaveAsActivity(false);
                        mail.setTemplateId('00XM0000000Hvfp');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                }*/
                
     /*  
        
        }
        else{
            
            //acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =: accId];
            //system.debug('$acc $'+acc+'$acc.Cable Unit no$'+acc.Cable_Unit_No__c+'$Cable Unit Name$'+acc.Cable_Unit_Name__c);
            if(sendCopy){
                //send mail to both customer and YS Manager
                //Following mail send to customer
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                toAddresses = new String[]{'evast@yousee.dk','savita.ramankutty@capgemini.com'};
                mail.setToAddresses(toAddresses);
                mail.setTargetObjectId(loggedInUser.Id);
                mail.setSaveAsActivity(false);
                mail.setTemplateId('00XM0000000HvgE');
                if(!TEST_MODE){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                //Following mail send to YS Manager
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                toAddresses = new String[]{'evast@yousee.dk','savita.ramankutty@capgemini.com'};
                mail1.setToAddresses(toAddresses);
                mail1.setTargetObjectId(loggedInUser.Id);
                mail1.setSaveAsActivity(false);
                templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:YS Customer Manager Email'];
                mail1.setTemplateId(templateList.get(0).id);
                if(!TEST_MODE){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                }
            }else{
                Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                toAddresses = new String[]{'evast@yousee.dk','savita.ramankutty@capgemini.com'};
                mail2.setToAddresses(toAddresses);
                mail2.setTargetObjectId(loggedInUser.Id);
                mail2.setSaveAsActivity(false);
                //templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:YS Customer Manager Email'];
                //mail2.setTemplateId(templateList.get(0).Id);
                mail2.setTemplateId('00XM0000000Hvfp');
                //mail2.setTemplateId('templateList.get(0).id'+templateList.get(0).id);
                if(!TEST_MODE){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail2 });
                }   
            }
        }
        return createAgreementsPageRef();
    }*/
    
    
    public PageReference returnToAgreement(){
        return createAgreementsPageRef();
    }
    
    private PageReference createAgreementsPageRef(){
        String newPageUrl = ApexPages.CurrentPage().getParameters().get('previousPage');
        if (Site.getPrefix() != null && Site.getPrefix()!= '')
          newPageUrl = Site.getPrefix() + newPageUrl;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
        newPage.setRedirect(true);
        return newPage;
    }
    
    public PageReference fetchAddressDetails(){
        if(contact != null){
            String addressId = contact.Street_P__c;
            // Query before implementing  SC- 168 for extra post box number
            List<Address__c> addressList = [Select Street__c, Entrance__c, External_Id__c, HouseNumber__c, House_No__c, Floor__c, Postcode__c, Town__c, Door_No__c from Address__c where id =: addressId];
            if(addressList.size() > 0){
                address = addressList.get(0);           
            }
        }
        displayAddressInfo = true;      
        return null;
    }
   
    public PageReference backToContactPersonPage(){
        if(pageFlag){
          //Changed for SC-22
            //String newPage1 = '/apex/viewYouSeeContactPersonPage';
            //PageReference newPage = new PageReference(newPage1);
            PageReference newPage = Page.viewYouSeeContactPersonPage;
            newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
            newPage.setRedirect(true);
            return newPage;
        }else{
            //Changed for SC-22
            //String newPage1 = '/apex/ViewAgreementsPage';
            //PageReference newPage = new PageReference(newPage1);
            PageReference newPage = Page.ViewAgreementsPage;
            newPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
            newPage.setRedirect(true);
            return newPage;
        }
    }
    
    
    public PageReference sendMail(){
        User loggedInUser = new User();
         //accId = ApexPages.currentPage().getParameters().get('accountId');
         //accId = ApexPages.currentPage().getParameters().get(contactConstClass.ACCOUNTID);
         //system.debug('$Account Id$'+accId);
         //cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
         if(!TEST_MODE1){
           acc = [select a.Cable_Unit_No__c,a.Cable_Unit_Name__c from Account a where a.Id =: accId];  
         }
         
        //Id loggedInId1 = UserInfo.getUserId();
        //loggedInUser1 = [Select u.LastName, u.Id, u.FirstName, u.Email, u.ContactId From User u where Id =: loggedInId1 limit 1];
        loggedInUser = [Select u.Id,u.FirstName,u.LastName,u.email,u.ContactId from user u where u.ContactId =: contact.Id];
        System.debug('$LoggedIn User Details@@@@@@$'+loggedInUser);
        List<EmailTemplate> templateList = null;
        if(editProfile){
            try{ 
                update contact;
                contact = [select Contact.Id,Contact.FirstName,Contact.LastName,Contact.Street_P__c,Contact.Email,Contact.Phone,Contact.MobilePhone,Contact.HomePhone from Contact 
                where Contact.Id in (select contactid from User where id =:UserInfo.getUserId())];
                loggedInUser = [Select u.Id,u.FirstName,u.LastName,u.email,u.ContactId from user u where u.ContactId =: contact.Id];
                loggedInUser.FirstName = contact.FirstName;
                loggedInUser.LastName = contact.LastName;
                update loggedInUser;
                if(tempFlag == true){
                    integer i;
                    i = 10/0;
                }
                    
            }catch (DmlException e){ 
                ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());
                ApexPages.addMessage(debugMsg);
            }
            catch(Exception e){
                ApexPages.Message debugMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(debugMsg1);
            }
             
        }
    system.debug('retURL aaaaa '+retURL );
    system.debug('scTestDomain.Value__c aaaaa ' +scTestDomain.Value__c);
    String value2;
    String[] toCCAddresses1; 
    
    if(retURL == scTestDomain.Value__c){
    if(ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != null && ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != ''){
       if(sendCopy){
            
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail1.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail1.getCcAddresses());
              }
                //toAddresses = new String[]{'amrish.surve@capgemini.com','savita.ramankutty@capgemini.com'};
                //mail1.setToAddresses(toAddresses);
                System.debug('Bcc***'+toBccAddresses);
                mail1.setBccAddresses(toBccAddresses);
                mail1.setTargetObjectId(loggedInUser.Id);
                mail1.setSaveAsActivity(false);
                templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:Mail To Customer'];
                mail1.setTemplateId(templateList.get(0).Id);
                //mail2.setTemplateId('00XM0000000Hwf7');
                system.debug('Before Mail send '+toAddresses);
                if(!TEST_MODE1){
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
                }
                system.debug('$Mail Send$'+mail1);
                
                Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
        if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail2.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail2.getCcAddresses());
              }
        //toAddresses = new String [] {'amsur@yousee.dk','savita.ramankutty@capgemini.com'};
        //mail2.setToAddresses(toAddresses);
        mail2.setBccAddresses(toBccAddresses);
        mail2.setTargetObjectId(loggedInUser.Id);
        mail2.setSaveAsActivity(false);
        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:PYS Customer Manager Email'];
              mail2.setTemplateId(templateList.get(0).Id);
              if(!TEST_MODE1){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail2});
              }
       }else{
         
         Messaging.SingleEmailMessage mail3 = new Messaging.SingleEmailMessage();
         if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail3.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail3.getCcAddresses());
              }
         //toAddresses = new String[] {'amsur@yousee.dk','savita.ramankutty@capgemini.com'};
         //mail3.setToAddresses(toAddresses);
         mail3.setBccAddresses(toBccAddresses);
         mail3.setTargetObjectId(loggedInUser.Id);
         mail3.setSaveAsActivity(false);
         templateList = [Select t.Name, t.Id From EmailTemplate t where t.Name =: 'Customer Portal:PYS Customer Manager Email'];
         mail3.setTemplateId(templateList.get(0).Id);
         if(!TEST_MODE1){
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail3});
         }
         
       }
    }else{
      if(sendCopy){
        Messaging.SingleEmailMessage mail4 = new Messaging.SingleEmailMessage();
        if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail4.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail4.getCcAddresses());
              }
        //toAddresses = new String[] {'amrish.surve@capgemini.com','savita.ramankutty@capgemini.com'};
        //mail4.setToAddresses(toAddresses);
        mail4.setBccAddresses(toBccAddresses);
        mail4.setTargetObjectId(loggedInUser.Id);
        mail4.setSaveAsActivity(false);
        templateList = [Select t1.Name, t1.Id From EmailTemplate t1 where t1.Name =: 'Customer Portal:Mail To Customer'];
        mail4.setTemplateId(templateList.get(0).Id);
        if(!TEST_MODE1){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail4});
        }
        
        Messaging.SingleEmailMessage mail5 = new Messaging.SingleEmailMessage();
        if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail5.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail5.getCcAddresses());
              }
        //toAddresses = new String[] {'amsur@yousee.dk','savita.ramankutty@capgemini.com'};
        //mail5.setToAddresses(toAddresses);
        mail5.setBccAddresses(toBccAddresses);
        mail5.setTargetObjectId(loggedInUser.Id);
        mail5.setSaveAsActivity(false);
        templateList = [Select t1.Name, t1.Id From EmailTemplate t1 where t1.Name =: 'Customer Portal:PYS Customer Manager Email'];
        mail5.setTemplateId(templateList.get(0).Id);
        if(!TEST_MODE1){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail5});
        }
        
      }else{
        
        Messaging.SingleEmailMessage mail6 = new Messaging.SingleEmailMessage();
        if(ccTestDomain != null && ccTestDomain.Value__c != null){
                  value2 = ccTestDomain.Value__c;
                  toCCAddresses1 = value2.split(';');
                  mail6.setCcAddresses(toCCAddresses1);
                  //mail1.setToAddresses(toCCAddresses1);
                  System.debug('#toCCAddresses#'+mail6.getCcAddresses());
              }
        //toAddresses = new String[]{'amrish.surve@capgemini.com','savita.ramankutty@capgemini.com'};
        //mail6.setToAddresses(toAddresses);
        mail6.setBccAddresses(toBccAddresses);
        mail6.setTargetObjectId(loggedInUser.Id);
        mail6.setSaveAsActivity(false);
        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:PYS Customer Manager Email'];
        mail6.setTemplateId(templateList.get(0).Id);
        if(!TEST_MODE1){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail6});
        }
      }
    }
    }
    else{
      if(ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != null && ApexPages.currentPage().getParameters().get('YouSeeContactEmail') != ''){
       if(sendCopy){
            
            Messaging.SingleEmailMessage mail7 = new Messaging.SingleEmailMessage();
                //toAddresses = new String[]{ApexPages.currentPage().getParameters().get('YouSeeContactEmail')};
                //mail7.setToAddresses(toAddresses);
                mail7.setBccAddresses(toBccAddresses);
                mail7.setTargetObjectId(loggedInUser.Id);
                mail7.setSaveAsActivity(false);
                templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:Mail To Customer'];
                mail7.setTemplateId(templateList.get(0).Id);
                //mail2.setTemplateId('00XM0000000Hwf7');
                system.debug('Before Mail send ');
                if(!TEST_MODE1){
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail7 });
                }
                
                System.debug('%%%Before Email send to Consultant8');
                Messaging.SingleEmailMessage mail8 = new Messaging.SingleEmailMessage();
        toAddresses = new String[]{ApexPages.currentPage().getParameters().get('YouSeeContactEmail')};
         mail8.setToAddresses(toAddresses);
        mail8.setBccAddresses(toBccAddresses);
        mail8.setTargetObjectId(loggedInUser.Id);
        mail8.setSaveAsActivity(false);
        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:PYS Customer Manager Email'];
              mail8.setTemplateId(templateList.get(0).Id);
              if(!TEST_MODE1){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail8});
              }
            System.debug('%%%After Email send to Consultant8'+toAddresses);
       }else{
         System.debug('%%%Before Email send to Consultant9');
         Messaging.SingleEmailMessage mail9 = new Messaging.SingleEmailMessage();
         toAddresses = new String[]{ApexPages.currentPage().getParameters().get('YouSeeContactEmail')};
         mail9.setToAddresses(toAddresses);
         mail9.setBccAddresses(toBccAddresses);
         mail9.setTargetObjectId(loggedInUser.Id);
         mail9.setSaveAsActivity(false);
         templateList = [Select t.Name, t.Id From EmailTemplate t where t.Name =: 'Customer Portal:PYS Customer Manager Email'];
         mail9.setTemplateId(templateList.get(0).Id);
         if(!TEST_MODE1){
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail9});
         }
         System.debug('%%%After Email send to Consultant9'+toAddresses);
       }
      }else{
        
        if(sendCopy){
          Messaging.SingleEmailMessage mail10 = new Messaging.SingleEmailMessage();
          //toAddresses = new String []{'amsur@yousee.dk','amrish.surve@capgemini.com'};
          //mail10.setToAddresses(toAddresses);
          mail10.setBccAddresses(toBccAddresses);
          mail10.setTargetObjectId(loggedInUser.Id);
          mail10.setSaveAsActivity(false);
          templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:Mail To Customer'];
          mail10.setTemplateId(templateList.get(0).Id);
          if(!TEST_MODE1){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail10});
          }
          Messaging.SingleEmailMessage mail11 = new Messaging.SingleEmailMessage();
          //toAddresses = new String []{'amsur@yousee.dk','amrish.surve@capgemini.com'};
          //mail11.setToAddresses(toAddresses);
          mail11.setBccAddresses(toBccAddresses);
          mail11.setTargetObjectId(loggedInUser.Id);
          mail11.setSaveAsActivity(false);
          templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:PYS Customer Manager Email'];
          mail11.setTemplateId(templateList.get(0).Id);
          if(!TEST_MODE1){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail11});
          }
        }else{
          
          Messaging.SingleEmailMessage mail12 = new Messaging.SingleEmailMessage();
          //toAddresses = new String []{'amsur@yousee.dk','amrish.surve@capgemini.com'};
          //mail12.setToAddresses(toAddresses);
          mail12.setBccAddresses(toBccAddresses);
          mail12.setTargetObjectId(loggedInUser.Id);
          mail12.setSaveAsActivity(false);
          templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal:PYS Customer Manager Email'];
          mail12.setTemplateId(templateList.get(0).Id);
          if(!TEST_MODE1){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail12});
          }
        }
          
      }       
      
      
    }     
        return createAgreementsPageRef();
    }
}