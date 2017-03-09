public with sharing class clsCasesSearchCustomerController {
    private static Integer ADDRESS_RESULTS_LIMIT = 200;
    private static String TOO_MANY_ADDRESSES_FOUND = 'Too many addresses found (' + ADDRESS_RESULTS_LIMIT + '). Please refine your search.';
    
    private ApexPages.StandardController controller;
    private Case cse;
    private List<List<SObject>> searchList;
    private List<Address__c> addresses;
    private List<Account> customers;
    private Boolean renderSearchPanel;
    private Boolean renderAddressList;
    private Boolean renderCustomerList;
    public Case ctrlCase{get;set;}
    
    public clsCasesSearchCustomerController(ApexPages.StandardController c) {
        controller = c;
        cse = (Case) controller.getRecord();
        if (ApexPages.currentPage().getUrl().startsWith('/apex/CasesSearchCustomer?')) {
            cse.Address_Search_Term__c = null;
        }
        renderSearchPanel = true;
        renderAddressList = true;
        renderCustomerList = false;
    }
    
   public Boolean getRenderAddressList() {
        return renderAddressList;
    }
    
    public Boolean getRenderCustomerList() {
        return renderCustomerList;
    }
    
    public Boolean getRenderSearchPanel() {
        return renderSearchPanel;
    }
    
    public List<Address__c> getAddresses() {
        return (List<Address__c>)searchList[0];
    }
    

    public List<Account> getCustomers() {
        return customers;
    }
    
    public PageReference navigateToSearch() {
        cse.manual_assign__c = true;
        cse.allow_edit__c = true;
        update cse;
        return null;
    }
    
    public PageReference searchAddresses() {
        if (cse.Address_Search_Term__c == '') {
            searchList[0].clear();
        } else {
            // KH: Added additional Address__c fields in select list
            searchList = [FIND :cse.Address_Search_Term__c IN ALL FIELDS RETURNING Address__c (Id, Name, Street__c, Floor__c, House_No__c, Postcode__c, Town__c, Side__c, PO_Box__c, Entrance__c, Door_No__c, District__c ORDER BY Street__c, House_No__c, Entrance__c)];
            if (searchList[0].size() > ADDRESS_RESULTS_LIMIT) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, TOO_MANY_ADDRESSES_FOUND));
            }
        } 
        return null;
    }
    
    // KH: Added selectedAddress property
    public Address__c selectedAddress {get;set;}
    
    /*
    // KH: Added newYKProspectAcc property
    public Contact newYKProspectAcc {set; get {
        if (newYKProspectAcc == null) {
            newYKProspectAcc = new Contact();
        }
        return newYKProspectAcc;
    }}
    
    
    // KH: Added saveYKProspect action
    public PageReference saveYKProspect() {
        Account personAcc = new Account(
            RecordTypeId = '012200000000nje',
            Salutation = newYKProspectAcc.Salutation,
            FirstName = newYKProspectAcc.FirstName,
            LastName = newYKProspectAcc.LastName,
            Street_YK__c = selectedAddress.id);

        insert personAcc;
        Case c = (Case) controller.getRecord();
        c.AccountId = personAcc.id;
        update c;
        return new PageReference('/' + c.Id);
    }
    */
    
    
    public PageReference selectAddress() {
        String addressId = ApexPages.currentPage().getParameters().get('AddressId');
        // KH: START : Added code to set selectedAddress property
        for (Address__c a : getAddresses()) {
            if (a.id == addressId) {
                selectedAddress = a;
                break;
            }
        }
        // KH : END
        customers = [Select Id, Name, Cable_Unit_No__c, Customer_No__c, Phone From Account Where Street_YK__c = :addressId];
        renderSearchPanel = false;
        renderAddressList = false;
        renderCustomerList = true;
        return null;
    }
    
    
    
    public PageReference selectCustomer() {
        String customerId = ApexPages.currentPage().getParameters().get('customerId');
        Case c = (Case) controller.getRecord();
        c.AccountId = customerId;
        c.Address_old__c = selectedAddress.Id;
        c.manual_assign__c = true;
        update c;
        //return new PageReference('/' + c.Id);
        ctrlCase = c;
        return new PageReference('/apex/RefreshCaseLinkedCustomer_Console');
    }
    
    public PageReference noCustomer() {
        Case c = (Case) controller.getRecord();
        c.Address_old__c = selectedAddress.Id;
        c.Customer_Number__c = null;
        c.manual_assign__c = true;
        update c;
        return new PageReference('/' + c.Id);
    }
    
    public PageReference back() {
        renderSearchPanel = true;
        renderAddressList = true;
        renderCustomerList = false;
        return null;
    }
    
    // Test coverage for requirement to search for customers to link to cases by address
    static testMethod void testCasesViewAttachment() {
        
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        PageReference pageRef = Page.CasesSearchCustomerResults;
        Test.setCurrentPage(pageRef);
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create customer record
        Account acc = new Account();
        acc.FirstName = 'Jon';
        acc.LastName = 'Smith';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234';
        insert acc;
        
        // Create case record
        List<Case> casesToCreate = new List<Case>();
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter ';
        c.Description = 'Department: '+System.label.PYSF+'TEST\r\nProduct: TV\r\nType: Complaint\r\nCustomerID: 123';
        c.RecordTypeId = recordType.Id;
        insert c;
        
        // Navigate to the search page and instantiate the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        clsCasesSearchCustomerController controller = new clsCasesSearchCustomerController(sc);
        controller.cse.Address_Search_Term__c = 'Test';
        System.assertEquals(true, controller.getRenderSearchPanel());
        System.assertEquals(true, controller.getRenderAddressList());
        System.assertEquals(false, controller.getRenderCustomerList());
        controller.searchAddresses();
        controller.addresses = new List<Address__c>();
        controller.addresses.add(add);
        System.assertNotEquals(null, controller.getAddresses());
        // Select an address
        ApexPages.currentPage().getParameters().put('addressId', add.Id);
        controller.selectAddress();
        System.assert(true, controller.getCustomers().size());
        System.assertEquals(false, controller.getRenderSearchPanel());
        System.assertEquals(false, controller.getRenderAddressList());
        System.assertEquals(true, controller.getRenderCustomerList());
        // Made a mistake so go back
        controller.back();
        System.assertEquals(true, controller.getRenderSearchPanel());
        System.assertEquals(true, controller.getRenderAddressList());
        System.assertEquals(false, controller.getRenderCustomerList());
        // Select address again
        ApexPages.currentPage().getParameters().put('addressId', add.Id);
        controller.selectAddress();
        // This time select the customer
        Account customer = controller.getCustomers()[0];
        ApexPages.currentPage().getParameters().put('customerId', customer.Id);
        controller.selectedAddress = add;
        controller.selectCustomer();
        controller.noCustomer();
        controller.navigateToSearch();
         
    }  
}