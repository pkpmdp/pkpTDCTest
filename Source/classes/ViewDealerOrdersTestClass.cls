@isTest
private class ViewDealerOrdersTestClass 
{
    static ViewDealerOrdersController controllerObj;
    static PaginationController pageObj;
    static User u;
    static Account acc;
    static {
        Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //Commented for DW-720: Side__c is going to be deleted from SFDC
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        acc = new Account();
        acc.Name ='test12';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;    
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='123';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'Ram Chokkam';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        
        insert add;
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
        system.runas(u){
         controllerObj = new ViewDealerOrdersController();
                pageObj = new PaginationController();
                pageObj.pageController = controllerObj.getThis();
                pageObj.rows = 5;
                              }
         }
    
   
    static testmethod void pageGetTest()
    {
        // Get header information
        //List<ForhandlerInformations__c> informationList = 
        ForhandlerInformations__c info1 = new ForhandlerInformations__c(Description__c='Info 1 Test',Sequence_Number__c = 1,EndDate__c = Date.valueof('2011-07-30'),Page_Type__c = 'Bestil Varer',Group_Information__c ='Historik Page',SubGroup_Information__c = 'Top');
        insert info1;
        List<ForhandlerInformations__c> infoList = controllerObj.getHistoryHeaderInformation();
        
        // Get search criteria
        List<SelectOption> searchItems = controllerObj.getItems();
        System.assertEquals('Ordrenummer',searchItems[1].getLabel());
        
        // Get Dealer Information
        string dealerNo = controllerObj.dealerNumber;
        string dealerName = controllerObj.dealerName;
    }
    
    static testmethod void searchOrdersTest()
    {
        Dealer_Products_Order__c orderProd = new Dealer_Products_Order__c();
        orderProd.OrderDateTime__c = System.now(); 
        insert orderProd;
        
        Dealer_Products_Order__c orderProd2 = new Dealer_Products_Order__c();
        orderProd2.OrderDateTime__c = System.now(); 
        insert orderProd2;
        
        Dealer_Products_Order__c orderProd3 = new Dealer_Products_Order__c();
        orderProd3.OrderDateTime__c = System.now(); 
        insert orderProd3;
         
        List<Dealer_Products_Order__c> orderedProducts;
        
        // Searching by order number
        controllerObj.assignedItems = '1';
        controllerObj.orderNumber = '1';
        controllerObj.findOrders();
        orderedProducts = controllerObj.orderedProducts;
        
        // Searching by order date
        controllerObj.assignedItems = '2';
        controllerObj.startDate = '01.11.2011';
        controllerObj.SearchEndDate = '30.11.2011';
        controllerObj.findOrders();        
        orderedProducts = controllerObj.orderedProducts;
        
        //Searching for last month's orders
        controllerObj.assignedItems = '3';
        controllerObj.findOrders();
        orderedProducts = controllerObj.orderedProducts;
        
    }
    
    static testmethod void paginationTest()
    {
        pageObj.first();
        pageObj.last();
        pageObj.previous();
        pageObj.next();
    }
    
    static testmethod void productLineItemsTest()
    {
        Dealer_Products_Order__c ord = new Dealer_Products_Order__c();
        insert ord;
        controllerObj.selectedOrderNumber = [select Name from Dealer_Products_Order__c where id=:ord.id].Name;

        Dealer_ProductLineItems_Order__c line1 = new Dealer_ProductLineItems_Order__c(Product_Number__c='800',Product_Name__c='Clear Product',Product_Group__c='YouSee Clear (kabel-tv)',Product_Description__c='56',Quantity__c=10,DealerOrderNumber__c=ord.id);
        insert line1;

        Dealer_ProductLineItems_Order__c line2 = new Dealer_ProductLineItems_Order__c(Product_Number__c='123',Product_Name__c='G1',Product_Group__c='Generel',Product_Description__c='56',Quantity__c=10,DealerOrderNumber__c=ord.id);
        insert line2;
        
        Dealer_ProductLineItems_Order__c line3 = new Dealer_ProductLineItems_Order__c(Product_Number__c='124',Product_Name__c='G2',Product_Group__c='Generel',Product_Description__c='5',Quantity__c=20,DealerOrderNumber__c=ord.id);
        insert line3;
        
        Test.startTest();
        List<ViewDealerOrdersController.c_DealerProductLineItems> lines = controllerObj.getProductLineItems();
        controllerObj.viewLineItems();
        System.assertEquals(2,lines.size());
        Test.stopTest();
    } 
    
    static testmethod void pageEventsTest()
    {
        controllerObj.selectionChange();
        System.assertEquals(false,controllerObj.resetOnChange);
        
        Pagereference pr;
        pr = controllerObj.dealerProductPage();
        System.assertEquals('/apex/DealerProductPage',pr.getUrl());
        
        controllerObj.backToHistoryPage();
        System.assertEquals(false,controllerObj.ordLine);
    }
    
    static testmethod void runAnonymously()
    {
        ViewDealerOrdersController controllerObjAnon = new ViewDealerOrdersController();
        System.assertEquals(null,controllerObjAnon.dealerNumber);
        System.assertEquals(null,controllerObjAnon.dealerName);
    }
}