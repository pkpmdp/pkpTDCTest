global class scs_SidebarWrapper{

	public List<String> fieldLabels {get; set;}
	public List<String> fieldNames {get; set;}
	public List<List<Object>> fieldValues {get; set;}
	public Integer sortOrder {get; set;}
	
	public List<Map<String,Object>> dataValues {get; set;}
	
	public String objectLabel {get; set;}
	
	public scs_SidebarWrapper(String objectLabel) {
		this.objectLabel = objectLabel;
	}


   // Compare wrapper objects on sort Order
   /* global Integer compareTo(Object compareTo) {
        // Cast
        scs_SidebarWrapper compareWrapper = (scs_SidebarWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (sortOrder > compareWrapper.sortOrder) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (sortOrder < compareWrapper.sortOrder) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }*/
}