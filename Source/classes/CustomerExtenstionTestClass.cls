@isTest
private class CustomerExtenstionTestClass
{
    static Pagereference pr;
    static ApexPages.StandardController sc;
    static customerExtenstion objController;
    static Id delAccountId;
    static {
         pr = Page.ForhandlerCustomer;
         pr.getparameters().put('DeleteFlag','False');
         Test.setcurrentPage(pr);
         sc = new ApexPages.StandardController(new Account()); 
         objController = new customerExtenstion(sc);      
    }
    
    static testmethod void pageActions()
    {
        objController.newDealer();
        objController.exportToExcel();
        objController.getAccountData();
        List<customerExtenstion.excelWrapperClass> xlsList = objController.ExcelList; 
    }
    
    static testmethod void deleteTest()
    {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        System.runAs(thisUser)
        {
            Test.startTest();
            
            RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
            Account acc = new Account(name='T000',phone='80000',Dealer_Number__c='T000',Debitor_Number__c='T000',Email__c='testmethod@sfdc.com',
                                      DealerGroup__c='Blaa Gruppe',Category__c='C',sales_consultant__c='CUL',POS__c=true,
                                      Afregnes__c='Forhandler',DealerProducts__c='Digitalt kabel-tv;YouSee Clear (kabel-tv)',recordTypeId=rt.id,Street_YK__c=addr.id);
            acc.recordTypeId = rt.Id;
            insert acc;
            pr.getparameters().put('accountId',acc.Id);
            objController.deleteAccount();
             objController.TESTMODE = true;
        }
        
		Test.stopTest();        
       
    }
    
}