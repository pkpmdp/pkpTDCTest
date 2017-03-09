public with sharing class clsAnlaegNumberYSController {
    private Account account;    
    private User user;
    public String anlaegNo;
    public clsAnlaegNumberYSController(ApexPages.StandardController controller) {
        SObject obj = controller.getRecord();
        if (obj.getsObjectType() == Schema.Account.SObjectType) {
            account = [Select name, id, Cable_Unit__c, Cable_Unit_No__c from Account where id = : obj.id];  
        } 
        user = [Select Id, MID__c From User Where Id =: UserInfo.getUserId()];
    }
    
    public Account getAccount() {
        return this.account;    
    }    
    
    public String getAnlaegNo() {
        ApexPages.Message existingProductsResponse = new ApexPages.Message(ApexPages.Severity.Error,'debug anlaegsnr ' + account.Cable_Unit_No__c);
        ApexPages.addMessage(existingProductsResponse);
        if (account.Cable_Unit_No__c == null || account.Cable_Unit_No__c.equals('')) {
            return 'Pending';
        } else {
            return account.Cable_Unit_No__c;
        }
    }
    
    public Boolean getPollerEnabled() {
        if (account == null) {
            return true;
        } else if ((account.Cable_Unit_No__c == null) || (account.Cable_Unit_No__c.equals(''))) {
            return true;
        } else {
            return false;
        }
    }
    
    public PageReference checkAnlaegNumber() {
        if (account != null) {
            if ((account.Cable_Unit_No__c == null) || (account.Cable_Unit_No__c.equals(''))) {
                account = [Select Id, Cable_Unit_No__c From Account Where Id = : account.Id];
            }   
        }       
        return null;
    }
    
    static testMethod void testDisplayAnlaeg() {
        RecordType recordType = [Select Id,Name From RecordType Where Name = 'YS Customer Account'];
        
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
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
        
        // Get a handle on controller with account as focus record
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        clsAnlaegNumberYSController controller = new clsAnlaegNumberYSController(sc);
        
     	cableUnit.Cable_Unit_No__c = '0001234567';
        update cableUnit;
        System.assertEquals(acc.id, controller.getAccount().id);
        System.assertEquals('0001234567', cableUnit.Cable_Unit_No__c);
        String cableno = [Select Cable_Unit_No__c From Account Where Id = : acc.Id].Cable_Unit_No__c;
        System.assertEquals('0001234567', cableno);
        System.assertEquals(null, controller.checkAnlaegNumber());
        controller.getAnlaegNo();
        controller.account = new Account();
        controller.getPollerEnabled();
         controller.getAnlaegNo();
        controller.getPollerEnabled();
    }

}