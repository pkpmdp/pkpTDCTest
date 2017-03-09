/**
 * This class contains unit tests for validating the behavior of Apex classes and triggers
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
    private class clsProductDistributionYSControllerTest {
    // Test coverage for requirement to run custom product distribution reports
    static testMethod void testProductDistributionSummaryReport() {
        
        // Set current page reference
        PageReference pageRef = Page.ProductDistributionYS;
        Test.setCurrentPage(pageRef);
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        //add.House_No__c = '1';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create parent account
        Account acc = new Account();
        acc.Name = 'ABC1';
        acc.Street_YK__c = add.Id;
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acc;
        
        // Create child accounts and related product distribution records
        List<Product_Distribution__c> pdsToInsert = new List<Product_Distribution__c>();
        List<Account> accounts = new List<Account>();        
        for (Integer i = 2; i < 3; i++) {        
            Account accChild = new Account();
            accChild.Name = 'ABC' + i;
            accChild.Street_YK__c = add.Id;
            accChild.ParentId = acc.Id;
            accChild.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
            accounts.add(accChild);            
        }
        Database.insert(accounts);
        
        for(Account accChild: accounts){
            Product_Distribution__c pd = new Product_Distribution__c();
            pd.Business__c = 'Consumer';
            pd.Product__c = 'Handset';
            pd.Amount__c = 1;
            pd.Customer__c = accChild.Id; 
            pdsToInsert.add(pd);    
        }
        insert pdsToInsert;
        
        /* Old version caused 'Too many soql quieries' in account triggers
        for (Integer i = 2; i < 12; i++) {        
            Account accChild = new Account();
            accChild.Name = 'ABC' + i;
            accChild.Street_YK__c = add.Id;
            accChild.ParentId = acc.Id;
            insert accChild;
            Product_Distribution__c pd = new Product_Distribution__c();
            pd.Business__c = 'Consumer';
            pd.Product__c = 'Handset';
            pd.Amount__c = 1;
            pd.Customer__c = accChild.Id; 
            pdsToInsert.add(pd);
        } 
        insert pdsToInsert;
        */
        
        // Get a handle on the custom controller
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        clsProductDistributionYSController controller = new clsProductDistributionYSController(sc);
        
        // Should only be one summary record so far
        List<clsProductDistributionYSController.cProductDistributionSummary> pdSummaries = controller.getProductDistributionSummaries();
        System.assertEquals(pdSummaries.size(), 1);
        
        // Amount of summary record should be ten since they were all the same business and product
        clsProductDistributionYSController.cProductDistributionSummary pdSummary = pdSummaries.get(0);         
        System.assertEquals(pdSummary.getSummaryRecord().Amount__c, 1);

        // Add some more data to test the grouping in the report
        pdsToInsert.clear();
        accounts.clear();
        
        for (Integer i = 12; i < 13; i++) {        
            Account accChild = new Account();
            accChild.Name = 'ABC' + i;
            accChild.Street_YK__c = add.Id;
            accChild.ParentId = acc.Id;
            accChild.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde2();
            accounts.add(accChild);
        }
        insert accounts;
        
        for(Account accChild: accounts){
            Product_Distribution__c pd = new Product_Distribution__c();
            pd.Business__c = 'Business';
            pd.Product__c = 'Handset';
            pd.Amount__c = 2;
            pd.Customer__c = accChild.Id; 
            pdsToInsert.add(pd);
        }
        insert pdsToInsert;
        /* Old version caused 'Too many soql quieries' in account triggers
        for (Integer i = 12; i < 22; i++) {        
            Account accChild = new Account();
            accChild.Name = 'ABC' + i;
            accChild.Street_YK__c = add.Id;
            accChild.ParentId = acc.Id;
            insert accChild;
            Product_Distribution__c pd = new Product_Distribution__c();
            pd.Business__c = 'Business';
            pd.Product__c = 'Handset';
            pd.Amount__c = 2;
            pd.Customer__c = accChild.Id; 
            pdsToInsert.add(pd);
        } 
        insert pdsToInsert;
        */

        // Should have an additional summary record now
        pdSummaries = controller.getProductDistributionSummaries();
        System.assertEquals(pdSummaries.size(), 2);
        
        // And the first summary in the list should be the business record based on alphabetic order
        clsProductDistributionYSController.cProductDistributionSummary pdSummary2 = pdSummaries.get(0);         
        System.assertEquals(pdSummary2.getSummaryRecord().Business__c, 'Consumer');
        System.assertEquals(pdSummary2.getSummaryRecord().Product__c, 'Handset');        
        System.assertEquals(pdSummary2.getSummaryRecord().Amount__c, 2);
        
    }
}