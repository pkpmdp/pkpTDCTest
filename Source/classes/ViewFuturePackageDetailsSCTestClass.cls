@isTest
private class ViewFuturePackageDetailsSCTestClass {
    
    public static ViewFuturePackageDetailsController cont;
    public static ApexPages.Standardsetcontroller sc1;
    
    static User u;
    static Account acc;
    static Product__c Prod;
    static Net_Installations__c NetInstall;
    static Subscription__c Subscp;
    
    
    static testMethod void testForSubscriptions(){
        
        Apexpages.currentpage().getparameters().put('futureSubsId', '1234');
        
        Cable_Unit__c cu = new Cable_Unit__c();
        cu.Name = 'ViewAddressesForInstallationsCU';        
        cu.Cable_Unit_No__c = '0000005566';
        cu.Status__c = '0';
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cu;
        
        
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        insert installation;
        
        Prod = new Product__c(Name='TestProduct', Product_ID__c = '1101101');
        insert Prod;
        
        Subscp = new Subscription__c(Product__c = Prod.id, Net_Installation__c = installation.id, Requested_End_Date__c = system.today(), Requested_Start_Date__c = system.today(), Address__c = '1234');
        insert Subscp;
        
        RecordType rt = [Select Id from RecordType where Name = 'YS Hierarchy Account'];
        acc = new Account();
        acc.Name ='978test655';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@abc.com'; 
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();    
        acc.RecordTypeId = rt.Id;
        insert acc;    
        
        Contact c = new contact (email = 'abc@yousee.dk.com',accountid=acc.Id,FirstName='9abc89',LastName='Kuaoan',Phone='3213213211', Street_P__c=addr.id);
        insert c;
           
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];        
        u = new User(alias = 'standt', email='abc@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', firstname = 'Arun', lastname='Mokkadm', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
            timezonesidkey='America/Los_Angeles', username='RamdChokadm@test.com',MID__c = 'M87294');        
        insert u;
        
        system.runas(u){
            cont = new ViewFuturePackageDetailsController();
            cont.getFutureSubscriptionList();
        }
    }

}