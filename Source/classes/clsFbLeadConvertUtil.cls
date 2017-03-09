public class clsFbLeadConvertUtil {

    public static final String CASE_DESC_SEPARATOR = '~--------------------------------------~';

    public static Database.LeadConvertResult convertLead(Id leadId, Id accountId, Id OwnerId) {
        system.debug('### Converting lead (' + leadId + ')' + ' to account (' + accountId + ')');
        
        // Code to covert the lead
        Database.LeadConvert lc = new Database.LeadConvert();
        // Set lead id
        lc.setLeadId(leadId);
        // Set account id to merge with if applicable
        if (accountId != null)
            lc.setAccountId(accountId);
        // We never want to create opportunities for YK leads
        lc.setDoNotCreateOpportunity(true);
        // Set owner id if applicable
        if (OwnerId != null)
            lc.setOwnerId(OwnerId);
        // Set converted Lead status 
        lc.setConvertedStatus('Kvalificeret');

        Database.LeadConvertResult lcr;
        lcr = Database.convertLead(lc);

        // Now copy the lead information requests to the new account
        if (lcr.isSuccess()) {
            List<Lead_Information_Request__c> lirs = [SELECT Agent__c, Campaign__c, Date_Requested__c, Email__c, Lead__c, Name, Offer__c,
                                                             OwnerId, RecordTypeId, Send__c, Team__c, Template__c, New_Template__c
                                                      FROM Lead_Information_Request__c WHERE Lead__c = : leadId];
            
            List<Customer_Information_Request__c >cirsToCreate = new List<Customer_Information_Request__c>();
            for (Lead_Information_Request__c lir : lirs) {
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
        }
        
        return lcr;
    }
    
    @isTest
    public static void testConvertLead() {
        // Prepare KKD-14's required data
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;             
        insert custSeq;
        
        String ykLeadType = System.Label.RecordTypeYKLead;
        
        // Add custom setting required by tgrPopulateAccountInfo
        Yousee13Campaign__c yousee13 = new Yousee13Campaign__c(Name='Registration');
        insert yousee13;
        // Prepare data
        Account a = new Account(FirstName='Test', LastName='Account');
        insert a;
        Lead l = new Lead(FirstName='Test', LastName='Lead', Email='my@email.com',RecordTypeID = ykLeadType);
        insert l;
        Lead_Information_Request__c lir = new Lead_Information_Request__c();
        lir.Agent__c = 'Agent';
        lir.Date_Requested__c = Date.today();
        lir.Email__c = 'your@email.com';
        lir.Lead__c = l.Id;
        insert lir;
        
        Test.startTest();
        
        Database.LeadConvertResult lcr = convertLead(l.Id, a.Id, UserInfo.getUserId());
        
        Test.stopTest();

        // Test whether the lead was correcly converted         
        Account a2 = [ SELECT Id, Name, PersonEmail, OwnerId FROM Account WHERE Id = : a.id ];
        Lead l2 = [ SELECT Id, Name, Email, IsConverted FROM Lead WHERE Id = : l.id ];
        Customer_Information_Request__c[] cirs = [ SELECT Agent__c, Date_Requested__c, Email__c, Account__c, Template__c FROM Customer_Information_Request__c
                                                   WHERE Account__c = : a.id ];
        
        System.assert(lcr.isSuccess());
        System.assert(l2.IsConverted);
        System.assertEquals('Test Account', a2.Name);
        System.assertEquals(l.Email, a2.PersonEmail);
        //System.assertEquals(UserInfo.getUserId(), a2.OwnerId);
        
        System.assert(cirs.size() == 1);
        Customer_Information_Request__c cir = cirs[0];
        System.assertEquals(lir.Agent__c, cir.Agent__c);
        System.assertEquals(lir.Date_Requested__c, cir.Date_Requested__c);
        System.assertEquals(lir.Email__c, cir.Email__c);
    }
}