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
private class CustomAddressLookupControllerSCTestClass {
    
    public static ApexPages.Standardsetcontroller sc1;
    static Account acc;
    static List<Address__c> dummyAdd;
    static User u;
    public static CustomAddressLookupController cont;
    
    static {
        
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
            emailencodingkey='UTF-8', lastname='Mokkadm', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=c.Id,
            timezonesidkey='America/Los_Angeles', username='RamdChokadm@test.com',MID__c = 'M87754');        
        insert u;
    
        system.runas(u){
         cont = new CustomAddressLookupController();
                 dummyAdd = new List<Address__c>(); 
                sc1 = new ApexPages.Standardsetcontroller(dummyAdd);
                sc1.first();
                sc1.last();
                sc1.previous();
                sc1.next();
         }
    } 
          
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
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
        
        List<Address__c> lstAdd = new List<Address__c>();
        dummyAdd = new List<Address__c>(); 
        lstAdd.add(add);
        
        insert lstAdd;
        
        dummyAdd = lstAdd;
        
        PageReference testPage = Page.CustomAddressLookup;
        Test.setCurrentPage(testPage);
        
        ApexPages.Standardsetcontroller sc = new ApexPages.Standardsetcontroller(dummyAdd);
        
        CustomAddressLookupController controller = new CustomAddressLookupController();
        controller.getFormTag();
        controller.getTextBox();
        controller.addressName = 'test1';
        controller.street = 'ordrupVej'; 
        controller.houseNumber = '34';
        controller.doorNumber = '1';
        controller.postCode = '4000076';
        controller.town = 'ABS';
        controller.entrance = 'ABC';
        controller.floor = '4';
        //controller.side ='TV';
        
        controller.resultSize = 100;
        controller.search();
        controller.first();
        controller.last();
        controller.previous();
        controller.next();
        
        Boolean B1 = controller.hasPrevious;
        Boolean B2 = controller.hasNext;
        Integer i1 = controller.fromRecordNumber;
        Integer i2 = controller.toRecordNumber;
        Integer i3 = controller.resultSize;
        controller.hasNext = TRUE;
        controller.hasPrevious = TRUE;
        controller.resultSize=0;
        
    }
    
    static testMethod void myUnitTest2() {
       
        CustomAddressLookupController controller = new CustomAddressLookupController();
        controller.getFormTag();
        controller.getTextBox();
        controller.street = 'ordrupVejwerer';
        controller.houseNumber = '324'; 
        controller.search();
        controller.street = '';
        controller.houseNumber = '334';
        controller.postCode = '400007612';
        controller.search();  
        controller.houseNumber = '';
        controller.doorNumber = '12';
        controller.postCode = '400007612';
        controller.search();
        controller.doorNumber = '';
        controller.postCode = '400007612';
        controller.town = 'ABSfd';
        controller.search();
        controller.postCode = '';
        controller.entrance = 'ABC';
        controller.floor = '4';
        controller.town = '';
        //controller.side ='TV12';        
        controller.search();
        controller.postCode = '';
        controller.entrance = '';
        controller.floor = '';
        controller.town = 'ABS123';
        //controller.side ='';        
        controller.search();
        controller.postCode = '';
        controller.entrance = '';
        controller.floor = '23234543';
        controller.town = '';
        //controller.side ='';        
        controller.search();
        controller.postCode = '';
        controller.entrance = '';
        controller.floor = '';
        controller.town = '';
        //controller.side ='TV12345'; 
        controller.search();
           
    }
}