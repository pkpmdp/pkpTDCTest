public with sharing class clsYSAttachAddressController {
    
    private Address__c address;
    public Account_Contact_Role__c accountContactRole {get;set;}
    private Contact contact {get;set;}
    private Account account {get;set;}
    
    public clsYSAttachAddressController(){
        accountContactRole  = new Account_Contact_Role__c(); 
        Id id = ApexPages.currentPage().getParameters().get('AddressId');
        if(id != null){                      
            this.address = Database.query('SELECT Id, Name, House_No__c, Side__c , Floor__c, Town__c, Entrance__c, Door_No__c, Postcode__c, District__c from Address__c  where id = :id');                            
        }               
    }
    
    public String getAddressString(){
        String addressString = address.Name + ' ';
        if (address.House_No__c != null) 
            addressString += address.House_No__c + ', ';
        if(address.Floor__c != null)
            addressString += address.Floor__c + '. etage, ';
        if(address.Entrance__c != null)
            addressString += 'opgang ' + address.Entrance__c + ', ';
        if(address.Side__c != null)
            addressString += address.Side__c + ', ';    
        if(address.Door_No__c != null)
            addressString += 'Dør ' + address.Door_No__c + ', ';
        if(address.Postcode__c != null)
            addressString += address.Postcode__c + ' ';
        if(address.Town__c != null)
            addressString += address.Town__c;
        return addressString;
    }
    
    public PageReference save(){
        
        if(accountContactRole.Customer__c != null){
            //Retrieve customer record
            this.account = [Select Id, Street_YK__c from Account where id= :accountContactRole.Customer__c];
            this.account.Street_YK__c = address.Id;         
            try {            
                update this.account;   
            } catch(System.DMLException e){
                String errorMessage = e.getDMLMessage(0);                            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));    
                system.debug(errorMessage);
            }
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'Addressen er nu tilknyttet kunden.'));          
            return ApexPages.currentPage(); 
        }
        
        if(accountContactRole.Contact__c != null){          
            //Retrieve customer record
            this.contact = [Select Id, Street_P__c from Contact where id= :accountContactRole.Contact__c];
            this.contact.Street_P__c = address.Id;
            
            try {            
                update this.contact;   
            } catch(System.DMLException e){
                String errorMessage = e.getDMLMessage(0);                            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Der er sket en teknisk fejl. Kontakt din administrator'));    
                system.debug(errorMessage);
            }
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'Addressen er nu tilknyttet kontakten.'));           
            return ApexPages.currentPage();
        }
        return null;    
    }
    
    public static testMethod void testController(){
    
        Address__c address = new Address__c(Name= 'Klostervangen', Active__c = true, External_Id__c = 'test500',
                                                House_No__c = '34', Postcode__c = '3360', Floor__c = '2',Entrance__c = 'Lef',  
                                                Side__c = 'Left', Door_No__c = '2', Town__c = 'Test'); 
        Address__c address2 = new Address__c(Name= 'Klostervangen', Active__c = true, External_Id__c = 'test454',
                                            House_No__c = '32', Postcode__c = '3360');
        insert address;
        insert address2;
        
        Cable_Unit__c cableUnit = new Cable_Unit__c();
        cableUnit.Name = 'YS test';
        cableUnit.Cable_Unit_No__c = '';
        cableUnit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cableUnit.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                    
        cableUnit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnit;   
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        acc.Cable_Unit__c = cableUnit.id;
        insert acc;  
        
        Contact contact = new Contact();
        contact.FirstName = 'test';
        contact.LastName = 'test';
        contact.MobilePhone = 'test';
        contact.Street_P__c = address2.Id;
    
        insert contact;
        
        PageReference testPage = new PageReference('/apex/YSAttachAddress?AddressId=' +  address.Id);
        
        Test.setCurrentPage(testPage);      
        
        clsYSAttachAddressController con = new clsYSAttachAddressController();      
        con.accountContactRole.Contact__c = contact.Id;  
        
        con.save();
        
        //System.assertEquals(address2.Id, con.contact.Street_P__c); 
        con.getAddressString(); 
        clsYSAttachAddressController con1 = new clsYSAttachAddressController();      
        con1.accountContactRole.Contact__c = contact.Id;  
        con1.accountContactRole.Customer__c  = acc.Id;
        System.debug('***-->'+acc.Id);
        con1.save();
         clsYSAttachAddressController con2 = new clsYSAttachAddressController(); 
        con2.save();
        
    }
    
    
       
}