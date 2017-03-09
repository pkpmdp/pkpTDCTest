@isTest
private class DealerGoodsReceiptsTestClass 
{

	private static void init(){
		Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //Commented for DW-720: Side__c field is going to be removed from SFDC.
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        system.debug('Address inserted is -->'+addr);
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc = new Account();
        acc.Name ='test12';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
 		system.debug('Account inserted is -->'+acc);
	}
	static testmethod void getDealerInfo(){
		init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];			   
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		system.runas(u){
                DealerGoodsReceiptController controllerObj = new DealerGoodsReceiptController();
                controllerObj.objCommon = new commonclass();
                controllerObj.objCommon.dealerAccount = acc;
                controllerObj.defectAndMissingHardware = '[{"Defective":["838303365552","838303365559"],"Missing":[]}]';
                system.debug('runas contact inserted is -->'+controllerObj.objCommon.dealerAccount);
        }
	}
	static testmethod void pageGetTest(){
		init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
        system.runas(u)
        {
        	DealerGoodsReceiptController controllerObj = new DealerGoodsReceiptController();
            List<ForhandlerInformations__c>  page1Info = controllerObj.getVaremodtagelseHeader();
            List<ForhandlerInformations__c>  page2Info = controllerObj.getFinalPageInformation();
           // System.assertequals(controllerObj.objCommon.dealerAccount.Dealer_Number__c,'T8062');
            
            List<SelectOption> searchOptions = controllerObj.getItems();
            System.debug('searchOptions  @@ - '+searchOptions);
          //  System.assertequals('Serialnummer',searchOptions[2].getLabel());
        }
    }   
    // End of section to test the dynamic information displayed on page
    
	 // Start of section to test the dealers goods fetched
    static testmethod void getDealerGoodsTest()
    {
    	init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		
		Case mycase = new Case();                                     
        mycase.AccountId = acc.Id; 
        mycase.Case_Source__c = 'DealerWeb:Varemodtagelse';
        mycase.Subject = 'Varemodtagelse';
        mycase.DefectiveAndMissingHardware__c = '[{"Defective":["838303365552","838303365559"],"Missing":[]}]';
        mycase.Status = 'New';
        insert mycase; 
        system.debug('case  inserted is -->'+mycase);
        
        system.runas(u){
            DealerGoodsReceiptController controllerObj = new DealerGoodsReceiptController();
            controllerObj.objCommon = new commonclass();
            controllerObj.objCommon.dealerAccount = acc;
            // Positive test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = true;
            controllerObj.callOutDealerGoods();
            system.assertEquals(controllerObj.dealerGoods,null);
            // Negative test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = false;
            controllerObj.callOutDealerGoods();
        }
    }
    
    // End of section to test the dealers goods fetched
	
	 // Start of section to test the dealers goods authorized
    static testmethod void goodsConfirmationTest()
    {
    	init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		
        system.runas(u){
        	test.startTest();
        	DealerGoodsReceiptController controllerObj = new DealerGoodsReceiptController();
            Pagereference pr;
            PageReference p1 = new PageReference('/apex/VaremodtagelsePage');
            Test.setCurrentPage(p1);
            ApexPages.currentPage().getParameters().put('receivedOrderedProducts','123,456');
            ApexPages.currentPage().getParameters().put('notReceivedOrderedProducts','789,987');
            ApexPages.currentPage().getParameters().put('defectiveOrderedProducts','567');
            // Positive test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = true;
            controllerObj.initCustomSettings();
            pr = controllerObj.confirmationPage();
            //system.assertEquals('/apex/VaremodtagelseConfirmationPage',pr.getUrl());
            
            // Negative test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = false;
            pr = controllerObj.confirmationPage();
            //system.assertEquals(pr,null);
            
            //No selected orders to authorize
            controllerObj.receivedOrderedProducts = '';
            DealerGoodsReceiptController.FORCE_TEST_MODE = true;
            pr = controllerObj.confirmationPage();
            //system.assertEquals(pr,null);
            test.stopTest();
        }
    }
    // End of section to test the dealers goods authorized
     // Start of section to test the dealers goods authorized
    static testmethod void goodsAuthorizeTest()
    {
    	init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		
        system.runas(u){
        	DealerGoodsReceiptController controllerObj = new DealerGoodsReceiptController();
            Pagereference pr;
            PageReference p1 = new PageReference('/apex/VaremodtagelseConfirmationPage');
            Test.setCurrentPage(p1);
            ApexPages.currentPage().getParameters().put('receivedOrderedProducts','123,456');
            ApexPages.currentPage().getParameters().put('notReceivedOrderedProducts','');
            ApexPages.currentPage().getParameters().put('defectiveOrderedProducts','');
            controllerObj.ETAG = '999';
            // Positive test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = true;
            controllerObj.initCustomSettings();
            pr = controllerObj.updateApprovalStatus();
            //system.assertEquals('/apex/DealerGoodsConfirmation',pr.getUrl());
            //system.assertEquals('/apex/VaremodtagelseReceiptPage',pr.getUrl());
            
            // Negative test case for web service call
            DealerGoodsReceiptController.FORCE_TEST_MODE = false;
            pr = controllerObj.updateApprovalStatus();
            //system.assertEquals(pr,null);
            
            //No selected orders to authorize
            controllerObj.receivedOrderedProducts = '';
            DealerGoodsReceiptController.FORCE_TEST_MODE = true;
            pr = controllerObj.updateApprovalStatus();
            controllerObj.backToVaremodtagelsePage();
            controllerObj.backToGoodsPage();
            controllerObj.setStartDate('2012-06-18 00:00:00');
            controllerObj.getStartDate();
            controllerObj.setEndDate('2020-06-18 00:00:002');
            controllerObj.getEndDate();
            controllerObj.getStartDateTime();
            controllerObj.getEndDateTime();
            controllerObj.getSearchEndDate();
            controllerObj.setSearchEndDate('2020-06-18 00:00:00');
            //system.assertEquals(pr,null);
        }
    }
    // End of section to test the dealers goods authorized
    
}