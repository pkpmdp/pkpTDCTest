// Converts a lead as a step in a Visual Workflow process
global class VWFConvertLead implements Process.Plugin {
    // This method runs when the step is reached in a Flow
    global Process.PluginResult invoke(Process.PluginRequest request) {
        // set up variables to store input parameters from the Flow
        String leadID = (String) request.inputParameters.get('LeadID');
        String contactID = (String) request.inputParameters.get('ContactID');
        String accountID = (String) request.inputParameters.get('AccountID');
        String anlaegNo = (String) request.inputParameters.get('Anlaeg');        
        String convertedStatus = (String) request.inputParameters.get('ConvertedStatus');
        Boolean overWriteLeadSource = (Boolean) request.inputParameters.get('OverwriteLeadSource');
        Boolean createOpportunity = (Boolean) request.inputParameters.get('CreateOpportunity');        
        String opportunityName = (String) request.inputParameters.get('ContactID');
        Boolean sendEmailToOwner = (Boolean) request.inputParameters.get('SendEmailToOwner');
        //String roleID = (String) request.inputParameters.get('LeadRoleID');   
        
        // Set the default handling for booleans 
        if (overWriteLeadSource == null) overWriteLeadSource = false;
        if (createOpportunity == null) createOpportunity = false;
        if (sendEmailToOwner == null) sendEmailToOwner = false;
        
        // convert the lead by passing to a helper method
        Map<String,Object> result = new Map<String,Object>();
        result = convertLead(leadID, contactID, accountID, anlaegNo,convertedStatus, overWriteLeadSource, createOpportunity, opportunityName, sendEmailToOwner);
 
        return new Process.PluginResult(result); 
    }
    
    // This method describes this plugin, as well as its inputs and outputs to the Cloud Designer
    // NOTE: Implementing this method is what makes this class appear in the designer
    global Process.PluginDescribeResult describe() {
        // Set up plugin metadata
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'The LeadConvert Flow Plug-in converts a lead into an account and contact, as well as (optionally) an opportunity.';
        result.tag = 'Lead Management';
        
        // create a list that stores both mandatory and optional *input* parameters from a Flow
        // NOTE: Only primitive types (STRING, NUMBER, etc) are supported at this time.
        // Collections are not currently supported
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            // Lead ID (mandatory)
            new Process.PluginDescribeResult.InputParameter('LeadID', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            // Account Id (optional)
            new Process.PluginDescribeResult.InputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            // Contact ID (optional)
            new Process.PluginDescribeResult.InputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Anlaeg',
                    Process.PluginDescribeResult.ParameterType.STRING, false),           
            // Status to use once converted
            new Process.PluginDescribeResult.InputParameter('ConvertedStatus', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('OpportunityName', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('OverwriteLeadSource', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('CreateOpportunity', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('SendEmailToOwner', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false)
           /* new Process.PluginDescribeResult.InputParameter('LeadRoleID', 
                    Process.PluginDescribeResult.ParameterType.String, true) */                                                
        };

        // Create a list that stores *output* parameters sent *to* your flow.
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            // Account ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING),
            // Contact ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING)
            // Opportunity ID of the converted lead
            /*new Process.PluginDescribeResult.OutputParameter('OpportunityID', 
                    Process.PluginDescribeResult.ParameterType.STRING),*/
                    
            /*new Process.PluginDescribeResult.OutputParameter('ACRID', 
                    Process.PluginDescribeResult.ParameterType.STRING)  */                                 
        };

        return result;
    }
        
    /**
     * Implementation of the LeadConvert plugin
     * Converts a given lead with several options:
     * leadID - The ID of the lead to convert
     * contactID - 
     * accountID - ID of the Account to attach the converted Lead/Oppty/Contact to.
     * convertedStatus - 
     * overWriteLeadSource - 
     * createOpportunity - true if you want to create a new Opportunity upon conversion
     * opportunityName - Name of the new Opportunity.
     * sendEmailtoOwner - true if you are changing owners upon conversion and want to send an email to the new owner of the Oppty.
     *
     * returns: a Map with the following output:
     * AccountID - ID of the Account created or attached to upon conversion.
     * ContactID - ID of the contact created or attached to upon conversion.
     * OpportunityID - ID of the opportunity created upon conversion.
     */
    public Map<String,String> convertLead (
                               String leadID,
                               String contactID,
                               String accountID,
                               String anlaegNo,                            
                               String convertedStatus,
                               Boolean overWriteLeadSource,
                               Boolean createOpportunity,
                               String opportunityName,
                               Boolean sendEmailToOwner                               
        ) {
        Map<String,String> result = new Map<String,String>();
                                
        if (leadId == null) throw new ConvertLeadPluginException('Lead Id cannot be null');
        
        // check for multiple leads with the same ID
        Lead[] leads = [Select Id, FirstName, LastName, Company, Anlaeg_No__c From Lead where Id = :leadID];
        if (leads.size() > 0) {
            Lead l = leads[0];
            System.debug('****Wen lead debug'+l.id+'Account'+accountID);            
            // CheckAccount = true, checkContact = false
            if ((accountID == null || accountID == '') && l.Company != null) {
                System.debug('*****Wen lead anlaeg'+l.Anlaeg_No__c);            
                Account[] accounts = [Select Id, Name FROM Account where Name = :l.Company AND Anlaeg_No__c =: l.Anlaeg_No__c LIMIT 1];
                if (accounts.size() > 0) {
                    accountId = accounts[0].id;
                    System.debug('******Wen'+accountId);        
                }
            } 
            
            // perform the lead conversion
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadID);
            lc.setOverwriteLeadSource(overWriteLeadSource);
            lc.setDoNotCreateOpportunity(!createOpportunity);
            lc.setConvertedStatus(convertedStatus);
            if (sendEmailToOwner != null) lc.setSendNotificationEmail(sendEmailToOwner);
            if (accountId != null && accountId.length() > 0) lc.setAccountId(accountId);
            if (contactId != null && contactId.length() > 0) lc.setContactId(contactId);
            /*if (createOpportunity) {
                lc.setOpportunityName(opportunityName);
            }*/
            
            Database.LeadConvertResult lcr = Database.convertLead(lc,true);
            if (lcr.isSuccess()) {
                result.put('AccountID', lcr.getAccountId());
                result.put('ContactID', lcr.getContactId());
                List<Contact> contacts = new List<Contact>();
                Contact c = new Contact(ID=lcr.getContactId());
                c.AccountId = null;
                //c.Company_Customer__c = 
                update c;
                contacts.add(c);
                clsContactsAddAccount util = new clsContactsAddAccount();  
                util.addDummyAccounts(contacts);
                if (createOpportunity) {
                    result.put('OpportunityID', lcr.getOpportunityId());
                }          
            } else {
                String error = lcr.getErrors()[0].getMessage();
                throw new ConvertLeadPluginException(error);
            }
        } else { 
            throw new ConvertLeadPluginException('No leads found with Id : "' + leadId + '"');
        }
        return result;
    }
        
        // Utility exception class
        class ConvertLeadPluginException extends Exception {}
/*
   static testMethod void basicTest() {
		testData();
        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
    
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        VWFConvertLead aLeadPlugin = new VWFConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        
    }
*/
 /*
  * This test is to test the convert Lead with the Account ID specified
  
       static testMethod void basicTestwithAccount() {
		testData();
         Account testAccount = testAccount();
        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe',Phone='12345',Street_Lookup__c=testAccount.Street_YK__c);
        insert testLead;
        
        
    
           // System.debug('ACCOUNT BEFORE' + testAccount.ID);

        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        VWFConvertLead aLeadPlugin = new VWFConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('AccountID',testAccount.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        //System.debug('ACCOUNT AFTER' + aLead.convertedAccountID);
        System.AssertEquals(testAccount.ID, aLead.convertedAccountID);
    }
*/
/*
  * This test is to test the convert Lead with the Account ID specified
  */
       static testMethod void basicTestwithAccounts() {
		testData();
          Account testAccount1 = testAccount(); 
        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe',Phone='12345',Street_Lookup__c=testAccount1.Street_YK__c,RecordTypeid='012200000000nzaAAA');
           insert testLead;
        
       // Account testAccount1 = testAccount();
       /* Account testAccount2 = new Account(name='Test Lead');
        insert testAccount2;*/

           // System.debug('ACCOUNT BEFORE' + testAccount.ID);

        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        VWFConvertLead aLeadPlugin = new VWFConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
    }


 /*
  * -ve Test
  */    
    static testMethod void errorTest() {

        // Create dummy lead
        //Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        VWFConvertLead aLeadPlugin = new VWFConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        inputParams.put('LeadID','00Q7XXXXxxxxxxx');
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        try {
            result = aLeadPlugin.invoke(request);    
        }
        catch (Exception e) {
          System.debug('EXCEPTION' + e);
          System.AssertEquals(1,1);
        }
        
    }
    
    
 /*
  * This test is to test the describe() method
  */ 
        static testMethod void describeTest() {

                VWFConvertLead aLeadPlugin = new VWFConvertLead();
                Process.PluginDescribeResult result = aLeadPlugin.describe();
                
                System.AssertEquals(result.inputParameters.size(), 9);
                System.AssertEquals(result.OutputParameters.size(), 2);
        
        }
    static void testData(){
       
        Yousee13Campaign__c customsetting =new Yousee13Campaign__c();
        customsetting.Name = 'Registration';
        customsetting.SiteGuestUserId__c = '005M0000004Odn8';
        customsetting.Lead_RecordType__c = '012200000000nzaAAA';
        insert customsetting;
        
        YSRecordTypes__c custSet = new YSRecordTypes__c();
        custSet.Name = 'YSRecordTypes';
        custSet.YS_Contact_Record_Type__c = '012M0000000Clg3';
        insert custSet;
        
        ServiceCenter_CustomSettings__c cus1 = new ServiceCenter_CustomSettings__c();
        cus1.Name = 'UserDataloadNoOutboundId';
        cus1.Value__c = '005M0000004cVgBIAU';
        insert cus1;
        ServiceCenter_CustomSettings__c cus2 = new ServiceCenter_CustomSettings__c();
        cus2.Name = 'UserCIID';
        cus2.Value__c = '005200000012Dn3AAE';
        insert cus2;
        ServiceCenter_CustomSettings__c cus3 = new ServiceCenter_CustomSettings__c();
        cus3.Name = 'UserAPINOId';
        cus3.Value__c = '005M0000004cVkwIAE';
        insert cus3;
		
    }
    static Account testAccount(){
       	
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Cable_Unit_No__c='0000001570';
        insert cableUnitTest;
        
         Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301'; 
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr;
        
        RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YS Customer Account'];  
        Account account = new Account();                     
        account.RecordTypeId =recordType.Id;
        account.Status_YK__c = 'Active';
        account.Name='Test Lead';
        account.Invoice_Test__c = true;
        account.Customer_No__c='982929';
        account.Street_YK__c = addr.Id;
        account.Billing_Address__c = addr.Id;
        account.Cable_Unit__c = cableUnitTest.Id;
       // account.Net_Installation__c = netInstallold.Id;
        account.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert account;
        
        return account;
    }

 }