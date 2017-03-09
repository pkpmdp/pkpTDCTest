@isTest
public class YouSee_O_cust_view_submitted_leadsTest {
	
	public  static Cable_Unit__c cableUnitTest;
	public static User user;
    public static User user1;
	
	@testSetup
	static void testData(){
	 	
	 	ServiceCenter_CustomSettings__c customsetting =new ServiceCenter_CustomSettings__c();
    	customsetting.Name='Service_Center_SiteCoreURL';
    	customsetting.Value__c='https://yousee.dk';
    	insert customsetting;
    	
    	ServiceCenter_CustomSettings__c customsetting2 =new ServiceCenter_CustomSettings__c();
    	customsetting2.Name='Contact Roles Bruger';
    	customsetting2.Value__c='Selvbetjeningsbruger';
    	insert customsetting2;
    	
    	Yousee13Campaign__c customsetting3 =new Yousee13Campaign__c();
    	customsetting3.Name='Registration';
    	customsetting3.SiteGuestUserId__c='005M0000004Odn8';
    	customsetting3.Lead_RecordType__c='012M0000000CsDc';
    	insert customsetting3;
    	
    	Lookup_Post_Code__c postcode= new Lookup_Post_Code__c();
        //postcode.PostCode_External_ID__c='7400';
        postcode.Name='7400';
        insert postcode;
        
    	cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing';
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest.Cable_Unit_No__c='0000000570';
        insert cableUnitTest;
        
        String leadownerId = UserInfo.getUserId();
        
        Cable_Unit__c cu = [Select cu.Cable_Unit_No__c, cu.Id from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
        
        user=new User();  
        user.Username='testvrs@test.com';
        user.LastName='testLastName';
        user.Email='test@test.com';
        user.Alias='trss';
        user.CommunityNickname='trstr';
        user.TimeZoneSidKey='Europe/Paris';
        user.LocaleSidKey='da_DK';  
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId='00e20000000v9G1AAI';
        user.LanguageLocaleKey='da';           
        user.MID__c='123';
        user.IsActive=true;        
        insert user;
        
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        addr.External_Id__c = '100';
        insert addr;
        
         user1=new User();  
        user1.Username='testvps@test.com';
        user1.LastName='testLName';
        user1.Email='testvps@test.com';
        user1.Alias='trvps';
        user1.CommunityNickname='trsts';
        user1.TimeZoneSidKey='Europe/Paris';
        user1.LocaleSidKey='da_DK';  
        user1.EmailEncodingKey='ISO-8859-1';
        user1.ProfileId='00e20000000v9G1AAI';
        user1.LanguageLocaleKey='da';           
        user1.MID__c='133';
        user1.IsActive=true;        
        insert user1;
        
         Lead lead1 = new Lead();
        lead1.FirstName = 'Tom';
        lead1.LastName = 'Jones';          
        lead1.Email = 'test@testaccount123.dk';
        lead1.Status = 'Åben';
        lead1.Unsubscribed__c = false;               
        lead1.Cable_Unit_1__c = cu.Id;
        lead1.LeadSource = 'Service Center - Member registration';
        lead1.OwnerId= user.Id;
        lead1.resendFlag__c = false;
        insert lead1;
        
        Lead lead3 = new Lead();
        lead3.FirstName = 'Minal';
        lead3.LastName = 'Kadam';       
        lead3.Email = 'trial@testaccount124.dk';
        lead3.Status = 'Åben';
        lead3.Unsubscribed__c = false;  
        lead3.Cable_Unit_1__c = cu.Id;
        lead3.LeadSource = 'Service Center - Member registration';
        lead3.OwnerId=user1.Id;
        lead3.resendFlag__c = false;
        insert lead3;

        
        Lead lead2 = new Lead();
        lead2.FirstName = 'Sona';
        lead2.LastName = 'Jain';       
        lead2.Email = 'test@testaccount124.dk';
        lead2.Status = 'Åben';
        lead2.Unsubscribed__c = true;  
        lead2.Cable_Unit_1__c = cu.Id;
        lead2.LeadSource = 'Service Center - Member registration';
        lead2.OwnerId=user.Id;
        lead2.resendFlag__c = false;
        lead2.Address_External_Id__c = '100';
        insert lead2;
        
	}
	
	 public static testmethod void youSee_O_cust_view_submitted_leadsTest(){
	 	Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
    	PageReference form = new PageReference('Page.YouSee_O_customers_submitted_leads_form');
    	Test.setCurrentPageReference(form);
        ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
        
    	User u1 = [SELECT Id FROM User WHERE Alias='trss'];
    	System.RunAs(u1){     
        
        YouSee_O_customers_view_submitted_leads obj = new YouSee_O_customers_view_submitted_leads();
        
       // System.assertequals(obj.getSubmittedLeads().size(),2);        
         
         }
	 }
	 
	 public static testmethod void youSee_O_cust_resend_emailsTest(){
	 	Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
    	PageReference form = new PageReference('Page.YouSee_O_customers_submitted_leads_form');
    	Test.setCurrentPageReference(form);
        ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
        User u1 = [SELECT Id FROM User WHERE Alias='trss'];
                System.RunAs(u1){  
            
        YouSee_O_customers_view_submitted_leads obj = new YouSee_O_customers_view_submitted_leads();
        List<YouSee_O_customers_view_submitted_leads.RegisteredLead> submittedLeads = obj.getSubmittedLeads();
         
         System.debug('****-->'+submittedLeads);
        
        for(YouSee_O_customers_view_submitted_leads.RegisteredLead lead : submittedLeads){
                lead.resend = true;
            
        }
         obj.resendEmail();
         obj.checkStatus();
         obj.cancelEmail();
                               
                 }
     }
    
     public static testmethod void youSee_O_cust_resend_emailsTest1(){
     Cable_Unit__c cu = [Select cu.Cable_Unit_No__c from Cable_Unit__c cu where cu.Name = 'cu_kundeCust_testing'  ];
         
         
     PageReference form = new PageReference('Page.YouSee_O_customers_submitted_leads_form');
     Test.setCurrentPageReference(form);
     ApexPages.currentPage().getParameters().put('cableunitnumber',cu.Cable_Unit_No__c);
         
        User u1 = [SELECT Id FROM User WHERE Alias='trvps'];
        System.RunAs(u1){  
            
        YouSee_O_customers_view_submitted_leads obj = new YouSee_O_customers_view_submitted_leads();
        List<YouSee_O_customers_view_submitted_leads.RegisteredLead> submittedLeads = obj.getSubmittedLeads();
         
         System.debug('****-->'+submittedLeads);
            obj.resendEmail();
            obj.checkStatus();
        }
     }

}