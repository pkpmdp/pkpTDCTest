/***********************************************************************************
************************************************************************************

* @class: Yousee13DeltageControllerTestClass
* @version History : 1.0
* @date: 18/12/2012
* @description: Test Class for Yousee13DeltageController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class Yousee13IndblikControllerTestClass {
    
    static ApexPages.StandardController sc;
    static Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');  
    static  String campaignId = yousee13.Jylland_Fyn_Campaign__c;
    static  String campaignIdSj = yousee13.Sjaelland_Campaign__c;
    static  String campaignIdCop = yousee13.Copenhagen_Campaign__c;
    
    static testMethod void testPositiveFlow() {
            Address__c addr  = getNewAddresses();        
            Account account = getNewAccount(addr);
            Contact contact = getNewContact(addr, account); 
            Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
            CampaignMember campaign = getNewCampaignMemberContact(contact);
            ApexPages.currentPage().getParameters().put('acc', account.id);
            ApexPages.currentPage().getParameters().put('cmid', campaign.id);
            ApexPages.currentPage().getParameters().put('loc', 'jf');
            Yousee13DeltageIndblikController contr = new Yousee13DeltageIndblikController(sc);
            contr.cm = campaign;
            contr.showBus = true;
            contr.saveRegistration();
    } 
   
    static testMethod void testNegativeFlow1() {
            Address__c addr  = getNewAddresses();        
            Account account = getNewAccount(addr);
            Contact contact = getNewContact(addr, account); 
            Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
            CampaignMember campaign = getNewCampaignMemberContact1(contact);
            ApexPages.currentPage().getParameters().put('acc', account.id);
            ApexPages.currentPage().getParameters().put('cmid', campaign.id);
            ApexPages.currentPage().getParameters().put('loc', 'jf');
            Yousee13DeltageIndblikController contr = new Yousee13DeltageIndblikController(sc);
            contr.cm = campaign;
            contr.showBus = true;
            contr.saveRegistration();
    } 
    
    static testMethod void testNegativeFlow2() {
            Address__c addr  = getNewAddresses();        
            Account account = getNewAccount(addr);
            Contact contact = getNewContact(addr, account); 
            Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
            CampaignMember campaign = getNewCampaignMemberContact2(contact);
            ApexPages.currentPage().getParameters().put('acc', account.id);
            ApexPages.currentPage().getParameters().put('cmid', campaign.id);
            ApexPages.currentPage().getParameters().put('loc', 'jf');
            Yousee13DeltageIndblikController contr = new Yousee13DeltageIndblikController(sc);
            contr.cm = campaign;
            contr.showBus = true;
            contr.saveRegistration();
    } 
    
    static testMethod void testNegativeFlow3() {
            Address__c addr  = getNewAddresses();        
            Account account = getNewAccount(addr);
            Contact contact = getNewContact(addr, account); 
            Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
            CampaignMember campaign = getNewCampaignMemberContact2(contact);
            ApexPages.currentPage().getParameters().put('acc', account.id);
            ApexPages.currentPage().getParameters().put('cmid', campaign.id);
            ApexPages.currentPage().getParameters().put('loc', 'jf');
            Yousee13DeltageIndblikController contr = new Yousee13DeltageIndblikController(sc);
            contr.cm = campaign;
            contr.showBus = true;
            contr.saveRegistration();
    } 
    
     static Contact getNewContact3(Address__c addr, Account acc){
            Contact contact = new Contact(); 
           contact.FirstName = 'TestContactFirstname';
           contact.LastName = 'TestContactLastname';
        //   contact.Email = 'test.TestClase@test1.com';
        // contact.Phone = '2222221';
        // contact.MobilePhone = '3333331';
        // contact.HomePhone = '4444441';
           contact.HierarchyAccount__c = acc.id;
           contact.Street_P__c = addr.Id;
           contact.KissPartyId__c = 'KAS.P2---4015110456';
           insert contact;
           return contact;
    }
    
    static CampaignMember getNewCampaignMemberContact2(Contact contact){
            CampaignMember campaign = new CampaignMember(); 
            campaign.ContactId = contact.id;  
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = false;
            campaign.Bus__c = null;
            campaign.show__c = true;
            campaign.Contact = contact;
            insert campaign; 
            return  campaign;
    }
    
    static CampaignMember getNewCampaignMemberContact1( Contact contact){
            CampaignMember campaign = new CampaignMember(); 
            campaign.ContactId = contact.id;  
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = false;
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
            campaign.Contact = contact;
            insert campaign; 
            return  campaign;
    }
    
    
    static CampaignMember getNewCampaignMemberContact( Contact contact){
            CampaignMember campaign = new CampaignMember(); 
            campaign.ContactId = contact.id;  
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = true;
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
            campaign.Contact = contact;
            insert campaign; 
            return  campaign;
    }
    
    static Address__c getNewAddresses(){
            Address__c addr  = new Address__c();      
            addr.Town__c = 'AH';        
            addr.Postcode__c = '421002';        
            addr.Door_No__c = '301';        
            addr.Side__c = 'A';        
            addr.Floor__c = 'Third';        
            addr.House_No__c = 'testData';        
            addr.Street__c = 'AH';        
            addr.Entrance__c = 'A';        
            insert addr;
            return  addr;
    }
    
    static Account getNewAccount(Address__c addr){
            Account account = new Account();        
            account.Name ='test12';        
            account.Phone = '223223';        
            account.Email__c = 'abc@xyz.com';
            account.Street_YK__c = addr.Id;         
            account.Street_YK__r = addr;
            account.Cable_Unit__c = getNewCableUnit().Id;  
            account.Customer_Segment_Lookup__c =  getCustomerSegment().Id;
            insert account;
            return account;
    }
   
    static Lookup_Customer_Segment__c getCustomerSegment(){
            Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
            customerSegmentObj.Start_Date__c=date.today();
            customerSegmentObj.End_Date__c=date.today().addMonths(1);
            customerSegmentObj.Name='pisse guard';
            customerSegmentObj.code__c='1212';        
            customerSegmentObj.SourceId__c='DCRM 1211';        
            insert customerSegmentObj;
            return customerSegmentObj;
    }      
    
    static Contact getNewContact(Address__c addr, Account acc){
            Contact contact = new Contact(); 
           contact.FirstName = 'TestContactFirstname';
           contact.LastName = 'TestContactLastname';
           contact.Email = 'test.TestClase@test1.com';
           contact.Phone = '2222222221';
           contact.MobilePhone = '3333222331';
           contact.HomePhone = '4444422241';
           contact.HierarchyAccount__c = acc.id;
           contact.Street_P__c = addr.Id;
           contact.KissPartyId__c = 'KAS.P2---4015110456';
           insert contact;
           return contact;
    }
    
    static Account_Contact_Role__c getNewAccountContactRole(Account account, Contact contact){
           Lookup_Contact_Roles__c role = [Select l.Visible_in_Service_Centre__c, l.SystemModstamp, l.Start_Date__c, l.SourceId__c, l.OwnerId, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.End_Date__c, l.CreatedDate, l.CreatedById, l.Code__c, l.Active__c From Lookup_Contact_Roles__c l where l.Name = 'Sagskontakt' limit 1];
           Account_Contact_Role__c acr = new Account_Contact_Role__c();
           acr.Customer__c = account.Id; 
           acr.Contact__c = contact.Id;
           acr.Role__c = role.Id;
           insert acr;
           return acr;
    }
    
    static Lookup_Housing_Ownership__c getHousingOwnerShip(){
            Lookup_Housing_Ownership__c housingOwnerShip = new Lookup_Housing_Ownership__c();        
            housingOwnerShip.name = 'Andel';        
            housingOwnerShip.Code__c = '12121';        
            housingOwnerShip.End_Date__c = date.today().addMonths(1);        
            housingOwnerShip.Start_Date__c = date.today();        
            housingOwnerShip.SourceId__c = 'Private bunglow876';        
            insert housingOwnerShip;
            return housingOwnerShip;
    }
    
    static Cable_Unit__c getNewCableUnit(){
            Cable_Unit__c cableUnit = new Cable_Unit__c();
            cableUnit.Potential_Installations__c = 68.0;
            cableUnit.Name = 'cu_kundeCust_testing'; 
            cableUnit.Municipaly__c = '223 Hørsholm'; 
            cableUnit.Cable_Unit_Post_Code__c = '7400';
            cableUnit.Housing_Ownership__c = getHousingOwnerShip().Id;                      
            cableUnit.Housing_Type__c = getHousingType().Id;                     
            cableUnit.Building_Type__c = getBuildingType().Id;
            insert cableUnit;
            return cableUnit;
    }
    
    static Lookup_Housing_Type__c getHousingType(){
            Lookup_Housing_Type__c housingType = new Lookup_Housing_Type__c(); 
            housingType.name = 'Private andelstype';
            housingType.Code__c = '12121';
            housingType.End_Date__c = date.today().addMonths(1);
            housingType.Start_Date__c = date.today();
            housingType.SourceId__c = 'Private bunglow545';
            insert housingType;      
            return housingType;
    }
    
    static Lookup_Building_Type__c getBuildingType(){
            Lookup_Building_Type__c buildingType = new Lookup_Building_Type__c(); 
            buildingType.name ='Private bunglow';
            buildingType.Code__c='12121';
            buildingType.End_Date__c = date.today().addMonths(1);
            buildingType.Start_Date__c= date.today();
            buildingType.SourceId__c='Private bunglow34';
            insert buildingType;
            return buildingType;
    }
}