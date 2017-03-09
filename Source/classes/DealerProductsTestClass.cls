@isTest
private class DealerProductsTestClass 
{

	private static void init(){
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
        Account acc = new Account();
        acc.Name ='test123';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'pqr@lmn.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;
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
					   from Account where name='test123' and Dealer_Number__c ='T7006'];
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		system.runas(u){
			ApexPages.StandardController dp = new ApexPages.StandardController(new Dealer_Product__c());
        	DealerProductController controllerObj = new DealerProductController(dp);
        	controllerObj.objClass.dealerAccount = acc;
        	List<DealerProductController.c_dealerSummary> dealerSummary = controllerObj.dealerSummary ;
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
					   from Account where name='test123' and Dealer_Number__c ='T7006'];			   
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		system.runas(u){
			ApexPages.StandardController dp = new ApexPages.StandardController(new Dealer_Product__c());
        	DealerProductController controllerObj = new DealerProductController(dp);
        	controllerObj.objClass.dealerAccount = acc;
        	List<ForhandlerInformations__c> infoList1 = controllerObj.getProductValgInformation();
	    	List<ForhandlerInformations__c> infoList2 = controllerObj.getGodkendInformation();
	    	List<ForhandlerInformations__c> infoList3 = controllerObj.getKvitteringInformation();
		}
    }
    
   	static testmethod void pageNavigationTest(){
   		init();
		/* Commented for DW-720: Removed side__c field from the new query below
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Side__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test12' and Dealer_Number__c ='T7006'];*/
		Account acc = [select id, name, Dealer_Number__c, Street_YK__c, Street_YK__r.Street__c,Street_YK__r.House_No__c,House_No__c, 
					   Street_YK__r.Entrance__c, Street_YK__r.Door_No__c, Street_YK__r.Postcode__c,Door_No_YK__c,  
					   phone, Email__c, DealerProducts__c, DealerGroup__c, Floor_No__c,Entrance_YK__c,Side_YK__c,Post_Code__c, Town_YK__c   
					   from Account where name='test123' and Dealer_Number__c ='T7006'];			   
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		system.runas(u){
			ApexPages.StandardController dp = new ApexPages.StandardController(new Dealer_Product__c());
        	DealerProductController controllerObj = new DealerProductController(dp);
        	controllerObj.objClass.dealerAccount = acc;
		    controllerObj.viewDealerProductSummary();
		    controllerObj.viewHistory();
		    controllerObj.backToDealerProductPage();
		    controllerObj.refreshDataDealerProductPage();
		    controllerObj.resetInputData();
		}
   }
   
   static testmethod void placeOrder()
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
					   from Account where name='test123' and Dealer_Number__c ='T7006'];			   
		System.debug('acc @@ - '+acc);
		Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		User u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
		system.runas(u){
			ApexPages.StandardController dp = new ApexPages.StandardController(new Dealer_Product__c());
        	DealerProductController controllerObj = new DealerProductController(dp);
        	controllerObj.objClass.dealerAccount = acc;
	     	String[] addreessStr = new String[1];
		    addreessStr[0] = 'vishu_nayak@capgemini.com';
		    controllerObj.toAddresses[0] = 'vishu_nayak@capgemini.com';
		    //Setup Products
		    Dealer_Product__c product = new Dealer_Product__c(Name='Standardboks1', Product_Number__c='1119', Product_Group__c='Digitalt kabel-tv', Product_Descriptions__c='Sagem 60', Max_Items_Allowed__c=26, Max_Antal_Dealer_Group__c=60, Dealer_Group__c='Øvrige; Fona');
		    insert product;
  	        //No order selected
		    controllerObj.generateOrder();
		      
		    if(controllerObj.productsList[0]!=null){
		       //Correct order
		       controllerObj.productsList[0].Quantity__c  = controllerObj.productsList[0].Max_Items_Allowed__c;
		       controllerObj.generateOrder();   
		       //Max quantity exceeded
		       controllerObj.productsList[0].Quantity__c  = controllerObj.productsList[0].Max_Items_Allowed__c + 1;
		       controllerObj.generateOrder();
		       List<Dealer_Product__c> orderedProds = controllerObj.orderedProducts;
		      }
		}
      
  }
}