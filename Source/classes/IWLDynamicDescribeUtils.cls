/**
* This class manages the widgets access to the Different describes for Object and field labels.
* It implements the Singleton pattern.
* 
* @author Rodrigo Juliani
*/
public with sharing class IWLDynamicDescribeUtils {
	
	public Map<String, Map<String, String>> objectFieldDescribeLabels {get; set;} //<Object API Name, <Field API Name, Field Name>>
	public  Map<String, String> objectDescribeLabels {get; set;} //<Object API Name, Object Name>
	
	public Map<String, Schema.SObjectType> globalDescribe {get; set;} //<Object API Name, Object Type information>
	public Map<String, Schema.DescribeSObjectResult> describeMap {get; set;} //<Object API Name, Object describe info>
	public Map<String, Map <String, Schema.SObjectField>> fieldsMap {get; set;} //<Object API Name, <Field API Name, field information>>
	
	private IWLDynamicDescribeUtils() {
		globalDescribe = Schema.getGlobalDescribe();
		fieldsMap = new Map<String, Map <String, Schema.SObjectField>>();
		objectDescribeLabels = new Map<String, String>();
		objectFieldDescribeLabels = new Map<String, Map<String, String>>();
		describeMap = new Map<String, Schema.DescribeSObjectResult>();
	}
	
	/**
	* Instance getter method for this class. It creates the new static instance reference in case it 
	* does not exist. 
	* @return the static instance of this class.
	*/
	public static IWLDynamicDescribeUtils Instance {
		get {
			if (Instance == null) {
				Instance = new IWLDynamicDescribeUtils();
			}
			return Instance;
		} set;
	}
	
	/**
	* Returns the describe information of the object with API name sObjectDevName, adding it to the collections
	* where the information is locally saved.
	* @param sObjectDebName the API name of an object.
	* @return the describe information for the object with the API name provided.
	*/
	public Schema.DescribeSObjectResult getObjectDescribe(String sObjectDevName) {
		if (!describeMap.containsKey(sObjectDevName)) {
			Schema.DescribeSObjectResult objectDescribe = globalDescribe.get( sObjectDevName ).getDescribe();
			describeMap.put(sObjectDevName, objectDescribe);
		}
		return describeMap.get(sObjectDevName);
	}
	
	/**
	* Returns the label of the object which API name is equals to sObjectDevName, storing the information locally for future retrieval.
	* @param sObjectDevName the API name of the object.
	* @return the Label of the object in the org.
	*/
	public String getObjectLabel(String sObjectDevName) {
		if (!objectDescribeLabels.containsKey(sObjectDevName)) {
			
			objectDescribeLabels.put(sObjectDevName, getObjectDescribe(sObjectDevName).getLabel());
		}
		return objectDescribeLabels.get(sObjectDevName);
	}
	
	/**
	* Returns the plural label of the object which API name is equals to sObjectDevName, storing the information locally for future retrieval.
	* @param sObjectDevName the API name of the object.
	* @return the plural Label of the object in the org.
	*/
	public String getObjectPluralLabel(String sObjectDevName) {
		return getObjectDescribe(sObjectDevName).getLabelPlural();
		
	}
	
	/**
	* Returns the label of the field which API name is equals to sObjectFieldDevName, from the 
	* object which API name is equals to sObjectDevName, storing the information locally for future retrieval.
	* @param sObjectDevName the API name of the object.
	* @param sObjectFieldDevName the API name of the field in the object.
	* @return the label of the field.
	*/
	public String getFieldLabel(String sObjectDevName, String sObjectFieldDevName) {
		if (!fieldsMap.containsKey(sObjectDevName)) {
			fieldsMap.put(sObjectDevName, getObjectDescribe(sObjectDevName).fields.getMap());
			objectFieldDescribeLabels.put(sObjectDevName, new Map<String, String>());
		}
		Map<String, String> objectFieldsLabels = objectFieldDescribeLabels.get(sObjectDevName);
		if (!objectFieldsLabels.containsKey(sObjectFieldDevName)) {
			objectFieldsLabels.put(sObjectFieldDevName, fieldsMap.get(sObjectDevName).get(sObjectFieldDevName).getDescribe().getLabel());
		}
		return objectFieldsLabels.get(sObjectFieldDevName);
	}
	
	/* TEST METHODS */
	
	@isTest
	private static void testDynamicDescribeUtils() {
		Test.startTest();
		
		IWLDynamicDescribeUtils controller = IWLDynamicDescribeUtils.Instance;
		system.assert(controller != null);
		
		String label = controller.getFieldLabel('Contact', 'Id');
		
		system.assert(label == Contact.Id.getDescribe().getLabel());
		
		label = controller.getObjectLabel('IWLWidget__c');
		
		system.assert(label == Schema.Sobjecttype.IWLWidget__c.getLabel());
		
		Test.stopTest();
	}
	
}