public class ContactWrapper{
 
        public Boolean checked{ get; set; }
	    public Contact contact1{ get; set;}
	    public Address__c address{get; set;}
	    public String rolename{get; set;}
	    public String userRolename{get; set;}
	     
	    public ContactWrapper(){
	        contact1 = new Contact();
	        //checked = false;
	    }
	 
	    public ContactWrapper(Contact c1){
	        contact1 = c1;
	        //checked = false;
	    }
}