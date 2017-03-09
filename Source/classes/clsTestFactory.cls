/*
	@Author: mkha@yousee.dk	
	
	Contains standard test methods for YS and YK objects
 */
 
 
@IsTest(SeeAllData=true) 
public class clsTestFactory {
	
	//Fetch YS contact record type 
	public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
	String contactRecordType = ysRecords.YS_Contact_Record_Type__c;
	String hierarchyCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
	String cableUnitCustomerRecordType = ysRecords.YS_Customer_Account__c;
	String personAccountRecordType = ysRecords.YK_Customer_Account__c;
	
		
	private static clsTestFactory instance = null;
	private KISS_Role_Validation_Rules__c rule;
    private Lookup_Contact_Roles__c role;
    private Lookup_Building_Type__c buildingType;
    private Lookup_Housing_Type__c housingType;
    private Lookup_Housing_Ownership__c housingOwnerShip; 
    private Lookup_Customer_Segment__c customerSegmentObj;
    private Address__c address;
        
    public static clsTestFactory getTestFactoryInstance(){
    	if (instance == null){
    		instance = new clsTestFactory();    		
    		return instance;   		    		
    	}
    	else
    		return instance;    				    	
    }
    
    public Lookup_Building_Type__c createLookupBuildingType(){    	
		buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow';
        buildingType.Code__c='12121';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow34'; 
        insert buildingType;
        return buildingType;
    }
    
    public Lookup_Housing_Type__c createLookupHousingType(){    	
		housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype';
        housingType.Code__c = '12121';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow545';
        insert housingType;
        return housingType;
    }
    
    public Lookup_Housing_Ownership__c createLookupHousingOwnership(){
    	housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel';
        housingOwnerShip.Code__c = '12121';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow876';
        insert housingOwnerShip;
        return housingOwnerShip;	
    }
    
    public Lookup_Customer_Segment__c createLookupCustomerSegment(){
    	customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';        
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        return customerSegmentObj;       	
    }
    
    public Address__c createAddress(){
    	address = new Address__c(Name= 'Testadresse', External_Id__c = 'test454',
	        				      				House_No__c = '56', Postcode__c = '3360');
	   	insert address;
	   	return address;		
    }
    
    public Account createYSCableUnitCustomer(){ 
    	if (buildingType == null){
    		createLookupBuildingType();	
    	}
    	if (housingType == null){
    		createLookupHousingType();	
    	}
    	if(housingOwnerShip == null){    		
	    	createLookupHousingOwnership();   
    	}
    	if(customerSegmentObj == null){
    		createLookupCustomerSegment(); 
    	}
    	
    	Cable_Unit__c cable_unit = new Cable_Unit__c();
        cable_unit.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cable_unit.Name = 'TestCustomerAccountRoleTrigger';
        cable_unit.Municipaly__c = '157 Gentofte';
        cable_unit.Cable_Unit_Post_Code__c = '3360';
        cable_unit.CA_Sales_Concept__c = 'SERVICE';        
        cable_unit.Housing_Ownership__c = housingOwnerShip.Id;                      
        cable_unit.Housing_Type__c = housingType.Id;                     
        cable_unit.Building_Type__c = buildingType.Id;
        cable_unit.Potential_Installations__c = 68.0;
        insert cable_unit;
        
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = cableUnitCustomerRecordType);
        account.Cable_Unit__c = cable_unit.Id;  
       	account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
       	insert account;
       	return account;
    }
    
    public Account createYSHierarchyCustomer(){
    	if(customerSegmentObj == null){
    		createLookupCustomerSegment();
    	}
    	Account account = new Account( Name = 'TestHierarchyCustomer', RecordTypeID = hierarchyCustomerRecordType);         
       	account.Customer_Segment_Lookup__c =  customerSegmentObj.Id;
       	insert account;
       	return account;
    }
    
    
    public Contact createYSContact(){
    	if(address == null){
    		createAddress();	
    	} 	      				
	    Contact contact = new Contact( FirstName = 'Test', 
	    							   Lastname = 'Test',
	    							   HomePhone = '999999', 
	    							   KissPartyId__c = String.valueOf(Crypto.getRandomInteger()), 
	    							   Street_P__c = address.Id,
	    							   RecordTypeId = contactRecordType);
	    insert contact;
	    return contact;
    }
    
    public Contact createYSContactWithParameters(String inputFirstName, String inputLastName, String inputHomePhone, String inputEmail){
    	if(address == null){
    		createAddress();	
    	} 	      				
	    Contact contact = new Contact( FirstName = inputFirstName != null ? inputFirstName : 'Test Fornavn', 
	    							   LastName = inputLastName != null ? inputLastName : 'Test Efternavn', 
	    							   HomePhone = inputHomePhone != null ? inputHomePhone : '9999999',
	    							   Email = inputEmail != null ? inputEmail : 'test12345@test43434.dk', 
	    							   KissPartyId__c = String.valueOf(Crypto.getRandomInteger()), 
	    							   Street_P__c = address.Id,
	    							   RecordTypeId = contactRecordType);
	    insert contact;
	    return contact;
    }
    
    public Lookup_Contact_Roles__c createExternalRoleTypeWithRule(String roleName){
    	role = new Lookup_Contact_Roles__c(Name = roleName, Start_Date__c = Date.valueOf('2011-01-01'),
	                                        	End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = String.valueOf(Crypto.getRandomInteger()),
	                                        	Code__c = roleName);
	    insert role;    	
    	KISS_Role_Validation_Rules__c rule = new KISS_Role_Validation_Rules__c( Name = roleName,
	                                               	  Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role.Id );	    
	    insert rule;
	  	
	  	return role;		
    }
    
    public Account_Contact_Role__c createYSContactRole(Id contactId, Id AccountId){
    	//Dummy rule with no contraints
    	String roleName = 'Role' + String.valueOf(Crypto.getRandomInteger());
    	
    	role = new Lookup_Contact_Roles__c(Name = roleName, Start_Date__c = Date.valueOf('2011-01-01'),
	                                        	End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = String.valueOf(Crypto.getRandomInteger()),
	                                        	Code__c = roleName );
	  	insert role;    	
    	
    	rule = new KISS_Role_Validation_Rules__c( Name = roleName,
	                                              Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'Kunde', Contact_Roles__c = role.Id );
	    
	    insert rule;
	  		  	
	  	Account_Contact_Role__c acr = 
            new Account_Contact_Role__c(Customer__c = AccountId, 
                                        Contact__c = contactId,                                       
                                        Role__c = role.Id); 
        //Insert fake-KISS-ID to bypass validation. We dont have time to wait for Cast iron update (ex. 4 secs)
        acr.ContactRoleExternalID__c = acr + String.valueOf(Crypto.getRandomInteger());
        insert acr;
        return acr;
    }
    
    public Account createPersonAccount(){
        Account acc = new Account(FirstName = 'Otto',
        						  LastName = 'Hansen',
        						  Customer_No__c = '987654321',
        						  Phone = '12345678',
        						  RecordTypeId = personAccountRecordType);        
        insert acc;
        return acc;
    }
}