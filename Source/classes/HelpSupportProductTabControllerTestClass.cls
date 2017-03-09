@isTest
private class HelpSupportProductTabControllerTestClass
{
    static HelpSupportProductTabController objController;
    
    static testmethod void getInformation()
    {
        PageReference pr = Page.HelpSupportProductTabPage;
        pr.getparameters().put('productType','Clear');
        Test.setcurrentPage(pr);
        ForhandlerInformations__c clear = new ForhandlerInformations__c(Page_Type__c ='Hjælp og support',Group_Information__c = 'Produkt Tab Information',SubGroup_Information__c='Clear',Sequence_Number__c=2,EndDate__c = Date.valueof('2012-07-30'));
        insert clear;
        objController = new HelpSupportProductTabController();
        System.assertEquals('YouSee Clear',objController.productType);
        
        pr.getparameters().put('productType','Broadband');
        ForhandlerInformations__c broadband= new ForhandlerInformations__c(Page_Type__c ='Hjælp og support',Group_Information__c = 'Produkt Tab Information',SubGroup_Information__c='Broadband',Sequence_Number__c=2,EndDate__c = Date.valueof('2012-07-30'));
        insert broadband;
        objController = new HelpSupportProductTabController();
        System.assertEquals('YouSee Bredbånd',objController.productType);
        
        pr.getparameters().put('productType','Digital');
        ForhandlerInformations__c digital= new ForhandlerInformations__c(Page_Type__c ='Hjælp og support',Group_Information__c = 'Produkt Tab Information',SubGroup_Information__c='Digital',Sequence_Number__c=2,EndDate__c = Date.valueof('2012-07-30'));
        insert digital;
        objController = new HelpSupportProductTabController();
        System.assertEquals('YouSee Plus',objController.productType);
        
        pr.getparameters().put('productType','Telephony');
        ForhandlerInformations__c telephony= new ForhandlerInformations__c(Page_Type__c ='Hjælp og support',Group_Information__c = 'Produkt Tab Information',SubGroup_Information__c='Telephony',Sequence_Number__c=2,EndDate__c = Date.valueof('2012-07-30'));
        insert telephony;
        objController = new HelpSupportProductTabController();
        System.assertEquals('YouSee Telefoni',objController.productType);
        
        pr.getparameters().put('productType','Ekstrakanaler');
        ForhandlerInformations__c ekstrakanaler= new ForhandlerInformations__c(Page_Type__c ='Hjælp og support',Group_Information__c = 'Produkt Tab Information',SubGroup_Information__c='Ekstrakanaler',Sequence_Number__c=2,EndDate__c = Date.valueof('2012-07-30'));
        insert ekstrakanaler;
        objController = new HelpSupportProductTabController();
        System.assertEquals('Ekstrakanaler',objController.productType);
    }
}