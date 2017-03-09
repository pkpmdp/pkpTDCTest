public class AddressPrePopulate{

    Address__c Address1{get;set;}
    String addressId {get;set;}
    String address {get;set;}
    public List<Net_Installations__c> netInst {get;set;}
    public String link {get;set;}

    public AddressPrePopulate(ApexPages.StandardController controller) {

        Address1 = (Address__c) controller.getRecord();
        addressId = Address1.Id;
        address = Address1.Street__c;
        link='/001/e?CF00N20000001gksH='+address+'&CF00N20000001gksH_lkid='+addressId+'&ent=Account&nooverride=1&RecordType=012200000000nje&retURL=%2F001%2Fo';
        netInst = [select Name,Id,Status__c,Cable_Unit_No__c,Cable_Unit__c, Address__c,Location__c,Cable_Type_del__c from Net_Installations__c where Address__c=:addressId];

    }


    public PageReference redirectPageToStandard(){
        PageReference pf;
        if(netInst!=null && netInst.size()==1){
            // commented for prod pf = new PageReference('/001/e?CF00NM0000000kqfN='+netInst[0].Name+'&CF00NM0000000kqfN_lkid='+netInst[0].Id+'&CF00N20000001gksH='+address+'&CF00N20000001gksH_lkid='+addressId+'&ent=Account&nooverride=1&RecordType=012200000000nje&retURL=%2F001%2Fo');
            pf = new PageReference('/001/e?CF00ND0000005Ylds='+netInst[0].Name+'&CF00ND0000005Ylds_lkid='+netInst[0].Id+'&CF00N20000001gksH='+address+'&CF00N20000001gksH_lkid='+addressId+'&ent=Account&nooverride=1&RecordType=012200000000nje&retURL=%2F001%2Fo');
        }else if(netInst!=null && netInst.size()>1){
            return null;
        }
        else{
            pf = new PageReference('/001/e?CF00N20000001gksH='+address+'&CF00N20000001gksH_lkid='+addressId+'&ent=Account&nooverride=1&RecordType=012200000000nje&retURL=%2F001%2Fo');
        }
            return pf;
    }


/**
    * @description: This method is used to Test AddressLocationCountSchedulerCls class.
    */
     public static testMethod void testAddressPrePopulate() {        
        Test.startTest();       
        User user = insertUser();
        
        Cable_Unit__c cu = new Cable_Unit__c();
        cu.Cable_Unit_No__c = '0000000435';   
        cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation();
        cu.Name = 'cu_kundeCust_testing'; 
        cu.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                 
        cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();     
        insert cu;
        
        Address__c addr1 = new Address__c();
        addr1.Name='Nerult';
        addr1.House_No__c='2';
        addr1.Entrance__c = '12';
        addr1.Side__c = 'west';
        addr1.Active__c = true;
        addr1.External_Id__c = '58849';
        insert addr1;

         Net_Installations__c installation = new Net_Installations__c();
        installation.Address_Id__c = 'add123a';
        installation.Address__c = addr1.id;
        installation.Cable_Unit__c = cu.Id;
        installation.AddressId_InstLbnr__c = '1';
        insert installation;

        Net_Installations__c installation1 = new Net_Installations__c();
        installation1.Address_Id__c = 'add123a';
        installation1.Address__c = addr1.id;
        installation1.Cable_Unit__c = cu.Id;
        installation1.AddressId_InstLbnr__c = '1';
        insert installation1;

         Address__c addr2 = new Address__c();
        addr2.Name='Vashi';
        addr2.House_No__c='1';
        addr2.Postcode__c='1100';
        addr2.Door_No__c='52';
        addr2.Street__c ='wall street';
        addr2.Active__c = true;
        addr2.External_Id__c = '58850';
        insert addr2;

        Net_Installations__c installation2 = new Net_Installations__c();
        installation2.Address_Id__c = 'add123a';
        installation2.Address__c = addr2.id;
        installation2.Cable_Unit__c = cu.Id;
        installation2.AddressId_InstLbnr__c = '1';
        insert installation2;
        
        system.runAs(user){
            ApexPages.StandardController standardController = new ApexPages.StandardController(addr1);
            AddressPrePopulate addressPopulate = new AddressPrePopulate(standardController);
            addressPopulate.redirectPageToStandard();

            ApexPages.StandardController standardController1 = new ApexPages.StandardController(addr2);
            AddressPrePopulate addressPopulate1 = new AddressPrePopulate(standardController1);
            addressPopulate1.redirectPageToStandard();
        }      
        Test.stopTest();
    }


public static User insertUser(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%YouSee System Administrator%']; 
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User testUser = new User(alias = 'standt', email='abc@test.com',title='kunderådgiver',
                                emailencodingkey='UTF-8', lastname='Chokkam', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profiles[0].Id, 
                                timezonesidkey='America/Los_Angeles', username='RamChokam@test.com'); 
        testUser.setOptions(dmo);
        testUser.MID__c = 'M78447VVMP';
        insert testUser;
        return testUser;
    }


}