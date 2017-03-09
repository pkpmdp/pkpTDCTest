@isTest
private class TestDtvChannelSelectionPopupController {
 static testMethod void DealerAdditionalProductest() {
 		test.startTest();
 		DealerAdditionalProductestSuccess();
 		DealerAdditionalProductestFailure();
 		 DealerAdditionalProductexceptiontest();
 		
 		test.stopTest();
 }

  static testMethod void DealerAdditionalProductestSuccess() {
  	
  	Product2 p1= new Product2();
  	p1.Campaign__c = true;
  	p1.Description = 'data is from test method';
  	p1.IsActive = true;
  	p1.Name ='TvillingKort';
  	p1.Offer__c = true;
  	p1.Popup_SiteCore_Id__c = '{12345}';
  	p1.Product_Number__c = '1201601';
  	p1.Product_Summary__c = 'Summary through test method';
  	
  	insert p1;
  	
  //	test.startTest();
  	
  	PageReference pageRef = Page.DtvChannelSelectionPopup;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('ProductNumber', '1201601');
   DtvChannelSelectionPopupController controller = new DtvChannelSelectionPopupController();
  	controller.ProductName = 'TvillingKort';
  	//controller.ProductNumber='1201601';
  	controller.popupSiteCoreId = '{123}';
  	controller.ProductDescription = '123';
  	controller.error ='';
  	//controller.URL='ANCbh';
  	controller.ShowAddProducts();
  	
  	//controller.popupSiteCoreId = null;
  	//controller.ShowAddProducts();
  	
  	  	  	
  	//test.stopTest();
  }	
  static testMethod void DealerAdditionalProductestFailure() {
  	//test.startTest();
  	PageReference pageRef = Page.DtvChannelSelectionPopup;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('ProductNumber', '123');
      DtvChannelSelectionPopupController controller = new DtvChannelSelectionPopupController();
  		controller.ShowAddProducts();  		
  		//test.stopTest();

  		
  }
 
 static testMethod void DealerAdditionalProductexceptiontest() {
  	
  	Product2 p2= new Product2();
  	p2.Campaign__c = true;
  	p2.Description = 'data is from test method';
  	p2.IsActive = true;
  	p2.Name ='TvillingKort';
  	p2.Offer__c = true;
  	p2.Popup_SiteCore_Id__c = '';
  	p2.Product_Number__c = '';
  	p2.Product_Summary__c = 'Summary through test method';
  	
  	insert p2;

  //	test.startTest();
  	
  	PageReference pageRef = Page.DtvChannelSelectionPopup;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('ProductNumber', '');
   DtvChannelSelectionPopupController controller = new DtvChannelSelectionPopupController();
  	controller.ProductName = 'TvillingKort';
  	//controller.ProductNumber='1201601';
  	controller.popupSiteCoreId = null;
  	controller.ProductDescription = '123';
  	controller.error ='';
  	//controller.URL='ANCbh';
  	controller.ShowAddProducts();
  	  	  	  	
  //	test.stopTest();
  }	
 
//test.stopTest(); 
  
}