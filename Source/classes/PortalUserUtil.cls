public class PortalUserUtil {
       
        public String foreningsOrgEmailAddDisplayName =  ServiceCenter_CustomSettings__c.getInstance('ServiceCenter ForeningsOrgEmail').Value__c;
        public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('PortalUserUtil','Administrer brugere');
        public static Boolean FORCE_TEST_MODE = false; 
        public void fireMail(User user,  List<String> accountsList, string subject, string message){
          try {
                User loggedInUser = [Select email, firstname, lastname from user where Id =: userInfo.getUserId() LIMIT 1];
                
                sendMail(user, accountsList, subject, message);
                message = message.replace('din', user.email);
                sendMail(loggedInUser , accountsList, subject, message);
          } catch (Exception e){
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
           }        
        }   


        public void sendMail(User user,  List<String> accountsList, string subject, string message){
          try {
                String[] toAddresses = new String[] {'vishal.nayak@capgemini.com','priyanka.bardhan@capgemini.com'}; 
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            
               // OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Foreningsservice' limit 1];
                OrgWideEmailAddress owa = [select id, Address,DisplayName from OrgWideEmailAddress where DisplayName =: foreningsOrgEmailAddDisplayName limit 1];
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
          }  catch (Exception e){
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
                //exceptionHandler.handleException(e,'sendMail()',false,false,null);
           }       

        
        }
        
        
                 
        /**This method pre-populates the data in the Street field of the contact from the acct object. */ 


        public Contact getStreetForAccount(ID accountId, Contact contact){
        
            boolean acctAddrFlag;
            boolean contactAddrFlag;
            try{
                List<Account> acct = [Select a.Street_YK__r.Name, a.Street_YK__c, a.Name, a.Id From Account a where id=:accountId limit 1]; 
                system.debug('THE ACCT IS '+acct);
                if(acct.size() > 0){
                    String streetName = acct[0].Street_YK__r.Name;
                    //check if streetName is null for acct
                    acctAddrFlag = checkIfObjectIsNull(acct[0].Street_YK__c);
                    contactAddrFlag = checkIfObjectIsNull(contact.Street_P__c);
                    if(!acctAddrFlag){
                        System.debug('###Not null--- check value fo acctAddrFlag ###'+acctAddrFlag);
                        // for cases where we have the addr of contact already populated.
                        if(!contactAddrFlag){
                            System.debug('###Not null--- check value fo contactAddrFlag ###'+contactAddrFlag);
                            //do not change the Contact Address with Acct Address       
                            contact.Street_P__c = contact.Street_P__c;
                         }else{
                            //change the Contact Address with Acct Address
                            System.debug('###NULL--- check value fo contactAddrFlag ###'+contactAddrFlag);
                            contact.Street_P__c = acct[0].Street_YK__c;
                         }
                    }else{
                        System.debug('###ACCT ADDR IS NULL ###');
                        // acctAddrFlag is null, check if contactAddrFlag is null.
                        if(!contactAddrFlag){
                            // Dont Change the Contact Address
                            contact.Street_P__c = contact.Street_P__c;
                        }
                    }    
                  system.debug('The contact.Street_P__c is <<<<<:'+contact.Street_P__c);
                }   
            }catch (Exception e) {
                     System.debug('### error '+e);
                     ApexPages.addMessages(e);   
                    // exceptionHandler.handleException(e,'getStreetForAccount()',false,false,null);  
                }
            return contact;
        }
        
        private boolean checkIfObjectIsNull(Id addrReceived){
            if(addrReceived != null){
            // NOT NULL 
                return false;
            }else{
                //NULL
                return true;    
            } 
        }
        
        public Map<ID, ID> getAssignedCableUnits(ID contactId){
          try {
                List<Account_Contact_Role__c> acrlist = [Select a.Customer__c From Account_Contact_Role__c a where a.Contact__c =:contactId and (Role__c =: ServiceCenterSingleton.getInstance().getUserRoleId() or Role__c =: ServiceCenterSingleton.getInstance().getAdminRoleId())];
                System.debug('**ACR List**'+ acrlist);  
                Map<ID, ID> params = new Map<ID, ID>();
                for(Account_Contact_Role__c acr : acrlist) {
                    params.put(acr.Customer__c, acr.Customer__c);
                    System.debug('**Params**'+params);
                }
                return params;
          } catch (Exception e){
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMsg);
                //exceptionHandler.handleException(e,'getAssignedCableUnits()',false,false,null); 
                return null;
           }         
        }
                      
}