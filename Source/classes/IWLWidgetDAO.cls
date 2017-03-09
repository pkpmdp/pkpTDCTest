/**
* This class serves as a DAO for the IWLWidget__c object, and provides methods to access records of such an object
*/ 
public with sharing class IWLWidgetDAO {

	public static Boolean canAccessWidget {
		get {
			if (canAccessWidget == null) {
				canAccessWidget = SecurityManager.isAccessible(IWLWidget__c.sObjectType);
				canAccessWidget = SecurityManager.isAccessible(new Schema.Sobjectfield[] {
					IWLWidget__c.Id, IWLWidget__c.Name, IWLWidget__c.Type__c, IWLWidget__c.Title__c, 
					IWLWidget__c.Origin__c, IWLWidget__c.FilterBasic__c, IWLWidget__c.ShareOn_Image__c, 
					IWLWidget__c.ShareOn_Type__c, IWLWidget__c.URL_Feed__c, IWLWidget__c.description__c, 
					IWLWidget__c.Redirect__c, IWLWidget__c.OrderByBasic__c, IWLWidget__c.CSSFileUrl__c, 
					IWLWidget__c.RecordTypeId, IWLWidget__c.backgroundColor__c, IWLWidget__c.fontColor__c, 
					IWLWidget__c.height__c, IWLWidget__c.width__c, IWLWidget__c.titleColor__c, 
					IWLWidget__c.overrideCSS__c, IWLWidget__c.Community__c, IWLWidget__c.sortOrder__c, 
					IWLWidget__c.listSize__c, IWLWidget__c.seeMoreUrl__c, IWLWidget__c.detailPageUrl__c,  
					IWLWidget__c.FontFamily__c, IWLWidget__c.transitionInterval__c, 
					IWLWidget__c.authorDetailUrl__c, IWLWidget__c.useAdvancedFiltering__c, 
					IWLWidget__c.filterAdvanced__c, IWLWidget__c.orderByAdvanced__c, 
					IWLWidget__c.emptyAvatarImageUrl__c, IWLWidget__c.contentLength__c, 
					IWLWidget__c.relatedFeedSize__c, IWLWidget__c.showRichText__c, IWLWidget__c.showPagination__c,
					IWLWidget__c.showRelatedFeed__c, IWLWidget__c.showStatusFilter__c,
					IWLWidget__c.votePanel__c, IWLWidget__c.viewType__c, IWLWidget__c.developerName__c, 
					IWLWidget__c.additionalFields__c, IWLWidget__c.RedirectURL__c, IWLWidget__c.twoStepIdea__c,
					IWLWidget__c.showLabels__c, IWLWidget__c.avatarsFolderDevName__c, 
					IWLWidget__c.loadMerged__c, IWLWidget__c.loadUserStats__c
				});
				//canAccessWidget = true;
			}	
			return canAccessWidget;		
		} set;
	}

	/**
	* this method queries the database for a record of IWLWidget__c with the same developerName__c specified in widgetDeveloperName.
	* @param widgetDeveloperName a String representing the developerName__c of the IWLWidget__c record to be retrieved.
	* @return the record of IWLWidget__c with developerName__c = widgetDeveloperName.
	* @throws Exception if the developerName__c is not valid. 
	*/ 
	public static IWLWidget__c getRecord(String widgetDeveloperName) {
		if (canAccessWidget) {
			
			
			
			
			return [Select Id, Name, Type__c, Title__c, Origin__c, FilterBasic__c,
			 ShareOn_Image__c, ShareOn_Type__c, URL_Feed__c, description__c, Redirect__c,
			 OrderByBasic__c, CSSFileUrl__c, RecordTypeId, backgroundColor__c, 
			 fontColor__c, height__c, width__c, titleColor__c, overrideCSS__c, 
			 Community__c, sortOrder__c, listSize__c, seeMoreUrl__c, detailPageUrl__c,  
			 FontFamily__c, transitionInterval__c, authorDetailUrl__c, useAdvancedFiltering__c,
			 filterAdvanced__c, orderByAdvanced__c, emptyAvatarImageUrl__c, contentLength__c,
			 relatedFeedSize__c, showRichText__c, showPagination__c, showRelatedFeed__c, showStatusFilter__c,
			 votePanel__c, viewType__c, developerName__c, additionalFields__c, RedirectURL__c, twoStepIdea__c,
			 showLabels__c, avatarsFolderDevName__c, loadMerged__c, loadUserStats__c  
			 from IWLWidget__c 
			 where developerName__c = :widgetDeveloperName limit 1];			
		}
		return null;
	}
	
	public static List<String> getAdditionalFieldsList(IWLWidget__c widgetRecord) {
		List<String> additionalFields = new List<String>();
		
		if (widgetRecord.additionalFields__c != null && widgetRecord.additionalFields__c.trim()!= '') {
			String tempContent = widgetRecord.additionalFields__c.trim().replaceAll('[^\\w\\d_]+', ',');
			additionalFields.addAll(tempContent.split(','));
		}
		
		return additionalFields;
	} 
	
	@isTest
	static void testGetRecord() {
		
		Test.startTest();
		
		//Community com = [Select Id from Community limit 1];
		
		IWLWidget__c wid = IWLTestUtilities.getIWLWidget(IWLTestUtilities.IWL_WIDGET_IDEASLIST);
		IWLWidget__c retrieved = getRecord(wid.developerName__c);
			
		System.assert(retrieved != null && retrieved.Id == wid.Id);
		
		wid.additionalFields__c = 'Field1__, Field2__c';
		List<String> additionalFields = getAdditionalFieldsList(wid);
		system.assert(additionalFields.size() == 2);
			
		
		Test.stopTest();
	}

}