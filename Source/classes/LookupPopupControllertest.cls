@isTest
public class LookupPopupControllertest{

    public static testMethod void runquerytest() {
        Address__c addr1 = new Address__c();
        addr1.House_No__c='11';
        insert addr1;
        Address__c addr2 = new Address__c();
        addr2.House_No__c='12';
        insert addr2;
        Address__c addr3 = new Address__c();
        addr3.House_No__c='13';
        insert addr3;
        LookupPopupController contrlobj = new LookupPopupController();
        contrlobj.query ='1';
        Test.startTest();
        
        contrlobj.runQuery();
        Test.stopTest();
        
    }
}