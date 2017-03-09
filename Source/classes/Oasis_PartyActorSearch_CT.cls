public class Oasis_PartyActorSearch_CT {

public String cable_unit_No {get; set;}
public List<ViewpartyActor> viewresult {get;set;}   // list to display party actors
    
    public Oasis_PartyActorSearch_CT()  
    {
     	
    }
    
    // event handler for the search CU button
    public pageReference searchPartyActors()
    {
    	Map<Id, Contact> mapContact = new Map<Id, Contact>();			// key= contact Id, value = contact Object
    	Map<Id,String> contactRoleMap = new Map<Id,String>();			// ket= contact Id, value = role name
    	viewresult = new List<ViewpartyActor>();
    	List<String> cableunitList = new List<String>();
    	
    	//get cable unit matching the cable unit number or name
    	if(cable_unit_No != null){
    		if(cable_unit_No.isNumeric()){
    			cable_unit_No = AmazonUtil.fixCableUnitNo(cable_unit_No);
    		}
	    	for(Cable_Unit__c c : [select Cable_Unit_No__c from Cable_Unit__c where Cable_Unit_No__c=:cable_unit_No or Name=:cable_unit_No]){
	    		cableunitList.add(c.Cable_Unit_No__c);
	    	}
    	}
    	
    	if(cable_unit_No != null){
	        for(Account_Contact_Role__c acr : [SELECT RoleName__c,  Contact__c, 
	        											Contact__r.Id, Contact__r.Name, 
	        											Contact__r.Street_P__r.Street__c, Contact__r.Street_P__r.House_No__c,
	        										    Contact__r.Street_P__r.Floor__c,Contact__r.Street_P__r.Door_No__c, 
	        										    Contact__r.Street_P__r.PostCode__c, Contact__r.Street_P__r.Town__c, 
                                                  		Contact__r.Street_P__r.Entrance__c,
	        											Contact__r.phone, contact__r.HomePhone, contact__r.MobilePhone,
	        											Contact__r.email 
	        											from Account_Contact_Role__c where CableUnit__c=:cableunitList]){
	        	mapContact.put(acr.Contact__c, acr.Contact__r);
	        	if(contactRoleMap.get(acr.Contact__c) == null){
	        		contactRoleMap.put(acr.Contact__c,acr.RoleName__c);
	        	}else{ 
	        		String temp = contactRoleMap.get(acr.Contact__c);
	        		temp = temp +', '+acr.RoleName__c;
	        		contactRoleMap.put(acr.Contact__c,temp);
	        	}
	        }
    	}
    	
    	for(Id contactId : mapContact.keySet()) 
    	{
    		//get contact
    		Contact c = mapContact.get(contactId);
    		//get rolename
    		String roleNames = contactRoleMap.get(contactId);
    		
    		ViewpartyActor v = new ViewpartyActor();
    		v.cont = c;
    		v.roles = roleNames;
    		if(String.isNotBlank(c.phone))
    		{
    			v.phoneNumber = c.phone;
    		} else if(String.isNotBlank(c.MobilePhone)) {
    			v.phoneNumber = c.MobilePhone;
    		} else if(String.isNotBlank(c.HomePhone)) {
    			v.phoneNumber = c.HomePhone;
    		}
    		v.fullAddress = Oasis_Utils.formatAddress(c.Street_P__r);
    		viewresult.add(v);
    	}    	
    
        System.debug('PrintMap*****'+viewresult);
        return null;
    }
    
    
  // class to hold display records  
  @TestVisible
    class ViewpartyActor{
    	public String roles {get;set;}
    	public Contact cont {get;set;}
    	public String phoneNumber {get; set;}
    	public String fullAddress {get;set;}
    }
}