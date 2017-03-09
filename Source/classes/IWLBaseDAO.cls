/**
* This class serves as a base class for all the complex DAO classes defined in IWL. It defines the basic methods to be implemented by all subclasses for 
* both retrieving and creating records in the database, as well as custom queries creation.
*/
public with sharing abstract class IWLBaseDAO {
 
	/**
	* This method returns a list of records of the objects accessed by this DAO class, according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return record retrieved from the database. 
	*/
	public abstract sObject getRecord(IWLWidget__c widgetSpecs, String IdRecord );	
	public Integer queryOffset {
		get {
			if (queryOffset == null) {
				queryOffset = 0;
			}
			return queryOffset;
		}
		set;
	}//the offset for the query
	
	/**
	* attribute that tells if the user can access this DAO's related object
	*/
	public Boolean canAccess {
		get {
			if (canAccess == null) {
				canAccess = isAccessible();
			}
			return canAccess;
		} set;
	}
	
	/**
	* Tells if the object associated to this DAO is accessible by the user
	*/
	protected virtual Boolean isAccessible() {
		return true;
	} 
	
	/**
	* This method returns a list of records of the objects accessed by this DAO class, according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return a list of records retrieved from the database.
	*/
	public abstract List<sObject> getRecords(IWLWidget__c widgetSpecs);
	
	/**
	* This methods returns the amount of records that can be retrieved from the database according to the specifications provided by widgetSpecs
	* @param widgetSpecs
	* @return the amount of records that can be retrieved with a query based on widgetSpecs
	*/ 
	public abstract Integer getRecordsCount(IWLWidget__c widgetSpecs);
	
	/**
	* Returns a string containing the SOQL query fragment corresponding to the "where" clause to be used to retrieve the records returned
	* by "getRecords" according to the criterias specified in widgetSpecs
	*
	*/
	protected abstract String getFilterCriteria(IWLWidget__c widgetSpecs);
	
	/**
	* Returns a string containing the SOQL query fragment corresponding to the "order by" clause to be used to retrieve the records returned
	* by "getRecords" according to the criterias specified in widgetSpecs
	*
	*/
	protected abstract String getOrderByClause(IWLWidget__c widgetSpecs);
	
	/**
	* Returns a set of strings representing each field that will be retrieved by the DAO from the database for each record.
	*/
	protected abstract Set<String> getFieldsForQuery(IWLWidget__c widgetSpecs);
	
	/**
	* Returns a string containing the SOQL query fragment corresponding to the "sort by" clause to be used to retrieve the records returned
	* by "getRecords" according to the criterias specified in widgetSpecs
	*
	*/
	protected virtual String getSortOrder(IWLWidget__c widgetSpecs) {
		String sortOrder = 'ASC';
		if (widgetSpecs.useAdvancedFiltering__c && widgetSpecs.orderByAdvanced__c != null && widgetSpecs.orderByAdvanced__c != '') {
			sortOrder = '';
		} else if (widgetSpecs.sortOrder__c != null && widgetSpecs.sortOrder__c != '') {
			if (widgetSpecs.sortOrder__c == IWLCodeSettings.SortOrderPicklistDescendingLabel) {
				sortOrder = 'DESC';
			}
		}
		return sortOrder;
	}
	
	
	/**
	* This method parses the 'additionalFields__c' field and returns the set of names of the fields that will be  the part of the query in charge of getting those fields.
	* @param widgetSpecs the widget record containing the specs for the query.
	* @return a set of strings with the names of the fields that were written in additionalFields__c
	*/
	protected virtual Set<String> getAdditionalFields(IWLWidget__c widgetSpecs) {
		Set<String> additionalFields = new Set<String>();
		if (widgetSpecs.additionalFields__c != null && widgetSpecs.additionalFields__c.trim()!= '') {
			additionalFields.addAll(widgetSpecs.additionalFields__c.trim().split('[^\\w\\d_]+', 0));
		}
		return additionalFields;
	}
	
	/**
	* This method takes the elements in fieldSet and creates a comma-sepparated string from them.
	* @param fieldSet a set of strings representing fields in an sobject.
	* @return a comma-sepparated string containing each value in fieldSet sepparated by a comma 
	*/
	protected virtual String getQueryString(Set<String> fieldSet) {
		String queryString = '';
		for (String fieldName : fieldSet) {
			queryString += fieldName + ',';
		}
		if (queryString.length() > 1) {
			queryString = queryString.substring(0, queryString.length() -1);
		}
		return queryString;
	}
	
	/**
	* This method retrieves a list of the developer names of all fields that are editable for the type of object
	* this DAO manages. Since this is a base class, we retrieve just an empty list.
	* @return an empty list.
	*/
	public virtual List<String> getEditableFieldsNames() {
		return new List<String>();
	}
}