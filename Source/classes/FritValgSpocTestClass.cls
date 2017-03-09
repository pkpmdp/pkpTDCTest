/* @ Author : Sagar Mehta
**
**/
@isTest
private class FritValgSpocTestClass{     
     static testMethod void fritValgTest() {
         fritValgSpocController.TEST_MODE = true;
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.Town__c = 'testTown';
        add.Street__c = 'test';
        add.House_No__c = '20';
        add.Postcode__c = '2100';
        add.External_Id__c = '999988';
        insert add;
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '1234567';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Apexpages.currentpage().getparameters().put('amsID', add.External_Id__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);        
        fritValgSpocController control = new fritValgSpocController(sc);
        control.kundeData = 'kundeData';
        control.arrayInit = 'arrayInit';
        control.url = 'http://preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1234';
        control.choosedAftale = 'http://preprod-kasia.yousee.dk/afsaetning/vaelg-aftale/1234';
        control.klientBruger = 'm12345';
        control.klientFunction = 'test';
        control.klientSystem = 'spoctest';
        control.etag = '12345678';
        control.amsID = '3583584';
        control.isNewKundeFlag = false;
        control.callToKasia();
        control.reset();
        control.chooseAftale();
        control.bookOrder();
        control.callToCasper();
        control.createKundeInSalesForce('1234567');
        Apexpages.currentpage().getparameters().put('amsID', null);
        control = new fritValgSpocController(sc);
    }
         
}// final class end