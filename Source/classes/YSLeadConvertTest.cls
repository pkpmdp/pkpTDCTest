@isTest(seeAllData = true)
private class YSLeadConvertTest {
 
    static testMethod void myUnitTest() {
        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        Lookup_Contact_Roles__c LCR =  clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle351');
        Lookup_Contact_Roles__c LCRAdmin =  clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Administrator');
        Address__c add = setupDummyAddress();
        Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
        
        Lookup_Contact_Roles__c lc=new Lookup_Contact_Roles__c();
        lc.Code__c='';
        lc.Portal_Description__c='';
        lc.SourceId__c='';
        lc.Visible_in_Service_Centre__c=true;
        lc.Vis_i_kontrakt__c=true;
       
        insert lc;
        
        Lead lead1 = new Lead();
        lead1.Anlaeg_No__c = acc.Cable_Unit__r.Cable_Unit_No__c;
        lead1.Anlaeg_Name__c =  acc.Cable_Unit__r.Name;
        lead1.Account__c = acc.Id;
        lead1.Title = 'Guest';
        lead1.FirstName = 'Me';
        lead1.LastName = 'N Marley';
        lead1.MobilePhone = '10000';
        lead1.Street_Lookup__c = add.id;
        lead1.Email= 'test1234@gmail.com';
        lead1.RecordTypeId = '012200000000nza';
        lead1.PORoles__c = lc.id;
        lead1.Description = 'Test Desc';
        insert lead1;
        
        Lead lead = new Lead();
        lead.Anlaeg_No__c = acc.Cable_Unit__r.Cable_Unit_No__c;
        lead.Anlaeg_Name__c =  acc.Cable_Unit__r.Name;
        lead.Account__c = acc.Id;
        lead.Title = 'Guest';
        lead.FirstName = 'Me';
        lead.LastName = 'N Marley';
        lead.MobilePhone = '10000';
        lead.Street_Lookup__c = add.id;
        lead.Email= 'test123@gmail.com';
        lead.RecordTypeId = '012200000000nza';
        lead.PORoles__c = LCR.id;
        lead.Description = 'Test Desc';
        insert lead;
        
       // Account_Contact_Role__c AccConRole  = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.id,acc.id);
        
        Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = acc.id, 
                                        Contact__c = contact.id,                                       
                                        Role__c = LCR.id
                                        ); 
        acr.ContactRoleExternalID__c = acr + String.valueOf(Crypto.getRandomInteger());        
        insert acr;
                
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(lead);
        YSLeadConvert con = new YSLeadConvert(stdController);        
        con.convertLead(); 

		con.lead.PORoles__c = LCRAdmin.id;
		con.lstConRole.add(acr);
        
        con.lead.PORoles__c =null;
		con.lstConRole.add(acr);
		
		con.convertLead();
		
        con.ownerId = '00GM0000000n1Sh';
        con.convertLead();
        
        con.leadID = null;
        con.convertLead();
        
        con.lead.PORoles__c ='a0yM0000003lXJ0IAM';
        con.lead.PORoles__r.Name ='Administrator';
        //YSLeadConvert.isEmpty();
        con.convertLead();
                
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1(){
    	YOSpocUtils.isYOAdmin(UserInfo.getUserId());
    }
    
    static testMethod void myUnitTest2() {

            Test.startTest();
            String CRON_EXP = '0 0 0 1 1 ? 2025';  
            String jobId = System.schedule('testScheduledApex', CRON_EXP, new YKSPOC_PostNewsInChatter() );
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression); 
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
    }
    
    //testclass
 		static testMethod void testVWFCreateACR() {
			/*testData();
	        Account testAccount1 = testAccount(); 
	        Address__c add = new Address__c();
	        add.Active__c= true;
	        add.District__c ='test';
	        add.Door_No__c ='1';
	        add.Entrance__c = 'ABC';
	        add.Floor__c = '4';
	        add.House_No__c ='34';
	        add.Name = 'test1';
	        add.Town__c = 'ABS';
	        add.Postcode__c = '4000076';
	        add.Street__c='ordrupVej';
	       // add.Side__c='TV';
	        insert add;
        
    		Contact  C2 = new Contact(AccountID = testAccount1.Id, 
    					FirstName = 'Test', LastName = 'User', 
    					Street_P__c = add.Id, Description = 'For Testing Purpose', 
    					Email = 'test_user@test.com', Phone = '22222', 
    					MobilePhone = '9870214578', HomePhone = '124578', 
    					AlternateEmail__c = 'test_user1@test.com');
	        Lookup_Contact_Roles__c lkRole = testContactRole();
	          
	        // Create dummy lead
	        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe',Phone='12345',Street_Lookup__c=testAccount1.Street_YK__c,RecordTypeid='012200000000nzaAAA');
	        insert testLead;
	        
	       
	        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; */
	        
	        Account acc = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
        	Lookup_Contact_Roles__c LCR =  clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle351');
        	Lookup_Contact_Roles__c LCRAdmin =  clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Administrator');
        	Address__c add = setupDummyAddress();
        	Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
	        
	        
	        VWFCreateACR aLeadPlugin = new VWFCreateACR();
	        Map<String,Object> inputParams = new Map<String,Object>();
	        Map<String,Object> outputParams = new Map<String,Object>();
	
	        inputParams.put('ContactID',contact.ID);
	        inputParams.put('AccountID',acc.id);
	        inputParams.put('SendEmailToOwner','true');
	        inputParams.put('LeadRoleID',LCRAdmin.ID);
	
	        Process.PluginRequest request = new Process.PluginRequest(inputParams);
	        Process.PluginResult result;
	        result = aLeadPlugin.invoke(request);
	        
	        //Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
	        //System.Assert(aLead.isConverted);
	    }
	    
	    static testMethod void describeTest() {

            VWFCreateACR aLeadPlugin = new VWFCreateACR();
            Process.PluginDescribeResult result = aLeadPlugin.describe();
                
                //System.AssertEquals(result.inputParameters.size(), 9);
                //System.AssertEquals(result.OutputParameters.size(), 2);        
        }
	    private static Address__c setupDummyAddress(){
	    	Address__c address = new Address__c();
	       address.Street__c = 'Stradellasvej';
	       address.External_Id__c ='66666666';
	       address.Entrance__c = '';
	       address.House_No__c = '80';
	       address.Floor__c = '2';
	       address.Postcode__c = '';
	       address.Town__c = 'paris'; 
	       address.Door_No__c = '';
	       address.OclearAddress__c = 'Yes';
	       address.Isubscription__c = 'No';
	       insert address;
	       
	       return address;
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
    
    static Contact testContact(){
    	Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c='ordrupVej';
       // add.Side__c='TV';
        insert add;
        
        Account Acc = testAccount();
        
    	Contact  C2 = new Contact(AccountID = Acc.Id, 
    					FirstName = 'Test', LastName = 'User', 
    					Street_P__c = add.Id, Description = 'For Testing Purpose', 
    					Email = 'test_user@test.com', Phone = '22222', 
    					MobilePhone = '9870214578', HomePhone = '124578', 
    					AlternateEmail__c = 'test_user1@test.com');
    	return C2;
    }
    
    static Lookup_Contact_Roles__c testContactRole(){
    	Lookup_Contact_Roles__c LCRAdmin =  clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Administrator');
    	return LCRAdmin;
    }
    
    
    
}