public class clsConvertLeadYKController {

    // Created: 1-Apr-2009
    // By: Darren Sabey
    // SOW: EMEA_SOW_YouSee_001
    // ======Requirement======
    // When a YK lead is converted show only a limited set of fields
    // and copy lead information requests from the lead to the account
    
    private Lead lead;
    public Account account {get; set;}
    public String duplicateAccountId {get; set;}    
    public List<SelectOption> duplicateAccounts;
    public String convertedLeadStatus {get; set;}    
    public List<SelectOption> convertedLeadStatuses;
    
    public clsConvertLeadYKController(ApexPages.StandardController controller) {
        Id leadId = controller.getId();
        this.lead = [Select Id, Name, Company, (Select Agent__c, Campaign__c, Date_Requested__c, Email__c, Lead__c, Name, Offer__c, OwnerId, RecordTypeId, Send__c, Team__c, Template__c, New_Template__c from Lead_Information_Requests__r) From Lead Where Id = : leadId];
        // Used to populate account owner lookup
        this.account = new Account(); 
        this.account.OwnerId = UserInfo.getUserId();
    }
         
    public List<SelectOption> getDuplicateAccounts() {
        // We need to know how many there are in advance of populating the select list
        List<Account> duplicates = new List<Account>();        
        for (Account acc : [Select Id, Name From Account Where Name = : this.lead.Name and IsPersonAccount = true Order By Name]) {
            duplicates.add(acc);
        }
        List<SelectOption> options = new List<SelectOption>();
        // If we have duplicates then force the user to look at the list
        if (duplicates.size() > 0) {
            options.add(new SelectOption('', '--None--'));
        }
        // Otherwise it can default to "Create New"
        options.add(new SelectOption(this.lead.Id, 'Create New Customer: ' + this.lead.Name));
        // Add the duplicates to the list
        for (Account acc : duplicates) {
            options.add(new SelectOption(acc.Id,'Attach to Existing: ' + acc.Name));
        }
        return options;
    }
    
    public List<SelectOption> getConvertedLeadStatuses() {
        // Display the possible lead converted statuses in the dropdown
        List<SelectOption> options = new List<SelectOption>();
        for (LeadStatus ls : [Select Id, MasterLabel From LeadStatus Where IsConverted = true]) {
            options.add(new SelectOption(ls.MasterLabel, ls.Masterlabel));
        }
        return options;
    }
    
    public PageReference convertLead() {
        // Code to covert the lead
        Database.LeadConvert lc = new Database.LeadConvert();
        // Set lead id
        lc.setLeadId(this.lead.Id);
        // Set account id to merge with if applicable
        if (this.duplicateAccountId.startsWith('001')) {
            lc.setAccountId(this.duplicateAccountId);
        }
        // We never want to create opportunities for YK leads
        lc.setDoNotCreateOpportunity(true);
        // Defaults to current user
        lc.setOwnerId(this.account.OwnerId);
        // User selects converted status 
        //lc.setConvertedStatus(this.convertedLeadStatus);
        // last minute requirement change - hide field and hard code
        lc.setConvertedStatus('Kvalificeret');
        Database.LeadConvertResult lcr;
        try {
            lcr = Database.convertLead(lc);
        } catch (Exception e) {
            System.debug('######First'+e+'###DMLTYPE'+e.getDmlType(0));
            string Err= e.getMessage();
            if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION)
            { 
            }else if(e.getDmlType(0) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
               	ApexPages.addMessage(myMsg);   
                ApexPages.addMessages(e);
            }
            // There was an exception so display the error message to the user
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));              
            return ApexPages.currentPage();
        }
        // Now copy the lead information requests to the new account
        if (lcr.isSuccess()) {
            List<Customer_Information_Request__c >cirsToCreate = new List<Customer_Information_Request__c>();
            for (Lead_Information_Request__c lir : this.lead.Lead_Information_Requests__r) {
                Customer_Information_Request__c cirToCreate = new Customer_Information_Request__c();
                cirToCreate.Agent__c = lir.Agent__c;
                cirToCreate.Campaign__c = lir.Campaign__c;
                cirToCreate.Date_Requested__c = lir.Date_Requested__c;
                cirToCreate.Email__c = lir.Email__c;
                cirToCreate.Account__c = lcr.getAccountId();
                cirToCreate.Offer__c = lir.Offer__c;
                cirToCreate.Send__c = lir.Send__c;
                cirToCreate.Team__c = lir.Team__c;
                cirToCreate.Template__c = lir.Template__c;
                cirToCreate.New_Template__c = lir.New_Template__c;
                cirsToCreate.add(cirToCreate);
            }
            // Insert the information request records
            Database.SaveResult[] results = Database.insert(cirsToCreate, true);
            // Navigate the user to the new account
            PageReference pr = new PageReference ('/' + lcr.getAccountId());
            return pr;                    
        } else {
            // Navigate the user to the lead convert screen displaying the error message
            System.debug('######Inside B');
            for (Database.Error error : lcr.getErrors()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, error.getMessage()));              
            }   
            PageReference pr = ApexPages.currentPage();
            return pr;
        }
    }
}