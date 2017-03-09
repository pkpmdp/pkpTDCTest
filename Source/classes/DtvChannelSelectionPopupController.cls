public class DtvChannelSelectionPopupController {

	string ProductNumber ;
	public string ProductName{get;set;}
	public string ProductDescription{get;set;}
	/*public List<AdditionalProductInformation__c> AddProdsList 
	{	get;set;	}*/
	public string error {	get;set;	}
	public string popupSiteCoreId {get;set;}
	string URL = 'https://yousee.dk/sitecore/content/data/export/export.aspx?html=true&popup=true&itemguid=';
	
	/*Constructor*/
	public DtvChannelSelectionPopupController()
	{	               
        popupSiteCoreId='';
        ProductNumber = apexPages.currentPage().getParameters().get('ProductNumber');                                
        ShowAddProducts();                             
	}/*End Constructor*/
	
	public pagereference  ShowAddProducts()
	{
		try{
				system.debug('Inside show products.... ');
				 List<Product2> AddProdsList1 =  new List<Product2>();
			/*	 AddProdsList1 = [Select Popup_SiteCore_Id__c,Product__r.Description,Product__r.Name,a.Product__r.ProductCode, a.Product__c, a.Name, a.Description__c 
						From AdditionalproductInformation__c a 
						where a.Product__r.Product_Number__c =:ProductNumber];		*/
				
				AddProdsList1 = [Select Popup_SiteCore_Id__c,Description,Name,Product_Number__c from Product2 where Product_Number__c =:ProductNumber];
							
				if(AddProdsList1.isEmpty())
				{								
					//error ='There are no Additional products';				
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Product ia available'));
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Ingen information om produktet'));				

				}
				else{																	
					popupSiteCoreId =  AddProdsList1[0].Popup_SiteCore_Id__c;
					if(popupSiteCoreId == null)
					{
						//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Offer/Campaign is not available for the product.'));
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Offer/Campaign is not available for the product.'));	
					}
					system.debug('*****************   '+popupSiteCoreId);		
				}
				
				
			return null;	
		}
		
		catch(Exception e)
		{
			throw e;
		}																				  
	}
		
 }