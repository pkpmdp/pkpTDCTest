public class YSLeadConvert{
    public ApexPages.standardController controller;
    public Account acc;
    public Lead lead; 
    public Contact con;
    public String convertedStatus;
    Boolean overWriteLeadSource ;
    public String leadID{get;set;}
    public String accountID{get;set;}
    public String ownerId;  
    public List<Account_Contact_Role__c> lstConRole;

    public YSLeadConvert(ApexPages.StandardController stdController) {
        controller = stdController;
        lead = [SELECT firstname, lastname, Account__c, MobilePhone, email, Street_Lookup__c, PORoles__c,PORoles__r.Name, description, Home_Phone__c, company, OwnerId FROM Lead WHERE Id = :((Lead) controller.getRecord()).Id];    
        Map<String,Object> result = new Map<String,Object>();
        overWriteLeadSource = false;
        system.debug('lead======'+lead);
        leadID = lead.id;
        accountID = lead.Account__c; 
        System.debug('rrrrr'+accountID);
        ownerId = lead.OwnerId;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		//lc.setConvertedStatus(convertStatus.MasterLabel);        
        convertedStatus= convertStatus.MasterLabel;       
        //result = convertLead(lead.id, lead.Account__c, convertedStatus, overWriteLeadSource);   
        lstConRole = new List<Account_Contact_Role__c> ();
         System.debug('wwww122'+lstConRole);
        lstConRole = [Select RoleName__c, Customer__c From Account_Contact_Role__c  where Customer__c =:accountID  and RoleName__c = 'Administrator'];     
    	System.debug('wwww'+lstConRole);
    }
    
     
    public PageReference convertLead() {
        Map<String, String> result =new Map<String, String>();
		
		 // Jira Task SF-2266 
        if(ownerId.startsWith('00G') == TRUE){
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Et lead kan ikke have en kø som ejer, venligst tag ejerskab inden du konvertere.');
            ApexPages.addMessage(m); 
            return null;
        }
         // Jira Task SF-2266 
        if(leadID == null || accountID == null || lead.PORoles__c == null || lead.Account__c == null || lead.Street_Lookup__c == null) {
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Følgende felter "Rolle", "Kundenavn", "Gadenavn" er krævet felter og skal udfyldes inden du konvertere.');
            ApexPages.addMessage(m); 
            return null;  
        }
        // Jira Task SF-2266 
        if(lead.PORoles__c!= null && lead.PORoles__r.Name == 'Administrator' && !lstConRole.isEmpty()) {
        	ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Tillføjelse af kontaktrolle ikke mulig. Der må maks være 1 \'Administrator\' -rolle(r) tilknyttet kunder af typen \'Kunde\'');
            ApexPages.addMessage(m); 
            return null;
        }
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadID);
        lc.setOverwriteLeadSource(overWriteLeadSource);
        lc.doNotCreateOpportunity=true;
        lc.setConvertedStatus(convertedStatus);
        if (accountId != null && accountId.length() > 0) 
        	lc.setAccountId(accountId);
        Database.LeadConvertResult lcr;
        try{
        	 lcr = Database.convertLead(lc, true);
            System.debug('checking'+lcr);
        } catch (Exception e){
        	ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage());
            ApexPages.addMessage(m); 
            return null;
        }    
        if (lcr.isSuccess()) {
            result.put('AccountID', lcr.getAccountId());
            result.put('ContactID', lcr.getContactId());
            List<Contact> contacts = new List<Contact>();
            List<Account_Contact_Role__c> acrs = new List<Account_Contact_Role__c> ();           
            Contact c = new Contact(ID=lcr.getContactId());
            c.AccountId = null;
            c.homephone = lead.Home_Phone__c;
            c.Company_Customer__c = lead.company;
            contacts.add(c);
            try{
                update contacts;
                } 
            catch(Exception e){
                 ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'error update contact from converting'+e.getmessage()); 
                 ApexPages.addMessage(m);
                 return null;       
            }               
            clsContactsAddAccount util = new clsContactsAddAccount();  
            util.addDummyAccounts(contacts);
            if(lead.PORoles__c!= null) {
                Account_Contact_Role__c acr = new Account_Contact_Role__c();
                acr.Customer__c = accountID;                   
                acr.Contact__c = lcr.getContactId();
                acr.Role__c = lead.PORoles__c;
                acrs.add(acr);
            }           
            try{    
                insert acrs;
            } catch(Exception e){
                 ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'error create ACR'+e.getmessage()); 
                 ApexPages.addMessage(m);
                 return null;       
            }                          
         } else {
             ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'error convertion'); 
             ApexPages.addMessage(m);
             return null;       
         }
           
        return new Pagereference('/'+lcr.getContactId());         
    }     

}