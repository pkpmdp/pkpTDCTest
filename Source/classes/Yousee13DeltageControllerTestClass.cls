/***********************************************************************************
************************************************************************************

* @class: Yousee13DeltageControllerTestClass
* @version History : 1.0
* @date: 18/12/2012
* @description: Test Class for Yousee13DeltageController.

************************************************************************************ 
***********************************************************************************/
@isTest(SeeAllData=true)
private class Yousee13DeltageControllerTestClass { 
    
    static ApexPages.StandardController sc;
    
    static Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');  
    static  String campaignId = yousee13.Jylland_Fyn_Campaign__c;
    
    static testMethod void testPositiveFlow() {
        
        Address__c addr  = getNewAddresses();        
        Account account = getNewAccount(addr);
        Test.startTest();
        Contact contact = getNewContact(addr, account); 
        Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
        Test.stopTest();
        Contact existingContact = getExistingContact(addr, account);
        Account_Contact_Role__c acrExisting  = addNewExitingAccountContactRole(account, existingContact);
        CampaignMember campaignExistingContact = getExistingCampaignMemberContact(existingContact);
        CampaignMember campaign = getNewCampaignMemberContact(contact);
        
        ApexPages.currentPage().getParameters().put('acc', account.id);
        ApexPages.currentPage().getParameters().put('cmid', campaign.id);
        ApexPages.currentPage().getParameters().put('loc', 'jf');
        
        Yousee13DeltageController contr = new Yousee13DeltageController(sc);
        contr.cm = campaign;
        contr.showBus = true;
        contr.campaignMember = campaign;
        List<CampaignMember> campaignMemberList = new List<CampaignMember>();
        campaignMemberList.add(campaignExistingContact);
        contr.existingContactList = campaignMemberList;
        contr.redirectToCreateMember();
        contr.totalTransportRequest = 2;
        
        contr.saveRegistration();
        Lead newLead = getNewLead();
        
        CampaignMember campaignMem = getNewCampaignMember();
    //  ExistingMember exm = new ExistingMember(existingContact.name, existingContact.email, existingContact.mobilephone, campaign);
        
        contr.saveLead(campaignMem, newLead);

        contr.saveAndMore(campaignMem, newLead);
        contr.saveGuest(campaignMem, newLead);
        contr.saveGuestAndMore(campaignMem, newLead);
        
     
        contr.initializeMember();
        
       contr.getRelations();
        contr.totalTransportRequest = 2;
        
        Lead newMoreLead = getNewMoreLead();
        CampaignMember campaignMoreLead = getNewCampaignMemberLead(newMoreLead); 
                
        contr.redirectToCreateGuest();
        
        contr.totalTransportRequest = 2;
       
        Lead newGuest = getGuest();
        CampaignMember campaignGuest = getNewCampaignMem();
        CampaignMember cm1 = new CampaignMember();
        Lead lead1 = new Lead();
        cm1.lead = lead1;
        contr.saveGuest(cm1, lead1);
        
        contr.initializeGuest();
           
        contr.totalTransportRequest = 2;
         
        Lead newMoreGuest = getMoreGuest();
       
        contr.saveGuestAndMore(getNewCampaignMember2(), newMoreGuest);
        contr.saveGuestAndMore(getNewCampaignMember3(), newMoreGuest);
        contr.saveGuestAndMore(getNewCampaignMember4(), newMoreGuest);
       
        List<CampaignMember> emailList = new List<CampaignMember>();
        emailList.add(campaign); 
        emailList.add(campaignMem); 
        emailList.add(campaignMoreLead); 
        contr.emailList = emailList;
        contr.redirectToConfirmation();
       // Yousee13DeltageController contrtest = new Yousee13DeltageController();
       list<Yousee13DeltageController.ExistingMember> exe=new list<Yousee13DeltageController.ExistingMember>();
        Yousee13DeltageController.ExistingMember rrr = new Yousee13DeltageController.ExistingMember('test','ss@gmail.com','9999999999',campaign);
        exe.add(rrr);
        contr.validateExistingMember(rrr);
        contr.HasValidationErrorsContactList();
        
        
       
        
    } 
    
     static testMethod void testNegativeFlow() {
        Lead newLead = new Lead();
        newLead.lastname = 'lastname';
        newLead.firstname = 'aaa';
        newLead.company = 'Compan111y';
        newLead.email = 'vna12@tdc.com';
        newLead.mobilephone = '22321113';
    
        
        CampaignMember campaign = new CampaignMember(); 
        
        Address__c addr5  = new Address__c();
        addr5.Town__c = 'AH';
        addr5.Postcode__c = '421002';
        addr5.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr5.Floor__c = 'Third';
        addr5.House_No__c = 'testData';
        addr5.Street__c = 'AH';
        addr5.Entrance__c = 'A';
        insert addr5;
        
        contact con=new contact(lastname='test', firstname='firstname' ,MobilePhone='1234567890', Street_P__c = addr5.id);
        insert con; 
        campaign.Lead = newLead;
        campaign.CampaignId = campaignId;
        campaign.Deltage__c = false;
        campaign.Bus__c = '';
        campaign.show__c = true;
        campaign.contactid=con.id;
        
        CampaignMember campaign12 = new CampaignMember(); 
            
        campaign12.Lead = newLead;
        campaign12.CampaignId = campaignId;
        campaign12.Deltage__c = false;
        campaign12.Bus__c = '';
        campaign12.show__c = true;
        campaign12.contactid=con.id;
        
        
        CampaignMember campaign124 = new CampaignMember(); 
            
        campaign124.Lead = newLead;
        campaign124.CampaignId = campaignId;
        campaign124.Deltage__c = false;
        campaign124.Bus__c = '';
        campaign124.show__c = false;
        campaign124.contactid=con.id;
        
                
        CampaignMember campaign123 = new CampaignMember(); 
            
        campaign123.Lead = newLead;
        campaign123.CampaignId = campaignId;
        campaign123.Deltage__c = true;
        campaign123.Bus__c = '';
        campaign123.show__c = true;
        campaign123.contact=con;
        
        
        
        
        CampaignMember campaign1 = new CampaignMember(); 
        Lead newLead1 = new Lead();
        newLead1.lastname = 'Compan111y';
        newLead1.firstname = 'Compan111y';
        newLead1.company = 'Compan111y';
        newLead1.email = 'ss@gmail.com';
        newLead1.mobilephone = '22321113';
        
        
        campaign1.Lead = newLead1;
        campaign1.CampaignId = campaignId;
        campaign1.Bus__c = null;
        
        
        CampaignMember campaign2 = new CampaignMember(); 
        Lead newLead2 = new Lead();
        newLead2.lastname = 'Compan111y';
        newLead2.firstname = 'Compan111y';
        newLead2.company = 'Compan111y';
        newLead2.email = 'vna12@tdc';
        newLead2.mobilephone = '22321113';
        
        
        campaign2.Lead = newLead2;
        campaign2.CampaignId = campaignId;
        
        
      
        Address__c addr  = getNewAddresses();        
        Account account = getNewAccount(addr);
        Test.startTest();
        Contact contact = getNewContact(addr, account); 
        Account_Contact_Role__c acr = getNewAccountContactRole(account, contact);
        Test.stopTest();
        CampaignMember cm = getNewCampaignMemberContact(contact);
        ApexPages.currentPage().getParameters().put('acc', account.id);
        ApexPages.currentPage().getParameters().put('cmid', campaign.id);
        ApexPages.currentPage().getParameters().put('loc', 'jf');
        Contact existingContact = getExistingContact(addr, account);
        Yousee13DeltageController contr11 = new Yousee13DeltageController(sc);
        contr11.showBus = false;
        contr11.cm = campaign124;       
        contr11.HasValidationErrorsContactList();
        contr11.HasValidationErrorsForContact();
        
        Yousee13DeltageController contr1 = new Yousee13DeltageController(sc);
        contr1.showBus = false;
        contr1.cm = campaign12;     
        contr1.HasValidationErrorsContactList();
        contr1.HasValidationErrorsForContact();
        list<Yousee13DeltageController.ExistingMember> exe=new list<Yousee13DeltageController.ExistingMember>();
        Yousee13DeltageController.ExistingMember rrr = new Yousee13DeltageController.ExistingMember('test','ss@gmail.com','9999999999',campaign12);
        exe.add(rrr);
        contr1.lgUserEmail='test@gmail.com';
        contr1.validateExistingMember(rrr);
        contr1.HasValidationErrorsContactList();
        contr1.getRelations();
        
        Yousee13DeltageController contr123 = new Yousee13DeltageController(sc);
        contr123.showBus = false;
        contr123.cm = campaign123;  
        contr123.lgUserEmail='test@gmail.com';
        contr123.getRelations();
        contr123.HasValidationErrorsContactList();
        
        Yousee13DeltageController contr = new Yousee13DeltageController(sc);
         CampaignMember campaignExistingContact = getExistingCampaignMemberContact(existingContact);
         contr.cm = campaign;
        contr.showBus = true;
        contr.campaignMember = campaign;
        List<CampaignMember> campaignMemberList = new List<CampaignMember>();
        campaignMemberList.add(campaignExistingContact);
        contr.existingContactList = campaignMemberList;
        contr.redirectToCreateMember();
        contr.totalTransportRequest = 2;
        
        contr.HasValidationErrors(campaign);
       
        contr.HasValidationErrors(campaign2);
        
        contr.findContactById(String.valueOf(contact.id));
        contr.findLeadOnCU('K');
        contr.findLeadOnCU('H');
        contr.findGuestOnCU('K');
        contr.findGuestOnCU('H');
        
        
        contr.validateGuest(campaign);
        contr.validateGuest(campaign1);
        contr.validateGuest(campaign2);
        
        contr.validateContactCM(campaign);
        contr.validateContactCM(campaign1);
        contr.validateContactCM(campaign2);
        
        contr.HasValidationErrorsForContact();
        contr.HasValidationErrorsContactList();
       list<Yousee13DeltageController.ExistingMember> exe1 = new list<Yousee13DeltageController.ExistingMember>();
        Yousee13DeltageController.ExistingMember rrr1 = new Yousee13DeltageController.ExistingMember('test','ss@gmail.com','9999999999',campaign);
        exe1.add(rrr);
        contr.validateExistingMember(rrr1);
        contr.saveContactRegistration();
        contr.valdiateTotalTransportRequested(campaign);
        
        contr.saveAndMore(campaign,newLead);
        contr.saveAndMore(campaign1,newLead);
        
        contr.saveAndMore(campaign2,newLead);
        contr.initializeMember();
        contr.saveAndRedirect();
        contr.addMore();
        contr.redirectToCreateGuest();
        contr.addMoreGuest();
        contr.saveGuestAndNext();
        
        contr.HasValidationErrors(campaign1);
        contr.valdiateTotalTransportRequested(campaign1);
        contr.saveLead(campaign1, newLead1);
        contr.saveAndMore(campaign1, newLead1);
        contr.saveGuest(campaign1, newLead1);
        contr.saveGuestAndMore(campaign1, newLead1);
        contr.validateGuest(campaign2);
        contr.valdiateTotalTransportRequested(campaign1);
        contr.saveGuestAndMore(campaign2, newLead1);
        contr.saveGuest(campaign2, newLead1);
        contr.saveGuest(campaign1, newLead1);
        contr.lgUserEmail='test@gmail.com';
        contr.getRelations();
    } 
     
    
    
     static Lead getGuest(){
            Lead newLead = new Lead();
            newLead.lastname = 'GuestLast11name';
            newLead.firstname = 'GuestFirs1t1Name';
            newLead.company = 'Compan111y';
            newLead.email = 'vna12@tdc.com';
            newLead.mobilephone = '22321113';
              insert newLead;
            return newLead;
    }
    
    static Lead getNewGuest(){
            Lead newLead = new Lead();
            newLead.lastname = 'GuestLast11name';
            newLead.firstname = 'GuestFirs1t1Name';
            newLead.company = 'Compan111y';
            newLead.email = 'vna12@tdc.com';
            newLead.mobilephone = '22321113';
            insert newLead;
            return newLead;
    }
    
    static Lead getMoreGuest(){
            Lead newLead = new Lead();
            newLead.lastname = 'Guest3Last112name';
            newLead.firstname = 'Guest3Firs1t12Name';
            newLead.company = 'Compan3111y';
            newLead.email = 'vna1233@tdc.com';
            newLead.mobilephone = '22321113';
             insert newLead;
            return newLead;
    }
    
    static Lead getNewMoreGuest(){
            Lead newLead = new Lead();
            newLead.lastname = 'GuestLast112name';
            newLead.firstname = 'GuestFirs1t12Name';
            newLead.company = 'Compan111y';
            newLead.email = 'vna123@tdc.com';
            newLead.mobilephone = '22321113';
            insert newLead;
            return newLead;
    }
    
    static Lead getNewMoreLead(){
            Lead newLead = new Lead();
            newLead.lastname = 'Last11name';
            newLead.firstname = 'Firs1t1Name';
            newLead.company = 'Compan111y';
            newLead.email = 'vna1@tdc.com';
            newLead.mobilephone = '22321113';
            insert newLead;
            return newLead;
    }
    
    static CampaignMember getNewCampaignMember(){
            CampaignMember campaign = new CampaignMember(); 
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
            return campaign;
    }
    
    
     static CampaignMember getNewCampaignMem(){
            CampaignMember campaign = new CampaignMember(); 
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = true;
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
            return campaign;
    }
    
     static CampaignMember getNewCampaignMember2(){
            CampaignMember campaign = new CampaignMember(); 
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = false;
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
           
            return campaign;
    }
    
    static CampaignMember getNewCampaignMember3(){
            CampaignMember campaign = new CampaignMember(); 
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = false;
            campaign.Bus__c = null;
            campaign.show__c = false;
            return campaign;
    }
    
    static CampaignMember getNewCampaignMember4(){
            CampaignMember campaign = new CampaignMember(); 
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = false;
            campaign.Bus__c = 'ffff';
            campaign.show__c = false;
            return campaign;
    }
    
    static CampaignMember getNewCampaignMemberLead(Lead newLead){
            CampaignMember campaign = new CampaignMember(); 
            campaign.Lead = newLead;
            campaign.Leadid = newLead.id;  
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = true;
            campaign.Bus__c = 'XXXXXX';
            campaign.show__c = true;
            insert campaign; 
            return campaign;
    }
    
    static Lead getNewLead(){
            Lead newLead = new Lead();
            newLead.lastname = 'LeadLastname';
            newLead.firstname = 'LeadFirstName';
            newLead.company = 'Company';
            newLead.email = 'vna@gmail.com';
            newLead.mobilephone = '22323233';
            newLead.Title = 'Guest';
            newLead.No_Email_Address__c=false;
            insert newLead;
            return  newLead;
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
    
    static CampaignMember getNewCampaignMember( Contact contact){
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
    
    static CampaignMember getExistingCampaignMemberContact( Contact contact){
            CampaignMember campaign = new CampaignMember(); 
            campaign.ContactId = contact.id;  
            campaign.CampaignId = campaignId;
            campaign.Deltage__c = true;
            campaign.Bus__c = null;
            campaign.show__c = false;
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
    
    
    static Contact getNewContact1(Address__c addr){
            Contact contact = new Contact(); 
            contact.FirstName = 'Contact1Firstname';       
            contact.LastName = 'Contact1Lastname';       
            contact.Email = 'test1.TestClase@test1.com';       
            contact.Phone = '222221';       
            contact.MobilePhone = '333331';       
            contact.HomePhone = '44441';
            contact.Street_P__c = addr.Id;     
            contact.Permission__c = true;
            insert contact;
            return contact;
    }
    
    static Contact getNewContact(Address__c addr, Account acc){
            Contact contact = new Contact(); 
           contact.FirstName = 'TestContactFirstname';
           contact.LastName = 'TestContactLastname';
           contact.Email = 'test.TestClase@test1.com';
           contact.Phone = '2222221';
           contact.MobilePhone = '3333331';
           contact.HomePhone = '4444441';
           contact.HierarchyAccount__c = acc.id;
           contact.Street_P__c = addr.Id;
           contact.KissPartyId__c = 'KAS.P2---4015110456';
           insert contact;
            return contact;
    }
    
    
     static Contact getExistingContact(Address__c addr, Account acc){
            Contact contact = new Contact(); 
           contact.FirstName = 'ExistingContactFirstname';
           contact.LastName = 'ExistingContactLastname';
         //  contact.Email = 'TestClase@test.com';
         //  contact.Phone = '2222221';
           contact.MobilePhone = '3333331';
         //  contact.HomePhone = '4444441';
           contact.HierarchyAccount__c = acc.id;
           contact.Street_P__c = addr.Id;
           contact.KissPartyId__c = 'KAS.P2---4015110454';
           insert contact;
            return contact;
    }
    
    static Account_Contact_Role__c getNewAccountContactRole(Account account, Contact contact){
           Lookup_Contact_Roles__c role = [Select l.Visible_in_Service_Centre__c, l.SystemModstamp, l.Start_Date__c, l.SourceId__c, l.OwnerId, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.End_Date__c, l.CreatedDate, l.CreatedById, l.Code__c, l.Active__c From Lookup_Contact_Roles__c l where l.Name = 'Sagskontakt' limit 1];
         //   Lookup_Contact_Roles__c role = new Lookup_Contact_Roles__c();      
          //  role =  new Lookup_Contact_Roles__c(Name = 'Admin',  Visible_in_Service_Centre__c = true, Start_Date__c = Date.valueOf('2011-01-01'), End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id', Code__c = 'Admin');
          //  insert role;
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
    
     static Account_Contact_Role__c addNewExitingAccountContactRole(Account account, Contact contact){
         Lookup_Contact_Roles__c role = [Select l.Visible_in_Service_Centre__c, l.SystemModstamp, l.Start_Date__c, l.SourceId__c, l.OwnerId, l.Name, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.End_Date__c, l.CreatedDate, l.CreatedById, l.Code__c, l.Active__c From Lookup_Contact_Roles__c l where l.Name = 'Selvbetjeningsbruger' limit 1];
          //  Lookup_Contact_Roles__c role = new Lookup_Contact_Roles__c();      
          //  role =  new Lookup_Contact_Roles__c(Name = 'Admin', Visible_in_Service_Centre__c = true, Start_Date__c = Date.valueOf('2011-01-01'), End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id', Code__c = 'Admin');
          //  insert role;
          Account_Contact_Role__c acr = new Account_Contact_Role__c();
          acr.Customer__c = account.Id; 
          acr.Contact__c = contact.Id;
          acr.Role__c = role.Id;
          insert acr; 
          return acr;
    }
}