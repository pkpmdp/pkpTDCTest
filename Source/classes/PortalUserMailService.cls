/** 

 Title: PortalUserMailService

 Purpose: This service will handle all mails sent when a portal user is updated, created & deleted
 
 Functionality : Manage Portal Users
 
 Application: ServiceCenter Application
   
*/


public class PortalUserMailService{ 
   //Variable for picking the display name from custom setting
    public String portalOrgEmailAddressDisplayName{get; set;}
    public String kontraktOrgEmailDisplayName =  ServiceCenter_CustomSettings__c.getInstance('ServiceCenter kontraktOrgEmail').Value__c;
    public String foreningsOrgEmailAddDisplayName =  ServiceCenter_CustomSettings__c.getInstance('ServiceCenter ForeningsOrgEmail').Value__c;
    //Testing team can add Email In this custom settings for Testing purpose(scTestDomain), On Production it will have null values 
    ServiceCenter_CustomSettings__c scTestDomain = ServiceCenter_CustomSettings__c.getValues('Production_CC_EmailSettings');
    ServiceCenter_CustomSettings__c scProductionDomain = ServiceCenter_CustomSettings__c.getValues('Production_Email_Setting');
    ServiceCenter_CustomSettings__c scToAddresses = ServiceCenter_CustomSettings__c.getValues('Test_ToAddresses');

    public static User userTest{get;set;}
    public String[] toCCAddresses;
    public List<User> user1 = new List<User>();
    public static User user2{get;set;}
    public static List<User> userMailTest{get;set;}
    public List<User> tempUser = new List<User>();
    public static string userPassword{get;set;}
    public static Contact con{get;set;}
    public static Contact con1{get;set;}
    public static String dt1{get;set;}
    public DateTime dt{get;set;}
    public static Boolean FORCE_TEST_MODE = false;
     /*--- Reading logged in usres details ----*/
    public User getLoggedInUserDetails(){
        User loggedInUser = [Select email, username ,firstname, lastname from user where Id =: userInfo.getUserId() LIMIT 1];
        return loggedInUser;
    }
 
    public void sendMailPortalUserCreation(String password, Contact contact){
        try{
        String[] toAddresses;
        List<EmailTemplate> templateList = null;
        
        user1 = [Select Id, username, email, name from User where ContactId =: contact.Id];
        if(user1.size() > 0){
            userPassword = password;
            system.debug('%%%%%%%%%%%%Second%%'+userPassword);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            toAddresses = new String[]{'priyanka.bardhan@capgemini.com'};
            system.debug('$toAddress$'+toAddresses);
            mail.setToAddresses(toAddresses);
            mail.setTargetObjectId(user1[0].Id);
            mail.setSaveAsActivity(false);
            //mail.setTemplateId('00XM0000000HvEZ');
            mail.setBccSender(false);
            templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal: Customer Portal New User Login Information (Service Center)'];
            mail.setTemplateId(templateList.get(0).id);
            if(!PortalUserService.TEST_MODE){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }   
            system.debug('$$$Mail send$$');
        }
        }catch(EmailException e){
            System.debug('exception in mail service  ----'+e);
        throw e;
      }
    }

    public void sendMailPortalUserCreationTest(String password, Contact contact){
        //String[] toAddreses;
        System.debug('Inside sendMailPortalUserCreationTest**');
        //String serverURL = ApexPages.currentPage().getHeaders().get('Host');
        String value;
        //System.debug('#serverURL#'+serverURL);
        System.debug('$newely password$'+password);
        System.debug('Contact Details'+contact);
        userMailTest = new List<User>();
        if(contact.Id != null){
            userMailTest = [Select Id,username,Name, Email, FirstName, LastName From User where ContactId =: contact.Id];
            System.debug('##userMailTest##'+userMailTest);
            List<String> toAddreses = new List<String>();
            List<EmailTemplate> templateList1 = null;
            //User tempUser = [Select Id, email, firstname, lastname from user where Email = 'tiols@yousee.dk' AND Name = 'Tina Olsen' LIMIT 1];
            //Id tempUserId = userInfo.getUserId();
            //System.debug('User Details'+tempUser);
            //user1 = [Select Id, username, email, name from User where ContactId =: contact.Id];
            System.debug('#User1 Details#'+user1);
            OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
            
            if(userMailTest.size() > 0 ){
                userPassword = password;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //if(serverURL == scTestDomain.Value__c){
                  //System.debug('@Inside test Server@'+serverURL+'Test Domain'+scTestDomain.Value__c);
                  //if(scToAddresses != null && scToAddresses.Value__c != null){
                    //value = scToAddresses.Value__c;
                    //this.toCCAddresses = value.split(';');
                    //System.debug('#To CC Addresses#'+this.toCCAddresses);  
                    if(scTestDomain != null && scTestDomain.Value__c != null){
                      value = scTestDomain.Value__c;
                      this.toCCAddresses = value.split(';');
                      mail.setCcAddresses(toCCAddresses);
                      
                    }
                    //toAddreses = new String[]{'priyanka.bardhan@capgemini.com','poth@tdc.dk','amsur@tdc.dk'};
                    //mail.setToAddresses(toCCAddresses);
                  //}  
                //}  
                
                //mail.setToAddresses(toAddreses);
                System.debug('mail.setCcAddresses'+mail.getCcAddresses());
                mail.setTargetObjectId(userMailTest[0].Id);
                mail.setSaveAsActivity(false);
                templateList1 = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal: Customer Portal New User Login Information (Service Center)'];
                mail.setTemplateId(templateList1.get(0).Id);
                //mail.setTemplateId('00XM0000000HvEZ');
                mail.setOrgWideEmailAddressId(owa.Id);
                System.debug('.'+ mail);
                if(!PortalUserService.TEST_MODE){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                }   
                System.debug('After Sending Email '+mail);
           } 
       }
    }
    
   public void sendMailUserCreation(String password, Contact contact){
        System.debug('sendMailUserCreation');
        List<String> toAddresses = new List<String>();
        List<User> userTemp = [Select Id, Name, Email , Username, ContactId From User Where ContactId =:contact.Id];
        String strBody = '';
        strBody = 'Hej' + userTemp[0].Name + '<br/>';
        strBody = strBody + 'Velkommen til YouSee Selvbetjening og din adgang til selvbetjening på yousee.dk/foreninger.' + '<br>/';
        strBody = strBody + '<b>Dit Login til Servicecenter er: </b><br/><br/>';
        strBody = strBody + 'Brugernavn :' + userTemp[0].Email + '<br/>';
        strBody = strBody + 'Adgangskode :'+ password + '<br/>';
        strBody = strBody + 'Du kan logge ind på Selvbetjeningsportalen ved at klikke på linket nedenfor<br/><br/>';
        //strBody = strBody + '<a href="https://cs7.salesforce.com/secur/login_portal.jsp?orgId=00DM0000000ARWB&portalId=060M00000000Q7r"><br/>';
        strBody = strBody + 'Har du spørgsmål eller brug for hjælp, er du velkommen til at kontakte os på 70 70 40 44 eller e-mail: foreningsservice@yousee.dk <br/><br/><br/>';
        strBody = strBody + 'Venlig hilsen<br/><br/>';
        strBody = strBody + 'YouSee Foreningsservice';
        Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
        toAddresses = new String[]{System.label.Recipient_email,System.label.Recipient_email1};
        sem.setUseSignature(false);
        sem.setCharset('UTF-8');
        sem.setToAddresses(toAddresses);
        sem.setSubject('Mail For User Creation');
        sem.setHtmlBody(strBody);
        system.debug('$Before Sending Mail$'+ strBody);
        if(!FORCE_TEST_MODE){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
        }
        system.debug('$after Sending Mail$'+ strBody);
        
   }
    
    
    public void sendMailForAccountDetached(User user, List<Account> accountsList){
        if(user != null){
            String[] toAddresses = new String[] {'priyanka.bardhan@capgemini.com'}; 
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('foreningsservice@yousee.dk');
            mail.setSubject('Kunde fjernet');
            mail.setSenderDisplayName(foreningsOrgEmailAddDisplayName);
            string strBody;
            strBody= 'Kære ' + user.firstname + '  ' + user.lastname + '<br>'; 
            strBody= strBody+ '<p> Følgende Kunde er ikke længere tilknyttet din profil på YouSee´s Servicecenter: <br> ';
            for(Account account : accountsList){
                String accountName;
                if(account.Anlaeg_No__c != null) {
                    accountName = account.name + ' ' + account.Anlaeg_No__c;
                }else{
                    accountName = account.name;
                } 
                strBody =strBody+ '<p> ' + accountName + '  <br>';
            } 
            strBody= strBody+' <br> <br>  Venlig hilsen <br> <br> '; 
            strBody= strBody+' YouSee A/S <br>';
            strBody= strBody+' Teglholmsgade 1 <br>';
            strBody= strBody+' 0900 København C <br>';
            strBody= strBody+' Tlf. 70 70 40 00 <br>';
            strBody= strBody+' E-mail: Foreningsservice@Yousee.dk <br>';
            strBody= strBody+' Web: Yousee.dk <br>';
            strBody= strBody+' CVR-nr. 25 76 75 78 <br>';
            mail.setHtmlBody(strBody);
            if(!FORCE_TEST_MODE){
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }  

    public void sendMailForAccountAssignment(User user, List<Account> accountsList){
        system.debug('$Send Mail For Account Assignment$');
        String[] toAddresses = new String[] {'priyanka.bardhan@capgemini.com','poonam.thergaonkar@capgemini.com','pba@yousee.dk','abhipsa.sahu@capgemini.com'}; 
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('foreningsservice@yousee.dk');
        mail.setSubject('Kunde tilføjet');
        mail.setSenderDisplayName(foreningsOrgEmailAddDisplayName);
        string strBody;
        strBody= 'Kære ' + user.firstname + '  ' + user.lastname + '<br>'; 
        strBody= strBody+ '<p> Følgende kunde er nu tilknyttet din profil på YouSee´s Servicecenter: <br> ';
        for(Account account : accountsList){
            String accountName;
            if(account.Anlaeg_No__c != null) {
                accountName = account.name + ' ' + account.Anlaeg_No__c;
            }else{
                accountName = account.name;
            } 
            strBody =strBody+ '<p> ' + accountName + '  <br>';
        } 
        strBody= strBody+' <br> <br>  Venlig hilsen <br> <br> '; 
        strBody= strBody+' YouSee A/S <br>';
        strBody= strBody+' Teglholmsgade 1 <br>';
        strBody= strBody+' 0900 København C <br>';
        strBody= strBody+' Tlf. 70 70 40 00 <br>';
        strBody= strBody+' E-mail: Foreningsservice@Yousee.dk <br>';
        strBody= strBody+' Web: Yousee.dk <br>';
        strBody= strBody+' CVR-nr. 25 76 75 78 <br>';
        mail.setHtmlBody(strBody);
        if(!FORCE_TEST_MODE){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        system.debug('send Mail End');
    }  
        
    public void sendMailPortalUserUpdation(Contact  contact){
        system.debug('**Inside sendMailPortalUserUpdation**');
        system.debug('Contact Id**'+contact.Id);
        system.debug('Contact**'+contact);
        system.debug('Contact Address**'+contact.Address_merge_field__c);
        con1 = [select c.Address_merge_field__c from Contact c where c.Id =:contact.Id];
        system.debug('***con1.Address_merge_field__c**'+con1.Address_merge_field__c);
        con = contact;
        dt1 = getTodayDate();
        user2 = [Select Id,username,email,name from user where ContactId =: contact.Id];
        system.debug('**User info'+user2.Id+'**'+user2.email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<EmailTemplate> templateList = null;
        String[] toAddresses;
        toAddresses = new String[]{user2.Email,'tiols@yousee.dk','ashwini.shinde@capgemini.com','savita.ramankutty@capgemini.com','poonam.thergaonkar@capgemini.com'};
        mail.setToAddresses(toAddresses);
        mail.setTargetObjectId(user2.Id);
        mail.setSaveAsActivity(false);
        templateList = [Select e.Name, e.Id From EmailTemplate e where e.Name =: 'Customer Portal: Customer Portal Updated Info Email Template'];
        mail.setTemplateId(templateList.get(0).id);
        if(!FORCE_TEST_MODE){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }

    public void sendMail(User user,  List<String> accountsList, string subject, string message){
        String[] toAddresses = new String[] {'priyanka.bardhan@capgemini.com'}; 
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
     /*   OrgWideEmailAddress owa = 
        [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
       */ 
       OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
       
           
        /*OrgWideEmailAddress owa = 
        [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName =: foreningsOrgEmailAddDisplayName limit 1];*/
     
        mail.setOrgWideEmailAddressId(owa.id);
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        
        string strBody;
        strBody= 'Kære  ' + user.firstname + '  ' + user.lastname + '<br>'; 
        strBody= strBody+ '<p> '+  message + '<br> ';
        strBody =strBody+ '<p><Table width=40% border=1>';
        strBody =strBody+ '<tr bgcolor="#B2B2B2">';
        strBody =strBody+ '<td> <b> Kunde </b></td>';
        strBody=strBody + '</tr>';  
            
        for(String account : accountsList){
            strBody =strBody+ '<tr>';
            strBody =strBody+ '<td> ' + account + ' </td>';
            strBody =strBody+ '</tr>';
        } 
        
        strBody=strBody + '</tr>';  
        strBody=strBody + '</Table>';
        
        strBody= strBody+' <br> <br>  Venlig hilsen <br> <br> '; 
        
        strBody= strBody+' YouSee A/S <br>';
        strBody= strBody+' Teglholmsgade 1 <br>';
        strBody= strBody+' 0900 København C <br>';
        strBody= strBody+' Tlf. 70 70 40 00 <br>';
        strBody= strBody+' E-mail: Foreningsservice@Yousee.dk <br>';
        strBody= strBody+' Web: Yousee.dk <br>';
        strBody= strBody+' CVR-nr. 25 76 75 78 <br>';
                     mail.setHtmlBody(strBody);
        if(!FORCE_TEST_MODE){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public string getTodayDate(){
        dt = datetime.now();
        return dt.format('dd-MM-yyyy');
    }
 }