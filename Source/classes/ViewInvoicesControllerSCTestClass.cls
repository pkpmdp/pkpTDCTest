/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
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
private class ViewInvoicesControllerSCTestClass {
    public static user u;
    public static String query = '';
    public static List<Invoice__c> inv_lst = new List<Invoice__c>();
    public static String invoiceNo;
    public static Date today = date.today();
    public static Date todays = today - 547;
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        try{
            Test.startTest();
            
            
            Account acc = new Account();
            acc.Name = 'TestAccount';
            acc.Type='Hierarki';
            acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
            insert acc;
            
            Cable_Unit__c cableUnitTest = new Cable_Unit__c();
            cableUnitTest.Name = 'cu_kundeCust_testing'; 
            cableUnitTest.Cable_Unit_No__c = '0000005566';
            cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
            cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
            cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
            cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
            cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
            cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
            insert cableUnitTest;
            
             
            
            List<Id> freeFlyContDiffHier = new List<Id>();
            List<Contact> contactEmail = new  List<Contact>();
            
            /*Account kundeChild = new Account();
            kundeChild.Name = 'kundeCustomer';
            kundeChild.parentId = acc.Id;
            kundeChild.Cable_Unit__c = cableUnitTest.id;
            kundeChild.RecordTypeId = '012200000000nf3';
            kundeChild.Type = 'kunde';
            insert kundeChild;*/
        
        
         Contact c = new Contact(email = 'abc@test.com',FirstName='abc',LastName='test',Phone='3213213211', Temporary_contact__c=true, HierarchyAccount__c=acc.Id);
         insert c;
         
         if(c.email != null){
            contactEmail = [select Id,FirstName,LastName,Street_P__c, Status__c, Post_Code_P__c, House_No_P__c, HomePhone, Floor_No_P__c, Entrance_P__c, Email,Door_No_P__c, District_P__c, AccountId,Account.Name, HierarchyAccount__c,UserProfile__c,IsPersonAccount from Contact where Email =: c.Email AND IsPersonAccount = false and RecordTypeId =: contactConstClass.ContactRecordType];
         }
         
         
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;
    //   u = [SELECT Id, Name FROM User where email = 'vishal.tambe@capgemini.com' limit 1]; 
       System.runAs(u) {
            ViewInvoicesController controller = new ViewInvoicesController();
            controller.setPollChecker(true);
            controller.getDataListFlag();
            controller.getinitialDataListFlag();
            controller.getInvoiceNotPresent();
            controller.getStartDate();
            controller.setStartDate('18.04.2012');
            controller.getEndDate();
            controller.setEndDate('20.05.2013');
            controller.getPollChecker();
            controller.getCableUnitName();
            controller.getCableUnitNumber();
            controller.getDebitorNumber();
            controller.getKontonNumber();
            controller.fetchInvoiceListHttpCallout();
            controller.getinvoiceList();
            controller.findInvoices();
            controller.checkOnDataSyncInvoice();
            controller.createInvoiceQuery('04-02-11','05-03-13');
            controller.backToInvoicesPage();
            controller.cancel();
            if(!controller.getPollChecker()){
                query = 'Select i.Type__c, i.Payment_Date__c, i.Out__c, i.DisplayInvoice_No__c, i.Name,'+
                'i.Invoice_Date__c, i.Invoice_Amount__c, i.In__c, i.Id, i.Due_Date__c,'+
                'i.Building_No__c, i.Balance__c, i.Address__c, i.Daekker_No__c '+
                'From Invoice__c i where Account_No__c =\''+ '001D000000lHuOWIA0' +'\'';
                query = query + ' order by i.Invoice_Date__c desc';
                inv_lst = Database.query(query);
            }
            
            
       }
        }catch(System.Exception e){
            system.debug('Error'+e.getMessage());
            Test.stopTest();    
        }
        
    }
    static testMethod void myUnitTest2() {
        
        ViewInvoicesController controller = new ViewInvoicesController();
        
        Apexpages.currentpage().getparameters().put('dataSyncLogId','00DM0000000ARWB');
        

        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        insert acc;
        
        Address__c add = new Address__c();
        add.Active__c = true;
        add.District__c ='test';
        add.Door_No__c ='1';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'test1';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        add.Street__c ='ordrupVej';
        //add.Side__c ='TV';
        insert add;
        
        Invoice__c TestInvoice = new Invoice__c();
        TestInvoice.Name = 'TestInv1';
        TestInvoice.Type__c = 'TestType1';
        TestInvoice.Payment_Date__c = system.today();
        TestInvoice.Account_No__c = acc.Id;
        TestInvoice.Address__c = add.Id;
        TestInvoice.Balance__c = 4500;
        TestInvoice.Daekker_No__c = 'TestDaekker';
        TestInvoice.Due_Date__c = system.today();
        TestInvoice.Out__c = 456;
        TestInvoice.DisplayInvoice_No__c = '1234';
        TestInvoice.Invoice_Date__c = system.today()-2;
        TestInvoice.Invoice_Amount__c = 123;
        TestInvoice.In__c = 123;
        insert TestInvoice;
        Apexpages.currentpage().getparameters().put('accountTypeId',acc.id);
        
        controller.checkOnDataSyncInvoice();
        
        controller.setStartDate('02.10.2010');
        controller.setEndDate('');
        controller.findInvoices();
        
        controller.setStartDate('');
        controller.setEndDate('12.12.2010');
        controller.findInvoices();
        controller.createInvoiceQuery('','');
        controller.createInvoiceQuery('test','');
        controller.createInvoiceQuery('','test');
    }
    
}