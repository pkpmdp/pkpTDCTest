trigger DummyContactForDealer on Account (after insert) {
   
   // this trigger will get fired only when the record type is forhandlerweb    
   for (Account account : Trigger.new) {
            if(account.RecordTypeName__c =='Forhandlerweb'){
               String mID= account.Dealer_Number__c;  
               Contact contact = createContact(account); 
               createUser(contact,mID);  
               sendMail(contact.id); 
               contact.EmailTemplatePassword__c = '';  
               update contact;     
            }
   }  
    
   // creates new contact 
   public Contact createContact(Account account){
    
       
             Contact contact = new Contact();
             try{
                 contact.accountId = account.id; 
                 contact.email = account.Email__c;
                 contact.LastName = account.name;
                 contact.FirstName = account.name;
                 contact.phone = account.phone;
                 contact.Street_P__c = account.Street_YK__c; 
                 contact.EmailTemplatePassword__c = generatePassword();
                 insert contact;   
                 return contact;     
            }catch(Exception ex){
                String errorMsg = ex.getMessage();
                if(errorMsg.contains('first error:')){
                    errorMsg = errorMsg.subString(errorMsg.indexOf('first error:') + 12,errorMsg.length());
                }
                trigger.new[0].addError(errorMsg);
                system.debug('error in DummyContactForDealer trigger--------'+errorMsg); 
             }
            system.debug('contact id generated is ---------'+contact.id);   
            return contact;
    }
      
    // creates new user 
    public User createUser(Contact contact, String mId){
             Profile profile = [Select id from Profile where name = 'YouSee Customer Portal User' limit 1];
             User user = new User( 
             email=contact.Email,contactid = contact.id, profileid = profile.Id, UserName=contact.Email,
             alias=(contact.lastName).substring(0, 3), CommunityNickName=contact.lastName, 
             LocaleSidKey='da_DK', 
             TimeZoneSidKey = 'Europe/Paris',
             EmailEncodingKey='ISO-8859-1',         
             LanguageLocaleKey='da', FirstName = contact.firstname, LastName = contact.lastname,
             isActive = true, MID__c = mId);
             try{
                 insert user;
                 System.setPassword(user.id, contact.EmailTemplatePassword__c);
                 return user;
             }catch(Exception ex){
                String errorMsg = ex.getMessage();
                if(errorMsg.contains('first error:')){
                    errorMsg = errorMsg.subString(errorMsg.indexOf('first error:') + 12,errorMsg.length());
                }
                trigger.new[0].addError(errorMsg);
             }  
             return user;   
    }   
    
    
    // send a mails to the dealer using the template
    public void sendMail(Id contactId)
    {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'NewUserEmail2'];  
            system.debug('value of contactId id ======------4$$$$$$$'+contactId);
            mail.setTargetObjectId(contactId); // Specify who the email should be sent to.
            mail.setOrgWideEmailAddressId(getOrgWideEmailAddress());
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
    } 
    
    public ID getOrgWideEmailAddress() {
            OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where DisplayName = 'YouSee Forhandler Support' limit 1];
            system.debug('value of OrgWideEmailAddress id ======------4$$$$$$$'+owa.id);
            return owa.id;
    }
    
   
    /**
    *@method generatePassword
    *@Return String
    *@Descrioption: This method is used to generate a password.
    */
    private String generatePassword(){
    		String userPassword = ServiceCenterTestUtil.getRandomAlphaNumericParam(6);
			userPassword += ServiceCenterTestUtil.getRandomCharsName(3) + ServiceCenterTestUtil.getRandomNumeric(3);
			return userPassword;
    		/**
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            key = key.substring(0,6);
            String password = 'a1';
            password = password + key;
            return password;
            */
    }
    
    
}