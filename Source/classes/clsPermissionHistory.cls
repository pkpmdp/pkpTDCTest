/**
	********************************************************************************
	************************************************************************************
	
	* @class: clsPermissionHistory
	* @author: Capgemini Consulting India Pvt. Ltd.
	* @Created Date = june 2013
	* @description: Class is used to get the permission history for an Account.
	
	************************************************************************************ 
	**********************************************************************************
*/

public class clsPermissionHistory {

	public Account customer{get;set;}
	public Permission__c perm {get;set;}
	public String customerId{get;set;}
	public Permission__c perhisList{get;set;}

	public List<PermissionHistoryObject> perhis = new List<PermissionHistoryObject>();
		public clsPermissionHistory(ApexPages.StandardController controller){
		customerId = ApexPages.currentPage().getParameters().get('id');
		String valueString = customerId.substring(0,3);
		system.debug('value of customerId---------'+customerId+'--------and value of '+valueString);
		if( valueString.contains('001')==false){
			permissionHistoryValues(customerId);
		}
			
		try{
			  Perm = [select Id from Permission__c where Customer__c=:customerId  limit 1 ];
		}catch(Exception ex){ 
		}
		
	} 
	 /** 
     * @method Redirect
     * @Return PageReference
     * @Redirect : PermissionHistoryPage
     * @Description: This method is called from AccountToPermission page.Here we dynamically fetch permission Id related to the Account.
     * using that Id we redirect it to the PermissionHistoryPage to display the permission history related to that Account.
     */
	 public PageReference Redirect(){
		if(perm != null && perm.Id != null){
		    PageReference pageRef = new PageReference('/apex/PermissionHistoryPage?Id='+perm.Id);
		    pageRef.setRedirect(true); 
		            return pageRef  ;
			}else{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.noSavedPermissions));
				return null;
			}
    }
    
    /** 
     * @method permissionHistoryValues
     * @input String
     * @Description: This method is used to show the history Of the given Person Account.
     * The permissions related to an Account are displayed on a visual force page namely PermissionHistoryPage.
     */
    
	public void permissionHistoryValues(String id){
		
		String type='Permission__c';
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		System.debug('@@@@Id--------------'+id);
		perhisList = [Select (Select NewValue,field ,oldValue, createdby.name,createddate From Histories order by CreatedDate DESC) From Permission__c where Id=:id];
		system.debug('Size of perhisList is -----'+perhisList.histories.size());
		for(integer i=0; i < perhisList.histories.size(); i++){
			PermissionHistoryObject perhistory = new PermissionHistoryObject(); 
				perhistory.createddate = String.valueof(perhisList.histories[i].createddate);
				try{
					perhistory.newValue = (String)perhisList.histories[i].NewValue;
				}catch(Exception e){
					perhistory.newValue = ''+perhisList.histories[i].NewValue;
					if(perhistory.newValue =='false')
					perhistory.newValue = 'Nej';
				}
				try{
					perhistory.oldValue = (String)perhisList.histories[i].oldValue;
				}catch(Exception e){
					perhistory.oldValue =''+ perhisList.histories[i].oldValue;
					if(perhistory.oldValue =='true')
					perhistory.oldValue = 'Ja';
				}
				
				perhistory.createdby = (String)perhisList.histories[i].createdby.name;
				if((String)perhisList.histories[i].field != 'created'){
						perhistory.field = fieldMap.get(perhisList.histories[i].field).getDescribe().getLabel();
					}else{
						perhistory.field = perhisList.histories[i].field;
					}
				perhis.add(perhistory);
			
		}
	}
	
	/** 
	 * @Wrapper Class: PermissionHistoryObject
	 * @Description: This class is a wrapper class which is utilised to group the different fields.
	 * Using this group of fields we are creating an arrray which is they used to display the history on the VF-page.
	 */
     class PermissionHistoryObject{
    	public String createddate{get;set;}
    	public String newValue{get;set;}
    	public String oldValue{get;set;}
    	public String field{get;set;} 
    	public string createdby{get;set;}
    }
    
	/** 
	* @method getPerhis
    * @Return List<PermissionHistoryObject>
    * @Description: This method is used to store the list of history Of the given Person Account.
    * This List is then displayed on a visual force page namely PermissionHistoryPage.
    */
    public List<PermissionHistoryObject> getPerhis() {
        return perhis;
    }
}