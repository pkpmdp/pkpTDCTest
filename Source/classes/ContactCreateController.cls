public with sharing class ContactCreateController {
 
    public String myparam;
    ServiceCenter_CustomSettings__c cs = ServiceCenter_CustomSettings__c.getValues('ServiceCenter Portal Administrator');
    String portalAdminUser;
    public String getMyparam(){
        return myparam;
    }       
    
    public void setMyparam(String param){
        myparam = param;
    
    }
    
    public User user{
      get {
        if (user == null){
             user = new User();
        }     
        return user;
    }
    set;
    }
    
     
  // the contact record you are adding values to
  public Contact contact {
    get {
      if (contact == null)
        contact = new Contact();
      return contact;
    }
    set;
  }
 
  public ContactCreateController() {  
    
  }
 
  // save button is clicked
  /*public PageReference save() {
    try {
    
   // insert contact; // inserts the new record into the database
 
      //get the contact.id and pass it to the user.ContactId
      contact.CanAllowPortalSelfReg = true;
      //user.IsPortalEnabled = true;
       String portalAdminUser = cs.Value__c;
       //String portalAdminUser = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal Administrator').Value__c;
       ID profileId = [ Select id from Profile where name =: portalAdminUser].id;
       user.ContactId = contact.id;
       user.email = contact.email;
       user.profileid = profileId;
       user.UserName = contact.LastName;
       user.Alias = contact.FirstName;
       user.CommunityNickName = contact.FirstName;
       user.TimeZoneSidKey='America/New_York';
       user.LocaleSidKey='en_US';
       user.EmailEncodingKey='ISO-8859-1';         
       user.LanguageLocaleKey='en_US';
       user.FirstName = contact.FirstName;
       user.LastName = contact.LastName; 
       insert user;      
            
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.'));
      return null;
    }
 
    // if successfully inserted new contact, then displays the thank you page.
    return Page.Contact_Create_Thankyou;
  }*/
 
}