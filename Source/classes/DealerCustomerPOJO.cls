/*
 *  following class use to hold customer information.
 *  @ Author :- Navneet Rajput
 *	@ Date :- 29 March 2011
 */

public class DealerCustomerPOJO {

	public Boolean customerSelected{set;get;}
	public String customerName{get;set;}
	public String firstName{get;set;}
    public String lastName{get;set;}
	public String customerNumber{get;set;}
	public String phone{get;set;}
	public Boolean credit{get;set;}
	public String email{get;set;}
	public String conformEmail{get;set;}
	public string sfdcID{get;set;}
	public string installationID{get;set;}
	//Added for DW-831
	public String mobilePhone {get;set;}
}